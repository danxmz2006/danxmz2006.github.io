// Cryptography cheat sheet — generated from content/Notes/2026-Fall-Cryptography/index.typ (lec01–lec06)
#set page(
  paper: "a4",
  margin: (top: 1.05cm, bottom: 0.55cm, x: 0.7cm),
  columns: 3,
  header: [
    #set text(size: 6.2pt, fill: luma(115))
    #grid(
      columns: (1fr, auto),
      align: (left, right),
      [*Cryptography — cheat sheet*],
      [2026 Fall · lec01–lec06 · after the course notes],
    )
    #v(-4pt)
    #line(length: 100%, stroke: 0.35pt + luma(175))
  ],
)

#set text(font: "New Computer Modern", size: 8.5pt, fill: luma(20))
#set par(justify: true, leading: 0.42em, spacing: 0.46em, first-line-indent: 0em)
#set math.equation(numbering: none)
#show math.equation: set block(above: 0.35em, below: 0.35em)

#let Pr = math.op("Pr")
#let negl = math.op("negl")
#let Gen = math.op("Gen")
#let Enc = math.op("Enc")
#let Dec = math.op("Dec")
#let Encaps = math.op("Encaps")
#let Decaps = math.op("Decaps")
#let Inv = math.op("Inv")
#let Mac = math.op("Mac")
#let Vrfy = math.op("Vrfy")
#let IV = math.op("IV")
#let D(t) = text(fill: rgb("#0b3d6b"), weight: "bold")[#t]
#let R(t) = text(fill: rgb("#8a1c1c"), weight: "bold")[#t]
#let hd(t) = block(
  above: 0.7em,
  sticky: true,
  below: 0.32em,
  width: 100%,
  fill: rgb("#0b3d6b"),
  inset: (x: 3.5pt, y: 1.8pt),
  radius: 1.5pt,
  text(fill: white, weight: "bold", size: 8.6pt)[#t],
)

#text(size: 7.4pt)[
  *Notation.* $lambda$ security parameter; $U_n$ uniform on ${0,1}^n$; p.p.t. = probabilistic
  poly-time; $negl$ = smaller than every $1/"poly"$ for large $lambda$; $X approx Y$ computational
  indistinguishability ($forall$ p.p.t. $D$: $|Pr[D(X) = 1] - Pr[D(Y) = 1]| = "negl"$);
  $X equiv Y$ identical distributions; $xor$ = bitwise xor; $parallel$ = concatenation;
  $chevron.l x,y chevron.r = sum_i x_i y_i mod 2$; $F_k (dot.c) = F(k, dot.c)$.
]

#hd[1 · Encryption: syntax and perfect secrecy]

#D[Def 1.1 (encryption scheme).]
$Pi = (cal(M), cal(C), cal(K), Gen, Enc, Dec)$: $Gen(1^lambda)$ is randomized and samples
$k <- cal(K)$; $Enc : cal(K) times cal(M) -> cal(C)$ may be randomized;
$Dec : cal(K) times cal(C) -> cal(M)$ is deterministic. *Correctness:*
$Dec(k, Enc(k,m)) = m$ for all $k, m$.

#D[Def 1.2 (perfect secrecy, Shannon).]
For all $m_0 != m_1$: $Enc(K, m_0) equiv Enc(K, m_1)$, where $K <- Gen$. Equivalently
$Pr[M = m | C = c] = Pr[M = m]$ for every $c$ in the support — the ciphertext leaks nothing about the
message.

#D[Def 1.3 (semantic security).]
For every function $f$ on $cal(M)$, every distribution $M$, every adversary $A$ with side information
$g(M)$, there is $S$ with
$ Pr[A(c, g(M)) = f(M)] <= Pr[S(g(M)) = f(M)]. $

#R[Prop 1.4.] Def 1.2 $arrow.l.r.double$ Def 1.3.
($arrow.r$: $S(g(M)) := A(Enc(K, m_0), g(M))$. $arrow.l$: if $Enc(K,m_0) != Enc(K,m_1)$, take $M$
uniform on ${m_0, m_1}$, $g = perp$ and a distinguisher $A$; then $S$ is at best a random guess while
$A$ wins $> 1/2$.)

*One-time pad (Ex 1.5).* $cal(K) = cal(M) = cal(C) = {0,1}^n$, $k <- U_n$;
$Enc(k,m) = k xor m$, $Dec(k,c) = k xor c$; perfectly secret.

#R[Prop 1.6 (key-length bound).] $|cal(K)| < |cal(M)|$ $arrow.r$ no perfect secrecy. Indeed
$|"supp"(Enc(K, m_0))| <= |cal(K)| < |cal(M)|$, so some $m_1$ lies outside the support and the two
distributions differ. Allowing total-variation error $epsilon$ gives *statistical secrecy* — useless
once $|cal(K)| << |cal(M)|$.

#D[Def 1.7 (scheme, v2).] A *security parameter* $lambda$ replaces the message length:
$k <- Gen(1^lambda)$, messages in $cal(M)_lambda$, all algorithms p.p.t. in $lambda$.

#D[Def 1.8 (computational indistinguishability, IND).]
For all $m_0 != m_1 in cal(M)_lambda$ output by the adversary and every p.p.t. distinguisher
$D : cal(C) -> {0,1}$,
$ Pr[D(Enc(K, m_b)) = b] <= 1\/2 + "negl"(lambda), $
with $b <- {0,1}$ chosen by the challenger.

#D[Def 1.9 (semantic security).] For every p.p.t. $A$ there is p.p.t. $S$ with
$ Pr[A(Enc(K,M), g(M)) = f(M)] <= Pr[S(g(M)) = f(M)] + "negl"(lambda). $

#R[Thm 1.10 (Goldwasser–Micali).] Def 1.8 $arrow.l.r.double$ Def 1.9.
(If security fails for some $m_1$, then for infinitely many $lambda$
$Pr[A(Enc(K,m_1)) = f(m_1)] >= Pr[A(Enc(K,m_0)) = f(m_0)] + 1\/"poly"$, contradicting IND; a
distinguisher conversely breaks semantic security for $M$ uniform on ${m_0, m_1}$.)

#hd[2 · Pseudorandom generators, stream ciphers]

#D[Def 1.11 (PRG).] $G : {0,1}^lambda -> {0,1}^(ell(lambda))$ with $ell(lambda) > lambda$ and
$G(U_lambda) approx U_(ell(lambda))$; $ell(lambda) - lambda$ is the *stretch*.

#R[Prop 1.12 (stretch amplification).] A 1-bit stretch extends to any poly stretch.
Write $G(s_i) = x_i parallel s_(i+1)$ and $G'(s) = x_1 parallel dots.c parallel x_n$, $n = ell(lambda)$.
If $G'$ is not a PRG, the hybrid argument yields a next-bit predictor
$Pr_s[P(x_i, x_(i+2), dots.c, x_n) = x_(i-1)] >= 1/2 + 1/"poly"(n)$. But $x_i dots.c x_n$ is a function
of $s_i$, so $P$ predicts a bit of $G(s_(i-1))$ — contradicting that $G$ is a PRG.

#R[Prop 1.13 (stream cipher).] If $G$ is a PRG then
$Enc(k,m) = G(k) xor m$, $Dec(k,c) = G(k) xor c$ is IND-secure.
(For a supposed distinguisher $D$ let $A(x)$ pick $b <- {0,1}$ and output $[D(x xor m_b) = b]$; then
$EE[A(U)] = 1\/2$ while $EE[A(G(k))] >= 1/2 + 1/"poly"$.)

A PRG with poly stretch XORed with an arbitrarily long message is a *stream cipher*.

#hd[3 · CPA security, PRFs, one-way functions]

#D[Def 2.1 (multi-message game).] The adversary sends $(m_i^0, m_i^1)_(i <= l)$ with
$m_i^0 = m_i^1$ allowed, receives $c_i = Enc(k, m_i^b)$, wins if $b' = b$. Not adaptive.

#D[Def 2.2 (CPA).] Oracle access to $Enc(k, dot.c)$ before and after the challenge; only one challenge
pair $m^b$ must be distinguished. #D[Def 2.3 (multi-CPA).] Poly many pairs, each answered *instantly*
with $Enc(k, m_i^b)$.

#R[Prop 2.4.] CPA $arrow.l.r.double$ multi-CPA. (Hybrid: answer the first $j$ queries from $m_i^0$ and the
rest from $m_i^1$.)

*Deterministic encryption is never CPA-secure* — query $m_i^0 = m_i^1$.

#D[Def 2.5 (PRF).] $F : {0,1}^lambda times {0,1}^(n(lambda)) -> {0,1}^(m(lambda))$ is p.p.t. computable
and $F(k, dot.c)$ is indistinguishable from a uniformly random function. The *GGM tree* builds a PRF
from a PRG; a PRF trivially gives a PRG.

*CPA-secure randomized encryption.* $Enc(k,m) = r_m parallel (F(k, r_m) xor m)$, $r_m <- {0,1}^lambda$.
The $r_m$ are distinct w.h.p.; conditioned on that, a large CPA advantage distinguishes $F$ from a
random function.

#D[Def 2.6 (OWF).] $f : {0,1}^* -> {0,1}^*$ is p.p.t. computable and for every p.p.t. $A$
$ Pr[A(f(U_n), 1^n) in f^(-1)(f(U_n))] = "negl"(n). $

#R[Prop 2.6′.] A PRG $G : {0,1}^ell -> {0,1}^n$ with $n >= 2 ell$ is a OWF.
(If $A$ inverts w.p. $>= 1\/n^c$, let $D(x) = 1$ when $G(A(x,1^ell)) = x$ and a fair coin otherwise;
then $Pr[D(G(U_ell)) = 1] >= 1/2 + 1\/n^c$ while
$Pr[D(U_n) = 1] <= 1/2 + 2^(ell-n) <= 1/2 + 2^(-n\/2)$.)

#R[Prop 2.7.] A CPA-secure scheme yields a OWF: $f(x) = Enc(Gen(1^lambda; x), 0^lambda)$.

*Length-preserving padding is delicate.* With $F : {0,1}^n -> {0,1}^(n\/2)$ a OWF, let
$F'(x) = x$ if $x = x' parallel 0^(n\/2)$ and $F(x)$ otherwise. Then $F'$ is still a OWF, but after
padding to length $n$ one has $F'(F'(x)) = F'(x)$, so it is no longer one-way. (Pad with a $1$ or with
the length.)

#hd[4 · Hardcore bits, OWP, PRP]

#D[Def 3.1 (weak OWF, OWP).] A *weak OWF* is p.p.t. and there is a fixed poly $q$ such that every
p.p.t. $A$ inverts it on at most a $1 - 1\/q(n)$ fraction of inputs (for large $n$). A *one-way
permutation* is a OWF that is a permutation.

#D[Def 3.2 (hardcore predicate).] $h : {0,1}^* -> {0,1}$ with, for every p.p.t. $A$,
$ Pr_(x <- {0,1}^lambda)[A(1^lambda, f(x)) = h(x)] <= 1\/2 + "negl"(lambda). $

#R[Thm 3.3 (Goldreich–Levin).] If a OWF exists, some OWF has a hardcore predicate.
For a OWF $f$ take $f_"GL" (x,y) = (f(x), y)$, $|y| = |x| = |f(x)|$, and the Hadamard bit
$h(x,y) = chevron.l x,y chevron.r$. A predictor with advantage $1\/"poly"$ gives, for a noticeable
fraction of $x$, $Pr_y[A_"GL" (f_"GL" (x,y)) = chevron.l x,y chevron.r] >= 1/2 + 1\/"poly"$; local
list-decoding of the Hadamard code then recovers $x$. Pick a random $<=t$-dimensional subspace
$V <= FF_2^n$; given correct values $chevron.l a, dot.c chevron.r$ on $V$, majority over
$x in V$ of $g(x xor e_i) xor chevron.l a,x chevron.r$ recovers $chevron.l a, e_i chevron.r$. Values on
$V$ are correct when they are correct on generators $r_1, dots.c, r_t$ (probability $2^(-t)$), and for
$r_S = xor.big_(i in S) r_i$ the pairwise independence plus Chebyshev gives error
$<= 1\/((2^t - 1) epsilon^2)$. With $t = log(2n\/epsilon^2)$ recovery is noticeable, so $f$ is
inverted. #R[Cor 3.4.] OWP $p$ + hardcore $h$ $arrow.r$ PRG $G(x) = p(x) parallel h(x)$.

#D[Def 3.5 (universal OWF); Prop 3.6.] Enumerate Turing machines and split
$x = x_1 parallel x_2 parallel dots.c$ with $|x_i| = |x|\/2^i$; then
$f(x) = "TM"_1 (x_1) parallel "TM"_2 (x_2) parallel dots.c$ is a OWF whenever any OWF exists. (Padding
gives a universal construction running in time $O(n^2)$.)

#R[Thm 3.8 (Yao).] Weak OWF $arrow.r$ OWF. With $f$ weak and
$f'(x_1 parallel dots.c parallel x_m) = f(x_1) parallel dots.c parallel f(x_m)$, $m = m(n)$ poly and
independent of $p$: if $A'$ inverts $f'$ w.p. $>= 1\/p(n)$, then either all blocks are "good" or some
block is bad — but a bad block would be inverted by $A'$, bounding the density of bad blocks; repetition
amplifies the good ones. (A direct-product theorem; full proof in pset3.)

#box[#D[PRP / block cipher.]] $P : {0,1}^lambda times {0,1}^(n(lambda)) -> {0,1}^(n(lambda))$ must be correct,
with $P$ and $P^(-1)$ computable in p.p.t. *Secure* = a PRF; *strongly secure* = secure even with
oracles to both $P$ and $P^(-1)$.

#R[Thm 3.7 (Feistel).] With $x = x_0 parallel x_1$ and
$x_(i+2) = F(k_(i+1), x_(i+1)) xor x_i$, the 3-round network is a secure PRP and the 4-round network is
a strong PRP. (Replace each $F$ by a random $f_i$ by a hybrid argument; collisions at $x_2, x_3, x_4$
occur with negligible probability by a union bound, after which the outputs are uniform and
independent. Alternating directions require "local replacement"; see pset3.)

*3 rounds are not strongly secure.* Query $(x_0, x_1)$, $(x_0 xor r, x_1)$ and
$P^(-1)(x_3^0, x_4^0 xor r)$; then $x_3^1 xor x_1^0 = x_1^2 xor x_3^0 = f_2 (x_2 xor r)$, a relation a
random permutation satisfies only with negligible probability. The cause: $x_2$ is reachable from both
directions, while with 4 rounds cross-direction collisions such as
$x_0^i xor f_1 (x_1^i) = x_4^j xor f_3 (x_3^j)$ are prevented.

#hd[5 · Modes of operation, block ciphers]

*ECB (Ex 4.1).* $c_i = F_k (m_i)$ — unsafe: equal blocks leak equality.
*CBC (Ex 4.2).* $c_0 = "IV"$, $c_(i+1) = F_k (c_i xor m_(i+1))$; CPA-secure for a PRP $F$ with a fresh
uniform IV.
*OFB (Ex 4.3).* $s_0 = "IV"$, $s_i = F_k (s_(i-1))$, $c_i = m_i xor s_(i-1)$.
*CTR (Ex 4.4).* $c_i = m_i xor F_k ("ctr" + i)$; needs a nonce unique per message; parallel and
random-access.

*SPN (Ex 4.5).* $k = k_0 parallel dots.c parallel k_m$; each round applies $xor k_i$ then a public
permutation $P_i = L_i compose S_i$ with $S_i$ block-wise nonlinear and $L_i$ linear. AES takes
$S_i : x |-> x^(-1)$ in $FF_(2^8)$ (plus an affine map) and $L_i$ a fixed matrix acting on 16 blocks.
*Swap-or-not (Ex 4.6).* $T$ rounds; in round $i$, if $F_k ({x, x xor Delta_i}) = 1$ then
$x <- x xor Delta_i$, else $x$ is unchanged. Generalizes to permutations of any set.

#hd[6 · CCA security, MACs, authenticated encryption]

#D[Def 4.7 (IND-CCA2).] $A$ gets $1^lambda$ and oracles $Enc(k, dot.c)$, $Dec(k, dot.c)$; it outputs
equal-length $m_0, m_1$; the challenger samples $b <- {0,1}$ and $c <- Enc(k, m_b)$; $A$ keeps both
oracles but may not decrypt $c$; it wins if $b' = b$. ($Enc$ is randomized.) Earlier schemes fail: a
slight modification of $c$ still decrypts to a related message (malleability).

#D[Def 4.8 (MAC, CMA).] $Pi = (Gen, "Mac", "Vrfy")$, with
$Pr["Vrfy"(k, m, "Mac"(k,m)) = 1] = 1$; for deterministic MACs *canonical* verification checks
$sigma = "Mac"(k,m)$. The *chosen-message attack* gives oracle access to $Mac(k, dot.c)$ and asks for
$(m, sigma)$ with $m$ unqueried, winning if it verifies. *Strongly secure*: also allows a new
$sigma'$ for an already queried $m$.

#D[Def 4.9 (authenticated encryption).] CPA-secure *and* unforgeable: a forger with an $Enc$ oracle
cannot output a ciphertext that decrypts to an unqueried message.

#R[Prop 4.10.] AE $arrow.r$ CCA. Unforgeability means the adversary never needs a meaningful $Dec$
query, so $Dec$ can be removed and only the CPA game remains.

#R[Prop 4.11.] CPA-secure $Enc$ + CMA-unforgeable $"Mac"$ $arrow.r$ encrypt-then-MAC is AE:
$c' = Enc(k,m)$, $sigma = "Mac"(k', c')$, $c = (c', sigma)$. (CPA: replace $k'$ by a random key,
contrapose. Unforgeability: replace $k$ by a random key, contrapose.)

*Composition pitfalls.* $c = (Enc(k,m), "Mac"(k', m))$ can fail CPA (the tag may leak $m$).
MAC-then-encrypt ($c = Enc(k, m parallel sigma)$) fails CCA — e.g. a scheme that prepends a "trash bit"
can be modified and still decrypt validly. Only encrypt-then-MAC is safe.

*CBC-MAC (Def 4.12).* $sigma_0 = 0^n$, $sigma_i = F_k (sigma_(i-1) xor m_i)$, $sigma = sigma_l$.
Unforgeable only for *prefix-free* query sets; fix with ECBC-MAC by encrypting the last round with an
independent key, $sigma_l = F_(k')(sigma_(l-1) xor m_l)$, which is essentially random as long as the
arguments $sigma_(l-1) xor m_l$ are pairwise distinct. #R[Prop 4.13] ECBC-MAC is unforgeable (induction
on the trie of the queried messages, as for Feistel).

*NMAC (Ex 4.14).* $H_k (M) = F(dots.c F(F(k, m_1), m_2) dots.c, m_l)$ and
$"Mac"(k parallel k', M) = F(k', H_k (M))$.
*PMAC (Ex 4.15).* $c_i = F_k (m_i xor L_i)$, $c = F_(k')(xor.big c_i)$.
*Ascon (Ex 4.16).* $S_(i+1) = p_k (S_i xor M_i)$.

#hd[7 · Hashing, random oracles]

#D[Def 5.1 (keyed hash).] $(Gen, H)$ with $Gen(1^lambda)$ giving $|k| = lambda$; *collision resistant*
if for every p.p.t. $A$
$ Pr[H(k,m_0) = H(k,m_1) : A(1^lambda) -> m_0 != m_1] = "negl"(lambda). $

*Universal hashing (Ex 5.2).* $k in FF_(2^lambda)$, $H(k,p) = p(k)$ with $deg p < 2^lambda$ is collision
resistant (a nonzero difference polynomial has fewer than $2^lambda$ roots). The keyless notion is the
same without $k$.

#R[Prop 5.3.] CRHF $arrow.r$ OWF: inverting a random $x$ to $x'$ with $H(x') = H(x)$ gives $x' != x$
w.h.p., a collision. Converse is impossible in a black-box way, so one extends a fixed-length CRHF:

*Merkle–Damgård (Ex 5.4).* $H : {0,1}^(2lambda) -> {0,1}^lambda$ CR, $d_0 = "IV"$,
$d_i = H(d_(i-1), m_i)$. Only equal-length messages remain a problem; reveal (or pad with) the length.
*Merkle tree (Ex 5.5).* $x_p = H(x_l, x_r)$ over a binary tree of blocks; same length fix.
*Weaker attackers.* Second preimage: given random $x$, find $x' != x$ with $H(x') = H(x)$. Preimage:
given random $y$, find any $x$ with $H(x) = y$.

*Keyed hashing from a CRHF (Ex 5.6).* $H(k parallel m)$ suffers length extension; $H(m parallel k)$
collides whenever $m != m'$ collide keylessly. *Hash-and-MAC:* key $(k,s)$ and
$"Mac"'_(k,s)(m) = "Mac"_k (H^s (m))$ with a fixed-length MAC and a seeded hash. *HMAC* is 2-nested: the
prepend-keyed hash is applied again, so the key enters both layers.

*Compression functions.* Using a block cipher directly inside Merkle–Damgård is unsafe (weak against
preimage attacks). *Davies–Meyer:* $H(x,y) = E_y (x) xor x$. Security needs an *ideal cipher*, not just a
PRP, because the adversary controls the key. #R[Prop 5.9] Davies–Meyer is collision resistant under an
ideal cipher $cal(E)$: for distinct queries $i < j$ the value $m_i xor c_i = m_j xor c_j$ has
probability $<= 1\/(2^n - j + 1)$ (randomness is fixed after query $j$), then union bound.

*Random-oracle model.* #R[Prop 5.7] A random oracle is a PRG against any $A^H$ making polynomially many
queries — no computational bound needed: given $y = H(x)$, w.h.p. $A$ never queried $x$, so the real
world degenerates to the ideal one. #R[Prop 5.8] A random oracle is collision resistant: the output pair
must appear among the queries, reducing to the non-adaptive bound.

#D[Def 5.10 (indifferentiability).] $C^F$ is indifferentiable from $P$ if some simulator $S$ gives, for
every $A$, $|EE[A^(C^F, F)] - EE[A^(P, S^P)]| = "negl"(n)$. Needed because the adversary may access the
underlying primitive $F$. A 5-round Feistel network is not indifferentiable from an ideal permutation;
10 rounds suffice.

#hd[8 · Public-key cryptography]

#D[Def 6.1 (key agreement).] A pair of interactive algorithms $(A(1^lambda), B(1^lambda))$, *correct*
(identical outputs) and *passively secure*: $(T,k) approx (T,k')$ with $T$ the transcript and $k'$
uniform — so $k$ is hard to find from $T$.

*Merkle puzzles (Ex 6.2).* Alice sends $N$ puzzles each costing $Theta(N)$ to solve; Bob solves one
($Theta(N)$), the eavesdropper must solve all ($Theta(N^2)$).

#D[Def 6.3 (PKE).] $Gen(1^lambda) -> (p k, s k)$, $Enc(p k, m)$, deterministic
$Dec(s k, c)$ with $Dec(s k, Enc(p k, m)) = m$.
#D[Def 6.4 (CPA).] $A$ receives $p k$, sends $m_0, m_1$, receives $Enc(p k, m_b)$, outputs $b'$; no
encryption oracle is needed since $p k$ is public. PKE $arrow.r$ key agreement: Bob publishes $p k$,
Alice sends $Enc(p k, k)$.

#D[Def 6.5 (KEM).] $(Gen, Encaps, Decaps)$ with $Gen(1^lambda) -> (p k, s k)$,
$Encaps(p k) -> (k, c)$, $Decaps(s k, c) = k$; secure if $k$ is indistinguishable from uniform given
$p k$ and $c$.

#D[Def 6.6 (trapdoor permutation).] $(Gen, F, Inv)$: $Gen(1^lambda) -> (f, "tp")$ where $f = F_"pp"$ is
injective with public parameter $"pp"$; $Inv("pp", "tp", f(x)) = x$; $f$ is one-way without $"tp"$.

*RSA (Ex 6.7).* $N = p q$, $e d equiv 1 space (mod phi(N))$, $"pp" = (N,e)$, $"tp" = d$;
$F_"pp" (x) = x^e mod N$, $Inv("pp","tp",y) = y^d mod N$, $x in ZZ_N^times$.

*Key agreement from a TDP (Def 6.8).* Alice runs $Gen$ and sends $"pp"$; Bob sends $y = f(x)$; Alice
outputs $h(Inv("pp","tp",y))$, Bob outputs $h(x)$. Given $f(x)$, $x$ is easily distinguishable from
random, so $h$ must be a random oracle (the adversary would have to query $x$) or a hardcore predicate
(one pseudo-bit per sample, combined by extractors — the notes call this handwaving).

#R[Prop 6.9.] With a hardcore $h(x,r)$ for $(f(x), r)$, the following is strongly secure: Bob sends
$(y = f(x), r)$; both output $h(x,r)$. A distinguisher with advantage $epsilon$ inverts $f$: on input
$y$, sample $r$, run it on $(y,r)$, compare with $h(x,r)$.

*Assumptions.* (0) RSA. (1) RSA with fixed $e$. (2) Strong RSA: given $y$, find $(x,e)$ with
$e != plus.minus 1$ and $y equiv x^e$. (3) $lambda$-bit safe primes $p = 2p' + 1$. (4) Factoring is
hard. (5) Discrete log: from $g, g^x$ find $x$. (6) CDH: from $g, g^x, g^y$ find $g^(x y)$ — gives a
key agreement with key $h(g^(x y))$. (7) DDH: $g^(x y) approx g^z$, after which $h$ is unnecessary.
Implications: $7 arrow.r 6 arrow.r 5$; $2 arrow.r 0$; $2 arrow.r 1$.

*ElGamal (Def 6.10).* Key $p k = (G, g, g^x)$, $s k = x$. Under DDH
$Enc(m) = (g^y, g^(x y) m)$ and $Dec(t,c) = t^(-x) c$; under CDH
$Enc(m) = (g^y, H(g^(x y)) xor m)$ and $Dec(t,c) = c xor H(t^x)$.

#R[Prop 6.11 (worst case to average case).] If RSA with fixed $(N,e)$ is hard, it is hard on random
instances: randomize $y' = y r^e$ (for discrete log, $h' = h g^r$), invert $y'$ to $z$, then
$x = z r^(-1)$ (resp. $x = z - r$).

*Keyed CRHF from discrete log.* Let $|G| = p$ be prime, $g in G$, $h = g^s$; then
$H(x,y) = g^x h^y$ — a collision reveals $s$ (hence the discrete log). Instantiate in $QQ RR_p$: for
$p = 2p' + 1$ the quadratic residues form a cyclic group of order $p'$.

#D[Def 6.12 (homomorphic encryption).] If $c = Enc(f(x_1, x_2))$ can be computed directly from
$c_1 = Enc(x_1)$, $c_2 = Enc(x_2)$, the scheme is homomorphic. Such schemes are never CCA-secure.

#hd[9 · Notions at a glance]

*Perfect secrecy* — $Enc(K,m_0) equiv Enc(K,m_1)$; needs $|cal(K)| >= |cal(M)|$; OTP attains it.
*Statistical secrecy* — the two distributions differ by total variation $epsilon$.
*IND (computational)* — $Pr[D(Enc(K,m_b)) = b] <= 1/2 + negl$; equivalent to semantic security (GM).
*CPA* — plus an encryption oracle; equivalent to its multi-message form; deterministic schemes excluded.
*CCA2* — plus a decryption oracle, except on the challenge ciphertext.
*AE* — CPA-secure and unforgeable; implies CCA; encrypt-then-MAC attains it.
*MAC* — CMA unforgeability (strong: no new tag for an old message).
*Hash* — collision resistance; a CRHF is a OWF, while second-preimage and preimage are weaker attacker
goals.
#box[*PKE / KEM*] — the CPA game with $p k$ public; a KEM encapsulates a random $k$.
*Key agreement* — correct and $(T,k) approx (T,U)$; Merkle puzzles give a $Theta(N^2)$ work gap.

#hd[10 · Reduction recipes and pitfalls]

*Recipes.*
*Hybrid argument* — swap one object at a time (multi-CPA $arrow.l.r.double$ CPA, stretch amplification,
Feistel round replacement).
*Distinguisher from inverter* — guess and test: $D(x) = 1$ iff $G(A(x)) = x$ (PRG $arrow.r$ OWF).
*Inverter from distinguisher* — embed the challenge: $A(x) = [D(x xor m_b) = b]$ (stream cipher), local
list-decoding (GL).
*Union bound on collisions* — Feistel, Davies–Meyer and ECBC-MAC need pairwise distinct arguments.
*"The query must be made"* — in the ROM a value never queried looks uniform (RO $arrow.r$ PRG; TDP + RO
key agreement).
*Contraposition with a random key* — the encrypt-then-MAC proof.
*Direct product* — Yao's weak-to-strong amplification.

*Pitfalls.* A deterministic scheme is never CPA-secure; CBC needs a fresh uniform IV and CTR a unique
nonce; CBC-MAC is safe only for prefix-free queries (use ECBC); $H(k parallel m)$ suffers length
extension whereas $H(m parallel k)$ inherits keyless collisions; a 3-round Feistel network is not a
strong PRP; padding a OWF must preserve one-wayness; ElGamal is malleable and homomorphic encryption is
never CCA-secure; ROM proofs hold only in the ROM, and indifferentiability is needed once the adversary
may call the underlying primitive.

#hd[11 · Constructions at a glance]

#set table(stroke: none, inset: (x: 2pt, y: 1.4pt))
#show table.cell: set text(size: 7pt)
#table(
  columns: (1.45fr, 1fr, 1.35fr),
  fill: (x, y) => if calc.odd(y) { rgb("#f2f6fb") },
  table.header([*Construction*], [*From*], [*Gives*]),
  [one-time pad], [uniform $k$], [perfect secrecy],
  [stream cipher], [PRG], [IND],
  [$r parallel F(k,r) xor m$], [PRF], [CPA],
  [CBC/OFB/CTR], [PRP], [CPA, fresh IV],
  [Feistel, 3/4 rounds], [PRF], [PRP, strong],
  [GGM tree], [PRG], [PRF],
  [$p(s) parallel h(s)$], [OWP $+$ HC], [PRG],
  [swap-or-not], [PRF], [PRP, any set],
  [CBC-MAC, ECBC], [PRF], [CMA],
  [encrypt-then-MAC], [CPA $+$ MAC], [AE $arrow.r$ CCA],
  [MD, Merkle tree], [fixed CRHF], [CRHF],
  [universal hash], [polynomial], [CRHF],
  [Davies–Meyer], [ideal cipher], [CRHF],
  [hash-and-MAC], [CRHF $+$ MAC], [MAC, long msg],
  [RSA, ElGamal], [RSA / DDH], [PKE],
  [TDP $+$ HC/RO], [TDP], [KA, KEM],
  [Merkle puzzles], [none], [KA, $Theta(N^2)$ gap],
)

#block(breakable: false, width: 100%)[
  #hd[12 · Implication map]
  #block(
    fill: rgb("#f3f6fa"),
    stroke: 0.4pt + rgb("#0b3d6b"),
    inset: 4pt,
    radius: 2pt,
    width: 100%,
    text(size: 7.4pt)[
      weak OWF $arrow.r$ OWF (Yao) $arrow.r$ OWF with a hardcore bit (GL);
      OWP + hardcore $arrow.r$ PRG (Cor 3.4) $arrow.r$ PRF (GGM) $arrow.r$ PRP (Feistel) $arrow.r$ block
      cipher and its modes; PRG with $n >= 2 ell$ $arrow.r$ OWF; CPA-secure $Pi$ $arrow.r$ OWF;
      CRHF $arrow.r$ OWF; random oracle $arrow.r$ PRG and CRHF; fixed-length CRHF $arrow.r$
      arbitrary-length CRHF (Merkle–Damgård, Merkle tree); CPA + CMA-unforgeable MAC $arrow.r$
      encrypt-then-MAC $arrow.r$ AE $arrow.r$ CCA; TDP + (random oracle or hardcore bit) $arrow.r$
      key agreement; DDH $arrow.r$ ElGamal, CDH $arrow.r$ key agreement; PKE $arrow.r$ key agreement;
      homomorphic encryption $arrow.r$ not CCA-secure.
    ],
  )
]











