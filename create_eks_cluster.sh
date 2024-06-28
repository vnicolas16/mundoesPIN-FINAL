#!/bin/bash

# Actualizar el sistema
sudo apt-get update -y

# Instalar AWS CLI
sudo apt-get install -y awscli

# Configurar región por defecto
export AWS_REGION="us-east-1"
export AWS_DEFAULT_REGION="us-east-1"

# Instalar kubectl
curl -o kubectl https://s3.us-west-2.amazonaws.com/amazon-eks/1.26.2/2023-03-17/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

# Instalar eksctl
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin/eksctl

# Crear el clúster EKS
eksctl create cluster \
  --name eks-mundos-e \
  --region us-east-1 \
  --node-type t3.small \
  --nodes 3 \
  --with-oidc \
  --ssh-access \
  --ssh-public-key pin \
  --managed \
  --zones us-east-1a,us-east-1b,us-east-1c

# Configurar kubectl para usar el contexto correcto
aws eks --region us-east-1 update-kubeconfig --name eks-mundos-e

# Crear y aplicar el aws-auth ConfigMap
cat <<EOF > aws-auth-cm.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
    - rolearn: arn:aws:iam::<YOUR_ACCOUNT_ID>:role/<YOUR_NODE_INSTANCE_ROLE>
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
  mapUsers: |
    - userarn: arn:aws:iam::<YOUR_ACCOUNT_ID>:user/<YOUR_USER>
      username: admin
      groups:
        - system:masters
EOF

kubectl apply -f aws-auth-cm.yaml
