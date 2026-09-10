#import "@preview/minimal-note:0.10.1": *

#show: minimal-note.with(
  title: [Commutative Algebra],
  author: [psoet],
  date: datetime.today().display("[month repr:long], [year]")
)

= Rings and Ideals

== Ideals, Quotient Rings

<1.1>
*Proposition 1.1.* Let $frak(a)$ be an ideal of $A$. The following is an one-to-one order-preserving correspondence between ideals $frak(b) supset.eq frak(a)$ of $A$ and ideals $overline(frak(b))$ of $A\/frak(a)$: $frak(b) <-> q^(-1) (overline(frak(b)))$. Here $q$ is the  surjective quotient map.

The homomorphism $f : A -> B$ induces an isomorphism $A\/ker(f) tilde.eq im(f)$.

== Zero-divisors, Nilpotent Elements, Units

A _zero-divisor_ in a ring $A$ is an element $x$ s.t. $exists y != 0, x y= 0 $. An _inetgral domain_ is a ring with no zero-divisor.

$x in A$ is _nilpotent_ if $x^n = 0$ for some $n > 0$. A _unit_ is an inversible element.

*Proposition 1.2* Let $A$ be a ring $!= 0$. TFAE:
1. $A$ is a field;
2. $A$ only has trivial ideals;
3. If $B$ is non-zero, $f : A -> B$ is a homomorphism, then $f$ is injective.

== Prime Ideals and Maximal Ideals

An ideal $frak(p)$ is _prime_ if $frak(p) != (1)$ and $x y in frak(p) => x in frak(p) or y in frak(p)$. An ideal $frak(m)$ is _maximal_ if there is no $frak(m) subset.neq frak(a) subset.neq (1)$. Equivalently, 

#align(center)[
  $frak(p)$ is prime $<=>$ $A\/frak(p)$ is an integral domain;

  $frak(m)$ is maximal $<=> A\/frak(m)$ is a field.
]

For a homomorphism $f : A -> B$, $f^(-1)$ always maps a prime ideal to a prime ideal, but it doesn't necessarily maps a maximal ideal to a maximal ideal. ($A = ZZ, B = QQ, f^(-1) ((0)).$)

*Theorem. 1.3* Every $A != 0$ has at least one maximal ideal. (Under AC)

#green-box([_Proof_.], [Ideals $!= (1)$ in $A$ froms a nonempty poset under $subset$. Every chain of ideals $frak(a)_1 subset frak(a)_2 subset dots.c$ is upper-bounded by $frak(a) = union.big frak(a)_k$. Take any maximal element by Zorn's lemma. $qed$])

*Corallary 1.4.* If $frak(a) != (1)$ is an ideal of $A$, then $exists$ a maximal ideal of $A$ that contains $frak(a)$.

<1.5>
*Corallary 1.5.* Every non-unit of $A$ is contained in a maximal ideal.

A ring with exactly one maximal ideal is called a _local ring_. A ring with finitely many maximal ideals is called _semi-local_.

*Proposition 1.6.* 
1. If $frak(m) != (1)$ is an ideal of $A$ s.t. every $x in A backslash frak(m)$ is a unit in $A$, then $A$ is a local ring and $frak(m)$ is its maximal ideal.
2. If $frak(m)$ is a maximal ideal of $A$ and $1 + frak(m) subset.eq A^times$, then $A$ is a local ring.

#green-box([_Proof_.], [1. Every ideal $!= (1)$ consists of non-units and is contained in $frak(m)$.
2. Let $x in A backslash frak(m)$. Since $frak(m)$ is maximal, $(x) + frak(m) = (1)$, so $exists t in A, y in frak(m), x t + y = 1$. So $x t = 1 - y in A^times$ and so is $x$. This implies the premise of 1., hence the conclusion. $qed$

Note that the premise of 1. also implies 2.])

#orange-box([Examples.], [1. If $f$ is irreducible in $k[x_1,x_2,dots.c,x_n]$, then $f$ is prime by unique factorization.
2. In $ZZ$, every non-zero prime ideal is maximal since $ZZ\/(p)$ is a field. The fact holds for every _principal ideal domain_.])

== Nilradical and Jacobson Radical

*Proposition 1.7.* The set $N(A)$ of all nilpotent elements in $A$ is an ideal, and $A\/N(A)$ has no nilpotent element $!= 0$. $N(A)$ is the _nilradical_ of $A$.

Equivalently,

*Proposition 1.8*. $N(A)$ is the intersection of all the prime ideals of $A$.

#green-box([_Proof_.],[If $x^n = 0$, the definition of prime ideals shows that $x in frak(p)$, for every prime ideal $frak(p)$.

On the other hand, suppose $x$ isn't nilpotent. Consider the set of ideals $frak(a)$ s.t. $x^n in.not frak(a), forall n$. The set is non-empty since $(0)$ is a member. By Zorn's lemma, this poset (under $subset$) has a maximal element $frak(p)$. Let $y,z in.not frak(p)$. Since $(y) + frak(p)$ and $(z) + frak(p)$ strictly contain $frak(p)$, they do not belong to the poset, hence 
$ x^m in (y) + frak(p), x^n in (z) + frak(p). $ Therefore $x^(m+n) in (y z) + frak(p)$ and $(y z) + frak(p)$ doesn't belong to the poset. Thus $y z in.not frak(p)$ and $frak(p)$ is prime. $qed$])
 
The _Jacobson radical_ $J(A)$ is the intersection of the maximal ideals of $A$. 

*Proposition 1.9.* $x in J(A) <=> 1 - x y in A^times, forall y in A$.

#green-box([_Proof_.], [
  $=>$: If $(1 - x y) != (1)$, then by #link(<1.5>, [(1.5)]) it is contained in some maximal $frak(m)$, which $x$ belongs to. This implies $1 in frak(m)$, contradiction.
  
  $arrow.double.l$: Suppose $x in.not frak(m)$ for some maximal $frak(m)$. We have $(x) + frak(m) = (1)$ hence $u + x y = 1$ for some $u in frak(m)$ and $y in A$. Hence $1 - x y in frak(m)$ and therefore is not a unit. $qed$
])

== Operations on Ideals

Those include $frak(a) + frak(b) = {x + y | x in frak(a), y in frak(b)}$, $frak(a) frak(b) = (x y) (x in frak(a), y in frak(b))$, $frak(a) inter frak(b)$. The intersection can be defined on any family of ideals.

The 3 operations are commutative and associative. We also have the _distributive law_
$ frak(a) (frak(b) + frak(c)) = frak(a) frak(b) + frak(a) frak(c). $

$inter$ and $plus$ are distributive in $ZZ$ but it it is not the case in general. The _modular law_ states
$ frak(b) subset.eq frak(a) or frak(c) subset.eq frak(a) => frak(a) inter (frak(b) + frak(c)) = frak(a) inter frak(b) + frak(a) inter frak(c). $
In general, we only have $supset.eq$. (Take $A = F[x,y]$, let $frak(a) = (x)$, $frak(b) = (y)$, $frak(c) = (x+y)$.)

In $ZZ$, we also have $(frak(a) + frak(b))(frak(a) inter frak(b)) = frak(a) frak(b)$, but in general only $L H S subset.eq R H S$. $frak(a) frak(b) subset.eq frak(a) inter frak(b)$, so when $frak(a) + frak(b) = (1)$, $frak(a) inter frak(b) = frak(a) frak(b)$.

$frak(a),frak(b)$ are said to be _coprime_ if $frak(a) + frak(b) = (1)$.

The _direct product_ of rings are defined with componentwise operations. The projections are surjective ring homomorphisms.

Let $frak(a)_([n])$ be ideals of $A$. Define a homomorphism
$ phi.alt : A -> product_(i=1)^n (A\/frak(a)_i) $
by $phi.alt(x) = (x+frak(a)_1, x+frak(a)_2, dots.c, x+frak(a)_n)$.

*Proposition 1.10.* 
1. If $frak(a)_i perp frak(a)_j (forall i < j)$, then $product frak(a)_i = inter.big frak(a)_i$.
2. $phi.alt$ surjective $<=>$ $forall i < j, frak(a)_i perp frak(a)_j$.
3. $phi.alt$ injective $<=> inter.big frak(a)_i = (0)$.

#green-box([_Proof_.], [
  1. Induction on $n$. $n = 2$ is dealt with. For $n > 2$, suppose the result is true for $n-1$, let $frak(b) = product_(i <= n-1) frak(a)_i = inter.big_(i <= n-1) frak(a)_i$. Suppose $x_i + y_i = 1 (x_i in frak(a)_i, y_i in frak(a)_n, 1<=i<=n-1).$ Then 
  $ product_(i<=n-1) x_i = product_(i<=n-1) (1-y_i) equiv 1(mod frak(a)_n). $
  Hence $frak(a)_n + frak(b) = 1$, so the conclusion holds.
  2. 
    $=>$: To show $frak(a)_1 + frak(a)_2 = 1$, take $x in A$ s.t. $phi.alt(x) = (1,0,dots.c,0)$, then $1 = (1-x) + x in frak(a)_1 + frak(a)_2$.
    
    $arrow.double.l$: Use something similar to the proof of CRT.
  3. Trivial by definition. $qed$
])

*Proposition 1.11.*
1. Let $frak(p)_([n])$ be prime ideals, $frak(a) subset.eq union.big frak(p)_i$. Then $exists i, frak(a) subset.eq frak(p)_i$.
2. Let $frak(p) supset.eq inter.big frak(a)_i$. Then $exists i, frak(p) supset.eq frak(a)_i$. Moreover, if $frak(p) = inter.big frak(a)_i$, then $exists i, frak(p) = frak(a)_i$.

#green-box([_Proof_.], [
  1. Induction on $n$. Assume for every $frak(a)$ and $frak(p)$, $ frak(a) subset.eq.not frak(p)_i (1 <= i <= n-1) => frak(a) subset.eq.not union.big_(i=1)^(n-1) frak(p)_i. $
    This is true for trivial case. If $n>1$, then $forall i$, $exists x_i in frak(a)$ s.t. $forall j != i, x_i in.not frak(p)_j$. If $exists i, x_i in.not frak(p)_i$ then we are done. Otherwise, 
    $ y = sum_(i=1)^n product_(j != i) x_j in frak(a) backslash union.big_(i=1)^n frak(p)_i. $

  2. Suppose $x_i in frak(a)_i backslash frak(p)$. Then $product x_i in product frak(a)_i subset.eq inter.big frak(a)_i$. Since $frak(p)$ is prime, $product x_i in.not frak(p)$. Hence $frak(p) supset.eq.not inter.big frak(a)_i$. The corollary is trivial. $qed$
])

The _ideal quotient_ of $frak(a),frak(b)$ is 
$ (frak(a):frak(b)) = {x in A : x frak(b) subset.eq frak(a)} $ which is an ideal.

$(0:frak(b))$ is called the _annihilator_ of $frak(b)$ or $op("Ann")(frak(b))$. The zero-divisors in $A$ is the union of all annihilators of non-zero elements.

*Exercise 1.12.* 
1. $(frak(a):frak(b)) frak(b) subset.eq frak(a) subset.eq (frak(a) : frak(b))$.
2. $((frak(a):frak(b)):frak(c)) = (frak(a):frak(b) frak(c)) = ((frak(a):frak(c)):frak(b))$.
3. $(inter.big_i frak(a)_i : frak(b)) = inter.big_i (frak(a)_i : frak(b)).$
4. $(frak(a):sum_i frak(b)_i) = inter.big_i (frak(a) : frak(b)_i)$.

The _radical_ of an ideal $frak(a)$ is $ sqrt(frak(a)) = {x in A : x^n in frak(a) "for some" n>0}. $

We have $sqrt(frak(a)) = q^(-1) (N(A\/frak(a)))$ where $q : A arrow.r.twohead A\/frak(a)$ is the quotient map, hence the radical is always an ideal.

*Exercise 1.13.* 
1. $sqrt(frak(a)) supset.eq frak(a)$. 
2. $sqrt(sqrt(frak(a))) = sqrt(frak(a))$.
3. $sqrt(frak(a) frak(b)) = sqrt(frak(a) inter frak(b)) = sqrt(frak(a)) inter sqrt(frak(b))$.
4. $sqrt(frak(a)) = (1) <=> frak(a) = 1$.
5. $sqrt(frak(a) + frak(b)) = sqrt(sqrt(frak(a)) + sqrt(frak(b)))$.
6. $frak(p)$ is prime implies $sqrt(frak(p)^n) = frak(p), forall n > 0$.

*Proposition 1.14.* $sqrt(frak(a))$ is the intersection of $frak(p) supset.eq frak(a)$.

We can define radical on any subset $E$, but $sqrt(E)$ is not necessarily an ideal.

*Proposition 1.15.* Let $D$ be the zero-divisors of $A$. Then $D = sqrt(D) = sqrt(union.big_(x!=0) op("Ann")(x)) = union.big_(x != 0) sqrt(op("Ann")(x))$.

*Proposition 1.16.* $sqrt(frak(a)) perp sqrt(frak(b)) <=> frak(a) perp frak(b).$

== Extension and Contraction

Fix a homomorphism $f : A -> B$. If $frak(a)$ is an ideal of $A$, then $f(A)$ is not always an ideal. (Consider $A = ZZ, B = QQ$.) Define the _extension_ $frak(a)^e = (f(frak(a)))$ which is an ideal of $B$.  If $frak(b)$ is an ideal of $B$, then $f^(-1) (frak(b))$ is always an ideal of $A$, called the _contraction_ $frak(b)^c$ of $frak(b)$.

Contraction of a prime ideal is always prime. This doesn't hold for extensions.

$f$ can be factored as follows:

$ A arrow.twohead^(i) f(A) arrow.hook^j B. $

From #link(<1.1>, [(1.1)]), $i$ is simple: ideals of $f(A)$ $<->^(1:1)$ ideals of $A supset.eq ker(f)$. However, $j$ is in general complicated.

#orange-box([Example.], [Consider $ZZ -> ZZ[i]$. $ZZ[i]$ is a principal domain. Consider prime ideal $(p)$ of $ZZ$.
1. $(2)^e = ((1+i)^2)$ which is the square of a prime ideal.
2. $p equiv 1 (mod 4) => (p)^e$ is the product of two distinct prime ideals.
3. $p equiv 3 (mod 4) => (p)^e$ is prime in $ZZ[i]$.
Here 2. is a non-trivial result and is equivalent to _Fermat's square theorem_.])

*Proposition 1.17.* 
1. $frak(a) subset.eq frak(a)^(e c)$, $frak(b) supset.eq frak(b)^(c e)$.
2. $frak(a)^e =  frak(a)^(e c e)$, $frak(b)^c = frak(b)^(c e c)$.
3. Let $C$ be the image of $ast^c$ and $E$ be the image of $*^e$. Then $C = {frak(a) | frak(a)^(e c) = frak(a)}$, $E = {frak(b) | frak(b)^(c e) = frak(b)}$, and $frak(a) mapsto frak(a)^e$, $frak(b)^c mapsfrom frak(b)$ gives a bijection $C <->^(1:1) E$.

*Exercise 1.18.*
1. $(frak(a)_1 + frak(a_2))^e = frak(a)_1^e + frak(a)_2^e$, $(frak(b)_1 + frak(b)_2)^c supset.eq frak(b)_1^c + frak(b)_2^c$.
2. $(frak(a)_1 inter frak(a_2))^e subset.eq frak(a)_1^e inter frak(a)_2^e$, $(frak(b)_1 inter frak(b)_2)^c = frak(b)_1^c inter frak(b)_2^c$.
3. $(frak(a)_1 frak(a_2))^e = frak(a)_1^e + frak(a)_2^e$, $(frak(b)_1 frak(b)_2)^c supset.eq frak(b)_1^c + frak(b)_2^c$.
4. $(frak(a)_1 : frak(a_2))^e subset.eq (frak(a)_1^e : frak(a)_2^e)$, $(frak(b)_1 : frak(b)_2)^c subset.eq (frak(b)_1^c : frak(b)_2^c)$.
5. $sqrt(frak(a))^e subset.eq sqrt(frak(a)^e)$, $sqrt(frak(b))^c = sqrt(frak(b)^c)$.

== The Prime Spectrum of a Ring

#let Spec = math.op("Spec")

Let $X$ be the set of prime ideals in $A$. $forall E subset.eq A$, let $V(E) = {frak(p) in X : E subset.eq frak(p)}$. We have the following properties:
1. Let $frak(a) = (E)$. Then $V(E) = V(frak(a)) = V(sqrt(frak(a)))$.
2. $V(0) = X, V(1) = emptyset$.
3. $V(union.big_(i in I) E_i) = inter.big_(i in I) V(E_i)$.
4. $forall frak(a), frak(b)$ of $A$, $V(frak(a) inter frak(b)) = V(frak(a) frak(b)) = V(frak(a)) union V(frak(b))$.

Thus the family of sets ${V(E)}$ forms the closed sets of a topology, which we refer to as the _Zariski topology_. $X$ is called the _prime spectrum_ of $A$ or $Spec(A)$.

#orange-box([Examples.], [
  1. $Spec(ZZ) = {0, (p)}$ and $V(dot)$ consists of the finite non-zero subsets of $Spec(ZZ)$ and the entire $Spec(ZZ)$.
  2. $Spec(F) = {0, F}$.
  3. $Spec(CC[x]) = {0,(x - alpha)_(alpha in CC)}$, $V(dot)$ is similar to 1.
  4. $Spec(RR[x]) = {0, (x - alpha)_(alpha in RR), (x^2 + b x + c)_(Delta < 0)}$.
  5. $Spec(ZZ[x]) = {0, (p), (p,g(x)), (f(x))}$ where $f$ is a primitive irreducible polynomial, $g$ is irreducible in $FF_p [x]$ (this is beyond the scope of this chapter).
])

Define $X_f = (V(f))^complement in Spec(A)$ where $f in A$. Then $X_f$ is an open set. We have $(X_f)$ forms a basis of open sets for the Zariski topology, and
1. $X_f inter X_g = X_(f g)$.
2. $X_f = emptyset <=> f$ is nilpotent.
3. $X_f = X <=> f in A^times$.
4. $X_f = X_g <=> sqrt((f)) = sqrt((g))$.
5. $X$ is quasi-compact (every open covering of $X$ has a finite sub-covering). 
6. More generally, an open subset of $X$ is quasi-compact iff it is a finite union of sets $X_f$.

// See https://typst.app/docs/reference/model/bibliography/ for more on styling your bibliography
#bibliography("refs.bib", style: "institute-of-electrical-and-electronics-engineers")