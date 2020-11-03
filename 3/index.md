在istio中包含以下自定义资源

```
adapters.config.istio.io                   2020-10-30T08:20:41Z
attributemanifests.config.istio.io         2020-10-30T08:20:41Z
authorizationpolicies.security.istio.io    2020-10-30T08:20:41Z
destinationrules.networking.istio.io       2020-10-30T08:20:42Z
envoyfilters.networking.istio.io           2020-10-30T08:20:42Z
gateways.networking.istio.io               2020-10-30T08:20:42Z
handlers.config.istio.io                   2020-10-30T08:20:42Z
httpapispecbindings.config.istio.io        2020-10-30T08:20:42Z
httpapispecs.config.istio.io               2020-10-30T08:20:42Z
instances.config.istio.io                  2020-10-30T08:20:42Z
istiooperators.install.istio.io            2020-10-30T08:20:42Z
peerauthentications.security.istio.io      2020-10-30T08:20:43Z
quotaspecbindings.config.istio.io          2020-10-30T08:20:43Z
quotaspecs.config.istio.io                 2020-10-30T08:20:43Z
requestauthentications.security.istio.io   2020-10-30T08:20:43Z
rules.config.istio.io                      2020-10-30T08:20:43Z
serviceentries.networking.istio.io         2020-10-30T08:20:43Z
sidecars.networking.istio.io               2020-10-30T08:20:43Z
templates.config.istio.io                  2020-10-30T08:20:43Z
virtualservices.networking.istio.io        2020-10-30T08:20:43Z
workloadentries.networking.istio.io        2020-10-30T08:20:43Z
```

- adapters 为mixer的适配器这里不再讲述
- attributemanifests 为mixer的属性清单这里不再讲述

- destinationrules 发生路由后应用于服务流量的策略，决定了cluster和endpoint配置
- envoyfilters 提供了一种机制来自定义Istio Pilot生成的Envoy配置
- gateways  Gateway描述了在网格边缘运行的负载均衡器，用于接收传入或传出的HTTP/TCP连接
- virtualservices 影响流量路由的配置，定义了一个域名的具体配置
- workloadentries 描述单个非Kubernetes工作负载(如VM或裸机服务器)的属性
- serviceentries 将额外条目添加到Istio的内部服务注册表中，以便网格中自动发现的服务可以访问/路由到这些手动指定的服务
- sidecars 描述了sidecar代理的配置，该代理将入站和出站通信调解到它所连接的工作负载实例

- peerauthentications 定义流量如何通过隧道传输（或不传输）到sidecar
- requestauthentications 定义工作负载支持哪些请求身份验证方法
- authorizationpolicies istio中的授权策略


- handlers
- httpapispecbindings
- httpapispecs
- instances
- istiooperators
- quotaspecbindings
- quotaspecs
- rules
- templates