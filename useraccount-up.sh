set -e
aws cloudformation deploy \
    --stack-name "test-useraccount" \
    --template-file cfn_useraccount.yaml \
    --output table \
    --no-fail-on-empty-changeset \
    --capabilities CAPABILITY_NAMED_IAM CAPABILITY_AUTO_EXPAND 