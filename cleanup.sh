#!/bin/bash
BUCKET_NAME="breach-tracker-s3"

echo "Emptying and deleting S3 bucket: $BUCKET_NAME..."
aws s3 rm "s3://$BUCKET_NAME" --recursive && aws s3 rb "s3://$BUCKET_NAME"

if [ $? -eq 0 ]; then
    echo "✅ Bucket $BUCKET_NAME successfully deleted."
else
    echo "Failed to delete bucket $BUCKET_NAME"
fi

cd terraform

terraform destroy -var-file=myvars.tfvars -auto-approve

aws ecr delete-repository --repository-name "breach-tracker" --force
