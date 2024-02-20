# SPDX-License-Identifier: GPL-2.0-or-later
# CAP: Categories, Algorithms, Programming
#
# Implementations
#

######################################
##
## Reps, types, stuff.
##
######################################

# backwards compatibility
@BindGlobal( "IsCapCategoryMorphismRep", IsCapCategoryMorphism );

######################################
##
## Properties logic
##
######################################
# 
# InstallTrueMethod( IsSplitMonomorphism and IsSplitEpimorphism, IsCapCategoryMorphism and IsIsomorphism );
# 
# InstallTrueMethod( IsAutomorphism, IsCapCategoryMorphism and IsOne );
# 
# InstallTrueMethod( IsIsomorphism and IsEndomorphism, IsCapCategoryMorphism and IsAutomorphism );
# 
# InstallTrueMethod( IsMonomorphism, IsCapCategoryMorphism and IsSplitMonomorphism );
# 
# InstallTrueMethod( IsEpimorphism, IsCapCategoryMorphism and IsSplitEpimorphism );
# 
# InstallTrueMethod( IsIsomorphism, IsMonomorphism and IsEpimorphism and IsAbelianCategory );#TODO: weaker?

#######################################
##
## Technical implications
##
#######################################

@InstallValueConst( PROPAGATION_LIST_FOR_EQUAL_MORPHISMS,
              [  
                 "IsMonomorphism",
                 "IsEpimorphism",
                 "IsIsomorphism",
                 "IsEndomorphism",
                 "IsAutomorphism",
                 "IsSplitMonomorphism",
                 "IsSplitEpimorphism",
                 "IsOne",
                 "IsIdempotent",
                 "IsZero",
                 # ..
              ] );

######################################
##
## Operations
##
######################################

@InstallMethod( Target,
               [ IsCapCategoryMorphism ],
               
  Range );

@InstallMethod( Add,
               [ IsCapCategory, IsCapCategoryMorphism ],
               
  function( category, morphism )
    local filter;
    
    filter = MorphismFilter( category );
    
    if (@not filter( morphism ))
        
        SetFilterObj( morphism, filter );
        
    end;
    
    AddObject( category, Source( morphism ) );
    
    AddObject( category, Range( morphism ) );
    
    if (category.predicate_logic)
        
        INSTALL_TODO_FOR_LOGICAL_THEOREMS( "Source", [ morphism ], Source( morphism ), category );
        
        INSTALL_TODO_FOR_LOGICAL_THEOREMS( "Range", [ morphism ], Range( morphism ), category );
      
    end;
    
    if (HasCapCategory( morphism ))
        
        if (IsIdenticalObj( CapCategory( morphism ), category ))
            
            return;
            
        else
            
            Error(
                @Concatenation(
                    "a morphism that lies in the CAP-category with the name\n",
                    Name( CapCategory( morphism ) ),
                    "\n",
                    "was tried to be added to a different CAP-category with the name\n",
                    Name( category ), ".\n",
                    "(Please note that it is possible for different CAP-categories to have the same name)"
                )
            );
            
        end;
        
    end;
    
    SetCapCategory( morphism, category );
    
end );

@InstallMethod( AddMorphism,
               [ IsCapCategory, IsCapCategoryMorphism ],
               
  function( category, morphism )
    
    Add( category, morphism );
    
end );

@InstallMethod( AddMorphism,
               [ IsCapCategory, IsAttributeStoringRep ],
               
  function( category, morphism )
    
    SetFilterObj( morphism, IsCapCategoryMorphism );
    
    Add( category, morphism );
    
end );

##
@InstallMethod( IsZero,
               [ IsCapCategoryMorphism ],
                  
IsZeroForMorphisms );

##
@InstallMethod( +,
               [ IsCapCategoryMorphism, IsCapCategoryMorphism ],
               
AdditionForMorphisms );

##
@InstallMethod( -,
               [ IsCapCategoryMorphism, IsCapCategoryMorphism ],
               
SubtractionForMorphisms );

##
@InstallMethod( AdditiveInverse,
                  [ IsCapCategoryMorphism ],
                  
AdditiveInverseForMorphisms );

CAP_INTERNAL_ADD_REPLACEMENTS_FOR_METHOD_RECORD(
  @rec(
    AdditiveInverse = [ [ "AdditiveInverseForMorphisms", 1 ] ],
    AdditiveInverseImmutable = [ [ "AdditiveInverseForMorphisms", 1 ] ],
  )
 );

##
@InstallMethod( Inverse,
                  [ IsCapCategoryMorphism ],
                  
InverseForMorphisms );

CAP_INTERNAL_ADD_REPLACEMENTS_FOR_METHOD_RECORD(
  @rec(
    Inverse = [ [ "InverseForMorphisms", 1 ] ],
    InverseImmutable = [ [ "InverseForMorphisms", 1 ] ],
  )
 );

##
@InstallMethod( *,
               [ IsRingElement, IsCapCategoryMorphism ],
               
MultiplyWithElementOfCommutativeRingForMorphisms );

##
@InstallMethod( *,
               [ IsCapCategoryMorphism, IsRingElement ],
               
  function( mor, r )
    
    return MultiplyWithElementOfCommutativeRingForMorphisms( r, mor );
    
end );

##
@InstallMethod( *,
               [ IsRat, IsCapCategoryMorphism ],
               
function( q, mor )
    local cat, ring, r;
    
    cat = CapCategory( mor );
    
    ring = CommutativeRingOfLinearCategory( cat );
    
    if (IsIdenticalObj( ring, Integers ) || IsIdenticalObj( ring, Rationals ))
        
        r = q;
        
    else
        
        if (@IsBound( ring.interpret_rationals_func ))
            
            r = ring.interpret_rationals_func( q );
            
            if (r == fail)
                
                Error( "cannot interpret ", StringGAP( q ), " as an element of the commutative ring of ", Name( cat ) );
                
            end;
            
        else
            
            Error( "The commutative ring of ", Name( cat ), "doesn't know how to interpret rationals" );
            
        end;
        
    end;
    
    return MultiplyWithElementOfCommutativeRingForMorphisms( r, mor );
    
end );

##
@InstallMethod( IsEqualForCache,
               [ IsCapCategoryMorphism, IsCapCategoryMorphism ],
               
  ( mor1, mor2 ) -> IsEqualForCacheForMorphisms( CapCategory( mor1 ), mor1, mor2 ) );

##
# generic fallback to IsIdenticalObj
@InstallMethod( IsEqualForCacheForMorphisms,
               [ IsCapCategory, IsCapCategoryMorphism, IsCapCategoryMorphism ],
               
  ( cat, mor1, mor2 ) -> IsIdenticalObj( mor1, mor2 ) );

##
@InstallMethod( AddMorphismRepresentation,
               [ IsCapCategory, IsObject ],
               
  function( category, representation )
    
    Print( "WARNING: AddMorphismRepresentation is deprecated and will not be supported after 2024.08.21. Please use CreateCapCategory with four arguments instead.\n" );
    
    if (@not IsSpecializationOfFilter( IsCapCategoryMorphism, representation ))
        
        Error( "the morphism representation must imply IsCapCategoryMorphism" );
        
    end;
    
    if (@IsBound( category.initially_known_categorical_properties ))
        
        Error( "calling AddMorphismRepresentation after adding functions to the category is not supported" );
        
    end;
    
    InstallTrueMethod( representation, MorphismFilter( category ) );
    
end );

@InstallMethod( RandomMorphismWithFixedSourceAndRange,
    [ IsCapCategoryObject, IsCapCategoryObject, IsInt ], RandomMorphismWithFixedSourceAndRangeByInteger );

@InstallMethod( RandomMorphismWithFixedSourceAndRange,
    [ IsCapCategoryObject, IsCapCategoryObject, IsList ], RandomMorphismWithFixedSourceAndRangeByList );

@InstallMethod( RandomMorphismWithFixedSource,
    [ IsCapCategoryObject, IsInt ], RandomMorphismWithFixedSourceByInteger );

@InstallMethod( RandomMorphismWithFixedSource,
    [ IsCapCategoryObject, IsList ], RandomMorphismWithFixedSourceByList );

@InstallMethod( RandomMorphismWithFixedRange,
    [ IsCapCategoryObject, IsInt ], RandomMorphismWithFixedRangeByInteger );

@InstallMethod( RandomMorphismWithFixedRange,
    [ IsCapCategoryObject, IsList ], RandomMorphismWithFixedRangeByList );

@InstallMethod( RandomMorphism,
    [ IsCapCategory, IsInt ], RandomMorphismByInteger );

@InstallMethod( RandomMorphism,
    [ IsCapCategory, IsList ], RandomMorphismByList );

@InstallMethod( RandomMorphism,
    [ IsCapCategoryObject, IsCapCategoryObject, IsList ], RandomMorphismWithFixedSourceAndRangeByList );

@InstallMethod( RandomMorphism,
    [ IsCapCategoryObject, IsCapCategoryObject, IsInt ], RandomMorphismWithFixedSourceAndRangeByInteger );

##
@InstallGlobalFunction( ObjectifyMorphismWithSourceAndRangeForCAPWithAttributes,
                       
  function( morphism, category, source, range, additional_arguments_list... )
    local arg_list, objectified_morphism;
    
    Print( "WARNING: ObjectifyMorphismWithSourceAndRangeForCAPWithAttributes is deprecated and will not be supported after 2024.08.29. Please use CreateCapCategoryMorphismWithAttributes instead.\n" );
    
    arg_list = @Concatenation(
        [ morphism, category.morphism_type, CapCategory, category, Source, source, Range, range ], additional_arguments_list
    );
    
    objectified_morphism = CallFuncList( ObjectifyWithAttributes, arg_list );
    
    if (category.predicate_logic)
        INSTALL_TODO_FOR_LOGICAL_THEOREMS( "Source", [ objectified_morphism ], source, category );
        INSTALL_TODO_FOR_LOGICAL_THEOREMS( "Range", [ objectified_morphism ], range, category );
    end;
    
    #= comment for Julia
    # This can be removed once AddMorphismRepresentation is removed.
    # work around https://github.com/gap-system/gap/issues/3642:
    # New implications of `MorphismFilter( category )` (e.g. installed via `AddMorphismRepresentation`)
    # are not automatically set in `category.morphism_type`.
    SetFilterObj( objectified_morphism, MorphismFilter( category ) );
    # =#
    
    return objectified_morphism;
    
end );

##
@InstallGlobalFunction( CreateCapCategoryMorphismWithAttributes,
                       
  function( category, source, range, additional_arguments_list... )
    local arg_list, objectified_morphism;
    
    arg_list = @Concatenation(
        [ @rec( ), category.morphism_type, CapCategory, category, Source, source, Range, range ], additional_arguments_list
    );
    
    objectified_morphism = CallFuncList( ObjectifyWithAttributes, arg_list );
    
    if (category.predicate_logic)
        INSTALL_TODO_FOR_LOGICAL_THEOREMS( "Source", [ objectified_morphism ], source, category );
        INSTALL_TODO_FOR_LOGICAL_THEOREMS( "Range", [ objectified_morphism ], range, category );
    end;
    
    #= comment for Julia
    # This can be removed once AddMorphismRepresentation is removed.
    # work around https://github.com/gap-system/gap/issues/3642:
    # New implications of `MorphismFilter( category )` (e.g. installed via `AddMorphismRepresentation`)
    # are not automatically set in `category.morphism_type`.
    SetFilterObj( objectified_morphism, MorphismFilter( category ) );
    # =#
    
    return objectified_morphism;
    
end );

##
@InstallGlobalFunction( AsCapCategoryMorphism,
                       
  function( category, source, morphism_datum, range )
    local morphism_datum_type, mor;
    
    morphism_datum_type = CAP_INTERNAL_GET_DATA_TYPE_FROM_STRING( "morphism_datum", category );
    
    if (morphism_datum_type != fail)
        
        CAP_INTERNAL_ASSERT_VALUE_IS_OF_TYPE_GETTER( morphism_datum_type, [ "the third argument of `AsCapCategoryMorphism`" ] )( morphism_datum );
        
    end;
    
    mor = ObjectifyWithAttributes( @rec( ), category.morphism_type, CapCategory, category, Source, source, Range, range, category.morphism_attribute, morphism_datum );
    
    if (@not IsIdenticalObj( category.morphism_attribute( mor ), morphism_datum ))
        
        Print( "WARNING: <morphism_datum> is not identical to `", category.morphism_attribute_name, "( <mor> )`. You might want to make <morphism_datum> immutable.\n" );
        
    end;
    
    if (category.predicate_logic)
        INSTALL_TODO_FOR_LOGICAL_THEOREMS( "Source", [ mor ], source, category );
        INSTALL_TODO_FOR_LOGICAL_THEOREMS( "Range", [ mor ], range, category );
    end;
    
    return mor;
    
end );

##
@InstallMethod( Simplify,
               [ IsCapCategoryMorphism ],
               
  function( morphism )
    local phi;
    
    phi = PreCompose( [ SimplifyObject_IsoToInputObject( Source( morphism ), infinity ),
                         morphism,
                         SimplifyObject_IsoFromInputObject( Range( morphism ), infinity ) ] );
    
    return SimplifyMorphism( phi, infinity );
    
end );

######################################
##
## Morphism equality functions
##
######################################

# This method should usually not be selected when the two morphisms belong to the same category and the category can compute IsEqualForMorphisms.
@InstallMethod( IsEqualForMorphisms,
                    [ IsCapCategory, IsCapCategoryMorphism, IsCapCategoryMorphism ],

  function( cat, morphism_1, morphism_2 )
    
    if (@not HasCapCategory( morphism_1 ))
        
        Error( @Concatenation( "the morphism \"", StringGAP( morphism_1 ), "\" has no CAP category" ) );
        
    end;
    
    if (@not HasCapCategory( morphism_2 ))
        
        Error( @Concatenation( "the morphism \"", StringGAP( morphism_2 ), "\" has no CAP category" ) );
        
    end;
    
    if (@not IsIdenticalObj( CapCategory( morphism_1 ), cat ))
        
        Error( @Concatenation( "the morphism \"", StringGAP( morphism_1 ), "\" does not belong to the CAP category <cat>" ) );
        
    elseif (@not IsIdenticalObj( CapCategory( morphism_2 ), cat ))
        
        Error( @Concatenation( "the morphism \"", StringGAP( morphism_2 ), "\" does not belong to the CAP category <cat>" ) );
        
    else
        
        # convenience: as long as the morphisms are identical, everything "just works"
        if (IsIdenticalObj( morphism_1, morphism_2 ))
            
            return true;
            
        else
            
            Error( "Cannot decide whether the morphism \"", StringGAP( morphism_1 ), "\" and the morphism \"", StringGAP( morphism_2 ), "\" are equal. You can fix this error by installing `IsEqualForMorphisms` in <cat> or possibly avoid it by enabling strict caching." );
            
        end;
        
    end;
    
end );

# This method should usually not be selected when the two morphisms belong to the same category and the category can compute IsCongruentForMorphisms.
@InstallMethod( IsCongruentForMorphisms,
                    [ IsCapCategory, IsCapCategoryMorphism, IsCapCategoryMorphism ],

  function( cat, morphism_1, morphism_2 )
    
    if (@not HasCapCategory( morphism_1 ))
        
        Error( @Concatenation( "the morphism \"", StringGAP( morphism_1 ), "\" has no CAP category" ) );
        
    end;
    
    if (@not HasCapCategory( morphism_2 ))
        
        Error( @Concatenation( "the morphism \"", StringGAP( morphism_2 ), "\" has no CAP category" ) );
        
    end;
    
    if (@not IsIdenticalObj( CapCategory( morphism_1 ), cat ))
        
        Error( @Concatenation( "the morphism \"", StringGAP( morphism_1 ), "\" does not belong to the CAP category <cat>" ) );
        
    elseif (@not IsIdenticalObj( CapCategory( morphism_2 ), cat ))
        
        Error( @Concatenation( "the morphism \"", StringGAP( morphism_2 ), "\" does not belong to the CAP category <cat>" ) );
        
    else
        
        if (CapCategory( morphism_1 ).is_computable)
            
            # convenience: as long as the morphisms are identical, everything "just works"
            if (IsIdenticalObj( morphism_1, morphism_2 ))
                
                return true;
                
            else
                
                Error( "Cannot decide whether the morphism \"", StringGAP( morphism_1 ), "\" and the morphism \"", StringGAP( morphism_2 ), "\" are congruent. You can fix this error by installing `IsCongruentForMorphisms` in <cat>." );
                
            end;
            
        else
            
            Error( "cannot decide congruence of morphisms in a non-computable category" );
            
        end;
        
    end;
    
end );

##
@InstallMethod( ==,
               [ IsCapCategoryMorphism, IsCapCategoryMorphism ],
               
  function( morphism_1, morphism_2 )
    
    if (CapCategory( morphism_1 ).input_sanity_check_level > 0 || CapCategory( morphism_2 ).input_sanity_check_level > 0 )
        if (@not IsIdenticalObj( CapCategory( morphism_1 ), CapCategory( morphism_2 ) ))
            Error( @Concatenation( "the morphism \"", StringGAP( morphism_1 ), "\" and the morphism \"", StringGAP( morphism_2 ), "\" do not belong to the same CAP category" ) );
        end;
    end;
    if (!(IsEqualForObjects( Source( morphism_1 ), Source( morphism_2 ) )) || @not IsEqualForObjects( Range( morphism_1 ), Range( morphism_2 ) ))
        
        return false;
        
    end;
    
    return IsCongruentForMorphisms( morphism_1, morphism_2 );
    
end );

##
@InstallGlobalFunction( INSTALL_TODO_LIST_FOR_EQUAL_MORPHISMS,
                       
  function( morphism_1, morphism_2 )
    local category, i, entry;
    
    category = CapCategory( morphism_1 );
    
    for i in PROPAGATION_LIST_FOR_EQUAL_MORPHISMS
        
        AddToToDoList( ToDoListEntryForEqualAttributes( morphism_1, i, morphism_2, i ) );
        
    end;
    
    if (@IsBound( category.PROPAGATION_LIST_FOR_EQUAL_MORPHISMS ))
        
        for i in category.PROPAGATION_LIST_FOR_EQUAL_MORPHISMS
            
            AddToToDoList( ToDoListEntryForEqualAttributes( morphism_1, i, morphism_2, i ) );
            
        end;
        
    end;
    
end );

##
@InstallMethod( AddPropertyToMatchAtIsCongruentForMorphisms,
               [ IsCapCategory, IsString ],
               
  function( category, name )
    
    if (@not @IsBound( category.PROPAGATION_LIST_FOR_EQUAL_MORPHISMS ))
        
        category.PROPAGATION_LIST_FOR_EQUAL_MORPHISMS = [ ];
        
    end;
    
    if (Position( category.PROPAGATION_LIST_FOR_EQUAL_MORPHISMS, name ) == fail)
        
        Add( category.PROPAGATION_LIST_FOR_EQUAL_MORPHISMS, name );
        
    end;
    
end );

######################################
##
## Convenience method
##
######################################

## FIXME: This might be dangerous
##
# InstallMethod( Zero,
#                [ IsCapCategoryMorphism ],
#                
#   function( mor )
#     
#     return ZeroMorphism( Source( mor ), Range( mor ) );
#     
# end );

##
@InstallMethod( PreComposeList,
               [ IsCapCategory, IsList ],
               
  function( cat, morphism_list )
    
    if (IsEmpty( morphism_list ))
        Error( "the given list of morphisms is empty\n" );
    end;
    
    return PreComposeList( cat, Source( First( morphism_list ) ), morphism_list, Range( Last( morphism_list ) ) );
    
end );

##
@InstallMethod( PostComposeList,
               [ IsCapCategory, IsList ],
               
  function( cat, morphism_list )
    
    if (IsEmpty( morphism_list ))
        Error( "the given list of morphisms is empty\n" );
    end;
    
    return PostComposeList( cat, Source( Last( morphism_list ) ), morphism_list, Range( First( morphism_list ) ) );
    
end );

##
@InstallMethod( PreComposeList,
               [ IsList ],
               
  function( morphism_list )
    
    if (IsEmpty( morphism_list ))
        Error( "the given list of morphisms is empty\n" );
    end;
    
    return PreComposeList( CapCategory( morphism_list[1] ), morphism_list );
    
end );

##
@InstallMethod( PostComposeList,
               [ IsList ],
               
  function( morphism_list )
    
    if (IsEmpty( morphism_list ))
        Error( "the given list of morphisms is empty\n" );
    end;
    
    return PostComposeList( CapCategory( morphism_list[1] ), morphism_list );
    
end );

##
@InstallMethod( PreCompose,
               [ IsList ],
               
  function( morphism_list )
    
    return PreComposeList( morphism_list );
    
end );

##
@InstallMethod( PostCompose,
               [ IsList ],
               
  function( morphism_list )
    
    return PostComposeList( morphism_list );
    
end );

##
@InstallMethod( HomStructure,
               [ IsCapCategoryMorphism, IsCapCategoryMorphism ],
               
  function( alpha, beta )
    
    return HomomorphismStructureOnMorphisms( alpha, beta );
    
end );

##
@InstallMethod( HomStructure,
               [ IsCapCategoryObject, IsCapCategoryMorphism ],
               
  function( a, beta )
    
    return HomomorphismStructureOnMorphisms( IdentityMorphism( a ), beta );
    
end );

##
@InstallMethod( HomStructure,
               [ IsCapCategoryMorphism, IsCapCategoryObject ],
               
  function( alpha, b )
    
    return HomomorphismStructureOnMorphisms( alpha, IdentityMorphism( b ) );
    
end );

##
@InstallMethod( HomStructure,
               [ IsCapCategoryObject, IsCapCategoryObject ],
               
  function( a, b )
    
    return HomomorphismStructureOnObjects( a, b );
    
end );

##
@InstallMethod( HomStructure,
               [ IsCapCategoryMorphism ],
    InterpretMorphismAsMorphismFromDistinguishedObjectToHomomorphismStructure
);

##
@InstallMethod( HomStructure,
               [ IsCapCategoryObject, IsCapCategoryObject, IsCapCategoryMorphism ],
    InterpretMorphismFromDistinguishedObjectToHomomorphismStructureAsMorphism
);

##
@InstallMethod( HomStructure,
               [ IsCapCategory ],
    DistinguishedObjectOfHomomorphismStructure
);

##

# usually the type signatures should be part of the gd file, but `CapJitAddTypeSignature` is not available there

CapJitAddTypeSignature( "HomomorphismStructureOnObjectsExtendedByFullEmbedding", [ IsCapCategory, IsCapCategory, IsCapCategoryObject, IsCapCategoryObject ], function ( input_types )
    
    return CapJitDataTypeOfObjectOfCategory( input_types[2].category );
    
end );

CapJitAddTypeSignature( "HomomorphismStructureOnMorphismsExtendedByFullEmbedding", [ IsCapCategory, IsCapCategory, IsCapCategoryMorphism, IsCapCategoryMorphism ], function ( input_types )
    
    return CapJitDataTypeOfMorphismOfCategory( input_types[2].category );
    
end );

CapJitAddTypeSignature( "HomomorphismStructureOnMorphismsWithGivenObjectsExtendedByFullEmbedding", [ IsCapCategory, IsCapCategory, IsCapCategoryObject, IsCapCategoryMorphism, IsCapCategoryMorphism, IsCapCategoryObject ], function ( input_types )
    
    return CapJitDataTypeOfMorphismOfCategory( input_types[2].category );
    
end );

CapJitAddTypeSignature( "DistinguishedObjectOfHomomorphismStructureExtendedByFullEmbedding", [ IsCapCategory, IsCapCategory ], function ( input_types )
    
    return CapJitDataTypeOfObjectOfCategory( input_types[2].category );
    
end );

CapJitAddTypeSignature( "InterpretMorphismAsMorphismFromDistinguishedObjectToHomomorphismStructureExtendedByFullEmbedding", [ IsCapCategory, IsCapCategory, IsCapCategoryMorphism ], function ( input_types )
    
    return CapJitDataTypeOfMorphismOfCategory( input_types[2].category );
    
end );

CapJitAddTypeSignature( "InterpretMorphismAsMorphismFromDistinguishedObjectToHomomorphismStructureWithGivenObjectsExtendedByFullEmbedding", [ IsCapCategory, IsCapCategory, IsCapCategoryObject, IsCapCategoryMorphism, IsCapCategoryObject ], function ( input_types )
    
    return CapJitDataTypeOfMorphismOfCategory( input_types[2].category );
    
end );

CapJitAddTypeSignature( "InterpretMorphismFromDistinguishedObjectToHomomorphismStructureAsMorphismExtendedByFullEmbedding", [ IsCapCategory, IsCapCategory, IsCapCategoryObject, IsCapCategoryObject, IsCapCategoryMorphism ], function ( input_types )
    
    return CapJitDataTypeOfMorphismOfCategory( input_types[1].category );
    
end );

@InstallMethod( ExtendRangeOfHomomorphismStructureByFullEmbedding,
               [ IsCapCategory, IsCapCategory, IsFunction, IsFunction, IsFunction, IsFunction ],
  function ( C, E, object_function, morphism_function, object_function_inverse, morphism_function_inverse )
    
    # C has a D-homomorphism structure
    # object_function and morphism_function defined a full embedding ι: D → E
    # object_function_inverse and morphism_function_inverse define the inverse of ι on its image
    
    InstallMethodForCompilerForCAP( DistinguishedObjectOfHomomorphismStructureExtendedByFullEmbedding,
                                    [ IsCapCategory && CategoryFilter( C ), IsCapCategory && CategoryFilter( E ) ],
      function ( C, E )
        
        return object_function( C, E, DistinguishedObjectOfHomomorphismStructure( C ) );
        
    end );
    
    InstallMethodForCompilerForCAP( HomomorphismStructureOnObjectsExtendedByFullEmbedding,
                                    [ IsCapCategory && CategoryFilter( C ), IsCapCategory && CategoryFilter( E ), IsCapCategoryObject && ObjectFilter( C ), IsCapCategoryObject && ObjectFilter( C ) ],
      function ( C, E, a, b )
        
        return object_function( C, E, HomomorphismStructureOnObjects( C, a, b ) );
        
    end );
    
    InstallMethodForCompilerForCAP( HomomorphismStructureOnMorphismsExtendedByFullEmbedding,
                                    [ IsCapCategory && CategoryFilter( C ), IsCapCategory && CategoryFilter( E ), IsCapCategoryMorphism && MorphismFilter( C ), IsCapCategoryMorphism && MorphismFilter( C ) ],
      function ( C, E, alpha, beta )
        local mor;
        
        mor = HomomorphismStructureOnMorphisms( C, alpha,  beta );
        
        return morphism_function( C, E, object_function( C, E, Source( mor ) ), mor, object_function( C, E, Range( mor ) ) );
        
    end );
    
    InstallMethodForCompilerForCAP( HomomorphismStructureOnMorphismsWithGivenObjectsExtendedByFullEmbedding,
                                    [ IsCapCategory && CategoryFilter( C ), IsCapCategory && CategoryFilter( E ), IsCapCategoryObject && ObjectFilter( E ), IsCapCategoryMorphism && MorphismFilter( C ), IsCapCategoryMorphism && MorphismFilter( C ), IsCapCategoryObject && ObjectFilter( E ) ],
      function ( C, E, s, alpha, beta, r )
        local mor;
        
        mor = HomomorphismStructureOnMorphismsWithGivenObjects( C, object_function_inverse( C, E, s ), alpha, beta, object_function_inverse( C, E, r ) );
        
        return morphism_function( C, E, s, mor, r );
        
    end );
    
    InstallMethodForCompilerForCAP( InterpretMorphismAsMorphismFromDistinguishedObjectToHomomorphismStructureExtendedByFullEmbedding,
                                    [ IsCapCategory && CategoryFilter( C ), IsCapCategory && CategoryFilter( E ), IsCapCategoryMorphism && MorphismFilter( C ) ],
      function ( C, E, alpha )
        local mor;
        
        mor = InterpretMorphismAsMorphismFromDistinguishedObjectToHomomorphismStructure( C, alpha );
        
        return morphism_function( C, E, object_function( C, E, Source( mor ) ), mor, object_function( C, E, Range( mor ) ) );
        
    end );
    
    InstallMethodForCompilerForCAP( InterpretMorphismAsMorphismFromDistinguishedObjectToHomomorphismStructureWithGivenObjectsExtendedByFullEmbedding,
                                    [ IsCapCategory && CategoryFilter( C ), IsCapCategory && CategoryFilter( E ), IsCapCategoryObject && ObjectFilter( E ), IsCapCategoryMorphism && MorphismFilter( C ), IsCapCategoryObject && ObjectFilter( E ) ],
      function ( C, E, distinguished_object, alpha, r )
        local mor;
        
        mor = InterpretMorphismAsMorphismFromDistinguishedObjectToHomomorphismStructureWithGivenObjects( C, object_function_inverse( C, E, distinguished_object ), alpha, object_function_inverse( C, E, r ) );
        
        return morphism_function( C, E, distinguished_object, mor, r );
        
    end );
    
    InstallMethodForCompilerForCAP( InterpretMorphismFromDistinguishedObjectToHomomorphismStructureAsMorphismExtendedByFullEmbedding,
                                    [ IsCapCategory && CategoryFilter( C ), IsCapCategory && CategoryFilter( E ), IsCapCategoryObject && ObjectFilter( C ), IsCapCategoryObject && ObjectFilter( C ), IsCapCategoryMorphism && MorphismFilter( E ) ],
      function ( C, E, a, b, iota )
        
        return InterpretMorphismFromDistinguishedObjectToHomomorphismStructureAsMorphism( C, a, b, morphism_function_inverse( C, E, object_function_inverse( C, E, Source( iota ) ), iota, object_function_inverse( C, E, Range( iota ) ) ) );
        
    end );
    
end );

##
@InstallMethod( ExtendRangeOfHomomorphismStructureByIdentityAsFullEmbedding,
               [ IsCapCategory ],
  function ( C )
    local object_function, morphism_function, object_function_inverse, morphism_function_inverse;
    
    if (@IsBound( C.range_category_of_hom_structure_already_extended_by_identity ))
        ## the range of the hom-structure has already been extended by identity
        return;
    end;
    
    object_function = function ( category, range_category, object )
        #% CAP_JIT_RESOLVE_FUNCTION
        
        return object;
        
    end;
    
    morphism_function = function ( category, range_category, source, morphism, range )
        #% CAP_JIT_RESOLVE_FUNCTION
        
        return morphism;
        
    end;
    
    object_function_inverse = function ( category, range_category, object )
        #% CAP_JIT_RESOLVE_FUNCTION
        
        return object;
        
    end;
    
    morphism_function_inverse = function ( category, range_category, source, morphism, range )
        #% CAP_JIT_RESOLVE_FUNCTION
        
        return morphism;
        
    end;
    
    ExtendRangeOfHomomorphismStructureByFullEmbedding( C, RangeCategoryOfHomomorphismStructure( C ), object_function, morphism_function, object_function_inverse, morphism_function_inverse );
    
    C.range_category_of_hom_structure_already_extended_by_identity = true;
    
end );

######################################
##
## Morphism transport
##
######################################

## mor: x -> y
## equality_source: x -> x'
## equality_range: y -> y'
## TransportHom( mor, equality_source, equality_range ): x' -> y'
##
InstallMethodWithCacheFromObject( TransportHom,
                                  [ IsCapCategoryMorphism, IsCapCategoryMorphism, IsCapCategoryMorphism ],
                                  
  function( mor, equality_source, equality_range )
    
    return PreCompose(
             Inverse( equality_source ),
             PreCompose( mor, equality_range )
           );
    
end );

###########################
##
## IsWellDefined
##
###########################

##
@InstallMethod( IsWellDefined,
               [ IsCapCategoryMorphism ],
               
  IsWellDefinedForMorphisms
);

###########################
##
## Print
##
###########################

@InstallMethod( StringGAP,
               [ IsCapCategoryMorphism ],
               
  function( morphism )
    
    return @Concatenation( "A morphism in ", Name( CapCategory( morphism ) ) );
    
end );

# fallback methods for Julia
@InstallMethod( ViewString,
               [ IsCapCategoryMorphism ],
               
  function ( morphism )
    
    # do not reuse `StringGAP` because morphisms might use `StringGAP` as the attribute storing the morphism datum
    return @Concatenation( "<A morphism in ", Name( CapCategory( morphism ) ), ">" );
    
end );

@InstallMethod( DisplayString,
               [ IsCapCategoryMorphism ],
               
  function ( morphism )
    
    # do not reuse `StringGAP` because morphisms might use `StringGAP` as the attribute storing the morphism datum
    return @Concatenation( "A morphism in ", Name( CapCategory( morphism ) ), ".\n" );
    
end );

##
@InstallGlobalFunction( CAP_INTERNAL_CREATE_MORPHISM_PRINT,
                       
  function( )
    local print_graph, morphism_function;
    
    morphism_function = function( object )
      local string;
        
        string = "morphism in ";
        
        Append( string, Name( CapCategory( object ) ) );
        
        return string;
        
    end;
    
    print_graph = CreatePrintingGraph( IsCapCategoryMorphism && HasCapCategory, morphism_function );
    
    AddRelationToGraph( print_graph,
                        @rec( Source = [ @rec( Conditions = "IsIsomorphism",
                                              PrintString = "iso",
                                              Adjective = true,
                                              NoSepString = true ) ],
                             Range = [ @rec( Conditions = "IsSplitMonomorphism",
                                             PrintString = "split mono",
                                             TypeOfView = "ViewObj",
                                             ComputeLevel = "AllWithCompute",
                                             Adjective = true,
                                              NoSepString = true ),
                                        @rec( Conditions = "IsSplitEpimorphism",
                                             PrintString = "split epi",
                                             Adjective = true,
                                              NoSepString = true ) ] ) );
    
    AddRelationToGraph( print_graph,
                        @rec( Source = [ @rec( Conditions = "IsOne",
                                              PrintString = "identity",
                                              Adjective = true ) ],
                             Range = [ @rec( Conditions = "IsAutomorphism",
                                             PrintString = "auto",
                                             Adjective = true,
                                             NoSepString = true ),
                                        "IsIsomorphism" ] ) );
    
    AddRelationToGraph( print_graph,
                        @rec( Source = [ "IsAutomorphism" ],
                             Range = [ "IsIsomorphism",
                                        @rec( Conditions = "IsEndomorphism",
                                             PrintString = "endo",
                                             Adjective = true,
                                             NoSepString = true) ] ) );
    
    AddRelationToGraph( print_graph,
                        @rec( Source = [ "IsSplitMonomorphism" ],
                             Range = [ @rec( Conditions = "IsMonomorphism",
                                             PrintString = "mono",
                                             Adjective = true,
                                             NoSepString = true ) ] ) );
    
    AddRelationToGraph( print_graph,
                        @rec( Source = [ "IsSplitEpimorphism" ],
                             Range = [ @rec( Conditions = "IsEpimorphism",
                                             PrintString = "epi",
                                             Adjective = true,
                                             NoSepString = true ) ] ) );
    
    AddNodeToGraph( print_graph,
                    @rec( Conditions = "IsZeroForMorphisms",
                         PrintString = "zero",
                         Adjective = true ) );
    
    InstallPrintFunctionsOutOfPrintingGraph( print_graph, -1 );
    
end );

#= comment for Julia
CAP_INTERNAL_CREATE_MORPHISM_PRINT( );
# =#
