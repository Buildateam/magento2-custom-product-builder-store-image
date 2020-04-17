# Custom Product Builder Magento Docker Image

Buildateam.io build this custom docker image so you can deploy your own Magento 2 Store with pre-installed Custom Product Builder solution in your own datacenter or cluster on the cloud using Kubernetes.

Below are the instructions on how to use this image.

### The Easy way

We recommend installing bitnami/magento helm chart (located at https://github.com/bitnami/charts/tree/master/bitnami/magento) and specifing our own custom docker image as the repository.

Here's an example on how to do that by installing the helm chart using the command line:

```
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install mymagento bitnami/magento \
    -f values.yaml \
    --set image.repository=customproductbuilder/m2-cpb-image \
    --set image.tag=2.3.4-debian-10-r66
```

In this scenario, we assume that all your magento specific configuration are in `values.yaml`.
What makes this use the Custom Product Builder version is by specifying our own image repository and tag.

Refer to the documentation of the helm chart to learn how to configure it:

https://github.com/bitnami/charts/tree/master/bitnami/magento


### Building the docker Image

This image is meant to be used with  magento helm chart (as described above) or docker-compose by changing the image to this one. But if you want to create your own image to host in your own docker image registry, follow the steps below.

The first step is to create your own image. Replace `yourimage` with the name of the image you want.

```
docker build -t yourimage .
```

If you want to run this locally, you can follow the instructions from https://github.com/bitnami/bitnami-docker-magento but you can change every occurances of `magento` image name with your own.

For example, if you want to run manually you would do:

```
docker run -d --name magento -p 80:80 -p 443:443 \
  -e MAGENTO_DATABASE_USER=bn_magento \
  -e MAGENTO_DATABASE_PASSWORD=your_password \
  -e MAGENTO_DATABASE_NAME=bitnami_magento \
  --net magento-tier \
  --volume magento_data:/bitnami \
  yourimage   # instead of bitnami/magento:latest
```


### Helm Chart

The easiest way to deploy this image is with a helm chart as it will create the necessary MariaDB and ElasticSearch component needed to make this work.

Read carefully all the configuration variables for this chart as defined here:

https://github.com/bitnami/charts/tree/master/bitnami/magento

Create a file called `values.yaml` which contains all the custom variables that you want available in the official bitnami repository in github.

For example, in that file you can specify Magento user and password that you want for your admin account like this:

```
magentoPassword: mysecretpassword
```

In order to use your custom image, you will need to push this image to some docker registry (example: docker.io) and then provide your docker image inside your file called `values.yaml`.

To push your image:

```
docker login
docker tag yourimage yourbusiness/yourimage:latest
docker push yourbusiness/yourimage:latest
```


To tell the helm chart to use your image:

```
image:
  registry: docker.io
  repository: yourbusiness/yourimage
  tag: latest
```

Now you can deploy your helm chart manually using `helm install ...` or using rancher or kubeapps. 

Kubeapps has actually a pretty straightforward interface that can be run locally and used to deploy customized helm charts easily in your own cluster.

More instructions at https://github.com/bitnami/charts/tree/master/bitnami/magento
