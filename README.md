![Lint](https://github.com/spaghettifunk/druid-terraform/workflows/Lint/badge.svg?branch=master)

# Druid terraform

This is a Terraform module for installing Druid on your Kubernetes cluster. This modules uses normal Kubernetes definitions files instead of the Helm Chart. Despite the Helm chart would make this module way more smaller, we think that for faster testing and deployment, it would have been simpler using multiple yaml files rather then templating.

## Build Druid image

To build the Druid docker image, follow the steps below:

1. `cd docker`
2. `docker build -t your-repo/druid:latest .`
3. `docker push your-repo/druid:latest`

Remeber to use your own repository

## Deploy Apache Druid

Once the image is built and pushed to the registry, you can install the module in your cluster.

It will take few minutes before it gets everything up and running. Once it's ready, you should be able to port-forward towards the Druid UI. To do so, run `kubectl port-forward --namespace druid svc/router-cs 8888:8888`, open your browser at `http://localhost:8888/unified-console.html#` and you should see the UI running. If you see 500 Errors within the boxes of the services, it means that it's not ready yet. Wait a little longer and then refresh. If it stays that way, you need to check where the error is.

If you are able to see all the services in the Druid UI it means that your cluster is ready to be used.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.9 |
| kubernetes | >= 1.11.1 |

## Providers

| Name | Version |
|------|---------|
| kubernetes | >= 1.11.1 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws\_access\_key | AWS Access Key value. Permissions needed for S3 | `string` | `""` | no |
| aws\_bucket\_index | S3 bucket for storing the indexes | `string` | `""` | no |
| aws\_bucket\_storage | S3 bucket for storing the segments | `string` | `""` | no |
| aws\_region | AWS region | `string` | `""` | no |
| aws\_secret\_key | AWS Secret Key value. Permissions needed for S3 | `string` | `""` | no |
| broker\_replicas | Number of replicas for the Broker service | `number` | `1` | no |
| coordinator\_replicas | Number of replicas for the Coordinator service | `number` | `1` | no |
| create\_postgres | Controls if Postgres database resources should be created (it affects almost all resources) | `bool` | `true` | no |
| create\_zookeeper | Controls if Zookeeper resources should be created (it affects almost all resources) | `bool` | `true` | no |
| druid\_image\_registry | Docker registry used to fetch the Apache Druid image | `string` | `"spaghettifunk"` | no |
| druid\_image\_repository | Docker image of Apache Druid compatible for this module | `string` | `"apache-druid"` | no |
| druid\_image\_tag | Docker image tag | `string` | `"0.18.1"` | no |
| historical\_replicas | Number of replicas for the Historical service | `number` | `1` | no |
| middlemanager\_replicas | Number of replicas for the Middlemanager service | `number` | `2` | no |
| namespace | Namespace where Druid will be deployed | `string` | `"druid"` | no |
| overlord\_replicas | Number of replicas for the Overlord service | `number` | `1` | no |
| postgres\_db | Postgress Database name for Druid | `string` | `"druid"` | no |
| postgres\_password | Postgress Password of the user | `string` | `"druid"` | no |
| postgres\_user | Postgres username for accessing the DB | `string` | `"druid"` | no |
| router\_replicas | Number of replicas for the Router service | `number` | `1` | no |
| zookeeper\_replicas | Number of replicas for the Zookeeper service | `number` | `3` | no |

## Outputs

No output.