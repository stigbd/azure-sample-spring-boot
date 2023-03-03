export AZURE_TENANT_ID=$(terraform -chdir=./terraform output -raw AZURE_TENANT_ID)

# set identifier_uris
echo "----------update identifier-uris start----------"
az ad app update --id $AZURE_CLIENT_ID --identifier-uris api://$AZURE_CLIENT_ID
echo "----------update identifier-uris completed----------"

export AZURE_CLIENT_ID=$(terraform -chdir=./terraform output -raw AZURE_CLIENT_ID)
export SERVICE_PRINCIPAL=$(terraform -chdir=./terraform output -raw SERVICE_PRINCIPAL)
export SERVICE_PRINCIPAL_PASSWORD=$(terraform -chdir=./terraform output -raw SERVICE_PRINCIPAL_PASSWORD)
export ADMIN_NAME=$(terraform -chdir=./terraform output -raw ADMIN_NAME)
export ADMIN_PASSWORD=$(terraform -chdir=./terraform output -raw ADMIN_PASSWORD)
export USER_NAME=$(terraform -chdir=./terraform output -raw USER_NAME)
export USER_PASSWORD=$(terraform -chdir=./terraform output -raw USER_PASSWORD)

echo AZURE_CLIENT_ID=${AZURE_CLIENT_ID}
echo SERVICE_PRINCIPAL_PASSWORD=${SERVICE_PRINCIPAL_PASSWORD}
echo SERVICE_PRINCIPAL=${SERVICE_PRINCIPAL}
echo AZURE_TENANT_ID=${AZURE_TENANT_ID}


echo "--------created admin user--------"
echo USER_NAME=${ADMIN_NAME}
echo USER_PASSWORD=${ADMIN_PASSWORD}

echo "--------created user--------"
echo USER_NAME=${USER_NAME}
echo USER_PASSWORD=${USER_PASSWORD}
