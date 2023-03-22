# SPDX-License-Identifier: GPL-2.0-or-later
# CAP: Categories, Algorithms, Programming
#
# Implementations
#
# backwards compatibility
@BindGlobal( "IsCapCategoryAsCatObjectRep", IsCapCategoryAsCatObject );

# backwards compatibility
@BindGlobal( "IsCapFunctorRep", IsCapFunctor );

# backwards compatibility
@BindGlobal( "IsCapNaturalTransformationRep", IsCapNaturalTransformation );

@BindGlobal( "TheTypeOfCapNaturalTransformations",
        NewType( TheFamilyOfCapCategoryTwoCells,
                IsCapNaturalTransformation ) );

##
@BindGlobal( "CAP_INTERNAL_CREATE_Cat",
               
  function(  )
    local cat;
    
    cat = CreateCapCategory( "Cat", IsCapCategory, IsCapCategoryAsCatObject, IsCapFunctor, IsCapNaturalTransformation );
    
    cat.category_as_first_argument = false;
    
    INSTALL_CAP_CAT_FUNCTIONS( cat );
    
    return cat;
    
end );

##
InstallMethod( @__MODULE__,  AsCatObject,
               [ IsCapCategory ],
  
  function( category )
    local cat_obj;
    
    cat_obj = CreateCapCategoryObjectWithAttributes( CapCat,
                                        AsCapCategory, category );
    
    SetIsWellDefined( cat_obj, true );
    
    return cat_obj;
    
end );

@BindGlobal( "CAP_INTERNAL_NICE_FUNCTOR_INPUT_LIST",
  
  function( list )
    
    return List( (1):(Length( list )), function ( i )
        
        if IsCapCategory( list[ i ] )
            return [ list[ i ], false ]; ##true means opposite
        elseif IsCapCategoryAsCatObject( list[ i ] )
            return [ AsCapCategory( list[ i ] ), false ];
        elseif IsList( list[ i ] ) && Length( list[ i ] ) == 2 && IsCapCategory( list[ i ][ 1 ] ) && ( !IsBool( list[i][2] ) )
            return [ list[ i ][1], true ];
        elseif IsList( list[ i ] ) && Length( list[ i ] ) == 2 && IsCapCategoryAsCatObject( list[ i ][ 1 ] ) && ( !IsBool( list[i][2] ) )
            return [ AsCapCategory( list[ i ][ 1 ] ), true ];
        else
            return list[i];
        end;
        
    end );
    
end );

@BindGlobal( "CAP_INTERNAL_CREATE_FUNCTOR_SOURCE",
  
  function( list )
    local source_list, i;
    
    source_list = [ ];
    
    for i in list
        
        if i[ 2 ] == false
            Add( source_list, i[ 1 ] );
        else
            Add( source_list, Opposite( i[ 1 ] ) );
        end;
        
    end;
    
    return CallFuncList( Product, source_list );
    
end );

##
InstallMethod( @__MODULE__,  CapFunctor,
               [ IsString, IsList, IsCapCategory ],
               
  function( name, source_list, range )
    local source, functor, objectified_functor;
    
    functor = rec( );
    
    source_list = CAP_INTERNAL_NICE_FUNCTOR_INPUT_LIST( source_list );
    
    functor.input_source_list = source_list;
    
    functor.number_arguments = Length( source_list );
    
    source = CAP_INTERNAL_CREATE_FUNCTOR_SOURCE( source_list );
    
    objectified_functor = ObjectifyMorphismWithSourceAndRangeForCAPWithAttributes( functor, CapCat,
                                                    AsCatObject( source ),
                                                    AsCatObject( range ),
                                                    Name, name,
                                                    InputSignature, source_list );
    
    return objectified_functor;
    
end );

##
InstallMethod( @__MODULE__,  CapFunctor,
               [ IsString, IsList, IsCapCategoryAsCatObject ],
               
  function( name, source_list, range )
    
    return CapFunctor( name, source_list, AsCapCategory( range ) );
    
end );

##
InstallMethod( @__MODULE__,  CapFunctor,
               [ IsString, IsCapCategory, IsCapCategory ],
               
  function( name, source, range )
    
    return CapFunctor( name, [ source ], range );
    
end );

##
InstallMethod( @__MODULE__,  CapFunctor,
               [ IsString, IsCapCategoryAsCatObject, IsCapCategory ],
               
  function( name, source, range )
    
    return CapFunctor( name, [ source ], range );
    
end );

##
InstallMethod( @__MODULE__,  CapFunctor,
               [ IsString, IsCapCategory, IsCapCategoryAsCatObject ],
               
  function( name, source, range )
    
    return CapFunctor( name, [ source ], AsCapCategory( range ) );
    
end );

##
InstallMethod( @__MODULE__,  CapFunctor,
               [ IsString, IsCapCategoryAsCatObject, IsCapCategoryAsCatObject ],
               
  function( name, source, range )
    
    return CapFunctor( name, [ source ], AsCapCategory( range ) );
    
end );

##
InstallMethod( @__MODULE__,  SourceOfFunctor,
          [ IsCapFunctor ],
  
  F -> AsCapCategory( Source( F ) )
);

##
InstallMethod( @__MODULE__,  RangeOfFunctor,
          [ IsCapFunctor ],
  
  F -> AsCapCategory( Range( F ) )
);

@BindGlobal( "CAP_INTERNAL_SANITIZE_FUNC_LIST_FOR_FUNCTORS",
  
  function( list )
    local sanitized_list, i;
    
    sanitized_list = [ ];
    
    for i in list
        
        if IsFunction( i )
            
            Add( sanitized_list, [ i, [ ] ] );
            
        elseif IsList( i ) && Length( i ) == 1
            
            Add( sanitized_list, [ i[ 1 ], [ ] ] );
            
        elseif IsList( i ) && Length( i ) == 2
            
            Add( sanitized_list, i );
            
        else
            
            Error( "wrong function input" );
            
        end;
        
    end;
    
    return sanitized_list;
    
end );

@BindGlobal( "CAP_INTERNAL_FUNCTOR_CREATE_FILTER_LIST",
  
  function( functor, type )
    local filter_list;
    
    filter_list = List( InputSignature( functor ), i -> i[ 1 ] );
    
    if type == "object"
        
        filter_list = List( filter_list, ObjectFilter );
        
    elseif type == "morphism"
        
        filter_list = List( filter_list, MorphismFilter );
        
    elseif type == "twocell"
        
        filter_list = List( filter_list, TwoCellFilter );
        
    else
        
        ## Should never be reached
        Error( "unrecognized type" );
        
    end;
    
    return filter_list;
    
end );

@BindGlobal( "CAP_INTERNAL_INSTALL_FUNCTOR_OPERATION",
  
  function( operation, func_list, filter_list, cache )
    local current_filter_list, current_methend;
    
    for current_method in func_list
        
        current_filter_list = CAP_INTERNAL_MERGE_FILTER_LISTS( filter_list, current_method[ 2 ] );
        
        InstallMethodWithCache( operation, current_filter_list, current_method[ 1 ]; Cache = cache );
        
    end;
    
end );

InstallMethod( @__MODULE__,  FunctorObjectOperation,
               [ IsCapFunctor ],
               
  function( functor )
    local filter_list;
    
    filter_list = CAP_INTERNAL_FUNCTOR_CREATE_FILTER_LIST( functor, "object" );
    
    return NewOperation( Concatenation( "CAP_FUNCTOR_", Name( functor ), "_OBJECT_OPERATION" ), filter_list );
    
end );

InstallMethod( @__MODULE__,  FunctorMorphismOperation,
               [ IsCapFunctor ],
               
  function( functor )
    local filter_list, range_cat;
    
    filter_list = CAP_INTERNAL_FUNCTOR_CREATE_FILTER_LIST( functor, "morphism" );
    
    range_cat = AsCapCategory( Range( functor ) );
    
    filter_list = Concatenation( [ ObjectFilter( range_cat ) ], filter_list, [ ObjectFilter( range_cat ) ] );
    
    return NewOperation( Concatenation( "CAP_FUNCTOR_", Name( functor ), "_MORPHISM_OPERATION" ), filter_list );
    
end );

##
InstallMethod( @__MODULE__,  AddObjectFunction,
               [ IsCapFunctor, IsList ],
               
  function( functor, func_list )
    local sanitized_list, filter_list, operation;
    
    sanitized_list = CAP_INTERNAL_SANITIZE_FUNC_LIST_FOR_FUNCTORS( func_list );
    
    filter_list = CAP_INTERNAL_FUNCTOR_CREATE_FILTER_LIST( functor, "object" );
    
    if !IsBound( functor.object_function_list )
        
        functor.object_function_list = sanitized_list;
        
    else
        
        Append( functor.object_function_list, sanitized_list );
        
    end;
    
    operation = FunctorObjectOperation( functor );
    
    CAP_INTERNAL_INSTALL_FUNCTOR_OPERATION( operation, sanitized_list, filter_list, ObjectCache( functor ) );
    
end );

##
InstallMethod( @__MODULE__,  AddObjectFunction,
               [ IsCapFunctor, IsFunction ],
               
  function( functor, func )
    
    AddObjectFunction( functor, [ [ func, [ ] ] ] );
    
end );

##
InstallMethod( @__MODULE__,  AddMorphismFunction,
               [ IsCapFunctor, IsList ],
               
  function( functor, func_list )
    local sanitized_list, filter_list, operation, range_cat;
    
    sanitized_list = CAP_INTERNAL_SANITIZE_FUNC_LIST_FOR_FUNCTORS( func_list );
    
    filter_list = CAP_INTERNAL_FUNCTOR_CREATE_FILTER_LIST( functor, "morphism" );
    
    range_cat = AsCapCategory( Range( functor ) );
    
    filter_list = Concatenation( [ ObjectFilter( range_cat ) ], filter_list, [ ObjectFilter( range_cat ) ] );
    
    if !IsBound( functor.morphism_function_list )
        
        functor.morphism_function_list = sanitized_list;
        
    else
        
        Append( functor.morphism_function_list, sanitized_list );
        
    end;
    
    operation = FunctorMorphismOperation( functor );
    
    CAP_INTERNAL_INSTALL_FUNCTOR_OPERATION( operation, sanitized_list, filter_list, MorphismCache( functor ) );
    
end );

##
InstallMethod( @__MODULE__,  AddMorphismFunction,
               [ IsCapFunctor, IsFunction ],
               
  function( functor, func )
    
    AddMorphismFunction( functor, [ [ func, [ ] ] ] );
    
end );

##
InstallMethod( @__MODULE__,  ObjectCache,
               [ IsCapFunctor ],
               
  function( functor )
    
    return CachingObject( functor.number_arguments );
    
end );

##
InstallMethod( @__MODULE__,  MorphismCache,
               [ IsCapFunctor ],
               
  function( functor )
    
    return CachingObject( functor.number_arguments + 2 );
    
end );

##
@InstallGlobalFunction( ApplyFunctor,
               
  function( functor, arguments... )
    local is_object, cache, cache_return, computed_value,
          source_list, source_value, range_list, range_value, i, tmp, source_category, range_category, input_signature;
    
    source_category = AsCapCategory( Source( functor ) );
    range_category = AsCapCategory( Range( functor ) );
    input_signature = InputSignature( functor );

    # n-ary functor && unary argument (possibly ⥉ product category)
    if Length( arguments ) == 1 && functor.number_arguments > 1
        
        if source_category.input_sanity_check_level > 0
            CAP_INTERNAL_ASSERT_IS_CELL_OF_CATEGORY( arguments[ 1 ], source_category, [ "the argument passed to the functor named \033[1m", Name(functor), "\033[0m" ] );
        end;

        arguments = ShallowCopy( Components( arguments[ 1 ] ) );
        
        for i in (1):(Length( arguments ))
            if input_signature[ i ][ 2 ] == true
                arguments[ i ] = Opposite( arguments[ i ] );
            end;
        end;
        
    elseif Length( arguments ) == 1 && input_signature[ 1 ][ 2 ] == true
        if source_category.input_sanity_check_level > 0
            CAP_INTERNAL_ASSERT_IS_CELL_OF_CATEGORY( arguments[ 1 ], false, [ "the argument passed to the functor named \033[1m", Name(functor), "\033[0m" ] );
        end;

        if IsIdenticalObj( CapCategory( arguments[ 1 ] ), Opposite( input_signature[ 1 ][ 1 ] ) )
            arguments[ 1 ] = Opposite( arguments[ 1 ] );
        end;
    elseif Length( arguments ) == 1
        if source_category.input_sanity_check_level > 0
            CAP_INTERNAL_ASSERT_IS_CELL_OF_CATEGORY( arguments[ 1 ], source_category, [ "the argument passed to the functor named \033[1m", Name(functor), "\033[0m" ] );
        end;
    end;
    
    
    if IsCapCategoryObject( arguments[ 1 ] )
        
        if source_category.input_sanity_check_level > 0
            if !Length( input_signature ) == Length( arguments )
                Error( Concatenation("expected number of arguments (=", StringGAP( Length( input_signature ) ), ") does !coincide with the provided number of arguments (=", StringGAP( Length( arguments ) ), ")" ) );
            end;

            for i in (1):(Length( input_signature ))
                CAP_INTERNAL_ASSERT_IS_OBJECT_OF_CATEGORY( arguments[ i ], input_signature[ i ][ 1 ], [ "the ", StringGAP(i), "-th argument passed to the functor named \033[1m", Name(functor), "\033[0m" ] );
            end;
        end;
        
        computed_value = CallFuncList( FunctorObjectOperation( functor ), arguments );

        if range_category.output_sanity_check_level > 0 && !range_category.add_primitive_output
            CAP_INTERNAL_ASSERT_IS_OBJECT_OF_CATEGORY( computed_value, range_category, [ "the result of the object function of the functor named \033[1m", Name(functor), "\033[0m" ] );
        end;
        
        if range_category.add_primitive_output
            
            AddObject( range_category, computed_value );
            
        end;
        
    elseif IsCapCategoryMorphism( arguments[ 1 ] )

        if source_category.input_sanity_check_level > 0
            if !Length( input_signature ) == Length( arguments )
                Error( Concatenation("expected number of arguments (=", StringGAP( Length( input_signature ) ), ") does !coincide with the provided number of arguments (=", StringGAP( Length( arguments ) ), ")" ) );
            end;

            for i in (1):(Length( input_signature ))
                CAP_INTERNAL_ASSERT_IS_MORPHISM_OF_CATEGORY( arguments[ i ], input_signature[ i ][ 1 ], [ "the ", StringGAP(i), "-th argument passed to the functor named \033[1m", Name(functor), "\033[0m" ] );
            end;
        end;
        
        source_list = List( arguments, Source );
        
        range_list = List( arguments, Range );
        
        for i in (1):(Length( arguments ))
            if InputSignature( functor )[ i ][ 2 ] == true
                tmp = source_list[ i ];
                source_list[ i ] = range_list[ i ];
                range_list[ i ] = tmp;
            end;
        end;
        
        source_value = CallFuncList( ApplyFunctor, Concatenation( [ functor ], source_list ) );
        
        range_value = CallFuncList( ApplyFunctor, Concatenation( [ functor ], range_list ) );
        
        computed_value = CallFuncList( FunctorMorphismOperation( functor ), Concatenation( [ source_value ], arguments, [ range_value ] ) );

        if range_category.output_sanity_check_level > 0 && !range_category.add_primitive_output
            CAP_INTERNAL_ASSERT_IS_MORPHISM_OF_CATEGORY( computed_value, range_category, [ "the result of the morphism function of the functor named \033[1m", Name(functor), "\033[0m" ] );
        end;
        
        if range_category.add_primitive_output
            
            AddMorphism( range_category, computed_value );
            
        end;
        
    else
        
        Error( "Second argument of ApplyFunctor must be a category object || morphism" );
        
    end;
    
    return computed_value;
    
end );

@BindGlobal( "INSTALL_CAP_CAT_FUNCTIONS", function ( cat )

##
AddPreCompose( cat,
               
  function( left_functor, right_functor )
    local new_functor;
    
    new_functor = CapFunctor( Concatenation( "Precomposition of ",
                                                 Name( left_functor ),
                                                 " && ",
                                                 Name( right_functor ) ),
                                  AsCapCategory( Source( left_functor ) ),
                                  AsCapCategory( Range( right_functor ) ) );
    
    AddObjectFunction( new_functor,
      
      obj -> ApplyFunctor( right_functor, ApplyFunctor( left_functor, obj ) )
      
    );
    
    AddMorphismFunction( new_functor,
      
      function( new_source, morphism, new_range )
        
        return ApplyFunctor( right_functor, ApplyFunctor( left_functor, morphism ) );
        
    end );
    
    return new_functor;
    
end );

##
AddIdentityMorphism( cat,
                     
  function( category )
    local new_functor;
    
    new_functor = CapFunctor( Concatenation( "Identity functor of ", Name( AsCapCategory( category ) ) ),
                                                 category, category );
    
    AddObjectFunction( new_functor,
                       
                       IdFunc );
    
    AddMorphismFunction( new_functor,
                         
      function( arg... ) return arg[ 2 ]; end );
    
    return new_functor;
    
end );

##
AddTerminalObject( cat,
                   
  function( )
    
    return AsCatObject( TerminalCategoryWithSingleObject( ) );
    
end );

##
AddUniversalMorphismIntoTerminalObjectWithGivenTerminalObject( cat,
                               
  function( category, terminal_cat )
    local new_functor;
    
    new_functor = CapFunctor( Concatenation( "The terminal of ", Name( AsCapCategory( category ) ) ), category, terminal_cat );
    
    AddObjectFunction( new_functor,
                       
                       function( arg... ) return UniqueObject( AsCapCategory( terminal_cat ) ); end );
    
    AddMorphismFunction( new_functor,
                         
                         function( arg... ) return UniqueMorphism( AsCapCategory( terminal_cat ) ); end );
    
    return new_functor;
    
end );

##
AddDirectProduct( cat,
                  
  function( object_product_list )
    
    return AsCatObject( CallFuncList( Product, List( object_product_list, AsCapCategory ) ) );
    
end );

##
AddProjectionInFactorOfDirectProductWithGivenDirectProduct( cat,
                            
  function( object_product_list, projection_number, direct_product )
    local projection_functor;
    
    projection_functor = CapFunctor( 
      Concatenation( "Projection into ", StringGAP( projection_number ),"-th factor of ", Name( AsCapCategory( direct_product ) ) ), 
      direct_product, 
      object_product_list[ projection_number ]
    );
    
    AddObjectFunction( projection_functor,
                       
          function( obj )
            
            return obj[ projection_number ];
            
        end );
        
    AddMorphismFunction( projection_functor,
                         
          function( new_source, morphism, new_range )
            
            return morphism[ projection_number ];
            
        end );
        
    return projection_functor;
    
end );

##
AddUniversalMorphismIntoDirectProductWithGivenDirectProduct( cat,
                                       
  function( diagram, test_object, sink, direct_product )
    local name_string, universal_functor;
    
    name_string = Concatenation( 
      "Product functor from ", 
      Name( AsCapCategory( Source( sink[1] ) ) ), 
      " to ", 
      Name( AsCapCategory( direct_product ) ) 
    );
    
    universal_functor = CapFunctor( name_string, Source( sink[1] ), direct_product );
    
    AddObjectFunction( universal_functor,
                       
          function( object )
            local object_list;
            
            object_list = List( sink, F -> ApplyFunctor( F, object ) );
            
            return CallFuncList( Product, object_list );
            
        end );
        
    AddMorphismFunction( universal_functor,
                         
          function( new_source, morphism, new_range )
            local morphism_list;
            
            morphism_list = List( sink, F -> ApplyFunctor( F, morphism ) );
            
            return CallFuncList( Product, morphism_list );
            
        end );
        
    return universal_functor;
    
end );

##
AddVerticalPreCompose( cat,
               
  function( above_transformation, below_transformation )
    local new_natural_transformation;
    
    new_natural_transformation = NaturalTransformation( Concatenation( "Vertical composition of ",
                                                         Name( above_transformation ),
                                                         " && ",
                                                         Name( below_transformation ) ),
                                                         Source( above_transformation ),
                                                         Range( below_transformation ) );
    
    AddNaturalTransformationFunction( new_natural_transformation,
      
      function( source_value, object, range_value )
        
        return PreCompose( ApplyNaturalTransformation( above_transformation, object ),
                           ApplyNaturalTransformation( below_transformation, object ) );
        
      end );
    
    return new_natural_transformation;
    
end );

##
AddHorizontalPreCompose( cat,
  
  function( left_natural_transformation, right_natural_transformation )
    local pre_compose_transfo_functor, pre_compose_functor_transfo;
    
    pre_compose_transfo_functor = 
          HorizontalPreComposeNaturalTransformationWithFunctor( left_natural_transformation, Source( right_natural_transformation ) );
          
    pre_compose_functor_transfo =
          HorizontalPreComposeFunctorWithNaturalTransformation( Range( left_natural_transformation ), right_natural_transformation );
    
    return VerticalPreCompose( pre_compose_transfo_functor, pre_compose_functor_transfo );
    
end );

##
AddIsWellDefinedForObjects( cat,

  IsCapCategoryAsCatObject

);

Finalize( cat );

end );

####################################
##
## Functor convinience
##
####################################

InstallMethod( @__MODULE__,  InstallFunctor,
               [ IsCapFunctor, IsString ],
               
  function( functor, install_name )
    local object_name, morphism_name, object_filters, object_product_filters, morphism_filters,
          morphism_product_filters, current_filters, install_list;
    
    if IsBound( functor.is_already_installed )
        
        return;
        
    end;
    
    if IsBoundGlobal( install_name ) && !IsOperation( ValueGlobal( install_name ) )
        
        Error( Concatenation( "can!install functor under name ", install_name ) );
        
    end;
    
    object_name = Concatenation( install_name, "OnObjects" );
    
    if HasObjectFunctionName( functor )
        
        object_name = ObjectFunctionName( functor );
        
    end;
    
    if IsBoundGlobal( object_name ) && !IsOperation( ValueGlobal( object_name ) )
        
        Error( Concatenation( "can!install functor object function under name ", object_name ) );
        
    end;
    
    SetObjectFunctionName( functor, object_name );
    
    morphism_name = Concatenation( install_name, "OnMorphisms" );
    
    if HasMorphismFunctionName( functor )
        
        morphism_name = MorphismFunctionName( functor );
        
    end;
    
    if IsBoundGlobal( morphism_name ) && !IsOperation( ValueGlobal( morphism_name ) )
        
        Error( Concatenation( "can!install functor morphism function under name ", morphism_name ) );
        
    end;
    
    SetMorphismFunctionName( functor, morphism_name );
    
    object_filters = CAP_INTERNAL_FUNCTOR_CREATE_FILTER_LIST( functor, "object" );
    morphism_filters = CAP_INTERNAL_FUNCTOR_CREATE_FILTER_LIST( functor, "morphism" );
    
    object_product_filters = [ ObjectFilter( AsCapCategory( Source( functor ) ) ) ];
    morphism_product_filters = [ MorphismFilter( AsCapCategory( Source( functor ) ) ) ];
    
    install_list = [
        [ install_name, object_filters ],
        [ install_name, morphism_filters ],
        [ object_name, object_filters ],
        [ morphism_name, morphism_filters ]
        ];
    
    if object_filters != object_product_filters
        
        Append( install_list, [ [ install_name, object_product_filters ], [ object_name, object_product_filters ] ] );
        
    end;
    
    if morphism_filters != morphism_product_filters
        
        Append( install_list, [ [ install_name, morphism_product_filters ], [ morphism_name, morphism_product_filters ] ] );
        
    end;
    
    for current_filters in install_list
        
        CallFuncList( DeclareOperation, current_filters );
        
        InstallMethod( ValueGlobal( current_filters[ 1 ] ),
                      current_filters[ 2 ],
                      
          function( arg... )
            
            return CallFuncList( ApplyFunctor, Concatenation( [ functor ], arg ) );
            
        end );
        
    end;
    
    functor.is_already_installed = true;
    
end );

##
InstallMethod( @__MODULE__,  IdentityFunctor,
               [ IsCapCategory ],
               
  function( category )
    
    return IdentityMorphism( AsCatObject( category ) );
    
end );

##
InstallMethod( @__MODULE__,  FunctorCanonicalizeZeroObjects,
               [ IsCapCategory ],
               
  function( category )
    local CZ, zero_obj;
    
    if !CanCompute( category, "IsZeroForObjects" )
        Error( "the category can!compute IsZeroForObjects\n" );
    end;
    
    CZ = CapFunctor( "functor canonicalizing zero objects", category, category );
    
    zero_obj = ZeroObject( category );
    
    AddObjectFunction( CZ,
            function( obj )
              
              if IsZeroForObjects( obj )
                  return zero_obj;
              end;
              
              return obj;
            end );
    
    AddMorphismFunction( CZ,
            function( new_source, mor, new_range )
              
              if IsZeroForObjects( Source( mor ) )
                  return UniversalMorphismFromZeroObjectWithGivenZeroObject( new_range, new_source );
              elseif IsZeroForObjects( Range( mor ) )
                  return UniversalMorphismIntoZeroObjectWithGivenZeroObject( new_source, new_range );
              end;
              
              return mor;
              
            end );
    
    return CZ;
    
end );

##
InstallMethod( @__MODULE__,  NaturalIsomorphismFromIdentityToCanonicalizeZeroObjects,
               [ IsCapCategory ],
               
  function( category )
    local Id, F, iso;
    
    Id = IdentityFunctor( category );
    
    F = FunctorCanonicalizeZeroObjects( category );
    
    iso = NaturalTransformation(
                   Concatenation( "natural isomorphism from the identity functor to ", Name( F ) ),
                   Id, F );
    
    AddNaturalTransformationFunction(
            iso,
            function( source, obj, range )
              
              if IsZeroForObjects( range )
                  return UniversalMorphismIntoZeroObjectWithGivenZeroObject( source, range );
              end;
              
              return IdentityMorphism( obj );
              
            end );
    
    SetIsIsomorphism( iso, true );
    
    return iso;
    
end );

##
InstallMethod( @__MODULE__,  FunctorCanonicalizeZeroMorphisms,
               [ IsCapCategory ],
               
  function( category )
    local CZ;
    
    if !CanCompute( category, "IsZeroForMorphisms" )
        Error( "the category can!compute IsZeroForMorphisms\n" );
    end;
    
    CZ = CapFunctor( "functor canonicalizing zero morphisms", category, category );
    
    AddObjectFunction( CZ, IdFunc );
    
    AddMorphismFunction( CZ,
            function( new_source, mor, new_range )
              
              if IsZeroForMorphisms( mor )
                  return ZeroMorphism( new_source, new_range );
              end;
              
              return mor;
              
            end );
    
    return CZ;
    
end );

##
InstallMethod( @__MODULE__,  NaturalIsomorphismFromIdentityToCanonicalizeZeroMorphisms,
               [ IsCapCategory ],
               
  function( category )
    local Id, F, iso;
    
    Id = IdentityFunctor( category );
    
    F = FunctorCanonicalizeZeroMorphisms( category );
    
    iso = NaturalTransformation(
                   Concatenation( "natural isomorphism from the identity functor to ", Name( F ) ),
                   Id, F );
    
    AddNaturalTransformationFunction(
            iso,
            function( source, obj, range )
              
              return IdentityMorphism( obj );
              
            end );
    
    SetIsIsomorphism( iso, true );
    
    return iso;
    
end );

###################################
##
## Natural transformations
##
###################################

##
InstallMethod( @__MODULE__,  NaturalTransformation,
               [ IsCapFunctor, IsCapFunctor ],
               
  function( source, range )
    
    return NaturalTransformation( Concatenation( "A natural transformation from ", Name( source ), " to ", Name( range ) ), source, range );
    
end );

##
InstallMethod( @__MODULE__,  NaturalTransformation,
               [ IsString, IsCapFunctor, IsCapFunctor ],
               
  function( name, source, range )
    local natural_transformation;
    
    ##formally, this has to be IsEqualForObjects (of CAT), but
    ##equality of categories is given by IsIdenticalObj.
    if !IsIdenticalObj( Source( source ), Source( range ) ) || !IsIdenticalObj( Range( source ), Range( range ) )
        
        Error( "a natural transformation between these functors does !exist" );
        
    end;
    
    natural_transformation = ObjectifyWithAttributes( rec( ), TheTypeOfCapNaturalTransformations,
                                                       Name, name,
                                                       Source, source,
                                                       Range, range );
    
    Add( CapCategory( source ), natural_transformation );
    
    return natural_transformation;
    
end );

##
InstallMethod( @__MODULE__,  NaturalTransformationCache,
               [ IsCapNaturalTransformation ],
               
  function( natural_trafo )
    
    return CachingObject( Source( natural_trafo ).number_arguments + 2 );
    
end );

##
InstallMethod( @__MODULE__,  NaturalTransformationOperation,
               [ IsCapNaturalTransformation ],
               
  function( trafo )
    local filter_list;
    
    filter_list = CAP_INTERNAL_FUNCTOR_CREATE_FILTER_LIST( Source( trafo ), "object" );
    
    filter_list = Concatenation( [ ObjectFilter( AsCapCategory( Range( Source( trafo ) ) ) ) ], filter_list, [ ObjectFilter( AsCapCategory( Range( Source( trafo ) ) ) ) ] );
    
    return NewOperation( Concatenation( "CAP_NATURAL_TRANSFORMATION_", Name( trafo ), "_OPERATION" ), filter_list );
    
end );

##
InstallMethod( @__MODULE__,  AddNaturalTransformationFunction,
               [ IsCapNaturalTransformation, IsList ],
               
  function( trafo, func_list )
    local sanitized_list, filter_list, operation, range_cat;
    
    sanitized_list = CAP_INTERNAL_SANITIZE_FUNC_LIST_FOR_FUNCTORS( func_list );
    
    filter_list = CAP_INTERNAL_FUNCTOR_CREATE_FILTER_LIST( Source( trafo ), "object" );
    
    filter_list = Concatenation( [ ObjectFilter( AsCapCategory( Range( Source( trafo ) ) ) ) ], filter_list, [ ObjectFilter( AsCapCategory( Range( Source( trafo ) ) ) ) ] );
    
    if !IsBound( trafo.function_list )
        
        trafo.function_list = sanitized_list;
        
    else
        
        Append( trafo.function_list, sanitized_list );
        
    end;
    
    operation = NaturalTransformationOperation( trafo );
    
    CAP_INTERNAL_INSTALL_FUNCTOR_OPERATION( operation, sanitized_list, filter_list, NaturalTransformationCache( trafo ) );
    
end );

##
InstallMethod( @__MODULE__,  AddNaturalTransformationFunction,
               [ IsCapNaturalTransformation, IsFunction ],
               
  function( trafo, func )
    
    AddNaturalTransformationFunction( trafo, [ [ func, [ ] ] ] );
    
end );

@InstallGlobalFunction( ApplyNaturalTransformation,
               
  function( arg... )
    local trafo, source_functor, arguments, i, source_value, range_value, computed_value;
    
    trafo = arg[ 1 ];
    
    source_functor = Source( trafo );
    
    arguments = arg[(2):(Length( arg ))];
    
    if Length( arguments ) == 1 && source_functor.number_arguments > 1
        
        arguments = Components( arguments[ 1 ] );
        
        for i in (1):(Length( arguments ))
            if InputSignature( source_functor )[ i ][ 2 ] == true
                arguments[ i ] = Opposite( arguments[ i ] );
            end;
        end;
        
    elseif Length( arguments ) == 1 && InputSignature( source_functor )[ 1 ][ 2 ] == true &&
         IsIdenticalObj( CapCategory( arguments[ 1 ] ), Opposite( InputSignature( source_functor )[ 1 ][ 1 ] ) )
         arguments[ 1 ] = Opposite( arguments[ 1 ] );
    end;
    
    source_value = CallFuncList( ApplyFunctor, Concatenation( [ source_functor ], arguments ) );
    
    range_value = CallFuncList( ApplyFunctor, Concatenation( [ Range( trafo ) ], arguments ) );
    
    computed_value = CallFuncList( NaturalTransformationOperation( trafo ), Concatenation( [ source_value ], arguments, [ range_value ] ) );
    
    Add( AsCapCategory( Range( source_functor ) ), computed_value );
    
    ## TODO: this should be replaced by an "a => b" todo_list with more properties
    if HasIsIsomorphism( trafo ) && IsIsomorphism( trafo )
        SetIsIsomorphism( computed_value, true );
    end;
    
    return computed_value;
    
end );

InstallMethod( @__MODULE__,  InstallNaturalTransformation,
               [ IsCapNaturalTransformation, IsString ],
               
  function( trafo, install_name )
    local object_filters, object_product_filters, current_filters;
    
    if IsBound( trafo.is_already_installed )
        
        return;
        
    end;
    
    if IsBoundGlobal( install_name ) && !IsOperation( ValueGlobal( install_name ) )
        
        Error( Concatenation( "can!install natural transformation under name ", install_name ) );
        
    end;
    
    object_filters = CAP_INTERNAL_FUNCTOR_CREATE_FILTER_LIST( Source( trafo ), "object" );
    
    object_product_filters = [ ObjectFilter( AsCapCategory( Source( Source( trafo ) ) ) ) ];
    
    for current_filters in [
        [ install_name, object_filters ],
        [ install_name, object_product_filters ],
        ]
        
        CallFuncList( DeclareOperation, current_filters );
        
        InstallMethod( ValueGlobal( current_filters[ 1 ] ),
                      current_filters[ 2 ],
                      
          function( arg... )
            
            return CallFuncList( ApplyNaturalTransformation, Concatenation( [ trafo ], arg ) );
            
        end );
        
    end;
    
    trafo.is_already_installed = true;
    
end );

##
InstallMethodWithCacheFromObject( HorizontalPreComposeNaturalTransformationWithFunctor,
                                  [ IsCapNaturalTransformation, IsCapFunctor ],
                           
  function( natural_transformation, functor )
    local composition;
    
    composition = NaturalTransformation( Concatenation( "Horizontal composition of natural transformation ",
                                                         Name( natural_transformation ),
                                                         " && functor ",
                                                         Name( functor ) ),
                                                         PreCompose( Source( natural_transformation ), functor ),
                                                         PreCompose( Range( natural_transformation ), functor ) );
    
    AddNaturalTransformationFunction( composition,
      
      function( source_value, object, range_value )
        
        return ApplyFunctor( functor, ApplyNaturalTransformation( natural_transformation, object ) );
        
      end );
    
    return composition;
    
end );

##
InstallMethodWithCacheFromObject( HorizontalPreComposeFunctorWithNaturalTransformation,
                                  [ IsCapFunctor, IsCapNaturalTransformation ],
                           
  function( functor, natural_transformation )
    local composition;
    
    composition = NaturalTransformation( Concatenation( "Horizontal composition of functor ",
                                                         Name( functor ),
                                                         " && natural transformation ",
                                                         Name( natural_transformation ) ),
                                                         PreCompose( functor, Source( natural_transformation ) ),
                                                         PreCompose( functor, Range( natural_transformation ) ) );
    
    AddNaturalTransformationFunction( composition,
      
      function( source_value, object, range_value )
        
        return ApplyNaturalTransformation( natural_transformation, ApplyFunctor( functor, object ) );
        
      end );
    
    return composition;
    
end );
