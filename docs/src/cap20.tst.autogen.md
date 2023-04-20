
```jldoctest
julia> using MonoidalCategories; using CAP

julia> true
true

julia> T = TerminalCategoryWithSingleObject( )
TerminalCategoryWithSingleObject( )

julia> Display( T )
A CAP category with name TerminalCategoryWithSingleObject( ):

63 primitive operations were used to derive 304 operations for this category which algorithmically
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

```
