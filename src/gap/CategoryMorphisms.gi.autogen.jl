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

InstallMethod( @__MODULE__,  Target,
               [ IsCapCategoryMorphism ],
               
  Range );

InstallMethod( @__MODULE__,  Add,
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

InstallMethod( @__MODULE__,  AddMorphism,
               [ IsCapCategory, IsCapCategoryMorphism ],
               
  function( category, morphism )
    
    Add( category, morphism );
    
end );

InstallMethod( @__MODULE__,  AddMorphism,
               [ IsCapCategory, IsAttributeStoringRep ],
               
  function( category, morphism )
    
    SetFilterObj( morphism, IsCapCategoryMorphism );
    
    Add( category, morphism );
    
end );

##
InstallMethod( @__MODULE__,  IsZero,
               [ IsCapCategoryMorphism ],
                  
IsZeroForMorphisms );

##
InstallMethod( @__MODULE__,  +,
               [ IsCapCategoryMorphism, IsCapCategoryMorphism ],
               
AdditionForMorphisms );

##
InstallMethod( @__MODULE__,  -,
               [ IsCapCategoryMorphism, IsCapCategoryMorphism ],
               
SubtractionForMorphisms );

##
InstallMethod( @__MODULE__,  AdditiveInverse,
                  [ IsCapCategoryMorphism ],
                  
AdditiveInverseForMorphisms );

CAP_INTERNAL_ADD_REPLACEMENTS_FOR_METHOD_RECORD(
  @rec(
    AdditiveInverse = [ [ "AdditiveInverseForMorphisms", 1 ] ],
    AdditiveInverseImmutable = [ [ "AdditiveInverseForMorphisms", 1 ] ],
  )
 );

##
InstallMethod( @__MODULE__,  Inverse,
                  [ IsCapCategoryMorphism ],
                  
InverseForMorphisms );

CAP_INTERNAL_ADD_REPLACEMENTS_FOR_METHOD_RECORD(
  @rec(
    Inverse = [ [ "InverseForMorphisms", 1 ] ],
    InverseImmutable = [ [ "InverseForMorphisms", 1 ] ],
  )
 );

##
InstallMethod( @__MODULE__,  *,
               [ IsRingElement, IsCapCategoryMorphism ],
               
MultiplyWithElementOfCommutativeRingForMorphisms );

##
InstallMethod( @__MODULE__,  *,
               [ IsCapCategoryMorphism, IsRingElement ],
               
  function( mor, r )
    
    return MultiplyWithElementOfCommutativeRingForMorphisms( r, mor );
    
end );

##
InstallMethod( @__MODULE__,  *,
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
InstallMethod( @__MODULE__,  IsEqualForCache,
               [ IsCapCategoryMorphism, IsCapCategoryMorphism ],
               
  ( mor1, mor2 ) -> IsEqualForCacheForMorphisms( CapCategory( mor1 ), mor1, mor2 ) );

##
# generic fallback to IsIdenticalObj
InstallMethod( @__MODULE__,  IsEqualForCacheForMorphisms,
               [ IsCapCategory, IsCapCategoryMorphism, IsCapCategoryMorphism ],
               
  ( cat, mor1, mor2 ) -> IsIdenticalObj( mor1, mor2 ) );

##
InstallMethod( @__MODULE__,  AddMorphismRepresentation,
               [ IsCapCategory, IsObject ],
               
  function( category, representation )
    
    if (@not IsSpecializationOfFilter( IsCapCategoryMorphism, representation ))
        
        Error( "the morphism representation must imply IsCapCategoryMorphism" );
        
    end;
    
    if (@IsBound( category.initially_known_categorical_properties ))
        
        Error( "calling AddMorphismRepresentation after adding functions to the category is not supported" );
        
    end;
    
    InstallTrueMethod( representation, MorphismFilter( category ) );
    
end );

InstallMethod( @__MODULE__,  RandomMorphismWithFixedSourceAndRange,
    [ IsCapCategoryObject, IsCapCategoryObject, IsInt ], RandomMorphismWithFixedSourceAndRangeByInteger );

InstallMethod( @__MODULE__,  RandomMorphismWithFixedSourceAndRange,
    [ IsCapCategoryObject, IsCapCategoryObject, IsList ], RandomMorphismWithFixedSourceAndRangeByList );

InstallMethod( @__MODULE__,  RandomMorphismWithFixedSource,
    [ IsCapCategoryObject, IsInt ], RandomMorphismWithFixedSourceByInteger );

InstallMethod( @__MODULE__,  RandomMorphismWithFixedSource,
    [ IsCapCategoryObject, IsList ], RandomMorphismWithFixedSourceByList );

InstallMethod( @__MODULE__,  RandomMorphismWithFixedRange,
    [ IsCapCategoryObject, IsInt ], RandomMorphismWithFixedRangeByInteger );

InstallMethod( @__MODULE__,  RandomMorphismWithFixedRange,
    [ IsCapCategoryObject, IsList ], RandomMorphismWithFixedRangeByList );

InstallMethod( @__MODULE__,  RandomMorphism,
    [ IsCapCategory, IsInt ], RandomMorphismByInteger );

InstallMethod( @__MODULE__,  RandomMorphism,
    [ IsCapCategory, IsList ], RandomMorphismByList );

InstallMethod( @__MODULE__,  RandomMorphism,
    [ IsCapCategoryObject, IsCapCategoryObject, IsList ], RandomMorphismWithFixedSourceAndRangeByList );

InstallMethod( @__MODULE__,  RandomMorphism,
    [ IsCapCategoryObject, IsCapCategoryObject, IsInt ], RandomMorphismWithFixedSourceAndRangeByInteger );

##
@InstallGlobalFunction( ObjectifyMorphismWithSourceAndRangeForCAPWithAttributes,
                       
  function( morphism, category, source, range, additional_arguments_list... )
    local arg_list, objectified_morphism;
    
    arg_list = @Concatenation(
        [ morphism, category.morphism_type, CapCategory, category, Source, source, Range, range ], additional_arguments_list
    );
    
    objectified_morphism = CallFuncList( ObjectifyWithAttributes, arg_list );
    
    if (category.predicate_logic)
        INSTALL_TODO_FOR_LOGICAL_THEOREMS( "Source", [ objectified_morphism ], source, category );
        INSTALL_TODO_FOR_LOGICAL_THEOREMS( "Range", [ objectified_morphism ], range, category );
    end;
    
    #= comment for Julia
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
    
    # inline ObjectifyMorphismWithSourceAndRangeForCAPWithAttributes( @rec( ), category, source, range, additional_arguments_list... );
    
    arg_list = @Concatenation(
        [ @rec( ), category.morphism_type, CapCategory, category, Source, source, Range, range ], additional_arguments_list
    );
    
    objectified_morphism = CallFuncList( ObjectifyWithAttributes, arg_list );
    
    if (category.predicate_logic)
        INSTALL_TODO_FOR_LOGICAL_THEOREMS( "Source", [ objectified_morphism ], source, category );
        INSTALL_TODO_FOR_LOGICAL_THEOREMS( "Range", [ objectified_morphism ], range, category );
    end;
    
    #= comment for Julia
    # work around https://github.com/gap-system/gap/issues/3642:
    # New implications of `MorphismFilter( category )` (e.g. installed via `AddMorphismRepresentation`)
    # are not automatically set in `category.morphism_type`.
    SetFilterObj( objectified_morphism, MorphismFilter( category ) );
    # =#
    
    return objectified_morphism;
    
end );


##
InstallMethod( @__MODULE__,  Simplify,
               [ IsCapCategoryMorphism ],
               
  function( morphism )
    local phi;
    
    phi = PreCompose( [ SimplifyObject_IsoToInputObject( Source( morphism ), infinity ),
                         morphism,
                         SimplifyObject_IsoFromInputObject( Range( morphism ), infinity ) ] );
    
    return SimplifyMorphism( phi, infinity );
    
end );

##
InstallMethod( @__MODULE__,  CoefficientsOfMorphismWithGivenBasisOfExternalHom,
          [ IsCapCategory, IsCapCategoryMorphism, IsList ],

  function( cat, morphism, basis )
    
    Display( "WARNING: CoefficientsOfMorphismWithGivenBasisOfExternalHom is deprecated and will not be supported after 2023.10.30. Please use CoefficientsOfMorphism instead!\n" );
    
    return CoefficientsOfMorphism( cat, morphism );
    
end );

##
InstallMethod( @__MODULE__,  CoefficientsOfMorphismWithGivenBasisOfExternalHom,
          [ IsCapCategoryMorphism, IsList ],

  ( morphism, basis ) -> CoefficientsOfMorphismWithGivenBasisOfExternalHom( CapCategory( morphism ), morphism, basis ) );

######################################
##
## Morphism equality functions
##
######################################

# This method should usually not be selected when the two morphisms belong to the same category and the category can compute IsEqualForMorphisms.
InstallMethod( @__MODULE__,  IsEqualForMorphisms,
                    [ IsCapCategory, IsCapCategoryMorphism, IsCapCategoryMorphism ],

  function( cat, morphism_1, morphism_2 )
    
    if (@not HasCapCategory( morphism_1 ))
        
        Error( @Concatenation( "the morphism \"", StringGAP( morphism_1 ), "\" has no CAP category" ) );
        
    end;
    
    if (@not HasCapCategory( morphism_2 ))
        
        Error( @Concatenation( "the morphism \"", StringGAP( morphism_2 ), "\" has no CAP category" ) );
        
    end;
    
    if (@not IsIdenticalObj( CapCategory( morphism_1 ), CapCategory( morphism_2 ) ))
        
        Error( @Concatenation( "the morphism \"", StringGAP( morphism_1 ), "\" and the morphism \"", StringGAP( morphism_2 ), "\" do not belong to the same CAP category" ) );
        
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
InstallMethod( @__MODULE__,  IsCongruentForMorphisms,
                    [ IsCapCategory, IsCapCategoryMorphism, IsCapCategoryMorphism ],

  function( cat, morphism_1, morphism_2 )
    
    if (@not HasCapCategory( morphism_1 ))
        
        Error( @Concatenation( "the morphism \"", StringGAP( morphism_1 ), "\" has no CAP category" ) );
        
    end;
    
    if (@not HasCapCategory( morphism_2 ))
        
        Error( @Concatenation( "the morphism \"", StringGAP( morphism_2 ), "\" has no CAP category" ) );
        
    end;
    
    if (@not IsIdenticalObj( CapCategory( morphism_1 ), CapCategory( morphism_2 ) ))
        
        Error( @Concatenation( "the morphism \"", StringGAP( morphism_1 ), "\" and the morphism \"", StringGAP( morphism_2 ), "\" do not belong to the same CAP category" ) );
        
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
InstallMethod( @__MODULE__,  ==,
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
InstallMethod( @__MODULE__,  AddPropertyToMatchAtIsCongruentForMorphisms,
               [ IsCapCategory, IsString ],
               
  function( category, name )
    
    if (@not @IsBound( category.PROPAGATION_LIST_FOR_EQUAL_MORPHISMS ))
        
        category.PROPAGATION_LIST_FOR_EQUAL_MORPHISMS = [ ];
        
    end;
    
    if (Position( category.PROPAGATION_LIST_FOR_EQUAL_MORPHISMS, name ) == fail)
        
        Add( category.PROPAGATION_LIST_FOR_EQUAL_MORPHISMS, name );
        
    end;
    
end );

# deprecated legacy aliases
InstallDeprecatedAlias( "IsIdenticalToIdentityMorphism", "IsEqualToIdentityMorphism", "2023.05.17" );
InstallDeprecatedAlias( "AddIsIdenticalToIdentityMorphism", "AddIsEqualToIdentityMorphism", "2023.05.17" );
InstallDeprecatedAlias( "IsIdenticalToZeroMorphism", "IsEqualToZeroMorphism", "2023.05.17" );
InstallDeprecatedAlias( "AddIsIdenticalToZeroMorphism", "AddIsEqualToZeroMorphism", "2023.05.17" );

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
InstallMethod( @__MODULE__,  PreCompose,
               [ IsList ],
               
  function( morphism_list )
    
    return PreComposeList( morphism_list );
    
end );

##
InstallMethod( @__MODULE__,  PostCompose,
               [ IsList ],
               
  function( morphism_list )
    
    return PostComposeList( morphism_list );
    
end );

##
InstallMethod( @__MODULE__,  HomStructure,
               [ IsCapCategoryMorphism, IsCapCategoryMorphism ],
               
  function( alpha, beta )
    
    return HomomorphismStructureOnMorphisms( alpha, beta );
    
end );

##
InstallMethod( @__MODULE__,  HomStructure,
               [ IsCapCategoryObject, IsCapCategoryMorphism ],
               
  function( a, beta )
    
    return HomomorphismStructureOnMorphisms( IdentityMorphism( a ), beta );
    
end );

##
InstallMethod( @__MODULE__,  HomStructure,
               [ IsCapCategoryMorphism, IsCapCategoryObject ],
               
  function( alpha, b )
    
    return HomomorphismStructureOnMorphisms( alpha, IdentityMorphism( b ) );
    
end );

##
InstallMethod( @__MODULE__,  HomStructure,
               [ IsCapCategoryObject, IsCapCategoryObject ],
               
  function( a, b )
    
    return HomomorphismStructureOnObjects( a, b );
    
end );

##
InstallMethod( @__MODULE__,  HomStructure,
               [ IsCapCategoryMorphism ],
    InterpretMorphismAsMorphismFromDistinguishedObjectToHomomorphismStructure
);

##
InstallMethod( @__MODULE__,  HomStructure,
               [ IsCapCategoryObject, IsCapCategoryObject, IsCapCategoryMorphism ],
    InterpretMorphismFromDistinguishedObjectToHomomorphismStructureAsMorphism
);

##
InstallMethod( @__MODULE__,  HomStructure,
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

InstallMethod( @__MODULE__,  ExtendRangeOfHomomorphismStructureByFullEmbedding,
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
InstallMethod( @__MODULE__,  ExtendRangeOfHomomorphismStructureByIdentityAsFullEmbedding,
               [ IsCapCategory ],
  function ( C )
    local object_function, morphism_function, object_function_inverse, morphism_function_inverse;
    
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
InstallMethod( @__MODULE__,  IsWellDefined,
               [ IsCapCategoryMorphism ],
               
  IsWellDefinedForMorphisms
);

###########################
##
## Print
##
###########################

InstallMethod( @__MODULE__,  StringGAP,
               [ IsCapCategoryMorphism ],
               
  function( morphism )
    
    return @Concatenation( "A morphism in ", Name( CapCategory( morphism ) ) );
    
end );

# fallback methods for Julia
InstallMethod( @__MODULE__,  ViewString,
               [ IsCapCategoryMorphism ],
               
  function ( morphism )
    
    # do not reuse `StringGAP` because morphisms might use `StringGAP` as the attribute storing the morphism datum
    return @Concatenation( "<A morphism in ", Name( CapCategory( morphism ) ), ">" );
    
end );

InstallMethod( @__MODULE__,  DisplayString,
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
