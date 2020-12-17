# 快速入门

## 下载istio

安装最新稳定版本
curl -L https://istio.io/downloadIstio | sh -

安装指定版本
curl -L https://istio.io/downloadIstio | ISTIO_VERSION=1.8.0-alpha.2  sh -

## 安装istio

对于loadbalancer类型

```shell
istioctl install --set profile=demo -y
```

对于Nodeport类型

```shell
istioctl manifest generate --set profile=demo | sed "s/LoadBalancer/NodePort/g" | kubectl apply -f -
```

添加名称空间标签,以使Istio在对应命名空间部署应用程序时自动注入Envoy sidecar代理:

```shell
kubectl label namespace default istio-injection=enabled
namespace/default labeled
```