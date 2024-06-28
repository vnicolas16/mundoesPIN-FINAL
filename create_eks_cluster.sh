#!/bin/bash

eksctl create cluster \
--name eks-mundos-e \
--region us-east-1 \
--node-type t3.small \
--nodes 3 \
--with-oidc \
--ssh-access \
--ssh-public-key pin \
--managed \
--full-ecr-access \
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
