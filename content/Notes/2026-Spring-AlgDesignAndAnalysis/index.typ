#import "../index.typ": template, tufted

#show: template.with(
  title: "算法设计与分析",
  description: "2026 Spring",
  date: datetime(year: 2026, month: 3, day: 2),
  lang: "zh",
)

= 算法设计与分析

== Ch01 导论

一个邻项微扰的例子(最小等待总时间).

各种排序算法的复杂度.

问题: 包含参数, 一个**实例**是对参数的赋值.

稳定婚姻问题.

区间调度问题: 最大不交区间子集.

摆了.

== Ch02 渐进分析

=== 解递推方程

对递归树的每一层算贡献.

假设猜想 $T(n) = O(f(n))$, 可以试着猜测 $T(n) <= c dot f(n)$, 然后归纳证明这个式子.

但是存在一种可能, 即这个假设不够强, 导致归纳的过程进行不下去.

改为猜测 $T(n) <= c_1 f(n) - c_2 g(n)$, 其中 $g(n) = o(f(n))$.

**主定理**. 考虑一类递推式 $T(n) = a T(n / b) + f(n)$. 建出递归树后, 深度为 $k = log_b n$, 叶子数为 $n^(log_b a)$. 于是 $ T(n) = Theta(n^(log_b a)) + sum_(j = 0)^(k - 1) a^j f(n / (b^j)). $

如果 $f(n) = O(n^(log_b a - epsilon))$, 代入上式得到的等比数列求和后的结果是 $O(n^(log_b a))$, 于是 $T(n) = Theta(n^(log_b a))$.

如果 $f(n) = Theta(n^(log_b a) log^k n)$, 等比数列的各项为 $Theta(n^(log_b a) log^k (n / 2^j))$, 于是 $T(n) = Theta(n^(log_b a) log^(k + 1) n)$.

如果 $f(n) = Omega(n^(log_b a + epsilon))$, 需要给出额外的正则性条件 $a f(n / b) <= c f(n)$, 对充分大的 $n$, 其中 $c < 1$. 此时 $T(n) = Theta(f(n))$.