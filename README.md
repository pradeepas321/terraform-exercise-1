# Terraform Exercise 1

Directory Structure: 

.
├── projects
│   └── apple
│       └── dev
│           ├── backend.tf
│           ├── compute
│           │   ├── main.tf
│           │   ├── outputs.tf
│           │   └── variables.tf
│           ├── database
│           │   ├── outputs.tf
│           │   ├── rds.tf
│           │   └── variables.tf
│           ├── main.tf
│           ├── network
│           │   ├── eic-endpoint.tf
│           │   ├── gateway.tf
│           │   ├── main.tf
│           │   ├── outputs.tf
│           │   ├── rtables.tf
│           │   ├── security_groups.tf
│           │   └── variables.tf
│           ├── output.tf
│           ├── provider.tf
│           └── variables.tf
└── README.md

link:https://livingdevops.com/aws/deploy-a-highly-secure-3-tier-infrastructure-on-aws-with-terraform-and-github-action/

######################

Terraform Configuration Flow (Module Structure)

Root (dev/)
   │
   ├── main.tf
   │     │
   │     ├── module "network" ──────────────────┐
   │     │                                      │
   │     ├── module "database" ─────────────────│──┐
   │     │                                      │  │
   │     └── module "compute" ─────────────────│──│──┐
   │                                            │  │  │
   ├── variables.tf (project, CIDRs, keys, DB)  │  │  │
   ├── provider.tf (AWS region)                │  │  │
   ├── backend.tf (S3 state)                   │  │  │
   │                                            │  │  │
   ═══════════════════════════════════════════════  │  │
   │                                            │  │  │
   ▼ network/ (module)                         │  │  │
   │  ├── main.tf ─────────────────────────────┼──┼──┘
   │  │   ├── VPC, public & private subnets    │  │
   │  │   └── second private subnet (RDS)      │  │
   │  ├── gateway.tf (IGW, EIP, NAT)           │  │
   │  ├── rtables.tf (public/private route)    │  │
   │  ├── security_groups.tf (web, rds, eic)   │  │
   │  ├── eic-endpoint.tf (EIC)                │  │
   │  ├── eic-sg.tf (EIC security group)       │  │
   │  ├── outputs.tf (subnet IDs, SG IDs) ─────┼──┘
   │  └── variables.tf                         │
   │                                           │
   ▼ database/ (module)                        │
   │  ├── rds.tf (subnet group, PostgreSQL)    │
   │  ├── outputs.tf (endpoint)                │
   │  └── variables.tf                         │
   │                                           │
   ▼ compute/ (module)                         │
      ├── main.tf (AMI, EC2, user_data) ───────┘
      ├── outputs.tf (instance ID, private IP)
      └── variables.tf


######################################

AWS Network Architecture Diagram



                              INTERNET
                                 │
                                 │ (SSH from my_ip only)
                                 ▼
                    ┌────────────────────────┐
                    │  EC2 Instance Connect   │
                    │     Endpoint (EIC)      │
                    │  (private subnet, free) │
                    └────────────┬───────────┘
                                 │ (private connection)
                                 ▼
   ┌─────────────────────────────────────────────────────────────┐
   │                         VPC (apple_dev_net)                 │
   │                     CIDR: 172.12.0.0/16                     │
   │                                                             │
   │  ┌──────────────────┐        ┌──────────────────────────┐  │
   │  │  Public Subnet    │        │     Private Subnet 1     │  │
   │  │ 172.12.1.0/24     │        │    172.12.2.0/24         │  │
   │  │                   │        │                          │  │
   │  │ ┌─────────────┐   │        │  ┌────────────────────┐  │  │
   │  │ │ Internet    │   │        │  │   EC2 Instance      │  │  │
   │  │ │ Gateway     │   │        │  │   (t3.micro)        │  │  │
   │  │ └──────┬──────┘   │        │  │   - Flask app :8080 │  │  │
   │  │        │          │        │  │   - SSH via EIC     │  │  │
   │  │        │          │        │  └──────────┬─────────┘  │  │
   │  │ ┌──────▼──────┐   │        │             │            │  │
   │  │ │ NAT Gateway │   │        │             │ (5432)     │  │
   │  │ │ (with EIP)  │   │        │             ▼            │  │
   │  │ └──────┬──────┘   │        │  ┌────────────────────┐  │  │
   │  └────────│──────────┘        │  │   RDS PostgreSQL    │  │  │
   │           │                   │  │   db.t3.micro       │  │  │
   │           │ (0.0.0.0/0)       │  │   - Multi-AZ? No    │  │  │
   │           │ via NAT           │  │   - Backups: 0 days │  │  │
   │           │                   │  └────────────────────┘  │  │
   │  ┌────────▼──────────┐        │                          │  │
   │  │ Private Subnet 2  │        │  (RDS also uses this     │  │
   │  │ 172.12.3.0/24     │◄───────┼── subnet for HA)         │  │
   │  │ (for RDS only)    │        │                          │  │
   │  └───────────────────┘        └──────────────────────────┘  │
   │                                                             │
   └─────────────────────────────────────────────────────────────┘

Traffic flows:
   - Internet → EIC → EC2 (SSH)
   - EC2 outbound → NAT → IGW → Internet (for updates, git clone)
   - EC2 app (port 8080) → tunneled via EIC to your local machine
   - EC2 app → RDS (port 5432) allowed by security group rule
   - No direct internet access to EC2 (no public IP)





