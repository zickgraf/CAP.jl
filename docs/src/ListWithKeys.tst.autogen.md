
```jldoctest
julia> using CAP

julia> true
true

julia> ListWithKeys( [ 9, 8, 7 ], ( key, value ) -> [ key, value ] ) == [ [ 1, 9 ], [ 2, 8 ], [ 3, 7 ] ]
true

julia> SumWithKeys( [ ], ( key, value ) -> key + value )
0

julia> SumWithKeys( [ 9, 8, 7 ], ( key, value ) -> key + value )
30

julia> ProductWithKeys( [ ], ( key, value ) -> key * value )
1

julia> ProductWithKeys( [ 9, 8, 7 ], ( key, value ) -> key * value )
3024

julia> ForAllWithKeys( [ 9, 8, 7 ], ( key, value ) -> [ 9, 8, 7 ][key] == value )
true

julia> ForAllWithKeys( [ 9, 8, 7 ], ( key, value ) -> key == 1 || value == 8 )
false

julia> ForAnyWithKeys( [ 9, 8, 7 ], ( key, value ) -> [ 9, 8, 7 ][key] != value )
false

julia> ForAnyWithKeys( [ 9, 8, 7 ], ( key, value ) -> key == 3 && value == 7 )
true

julia> NumberWithKeys( [ 9, 8, 7 ], ( key, value ) -> key == 1 || value == 8 )
2

julia> FilteredWithKeys( [ 9, 8, 7 ], ( key, value ) -> key == 1 || value == 8 ) == [ 9, 8 ]
true

julia> FirstWithKeys( [ 9, 8, 7 ], ( key, value ) -> key == 1 && value == 7 )
fail

julia> FirstWithKeys( [ 9, 8, 7 ], ( key, value ) -> key == 3 && value == 7 )
7

julia> LastWithKeys( [ 9, 8, 7 ], ( key, value ) -> key == 3 && value == 9 )
fail

julia> LastWithKeys( [ 9, 8, 7 ], ( key, value ) -> key == 1 && value == 9 )
9

```
