#!/bin/bash
# ======================================================
# EC2 Control Script - Start or Stop instances
# Usage:
#   ./ec2-control.sh start
#   ./ec2-control.sh stop
# ======================================================

# Set region
REGION="us-east-1"

# List your instance IDs here (space-separated)
INSTANCE_IDS=("i-04a937c3df6098af7" "i-0aa1dd11ddc89cbda" "i-0f57c04191340f256")

# Validate input
ACTION=$1

if [[ -z "$ACTION" ]]; then
  echo "❌ Usage: $0 [start|stop|status]"
  exit 1
fi

case "$ACTION" in
  start)
    echo "🚀 Starting EC2 instances in region ${REGION}..."
    aws ec2 start-instances --instance-ids "${INSTANCE_IDS[@]}" --region "$REGION"
    aws ec2 wait instance-running --instance-ids "${INSTANCE_IDS[@]}" --region "$REGION"
    echo "✅ Instances started successfully."
    ;;
  
  stop)
    echo "🛑 Stopping EC2 instances in region ${REGION}..."
    aws ec2 stop-instances --instance-ids "${INSTANCE_IDS[@]}" --region "$REGION"
    aws ec2 wait instance-stopped --instance-ids "${INSTANCE_IDS[@]}" --region "$REGION"
    echo "✅ Instances stopped successfully."
    ;;
  
  status)
    echo "🔍 Checking status of EC2 instances in region ${REGION}..."
    aws ec2 describe-instances \
      --instance-ids "${INSTANCE_IDS[@]}" \
      --region "$REGION" \
      --query "Reservations[].Instances[].{ID:InstanceId,State:State.Name,Name:Tags[?Key=='Name']|[0].Value}" \
      --output table
    ;;
  
  *)
    echo "❌ Invalid action. Use start, stop, or status."
    exit 1
    ;;
esac
