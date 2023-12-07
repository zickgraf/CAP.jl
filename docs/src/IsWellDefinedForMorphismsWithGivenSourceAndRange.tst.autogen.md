
```jldoctest
julia> using MonoidalCategories; using CAP

julia> true
true

julia> T = TerminalCategoryWithMultipleObjects( )
TerminalCategoryWithMultipleObjects( )

julia> a = "a" / T;

julia> b = "b" / T;

julia> alpha = ZeroMorphism( a, b );

julia> IsWellDefinedForMorphisms( alpha )
true

julia> IsWellDefinedForMorphismsWithGivenSourceAndRange( a, alpha, b )
true

julia> IsWellDefinedForMorphismsWithGivenSourceAndRange( b, alpha, a )
false

julia> op = Opposite( T );

julia> a_op = a / op;

julia> b_op = b / op;

julia> alpha_op = Opposite( alpha );

julia> IsWellDefinedForMorphisms( alpha_op )
true

julia> IsWellDefinedForMorphismsWithGivenSourceAndRange( a_op, alpha_op, b_op )
false

julia> IsWellDefinedForMorphismsWithGivenSourceAndRange( b_op, alpha_op, a_op )
true

```
