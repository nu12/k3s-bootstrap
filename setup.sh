#!/bin/bash

echo "One-time setup script will help you configure the settings of the repository to run the pipelines."

echo "Logging in into the Azure account..."

az login --use-device-code --output none

tenant=`az account show --query "tenantId"`
subscription=`az account show --query "id"`

echo "Creating service principal..."
az ad sp create-for-rbac --name bootstrap \
    --role Contributor \
    --scopes /subscriptions/$(echo $subscription | tr -d '"' ) \
    --years 99 > cred

client_id=`cat cred | jq ".appId"`
client_secret=`cat cred | jq ".password"`
rm cred

echo "Creating resource group..."
az group create --location canadaeast --name bootstrap --output none

echo "Creating storage account..."
uuid=`uuidgen | tr -d '-' | cut -b 1-20`
az storage account create --name $uuid --resource-group bootstrap --output none

echo "Creating storage container..."
az storage container create --name tfstates --account-name $uuid --output none

echo "Loggin out..."
az logout

echo "Done. Please add the following secrets into the repo settings:"
echo "ARM_CLIENT_ID=$client_id"
echo "ARM_CLIENT_SECRET=$client_secret"
echo "ARM_TENANT_ID=$tenant"
echo "ARM_SUBSCRIPTION_ID=$subscription"
echo "STORAGE_ACCOUNT_NAME=$uuid"