# K3s-bootstrap

This repo delivers automation for the creation of a K3s Kubernetes cluster. Creating a cluster with the `start` pipeline ensures a Kubernetes cluster is ready to rock within X minutes, while the `stop` pipeline can be used to teardown everything and keep costs down. Need a Kubernetes cluster quick and use ? Let's roll!

## Pre requisites

An Azure account with a "Pay as you go" subscription.

A SSH key pair.

Command line tools:
* az cli
* jq

## One-time setup

To automate the process, run `./setup.sh` and configure the secrets in the repo as specified in the code output.

In addition, also provide a SSH public key to run the configuration after resources creation.

### Configuring repo secrets

List of needed secrets:
|SECRET|VALUE|
|------|-----|
|ARM_CLIENT_ID| Service Principal's Client Id|
|ARM_CLIENT_SECRET|Service Principal's Secret value|
|ARM_TENANT_ID| Tenant Id |
|ARM_SUBSCRIPTION_ID| Subscription Id|
|STORAGE_ACCOUNT_NAME| Storage account name for the tfstate file|
|SSH_PUBLIC| Public SSH key for the configuration and later access to the VM|
|SSH_PRIVATE| Private SSH key for the configuration|

## Usage

## Contributing

Desired features to be added:
* Add a VMSS for worker nodes
* Optionally deploy nginx, gitlab, nexus repository, elastic stack in the cluster
* Add parameter values to the script such as location, VM sizes, etc.

PRs are welcomed.