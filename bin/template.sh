#!/usr/bin/env  bash

ROOT_DIR=`pwd`

. $ROOT_DIR/bin/utils.sh

COMMIT_SHA=`git rev-parse --short HEAD`
VARIABLES=('NAMESPACE' 'IMAGE_TAG' 'PORT' 'PROJECT_NAME')

# Image tag and namespace should be diffrent based on branches
if [ "$CIRCLE_BRANCH" == 'master' ]; then
    NAMESPACE=production
    IMAGE_TAG=$COMMIT_SHA
else
    IMAGE_TAG=staging-$COMMIT_SHA
    NAMESPACE=staging
fi

# Default variable values
PORT=${PORT:=8000}
PROJECT_NAME=${PROJECT_NAME:=fluffy}
# Ensure that all the required variables have been set
require VARIABLES $VARIABLES
require NAMESPACE $NAMESPACE
require IMAGE_TAG $IMAGE_TAG
require PORT $PORT
require PROJECT_NAME $PROJECT_NAME

# Build template files for deployment.
find_tempate_files "TEMPLATES"
find_and_replace_variables