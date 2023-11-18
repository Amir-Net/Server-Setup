openssl genrsa -out key.pem 2048
openssl req -new -x509 -key key.pem -out cert.pem -days 1095
cat key.pem cert.pem >> full.pem
cp key.pem cert.pem full.pem /etc/ssl/certs
rm *.*
