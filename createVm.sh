
VM_NAMTE=$0
unzip $0
git clone git@github.com:alephsecurity/xnu-qemu-arm64-tools.git

git clone git@github.com:v1X3Q0/xnu-qemu-arm64.git
git checkout tc-Experiment

python3 xnu-qemu-arm64-tools/bootstrap_scripts/asn1kerneldecode.py kernelcache.release.n66 kernelcache.release.n66.asn1decoded
python3 xnu-qemu-arm64-tools/bootstrap_scripts/decompress_lzss.py kernelcache.release.n66.asn1decoded kernelcache.release.n66.out
python3 xnu-qemu-arm64-tools/bootstrap_scripts/asn1dtredecode.py Firmware/all_flash/DeviceTree.n66ap.im4p Firmware/all_flash/DeviceTree.n66ap.im4p.out

fileST=()
fileNM=()
ramFS=()
ipswFS=()

for filename in ./*.dmg; do
    myfilesize=$(wc -c "${filename}" | awk '{print $1}')
    if [ ${#fileST[@]} -eq 0 ]
    then
        fileST+=("$myfilesize")
        fileNM+=("$filename")        
    elif [ $myfilesize -ge ${fileST[ ${#fileST[@]} - 1 ]} ]
    then
        fileST+=("$myfilesize")
        fileNM+=("$filename")        
    elif [ $myfilesize -le ${fileST[ 0 ]} ]
    then
        fileST=("$myfilesize" ${fileST[@]})
        fileNM=("$filename" ${fileNM[@]})
    else
        ramFS=${filename}
    fi
done

if [ ${#fileST[@]} -eq 3]
then
    ramFS=${fileNM[ ${#fileNM[@]} - 2 ]}
fi

ipswFS=${fileNM[ ${#fileNM[@]} - 1 ]}


python3 xnu-qemu-arm64-tools/bootstrap_scripts/asn1rdskdecode.py ${ramFS} ${ramFS}.out
