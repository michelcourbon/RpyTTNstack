# local ip as domain !
TTS_DOMAIN=$(hostname  -I | cut -f1 -d' ' )

#  initialize certificate data
TTS_SUBJECT_ORGANIZATION=UJM
TTS_SUBJECT_COUNTRY=${TTS_SUBJECT_COUNTRY:-FR}
TTS_SUBJECT_STATE=${TTS_SUBJECT_STATE:-AURA}
TTS_SUBJECT_LOCATION=${TTS_SUBJECT_LOCATION:-Sainte}
TTS_ORGANIZATION=${TTS_SUBJECT_ORGANIZATION:-UJM}

# build certificate in temp directory
mkdir temp
cd  temp/

# build the certificate
echo '{"CN":"'$TTS_SUBJECT_ORGANIZATION CA'","key":{"algo":"rsa","size":2048},"names":[{"C":"'$TTS_SUBJECT_COUNTRY'","ST":"'$TTS_SUBJECT_STATE'","L":"'$TTS_SUBJECT_LOCATION'","O":"'$TTS_SUBJECT_ORGANIZATION'"}]}' > ca.json
cfssl genkey -initca ca.json | cfssljson -bare ca
echo '{"CN":"'$TTS_DOMAIN'","hosts":["'$TTS_DOMAIN'","localhost","'$(echo $IP_LAN | sed 's/,/\",\"/')'"],"key":{"algo":"rsa","size":2048},"names":[{"C":"'$TTS_SUBJECT_COUNTRY'","ST":"'$TTS_SUBJECT_STATE'","L":"'$TTS_SUBJECT_LOCATION'","O":"'$TTS_SUBJECT_ORGANIZATION'"}]}' > cert.json
cfssl gencert -hostname "$TTS_DOMAIN,localhost,$IP_LAN" -ca ca.pem -ca-key ca-key.pem cert.json | cfssljson -bare cert 

# rename
cp cert-key.pem key.pem
sudo chmod 664 key.pem

cd ..
cp temp/ca.pem ca.pem
cp temp/key.pem key.pem
cp temp/cert.pem cert.pem
