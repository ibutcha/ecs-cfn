#!/bin/bash

if ! aws cloudformation describe-stacks --stack-name $1 > /dev/null ; then

	echo "Stack doesn't exist.."

	aws cloudformation create-stack \
		--stack-name $1 \
		--capabilities CAPABILITY_IAM $3\
		--template-body file://$2

	echo "Waiting for stack create to complete ..."
	aws cloudformation wait stack-create-complete \
	--stack-name $1

else

	echo "Stack exist.."

	update_output=$(aws cloudformation update-stack \
		--capabilities CAPABILITY_IAM $3\
		--stack-name $1 \
		--template-body file://$2\
	${@:5}  2>&1)

	status=$?

	echo "$update_output"
	echo "$status"

	if [ $status -ne 0 ] ; then
		if [[ $update_output == *"ValidationError"* && $update_output == *"No updates"* ]] ; then
			echo -e "\nFinished create/update - no updates to be performed"
			exit 0
		else
			exit $status
		fi
	fi

	echo "Waiting for stack update to complete ..."
		aws cloudformation wait stack-update-complete \
		--stack-name $1
fi
