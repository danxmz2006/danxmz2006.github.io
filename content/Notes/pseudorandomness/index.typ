#import "../index.typ": template, tufted

#show: template.with(
  title: "Pseudorandomness",
  description: "CS59200",
  date: datetime(year: 2026, month: 6, day: 3),
  lang: "en",
)

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

*Definition. Averaging Sampler.* Let $f : [M] -> [0, 1], mu(f) = 1 / M sum_(x in [M]) f(x)$. $"Samp"$ is a $(delta, epsilon)$ averaging sampler if $forall f$, 

$ Pr_(z_i <- "Samp") [1/t sum_(i=1)^t f(z_i) > mu(f) + epsilon] <= delta. $

(This is actually two-sided by letting $f <- 1 - f$.) 

e.g. An i.i.d. averaging sampler requires $t = O(1 / epsilon^2 log delta^(-1)), ell = t m = O(m / epsilon^2 log delta^(-1))$.

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

The complexity class $bold("BPL")$ is similar to $bold("BPP")$. It uses *read-once* seed of length *polynomial in $n$*. #tufted.margin-note[Breaking the second assumption allows us to solve hard problems like $"SAT"$ with exponential random bits. Breaking the first assumption gives us a class $bold("BP") dot bold("L")$ or $bold("BP*L")$ and it's proven that $bold("BPL") subset bold("ZP*L")$, and we don't know if it is in $bold("P")$.] 
This implies that $bold("BPL") in bold("P")$ since $T(n) <= 2^(O(S(n))) m(n).$

To derandomize $bold("BPL")$ it suffices to give $G : {0, 1}^(ell(n)) -> {0, 1}^(m(n))$ that $0.1$-fools logspace algorithm $A(x, r)$, $ell(n) = O(log n)$, and $G$ can be computed within $O(log n)$ space.

But this can't be achieved. Let $A(x, r) = 1$ iff $r[1 dots 2 ell]$ is consistent with any string in $"range"(G)$, then $G$ doesn't fool $A$.

The actual goal is to find $G_c$ that fools every $A$ in $sans("SPACE")(c log n)$ for each $c$, where $ell(n) = O(log n)$ and $G_c in bold("FL")$.

*Definition. (ROBP)* A *read-once branching program* is a DAG with $(n+1)$ layers and $w$ vertices per each layer. In the first $n$ layers, the out-degree is 2. Vertices in the last layer each correspond to an output in ${0, 1}$. The ROBP is a function $B : {0, 1}^n -> {0, 1}$.

A $sans("SPACE")(s)$ PTM can be simulated by a $sans("SPACE")(s)$-uniform $w = 2^(O(s)), n = 2^(O(s))$ PTM. For $bold("BPL")$, $A(x,r)$ can be simulated by $B_x (r)$ with width and length $"poly"(n)$.

*Theorem.* If $forall n,w$, $exists ell = O(log(n w)), G_(n,w) in sans("SPACE")(O(ell)) : {0, 1}^ell -> {0, 1}^n$ that $0.1$-fools every ROBP with parameters $w,n$, then $bold("BPL") = bold("L")$.

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

By triangular inequality, if $G : {0, 1}^ell -> {0, 1}^(n/2) epsilon$-fools $M^(n/2)$, w.p. $>= 1 - w^4 / (2^ell delta^2)$ over $h$ $G_h = (G(s), G(h(s)))$ $(2 epsilon + delta)$-fools $M^n$. Finally, let $epsilon = 2^k delta$, w.p. $>= 1 - (w^4 k) / (2^ell delta^2)$ over $h_1, h_2, dots.c h_k$ independently drawn, $G_(h_1,dots.c, h_k) (s) epsilon$-fools $B$, for every $B in "ROBP"(n, w)$. When $k = O(log n), delta = O(1 / n)$ we have $ell = O(log(w^4 k \/ delta^2)) = O(log(n w))$. However, we don't know if a specific $h_1, dots.c, h_k$ is good, so they are part of the seed. The actual seed length is $O(k ell) = O(log n dot log(n w))$.

*Definition. (TISP, SC)* $sans("TISP")(n^c, log^c n) = sans("TIME")(O(n^c)) inter sans("SPACE")(O(log^c n))$, $bold("SC") = union_(c > 0) sans("TISP")(n^c, log^c n)$.

The seed in Nisan's PRG can be divided into $k = O(log n)$ parts. Once $h_1, dots.c, h_(i-1)$ are given, we can check if $h_i$ is good by verifying the condition in the lemma, since each entry of the matrix $M_(G(s), G(s'))$ and $M_(G(s), G(h(s)))$ can be computed with brute force. So $bold("BPL") subset bold("SC")$.