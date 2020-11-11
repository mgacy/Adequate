#!/bin/bash
#check if env-vars.sh exists
if [ -f ./env-vars.sh ]
then
source ./env-vars.sh
fi
#no `else` case needed if the CI works as expected
printenv
sourcery --sources . --templates ./templates/AppSecrets.stencil --output ./Adequate/Application --args identity_pool_id=$IDENTITY_POOL_ID,platform_application_arn=$PLATFORM_APPLICATION_ARN,platform_application_arn_prod=$PLATFORM_APPLICATION_ARN_PROD,topic_arn=$TOPIC_ARN,logger_app_id=$LOGGER_APP_ID,logger_app_secret=$LOGGER_APP_SECRET,logger_encryption_key=$LOGGER_ENCRYPTION_KEY

