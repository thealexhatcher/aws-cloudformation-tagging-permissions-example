# aws-cloudformation-tagging-permissions-example
This project demonstrates the capabilities made available with this [AWS announcement](https://aws.amazon.com/about-aws/whats-new/2019/05/announcing-tag-based-access-control-for-aws-cloudformation/). It is an example of how to use tags on AWS Cloudformation stacks in conjunction with IAM Policy permissions to manage AWS resource creation.



# Usage

This project uses a vscode devcontainer environment. More information on setup can be found [here](https://code.visualstudio.com/docs/remote/containers).

### Assumptions 
1. You have an AWS Account 
2. You have an IAM User Account or Role with permissions to create the required IAM User Account and IAM Role for AWS Cloudformation actions.
3. You have obtained [AWS Access Keys and Secret Keys]([Obtain AWS access keys and secret keys](https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#access-keys-and-secret-access-keys) for your account or role
4. You are running this is example in the vscode devcontainer environment
5. You have [configured the aws cli](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html#cli-configure-quickstart-config) to use your AWS Access Key and Secret Key.

### Run-Time
##### 1. Setup 
a. Create our IAM Users Accounts
```bash
create-account1-stack
create-account2-stack 
```
b. Set Configuration for AWS CLI profiles
```bash
make set-account1-configuration
make set-account1-configuration
```

###### 2. Tests
2a. Create a Cloudformation Stack using Account1. This should succeed.
```bash
    aws cloudformation create-stack \
	--stack-name test-stack1 \
	--template-body file://cfn_stack_1.yaml \
	--capabilities CAPABILITY_NAMED_IAM CAPABILITY_AUTO_EXPAND \
	--tags Key=Environment,Value=USER_ENVIRONMENT_1 \
	--role-arn $USER_ACCOUNT1_ROLE \
	--profile user-account1-profile
```

2b. Update a Cloudformation Stack created by Account1 with the Account1 User and Role. This should succeed.
```bash
    aws cloudformation update-stack \
	--stack-name test-stack1 \
	--template-body file://cfn_stack_2.yaml \
	--capabilities CAPABILITY_NAMED_IAM CAPABILITY_AUTO_EXPAND \
	--role-arn $USER_ACCOUNT1_ROLE \
	--profile user-account1-profile
```

2c. Attempt to update a Cloudformation Stack created by Account1 with the Account2 User and Role. This will fail.
```bash
    aws cloudformation update-stack \
	--stack-name test-stack1 \
	--template-body file://cfn_stack_2.yaml \
	--capabilities CAPABILITY_NAMED_IAM CAPABILITY_AUTO_EXPAND \
	--role-arn $USER_ACCOUNT2_ROLE \
	--profile user-account2-profile
```

2d. Attempt to delete a Cloudformation Stack created by Account1 with the Account2 User and Role. This will fail.
```bash
	aws cloudformation delete-stack \
	--stack-name test-stack1 \
	--role-arn $USER_ACCOUNT2_ROLE \
    --profile user-account2-profile
```

2e. Delete the Cloudformation Stack created by Account1 with the Account1 User and Role.
```bash
    aws cloudformation delete-stack \
    --stack-name test-stack1 \
    --role-arn $USER_ACCOUNT1_ROLE \
    --profile user-account1-profile
```

### Clean Up

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.
