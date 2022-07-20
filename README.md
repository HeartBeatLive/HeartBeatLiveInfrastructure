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
| `google_region` | Google Region, where we should deploy resources. Default: `europe-west3`. |
| `config_url` | URL to configuration file. See [configuration properties](#configuration-properties). |
| `config_access_token` | Access token to request a configuration file. [GitHub example](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token). |
| `backend_application_image` | Backend application image URL. For example: `gcr.io/heartbeatlive/backend_server:v1`. |

## Configuration Properties
| Name | Description |
| ---- | ----------- |
| `backendApplication.maxScale` | Instances limit of backend application. |
| `backendApplication.vpcConnector.machineType` | Machine type of VPC connector. `f1-micro`, `e2-micro`, or `e2-standard-4`. [Docs](https://cloud.google.com/vpc/docs/configure-serverless-vpc-access) |
| `backendApplication.vpcConnector.minInstances` | Minimum instances number of VPC connector. From 2 to 9. |
| `backendApplication.vpcConnector.maxInstances` | Minimum instances number of VPC connector. From 3 to 10. |
| `backendRedis.memorySizeGb` | Memory size of Backend Redis cluster. |
| `backendRedis.tier` | Tier of Backend Redis cluster. `BASIC` or `STANDARD_HA`. [Docs](https://cloud.google.com/memorystore/docs/redis/pricing#instance_pricing_with_no_read_replicas) |
| `backendAtlasMongodb.projectId` | MongoDB Atlas project identifier. |
| `backendAtlasMongodb.cluster.name` | MongoDB new cluster name to use. |
| `backendAtlasMongodb.cluster.type` | MongoDB cluster type. |
| `backendAtlasMongodb.cluster.cloudBackup` | Enable/disable MongoDB cluster backup. |
| `backendAtlasMongodb.cluster.instanceSizeName` | MongoDB cluster size name. [Docs.](https://www.mongodb.com/docs/atlas/billing/cluster-configuration-costs/#std-label-server-number-costs) |
| `backendAtlasMongodb.cluster.regionName` | MongoDB cluster region name. Choose from GCP regions. [Docs.](https://www.mongodb.com/docs/atlas/reference/google-gcp/#std-label-google-gcp) |
| `backendAtlasMongodb.cluster.autoscaling.enabled` | Enable/disable MongoDB cluster autoscaling. |
| `backendAtlasMongodb.cluster.autoscaling.scaleDownEnabled` | Enable/disable MongoDB cluster scaling down. |
| `backendAtlasMongodb.cluster.autoscaling.maxInstanceSize` | MongoDB cluster maximum instances size for autoscaling. [Docs.](https://www.mongodb.com/docs/atlas/billing/cluster-configuration-costs/#std-label-server-number-costs) |
| `backendAtlasMongodb.cluster.autoscaling.minInstanceSize` | MongoDB cluster minimum instances size for autoscaling. [Docs.](https://www.mongodb.com/docs/atlas/billing/cluster-configuration-costs/#std-label-server-number-costs) |
| `backendAtlasMongodb.cluster.disk.autoScalingEnabled` | Enable/disable MongoDB cluster disk autoscaling. |
| `backendAtlasMongodb.cluster.disk.sizeGb` | MongoDB cluster disk size. |

## Outputs
| Name | Description |
| ---- | ----------- |
| `rest_api_url` | Base URL, on which REST API is availiable. |