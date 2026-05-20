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

仅仅用 Fermat 小定理是不够的, 存在 Carmichael 数: 所有和合数 $n$ 互素的数 $a$ 都满足 $a^(n-1) equiv 1 (mod n)$. 假设某个合数不是 Carmichael 数，那么满足 $a^(n-1) equiv 1$ 的数不会很多: 这样的数构成简化剩余系的*真*子群, 因此至多只有一半.

素数满足 $a^2 equiv 1 => a equiv plus.minus 1$. 随机找一个 $a in [n-1]$, 从 $a^((n-1) / 2^m)$ 开始每次平方, 遇到 $x equiv.not plus.minus 1, x^2 equiv 1$ 的时候返回假. 这里 $n - 1 = 2^m dot (2t + 1)$. 可以发现通过当且仅当 $a^(2t+1) equiv 1 (mod n)$ 或 $a^(2^k (2t+1)) equiv -1 (mod n)$. 

下面分析一个弱化版本: 假设 $n$ 不是质数的幂. 令 $k^ast$ 为最大的 $k < m$ 使得存在 $a_0^(2^k (2t+1)) equiv -1 (mod n)$. 则 $S = {a^(2^k (2t+1)) equiv plus.minus 1}$ 构成乘法群, 其为 $mod n$ 简化剩余系的子群. 实际上是真子群: 设 $n = n_1 n_2$, $n_1, n_2$ 互质, 取 $x equiv a_0 (mod n_1)$, $x equiv 1 (mod n_2)$ #footnote[依中国剩余定理.] 那么一定有 $x in.not S$, 因为大模数可以控制小模数.

=== 概率方法

e.g. $R(k, k) > 2^(k/2)$.

e.g. 最大割 $>= (|E|)/2$.

e.g. 最大独立集 $>= sum_v 1/(deg_v + 1)$.

== lec04

=== Alteration

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

考虑 $2k+1$ 个小组, 每个小组取平均再对这些小组求中位数. 假设一个小组以至少 $3/4$ 的概率落在 $[mu - sigma, mu + sigma]$ 内, 每个小组的大小是 $O(sigma^2 / (epsilon^2 mu^2))$. 令 $k = Theta(log (1 / delta))$ 可以保证出问题的概率 $< delta$.

== lec08

=== Counting DNF

这里 DNF 指的是满足 $(X_1 and X_2 and dots.c and X_k) or (Y_1 and Y_2 and dots.c ) or dots.c$ 的 赋值. 设各个 clause 的满足集合是 $A_i$.

一个 naive 的想法是直接在所有赋值里抽样, 但是这个误差系数乘在了 $2^n$ 上, 而 $|union.big A_i|$ 可能远小于这个值.

我们有 $|union.big_i A_i| = sum_i |A_i inter (inter.big_(j < i) overline(A_j))|$. 如此一来误差系数乘在了 $|A_i|$ 上, 而这不超过真实的答案.

一个类似的描述是: 先正比于 $|A_k|$ 的概率抽 $A_k$, 再在 $A_k$ 中抽一个元素 $x$ 看是否 $x in.not A_j(j < k)$.

注意 counting CNF 是不可做的 (SAT 是 \#P-complete 的).

=== Network Reliability

连通图 $G = (V, E)$ 每条边以 $p$ 的概率断开. 求 $G$ 不连通的概率. 需要复杂度是 $p o l y(n, 1/epsilon)$.

朴素 Monte-Carlo 算法有什么问题? 假设最小割 $c$ 很小, 这样做并没有什么问题, 此时 $p_("fail") >= p^c >= 1 / (n^4)$.

假设 $p$ 充分小. 类似 counting DNF, 我们将所有 cut 排成一列. 所有割可以看成全体 $(V^prime, V backslash V^prime)$ 之间的割取并集.

然而这里的问题是割很多. 我们有一个非常聪明的想法: 一个大割 fail 的概率很小; 小割的数量不多.

*Lemma.* 最小割的数量不超过 $binom(n, 2)$. 更一般地, 最多有 $n^(2 alpha)$ 个大小 $< alpha c$ 的割.

*Proof.* 考虑如下随机过程: 每次选一条没选过的边, 将其连接的两个点合并. 剩下 2 个点的时候输出其间的所有重边. 容易看出这确实构成原图的割. #tufted.margin-note[注意 $G$ 是连通的, 因此缩边之后依然连通. 我们实际上只用考虑删去后恰好剩下两个连通块的割. 对于这些割而言, 一旦上述过程中割内的边被保留下来, 则一定只有这些边被保留, 否则删去这些边后图依然是连通的.]

已知最小割为大小 $c$, 固定一个大小为 $c$ 的割, 输出它的概率如何? 首先注意到, 考虑某一时刻(缩点后)一个点的度数, 其有下界 $c$, 因此此时非自环的边数不低于 $(|V^prime| c) / 2$. 因此一个大小不超过 $c$ 的割内的边自始至终未被选的概率有下界
$ product_(2 < k <= n) (1 - (2 c) / (k c)) = 2 / (n (n-1)). $

$alpha > 1$ 的情况怎么处理? 此时, 我们不能缩到 2 个点, 因为 $(2 alpha) / k$ 可能比 1 大. 令 $t = ceil(2 alpha)$. 我们缩到恰好剩下 $t$ 个点, 再在不超过 $2^(t-1)$ 个割中随机抽一个. 一个大小不超过 $alpha c$ 的割最终被抽到的概率有下界
$ 1 / (2^(t-1) binom(n, t)). $ 因此, 大小为 $alpha c$ 的割的数量有上界 $n^(2 alpha)$ (我们只用到 $alpha in ZZ$ 的情况.)

因此, 固定一个参数 $alpha$, 我们可以用上述做法随机抽样, 知道抽出所有的小割; 大割 fail 的概率不超过 $ sum_(k >= alpha) (n^2 p^c)^k < epsilon p^c <= epsilon p_("fail"). $ 计算可知 $n^alpha = p o l y(1 / epsilon)$ 所以这个算法是 $p o l y(n, 1 / epsilon)$ 的.

== lec09

=== Chernoff Bound

互相独立条件可以放宽成 $k$-wise 独立, 求和可以放宽成 Lipschitz 连续的多元函数, 有界是必要的.

加性的结论称为 Hoeffding 不等式. 设 $X_1, X_2, dots.c, X_n$ 为独立的 01 变量, $X_i ~ "Bern"(p_i), X = sum_i X_i$, $p = 1/n sum p_i$. 有 $Pr[X >= EE[X] + n epsilon] <= exp(-n D(p + epsilon || p)) <= exp(-2n epsilon^2).$

我们还有乘性的结论, 这被称作 multiplicative Chernoff bound. 设 $mu = n p, lambda = beta mu = beta n p$, 有
$ Pr[X <= (1 - beta) mu] <= exp(-n D(1 - p + beta p || 1 - p)) <= exp(- (mu beta^2) / 2). $

中途用到了 $(1 - x) ln (1 - x) >= -x + x^2 / 2.$

类似地, $ Pr[X >= (1 + beta) mu] <= exp(-mu (-beta + (1 + beta) ln (1 + beta))) <= cases(exp(-(beta^2 mu)/(2+beta)) quad beta > 0, exp(-(beta^2 mu) / 3) quad 0 < beta <= 1). $

=== Randomized Routing

设 $pi$ 是超立方体 ${0, 1}^n$ 上的排列. 对某个 $i$ 需要将数据从 $i$ 运到 $pi(i)$. 同时刻不能占据同一条边. 最小化运输所有数据需要的时间.

考虑对所有 $i$ 抽一个中点, 将路径拆成 $i arrow.r.squiggly delta(i) arrow.r.squiggly pi(i)$. 每次翻一个和目标不同的位, 有冲突就先翻优先的 $i$. 我们说明期望总花费时间是 $O(n)$ 的.

考虑所有的路径 $P_i = i arrow.r.squiggly delta(i)$. 设 $S_i = {j | P_i inter P_j eq.not emptyset, j > i}$. 注意 $P_i inter P_j$ 一定是一条路径. 设 $D_i$ 为 $i$ 堵塞的时刻集合. 我们证明对每个 $i$, 存在单射 $phi_i : D_i arrow.r.hook S_i$.

考虑如下过程. 维护一些赋值 $c_x, x in S_i$. 每当 $i$ 和 $x$ 相遇, 取最大的 $x$, 令 $c_x <- c_x + 1$. 假设某 $x < y$ 在 $P_i$ 上相遇, 令 $c_y <- c_y + c_x, c_x <- 0.$

我们说明任何时刻 $c_x <= 1$. 考虑追踪一个 1 的流动, 我们发现它永远不会停滞. 另一方面, 当一个新的 1 产生的时候, 原本路径上的 1 一定移动至路径上后面的位置, 因此不同的 1 一定不会同时到达同一个点.

最终, ${x | c_x = 1}$ 构成了 $phi_i$ 的像集.

设 $I_(i j) = [P_i inter P_j != emptyset].$ 注意固定 $i$, 不同 $I_(i j)$ 是互相独立的, 因为它们只取决于 $delta(j)$ 的取值.

估计 $EE[sum_j I_(i j)]$, 对每条有向边计算贡献, 贡献为出现在路径中的概率 $times$ 期望有多少 $j -> delta(j)$ 经过该有向边. 然而根据对称性, 后者是一个定值. 对所有边出现在路径中的概率求和即路径长度期望, 即 $n / 2$. 因此, $ EE[sum_j I_(i j)] <= n / 2 (2^n n/2) / (2^n n) = n / 4$. 以高概率 $sum_j I_(i j) <= O(n)$ #footnote[Multiplicative Chernoff bound.], 之后用 union bound. 
这里有个小问题是我们有 $Pr[|S_i| >= (1 + beta) mu] <= exp(-Omega(beta^2)mu)$, $mu$ 可能比较小. 但是固定 $(1 + beta) mu$ 之后, 上述界在 $mu$ 最大的时候是最优的.

== lec10 

=== 随机图的 Hamilton 圈

设随机图 $G(n, p), p >= (72 ln n) / (n - 1)$. 存在随机算法高概率找到一个 Hamilton 圈.

考虑随机扩展路径. 每次在端点中随机选一个, 假设抽到了已经访问过的点就在分叉处切换.

我们希望以一个端点出发选到任何一个其它的点的概率都相同. 注意这里我们将随机图的分布视为分布的一部分, 然而执行算法的过程中, 随机图被视为固定的. 因此我们需要调整条件概率使得在乘上随机图的分布后得到的东西可以视为每次在剩下 $n-1$ 个点中均匀随机选一个.

假设某一时刻 Hamilton 链的结尾是 $x$, $N(x)$ 是与 $x$ 相邻的点的集合, $O L D(x)$ 是过去 $x$ 选择过的集合. 我们有 $O L D(x) subset N(x)$.

我们以 $abs(O L D(x)) / (n - 1)$ 的概率在 $O L D(x)$ 中均匀随机选择一个点, 以 $1 - abs(O L D(x)) / (n - 1)$ 的概率在 $N(x) backslash O L D(x)$ 中均与随机选择一个点. 假设 $N(x) = O L D(x)$, 我们触发一个失败事件. 

这里就会出现一个问题: $O L D(x)$ 之外的点未必是对称的, 因为对于不同的 $y$, $(x,y)$ 连边情况并不相同, 因此不同点的选择不是独立的. 

我们用有向边替代无向边. 假设有无向边 $u, v$, 以 $p/4$ 的概率有边 $u <-> v$, 以 $1/2 - p/4$ 的概率有边 $u -> v$, 以 $1/2 - p/4$ 的概率有边 $v -> u$, 以 $p/4$ 的概率无边. #footnote[这里取值相对随意.] 容易验证 $u->v$, $v->u$ 是独立的. 我们在没有增加可达性的情况下增加了随机源.

需要估计 $N(x) = O L D(x)$ 的概率. 首先, 根据 coupon collector 的结论, 经过 $2 (n - 1) ln(n - 1)$ 次操作后以高概率路径包括所有的点; 其二, 同样根据 coupon collector, 之后的 $2 (n - 1) ln (n - 1)$ 以高概率每个点都被作为过路径的端点, 因此能找到 Hamilton 圈. 现在需要说明在 $4 (n - 1) ln (n - 1)$ 次操作内坏事件大概率不发生.

+ 对于 $x$, $Pr[abs(N(x)) <= 24 ln n] <= 1 / n^2$. 这是由于 $abs(N(x)) ~ B(n - 1, p/2), EE[N(x)] = 36 ln n.$ 由 Chernoff bound 得到 $Pr[abs(N(x)) <= 24 ln n] <= 1/n^2$.

+ 假设 $abs(N(x)) >= 24 ln n$. 注意到 $abs(O L D(x))$ 被 $B(4 (n - 1) ln (n - 1), 1 / (n - 1))$ 控制, 其期望 $mu = 4 ln (n - 1)$, 同理可证 $Pr[abs(O L D(x)) >= 24 ln n] = Pr[abs(O L D(x)) >= (1 + 5) mu] <= 1 / n^2$.

最后用 union bound 即可.

== lec11

=== Balls and Bins

将 $m$ 个球放入 $n$ 个桶, 分析最大负载量.

相对困难的一个方向是控制最大负载量的下界.

#show sym.prec.eq: math.scripts
#show sym.succ.eq: math.scripts
#show sym.prec: math.scripts
#show sym.succ: math.scripts

*Stochastic Dominance.* 若 $forall c in RR, Pr[X >= c] >= Pr[Y >= c]$, 记 $X succ.eq_1 Y$. 若 $X succ.eq_1 Y, X' succ.eq_1 Y'$, $X,X'$ 独立, $Y,Y'$ 独立, 则 $X + X' succ.eq_1 Y + X' succ.eq_1 Y + Y'$. 

*Lemma.* 设 $Y_i ~ pi(m / n)$ 独立, 则 $Pr[X_1 = c_1, X_2 = c_2, dots.c] = Pr[Y_1 = c_1, Y_2 = c_2, dots.c | sum_i Y_i = m]$.

下面证明 $Pr[forall i, X_i <= c] <= O(1) dot.c Pr[forall i, Y_i <= c]$

$ Pr[forall i, Y_i <= c] &= sum_k Pr[forall i, Y_i <= c | sum_i Y_i = k] \
  & >= sum_(k <= m) Pr[forall i, Y_i <= c | sum_i Y_i = k] Pr[sum_i Y_i = k] \
  & >= Pr[forall i, Y_i <= c | sum_i Y_i = k] Pr[sum_i Y_i <= m] = O(1) Pr[forall i, X_i <= c]. $

=== Power of Two Choices

$m$ 个球, $n$ 个桶, 每次扔球的时候随机选两个桶将球放入较少的桶内. 证明 $m = n$ 时最大负载量高概率不超过 $(ln ln n) / (ln 2) + Theta(1).$

设 $B_i$ 表示最终装了至少 $i$ 个球的桶的数量. 我们归纳地证明以高概率 $B_i <= beta_i$.

#tufted.margin-note[ 这里的想法是一个新的球丢入 $>= i$ 桶的概率不超过 $(beta_i / n)^2$. 粗略地看, $B_(i+1) prec.eq_1 B(n, (beta_i / n)^2)$, 因此我们可以有 $beta_(i+1) = c beta_i^2 / n$. 当 $i approx (ln ln n) / (ln 2)$ 时 $beta_i < 1$. ]

我们先稍稍推广 Stochastic Dominance. 对于非负序列 $f,g$, 定义 $f prec.eq_R g$ 当且仅当 $forall n, sum_(k >= n) f_k <= sum_(k >= n) g_k$. 我们将每个序列与一个形式幂级数对应, 那么已经证明了若 $f_1 prec.eq_R f_2, g_1 prec.eq_R g_2$, 则 $f_1 + g_1 prec.eq_R f_2 + g_2, f_1 g_1 prec.eq_R f_2 g_2.$ 定义 $f prec.eq_L g$ 当且仅当 $forall n, sum_(k <= n) f_k >= sum_(k <= n) g_k$, 其同样在加法, 乘法下封闭.

设 $P_k (X) = sum_j Pr[B_i^((k)) <= beta_i and B_(i+1)^((k)) = j] X^j.$ 这里 $P_k$ 并非 PGF, 因为所有系数加起来可能小于 1. 设 $P_(k,l) (l <= beta_i)$ 表示将其中的 $<= beta_i$ 换成 $= l$ 后的结果, 那么 $P_k (X) = sum_(l <= beta_i) P_(k,l) (X)$. 从而

$ P_(k+1) prec.eq_R sum_(l <= beta_i) P_(k,l) [(l / n)^2 X + 1 - (l / n)^2] prec.eq_R sum_(l <= beta_i) P_(k,l) [(beta_i / n)^2 X + 1 - (beta_i / n)^2] = P_k [(beta_i / n)^2 X + 1 - (beta_i / n)^2]. $

然而 $[(beta_i / n)^2 X + 1 - (beta_i / n)]^n$ 恰为 $B(n, (beta_i / n)^2)$ 的 PGF, 因此有 $B_(i+1) prec.eq_R B(n, (beta_i / n)^2)$. 

由于 $n / 6 < n / (2e)$, $B_6 <= n / (2e) := beta_6$. 取 $beta_(i+1) = (e beta_i^2) / n$. 根据 Multiplicative Chernoff bound $Pr[X >= e mu] <= e^(-mu)$. 基于上述结论 $Pr[overline(E_(i+1))] <= Pr[E_i] Pr[overline(E_(i+1)) | E_i] + Pr[overline(E_i)] <= e^(-beta_i^2 \/ n) / Pr[E_i] <= (1 \/ n^2) / Pr[E_i] Pr[E_i] + Pr[overline(E_i)]$, 若 $beta_i^2 >= 2 n ln n$. 从而 $Pr[overline(E_i)] <= i / n^2 <= 1 / n$ 若 $beta_i^2 >= 2 n ln n$. 最小的 $i$ 使得 $beta_i^2 < 2n ln n$ 是 $i^* = (ln ln n) / (ln 2) + O(1)$.

落入装了 $>= i^* + 1$ 的球的个数期望以高概率不超过 $(sqrt(2n ln n))^2 / n = 2 ln n$. 进一步地, $Pr[B_(i^* + 2) >= 1] = O(log^2 / n).$

== lec12

=== Branching Process

设 $X$ 是非负整数值的随机变量. 

考虑一棵树. 时间 0 产生一个节点. 时间 $t$ 的时候时间 $t-1$ 产生的节点独立生成 $~ X$ 的子节点. 设 $Z_t$ 表示时间 $t$ 产生的节点数. 我们证明当 $EE[X] <= 1$ 的时候 $lim_(n -> infinity) Pr[Z_n = 0] = 1$, 当 $EE[X] > 1$ 的时候 $lim_(n -> infinity) Pr[Z_n = 0] = p^* < 1$.

设 $Pr[Z_n = 0] = q_n$. 枚举时间 $1$ 产生的节点数, $q_n = sum_(k >= 0) Pr[X = k]q_(n-1)^k$. 考虑函数 $f(q) = sum_(k >= 0) Pr[X = k] q^k$, $q_n = f^((n))(0)$. $f$ 是单增且凸的. 研究 $lim q_n$ 只需考虑 $f^prime (1).$

=== Giant Component

考虑 $G(n,p), p = c / n$ 中最大连通分支的大小.

当 $c < 1$ 时, 设随机变量 $X_k$ 表示从某个点开始进行 $k$ 次扩展 (BFS) 后的总感染数. 注意我们并不要求扩展次数至少是 $k$. 如果 BFS 已经结束了, 让 $X_(k+1) = X_k$ 即可. 如果 $X_k < k + 1$, 这说明当前连通块大小不超过 $k$.

我们有 $X_k prec.eq_R 1 + sum_(i=1)^k B(n, p)$. 根据 Chernoff bound, $Pr[sum_(i=1)^k Y_i >= k-1] (Y_i ~ B(n, c/n)) = Pr[sum_(i=1)^k Y_i - c k >= (1 - c) k - 1] <= exp(- (1-c)^2 k / 2)$, 最后用 Union bound 即可.

假设 $c > 1$. 我们证明 a.a.s. 最大连通分支大小为 $(1 + o(1)) beta n$, $beta$ 为 $beta + e^(-beta c)$ 的解. 

*Lemma.* 取 $k^- = O(ln n), k^+ = n^(2 / 3)$. 对于任何 $v$, a.a.s. (i) 从 $v$ 开始的分支过程在 $k^-$ 步后终止或 (ii) $forall k^- <= k <= k^+$, 从 $v$ 开始的分支过程在 $k$ 步之后队列内剩余至少 $(c - 1) k \/ 2$ 个点.

*Proof.* 对于 $k^- <= k <= k^+$, 称一个节点 $v$ 是 $k$-bad 的若从 $v$ 开始的分支过程 $k$ 步之后已经结束, 或者已经遍历过少于 $((c+1)k) / 2$ 个点. 设 $Y_i ~ B(n - ((c+1)k^+)/2, c/n)$, 则 $X_k succ.eq_L sum_(i=1)^k Y_i$. 从而 $Pr[v "is" k"-bad"] <= Pr[sum_(i=1)^k Y_i <= c k - (c - 1) k \/ 2] <= exp(-((c-1)^2 k) / (8c)).$ 对 $k$ 求和得到 $Pr[v "is bad"] <= n^(2/3) exp(-((c-1)^2 k^-) / (8c)) <= n^(-4/3)$, 这里取 $k^- = (16 c ln n) / (c - 1)^2$, 对 $v$ 求和得到 $<= n^(-1/3)$. $qed$

下面说明高概率*存在唯一*的至少大小为 $k^+$ 的连通块. 对 $u,v$, 设 $U(u),U(v)$ 为 $k^+$ 步后队列剩余的点集, 以高概率 $abs(U(dot.c)) >= (c-1)/2 k^+$. 若 $U(u) inter U(v) = emptyset$, 两者间不存在连边的概率 $<= (1-p)^(((c-1)/2 k^+)^2) = o(n^(-2))$, 对 $(u,v)$ 求和后为 $o(1)$.

为了说明高概率存在大连通块, 我们说明 "小点" (分支过程在 $k^-$ 步内结束) 的数量是 $(1+o(1))(1-beta)n$.

有如下不等式

$ Pr["b.p. with " B(n, c/n) "from" v "dies in" k^-] <= Pr[v "is small"] <= Pr["b.p. with " B(n - k^-, c/n) "from" v "dies out"]. $

根据引理的证明过程, 实际上左式的概率不会比 $B(n,c/n)$ 灭绝的概率低很多 (至多差 $o(1)$). 设灭绝概率 $d(n, c/n)$, 则 $d(n, c/n) + o(1) <= Pr[v "is small"] <= d(n - k^-, c/n)$. 

设 $f(x)$ 为 $pi(c)$ 的 PGF, $f_n (x)$ 为 $B(n, c/n)$ 的 PGF, 有 $f(x) = e^(c(x-1))$ 且 $f_n$ 一致收敛于 $f$. 注意到 $1 - beta$ 是 $f$ 的不动点. 因而, $d(n, c/n) -> 1 - beta$. 又因为 $k^- << n$, 同样 $d(n - k^-, c/n) -> 1 - beta$. 从而 $E[\# "small" v] -> (1 + o(1)) beta n$. 余下的工作是一些二阶矩法, 重点是 $u,v$ 属于不同连通块时, $ sum_u Pr[u "is small" | v "is small"] <= k^- + n Pr[u "is small in" G backslash {"component of" v}] <= k^- + n d(n - k^-, c/n). $

== lec13

=== 保距嵌入

给出度量空间 $(X, d)$, 给出 $phi, d'$ 使得 $d'(phi(u), phi(v)) approx d(u, v)$.

=== JL Lemma

$X$ 为 $RR^d$ 中的 $n$ 个点, $forall epsilon in (0, 1), k > (24 ln n) / epsilon^2$, 存在线性映射 $phi : RR^d -> RR^k$, 使得 $forall u, v, norm(phi(u) - phi(v))_2 in norm(u - v)_2 (1 plus.minus epsilon)$.

假设固定一个正交坐标系后让单位向量 $u$ 在 $SS^(d-1)$ 内随机旋转, 我们取 $phi$ 为 $u$ 的前 $k$ 个坐标.

设 $X_1, X_2, dots.c, X_d ~ N(0, 1)$. 我们有 w.h.p. $sum_(i=1)^k X_i^2 in (1 plus.minus epsilon) k/d sum_(i=1)^d X_i^2.$ 这可以用类似 Chernoff Bound 的方法 ($X ~ N(0, 1)$ 情况下 $EE[e^(t X^2)]$ 等可以直接写出来).

=== 一般度量的嵌入
 
有限度量空间可以被嵌入到一个 $O(log^2 n)$ 维的 $cal(l)_p$ 空间, 以 $O(log n)$ 的误差. 这被称为 *Bourgain 嵌入定理*. 下文先考虑 $p = 1$.

对于一个集合 $S$, 定义 $d(x, S) = min_(y in S) {d(x, y)}$. 一个 *Fréchet 嵌入* 指的是给定集合 $S_1, dots.c, S_r, f(x) = (d(x, S_i))_(1 <= i <= r)$. 根据三角不等式, $norm(f(x) - f(y))_1 <= r d(x, y)$. 下文中 $S$ 将会以某个 $p$ 概率独立采样, 即 $Pr[x in S] = p$.

设 $B(u, rho) = {x in X : d(u, x)}$. 我们考虑一种极端情况: 假设所有点分散于 $B(x, epsilon) union.plus B(y, epsilon)$ 之中, 两者大小相近, 那么我们取 $p approx 1 / abs(B(x, epsilon))$ 可以保证以至少常数概率 $S(p) inter B(x, epsilon) = emptyset and S(p) inter B(y, epsilon) != emptyset$, 此时 $d(x, S) - d(y, S) >= d(x, y) - 2 epsilon$.

一般的情况下, 我们需要考虑固定 $abs(B(dot.c, rho))$ 下的 $rho$. 设 $rho_k = min {rho : B(x, rho), B(y, rho) >= 2^k}$. 令 $B^o (u, rho) = {v : d(u, v) < rho}$. 取一个充分大的 $t$ 使得 $rho_(t-1) < rho_t < d(x,y) / 4$ (进行"截断"), 我们可以令 $B(x, dot.c) inter B(y, dot.c) = emptyset$.

WLOG, 我们有 $abs(B^o (y, rho_j)) < 2^j$ 和 $abs(B(x, rho_(j-1))) >= 2^(j-1)$, 从而
$ Pr[S(2^(-j)) inter B^o (y, rho_j) != emptyset and S(2^(-j)) inter B(x, rho_j) = emptyset] >= (1 - (1 - 2^(-j))^(2^(j-1)))(1 - 2^(-j))^(2^j) >= 1 / 12. $

取 $m = O(log n)$, 独立采样 $m$ 个 $S(2^(-j))$, 则以高概率上述事件至少发生 $m / 24$ 次, 取均值后贡献 $"Const" dot.c (rho_j - rho_(j-1))$. 对所有 $j$ 加总取均值得到以高概率贡献至少 $"Const" dot.c d(x, y) / log n$. 坐标总量 $O(log^2 n)$.

以上为 $cal(l)_1$ 的情况. 对于 $cal(l)_p$ 的情况依然采取上述构造. 设 $k$ 为总共的坐标数, 首先有 $norm(f(x) - f(y))_p <= k^(1 / p) d(x, y)$, 根据 Hölder 不等式 $norm(f(x) - f(y))_p k^(1 - 1/p) >= norm(f(x) - f(y))_1 >= Theta(log n) d(x, y)$. 结合两者即可得到偏移量是 $O(log n)$.

== lec14

=== 鞅

设 $X_t (t in NN)$ 是随机过程, $cal(F)_t$ 为一列递增的 $sigma$-代数, 若 $EE[X_(t+1) | cal(F)_t] = X_t$, 则称 $(X_t)$ 为一个*鞅 (Martingale)*.

假设随机过程有 $T$ 步, $A$ 是 $cal(F)_T$ 上的函数, 那么 $EE[A | cal(F)_t]$ 是一个鞅 (被称为 Doob 鞅).

=== Azuma Inequality

设 $(X_t)$ 是关于 filter $(cal(F)_t)$ 的鞅, $Y_t = X_t - X_(t - 1)$ 满足存在 $(c_t), abs(Y_t) <= c_t$, 那么有 $Pr[X_n >= (<=) X_0 + lambda] <= e^(-lambda^2 / (2 sum_(i=1)^n c_i^2))$. 这是 Hoeffding 的推广.

$ EE[e^(t(X_n - X_0))] &= EE_(cal(F)_(n-1))[EE [e^(t(X_n - X_0)) | cal(F)_(n-1)]] \
  &= EE_(cal(F)_(n-1))[EE [e^(t Y_n) | cal(F)_(n-1)] e^(t(X_(n-1) - X_0))] \
  &<= (e^(t c_i) + e^(-t c_i)) / 2 EE[e^(t(X_(n-1) - X_0))] <= dots.c \
  &<= e^(t/2 sum_(i=1)^n c_i^2). $

剩余部分的分析和 Hoeffding 是一样的.

== lec15

=== Azuma Inequality 的应用

考虑分析 Balls and Bins 空桶的个数. 设 $X_i$ 表示扔了 $i$ 个球后期望空桶的数量, 则 $abs(X_i - X_(i-1)) <= 1$, 因此有 concentration bound.

考虑 $G(n, 1/2)$ 的点染色数, 这个东西的期望并不好算. 令 $X_i$ 表示给前 $i$ 个点导出子图内的点染色数, 这是 $1-$Lipschitz 的.

=== 快排时间

设长为 $n$ 的随机排列上快排的比较次数是随机变量 $Q_n$, 则 $q_n = EE[Q_n] = n - 1 + 1/n sum_(i=1)^n (q_(i-1)+q_(n-i)).$ 可以算出 $q_n = sum_(k=1)^(n-1) (2(n-k)) / (k+1) = 2 n ln n - (4 - 2 gamma)n + 2 ln n + O(1).$

*Theorem.* $forall 0 < epsilon < 1$, $Pr[abs(Q_n - q_n) >= epsilon q_n] = n^(-(2 + o(1))epsilon ln ln n)$.

我们只证明 $<=$.

将二叉树从根开始用 $1,2,3,dots.c$ 标号, 设节点 $j$ 对应序列的长度是 $L_j$, 那么 $sum_(j "at level" k) L_j <= n$.

*Fact 1.* 设 $M_k^n = max{L_j : j "at level" k}$, $0 < alpha < 1, k >= ln(1/alpha)$, 则 $ Pr[M_k^n >= alpha n] <= alpha ((2 e ln (1/alpha))/k)^k. $

*Fact 2.* 设 $V_n = {[(n - 1) + q_(j-1) + q_(n-j)] - q_n : j in [n]}$, 则 $V_n subset [-n, n]$. 这可由 $q$ 的精确表达式算出.

设 $H_k$ 为第 $k$ 层的比较结果, $cal(H)^(k) = (H_0, H_1, dots.c, H_(k-1))$. 设 $k_1 = 2 epsilon ln n, k_2 ~ ln n ln ln n$, 高概率算法在第 $k_2$ 层已经结束了.

*Lemma.* $forall h, abs(EE[Q_n | cal(H)^(k) = h] - q_n) <= k n$.

这基于 Fact 2. 若 $j$ 为第 $k$ 层的一个结点, 则往下走一层后期望的变化至多为 $plus.minus abs(L_j)$, 一层的总变化量至多为 $plus.minus n$. 

当 $k_1 <= 2 epsilon ln n$ 的时候, $k_1 n <= epsilon q_n$.

*Lemma.* 设 $0 < k_1 < k_2, 0 < alpha < 1, M_(k_1)^n <= alpha n$, 则 $ forall h, Pr[abs(EE[Q_n | cal(H)^(k_2)] - EE[Q_n | cal(H)^(k_1) = h]) >= lambda | cal(H)^(k_1) = h] <= 2 exp(-lambda^2 / (2(k_2 - k_1) alpha n^2)). $

考虑如下的 Doob 鞅 $ X_0 = EE[Q_n | cal(H)^(k_1) = h], X_i = EE[Q_n | cal(H)^(k_1+i), cal(H)^(k_1) = h]. $
我们不能期望 $abs(X_i - X_(i-1))$ 有界, 而是直接计算 $EE[exp(t(X_i - X_(i-1))) | cal(F)_i]$.

$X_i - X_(i-1) = sum_(j "at level" i-1) T_j$, 其中 $T_j$ 是 $j$ 对 $X_i - X_(i-1)$ 的贡献. 注意到 $T_j$ 是互相独立的, $EE[T_j] = 0$, 且 $abs(T_j) <= L_j$. 根据凸性有 $EE[exp(t T_j) | L_j] <= exp(1/2 t^2 L_j^2)$. 相乘后得到
$ EE[exp(t(X_i - X_(i-1))) | {L_j}] <= exp(1/2 t^2 sum_(j "at level" i-1) L_j^2) <= exp(1/2 t^2 alpha n^2). $

于是可以得到类似 Azuma 不等式的引理. 根据 union bound,

$ 
  Pr[abs(Q_n - q_n) >= k_1 n + lambda] &<= Pr[M_(k_2)^n >= 2] + Pr[M_(k_1)^n > alpha n] + Pr[abs(EE[Q_n | cal(H)^(k_2)] - EE[Q_n | cal(H)^(k_1)]) >= lambda | cal(H)^(k_1), M_(k_1)^n <= alpha n] \
  &<= 2/n ((2 epsilon ln(n/2))/k_2)^k_2 + alpha((2 epsilon ln(1/alpha))/k_1)^k_1 + 2 exp(- lambda^2/(2(k_2-k_1)alpha n^2)).
$

带入适当参数后得到定理.

== lec16

=== Optional Stopping Theorem

从 0 开始在 $ZZ$ 上随机游走, 遇到 $-a$ 或 $b$ 的时候结束, 计算遇到 $-a$ 的概率. 则 $(X_t)$ 是一个鞅.

*Theorem. Optional Stopping Theorem.* 设 $tau$ 为停时, 那么 $EE[X_tau] = X_0$, 若 (i) $EE[tau] < +infinity$, (ii) $EE[abs(X_i - X_(i-1)) | cal(F)_(i-1)] < c, forall i$.

e.g. 令上述概率为 $p$. 先验证 $EE[tau] < +infinity$. 则 $EE[X_tau] = p (-a) + (1-p) b = X_0 = 0$, 从而 $p = b / (a+b)$.

e.g. 计算 $EE[tau]$. 令 $Y_i = X_i^2 - i$, 则 $(Y_t)$ 是一个鞅. 从而 $EE[tau] = EE[X_tau^2] = b/(a+b) a^2 + a/(a+b) b^2 = a b.$

e.g. 从 $(x,y) = (a,b) (a > b > 0)$ 开始, 每次以 $x/(x+y)$ 的概率令 $x <- x-1$, 以 $y/(x+y)$ 的概率令 $y <- x-1$. 计算当 $x+y>0$ 时 $x > y$ 始终成立的概率. 

注意到 $(x-y)/(x+y)$ 是鞅. 定义 $tau$ 为第一次 $x=y$ 或 $(x,y) = (1, 0)$ 的时间, 可算出 $p = (a-b)/(a+b)$.

=== Randomized 2SAT

任选一个初始的赋值. 每次找第一个坏的语句随机翻转一个 bit.

设一个满足的赋值是 $a*$. 设 $X_i$ 为 $i$ 轮后赋值与 $a*$ 的 Hamming 距离. 考虑第一个坏的子句, 有 $EE[X_i - X_(i-1) | cal(F)_(i-1)] <= 0$. 令 $Y_i = X_i^2 - 2n X_i - i$. 那么 $EE[Y_i - Y_(i-1) | cal(F)_(i-1)] = EE[(X_i - X_(i-1))(2X_(i-1) - 2n) | cal(F)_(i-1)] >= 0.$ 这表明 $Y_i$ 是 submartingale. 从而 $EE[tau] <= EE[X_tau^2 - 2n X_tau - X_0^2 + 2n X_0] <= n^2.$

== lec17

=== Percolation

设 $G$ 为 $d$-正则图. 一个 $p = 1/(d-1)$ 渗滤为让 $G$ 的每条边以 $p$ 的概率存在的随机图. 

仍然考虑之前的分支过程, 有 $t$ 时刻未探索的点数被 $X_t = X_(t-1) - 1 + B(d-1, 1/(d-1))$ 控制. $(X_t)$ 是一个鞅.

取 $h,k$, 设 $tau := {min t : X_t = 0 or X_t >= h or t >= k}$. 我们期望 $k = n^(2/3)$. 则 $Pr[forall t <= k, X_t > 0] <= Pr[tau >= k] + Pr[X_tau >= h] <= EE[tau] / k + EE[X_tau] / h = EE[tau] / k + 1 / h$.

令 $Y_t = X_t^2 - h X_t$, 则 $EE[Y_t - Y_(t-1) | cal(F)_(t-1)] = EE[(X_t - X_(t-1))^2 | cal(F)_(t-1)] = Var[B(d-1, 1/(d-1))] = (d-2)/(d-1) >= 1/2$. 从而 $EE[Y_tau] <= Pr[X_tau >= h] EE[X_tau^2 | X_tau >= h], EE[tau] <= 2(EE[Y_tau] - EE[Y_0]) <= 2(1/h EE[(h + B(d-1, 1/(d-1)))^2] - (1-h)) <= 2(2h + 1 + 1/h).$ $Pr[forall t <= k, X_t > 0] <= 2/k (2h + 1 + 1/h) + 1/h = O(1 / sqrt(k)) (h = Theta(sqrt(k))).$ 设 $N_k$ 表示所属连通块大小至少是 $k$ 的点的数量, 那么 $EE[N_k] = O(n / sqrt(k))$, $Pr[N_k >= k] <= EE[N_k] / k = O(n / (k^(3/2)))$. 取 $k = A n^(2/3)$ 可使得概率为小常数.

== lec18

=== Markov Chain

随机变量序列 $(X_t)$ 满足 $Pr[X_(t+1) = y | X_1, dots.c, X_t] = Pr[X_(t+1) = y | X_t]$. 有限情况下写成转移矩阵 $pi -> pi P$.

如果 $P$ 连通且满足非周期性, 那么可以证明一定收敛到唯一的稳定分布.

e.g. 洗牌. 将其视为反向的 Coupon Collection.

一个特殊情况: 如果 $forall x,y, pi(x) P(x,y) = pi(y) P(y,x)$, 则 $pi$ 是稳定分布.

=== Metropolis Process

将空间中的点连接起来, 抽取邻居的方法 $kappa(x, y) > 0$.

过程: 设从 $x$ 按照 $kappa(x, y)$ 的概率抽到 $y$. 以 $p(x, y)$ 的概率转移到 $y$, 以 $1 - p(x, y)$ 的概率留到 $x$. 设计 $p$ 使得稳定分布为 $pi$.

可以取 $pi(x) kappa(x, y) p(x, y) = pi(y) kappa(y, x) p(y, x) arrow.l.double p(x, y) = min{1, (pi(y) kappa(y, x)) / (pi(x) kappa(x, y))}$.

=== Mixing Time 

设 $Delta(t)$ 表示 $t$ 时刻*任意*初始分布得到的转移后的分布与均匀分布之间的最大全变差. 定义 $tau_"mix" = min{t : Delta(t) < 1/(2e)}$.

如果存在强稳定时间 $T$: $Pr[X_t = y | T = t] = pi(y)$, 则 $Delta(t) <= Pr[T > t]$.

=== Coupling

考虑两个随机序列 $(X_t), (Y_t)$ 的联合分布, 满足其边缘分布相同, 并且 $X_t = Y_t => X_(t+1) = Y_(t+1)$. 设 $T_(x y) = min{t : X_t = Y_t | X_0 = x, Y_0 = y}$. 一个关键结论是 $Delta(t) <= max_(x,y) Pr[T_(x y) >= t].$ 这是由于

$ max_x Delta(P_x^((t)), pi) <= max_(x,y) Delta(P_x^((t)), P_y^((t))) <= max_(x,y) Pr[X_t != Y_t | X_0 = x, Y_0 = y] <= max_(x,y) Pr[T_(x y) >= t]. $

第二步用到了 $Pr[X != Y] >= Delta(X, Y)$ (考虑分析 $Pr[X = Y]$).

下面分析通过每次随机交换两张牌(可以相同)进行洗牌. 与如下过程耦合: 随机选取位置 $i$ 和牌 $c$, 交换 $i$ 处的牌和 $c$, 那么每次距离不增. 设当前距离为 $d$, 那么距离减小的概率为 $d^2/n^2$, 因此降低为 $0$ 的期望时间是 $sum_d n^2 / d^2 = O(n^2)$. (这个界并不是最优的.)

== lec19

=== 点染色采样

设可以选择的颜色数至少是最大度数 $Delta + 2$. 从一个合法染色出发, 每次随机选择一个点和颜色, 如果这个颜色不会造成冲突就将当前点的颜色改变为选择的颜色.

由于转移矩阵是对称的, 因此均匀分布确实为稳定分布. 另一方面, 不同的合法染色方案是连通的. 考虑逐个调整每个点的颜色, 现在将 $u$ 的颜色从 $c_1$ 调整到 $c_2$. 当前 $u$ 的邻居 $v$ 的颜色可能为 $c_2$, 需要将其临时调整为另一种颜色. 这样的 $v$ 不可能是已经调整后的, 因此每次不同点的数量至少少 1.

