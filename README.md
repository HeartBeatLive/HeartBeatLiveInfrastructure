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
   See authentication solutions [here](https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/provider_reference#authentication).
3. Specify [required environment variables](#required-environment-variables).
4. Deploy infrastructure using `$ terraform apply` command.
5. Additionaly you need to manualy enable Firebase Authentication and deploy Firebase Functions.

## Required Environment Variables
| Name | Description |
| ---- | ----------- |
| `MONGODB_ATLAS_PUBLIC_KEY` | MongoDB Atlas public key to manage specified in variables atlas project. |
| `MONGODB_ATLAS_PRIVATE_KEY` | MongoDB Atlas private key to manage specified in variables atlas project. |

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
| `backend_atlas_mongodb.project_id` | MongoDB Atlas project identifier. |
| `backend_atlas_mongodb.cluster.name` | MongoDB new cluster name to use. |
| `backend_atlas_mongodb.cluster.type` | MongoDB cluster type. |
| `backend_atlas_mongodb.cluster.cloud_backup` | Enable/disable MongoDB cluster backup. |
| `backend_atlas_mongodb.cluster.instance_size_name` | MongoDB cluster size name. [Docs.](https://www.mongodb.com/docs/atlas/billing/cluster-configuration-costs/#std-label-server-number-costs) |
| `backend_atlas_mongodb.cluster.region_name` | MongoDB cluster region name. Choose from GCP regions. [Docs.](https://www.mongodb.com/docs/atlas/reference/google-gcp/#std-label-google-gcp) |
| `backend_atlas_mongodb.cluster.autoscaling.enabled` | Enable/disable MongoDB cluster autoscaling. |
| `backend_atlas_mongodb.cluster.autoscaling.scale_down_enabled` | Enable/disable MongoDB cluster scaling down. |
| `backend_atlas_mongodb.cluster.autoscaling.max_instance_size` | MongoDB cluster maximum instances size for autoscaling. [Docs.](https://www.mongodb.com/docs/atlas/billing/cluster-configuration-costs/#std-label-server-number-costs) |
| `backend_atlas_mongodb.cluster.autoscaling.min_instance_size` | MongoDB cluster minimum instances size for autoscaling. [Docs.](https://www.mongodb.com/docs/atlas/billing/cluster-configuration-costs/#std-label-server-number-costs) |
| `backend_atlas_mongodb.cluster.disk.auto_scaling_enabled` | Enable/disable MongoDB cluster disk autoscaling. |
| `backend_atlas_mongodb.cluster.disk.size_gb` | MongoDB cluster disk size. |

## Outputs
| Name | Description |
| ---- | ----------- |
| `rest_api_url` | Base URL, on which REST API is availiable. |