
```jldoctest AutoDocTests
julia> using MonoidalCategories; using CAP

julia> true
true

julia> list_of_operations_to_install = [
            "ObjectConstructor",
            "MorphismConstructor",
            "ObjectDatum",
            "MorphismDatum",
            "IsCongruentForMorphisms",
            "PreCompose",
            "IdentityMorphism",
            "DirectSum",
        ];

julia> dummy = DummyCategory( @rec(
            list_of_operations_to_install = list_of_operations_to_install,
            properties = [ "IsAdditiveCategory" ],
        ) );

julia> ForAll( list_of_operations_to_install, o -> CanCompute( dummy, o ) )
true

julia> IsAdditiveCategory( dummy )
true

```

```jldoctest AutoDocTests
julia> using MonoidalCategories; using CAP

julia> true
true

julia> dummy1 = CreateCapCategory( );

julia> dummy2 = CreateCapCategory( );

julia> dummy3 = CreateCapCategory( );

julia> PrintAndReturn = function ( string )
            Print( string, "\n" ); return string; end;

julia> dummy1.compiler_hints = @rec( );

julia> dummy1.compiler_hints.precompiled_towers = [
          @rec(
            remaining_constructors_in_tower = [ "Constructor1" ],
            precompiled_functions_adder = cat ->
              PrintAndReturn( "Adding precompiled operations for Constructor1" ),
          ),
          @rec(
            remaining_constructors_in_tower = [ "Constructor1", "Constructor2" ],
            precompiled_functions_adder = cat ->
              PrintAndReturn( "Adding precompiled operations for Constructor2" ),
          ),
        ];

julia> HandlePrecompiledTowers( dummy2, dummy1, "Constructor1" )
Adding precompiled operations for Constructor1

julia> HandlePrecompiledTowers( dummy3, dummy2, "Constructor2" )
Adding precompiled operations for Constructor2

```

```jldoctest AutoDocTests
julia> using MonoidalCategories; using CAP

julia> true
true

julia> T = TerminalCategoryWithMultipleObjects( )
TerminalCategoryWithMultipleObjects( )

julia> Display( T )
A CAP category with name TerminalCategoryWithMultipleObjects( ):

82 primitive operations were used to derive 383 operations for this category which algorithmically
* IsCategoryWithDecidableColifts
* IsCategoryWithDecidableLifts
* IsEquippedWithHomomorphismStructure
* IsLinearCategoryOverCommutativeRing
* IsLeftClosedMonoidalCategory
* IsLeftCoclosedMonoidalCategory
* IsAbelianCategoryWithEnoughInjectives
* IsAbelianCategoryWithEnoughProjectives
* IsRigidSymmetricClosedMonoidalCategory
* IsRigidSymmetricCoclosedMonoidalCategory
and not yet algorithmically
* IsLinearCategoryOverCommutativeRingWithFinitelyGeneratedFreeExternalHoms
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

julia> mor_ab = SomeIsomorphismBetweenObjects( a, b )
<A morphism in TerminalCategoryWithMultipleObjects( )>

julia> IsIsomorphism( mor_ab )
true

julia> Display( mor_ab )
a
|
| SomeIsomorphismBetweenObjects
v
b

julia> Hom_ab = MorphismsOfExternalHom( a, b );

julia> Length( Hom_ab )
1

julia> Hom_ab[1]
<A morphism in TerminalCategoryWithMultipleObjects( )>

julia> Display( Hom_ab[1] )
a
|
| InterpretMorphismFromDistinguishedObjectToHomomorphismStructureAsMorphism
v
b

julia> Hom_ab[1] == mor_ab
true

julia> HomStructure( mor_ab )
<A morphism in TerminalCategoryWithSingleObject( )>

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

julia> hom_mn = HomStructure( m, n )
<A morphism in TerminalCategoryWithSingleObject( )>

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

```jldoctest AutoDocTests
julia> using MonoidalCategories; using CAP

julia> true
true

julia> T = TerminalCategoryWithSingleObject( )
TerminalCategoryWithSingleObject( )

julia> Display( T )
A CAP category with name TerminalCategoryWithSingleObject( ):

76 primitive operations were used to derive 383 operations for this category which algorithmically
* IsCategoryWithDecidableColifts
* IsCategoryWithDecidableLifts
* IsEquippedWithHomomorphismStructure
* IsLinearCategoryOverCommutativeRing
* IsLeftClosedMonoidalCategory
* IsLeftCoclosedMonoidalCategory
* IsAbelianCategoryWithEnoughInjectives
* IsAbelianCategoryWithEnoughProjectives
* IsRigidSymmetricClosedMonoidalCategory
* IsRigidSymmetricCoclosedMonoidalCategory
and not yet algorithmically
* IsLinearCategoryOverCommutativeRingWithFinitelyGeneratedFreeExternalHoms
and furthermore mathematically
* IsLocallyOfFiniteInjectiveDimension
* IsLocallyOfFiniteProjectiveDimension
* IsSkeletalCategory
* IsStrictMonoidalCategory
* IsTerminalCategory

julia> i = InitialObject( T )
<An object in TerminalCategoryWithSingleObject( )>

julia> t = TerminalObject( T )
<An object in TerminalCategoryWithSingleObject( )>

julia> z = ZeroObject( T )
<An object in TerminalCategoryWithSingleObject( )>

julia> Display( i )
An object in TerminalCategoryWithSingleObject( ).

julia> Display( t )
An object in TerminalCategoryWithSingleObject( ).

julia> Display( z )
An object in TerminalCategoryWithSingleObject( ).

julia> IsIdenticalObj( i, z )
true

julia> IsIdenticalObj( t, z )
true

julia> IsWellDefined( z )
true

julia> id_z = IdentityMorphism( z )
<A morphism in TerminalCategoryWithSingleObject( )>

julia> fn_z = ZeroObjectFunctorial( T )
<A morphism in TerminalCategoryWithSingleObject( )>

julia> IsWellDefined( fn_z )
true

julia> IsEqualForMorphisms( id_z, fn_z )
true

julia> IsCongruentForMorphisms( id_z, fn_z )
true

julia> IsLiftable( id_z, fn_z )
true

julia> Lift( id_z, fn_z )
<A morphism in TerminalCategoryWithSingleObject( )>

julia> IsColiftable( id_z, fn_z )
true

julia> Colift( id_z, fn_z )
<A morphism in TerminalCategoryWithSingleObject( )>

julia> DirectProduct( T, [ ] )
<An object in TerminalCategoryWithSingleObject( )>

julia> Equalizer( T, z, [ ] )
<An object in TerminalCategoryWithSingleObject( )>

julia> Coproduct( T, [ ] )
<An object in TerminalCategoryWithSingleObject( )>

julia> Coequalizer( T, z, [ ] )
<An object in TerminalCategoryWithSingleObject( )>

```
