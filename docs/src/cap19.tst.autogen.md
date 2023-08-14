
```jldoctest
julia> using MonoidalCategories; using CAP

julia> true
true

julia> T = TerminalCategoryWithMultipleObjects( )
TerminalCategoryWithMultipleObjects( )

julia> Display( T )
A CAP category with name TerminalCategoryWithMultipleObjects( ):

65 primitive operations were used to derive 306 operations for this category which algorithmically
* IsCategoryWithDecidableColifts
* IsCategoryWithDecidableLifts
* IsEquippedWithHomomorphismStructure
* IsLinearCategoryOverCommutativeRing
* IsAbelianCategoryWithEnoughInjectives
* IsAbelianCategoryWithEnoughProjectives
* IsRigidSymmetricClosedMonoidalCategory
* IsRigidSymmetricCoclosedMonoidalCategory
and furthermore mathematically
* IsLocallyOfFiniteInjectiveDimension
* IsLocallyOfFiniteProjectiveDimension
* IsTerminalCategory

julia> i = InitialObject( T )
<An object in TerminalCategoryWithMultipleObjects( )>

julia> t = TerminalObject( T )
<An object in TerminalCategoryWithMultipleObjects( )>

julia> z = ZeroObject( T )
<An object in TerminalCategoryWithMultipleObjects( )>

julia> Display( i )
ZeroObject

julia> Display( t )
ZeroObject

julia> Display( z )
ZeroObject

julia> IsIdenticalObj( i, z )
true

julia> IsIdenticalObj( t, z )
true

julia> id_z = IdentityMorphism( z )
<A morphism in TerminalCategoryWithMultipleObjects( )>

julia> fn_z = ZeroObjectFunctorial( T )
<A morphism in TerminalCategoryWithMultipleObjects( )>

julia> IsEqualForMorphisms( id_z, fn_z )
false

julia> IsCongruentForMorphisms( id_z, fn_z )
true

julia> a = "a" / T
<An object in TerminalCategoryWithMultipleObjects( )>

julia> Display( a )
a

julia> IsWellDefined( a )
true

julia> aa = ObjectConstructor( T, "a" )
<An object in TerminalCategoryWithMultipleObjects( )>

julia> Display( aa )
a

julia> IsEqualForObjects( a, aa )
true

julia> IsIsomorphicForObjects( a, aa )
true

julia> IsIsomorphism( SomeIsomorphismBetweenObjects( a, aa ) )
true

julia> b = "b" / T
<An object in TerminalCategoryWithMultipleObjects( )>

julia> Display( b )
b

julia> IsEqualForObjects( a, b )
false

julia> IsIsomorphicForObjects( a, b )
true

julia> IsIsomorphism( SomeIsomorphismBetweenObjects( a, b ) )
true

julia> t = TensorProduct( a, b )
<An object in TerminalCategoryWithMultipleObjects( )>

julia> Display( t )
TensorProductOnObjects

julia> a == t
false

julia> TensorProduct( a, a ) == t
true

julia> m = MorphismConstructor( a, "m", b )
<A morphism in TerminalCategoryWithMultipleObjects( )>

julia> Display( m )
a
|
| m
v
b

julia> IsWellDefined( m )
true

julia> n = MorphismConstructor( a, "n", b )
<A morphism in TerminalCategoryWithMultipleObjects( )>

julia> Display( n )
a
|
| n
v
b

julia> IsEqualForMorphisms( m, n )
false

julia> IsCongruentForMorphisms( m, n )
true

julia> m == n
true

julia> id = IdentityMorphism( a )
<A morphism in TerminalCategoryWithMultipleObjects( )>

julia> Display( id )
a
|
| IdentityMorphism
v
a

julia> m == id
false

julia> id == MorphismConstructor( a, "xyz", a )
true

julia> zero = ZeroMorphism( a, a )
<A morphism in TerminalCategoryWithMultipleObjects( )>

julia> Display( zero )
a
|
| ZeroMorphism
v
a

julia> id == zero
true

julia> IsLiftable( m, n )
true

julia> lift = Lift( m, n )
<A morphism in TerminalCategoryWithMultipleObjects( )>

julia> Display( lift )
a
|
| Lift
v
a

julia> IsColiftable( m, n )
true

julia> colift = Colift( m, n )
<A morphism in TerminalCategoryWithMultipleObjects( )>

julia> Display( colift )
b
|
| Colift
v
b

julia> DirectProduct( T, [ ] )
<An object in TerminalCategoryWithMultipleObjects( )>

julia> Equalizer( T, z, [ ] )
<An object in TerminalCategoryWithMultipleObjects( )>

julia> Coproduct( T, [ ] )
<An object in TerminalCategoryWithMultipleObjects( )>

julia> Coequalizer( T, z, [ ] )
<An object in TerminalCategoryWithMultipleObjects( )>

```
