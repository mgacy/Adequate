#!/bin/bash

# This stretches the meaning of "secret", but it lets us keep additional AWS config together
export SERVICE_REGION="XXXXXXX"
case $ENV_NAME in
	development)
		# AWS
		export PLATFORM_APPLICATION_ARN="arn:aws:sns:xx-xxxx-x:xxxxxxxxxxxx:app/APNS_SANDBOX/Adequate-Development" 
		export TOPIC_ARN="arn:aws:sns:xx-xxxx-x:xxxxxxxxxxxx:adequate-sam-dev-DealNotificationTopic-XXXXXXXXXXXXX"
		# SwiftyBeaver
        export LOGGER_APP_ID="xxxxxx"
        export LOGGER_APP_SECRET="xxxxxx"
        export LOGGER_ENCRYPTION_KEY="xxxxxx"
		;;
	staging)
		# AWS
		export PLATFORM_APPLICATION_ARN="arn:aws:sns:xx-xxxx-x:xxxxxxxxxxxx:app/APNS/Adequate-Production"
		export TOPIC_ARN="arn:aws:sns:xx-xxxx-x:xxxxxxxxxxxx:adequate-sam-master-DealNotificationTopic-XXXXXXXXXXXX"
		# SwiftyBeaver
        export LOGGER_APP_ID="xxxxxx"
        export LOGGER_APP_SECRET="xxxxxx"
        export LOGGER_ENCRYPTION_KEY="xxxxxx"
		;;
	production)
		# AWS
		export PLATFORM_APPLICATION_ARN="arn:aws:sns:xx-xxxx-x:xxxxxxxxxxxx:app/APNS/Adequate-Production"
		export TOPIC_ARN="arn:aws:sns:xx-xxxx-x:xxxxxxxxxxxx:adequate-sam-master-DealNotificationTopic-XXXXXXXXXXXX"
		# We don't log to SwiftyBeaver platform in production
		;;
	*)
		echo "Error: unrecognized ENV_NAME: '${ENV_NAME}'" 1>&2
		exit 1
		;;
esac
