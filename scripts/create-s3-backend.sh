#!/bin/bash

# Parse command line arguments
while getopts "b:r:t:" opt; do
    case $opt in
        b) BUCKET_NAME="$OPTARG"
        ;;
        r) REGION="$OPTARG"
        ;;
        t) TABLE_NAME="$OPTARG"
        ;;
        \?) echo "Invalid option -$OPTARG" >&2
        ;;
    esac
done

# Set default values if not provided
if [ -z "$BUCKET_NAME" ]; then
    # Bucket names must be unique across all existing bucket names in Amazon S3.
    BUCKET_NAME="my-bucket-$(uuidgen | tr '[:upper:]' '[:lower:]')"
fi

if [ -z "$REGION" ]; then
    REGION="us-east-1"
fi

if [ -z "$TABLE_NAME" ]; then
    TABLE_NAME="$BUCKET_NAME-tfstate-lock"
fi

# Creates a bucket in Amazon S3 to store the Terraform state file
aws s3api create-bucket \
    --bucket "$BUCKET_NAME" \
    --region "$REGION" \
    --create-bucket-configuration LocationConstraint="$REGION"

# Creates a DynamoDB table to store the Terraform state lock
aws dynamodb create-table \
        --table-name "$TABLE_NAME" \
        --attribute-definitions AttributeName=LockID,AttributeType=S \
        --key-schema AttributeName=LockID,KeyType=HASH \
        --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 \
        --region "$REGION"
§