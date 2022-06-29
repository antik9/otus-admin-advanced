### Deploy NGINX with terraform & ansible to Ya Cloud

```bash
$ cp terraform.tfvars{.example,}
$ : # configure your vars
$ terraform init
$ terrafrom apply -auto-approve
$ : # check nginx
$ terraform destroy -auto-approve
```
