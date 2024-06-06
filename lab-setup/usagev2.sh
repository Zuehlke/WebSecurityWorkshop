# 1. Install Azure CLI (macOS)
brew update && brew install azure-cli

# 2. Login into Azure CLI
az login

# 3. Make sure you have access to the subscription and ressource group
az account set --subscription "D10374 - Zühlke Web Security Workshop"
az group show --name RG-WebSecurityWorkshopLab

# 4. Create and check lab with ressources
bash lab-setupv2.sh create 0 10
bash lab-setupv2.sh check 0 10


# Tear down
bash lab-setupv2.sh delete 0 10



# If you neeed to update the Let's encrypt certificate
brew install certbot
sudo certbot certonly --manual --preferred-challenges=dns -d "*.donttrustmyinput.com" --register-unsafely-without-email #Update Challenge in Azure DNS Record
# Certificate is saved at: /etc/letsencrypt/live/donttrustmyinput.com/fullchain.pem
# Key is saved at:         /etc/letsencrypt/live/donttrustmyinput.com/privkey.pem
sudo cp /etc/letsencrypt/live/donttrustmyinput.com/fullchain.pem fullchain.pem
sudo cp /etc/letsencrypt/live/donttrustmyinput.com/privkey.pem privkey.pem
sudo cat fullchain.pem privkey.pem > combined.pem
# Manually upload combined to Azure (In Container Apps Environments under Custom DNS suffix)
