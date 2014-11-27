#!/bin/bash

HR="-------------------------------------------"
BR=""
VALID=3650
OPENSSL_BIN=`which openssl`
OPENSSL_CNF=./conf/openssl.cnf
OPENSSL_CURVE=prime256v1
MESSAGE="Usage:  sh ${0} [your_server_name]"

if [ $# -ne 1 ];
then
	echo ${MESSAGE}
	exit 2
fi

if [ ${1} = "--help" ];
then
	echo ${MESSAGE}
	exit 2
fi

if [ ! -d ./server/ ];
then
	echo "Creating Server folder: server/"
	mkdir -p ./server/keys/
	mkdir -p ./server/certificates/
	mkdir -p ./server/requests/
fi

CA_KEY=./ca/ca.key
CA_CRT=./ca/ca.crt.pem

SERVER=${1}
SERVER_KEY=./server/keys/${SERVER}.key
SERVER_CSR=./server/requests/${SERVER}.csr
SERVER_CRT=./server/certificates/${SERVER}.crt

echo ${BR}
echo ${HR}
echo "CREATING SERVER KEY"
echo ${HR}
${OPENSSL_BIN} ecparam -out ${SERVER_KEY} -outform PEM -name ${OPENSSL_CURVE} -genkey

echo ${BR}
echo ${HR}
echo "CREATING SERVER CERTIFICATE REQUEST"
echo ${HR}
${OPENSSL_BIN} req -config ${OPENSSL_CNF} -newkey ec:${CA_CRT} -keyout ${SERVER_KEY} -out ${SERVER_CSR}

echo ${BR}
echo ${HR}
echo "CA SIGNING AND ISSUING SERVER CERTIFICATE"
echo ${HR}
${OPENSSL_BIN} x509 -CA ${CA_CRT} -CAkey ${CA_KEY} -CAcreateserial -days ${VALID} -req -in ${SERVER_CSR} -out ${SERVER_CRT}
rm ${SERVER_CSR}
