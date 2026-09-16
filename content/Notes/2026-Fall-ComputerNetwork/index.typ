#import "../index.typ": template, tufted

#show: template.with(
  title: "计算机网络",
  description: "2026 Fall",
  date: datetime(year: 2026, month:9, day: 8),
  lang: "zh",
)

== Ch01 Computer Networks and the Internet

=== 网络边缘 (Network Edge)

*端系统*被称为 *host* 或者 *end system*, 通常被分为*服务器*和*客户*.

*接入网 (access network)* 将端系统连接到边缘路由器.

== Ch02 The Application Layer

*进程*间使用*套接字 (socket)* 进行通信.

网络应用的要求: 可靠, 高吞吐, 低时延, 安全.

网络应用有两种主流组织方式: *客户-服务器 (C/S)* 方式和 *P2P* 方式.

C/S 方式可以分为面向连接 (TCP) 的和无连接 (UDP) 的. 服务器可以采用循环方式或并发方式. TCP 使用二种套接字: 监听套接字和(多个)连接套接字. UDP 只使用一种套接字.

P2P 方式中每个程序的地位对等, 可以直接通信.

=== Protocals for the Application Layer

*WWW = World Wide Web = 万维网*. WWW 由 HTTP 服务器/客户端, Web 对象和 HTTP 协议构成.

Web 服务器存储 Web 对象 (文档, 图像, 视频, 脚本等), 对象用 *统一资源定位器 (URL)* 描述. URL 通常形如 `proc://hostname:port/filename`.

Web 对象分为静态,动态和链接.

*HTTP 协议* 在传输层通常使用 TCP 协议 (缺省使用 80 端口).

HTTP/1.0 在每次获取都需要执行三次握手 (每次重新建立连接). HTTP/1.1 改为持久连接, 后续还支持流水线机制.

HTTP 请求报文分为*开始行, 首部行和实体主体*. 每一行的末尾都有回车换行 `CRLF`.

```
GET /somedir/page.html HTTP/1.1
Host: www.someschool.edu
Connection: close
User-agent: Mozilla/5.0
Accept-language: fr
```

这里 `GET` 被称为*方法 (method)*. 紧跟着的为 URL 字段. `HTTP/1.1` 为版本字段.