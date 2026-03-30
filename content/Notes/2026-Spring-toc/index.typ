#import "../index.typ": template, tufted

#show: template.with(
  title: "计算理论导论",
  description: "2026 Spring",
  date: datetime(year: 2026, month: 3, day: 6),
  lang: "zh",
)

#set math.equation(numbering: none)

= 计算理论导论

== Ch01 Intro, Regular Languages and Automata

一个*确定性有限状态自动机*(DFA)包含 5 元组 $(Q, Sigma, delta: Q times Sigma -> Q, q_0: Q, F subset.eq Q)$, 分别为状态集合, 输入字母表, 状态转移函数, 起始状态和接受状态.

能被 DFA $M$ 接受的字符串集合 $L subset.eq Sigma^(ast)$ 称为 $M$ 的语言. "接受" 无非是一列状态转移的过程.

一个语言是*正则*语言当且仅当其能被一个 DFA 接受.

=== 自动机设计

(先举了一些简单小例子.)

因为 DFA 是可数的但语言是不可数的, 显然存在一个非正则语言.

有一些具体的例子, 可以证明它们不是正则语言.

比如考虑 $L = {1^(n^2) mid(|) n in NN}$. 状态转移图一定是若干个内向基环树, 并且每个环上一定有终止状态, 但是 $a + d NN$ 都是完全平方数是一定不成立的.

#let smallcirc = math.class("binary", math.circle.small)

对语言的运算. 已知语言 $A, B$, 我们有正常的集合操作. 定义 $A smallcirc B$ 为 $A, B$ 中任取元素拼接, $A^ast = {epsilon} union A union (A smallcirc A) union (A smallcirc A smallcirc A) dots$.

对对应的 DFA 也能进行相应的运算. 取反只需交换终止状态和非终止状态. 取并可以对状态取笛卡尔积. 拼接相对麻烦, 需要先造出 NFA 再转 DFA. $A^ast$ 也类似.

一个 NFA 可以视为在 DFA 基础上加入 $epsilon$ 状态转移, 并且转移的结果是一个集合. 具体识别的过程如下: 先读入一个字符 (到达一些可能状态), 再走 $epsilon$ 转移 (任意多步), 最终到达一个可能的状态. 可以先把所有 $epsilon$ 边缩起来.

NFA 可以转为 DFA, DFA 中的一个状态对应 NFA 可能的状态集合.

== Ch02 Regular Languages v.s. Regular Expressions

定义 $R$ 是*正则表达式*如果 $ R = a in Sigma | epsilon | emptyset | R_1 union R_2 | R_1 smallcirc R_2 | R_1^ast. $

*Theorem.* 正则语言 $<=>$ 存在正则表达式.

从右到左即为上次的结论.

对一个 NFA, 我们考虑一个中间状态 GNFA: 每条边是正则表达式的 NFA. NFA 是 GNFA.

我们可以用如下手段删去一个点 $w$: 对于 $u -> w -> v$, 在 $u, v$ 间连边 $R(u, w) smallcirc R(w, w)^ast smallcirc R(w, v)$. 可能出现重边, 用并集代替. 最后 $R(q_(s t a r t), q_(e n d))$ 即为所求的正则表达式. $qed$

_Pumping Lemma_. 如果 $A$ 是正则语言, 那么存在 $p$ 使得如果 $s in A$, $|s| >= p$ 则 $s = x y z$ 使得 (1) $forall i >= 0, x y^i z in A$ (2) $|y| > 0$ (3) $|x y| <= p$.

直观上看, DFA 上的任何一个足够长的 walk 一定有环.

令 $p = |Q|$, $r_1, r_2, dots, r_(n+1)$ 是读 $s$ 的时候经过的状态. 由 $n+1 > |Q|$ 知一定存在 $i < j, r_i = r_j$. 取最小的 $j$, 一定有 $j <= p + 1$. 令 $y$ 为从 $r_i$ 到 $r_j$ 接受的子串, 则三个条件均满足. $qed$

用这个技术容易证明很多语言不是正则语言. 需要特别注意的是 pumping lemma 允许 $i = 0$. 有些情况下还是得寻求别的方法刻画语言的性质.

== Ch03 Context-free Language and Pushdown Automata

一个 *context-free grammar* 是一个四元组 $(V, Sigma, R, S)$. $V$ 为变量构成的有限集, $Sigma$ 为字母表, 被称为 terminals. $R$ 为 $V$ 到 $(V union Sigma)^ast$ 的一些规则. $S$ 为起始变量.

设 $A -> w$ 是一个文法的规则, 则有推出规则 $u A v => u w v$. $S$ 在有限步内能推出的字符串集合被称为文法之语言.

下面寻找对应的计算模型. 一个*下推自动机*为在 NFA 基础上加入一个栈. 每次转移需要看栈顶的字符, 并压入/弹出一个字符.

*Theorem.* context-free language $<=>$ 存在 PDA.

先证明 context-free 能推出 PDA. 考虑从左往右读的时候维护一个由 $V \/ Sigma$ 构成的栈, 其中栈顶对应当前串的最左边, 栈底对应最右边. 如果栈顶是一个变量, 尝试将其替换为一个串, 将串整个推入栈顶; 否则要求栈顶和当前输入的最左边字符相同, 弹栈并读下一个字符. 

假设语言 $L$ 能被 PDA 识别. 可以假设读完整个串后将栈清空.  

令 $V = {[q X q^prime]}$, 表示当前栈顶为 $X$, 读入一个字符串后状态从 $q$ 转移到 $q^prime$, 最后弹出了 $X$ (中途未弹出 $X$). 转移 $delta(q, X, a) = (p, Y)$ 导出替换 $[q X q^prime] -> a [p Y q^prime]$. 特别地, 如果 $Y = epsilon$ 导出替换 $[q X p] -> a$. 如果 $X = epsilon$, 导出替换 $[q Z q^prime] -> a [p Y r] [r Z q^prime]$, $Z$ 是任何的字符. 如果 $X = Y = epsilon$, 替换 $[q Z q^prime] -> a [p Z q^prime]$. 令 $a = epsilon$ 可以添加 $epsilon$ 边. 初始 $S -> [q_0 perp q_F].$ 

需要说明 $[q Z q^prime]$ 包含且仅包含那些 "存在 $q --> q^prime$ 的接受路径, 栈的状态从仅包含 $Z$ 到最终删空的字符串".

假设 $x$ 可以被按照如此方式接受. 那么存在路径 $(p_0 = epsilon, q_0 = q, s_0)->(p_1, q_1, s_1)->(p_2, q_2, s_2)->dots.c->(p_k = x, q_k=q^prime, s_k)$, 其中 $s_i$ 为栈的状态, $p_i$ 为已接受部分构成的前缀. 对 $k$ 归纳. 如果栈自始至终都保持不变则每一步的推导规则都给出了. 否则考虑第一次压栈的位置和第一次弹出这个位置, 可以用一次推导规则后针对两个 $[dots]$ 用归纳假设.

反过来, 需要证明 $[q Z q^prime]$ 只能推出被接受的 $x$. 我们对替换次数归纳并讨论第一次替换所使用的规则, 在新产生的变量上用归纳假设. $qed$ #footnote[和正则语言的情况不同的是, 下推自动机基本上并没有什么好的性质. 多数结论都是用 CFG 本身推出来的.]

=== Boundary for CFL

_Pumping Lemma for CFL._ 若 $A$ 是 CFL, 则存在 $p > 0$, 若 $s in A, |s| >= p$, 有 $s = u v x y z$, 使得 $u v^i x y^i z in A, |v y| > 0, |v x y| <= p$.

设 $G$ 是 $A$ 的 CFL. 设 $b$ 是推导规则右侧长度的上界. 从 $S$ 开始经过 $h$ 次推导后, 得到字符串的长度最多是 $b^h$. 如果 $h >= |V| + 1$, 那么必然经过重复变量. 总之, 若 $|s| >= b^(|V|+1) = p$, 那么某个变量至少经过两次. 设这个变量是 `X`, 即从 `X` 出发, 推了一段时间后推出包含 `X` 的串. 可以假设这个重复发生在最后 $|V|+1$ 次推导过程中. 设此时串形如 `...[...[..]...]...`, 这里 `[]` 内的部分由 `X` 替换而来. 可以取 `u[v[x]y]z`. 那么第一个条件自然满足(可以反复进行 `X` 的替换, 或者不进行第二次替换), 第三个条件由前述性质满足. 为了保证 $|v y| > 0$ 我们令替换的过程是极短的, 第二次 `X` 替换不平凡保证了这一点. $qed$

e.g. $L = {a^n b^n c^n}$. 取 $n >= p$. 循环节至多含有两种字母.

e.g. $L = {a^i b^j c^k | i <= j <= k}$. 取 $i = j = k = p$. 如果 $v x y$ 只包含 $b, c$ 需要删去部分.

CFL 的一个好处在于它很适合表达那些 "某个局部性质被破坏" 的语言. 例如, 它可以表达所有发生错误的 TM 计算过程.

== Ch04 Turing Machine

这里给出的定义是 $k$ 带确定性 TM.

定义一个语言是 *Turing-recognizable* 如果存在 M, 当且仅当输入该语言时, M 停机并接受.

一个 *decider* 是一个不会进入死循环的 TM. 一个语言是 *Turing-decidable* 的如果一个 decider TM 判定它. Turing-recognizable 情况中我们不要求对于 $x in.not L$, TM 一定停机.

TM 也可以执行长输出, 输出在一个纸带上. $M$ 在 $T(n)$ 时间运行如果运行步数 $<= T(|x|)$, 对于输入 $x$. 若 $T(n) >= n$ 的二进制表示能在 $T(n)$ 时间内计算称 $T$ 是 *time-constructible* 的.

=== Variants of TM

改变字母表的大小. 使用字符集 $Gamma$ 在时间 $T(n)$ 内计算 $f: {0, 1}^ast -> {0, 1}$ 的 TM, 总是可以在 $O(T(n) log |Gamma|)$ 内计算, 只使用字符集 ${0, 1, gt.tri, ␣}$.

$k$ 个纸带转 1 个纸带. 可以 $O(k T(n)^2)$ 模拟.

Church-Turing Thesis. 合理计算模型计算能力和 TM 相同.

=== Universal TM

存在图灵机 $U$, 输入任何 $alpha, x in {0, 1}^*$, $U(x, alpha) = M_alpha(x)$. $alpha$ 给出一个图灵机的描述. 设 $M_alpha$ 停机时间是 $T(n)$, 则 $U(x, alpha)$ 运行时间是 $O(T(n) log T(n))$.

$O(T(n)^2)$ 的构造相对平凡, 而 $O(T(n) log T(n))$ 的构造非常智慧 (大致是将纸带分为大小为 2 的幂的块之后定时重构). 这个 UTM 可以是 oblivious 的. 

== Ch05 Computability

本讲针对 recognize-decide 之间差别对问题/语言进行分类.

由于 TM 是可数的, ${0, 1}^* -> {0, 1}$ 是不可数的, 显然存在不可被识别的语言. 将图灵机排成一列, 具体构造就是对角线构造 $"UC"(x) = not M_x (x)$.

定义 $sans("HALT") = {chevron.l M, alpha chevron.r | M "halts on" alpha}$. 我们说明 $sans("HALT")$ 不可判定.

设矩阵 $chevron.l M, alpha chevron.r$ 的位置为是否停机, 依然用对角线法, 假设可以判定, 可以构造一个不在矩阵中的行. $qed$

另一种证法是假设存在一个 $M_("HALT")$, 把它作为 oracle 我们可以构造一个 $M_("UC")$. 这种做法称为*归约*.

#show sym.lt.eq: math.scripts

Mapping reduction: $A <=_m B$ 当且仅当存在可计算函数 $f$, $forall w, w in A <-> f(w) in B$.

e.g. 证明 $E_(T M) = {M | M "accepts" emptyset}$ 是 undecidable 的.

我们说明 $A_(T M) = {chevron.l M, alpha chevron.r | M "accepts" alpha} <=_m overline(E_(T M))$. 令 $f(chevron.l M, alpha chevron.r) = M^prime$, 这里 $M^prime$ accepts 当且仅当输入为 $alpha$ 且 $M$ 接受 $alpha$.

e.g. 证明 $E Q_(T M) = {chevron.l, M_1, M_2, chevron.r | M_1 "and" M_2 "are TMs and have the same language"}$ undecidable.

取 $L(M_2) = emptyset$, 有 $E_(T M) <=_m E Q_(T M)$.

可以发现, $sans("HALT")$ 和 $A_(T M)$ 都是 recognizable 且 undecidable 的.

*Theorem.* $A$ 是 decidable 的当且仅当 $A, overline(A)$ 是 recognizable 的.

从左到右是显然的. 假设 $A$ 和 $overline(A)$ 都 recognizable 的, 我们可以同步运行 recognize $A$ 和 $overline(A)$ 的 TM (每次运行一步), 最终一定停机.
