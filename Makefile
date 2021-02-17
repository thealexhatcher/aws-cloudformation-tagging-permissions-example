SHELL := /bin/bash

#user account 1
create-account1-stack:
	aws cloudformation deploy \
	--stack-name test-useraccount1 \
	--template-file cfn_useraccount.yaml \
	--parameter-overrides AccountName=useraccount1 EnvironmentName=USER_ENVIRONMENT_1 \
	--no-fail-on-empty-changeset \
	--capabilities CAPABILITY_NAMED_IAM 
delete-account1-stack:
	aws cloudformation delete-stack --stack-name test-useraccount1
set-account1-configuration:
	aws configure --profile useraccount1-profile

#user account 2
create-account2-stack:
	aws cloudformation deploy \
	--stack-name test-useraccount2 \
	--template-file cfn_useraccount.yaml \
	--parameter-overrides AccountName=useraccount2 EnvironmentName=USER_ENVIRONMENT_2 \
	--no-fail-on-empty-changeset \
	--capabilities CAPABILITY_NAMED_IAM 
delete-account2-stack:
	aws cloudformation delete-stack --stack-name test-useraccount2
set-account2-configuration:
	aws configure --profile useraccount2-profile

#test
create-test-stack:
	ROLE=$$(aws cloudformation describe-stacks --stack-name test-useraccount1 --query 'Stacks[0].Outputs[?OutputKey==`CloudformationRole`].OutputValue' --output text) \
	&& aws cloudformation create-stack \
	--stack-name test-stack \
	--role-arn $$ROLE \
	--template-body file://cfn_stack_1.yaml \
	--capabilities CAPABILITY_NAMED_IAM \
	--tags Key=Environment,Value=USER_ENVIRONMENT_1 \
	--profile useraccount1-profile
	@echo "Waiting for stack to be created ..." 
	aws cloudformation wait stack-create-complete --stack-name test-stack --profile useraccount1-profile
	@echo "Stack Created."
update-test-stack:
	ROLE=$$(aws cloudformation describe-stacks --stack-name test-useraccount1 --query 'Stacks[0].Outputs[?OutputKey==`CloudformationRole`].OutputValue' --output text) \
	&& aws cloudformation update-stack \
	--stack-name test-stack \
	--role-arn $$ROLE \
	--template-body file://cfn_stack_2.yaml \
	--capabilities CAPABILITY_NAMED_IAM \
	--profile useraccount1-profile
	@echo "Waiting for stack to be updated ..."
	aws cloudformation wait stack-update-complete \
	--stack-name test-stack \
	--profile useraccount1-profile
	@echo "Stack Updated."
delete-test-stack:
	ROLE=$$(aws cloudformation describe-stacks --stack-name test-useraccount1 --query 'Stacks[0].Outputs[?OutputKey==`CloudformationRole`].OutputValue' --output text) \
	&& aws cloudformation delete-stack \
	--stack-name test-stack \
	--role-arn $$ROLE \
	--profile useraccount1-profile
	@echo "Waiting for stack to be deleted ..." 
	aws cloudformation wait stack-delete-complete \
	--stack-name test-stack \
	--profile useraccount1-profile
	@echo "Stack Deleted."
