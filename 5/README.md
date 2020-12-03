# Bookinfo 应用

此示例部署了一个示例应用程序，该应用程序由四个单独的微服务组成，用于演示各种Istio功能。

该应用程序显示有关书籍的信息，类似于在线书籍商店的单个目录条目。页面上显示的是书籍说明，书籍详细信息（ISBN，页数等）以及一些书籍评论。

Bookinfo应用程序分为四个单独的微服务：

- productpage。该productpage微服务调用details和reviews微服务来填充页面。
- details。该details微服务包含图书信息。
- reviews。该reviews微服务包含了书评。它还称为ratings微服务。
- ratings。该ratings微服务包含预定伴随书评排名信息。

reviews微服务有3个版本：

- 版本v1不会调用该ratings服务。
- 版本v2调用该ratings服务，并将每个等级显示为1到5个黑星。
- 版本v3调用该ratings服务，并将每个等级显示为1到5个红色星号。

该应用程序的端到端体系结构如下所示。

![](https://preliminary.istio.io/latest/docs/examples/bookinfo/noistio.svg)

该应用程序是多语言的，即微服务以不同的语言编写。值得注意的是，这些服务不依赖于Istio，但是提供了一个有趣的服务网格示例，特别是由于服务的多样性，服务的语言和版本reviews。


# 部署bookinfo

1. 默认的Istio安装使用自动Sidecar注入。使用以下命令为托管应用程序的名称空间设置istio-injection=enabled标签

kubectl label namespace default istio-injection=enabled

2. 使用以下kubectl命令部署应用程序：

kubectl apply -f samples/bookinfo/platform/kube/bookinfo.yaml

3. 确认所有服务和Pod均已正确定义并正在运行：

查看服务创建完成

kubectl get services
NAME          TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)    AGE
details       ClusterIP   10.0.0.31    <none>        9080/TCP   6m
kubernetes    ClusterIP   10.0.0.1     <none>        443/TCP    7d
productpage   ClusterIP   10.0.0.120   <none>        9080/TCP   6m
ratings       ClusterIP   10.0.0.15    <none>        9080/TCP   6m
reviews       ClusterIP   10.0.0.170   <none>        9080/TCP   6m

查看pod创建完成

kubectl get pods
NAME                             READY     STATUS    RESTARTS   AGE
details-v1-1520924117-48z17      2/2       Running   0          6m
productpage-v1-560495357-jk1lz   2/2       Running   0          6m
ratings-v1-734492171-rnr5l       2/2       Running   0          6m
reviews-v1-874083890-f0qf0       2/2       Running   0          6m
reviews-v2-1343845940-b34q5      2/2       Running   0          6m
reviews-v3-1813607990-8ch52      2/2       Running   0          6m

4. 要确认Bookinfo应用程序正在运行，通过curl向ratings服务发送请求：

kubectl exec "$(kubectl get pod -l app=ratings -o jsonpath='{.items[0].metadata.name}')" -c ratings -- curl productpage:9080/productpage | grep -o "<title>.*</title>"
<title>Simple Bookstore App</title>


# 确定入口IP和端口

现在Bookinfo服务已启动并正在运行，您需要使该应用程序可以从Kubernetes集群外部访问，例如，从浏览器访问。一个Istio网关 用于此目的。

定义应用程序的入口网关：

kubectl apply -f samples/bookinfo/networking/bookinfo-gateway.yaml

确认网关已创建：

kubectl get gateway
NAME               AGE
bookinfo-gateway   32s

请按照以下说明设置INGRESS_HOST和INGRESS_PORT变量以访问网关。设置好后返回此处。

设置GATEWAY_URL：

export GATEWAY_URL=$INGRESS_HOST:$INGRESS_PORT

# 确认可以从集群外部访问该应用程序

要确认可以从群集外部访问Bookinfo应用程序，请运行以下curl命令：

curl -s "http://${GATEWAY_URL}/productpage" | grep -o "<title>.*</title>"
<title>Simple Bookstore App</title>

您也可以将浏览器指向浏览http://$GATEWAY_URL/productpage Bookinfo网页。如果您多次刷新页面，则应该看到productpage以轮循样式显示的中不同版本的评论（红色星星，黑色星星，没有星星），因为我们尚未使用Istio来控制版本路由。

# 应用默认目标规则
在使用Istio控制Bookinfo版本路由之前，您需要在目标规则中定义可用的版本，称为子集。

运行以下命令为Bookinfo服务创建默认目标规则：

kubectl apply -f samples/bookinfo/networking/destination-rule-all.yaml

在default与demo 配置轮廓具有自动相互TLS启用默认情况下。要实施双向TLS，请使用`samples/bookinfo/networking/destination-rule-all-mtls.yaml。`中的目标规则

等待几秒钟，以便传播目标规则。

您可以使用以下命令显示目标规则：

$ kubectl get destinationrules -o yaml

