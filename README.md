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
| google_region | Google Region, where we should deploy resources. Default: `europe-west3` |
| google_backend_application_image | Backend application image URL. |
