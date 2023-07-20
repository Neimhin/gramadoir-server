cp ./gramadoir-server.nginx.conf /etc/nginx/sites-available/gramadoir.abair.ie
ln -s /etc/nginx/sites-available/gramadoir.abair.ie /etc/nginx/sites-available/
nginx -t


echo "now reload nginx"
