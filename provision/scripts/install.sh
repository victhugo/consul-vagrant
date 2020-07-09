#!/usr/bin/env bash
LOCAL_CONSUL_BINARY=$1
LOCAL_VAULT_BINARY=$2
LOCAL_NOMAD_BINARY=$3

echo "LOCAL_CONSUL_BINARY=$LOCAL_CONSUL_BINARY"
echo "LOCAL_NOMAD_BINARY=$LOCAL_NOMAD_BINARY"
echo "LOCAL_VAULT_BINARY=$LOCAL_VAULT_BINARY"


curl -sL -sL 'https://getenvoy.io/gpg' | sudo apt-key add -
sudo add-apt-repository \
"deb [arch=amd64] https://dl.bintray.com/tetrate/getenvoy-deb \
$(lsb_release -cs) \
stable"

sudo apt-get update
sudo apt-get install -y \
    getenvoy-envoy \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common \
    unzip \
    jq

# Install Keys
curl -sL -s https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

sudo apt-get update
sudo apt-get install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io

cat >> ~/.bashrc <<"END"
# Coloring of hostname in prompt to keep track of what's what in demos, blue provides a little emphasis but not too much like red
NORMAL="\[\e[0m\]"
BOLD="\[\e[1m\]"
DARKGRAY="\[\e[90m\]"
BLUE="\[\e[34m\]"
PS1="$DARKGRAY\u@$BOLD$BLUE\h$DARKGRAY:\w\$ $NORMAL"
END

# if [ "$LOCAL_CONSUL_BINARY" != "true"]; then
# echo "############## Downloading consul binary ########################"
# Download consul
export CONSUL_VERSION=1.7.3
curl -sL https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip -o consul.zip

# Install consul
sudo unzip consul.zip
sudo chmod +x consul
sudo mv consul /usr/bin/consul
# else
# echo "############## Copying consul binary ########################"
#     cp /vagrant/bin/consul .
#     sudo chmod +x consul
#     sudo mv consul /usr/bin/consul
# fi

# Download consul-template
export CONSUL_TEMPLATE_VERSION=0.25.0
curl -sL https://releases.hashicorp.com/consul-template/${CONSUL_TEMPLATE_VERSION}/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip -o consul-template.zip

# Install consul-template
sudo unzip consul-template.zip
sudo chmod +x consul-template
sudo mv consul-template /usr/bin/consul-template

export CONSUL_REPLICATE_VERSION=0.4.0
curl -sL https://releases.hashicorp.com/consul-replicate/${CONSUL_REPLICATE_VERSION}/consul-replicate_${CONSUL_REPLICATE_VERSION}_linux_amd64.zip -o consul-replicate.zip
sudo unzip consul-replicate.zip
sudo chmod +x consul-replicate
sudo mv consul-replicate /usr/bin/consul-replicate