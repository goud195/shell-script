#!/bin/bash

# AWS region
REGION="us-east-1"

# Instance IDs
INSTANCES=("i-0abc123456789def0" "i-0123456789abcdef1" "i-0fedcba9876543210")

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
    ;;
  stop)
    echo "Stopping EC2 instances..."
    aws ec2 stop-instances --instance-ids "${INSTANCES[@]}" --region "$REGION"
    aws ec2 wait instance-stopped --instance-ids "${INSTANCES[@]}" --region "$REGION"
    ;;
  status)
    echo "Checking instance status..."
    aws ec2 describe-instances \
      --instance-ids "${INSTANCES[@]}" \
      --region "$REGION" \
      --query "Reservations[].Instances[].{ID:InstanceId,State:State.Name,Name:Tags[?Key=='Name']|[0].Value}" \
      --output table
    ;;
esac
