#!/bin/bash
set -e

DEPLOY_ENV=${1:latest}
IMAGE_TAG=${2:latest}


cmd="ecsdeploy ecs deploy
		--cfg-file=./${DEPLOY_ENV}/deploy_cfg.json
		--tv=./${DEPLOY_ENV}/taskdef_vars.json
		--task-def-file=./taskdef.json.erb
		--app-env=${DEPLOY_ENV}
		--app-name=orcs
		--image-tag=${IMAGE_TAG}
		--skip-canary true -v live"

echo
echo "Deploying service1 (${IMAGE_TAG}) to ${DEPLOY_ENV} Live"
echo "-------------------------------"
echo $cmd
time $cmd
