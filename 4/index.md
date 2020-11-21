# 快速入门

## 下载istio

安装最新稳定版本
curl -L https://istio.io/downloadIstio | sh -

安装指定版本
curl -L https://istio.io/downloadIstio | ISTIO_VERSION=1.8.0-alpha.2  sh -

## 安装istio

对于loadbalancer类型
```
istioctl install --set profile=demo -y
```
对于Nodeport类型

```
istioctl manifest generate --set profile=demo | sed "s/LoadBalancer/NodePort/g" | kubectl apply -f -
```

添加名称空间标签，以使Istio在对应命名空间部署应用程序时自动注入Envoy sidecar代理：

```
kubectl label namespace default istio-injection=enabled
namespace/default labeled
```

## 部署示例程序

```
kubectl apply -f samples/bookinfo/platform/kube/bookinfo.yaml
```

检查示例服务
```
kubectl get services
```
检查示例pod
```
kubectl get pods
```

## 测试示例服务能够正常提供服务

```
kubectl exec "$(kubectl get pod -l app=ratings -o jsonpath='{.items[0].metadata.name}')" -c ratings -- curl -s productpage:9080/productpage | grep -o "<title>.*</title>"
<title>Simple Bookstore App</title>
```

# 外部访问

export INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].nodePort}')
export SECURE_INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="https")].nodePort}')

curl http://$INGRESS_HOST:$INGRESS_PORT/productpage