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

匹配问题. 考虑判定二分图是否存在完美匹配, 在多项式环 $F[dots, x_(i,j), dots]$ 中求行列式 $det((x_(i,j)[(i, j) in E]))$, 则结果非零当且仅当存在完美匹配.

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

=== 概率方法

e.g. $R(k, k) > 2^(k/2)$.

e.g. 最大割 $>= |E|/2$.

e.g. 最大独立集 $>= sum_v 1/(deg_v + 1)$.

== lec04

=== Alternation

e.g. 定义 $c(G)$ 为图 $G = (V, E)$ 的最小交叉边数. 已知 $c(G) >= |E| - 3|V|.$ 改进 $c$ 的估计.

以 $p$ 的概率保留一个点. 我们有 $p^4 c(G) >= p^2|E| - 3p|V|$. 取适当的 $p$ 有 $c(G) >= (|E|^3) / (64 |V|^2)$.

e.g. 考虑 $n times n$ 方阵, 给定任意初始情形, 存在一种开关方式使得亮灯数 $approx (n^2)/2 + sqrt(1 / (2 pi)) n^(3/2)$.

如果纯随机期望是 $n^2/2$ 的. 我们随机按行的开关, 然后贪心地按列的开关. 在按完行的开关后, 每一列以高概率有 $Omega(sqrt(n))$ 的偏差. 然后用 Union bound.

e.g. 存在一个图, 它同时有高的 girth (最小圈)和高染色数.

染色数高可以转化为最大独立集小. 我们有两个约束: 不存在 $< l$ 的小圈, 以及不存在 $ > n/k$ 的独立集.

然而直接确定 $G(n, p)$ 中 $p$ 的范围是没前途的. 我们将第一个约束放松至 $< l$ 的小圈数量不超过 $n/2$.

=== 条件概率方法

e.g. 任意 3CNF $phi$ 都存在一个赋值使得至少 $7/8$ 的 clause 都能被满足.

有确定性的算法, 因为固定了一些赋值可以算出剩下期望有多少 clause 被满足.

== lec05

e.g. 存在 $sans("NC")^1$ 的单调多数决电路. (不含非门)

#let Maj = math.op("Maj")
#let Bern = math.op("Bern")
#let Var = math.op("Var")

可以用 $4$ 个 gate 构造一个 $Maj_3(x_1,x_2,x_3)$ 电路.

直观地, 如果 $X_i ~ Bern(p)$ 使得 $p$ 略大于 $1/2$, 可以通过一个 $Maj_3(X_1,X_2,X_3)$ 来放大 $p$.

考虑若干层的电路, 最底层是若干个 $Maj_3(x_i, x_j, x_k)$, $i, j, k$ 随机选取. 设第 $i$ 层输出 $1$ 的概率是 $p_i$, 则 $p_(i+1) = p_i^2 (3-2p_i)$. 可以发现这个东西是平方收敛的.

=== 二阶矩方法

Chebychev 不等式: $Pr[|X - E[X]| >= a] <= (Var[X] / a^2)$.

这被广泛用于研究 phase transition 现象: 设一个随机事件被概率 $p$ 参数化, 存在一个(一些) $f(n)$ 使得 $p >> f(n)$ 时, 该事件几乎一定发生; 当 $p << f(n)$ 时, 该事件几乎一定不发生. (在一些假设下我们能证明这种 $f$ 是普遍存在的.)

一个对方差的常见估计是 $Var[X] <= EE[X]$, $X$ 是 01 变量.

下面讨论这种做法什么时候有效. 使用 Chebychev 不等式的时候, 分子 $Var[sum X_i] approx sum EE[X_i] + 2sum_(i<j) EE[X_i X_j]$, 分母是 $(sum EE[X_i])^2$. 每一项都近似 $n^i p^j$. 这一定程度上衡量了一个子图的"密度": $j$ 越高越稠密, $i$ 越高越稀疏.

如果有 $Var[sum X_i] = o(1)$, 则协方差部分, 也就是两个结构交出来的部分, 必须比原图更稀疏(这样并起来才更稠密). 风筝形状就不满足这个条件.

== lec06

=== Pairwise ($k$-wise) independence

我们进行分析的时候常常假设一些随机变量是互相独立的, 但是这个假设太强了. 很多时候 $2$-wise 或 $k$-wise 就够了.

e.g. 假设算法在 $x in L$ 的时候以 $1/2$ 概率输出 Yes, 在 $x in.not L$ 的时候必然输出 No. 重复运行 $T$ 次以提高正确率.

满足互相独立的时候我们可以将错误率降到 $1/(2^T)$. 假设只有两两独立. 我们运行第 $t$ 次输出 $I_t in {0, 1}$. 犯错意味着 $sum I_t = 0$ 但 $x in L$, 这可以用 Chebychev 不等式分析, $Var[sum I_t] = sum Var[I_t] = T/4$, 偏差概率不超过 $(T/4) / ((T/2)^2) = 1/T$.

单次需要 $m$ 个随机 bit 运行 $T$ 次需要 $m T$ 个 bit. 我们想砍掉 $T$ 使得两两独立依然成立.

可以考虑 $FF_p$ 下两两不同的线性组合.

=== 去随机化

考虑之前估计 Ramsey Number 下界时候的证明. 我们只用到了 $binom(k, 2)$-wise independence. 可以并行枚举随机种子, 总共 $q^(O(k^2))$ 种.

== lec07

=== Universal Hashing

问题: 考虑逐个加入一些数, 判断一个数是否出现过.

考虑将这些数压缩到一些较小的数. 注意我们认为输入是固定且 adversary 的. 那么可以取一个 $FF_q$, 然后考虑上次的 $h_(a,b)(x)$.

(我们必须保证输入嵌入到 $FF_q$ 之后两两不同, 这要求 $q$ 充分大, 但是对这个问题太大的值域是没有意义的, 所以需要在 $FF_q$ 之内对另一个小的模数 $m << q$ 取模. 可以让 $q = p^k, m = p$ 之类的. 假设 $m$ 不整除 $q$ 就可能不完全均衡.)

=== FKS Hashing

静态集合查询问题. 考虑一个集合 $S$, 其中的数可能很大, 需要 $O(1)$ 判定一个数是否在 $S$ 内, 空间 $O(|S|)$. (我们认为一个数的空间是 $O(1)$ 的.) 如果数本身是 $O(|S|)$ 的, 就可以用一个 bool 数组.

设哈希值域为 $T$, $H = {h: U -> T}$ 为哈希函数. 如果 $|T| = Omega(|S|^2)$, 那么按照之前的方案随机采样就可以找到没有碰撞的 $h$.

现在要求 $|T| = O(|S|)$. 先构造 $h: S -> T$, 设 $b_x = |h^(-1)(x)|$. 我们可以把 $h^(-1)(x)$ 中的元素映射到一个大小为 $Omega(b_x^2)$ 的集合. 我们期望 $sum_x b_x^2 = O(|S|)$. 根据 universal hashing 的性质, 这件事情是对的.

=== Monte-Carlo

考虑给定 $Var[X] = sigma^2$ 情况下对 $mu$ 进行估计, 不能直接用 Chernoff bound 等方法(矩函数要求 $X$ 有界).

取 $T = Theta((sigma / mu)^2 (1 / epsilon^2) log(1/delta))$, 用二阶矩方法可以推出 $Pr[|overline(h)(X) - mu| >= epsilon mu] = O(1 / log(1/delta))$.

考虑 $2k+1$ 个小组, 每个小组取平均再对这些小组求中位数. 假设一个小组以至少 $3/4$ 的概率落在 $[mu - simga, mu + sigma]$ 内, 每个小组的大小是 $O(sigma^2 / (epsilon^2 mu^2))$. 令 $k = Theta(log (1 / delta))$ 可以保证出问题的概率 $< delta$.