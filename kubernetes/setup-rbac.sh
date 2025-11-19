
1. Creates service accounts (dev-sa, test-sa, prod-sa).


2. Applies the full RBAC YAML (Role, RoleBinding, ClusterRole, ClusterRoleBinding).


3. Shows verification commands at the end.


---

📄 setup-rbac.sh

#!/bin/bash

# ============================
# 1. Create namespaces (if not exist)
# ============================
kubectl create namespace dev --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace test --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace prod --dry-run=client -o yaml | kubectl apply -f -

# ============================
# 2. Create Service Accounts
# ============================
kubectl create sa dev-sa -n dev --dry-run=client -o yaml | kubectl apply -f -
kubectl create sa test-sa -n test --dry-run=client -o yaml | kubectl apply -f -
kubectl create sa prod-sa -n prod --dry-run=client -o yaml | kubectl apply -f -

# ============================
# 3. Apply RBAC YAML
# ============================
cat <<EOF | kubectl apply -f -
# ========================
# Role for dev namespace
# ========================
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: dev-app-role
  namespace: dev
rules:
- apiGroups: [""]
  resources: ["pods", "services"]
  verbs: ["get", "list", "watch", "create", "update", "delete"]
- apiGroups: ["apps"]
  resources: ["deployments"]
  verbs: ["get", "list", "watch", "create", "update", "delete"]
- apiGroups: ["networking.k8s.io"]
  resources: ["ingresses"]
  verbs: ["get", "list", "watch", "create", "update", "delete"]
---
# RoleBinding for dev namespace
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: dev-app-rolebinding
  namespace: dev
subjects:
- kind: ServiceAccount
  name: dev-sa
  namespace: dev
roleRef:
  kind: Role
  name: dev-app-role
  apiGroup: rbac.authorization.k8s.io
---
# ========================
# ClusterRole (read-only across namespaces)
# ========================
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: view-app-resources
rules:
- apiGroups: [""]
  resources: ["pods", "services"]
  verbs: ["get", "list", "watch"]
- apiGroups: ["apps"]
  resources: ["deployments"]
  verbs: ["get", "list", "watch"]
- apiGroups: ["networking.k8s.io"]
  resources: ["ingresses"]
  verbs: ["get", "list", "watch"]
---
# ClusterRoleBinding across dev, test, prod
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: view-app-rolebinding
subjects:
- kind: ServiceAccount
  name: dev-sa
  namespace: dev
- kind: ServiceAccount
  name: test-sa
  namespace: test
- kind: ServiceAccount
  name: prod-sa
  namespace: prod
roleRef:
  kind: ClusterRole
  name: view-app-resources
  apiGroup: rbac.authorization.k8s.io
EOF

# ============================
# 4. Verification Commands
# ============================
echo "✅ Setup complete! Run these commands to verify:"
echo "------------------------------------------------"
echo "kubectl get roles -n dev"
echo "kubectl get rolebindings -n dev"
echo "kubectl get clusterroles | grep view-app-resources"
echo "kubectl get clusterrolebindings | grep view-app-rolebinding"
echo "kubectl auth can-i list pods --as=system:serviceaccount:dev:dev-sa -n dev"
echo "kubectl auth can-i create deployments --as=system:serviceaccount:dev:dev-sa -n dev"
echo "kubectl auth can-i list pods --as=system:serviceaccount:test:test-sa -n test"


---

⚡ Usage

1. Save the script:

nano setup-rbac.sh

(paste the script above)


2. Make it executable:

chmod +x setup-rbac.sh


3. Run it:

./setup-rbac.sh




---

👉 This will:

Ensure dev, test, prod namespaces exist.

Create service accounts in each.

Apply Role, RoleBinding, ClusterRole, ClusterRoleBinding.

Give you commands to test.



---
