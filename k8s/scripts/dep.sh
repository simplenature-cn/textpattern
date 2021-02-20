#!/bin/sh

DEV_KUBE_CONTEXT="kubernetes-admin-c3a46acb58dec46a593327173db171c52"
PROD_KUBE_CONTEXT="kubernetes-admin-cf164975517e64e3984e001cc6a909e3d"

DOCKER_USERNAME=""
DOCKER_PWD=""
IMAGENAME=""
NAMESPACE=""
KUBECONTEXT=""
echo "$1"
if [ "$1" = "Prod" ]; then
  DOCKER_USERNAME=""
  DOCKER_PWD=""
  NAMESPACE=""
  IMAGENAME=""
  KUBECONTEXT=$PROD_KUBE_CONTEXT
else
  DOCKER_USERNAME="simplenature"
  DOCKER_PWD="~liyan850723"
  NAMESPACE="xpatglodon"
  IMAGENAME="sn-txp-hellolinux"
  KUBECONTEXT=$DEV_KUBE_CONTEXT
fi

TAG=$(date "+%Y%m%d-%H%M%S")
echo $NAMESPACE
docker login --username="$DOCKER_USERNAME" registry.cn-beijing.aliyuncs.com --password "$DOCKER_PWD"
docker build -t registry.cn-beijing.aliyuncs.com/$NAMESPACE/sn-txp-hellolinux:"$TAG" .
docker push registry.cn-beijing.aliyuncs.com/$NAMESPACE/sn-txp-hellolinux:"$TAG"

kubectl config use-context $KUBECONTEXT
CUR_CONTEXT=$(kubectl config current-context)
if [ $KUBECONTEXT = "$CUR_CONTEXT" ]; then
  kubectl --record deployment/$IMAGENAME set image deployment/$IMAGENAME $IMAGENAME=registry.cn-beijing.aliyuncs.com/$NAMESPACE/sn-txp-hellolinux:"$TAG"
else
  echo "fail to switch to context:"$KUBECONTEXT
  echo "KUBECONTEXT:"$KUBECONTEXT
  echo "CUR_CONTEXT:""$CUR_CONTEXT"
fi
