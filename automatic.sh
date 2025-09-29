#!/bin/bash

# Change to Terraform directory
cd /root/terraform1

# Get current time in 12-hour format with AM/PM
current_time=$(date +"%I:%M %P")

# Extract time and AM/PM
time_part=$(echo "$current_time" | cut -d' ' -f1)
ampm=$(echo "$current_time" | cut -d' ' -f1)

#machine_type
#cat /root/terraform1/terraform.tfstate | grep -o e2-.* | cut -d '"' -f1

machine=$(cat terraform.tfstate | jq -r '.resources[] | select(.type=="google_compute_instance" and .name=="insta1") | .instances[0].attributes.machine_type')

echo "Current time: $current_time"

# Convert time to minutes since midnight for easier comparison
hours=$(date +"%H")
minutes=$(date +"%M")
# check if the time is between 3:00pm to 4:00pm then vm must be in e2-micro
if [[ "$hours" -ge 15 && "$hours" -le 16 && "${#machine}" -ne 0 ]]
then
        terraform init
        terraform plan -var "machine_type=e2-micro"
        terraform apply -var "machine_type=e2-micro" -auto-approve
elif [[ "$hours" -lt 15 || "$hours" -gt 16 ]] && [[ "${#machine}" -ne 0 ]]
then  
        terraform init
        terraform plan -var "machine_type=e2-small" 
        terraform apply -var "machine_type=e2-small" -auto-approve
else
        terraform init
        terraform plan -var "machine_type=e2-small"
        terraform apply -var "machine_type=e2-small" -auto-approve
fi
