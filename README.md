# Heart Beat Live Infrastructure
Infrastrcuture settings of HeartBeatLive application.
It using terraform to deploy infrastracture and Google Cloud Platform as cloud provider.

## Prerequirements
1. Terraform
2. `gcloud` CLI

## What it create
1. Google Cloud Run application to run HeartBeatLive application in it.
2. Redis
3. MongoDB

## Variables
| Name | Description |
| ---- | ----------- |
| google_project_id | Google Project ID to use. |
| google_region | Google Region, where we should deploy resources. |
| google_rest_api_application_image_name | Backend application image name. Terraform will reference to it using `gcr.io/${google_project_id}/${google_rest_api_application_image_name}`. There should be at lease one tag when you apply deployment. |
