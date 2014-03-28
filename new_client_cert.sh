#!/bin/bash

HR="-------------------------------------------"
BR=""
VALID=3650
OPENSSL_BIN=/usr/local/bin/openssl
OPENSSL_CNF=./conf/ca_openssl.cnf
OPENSSL_CURVE=prime256v1
MESSAGE="Usage:  sh ${0} [client_name]"

if [ $# -ne 1 ];
then
	echo ${MESSAGE}
	exit 2
fi

if [ $1 = "--help" ];
then
	echo ${MESSAGE}
	exit 2
fi

if [ ! -d ./user/ ];
then
	echo "Creating User folder: user/"
	mkdir -p ./user/keys/
	mkdir -p ./user/requests/
	mkdir -p ./user/certificates/
	mkdir -p ./user/p12/
fi

CA_KEY=./ca/ca.key
CA_CRT=./ca/ca.crt.pem

USER=${1}
USER_KEY=./user/keys/${USER}.key
USER_CSR=./user/requests/${USER}.csr
USER_CRT=./user/certificates/${USER}.crt
USER_P12=./user/p12/${USER}.p12

echo ${BR}
echo ${HR}
echo "CREATING CLIENT KEY"
echo ${HR}
${OPENSSL_BIN} ecparam -out ${USER_KEY} -outform PEM -name ${OPENSSL_CURVE} -genkey


echo ${BR}
echo ${HR}
echo "CREATING CLIENT CERTIFICATE REQUEST"
echo ${HR}
${OPENSSL_BIN} req -config ${OPENSSL_CNF} -newkey ec:${CA_CRT} -keyout ${USER_KEY} -out ${USER_CSR}

echo ${BR}
echo ${HR}
echo "CA SIGNING AND ISSUING CLIENT CERTIFICATE"
echo ${HR}
${OPENSSL_BIN} x509 -CA ${CA_CRT} -CAkey ${CA_KEY} -CAcreateserial -days ${VALID} -req -in ${USER_CSR} -out ${USER_CRT}
rm ${USER_CSR}

echo $br
echo $hr
echo "CREATING A PKCS#12 CERTIFICATE FOR BROWSER"
echo $hr
${OPENSSL_BIN} pkcs12 -export -clcerts -in ${USER_CRT} -inkey ${USER_KEY} -out ${USER_P12}
