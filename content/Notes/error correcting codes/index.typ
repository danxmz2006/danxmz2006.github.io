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

*Theorem. (GV bound)* For $q,n,d$, $exists cal(C)$ with $d(cal(C)) >= d$ and $ abs(cal(C)) >= q^(n(1 - H_q ((d-1)/n, n))). $

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

_Proof._ Assume $g(X) divides p(X)$ and $p(X)$ has less than $d$ nonzero terms. Let $p(X) = sum_(i=1)^(d-1) b_i X^(k_i).$ Since $alpha, dots.c, alpha^(d-1)$ are roots of $p$, 
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

*Definition.* Given $[n,k]_(q^m)$ outer code $cal(C)_"out"$ and $[n',m]_q$ inner code $cal(C)_"in"$, the concatenated code $cal(C) = cal(C)_"out" diamond.stroked.small.small cal(C)_"in"$ is defined by composition of $cal(C)_"in"$ and some bijective linear map on each symbol. 

$cal(C)$ is a $[n dot n', k dot m]_q$ code. We have $d(cal(C)) >= d(cal(C_"out")) d(cal(C_"in"))$.

Now we want to convert a $FF_(2^m)$ RS code to a binary code. Let $r$ be the rate of the inner code $[m/r, m, delta_"in" m]_2$. By the GV bound we can achieve $delta_"in" = h^(-1) (1-r)$. Let $R$ be the desired rate then we have $delta_"out" = 1 - R/r$, thus we have 

$ delta(R) = max_(r:R<=r<=1) (1-R/r) h^(-1) (1-r). $

This is called the *Zyablov bound*. The inner code can be found in $2^(O(m))$ time which is polynomial in $n$.

When $delta=1/2 - epsilon$, the Zyablov bound gives $R = Omega(epsilon^3)$ while $R_"GV" = Omega(epsilon^2)$; when $delta->0$, the former gives $1 - O(sqrt(delta) log delta)$ while $R_"GV" = 1 - O(delta log 1\/delta)$.

The *Justesen Codes* provide a fully expicit construction that matches the Zyablov bound for $R >= 0.31$. Let $C_alpha : FF_(2^m) -> FF_(2^m) times FF_(2^m)$, $x mapsto (x,alpha x)$ be different inner codes. The Justesen Codes map a polynomial $f$ to $ (f(a_1), a_1 f(a_1), f(a_2), a_2 f(a_2), dots.c, f(a_n), a_n f(a_n)). $

We claim that $ delta >= (1-2R) h^(-1) (1/2) - o(1). $

*Lemma.* As $m -> infinity$, $forall epsilon > 0$, $ Pr_(alpha in FF_(2^m)^times) [delta(C_alpha) >= h^(-1) (1/2) - epsilon] -> 1. $

_Proof._ ${C_alpha}$ is known as the *Wozencraft Ensemble*. For $alpha != alpha'$, $C_alpha inter C_alpha' = {0}$. Since the distance of a *linear code* is determined by its nonzero element with minimum Hamming weight, the number of $alpha$ with $delta(C_alpha) < h^(-1) (1/2) - epsilon$ is bounded by the number of $x in FF_2^(2m) != 0$ with Hamming weight $< 2 m (h^(-1) (1/2) - epsilon)$, which is 
$ sum_(i=1)^(2 m (h^(-1) (1/2) - epsilon)) binom(2m, i) = 2^(2 m (h(h^(-1) (1/2) - epsilon) + o(1))) << 2^m. $

The limit $R < 1/2$ is due to the inner code. Define the following "truncated code"
$ C_alpha^"trunc" : x mapsto (x, (alpha dots x)[0:s-1]). $
It gives $R = m / (m+s)$. Similar argument shows that
$ Pr_alpha [delta(C_alpha^"trunc") > h^(-1) (s / (m+s)) - epsilon] -> 1. $ Put it together,
$ delta_"Justesen" (R) = max_(max{R,1/2} <= r <= 1) (1-R/r) h^(-1) (1-r). $

$R$ can be furthur reduced by using $x mapsto (x, alpha x, beta x)$ for instance. This increases the number of inner codes thus requires longer outer codewords while $FF_(q^m)$ is invariant. General algebraic geometry codes can meet this criterion.

== Decoding RS Codes

*Erasure.* Suppose $c = (f(a_1), f(a_2), dots.c, f(a_n))$. Decoding erasure can be done with fast interpolation in $tilde(O)(n)$ time.

*Error. (Welch-Berlekamp Algorithm)* Assume $c'$ contains $e$ errors. There are $binom(n, e)$ possibilities. 

Let $F = {i: f(a_i) != y_i}$, $abs(F) <= e$. Let $E(X) = product_(i in F) (X - a_i)$. The bivariate polynomial

$ Q(X,Y) = E(X) (Y - f(X)) = E(X) Y - N(X), Q(a_i, y_i) = 0. $

We have $deg E(X) <= e$ and $deg N(X) <= e + k - 1$. The coefficients of $E$ and $N$ can be found in polynomial time. Let $E,N$ be the solution, we claim that $f = N(X) / E(X)$.

Let $R(X) = f(X) E(X) - N(X)$. If $f(a_i) = y_i$, then $R (a_i) = f(a_i) E(a_i) - N(a_i) = Q(a_i, y_i) = 0 $. So $deg R >= n - e$ or $R = 0$. However, $deg f = k-1$, $deg R <= e+k-1$. $e <= floor((n-k)/2)$ by the definition of $e$, 
showing that $R = 0$.

== Decoding Concatenated Codes

We would like to correct $e < (delta_"out" dot delta_"in") / 2$ fraction of errors in $cal(C) = cal(C)_"out" diamond.stroked.small.small cal(C)_"in"$ in time polynomial in $n$.

Assume $d(cal(C)_"out") = D$ and $d(cal(C)_"in") = d$, the inner code has length $n'$. A naive solution is to first decode inner code blocks and then decode the outer code, but it can only correct up to $(D dot d) / 4$ errors.

$tau = (delta_"out" dot delta_"in") / 2$ is achieved using the *Generalized Minimum Distance Decoding*. It proceeds in two steps:

1. Inner Decoding: For $c' = (z_1, z_2, dots.c, z_n)$, decode $z_i$ to $a_i in Sigma$ s.t. $d(z_i, cal(C)_"in" (a_i))$ is minimized with brute force. Let $w_i = min(d/2, d(z_i, cal(C)_"in" (a_i)))$.

2. Outer Decoding: Set $a_i$ as an erasure w.p. $(2 w_i) / d$ and run errors and erasures decoding on the outer codeword.

*Lemma.* Let $e_i = d(z_i, cal(C)_"in" (c_i))$. If $sum_i e_i < (D dot d) / 2$, then $EE[2 Z_i^"errors" + Z_i^"erasures"] < D$.

_Proof._ By linearity we can focus on each individual $i$. If $a_i = c_i$, then $EE[Z_i^"errors"] = 0$ and $EE[Z_i^"erasures"] = (2 w_i) / d = (2 e_i) / d$. If $a_i != c_i$, $EE[Z_i^"errors"] = 1 - (2 w_i) / d$ and $EE[Z_i^"erasures"] = (2 w_i) / d$. 

We have $ w_i + e_i = d(z_i, cal(C)_"in" (a_i)) + d(z_i, cal(C)_"in" (c_i)) >= d(cal(C)_"in" (a_i), cal(C)_"in" (c_i)) >= d. $
Therefore, $ EE[2 Z_i^"errors" + Z_i^"erasures"] = 2(1 - (2 w_i) / d) + (2 w_i) / d >= (2 e_i) / d. $

Summation over $i$ gives us the result. 

To make it deterministic, notice that we don't need independence. We may use a _coupled_ coin, i.e. for $(2 w_i) / d < (2 w_j) / d$, always make $j$ an erasure when $i$ is an erasure. Thus we can enumerate $O(n)$ thresholds $l$ and make $i$ s.t. $(2 w_i) / d > l$ an erasure. $qed$

== Tanner Codes and Expander Codes

*Definition.* Given a $r$-right regular bipartite graph $G = (L,R)$, $abs(L) = n$, $abs(R) = m$, $C_0 subset.eq FF_2^r$. The *Tanner code* 
$ T(G, C_0) = {c in FF_2^n | forall u in R, C|_(N(u)) in C_0}. $

Assume $C_0$ is the parity check code, then $T(G,C_0)$ has parity check matrix equal to the adjacent matrix of $G$.

Assume $C_0$ is linear, then $T(G,C_0)$ is linear and $dim T(G,C_0) >= n - m(r - dim C_0)$.

A $(2,r)$-regular bipartite graph can be constructed from a $r$-regular graph $G' = (V,E)$ where $L = E$ and $R = V$. We view the bits of codewords of a Tanner code as edges on $G'$, where each vertex is a constraint. Let $X(G',C_0) = T(G,C_0)$, $R_0$ and $delta_0$ be the parameters of $C_0$.

$ dim X(G',C_0) >= v r / 2 - v (r - dim C_0) = v r / 2 - v (r - R_0 r) = v r / 2 (2 R_0 - 1). $

To have positive rate we can pick $R_0 > 1/2$.

Bounding relative distance of $X(G',C_0)$ is equivalent to lower bounding the weight of $c in X(G',C_0)$. Let $c in FF_2^E$ be a nonzero codeword. Let $V_c$ be vertices adjacent to some nonzero edge in $c$. Let $H$ be the subgraph of $V_c$ and edges in $c$.

By the distance of the local code, vertices in $H$ has degree $>= delta_0 r$. Thus $ op("wt")(c) = abs(E(H)) >= delta_0 r abs(V_c) \/ 2. $
To show $op("wt")(c) >= delta v r \/ 2$, we only need to prove $abs(V_c) >= (2 delta) / delta_0 v.$

Assume $G'$ has spectral expansion $1 - lambda$. By expander's mixing lemma,

$ abs(V_c) delta_0 r <= abs(E(V_c, V_c)) <= (r abs(V_c)^2) / v + lambda r abs(V_c), \
abs(V_c) >= (delta_0 - lambda) v. $

This implies $delta >= (delta_0 - lambda) delta_0.$

We can also view $G'$ as a bipartite graph: let $L = R = V$, for $(u,v) in G$, add $(u_L, v_R)$ nad $(v_L, u_R)$ to the bipartite graph. Such bipartite graph is called the *double cover* of $G'$. Equivalently, we replace 
an undirected edge in $G'$ with 2 directed edges. We still have $R >= 2 R_0 - 1$ and $delta = (delta_0 - lambda) delta_0.$

=== Decoding Tanner Codes

*Zemor's Algorithm.* We try to decode locally first: for each vertex, decode its adjacent edges. The algorithm works in several stages. In each stage, we decode first the left side of the bipartite graph, then the right side.

*Theorem.* In $O_epsilon (log n)$ rounds, the algorithm corrects $(1-epsilon) delta_0 / 2 (delta_0 / 2 - lambda)$ fraction of errors.

_Proof._ Let $c^*$ be the unique code that we want to decode to. Let $ S_i = {u in L | y|_(E(u)) != c^*|_(E(u)) "after round" i "of left-side decoding"}. $

Define similarily $T_i$ for $u in R$. Let $e := delta_0 / 2 (delta_0 / 2 - lambda) (1 - epsilon) n r$ be the bound on number of errors.

*Claim.* $ abs(S_1) <= e / (delta_0 r \/ 2) = (delta_0 / 2 - lambda) (1 - epsilon) n. $

This is because each $u in S_1$ contributes to at least $(delta_0 r) / 2$ errors.

Assume that ${e : y_e != c_e^*} != emptyset$ after the first right-side decoding. Then every node in $T_1$ must have $>= (delta_0 r)/2$ errors before the right-side decoding step. Those erroneous edges are incident to $S_1$. Thus

$ abs(E(S_1, T_1)) >= (delta_0 r) / 2 abs(T_1). $

Plug in the expander mixing lemma,

$ (delta_0 r) / 2 abs(T_1) <= (r abs(S_1) abs(T_1)) / v + lambda r sqrt(abs(S_1) abs(T_1)),\
abs(T_1) <= abs(S_1) / (1 + epsilon (delta_0 / lambda - 2)). $

Pick a small enough $lambda$ so that $T_1$ decay geometrically. similarily, we can bound $S_(i+1)$ with $T_i$ and bound $T_i$ with $S_i$. Thus in logarithmic number of rounds $S_i = T_i = emptyset. qed$ 

The algorithm can be made into linear time. We only need to consider neighbours of $S_i$ or $T_i$, so the total complexity is $O(sum_i (abs(S_i) + abs(T_i))) = O(n)$.

=== Distance Amplification

*Definition. (Distance Amplification Code)* Given a binary code $cal(C)$ and an $r$-biregular bipartite graph $G = (L,R,E)$. Define a new code $G(cal(C)) subset ({0,1}^r)^n$, where 
$ G(c)_j = (c_(N_1 (j)), dots.c, c_(N_r (j))) $

We have $R(G(cal(C))) = R(cal(C)) / r$.

*Lemma.* If $delta(cal(C)) = delta$, $G$ is $sqrt(gamma delta)$-mixing, then $delta(G(cal(C))) >= 1-gamma$.

_Proof._ Take $c != 0$ in $cal(C)$ and embed it in $L$. At least a $delta$ fraction of vertices in $L$ are assigned to 1. Let $S = {i : c_i = 1}$.

For every vertex adjacent to $S$, $G(c)_j != 0$. Thus the weight of $G(c)$ is $abs(N(S))$. Let $T = R without N(S)$, then $abs(E(S,T)) = 0$. If $G$ is $epsilon$-mixing, then

$ 0 = abs(E(S,T)) >= (r abs(S) abs(T)) / n - epsilon r sqrt(abs(S) abs(T)),\
abs(T) <= (epsilon^2 n^2) / abs(S) <= (epsilon^2 n) / delta. $

Then $abs(T) <= gamma n$ if $epsilon <= sqrt(gamma delta)$. $qed$

When $lambda = O(1/sqrt(r))$ (near Ramanujan graph), $delta(G(cal(C))) >= 1 - gamma$ and $abs(Sigma) = 2^(O(1\/gamma))$.

*Decoding distance-amplified Tanner codes.* The algorithm decodes up to $(1-gamma)/2$ fraction of errors. For codeword $y in Sigma_2^n$, $z in FF_2^n$ take the majority of the $r$ neighbours for each $z_i$. Decode $z$ to some codeword $c$ if there exists one within $tau n approx (delta_0 n)/4$.

Let $S$ be the set of errors on the left side and $T$ be the correct tuples on the right set. Assume $abs(T) >= (1+gamma)/2 n$. If $u in S$, then $u$ has at most $r/2$ neighbours in $T$.

$ (r abs(S)) / 2 >= abs(E(S,T)) >= (r abs(S) abs(T)) / n - epsilon r sqrt(abs(S) abs(T)) \
abs(S) <= (4 epsilon^2) / gamma^2 n <= tau n $
when $epsilon^2 <= 1/4 tau gamma^2$. (We need $r = Omega(1/gamma^2)$ here.)

== List Decoding

*Definition.* $cal(C) subset Sigma^n$ is $(rho,L)$-list decodable if $forall y subset Sigma^n$, $abs(B_q (y, rho n)) <= L$.

*Theorem. (Upper bound of list decoding capacity)* Let $q >= 2$, $0 < rho < 1 - 1/q$, $epsilon > 0$. For all large enough $n$, if $cal(C)$ is a $q$-ary code of block size $n$ and $R = 1 - h_q (rho) + epsilon$, then $cal(C)$ is not $(rho,L)$-list decodable for $L <= q^(epsilon n \/ 2)$.

_Proof._ On average, $ EE_y [abs(B_q (y, rho n) inter cal(C))] = (abs(cal(C)) abs(B_q (0, rho n))) / q^n >= q^(epsilon n - o(n)) > q^(epsilon n \/ 2). qed $

*Theorem. (Lower bound of list decoding capacity)* For $rho < 1 - 1/q$, there exists $(rho,L)$-list decodable code with $R >= 1 - h_q (rho) - 1/(L+1)$.

_Proof._ Pick $M$ distinct random codewords. The probability that $(L+1)$ codewords lie in a fixed Hamming ball $B_q (y, rho n)$ is $<= (abs(B_q (y,rho n) \/ q^n))^(L+1)$, so the probability that it isn't $(rho,L)$-list decodable is at most

$ binom(M,L+1) q^n q^(-(L+1)(1-h_q (rho)) n). $

When $M = q^(1 - h_q (rho) - 1\/(L+1))$ the probability $<1$. $qed$

The capacity can also be reached by linear codes. 

*Theorem.* There exists $(rho,L)$-list decodable code with $R>=1 - h_q (rho) - 1 / (log_q (L+1))$.

_Proof._ Suppose $abs(B_q (y,rho n) inter cal(C)) >= L+1$. The linear subspace this set generates has rank $r >= log_q (L+1)$.

Let $x_1, x_2, dots.c, x_r$ be linear independent. We have 
$ Pr_h [chevron.l h,x_1 chevron.r = chevron.l h,x_2 chevron.r = dots.c = chevron.l h,h_r chevron.r = 0] = q^(-r). $

Thus $Pr[(x_i) subset cal(C)] = q^(-(n-k) r) = q^(-(1-R) n r)$.

Summing over $binom(B_q (y,rho n),[r])$ we have the probability is at most 
$ q^n q^(n r h_q (rho) + o(n)) q^(-(1-R) n r), $
when $R < 1 - h_q (rho) - 1 / (log_q L)$ the probability $<1$. $qed$

Recall the Johnson bound $J_q (delta) >= 1 - sqrt(1 - delta) = 1 - sqrt(R)$ for codes on the singleton bound, and we can list decode up to $rho = 1 - sqrt(R)$. This is better than $(1-R)/2$.

*Theorem. (Goldreich-Levin)* Given $f : FF_2^k -> FF_2$, $epsilon > 0$, there is probabilistic algorithm runs in $"poly"(n,1/epsilon)$ and outputs a list $L$ s.t. 

$ Pr_(x ~ FF_2^k) [chevron.l a,x chevron.r = f(x)] >= 1/2 + epsilon => Pr[a in L] >= 1/2. $

In other word, Hadamard code can be list to $rho = 1/2 - epsilon$ error.

=== List Decoding RS Codes up to the Johnson Radius

The list decoding algorithm generalizes the Welsh-Berlekamp algorithm. Specifically, it replaces $Q(X,Y) = A_0 (X) + Y A_1 (Y)$ with

$ Q(X,Y) = sum_(i=0)^L A_i (X) Y^i. $

The goal is to make $Y - f(X)$ a factor of $Q(X,Y)$, or equivalently $Q(X,f(X)) = 0$. The previous method is to bound $deg R(X)$, $R(X) = Q(X,f(X))$, and show that when $y_i = f(a_i)$, $R(a_i) = Q(a_i,y_i) = 0$.

Here we find a $Q(X,Y) != 0$ s.t. $Q(a_i,y_i) = 0 forall i in [n]$ and $deg A_j (X) <= D - j k$. Then find every $f(X)$ s.t. $(Y - f(X)) divides Q(X,Y)$ and output those which satisfies $deg f <= k$ and $f(a_i) = y_i$ for at least $t$ values of $i in [n]$.

For a nonzero $Q$ to exists, the first step requires
$ sum_(j=0)^L (D - j k + 1) > n \ D >= n / (L+1) + (k L) / 2. $

*Claim.* If $deg f <= k$ and $f(a_i) = y_i$ for $>=t$ values of $i$, then $(Y - f(X)) divides Q(X,Y)$.

_Proof._ By the construction of $Q$, $deg R <= D$. Hence $R(X)$ has $>= t$ roots. *When $t > D$*, $R(X) = 0$, thus $Q(X,f(X)) = 0$. Polynomial division shows that $(Y - f(X)) divides Q(X,Y)$. $qed$

*Claim.* The second step outputs $<= L$ polynomials in polynomial time.

_Proof._ $Q(X,Y) in (FF_q [X])[Y]$ has at most $t$ roots since $FF_q [X]$ is an integral domain. So it has at most $L$ factors of the form $Y - f(X)$.

We can embed $FF_q [X]$ into a field $F = FF_q [X]/(E(X))$. Factor in $F[X]$ can be done using Berlekamp's algorithm.

To minimize $D = n / L + (k L) / 2$, we have $D >= 2 sqrt(n k)$ when $L = ceil(sqrt(2 n \/ k))$, and $t approx sqrt(2 n k) approx sqrt(2 R) n$. The error fraction is $1 - sqrt(2 R)$.

*Method of Multiplicities.* We will remove the factor $sqrt(2)$. Note that the above claim doesn't work when $t <= D$. We address to this issue by raising the *multiplicities* of $(a_i, y_i)$.

*Definition.* $Q(X,Y)$ is said to have a zero of multiplicity $r >= 1$ at $(alpha,beta) in FF^2$ if $Q(X + alpha, Y + beta)$ has no monomial of degree $< r$ with nonzero coefficient.

*Lemma.* Let $Q(X,Y)$ be a polynomial with $(1,k)$-weighted degree (i.e., consists of $X^i Y^j$ s.t. $i + j k <= D$). If $(a_i, y_i)$ is a zero of multiplicity $r$ for every $i in [n]$, $deg f <= k$, then $Q(X,f(X)) = 0$ given $f$ passes $t > D\/r$ points of $(a_i, y_i)$.

_Proof._ Let $R(X) = Q(X,f(X))$, then $deg R <= D$. Let $Q_i (X,Y) = Q(X + a_i, Y + y_i)$, then for $y_i = f(a_i)$

$ R(X) = Q(X, f(X)) = Q_i (X - a_i, f(X) - y_i) = Q_i (X - a_i, f(X) - f(a_i)). $

Since $(X - a_i) divides (f(X) - f(a_i))$, $(X - a_i)^r divides R(X)$. Summing over $i$ gives $deg R(X) <= r t$, contradiction. $qed$

There are $n binom(r+1, 2)$ linear constraints. We need

$ (D+1)(L+1) - k L(L+1) \/ 2 > n binom(r+1,2),\
D >= (n r (r+1)) / (2 L) + (k L) / 2. $

For $r t > D$, $ t > (n(r+1)) / (2 L) + (k L) / (2 r). $

Let $L approx sqrt((n r (r+1)) / k)$, we can take

$ t > sqrt((n k (r+1))/r) = sqrt(n k + 1/r). $

So we can achieve $rho = 1 - sqrt((1 + epsilon) R)$ with list size $L = O(epsilon^(-1) \/ sqrt(R))$.

=== Folded RS Codes

Recall that a RS code $"RS"_(FF,FF^times) [n,k]$ maps

$ f(X) mapsto (f(1), f(gamma), dots.c, f(gamma^(n-1))) $

where $n = q-1$, $FF^times = chevron.l gamma chevron.r$.

*Folded Reed-Solomon code* $"FRS"_FF^(m) [k]$ is the $m$-folded version where $Sigma = FF^m$:

$ f(X) mapsto (vec(delim:"[", f(1),f(gamma),dots.v,f(gamma^(m-1))), vec(delim:"[", f(gamma^m), f(gamma^(m+1)), dots.v, f(gamma^(2m-1))), dots.c, vec(delim:"[", f(gamma^(n-m)), f(gamma^(n-m+1)), dots.v, f(gamma^(n-1)))) $

For some $1<=s<=m$, We extend $Q$ to $(s+1)$-variate $(1,k,dots.c,k)$-weighted degree polynomial $Q(X,Y_1,dots.c,Y_s)$ with similar parameters $t$, $D$. The main goal is to reduce $D$.

Assume $Q$ has zero multiplicity $r$ at $(gamma^i, y_i, y_(i+1), dots.c, y_(i+s-1))$.

*Lemma.* If $(D^(s+1))/((s+1)! k^s) > n binom(r+s,s+1)$, a nonzero polynomial $Q$ with the above properties exists.

This is based on counting constraints and variables.

*Lemma.* Suppose $r t (m-s+1) > D$. Then for every $f(X) in FF[X]$, $deg f <= k$, whose encoding agree with the received word on at least $t$ locations, $f$ satisfies 
$ Q(X,f(X),f(gamma X), dots.c, f(gamma^(s-1) X)) = 0. $

_Proof._ If we have $f(gamma^(i+j)) = y_(i+j) (0<=j<=s-1)$, let $Q_i (X,Y_1,dots.c,Y_s) = Q(gamma^i + X, f(gamma^i) + Y_1, dots.c, f(gamma^(i+s-1)) + Y_s)$, then

$ Q(X,Y_1,dots.c,Y_s) = Q_i (X - gamma^i, Y_1 - f(gamma^i), dots.c, Y_s - f(gamma^(i+s-1))) = Q_i (X - gamma^i, Y_1 - y_i, dots.c, Y_s - y_(i+s-1)). $

Let $Y_j = f(gamma^(j-1) X)$, then $(X - gamma^i) divides (f(gamma^(j-1) X) - f(gamma^(i+j-1)))$, resulting in $(X - gamma^i)^r divides R(X)$. Note that $i$ can take $t(m-s+1)$ values (from $m p$ to $m (p+1) - s - 1$ where $p$ is an agreement). The lemma follows from the degree of $R$. $qed$

Now we can choose 
$ D = (k^s n r (r+1) dots.c (r+s))^(1\/(s+1)) + 1 $ to interpolate $Q$.

We need find every $deg f = k$ s.t. $Q(X,f(X),f(gamma X), dots.c, f(gamma^(s-1) X)) = 0$. 

Let $h(X) = X^(q-1) - gamma$, then $h(X)$ is irreducible. (Let $h(alpha) = 0$ in the splitting field. One can observe that $"ord"(alpha) = (q-1)^2$. If $d = [FF_q [alpha] : FF_q] < q-1$, then $"ord"(q) = (q-1)^2 divides (q^d - 1)$, which gives contradiction.)
Also, $f(gamma X) = f(X)^q mod h(X)$. Let $tilde(FF) = FF[X]/(h(X))$. The above problem is equivalent to finding roots in $tilde(FF)$ of $P(Y_1) = T(Y_1,Y_1^q,dots.c,Y_1^(q^(s-1)))$, where $T$ is $Q$ regarded as a polynomial in $tilde(F)$. 
Note that there is a bijection between terms in $T$ and monomials in $Q$, since the total degree in $Q$ is at most $D\/k <= (r + s) (n\/k)^(1\/(s+1)) << q$.

Roots in $P(Y_1)$ can be found in $q^(O(s))$ time, which is still polynomial.

The algorithm works for $t > D / ((m-s+1)r)$, $L <= q^s$, and $rho$ approaches

$ 1 - (1+s/r) (m/(m-s+1)) R^(s\/(s+1)) > 1 - (1 + zeta) R^(s\/(s+1)). $

Finally, when $rho = 1 - R - epsilon$, the alphabet size is $(N\/epsilon^2)^(O(1\/epsilon^2))$.

== Locally Decodable Codes

*Definition. (LDC)* Code with encoder $"Enc" : {0,1}^k -> {0, 1}^n$ is $(q,delta,gamma)$-locally decodable if there is a decoder $"Dec"$ that probes the noisy message $q$ times, and $forall m in {0, 1}^k$, $forall i in [k]$, $"Dec"^y (i) = m_i$ w.p. $>= 1/2 + gamma$ when $d(y, "Enc"(m)) <= delta n$. 
A $(q,delta,gamma)$-locally correctable code reads $q$ locations and outputs $"Enc"(m)_i$ w.p. $>= 1/2 + gamma$.

Since a linear code can always be made systematic, a linear LCC is also a linear LDC. In general, it is proven that a LCC is a LDC with a constant blowup in $q$.

e.g. For $q = 2$, the Hadamard code has $n = 2^k$ and decodes correctly w.p. $1 - 2 delta$.

Typical settings of length: 
1. $q = O(1)$ and $n = exp(k^(1/(q-1)))$;
2. $q = n^epsilon$ and $n = exp(1/epsilon) k$;
3. $q = log n$ and $n = "poly"(k)$.

There exists LDCs with $q approx 2^sqrt(log n)$ with rate $1-epsilon$. For small $q$'s,

#table(columns: 3, align: center,
      table.header([$q$], [Lower bound on $n$], [Upper bound on $n$]),
      [2], [$2^(Omega(k))$], [$2^k$],
      [3], [$k^2$], [$approx exp(2^(sqrt(log k)))$],
      [$O(1)$, even], [$k^(q/(q-2))$], [$exp(k^(o(1)))$],
      [$O(1)$, odd], [$k^((q+1)/(q-1))$], [$exp(k^(o(1)))$])

*Definition. (Reed-Muller codes)* Let $q > d$, Reed-Muller code $"RM"[q,m,d]$ maps an $m$-variable degree $d$ polynomial $f in FF_q [X_1,dots.c,X_m]$ to its evaluation on *all* points.

We have $n = q^m$, $k = binom(m+d,m)$, $delta = 1 - d/q$ (from Schwartz-Zippel Lemma).

*Theorem.* $"RM"[q,m,d]$ is a $[d+1,delta,1-(d+1)delta]$-locally correctable code.

_Proof._ Given $arrow(a) in FF_q^m$, we would like to find $f(arrow(a))$. $f(arrow(a) + X arrow(b)) in FF_q [X]$ is a univariate polynomial with degree $<= d$. Randomly select $arrow(b) != 0$ and $lambda_1, lambda_2, dots.c, lambda_(d+1)$. Then $ Pr[f(arrow(a) + lambda_i arrow(b)) != y_(arrow(a) + lambda_i arrow(b))] <= delta, $ by union bound w.p. $1 - (d+1)delta$ $f(arrow(a) + X arrow(b))$ can be correctly interpolated. Return its value at $X = 0$. $qed$

#table(columns: 2, align: (center, center), [$q=$ number of queries], [$n$], 
      [$O(1)$], [$exp(O(k^(1\/(q-1))))$],
      [$log n$], [$k^(O(log log k))$],
      [$log^t n, t > 1$], [$k^(1+1/(t-1)+o(1))$],
      [$n^(1\/t), t>=1$], [$t^(t+o(t)) dot k$])

*Theorem. (Normal (linear) form for LDCs)* LDC properties implies $exists$ $q$-uniform hypergraphs $H_1, H_2, dots.c, H_k$ on $[n]$ s.t. (i) each $H_i$ is a matching with $Omega(n)$ hyperedges; (ii) for each $i$ and each hyperedge $E in H_i$, $m_i = plus.big.o_(j in E) C(m)_j.$ The reverse holds similar to the hypergraph code.