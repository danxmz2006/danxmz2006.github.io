#import "../index.typ": template, tufted

#show: template.with(
  title: "信息论",
  description: "2026 Spring",
  date: datetime(year: 2026, month: 3, day: 24),
  lang: "zh",
)

#set math.equation(numbering: none)

= 信息论

== Discrete Entropy, Mutual Information, KL Divergence, and several properties

*信息熵 (Entropy)* $H[X]$ 是定义在一个离散变量分布列 $p(x)$ 上的函数, $ H[X] = sum_x p(x) log 1/p(x). $

$log$ 的底数一般不重要, 视上下文而定. 这里不应将 $H$ 视为随机变量 $X$ 的函数. 也可以对 $X ~ D$ 写作 $H[D] = H[X]$. 令 $h(p) = p log 1/p + (1-p) log 1/(1-p)$. 根据 Jensen 不等式, $0 <= H[X] <= log |Omega|$, $Omega$ 为 $X$ 的 support.

#let Unif = math.op("Unif", limits: false)

$H$ 在一些程度上和对"信息"的直觉有平行关系. 例如, 对于均匀分布 $X_n ~ Unif(n)$, 我们有 $H[X_n] = log n arrow.t$. 再如, 如果随机试验可以分成两部分, 在第一次结果的基础上再进行划分, 最终得到可能的熵等于两部分的和: $ H[p_1, p_2, dots.c p_n] = H[p_1 + p_2, p_3, dots.c, p_n] + (p_1 + p_2)H[p_1 / (p_1+p_2), p_2 / (p_1+p_2)]. $

由这两点加上连续性假设实际上可以确定 $H$.

一个与后文内容关系更大的引入方式是考虑*信源编码 (Source Coding)*: 假设随机变量 $X$ 服从分布列 $p_1, p_2, dots.c, p_n$, 需要多少 bit 才能表示一个 $X$? 假设每种可能对应的码长是 $l_1, l_2, dots.c, l_n$. 我们总是考虑编码一列同分布的 $X$, 所以要求可唯一解码. 什么样的 $l$ 满足可唯一解码? 有如下结论: 

*Theorem. (Kraft's Inequality.)* 存在一组可唯一解码的方案, 当且仅当 $sum_(i=1)^n 2^(-l_i) <= 1$.

*Proof.* 令 $S = sum_(i=1)^n 2^(-l_i).$ 假设 $S > 1$, 对任何 $m > 0$ 有 $ S^m <= sum_x 2^(-|x|). $
这里 $x$ 取遍所有长度不超过 $m max l_i$ 的二进制串. 由于可唯一解码, 每个 $x$ 对展开后的和至多贡献一次, 所以总和不超过 $sum_(k <= m max l_i) 2^k dot.c 2^(-k) = m max l_i + 1.$ 然而 $S^m (S > 1)$ 是指数级的! 矛盾.

假设 $S <= 1$, 我们实际上可以构造出*前缀码*: 任意两个码字没有前缀关系. 我们可以假设 $S = 1$. 考虑那些达到了最大码长的 $l_i$, 可以发现其一定出现了偶数次, 因此可以将它们两两配对, 并合并为一个长 $l - 1$ 的码字. 不断归纳直到只剩一个点, 我们可以恢复完整的二叉树. 这被称为 Huffman 树. $qed$

给出 $l_i$, 平均码长是 $sum_i p_i l_i$. 因此考虑如下优化问题:

#align(center, [
  $ min sum_(i=1)^n p_i l_i \ s.t. sum_i 2^(-l_i) = 1. $
])

假设不限定 $l_i$ 是整数, 我们可以直接给出最优 $l_i = -log_2 p_i$. 这源于一个将反复出现的不等式:

*Proposition.* $p, q$ 是分布列, 则 $sum_(i=1)^n p_i log p_i / q_i >= 0$. 该和被称为 *KL Divergence* $D(p || q).$ 这可以视为对概率的估计偏差带来的编码的额外开销.

*Proof.* 对上凸函数 $f(x) = x log x$ 用 Jensen 不等式, 注意到 $p_i log p_i / q_i = q_i dot.c p_i / q_i log p_i / q_i.$ $qed$

$H$ 是定义在分布列上的, 因此将其推广到多元变量没有任何障碍(称为 Joint Entropy). 然而暂且考虑两个变量的推广.

我们有自然的*条件熵* $H[X | A]$: 考虑 $X$ 在事件 $A$ 条件下的分布的 entropy. *条件熵* 定义如下: $ H[Y | X] = sum_x Pr[X = x] H[Y | X = x]. $

即对不同的 $X$ 加权平均. 存在如下关系: $ H[Y | X] = sum_(x, y) Pr[X = x] dot.c Pr[X = x, Y = y] / Pr[X = x] log Pr[X = x] / Pr[X = x, Y = y] = H[X, Y] - H[X]. $

$H[X, Y]$ 是关于 $X, Y$ 对称的, 因而 $H[X, Y] = H[X] + H[Y | X] = H[Y] + H[X | Y]$

定义*互信息 (Mutual Information)* $I[X;Y] = H[X] - H[X | Y] = H[X] + H[Y] - H[X, Y]$. 直观上, $I[X ; Y] >= 0$, 因为在知道 $Y$ 的信息情况下 $X$ 的不确定性不会增加. 事实确实如此: $ I[X;Y] = sum_(x,y) P_(X Y)(x, y) log (P_(X Y)(x, y)) / (P_X (x) P_Y (y)) = D(P_(X Y) || P_X P_Y) >= 0. $

$I$ 不能推广到三个变量间的情况(即强行用容斥原理的式子计算), 因为得到的东西可正可负.

下面是一个有趣(有用)的命题.

*Theorem. (Fano's Inequality.)* 设 $X, Y, Z$ 为离散随机变量. 定义 $A(z) = sum_(x,y) p(y)p(z | x,y).$ 则 $H[X|Y] <= H[Z] + EE[log A].$ 特别地, 令 $Z = [X eq.not Y], H[X | Y] <= h(Pr[X eq.not Y]) + Pr[X eq.not Y] log (r-1).$ 这里设 $X, Y$ 在 $[r]$ 中取值.

*Proof.* $ H[X | Y] &<= EE[log(1 / p(x | y))] \
            &= sum_(x,y,z) p(x, y, z) log(1 / p(x | y)) \
            &= sum_z p(z) sum_(x, y) p(x, y | z) log(1 / p(x | y)) \
            &<= sum_z p(z) log[1 / p(z) dot.c sum_(x, y) (p(x, y, z) / p(x | y))] \
            &= sum_z p(z) log(1 / p(z)) + sum_z p(z) log sum_(x, y) (p(x, y, z) / p(x | y)) \
            &= H[Z] + EE[log A].  $

特殊情况下 $A(0) = 1, A(1) = r-1$ 容易验证. $qed$

上述定理的一种解释是: 假设已知 $Y$ 想要确定 $X$, 可以先判定是否 $X = Y$, 如果不等再用至多 $log(r-1)$ 位确定 $X$. 如果高概率 $X = Y$ 这比直接求 $X$ 更优.

若干凸性结论.

+ $H[lambda P + (1 - lambda) Q] >= lambda H[P] + (1 - lambda)H[Q].$ (归结为 $f(x) = -x log x$ 的下凸性)
+ $D(lambda P_1 + (1 - lambda)P_2 || lambda Q_1 + (1 - lambda)Q_2) <= lambda D(P_1 || Q_1) + (1 - lambda) D(P_2 || Q_2). $ 这源于 $f(x, y) = x log (x / y)$ 是上凸的, 其 Hessian 半正定. 或者考虑一个拓展的不等式 $sum a_i log(a_i / b_i) >= (sum a_i) log((sum a_i) / (sum b_i))$.

*Theorem. Chain Rule.* $H[X_1, X_2, dots.c, X_n] = H[X_1] + H[X_2 | X_1] + H[X_3 | X_1, X_2] + dots.c + H[X_n | X_1, X_2, dots.c, X_(n-1)]$.

我们同样有关于互信息的 Chain rule: $ I[X_1, X_2, dots.c, X_n ; Y] = sum_(i=1)^n I[X_i;Y | X_1, X_2, dots.c, X_(i-1)]. $ 这可以由 $I[X_1, X_2, dots.c, X_n ; Y] = H[X_1, dots.c, X_n] - H[X_1, dots.c, X_n | Y]$ 推出.

*Theorem. Data Processing.* 对 Markov Chain $X -> Y -> Z$, 有 $I[X;Y] >= I[X;Z]$.

*Proof.* $I[X;Y,Z] = I[X;Y] + I[X;Z | Y] = I[X;Z] + I[X;Y | Z]$. 由于 $X,Z$ 在 $dot.c | Y$ 下是独立的, $I[X;Z | Y] = 0$, 从而 $I[X;Y] >= I[X;Z]. qed$

*Theorem. Data Processing of Divergence.* 设 $P_Y = P_(Y | X) P_X, Q_Y = P_(Y | X) Q_X$, 则 $D(P_Y || Q_Y) <= D(P_X || Q_X)$.

*Proof.* $ D(P_Y || Q_Y) <= D(P_(X Y) || Q_(X Y)) = D(P_X || Q_X) + D(P_(Y | X) || Q_(Y | X)) = D(P_X || Q_X). $

*Proposition.* $D(P || Q) >= 1/2 log_e norm(P - Q)_1^2$.

*Proof.* 两点分布是导数练习题. 一般情况可以映为 $p_i < q_i$ 和 $p_i > q_i$ 两种情况, 然后用 Data processing 不等式. $qed$


== Source Coding

=== Asymptotic Equipartition Property (AEP) and Typical Set

AEP: 根据 Law of Large Numbers, 我们有若 $X_1, X_2, dots.c ~ p(x)$ (i.i.d.), 则 $-1/n log p(X_1, X_2, dots.c, X_n) limits(-->)^p H[X]$. 

*Definition.* 一个 *typical set* $A_epsilon^((n))$ 包含 $(x_1, x_2, dots.c, x_n) in cal(X)^n$, 使得 $exp(-n (H[X] + epsilon)) <= p(x_1, x_2, dots.c, x_n) <= exp(-n (H[X] - epsilon))$.

*Theorem.* (i) 对充分大的 $n$, $Pr[A_epsilon^((n))] >= 1 - epsilon$. (ii) $(1-epsilon)exp(n(H[X] - epsilon)) <= |A_epsilon^(n)| <= exp(n(H[X] + epsilon)).$

*Proof.* (i) 这缘于 AEP. (ii) 根据 $1 - epsilon <= Pr[A_epsilon^((n))] <= 1.$ $qed$

根据 Huffman Coding, 可以构造码长 $l$ 使得 $EE[l(X)] <= H[X] + 1$.

这个 1 并不是本质的. 考虑将 $X_1, X_2, dots.c, X_T$ (独立服从 $X$) 统一编码, 有 $1/T EE[l(X_1, X_2, dots.c, X_T)] <= H[X] + 1/T$. 因此 $H[X]$ 是平均码长的下确界.

*Definition. Entropy rate.* 对随机过程 $cal(X) = (X_t)$, 若 $lim_(T -> infinity) 1/T H[X_1, X_2, dots.c, X_T]$ 存在, 定义其为 $cal(X)$ 的 *entropy rate*, 记为 $cal(H)(cal(X))$.

我们也可以定义 $cal(H')(cal(X)) = lim_(T -> infinity) H[X_T | X_1, X_2, dots.c, X_(T-1)]$. 假设该极限存在, 则 $cal(H)$ 极限也存在, 且它们相等.

对于*稳态分布* $p(X_1 = x_1, X_2 = x_2, dots.c, X_n = x_n) = p(X_2 = x_1, X_3 = x_2, dots.c, X_(n+1) = x_n)$ 而言, $cal(H')$ 中的数列是单调下降的, 故其极限必然存在.

对于 Markov Chain 而言, 上述极限即为 $H[mu P | mu]$, 其中 $mu$ 为稳态分布, 有 $H[mu P | mu] = -sum_(i j) mu_i P_(i j) log P_(i j)$.

== Differential Entropy

考虑连续变量 $X$, 我们可以无障碍地定义 $ H[X] = - integral_Omega p(x) log p(x) dif x. $ 但这不能被视为离散熵的平凡推广, 因为测量连续变量时我们只能精确到一定的精度. 

具体地, 假设将 $Omega$ 分为 $Delta_1, Delta_2, dots.c$, $abs(Delta_i) = Delta$, $p_i = integral_(Delta_i) p(x) dif x = p(x_i) Delta$, 我们有 $sum_i -p_i log p_i = -sum_i p(x_i) log p(x_i) Delta - sum_i p(x_i) log Delta = -sum_i p(x_i) log p(x_i) Delta - log Delta$. 注意根据 Riemann 积分的定义第一项会趋于 $H[X]$, 而第二项会趋于 $+infinity$.

微分熵可正可负. 注意我们可以取分划使得每个部分概率小于 $epsilon$, 于是 $sum_i -p_i log p_i -> +infinity$, 这个结论即使 $H[X] = -infinity$ 的时候还是对的.

我们可以类似地定义 KL 散度和互信息.

$ D(P || Q) = integral_Omega p(x) log p(x) / q(x), I[X;Y] = D(P_(X Y) || P_X P_Y). $

注意到这里 $log$ 内的部分是齐次的, 这意味着划分带来的 $log Delta$ 刚好可以抵消. 所以这样定义出来的和离散化后的极限是一致的.

== Kolmogorov Complexity

给出通用 TM $U$, 定义 $x in {0, 1}^*$ 的 Kolmogorov Complexity 是 $K_U (x) = min_(U(p) = x) abs(p).$

设 $A$ 为任何 TM, 存在和 $x$ 无关的 $c_A$ 使得 $K_U (x) <= K_A (x) + c_A$, 理由是可以写下 $A$ 的描述.

固定 $U$, $K_U (x)$ 是不可计算的. 反证, 假设存在一个 TM $p$ 使得 $p(x) equiv K_U(x)$. 固定一个常数 $M$, 我们可以找到(将所有输入排成一列后)第一个 $x_0 : K_U(x_0) > M$. 这件事情可以用一个长度为 $O(log M) << M$ 的事情完成, 然而这和 $x_0$ 的定义矛盾.

== Channel Coding

设信息 $x in {0, 1}^m$, 需要构造 $f : {0, 1}^m -> {0, 1}^n$, 使得 Hamming 距离 $d_H (f(x), f(x')) >= d$, 则可以纠正至多 $floor((d-1)/2)$ 位错误.

设 $A(n,d)$ 为在 ${0,1}^n$ 中至多能选多少个元素, 使得两两 Hamming 距离至少为 $d$, 则有显然的上界 $A(n,d) <= 2^n / (sum_(i=0)^floor((d-1)/2) binom(n,i))$.

Universal Coding 给出 $A(n, d)$ 的下界: 枚举每个 $x$, 将其随机映射到 $C_x in {0, 1}^n$, 那么对于已经确定的 $C_y$, 其与 $C_x$ Hamming 距离不超过 $d$ 的概率不超过 $2^(-n (1-h(d/n)))$, 只需要这个数乘上 $A(n, d) < 1$, 故而 $A(n, d) >= 2^(n(1 - h(d/n)))$.

考虑 Discrete Memoryless Channel $P_(Y|X)$. 定义 *Channel Capacity* $C = max_(P_X) I[X;Y]$. 编码可视为函数 $"Enc": {0, 1}^(n R) -> cal(X)^n$. 解码函数可视为 $"Dec": cal(Y)^n -> {0, 1}^(n R)$. $R$ 为 Information Rate. #footnote[这不同于码率, 后者是一个无量纲数, 类似于 $R/C$] 设输入在 ${0, 1}^(n R)$ 上均匀分布, 错误概率为 $P_e^n$.

*Theorem.* 若 $R < C$, 则存在一族 $"Enc"$ 使得 $P_e^n -> 0$; 若 $R > C$, 则 $P_e^n -> 1$.

_使用 AEP 的证明._ 对于 $(X^n, Y^n)$, 定义 $A_epsilon^((n)) subset cal(X)^n times cal(Y)^n$, 其成员满足 $max{abs(1/n log p(x^n) - H[X]), abs(1/n log p(y^n) - H[Y]), abs(1/n log p(x^n, y^n) - H[X, Y])} < epsilon$. 根据大数定律, $Pr[(X^n, Y^n) in A_epsilon^((n))] -> 1$. 设 $(tilde(X)^n, tilde(Y)^n) ~ P_X^n P_Y^n$. 注意到 

$ Pr[(tilde(X)^n, tilde(Y)^n) in A_epsilon^((n))] dot 2^(n(I[X;Y] - 3 epsilon)) <= sum_(x^n, y^n) p(x^n) p(y^n) [(x^n, y^n) in A_epsilon^((n))] dot p(x^n, y^n) / (p(x^n) p(y^n)) <= 1, $

因此 $Pr[(tilde(X)^n, tilde(Y)^n) in A_epsilon^((n))] <= 2^(-n (I[X;Y] - 3 epsilon))$.

考虑矩阵 $cal(C)_(M times n)$, 其中 $M = 2^(n R)$. 设 $P_X$ 为使得 $I[X;Y]$ 最大化的分布. 让 $C_(i j) ~ P_X$ i.i.d. $"Enc"(i)$ 即为 $cal(C)$ 的第 $i$ 行. 解码的时候, 如果 $y^n$ 满足 $cal(C)$ 中存在唯一的 $x^n$ 使得 $(x^n, y^n) in A_epsilon^((n))$, 则令 $"Dec"(y^n) = x^n$, 否则视为失败.

考虑一个固定的输入 $W = 1$ 的失败概率. 设事件 $E_i$ 表示 $cal(C)$ 的第 $i$ 行和 $Y^n$ jointly typical. $"Enc"(1)$ 经过信道后高概率是典型的: 取充分大的 $n$ 使得 $Pr[E_1^complement | W = 1] < epsilon$. 另一方面, 对于 $i > 1$, $Pr[E_i | W = 1] <= 2^(-n(I[X;Y] - 3 epsilon))$, 对 $2^(n R)$ 个 $i$ 求和得到 $2^(-n(I[X;Y] - R) + 3 n epsilon) <= epsilon$, 若 $R < I[X;Y] - 3 epsilon$ 且 $n$ 充分大.

注意这里的 $cal(C)$ 是随机的, 而我们需要一个固定的 $cal(C)$. 在上面的结论中对 $W$ 求和得到

$ 1 / M sum_(W in [M]) Pr_(cal(C), f)["Dec"(f("Enc"(W))) != W] < 2 epsilon. $

因此存在一个 $cal(C)$ 使得 $1 / M sum_(W in [M]) Pr_f ["Dec"(f("Enc"(W))) != W] < 2 epsilon$. 根据 Markov 不等式这些 $W$ 中满足错误概率大于 $4 epsilon$ 的至多只有一半. 丢弃这一半后 $R' = R - 1/n$ 并且所有输入的最大概率都不超过 $4 epsilon$.

下面证明 $liminf P_e >= 1 - C/R$. 根据 Fano 不等式

$ h(P_e) + P_e log(2^(n R) - 1) >= H[W | Y^n]. $

另一方面, 根据 data processing 不等式,

$ I[W; Y^n] <= I[X^n; Y^n] &= H[Y^n] - H[Y^n | X^n] \ &<= sum_(i=1)^n H[Y_i] - H[Y_i | Y_(<=i-1), X^n] \ &= sum_(i=1)^n H[Y_i] - sum_(i=1)^n H[Y_i | X_i] = n I[X_i;Y_i] <= n C. $

综上, $R <= C + 1/n + R P_e$, 令 $n -> infinity$ 即可.

=== Hamming Code

设 $H$ 为 $k times (2^k - 1)$ 的校验矩阵, 满足码字集合为 ${x | H x = 0} = ker H$, 其第 $i$ 列为 $i$ 的二进制表示, 其可以纠正至多一位错误. 假设 $hat(x) = x + e$, 解码时通过 $H hat(x) = H e$ 可以找到错的一位.

生成矩阵 $G$ 大小为 $(2^k - 1) times (2^k - 1 - k)$ 满足 $ker H = im G$. 一个构造是将 $H$ 分块后转置, 保持有一个满的单位子矩阵. 

== Maximum Entropy Principle

假设给出一个分布的期望 $mu$ 和方差 $sigma^2$. 设其密度函数 $f(x)$, 那么一般 $f$ 不是唯一确定的. 

我们寻求一个分布使得 $H[X] = integral f(x) log (1 / f(x)) dif x$ 最大. 令正态分布 $Y ~ N(mu, sigma^2)$, 有 $D(X || Y) = integral f(x) log f(x) dif x - integral f(x) (-(x - mu)^2 / (2 sigma^2) - log sqrt(2 pi)) dif x.$ 这表明正态分布是最大熵分布.