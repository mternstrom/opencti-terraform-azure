#!/bin/bash

# Declare variables for VMs and resource groups
declare -A vms=(
  ["rty-opencti-vm-dev-opencti"]="rty-mathias-rg-dev-01"
  ["rty-opencti-vm-dev-elasticsearch01"]="rty-mathias-rg-dev-02"
  ["rty-opencti-vm-dev-elasticsearch02"]="rty-mathias-rg-dev-02"
  ["rty-opencti-vm-dev-elasticsearch03"]="rty-mathias-rg-dev-02"
  ["rty-opencti-vm-dev-elasticsearch04"]="rty-mathias-rg-dev-02"
  ["rty-opencti-vm-dev-kibana"]="rty-mathias-rg-dev-02"
  ["rty-opencti-vm-dev-logstash"]="rty-mathias-rg-dev-02"
)

# Get IP addresses for VMs
for vm in "${!vms[@]}"; do
  resource_group="${vms[$vm]}"
  public_ip=$(az vm show -d -g "$resource_group" -n "$vm" --query publicIps -o tsv)
  private_ip=$(az vm show -d -g "$resource_group" -n "$vm" --query privateIps -o tsv)
  echo "Public IP for $vm in $resource_group: $public_ip"
  echo "Private IP for $vm in $resource_group: $private_ip"
done

# Get Public IP address for Application Gateway
appgw_resource_group="rty-mathias-rg-appgw-dev"
appgw_name="rty-opencti-appgw-dev"
public_ip_name="rty-opencti-appgw-public-ip-dev"
public_ip_id=$(az network application-gateway show -g "$appgw_resource_group" -n "$appgw_name" --query "frontendIpConfigurations[0].publicIpAddress.id" -o tsv)

# Get the Public IP address associated with the Application Gateway
public_ip=$(az network public-ip show -g "$appgw_resource_group" -n "$public_ip_name" --query "ipAddress" -o tsv)
echo "Public IP for $appgw_name in $appgw_resource_group: $public_ip"

