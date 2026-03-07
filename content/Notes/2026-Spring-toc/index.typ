#import "../index.typ": template, tufted

#show: template.with(
  title: "计算理论导论",
  description: "2026 Spring",
  date: datetime(year: 2026, month: 3, day: 2),
  lang: "zh",
)

= 计算理论导论

== Ch01 Intro, Regular Languages and Automata

一个**确定性有限状态自动机**(DFA)包含 5 元组 $(Q, Sigma, delta: Q times Sigma -> Q, q_0: Q, F subset.eq Q)$, 分别为状态集合, 输入字母表, 状态转移函数, 起始状态和接受状态.

能被 DFA $M$ 接受的字符串集合 $L subset.eq Sigma^(ast)$ 称为 $M$ 的语言. "接受" 无非是一列状态转移的过程.

一个语言是**正则**语言当且仅当其能被一个 DFA 接受.

=== 自动机设计

(先举了一些简单小例子.)

因为 DFA 是可数的但语言是不可数的, 显然存在一个非正则语言.

有一些具体的例子, 可以证明它们不是正则语言.

比如考虑 $L = {1^(n^2) mid(|) n in NN}$. 状态转移图一定是若干个内向基环树, 并且每个环上一定有终止状态, 但是 $a + d NN$ 都是完全平方数是一定不成立的.

对语言的运算. 已知语言 $A, B$, 我们有正常的集合操作. 定义 $A + B$ 为 $A, B$ 中任取元素拼接, $A^ast = {epsilon} union A union (A + A) union (A + A + A) dots$.

对对应的 DFA 也能进行相应的运算. 取反只需交换终止状态和非终止状态. 取并可以对状态取笛卡尔积. 拼接相对麻烦, 需要先造出 NFA 再转 DFA. $A^ast$ 也类似.

一个 NFA 可以视为在 DFA 基础上加入 $epsilon$ 状态转移, 并且转移的结果是一个集合. 具体识别的过程如下: 先读入一个字符 (到达一些可能状态), 再走 $epsilon$ 转移 (任意多步), 最终到达一个可能的状态. 可以先把所有 $epsilon$ 边缩起来.

NFA 可以转为 DFA, DFA 中的一个状态对应 NFA 可能的状态集合.