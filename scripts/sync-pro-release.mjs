import fs from 'node:fs/promises';
import {createHash,createPublicKey,verify} from 'node:crypto';
import {fileURLToPath} from 'node:url';
const origin='https://notchnook-v2-licensing.lo-cafe-public.workers.dev';
const publicKey='e1V/e/xly9fN/JhAxxDQ7fJtDTYZSpH8m+i3r9N7H4E=';
const decode=s=>s.replaceAll('&quot;','"').replaceAll('&amp;','&');
export function readSignedRelease(raw,key=publicKey){
 const text=raw.toString('utf8');
 const signature=text.match(/<!-- sparkle-signatures:\s*edSignature: ([A-Za-z0-9+/=]+)\s*length: (\d+)\s*-->/);
 const length=Number(signature?.[2]);
 if(!signature||!Number.isSafeInteger(length)||length<1||length>raw.length||raw.length>262144)throw Error('Invalid signed feed');
 const ed=createPublicKey({key:Buffer.concat([Buffer.from('302a300506032b6570032100','hex'),Buffer.from(key,'base64')]),format:'der',type:'spki'});
 if(!verify(null,raw.subarray(0,length),ed,Buffer.from(signature[1],'base64')))throw Error('Invalid release signature');
 const item=text.match(/<item\b[^>]*>([\s\S]*?)<\/item>/)?.[1];
 const version=item?.match(/<sparkle:shortVersionString>([^<]+)</)?.[1];
 const build=item?.match(/<sparkle:version>(\d+)</)?.[1];
 const attributes=Object.fromEntries([...(item?.match(/<nn:installer\b([^>]+)>/)?.[1]||'').matchAll(/([\w:]+)=["']([^"']*)["']/g)].map(m=>[m[1],decode(m[2])]));
 if(!/^\d+(?:\.\d+){1,3}$/.test(version||'')||!build||!/^\d+$/.test(build)||!/^[a-f0-9]{64}$/.test(attributes.sha256||''))throw Error('Missing approved installer metadata');
 const url=new URL(attributes.url);const bytes=Number(attributes.length);
 if(url.origin!==origin||url.pathname!==`/updates/v2/NotchNook-Pro-build${build}.dmg`||url.search||url.hash||url.username||url.password||!Number.isSafeInteger(bytes)||bytes<1024)throw Error('Unsafe installer destination');
 return {version,build,url:url.href,sha256:attributes.sha256,bytes};
}
export function updateCask(text,release){
 const current=text.match(/version "([\d.]+),(\d+)"/);if(!current)throw Error('Unknown cask format');
 if(BigInt(release.build)<BigInt(current[2]))throw Error('Refusing a release downgrade');
 const previous=text.match(/sha256 "([a-f0-9]{64})"/)?.[1];
 if(release.build===current[2]&&previous!==release.sha256)throw Error('An immutable build changed its hash');
 return text.replace(/version "[\d.]+,\d+"/,`version "${release.version},${release.build}"`).replace(/sha256 "[a-f0-9]{64}"/,`sha256 "${release.sha256}"`);
}
async function main(){
 const response=await fetch(origin+'/updates/v2/appcast.xml',{cache:'no-store',redirect:'error',signal:AbortSignal.timeout(30000)});if(!response.ok)throw Error('Official release unavailable');
 const release=readSignedRelease(Buffer.from(await response.arrayBuffer()));
 const fileIndex=process.argv.indexOf('--artifact-file');let bytes;
 if(fileIndex>=0)bytes=await fs.readFile(process.argv[fileIndex+1]);
 else{const r=await fetch(release.url,{redirect:'error',signal:AbortSignal.timeout(180000)});if(!r.ok)throw Error('Installer unavailable');bytes=Buffer.from(await r.arrayBuffer());}
 if(bytes.length!==release.bytes||createHash('sha256').update(bytes).digest('hex')!==release.sha256)throw Error('Published installer integrity mismatch');
 const target=new URL('../Casks/notchnook-v2.rb',import.meta.url);const old=await fs.readFile(target,'utf8'),updated=updateCask(old,release);
 if(!process.argv.includes('--dry-run'))await fs.writeFile(target,updated);
 console.log(JSON.stringify({...release,changed:updated!==old},null,2));
}
if(process.argv[1]===fileURLToPath(import.meta.url))await main();
