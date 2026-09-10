#import "../index.typ": template, tufted

#show: template.with(
  title: "Cryptography",
  description: "2026 Fall",
  date: datetime(year: 2026, month: 9, day: 9),
  lang: "en",
)

== lec01

#let Enc = math.op(math.sans("Enc"))
#let Dec = math.op(math.sans("Dec"))
#let Gen = math.op(math.sans("Gen"))

*Definition 1.1. (Encryption Scheme, version 1)* An *encryption scheme* $Pi$ consists of the following tuple

$ Pi = (cal(M), cal(C), cal(K), Gen, Enc, Dec). $

Here $Gen$ is an randomized algorithm that determines the distribution of $k in cal(K)$; $Enc : cal(K) times cal(M) -> cal(C)$ and $Dec : cal(K) times cal(C) -> cal(M)$ are *encryption* and *decryption* algorithms. We require that the scheme is *correct*, that is $Dec(k, Enc(k, m)) = m$, $forall k,m$.

*Definition 1.2. (Perfect Secrecy)* $Pi$ has *perfect secrecy* if for any $m_0 != m_1$, $Enc(K,m_0)$ and $Enc(K,m_1)$ are equidistributed, where $K <- Gen$. (Equivalently, $c$ reveals no information of $m$ and $Pr[M = m | C = c]$.) #tufted.margin-note[This is also known as Shannon security.]

*Definition 1.3. ("Semantic Security")* $Pi$ has *"semantic security"* if for any function $f$ on $cal(M)$, any distribution $M$ on $cal(M)$, and any adversary $A$ which is defined on $cal(C)$ with any possible side information $g(M)$, there is some algorithm $S(g(M))$ s.t. $ Pr[A(c,g(M)) = f(M)] <= Pr[S(g(M)) = f(M)]. $

*Proposition 1.4.* The above definitions are equivalent.

_Proof._ If $Pi$ is perfectly secure, we can let $S(g(M)) <- A(Enc(K,m_0), g(M))$ where $m_0$ is arbitrary. If $Pi$ isn't perfectly secure, say $Enc(K,m_0)$ and $Enc(K,m_1)$ are not equidistributed, then let $M$ be uniform distribution on ${m_0, m_1}$, $g(M) = perp$, $A(dot.c,perp)$ be a distinguisher on $Enc(K,m_0)$ and $Enc(K,m_1)$. $S$ can't do better than random guessing while $A$ achieves a success $> 1/2$. $qed$

*Example 1.5. (One-time Pad)* When $cal(K) = cal(M)$, let $Enc(k,m) = k plus.o m$, $Dec(k,c) = k plus.o c$. This scheme is perfectly secure.

*Proposition 1.6.* When $abs(cal(K)) < abs(cal(M))$, no scheme is perfectly secure.

_Proof._ Since $abs(Enc(dot.c, m_0)) <= abs(cal(K)) < cal(M)$, there is some $m_1 in.not Enc(dot.c, m_0)$ and $Enc(K,m_0)$ and $Enc(K,m_1)$ aren't equidistributed.

So the above definition isn't useful. If we allow some error (total variance) we get *statistical secrecy*, but when $abs(cal(K)) << abs(cal(M))$ it won't be helpful.

*Definition 1.7. (Encryption Scheme, version 2)* We introduce the *security parameter* $lambda$, which is similar to the message length. Let $K <- Gen(1^lambda)$.

#let negl = math.op("negl")
#let poly = math.op("poly")

#tufted.margin-note(image("imgs/distinguish.png"))

*Definition 1.8. (Computational Indistinguishability)* A scheme $Pi$ is *computationally indistinguishable* if for any $m_0 != m_1 in cal(M)_lambda$ (selected by the p.p.t. adversary) and probabilistic polynomial time distinguisher $D : cal(C) -> {0,1}$, $Pr[D(Enc(K, m_b)) = b] <= 1/2 + negl(lambda)$. Here $b in {0,1}$ is selected by the challenger. 

*Definition 1.9. (Semantic Security)* $Pi$ has *semantic security* if for every ... and every p.p.t. A, there exists a p.p.t. $S$, such that
$ Pr[A(Enc(K,M), g(M)) = f(M)] <= Pr[S(g(M)) = f(M)] + negl(lambda). $

*Proposition 1.10. (Goldwasser-Micali)* The above two definitions are equivalent. 

_Proof._ Again, suppose $Pi$ is *computationally indistinguishable*, we let $S(g(M)) <- A(Enc(K, m_0))$. If semantic security isn't satisfied then for some $m_1$ and an infinite sequence of ${lambda}$, $ Pr[A(Enc(K,m_1), g(m_1)) = f(m_1)] >= Pr[A(Enc(K,m_0), g(m_0)) = f(m_0)] + 1/poly(lambda), $
which contradicts the computational indistinguishability.
Suppose we have a distinguisher $D$. We can use it like the previous proof. $qed$

At this point we may consider messages significantly longer than keys.

*Definition 1.11. (Cryptography PRG)* A *cryptography PRG* $G: {0,1}^lambda -> {0,1}^(l(lambda))$ satisfies that $l(lambda) > lambda$ and no p.p.t. distinguisher $D:{0,1}^(l(lambda)) -> {0,1}$ can distinguish the two
distributions $G(U_lambda)$ and $U_(l(lambda))$. Actually $G$ is subscripted with $lambda$ but we omit that.

The difference $l(lambda) - lambda$ is called the *stretch* of the PRG.

*Proposition 1.12.* A 1-stretch cryptographic PRG $G:{0,1}^lambda -> {0,1}^(lambda+1)$ can be extended to a $poly(lambda)$ stretch cryptographic PRG $G'$.

_Proof._ (See #link("../pseudorandomness", [_Pseudorandomness_]).)Let $n = l(lambda)$. Let $s_0 = s$, $G(s_i) = x_i s_(i+1)$. $G'(s) = x_1 x_2 dots.c x_n$. Assume $G'$ is not a PRG, by a hybrid argument there is a previous-bit predictor $P$,
$ Pr_s [P(x_(i+1), x_(i+2), dots.c, x_n) = x_i] >= 1/2 + 1/("poly"(n)). $

$x_(i+1) dots.c x_n$ can be computed from $s_i$, so we get $P'(s_i)=x_i$ w.p. $1/2 + 1/("poly"(n)).$ $P'$ is a next-bit predictor of $G(s_(i-1))$. Since $s_(i-1)$ is indistinguishable from uniform, this gives contradiction. $qed$

*Proposition 1.13.* Assume $G$ is a cryptographic PRG. Then the following scheme is computationally secure: 

$ Enc(k,m) = G(k) plus.o m, Dec(k,c) = G(k) plus.o c. $

_Proof._ Suppose for $m_0,m_1$ there is a distinguisher $D:cal(C)->{0,1}$ s.t. $Pr[D(Enc(K,m_b)) = b] >= 1/2 + 1/poly(n)$, $b = 0,1$. Let $A(x)$ be a distinguisher as follows: uniformly select $b in {0,1}$, return $[D(x plus.o m_b) = b]$. When $x$ is sampled from a uniform distribution $EE[A(x)] = 1/2$, where as when $x <- G(k)$ $EE[A(x)] >= 1/2 + 1/poly(n)$. $qed$