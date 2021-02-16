SHELL := /bin/bash
ENVIRONMENT_TAG=dev

#account and role stack commands
create-account-stack:
	aws cloudformation deploy \
	--stack-name test-useraccount \
	--template-file cfn_useraccount.yaml \
	--parameter-overrides EnvironmentName=$(ENVIRONMENT_TAG) \
	--no-fail-on-empty-changeset \
	--capabilities CAPABILITY_NAMED_IAM CAPABILITY_AUTO_EXPAND 
destroy-account-stack:
	aws cloudformation delete-stack --stack-name test-useraccount

#resource stack commands
create-stack:
	$(eval ROLE=$(aws cloudformation describe-stacks --stack-name test-useraccount --query 'Stacks[0].Outputs[?OutputKey==`CloudformationRole`].OutputValue' --output text))
	aws cloudformation create-stack \
	--stack-name test-stack \
	--role-arn $(ROLE) \
	--template-body file://cfn_stack_1.yaml \
	--capabilities CAPABILITY_NAMED_IAM CAPABILITY_AUTO_EXPAND \
	--tags Key=Environment,Value=$(ENVIRONMENT_TAG)
	@echo "Waiting for stack to be created ..." 
	aws cloudformation wait stack-create-complete --stack-name test-stack
	@echo "Stack Created."
update-stack:
	$(eval ROLE=$(aws cloudformation describe-stacks --stack-name test-useraccount --query 'Stacks[0].Outputs[?OutputKey==`CloudformationRole`].OutputValue' --output text))
	aws cloudformation update-stack \
	--stack-name test-stack \
	--role-arn $(ROLE) \
	--template-body file://cfn_stack_2.yaml \
	--capabilities CAPABILITY_NAMED_IAM CAPABILITY_AUTO_EXPAND \
	@echo "Waiting for stack to be updated ..."
	aws cloudformation wait stack-update-complete --stack-name test-stack
	@echo "Stack Updated."
delete-stack:
	$(eval ROLE=$(aws cloudformation describe-stacks --stack-name test-useraccount --query 'Stacks[0].Outputs[?OutputKey==`CloudformationRole`].OutputValue' --output text))
	aws cloudformation delete-stack --stack-name test-stack --role-arn $(ROLE)
	@echo "Waiting for stack to be deleted ..." 
	aws cloudformation wait stack-delete-complete --stack-name test-stack
	@echo "Stack Deleted."

#example
run-example: create-stack update-stack delete-stack
