# docker-automl
Docker container for Azure AutoML

## How to use
Run using
```
docker run -it --env WORKSPACE_NAME={workspace_name} \
               --env SUBSCRIPTION_ID={subscription_id} \
               --env RESOURCE_GROUP={resource_group} \
               jnnorthway/automl /bin/bash
```
or pass in the current directory with
```
docker run -it --env WORKSPACE_NAME={workspace_name} \
               --env SUBSCRIPTION_ID={subscription_id} \
               --env RESOURCE_GROUP={resource_group} \
               --volume $(pwd):/ws \
               jnnorthway/automl /bin/bash
```
Import Python libraries from anywhere. \
Libraries are located at `/src`. \
Get the handler using
```
from automl_common import AutoML

automl_handler = AutoML()
```
