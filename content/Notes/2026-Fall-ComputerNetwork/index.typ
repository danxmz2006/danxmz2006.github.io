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

== Ch02 Application Layer

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

分布式哈希表. 需要管理 key->peer 映射, 处理 peer 的加入和退出. 

=== 流媒体

连续媒体经过处理发送给接收方, 并进行重组, 解码和播放.

流媒体具有端到端性能约束, 要求满足时序性, 允许一定容错. 流媒体服务包括媒体点播, 媒体直播和实时交互等.

媒体点播: 客户端浏览器先通过 HTTP GET 获取元文件 (有音/视频文件的统一资源 URL), 在将元文件提供给媒体服务器要求下载音/视频文件. 为了应对抖动, 接收端经过缓存后再以恒定速率播放.

流媒体服务采取特殊协议, 例如 RTP/RTCP (传输层), RTSP (应用层, 时令协议).

RTP 和 RTCP 是最基础的流媒体协议. RTP 使用 UDP, 提供端到端的数据传输 (未提供服务质量保证). RTCP 是与 RTP 配合的辅助控制协议, 使用 UDP.

RTSP: 实时流式协议. 本身不传输数据, 是一个多媒体服务控制协议, 对*播放状态*进行控制, 使用 UDP 或 TCP.

#image("imgs/RTSP.png")

RTMP: 由 Adobe 开发, 最初用于 Flash 媒体传输.

最新流媒体技术使用 WebRTC 和基于 HTTP 的流媒体.

WebRTC: 网页实时通信. 实现浏览器之间点对点的连接. 基于 UDP. SRTP 和 SRTCP 是对媒体数据的封装和传输控制协议.

== Ch03 Transport Layer

基于网络层的服务向不同主机上的应用程序提供通信服务. 传输层和应用层间的接口为*套接字*.

网络层不会对终端间的交互提供任何承诺. 传输层可以提供可靠, 按序保证.

典型传输层协议包括 TCP 和 UDP. UDP 基于*数据报 (datagram)*, 应用层需要处理报文边界, 提供报文检错(而可选). TCP 以字节流的形式发送, 接收数据, 提供可靠数据传输, 流量控制, 拥塞控制.

TCP/UDP 报文段包括源和目的端口号. 端口号分为一般的端口号和保留端口号 (0-1023).

UDP 和 TCP 基于*多路复用 (multiplexing)* 和*分用 (demultiplexing)* 进行进程-进程数据交付.

UDP 套接字使用 IP 地址 + 端口号二元组进行标识. 接收方传输层收到 UDP 报文段后将其交付具有目的端口号的套接字.

TCP 为了同时服务多个客户, 使用两种套接字. 
- 监听套接字: 服务器监听客户的连接请求. 具有众所周知的端口号.
- 连接套接字: 收到连接请求后创建, 使用原监听端口号. 每个连接套接字只和一个客户通信.

=== UDP

UDP 完成基本的复用和分用.

```
      +-----------------------------------------------------+
      |              32-bit source IP address               |
      +-----------------------------------------------------+
      |            32-bit destination IP address            |
      +---------------------------+-------------------------+
      | 0 |  8-bit protocal(=17)  | 16-bit UDP total length |
      +------------------------+--+-------------------------+
      |  source port address   |  destination port address  |
      +------------------------+----------------------------+
      |   UDP total length     |       16-bit checksum      |
      +------------------------+----------------------------+
      |                                                     |
      |                      Data                           |
      |                                                     |
      +-----------------------------------------------------+
```

前三行被称为伪头 (pseudo-header), 并不进行传输. 后二行为 UDP 头. Checksum (校验和) 的计算分为这三个部分 (将 checksum 置为 0); 计算方法为对一系列 16 位数求和, 每次如果相加结果最高位为 1 则将 1 加到最低位, 最终对结果取反. 若结果为 `0xffff` 认为没有错误.

=== TCP

TCP 需要实现点对点通信, 全双工, 可靠, 有序的字节流. 需要建立连接, *可靠传输*, 流量控制, 拥塞控制.

不可靠信道会带来数据损坏, 数据丢失和乱序的问题. (不考虑恶意攻击的场景.)

可靠性机制是分布式算法, 用 FSM 表示. 称可靠传输协议的发送方为 `rdt_send()` (由上层调用), 接收方为 `rdt_rcv()` (由下层不可靠信道调用), `udt_send()` 和 `deliver_data()` 由可靠传输协议调用.

场景 1. 无错误和丢包. 乌托邦协议.

#image("imgs/utopian.png")

场景 2. 有错但不丢包. 错误可以被校验检测.

自动重传请求: 接收方检测到错误后反馈, 发送方重传. rdt 2.0 协议返回 ACK 或 NAK, 为所谓的*停-等式协议*. 

#image("imgs/rdt2-0.png")

该协议的问题在于 ACK 或 NAK 也可能出错. 可以考虑更复杂的纠错方式, 但是会增加开销. 通常会考虑让发送方直接重传 (接收方会接受多份数据). 发送方会给数据包加上序号 Seq, 区分不同数据包; 接收方会忽略序号重复的数据包. 停等协议下只需区分当前数据包是否是前一次的重传, 因此 Seq 只需 1bit.

#image("imgs/rdt2-1.png")

#image("imgs/rdt2-1recv.png")

rdt 2.2 中在 ACK 中加上最近接收的 Seq, 这样就不需要 NAK.

#image("imgs/rdt2-2.png")

#image("imgs/rdt2-2recv.png")

场景 3. 信道可能出错, 可能丢失数据包. 不考虑乱序.

rdt 3.0 发送方增加一个计时器, 如果经过一段时间没有确认将超时, 于是再次发送数据包.

#image("imgs/rdt3-0.png")

设数据大小为 $F "b"$, 发送速率为 $R "b"\/"s"$, 信道传输延迟 $I$, 往返延迟 $R T T = 2 I$. 停等协议的工作时间为 $F\/R$, 空闲时间是 $R T T$, 信道利用率是 $F \/ (F + R dot.c R T T)$.

停等式协议无法使数据填满带宽, 多数时间耗费在延迟上面.

流水线协议允许发送方在没收到确认前连续发送多个数据包. $N$-数据包流水线的利用率为 $(N F\/ R) / (R T T + F\/R)$.

限制最多有 $N$ 个未确认数据包的机制又称为滑动窗口机制. 接收 + 反馈处理可以分为回退 N (GBN) 或者选择重传 (SR).

回退 N: 接收方收到出错/乱序报文后丢弃并不发送确认, 发送端超时后重传所有未被确认的报文. 

#image("imgs/gbn.png")

#image("imgs/gbnrecv.png")

选择重传: 接收方独立确认每个数据包. 若发送方发出若干连续的若干包后, 收到某一包的 ACK 错误, 或某一方的定时器超时, 则只重传该出错或超时的数据包. 发送方需要对每个包维护计时器.

#image("imgs/sr.png")

#image("imgs/srevents.png")

注意发送方和接收方的窗口不一定相同. `recvbase` 最极端情况下会比 `sendbase` 大 N (窗口长度), 因此窗口大小不能超过 seq 取值空间的一半, 否则无法区分下一个包和重传的包.

上面考虑的是*一般*的可靠性方案. TCP 在不可靠的 IP 服务上建立可靠的数据传输, 与上述机制不同的是其对字节建立序号, 而非报文. 每个主机*都*会捎带一个 ACK 值, 表示下一个期望的字节序号. 协议未对乱序处理做出明确规定, 可以接收端缓存/不缓存.

#image("imgs/tcpeg.png")

下述简化的 TCP 协议仅对最早的未确认报文使用重传定时器, 仅在超时后重发最早未确认的报文段; 接收方采取累积确认, 仅在正确, 按序收到报文段后更新确认序号; 其余情况重复前一次的确认序号. 缓存失序的报文段. 这种机制避免了超时设置过小导致大量的重传, 可以避免重发某些丢失了 ACK 的报文段.

由于 RTT 是动态变化的, 需要不断采样 (SampleRTT) 并更新估计 (EstimatedRTT). 同时瞬时 RTT 和平均 RTT 之间有很大的误差, 实际设计的超时值是估计 RTT 加上 4 倍的估计偏差.

由于重传的报文段采取的是与原报文段相同的序号, 发送端确认后无法得知是对哪个报文段进行的确认, 这回给测量 SampleRTT 带来数倍的误差. 一种方法是只对第一次发送成功的报文段测量 SampleRTT.

Karn 算法结合使用 RTT 估计值和定时器补偿策略. 其使用 EstimatedRTT 估计初始的超时值, 发生超时后每次重传时对定时器进行补偿 (超时值加倍), 直到成功传输一个报文段. 若收到上层应用程序或某个报文段没有重传就被确认, 用最近的 EstimatedRTT 估计超时值.

快速重传: 多个重复序号 ACK 极有可能因丢包产生, 因此在定时器到期前重传.

TCP 接收端可以采用推迟确认的策略, 即在收到若干个报文段后发送一个累积确认的报文段. 但是推迟时间不能过大 (限制最多为 500ms), 至少每隔一个报文段使用正常方式进行确认.