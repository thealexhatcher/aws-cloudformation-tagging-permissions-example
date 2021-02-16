# aws-cloudformation-tagging-permissions-example

This project is an example of how to use tags on AWS Cloudformation stacks in conjunction with IAM Policy permissions to manage access of AWS resources.

This project demonstrates the capabilities made available with this AWS announcement:
  https://aws.amazon.com/about-aws/whats-new/2019/05/announcing-tag-based-access-control-for-aws-cloudformation/

# Usage
### Assumptions 
1. You have an AWS Account 
2. You have an IAM User Account or IAM Role with permissions.
3. You have obtained AWS Access Keys and Secret Keys for your account or role

### Setup 
This project uses a vscode devcontainer to store development-time configuration defined in a Dockerfile. This includes AWS CLI installation running on the latest version of AmazonLinux.


### Run-Time
1. Create an IAM user with permissions to 
```bash

```

2. [Obtain AWS access keys and secret keys](https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#access-keys-and-secret-access-keys)
3. [Create a new AWS CLI profile](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html#cli-configure-quickstart-profiles)

4. Create a resource stack using 
```bash
make create-stack
```

make update stack


### Clean Up

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.