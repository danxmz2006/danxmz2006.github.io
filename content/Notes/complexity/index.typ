#import "../index.typ": template, tufted

#show: template.with(
  title: "复杂度理论",
  description: "2026 Spring",
  date: datetime(year: 2026, month: 4, day: 3),
  lang: "zh",
)

#set math.equation(numbering: none)

= 复杂度理论

== Variants of TM

=== Crossing Sequence

将纸带分为左右两半, 则左右两边的计算是相对独立的, 只需给出 TM 在中间往复时候的状态. 这被称为 *crossing sequence* $c_i$. 总运行时间即为 $sum abs(c_i)$.

基于这种技术我们可以给出一些*较少资源*下的分析, 例如单带 v.s. 多带等. 例如, 不妨设单带图灵机运行完了之后移动到了最右边, 那么假设 $c_i = c_j (i < j)$, 我们可以删除 $[i+1, j]$ 之间的输入, 而不改变最终的状态. 再如, 假设总状态数比较少 (e.g. 空间受限), 则 $c_i$ 长度受限, 否则会出现循环.

e.g. 单带 TM 回文串判定时间是 $Omega(n^2)$. 考虑形如 $x^R \# \# dots.c \# x$ 的串, 则对于不同的 $x$, 中间部分的 crossing sequence 两两无交, 否则可以拼接产生 $y^R \# \# dots.c \# x$.

#let DTIME = math.op("DTIME", limits: false)
#let DSPACE = math.op("DSPACE", limits: false)

e.g. 若 $L in DSPACE(o(log log n))$ 或 $L in DTIME(o(n log n))$, 则 $L$ 是正则语言.

=== Construction of an $O(T(n) log T(n))$ Oblivious UTM



== Diagonalization and Separation

回忆对 $sans("HALT")$ 不可判定的证明: 我们将全体 TM 的编码 $alpha_1, alpha_2, dots.c$ 排成一列, 全体输入的编码 $x_1, x_2, dots.c$ 排成一列. $chevron.l alpha, x chevron.r$ 是 $1$ 若 $M_alpha (x)$ 停机. 假设存在 $M$ 判定 $sans("HALT")$, 则构造 $chevron.l alpha, dot.c chevron.r$ 使得 $chevron.l alpha, x_i chevron.r != chevron.l alpha_i, x_i chevron.r$, $M$ 的存在使得 $alpha$ 确实为某个 TM, 矛盾.

通过在编码的前导 $1$, 我们可以认为每个 TM 都在序列中出现无穷多次.

*Theorem.* 设 $f(n) log f(n) = o(g(n))$, 且 $f,g$ 时间可构造. 则存在 $L in DTIME(g(n)), L in.not DTIME(f(n))$.

定义 $M_alpha^f (x)$ 表示 $alpha$ 在 $x$ 上运行至多 $f(abs(x))$ 步, 如果没有停止则输出 $0$. 令 $chevron.l alpha, x chevron.r := M_alpha^f (x)$, 则 $chevron.l alpha, dot.c chevron.r$ 构成全体在 $DTIME(f(n))$ 内的语言. 令语言 $L$ 使得对充分大的 $i$, $L(x_i) != chevron.l alpha_i, x_i chevron.r$. 构造图灵机 $M_alpha (x_i)$ 如下: 设 $U$ 为 $O(T log T)$ 的 UTM, 调用 $U(alpha_i, x_i)$ 并限制运行至多 $g(n)$ 步, 输出 $1$ (超时) 或结果取反. 由于 $f(n) log f(n) = o(g(n))$, 对于充分大的 $i$, 用 $U$ 模拟 $M_alpha^f (x_i)$ 的时间不超过 $g(n)$. $qed$

类似地, 有空间上的结果, 这里只需 $f(n) = o(g(n))$.

=== Non-deterministic Version



== NP Completeness

== Logspace Computability, P Completeness

== PSPACE Complete Problems

== Polynomial Hierarchy, Alternation

== 