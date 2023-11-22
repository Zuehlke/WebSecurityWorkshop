#!/bin/bash
prefix="230123"
resourceGroup="RG-WebSecurityWorkshopLab"
region="northeurope"

create_instance () {
  az containerapp create \
  --name $1 \
  --resource-group $resourceGroup \
  --environment lab-containerapps-env \
  --image gianlucafrei/juice-shop-workshop:latest \
  --target-port 3000 \
  --ingress 'external' \
  --min-replicas 1 --max-replicas 1 \
  --query properties.configuration.ingress.fqdn \
  && echo "creating: $1"
}

delete_instance() {
    az containerapp delete --name $1 --resource-group $resourceGroup --yes && echo "deleted: $1"
}

check_instance() {
    url="https://$1.donttrustmyinput.com"
    status_code=$(curl --write-out "%{http_code}" --silent --output /dev/null "$url")

    if [[ "$status_code" == "200" ]] ; then
        echo "$1 is up at $url"
    else
        echo "ERROR $1 $status_code"
    fi
}

for i in `seq -f "%02g" $2 $3`
do
    
name="lab-$i"

if [[ "$1" == "delete" ]] ; then
    
    delete_instance $name
elif [[ "$1" == "check" ]]  ; then
    check_instance $name

elif [[ "$1" == "create" ]]  ; then
    create_instance $name

else
    echo "ERROR command must be create or delete"
    exit 0
fi

done