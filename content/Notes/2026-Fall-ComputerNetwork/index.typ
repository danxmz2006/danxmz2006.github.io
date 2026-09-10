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