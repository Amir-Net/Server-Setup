openssl genrsa -out key.pem 2048
openssl req -new -x509 -key key.pem -out cert.pem -days 1095
cat key.pem cert.pem >> full.pem
mv -f key.pem /etc/ssl/certs
mv -f cert.pem /etc/ssl/certs
mv -f full.pem /etc/ssl/certs
