# 仓库秘钥
DOCKER_REGISTRY_SERVER=registry.cn-shanghai.aliyuncs.com
DOCKER_USER=复深蓝开发一中心研发
DOCKER_PASSWORD=fulan123wmy
kubectl create secret docker-registry registry-ali --docker-server=$DOCKER_REGISTRY_SERVER --docker-username=$DOCKER_USER --docker-password=$DOCKER_PASSWORD -n 'wmy' 
kubectl   patch sa default -p '{"imagePullSecrets": [{"name":"registry-ali"}]}' -n 'wmy'    
