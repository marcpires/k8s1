# k8s1

## Requisitos
- Sistema operacional *nix-like
- Binários docker e kubectl
- Python (required for pre-commit)
- pre-commit hook
- Golang required for e2e tests

## Organização do repositório

## Começando

1. Instalar pre-commit hook e hooks
  
```
$ pip install pre-commit
$ pre-commit install --install-hooks
``` 

2. Instale um cluster kubernetes usando um dos scripts abaixo

```
curl -s https://raw.githubusercontent.com/lhc/k8s1/refs/heads/main/k3s-install.sh | bash -x
```

3. Instale e configure o argocd (ele vai aplicar tudo em `./applicationsets`)
   
```
curl -s https://raw.githubusercontent.com/lhc/k8s1/refs/heads/main/argocd-install.sh | bash -x
```
