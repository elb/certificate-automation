#!/bin/bash

hr="-------------------------------------------"
br=""
VALID=3650
OPENSSL_BIN=`which openssl`
OPENSSL_CNF=./conf/openssl.cnf

CA_KEY=./ca/ca.key
CA_CRT=./ca/ca.crt.pem

mkdir -p ./ca
mkdir -p ./clients
mkdir -p ./server/keys/
mkdir -p ./server/certificates/
mkdir -p ./server/requests/
mkdir -p ./user/keys/
mkdir -p ./user/requests/
mkdir -p ./user/certificates/
mkdir -p ./user/p12/
echo "0001" > serial
touch index.txt

echo $br
echo $hr
echo "CREATING CA"
echo $hr
${OPENSSL_BIN} ecparam -out ${CA_KEY} -outform PEM -name prime256v1 -genkey
${OPENSSL_BIN} req -config ${OPENSSL_CNF} -x509 -new -key ${CA_KEY} -out ${CA_CRT} -outform PEM -days ${VALID}

