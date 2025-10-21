# 🚀 Infraestrutura Escalável na AWS com Terraform e NGINX

Este projeto provisiona uma infraestrutura escalável na AWS utilizando Terraform. Ele implementa instâncias EC2 com NGINX, balanceamento de carga, grupos de Auto Scaling e configurações de rede seguras e distribuídas.

---

## 🧩 Visão Geral

- **Terraform** como ferramenta de IaC
- **NGINX** como servidor web
- **AWS EC2**, **Auto Scaling**, **Security Groups**, **Load Balancer**

---

## 🏗️ Componentes da Infraestrutura

| Componente         | Descrição                                                                 |
|--------------------|---------------------------------------------------------------------------|
| VPC                | Rede virtual isolada com subnets públicas e privadas                      |
| EC2 + NGINX        | Instâncias configuradas com NGINX para servir conteúdo estático ou proxy  |
| Auto Scaling Group | Escalabilidade automática com base em métricas de uso                     |
| Load Balancer      | Distribuição de tráfego entre instâncias                                  |
| Security Groups    | Regras de acesso para proteger os recursos                                |
| Outputs            | IPs públicos, DNS do Load Balancer, IDs de recursos                       |

---

## 📂 Estrutura de Arquivos

```bash
infra-aws-scalable-nginx/
├── main.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars         # (opcional, ignorado pelo Git)
├── .gitignore
└── README.md
```

---

## ⚙️ Pré-requisitos

- Conta AWS com permissões adequadas
- Terraform instalado (`terraform -v`)
- Chave SSH para acesso às instâncias (`.pem`)

---

## 📦 Como usar

```bash
# Inicializar o Terraform
terraform init

# Validar a configuração
terraform validate

# Visualizar o plano de execução
terraform plan

# Aplicar a infraestrutura
terraform apply
```

---

## 🔐 Segurança

- Chaves `.pem`, arquivos `.tfvars` e `.csv` são ignorados via `.gitignore`
- Security Groups configurados para permitir apenas portas necessárias (ex: 22, 80, 443)

---

## 📤 Outputs esperados

- IP público das instâncias
- DNS do Load Balancer
- ID do Auto Scaling Group

---

## 📌 Referências

- [Guia oficial da AWS sobre Terraform](https://docs.aws.amazon.com/pt_br/prescriptive-guidance/latest/getting-started-terraform/introduction.html)
- [Artigo sobre infraestrutura escalável com Terraform e AWS](https://dev.to/ezequiel_lopes/como-construir-uma-aplicacao-escalavel-com-terraform-e-aws-3c3p)

---

## 🧠 Autor

**Gustavo Ribeiro**  
Infraestrutura como código, automação e escalabilidade na nuvem ☁️  
[GitHub](https://github.com/ribeeiro95)

```