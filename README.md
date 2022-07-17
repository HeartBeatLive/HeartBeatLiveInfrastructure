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
3. Deploy infrastructure using `$ terraform apply` command.
4. Additionaly you need to manualy enable Firebase Authentication and deploy Firebase Functions.

## Variables
| Name | Description |
| ---- | ----------- |
| `google_project_id` | Google Project ID to use. |
| `google_region` | Google Region, where we should deploy resources. Default: `europe-west3` |
| `backend_application.image` | Backend application image URL. |
| `backend_application.max_scale` | Instances limit of backend application. |
| `backend_application.vpc_connector.machine_type` | Machine type of VPC connector. `f1-micro`, `e2-micro`, or `e2-standard-4`. [Docs](https://cloud.google.com/vpc/docs/configure-serverless-vpc-access) |
| `backend_application.vpc_connector.min_instances` | Minimum instances number of VPC connector. From 2 to 9. |
| `backend_application.vpc_connector.max_instances` | Minimum instances number of VPC connector. From 3 to 10. |
| `backend_redis.memory_size_gb` | Memory size of Backend Redis cluster. |
| `backend_redis.tier` | Tier of Backend Redis cluster. `BASIC` or `STANDARD_HA`. [Docs](https://cloud.google.com/memorystore/docs/redis/pricing#instance_pricing_with_no_read_replicas) |

## Outputs
| Name | Description |
| ---- | ----------- |
| `rest_api_url` | Base URL, on which REST API is availiable. |