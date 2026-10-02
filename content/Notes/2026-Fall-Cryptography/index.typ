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

The PRG in Proposition 1.12 can be made to generate unlimited amount of pseudorandom bits. The infinite string then can be used to encrypt multiple messages. Such a scheme is called a *stream cipher*.

We define several candidates for multi-message security.

*Definition 2.1. (Multi-message Indistinguishability Game)* The challenger sends $lambda$ to the adversary. Then the adversary sends $m_([l])^0, m_([l])^1$ to the challenger, who samples $b <- {0,1}, k <- Gen(1^lambda)$ then responds with $(c_i = Enc(k,m_i^b))$. The adversary outputs $b' in {0,1}$ and wins if $b' = b$. Notice that we allow $m_i^0 = m_i^1$.

The problem with this definition is that it doesn't handle _adaptive queries_, and $Enc$ might be weak against this type of attacks.

*Definition 2.2. (Chosen Plaintext Attack)* The CPA game allows the adversary to query polynomially many instances $Enc(k,m_i)$ before and after the distinguishing process. ($k$ is fixed in advance.) It is only required to distinguish a single pair of messages $m^b, b <- {0,1}$.

*Definition 2.3. (Multi-message CPA)* The adversary now queries a polynomially long sequence of $(m_i^0, m_i^1)$, and the challenger responds with $Enc(k,m_i^b)$ *instantly after each query*. 

*Proposition 2.4.* CPA and multi-message CPA are equivalent.

_Proof Sketch._ It is evident that multi-message CPA security implies CPA security. The opposite direction is proven with a hybrid argument: consider letting the challenger respond with $Enc(k,m_i^0)$ in the first $j$ queries and respond with $Enc(k,m_i^1)$ in the last $l-j$ queries. 

One can see that a deterministic encryption scheme cannot be CPA secure since we allow $m_i^0 = m_i^1$.

To construct a scheme which handles multiple messages while satisfying the CPA security, we need to use *pseudorandom functions*. 

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

Assume the block size (i.e. the length of the PRP) is fixed. We can encrypt larger files by using *mode of operation*. Often an *initialization vector (IV)* is needed.

*Example 4.1. (ECB mode)* Let $c_i = F_k (m_i)$. Clearly unsafe.

*Example 4.2. (CBC mode)* Let $c_(i+1) = F_k (c_i plus.o m_(i+1))$. This is a stated encryption.

*Example 4.3. (OFB mode)* Let $c_i = m_i plus.o s_(i-1)$, $s_i = F_k (s_(i-1))$.

*Example 4.4. (CTR mode)* Let $c_i = m_i plus.o F_k (i)$.

The following is an ad hoc construction of a PRP.

*Example 4.5. (Substitution-Permutation Network)* Suppose the key is divided into $m+1$ parts $k = k_0 || k_1 || dots.c || k_m$. The encryption is a composition of $plus.o k_i$ and $P_i$, where each $P_i$ is a public, efficiently computable and (hopefully) complex permutation.

$P_i$ is usually a composition of $L_i compose S_i$. Here $S_i$ is a block-wise function and $L_i$ is a linear function. 

In *Advanced Encryption Standard*, $S_i$ is chosen to be $x mapsto x^255$ (in $FF_256$), while $L_i$ is a permutation of 16 blocks left-multiplied by a fix matrix.

Here is another construction of a PRP based on a PRF.

*Example 4.6. (Swap-or-not)* Perform $T$ rounds of operation. In round $i$, if $F_k ({x,x plus.o Delta_i}) = 0$ then leave $x$ as it is, otherwise let $x <- x plus.o Delta_i$.

*Definition 4.7. (Chosen Ciphertext Attack)* The adversary is allowed to ask for plaintext encryption or ciphertext decryption. Then it is required to send two messages, receiving the ciphertext from one of them. The adversary now can make some further queries (mustn't collide with previous ones). It is asked to distinguish the two messages.

Message authentication codes are used against CCA: suppose there is a way to certify that a ciphertext is not generated by someone who has the private key, then $Dec$ can refuse to decrypt the ciphertext.  (Enc(m), MAC) Enc(m||sigma)

*Definition 4.8. (MAC, CMA game)* A *message authentication code* consists of a triple $ Pi = (Gen, sans("Mac"), sans("Vrfy")). $

$sans("Mac")$ maps $(k,m)$ to $sigma$, $sans("Vrfy")$ takes $(k,m,sigma)$ and outputs ${0,1}$. We require that $Pr[sans("Vrfy")(k,m,sans("Mac")(k,m)) = 1] = 1$.

The security of $Pi$ is defined via the *chosen message attack* game. The adversary receives $1^lambda$, 