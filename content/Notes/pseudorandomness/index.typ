#import "../index.typ": template, tufted

#show: template.with(
  title: "Pseudorandomness",
  description: "CS59200",
  date: datetime(year: 2026, month: 6, day: 3),
  lang: "en",
)

#set math.equation(numbering: none)

= Pseudorandomness

== Concepts of PRG

*Definition. PRG.* Let $cal(S), cal(D)$ be distributions, $cal(A)$ consists of $A : "supp"(cal(D)) -> {0, 1}$. We say $G$ *$epsilon$-fools* $cal(A)$ if $forall A in cal(A)$, $ abs(EE_(s ~ cal(S))[A(G(s))] - EE_(r ~ cal(D))[A(r)]) <= epsilon. $ If $cal(D) = "Unif"({0, 1}^n), cal(S) = 
"Unif"({0, 1}^ell)$, we say $G$ is a *PRG against $cal(A)$*.

A member of $cal(A)$ is a *distinguisher*, $s ~ cal(S)$ is a *seed*.

e.g. Let $A(x) = [x in "range"(G)]$, and the distinguishing advantage is large. $A$ runs in $O(2^(ell(n)) n)$ time, so if $ell(n) = O(log n)$ and $G in bold("FP")$ then $G$ cannot fool $bold("P")$. So if $G in bold("FP")$ $epsilon$-fools $bold("P")$ then $ell(n) = omega(log n)$.

*Lower-bounds and upper-bounds of $ell$*. When $abs(cal(A)) = 1, ell >= ceil(log(1/epsilon)) + 1$. When $cal(A) = {0, 1}^n -> {0, 1}$, $ell(n) = n$.

Let $G : {0, 1}^ell -> {0, 1}^n$ be a random function. Hoeffding's inequality shows that

$ Pr_G [forall A, abs(EE_(s ~ cal(S))[A(G(s))] - EE_(r ~ cal(D))[A(r)]) <= epsilon] >= 1 - 2 exp(-2^ell epsilon^2) abs(cal(A)). $ So $ell = log log (abs(cal(A))) + 2 log(1/epsilon) + O(1)$ is sufficient.

If $cal(A) = sans("SIZE")(K)$, then $abs(cal(A)) = 2^(O(K log K))$, so there is a PRG against $cal(A)$ with $epsilon = 1/K$ and $ell = O(log K)$. If $K = 2^(omega(log n))$, $forall A in bold("P")$, $A$ can be computed by some member in $sans("SIZE")(K)$ for sufficently large $n$.

*Definition. Cryptographic PRG.* A PRG $G$ that $epsilon$-fools $bold("P")$ where $epsilon = "negl"(n)$ is a *cryptographic PRG*. From the discussion above, for every $ell = omega(log n)$ there is a cryptographic PRG of seed length $ell$, while no explicit construction is known for $ell = n - 1$.

== Constructions of pairwise and $k$-wise independence

Let $N = 2^n$ and $M = 2^m$. We would like to construct a class of $N$ PRGs $G(i) : {0, 1}^ell -> {0, 1}^m$. With respect to a seed $s in {0, 1}^ell$, $G$ is a hash function ${0, 1}^n -> {0, 1}^m$.

e.g. Let $m = 1, ell = n = log N$, $G_s (i) = chevron.l s,i chevron.r$ where $s, i in FF_2^n$. Then $G(i) (i != 0)$ are pairwise independent.

e.g. Use a $d$-degree polynomial in $FF_q$. Then $n = m = log_q$, $ell = (d+1) log q$, $G(i)$ are $(d+1)$-wise independent.

When $m < n$, we can take the lowest $m$ bits of a ${0, 1}^n -> {0, 1}^n$ function. $(n-m)$ bits can be saved by storing only the lowest $m$ bits in the constant term. In general, we have an $ell = (k-1) max(n, m) + m$ construction. This is asymptotically optimal (Alon, Babai, Itai 1986).

== Sampling

A *sampler* is a function $"Samp" : {0, 1}^ell -> [M]^t$. We consider _averaging sampler_ and _hitting sampler_, which are applied in two-sided error and one-sided error settings respectively.

*Definition. Averaging Sampler.* Let $f : [M] -> [0, 1]$, $mu(f) = 1 / M sum_(x in [M]) f(x)$. $"Samp"$ is a $(delta, epsilon)$ averaging sampler if $forall f$, 

$ Pr_(z_i <- "Samp") [1/t sum_(i=1)^t f(z_i) > mu(f) + epsilon] <= delta. $

(This is actually two-sided by letting $f <- 1 - f$.) 

e.g. An i.i.d. averaging sampler requires $t = O(1 / epsilon^2 log delta^(-1))$, $ell = t m = O(m / epsilon^2 log delta^(-1))$.

To reduce $ell$, we apply the $2k$th moment method. Assume $z_i$ are $2k$-wise independent.

$ EE[(sum_(i=1)^t f(z_i) - t mu(f))^(2k)] &= sum_(sum k_i = 2k) product_(i=1)^t EE[(f(z_i) - mu(f))^(k_i)] \
  &= sum_(k_i != 1, sum k_i = 2k) product_(i=1)^t EE[(f(z_i) - mu(f))^(k_i)] \
  &<= binom(t, k) k^(2k) <= k^(2k) t^k. $

So $ Pr[abs(1/t sum_(i=1)^t f(z_i) - mu(f)) >= epsilon] <= (k^(2k)) / (t^k epsilon^(2k)). $

A $2k$-wise independent sampler requires $t >= k^2 / epsilon^2 delta^(-1/k)$ and $ell = O(k(log t + m))$. We choose $k = log delta^(-1)$. There are two typical settings:

- When $delta$ is some constant, pick $k = 1$, $t = O(1 / epsilon^2)$, $ell = O(m + log (1 / epsilon))$.

- When $delta = 1 / "poly"(n)$, pick $k = O(log n)$, $t = O(log^2 n / epsilon^2)$, $ell = O(log n (m + log(1/epsilon) + log log n))$.

By definition, $k$-wise independence fools degree-$k$ polynomials.

*Definition. Hitting Sampler.* $"Samp"$ is called a $(delta,epsilon)$ hitting sampler if $forall T subset [M]$ with density $> epsilon$, $ Pr_(z_i <- "Samp") [exists i, z_i in T] >= 1 - delta. $

Clearly, a $(delta, epsilon)$ averaging sampler is a $(delta, epsilon)$ hitting sampler.

e.g. An i.i.d. hitting sampler requires $t = O(1 / epsilon log delta^(-1)), ell = m t$.

For $2k$-wise independent hitting sampler, we only requires $t = O(1 / epsilon delta^(-1/k) k^2)$ this time, since we focus on *multiplicative* error instead of *additive* error.

== Basic Boolean Fourier Analysis

$ f(x) = sum_S hat(f)(S) chi_S (x). $

Where ${chi_S}$ forms an orthonormal basis. Define the inner product $chevron.l f,g chevron.r = EE_X [f(X) g(X)]$.

$hat(f)(S)$ is given by $ hat(f)(S) = chevron.l f, chi_S chevron.r = 1 / 2^n sum_x f(x) chi_S (x). $

The Fourier transforms preserves inner product: $ chevron.l f,g chevron.r = sum_S hat(f)(S) hat(g)(S). $

Characterization of $k$-wise uniformity. Let $p$ be a distribution on ${0, 1}^n$.

*Theorem.* $p$ is $k$-wise uniform iff $forall 1 <= abs(S) <= k$, $hat(p)(S) = 0$. ($hat(p)(emptyset) = 1 / 2^n$.)

Now consider functions $f : {0, 1}^n -> RR$ $epsilon$-fooled by $k$-wise independent distributions. We have 

$ abs(EE_(X ~ p) [f(X)] - EE_(X ~ {0, 1}^n) [f(X)]) = abs(hat(f)(emptyset) + 2^n sum_(S != emptyset) hat(p)(S) hat(f)(S) - hat(f)(emptyset)) = 2^n abs(sum_(abs(S) >= k + 1) hat(p)(S) hat(f)(S)). $

Since $abs(hat(p)(S)) <= 1 / 2^n$, the sum is bounded by $abs(sum_(abs(S) >= k + 1) hat(f)(S))$. If this value $<= epsilon$ then $f$ is $epsilon$-fooled. (It is called the $ell_1$ Fourier tail). Similarily, we have the $ell_2$ tail.

== $delta$-biased Distributions and $epsilon$-almost $k$-wise Uniformity 

*Definition. $delta$-biased distribution.* A probability distribution $p$ is $delta$-biased if $abs(hat(p)(S)) <= 2^(-n) delta, forall S != emptyset$.

Since $EE_(x ~ p) [chi_S (x)] = 2^n hat(p)(S)$, this is equivalent to $p$ $delta$-fooling all $chi_S$.

*Theorem. (Alon, Goldreich, Hastad, Peralta)* $ell = 2 log n/delta$ is sufficient to construct a $delta$-biased distribution.

_Proof._ Their is a natural isomorphism $pi : FF_(2^l) tilde(->) FF_2^l$. For $s in FF_(2^l), s' in FF_2^l$, let $x in FF_2^n$ where $x_i = chevron.l pi(s^i), s' chevron.r$. Let $X$ be a distribution based on $x$.

$sum_(i in T) x_i = chevron.l pi(sum_(i in T)s^i), s' chevron.r$ is uniform over ${0, 1}$ unless $sum_(i in T) s^i = 0$, so $Pr[sum_(i in T) X_i = 0] <= 1/2 + 1/2 Pr[sum_(i in T) s^i = 0] <= 1/2(1 + n / 2^l)$. When $n / 2^l <= delta$ the distribution is $delta$-biased. $qed$

*Lemma.* If $sum_(S != emptyset) abs(hat(f)(S)) <= c$, $f$ is $c delta$-fooled by every $delta$-biased distribution.

An application of the Parseval's identity gives $forall A in {0, 1}^n -> {0, 1}, sum_(S != emptyset) abs(hat(A)(S)) <= 2^(n/2)$ and $Delta_"TV" (p, u) <= 2^(n/2) delta,$ if $p$ is $delta$-biased.

*Definition.* $X_1,X_2,dots.c,X_n in S$ are *$epsilon$-almost $k$-wise uniform* if $Delta_"TV" ((X_(i_1), dots.c, X_(i_k)), u^k) <= epsilon$. 

e.g. Consider randomized MAX-CUT. Let $A(G, x) = 1 / abs(E) sum_((i, j) in E) [x_i != x_j]$, then if $x_1, x_2, dots.c, x_n$ are $epsilon$-almost pairwise uniform, $A(G, dot)$ is $epsilon$-fooled by $x$. Let $epsilon = 1 / n^2$ and we are able to find a cut of size $abs(E) / 2$.

*$epsilon$-almost $k$-wise independent* is defined as $Delta_"TV" ((X_(i_1), X_(i_2), dots.c, X_(i_k)), (Y_(i_1), dots.c, Y_(i_k))) <= epsilon$, where $Y_i$ are mutually independent variables.

*Theorem.* If $p$ is $epsilon$-almost $k$-wise uniform then $hat(p)(S) <= 2^(1-n) epsilon, forall 1 <= abs(S) <= k$.

_Proof._ $ abs(hat(p)(S)) = 2^(-n) abs(EE_(x ~ p)[chi_S (x)]) = 2^(-n) abs(EE_(x ~ p)[chi_S (x)] - EE_(x ~ {0, 1}^n) [chi_S (x)]) <= 2 epsilon dot 2^(-n). qed $

*Theorem. Vazirani's XOR Lemma.* $p$ is $delta$-biased implies $p$ is $2^(k/2) delta$-almost $k$-wise uniform.

_Proof._ We show that $p$ $2^(k/2) delta$-fools every $A$ that depends on $k$ coordinates ${i_1, dots.c, i_k}$. When $S subset.eq.not {i_1, dots.c, i_k}$, $hat(A)(S) = 0$. By Parseval's identity,

$ sum_(S != emptyset) abs(hat(A)(S)) <= sqrt(2^k) sqrt(sum_(S subset.eq {i_1, dots.c, i_k}) hat(A)^2 (S)) = sqrt(2^k) sqrt(EE[A^2 (x)]) = 2^(k/2). $

We can conclude with the lemma above. $qed$

So it takes $O(log n/delta) = O(log n + k + log 1/epsilon)$ bits to construct an $epsilon$-almost $k$-wise uniform distribution. ($log n$ can be improved to $log log n$).

== PRG for Derandomization, Branching Programs

The complexity class $bold("BPL")$ is similar to $bold("BPP")$. It uses *read-once* seed of length *polynomial in $n$*. #tufted.margin-note[Breaking the second assumption allows us to solve $"PATH"$ by keep guessing a path. Breaking the first assumption gives us a class $bold("BP") dot bold("L")$ or $bold("BP*L")$ and it's proven that $bold("BPL") subset bold("ZP*L")$, and we don't know if it is in $bold("P")$.] 
This implies that $bold("BPL") in bold("P")$ since $T(n) <= 2^(O(S(n))) m(n).$

To derandomize $bold("BPL")$ it suffices to give $G : {0, 1}^(ell(n)) -> {0, 1}^(m(n))$ that $0.1$-fools logspace algorithm $A(x, r)$, $ell(n) = O(log n)$, and $G$ can be computed within $O(log n)$ space.

But this can't be achieved. Let $A(x, r) = 1$ iff $r[1 dots 2 ell]$ is consistent with any string in $"range"(G)$, then $G$ doesn't fool $A$.

The actual goal is to find $G_c$ that fools every $A$ in $sans("SPACE")(c log n)$ for each $c$, where $ell(n) = O(log n)$ and $G_c in bold("FL")$.

*Definition. (ROBP)* A *read-once branching program* is a DAG with $(n+1)$ layers and $w$ vertices per each layer. In the first $n$ layers, the out-degree is 2. Vertices in the last layer each correspond to an output in ${0, 1}$. The ROBP is a function $B : {0, 1}^n -> {0, 1}$.

A $sans("SPACE")(s)$ PTM can be simulated by a $sans("SPACE")(s)$-uniform $w = 2^(O(s)), n = 2^(O(s))$ PTM. For $bold("BPL")$, $A(x,r)$ can be simulated by $B_x (r)$ with width and length $"poly"(n)$.

*Theorem.* If $forall n,w$, $exists ell = O(log(n w))$, $G_(n,w) in sans("SPACE")(O(ell)) : {0, 1}^ell -> {0, 1}^n$ that $0.1$-fools every ROBP with parameters $w,n$, then $bold("BPL") = bold("L")$.

We can assume that the transition of a ROBP is time-invariant (by possibly increasing $w$). $EE_(r ~ {0, 1}^n) [B(r)]$ is a specific entry of a matrix power $M^n$. This can be computed recursively. Analyzing the 2-norm shows that we only need $1 / "poly"(n)$ precision. The total space is $O(log n log w) = O(log^2 n)$.

== Nisan's PRG

Consider the following recursive construction. Suppose we have a PRG $G : {0, 1}^ell -> {0, 1}^(n/2)$ that fools $"ROBP"(n/2, w)$. A naive idea is to have $(G(s), G(s')) (s,s' in {0,1}^ell)$, but the seed length doubles.

Instead, try to use a function $h : {0, 1}^ell -> {0, 1}^ell$ that is complicated or random enough let $s' = h(s)$. 

*Lemma.* If $h : {0, 1}^ell -> {0, 1}^ell$ is drawn from a *pairwise* uniform hash family, then forall $A : {0, 1}^(2 ell) -> [0, 1]$, w.p. $>= 1 - 1 / (2^ell epsilon^2)$, 
$ abs(EE_(s,s' ~ {0, 1}^ell) [A(s,s')] - EE_(s ~ {0, 1}^ell) [A(s, h(s))]) <= epsilon. $

This is a direct corollary of Chebychev's inequality (after $s$ is fixed).

So if $G : {0, 1}^ell -> {0, 1}^(n/2)$ $epsilon$-fools $"ROBP"(n/2, w)$, forall $B in "ROBP"(n, w)$, w.p. $>= 1 - 1 / (2^ell delta^2)$ over $h$, $G_h (s) = (G(s), G(h(s)))$ $(2 epsilon + delta)$-fools $B$. However, this isn't good enough *compared with the assumption* since we can only fool a single ROBP. 

Assume each layer of $B$ has the same transition matrix $M_0, M_1, M = (M_0 + M_1)/2, M_x = M_(x_n) M_(x_(n-1)) dots.c M_(x_1)$, then $EE_(x ~ {0, 1}^n) [M_x] = M^n$. $M$ is a stochastic matrix. Say $G : {0, 1}^ell -> {0, 1}^n epsilon$-fools $M^n$, if $norm(EE_(s ~ {0, 1}^ell) [M_x] - M^n)_1 <= epsilon$. Notice that $norm(M)_1 = 1$.

*Lemma.* If $h : {0, 1}^ell -> {0, 1}^ell$ is drawn from a pairwise uniform hash function family, then $forall M, G : {0, 1}^ell -> {0, 1}^(n/2)$, w.p. $>= 1 - w^4 / (2^ell epsilon^2)$, $ norm(EE_(s,s') [M_(G(s), G(s'))] - EE_s [M_(G(s), G(h(s)))])_1 <= epsilon. $

By triangular inequality, if $G : {0, 1}^ell -> {0, 1}^(n/2) epsilon$-fools $M^(n/2)$, w.p. $>= 1 - w^4 / (2^ell delta^2)$ over $h$ $G_h = (G(s), G(h(s)))$ $(2 epsilon + delta)$-fools $M^n$. Finally, let $epsilon = 2^k delta$, w.p. $>= 1 - (w^4 k) / (2^ell delta^2)$ over $h_1, h_2, dots.c h_k$ independently drawn, $G_(h_1,dots.c, h_k) (s) epsilon$-fools $B$, for every $B in "ROBP"(n, w)$. When $k = O(log n)$, we have $ell = O(log(w^4 k \/ delta^2)) = O(log(n w \/ epsilon))$. However, we don't know if a specific $h_1, dots.c, h_k$ is good, so they are part of the seed. The actual seed length is $O(k ell) = O(log n dot log(n w \/ epsilon))$.

*Definition. (TISP, SC)* $ sans("TISP")(n^c, log^c n) = sans("TIME")(O(n^c)) inter sans("SPACE")(O(log^c n)), $ $ bold("SC") = union_(c > 0) sans("TISP")(n^c, log^c n). $

The seed in Nisan's PRG can be divided into $k = O(log n)$ parts. Once $h_1, dots.c, h_(i-1)$ are given, we can check if $h_i$ is good by verifying the condition in the lemma, since each entry of the matrix $M_(G(s), G(s'))$ and $M_(G(s), G(h(s)))$ can be computed with brute force. So $bold("BPL") subset sans("TISP")(n^(O(1)), log^2 n) bold("SC")$. #footnote[$O(log^2 n)$ is the best known space bound today if we insist on a polynomial-time simulation.]

== Saks-Zhou Theorem

An attempt to reduce the seed length in Nisan's PRG is to avoid using different $h_i$. We would like
$ EE_(s in {0, 1}^ell) [M_(G(s)) M_(G(h(s)))] approx EE_(s in {0, 1}^ell) [M_(G(s))]^2. $

Both sides should be close to $M^(2^k ell)$. This suggests that $M_(G(s))$ and $h$ are not _so_ correlated, even if we use $h$ in $G$.

*Downward perturbation.* For $hat(p) in [0, 1]$, $d in NN$, $r in [2^d]$, let $ hat(p) minus.o_d r := 2^(-d) floor(2^d max{0, hat(p) - r dot 2^(-2d)}). $ 

We have $max{0, hat(p) - 2^(-d+1)} <= hat(p) minus.o_d r <= hat(p)$, so $minus.o$ doesn't introduce much error. Meanwhile, $minus.o$ destroys information: consider $p in [0, 1]$ such that $abs(p - hat(p)) < 2^(-2d - 1)$, then for all but *at most 1* $r$, $hat(p) minus.o_d r = p minus.o_d r$. (Consider the $(d+1) ~ 2d$th highest bits of $hat(p)$'s mantissa).

Suppose $hat(M)_(w times w)$ is a stochastic matrix. Define $hat(M) minus.o_d r$ as follows: apply $minus.o_d$ on each entry of $hat(M)$, then increase the last entry of each column that it becomes a stochastic matrix.

From the properties above we have $norm(hat(M) - (hat(M) minus.o_d r))_1 <= 2^(-d+2) w,$ and for all but at most $w^2$ $r$'s, if $norm(M - hat(M))_infinity < 2^(-2d-1)$, $hat(M) minus.o_d r = M minus.o_d r$. The computation of $hat(M) minus.o_d r$ is done with $O(k + d + log w)$ space ($k$ is the precision of $hat(M)$). #tufted.margin-note([A stochastic matrix $M$ can be used to build a function $[w] times {0, 1}^k -> [w]$, which is an _automaton_ for multiple steps. What we have done is calculating this automaton implicitly.])

Given $M: [w] times {0, 1} -> [w]$, we would like to build $hat(M)$ s.t. $norm(hat(M) - M^n)_1 <= epsilon$. Let $k = O(log (w n \/ epsilon)), d<=k, s t = log n$ be parameters, $cal(H)$ be a pairwise independent hash family ${h : {0, 1}^k -> {0, 1}^k}$. Sample $h_1, dots.c, h_s in cal(H)$, $r_1, dots.c, r_t in [2^d]$ independently, and let $ hat(M)^((0)) = M, \ hat(M)^((i)) = hat(M)_(vec(h))^((i-1)) minus.o_d r_i. $ #tufted.margin-note([For $M : [w] times Sigma -> [w]$, $h : Sigma -> Sigma$, define $M_h : [w] times Sigma -> [w]$ as $M_h (u,x) = M(M(u,x), h(x))$, $M_(h_1, h_2, dots.c) = (dots.c (M_(h_1))_(h_2) dots.c)$.])

The output of the Saks-Zhou algorithm is $hat(M)^((t))$. Both the space complexity and randomness is $O(log(w n \/ epsilon) (s + t))$.

*Proposition.* Except w.p. at most $w^2 t 2^(-d) + w^5 log n 2^(O(d+s)) 2^(-k)$, $ norm(hat(M)^((t)) - M^n)_1 <= 4 n w 2^(-d). $

_Proof._ Define $ M^((0)) = M, \ M^((i)) = (M^((i-1)))^(2^s) minus.o_d r_i. $

The probability that some $r_i$ is bad for $(M^((i-1)))^(2^s) minus.o_d$ is at most $w^2 t 2^(-d)$. Assume this doesn't happen. Also, by analysis in Nisan's PRG we have except w.p. $w^5 log n 2^(O(d+s)) 2^(-k)$, $norm(M_(vec(h))^((i-1)) - (M^((i-1))^(2^s))_1 < 2^(-2d-1))$. Assume no bad event happens. Then induction shows $hat(M)^((i)) = M^((i))$. The remaining work is to bound $norm(M^((i)) - M^(2^(s i)))_1$, the key is 
$ norm(M^((i)) - M^(2^(s i)))_1 <= norm(M^((i)) - (M^((i-1)))^(2^s))_1 + norm((M^((i-1)))^(2^s) - M^(2^(s i)))_1 <= 2^(-d + 2) w + 2^s norm(M^((i-1)) - M^(2^(s (i-1))))_1 <= (2^(s i) - 1) / (2^s - 1) 2^(-d+2) w. $

*Corollary.* Set $s = t = sqrt(log n)$. We have $bold("BPL") subset sans("DSPACE")(log^(3\/2) n).$

== INW Generator

*Definition. ($epsilon$-recycling)* For $d in ZZ_(>0)$, $H : {0, 1}^ell times [d] -> {0, 1}^ell$ is $epsilon$-recycling iff for every $w > 0$, $F : {0, 1}^ell -> [w]$, $ Delta_"TV" ((F(s), s'), (F(s), H(s, r))) <= w epsilon. $

Where $s,s' in {0, 1}^ell$ and $r in [d]$. In Nisan's PRG, $H$ is a pairwise independent hash family with $d = 2^(O(ell))$ and is 0-recycling.

The INW generator is built upon a family of $epsilon$-recycling functions,

$ cal(H) = {H_k : {0, 1}^(ell + (k-1)log d) times [d] -> {0, 1}^(ell + (k-1) log d), k in NN}. $

$G_k : {0, 1}^(ell + k log d) -> {0, 1}^(2^k ell)$ is defined as 
$ G_0 (s) = s, G_k (s_k) = (G_(k-1) (s_(k-1)), G_(k-1) (H_k (s_(k-1), r_k))) $
where $s_k = (s, r_1, r_2, dots.c, r_k)$, $r_i in [d]$. Let $B in "ROBP"(2^k ell, w)$. #footnote[A major difference between this and Nisan's PRG is that we use $r_i$ as *seeds* instead of *subscripts*, so the seed length is increasing.]

*Theorem.* $G_k$ with $epsilon$-recycling functions $(2^k - 1) w epsilon$-fools $"ROBP"(2^k ell, w)$.

_Proof._ Induction on $k$. Since $H_k$ is $epsilon$-recycling, $ abs(EE_(s_k) [B(G_k (s_k))] - EE_(s_(k-1),s'_(k-1)) [B(G_(k-1) (s_(k-1)), G_(k-1) (s'_(k-1)))]) <= w epsilon. $ 

By inductive hypothesis, $ abs(EE_(s_(k-1), s'_(k-1)) [B(G_(k-1) (s_(k-1)), G_(k-1) (s'_(k-1)))] - EE_(s_(k-1),x_2) [B(G_(k-1) (s_(k-1)), x_2)]) + abs(EE_(s_(k-1),x_2) [B(G_(k-1) (s_(k-1)), x_2)] - EE_(x_1,x_2) [B(x_1, x_2)]) <= 2 (2^(k-1) - 1) w epsilon. $

So the total is at most $(2^k - 1) w epsilon. qed$

When $ell = O(1), k = O(log n)$ the seed length is $O(ell + k log d) = O(log n dot log d)$. We need $epsilon = O(1 / (n w))$. So it boils down to find $d$.

*Theorem.* Assume $H : {0, 1}^ell times [d] -> {0, 1}^ell$ is $epsilon$-recycling, then $d = Omega(min{epsilon^(-1), 2^ell})$.

_Proof._ Let $F : {0, 1}^ell -> [w]$ be uniform that $forall v$, $abs(F^(-1) (v)) <= ceil(2^ell \/ w)$, then 
$ Delta_"TV" ((F(s), s'), (F(s), H(s, r))) = EE_v [Delta_"TV" (s', H(s, r) | F(s) = v)]. $

The support size of $s' = 2^ell$. When $w = 1 \/ 2 epsilon$, $Delta_"TV" <= 1 \/ 2$, so for at least one $v$, the support of $H(s, r) | F(s) = v$ has size $>= 2^ell \/ 2$, therefore $ 2^ell \/ 2 <= ceil(2^ell \/ w) d <= d (2^epsilon dot 2^ell + 1). $

This implies $d = Omega(min{epsilon^(-1), 2^ell}). qed$

When $ell = log n dot log d$, $2^ell >> d$, so we get $d = Omega(epsilon^(-1))$. When $d = O(epsilon^(-1))$, the seed length is as good as Nisan's PRG.

We can't afford to use pairwise independent function (which is in fact 0-recycling) or any function with $d >= 2^ell$ since $ell$ is to large.

*Definition. ($epsilon$-mixing)* A function $H:{0, 1}^ell -> {0, 1}$ is said to be $epsilon$-mixing if $(s, H(s, r)) (s ~ {0, 1}^ell, r ~ [d])$ $epsilon$-fools every combinatorical rectangle ($f(x, y) = g(x) h(y)$).

For any distinguisher $A : [w] times {0, 1}^ell -> {0, 1}$, we have $ A(F(s), s') = sum_(v in [w]) [F(s) = v] dot [A(v, s') = 1], $

so an $epsilon$-mixing function is an $epsilon$-recycling function.

Consider a $d$-regular graph with $V = {0, 1}^ell = n$. The $epsilon$-mixing property is equivalent to $forall S,S' subset.eq V$, 
$ abs(e(S,S') / (n d) - (abs(S) abs(S')) / n^2) <= epsilon. $

This is called the $epsilon$-mixing property of a graph, which is satisfied on _expanders_.

== Spectral expansion

Let $G$ be an undirected $d$-regular graph and $A$ be its adjacent matrix. Then $M = 1/d A$ is doubly stochastic and $norm(M)_1 = 1$. Let $lambda_1 >= lambda_2 >= dots.c >= lambda_n$ be the eigenvalues of $M$. #footnote[For regular digraphs many of the following properties still hold, but $lambda_i$ might not be real numbers.]

*Definition. (spectral expansion)* $gamma = 1 - max{abs(lambda_2), abs(lambda_n)}$.

Since $M$ preserves $norm(dot)_1$, $abs(lambda_i) <= 1$ and $lambda_1 = 1$ ($M u = u$).

*Theorem.* $ 1 - gamma = max_(x perp u) norm(M x)_2 \/ norm(x)_2 = max_(norm(x)_1 = 1) norm(M x - u)_2 \/ norm(x - u)_2. $

It's easy to prove that $lambda_2 < 1$ iff the graph is connected; a connected undirected graph is bipartite iff $lambda_n = -1$ (consider $x^top (M + 1_(n times n)) x$).

*Theorem.* A graph $H$ is *$(K, alpha)$-vertex expanding* if $forall abs(S) <= K$, $abs(N(S) without S) >= alpha abs(S)$, where $N(S) = {u | exists v in S, (v,u) in H}$. Then $H$ has $gamma$ spectral expansion $=>$ $H$ has $(n/2, gamma)$ vertex expansion.

_Proof._ Let $x$ be the uniform distribution on $S$. Then $chevron.l x,u chevron.r = 1/n$, $norm(x - u)_2 = sqrt(1 / abs(S) - 1 / n)$. Since $M x$ has support in $N(S)$, by Cauchy-Schwartz inequality 

$ (1 - gamma) sqrt(1 / abs(S) - 1 / n) >= norm(M x)_2^2 >= abs(M x)_1^2 \/ abs(N(S)) = 1 / abs(N(S)). $

Thus $ abs(N(S)) / abs(S) >= 1 / (1 - (2 gamma - gamma^2) (1 - abs(S) / n)) >= 1 / (1 - gamma + 1/2 gamma^2) >= 1 + gamma. qed$

*Theorem.* A graph $H$ is *$(K,alpha)$-edge expanding* if $forall abs(S) <= K$, $e(S, overline(S)) >= alpha d abs(S)$. A graph with spectral expansion $gamma$ also has $(n/2, gamma/2)$ edge expansion.

_Proof._ For $abs(S) <= n/2$, we have $e(S, overline(S)) = bb(1)_S^top A bb(1)_overline(S)$. Let $x$ be uniform distribution on $S$. Then

$ e(S,overline(S)) &= abs(S) x^top A (n u - abs(S) x) \ &= n d abs(S) x^top u - abs(S)^2 x^top A x \
  &= d abs(S) - abs(S)^2 (x-u)^top A (x-u) - abs(S)^2 (u^top A x + x^top A u - u^top A u) \ 
  &= d abs(S) - abs(S)^2 (x-u)^top A (x-u) - d/n abs(S)^2 \
  &>= d abs(S) - d abs(S)^2 norm(x-u)_2 norm(M (x-u))_2 - d/n abs(S)^2 \
  &>= d abs(S) - d abs(S)^2 (1 - gamma) (1 / abs(S) - 1 / n) - d/n abs(S)^2 \
  &= gamma d abs(S) (1 - abs(S) / n) >= 1/2 gamma d abs(S). qed $

*Theorem.* If a graph $H$ has $(1-lambda)$ spectral expansion then it is $lambda$-mixing.

_Proof._ Let $x,y$ be uniform distributions on $S,S'$ respectively. Then 
$ x^top A y = (x - u)^top A (y - u) + u^top A y + x^top A u - u^top A u = (x - u)^top A (y - u) + d/n. $

Thus 
$ abs(e(S,S') / (d n) - (abs(S) abs(S')) / n^2) &= (abs(S) abs(S')) / (n d) abs((x - u)^top A (y - u)) \
&<= (abs(S) abs(S')) / n norm(x - u)_2 (1 - gamma) norm(y - u)_2 \
&= (1 - gamma) sqrt(abs(S) / n dot (n - abs(S)) / n dot abs(S') / n dot (n - abs(S')) / n) <= 1 - gamma. qed $

Now we consider random walks on expanders. The following two properties contribute to hitting samplers and average samplers. The main idea is that we can directly compute some quantities via linear algebra.

*Theorem. (Hitting property)* Suppose $H$ has $gamma$ spectral expansion, $(v_1, dots.c, v_t)$ be a random walk on $H$. $forall S subset.eq V$,
$ Pr[forall i, v_i in.not S] <= (1 - (gamma abs(S)) / n)^t. $

_Proof._ 
$ Pr[forall i, v_i in.not S] = Pr[v_1 in.not S] dot product_(i=2)^t (Pr[v_i in.not S, v_(i-1) in.not S]) / (Pr[v_(i-1) in.not S]). $
Since $H$ is $d$-regular, each $v_i$ is uniformly distributed, and $Pr[v_(i-1) in.not S] = 1 - abs(S) / n$. Meanwhile, 
$ Pr[v_(i-1),v_i in.not S] = (e(overline(S),overline(S))) / (n d) <= (abs(overline(S)) / n)^2 + (1 - gamma) (abs(S) abs(overline(S))) / n^2. $

Plug them in and we have the result. $qed$

*Theorem. (Expander Chernoff bound)* Under the same setting, for every $f : V -> [0, 1]$, $mu = 1/n sum_v f(v)$,
$ Pr[1/t sum_(i=1)^t f(v_i) - mu >= lambda + epsilon] <= exp(- 1/4 t epsilon^2). $

_Proof._ First we give a decomposition of the matrix $M$. Let $J = (1/n)_(i,j)$ be the projection onto $RR u$, then $ M v = J v + M (1 - J) v = gamma J v + (lambda J v + M (1 - J) v). $
Let $E = 1 / lambda (lambda J + M (1 - J))$, then $M = gamma J + lambda E$. We claim that $norm(E)_2 <= 1$. Both $RR u$ and $(RR u)^perp$ are $M$-invariant, so it suffices to show that $norm(E u)_2 <= norm(u)_2$ and $norm(E v^perp)_2 <= norm(v^perp)_2$, which are straightforward. 
The benefit of this decomposition is that we don't need prior knowledge on $v$ (like its decomposition).

Let $phi_t (s) = EE[exp(s sum_(i=1)^t f(v_i))]$, then $phi_t (s) = norm((P M)^t u)_1$, where $P = "diag"(exp(s f(v)))$.

We would like to bound $norm(P M)_2 <= gamma norm(P J)_2 + (1 - gamma) norm(P E)_2$.

$ norm(P J)_2^2 &= norm(P u)_2^2 / norm(u)_2^2 \ &= 1 / n sum_v e^(2 s f(v)) \ &<= 1 + 2 mu s + s^2 (s <= 1/2 => e^s <= 1 + s + s^2) \ &<= (1 + mu s + s^2)^2. $

$ norm(P E)_2 <= norm(P)_2 <= e^s <= 1 + s + s^2. $

So $norm(P M)_2 <= 1 + (mu + lambda) s + s^2$,
$ Pr[sum_(i=1)^t f(v_i) - mu t >= lambda t + epsilon t] &<= e^(-s t (mu + lambda + epsilon)) phi_t (s) \ 
&<= e^(-s t (mu + lambda + epsilon)) norm(P M)_2^t \
&<= e^(-epsilon s t + s^2 t) = e^(-1/4 t epsilon^2). $

*Remark.* It is also proven that 
$ Pr[1/t sum_(i=1)^t f(v_i) - mu >= epsilon] <= exp(-1/4 gamma t epsilon^2). $

This is done by decomposing $v$ and simultaneously bound $v^parallel$ and $v^perp$. Refer to @healy2008. Neither of the two results implies the other, and there are methods to interpolate between them.

Spectral expanders can be used to construct optimal samplers. Assume $d = O(1), gamma <= 1/2$, then $ell$ can be reduced from $O(m t)$ to $m + O(t)$.

A *near-optimal* average sampler is constructed using the _median of averages_ trick. Let $t = T k$, for each of the $T$ groups of samples, compute the average of $f$, and output the median of the $T$ results. The samples in each group are pairwise independent. When $k = O(1 / epsilon^2)$, with probability $>= 2/3$ the average is $epsilon$-close to $mu(f)$. Finally, use expander walk to generate $T = O(log(1/delta))$ seeds, each of length $O(m + log(1/epsilon))$. The total randomness is $ell = O(m + log(1/epsilon) + log(1/delta))$.

Similarily, for hitting sampler, $t = O(1/epsilon log(1/delta))$, $ell = O(m + log(1/epsilon) + log(1/delta))$.

== Constructions of Expanders

We first give bounds for spectral expansion.

*Theorem.* Let $d$ be a constant. Then every $d$-regular graph with spectral expansion $(1-lambda)$ satisfies $ lambda >= (2 sqrt(d-1)) / d - o_n (1). $

The main idea is that the "optimal" $d$-regular expander is an infinite $d$-regular tree.

*Theorem.* $forall epsilon > 0$, a random $d$-regular graph over $n$ vertices with high probability satisfies

$ lambda <= (2 sqrt(d-1)) / d + epsilon. $

We can construct larger expanders based on small expanders. The following table shows different *graph products* and their parameters.

#let zprod = math.class("binary", $ⓩ$)
#let rprod = math.class("binary", $ⓡ$)
#table(columns: 4,
      align: center,
      table.header([Graphs], [size], [degree], [$1 - gamma$]),
      [$G$], [$N$], [$D$], [$Lambda$],
      [$H$], [$n$], [$d$], [$lambda$],
      [$G H = H G$ \ $G^2$], [$N = n$ \ $N^2$], [$D d$ \ $D^2$], [$Lambda lambda$ \ $Lambda^2$],
      [$G times.o H$ \ $G times.o G$], [$N n$ \ $N^2$], [$D d$ \ $D^2$], [$max{Lambda, lambda}$ \ $Lambda$],
      [$G rprod H = B + I_N times.o H$], [$N n = N D$], [$d + 1$], [?],
      [$G zprod H = (I_N times.o H) B (I_N times.o H)$], [$N n = N D$], [$d^2$], [$Lambda + 2 lambda$]).

If two expanders $G,H$ share the same size, their *matrix product* $G H$ consists of edges corresponding to two-step walks by first taking a step in $H$ then taking a step in $G$.

The *tensor product* $G times.o H$ has vertices in $V(G) times V(H)$. For $(u,v) in G$, $(u',v') in H$, there is $((u,u'), (v,v')) in G times.o H$.

Let $tilde(G) = 1/D G$ and $tilde(H) = 1/d H$. For a direct product $v times.o w$, let $v = v^parallel + v^perp$ and $w = w^parallel + w^perp$ be its composition. Then
$ (tilde(G) times.o tilde(H)) (v times.o w - v^parallel times.o w^parallel) &= (tilde(G) times.o tilde(H)) (v^parallel times.o w^perp + v^perp times.o w^parallel + v^perp times.o w^perp) \
&= v^parallel times.o (tilde(H) w^perp) + (tilde(G) v^perp) times.o w^parallel + (tilde(G) v^perp) times.o (tilde(H) w^perp). $

Each term shrinks by a factor at most $max{Lambda, lambda}$, so the spectral expansion is $1 - max{Lambda, lambda}.$

Assume $n = D$. The *replacement product* $G rprod H$ is "replacing" each vertex of $G$ by a copy of $H$. Specifically, let $B$ is a degree-1 graph with $N D$ vertices so that $((v,i), (u,j)) in B$ if the $i$th adjacent edge of $v$ is the $j$th adjacent edge of $u$. Then $G rprod H = B + I_N times.o H$.

The *zigzag product* $G zprod H$ corresponds to a three-step walk on $G rprod H$: $G zprod H = (I_N times.o H) B (I_N times.o H)$.

*Theorem.* $G zprod H$ as spectral expansion $>= 1 - Lambda - 2 lambda$.

_Proof._ Let $J_n$ be a all-1 matrix. Consider the intermediate graph $G zprod J_n$. A crucial observation is that $G zprod J_n = G times.o J_n$ (two random steps are equivalent to one). Therefore,
$ norm(1/d^2 G zprod H - 1 / (N n) J_(N n))_2 &<= norm(1/d^2 G zprod H - 1 / n^2 G zprod J_n)_2 + norm(1/n^2 G times.o J_n - 1/N J_N times.o 1/n J_n)_2 \
&<= norm(1/d^2 (I_N times.o H) B (I_N times.o H) - 1 / (d n) (I_N times.o J_n) B (I_N times.o H))_2 \
&space + norm(1/(d n) (I_N times.o J_n) B (I_N times.o H) - 1/n^2 (I_N times.o J_n) B (I_N times.o J_n))_2 \
&space + norm(1/n^2 G times.o J_n - 1/N J_N times.o 1/n J_n)_2 \
&<= 2 norm(I_N times.o (1/d H - 1 / n J_n))_2 + norm((1/n G - 1/N J_N) times.o 1/n J_n)_2 \
&<= 2 lambda + Lambda. qed $

Starting from a $(c,10^8, 0.1)$-graph $G$ (for $c$ large enough) and $(10^16, 100, 0.1)$-graph $H$, the new graph

$ G_1 = ((G times G) zprod H)^2 $

is $(10^16 c^2, 10^8, 0.09)$. In $O(log log n)$ repetitions we can get an $(n, 10^8, 0.1)$-graph. 

The graph can be computed *fully explicitly* in $bold("L")$. That is, on input $(v,i)$, we can recursively compute $(u,j)$ such that the $i$th edge adjacent to $v$ is the $j$th edge adjacent to $u$. The key is that during the whole process, the space used to save vertices is invariant, and the representation of every other element is $<< log n$.

== Randomness Extractor

#bibliography("refs.bib")