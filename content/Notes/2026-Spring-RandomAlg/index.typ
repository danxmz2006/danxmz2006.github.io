#import "../index.typ": template, tufted

#show: template.with(
  title: "随机算法",
  description: "2026 Spring",
  date: datetime(year: 2026, month: 3, day: 2),
  lang: "zh",
)

#set math.equation(numbering: none)

= 随机算法

== lec01

所谓*随机算法*可以被视为一个 TM 的变种, 额外地接受了一些随机 bit 作为输入.

对于判定性问题, 根据假阳性/假阴性可以被分为 two-sided, one-sided 和 zero-sided error.

=== 验证矩阵乘法

为了验证矩阵乘法 $A B = C$ 的正确性, 可以随机选取一个向量 $x$ 验证 $A ( B x ) = C x$. 这是 one-sided 的, 如果 $A B eq.not C$ 错误率不超过 $1 / q$ (假设我们在一个大小为 $q$ 的有限域中运算).

=== 验证结合律

#let smallcirc = math.class("binary", math.circle.small)

考虑在大小为 $n$ 的集合上定义的一种乘法运算 $\_ smallcirc \_$, 以乘法表给出. 我们需要以 $o(n^3)$ 的复杂度判断该运算是否满足结合律.

注意到可以构造出方案使得只有 $O(1)$ 个错误: 取 $a smallcirc b = min(a, b)$, 但是适当修改 $a, b$ 在 ${n, n - 1}$ 中的结果.	

考虑一类"形式和" $sum_a s_a a$, 用如下方式定义乘法: $ (sum_a s_a a) smallcirc (sum_a t_a a) = sum_(a,b) s_a t_b (a smallcirc b). $ 

那么考虑计算 $sum_a r_a a, sum_a s_a a, sum_a t_a a$ 乘起来的两种顺序, 视结果的系数为 $F[r_1, dots, r_n, s_1, dots, s_n, t_1, dots, t_n]$ 中的元素, 则两个结果相等当且仅当对于所有 $a,b,c$ 有 $(a smallcirc b) smallcirc c = a smallcirc (b smallcirc c)$. 令 $F = G F(q)$ 采样, 根据 Schwartz-Zippel 引理错误率为 $O(1/q)$.

== lec02

=== Polynomial Identity Testing

下面分析 $f in F[X_1, X_2, dots, X_n]$ 的根的个数.

Schwartz-Zippel 引理. 设 $X_i$ 在有限集 $S$ 中随机取值 $deg(f) = d$, 则 $Pr[f(X_1, X_2, dots, X_n) = 0] <= d / (|S|)$.

对变量个数归纳. 单变量的情形即代数基本定理.

将 $f$ 视同 $F[X_2, X_3, dots, X_n][X_1]$. 设其最高次项为 $g(X_1, X_2, dots, X_n) X_1^k$, 那么以至少 $1 - (d-k) / abs(S)$ 的概率, $g eq.not 0$; 在此基础上, 以至少 $1 - k / abs(S)$ 的概率, $f(X_1) eq.not 0$. 所以 $Pr[f eq.not 0] >= (1 - (d-k) / abs(S))(1 - k / abs(S)) >= 1 - d / abs(S)$.

上述分析适用于 $F$ 充分大的情况. 如果 $F$ 自身很小, 只要单一变量的次数不是很大, 还是可以控制相应的概率.

Tutte 矩阵. 考虑判定二分图是否存在完美匹配, 在多项式环 $F[dots, x_(i,j), dots]$ 中求行列式 $det((x_(i,j)[(i, j) in E]))$, 则结果非零当且仅当存在完美匹配.

现在我们要并行求出匹配. 假设有了一个对边权赋值的方案 $w_(i,j)$ 使得存在*唯一的*最小完美匹配, 那么利用 $det((2^(w_(i,j))))$ 可以求出最小完美匹配, 且删去该匹配中的一条边后还有唯一的最小完美匹配. 另一方面, 如果一条边不在最小完美匹配中, 那么其余子式中 2 的指数不会小于删去该边后的最小完美匹配, 因此不会将边加入匹配. 因此可以判定一条边是否在最小完美匹配中.

计算行列式过程中出现的数可能很大, 但这无关宏旨, 代数运算电路深度是 $O(log n)$ 的.

下面证明 $w_(i, j) ~ "Unif"(S)$ 的时候, 以至少 $(|S| - 1)^(|E|) / (|S|^(|E|)) >= 1 - (|E|)/(|S|)$ 的概率存在最小完美匹配. 这是因为可以先让 $w_(i, j)$ 在 $[2, abs(S)]$ 中取值, 再任意取一个最小完美匹配将边权全部减 1.

== lec03

=== Fingerprinting

判定两个长 01 串是否相等. 在 $[T]$ 内随机选取一个素数 $P$, 判断是否有 $x mod P = y mod P$. 由于 $x - y$ 的素因子不超过 $n$ 个, 错误概率不超过 $n / pi(T)$.

判断短序列是否是长序列的一部分. 上述做法加上滑动窗口.

=== 素数判定

仅仅用 Fermat 小定理是不够的, 存在 Carmichael 数: 所有和合数 $n$ 互素的数 $a$ 都满足 $a^(n-1) equiv 1 (mod n)$. 假设某个合数不是 Carmichael 数，那么满足 $a^(n-1) equiv 1$ 的数不会很多: 这样的数构成简化剩余系的**真**子群, 因此至多只有一半.

素数满足 $a^2 equiv 1 => a equiv plus.minus 1$. 随机找一个 $a in [n-1]$, 从 $a^((n-1) / 2^m)$ 开始每次平方, 遇到 $x equiv.not plus.minus 1, x^2 equiv 1$ 的时候返回假. 这里 $n - 1 = 2^m dot (2t + 1)$. 可以发现通过当且仅当 $a^(2t+1) equiv 1 (mod n)$ 或 $a^(2^k (2t+1)) equiv -1 (mod n)$. 

下面分析一个弱化版本: 假设 $n$ 不是质数的幂. 令 $k^ast$ 为最大的 $k < m$ 使得存在 $a_0^(2^k (2t+1)) equiv -1 (mod n)$. 则 $S = {a^(2^k (2t+1)) equiv plus.minus 1}$ 构成乘法群, 其为 $mod n$ 简化剩余系的子群. 实际上是真子群: 设 $n = n_1 n_2$, $n_1, n_2$ 互质, 取 $x equiv a_0 (mod n_1)$, $x equiv 1 (mod n_2)$ #footnote[依中国剩余定理.] 那么一定有 $x in.not S$, 因为大模数可以控制小模数.