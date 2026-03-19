#import "../index.typ": template, tufted

#show: template.with(
  title: "概率论",
  date: datetime(year: 2026, month: 3, day: 17),
  lang: "zh",
)

= 概率论

== Ch01 Basic Measure Theory, Topology, etc.

_Notations._ 约定 $inter$-closed, $union$-closed 是在运算下封闭. $sigma$- 前缀表示可数操作下封闭. $inter$-closed 集族也被称为 *$pi$-system*.

*Definition. $sigma$-algebra.* $cal(A) subset 2^Omega$ 满足 (i) $Omega in cal(A)$; (ii) $complement$-closed; (iii) $sigma$-$	union$-closed.

注意由于 $A backslash (A backslash B) = A inter B$, $backslash$-closed 蕴含 $inter$-closed.

*Definition. algebra.* $cal(A) subset 2^Omega$ 满足 (i) $Omega in cal(A)$; (ii) $backslash$-closed; (iii) $union$-closed.

*Definition. ring.* 将上述定义中 $Omega in cal(A)$ 改为 $emptyset in cal(A)$. #footnote[视对称差为加法, 交为乘法, 则 $cal(A)$ 的确构成(不一定含幺)的环; 如果加强为 algebra, 则其构成抽象代数中的代数, 其同时具有环结构和 $FF_2$-向量空间结构, 并且两者是相容的.]

*Definition. semiring.* 将上述定义中的 (ii) 改为 $B backslash A$ 可以写成有限个 $cal(A)$ 元素的无交并, (iii) 改为 $inter$-closed.

*Definition. $lambda$-system.* (i) $Omega in cal(A)$; (ii) $backslash$-closed (iii) $sigma$-$union.plus$-closed. 这个符号是无交并.

*Definition. * $ liminf_(n -> infinity) := union.big_(n >= 1) inter.big_(m >= n), limsup_(n -> infinity) := inter.big_(n >= 1) union.big_(m >= n). $ 类似下极限和上极限. $sigma$-代数对 $liminf$ 和 $limsup$ 封闭.

设 $cal(A)_i (i in I)$ 是一族 $sigma$-代数, 则所有 $cal(A)_i$ 取交仍是 $sigma$-代数. 对一些更弱的结构这一点也成立.

鉴于此, 对包含 $cal(E)$ 的 $sigma$-代数取交可以得到一个最小者, 即为 $sigma(cal(E))$. 类似的记 $delta(cal(E))$ 为最小的包含 $cal(E)$ 的 $lambda$-系统.

*Theorem.* 若 $cal(D)$ 是 $lambda$-system 则其为 $sigma$-algebra 等价于其为 $pi$-system.

这无非是定义的操演. $qed$

下图表示了常见集族和包含关系.

#image("imgs/fig1-1.png", width: 50%)

*Theorem. Dynkin's $pi-lambda$ theorem.* 对于 $pi$-system $cal(E)$, $sigma(cal(E)) = delta(cal(E))$.

"$supset$" 方向是显然的. "$subset$" 要求证明 $delta(cal(E))$ 是 $sigma$-代数, 进而由上述结论只用证明它是 $pi$-system.

设 $B in delta(cal(E))$, 我们要证明 $forall A in delta(cal(E)), A inter B in delta(cal(E))$. 如果证明 ${A | A inter B in delta(cal(E))}$ 构成 $lambda$-system 即可证明所有 $delta(cal(E))$ 都满足这个条件.

1. $Omega inter B = B in delta(cal(E))$.

2. 若 $C, D in delta(cal(E)), C inter B in delta(cal(E)), D inter B in delta(cal(E))$, 我们有 $(C backslash D) inter B = (C inter B) backslash (D inter B) in delta(cal(E))$.

3. 若 $A_i inter B in delta(cal(E)), A_i inter A_j = emptyset$, 则 $(union.plus.big A_i) inter B = union.plus.big (A_i inter B) in delta(cal(E))$. $qed$

*Definition. topology.* 定义 $Omega$ 上的拓扑 $tau$ 为包含 $emptyset$ 和 $Omega$, 在*有限*交和*可数*并下封闭的集族. $tau$ 中元素称为开集; $tau$ 中元素的补称为闭集. 闭集可数并和开集可数交被称为 $F_sigma$ 集和 $G_delta$ 集. 一个典型的拓扑为可数个开球的并构成的开集.

*Definition. Borel $sigma$-algebra.* $cal(B)(Omega) := cal(B)(Omega, tau) := sigma(tau)$, $tau$ 是 $Omega$ 上的拓扑.

存在很多等价的生成 $cal(B)(RR^n)$ 的方式. 有时需要将开集 $A$ 写成可数个开球/开矩形的并, 可以考虑每个有理点的附近.

*Definition. trace of a class of sets.* $cal(A)|_A := {A inter B | B in cal(A)}$. 若 $cal(A)$ 是 $Omega$ 上的 $sigma$-代数(或上述别的种类的集族)则 $cal(A)|_A$ 是 $A$ 上的 $sigma$-代数(或别的某某).

#let smallcirc = math.class("binary", math.circle.small)

现在考虑定义在 $cal(A) subset 2^Omega$ 上, 取值 $[0, infinity]$ 的函数 $mu$. 称其*可数可加*(或 $sigma$-可加)若对一列集合有 $mu smallcirc union.plus.big^infinity = sum^infinity smallcirc mu$, 如果无交并确在 $cal(A)$ 内. 类似有次可数可加(小于等于), 只限于有限和则去掉"可数", 等等. 若 $A subset B => mu(A) <= mu(B)$ 则称 $mu$ 单调.

后文我们至少假设 $mu$ 是有限可加的, 并且 $cal(A)$ 至少是 semiring(这蕴含 $mu$ 是单调的). 满足 $sigma$-可加的 $mu$ 被称为 *premeasure*. 若进一步 $A$ 是 $sigma$-代数则 $mu$ 是 *measure*.

注意到 $mu$ 一定是 subadditive 的(考虑从前往后排除掉和之前集合的交集), 并且 $sigma$-additive 可以推出 $sigma$-subadditive.

另一方面, 若 $A$ 是一个 ring, 对于一列不交的 $A_i$ 一定有 $sum_(n=1)^infinity mu(A_i) <= mu(union.plus.big_(n=1)^infinity A_n)$, 这可以对前 $n$ 个 $A_i$ 得到不等式再取极限. 这和 subadditive 的方向刚好是反的, 因此 $sigma$-additive 等价于 $sigma$-subadditive. 我们只需补充连续性条件即可将 $mu$ 强化为 premeasure. 

连续性条件有若干等价形式, 它们*几乎*等价于上式可以取等. 唯一的麻烦在于我们的定义允许 $mu(A) = +infinity$, 而无穷不能用来做减法. 

具体地, 若对 $A_1 subset A_2 subset dots.c$ 成立 $lim smallcirc mu = mu smallcirc lim$ 称 $mu$ 下半连续; 若对 $A_1 supset A_2 supset dots.c$ 且至少有一个 $mu(A_n) < infinity$ 成立称 $mu$ 上半连续; 若对 $A_1 supset A_2 supset dots.c$ 且 $lim A_n = emptyset$ 成立称 $mu$ $emptyset$-连续.

下半连续和 $sigma$-additive 的等价性是不难验证的; 上半连续和 $emptyset$-连续的等价性也显然(直接和极限做差). 然而只能由下半连续推出 $emptyset$-连续等, 而不能反过来.

*Definition.* 称 $mu < infinity$ 为有限的; 若 $Omega = union.big Omega_n, mu(Omega_n) < infinity$ 称 $mu$ 为 $sigma$-有限的.

=== The Measure Extension Theorem

下文的主旨是将 semiring 上的 $mu$ 延拓至 $sigma$-algebra.

考虑 semiring $cal(A)$, 我们加入 $cal(A)$ 上的所有有限无交并, 得到 $cal(A)^prime$; 很自然地, 令 $mu^prime (union.plus.big_(i=1)^n A_i) = sum_(i=1)^n mu(A_i)$.

这样做需要解决良定义的问题. 如果 $union.plus.big_(i=1)^n A_i = union.plus.big_(j=1)^m B_j$, 是否有 $mu^prime (union.plus.big_(i=1)^n A_i) = mu^prime (union.plus.big_(j=1)^m B_j)$? 答案是肯定的, 因为令 $C_(i j) = A_i inter B_j$, $A_i$ 和 $B_j$ 都可写成若干 $C$ 的有限并, 等式无非是交换求和顺序. #footnote[这蕴含延拓后 $mu^prime$ 的定义和 $mu$ 是相容的.]

容易验证 $cal(A)^prime$ 在交并补下都是封闭的, 并且 $Omega in cal(A)^prime$, 所以 $cal(A)^prime$ 是 algebra.

能否直接如法炮制令 $mu^(prime prime)(union.plus.big_(i=1)^infinity A_i) = sum_(i=1)^infinity mu^prime (A_i)$?

这个时候, 我们证明良定义性就会遇到困难: 至少需要保证 $mu^(prime prime)|_(cal(A)^prime) = mu^prime$, 而这依赖于 $mu^prime$ 的可数可加性, 而我们目前只有有限可加性. 事实上, 从有限可加测度延拓至预测度必须引入额外的假设. #footnote[考虑 $mu(A) := cases(0 "if" |A| < infinity, infinity "if" |A| = infinity).$]

假设 $mu^prime$ 是预测度. 另一个困难在于, 代数中元素的可数并未必构成 $sigma$-代数(取补不封闭, 可数并的补集是可数交).

且慢, 我们所做的事情无非是对一列上升集合 $A_n$ 加入它们的极限 $A$, 这是一个完备化的过程. 限制 $A_n$ 上升看上去自缚手足. 完备化的起点是一个度量. 令 $d(A_1, A_2) = mu^prime (A_1 backslash A_2) + mu^prime (A_2 backslash A_1)$. #footnote[这其实是一个 pseudo-metric, 因为可能有 $d(A, emptyset) = 0$ 但 $A eq.not emptyset$, 但这并不会造成太大的困难. 这样的 $A$ 被称为零测集. 实际上可以商去零测集.]

