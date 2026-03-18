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

*Definition. Topology.* 定义 $Omega$ 上的拓扑 $tau$ 为包含 $emptyset$ 和 $Omega$, 在*有限*交和*可数*并下封闭的集族. $tau$ 中元素称为开集; $tau$ 中元素的补称为闭集. 闭集可数并和开集可数交被称为 $F_sigma$ 集和 $G_delta$ 集. 一个典型的拓扑为可数个开球的并构成的开集.

*Definition. Borel $sigma$-algebra.* $cal(B)(Omega) := cal(B)(Omega, tau) := sigma(tau)$, $tau$ 是 $Omega$ 上的拓扑.

存在很多等价的生成 $cal(B)(RR^n)$ 的方式. 有时需要将开集 $A$ 写成可数个开球/开矩形的并, 可以考虑每个有理点的附近.

*Definition. trace of a class of sets.* $eval(cal(A), A) := {A inter B | B in cal(A)}$. 若 $cal(A)$ 是 $Omega$ 上的 $sigma$-代数(或上述别的种类的集族)则 $eval(cal(A), A)$ 是 $A$ 上的 $sigma$-代数(或别的某某).

