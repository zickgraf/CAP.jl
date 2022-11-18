# ProjectionInFactorOfDirectSum
function ( cat, L, projection_number )
    Let morphisms be
        `List( (1):(Length( list )), function( i )
            
            if i == projection_number
                
                return IdentityMorphism( cat, list[projection_number] );
                
            else
                
                return ZeroMorphism( cat, list[i], list[projection_number] );
                
            end;
            
        end )`.
    Return the morphism from the direct sum of L to `list[projection_number]` with components morphisms.
end

# UniversalMorphismIntoFiberProduct
function( cat, diagram, test_object, source )
    Let τ be the morphism from test_object to the direct sum of `List( source, Range )` with components source.
    Let Δ be `DirectSumDiagonalDifference( cat, diagram )`.
    Let λ be the morphism such that λ * KernelEmbedding( Δ ) == τ.
    Return λ * `IsomorphismFromKernelOfDiagonalDifferenceToFiberProduct( cat, diagram )`.
end
