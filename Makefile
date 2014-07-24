all: ca1-cert.pem agent1-key.pem agent1-csr.pem agent1-cert.pem ss-key.pem ss-csr.pem ss-cert.pem

#
# Create Certificate Authority: ca1
#
ca1-cert.pem: ca1.cnf
	openssl req -new -x509 -days 9999 -config ca1.cnf -keyout ca1-key.pem -out ca1-cert.pem

#
# agent1 is signed by ca1
#
agent1-key.pem:
	openssl genrsa -out agent1-key.pem 1024

agent1-csr.pem: agent1.cnf agent1-key.pem
	openssl req -new -config agent1.cnf -key agent1-key.pem -out agent1-csr.pem

agent1-cert.pem: agent1-csr.pem ca1-cert.pem ca1-key.pem
	openssl x509 -req -days 9999 -passin "pass:password" -in agent1-csr.pem -CA ca1-cert.pem -CAkey ca1-key.pem -CAcreateserial -out agent1-cert.pem

# Verify the signed certificate
agent1-verify:
	openssl verify -CAfile ca1-cert.pem agent1-cert.pem

#
# Create a self signed cert
#
# Generate a new private key
ss-key.pem:
	openssl genrsa -out selfcert-key.pem 1024

# Create a certificate signing request
ss-csr.pem: ss-key.pem
	openssl req -new -config selfcert.cnf -key selfcert-key.pem -out selfcert-csr.pem

# Sign the certificate
ss-cert.pem: ss-key.pem ss-csr.pem
	openssl x509 -req -days 9999 -in selfcert-csr.pem -signkey selfcert-key.pem -out selfcert-cert.pem

# Verify the certificate
ss-verify:
	openssl verify -CAfile selfcert-cert.pem selfcert-cert.pem

ss.pem: ss-key.pem ss-csr.pem ss-cert.pem ss-verify

clean:
	rm -f *.pem *.srl

ss-test: ss-verify
