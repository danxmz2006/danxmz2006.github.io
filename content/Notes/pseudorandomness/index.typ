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