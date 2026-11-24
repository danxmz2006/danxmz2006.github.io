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

_Proof._ (See #link("../pseudorandomness", [_Pseudorandomness_]).) Let $n = l(lambda)$. Let $s_0 = s$, $G(s_i) = x_i s_(i+1)$. $G'(s) = x_1 x_2 dots.c x_n$. Assume $G'$ is not a PRG, by a hybrid argument there is a previous-bit predictor $P$,
$ Pr_s [P(x_i, x_(i+2), dots.c, x_n) = x_(i-1)] >= 1/2 + 1/("poly"(n)). $

$x_i dots.c x_n$ can be computed from $s_i$, so we get $P'(s_i)=x_(i-1)$ w.p. $1/2 + 1/("poly"(n)).$ $P'$ is a next-bit predictor of $G(s_(i-1))$. Since $s_(i-1)$ is indistinguishable from uniform, this gives contradiction. $qed$

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

Note that by linearity, the linear function is correctly evaluated on $V$ as long as is it is correctly evaluated on $r_1,r_2,dots.c,r_t$ which generate $V$. The probability is $2^(-t)$ (random guessing). Let $r_S = plus.o.big_(i in S) r_i$. Since $r_i <- U_n$, $(r_S)$ are pairwise independent. Thus by Chebychev inequality,
$ Pr[op("Maj")_(S != emptyset) (g(r_S plus.o e_i) plus.o chevron.l a, r_S chevron.r) != chevron.l a,e_i chevron.r] <= 1/((2^t - 1) epsilon^2). $ 

So $a$ is computed correctly w.p. $>= 1/(2^t) (1-n/((2^t - 1) epsilon^2))$. When $t = log(2n\/epsilon^2)$ we can recover $a$ with noticeable probability.

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

_Proof._ From the unforgeability we can assume that the adversary never queries some $c in.not {Enc(k,m): m "not queried"}$. Therefore the decryption oracle can be removed, what's left is a CPA game. $qed$

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

*Definition 6.6. (Trapdoor permutation)* A *trapdoor permutation* is a tuple $(Gen, F, Inv)$. 
- $Gen(1^lambda) -> (f, sans("tp"))$. Here $f = F_sans("pp")$ is an injective function and $sans("tp")$ is called a _trapdoor_. $f$ is specified with a _public parameter_ $sans("pp")$. 
- $Inv$ is an algorithm that inverts $f$ given $sans("tp")$. We require that $Inv(sans("pp"), sans("tp"), f(x)) = x$.
- $f$ is one-way without $sans("tp")$. That is, for any p.p.t. adversary $A$, $Pr[A(f, f(x)) = x] = negl(lambda)$.

*Example 6.7. (TDP from RSA)* $Gen(1^lambda)$ generates $N = p q$ ($p,q$ are prime numbers), $e,d$ s.t. $e d equiv 1 (mod phi(N))$, $sans("pp") = (N,e)$, $sans("tp") = d$. Here $F_sans("pp") (x) = x^e mod N$, $Inv(sans("pp"), sans("tp"), y) = y^d mod N$, $x$ lies inside $ZZ_N^times$.

*Definition 6.8. (Key Agreement from Trapdoor Permutation)* #tufted.margin-note([This can be viewed equivalently as a key encapsulation scheme.])
+ Alice runs $Gen$ and sends $sans("pp")$ to Bob.
+ Bob samples $x$ from the domain of $f$ and sends $y = f(x)$ to Alice.
+ Alice outputs $h(Inv(sans("pp"), sans("tp"), y))$ while Bob outputs $h(x)$.

The purpose of $h$ in the last step is that we can easily distinguish $x$ from a random key given $f(x)$, so only the weaker sense of security in key agreement is satisfied. However, we need the key to be pseudorandom during public encryption. 

A simple solution is to choose $h$ to be a random oracle. The adversary either has made query to $x$ (which happens with negligible probability even with a random oracle), or fails to distinguish $h(x)$ from random (since they are equally distributed).

Another solution is to use $h$ as a hardcore predicate of $f$. In this case, there is one bit of pseudo-entropy in $h(x)$ given $f(x)$. With enough independent samples of $x$ we are able to extract enough randomness for a key using extractors. _This is only handwaving._

Here is a simplified version when we only encode $m in {0,1}$.

*Proposition 6.9.* The following is a (strongly) secure key agreement. Let $h(x,r)$ be the hardcore predicate constructed for $(f(x),r)$.
+ Alice runs $Gen$ and sends $sans("pp")$ to Bob.
+ Bob samples $x$ from the domain of $f$, samples unformly random $r$, and sends $y=f(x), r$ to Alice.
+ Alice outputs $h(Inv(sans("pp"), sans("tp"), y), r)$ while Bob outputs $h(x,r)$.

_Proof._ Suppose there is an adversary $A$ that distinguishes $h(x,r)$ from random with probability $epsilon$. Then $A$ can be used to invert $f$: given $y$, sample $r$, run $A$ on $(y,r)$ and compare with $h(x,r)$. This is a contradiction. $qed$

The third solution, which is the one we focus on, is to use different assumptions.

0. RSA assumption.
1. RSA assumption for fixed $e$: pick $d$ s.t. $e d equiv 1 (mod phi(N))$.
2. Strong RSA: on random $y$, the adversary finds $(x,e)$ and wins if $y equiv x^e, e != plus.minus 1$.
3. $lambda$-bit safe primes $p,q$. A safe prime $p = 2 p' + 1$ is one such that $p'$ is also a prime. 
4. Factorization is hard.
5. Discrete logarithm assumption. Given a cyclic group $G$, a generator $g$ and a random element $g^x$, it's hard to find $x$ given only $g^x$.
6. Computational Diffie-Hellman assumption. Given $g,g^x,g^y$, it's hard to find $g^(x y)$. This induces a natural key agreement protocol: let Alice and Bob send $g^x,g^y$ to the other party respectively, use $h(g^(x y))$ as the key.
7. Decisional Diffie-Hellman assumption. Hard to distinguish $g^(x y)$ from a random $g^z$. In this case $h$ is no longer required.

We have $7 -> 6 -> 5$; $2 -> 0$; $2 -> 1$.

*Definition 6.10. (ElGamal Encryption)*
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

== lec07

#let Sign = math.op(math.sans("Sign"))
#let Vrfy = math.op(math.sans("Vrfy"))

*Definition 7.1 (Signature)* A *signature* scheme $Pi = (Gen, Sign, Vrfy)$, where
- $Gen(1^lambda) -> (p k, s k)$;
- $Sign(s k, m) -> sigma$;
- $Vrfy(p k, m, sigma) -> {0,1}$;
- Correctness: $Vrfy(p k, m, Sign(s k, m)) = 1$.

Security: the challenger sends $p k$ to the adversary. The adversary make queries $m_i$ and asks for $sigma_i$ and wins if it outputs $(m,sigma)$ s.t. $Vrfy(p k, m, sigma) = 1$ and $m != m_i$.

Strong security: requires that $(m,sigma) != (m_i, sigma_i)$.

Similar to public key encryption, signature can be build from trapdoor permutations. #tufted.margin-note([Recall that in PKE, $p k = f$ which maps plaintext to ciphertext, $s k$ is the trapdoor.]) 

Let $f$ be a TDP, $p k = f$, $s k = sans("tp")$. Then $Sign(s k, m) = f^(-1)(m)$, $Vrfy(p k, m, sigma) = [f(sigma) = m]$. A problem with this scheme is that the adversary can simply output $(f(sigma), sigma)$ without making any query. To fix this, we can use a hash function $H$ and sign $H(m)$ instead of $m$.

*Proposition 7.2.* If $f$ is a TDP and $H$ is a random oracle whose codomain is the range of the TDP, then the above scheme is secure.

_Proof._ Suppose $A$ breaks the signature scheme. WLOG assume that if $A$ requests $Sign(s k, m)$ or outputs $(m, sigma)$, then it has queried $m$ to $H$. Let $q$ be the upper bound on the number of queries that $A$ makes. We give an algorithm $B$ that inverts the TDP.

On input $m$, $B$ selects a random $r_m$ and set $H(m) = f(r_m)$ (this simulates the random oracle with equal distribution since $f$ is a permutation). Let $Sign(s k, m) -> r_m$. 

The key is that suppose the output is $(m^*, sigma^*)$, then $A$ comes up with $f^(-1) (H(m^*))$. The goal of $B$ is to invert a uniformly random input $y$ using the power of $A$. $B$ can guess an index $i in [q]$ so that $m^* = m_i$, and set $H(m) <- y$. The multiplicative loss is at most $1/q$. $qed$

*Example 7.3. (Blind Signature)* We would like the party with $s k$ to sign a message $m$ without learning anything from $m$. The homomorphic property of RSA makes it possible. Sample a random $r$ and let $m' = H(m) r^e$. The signer signs $m'$ and sends $sigma' = (m')^d = (H(m))^d r$. The requester then computes $sigma = sigma' r^(-1) = (H(m))^d$.

*Example 7.4. (Threshold Signature)* In RSA, break $d$ into random $d_1, d_2, d_3$ s.t. $d_1 + d_2 + d_3 = d$. Then $sigma = sigma_1 sigma_2 sigma_3$. A malicious party would need to retrieve all $d_i$ to forge a signature.

*Definition 7.5. (Elliptic Curve)* An *elliptic curve* is a set of points $(x,y)$ satisfying $y^2 = x^3 + a x + b$, plus a point at infinity. The points form an abelian group under a geometric addition law. The elliptic curve group on $FF_q$ is denoted as $E(FF_q)$. A theorem of Hasse states that $abs(E(FF_q)) = q + 1 - t$, where $abs(t) <= 2 sqrt(q)$.

*Proposition 7.6. (Bilinear Map / Pairing)* There exists two elliptic curves $G, G_T$ of prime order $p$ and a map $e: G times G -> G_T$ s.t. $e(g^x, g^y) = g_T^(x y)$. An _assymmetric_ pairing uses two isomorphic groups $G_1,G_2$ and $e:G_1 times G_2 -> G_T$ instead. It is required that $e(a^x, b^y) = (e(a,b))^(x y)$. It is also required that $e(g_1,g_2) != 1$.

This implies that DDH doesn't hold on elliptic curves. However, cryptographers are dumb and they are unable to find a similar "trilinear map" that distinguishes $(g,g^x,g^y,g^z, g^(x y z))$ and $(g,g^x,g^y,g^z, g^r)$. So this is used as an assumption (one can see that it implies CDH).

*Example 7.7. (BLS Signature)* Let $s k = x$, $p k = g^x$, $sigma = H(m)^x$. The verifier checks $e(sigma, g) = e(H(m), p k)$. 

This scheme is safe under CDH.

*Definition 7.8. (Identification protocol)* An *identification protocol* is an interactive protocol that allows a party to prove its identity to another party.

*Example 7.9. (Pairing-based Identification protocol)* Let $(g,g^x)$ be public. The prover possesses $x$, and in each turn the verifier samples $y$ and sends $g^y$ to the prover. The prover computes $g^(x y)$ and sends it to the verifier. The verifier checks if $e(g^x, g^y) = g^(x y)$.

Now we present an identification protocol that is based on the hardness of discrete logarithm (which is weaker than DDH, CDH, etc.). We would like the IP to be *honest verifier perfect zero-knowledge*. #tufted.margin-note([The word _honest_ here states that we only need a simulator against *passive* verifiers. In the following example all the verifier does is flipping public coins, so there is no malicious verifier.]) That is, a party with no possession of the secrete can simulate the whole interaction in the same distribution as the interaction with known secret and honest parties, in polynomial time. For example, $cal(P)$ sending $H(s k)$ to $cal(V)$ is not honest verifer perfect zero-knowledge.

*The $Sigma$-protocol.* Suppose the honest prover $cal(P)$ has a private $w$ and $g, h = g^w$ are public. The protocol proceeds in 3 rounds:
1. $cal(P)$ sends $a$ to $cal(V)$.
2. $cal(V)$ responds with $e$ chosen via *public* random coin tosses.
3. $cal(P)$ replies with $z$. $cal(V)$ checks if $(a,e,z)$ is valid.

*Perfect completeness*: if the prover follows this protocol then $cal(V)$ accepts with probability 1.

*Special soundness*: We require that given $cal(V)(a,e,z) = cal(V)(a,e',z') = 1$, $e != e'$, a witness $w$ can be computed in polynomial time s.t. $h = g^w$.

*Knowledge soundness*: If there exists a p.p.t. prover $cal(P)$ that succeeds on the IP with non-negligible probability, then we can use $cal(P)$ (possibly in a non-blackbox way) to extract $w$ with high probability.

*Example 7.10. (Schnorr's $Sigma$-protocol)* Assume $G, g, h = g^w$ are public.
1. $cal(P)$ sends $a = g^r$ to $cal(V)$ where $r$ is drawn randomly.
2. $cal(V)$ responds with a random $e in [0, abs(G)-1]$.
3. $cal(P)$ sends $z = w e + r$ to $cal(V)$, who checks if $a dot.c h^e = g^z$.

Assume $abs(G)$ is prime, completeness and special soundness can be easily verified. A simulator exists by sampling $e, z$ and compute $a = g^z h^(-e)$.

*Proposition 7.11.* $Sigma$-protocol is knowledge sound. (This holds *unconditionally*.)

_Proof._ Assume $cal(P)$ wins the $Sigma$-protocol with probability $epsilon$. Then w.p. $>= epsilon/2$, when the randomness of $cal(P)$ is fixed, $ Pr_e [cal(V)(a,e,z) = 1] >= epsilon/2. $
Generate two transcripts $(a,e,z)$ and $(a,e^prime, z^prime)$ as follows. Fix the randomness of $cal(P)$ and generate $(a,e,z)$ as usual. Then *rewind* $cal(P)$ to the point after $a$ is sent and uniformly samples $e^prime$. When the randomness of $cal(P)$ is good (in the aformentioned sense), 
$ Pr[cal(V)(a,e,z) = 1 and cal(V)(a,e^prime,z^prime) = 1] >= (epsilon/2)^2. $
Thus the extraction succeed w.p. $Omega(epsilon^3)$. $qed$

It is crucial that the randomness in step 2 is public. However, this is hard to achieve in reality. Instead, we would like to use signatures, who can be viewed as a non-interactive prover.

The main issue is that we cannot simply let the prover generate all the randomness (as it can be dishonest). In the general case, the *Fiat-Shamir transformation* uses a random oracle $R$. A new problem is that the prover can learn $R$ on several inputs, so we require that the $i$th random value is evaluated at a point that depends on the first $i$ outputs of the prover, namely $r_i = R(x,g_1,g_2,dots.c,g_i)$ if $g_dot.c$ are the messages $cal(P)$ sends to $cal(V)$. Intuitively, $cal(P)$ cannot learn $r_i$ before determining $g_i$.

In certain cases (e.g. constant round number), Fiat-Shamir transformation is proven to be sound. We prove the soundness when it is applied to $Sigma$-protocols.

*Proposition 7.12.* Applying the Fiat-Shamir transformation to any $Sigma$-protocol yields a non-interactive argument of knowledge (i.e. signature) in the random oracle model.

_Proof._ We present the proof in the context of Schnorr's protocol. Recall that $e = R(h,a)$. Let $cal(Q)$ refer to the non-interactive argument. Let $cal(P)_"FS"$ be a prover for $cal(Q)$ that produces an accepting transcript $(a,e,z) = cal(P)_"FS" (h)$ w.p. $>= epsilon$ (the randomness is over the random oracle and the choices made by $cal(P)_"FS"$). 

Assume that $cal(P)_"FS"$ always makes $T$ distinct queries to $R$, outputs $e = R(h,a)$ and at least one of $cal(P)_"FS"$'s queries was at $(h,a)$. We generate two transcripts in the following way. Fix the internal randomness of $cal(P)_"FS"$ that it outputs some $(a,e,z)$. *Rewind to* the point that it makes query $R(h,a)$. We replace the output with some random $e'$ and let $cal(P)_"FS"$ proceed (again, with freshly generated random responses). It stops with $(a,e^prime,z^prime)$ being the output.

*Claim.* W.p. $Omega(epsilon^4\/T^3)$, $(a,e,z)$ and $(a,e^prime,z^prime)$ are accepting.

Let $X,Y$ be the randomness of $cal(P)_"FS"$ and $R$ respectively. Denote $A(X,Y)$ be the event that $cal(P)_"FS"$ wins. Since $Pr_(X,Y) [A(X,Y)] >= epsilon$, we have $ Pr_X [Pr_Y [A(X,Y) | X] >= epsilon/2] >= epsilon/2. $  

Let $E$ be the event that $Pr_Y [A(X,Y) | X] >= epsilon/2$. The witness extraction succeeds w.p.
$ >= Pr[E] dot.c Pr["witness extraction succeeds" | E] >= epsilon/2 dot.c Pr["witness extraction succeeds" | E]. $

Assume from now on that $X$ is fixed so that $E$ happens. From union bound, for some $i^ast in [T]$, $ Pr_Y [cal(P)_"FS" "wins" and Q_(i^ast) = (h,a)] >= epsilon/(2T). $
Here $Q_i$ refers to the $i$th query. Given $i^ast$, from a similar argument #footnote([We have used this argument 3 times in this proposition and the last proposition.]), w.p. $>= epsilon/(4 T)$ over the random oracle on the first $(i^ast - 1)$ arguments, $cal(P)_"FS"$ wins w.p. $>= epsilon/(4 T)$. Therefore, the extraction succeeds w.p. $>= (epsilon/(4T))^3.$

In conclusion, the witness-extraction procedure succeeds w.p. $Omega(epsilon^4\/T^3)$. $qed$

In fact, it is possible to build signature based on classial primitives, e.g. OWF.

*Definition 7.13. (Lamport Signature)* Let $f$ be an OWF. The secret key is $2 n$ random elements $x_(i,b)$. The public key is $y_(i,b) = f(x_(i,b))$. To sign $m$, for each bit $m_i$, reveal $x_(i,m_i)$. *This works if the adversary only makes 1 query.*

*Definition 7.14. (Chain-Based Signatures)* An improvement is to use multiple $(p k_i, s k_i)$. Initially we have $(p k_1, s k_1)$. On message $m_1$, let $sigma_1 = Sign(s k_1, m_1 || p k_2)$, the signature includes $(sigma_1, p k_2)$. Then $s k_2$ is used to sign $m_2 || p k_3$, etc. Each signature includes its predecessors.

This construction is *stateful* (we have to save every $p k_i, s k_i$ to validate each public key). In general, when the state is $s t$, the signer outputs $Sign((s t, s k_i), m_i) -> sigma_i$ and update $s t$ to $s t^prime$.

*Proposition 7.15.* If $Sign$ is one-time secure, then this scheme is secure under the following attack: the adversary makes several queries and the signer's state changes accordingly; it then forges a (probably long) signture.

_Proof Sketch._ We can attack the one-time signature based on simulation of an adversary $A$ which wins the above game with noticeable probability. The crucial step is to guess the first "fork" that $A$ makes, and place the attack we would like to make at that point.

*Definition 7.16. (Tree-Based Signatures)* We would like a stateless scheme. Intuitively, if we randomly generate a pair of $(p k_m, s k_m)$ for each message $m$, then the signer can use $s k_m$ to sign $m$. 
The tree-based signature provides $sigma_w <- Sign(s k_w, p k_(w 0) || p k_(w 1))$, where each $(p k_w, s k_w)$ is generated independently on node $w$. Finally, $sigma_m <- Sign(s k_m, m)$. The signature includes $(sigma_(m[:i]), p k_(m[:i] 0), p k_(m[:i] 1))$ and $sigma_m$. 

#image("imgs/treebasedsig.png")

*Proposition 7.17.* This scheme is secure as long as $Sign$ is one-time secure.

_Proof Sketch._ Like the last proof, guess the position of the "fork". 

To make the scheme completely stateless, instead of saving each generated pair $(p k_w, s k_w)$, we can use a PRF (whose key is contained in $p k$) and map each node to the random seed used in $Gen$.

*Public-Key Infrastructure.* A client is trying to fetch the public key from a website. The general assumption is that there is some trustworthy *certificate authority*, who generates $(p k, s k)$. The website generates $(p k_1, s k_1)$ and let the CA signs its name and $p k_1$ with $s k$. The client checks the certificate with $p k$. 

In practice there are CAs in different hierarchies. 

== lec08

#let Ext = math.op(math.sans("Ext"))

*Definition 8.1. (Identity-Based Encryption)* An IBE scheme consists of four algorithms: $Gen$, $Ext$, $Enc$, $Dec$.

- $Gen(1^lambda) -> (p k, m s k)$;
- $Ext(m s k, "id") -> s k_("id")$;
- $Enc(p k, "id", m) -> c$;
- $Dec([p k, "id"], s k_("id"), c) -> m$.

We require that $Dec$ is correct.

(IND-ID-CPA) Security: the adversary is given $p k$. It can query in multiple rounds $Ext$, then sends $"id", m_0, m_1$. Then it queries $Ext$ again. Then it sends $b'$ and wins if $b = b'$ and $"id"$ hasn't been queried.

*Example 8.2. (Pairing-Based IBE)* Assume symmetric BDH. The public key includes the two groups $G$ and $G_T$, the bilinear map $e$, and $g, g^alpha$. The master secret key is $alpha$. The identity is mapped to $h_"id" = H_1 ("id") in G$. The secret key is $s k_"id" = h_"id"^alpha$. The encryption is $Enc(g^alpha, "id", m) = (g^r, m plus.o H_2(e(g^alpha, h_"id")^r))$. The decryption is $Dec(s k_"id", (g^r, c)) = c plus.o H_2(e(s k_"id", g^r))$.

*Proposition 8.3.* The scheme is IND-CPA-secure given BDH, when $H_1,H_2$ are modeled as random oracles.

_Proof._ We first convert the IBE to a regular PKE. The PKE only has one public key $(P, p k, Q_0)$ and has access to oracle $H_2$. Here $p k = s P$ is the public key of the IBE ($s$ is the master secret key), $Q_0$ is a random element from $G^*$, $s k = s Q_0$ is the secret key. On $Enc(m)$ we sample a random $r$ and output $c = (r P, m plus.o H_2(e(Q_0, p k)^r))$, for decryption $Dec(U,V) = V plus.o H_2(e(s k,U))$.

We simulate an adversary that attacks the PKE, given an adversary that attacks the IBE. It is required to simulate $H_1$. It can make 2 choices: either set $H_1("id") = b_"id" P$ ($b_"id"$ is a random element) and compute $s k_"id" = s H_1("id") = b_i p k$, or $"id"$ is the challenge identity and $H_1("id") = b^* Q_0$. One can guess the index of the second case.

Given $(P,a P, b P, c P)$, we try to use the CPA adversary for the PKE to compute $a b c P$. Set $p k = a P$, $Q_0 = b P$. Then $s k = a b P$. Maintain the random oracle $H_2$. When the PKE adversary sends $m_0,m_1$, we ought to reply with $c = (c P,m_b plus.o H_2(e(Q_0,p k)^c))$, which is just $m_b plus.o H_2(D)$. Either the adversary computes $D$, or the second part of $c$ is indistinguishable from random, conditioned on $c P$. Hence If the adversary has noticeable IND-CPA advantage it must has queried $H_2(D)$. $qed$

*Definition 8.4. (Attribute-Based Encryption)* This is a generalization over IBE. $Enc$ encrypts $m$ and an "attribute" $x$ into $c$. $Ext(m s k, x) = s k_f$ for some predicate $f$ defined on the space of $x$. $Dec(s k_f, c)$ works if $f(x) = 1$, and outputs $perp$ otherwise.

The following encryption is based on *learning with error (LWE)*.

*Definition 8.5. (LWE)* Let $n, q$ be integers, and $chi$ be a distribution on $ZZ_q$. The LWE problem is to distinguish $(A, A s + e)$ from $(A, u)$, where $A <- ZZ_q^(m times n)$, $s in ZZ_q^n$, $e <- chi^m$, and $u in ZZ_q^m$. Usually each entry of $e$ has scale $O(sqrt(q))$.

LWE can be reduced to the short integer solution (SIS) problem.

*Example 8.6. (Homomorphic Encryption)* An encryption scheme is *homomorphic* if we can compute $Enc(m_1 + m_2)$ from $Enc(m_1)$ and $Enc(m_2)$. Let $s k = bold(s)$, $p k = (q, bold(s) A + e)$. The encryption samples small $bold(r) in {0,1}^n$ and outputs $(A bold(r), (bold(s) A + e) bold(r) + m floor(q/2))$. The decryption computes $c_2 - bold(s) c_1 = e bold(r) + m floor(q/2)$ and rounds.

*Proposition 8.7.* This scheme is CPA-secure under LWE.

_Proof._ $(A,s^top A + e^top)$ and $(A,b^top)$, where $A,b$ are independent and uniform, are indistinguishable. After they are multiplied with $bold(r)$ on the right, the result is indistinguishable from a random vector (by leftover hash lemma). For $m_0,m_1$ the ciphertext distributions are indistinguishable. $qed$

*Definition 8.8. (Fully Homomorphic Encryption)* An encryption scheme is *fully homomorphic* if we can compute $Enc(f(m_1, dots, m_n))$ from $Enc(m_1), dots, Enc(m_n)$ for any arithmetic function $f$. Its public key is divided into encryption key and evaluation key. The evaluation function for addition and multiplication takes the evaluation key as an additional input.

Let $ C = mat(A; bold(s)^top A + e^top) + m I. $

Then $bold(t) = (bold(s)^top || -1)$ is its (approximate) left eigenvector. This scheme is CPA-secure by LWE. We can perform homomorphic addition with simple addition (the error grows a little), but multiplication won't work, since the second matrix might have large entries.

For a matrix $C_(k times k)$, we can compute the binary decomposition of each entry, yielding a $k log q times k$ matrix. Denote this matrix as $G^(-1) (C) in {0,1}^(k log q times k)$. There is a fixed matrix $G$ s.t. $C = G dot.c G^(-1) (C)$. $G$ is called _gadget_.

We replace the encryption scheme with $ C = mat(A; bold(s)^top A + e^top) + m G, $
here $A$ is a random $(n+1) times n log q$ matrix. Decryption is done similarly. During multiplication, we compute

$ 
 bold(s)^top dot.c C_1 dot.c G^(-1) (C_2) &= (e_1^top + m_1 bold(s)^top G) dot.c G^(-1) (C_2) \
 &= e_1^top dot.c G^(-1) (C_2) + m_1 bold(s)^top C_2 \ 
 &= e_1^top dot.c G^(-1) (C_2) + m_1 (e_2^top + m_2 bold(s)^top G) \
 &= m_1 m_2 bold(s)^top G + (e_1^top G^(-1) (C_2) + m_1 e_2^top).
$

The error is now bounded by a fixed polynomial blowup.

Since the noise gradually grows, the depth of the evaluation is limited to sublinear, for instance $d = O(n^(0.99))$. To resolve this issue we use a method called _bootstrapping_. 

Suppose the noise of $c$ is high but it is still decodable. Let 

$ c' = sans("Eval")(e k, Dec, s k, c). $

That is, when the server possesses $Enc(p k, s k)$ #footnote([This require that the scheme is circularily secure.]) and $Enc(p k, c)$, it can compute $Enc(p k, Dec(s k, c))$ which decodes to $m$. Notice that now the error of $c'$ only has to do with the $Dec$ process and has nothing to do with $c$.

Some technical work guarantees that the $Dec$ circuit is shallow enough.

== lec09

Recall that $cal("IP") = cal("PSPACE")$. The following example is an interactive proof that is also *zero-knowledge*. We will consider provers and verifiers that have limited computational power (polytime).

*Example 9.1.* A prover tries to convince a verifier that $g$ is a quadratic residue. 
+ $cal(P)$ sends $h = b^2$ to $cal(V)$. (It does not reveal $b$.)
+ W.p. $1/2$, $cal(V)$ asks for $sqrt(h)$; w.p. $1/2$, $cal(V)$ asks for $sqrt(g/h)$.
+ $cal(P)$ responds with the requested value. When $g$ is not a quadratic residue, $cal(P)$ has $<=1/2$ chance to succeed.

*Definition 9.2. (ZKP)* We consider the language $L$. The verifier and the prover both runs in p.p.t. on an input $x$. The prover additionally takes a witness $w$ when $x in L$.
- Completeness: when $x in L$, $chevron.l cal(P)(x,w), cal(V)(x) chevron.r$ accepts.
- Soundness: for every $cal(P)^*$ with unbounded power, when $x in.not L$, it rejects w.p. $>= 1/2$. If we only consider p.p.t. $cal(P)^*$, the protocal is called an *argument*.
- *Honest-verifier zero-knowledge*: when $x in L$, there exists a p.p.t. $S(x)$, s.t. the output of $S(x)$ is indistinguishable from $"View"_cal(V) chevron.l cal(P)(x,w), cal(V)(x) chevron.r$. One can choose different types of indistinguishability.
- *Malicious-verifier zero-knowledge*: a simulator exists for every p.p.t. $cal(V)^ast$.

Example 9.1 is actually MVZK. Though in step 2 $cal(V)^*$ can send either challenge, the simulator can pick a random challenge and rewind if the guess is wrong. Like rejection sampling, the view it outputs is indistinguishable from the real view.

*Definition 9.3. (Proof of Knowledge)* A protocol is a *proof of knowledge* if there exists a p.p.t. extractor $cal(E)$ s.t. for any $cal(P)^*$ with success probability greater than a constant (called the *knowledge error*), $cal(E)$ can extract a witness $w$ from $cal(P)^*$.

*Example 9.4.* Graph isomorphism has a zero-knowledge proof of knowledge.
+ $cal(P)$ samples a random permutation $pi$ and sends $H = pi(G_0)$ to $cal(V)$.
+ $cal(V)$ sends $b in {0,1}$.
+ $cal(P)$ sends $pi'$ s.t. $H = pi'(G_b)$.

We construct an extractor as follows. Suppose there is some prover $cal(P)^*$. We run $cal(P)^*$ twice with the same random tape, and get two different $b$'s. If the prover succeeds in both, we get $pi_0$ and $pi_1$.

If the original protocal accepts w.p. $>= 1/2 + epsilon$, then for each $b$, $cal(P)^*$ succeeds w.p. $>= 2 epsilon$. Thus we extract the isomorphism w.p. $2 epsilon$.

We don't expect that every problem in $cal("NP")$ has a statistical ZKP. In fact, it is proven that $cal("SZK") subset.eq cal("AM") inter cal("coAM")$, so this would imply that the polynomial hierarchy collapses.

However, as we will see, $cal("NP")$ is indeed contained in $cal("CZK")$, assuming OWF exists. 

Very often, we exploit _locality_ of the proof. That is, if the verifier is only allowed to observe a small fraction of $w$, then it is likely that the proof is zero knowledge. However, to guarantee that the prover actually has a proof, it must send a preliminary version of the proof before revealing local parts of it. 
This goal is achieved using *commitment*.

*Definition 9.5. (Commitment)* A commitment scheme consists of an algorithm $Gen$ and a polynomial time computable function $C$.
+ $Gen(1^lambda)$ outputs public parameter $"pp"$.
+ To commit a bit $b$, the sender samples random $r$ and sends $d = C("pp", b; r)$. To open, the sender receives $(b,r)$, the receiver accepts if $d = C("pp", b; r)$.

A commitment has two properties.
- *(Computational) hiding*: for $"pp" <- Gen(1^lambda)$ and i.i.d. $r_0,r_1$, $("pp", C("pp",0;r_0))$ and $("pp", C("pp",1;r_1))$ are indistinguishable.
- *(Statistical) binding*: except with negligible probability over $Gen$, there do not exist $r_0,r_1$ s.t. $C("pp", 0; r_0) = C("pp", 1; r_1)$.

We can commit independently each bit of a message.

*Example 9.6. (Pedersen Commitment)* Assume $G$ is a group of prime order. Randomly select $g,h in G^*$, let $C = g^m h^r$. 

It satisfies perfect hiding. Assume for $m != m'$ we have $g^m h^r = g^(m') h^(r')$, then we can compute $log_g h$. This contradicts the discrete logarithm assumption.

*Example 9.7. (Naor Commitment)* Let $G: {0,1}^n -> {0,1}^(3n)$ be a PRG. Let $r <- {0,1}^n$, $s <- {0,1}^(3n)$. Let $C = G(r) plus.o (s b)$ for $b in {0,1}$. Here $s$ is public.

Computational hiding is guaranteed by the pseudorandomness of the PRG. If $G(r_0) = G(r_1) plus.o s$, then $s = G(r_0) plus.o G(r_1)$. Notice that the RHS can only take $2^(2n)$ values. So it is in fact a statistical binding. 

Communication complexity can be reduced using structures like the Merkle tree.

Take $sans("3COL")$ as an example. The prover chooses a random permutation of a valid coloring and for each vertex $i$ sends $d_i = C("pp", c_i; r_i)$. The verifier then chooses a random edge $(i,j)$ asks the prover to open it.

Statistical binding ensures that the soundness error is at most $1 - 1 / abs(E) + negl(n)$. MVZK follows since $cal(V)$ has only $abs(E)$ choices, and for each edge the pair of colors distributes uniformly.

*Error reduction.* We consider parallel repetition and sequential repetition. One can see that under both scenerios the soundness error reduces exponentially (like in other interactive protocals).

The MVZK holds in sequential repetition: if the guess is incorrect, the simulator can rewind to the beginning of the current round.

HVZK holds in parallel repetition (simply modify the old simulator). However, under certain assumptions, parallel repetition does not preserve MVZK.

Many of the zero-knowledge proofs we've seen are public-coined, so we can try using the Fiat-Shamir transform. 

Consider the graph isomorphism problem. A naive approach is to let $b = R(G')$ and let the prover send an isomorphism $pi(G_b) = G'$. The problem is that in each round the prover has about $1/2$ probability to succeed, and within a few accesses to $R$ it can find a $G'$ which passes the verification. 

Instead, we should use parallel repetition and let $R$ output multiple bits. (Sequential repetition won't work.)

*PCP.* It is possible to produce polynomial-length proofs, and let the verifier check only constant bits. Intuitively, using adequate commitment scheme makes it zero-knowledge. However we still need to give some constructions for zero-knowledge.

*Groth-Sahai proofs.* By adding auxiliary variables, $sans("CKTSAT")$ can be reduced to $sans("QUADEQ")$. Let $w$ be the witness vector, $W = w w^top$. Then the system is 
$ chevron.l A_i,W chevron.r + b_i^top w + c_i = 0. $

It costs too much to verify each equation independently. Instead, take a random linear combination of the equations. The soundness error is $1/2$.

Suppose that the prover sends $w,W$. We also need to verify that $W = w w^top$. To achieve that goal we sample random $a,b$ and verify that $a^top W b = (a^top w) (b^top w)$. One can see that the soundness error is $3/4$.

#image("imgs/gscomm.png")

Consider the following setting. The witnesses lies in world $A_i$, which are some $cal(R)$-modules equipped with a bilinear map $f$, and we want to prove some quadratic relation. The commitment homomorphically sends them to world $B_i$, where we can verify the quadratic relations. (The graph above commutes.)

We use _common reference string_ $sans("crs") = (B, F, iota, p, u_([m]), v_[m], H_i)$. For $x in A_1$, its commitment would be $c = iota_1 (x) + sum_(i=1)^m r_i u_i$ ($r_i$ are random values in $cal(R)$). In general, for vectors $bold(x),bold(y)$, the commitments are in the form

$ bold(c) = iota_1 (bold(x)) + R bold(u), bold(d) = iota_2 (bold(y)) + S bold(v). $

In the following two settings, the $sans("crs")$ would subject to two (contradictory) settings.

*Binding (soundness)*: $p_1 (bold(u)) = p_2 (bold(v)) = 0$, and $p_i compose iota_i$ are nontrivial.

*Hiding (witness-indistinguishability)*: $iota_1 (A_1) subset.eq chevron.l u_i chevron.r$ and $iota_2 (A_2) subset.eq chevron.l v_i chevron.r$, so commitments are indistinguishable from random. Assume that $chevron.l H_i chevron.r$ is the $cal(R)$-module of all matrices $H$ s.t. $chevron.l u, H v chevron.r = 0$.

*Computational indistinguishability*: under some constructions the two settings are computationally indistinguishable.

Suppose that we would like to prove 

$ chevron.l bold(a), bold(y) chevron.r + chevron.l bold(x), bold(b) chevron.r + chevron.l bold(x), Gamma bold(y) chevron.r = t. $

Applying $iota_i$ to LHS gives us $ iota_T (t) + chevron.l bold(u),bold(pi) chevron.r + chevron.l bold(theta), bold(v) chevron.r. $

We can send $bold(pi), bold(theta)$ as part of the proof and verify that 

$ chevron.l iota_1 (bold(a)), bold(d) chevron.r + chevron.l bold(c), iota_2 (bold(b)) chevron.r + chevron.l bold(c), Gamma bold(d) chevron.r = iota_T (t) + chevron.l bold(u), bold(pi) chevron.r + chevron.l bold(theta), bold(v) chevron.r. $

In the soundness setting, assuming further $p_i compose iota_i$ is identity, applying $p$ to the equation above we can retrieve our witness.

In the witness-indistinguishability setting, we would like to generate a random pair $(bold(pi), bold(theta))$, when every other variable is fixed. For two pairs that satisfy the same equation, 

$ chevron.l bold(u), bold(pi)' - bold(pi) chevron.r + chevron.l bold(theta)' - bold(theta), v chevron.r = 0. $

Recall that the differences are generated by $chevron.l v_i chevron.r$ and $chevron.l u_i chevron.r$ respectively, and we've given $H_i$. Thus we can let 

$ pi' - pi = (H - T) bold(v), theta' - theta = T^top bold(u), $

where $H in chevron.l H_i chevron.r$, $T$ are random.