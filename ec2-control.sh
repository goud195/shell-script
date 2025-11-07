#!/bin/bash

# AWS region
REGION="us-east-1"

# Instance IDs
INSTANCES=("i-0aa1dd11ddc89cbda" "i-0f57c04191340f256")

# Action argument
ACTION=$1

# Ensure argument is provided
if [[ ! "$ACTION" =~ ^(start|stop|status)$ ]]; then
  echo "Usage: $0 [start|stop|status]"
  exit 1
fi

# Perform action
case $ACTION in
  start)
    echo "Starting EC2 instances..."
    aws ec2 start-instances --instance-ids "${INSTANCES[@]}" --region "$REGION"
    aws ec2 wait instance-running --instance-ids "${INSTANCES[@]}" --region "$REGION"
    echo "Instances started successfully."
    ;;
  stop)
    echo "Stopping EC2 instances..."
    aws ec2 stop-instances --instance-ids "${INSTANCES[@]}" --region "$REGION"
    aws ec2 wait instance-stopped --instance-ids "${INSTANCES[@]}" --region "$REGION"
    echo "Instances stopped successfully."
    ;;
  status)
    echo "Checking instance status..."
    aws ec2 describe-instances \
      --instance-ids "${INSTANCES[@]}" \
      --region "$REGION" \
      --query "Reservations[].Instances[].{ID:InstanceId,State:State.Name,Name:Tags[?Key=='Name']|[0].Value}" \
      --output table
    ;;
  *)
    echo " Invalid action. Use start, stop, or status."
    exit 1
esac
