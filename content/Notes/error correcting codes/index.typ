#import "../index.typ": template, tufted

#show: template.with(
  title: "Error Correcting Codes",
  description: "UCB CS 294-226",
  date: datetime(year: 2026, month: 7, day: 5),
  lang: "en",
)

= Error Correcting Codes

== Settings

*Definition.* A *code* $cal(C)$ is a subset of $Sigma^n$. $n$ is called *block length*. There is an *encoding scheme* $"Enc"$ that maps a message to $c in cal(C)$, then some kind of channel (e.g. erasure, deletion, error) add noise $c mapsto c'$, and a *decoding scheme* $"Dec"$ tries to restore the original message. The *code rate* $R = (log(abs(cal(C)))) / (n log abs(Sigma)) <= 1$. #footnote[Sometimes $R$ takes $n -> infinity$.]

*Hamming bound.* Let $cal(C)$ be a $q$-ary code of block length $n$ and mininum Hamming distance $d$. then

$ abs(cal(C)) <= q^n / (sum_(i=0)^floor((d-1)\/2) binom(n, i) (q-1)^i). $

Let $q^(n H_q (delta, n)) = sum_(i=0)^(delta n) binom(n, i) (q-1)^i$. Then $R <= 1 - H_q (d / (2 n), n)$.

Let $h_q (delta) = delta log_q (q-1)/delta + (1-delta) log_q 1/(1-delta)$. When $delta <= 1 - 1/q$, $H_q (delta, n) = h_q (delta) + O((log n) / n)$ as $n -> infinity$.

e.g. Binary codes against 1-bit error. The _Varshamov-Tenengolts code_ $"VT"_a (n)$ are binary vectors $(x_1,x_2, dots.c, x_n)$ s.t. $ sum_i i x_i equiv a (mod (n+1)). $

It's not hard to see that they can be used to correct 1-bit error. Let $k = n - log_2 (n+1)$. We show that $abs("VT"_a (n)) = 2^k$: for $i in [n]$ that are not power of 2, let $x_i in {0, 1}$ arbitrarily, then there is a unique way to assign $x_(2^j)$. We have $R = 1 - (log_2 n + O(1)) / n$.

We can also view error correcting codes as sending *side information*. Let $c in Sigma^n$ be the original message and $c'$ be the corrupted message. Let $m = f(c)$ be a $k$-bit side information that is computed from $c$. If $c$ can be restored using $m$ and $c'$, then there is some $m$ s.t. $abs(f^(-1) (m)) >= Sigma^n / 2^k$, so $f^(-1) (m)$ serves as an ECC with loss $k$.

== Linear Codes and Asymptotically Good Codes

*Definition.* A $[n,k,d]_q$ *linear code* is an injective linear mapping $f : FF_q^k -> FF_q^n$ s.t. $forall x != y$, $f(x)$ and $f(y)$ have Hamming distance $>=d$. Equivalently, it is a $k$-dimensional subspace of $FF_q^n$. Denote $d(cal(C))$ as the minimum distance. The *packing radius* $tau = floor((d-1)/2)$ is the largest radius s.t. balls of radius $tau$ are disjoint.

The following are equivalent:
1. $cal(C)$ has $d >= 2 e + 1$.
2. $cal(C)$ *corrects* up to $e$ errors.
3. $cal(C)$ *detects* up to $2 e$ errors.
4. $cal(C)$ *corrects* up to $2 e$ *erasures*.

The Hamming code is a $[2^r - 1, 2^r - 1 - r, 3]$ code.

*Theorem. (Singleton bound)* $abs(cal(C)) <= q^(n - d + 1)$.

_Proof._ Erasing $d - 1$ bits gives us an injective map. $qed$

The Simplex code is the dual of the Hamming code (i.e. orthogonal complement). It is a $[2^r - 1, r, 2^(r-1)]$ code. The Simplex Code is optimal when $d > n/2$:

*Theorem.* For any $n,q$, $d > (1 - 1/q) n$, $ abs(cal(C)) <= d / (d - (q-1)/q n). $

This is based on the following construction.

*Lemma.* Let $bb(1) = (1,dots.c,1) in RR^(q-1)$, $u_i = sqrt(q / (q-1)) (e_i - 1/q bb(1))$. Then $norm(u_i) = 1$, $chevron.l u_i,u_j chevron.r (i!=j) = -1/(q-1)$. This is in fact the lower bound (known as Welch bound).

For each $c in cal(C)$, let $ v_c = 1/sqrt(n) (u_(c_1), u_(c_2), dots.c, u_(c_n)). $ Then for $c_1 != c_2$, $chevron.l c_1,c_2 chevron.r <= 1 - q/(q-1) dot d/n$. Expanding $norm(sum_c v_c)^2$ gives $ 0 <= abs(cal(C)) + abs(cal(C)) (abs(cal(C)) - 1) (1 - q/(q-1) dot d/n). $ Therefore, $ abs(cal(C)) <= 1 + 1 / (q/(q-1) dot d/n - 1) = d / (d - (q-1)/q n). $

*Corollary. (Plotkin bound)* If $0 <= delta <= 1-1/q$, then $R <= 1 - q / (q-1) delta$.

The idea is to fix the prefix and use the theorem above.  

=== Asymptotically Good Codes

*Theorem. (GV bound)* For $q,n,d$, $exists cal(C)$ with $d(cal(C)) >= d$ and $ abs(cal(C)) >= q^(n(1 - H_q((d-1)/n, n))). $

_Proof._ Keep picking $c in cal(C)$ until every point is covered by some Hamming ball. $qed$  

We can also produce a linear code achiving the same bound. Let $m = n - k$ be the rank of the parity check matrix. This is because when $ q^m > sum_(i=0)^(d-2) binom(n-1,i) (q-1)^i, $ it is possible to fill the parity check matrix $H_(m times n)$ s.t. $H$ has rank $m$ column by column.

Finally, the GV bound gives $R >= 1 - h_q (delta) - o(1)$ where $delta = d/n$. When $delta->0$, $R = 1 - O(delta log 1/delta)$. In the binary case, when $delta = 1/2 - epsilon$, $R = Theta(epsilon^2)$.

There are some explicit constructions. When $delta->0$, there are explicit codes of rate $1 - O(delta "polylog"(1/delta))$. When $delta = 1/2 - epsilon$, there are explicit codes of rate $Omega(epsilon^(2+o(1)))$.

We can give tighter upper bounds. 

*Theorem. (Elias-Bassalygo Bound)* For sufficiently large $n$, binary codes satisfy
$ R <= R_"EB" (delta) := 1 - h(J(delta)), J(delta) = (1 - sqrt(1 - 2 delta)) / 2, $
for $q > 2$, we have
$ R <= R_"EB" (delta) := 1 - h_q (J_q (delta)), J_q (delta) = (1-1/q) (1 - sqrt(1-(1-q delta) / (q-1))). $

This is better than the Plotkin bound $1 - q / (q-1) delta$ and the Hamming bound.

_Proof._ The idea is to increase the radius $rho$ in the Hamming bound proof and introduce the idea of *list decoding*. We will prove that each point will only be counted $L = O(n)$ times thus yield the bound $ abs(cal(C)) 2^(n h(rho)) <= L dot 2^n. $

Specifically, the bound is directly implied from

*Lemma. (Johnson Bound)* Let $cal(C)$ has distance $d$. If $rho <= J_q (d/n)$, then $cal(C)$ is $(rho, 2 q n)$ list decodable. (The second parameter is the list size.) The value of $L$ can take different values but it doesn't matter.

_Proof._ We have constructed an embedding $cal(C) -> RR^(q n)$ s.t. if $d(c_i,c_j) = delta n$, then $chevron.l v_i,v_j chevron.r = 1 - delta dot q / (q-1).$ 

Assume $c_1,c_2,dots.c,c_m$ satisfy $d(c_i,c_j) >= delta n$, $d(y,c_i) <= rho n$. When $alpha = sqrt(1 - (q delta) / (q-1))$, $rho = J_q (delta)$, we can prove that $chevron.l v_i - alpha y, v_j - alpha y chevron.r <= 0$. A geometry-related proposition gives that $m <= 2 q n. qed$

== BCH Codes and Reed-Solomon Codes

A *polynomial code* consist of codewords that are multiples of a polynomial $g$. $g$ is called the *generator polynomial*.

Given prime $q$, number $m$ and code distance $d$, *BCH code* is a polynomial code over $FF_q$ with code length $n = q^m - 1$. Let $alpha$ be the primitive element of $FF_(q^m)$. Then $cal(C)$ consists of $f in FF_q [X]$ s.t. $f(alpha^i) = 0$, $forall 1 <= i <= d - 1$. In other word, $cal(C)$ is the 
polynomial code generated by $ g = lcm("Min"_(FF_q) (alpha^i)), 1 <= i <= d - 1. $

*Lemma.* When $q > 2$, $deg g <= (d-1)m$; when $q = 2$, $deg g <= (d m) / 2$.

Bound LCM's with products. When $q = 2$, $"Min"_(FF_q) (alpha^i) = "Min"_(FF_q) (alpha^(2i))$.

*Lemma.* $d(cal(C)) >= d$.

_Proof._ Assume $g(X) divides p(X)$ and $p(X)$ has less than $d$ non-zero terms. Let $p(X) = sum_(i=1)^(d-1) b_i X^(k_i).$ Since $alpha, dots.c, alpha^(d-1)$ are roots of $p$, 
$ sum_(j=1)^(d-1) b_j alpha^(i k_j) = 0, forall j. $
This implies $b_j equiv 0$ since the coefficients form a transposed Vandermonde matrix. $qed$

The binary BCH code works for $delta < 1 / (log n)$ and has dimension $n - floor((d-1)/2) ceil(log n) - O(1).$

*Definition.* The $[n,k,n-k+1]_q$ Reed-Solomon code is $R S:FF_q^k -> FF_q^n$ that maps a degree $k-1$ polynomial to its first $n$ point values.

The distance $n - k + 1$ matches the Singleton bound. However, $q >= n$ requires a large alphabet size.

The RS code can be made systematic (i.e., the message appears in the codeword as a prefix). Given $m = (m_1, m_2, dots.c, m_k)$, it corresponds to a unique $f$ s.t. $deg f = k-1$, $f(i) = m_i$. Let $c = (m_1, m_2, dots.c, m_k, f(k+1), f(k+2), dots.c, f(n))$ which is a RS codeword.

Now, assume $q = n+1$, evaluate the polynomial on $FF_q^times = {alpha^i : i in [0,n-1]}$. From the parity checking view, the RS code is equivalent to the following:

$ R S_(FF_q) (FF_q^times, k) = {(c_0, c_1, dots.c, c_(n-1)) : forall i in [n-k], c(alpha^i) = 0}. $

A BCH code is actually some RS code with each coefficient restricted to a subfield.

== Code Concatenation

An idea to reduce large alphabet is to replace each symbol with several symbols. e.g., use a linear bijection $phi.alt: FF_(q^m) -> FF_q^m.$ The problem is, if $x != y$, $phi.alt(x)$ and $phi.alt(y)$ might only differ by 1 bit.

Instead, we use inner code to correct errors. 

*Definition.* Given $[n,k]_(q^m)$ outer code $cal(C)_"out"$ and $[n',m]_q$ inner code $cal(C)_"in"$, the concatenated code $cal(C) = cal(C)_"out" diamond cal(C)_"in"$ is defined by composition of $cal(C)_"in"$ and some bijective linear map on each symbol. 

$cal(C)$ is a $[n dot n', k dot m]_q$ code. We have $d(cal(C)) >= d(cal(C_"out")) d(cal(C_"in"))$.

Now we want to convert a $FF_(2^m)$ RS code to a binary code. Let $r$ be the rate of the inner code $[m/r, m, delta_"in" m]_2$. By the GV bound we can achieve $delta_"in" = h^(-1) (1-r)$. Let $R$ be the desired rate then we have $delta_"out" = 1 - R/r$, thus we have 

$ delta(R) = max_(r:R<=r<=1) (1-R/r) h^(-1) (1-r). $

This is called the *Zyablov bound*. The inner code can be found in $2^(O(m))$ time which is polynomial in $n$.

When $delta=1/2 - epsilon$, the Zyablov bound gives $R = Omega(epsilon^3)$ while $R_"GV" = Omega(epsilon^2)$; when $delta->0$, the former gives $1 - O(sqrt(delta) log delta)$ while $R_"GV" = 1 - O(delta log 1\/delta)$.

The *Justesen Codes* provide a fully expicit construction that matches the Zyablov bound for $R >= 0.31$. Let $C_alpha : FF_(2^m) -> FF_(2^m) times FF_(2^m)$, $x mapsto (x,alpha x)$ be different inner codes. The Justesen Codes map a polynomial $f$ to $ (f(a_1), a_1 f(a_1), f(a_2), a_2 f(a_2), dots.c, f(a_n), a_n f(a_n)). $

We claim that $ delta >= (1-2R) h^(-1) (1/2) - o(1). $

*Lemma.* As $m -> infinity$, $forall epsilon > 0$, $ Pr_(alpha in FF_(2^m)^times) [delta(C_alpha) >= h^(-1) (1/2) - epsilon] -> 1. $