#!/bin/bash
prefix="202205-"

create_instance () {
  az container create --resource-group web-sec-workshop --name $prefix$1 --image gianlucafrei/juice-shop-workshop --dns-name-label $1 --ports 3000 --cpu 0.25 --ip-address public --environment-variables "NODE_ENV=unsafe" -o none && echo "created: http://$1.westeurope.azurecontainer.io:3000"
}

delete_instance() {
    az container delete --name $prefix$1 --resource-group web-sec-workshop -o none --yes && echo "deleted: $1"
}

start_instance() {
    az container start --name $prefix$1 --resource-group web-sec-workshop -o none && echo "started: $1"
}

stop_instance() {
    az container stop --name $prefix$1 --resource-group web-sec-workshop -o none && echo "stoped: $1"
}

check_instance() {
    url="$1.westeurope.azurecontainer.io:3000"
    status_code=$(curl --write-out "%{http_code}" --silent --output /dev/null "$url")

    if [[ "$status_code" == "200" ]] ; then
        echo "$1 up"
    else
        echo "ERROR $1 $status_code"
    fi
}

for i in `seq -f "%02g" $2 $3`
do
    
name="z-web-sec-$i"
echo "$name"

if [[ "$1" == "delete" ]] ; then
    
    read -p "Are you sure? " -n 1 -r
    echo    # (optional) move to a new line
    if [[ ! $REPLY =~ ^[Yy]$ ]]
    then
        exit 1
    fi

    delete_instance $name
elif [[ "$1" == "check" ]]  ; then
    check_instance $name

elif [[ "$1" == "start" ]]  ; then
    start_instance $name

elif [[ "$1" == "stop" ]]  ; then
    stop_instance $name

elif [[ "$1" == "create" ]]  ; then
    create_instance $name

else
    echo "ERROR command must be create or delete"
    exit 0
fi

done

echo "finished"