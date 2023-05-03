#!/bin/bash

# Set parameters
STACK_NAME="my-flask-app-stack"
TEMPLATE_FILE="my-flask-app.yaml"
REGION='eu-west-1'

echo "Starting creation of the stack..."
# Create CloudFormation stack
aws cloudformation create-stack \
  --stack-name $STACK_NAME \
  --template-body file://$TEMPLATE_FILE \
  --region $REGION \

# Wait for stack to complete
echo "Waiting for stack to be created..."
aws cloudformation wait stack-create-complete \
  --stack-name $STACK_NAME \
  --region $REGION
echo "Stack created!"

# Get public IP address of EC2 instance
INSTANCE_ID=$(aws cloudformation describe-stack-resources \
    --stack-name $STACK_NAME \
    --query 'StackResources[?LogicalResourceId==`EC2Instance`].PhysicalResourceId' \
    --output text)

PUBLIC_IP=$(aws ec2 describe-instances \
    --instance-ids $INSTANCE_ID \
    --query 'Reservations[0].Instances[0].PublicIpAddress' \
    --output text)

echo "Flask web server deployed successfully!"
echo "The URL for the web server is http://${PUBLIC_IP}:5000"
