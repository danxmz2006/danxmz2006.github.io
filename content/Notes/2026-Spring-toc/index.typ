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

Theorem. 正则语言 $<=>$ 存在正则表达式.

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

Theorem. context-free language $<=>$ 存在 PDA.

先证明 context-free 能推出 PDA. 考虑从左往右读的时候维护一个由 $V \/ Sigma$ 构成的栈, 其中栈顶对应当前串的最左边, 栈底对应最右边. 如果栈顶是一个变量, 尝试将其替换为一个串, 将串整个推入栈顶; 否则要求栈顶和当前输入的最左边字符相同, 弹栈并读下一个字符. 

假设语言 $L$ 能被 PDA 识别. 可以假设读完整个串后将栈清空.  

令 $V = {[q X q^prime]}$, 表示当前栈顶为 $X$, 读入一个字符串后状态从 $q$ 转移到 $q^prime$, 然后弹出了 $X$. 转移 $delta(q, X, a) = (p, Y)$ 导出替换 $[q X q^prime] -> a [p Y q^prime]$. 特别地, 如果 $Y = epsilon$ 导出替换 $[q X p] -> a$. 如果 $X = epsilon$, 导出替换 $[q Z q^prime] -> a [p Y r] [r Z q^prime]$, $Z$ 是任何的字符. 令 $a = epsilon$ 可以添加 $epsilon$ 边. 初始 $S -> [q_0 perp q_F].$ 验证的过程挺麻烦. $qed$

=== Boundary for CFL

_Pumping Lemma for CFL._ 若 $A$ 是 CFL, 则存在 $p > 0$, 若 $s in A, |s| >= p$, 有 $s = u v x y z$, 使得 $u v^i x y^i z in A, |v y| > 0, |v x y| <= p$.

设 $G$ 是 $A$ 的 CFL. 设 $b$ 是推导规则右侧长度的上界. 从 $S$ 开始经过 $h$ 次推导后, 得到字符串的长度最多是 $b^h$. 如果 $h >= |V| + 1$, 那么必然经过重复变量. 总之, 若 $|s| >= b^(|V|+1) = p$, 那么某个变量至少经过两次. 设这个变量是 `X`, 即从 `X` 出发, 推了一段时间后推出包含 `X` 的串. 可以假设这个重复发生在最后 $|V|+1$ 次推导过程中. 设此时串形如 `...[...[..]...]...`, 这里 `[]` 内的部分由 `X` 替换而来. 可以取 `u[v[x]y]z`. 那么第一个条件自然满足(可以反复进行 `X` 的替换, 或者不进行第二次替换), 第三个条件由前述性质满足. 为了保证 $|v y| > 0$ 我们令替换的过程是极短的, 第二次 `X` 替换不平凡保证了这一点. $qed$

e.g. $L = {a^n b^n c^n}$. 取 $n >= p$. 循环节至多含有两种字母.

e.g. $L = {a^i b^j c^k | i <= j <= k}$. 取 $i = j = k = p$. 如果 $v x y$ 只包含 $b, c$ 需要删去部分.

== Ch04 Turing Machine

这里给出的定义是 $k$ 带确定性 TM.

定义一个语言是 *Turing-recognizable* 如果某个 TM 接受它.

一个 *decider* 是一个不会进入死循环的 TM. 一个语言是 *Turing-decidable* 的如果一个 decider TM 判定它. Turing-recognizable 情况中我们不要求对于 $x in.not L$, TM 一定停机.

TM 也可以执行长输出, 输出在一个纸带上. $M$ 在 $T(n)$ 时间运行如果运行步数 $<= T(|x|)$, 对于输入 $x$. 若 $T(n)$ 能在 $O(T(n))$ 时间内计算称 $T$ 是 *time-constructible* 的.

=== Variants of TM

改变字母表的大小. 使用字符集 $Gamma$ 在时间 $T(n)$ 内计算 $f: {0, 1}^ast -> {0, 1}$ 的 TM, 总是可以在 $O(T(n) log |Gamma|)$ 内计算, 只使用字符集 ${0, 1, gt.tri, ␣}$.

$k$ 个纸带转 1 个纸带. 可以 $O(k T(n)^2)$ 模拟.

Church-Turing Thesis. 合理计算模型计算能力和 TM 相同.