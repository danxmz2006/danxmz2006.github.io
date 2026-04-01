#import "../index.typ": template, tufted

#show: template.with(
  title: "信息论",
  description: "2026 Spring",
  date: datetime(year: 2026, month: 3, day: 24),
  lang: "zh",
)

#set math.equation(numbering: none)

= 信息论

== Ch01 Discrete Entropy, Mutual Information, KL Divergence, and several properties

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

*Proposition.* $p, q$ 是分布列, 则 $sum_(i=1)^n p_i log p_i / q_i >= 0$. 该和被称为 *KL Divergence* $D(p || q).$

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

*Theorem. Chain rule.* $H[X_1, X_2, dots.c, X_n] = H[X_1] + H[X_2 | X_1] + H[X_3 | X_1, X_2] + dots.c + H[X_n | X_1, X_2, dots.c, X_(n-1)]$.

*Proposition.* $D(P || Q) >= 1/2 log_e norm(P - Q)_1^2$.

*Proof.* 两点分布是导数练习题. 一般情况可以映为 $p_i < q_i$ 和 $p_i > q_i$ 两种情况, 然后用 Data processing 不等式. $qed$

*Definition. Differential Entropy.* 

== Ch02 Source Coding

根据 Huffman Coding, 可以构造码长 $l$ 使得 $EE[l(X)] <= H[X] + 1$.

这个 1 并不是本质的. 考虑将 $X_1, X_2, dots.c, X_T$ (独立服从 $X$) 统一编码, 有 $1/T EE[l(X_1, X_2, dots.c, X_T)] <= H[X] + 1/T$. 因此 $H[X]$ 是平均码长的下确界.

*Definition. Entropy rate.* 对随机过程 $cal(X) = (X_t)$, 若 $lim_(T -> infinity) 1/T H[X_1, X_2, dots.c, X_T]$ 存在, 定义其为 $cal(X)$ 的 *entropy rate*, 记为 $cal(H)(cal(X))$.