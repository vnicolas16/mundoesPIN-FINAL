#!/bin/bash

# Cargar el nombre de la clave SSH desde el archivo
source /home/ubuntu/ssh_key_name.txt

eksctl create cluster \
--name eks-mundos-e \
--region us-east-1 \
--node-type t3.small \
--nodes 3 \
--with-oidc \
--ssh-access \
--ssh-public-key $KEY_NAME \
--managed \
--full-ecr-access \
--zones us-east-1a,us-east-1b,us-east-1c
