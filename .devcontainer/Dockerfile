FROM amazonlinux
## SYSTEM SETUP
RUN yum update -y
RUN yum groupinstall "Development Tools" -y
RUN yum install -y wget sudo
## AWS CLI
RUN wget --quiet "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -O ~/awscliv2.zip \
    && unzip ~/awscliv2.zip \
    && ./aws/install \
    && aws --version \
    && rm aws/install \
    && rm ~/awscliv2.zip
## VSCODE USER Setup
RUN adduser vscode 
RUN usermod -aG wheel vscode
RUN echo '%vscode ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
USER vscode

