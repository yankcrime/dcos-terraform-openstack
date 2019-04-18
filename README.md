# DC/OS on OpenStack

🚨Work in progress!🚨

The Terraform code and scripts in this repository install and configure DC/OS on a 'typical' OpenStack deployment.  Typical in this case means:

* Per-tenant networking, with an external provider network that's used to provide ingress / egress Internet connectivity;
* A pool of floating IP addresses, allocated from this provider network;
* LBaaSv2 is configured and available for use.

There are a number of bugs and limitations, but infrastructure-wise and off the top of my head:

* No block storage service integration;
* No DNS ([Designate DNaaS](https://docs.openstack.org/designate/latest/) is sadly still relatively rare across OpenStack deployments);
* No SSL.

You will also need a compatible operating system image to use, in this case CentOS 7.6, ideally with Docker pre-installed.  You could add DC/OS pre-requisites such as this via cloud-init at time of bootstrap though if needs be.

No guarantees are made about the utility of the resulting DC/OS deployment.

## Getting started

This repo relies [on another](https://github.com/yankcrime/dcos-terraform-infrastructure-openstack) to handle creating the virtual infrastructure for us, so we need to clone both of these:

``` shell
git clone https://github.com/yankcrime/dcos-terraform-openstack.git
git clone https://github.com/yankcrime/dcos-terraform-infrastructure-openstack.git
```

And then initialise our installation:

``` shell
$ cd dcos-terraform-openstack
$ terraform init
Initializing modules...
- module.dcos-infrastructure
  Getting source "../dcos-terraform-infrastructure-openstack"
- module.dcos-install
  Found version 0.1.1 of dcos-terraform/dcos-install-remote-exec/null on registry.terraform.io
  Getting source "dcos-terraform/dcos-install-remote-exec/null"
  
[..]

Terraform has been successfully initialized!
  
```

Prior to deployment, we need to configure some cloud-specific variables which will be unique to each OpenStack installation.  Create a file called `terraform.tfvars` in the `dcos-terraform-openstack` directory and populate it with something such as the following:

``` hcl
cluster_name = "test"
floating_ip_pool = "internet"
external_network_id = "c72d2f60-9497-48b6-ab4d-005995aa4b21"

num_public_agents = "1"
num_private_agents = "2"
num_masters = "1"

bootstrap_image = "CentOS 7.6-docker"
master_image = "CentOS 7.6-docker"
public_agent_image = "CentOS 7.6-docker"
private_agent_image = "CentOS 7.6-docker"

ssh_public_key_file = "~/.ssh/id_rsa.pub"

bootstrap_os_user = "centos"
masters_os_user = "centos"
private_agents_os_user = "centos"
public_agents_os_user = "centos"

dcos_version = "1.12.3"
dcos_variant = "open"
```

Then run `terraform plan -out=plan.out -var-file=terraform.tfvars`, again from in the `dcos-terraform-openstack` folder:

``` shell
Refreshing Terraform state in-memory prior to plan...

[..]

Plan: 79 to add, 0 to change, 0 to destroy.
```

And then to deploy:

``` shell
$ terraform apply "plan.out"
```

After a few minutes and a successful run (🤞!) then Terraform should output the IP address of various resources, you'll then be able to point your browser to the IP address of the masters' load balancer in order to login.


