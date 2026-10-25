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

*Definition 1.2. (Perfect Secrecy)* $Pi$ has *perfect secrecy* if for any $m_0 != m_1$, $Enc(K,m_0)$ and $Enc(K,m_1)$ are equidistributed, where $K <- Gen$. (Equivalently, $c$ reveals no information of $m$.) #tufted.margin-note[This is also known as Shannon security.]

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

*Definition 1.8. (Computational Indistinguishability)* A scheme $Pi$ is *computationally indistinguishable* if for any $m_0 != m_1 in cal(M)_lambda$ (selected by the p.p.t. adversary) and probabilistic polynomial time distinguisher $D : cal(C) -> {0,1}$, $Pr[D(Enc(K, m_b)) = b] <= 1/2 + negl(lambda)$. Here $b in {0,1}$ is selected randomly by the challenger. 

*Definition 1.9. (Semantic Security)* $Pi$ has *semantic security* if for every ... and every p.p.t. $A$, there exists a p.p.t. $S$, such that
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

_Proof._ Suppose for $m_0,m_1$ there is a distinguisher $D:cal(C)->{0,1}$ s.t. $Pr[D(Enc(K,m_b)) = b] >= 1/2 + 1/poly(n)$, $b = 0,1$. Let $A(x)$ be a distinguisher as follows: uniformly select $b in {0,1}$, return $[D(x plus.o m_b) = b]$. When $x$ is sampled from a uniform distribution $EE[A(x)] = 1/2$, whereas when $x <- G(k)$ $EE[A(x)] >= 1/2 + 1/poly(n)$. $qed$

== lec02

The PRG in Proposition 1.12 can be made to generate unlimited amount of pseudorandom bits to be XORed with an arbitrarily long message. Such a scheme is called a *stream cipher*.

We define several candidates for multi-message security.

*Definition 2.1. (Multi-message Indistinguishability Game)* The challenger sends $lambda$ to the adversary. Then the adversary sends $m_([l])^0, m_([l])^1$ to the challenger, who samples $b <- {0,1}, k <- Gen(1^lambda)$ then responds with $(c_i = Enc(k,m_i^b))$. The adversary outputs $b' in {0,1}$ and wins if $b' = b$. Notice that we allow $m_i^0 = m_i^1$.

The problem with this definition is that it doesn't handle _adaptive queries_, and $Enc$ might be weak against this type of attacks.

*Definition 2.2. (Chosen Plaintext Attack)* The CPA game allows the adversary to query polynomially many instances $Enc(k,m_i)$ before and after the distinguishing process. ($k$ is fixed in advance.) It is only required to distinguish a single pair of messages $m^b, b <- {0,1}$.

*Definition 2.3. (Multi-message CPA)* The adversary now queries a polynomially long sequence of $(m_i^0, m_i^1)$, and the challenger responds with $Enc(k,m_i^b)$ *instantly after each query*. 

*Proposition 2.4.* CPA and multi-message CPA are equivalent.

_Proof Sketch._ It is evident that multi-message CPA-security implies CPA-security. The opposite direction is proven with a hybrid argument: consider letting the challenger respond with $Enc(k,m_i^0)$ in the first $j$ queries and respond with $Enc(k,m_i^1)$ in the last $l-j$ queries. 

One can see that a deterministic encryption scheme cannot be CPA-secure since we allow $m_i^0 = m_i^1$.

To construct a scheme which handles multiple messages while satisfying the CPA-security, we need to use *pseudorandom functions*. 

*Definition 2.5. (PRF)* A PRF $F:{0,1}^lambda times {0,1}^(n(lambda)) -> {0,1}^(m(lambda))$ (i) is computable in polynomial time; (ii) is indistinguishable in p.p.t. from a truly random oracle.

There is a classic PRF construction from PRG (see #link("../pseudorandomness", [_Pseudorandomness_])) called the _GGM tree_. Constructing PRG from PRF is trivial.

Now we construct a CPA-secure *randomized* encryption scheme. #tufted.margin-note[An alternative approach is to use a *stated* encryption.] When encrypting $m$, let $r_m$ be sampled from ${0,1}^lambda$ and let $Enc(k,m) = r_m || F(k,r_m) plus.o m$. With high probability in $r$, ${r_m}$ won't collide. Under this condition, if the CPA game gives large advantage then it is a distinguisher between $F$ and a random oracle.

*Definition 2.6. (OWF)* $f:{0,1}^* -> {0,1}^*$ is called a *one-way function* if (i) $f$ can be evaluated by a polynomial algorithm; (ii) for every p.p.t. $A$,

$ Pr[A(f(U_n), 1^n) in f^(-1) (f(U_n))] = negl(n). $

*Proposition 2.6.* A PRG $G:{0,1}^ell -> {0,1}^n$ where $n >= 2 ell$ is always an OWF. 

_Proof._ Assume $Pr[G(A(G(U_ell),1^ell)) = G(U_ell)] >= 1/n^c.$ We can construct a distinguisher $D$ as follows. On input $x$, if $G(A(x,1^ell)) = x$, output $1$; otherwise, output ${0,1}$ w.p. $1/2$ each. If $x <- G(U_ell)$, $Pr[D(x) = 1] >= 1/2 + 1/n^c$; if $x <- U_n$, since $abs(G(A({0,1}^ell, 1^ell))) <= 2^ell$, $Pr[D(x) = 1] <= 1/2 + 2^(ell - n)$. This contradicts the definition of a PRG. $qed$

*Proposition 2.7.* A CPA-secure encryption scheme implies an OWF.

_Proof._ Let $f(x) = Enc(Gen(1^lambda,x), 0^lambda)$. ($Gen$ should output a distribution of keys based on a uniform distribution.) The security clearly implies that $f$ is an OWF. $qed$

An OWF can be made *length-preserving* by padding the output with `100...` and possibly truncating part of the input. However, inadequete padding may cause the resulting function to lose the OWF property. Consider padding with only 0. Let $F:{0,1}^n -> {0,1}^(n/2)$ be an OWF. Consider the following function: 

$ F^prime (x) = cases(x "if" x = x^prime || 0^(n/2), F(x) "otherwise"). $

It's easy to see that $F^prime$ is still an OWF. However, once it is padded to length $n$, we always have $F^prime (F^prime (x)) = F^prime (x)$, so it's no longer an OWF.

== lec03

*Definition 3.1. (Weak OWF, OWP)* A *weak one-way function* is an efficiently computable function that for some fixed polynomial $q(n)$, any p.p.t. $A$ can invert it on at most $1 - 1/(q(n))$ portion for suffiently large $n$. A *one-way permutation* is an OWF that is also a permutation.

*Definition 3.2.* A *hardcore predicate for $f$* is a function $h:{0,1}^* -> {0,1}$ is a function s.t. for every p.p.t. $A$, 
$ Pr_(x<-{0,1}^lambda) [A(1^lambda, f(x)) = h(x)] <= 1/2 + negl(lambda). $

*Proposition 3.3. (Goldreich-Levin) * If OWF exists, then some OWF has a hardcore predicate.

_Proof._ For any OWF $f$, construct another OWF $f_"GL" (x,y) = (f(x),y)$ ($abs(y) = abs(f(x)) = abs(x)$). Consider the Hadamard encoding of $x$ ($h(x,y) = chevron.l x,y chevron.r$). If $h$ is not a hardcore predicate, then there is a p.p.t. $A$ that can compute $h$ based on $f_"GL" (x,y)$, and the local list-decoding of the Hardmard code gives a way to compute $x$.

Specifically, assume a p.p.t. $A_"GL"$ satisfies that $ Pr_(x,y) [A_"GL" (f_"GL" (x,y)) = chevron.l x,y chevron.r] >= 1/2 + 1/(p(lambda)). $

Then for a noticeable portion of $x$, $Pr_y [A_"GL" (f_"GL" (x,y)) = chevron.l x,y chevron.r] >= 1/2 + 1/(q(lambda)).$

We present the local list-decoding algorithm here. Assume we have a binary function $g:{0,1}^n->{0,1}$ which is $1/2 - epsilon$ close to some linear function $chevron.l a,dot.c chevron.r$. That is, for at least $1/2 + epsilon$ fraction of $x$, $g(x) = chevron.l a,x chevron.r$.

We have $a_i = chevron.l a,x chevron.r plus.o chevron.l a,x plus.o e_i chevron.r$. Pick a random $<=t$-dimensional subspace $V <= FF_2^n$. If we have the correct values of $chevron.l a,dot.c chevron.r$ *on the entire subspace*, then by taking majority of $g(x plus.o e_i) plus.o chevron.l a,x chevron.r (x in V)$, we can raise the success by concentration inequality.

Note that by linearity, the linear function is correctly evaluated on $V$ as long as is it is correctly evaluated on $r_1,r_2,dots.c,r_t$ which generate $V$. The probability is $2^(-t)$ (random guessing). Let $r_S = plus.o.big_(i in S) r_i$. Since $r_i <- U_n$, $(r_S)$ are pairwise independent. Thus by Chernoff bound,
$ Pr[op("Maj")_(S != emptyset) (g(r_S plus.o e_i) plus.o chevron.l a, r_S chevron.r != chevron.l a,e_i chevron.r] <= 1/((2^t - 1) epsilon^2). $ 

So $a_i$ is computed correctly w.p. $>= 1/(2^t (2^t - 1) epsilon^2)$. When $t = O(log(n/epsilon))$ we can recover $a$ with noticeable probability.

Now we can recover $x$ based on $f_"GL" (x,y)$. $qed$ #tufted.margin-note[Local list-decoding of Reed-Muller codes up to minimum distance is much harder (it is done in 2023).]

*Corollary 3.4.* OWP $p$ + hardcore predicate $h$ implies PRG.

_Proof._ Let $G(x) = p(x) || h(x)$. $qed$

*Definition 3.5. (Universal OWF)* A function $f$ is a universal OWF if it is polynomial time computable, and it is always an OWF if any OWF exists.

*Proposition. 3.6.* Universal OWF exists.

_Proof._ Let $"TM"_i$ be an enumeration of Turing machines. Let the input $x$ be partitioned into $x_1 || x_2 || dots.c$ where $abs(x_i) = 1/2^i abs(x)$ (we truncate $i > log_2 abs(x)$). Define 
$ f(x) = "TM"_1 (x_1) || "TM"_2 (x_2) || dots.c $

Since some $"TM"_i$ computes an OWF, $f(x)$ is an OWF. (By a padding argument, we can prove something like "If OWF exists, then $f$ is an OWF which runs in time $O(n^2)$.")

*Definition. (PRP)* A *pseudorandom permutation* $P:{0,1}^lambda times {0,1}^(n(lambda)) -> {0,1}^(n(lambda))$ has to be correct (we require that $P,P^(-1)$ are efficiently computable). We say $P$ is *secure* if $P$ is also a PRF; we say $P$ is *strongly secure* if there is no distinguisher under oracles to both $P$ and $P^(-1)$.

PRP is sometime referred to as *block cipher*.

*Proposition 3.7. (Feistel Network)* PRF implies (strong) PRP. 

_Proof_. Assume the input $abs(x) = 2n$. The construction is called *Feistel network*. Let $x = x_0 || x_1$ and $ x_(i+2) = F(k_(i+1),x_(i+1)) plus.o x_i. $
Let $x_i || x_(i+1)$ be called the output of the $i$-round Feistel network. We claim that (i) 3-round Feistel network computes a secure PRP; (ii) 4-round Feistel network computes a strong PRP.

WLOG, assume that the adversary would never query the same input again (we can maintain a list of $(x,f(x))$). By a simple hybrid argument we can also replace $F$ with truly random functions ($F(k_i, dot.c) -> f_i$). 

Let $q = q(n)$ be the upper bound on the number of queries made by a distinguisher $D$. Let $x_j^i$ be the intermediate value $x_j$ in the $i$th query.

We say there is a _collision_ at $x_2$ if for $i!=j$, $x_2^i = x_2^j$. We show that this happens with negligible probability. If $x_1^i = x_1^j$ then $x_0^i != x_0^j$ and $ x_2^i = x_0^i plus.o f_1 (x_1^i) != x_0^j plus.o f_1 (x_1^i) = x_2^j. $
So $x_1^i != x_1^j$ and the collision probability is $2^(-n)$. Taking union bound we have that a collision won't happen w.h.p. 

Conditioned on there is no collision, since $x_3 = x_1 plus.o f_2 (x_2)$, $x_3^i$ are uniformly and independently distributed. Similarly, conditioned on $(x_0,x_1,x_3)$, w.h.p. $x_4^i$ are also w.h.p. uniformly and independently distributed (conditioned on there is no collision between $x_3^i$). So when querying $F^((3))$, except with negligible probability, the output is uniformly distributed.
#tufted.margin-note([This proof omits some technical details. A more rigorous (and lengthy) way is to proceed by "locally replacing" the challenger step by step.])

3-round Feistel network is not a strong PRP. Let $r <- {0,1}^n$, consider the following 3-round game. 
$ 
 (x_3^0, x_4^0) = F(x_0^0, x_1^0) \
 (x_3^1, x_4^1) = F(x_0^0 plus.o r, x_1^0) \
 (x_0^2, x_1^2) = F^(-1) (x_3^0, x_4^0 plus.o r)
$
It can be shown that $x_3^1 plus.o x_1^0 = x_1^2 plus.o x_3^0 = f_2 (x_2 plus.o r)$. For strong PRPs, however, this happens with negligible probability.

The main problem is that $x_2$ can be computed in 2 different directions. For $i<j$, there is no obstacle preventing events like $x_0^i plus.o f_1 (x_1^i) = x_4^j plus.o f_3 (x_3^j)$, so $x_2$ might collide with noticeable probability.

The reason why 4-round Feistel network is a bit involved. The main idea is that, when making a query $P(x_0,x_1)$, we can adjust the challenger program, so that $(x_3,x_4,x_5)$ can be viewed as they are i.i.d. distributed, and check collision after every query is handled. Refer to #link("./pset3.pdf", [pset3]) for a full proof.

*Proposition 3.8. (Yao)* Weak OWF implies OWF.

_Proof Sketch._ Assume $f$ is a weak OWF: inversion succeed w.p. at most $1-1/(q(n))$ for sufficiently large $n$. Take $ f'(x_1 || x_2 || dots.c || x_m) = (f(x_1) || f(x_2) || dots.c || f(x_m)). $

Assume $f'$ is not an OWF. That is, some p.p.t. $A'$ invert it w.p. $>= 1/(p(n))$. We derive contradiction by the following argument. *Here $m = m(n)$ is a polynomial that does not depend on $p$.*
- If $A'$ succeed, either every $x_i$ is good (easy to invert for $f$ using $A'$ in some sense), or some $x_i$ is bad. However, we can use $A'$ to invert $x_i$, so the second type of event happens with bounded probability. So there is an upper bound on the fraction of bad $x$.
- We can use multiple repetition to increase the chance to invert a good $x$. 

Check #link("./pset3.pdf", [pset3]) for a detailed proof. #tufted.margin-note([This is an example of the direct product theorems.])

#figure(image("imgs/cryptomap.png"), caption: [Implications of cryptographic primitives.])

== lec04

Assume the block size (i.e. the length of the PRP) is fixed. We can encrypt larger files by using *modes of operation*. Often a uniform *initialization vector (IV)* is needed.

*Example 4.1. (ECB mode)* Let $c_i = F_k (m_i)$. Clearly unsafe.

*Example 4.2. (CBC mode)* Let $c_0 = I V$, $c_(i+1) = F_k (c_i plus.o m_(i+1))$. This mode is CPA-secure if $F$ is a PRP. (IV need to be uniform for every encryption.)

*Example 4.3. (OFB mode)* Let $c_i = m_i plus.o s_(i-1)$, $s_i = F_k (s_(i-1))$, $s_0 = I V$.

*Example 4.4. (CTR mode)* Let $c_i = m_i plus.o F_k (c t r + i)$.

The following is an ad hoc construction of a PRP.

*Example 4.5. (Substitution-Permutation Network)* Suppose the key is divided into $m+1$ parts $k = k_0 || k_1 || dots.c || k_m$. The encryption is a composition of $plus.o k_i$ and $P_i$, where each $P_i$ is a public, efficiently computable and (hopefully) complex permutation.

$P_i$ is usually a composition of $L_i compose S_i$. Here $S_i$ is a block-wise function and $L_i$ is a linear function. 

In *Advanced Encryption Standard*, $S_i$ is chosen to be $x mapsto x^255$ (in $FF_256$), while $L_i$ is a permutation of 16 blocks left-multiplied by a fix matrix.

Here is another construction of a PRP based on a PRF.

*Example 4.6. (Swap-or-not)* Perform $T$ rounds of operation. In round $i$, if $F_k ({x,x plus.o Delta_i}) = 0$ then leave $x$ as it is, otherwise let $x <- x plus.o Delta_i$. This can be generalized to permutation on any set.

*Definition 4.7. (Chosen Ciphertext Attack, IND-CCA2)* A key $k$ is generated from $Gen(1^lambda)$. An adversary $A$ is given $1^lambda$ and oracle access to $Enc(k,dot.c)$ and $Dec(k,dot.c)$, and outputs $m_0,m_1$ of the same length. $b$ is chosen uniformly and a ciphertext $c <- Enc(k, m_b)$. $A$ continues to have oracle access to $Enc$ and $Dec$ but is not allowed to decipher $c$. Finally the adversary outputs $b'$ and wins if $b = b'$. #tufted.margin-note([Remember that $Enc$ is randomized.])

The schemes we've seen so far are not CCA-secure. From a high level, we can modify $c$ slightly (to get around the requirement of the CCA game) while still being able to recover part of $m_b$ from the decrypted message.

Message authentication codes are used against CCA: suppose there is a way to certify that a ciphertext is not generated by someone who has the private key, then $Dec$ can refuse to decrypt the ciphertext. 

*Definition 4.8. (MAC, CMA game)* A *message authentication code* consists of a triple $ Pi = (Gen, sans("Mac"), sans("Vrfy")). $

$sans("Mac")$ maps $(k,m)$ to $sigma$, $sans("Vrfy")$ takes $(k,m,sigma)$ and outputs ${0,1}$. We require that $Pr[sans("Vrfy")(k,m,sans("Mac")(k,m)) = 1] = 1$. For deterministic message authentication, a *canonical* verification simply checks if $sigma = sans("Mac")(k,m)$.

The security of $Pi$ is defined via the *chosen message attack* game. The adversary receives $1^lambda$, and is given oracle access to $sans("Mac")(k,dot.c)$. It is than asked to output $(m,sigma)$ where $m$ isn't queried before and wins if $sans("Vrfy")(k,m,sigma) = 1$. $sans("Mac")$ is secure if any adversary can't win with noticeable probability. A MAC is *strongly secure* if an adversary who is allowed to print $(m,sigma^prime)$ (here $m$ is queried but the pair isn't an answer of the oracle) still has a negligible winning chance. 

There are several paths towards *authenticated encryption*.
- $c = (Enc(k,m), sans("Mac")(k', m))$: not necessarily CPA-secure since MAC may reveal the message.
- MAC-then-Encrypt: $sigma = sans("Mac")(k', m)$, $c = Enc(k, m || sigma)$: not CCA-secure for some encryption scheme. For example, consider an encryption scheme which outputs an extra "trash bit" at the front.
- Encrypt-then-MAC: $c' = Enc(k,m)$, $sigma = sans("Mac")(k', c')$, $c = (c', sigma)$: we will show that this is CCA-secure.

*Definition 4.9. (Authenticated Encryption)* A private-key encryption scheme is an *authenticated encryption* if it is both CPA-secure and unforgeable. We say as scheme is unforgeable if after given access to an oracle $Enc(k,dot.c)$, it can't output a ciphertext which successfully decodes to some unqueried message.

*Proposition 4.10.* Authenticated encryption implies CCA-security.

_Proof._ From the unforgeability we can assume that the adversary never queries some $c in.not {Enc(k,m): m "queried"}$. Therefore the decryption oracle can be removed, what's left is a CPA game. $qed$

*Proposition 4.11.* If $Enc$ is CPA-secure and $sans("Mac")$ is unforgeable under CMA game, then encrypt-then-MAC is an authenticated encryption.

_Proof_. The CPA-security can be proven by contraposition using a random $k'$. The unforgeability can be proven by contraposition using a random $k$.

A pseudorandom function always serves as a secure *fixed-length* MAC. Here we construct a MAC which takes $m in {0,1}^(ell(n) dot.c n)$ and outputs $sigma in {0,1}^n$.

*Definition 4.12. (CBC-MAC)* Let $F_k$ be a PRF. On message $m = (m_1,m_2,dots.c, m_ell)$, set $sigma_i = F_k (sigma_(i-1) plus.o m_i)$, $sigma_0 = 0^n$. Output $sigma = sigma_ell$.

This construction works fine as long as the queries are *prefix-free*. To address to this issue we encrypt the last round by $sigma_ell = F_(k') (sigma_(ell - 1) plus.o m_ell)$. #footnote[This scheme is called ECBC-MAC.] This is almost random as long as $sigma_(ell - 1) plus.o m_ell$ are pairwise distinct.

This claim is proven by doing induction on the trie formed by all the messages, in a similar fashion to the Feistel network.

*Proposition 4.13. ECBC-MAC is unforgeable.* 

There are other MAC variants.

*Example 4.14. (NMAC)* Let $H_k (M) = F(dots.c F(F(k, m_1), m_2) dots.c, m_ell)$, $sans("Mac")(k || k', M) = F(k', H_k (M))$. 

*Example 4.15. (PMAC)* Let $c_i = F_k (m_i plus.o L_i)$, $c = F_(k') (plus.big.o c_i)$.

*Example 4.16. (Ascon MAC)* Let $S_(i+1) = p_k (S_i plus.o M_i)$.

== lec05

*Definition 5.1 (Keyed Hash Function)* A *keyed hash function* is a pair $(Gen, H)$. $Gen(1^lambda)$ outputs $abs(k) = lambda$, and $H$ maps $(k,x)$ to a digest. We say $H$ is collision-resistant if for any p.p.t. $A$, $Pr[H(k,m_0) = H(k,m_1) : A(1^lambda) -> m_0 != m_1] = negl(lambda)$.

*Example 5.2. (Universal Hash Function)* Consider $k in FF_(2^lambda)$, $H(k,p) = p(k)$ (here $p in FF_(2^lambda) [X]$). This is collision-resistant.

Definition 5.1 naturally extends to *keyless* computational CRHF. 

*Proposition 5.3.* A CRHF is an OWF.

_Proof._ If a random input $x$ is inverted to some $x'$ that $H(x) = H(x')$, then w.h.p. $x' != x$ and there is a collision. $qed$

However, it is proven that OWF cannot imply CRHF in a blackbox way. So instead we consider building an arbitrarily long CRHF based on a fixed-length CRHF.

*Example 5.4. (Merkle-Damgård)* Suppose $H:{0,1}^(2 lambda) -> {0,1}^lambda$ is a CRHF. Let $d_i = H(d_(i-1), m_i)$, $d_0 = I V$ is some fixed value. To avoid problems caused by messages of the same length (which is the only issue), we can reveal the length in the last message.

*Example 5.5. (Merkle tree)* Let $H:{0,1}^(2 lambda) -> {0,1}^lambda$ be a CRHF. Construct a binary tree where at each parent $x_p = H(x_l,x_r)$. The length problem can be fixed with the same trick.

There are weaker types of security specified by stronger requirements on the attacker: second preimage attack receives a random $x$ and is asked to find $x' != x$, $f(x) = f(x')$; preimage attack receives a random $y$ and is asked to find 

Now we consider constructing keyed hash function based on CRHF. (The primitive is no longer collsion resistence.)

*Example 5.6.* Consider the Merkle-Damgård transform. $H'(k,m) = H(k||m)$ would be weak under length-variant attack. $H'(k,m) = H(m||k)$ would collide when a collsion is found for $m!=m'$, regardless of the key.

Hash-and-MAC scheme. Let $k' = (k,s)$ be the key of the scheme, then $sans("Mac")'(k', m) = sans("Mac")_k (H^s (m))$. Here $sans("Mac")$ is a fixed-length MAC, $H$ is a seeded hash function.

2-nested HMAC. The key is applied again after the prepend method.

In reality we need to build compression functions. An approach would be using the block cipher as the hash function and plugging it into the Merkle-Damgård paradigm. 

However this is unsafe. Block cipher is weak under preimage attack.

The *Davies-Meyer compression function* uses $H(x,y) = Enc(y,x) plus.o x$. Once again, this is not secure under conventional PRP assumption, since it doesn't give any requirement when the adversary has control of the key. Thus we introduce the following model.

*Idealized model.* We often design schemes that use some keyless hash function $H$ which has some particular property. However, whether $H$ is good enough for our purpose is hard to decide (we often choose not to prove that in practice). A weaker notion of safety *on the scheme* is that it is safe when using a random oracle against adversaries which have access to the same oracle.

*Proposition 5.7.* A random oracle $H$ is a PRG againsts any adversary $A^H$. In fact, we don't need to limit the computational power of $A$, as long as it queries $H$ for polynomial times. Formally, $ abs(Pr[A^H (y) -> 1] - Pr[A^H (H(x)) -> 1]) = negl(lambda). $

_Proof._ In the real world, given $y = H(x)$, w.h.p. $x$ is never queried by $A$. In this case the real world degenerates to the ideal world. $qed$

*Proposition 5.8.* A random oracle is collision resistant. That is, $A^H$ finds a collision pair $x != x'$, $H(x) = H(x')$ with only negligible probability.

_Proof._ We can assume that the adversary doesn't make repeated query. Furthermore, the pair that it outputs is part of the queries. Then collision probability is bounded like non-adaptive queries. $qed$

*Proposition 5.9.* Let $cal(E)$ be an ideal cipher. Then the Davies-Meyer compression function is collision-resistant under $cal(E)$.

_Proof._ Suppose an adversary $A$ makes $q$ queries and outputs $(x,y) != (x',y')$. We assume that $A$ have made either $Enc(y,x)$ or $Dec(y,dot.c)$ that yields $x$. We make the similar assumption on $(x',y')$. We also assume that $A$ makes no extraneous queries so the triples $(k,m,c)$ don't repeat.

For $i<j$, $Pr[m_i plus.o c_i = m_j plus.o c_j] <= 1/(2^n - j + 1)$ since the randomness is fixed *after* the $j$th query has been made. So from union bound a collision happens with negligible probability. $qed$

We need stronger notion of "indistinguishability" when constructing an oracle $C^F$ from a primitive $F$, because the adversary often has access to $F$. 

*Definition 5.10. (Indifferentiability)* $C^F$ is *indifferentiable* from $P$ if there is a similator $S$ that for any adversary $A$, $ abs(EE[A^(C^F,F)] - EE[A^(P,S^P)]) = negl(n). $

For example, 5-round Feistel network is not indifferentiable from an ideal permutation; higher round number (10) suffices.

== lec06

An premise of private-key encryption is that the sender and receiver can share the same key. This is nontrivial in scenarios like the server-client model.

*Definition 6.1. (Key Agreement)* The *key agreement* is a pair of algorithms $(A(1^lambda), B(1^lambda))$ that can communicate between each other. We require that it is correct (the outputs of $A$ and $B$ are identical) and passively secure ($(T,k)$ is indistinguishable from $(T,k')$ where $T$ is the communication transcript, $k$ is the output, and $k'$ is uniformly random). This implies that it's hard to find $k$ given $T$. Sometimes, we only require the latter weaker condition. 

*Example 6.2. (Merkle's KA)* 
+ Alice generates $N$ pairs $(r_i, k_i)$ and encode each of them in a puzzle. Each puzzle takes about $Theta(N)$ time to solve. The puzzles are sent to Bob.
+ Bob selects a random puzzle, solves it in $O(N)$ time, and send $r_i$ to Alice.
+ Alice and Bob shares $k_i$. However, the eavesdropper takes $Theta(N^2)$ time to solve all the puzzles.

*Definition 6.3. (Public-key Encryption)* A *public-key encryption scheme* is a tuple $Pi = (Gen, Enc, Dec)$. 
- $Gen(1^lambda) -> (p k, s k)$. 
- $Enc(p k, m) -> c$.
- $Dec(s k, c) -> m$. $Dec$ is actually deterministic since we require $Dec(s k, Enc(p k, m)) = m$.

*Definition 6.4. (CPA-security)* A public-key encryption scheme is said to be *CPA-secure* if the adversary cannot win the following game with a noticeable advantage.
+ Challenger sends $p k$ to $A$.
+ $A$ sends $m_0, m_1$ of the same length to challenger.
+ Challenger selects a random $b <- {0,1}$, sends $c <- Enc(p k, m_b)$ to $A$.
+ $A$ outputs $b' in {0,1}$ and wins if $b' = b$.
Since $p k$ is made public, $A$ doesn't need to ask the challenger for encryption like in the private-key setting.

If we have a public-key encryption scheme, we can establish a key agreement:
+ Bob runs $(p k, s k) <- Gen(1^lambda)$ and sends $p k$ to Alice via a public channel.
+ Alice sends $c <- Enc(p k, k)$ to Bob where $k$ is the selected private key.
+ Bob decodes $k = Dec(s k, c)$.

#let Encaps = math.op(math.sans("Encaps"))
#let Decaps = math.op(math.sans("Decaps"))

We often use another primitive that combines the key ($k$) generation and public encryption.
*Definition 6.5. (Key Encapsulation, secure KEM)* A *key-encapsulation mechanism* is a tuple $(Gen, Encaps, Decaps)$.
- $Gen(1^lambda) -> (p k, s k)$.
- $Encaps(p k) -> (k, c(k))$. 
- $Decaps(s k, c(k)) -> k$. We require that $Decaps(s k, c(k)) = k$.

We say this scheme is secure if any p.p.t. adversary cannot distinguish $k$ from an independent random variable, when $p k$ and $c(k)$ are given.

#let Inv = math.op(math.sans("Inv"))

*Definition 6.6. (Trapdoor Function)* A *trapdoor function* is a tuple $(Gen, F, Inv)$. 
- $Gen(1^lambda) -> (f, sans("tp"))$. Here $f = F_sans("pp")$ is an injective function and $sans("tp")$ is called a _trapdoor_. $f$ is specified with a _public parameter_ $sans("pp")$. 
- $Inv$ is an algorithm that inverts $f$ given $sans("tp")$. We require that $Inv(sans("pp"), sans("tp"), f(x)) = x$.
- $f$ is one-way without $sans("tp")$. That is, for any p.p.t. adversary $A$, $Pr[A(f, f(x)) = x] = negl(lambda)$.

*Example 6.7. (OWF from RSA)* $Gen(1^lambda)$ generates $N = p q$ ($p,q$ are prime numbers), $e,d$ s.t. $e d equiv 1 (mod phi(N))$, $sans("pp") = (N,e)$, $sans("tp") = d$. Here $F_sans("pp") (x) = x^e mod N$, $Inv(sans("pp"), sans("tp"), y) = y^d mod N$, $x$ lies inside $ZZ_N^times$.

*Definition 6.8. (Key Agreement from Trapdoor Function)*
+ Alice runs $Gen$ and sends $sans("pp")$ to Bob.
+ Bob samples $x$ from the domain of $f$ and sends $y = f(x)$ to Alice.
+ Alice outputs $h(Inv(sans("pp"), sans("tp"), y))$ while Bob outputs $h(x)$.

The purpose of $h$ in the last step is that we can easily distinguish $x$ from a random key given $f(x)$, so only the weaker sense of security in key agreement is satisfied. However, we need the key to be pseudorandom during public encryption. 

A simple solution is to choose $h$ to be a random oracle. 

*Proposition 6.9.* 

Another solution is to use $h$ as a hardcore predicate of $f$. In this case, there is one bit of pseudo-entropy in $h(x)$ given $f(x)$. With enough independent samples of $x$ we are able to extract enough randomness for a key using extractors. _This is only handwaving._

The third solution, which is the one we focus on, is to use different assumptions.

0. RSA assumption.
1. RSA assumption for fixed $e$: pick $d$ s.t. $e d equiv 1 (mod phi(N))$.
2. Strong RSA: on random $y$, the adversary finds $(x,e)$ and wins if $y equiv x^e, e != plus.minus 1$.
3. $lambda$-bit safe primes $p,q$. A safe prime $p = 2 p' + 1$ is one such that $p'$ is also a prime. 
4. Factorization is hard.
5. Discrete logarithm assumption. Given a cyclic group $G$, a generator $g$ and a random element $g^x$, it's hard to find $x$ given only $g^x$.
6. Computational Diffie-Hellman assumption. Given $g,g^x,g^y$, it's hard to find $g^(x y)$. This induces a natural key agreement protocal: let Alice and Bob send $g^x,g^y$ to the other party respectively, use $h(g^(x y))$ as the key.
7. Decisional Diffie-Hellman assumption. Hard to distinguish $g^(x y)$ from a random $g^z$. In this case $h$ is no longer required.

We have $7 -> 6 -> 5$; $2 -> 0$; $2 -> 1$.

*Definition 6.10. (El Gamel Encryption)*
- $Gen(1^lambda) -> p k = (G, g, g^x)$, $s k = x$.
- $Enc(k, m) -> (g^y, g^(x y) m)$ (under DDH); $Enc(k, m) -> (g^y, H(g^(x y)) plus.o m)$ (under CDH).
- $Dec(k, (t, c)) = t^(-x) c$ (under  DDH); $Dec(k, (t, c)) = c plus.o H(t^x)$ (under CDH).

Some assumptions admit *worst-case to average-case reduction*. 

*Proposition 6.11.* If the RSA assumption for fixed $N,e$ holds, then it also holds for random input $x$. This fact is also true for discrete logarithm.

_Proof._ Let $tilde(x) = x r$, $r$ is random. Then $tilde(x)$ is random. If $A(tilde(x)) -> tilde(x)$, then $x = r^(-1) tilde(x)$ is found. Discrete logarithm is handled similarly. $qed$

_A new keyed CRHF._ Let $abs(G) = p$ be a prime number, $g in G$, $h = g^s$ be random elements. Let $H(x,y) = g^x h^y$. If we find a collision then $s$ is recovered.

Such group can be constructed from safe primes. Let $p = 2 p' + 1$, then the quadratic residues of $FF_p$ is a cyclic group of order $p'$. This group is named $QQ RR_p$.

*Definition 6.12. (Homomorphic Encryption)* Given $c_1 = Enc(x_1), c_2 = Enc(x_2)$, if $c = Enc(f(x_1,x_2))$ where $c$ can be directly computed from $c_1,c_2$ then this scheme is a *homomorphic encryption*.

A homomorphic encryption is not CCA-secure.