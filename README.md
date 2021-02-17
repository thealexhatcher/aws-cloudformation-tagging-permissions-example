# aws-cloudformation-tagging-permissions-example
This project demonstrates the capabilities made available with this [AWS announcement](https://aws.amazon.com/about-aws/whats-new/2019/05/announcing-tag-based-access-control-for-aws-cloudformation/). It is an example of how to use tags on AWS Cloudformation stacks in conjunction with IAM Policy permissions to manage AWS resource creation.

# Usage

This project uses a vscode devcontainer environment. More information on setup can be found [here](https://code.visualstudio.com/docs/remote/containers).

### Assumptions 

1. You have an AWS Account 
2. You have an IAM User Account or Role with permissions to create the required IAM User Account and IAM Role for AWS Cloudformation actions.
3. You have obtained [AWS Access Keys and Secret Keys](https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#access-keys-and-secret-access-keys) for your IAM account or role
4. You are running this is example in the vscode devcontainer environment
5. You have [configured the aws cli](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html#cli-configure-quickstart-config) to use your AWS Access Key and Secret Key.

#### 1. Setup 

a. Create our IAM Users Accounts
```bash
create-account1-stack
create-account2-stack 
```

b. Set Configuration for AWS CLI profiles
Get AWS Access and Secret keys for each Account1 and Account2 and configure aws cli profiles for each.
```bash
make set-account1-configuration
make set-account1-configuration
```

c. Get Cloudformation Role Arn values for user accounts 
```bash
USER_ACCOUNT1_ROLE=$(make get-account1-cloudformation-role)
USER_ACCOUNT2_ROLE=$(make get-account2-cloudformation-role)
```

#### 2. Execution

Account1 that we created is only able to create and modifty stacks that are tagged with Environment=USER_ENVIRONMENT_1 and can only pass its associated role to cloudformation for creating resournces. Account2 can only create and modify stacks that are tagged with Environment=USER_ENVIRONMENT_2 and can also only pass its associated role. For Account1 and Account2, resources can only be created through Cloudformation. Provisioning User Accounts or ( or federated roles ) in this way  allows for a scheme to partition 

a. Create a Cloudformation Stack using Account1. This should succeed.
```bash
aws cloudformation create-stack \
  --stack-name test-useraccount2 \
  --template-body file://cfn_stack_1.yaml \
  --capabilities CAPABILITY_NAMED_IAM CAPABILITY_AUTO_EXPAND \
  --tags Key=Environment,Value=USER_ENVIRONMENT_1 \
  --role-arn $USER_ACCOUNT1_ROLE \
  --profile user-account1-profile
```

b. Update a Cloudformation Stack created by Account1 with the Account1 User and Role. This should succeed.
```bash
aws cloudformation update-stack \
  --stack-name test-stack1 \
  --template-body file://cfn_stack_2.yaml \
  --capabilities CAPABILITY_NAMED_IAM CAPABILITY_AUTO_EXPAND \
  --role-arn $USER_ACCOUNT1_ROLE \
  --profile user-account1-profile
```

c. Attempt to update a Cloudformation Stack created by Account1 with the Account2 User and Role. This will fail.
```bash
aws cloudformation update-stack \
  --stack-name test-stack1 \
  --template-body file://cfn_stack_2.yaml \
  --capabilities CAPABILITY_NAMED_IAM CAPABILITY_AUTO_EXPAND \
  --role-arn $USER_ACCOUNT2_ROLE \
  --profile user-account2-profile
```

d. Attempt to delete a Cloudformation Stack created by Account1 with the Account2 User and Role. This will fail.
```bash
aws cloudformation delete-stack \
  --stack-name test-stack1 \
  --role-arn $USER_ACCOUNT2_ROLE \
  --profile user-account2-profile
```

e. Delete the Cloudformation Stack created by Account1 with the Account1 User and Role.
```bash
aws cloudformation delete-stack \
  --stack-name test-stack1 \
  --role-arn $USER_ACCOUNT1_ROLE \
  --profile user-account1-profile
```

#### 3. Cleanup 

a. Remove our IAM Users Accounts and associated roles
```bash
delete-account1-stack
delete-account2-stack 
```

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.
