set -e
ROLE="arn:aws:iam::838211705424:role/test-useraccount-CloudformationRole-1MUSCFTPNFRWW"
STACKNAME="test-stack"
FILE1="cfn_stack_1.yaml"
FILE2="cfn_stack_2.yaml"
ENVIRONMENT_TAG=dev
echo "Create Stack ..." 
if [[ -z "$(aws cloudformation describe-stacks --query 'Stacks[?StackName==`'$STACKNAME'`].StackName' --output text)" ]] ; then
    aws cloudformation create-stack \
        --stack-name $STACKNAME \
        --output table \
        --role-arn $ROLE \
        --template-body "file://$FILE1" \
        --capabilities CAPABILITY_NAMED_IAM CAPABILITY_AUTO_EXPAND \
        --tags Key=Environment,Value=$ENVIRONMENT_TAG
    aws cloudformation wait stack-create-complete \
        --stack-name $STACKNAME
fi
echo "Update Stack ..."
aws cloudformation update-stack \
    --stack-name $STACKNAME \
    --output table \
    --role-arn $ROLE \
    --template-body "file://$FILE2" \
    --capabilities CAPABILITY_NAMED_IAM CAPABILITY_AUTO_EXPAND
echo "Waiting for stack to be updated ..."
aws cloudformation wait stack-update-complete \
    --stack-name $STACKNAME
echo "Deleting Stack ..."
aws cloudformation delete-stack \
    --stack-name $STACKNAME \
    --role-arn $ROLE \
    --output table
echo "Waiting for stack to be deleted ..."
aws cloudformation wait stack-delete-complete \
    --stack-name $STACKNAME
echo "Done!"