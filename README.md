## How to run

First deploy on AWS using terraform:

```shell
terraform init
terraform plan
terraform apply
```

After the deployment has been finished, SSH into the AWS EC2. Start a jupyter notebook using the following command:

```shell
docker run --gpus all -p 8888:8888 anaconda
```
