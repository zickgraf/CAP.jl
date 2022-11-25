# SPDX-License-Identifier: GPL-2.0-or-later
# CAP: Categories, Algorithms, Programming
#
# Implementations
#

@BindGlobal( "init_CAP", function ( )
    
    ##
    @InstallValue( CAP_INTERNAL,
                    rec(
                        name_counter = 0,
                        default_cache_type = "weak",
                        operation_names_with_cache_disabled_by_default = [
                            # the following operations are needed for comparison in caches
                            "IsEqualForObjects",
                            "IsEqualForMorphisms",
                            "IsEqualForMorphismsOnMor",
                            "IsEqualForCacheForObjects",
                            "IsEqualForCacheForMorphisms",
                            # it is unclear how `IsEqualForCacheForObjects` && `IsEqualForCacheForMorphisms`
                            # would behave on non-well-defined objects/morphisms, so exclude `IsWellDefined*`
                            "IsWellDefinedForObjects",
                            "IsWellDefinedForMorphisms",
                            "IsWellDefinedForTwoCells",
                            # do !cache operations returning random data
                            "RandomObjectByInteger",
                            "RandomMorphismByInteger",
                            "RandomMorphismWithFixedSourceByInteger",
                            "RandomMorphismWithFixedRangeByInteger",
                            "RandomMorphismWithFixedSourceAndRangeByInteger",
                            "RandomObjectByList",
                            "RandomMorphismByList",
                            "RandomMorphismWithFixedSourceByList",
                            "RandomMorphismWithFixedRangeByList",
                            "RandomMorphismWithFixedSourceAndRangeByList",
                            # by default, do !cache constructors && object/morphism data
                            # because ⥉ general these operations are cheap,
                            # so caching would !improve the performance
                            "ObjectConstructor",
                            "ObjectDatum",
                            "MorphismConstructor",
                            "MorphismDatum",
                        ],
                  )
    );
    
    #= comment for Julia
    @BindGlobal( "CapCat", CAP_INTERNAL_CREATE_Cat( ) );
    # =#
    
end );

#= comment for Julia
init_CAP( );
# =#
