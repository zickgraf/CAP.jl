# SPDX-License-Identifier: GPL-2.0-or-later
# CAP: Categories, Algorithms, Programming
#
# Implementations
#
#! @Chapter Universal Objects

# deprecated legacy aliases
InstallDeprecatedAlias( "CokernelFunctorial", "CokernelObjectFunctorial", "2023.05.17" );
InstallDeprecatedAlias( "CokernelFunctorialWithGivenCokernelObjects", "CokernelObjectFunctorialWithGivenCokernelObjects", "2023.05.17" );

####################################
##
## Coproduct && Pushout
##
####################################

####################################
##
## Coproduct
##
####################################

####################################
## Convenience methods
####################################

##
InstallMethod( @__MODULE__,  Coproduct,
               [ IsCapCategoryObject, IsCapCategoryObject ],
               
  function( object_1, object_2 )
    
    return Coproduct( CapCategory( object_1 ), [ object_1, object_2 ] );
    
end );

##
InstallMethod( @__MODULE__,  Coproduct,
               [ IsCapCategoryObject, IsCapCategoryObject, IsCapCategoryObject ],
               
  function( object_1, object_2, object_3 )
    
    return Coproduct( CapCategory( object_1 ), [ object_1, object_2, object_3 ] );
    
end );

####################################
##
## Direct Product && FiberProduct
##
####################################

####################################
## Convenience methods
####################################


####################################
##
## Direct Product
##
####################################

####################################
## Convenience methods
####################################

##
# compatibility with GAP's DirectProduct function
InstallMethod( @__MODULE__,  DirectProductOp,
               [ IsList, IsCapCategoryObject ],
               
  function( diagram, object )
    
    return DirectProductOp( CapCategory( object ), diagram );
    
end );

##
# compatibility with GAP's DirectProduct function
InstallMethod( @__MODULE__,  DirectProductOp,
               [ IsList, IsCapCategory ],
               
  function( category_and_diagram, category )
    local diagram;
    
    diagram = category_and_diagram[2];
    
    return DirectProductOp( category, diagram );
    
end );

####################################
##
## Direct sum
##
####################################

####################################
## Technical methods
####################################

####################################
## Convenience methods
####################################

##
# compatibility with GAP's DirectSum function
InstallMethod( @__MODULE__,  DirectSumOp,
               [ IsList, IsCapCategoryObject ],
               
  function( diagram, object )
    
    return DirectSumOp( CapCategory( object ), diagram );
    
end );

##
# compatibility with GAP's DirectSum function
InstallMethod( @__MODULE__,  DirectSumOp,
               [ IsList, IsCapCategory ],
               
  function( category_and_diagram, category )
    local diagram;
    
    diagram = category_and_diagram[2];
    
    if !( IsBound( category.supports_empty_limits ) && category.supports_empty_limits == true ) && diagram == [ ]
        return ZeroObject( category );
    end;
    
    return DirectSumOp( category, diagram );
    
end );

####################################
## Add methods
####################################


####################################
## Categorical methods
####################################

# convenience
##
InstallMethod( @__MODULE__,  MorphismBetweenDirectSums,
               [ IsList ],
               
  function( morphism_matrix )
    local nr_rows, nr_cols;
    
    nr_rows = Size( morphism_matrix );
    
    if nr_rows == 0
        
        Error( "The given matrix must !be empty" );
        
    end;
    
    nr_cols = Size( morphism_matrix[1] );
    
    if nr_cols == 0
        
        Error( "The given matrix must !be empty" );
        
    end;
    
    return MorphismBetweenDirectSums( CapCategory( morphism_matrix[1,1] ),
             List( morphism_matrix, row -> Source( row[1] ) ),
             morphism_matrix,
             List( morphism_matrix[1], col -> Range( col ) )
           );
end );

##
InstallOtherMethod( MorphismBetweenDirectSums,
                    [ IsCapCategory, IsList ],
               
  function( cat, morphism_matrix )
    local nr_rows, nr_cols;
    
    nr_rows = Size( morphism_matrix );
    
    if nr_rows == 0
        
        Error( "The given matrix must !be empty" );
        
    end;
    
    nr_cols = Size( morphism_matrix[1] );
    
    if nr_cols == 0
        
        Error( "The given matrix must !be empty" );
        
    end;
    
    return MorphismBetweenDirectSums( cat,
             List( morphism_matrix, row -> Source( row[1] ) ),
             morphism_matrix,
             List( morphism_matrix[1], col -> Range( col ) )
           );
end );

####################################
##
## Equalizer
##
####################################

####################################
## Convenience methods
####################################

##
@InstallGlobalFunction( Equalizer,
  
  function( arg... )
    
    if IsCapCategory( arg[1] )
        
        return CallFuncList( EqualizerOp, arg );
        
    end;
    
    if Length( arg ) == 1 &&
       IsList( arg[1] ) &&
       ForAll( arg[1], IsCapCategoryMorphism )
       
       return EqualizerOp( CapCategory( arg[1][1] ), arg[1] );
       
    end;
    
    if Length( arg ) == 2 &&
       IsCapCategoryObject( arg[1] ) &&
       IsList( arg[2] ) &&
       ForAll( arg[2], IsCapCategoryMorphism )
       
       return EqualizerOp( CapCategory( arg[1] ), arg[1], arg[2] );
       
    end;
    
    return EqualizerOp( CapCategory( arg[1] ), arg );
    
end );

##
InstallOtherMethod( EqualizerOp,
        [ IsList ],
        
  function ( list_of_morphisms )
    
    if IsEmpty( list_of_morphisms )
        
        Error( "the list of morphisms must !be empty" );
        
    end;
    
    return EqualizerOp( CapCategory( list_of_morphisms[1] ), list_of_morphisms );
    
end );

InstallOtherMethod( EqualizerOp,
        [ IsCapCategory, IsList ],
        
  function ( cat, list_of_morphisms )
    
    if IsEmpty( list_of_morphisms )
        
        Error( "the list of morphisms must !be empty" );
        
    end;
    
    return EqualizerOp( cat, Source( list_of_morphisms[1] ), list_of_morphisms );
    
end );

##
InstallOtherMethod( EmbeddingOfEqualizer,
        [ IsList ],
        
  function ( list_of_morphisms )
    
    if IsEmpty( list_of_morphisms )
        
        Error( "the list of morphisms must !be empty" );
        
    end;
    
    return EmbeddingOfEqualizer( CapCategory( list_of_morphisms[1] ), list_of_morphisms );
    
end );

InstallOtherMethod( EmbeddingOfEqualizer,
        [ IsCapCategory, IsList ],
        
  function ( cat, list_of_morphisms )
    
    if IsEmpty( list_of_morphisms )
        
        Error( "the list of morphisms must !be empty" );
        
    end;
    
    return EmbeddingOfEqualizer( cat, Source( list_of_morphisms[1] ), list_of_morphisms );
    
end );

##
InstallOtherMethod( EmbeddingOfEqualizerWithGivenEqualizer,
        [ IsList, IsCapCategoryObject ],
        
  function ( list_of_morphisms, E )
    
    if IsEmpty( list_of_morphisms )
        
        Error( "the list of morphisms must !be empty" );
        
    end;
    
    return EmbeddingOfEqualizerWithGivenEqualizer( CapCategory( list_of_morphisms[1] ), list_of_morphisms, E );
    
end );

InstallOtherMethod( EmbeddingOfEqualizerWithGivenEqualizer,
        [ IsCapCategory, IsList, IsCapCategoryObject ],
        
  function ( cat, list_of_morphisms, E )
    
    if IsEmpty( list_of_morphisms )
        
        Error( "the list of morphisms must !be empty" );
        
    end;
    
    return EmbeddingOfEqualizerWithGivenEqualizer( cat, Source( list_of_morphisms[1] ), list_of_morphisms, E );
    
end );

##
InstallOtherMethod( MorphismFromEqualizerToSink,
        [ IsList ],
        
  function ( list_of_morphisms )
    
    if IsEmpty( list_of_morphisms )
        
        Error( "the list of morphisms must !be empty" );
        
    end;
    
    return MorphismFromEqualizerToSink( CapCategory( list_of_morphisms[1] ), list_of_morphisms );
    
end );

InstallOtherMethod( MorphismFromEqualizerToSink,
        [ IsCapCategory, IsList ],
        
  function ( cat, list_of_morphisms )
    
    if IsEmpty( list_of_morphisms )
        
        Error( "the list of morphisms must !be empty" );
        
    end;
    
    return MorphismFromEqualizerToSink( cat, Source( list_of_morphisms[1] ), list_of_morphisms );
    
end );

##
InstallOtherMethod( MorphismFromEqualizerToSinkWithGivenEqualizer,
        [ IsList, IsCapCategoryObject ],
        
  function ( list_of_morphisms, E )
    
    if IsEmpty( list_of_morphisms )
        
        Error( "the list of morphisms must !be empty" );
        
    end;
    
    return MorphismFromEqualizerToSinkWithGivenEqualizer( CapCategory( list_of_morphisms[1] ), list_of_morphisms, E );
    
end );

InstallOtherMethod( MorphismFromEqualizerToSinkWithGivenEqualizer,
        [ IsCapCategory, IsList, IsCapCategoryObject ],
        
  function ( cat, list_of_morphisms, E )
    
    if IsEmpty( list_of_morphisms )
        
        Error( "the list of morphisms must !be empty" );
        
    end;
    
    return MorphismFromEqualizerToSinkWithGivenEqualizer( cat, Source( list_of_morphisms[1] ), list_of_morphisms, E );
    
end );

##
InstallOtherMethod( UniversalMorphismIntoEqualizer,
        [ IsList, IsCapCategoryMorphism ],
        
  function ( list_of_morphisms, tau )
    
    if IsEmpty( list_of_morphisms )
        
        Error( "the list of morphisms must !be empty" );
        
    end;
    
    return UniversalMorphismIntoEqualizer( CapCategory( list_of_morphisms[1] ), list_of_morphisms, tau );
    
end );

InstallOtherMethod( UniversalMorphismIntoEqualizer,
        [ IsCapCategory, IsList, IsCapCategoryMorphism ],
        
  function ( cat, list_of_morphisms, tau )
    
    if IsEmpty( list_of_morphisms )
        
        Error( "the list of morphisms must !be empty" );
        
    end;
    
    return UniversalMorphismIntoEqualizer( cat, Source( list_of_morphisms[1] ), list_of_morphisms, tau );
    
end );

##
InstallOtherMethod( UniversalMorphismIntoEqualizerWithGivenEqualizer,
        [ IsList, IsCapCategoryMorphism, IsCapCategoryObject ],
        
  function ( list_of_morphisms, tau, E )
    
    if IsEmpty( list_of_morphisms )
        
        Error( "the list of morphisms must !be empty" );
        
    end;
    
    return UniversalMorphismIntoEqualizerWithGivenEqualizer( CapCategory( list_of_morphisms[1] ), list_of_morphisms, tau, E );
    
end );

InstallOtherMethod( UniversalMorphismIntoEqualizerWithGivenEqualizer,
        [ IsCapCategory, IsList, IsCapCategoryMorphism, IsCapCategoryObject ],
        
  function ( cat, list_of_morphisms, tau, E )
    
    if IsEmpty( list_of_morphisms )
        
        Error( "the list of morphisms must !be empty" );
        
    end;
    
    return UniversalMorphismIntoEqualizerWithGivenEqualizer( cat, Source( list_of_morphisms[1] ), list_of_morphisms, tau, E );
    
end );

####################################
##
## FiberProduct
##
####################################

####################################
## Convenience methods
####################################

##
@InstallGlobalFunction( FiberProduct,
  
  function( arg... )
    
    if IsCapCategory( arg[1] )
        
        return CallFuncList( FiberProductOp, arg );
        
    end;
    
    if Length( arg ) == 1 &&
       IsList( arg[1] ) &&
       ForAll( arg[1], IsCapCategoryMorphism )
       
       return FiberProductOp( CapCategory( arg[1][1] ), arg[1] );
       
     end;
    
    return FiberProductOp( CapCategory( arg[ 1 ] ), arg );
    
end );

####################################
##
## Coequalizer
##
####################################

####################################
## Convenience methods
####################################

##
@InstallGlobalFunction( Coequalizer,
  
  function( arg... )
    
    if IsCapCategory( arg[1] )
        
        return CallFuncList( CoequalizerOp, arg );
        
    end;
    
    if Length( arg ) == 1 &&
       IsList( arg[1] ) &&
       ForAll( arg[1], IsCapCategoryMorphism )
       
       return CoequalizerOp( CapCategory( arg[1][1] ), arg[1] );
       
     end;
    
    if Length( arg ) == 2 &&
       IsCapCategoryObject( arg[2] ) &&
       IsList( arg[2] ) &&
       ForAll( arg[2], IsCapCategoryMorphism )
       
       return CoequalizerOp( CapCategory( arg[1] ), arg[1], arg[2] );
       
     end;
    
    return CoequalizerOp( CapCategory( arg[ 1 ] ), arg );
    
end );

##
InstallOtherMethod( CoequalizerOp,
        [ IsList ],
        
  function ( list_of_morphisms )
    
    if IsEmpty( list_of_morphisms )
        
        Error( "the list of morphisms must !be empty" );
        
    end;
    
    return CoequalizerOp( CapCategory( list_of_morphisms[1] ), list_of_morphisms );
    
end );

InstallOtherMethod( CoequalizerOp,
        [ IsCapCategory, IsList ],
        
  function ( cat, list_of_morphisms )
    
    if IsEmpty( list_of_morphisms )
        
        Error( "the list of morphisms must !be empty" );
        
    end;
    
    return CoequalizerOp( cat, Range( list_of_morphisms[1] ), list_of_morphisms );
    
end );

##
InstallOtherMethod( ProjectionOntoCoequalizer,
        [ IsList ],
        
  function ( list_of_morphisms )
    
    if IsEmpty( list_of_morphisms )
        
        Error( "the list of morphisms must !be empty" );
        
    end;
    
    return ProjectionOntoCoequalizer( CapCategory( list_of_morphisms[1] ), list_of_morphisms );
    
end );

InstallOtherMethod( ProjectionOntoCoequalizer,
        [ IsCapCategory, IsList ],
        
  function ( cat, list_of_morphisms )
    
    if IsEmpty( list_of_morphisms )
        
        Error( "the list of morphisms must !be empty" );
        
    end;
    
    return ProjectionOntoCoequalizer( cat, Range( list_of_morphisms[1] ), list_of_morphisms );
    
end );

##
InstallOtherMethod( ProjectionOntoCoequalizerWithGivenCoequalizer,
        [ IsList, IsCapCategoryObject ],
        
  function ( list_of_morphisms, E )
    
    if IsEmpty( list_of_morphisms )
        
        Error( "the list of morphisms must !be empty" );
        
    end;
    
    return ProjectionOntoCoequalizerWithGivenCoequalizer( CapCategory( list_of_morphisms[1] ), list_of_morphisms, E );
    
end );

InstallOtherMethod( ProjectionOntoCoequalizerWithGivenCoequalizer,
        [ IsCapCategory, IsList, IsCapCategoryObject ],
        
  function ( cat, list_of_morphisms, E )
    
    if IsEmpty( list_of_morphisms )
        
        Error( "the list of morphisms must !be empty" );
        
    end;
    
    return ProjectionOntoCoequalizerWithGivenCoequalizer( cat, Range( list_of_morphisms[1] ), list_of_morphisms, E );
    
end );

##
InstallOtherMethod( MorphismFromSourceToCoequalizer,
        [ IsList ],
        
  function ( list_of_morphisms )
    
    if IsEmpty( list_of_morphisms )
        
        Error( "the list of morphisms must !be empty" );
        
    end;
    
    return MorphismFromSourceToCoequalizer( CapCategory( list_of_morphisms[1] ), list_of_morphisms );
    
end );

InstallOtherMethod( MorphismFromSourceToCoequalizer,
        [ IsCapCategory, IsList ],
        
  function ( cat, list_of_morphisms )
    
    if IsEmpty( list_of_morphisms )
        
        Error( "the list of morphisms must !be empty" );
        
    end;
    
    return MorphismFromSourceToCoequalizer( cat, Range( list_of_morphisms[1] ), list_of_morphisms );
    
end );

##
InstallOtherMethod( MorphismFromSourceToCoequalizerWithGivenCoequalizer,
        [ IsList, IsCapCategoryObject ],
        
  function ( list_of_morphisms, E )
    
    if IsEmpty( list_of_morphisms )
        
        Error( "the list of morphisms must !be empty" );
        
    end;
    
    return MorphismFromSourceToCoequalizerWithGivenCoequalizer( CapCategory( list_of_morphisms[1] ), list_of_morphisms, E );
    
end );

InstallOtherMethod( MorphismFromSourceToCoequalizerWithGivenCoequalizer,
        [ IsCapCategory, IsList, IsCapCategoryObject ],
        
  function ( cat, list_of_morphisms, E )
    
    if IsEmpty( list_of_morphisms )
        
        Error( "the list of morphisms must !be empty" );
        
    end;
    
    return MorphismFromSourceToCoequalizerWithGivenCoequalizer( cat, Range( list_of_morphisms[1] ), list_of_morphisms, E );
    
end );

##
InstallOtherMethod( UniversalMorphismFromCoequalizer,
        [ IsList, IsCapCategoryMorphism ],
        
  function ( list_of_morphisms, tau )
    
    if IsEmpty( list_of_morphisms )
        
        Error( "the list of morphisms must !be empty" );
        
    end;
    
    return UniversalMorphismFromCoequalizer( CapCategory( list_of_morphisms[1] ), list_of_morphisms, tau );
    
end );

InstallOtherMethod( UniversalMorphismFromCoequalizer,
        [ IsCapCategory, IsList, IsCapCategoryMorphism ],
        
  function ( cat, list_of_morphisms, tau )
    
    if IsEmpty( list_of_morphisms )
        
        Error( "the list of morphisms must !be empty" );
        
    end;
    
    return UniversalMorphismFromCoequalizer( cat, Range( list_of_morphisms[1] ), list_of_morphisms, tau );
    
end );

##
InstallOtherMethod( UniversalMorphismFromCoequalizerWithGivenCoequalizer,
        [ IsList, IsCapCategoryMorphism, IsCapCategoryObject ],
        
  function ( list_of_morphisms, tau, E )
    
    if IsEmpty( list_of_morphisms )
        
        Error( "the list of morphisms must !be empty" );
        
    end;
    
    return UniversalMorphismFromCoequalizerWithGivenCoequalizer( CapCategory( list_of_morphisms[1] ), list_of_morphisms, tau, E );
    
end );

InstallOtherMethod( UniversalMorphismFromCoequalizerWithGivenCoequalizer,
        [ IsCapCategory, IsList, IsCapCategoryMorphism, IsCapCategoryObject ],
        
  function ( cat, list_of_morphisms, tau, E )
    
    if IsEmpty( list_of_morphisms )
        
        Error( "the list of morphisms must !be empty" );
        
    end;
    
    return UniversalMorphismFromCoequalizerWithGivenCoequalizer( cat, Range( list_of_morphisms[1] ), list_of_morphisms, tau, E );
    
end );

####################################
##
## Pushout
##
####################################

####################################
## Convenience methods
####################################

##
InstallMethod( @__MODULE__,  Pushout,
               [ IsCapCategoryMorphism, IsCapCategoryMorphism ],
               
  function( mor1, mor2 )
    
    return Pushout( CapCategory( mor1 ), [ mor1, mor2 ] );
    
end );

####################################
##
## Coimage
##
####################################

####################################
## Convenience methods
####################################

# deprecated legacy aliases
InstallDeprecatedAlias( "Coimage", "CoimageObject", "2023.03.29" );
InstallDeprecatedAlias( "CoimageProjectionWithGivenCoimage", "CoimageProjectionWithGivenCoimageObject", "2023.03.29" );
InstallDeprecatedAlias( "AstrictionToCoimageWithGivenCoimage", "AstrictionToCoimageWithGivenCoimageObject", "2023.03.29" );
InstallDeprecatedAlias( "UniversalMorphismIntoCoimageWithGivenCoimage", "UniversalMorphismIntoCoimageWithGivenCoimageObject", "2023.03.29" );
InstallDeprecatedAlias( "AddCoimage", "AddCoimageObject", "2023.03.29" );
InstallDeprecatedAlias( "AddCoimageProjectionWithGivenCoimage", "AddCoimageProjectionWithGivenCoimageObject", "2023.03.29" );
InstallDeprecatedAlias( "AddAstrictionToCoimageWithGivenCoimage", "AddAstrictionToCoimageWithGivenCoimageObject", "2023.03.29" );
InstallDeprecatedAlias( "AddUniversalMorphismIntoCoimageWithGivenCoimage", "AddUniversalMorphismIntoCoimageWithGivenCoimageObject", "2023.03.29" );

##
InstallMethod( @__MODULE__,  MorphismFromCoimageToImage,
               [ IsCapCategoryMorphism ],
               
  function( morphism )
    
    return MorphismFromCoimageToImageWithGivenObjects( CoimageObject( morphism ), morphism, ImageObject( morphism ) );
    
end );

##
InstallMethod( @__MODULE__,  InverseMorphismFromCoimageToImage,
               [ IsCapCategoryMorphism ],
               
  function( morphism )
    
    return InverseMorphismFromCoimageToImageWithGivenObjects( CoimageObject( morphism ), morphism, ImageObject( morphism ) );
    
end );

CAP_INTERNAL_ADD_REPLACEMENTS_FOR_METHOD_RECORD(
  rec(
    MorphismFromCoimageToImage =
      [ [ "MorphismFromCoimageToImageWithGivenObjects", 1 ],
        [ "CoimageObject", 1 ],
        [ "ImageObject", 1 ] ],
    InverseMorphismFromCoimageToImage =
      [ [ "InverseMorphismFromCoimageToImageWithGivenObjects", 1 ],
        [ "CoimageObject", 1 ],
        [ "ImageObject", 1 ] ],
  )
 );


####################################
##
## Homology object
##
####################################

####################################
## Convenience methods
####################################

##
InstallMethod( @__MODULE__,  HomologyObjectFunctorial,
              [ IsCapCategoryMorphism, IsCapCategoryMorphism, IsCapCategoryMorphism, IsCapCategoryMorphism, IsCapCategoryMorphism ],
              
  function( alpha, beta, epsilon, gamma, delta )
    
    return HomologyObjectFunctorialWithGivenHomologyObjects(
      HomologyObject( alpha, beta ),
      [ alpha, beta, epsilon, gamma, delta ],
      HomologyObject( gamma, delta )
    );
    
end );

####################################
##
## Scheme for Universal Object
##
####################################

####################################
## Add Operations
####################################

####################################
## Attributes
####################################

####################################
## Implied Operations
####################################

