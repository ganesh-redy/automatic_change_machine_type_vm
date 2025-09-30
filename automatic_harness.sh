#!/bin/bash


# Get current time in 12-hour format with AM/PM
current_time=$(date +"%I:%M %P")

# Extract time and AM/PM
time_part=$(echo "$current_time" | cut -d' ' -f1)
ampm=$(echo "$current_time" | cut -d' ' -f2)

# Read the current machine state from a file
STATE_FILE="/root/machine_state"
if [[ -f "$STATE_FILE" ]]; then
    machine=$(cat "$STATE_FILE")
else
    machine=""
fi

echo "Current time: $current_time"
echo "Current machine state: $machine"

# Convert time to minutes since midnight for easier comparison
hours=$(date +"%H")
minutes=$(date +"%M")

# check if the time is between 10:30am to 10:45pm then vm must be in e2-micro
if [[ "$hours" -eq 12 && "$minutes" -le 15 && "$machine" != "medium" ]]; then
        machine="medium"
        echo "medium" > "$STATE_FILE"
        curl -X POST -H 'content-type: application/json' --url 'https://app.harness.io/gateway/pipeline/api/webhook/custom/7fc_ITmqTq696X3Xt7WcxQ/v3?accountIdentifier=ucHySz2jQKKWQweZdXyCog&orgIdentifier=default&projectIdentifier=SFTY_Training&pipelineIdentifier=IACMmachinetypeganesh&triggerIdentifier=trigger1' -d '{"machine": "e2-medium","choice":"apply"}'
elif [[ "$hours" -eq 12 && "$minutes" -ge 18 && "$minutes" -le 25 && "$machine" != "micro" ]]; then
        machine="micro"
        echo "micro" > "$STATE_FILE"
        curl -X POST -H 'content-type: application/json' --url 'https://app.harness.io/gateway/pipeline/api/webhook/custom/7fc_ITmqTq696X3Xt7WcxQ/v3?accountIdentifier=ucHySz2jQKKWQweZdXyCog&orgIdentifier=default&projectIdentifier=SFTY_Training&pipelineIdentifier=IACMmachinetypeganesh&triggerIdentifier=trigger1' -d '{"machine": "e2-micro","choice":"apply"}'
elif [[ $hours -eq 12 && "$minutes" -ge 30 && $machine != "small" ]]; then
        machine="small"
        echo "small" > "$STATE_FILE"
        curl -X POST -H 'content-type: application/json' --url 'https://app.harness.io/gateway/pipeline/api/webhook/custom/7fc_ITmqTq696X3Xt7WcxQ/v3?accountIdentifier=ucHySz2jQKKWQweZdXyCog&orgIdentifier=default&projectIdentifier=SFTY_Training&pipelineIdentifier=IACMmachinetypeganesh&triggerIdentifier=trigger1' -d '{"machine": "e2-small","choice":"apply"}'
fi
~                     
