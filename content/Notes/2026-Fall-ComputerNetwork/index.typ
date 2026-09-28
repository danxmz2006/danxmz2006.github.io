#import "../index.typ": template, tufted

#show: template.with(
  title: "计算机网络",
  description: "2026 Fall",
  date: datetime(year: 2026, month:9, day: 8),
  lang: "zh",
)

== Ch01 Computer Networks and the Internet

=== 实体

计算机网络分为若干层次, 通常被称为 XAN. (PAN < LAN < MAN < WAN) 

互联网是网络的网络. ISP (Internet service provider) 提供网络接入和互联服务.

*网络边缘*: 端系统指互联网边缘和互联网相连的计算机和其它设备. 端系统由各类主机 (host) 构成, 主机通过网络设备硬件 (网卡) 同外部通信. 每个网卡有唯一的设备 ID (48 位 mac 地址, 数据链路层); IP 地址由一组数字构成 (IPv4 32 位, IPv6 64 位), 由运营商提供 (网络层); 主机名为字符串.  

*接入网 (access network)* 将端系统连接到边缘路由器. 物理介质分为有线和无线, 引导型和非引导型. DSL 为数字用户线. (DSL < 无线链路 < 同轴电缆 < 双绞线 < 光纤)

下行速率 (下载) 通常远高于上行速率 (上传).

企业网络通常通过*交换机* (方形的 X) 与专线直连介入到 ISP.

*网络核心*将端系统互联, 由各类路由器 (圆形的 X) 和链路构成. 端系统通过本地网络提供商 (access ISP) 接入 Internet, 本地网络提供商之间也需要互相连接. 每个 access ISP 会接入一个或多个 global ISP. Global ISP 之间的连接被称为 Internet eXchange Point (IXP), 连接 access ISP 和 global ISP 的被称为局域 ISP.

=== 服务

网络可以被拆分为路由和转发两大功能.

网络分为分组交换和电路交换两种工作方式. 前者将 message 拆分成小的分组 (packet), 使用*存储-转发* 机制,独立选择路径, 支持统计多路复用. 存储转发需要逐个处理完整的数据包, 会带来 (相较于逐比特) 额外的延迟. 电路交换需要预先建立连接.

网络服务的性能指标:

*带宽*: 单位时间内某信道所能通过的最高数据率.

*包转化率*: 交换机/路由器以包为单位的转发速率. 线速转发: 交换机端口满负载时对帧转发时能够达到该端口线路的最高速度.

*比特率*: 主机往数字信道传输数据的速率.

*吞吐量*: 单位时间内通过某信道的数据量.

*有效吞吐量*: 单位时间内目的地正确接收到有用信息的数量.

*利用率*: 某信道(或全网络加权平均)被利用的时间比例.

*丢包率*: 丢失包的比例.

*时延* 分为传输/发送时延, 传播时延, (节点)处理时延, 排队时延. 如果分组到达速率超过链路传播速率就会发生排队或丢包.

*时延带宽积* 为传播时延和带宽的乘积.

变化的时延称为*抖动*. 数据包延迟到达会造成*延迟丢包*.

=== 协议

网络协议为为了进行数据交流而建立的规则, 包含格式, 语义和时序. 网络协议由头部封装的形式定义, 数据被封装为有效载荷.

=== 网络分层

#image("imgs/layers.png")

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

这里 `GET` 被称为*方法 (method)*, 类似的还有 `POST`. 紧跟着的为 URL 字段. `HTTP/1.1` 为版本字段.

首部行的最后一行和实体主体 (通常不用) 之间隔了一个空行 `CRLF`. POST 方法的参数在实体主体中, GET 的参数在 URL 中 (以 '?' 开始, 用 '&' 分割).

HTTP 响应报文同样分为开始行, 首部行和实体主体. 不同的是, 开始行形如 `版本 状态码 短语+CRLF`, 又称为状态行.

浏览器和代理服务器中都会使用缓存. 再次访问前需要检查是否过期.

*Cookie* 为一个由服务器分配, 具有唯一性的内容. 服务器在 HTTP 相应中会使用关键字 set-cookie, cookie 被保存在主机中. 后续 HTTP 请求会附加 cookie 的值, 表明这个请求是之前请求的后续.

Cookies 包含域, 路径, 内容, 过期, 安全五个字段. 

=== DNS

*域名系统 (DNS)* 维护域名 (主机名) 和 IP 地址之间的映射关系.

DNS 提供的是网络层有关的功能, 但以应用层的方式实现. 域名和 IP 之间的是一对多和多对一的关系.

Internet 的 DNS 是一个分布式数据库系统, 由若干个域名服务器完成查询.

域名结果形如 `...三级域名.二级域名.顶级域名`.

域名服务器保留了域树的信息和相邻域名服务器的信息. 域名服务器同域树一样分为若干层.

*根服务器*为最高层次的域名服务器, 知道顶级域名服务器 (TLD name servers) 的域名和 IP 地址. IPv4 根服务器共有 13 套, 域名是 `a.rootservers.net` 到 `m.rootservers.net`. 每套有多个镜像根服务器, 只能在 `a.rootservers.net` 上改数据然后同步. 全球共 25 套 IPv6 根服务器.

*顶级域名服务器*负责管理该顶级域名服务器注册的所有二级域名 (e.g. `.com DNS servers`). 收到 DNS 请求时给出回答 (最后的结果或二级域名字服务器的 IP 地址).

主机必须在某个 *二级域(权威)名字服务器* 处注册登记. 二级域名管理机构将所属域分为若干个区, 每个区设置二级名字服务器.

每个 ISP 都至少有一个*本地 DNS 服务器 (递归服务器)* 距离用户主机较近. 本地 DNS 服务器可能有一层或多层.  

域名解析首先发给本地 DNS 服务器, 然后采取递归查询 (主机向本地 DNS 服务器查询) 或者迭代查询 (本地 DNS 服务器向更上层服务器).

DNS 报文包括*基础结构* (报文首部), *问题*和*资源记录*. 报文类型包括查询请求和查询响应.

#image("imgs/dns.png")

基础结构包括*事务 ID*, *标志*, *问题计数*, *回答资源记录数*, *权威资源记录数*和*附加资源记录数*. 

标志字段包括 Q/R 状态, Opcode (操作码) (0: 标准查询, 1: 反向查询, 2: 服务器状态查询), AA (权威应答, 在响应报文中生效, 标志是不是权威服务器), TC (表示是否被截断), RD (期望递归), RA (可用递归), Z (保留字段, =0), Rcode (返回码: 表示响应的差错状态).

问题部分包括查询名, 查询类型和查询类.

资源部份只在 DNS 响应报文中出现, 包括回答问题区域字段, 权威名字服务器区域字段, 附加信息区域字段. 这三个字段都采用*资源记录 (RR)* 格式 `NAME + TYPE + class + 生存时间 TTL + 资源数据长度 RDLENGTH + 资源数据 RDATA`.

资源记录类型同问题部分的查询类型相同, 决定了 name 和 value 分别的含义.

域名系统采取高速缓存, 包括域名-IP 映射和顶级域名服务器信息. 缓存项目具有时限.

DNS 协议未多考虑安全问题, 通常基于 UDP 明文传输. DNSSEC 依靠数字签名保证 DNS 报文的真实性和完整性.

=== 电子邮件服务

电子邮件系统体系结构包括 *用户代理 (客户端)*, *传输代理 (邮件服务器)* 和 *协议 (SMTP, POP3, IMAP)*. 待发送的邮件和用户收到的邮件放在邮件队列和邮箱, 位于邮件服务器.

SMTP 定义了如何传输邮件. 邮件需要遵循特定格式:
```
首行 (header): From: 首部行 + To: 首部行, 可以包含 Subject: 等可选首部行
<空行>
主体 (body)
```

邮件格式有 RFC 5322 和 MIME. 基本 ASCII 邮件使用 RFC 5322. MIME 为多用途 Internet 邮件拓展 (多媒体拓展). MIME 加入了消息体结构 (定义非 ASCII 消息编码规则).

SMTP 利用 TCP 从客户向服务器传递邮件, 使用端口 25. 实际实现中客户端需要向服务器发送一系列命令, 服务器一一响应.

假设邮件到达了 Bob 的邮箱. 现在需要将邮件的一个副本传送给 Bob 的用户代理.

最终交付协议: 从邮箱中取邮件. e.g. POP3, IMAP, Webmail

POP3 采用端口 110 上的 TCP 连接, 分为认证, 事务处理和更新三个阶段. POP3 包含 `user, pass, list, retr, dele, quit` 等命令.

IMAP 是 POP3 的改进版, 邮件服务器运行侦听端口 143 的 IMAP 服务器, 用户代理运行 IMAP 客户端. 最大区别是邮件存在服务器上不要求用户取走.

Webmail 基于 Web, 通过 HTTP 进行.

=== 套接字编程

应用需*显示*地创建, 使用和释放套接字.

Linux 系统中程序通过访问*套接字描述符*进行通信. 用文件读写的方式发送,接收数据.

```c
#include <unistd.h>

int read(int fd, void *buf, size_t count);
int write(int fd, void *buf, size_t count);
```

进程标识包括主机地址和与该进程关联的端口号. 使用 `socket()` 创建本地套接字.

```c 
#include <sys/socket.h>

int socket(
  int domain, /* AF_UNIX, AF_INET, etc. Network layer address family. */
  int type, /* SOCK_STREAM, SOCK_DGRAM */
  int protocal); /* usually 0 */
  // return fd if success, -1 on error
```

使用 `bind()` 将本地套接字地址和描述符绑定. *通常在服务器端调用.*

```c 
#include <sys/socket.h>
int bind(
    int socket_fd,
    const struct sockaddr *sa,
    socklen_t sa_len);
 /* Returns 0 if OK or -1 on error (sets errno) */

struct sockaddr {
  u_short sa_family;        /* type of address，2 bytes, UNIX field / IPv4 / IPv6 */
  char    sa_data[14];      /* value of address，14 bytes */
}
```

`struct sockaddr_in` 用于描述 IPv4 套接字地址, 是 `struct sockaddr` 的一个子类.

```c 
struct sockaddr_in {  //struct to hold an address
    sa_family_t sin_family;  //always AF_INET, 2 bytes
    in_port_t sin_port; //protocol port number: uint16_t, 2 bytes
    struct in_addr sin_addr; //IP address, 4 bytes
    char sin_zero[8];   //unused(set to zero), 8 bytes
};

struct in_addr {
  in_addr_t s_addr; // IPv4 address (uint32_t)
};
```

客户和服务器调用 `close()` 关闭套接字. 如果 fd 为 TCP 描述符则会向远程进程发送关闭连接的信息.

```c 
#include <unistd.h>

int close(int fd);
/* Return 0 if ok or -1 if error */
```

UDP 在设置完 fd 后可以直接用 fd 收发数据.

```c 
#include <sys/socket.h>
ssize_t sendto(
        int socket_fd,
        const void *buff,
        size_t nbytes,
        int flags, /* usually 0 */
        const struct sockaddr *to, 
        socklen_t *addrlen,
        );
/*Return number of bytes written if OK or -1 on error*/

ssize_t recvfrom(
        int socket_fd,
        void *buff,
        size_t nbytes,
        int flags, /* usually 0*/
        struct sockaddr *from, 
        socklen_t *addrlen,
        );
/*Return number of bytes read if OK or -1 on error*/
```

#image("imgs/udp.png") 

使用 TCP 时, 需要建立连接. 服务器维护多个套接字, 包括一个监听套接字和多个连接套接字. 服务器在监听套接字上等待客户的连接请求, 直到客户端调用 `connect()` 发起连接请求. 之后系统自动创建一个临时套接字 (连接套接字) 与客户进程通信. 

```c 
#include <sys/socket.h>

int connect(
  int socket_fd,
  const struct sockaddr *servaddr, 
  socklen_t *addrlen);
/* Return 0 or -1 on error */

int listen( // turn a socket into a passive socket, entering the listening state
  int socket_fd,
  int backlog); // maximum connection queue length
/* Returns 0 if OK or -1 on error */

int accept(
  int socket_fd,
  struct sockaddr *cliaddr,
  socklen_t *addrlen);
/* Return fd or -1 on error */
```

=== P2P

P2P 中每个实体都是对等实体 (peer). P2P 架构的上传 + 下载耗时低于 C/S 架构, 因为每个节点都提供了上传能力.

资源索引: 给定资源查询拥有资源的 peer.

中心化索引: 建立一个中心化服务器帮助检索. 每个 peer 需要连接中心化服务器告知自身 IP 地址和拥有内容. 每个 peer 进行查询时先查询中心化服务器. 中心化索引会带来单点故障问题和性能瓶颈.

解决方案: Query Flood (洪泛请求). 每个 peer 建立索引记录*自己*拥有的资源, peer 之间通过 TCP 连接形成一个图, 满足点度小于 10. 查询时采取 BFS.

混合方法: 建立超级节点, 超级节点之间使用去中心化索引, 普通节点和超级节点之间使用中心化索引.

Gnutella: 纯 P2P 的文件分发协议.

BitTorrent: 正在交换某个文件的 peer 组成一个 torrent (种子). 追踪器 (Tracker) 为一个独立服务器, 维护一个正在主动上传和下载该内容的所有其它对等用户列表. Peer 可以通过 Tracker 找到其它 peers. 文件被分为大小为 256Kb 的块. 一个 peer 加入 torrent 时向追踪器注册, 然后逐渐从其它 peers 获取文件块. 下载时 peers 彼此交换各自拥有的块清单 (同时交换邻居列表).

Skype: 基于 P2P 的即时通讯. 基于层次化结构的混合方法. 层次化结构可以避免普通节点之间无法直接进行连接.

区块链: 每个 peer 存储一部分数据并记录在区块上. 具有频繁写操作. 比特币协议每周期内产生一个区块, 由最早解决某个计算问题 (通常为对单向函数求逆) 获得写权力. 对于几乎同时产生的区块看各自获得认可 peers 人数.