cluster_name = ""
floating_ip_pool = ""
external_network_id = ""

num_public_agents = "1"
num_private_agents = "1"
num_masters = "1"

bootstrap_image = "CentOS 7.6-docker"
master_image = "CentOS 7.6-docker"
public_agent_image = "CentOS 7.6-docker"
private_agent_image = "CentOS 7.6-docker"

bootstrap_flavor_name = ""
masters_flavor_name = ""
private_agents_flavor_name = ""
public_agents_flavor_name = ""

ssh_public_key_file = "~/.ssh/id_rsa.pub"

bootstrap_os_user = "centos"
masters_os_user = "centos"
private_agents_os_user = "centos"
public_agents_os_user = "centos"

dcos_version = "1.12.3"
dcos_variant = "open"
