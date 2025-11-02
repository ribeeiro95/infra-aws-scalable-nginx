# ⚡ Scalable NGINX Infrastructure on AWS with Terraform

[![Terraform](https://img.shields.io/badge/Terraform-1.0+-623CE4?logo=terraform&logoColor=white)](https://www.terraform.io/)
[![AWS](https://img.shields.io/badge/AWS-Cloud-FF9900?logo=amazon-aws&logoColor=white)](https://aws.amazon.com/)
[![NGINX](https://img.shields.io/badge/NGINX-1.24+-009639?logo=nginx&logoColor=white)](https://nginx.org/)
[![CI/CD](https://img.shields.io/badge/CI%2FCD-GitHub_Actions-2088FF?logo=github-actions&logoColor=white)](https://github.com/ribeeiro95/infra-aws-scalable-nginx/actions)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

> **Infraestrutura web escalável e de alta performance com NGINX, Application Load Balancer, Auto Scaling e monitoramento completo.**

## 📋 Índice

- [Visão Geral](#-visão-geral)
- [Arquitetura](#-arquitetura)
- [Tecnologias Utilizadas](#-tecnologias-utilizadas)
- [Features](#-features)
- [Estrutura do Projeto](#-estrutura-do-projeto)
- [Pré-requisitos](#-pré-requisitos)
- [Instalação e Deploy](#-instalação-e-deploy)
- [Auto Scaling em Ação](#-auto-scaling-em-ação)
- [Custos Estimados](#-custos-estimados)
- [Monitoramento e Performance](#-monitoramento-e-performance)
- [Testes de Carga](#-testes-de-carga)
- [Troubleshooting](#-troubleshooting)
- [Melhorias Futuras](#-melhorias-futuras)
- [Aprendizados](#-aprendizados)

---

## 🎯 Visão Geral

Este projeto implementa uma **infraestrutura web escalável** na AWS, utilizando NGINX como servidor web de alta performance, com escalabilidade automática baseada em métricas de CPU e distribuição inteligente de carga.

### 🌟 Destaques do Projeto

- ✅ **Auto Scaling Automático** - Escala baseado em CPU (target: 50%)
- ✅ **Alta Performance** - NGINX otimizado para produção
- ✅ **Load Balancing** - Application Load Balancer Layer 7
- ✅ **Multi-AZ Deployment** - Alta disponibilidade em múltiplas zonas
- ✅ **EBS Optimization** - Volumes otimizados para I/O
- ✅ **Health Checks** - Monitoramento contínuo de saúde
- ✅ **CI/CD Pipeline** - GitHub Actions para validação automática
- ✅ **Production-Ready** - Configuração enterprise-grade

### 🎓 Objetivo Educacional

Demonstrar competências em:
- Design de arquiteturas escaláveis
- Auto Scaling e Load Balancing
- Performance tuning (NGINX)
- Infrastructure as Code (Terraform)
- Monitoramento e observabilidade
- DevOps best practices

---

## 🏗️ Arquitetura

### 📊 Diagrama da Infraestrutura

```
                          ┌──────────────────┐
                          │     INTERNET     │
                          │   (End Users)    │
                          └────────┬─────────┘
                                   │
                          ┌────────▼─────────┐
                          │ Internet Gateway │
                          └────────┬─────────┘
                                   │
                    ┌──────────────▼──────────────┐
                    │  Application Load Balancer  │
                    │   (ALB - Layer 7)           │
                    │   DNS: scalable-nginx-alb   │
                    └──────────────┬──────────────┘
                                   │
                    ┌──────────────┴──────────────┐
                    │       Target Group          │
                    │   Health Check: /health     │
                    │   Protocol: HTTP:80         │
                    └──────────────┬──────────────┘
                                   │
              ┌────────────────────┴────────────────────┐
              │          Auto Scaling Group             │
              │  Min: 1 | Max: 4 | Desired: 2          │
              │  Scale Up: CPU > 50%                    │
              │  Scale Down: CPU < 30%                  │
              └────────────────────┬────────────────────┘
                                   │
         ┌─────────────────────────┼─────────────────────────┐
         │                         │                         │
┌────────▼─────────┐      ┌────────▼─────────┐     ┌────────▼─────────┐
│  Availability     │      │  Availability     │     │  Availability     │
│  Zone us-east-1a  │      │  Zone us-east-1b  │     │  Zone us-east-1a  │
│                   │      │                   │     │  (Scale Event)    │
│ ┌───────────────┐ │      │ ┌───────────────┐ │     │ ┌───────────────┐ │
│ │  EC2 Instance │ │      │ │  EC2 Instance │ │     │ │  EC2 Instance │ │
│ │  t3.micro     │ │      │ │  t3.micro     │ │     │ │  t3.micro     │ │
│ │  + NGINX      │ │      │ │  + NGINX      │ │     │ │  + NGINX      │ │
│ │  + EBS 8GB    │ │      │ │  + EBS 8GB    │ │     │ │  + EBS 8GB    │ │
│ └───────────────┘ │      │ └───────────────┘ │     │ └───────────────┘ │
│                   │      │                   │     │                   │
│ Public Subnet     │      │ Public Subnet     │     │ Public Subnet     │
│ 10.0.1.0/24       │      │ 10.0.2.0/24       │     │ 10.0.1.0/24       │
└───────────────────┘      └───────────────────┘     └───────────────────┘
         │                         │                          │
         └─────────────────────────┴──────────────────────────┘
                                   │
                          ┌────────▼─────────┐
                          │   CloudWatch     │
                          │   Monitoring     │
                          │   + Alarms       │
                          └──────────────────┘

VPC: 10.0.0.0/16
Region: us-east-1 (North Virginia)
```

### 🔄 Fluxo de Requisições

```
1. User Request → Internet Gateway
2. ALB recebe request e verifica Target Health
3. ALB distribui para instância saudável (Round Robin)
4. NGINX processa request e retorna resposta
5. Resposta volta através do ALB
6. CloudWatch monitora métricas continuamente
7. Se CPU > 50% por 2 minutos → Auto Scaling adiciona instância
8. Se CPU < 30% por 5 minutos → Auto Scaling remove instância
```

### 📐 Componentes Detalhados

```
VPC (10.0.0.0/16)
│
├── Public Subnet 1a (10.0.1.0/24)
│   ├── Route Table → Internet Gateway
│   └── EC2 Instances (Auto Scaled)
│
├── Public Subnet 1b (10.0.2.0/24)
│   ├── Route Table → Internet Gateway
│   └── EC2 Instances (Auto Scaled)
│
├── Internet Gateway
│   └── Conectado à VPC
│
├── Security Groups
│   ├── ALB-SG
│   │   ├── Inbound: 80 (HTTP) from 0.0.0.0/0
│   │   └── Outbound: All to EC2-SG
│   │
│   └── EC2-SG
│       ├── Inbound: 80 from ALB-SG
│       ├── Inbound: 22 from MY_IP (SSH)
│       └── Outbound: All
│
├── Application Load Balancer
│   ├── Scheme: internet-facing
│   ├── Target Group: nginx-tg
│   │   ├── Protocol: HTTP
│   │   ├── Port: 80
│   │   ├── Health Check: /health
│   │   └── Stickiness: Disabled
│   │
│   └── Listeners
│       └── HTTP:80 → Forward to nginx-tg
│
└── Auto Scaling Group
    ├── Launch Template
    │   ├── AMI: Amazon Linux 2023
    │   ├── Instance Type: t3.micro
    │   ├── Key Pair: scalable-nginx-key
    │   ├── Security Group: EC2-SG
    │   ├── User Data: install_nginx.sh
    │   └── EBS: 8GB gp3
    │
    ├── Capacity
    │   ├── Minimum: 1
    │   ├── Maximum: 4
    │   └── Desired: 2
    │
    └── Scaling Policies
        ├── Scale Up
        │   ├── Metric: CPUUtilization
        │   ├── Threshold: > 50%
        │   ├── Period: 120 seconds
        │   └── Action: Add 1 instance
        │
        └── Scale Down
            ├── Metric: CPUUtilization
            ├── Threshold: < 30%
            ├── Period: 300 seconds
            └── Action: Remove 1 instance
```

---

## 🛠️ Tecnologias Utilizadas

### Infrastructure & Automation
- **Terraform** `~> 5.0` - Infrastructure as Code
- **GitHub Actions** - CI/CD pipeline
- **Bash** - Automation scripts

### AWS Services
- **EC2** - Elastic Compute (t3.micro instances)
- **Auto Scaling** - Automatic scaling based on metrics
- **Application Load Balancer** - Layer 7 load balancing
- **VPC** - Virtual Private Cloud
- **CloudWatch** - Monitoring, metrics, and alarms
- **EBS** - Elastic Block Store (gp3 volumes)
- **IAM** - Identity and Access Management

### Web Server
- **NGINX** `1.24+` - High-performance HTTP server
  - Worker processes: auto (based on CPU cores)
  - Worker connections: 1024
  - Keepalive timeout: 65s
  - Gzip compression: enabled

---

## ⚡ Features

### 1. Auto Scaling Inteligente

```hcl
Scale Up Policy:
  ├─ Trigger: Average CPU > 50%
  ├─ Evaluation Period: 2 minutes
  ├─ Cooldown: 300 seconds
  └─ Action: Add 1 instance (até max 4)

Scale Down Policy:
  ├─ Trigger: Average CPU < 30%
  ├─ Evaluation Period: 5 minutes
  ├─ Cooldown: 600 seconds
  └─ Action: Remove 1 instance (mínimo 1)
```

### 2. Health Checks Robustos

```yaml
Target Group Health Check:
  Path: /health
  Protocol: HTTP
  Port: 80
  Interval: 30 seconds
  Timeout: 5 seconds
  Healthy Threshold: 3 consecutive successes
  Unhealthy Threshold: 2 consecutive failures
```

### 3. NGINX Otimizado

```nginx
# /etc/nginx/nginx.conf
worker_processes auto;
worker_connections 1024;

http {
    # Performance
    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;
    
    # Compression
    gzip on;
    gzip_types text/plain text/css application/json;
    
    # Keepalive
    keepalive_timeout 65;
    
    # Caching
    open_file_cache max=1000 inactive=20s;
}
```

### 4. Security Best Practices

- ✅ Security Groups com mínimo privilégio
- ✅ SSH apenas do seu IP
- ✅ Tráfego web apenas através do ALB
- ✅ Instâncias em subnets públicas (可 melhorar: private)
- ✅ IAM roles ao invés de access keys

---

## 📁 Estrutura do Projeto

```
infra-aws-scalable-nginx/
│
├── .github/
│   └── workflows/
│       └── terraform.yml          # CI/CD pipeline
│
├── terraform/
│   ├── main.tf                    # Provider & backend config
│   ├── variables.tf               # Input variables
│   ├── outputs.tf                 # Output values
│   ├── terraform.tfvars.example   # Template de variáveis
│   │
│   ├── vpc.tf                     # VPC, Subnets, IGW, Routes
│   ├── security_group.tf          # Security Groups (ALB + EC2)
│   ├── alb.tf                     # Application Load Balancer
│   ├── ec2.tf                     # Launch Template + ASG
│   ├── ebs.tf                     # EBS Volume configuration
│   │
│   └── user_data.sh               # NGINX installation script
│
├── .gitignore                     # Arquivos ignorados
├── .vscode/
│   └── settings.json              # VS Code config
│
└── README.md                      # Este arquivo
```

---

## ✅ Pré-requisitos

### 1. Ferramentas

```bash
# Terraform >= 1.0
terraform -v
# Terraform v1.0.0 ou superior

# AWS CLI configurado
aws --version
aws configure

# Git
git --version
```

### 2. Conta AWS

- [x] Conta AWS ativa
- [x] Usuário IAM com permissões:
  ```
  - AmazonEC2FullAccess
  - AmazonVPCFullAccess
  - ElasticLoadBalancingFullAccess
  - AutoScalingFullAccess
  - CloudWatchFullAccess
  ```

### 3. Par de Chaves SSH

```bash
# Criar chave na AWS Console
# ou via CLI:
aws ec2 create-key-pair \
  --key-name scalable-nginx-key \
  --region us-east-1 \
  --query 'KeyMaterial' \
  --output text > scalable-nginx-key.pem

# Permissões (Linux/Mac)
chmod 400 scalable-nginx-key.pem

# Windows (PowerShell)
icacls scalable-nginx-key.pem /inheritance:r
icacls scalable-nginx-key.pem /grant:r "$($env:USERNAME):R"
```

---

## 🚀 Instalação e Deploy

### Passo 1: Clonar o Repositório

```bash
git clone https://github.com/ribeeiro95/infra-aws-scalable-nginx.git
cd infra-aws-scalable-nginx/terraform
```

### Passo 2: Configurar Variáveis

```bash
# Copiar template
cp terraform.tfvars.example terraform.tfvars

# Editar com suas configurações
nano terraform.tfvars
```

**Exemplo de `terraform.tfvars`:**

```hcl
# Região AWS
aws_region = "us-east-1"

# VPC Configuration
vpc_cidr = "10.0.0.0/16"
availability_zones = ["us-east-1a", "us-east-1b"]
public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]

# EC2 Configuration
instance_type = "t3.micro"
key_name = "scalable-nginx-key"

# Auto Scaling Configuration
asg_min_size = 1
asg_max_size = 4
asg_desired_capacity = 2

# Seu IP para SSH (obter em: https://checkip.amazonaws.com)
my_ip = "203.0.113.0/32"

# Tags
project_name = "scalable-nginx"
environment = "production"
```

### Passo 3: Deploy

```bash
# Inicializar Terraform
terraform init

# Validar configuração
terraform validate
# Success! The configuration is valid.

# Visualizar plano
terraform plan

# Aplicar infraestrutura
terraform apply
# Digite 'yes' quando solicitado
```

**Tempo estimado:** 8-12 minutos ⏱️

### Passo 4: Obter Informações

```bash
# Outputs do Terraform
terraform output

# Expected outputs:
# alb_dns_name = "scalable-nginx-alb-123456.us-east-1.elb.amazonaws.com"
# asg_name = "scalable-nginx-asg"
# vpc_id = "vpc-0a1b2c3d4e5f6g7h8"
```

### Passo 5: Testar a Aplicação

```bash
# Obter DNS do ALB
ALB_DNS=$(terraform output -raw alb_dns_name)

# Testar com curl
curl http://$ALB_DNS

# Testar health endpoint
curl http://$ALB_DNS/health

# Ver qual instância respondeu
curl -I http://$ALB_DNS | grep -i server
```

---

## 📈 Auto Scaling em Ação

### Simular Carga Alta para Trigger Scale Up

#### Método 1: Apache Benchmark

```bash
# Instalar Apache Bench (se necessário)
# Ubuntu/Debian:
sudo apt-get install apache2-utils
# macOS:
brew install httpd

# Gerar carga
ALB_DNS=$(terraform output -raw alb_dns_name)

# 10000 requests, 100 concurrent
ab -n 10000 -c 100 http://$ALB_DNS/

# Monitorar CPU no CloudWatch
watch -n 10 '
aws cloudwatch get-metric-statistics \
  --namespace AWS/EC2 \
  --metric-name CPUUtilization \
  --dimensions Name=AutoScalingGroupName,Value=scalable-nginx-asg \
  --start-time $(date -u -d "10 minutes ago" +"%Y-%m-%dT%H:%M:%S") \
  --end-time $(date -u +"%Y-%m-%dT%H:%M:%S") \
  --period 300 \
  --statistics Average \
  --query "Datapoints[*].[Timestamp,Average]" \
  --output table
'
```

#### Método 2: Stress Test nas Instâncias

```bash
# 1. Conectar via SSH em uma instância
INSTANCE_IP=$(aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=scalable-nginx-instance" \
  --query "Reservations[0].Instances[0].PublicIpAddress" \
  --output text)

ssh -i scalable-nginx-key.pem ec2-user@$INSTANCE_IP

# 2. Instalar stress tool
sudo yum install stress -y

# 3. Gerar carga de CPU
stress --cpu 8 --timeout 600s
# Mantém CPU alta por 10 minutos

# 4. Monitorar Auto Scaling Activity
aws autoscaling describe-scaling-activities \
  --auto-scaling-group-name scalable-nginx-asg \
  --max-records 10
```

### Observar o Scale Up

```bash
# Listar instâncias do ASG
aws autoscaling describe-auto-scaling-groups \
  --auto-scaling-group-names scalable-nginx-asg \
  --query "AutoScalingGroups[0].[MinSize,MaxSize,DesiredCapacity]"

# Ver eventos de scaling
aws autoscaling describe-scaling-activities \
  --auto-scaling-group-name scalable-nginx-asg \
  --output table

# Monitorar quantidade de instâncias
watch -n 10 '
echo "Current instances:"
aws ec2 describe-instances \
  --filters "Name=tag:aws:autoscaling:groupName,Values=scalable-nginx-asg" \
  --query "Reservations[*].Instances[*].[InstanceId,State.Name,LaunchTime]" \
  --output table
'
```

### Timeline do Scale Up

```
T+0min  : Carga aumenta, CPU sobe para 60%
T+2min  : CloudWatch Alarm: CPU > 50% por 2 minutos consecutivos
T+2min  : Auto Scaling Policy triggered
T+2min  : Inicia launch de nova instância
T+3min  : Nova instância iniciando (initializing)
T+4min  : User-data executando (instalando NGINX)
T+5min  : Health checks iniciando
T+6min  : Health checks passaram (3 sucessos consecutivos)
T+6min  : Instância adicionada ao Target Group
T+6min  : ALB começa a enviar tráfego para nova instância
T+8min  : Scale up completo ✅
```

---

## 💰 Custos Estimados

### 💵 Custos Mensais (us-east-1)

#### Cenário 1: Mínimo (1 instância)
| Serviço | Quantidade | Custo Mensal |
|---------|------------|--------------|
| EC2 t3.micro | 1 instância | $7.59 |
| Application Load Balancer | 1 ALB | $22.00 |
| EBS gp3 (8GB) | 1 volume | $0.64 |
| Data Transfer OUT | ~5GB | $0.45 |
| **TOTAL** | | **$30.68/mês** |

#### Cenário 2: Normal (2 instâncias)
| Serviço | Quantidade | Custo Mensal |
|---------|------------|--------------|
| EC2 t3.micro | 2 instâncias | $15.18 |
| Application Load Balancer | 1 ALB | $22.00 |
| EBS gp3 (8GB cada) | 2 volumes | $1.28 |
| Data Transfer OUT | ~10GB | $0.90 |
| **TOTAL** | | **$39.36/mês** |

#### Cenário 3: Peak (4 instâncias)
| Serviço | Quantidade | Custo Mensal |
|---------|------------|--------------|
| EC2 t3.micro | 4 instâncias | $30.36 |
| Application Load Balancer | 1 ALB | $22.00 |
| EBS gp3 (8GB cada) | 4 volumes | $2.56 |
| Data Transfer OUT | ~20GB | $1.80 |
| **TOTAL** | | **$56.72/mês** |

### 💡 Estimativa Real

```
Assumindo:
- 70% do tempo: 2 instâncias (normal)
- 20% do tempo: 3 instâncias (pico moderado)
- 10% do tempo: 1 instância (baixo tráfego)

Custo Médio Mensal: ~$42/mês
```

### 📊 Breakdown Detalhado

```
EC2 t3.micro (us-east-1):
  ├─ On-Demand: $0.0104/hora
  ├─ Por instância/mês: $7.59
  └─ 2 instâncias average: $15.18/mês

Application Load Balancer:
  ├─ ALB Hour: $0.0225/hora = $16.43/mês
  ├─ LCU (Load Balancer Capacity Unit): ~$5.57/mês
  └─ Total: $22.00/mês

EBS gp3:
  ├─ Storage: $0.08/GB/mês
  ├─ 8GB por volume: $0.64/mês
  └─ 2 volumes: $1.28/mês

Data Transfer:
  ├─ First 10TB/month OUT: $0.09/GB
  └─ ~10GB/mês: $0.90/mês

CloudWatch:
  ├─ Basic Monitoring: FREE
  ├─ 10 Alarms: FREE
  └─ Total: $0.00/mês
```

### 💰 Opções de Economia

#### 1. Reserved Instances (1 ano, parcial)
```
EC2 Savings: ~40%
Novo custo 2 instâncias: $9.11/mês (vs $15.18)
Economia anual: ~$72
```

#### 2. Savings Plans (1 ano, compute)
```
Savings: ~30%
Aplicável a: EC2 + ALB
Economia mensal: ~$6/mês
```

#### 3. Spot Instances (Advanced)
```
⚠️ Para workloads fault-tolerant
Savings: até 90%
Porém: Instâncias podem ser terminadas
```

---

## 📊 Monitoramento e Performance

### CloudWatch Métricas Principais

```yaml
EC2 Metrics:
  - CPUUtilization (%)
  - NetworkIn/Out (bytes)
  - DiskReadOps/WriteOps
  - StatusCheckFailed

Auto Scaling Metrics:
  - GroupDesiredCapacity
  - GroupInServiceInstances
  - GroupMinSize/MaxSize

ALB Metrics:
  - TargetResponseTime (ms)
  - RequestCount
  - HTTPCode_Target_2XX_Count
  - HTTPCode_Target_5XX_Count
  - UnHealthyHostCount
  - ActiveConnectionCount
```

### Alarmes CloudWatch Configurados

```hcl
1. High CPU Alarm
   Metric: CPUUtilization > 70%
   Period: 5 minutes
   Action: SNS notification

2. Unhealthy Targets
   Metric: UnHealthyHostCount > 0
   Period: 2 minutes
   Action: SNS notification + Auto Scaling check

3. High Response Time
   Metric: TargetResponseTime > 500ms
   Period: 5 minutes
   Action: Investigation alert

4. Low Traffic (cost optimization)
   Metric: RequestCount < 100/5min
   Period: 30 minutes
   Action: Scale down consideration
```

### Dashboard CloudWatch

```bash
# Criar dashboard via CLI
aws cloudwatch put-dashboard \
  --dashboard-name ScalableNginxDashboard \
  --dashboard-body file://dashboard-config.json
```

**dashboard-config.json:**
```json
{
  "widgets": [
    {
      "type": "metric",
      "properties": {
        "metrics": [
          [ "AWS/EC2", "CPUUtilization", { "stat": "Average" } ],
          [ "AWS/ApplicationELB", "TargetResponseTime" ],
          [ "AWS/ApplicationELB", "RequestCount" ]
        ],
        "period": 300,
        "stat": "Average",
        "region": "us-east-1",
        "title": "Performance Overview"
      }
    }
  ]
}
```

---

## 🧪 Testes de Carga

### Teste 1: Baseline Performance

```bash
# Teste simples com curl
for i in {1..100}; do
  time curl -s http://$ALB_DNS > /dev/null
done

# Resultado esperado:
# Average: ~50ms
# p95: ~100ms
# p99: ~200ms
```

### Teste 2: Load Test com Apache Bench

```bash
# 1000 requests, 10 concurrent users
ab -n 1000 -c 10 http://$ALB_DNS/

# Métricas importantes:
# - Requests per second
# - Time per request
# - Transfer rate
```

**Resultado Esperado (2 instâncias):**
```
Requests per second:    ~200 [#/sec]
Time per request:       50 [ms] (mean)
Time per request:       5 [ms] (mean, across all concurrent)
Transfer rate:          ~400 [Kbytes/sec]
```

### Teste 3: Stress Test (Trigger Auto Scaling)

```bash
# 10000 requests, 100 concurrent
ab -n 10000 -c 100 -t 300 http://$ALB_DNS/

# -t 300: rodar por 5 minutos
# Monitore no CloudWatch:
# 1. CPU deve subir >50%
# 2. Após ~2min: nova instância deve ser lançada
# 3. Após scale up: performance deve melhorar
```

### Teste 4: Análise Detalhada com wrk

```bash
# Instalar wrk
git clone https://github.com/wg/wrk.git
cd wrk
make

# Teste de 5 minutos com 10 threads e 100 conexões
./wrk -t10 -c100 -d300s http://$ALB_DNS/

# Saída example:
# Running 5m test @ http://alb-xxx.amazonaws.com/
#   10 threads and 100 connections
#   Thread Stats   Avg      Stdev     Max   +/- Stdev
#     Latency    45.23ms   12.45ms  200.00ms   75.32%
#     Req/Sec   210.45     45.32     350.00     68.12%
#   Latency Distribution
#      50%   42.00ms
#      75%   51.00ms
#      90%   62.00ms
#      99%   98.00ms
#   63000 requests in 5.00m, 15.23MB read
# Requests/sec:   210.00
# Transfer/sec:   52.15KB
```

---

## 🔧 Troubleshooting

### Problema 1: Instâncias Unhealthy no Target Group

**Sintoma:**
```
UnHealthyHostCount > 0
```

**Debug:**
```bash
# 1. Ver status dos targets
aws elbv2 describe-target-health \
  --target-group-arn $(aws elbv2 describe-target-groups \
    --names nginx-tg \
    --query 'TargetGroups[0].TargetGroupArn' \
    --output text)

# 2. Verificar Security Group
aws ec2 describe-security-groups \
  --filters "Name=tag:Name,Values=scalable-nginx-ec2-sg" \
  --query 'SecurityGroups[0].IpPermissions'

# 3. Conectar na instância e verificar NGINX
ssh -i scalable-nginx-key.pem ec2-user@<INSTANCE_IP>
sudo systemctl status nginx
sudo journalctl -u nginx -n 50
```

**Soluções:**
- Verificar se NGINX está rodando
- Conferir endpoint /health existe
- Security Group permite tráfego do ALB
- Verificar logs de user-data: `/var/log/cloud-init-output.log`

### Problema 2: Auto Scaling Não Funciona

**Sintoma:**
```
CPU > 50% mas nenhuma instância nova lançada
```

**Debug:**
```bash
# 1. Verificar políticas de scaling
aws autoscaling describe-policies \
  --auto-scaling-group-name scalable-nginx-asg

# 2. Ver atividades recentes
aws autoscaling describe-scaling-activities \
  --auto-scaling-group-name scalable-nginx-asg \
  --max-records 5

# 3. Verificar alarmes CloudWatch
aws cloudwatch describe-alarms \
  --alarm-names cpu-high-alarm
```

**Causas Comuns:**
- Já atingiu MaxSize
- Cooldown period ativo
- Insufficient capacity (quota AWS)
- Alarm não está em estado ALARM

### Problema 3: Alto Custo Inesperado

**Debug:**
```bash
# 1. Verificar quantas instâncias rodando
aws autoscaling describe-auto-scaling-groups \
  --auto-scaling-group-names scalable-nginx-asg \
  --query 'AutoScalingGroups[0].[DesiredCapacity,MinSize,MaxSize]'

# 2. Ver histórico de scaling
aws autoscaling describe-scaling-activities \
  --auto-scaling-group-name scalable-nginx-asg \
  --max-records 20 \
  --output table

# 3. Análise de custos
aws ce get-cost-and-usage \
  --time-period Start=2025-11-01,End=2025-11-30 \
  --granularity DAILY \
  --metrics UnblendedCost \
  --group-by Type=SERVICE \
  --filter file://filter.json
```

**filter.json:**
```json
{
  "Tags": {
    "Key": "Project",
    "Values": ["scalable-nginx"]
  }
}
```

### Problema 4: Performance Degradada

**Sintoma:** Response time alto mesmo com baixa carga

**Debug:**
```bash
# 1. Verificar métricas ALB
aws cloudwatch get-metric-statistics \
  --namespace AWS/ApplicationELB \
  --metric-name TargetResponseTime \
  --dimensions Name=LoadBalancer,Value=app/scalable-nginx-alb/xxx \
  --start-time $(date -u -d '1 hour ago' +%Y-%m-%dT%H:%M:%S) \
  --end-time $(date -u +%Y-%m-%dT%H:%M:%S) \
  --period 300 \
  --statistics Average

# 2. Conectar em instância e analisar NGINX
ssh -i scalable-nginx-key.pem ec2-user@<IP>

# Ver configuração NGINX
sudo nginx -T

# Ver connections ativas
sudo netstat -an | grep :80 | grep ESTABLISHED | wc -l

# Ver processos NGINX
ps aux | grep nginx

# 3. Verificar se EBS está throttling
aws cloudwatch get-metric-statistics \
  --namespace AWS/EBS \
  --metric-name VolumeReadOps \
  --dimensions Name=VolumeId,Value=vol-xxx \
  ...
```

---

## 🚀 Melhorias Futuras

### Fase 1: Segurança
- [ ] Mover instâncias para private subnets
- [ ] Adicionar NAT Gateway para updates
- [ ] Implementar WAF no ALB
- [ ] Adicionar HTTPS/TLS (ACM certificate)
- [ ] Secrets Manager para credenciais

### Fase 2: Performance
- [ ] CDN com CloudFront
- [ ] ElastiCache (Redis) para caching
- [ ] RDS para database (se aplicável)
- [ ] Otimizar NGINX config (worker_processes, buffers)

### Fase 3: Observabilidade
- [ ] AWS X-Ray para distributed tracing
- [ ] Centralized logging (ELK stack)
- [ ] Custom CloudWatch Logs
- [ ] Prometheus + Grafana
- [ ] PagerDuty integration

### Fase 4: Automação
- [ ] Blue-Green deployment
- [ ] Scheduled scaling (scale up durante horário pico)
- [ ] Predictive scaling (ML-based)
- [ ] Auto remediation com Lambda

### Fase 5: Multi-Region
- [ ] Deploy em us-west-2
- [ ] Route 53 latency-based routing
- [ ] Cross-region replication

---

## 📚 Aprendizados

### Competências Desenvolvidas

✅ **Auto Scaling**
- Políticas de scaling (target tracking, step, simple)
- Cooldown periods e timing
- Launch templates vs configurations

✅ **Load Balancing**
- ALB vs NLB vs CLB
- Target groups e health checks
- Connection draining e deregistration delay

✅ **Performance Tuning**
- NGINX optimization
- EBS volume types (gp3 vs gp2)
- Instance sizing

✅ **Cost Optimization**
- Right-sizing instances
- Auto scaling para economizar
- Monitoring custos com CloudWatch

✅ **Infrastructure as Code**
- Terraform modules organization
- Variable management
- State management

### Desafios Superados

1. **Timing do Auto Scaling**
   - Balance entre responsividade e estabilidade
   - Evitar flapping (scale up/down constante)

2. **Health Check Configuration**
   - Tuning de thresholds
   - Evitar false positives

3. **NGINX Performance**
   - Worker processes optimization
   - Keepalive tuning
   - Buffer sizes

---

## 📞 Contato

**Gustavo Ribeiro do Vale**

- 💼 [LinkedIn](https://www.linkedin.com/in/GustavoRibeiro95/)
- 🐙 [GitHub](https://github.com/Ribeeiro95)
- 📧 Email: gustavordovale@hotmail.com
- 🌍 Localização: Americana, SP - Brasil

---

## 📄 Licença

Este projeto está sob a licença MIT.

---

⭐ **Se este projeto ajudou você a aprender sobre Auto Scaling e Load Balancing, considere dar uma estrela!**

---

**Desenvolvido com ❤️ e ☕ por Gustavo Ribeiro | Aspirante a DevOps Engineer**
