#!/bin/bash

# Leer el nombre de la clave SSH
if [ -f /home/ubuntu/ssh_key_name.txt ]; then
    source /home/ubuntu/ssh_key_name.txt
else
    echo "Error: No se pudo encontrar ssh_key_name.txt"
    exit 1
fi

# Verificar si la clave SSH existe en EC2
if aws ec2 describe-key-pairs --key-names "$KEY_NAME" --region us-east-1 > /dev/null 2>&1; then
    echo "Usando la clave SSH existente: $KEY_NAME"
else
    echo "Error: La clave SSH $KEY_NAME no existe en EC2"
    exit 1
fi

# Configurar EKS Cluster usando eksctl
eksctl create cluster --name pin-cluster --version 1.21 --region us-east-1 --nodegroup-name standard-workers --node-type t2.micro --nodes 3 --nodes-min 1 --nodes-max 4 --ssh-access --ssh-public-key "$KEY_NAME" --managed
