
# remove certificates
rm -r temp/
rm *.pem

# remove docker configuration
rm -r config/
rm docker-compose.yml
rm ttn-lw-stack-docker.yml

# remove docker old containers
sudo rm -r blob
sudo rm -r .env/

