# SPDX-License-Identifier: GPL-2.0-or-later
# CAP: Categories, Algorithms, Programming
#
# Implementations
#
#! @Chapter Universal Objects

####################################
##
## Coproduct and Pushout
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
@InstallMethod( Coproduct,
               [ IsCapCategoryObject, IsCapCategoryObject ],
               
  function( object_1, object_2 )
    
    return Coproduct( CapCategory( object_1 ), [ object_1, object_2 ] );
    
end );

##
@InstallMethod( Coproduct,
               [ IsCapCategoryObject, IsCapCategoryObject, IsCapCategoryObject ],
               
  function( object_1, object_2, object_3 )
    
    return Coproduct( CapCategory( object_1 ), [ object_1, object_2, object_3 ] );
    
end );

####################################
##
## Direct Product and FiberProduct
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
@InstallMethod( DirectProductOp,
               [ IsList, IsCapCategoryObject ],
               
  function( diagram, object )
    
    return DirectProductOp( CapCategory( object ), diagram );
    
end );

##
# compatibility with GAP's DirectProduct function
@InstallMethod( DirectProductOp,
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
@InstallMethod( DirectSumOp,
               [ IsList, IsCapCategoryObject ],
               
  function( diagram, object )
    
    return DirectSumOp( CapCategory( object ), diagram );
    
end );

##
# compatibility with GAP's DirectSum function
@InstallMethod( DirectSumOp,
               [ IsList, IsCapCategory ],
               
  function( category_and_diagram, category )
    local diagram;
    
    diagram = category_and_diagram[2];
    
    if (!( @IsBound( category.supports_empty_limits ) && category.supports_empty_limits == true ) && diagram == [ ])
        return ZeroObject( category );
    end;
    
    return DirectSumOp( category, diagram );
    
end );

# usually the type signatures should be part of the gd file, but `CapJitAddTypeSignature` is not available there
CapJitAddTypeSignature( "DirectSumFunctorial", [ IsCapCategory, IsList ], function ( input_types )
    
    return CapJitDataTypeOfMorphismOfCategory( input_types[1].category );
    
end );

####################################
## Add methods
####################################


####################################
## Categorical methods
####################################

# convenience
##
@InstallMethod( MorphismBetweenDirectSums,
               [ IsList ],
               
  function( morphism_matrix )
    local nr_rows, nr_cols;
    
    nr_rows = Size( morphism_matrix );
    
    if (nr_rows == 0)
        
        Error( "The given matrix must not be empty" );
        
    end;
    
    nr_cols = Size( morphism_matrix[1] );
    
    if (nr_cols == 0)
        
        Error( "The given matrix must not be empty" );
        
    end;
    
    return MorphismBetweenDirectSums( CapCategory( morphism_matrix[1,1] ),
             List( morphism_matrix, row -> Source( row[1] ) ),
             morphism_matrix,
             List( morphism_matrix[1], col -> Range( col ) )
           );
end );

##
@InstallMethod( MorphismBetweenDirectSums,
                    [ IsCapCategory, IsList ],
               
  function( cat, morphism_matrix )
    local nr_rows, nr_cols;
    
    nr_rows = Size( morphism_matrix );
    
    if (nr_rows == 0)
        
        Error( "The given matrix must not be empty" );
        
    end;
    
    nr_cols = Size( morphism_matrix[1] );
    
    if (nr_cols == 0)
        
        Error( "The given matrix must not be empty" );
        
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
    
    if (IsCapCategory( arg[1] ))
        
        return CallFuncList( EqualizerOp, arg );
        
    end;
    
    if (Length( arg ) == 1 &&
       IsList( arg[1] ) &&
       ForAll( arg[1], IsCapCategoryMorphism ))
       
       return EqualizerOp( CapCategory( arg[1][1] ), arg[1] );
       
    end;
    
    if (Length( arg ) == 2 &&
       IsCapCategoryObject( arg[1] ) &&
       IsList( arg[2] ) &&
       ForAll( arg[2], IsCapCategoryMorphism ))
       
       return EqualizerOp( CapCategory( arg[1] ), arg[1], arg[2] );
       
    end;
    
    return EqualizerOp( CapCategory( arg[1] ), arg );
    
end );

##
@InstallMethod( EqualizerOp,
        [ IsList ],
        
  function ( list_of_morphisms )
    
    if (IsEmpty( list_of_morphisms ))
        
        Error( "the list of morphisms must not be empty" );
        
    end;
    
    return EqualizerOp( CapCategory( list_of_morphisms[1] ), list_of_morphisms );
    
end );

@InstallMethod( EqualizerOp,
        [ IsCapCategory, IsList ],
        
  function ( cat, list_of_morphisms )
    
    if (IsEmpty( list_of_morphisms ))
        
        Error( "the list of morphisms must not be empty" );
        
    end;
    
    return EqualizerOp( cat, Source( list_of_morphisms[1] ), list_of_morphisms );
    
end );

##
@InstallMethod( EmbeddingOfEqualizer,
        [ IsList ],
        
  function ( list_of_morphisms )
    
    if (IsEmpty( list_of_morphisms ))
        
        Error( "the list of morphisms must not be empty" );
        
    end;
    
    return EmbeddingOfEqualizer( CapCategory( list_of_morphisms[1] ), list_of_morphisms );
    
end );

@InstallMethod( EmbeddingOfEqualizer,
        [ IsCapCategory, IsList ],
        
  function ( cat, list_of_morphisms )
    
    if (IsEmpty( list_of_morphisms ))
        
        Error( "the list of morphisms must not be empty" );
        
    end;
    
    return EmbeddingOfEqualizer( cat, Source( list_of_morphisms[1] ), list_of_morphisms );
    
end );

##
@InstallMethod( EmbeddingOfEqualizerWithGivenEqualizer,
        [ IsList, IsCapCategoryObject ],
        
  function ( list_of_morphisms, E )
    
    if (IsEmpty( list_of_morphisms ))
        
        Error( "the list of morphisms must not be empty" );
        
    end;
    
    return EmbeddingOfEqualizerWithGivenEqualizer( CapCategory( list_of_morphisms[1] ), list_of_morphisms, E );
    
end );

@InstallMethod( EmbeddingOfEqualizerWithGivenEqualizer,
        [ IsCapCategory, IsList, IsCapCategoryObject ],
        
  function ( cat, list_of_morphisms, E )
    
    if (IsEmpty( list_of_morphisms ))
        
        Error( "the list of morphisms must not be empty" );
        
    end;
    
    return EmbeddingOfEqualizerWithGivenEqualizer( cat, Source( list_of_morphisms[1] ), list_of_morphisms, E );
    
end );

##
@InstallMethod( MorphismFromEqualizerToSink,
        [ IsList ],
        
  function ( list_of_morphisms )
    
    if (IsEmpty( list_of_morphisms ))
        
        Error( "the list of morphisms must not be empty" );
        
    end;
    
    return MorphismFromEqualizerToSink( CapCategory( list_of_morphisms[1] ), list_of_morphisms );
    
end );

@InstallMethod( MorphismFromEqualizerToSink,
        [ IsCapCategory, IsList ],
        
  function ( cat, list_of_morphisms )
    
    if (IsEmpty( list_of_morphisms ))
        
        Error( "the list of morphisms must not be empty" );
        
    end;
    
    return MorphismFromEqualizerToSink( cat, Source( list_of_morphisms[1] ), list_of_morphisms );
    
end );

##
@InstallMethod( MorphismFromEqualizerToSinkWithGivenEqualizer,
        [ IsList, IsCapCategoryObject ],
        
  function ( list_of_morphisms, E )
    
    if (IsEmpty( list_of_morphisms ))
        
        Error( "the list of morphisms must not be empty" );
        
    end;
    
    return MorphismFromEqualizerToSinkWithGivenEqualizer( CapCategory( list_of_morphisms[1] ), list_of_morphisms, E );
    
end );

@InstallMethod( MorphismFromEqualizerToSinkWithGivenEqualizer,
        [ IsCapCategory, IsList, IsCapCategoryObject ],
        
  function ( cat, list_of_morphisms, E )
    
    if (IsEmpty( list_of_morphisms ))
        
        Error( "the list of morphisms must not be empty" );
        
    end;
    
    return MorphismFromEqualizerToSinkWithGivenEqualizer( cat, Source( list_of_morphisms[1] ), list_of_morphisms, E );
    
end );

##
@InstallMethod( UniversalMorphismIntoEqualizer,
        [ IsList, IsCapCategoryMorphism ],
        
  function ( list_of_morphisms, tau )
    
    if (IsEmpty( list_of_morphisms ))
        
        Error( "the list of morphisms must not be empty" );
        
    end;
    
    return UniversalMorphismIntoEqualizer( CapCategory( list_of_morphisms[1] ), list_of_morphisms, tau );
    
end );

@InstallMethod( UniversalMorphismIntoEqualizer,
        [ IsCapCategory, IsList, IsCapCategoryMorphism ],
        
  function ( cat, list_of_morphisms, tau )
    
    if (IsEmpty( list_of_morphisms ))
        
        Error( "the list of morphisms must not be empty" );
        
    end;
    
    return UniversalMorphismIntoEqualizer( cat, Source( list_of_morphisms[1] ), list_of_morphisms, tau );
    
end );

##
@InstallMethod( UniversalMorphismIntoEqualizerWithGivenEqualizer,
        [ IsList, IsCapCategoryMorphism, IsCapCategoryObject ],
        
  function ( list_of_morphisms, tau, E )
    
    if (IsEmpty( list_of_morphisms ))
        
        Error( "the list of morphisms must not be empty" );
        
    end;
    
    return UniversalMorphismIntoEqualizerWithGivenEqualizer( CapCategory( list_of_morphisms[1] ), list_of_morphisms, tau, E );
    
end );

@InstallMethod( UniversalMorphismIntoEqualizerWithGivenEqualizer,
        [ IsCapCategory, IsList, IsCapCategoryMorphism, IsCapCategoryObject ],
        
  function ( cat, list_of_morphisms, tau, E )
    
    if (IsEmpty( list_of_morphisms ))
        
        Error( "the list of morphisms must not be empty" );
        
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
    
    if (IsCapCategory( arg[1] ))
        
        return CallFuncList( FiberProductOp, arg );
        
    end;
    
    if (Length( arg ) == 1 &&
       IsList( arg[1] ) &&
       ForAll( arg[1], IsCapCategoryMorphism ))
       
       return FiberProductOp( CapCategory( arg[1][1] ), arg[1] );
       
     end;
    
    return FiberProductOp( CapCategory( arg[ 1 ] ), arg );
    
end );

##
@InstallMethod( FiberProductEmbeddingInDirectProduct,
        [ IsList ],
        
  function( diagram )
    
    return FiberProductEmbeddingInDirectProduct( CapCategory( diagram[1] ), diagram );
    
end );

##
@InstallMethod( FiberProductEmbeddingInDirectProduct,
        [ IsCapCategory, IsList ],
        
  function( cat, diagram )
    local sources_of_diagram, test_source;
    
    sources_of_diagram = List( diagram, Source );
    
    test_source = List( (1):(Length( diagram )), i -> ProjectionInFactorOfFiberProduct( cat, diagram, i ) );
    
    return UniversalMorphismIntoDirectProduct( cat, sources_of_diagram, FiberProduct( cat, diagram ), test_source );
    
end );

##
@InstallMethod( FiberProductEmbeddingInDirectSum,
        [ IsList ],
        
  function( diagram )
    
    return FiberProductEmbeddingInDirectSum( CapCategory( diagram[1] ), diagram );
    
end );

##
@InstallMethod( FiberProductEmbeddingInDirectSum,
        [ IsCapCategory, IsList ],
        
  function( cat, diagram )
    local sources_of_diagram, test_source;
    
    sources_of_diagram = List( diagram, Source );
    
    test_source = List( (1):(Length( diagram )), i -> ProjectionInFactorOfFiberProduct( cat, diagram, i ) );
    
    return UniversalMorphismIntoDirectSum( cat, sources_of_diagram, FiberProduct( cat, diagram ), test_source );
    
end );

CAP_INTERNAL_ADD_REPLACEMENTS_FOR_METHOD_RECORD(
  @rec(
    FiberProductEmbeddingInDirectSum =
      [ [ "ProjectionInFactorOfFiberProduct", 2 ],
        [ "UniversalMorphismIntoDirectSum", 1 ],
        [ "FiberProduct", 1 ] ],
  )
);

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
    
    if (IsCapCategory( arg[1] ))
        
        return CallFuncList( CoequalizerOp, arg );
        
    end;
    
    if (Length( arg ) == 1 &&
       IsList( arg[1] ) &&
       ForAll( arg[1], IsCapCategoryMorphism ))
       
       return CoequalizerOp( CapCategory( arg[1][1] ), arg[1] );
       
     end;
    
    if (Length( arg ) == 2 &&
       IsCapCategoryObject( arg[1] ) &&
       IsList( arg[2] ) &&
       ForAll( arg[2], IsCapCategoryMorphism ))
       
       return CoequalizerOp( CapCategory( arg[1] ), arg[1], arg[2] );
       
     end;
    
    return CoequalizerOp( CapCategory( arg[ 1 ] ), arg );
    
end );

##
@InstallMethod( CoequalizerOp,
        [ IsList ],
        
  function ( list_of_morphisms )
    
    if (IsEmpty( list_of_morphisms ))
        
        Error( "the list of morphisms must not be empty" );
        
    end;
    
    return CoequalizerOp( CapCategory( list_of_morphisms[1] ), list_of_morphisms );
    
end );

@InstallMethod( CoequalizerOp,
        [ IsCapCategory, IsList ],
        
  function ( cat, list_of_morphisms )
    
    if (IsEmpty( list_of_morphisms ))
        
        Error( "the list of morphisms must not be empty" );
        
    end;
    
    return CoequalizerOp( cat, Range( list_of_morphisms[1] ), list_of_morphisms );
    
end );

##
@InstallMethod( ProjectionOntoCoequalizer,
        [ IsList ],
        
  function ( list_of_morphisms )
    
    if (IsEmpty( list_of_morphisms ))
        
        Error( "the list of morphisms must not be empty" );
        
    end;
    
    return ProjectionOntoCoequalizer( CapCategory( list_of_morphisms[1] ), list_of_morphisms );
    
end );

@InstallMethod( ProjectionOntoCoequalizer,
        [ IsCapCategory, IsList ],
        
  function ( cat, list_of_morphisms )
    
    if (IsEmpty( list_of_morphisms ))
        
        Error( "the list of morphisms must not be empty" );
        
    end;
    
    return ProjectionOntoCoequalizer( cat, Range( list_of_morphisms[1] ), list_of_morphisms );
    
end );

##
@InstallMethod( ProjectionOntoCoequalizerWithGivenCoequalizer,
        [ IsList, IsCapCategoryObject ],
        
  function ( list_of_morphisms, E )
    
    if (IsEmpty( list_of_morphisms ))
        
        Error( "the list of morphisms must not be empty" );
        
    end;
    
    return ProjectionOntoCoequalizerWithGivenCoequalizer( CapCategory( list_of_morphisms[1] ), list_of_morphisms, E );
    
end );

@InstallMethod( ProjectionOntoCoequalizerWithGivenCoequalizer,
        [ IsCapCategory, IsList, IsCapCategoryObject ],
        
  function ( cat, list_of_morphisms, E )
    
    if (IsEmpty( list_of_morphisms ))
        
        Error( "the list of morphisms must not be empty" );
        
    end;
    
    return ProjectionOntoCoequalizerWithGivenCoequalizer( cat, Range( list_of_morphisms[1] ), list_of_morphisms, E );
    
end );

##
@InstallMethod( MorphismFromSourceToCoequalizer,
        [ IsList ],
        
  function ( list_of_morphisms )
    
    if (IsEmpty( list_of_morphisms ))
        
        Error( "the list of morphisms must not be empty" );
        
    end;
    
    return MorphismFromSourceToCoequalizer( CapCategory( list_of_morphisms[1] ), list_of_morphisms );
    
end );

@InstallMethod( MorphismFromSourceToCoequalizer,
        [ IsCapCategory, IsList ],
        
  function ( cat, list_of_morphisms )
    
    if (IsEmpty( list_of_morphisms ))
        
        Error( "the list of morphisms must not be empty" );
        
    end;
    
    return MorphismFromSourceToCoequalizer( cat, Range( list_of_morphisms[1] ), list_of_morphisms );
    
end );

##
@InstallMethod( MorphismFromSourceToCoequalizerWithGivenCoequalizer,
        [ IsList, IsCapCategoryObject ],
        
  function ( list_of_morphisms, E )
    
    if (IsEmpty( list_of_morphisms ))
        
        Error( "the list of morphisms must not be empty" );
        
    end;
    
    return MorphismFromSourceToCoequalizerWithGivenCoequalizer( CapCategory( list_of_morphisms[1] ), list_of_morphisms, E );
    
end );

@InstallMethod( MorphismFromSourceToCoequalizerWithGivenCoequalizer,
        [ IsCapCategory, IsList, IsCapCategoryObject ],
        
  function ( cat, list_of_morphisms, E )
    
    if (IsEmpty( list_of_morphisms ))
        
        Error( "the list of morphisms must not be empty" );
        
    end;
    
    return MorphismFromSourceToCoequalizerWithGivenCoequalizer( cat, Range( list_of_morphisms[1] ), list_of_morphisms, E );
    
end );

##
@InstallMethod( UniversalMorphismFromCoequalizer,
        [ IsList, IsCapCategoryMorphism ],
        
  function ( list_of_morphisms, tau )
    
    if (IsEmpty( list_of_morphisms ))
        
        Error( "the list of morphisms must not be empty" );
        
    end;
    
    return UniversalMorphismFromCoequalizer( CapCategory( list_of_morphisms[1] ), list_of_morphisms, tau );
    
end );

@InstallMethod( UniversalMorphismFromCoequalizer,
        [ IsCapCategory, IsList, IsCapCategoryMorphism ],
        
  function ( cat, list_of_morphisms, tau )
    
    if (IsEmpty( list_of_morphisms ))
        
        Error( "the list of morphisms must not be empty" );
        
    end;
    
    return UniversalMorphismFromCoequalizer( cat, Range( list_of_morphisms[1] ), list_of_morphisms, tau );
    
end );

##
@InstallMethod( UniversalMorphismFromCoequalizerWithGivenCoequalizer,
        [ IsList, IsCapCategoryMorphism, IsCapCategoryObject ],
        
  function ( list_of_morphisms, tau, E )
    
    if (IsEmpty( list_of_morphisms ))
        
        Error( "the list of morphisms must not be empty" );
        
    end;
    
    return UniversalMorphismFromCoequalizerWithGivenCoequalizer( CapCategory( list_of_morphisms[1] ), list_of_morphisms, tau, E );
    
end );

@InstallMethod( UniversalMorphismFromCoequalizerWithGivenCoequalizer,
        [ IsCapCategory, IsList, IsCapCategoryMorphism, IsCapCategoryObject ],
        
  function ( cat, list_of_morphisms, tau, E )
    
    if (IsEmpty( list_of_morphisms ))
        
        Error( "the list of morphisms must not be empty" );
        
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
@InstallMethod( Pushout,
               [ IsCapCategoryMorphism, IsCapCategoryMorphism ],
               
  function( mor1, mor2 )
    
    return Pushout( CapCategory( mor1 ), [ mor1, mor2 ] );
    
end );

##
@InstallMethod( PushoutProjectionFromCoproduct,
        [ IsList ],
                    
  function( diagram )
    
    return PushoutProjectionFromCoproduct( CapCategory( diagram[1] ), diagram );
    
end );

##
@InstallMethod( PushoutProjectionFromCoproduct,
        [ IsCapCategory, IsList ],
                    
  function( cat, diagram )
    local ranges_of_diagram, test_sink;
    
    ranges_of_diagram = List( diagram, Range );
    
    test_sink = List( (1):(Length( diagram )), i -> InjectionOfCofactorOfPushout( cat, diagram, i ) );
    
    return UniversalMorphismFromCoproduct( cat, ranges_of_diagram, Pushout( cat, diagram ), test_sink );
    
end );

##
@InstallMethod( PushoutProjectionFromDirectSum,
        [ IsList ],
                    
  function( diagram )
    
    return PushoutProjectionFromDirectSum( CapCategory( diagram[1] ), diagram );
    
end );

##
@InstallMethod( PushoutProjectionFromDirectSum,
        [ IsCapCategory, IsList ],
                    
  function( cat, diagram )
    local ranges_of_diagram, test_sink;
    
    ranges_of_diagram = List( diagram, Range );
    
    test_sink = List( (1):(Length( diagram )), i -> InjectionOfCofactorOfPushout( cat, diagram, i ) );
    
    return UniversalMorphismFromDirectSum( cat, ranges_of_diagram, Pushout( cat, diagram ), test_sink );
    
end );

CAP_INTERNAL_ADD_REPLACEMENTS_FOR_METHOD_RECORD(
  @rec(
    PushoutProjectionFromDirectSum =
      [ [ "InjectionOfCofactorOfPushout", 2 ],
        [ "UniversalMorphismFromDirectSum", 1 ],
        [ "Pushout", 1 ] ],
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
@InstallMethod( HomologyObjectFunctorial,
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

