# IaC - El Fin del ClickOps

![Terraform](https://img.shields.io/badge/Terraform-~>6.0-7B42BC?logo=terraform&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-us--east--1-FF9900?logo=amazonaws&logoColor=white)
![Amazon Linux](https://img.shields.io/badge/AMI-Amazon_Linux_2023-232F3E?logo=amazon&logoColor=white)

## Descripción

Masterclass educativa de **Infraestructura como Código (IaC)** desarrollada para [Bootcamperu](https://bootcamperu.com). El objetivo es mostrar cómo pasar del enfoque manual de ClickOps (crear recursos en la consola de AWS uno por uno) a la automatización declarativa con Terraform.

Incluye una demo funcional que aprovisiona infraestructura en AWS y una presentación de apoyo (`IaC_El_Fin_del_ClickOps.pptx`).

## Tecnologías

- [Terraform](https://www.terraform.io/) `~> 6.0` (provider AWS)
- AWS EC2 (`t2.micro`, 3 instancias)
- AWS VPC, Subnet pública, Internet Gateway, Route Table
- AWS Security Groups (SSH)
- Amazon Linux 2023 (AMI `al2023-ami-*-x86_64`)
- Estado remoto en S3 con lock nativo

## Arquitectura

```
us-east-1
└── VPC: 10.0.0.0/16  (vpc-demo)
    ├── Internet Gateway  (igw-demo)
    ├── Subnet pública: 10.0.1.0/24  (subnet-publica-demo)  [us-east-1a]
    ├── Route Table → 0.0.0.0/0 → IGW  (rt-publica-demo)
    ├── Security Group: SSH 22/tcp  (sg-ssh-demo)
    └── EC2 x3: t2.micro, Amazon Linux 2023  (ec2-demo)
```

Estado de Terraform almacenado en S3:
- **Bucket:** `bootcamperu-tf-state`
- **Key:** `terraform.tfstate`
- **Región:** `us-east-1`

## Prerrequisitos

- [Terraform CLI](https://developer.hashicorp.com/terraform/install) instalado
- Credenciales AWS configuradas (`aws configure` o variables de entorno `AWS_ACCESS_KEY_ID` / `AWS_SECRET_ACCESS_KEY`)
- Bucket S3 `bootcamperu-tf-state` creado en `us-east-1` para el estado remoto

## Primeros pasos

```bash
cd demo

# 1. Inicializar Terraform y descargar el provider
terraform init

# 2. Ver el plan de cambios antes de aplicar
terraform plan

# 3. Aprovisionar la infraestructura
terraform apply
```

## Estructura del proyecto

```
masterclass-iac-terraform/
├── demo/
│   └── main.tf                    # Configuración completa de Terraform
├── IaC_El_Fin_del_ClickOps.pptx   # Presentación de la masterclass
└── README.md
```

## Outputs

| Output  | Descripción           |
|---------|-----------------------|
| `vpc_id` | ID de la VPC creada  |

## Limpieza

Para destruir todos los recursos aprovisionados:

```bash
cd demo
terraform destroy
```
