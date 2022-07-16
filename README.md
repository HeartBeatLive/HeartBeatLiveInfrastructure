# Heart Beat Live Infrastructure
Infrastrcuture settings of HeartBeatLive application.
It using terraform to deploy infrastracture and Google Cloud Platform as cloud provider.

## Prerequirements
1. Terraform
2. `gcloud` CLI

## Set up
1. Deploy backend application image. \
   You may use following steps:
   1. Set up docker credentials using `$ gcloud auth configure-docker`.
   2. Tag docker image using `$ docker tag image_name gcr.io/${project_id}/${image_name}:${tag}`.
   3. Push container using `$ docker push gcr.io/${project_id}/${image_name}:${tag}`.
2. Authenticate Google Cloud provider. \
   You may use following command: `$ gcloud auth application-default login`.


## What it create
1. Google Cloud Run application to run HeartBeatLive application in it.
2. Redis
3. MongoDB

## Variables
| Name | Description |
| ---- | ----------- |
| google_project_id | Google Project ID to use. |
| google_region | Google Region, where we should deploy resources. Default: `europe-west3` |
| google_backend_application_image | Backend application image URL. |
