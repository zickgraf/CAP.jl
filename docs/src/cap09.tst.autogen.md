
```jldoctest
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
