#import "../index.typ": template, tufted

#show: template.with(
  title: "概率论",
  date: datetime(year: 2026, month: 3, day: 17),
  lang: "zh",
)

#set math.equation(numbering: none)

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

*Definition.* 称 $mu < infinity$ 为有限的; 若 $Omega = union.big Omega_n, mu(Omega_n) < infinity$ 称 $mu$ 为 $sigma$-有限的. #footnote[测度的信息可由全体 $mu(dot.c inter Omega_n)$ 给出, 所以 $sigma$-有限基本就是有限.]

=== The Measure Extension Theorem

下文的主旨是将 semiring 上的 $mu$ 延拓至 $sigma$-algebra.

考虑 semiring $cal(A)$, 我们加入 $cal(A)$ 上的所有有限无交并, 得到 $cal(A)^prime$; 很自然地, 令 $mu^prime (union.plus.big_(i=1)^n A_i) = sum_(i=1)^n mu(A_i)$.

这样做需要解决良定义的问题. 如果 $union.plus.big_(i=1)^n A_i = union.plus.big_(j=1)^m B_j$, 是否有 $mu^prime (union.plus.big_(i=1)^n A_i) = mu^prime (union.plus.big_(j=1)^m B_j)$? 答案是肯定的, 因为令 $C_(i j) = A_i inter B_j$, $A_i$ 和 $B_j$ 都可写成若干 $C$ 的有限并, 等式无非是交换求和顺序. #footnote[这蕴含延拓后 $mu^prime$ 的定义和 $mu$ 是相容的.]

容易验证 $cal(A)^prime$ 在交并补下都是封闭的, 并且 $Omega in cal(A)^prime$, 所以 $cal(A)^prime$ 是 algebra.

给出代数 $cal(A)$ 中的有限可加测度 $mu_0$, 能否直接如法炮制令 $mu(union.plus.big_(i=1)^infinity A_i) = sum_(i=1)^infinity mu_0 (A_i)$?

这个时候, 我们证明良定义性就会遇到困难: 至少需要保证 $mu|_(cal(A)) = mu_0$, 而这依赖于 $mu_0$ 的可数可加性, 而我们目前只有有限可加性. 事实上, 从有限可加测度延拓至预测度必须引入额外的假设. #footnote[考虑 $mu_0(A) := cases(0 "if" |A| < infinity, 1 "if" |A| = infinity).$]

在证明测度扩张的存在性之前, 先说明对于 $sigma$-有限的预测度 $mu_0$, 所有可能的扩张限制在 $sigma(cal(A))$ 上是唯一的. #footnote[考虑 $RR$ 上全体有限和余有限集构成的代数, 令 $mu_0$ 在前者上取值为 $0$ 在后者上取值 $infinity$. 我们只能推出所有可数集的测度是 $0$. 对于那些既不可数, 也不余有限的集合而言, 让它们的测度是 $0$ 或 $infinity$ 都不会有问题.]

*Lemma. (单调类引理)* 称 $cal(M)$ 是单调类若其中的集合在可数并, 可数交下封闭, 显然单调类的交还是单调类. 称 $cal(M)(cal(A))$ 为包含 $cal(A)$ 的最小单调类. 那么若 $cal(A)$ 为代数, 则 $cal(M)(cal(A)) = sigma(cal(A))$.

$sigma$ 代数要满足的条件强于单调类, 故而只需证明 $cal(M)(cal(A))$ 在代数运算下封闭. 我们使用如下技巧. 以补集为例, 考虑 $M = {A | A^complement in cal(M)(cal(A))}$. 容易验证 $M$ 确实是单调类. $cal(A)$ 对 $complement$ 封闭, 故 $M$ 包含 $cal(A)$ 中所有元素. 但 $cal(M)(cal(A))$ 是最小的包含 $cal(A)$ 的单调类, 故而 $M$ 包含 $cal(M)(cal(A))$ 中所有集合.

对于二元运算可以如法炮制: 以 $union$ 为例, 先固定一个 $A in cal(A)$, 令 $M = {X | A union X in cal(M)(cal(A))}$, 可以说明对任意 $A in cal(A), X in cal(M)(cal(A)), A union X in cal(M)(cal(A))$; 再固定 $X in cal(M)(cal(A))$, 利用 $M^prime = {Y | X union Y in cal(M)(cal(A))}$ 得到最终的结论. $inter$ 类似. $qed$

*Corollary.* 有限测度 $mu_0$ 在 $sigma(cal(A))$ 上的扩展是唯一的. 这容易扩展到 $sigma$ 有限的情况.

对于不同测度 $mu, nu$, 考虑它们取值相等的部分, 根据上下半连续性(由于是有限测度)这构成一个单调类. $qed$

#let tri = math.class("binary", sym.triangle.stroked.t)

为了给出一般预测度的扩张, 我们先考虑有限测度的情况. 此时 $mu_0$ 的各种连续性都是成立的. 我们需要执行某种 "取闭包" 的操作, 这依赖于某种度量 $d(X, Y)$ 的构造, 该度量可以表示集合之间的逼近程度, 因此本质上只和 $X tri Y$ 有关. 记 $d(X, Y) = mu^* (X tri Y)$. #footnote[严格上 $d$ 是"伪度量", 我们允许不等的 $d(X, Y) = 0$.]

$mu^ast$ 需要满足一些性质. 显然 $mu^ast$ 在包含下是单调的. 考虑 $mu^ast |_cal(A)$, 总是可以用自身逼近自身, 故必然有 $mu^ast (A in cal(A)) <= mu_0(A))$. 由于 $mu_0$ 满足可数可加性(进而满足可数次可加性), 等号可以取到. 令 $mu^ast$ 作用在一列偏差的并之上, 这列偏差的误差和不会超过并集的误差, 因此 $mu^ast$ 需要满足可数次可加性.

总之, 1) $mu^ast |_cal(A) = mu_0$, 2) $mu^ast$ 具有可数次可加性. 这被称为*外测度*.

一个满足条件的是 $mu^ast (X) = inf_(X subset union.big A_n) sum_n mu_0(A_n)$. #footnote[注意, $cal(A)$ 中集合的可数并是能用 $cal(A)$ "控制"的最大集合.] $mu^ast$ 作为一个函数在 $d$ 下是 Lipschitz 连续的, 故而有自然的完备化:
$ mu^ast (lim dot.c) = lim mu^ast (dot.c) $

可以令 $mu = mu^ast.$ 验证代数运算下的封闭性是容易的.

已经说明, $sigma$-有限可以由有限测度唯一扩展. 下面说明, 一般测度同样可以由 $sigma$-有限的部分扩展.

考虑 $X subset Omega$. 假设 $X subset F$, $F$ 关于 $mu_0$ $sigma$-有限. $mu(X)$ 可以由 $cal(A) |_F$ 上的部分确定; 对于不同的 $F, F^prime$, 得到的 $mu(X)$ 是相容的, 因为 $F inter F^prime$ 同样 $sigma$-有限. #footnote[对于任何 $E in sigma(cal(A))$, $cal(A)$ 对 $E$ 的限制完全等同于 $cal(A) inter 2^E$ 对 $E$ 的限制, 因为 $cal(A) |_E = cal(A) inter 2^E$.]

如果 $X$ 不包含于任何这样的 $F$, 显见一定有 $mu^ast (X) = infinity$. 无论是否能推出 $X$ 可测, 令 $mu(X) = infinity$. #footnote[可以这么理解: 站在 $cal(A)$ 的角度, 无论怎样测量 $X$, 总会多出一部分; 因此 $cal(A)$ 不可能判定 $mu(X) < infinity$ (当然, 可能可以确定 $mu(X) = infinity$). 我们不能保证 $X$ 一定可测/不可测, 也*不一定*能保证对任何测度都有 $mu(X) = infinity$, 鉴于非 $sigma$-有限情况下测度扩张未必唯一.] 最后可以验证至少限制在 $sigma(cal(A))$ 上 $mu$ 满足一切需要的性质. 这就得到了扩张. $qed$

我们还可以将 $sigma(cal(A))$ 稍稍扩大, 添加所有零测集的子集作为零测集. 这并无困难, ${A union F | A,E in sigma(cal(A)), mu(E) = 0, F subset E}$ 构成 $sigma$-代数.

我不认为测度扩张的问题已经完全解决. 我们将 $2^Omega$ 分解为被 $sigma$-有限集覆盖的"刚性部分"和其余的"半自由"部分, 后者是否可以进一步地分拆, 从而完全确定一个集合是否是自由的? 上述构造能否给出一个比 $sigma(cal(A))$ 更大的 $sigma$-代数? Carathéodory 奇怪的构造在上述刻画下如何表现? 但我们已经知道了需要知道的一切, 故而到此为止.

=== Some Concrete Measures

上述扩张定理要求 $mu_0$ 在代数上是预测度. 然而代数往往是由某个半环扩张而来的, 半环比代数好操作很多. 

*Lemma.* 若 $mu$ 在 semiring $cal(S)$ 上是次可数可加的, 则其在 $cal(S)$ 诱导出的代数 $cal(A)$ 上是预测度.

注意我们总是有 $mu(union.plus.big A_n) >= sum_n mu(A_n)$, 这只需要单调性和有限可加性. 设 $union.plus.big_(k=1)^m S_k = union.plus.big_(n>=1) A_n$, 则 
$ mu(union.plus.big_(k=1)^m S_k) &= sum_(k=1)^m mu(S_k) \ &= sum_(k=1)^m mu(union.plus.big_(n>=1) S_k inter A_n) \ &<= sum_(k=1)^m sum_(n>=1) mu(S_k inter A_n) \ &= sum_(n>=1) sum_(k=1)^m mu(S_k inter A_n) \ &= sum_(n >= 1) mu(A_n). $

中间我们将 $A_n$ 写成有限个 $cal(S)$ 中集合的不交并. 由于 $S_k = union.plus.big_(n >= 1) S_k inter A_n$, 由次可数可加性中间的 $<=$ 成立. $qed$

*Definition. Lebesgue measure.* 考虑 $RR^n$ 中所有左开右闭矩形 $(a, b]$, 这构成一个半环 $cal(A)$. 定义 $mu((a, b]) = product_(k=1)^n (b_k - a_k)$. 我们有次可数可加性成立, 因而可以在 $sigma(cal(A)) = cal(B)(RR^n)$ 上定义测度.

只需验证若 $(a, b] = union.big_(k>=1) (a(k), b(k)]$, 则 $mu((a, b]) <= sum_(k>=1) mu((a(k), b(k)])$.

下述技巧被称为紧性论证 (compactness argument). 我们知道 $RR^n$ 上有限闭集都是紧集, 因此只需适当修改不等式左右两边.

假设 $(a, b]$ 有界, 可以找到 $mu([a_epsilon, b]) >= mu((a, b]) - epsilon, mu((a(k), b_epsilon(k))) <= mu((a(k), b(k))) + epsilon / 2^(k+1)$, 于是 $[a_epsilon, b] subset union.big (a(k), b_epsilon(k))$. 由于开覆盖有有限子覆盖, 可以令 $k <= n$ 使得 $subset$ 依然成立, 而有限次可加性是平凡的.

无界的情况, 可以找到有界子区间 $mu([a_M, b_M]) >= M$, 仍旧调用上述做法可知 $R H S >= M, forall M > 0$. $qed$

记得到的测度是 $lambda^n$.

*Definition. Lebesgue-Stieljies measure.* 对右连续, 单调递增的 $F$, 令 $mu((a, b]) = F(b) - F(a)$. 延拓出的 $cal(B)(RR)$ 上的测度记为 $mu_F$.

若额外要求 $F(-infinity) = 0, F(+infinity) = 1$ 则 $F$ 称为分布函数, 其诱导出概率测度 $mu$; 另一方面, 给定概率测度 $mu$, $x mapsto mu((-infinity, x])$ 确实构成分布函数.

*Definition. Bernoulli measure.* 考虑可数次独立 Bernoulli 试验构成的空间. 代数 $cal(A)$ 为有限前缀固定的试验, 定义 $mu([omega_1, dots.c, omega_n]) = product_(i=1)^n p_(omega_i)$.

我们说明 $cal(A)$ 中的元素都是紧集. 假设 $A subset union.big_(n >= 1) A_n$. 令 $B_n = A backslash union.big_(k=1)^n A_k$. 假设 $forall n, B_n != emptyset$. 如果对于所有 $omega$, $[omega] inter B_n != emptyset$ 都只对有限多个 $n$ 成立, 那么取这些 $n$ 的最大值可得和假设矛盾. 设 $[omega_1] inter B_n != emptyset, forall n$. 假设对于某个 $n$, $(omega_k) in.not B_n$.

$B_n$ 是一些 $C_1, C_2, dots.c, C_m in cal(A)$ 的无交并. 因此存在某个 $i$, 对于所有 $k, [omega_1, dots.c, omega_k] inter C_i != emptyset$. 根据 $C_i$ 的构成可知矛盾. $qed$

记 $(sum_(e in E) p_e delta_e)^(times.circle NN) := mu$.

=== Approximation Theorem for Measures

*Theorem.* 设 $cal(A)$ 是半环, $mu$ 是 $sigma(cal(A))$ 上的 $sigma$-有限测度. 

  (i) 设 $A in sigma(cal(A))$, $mu(A) < infinity$. $forall epsilon > 0$, 存在 $cal(A)$ 中 $n$ 个两两不交的集合使得 $mu(A tri union_(k=1)^n A_k) < epsilon$.

  (ii) 设 $A in sigma(cal(A))$, $forall epsilon > 0$, 存在一列 $cal(A)$ 中两两不交的集合覆盖 $A$, 并且多出来的部分测度 $<epsilon$.

  (iii) 设 $A$ $mu^*$-可测. 存在 $A_- subset A subset A_+, A_-, A_+ in sigma(cal(A))$, $A_+ backslash A_-$ 是零测集.

(i) 我们有 $mu(A) = mu^*(A)$, 故存在一列 $(B_n in cal(A))$ 使得 $A subset union.big B_n, mu(A) >= sum_(n>=1) mu(B_n) - epsilon / 2$. 设 $sum_(n > N) mu(B_n) < epsilon / 2$, 根据三角不等式 $mu(A tri union.big_(n=1)^N B_n) <= mu(A tri union.big_(n>=1) B_n) + mu(union.big_(n > N) B_n) < epsilon$.

(ii) 可以归约到有限测度的情形 (注意 $epsilon = sum_(n >= 1) epsilon 2^(-n)$). 上述 $B_n$ 未必两两不交, 但是可以令 $B_n <- B_n inter (inter.big_(k=1)^(n-1) B_k^complement)$, 得到的东西依然可以写成有限个 $cal(A)$ 中集合的无交并, 最后排成一列.

(iii) 依然归约到有限测度. 利用 (ii), 我们可以同时从上方和下方逼近. 然后只需注意到 $mu*(A_+ backslash A_-) = mu^*(A_+ backslash A) + mu^*(A backslash A_-).$ $qed$

*Corollary.* $cal(B)(RR^n)$ 中, 对任何 $A, epsilon > 0$, 存在开集 $U$ 使得 $lambda^n (U backslash A) < epsilon$, 此性质被称为*外正则性*. 类似地, 若 $lambda^n (A) < infinity$, 可以由紧集从内任意逼近, 此性质被称为*内正则性*.

后者可能稍费功夫: 设 $lambda^n (A) < infinity$, 存在一列基 $B_k, A subset union.big B_k, sum_k lambda^n (B_k) < lambda^n (A) + epsilon / 2$. 设 $sum_(k > N) lambda^n (B_k) < epsilon / 2$, 用充分大的 $[-M, M]^n$ 覆盖 $union.big_(k <= N) B_k$, 有 $lambda^n (A) - lambda^n (A inter [-M, M]^n) < epsilon / 2$. 存在一个开集 $U supset (A inter [-M, M]^n)^complement, lambda^n (U backslash (A inter [-M, M]^n)^complement) < epsilon / 2$, 于是 $[-M, M]^n backslash U$ 即为所求. $qed$

*Definition.* $(Omega, cal(A), mu)$ 是完备的若零测集 $cal(N)_mu subset cal(A)$.

=== Measurable Maps

*Definition.* 使得可测集的原像仍为可测集的映射称为*可测映射*.

*Definition.* 考虑映射 $f : Omega -> Omega'$, $(Omega', cal(A)')$ 为一测度空间. 则 $f^(-1)(cal(A)) := {f^(-1)(A') | A' in cal(A)'}$ 为最小的 $sigma$-代数使得 $f$ 可测. 这被称为由 $f$ *生成*的 $sigma$-代数. #footnote[$f^-1$ 是集合运算下的一个性质很好的同态.]

假设想验证 $f$ 是不是可测的. 这里的问题在于像集中的 $sigma$ 代数可能很大. 我们更希望只验证生成该 $sigma$ 代数的集族.

*Theorem. Measurability on a generator.* 设 $cal(E)' subset cal(A)'$ 是一族 $cal(A)'$-可测集. 则 $sigma(f^(-1)(cal(E)')) = f^(-1)(sigma(cal(E)'))$. 进而 $f$ 是 $cal(A)-sigma(cal(E)')$-可测的当且仅当 $f^(-1)(E') in cal(A)$, 对于所有 $E' in cal(E)'$. 特别地, $sigma(cal(E)') = cal(A)'$ 时 $f$ 是 $cal(A)-cal(A)'$ 可测的当且仅当 $X^(-1)(cal(E)') subset cal(A)$.

鉴于右式是 $sigma$ 代数, $subset$ 方向是容易的. 为了验证 $supset$ 方向, 令 $cal(A)'_0 = {A' in sigma(cal(E)') | f^(-1)(A') in sigma(f^(-1)(cal(E)'))}$, 只需验证其是 $sigma$ 代数即可.

取 $f : A arrow.r.hook Omega$ 为平凡的嵌入. 我们得到 $sigma(cal(E)) stretch(|, size: #150%)_A = sigma(cal(E) stretch(|, size: #150%)_A)$.

另一个推论是连续映射是 Borel 可测的.

*Theorem.* 设 $(Omega, cal(A))$ 可测, $f_1, f_2, dots.c, f_n : Omega -> RR$. 设 $f := (f_1, f_2, dots.c, f_n) : Omega -> RR^n$, 则 $f$ 可测当且仅当 $f_i$ 可测.

假设 $f_i$ 均可测, 考察所有 $RR^n$ 中 $(-infinity, b)$ 的原像即可得到 $f$ 可测. 对于另一个方向, 注意到坐标投影是连续的. $qed$

从而, 能推出常见四则运算作用在可测函数上都是可测的.

*Theorem.* $inf, sup, liminf, limsup$ 作用在一列可测函数上是可测的. 需要考虑扩充的实数集 $overline(RR)$.

考虑 $(inf_n f_n)^(-1) ([-infinity, a)) = union_n f_n^(-1) ([-infinity, a))$ 等等. $qed$

*Definition. 简单函数.* $(Omega, cal(A))$ 上的简单函数形如 $f = sum_(i=1)^n alpha_i chi_(A_i), A_i in cal(A)$.

注意到我们可以进行调整使得 $A_i inter A_j = emptyset$.

*Theorem.* 设 $f : Omega -> [0, +infinity]$ 可测. (i) 存在一列简单函数 $f_n arrow.t f$. (ii) $f$ 可以写成 $sum_(n=1)^infinity alpha_n chi_(A_i)$.

(i) 取 $f_n = min{n, 2^(-n) floor(2^n f)}$. (ii) $f_n - f_(n-1)$ 总是简单函数, $f$ 可以写成这些简单函数的和. $f$ 有界的情况下可以一致逼近. $qed$

*Corollary. Factorization Lemma.* 设 $(Omega', cal(A)')$ 可测, $Omega != emptyset, f : Omega -> Omega'$. $g : Omega -> overline(RR)$ 是 $sigma(f)-cal(B)(overline(R))$-可测的当且仅当存在可测 $phi : (Omega', cal(A)') -> (overline(R), cal(B)(cal(R)))$ 使得 $g = phi compose f$.

$<==$ 方向显然. 对 $==>$ 方向若 $g >= 0$ 设 $g = sum_(n=1)^infinity alpha_n xi_(A_n), A_n in sigma(f).$ 根据 $sigma(f)$ 的定义存在 $B_n in cal(A)', f^(-1)(B_n) = A_n$. 于是 $phi = sum_(n=1)^infinity alpha_n xi_(B_n)$ 满足条件. 一般情况可以拆成 $g = g^+ - g^-$.

对可测映射 $f : (Omega, cal(A)) -> (Omega', cal(A)')$, $Omega$ 上的测度 $mu$ 可以对 $f^(-1)$ 做拉回到 $Omega'$ 上的测度. 则会被称为 $mu$ 在 $f$ 下的像测度.

*Theorem. (Lusin)* 设 $f : RR -> RR$ Borel 可测. $forall epsilon > 0$, 存在闭集 $C subset R$ 使得 $lambda(RR backslash C) < epsilon$ 使得 $f stretch(|, size: #150%)_C$ 在 $C$ 上连续.

对于 $f = chi_A$, 由内正则性可以取 $C subset A, lambda(A backslash C) < epsilon$.

对于简单函数 $f = sum_i alpha_i chi_(A_i)$, $A_i$ 两两无交, 可以如法炮制, 利用闭集的有限并还是闭集.

有界的 $f$ 可以由简单函数 $phi_n$ 一致逼近. 设 $C_n$ 为 $phi_n$ 得到的闭集, $lambda(RR backslash C_n) < epsilon 2^(-n)$. 则 $C = inter_n C_n$ 仍为闭集满足 $lambda(RR backslash C) < epsilon$. 一致收敛的连续函数收敛到连续函数.

对于未必有界的 $f$, 首先将定义域 $RR$ 分成 ${[n, n+1] | n in ZZ}$. 我们构造 $C_n subset S_n = [n + epsilon 2^(-abs(n) - 2), n + 1 - epsilon 2^(-abs(n) - 3)]$. 具体的, 由于 $S_n = union.big_(k > 0) f^(-1)((-infinity, k]) inter S_n$, 测度的连续性使得我们可以取充分大的 $k$, 差集的测度至多为 $epsilon 2^(-abs(n) - 3)$. 之后再用内正则性即可得到 $C_n$.

一般而言闭集的可数并未必是闭集, 但这里我们特殊分离性质保证了这一点. $qed$