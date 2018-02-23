# cf-docker-registry

This repository demonstrates how easy it is to run a scalable and secure docker registry on Cloud Foundry backed by OpenStack Swift storage - for very little effort and cost.

## How to use it

Deploying this sample is very easy. All you have to do is:
 - Create a Swift Container via the [Meshcloud Panel](https://panel.meshcloud.io/)
 - Create a 
[service user](https://meshcloud.gitbooks.io/meshcloud/content/service-user.html) for your Project which allows access to OpenStack
 - Fill in the credentials in `manifest.yml` and `cf push`

You can quickly verify your registry works by pushing an image to it: 

```bash
# pull a simple image
docker pull busybox

# login to your registry
docker login https://my.registry.example.com

# tag the image for our own registry
docker tag busybox my.registry.example.com/busybox

# push the image
docker push busybox my.registry.example.com/busybox
```

## How it works

To run the registry on Cloud Foundry, we use the official docker [registry container image](https://hub.docker.com/r/_/registry/) and add our own `entrypoint.sh` script that generates the configuration based on environment variables provided via a Cloud Foundry manifest in true 12-factor app fashion. The entry point also generates a `htpasswd` file to secure the registry with http basic auth.

We provide an automated build for this container on docker hub at [meshcloud/cf-docker-resource](https://hub.docker.com/r/meshcloud/cf-docker-registry/)

> Note: due to a bug in the most recent release of docker registry (2.6.2), we have to disable storage backend health checks in the config. For more details, see this [issue](https://github.com/docker/distribution/issues/2292)
