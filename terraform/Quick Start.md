## Deploying Amazon EC2 Auto Scaling group and load balancer + RDS PostgreSQL (Terraform)

**Objective**: Create a highly available, Scalable, Secure VPC with public, cost-effective, application, and database
tiers across 3 Availability Zones. Connectivity Two-tier application of backend App tier and RDS database tier each in
separate private subnet.

**Specification**: A public CloudFront in front of a Spring Boot application tier (EC2, private subnets), backed by an
isolated RDS PostgreSQL Multi-AZ database, all across 3 Availability Zones (`us-east-1a`, `us-east-1b`, `us-east-1c`).
Deploying a few EC2 Auto Scaling group in a private subnet and attach them to an application load balancer in a public
subnet.

### Deploy

```bash
$ cd alb-autoscale-ec2/terraform
$ terraform init
$ terraform fmt -recursive
$ terraform validate
$ terraform plan -var-file="terraform.tfvars" -no-color -out=TFplan.JSON
$ terraform apply -var-file="terraform.tfvars" -auto-approve
```

### Cleanup

***

To destroy all resources, run ```terraform destroy -var-file="terraform.tfvars" -auto-approve```
