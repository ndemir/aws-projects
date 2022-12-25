# Project 1

## Compile the webapp
```
cd project1/webapp
npm install
npm run build
```

## Run the terraform code 

NOTE: Do not forget to setup your env variables for AWS credentials before running terraform.

```
cd project1/terraform
terraform init
terraform apply
```

During the process, certificate generation phase will fail because of the DNS confirmation problem. In this example, I am using `my-aws-project.com` and you need to change for your own domain name. After it fails, change your DNS NS records to the ones provided by AWS Route 53 and run `terraform apply` again. It will succeed.
