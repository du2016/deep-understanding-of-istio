# envoy 

envoy 在当前众多servicemesh框架数据面的共同选择，其具有高性能，易配置，功能强大等特点。

# 什么是envoy

Envoy是L7代理和通信总线，专为面向大型现代服务的体系结构而设计。该项目是基于以下信念而诞生的：

网络对应用程序应该是透明的。当确实发生网络和应用程序问题时，应该容易确定问题的根源。

在实践中，要实现上述目标非常困难。Envoy尝试通过提供以下高级功能来做到这一点：

流程外架构： Envoy是一个自包含的流程，旨在与每个应用程序服务器一起运行。所有的Envoy都构成一个透明的通信网格，每个应用程序在其中都与localhost之间发送和接收消息，并且它们不知道网络拓扑。与传统的库服务到服务通信方法相比，进程外体系结构具有两个实质性的好处：

Envoy可与任何应用程序语言一起使用。单个Envoy部署可以在Java，C ++，Go，PHP，Python等之间形成网格。面向服务的体系结构使用多种应用程序框架和语言正变得越来越普遍。特使透明地弥合了差距。

任何使用大型面向服务的体系结构的人都知道，部署库升级可能会非常痛苦。Envoy可以透明地在整个基础架构中快速部署和升级。

L3 / L4 filter体系结构： Envoy是L3 / L4网络代理。可插入的 filter chains机制允许编写 filter以执行不同的TCP / UDP代理任务，并将其插入主服务器。已经编写了 filter来支持各种任务，例如原始TCP代理，UDP代理，HTTP代理，TLS客户端证书认证，Redis， MongoDB，Postgres等。

HTTP L7 filter体系结构： HTTP是现代应用程序体系结构的关键组成部分，Envoy支持附加的HTTP L7 filter layer。可以将HTTP filter插入HTTP连接管理子系统，该子系统执行不同的任务，例如缓冲，速率限制，路由/转发，嗅探Amazon的DynamoDB等。

一流的HTTP / 2支持：在HTTP模式下运行时，Envoy支持HTTP / 1.1和HTTP / 2。Envoy可以在两个方向上充当透明的HTTP / 1.1到HTTP / 2代理。这意味着可以桥接HTTP / 1.1和HTTP / 2客户端与目标服务器的任何组合。推荐的服务到服务配置使用所有Envoy之间的HTTP / 2创建持久连接的网格，可以在请求和响应之间进行多路复用。

HTTP L7路由：在HTTP模式下运行时，Envoy支持一个 路由子系统，该子系统能够基于路径，权限，内容类型，运行时值等来路由和重定向请求。当使用Envoy作为前端/边缘时，此功能最有用代理，但在构建服务到服务网格时也会利用。

gRPC支持： gRPC是Google的RPC框架，使用HTTP / 2作为基础的多路复用传输。Envoy支持所有HTTP / 2功能，这些功能必须用作gRPC请求和响应的路由和负载平衡基础。这两个系统是非常互补的。

服务发现和动态配置： Envoy可以选择使用一组分层的 动态配置API进行集中管理。这些层为Envoy提供有关以下方面的动态更新：后端集群中的主机，后端集群本身，HTTP路由，侦听套接字和加密材料。对于更简单的部署，可以通过DNS解析 （甚至 完全跳过）来完成后端主机发现 ，而将其他层替换为静态配置文件。

运行状况检查： 构建Envoy网格的推荐方法是将服务发现视为最终一致的过程。Envoy包括运行状况检查子系统，该子系统可以有选择地对上游服务集群执行主动运行状况检查。然后，Envoy使用服务发现和运行状况检查信息的结合来确定健康的负载平衡目标。Envoy还通过异常值检测子系统支持被动健康检查。

高级负载平衡： 分布式系统中不同组件之间的负载平衡是一个复杂的问题。因为Envoy是一个自包含的代理而不是一个库，所以它能够在一个地方实现高级负载平衡技术，并使任何应用程序都可以访问它们。目前，Envoy包括对自动重试，断路， 通过外部速率限制服务进行全局速率限制， 请求屏蔽和 异常检测的支持。计划为请求竞赛提供将来的支持。

前端/边缘代理支持：在边缘使用相同的软件（可观察性，管理，相同的服务发现和负载平衡算法等）具有很大的好处。Envoy具有一项功能集，使其非常适合作为大多数现代Web应用程序用例的边缘代理。这包括TLS终止，HTTP / 1.1和HTTP / 2支持以及HTTP L7路由。

一流的可观察性：如上所述，Envoy的主要目标是使网络透明。但是，问题在网络级别和应用程序级别都会发生。Envoy包括对所有子系统的强大统计支持。statsd（和兼容的提供程序）是当前受支持的统计接收器，尽管插入另一个并不困难。还可以通过管理端口查看统计信息。Envoy还支持通过第三方提供商进行分布式 跟踪。


# 术语

在深入了解主要体系结构文档之前，请先定义一些定义。一些定义是行业内略有争议，但他们是由envoy使用贯穿文档和代码。

主机：能够进行网络通信的实体（手机，服务器等上的应用程序）。在本文档中，主机是逻辑网络应用程序。一个物理硬件可能会在其上运行多个主机，只要它们中的每一个都可以独立寻址。

下游：下游主机连接到Envoy，发送请求并接收响应。

上游：上游主机从Envoy接收连接和请求，并返回响应。

listener：listener是可以由下游客户端连接到的命名网络位置（例如，端口，Unix域套接字等）。Envoy公开了下游主机连接到的一个或多个listener。

群集：群集是Envoy连接到的一组逻辑相似的上游主机。Envoy通过服务发现来发现集群的成员。它可以选择通过主动运行状况检查来确定集群成员的运行状况。Envoy将请求路由到的群集成员由负载平衡策略确定。

网格：一组主机，它们相互协作以提供一致的网络拓扑。在本文档中，“ Envoy网格”是一组Envoy代理，它们构成了由许多不同服务和应用程序平台组成的分布式系统的消息传递基础。

运行时配置：与Envoy一起部署的带外实时配置系统。可以更改配置设置，这将影响操作，而无需重新启动Envoy或更改主要配置。

