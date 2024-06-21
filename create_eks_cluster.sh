#!/bin/bash

# Reemplaza 'source' con '.' para cargar el archivo correctamente
. /home/ubuntu/ssh_key_name.txt

# Verifica que KEY_NAME esté definido
if [ -z "$KEY_NAME" ]; then
  echo "Error: No se pudo encontrar KEY_NAME en /home/ubuntu/ssh_key_name.txt"
  exit 1
fi

# Crear el clúster EKS con la clave EC2 especificada
eksctl create cluster \
  --name eks-cluster \
  --version 1.23 \
  --region us-east-1 \
  --nodegroup-name standard-workers \
  --node-type t2.micro \
  --nodes 2 \
  --nodes-min 1 \
  --nodes-max 3 \
  --managed \
  --ssh-access \
  --ssh-public-key $KEY_NAME
