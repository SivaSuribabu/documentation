#!/bin/bash
#Author: P Siva Suribabu
#Date: 2023-09-15
#Version: 1.0
#Description: This script lists all active AWS services in the configured AWS account and region.
# It requires AWS CLI to be installed and configured with appropriate permissions.
# This sceipt supports following resource types: ec2, s3, rds, lambda, dynamodb, iam, cloudformation, sns, sqs, eks, ecs, cloudwatch, elb, route53, vpc, cloudfront, waf, athena, glue, redshift, kinesis, emr, efs, secretsmanager, ssm, codecommit, codedeploy, codepipeline
#usage: AWS_PROFILE=account1 ./active_aws_services_list.sh <region> <resourece_type>
#example: ./active_aws_services_list.sh us-east-1 ec2


# Check if the correct number of arguments is provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <region> <resource_type>"
    exit 1
fi

# Assign input arguments to variables
REGION=$1
RESOURCE_TYPE=$2    


# Check if the AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo "AWS CLI is not installed. Please install it and try again."
    exit 1
fi

# Check if AWS CLI is configured
if ! aws sts get-caller-identity &> /dev/null; then
    echo "AWS CLI is not configured. Please configure it and try again."
    exit 1
fi

# Function to list active resources based on resource type
list_active_resources() {
    case $RESOURCE_TYPE in
        ec2)
            aws ec2 describe-instances --region "$REGION" --query 'Reservations[].Instances[].InstanceId' --output text
            ;;
        s3)
            aws s3api list-buckets --query 'Buckets[].Name' --output text
            ;;
        rds)
            aws rds describe-db-instances --region "$REGION" --query 'DBInstances[].DBInstanceIdentifier' --output text
            ;;
        lambda)
            aws lambda list-functions --region "$REGION" --query 'Functions[].FunctionName' --output text
            ;;
        dynamodb)
            aws dynamodb list-tables --region "$REGION" --query 'TableNames[]' --output text
            ;;
        iam)
            aws iam list-users --query 'Users[].UserName' --output text
            ;;
        cloudformation)
            aws cloudformation describe-stacks --region "$REGION" --query 'Stacks[].StackName' --output text
            ;;
        sns)
            aws sns list-topics --region "$REGION" --query 'Topics[].TopicArn' --output text
            ;;
        sqs)
            aws sqs list-queues --region "$REGION" --query 'QueueUrls[]' --output text
            ;;
        eks)
            aws eks list-clusters --region "$REGION" --query 'clusters[]' --output text
            ;;
        ecs)
            aws ecs list-clusters --region "$REGION" --query 'clusterArns[]' --output text
            ;;
        cloudwatch)
            aws cloudwatch list-metrics --region "$REGION" --query 'Metrics[].MetricName' --output text
            ;;
        elb)
            aws elb describe-load-balancers --region "$REGION" --query 'LoadBalancerDescriptions[].LoadBalancerName' --output text
            ;;
        route53)
            aws route53 list-hosted-zones --query 'HostedZones[].Name' --output text
            ;;
        vpc)
            aws ec2 describe-vpcs --region "$REGION" --query 'Vpcs[].VpcId' --output text
            ;;
        cloudfront)
            aws cloudfront list-distributions --query 'DistributionList.Items[].Id' --output text
            ;;
        waf)
            aws waf list-web-acls --region "$REGION" --query 'WebACLs[].WebACLId' --output text
            ;;
        athena)
            aws athena list-databases --region "$REGION" --query 'DatabaseList[].Name' --output text
            ;;
        glue)
            aws glue get-tables --region "$REGION" --query 'TableList[].Name' --output text
            ;;
        redshift)
            aws redshift describe-clusters --region "$REGION" --query 'Clusters[].ClusterIdentifier' --output text
            ;;
        kinesis)
            aws kinesis list-streams --region "$REGION" --query 'StreamNames[]' --output text
            ;;
        emr)
            aws emr list-clusters --region "$REGION" --query 'Clusters[].Id' --output text
            ;;
        efs)
            aws efs describe-file-systems --region "$REGION" --query 'FileSystems[].FileSystemId' --output text
            ;;
        secretsmanager)
            aws secretsmanager list-secrets --region "$REGION" --query 'SecretList[].Name' --output text
            ;;
        ssm)
            aws ssm describe-parameters --region "$REGION" --query 'Parameters[].Name' --output text
            ;;
        codecommit)
            aws codecommit list-repositories --region "$REGION" --query 'repositories[].repositoryName' --output text
            ;;
        codedeploy)
            aws deploy list-applications --region "$REGION" --query 'applications[]' --output text
            ;;
        codepipeline)
            aws codepipeline list-pipelines --region "$REGION" --query 'pipelines[].name' --output text
            ;;
        *)
            echo "Unsupported resource type: $RESOURCE_TYPE"
            exit 1
            ;;
    esac
} 

echo "##################################################################################"
# List active resources
echo "Active $RESOURCE_TYPE resources in region $REGION:"
echo "count: $(list_active_resources | wc -w)"
echo "Resources:"
echo "------------------------------------------"
list_active_resources 
echo "------------------------------------------"
echo "##################################################################################"
        
