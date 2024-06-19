#!/bin/bash

# Nombre del clúster EKS
CLUSTER_NAME="eks-mundos-e"
REGION="us-east-1"
NODE_TYPE="t3.small"
NODE_COUNT=3
SSH_PUBLIC_KEY="pin"
ZONES="us-east-1a,us-east-1b,us-east-1c"

# Crear el clúster EKS
eksctl create cluster \
    --name "$CLUSTER_NAME" \
    --region "$REGION" \
    --node-type "$NODE_TYPE" \
    --nodes "$NODE_COUNT" \
    --with-oidc \
    --ssh-access \
    --ssh-public-key "$SSH_PUBLIC_KEY" \
    --managed \
    --full-ecr-access \
    --zones "$ZONES"
