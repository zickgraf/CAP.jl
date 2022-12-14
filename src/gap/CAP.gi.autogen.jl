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

@BindGlobal( "TheFamilyOfCapCategoryObjects",
        NewFamily( "TheFamilyOfCapCategoryObjects" ) );

@BindGlobal( "TheFamilyOfCapCategoryMorphisms",
        NewFamily( "TheFamilyOfCapCategoryMorphisms" ) );

@BindGlobal( "TheFamilyOfCapCategoryTwoCells",
        NewFamily( "TheFamilyOfCapCategoryTwoCells" ) );

######################################
##
## Properties logic
##
######################################

InstallTrueMethod( IsEnrichedOverCommutativeRegularSemigroup, IsAbCategory );

InstallTrueMethod( IsAbCategory, IsAdditiveCategory );

InstallTrueMethod( IsAdditiveCategory, IsPreAbelianCategory );

InstallTrueMethod( IsPreAbelianCategory, IsAbelianCategory );

InstallTrueMethod( IsAbelianCategory, IsAbelianCategoryWithEnoughProjectives );

InstallTrueMethod( IsAbelianCategory, IsAbelianCategoryWithEnoughInjectives );

######################################
##
## Technical stuff
##
######################################

##
@InstallGlobalFunction( CAP_INTERNAL_NAME_COUNTER,
                       
  function( )
    local counter;
    
    counter = CAP_INTERNAL.name_counter + 1;
    
    CAP_INTERNAL.name_counter = counter;
    
    return counter;
    
end );

##
@InstallGlobalFunction( GET_METHOD_CACHE,
                       
  function( category, name, number )
    local cache, cache_type;
    
    cache = fail;
    
    #= comment for Julia
    if IsBound( category.caches[name] ) && IsCachingObject( category.caches[name] )
        
        if category.caches[name].nr_keys != number
            
            Error( "you have requested a cache for \"", name, "\" with ", number,
                   " keys but the existing cache with the same name has ", category.caches[name].nr_keys, " keys" );
            
        end;
        
        return category.caches[name];
        
    end;
    
    if IsBound( category.caches[name] ) && IsString( category.caches[name] )
        
        cache_type = category.caches[name];
        
    else
        
        cache_type = category.default_cache_type;
        
    end;
    
    if cache_type == "weak"
        cache = CreateWeakCachingObject( number );
    elseif cache_type == "crisp"
        cache = CreateCrispCachingObject( number );
    elseif cache_type == "none"
        cache = CreateCrispCachingObject( number );
        DeactivateCachingObject( cache );
    else
        Error( "unrecognized cache type ", cache_type );
    end;
    
    category.caches[name] = cache;
    # =#
    
    return cache;
    
end );

##
@InstallGlobalFunction( SET_VALUE_OF_CATEGORY_CACHE,
                       
  function( category, name, number, key, value )
    local cache;
    
    cache = GET_METHOD_CACHE( category, name, number );
    
    SetCacheValue( cache, key, value );
    
end );

##
@InstallGlobalFunction( HAS_VALUE_OF_CATEGORY_CACHE,
                       
  function( category, name, number, key, value )
    local cache;
    
    cache = GET_METHOD_CACHE( category, name, number );
    
    return CacheValue( cache, key, value ) != [ ];
    
end );

@InstallValueConst( CAP_INTERNAL_DERIVATION_GRAPH,
    
    MakeDerivationGraph( [ ] ) );


######################################
##
## Reps, types, stuff.
##
######################################

# backwards compatibility
@BindGlobal( "IsCapCategoryRep", IsCapCategory );

@BindGlobal( "TheFamilyOfCapCategories",
        NewFamily( "TheFamilyOfCapCategories" ) );

@BindGlobal( "TheTypeOfCapCategories",
        NewType( TheFamilyOfCapCategories,
                 IsCapCategory ) );


#####################################
##
## Global functions
##
#####################################

##
@InstallGlobalFunction( "CREATE_CAP_CATEGORY_OBJECT",
  function( obj_rec, name, category_filter, object_filter, morphism_filter, two_cell_filter )
    local filter, obj, operation_name;
    
    obj_rec.logical_implication_files = StructuralCopy( CATEGORIES_LOGIC_FILES );
    
    filter = NewFilter( Concatenation( name, "InternalCategoryFilter" ), category_filter );
    
    obj = ObjectifyWithAttributes( obj_rec, NewType( TheFamilyOfCapCategories, filter ), Name, name );
    
    SetCategoryFilter( obj, filter );
    
    # object filter
    filter = NewCategory( Concatenation( name, "ObjectFilter" ), object_filter );
    
    SetObjectFilter( obj, filter );
    
    obj.object_representation = object_filter;
    obj.object_type = NewType( TheFamilyOfCapCategoryObjects, filter );
    
    # morphism filter
    filter = NewCategory( Concatenation( name, "MorphismFilter" ), morphism_filter );
    
    SetMorphismFilter( obj, filter );
    
    obj.morphism_representation = morphism_filter;
    obj.morphism_type = NewType( TheFamilyOfCapCategoryMorphisms, filter );
    
    # two cell filter
    filter = NewCategory( Concatenation( name, "TwoCellFilter" ), two_cell_filter );
    
    SetTwoCellFilter( obj, filter );
    
    SetIsFinalized( obj, false );
    
    obj.derivations_weight_list = MakeOperationWeightList( obj, CAP_INTERNAL_DERIVATION_GRAPH );
    
    obj.caches = rec( );
    
    for operation_name in CAP_INTERNAL.operation_names_with_cache_disabled_by_default
        
        obj.caches[operation_name] = "none";
        
    end;
    
    obj.primitive_operations = rec( );

    obj.added_functions = rec( );
    
    obj.timing_statistics = rec( );
    obj.timing_statistics_enabled = false;
    
    obj.default_cache_type = CAP_INTERNAL.default_cache_type;
    
    obj.input_sanity_check_level = 1;
    obj.output_sanity_check_level = 1;
    
    obj.predicate_logic_propagation_for_objects = false;
    obj.predicate_logic_propagation_for_morphisms = false;
    
    obj.predicate_logic = true;
    
    obj.add_primitive_output = false;
    
    return obj;
    
end );

InstallMethod( @__MODULE__,  TheoremRecord,
               [ IsCapCategory ],
               
  function( category )
    
    return rec( );
    
end );

######################################################
##
## Add functions
##
######################################################

InstallMethod( @__MODULE__,  AddCategoryToFamily,
               [ IsCapCategory, IsString ],
               
  function( category, family )
    
    if !IsBound( category.families )
        
        category.families = [ ];
        
    end;
    
    Add( category.families, LowercaseString( family ) );
    
end );

#######################################
##
## Caching
##
#######################################

##
InstallMethod( @__MODULE__,  SetCaching,
               [ IsCapCategory, IsString, IsString ],
               
  function( category, function_name, caching_info )
    local current_cache;
    
    if !caching_info ??? [ "weak", "crisp", "none" ]
        
        Error( "wrong caching type" );
        
    end;
    
    if !IsBound( category.caches[function_name] ) || IsString( category.caches[function_name] )
        
        category.caches[function_name] = caching_info;
        
    elseif IsCachingObject( category.caches[function_name] )
        
        current_cache = category.caches[function_name];
        
        if caching_info == "weak"
            SetCachingObjectWeak( current_cache );
        elseif caching_info == "crisp"
            SetCachingObjectCrisp( current_cache );
        elseif caching_info == "none"
            DeactivateCachingObject( current_cache );
        end;
        
    end;
    
end );

##
InstallMethod( @__MODULE__,  SetCachingToWeak,
               [ IsCapCategory, IsString ],
               
  function( category, function_name )
    
    SetCaching( category, function_name, "weak" );
    
end );

##
InstallMethod( @__MODULE__,  SetCachingToCrisp,
               [ IsCapCategory, IsString ],
               
  function( category, function_name )
    
    SetCaching( category, function_name, "crisp" );
    
end );

##
InstallMethod( @__MODULE__,  DeactivateCaching,
               [ IsCapCategory, IsString ],
               
  function( category, function_name )
    
    SetCaching( category, function_name, "none" );
    
end );

#= comment for Julia
##
InstallMethod( @__MODULE__,  CachingObject,
               [ IsCapCategoryCell, IsString, IsInt ],
               
  function( cell, name, number )
    
    return GET_METHOD_CACHE( CapCategory( cell ), name, number );
    
end );

##
InstallMethod( @__MODULE__,  CachingObject,
               [ IsCapCategory, IsString, IsInt ],
               
  GET_METHOD_CACHE );
# =#

@InstallGlobalFunction( SetCachingOfCategory,
  
  function( category, type )
    local current_name;
    
    if !type ??? [ "weak", "crisp", "none" ]
        Error( "wrong type for caching" );
    end;
    
    category.default_cache_type = type;
    
    for current_name in RecNames( category.caches )
        
        if current_name ??? CAP_INTERNAL.operation_names_with_cache_disabled_by_default
            continue;
        end;
        
        SetCaching( category, current_name, type );
        
    end;
    
end );

@InstallGlobalFunction( SetCachingOfCategoryWeak,
  
  function( category )
    
    SetCachingOfCategory( category, "weak" );
    
end );

@InstallGlobalFunction( SetCachingOfCategoryCrisp,
  
  function( category )
    
    SetCachingOfCategory( category, "crisp" );
    
end );

@InstallGlobalFunction( DeactivateCachingOfCategory,
  
  function( category )
    
    SetCachingOfCategory( category, "none" );
    
end );


@InstallGlobalFunction( SetDefaultCaching,

  function( type )
    local current_name;

    if !type ??? [ "weak", "crisp", "none" ]
        Error( "wrong type for caching" );
    end;

    CAP_INTERNAL.default_cache_type = type;

end );

@InstallGlobalFunction( SetDefaultCachingWeak,
  function( )
    SetDefaultCaching( "weak" );
end );

@InstallGlobalFunction( SetDefaultCachingCrisp,
  function( )
    SetDefaultCaching( "crisp" );
end );

@InstallGlobalFunction( DeactivateDefaultCaching,
  function( )
    SetDefaultCaching( "none" );
end );

#######################################
##
## Constructors
##
#######################################

##
InstallMethod( @__MODULE__,  CreateCapCategory,
               [ ],
               
  function( )
    local name;
    
    name = Concatenation( "AutomaticCapCategory", string( CAP_INTERNAL_NAME_COUNTER( ) ) );
    
    return CreateCapCategory( name );
    
end );

##
InstallMethod( @__MODULE__,  CreateCapCategory,
               [ IsString ],
               
  function( name )
    
    return CreateCapCategory( name, IsCapCategory, IsCapCategoryObject, IsCapCategoryMorphism, IsCapCategoryTwoCell );
    
end );

##
InstallMethod( @__MODULE__,  CreateCapCategory,
               [ IsString, IsFunction, IsFunction, IsFunction, IsFunction ],
               
  function( name, category_filter, object_filter, morphism_filter, two_cell_filter )
    local overhead, is_computable, category;
    
    overhead = CAP_INTERNAL_RETURN_OPTION_OR_DEFAULT( "overhead", true );
    
    is_computable = CAP_INTERNAL_RETURN_OPTION_OR_DEFAULT( "is_computable", true );

    category = CREATE_CAP_CATEGORY_OBJECT( rec( ), name, category_filter, object_filter, morphism_filter, two_cell_filter );
    
    category.overhead = overhead;
    
    category.is_computable = is_computable;

    if overhead
    
      AddCategoryToFamily( category, "general" );
      
    else
      
      category.predicate_logic = false;
      
    end;
    
    return category;
    
end );

##
InstallMethod( @__MODULE__,  CanCompute,
               [ IsCapCategory, IsString ],
               
  function( category, string )
    local weight_list;
    
    if !IsBound( CAP_INTERNAL_METHOD_NAME_RECORD[string] )
        
        Error( string, " is !the name of a CAP operation" );
        
    end;
    
    weight_list = category.derivations_weight_list;
    
    return CurrentOperationWeight( weight_list, string ) != Inf;
    
end );

##
InstallMethod( @__MODULE__,  CanCompute,
               [ IsCapCategory, IsFunction ],
               
  function( category, operation )
    
    Display( "WARNING: calling `CanCompute` with a CAP operation as the second argument should only be done for debugging purposes." );
    
    return CanCompute( category, NameFunction( operation ) );
    
end );

##
InstallMethod( @__MODULE__,  CheckConstructivenessOfCategory,
               [ IsCapCategory, IsString ],
               
  function( category, string )
    local category_property, result_list;
    
    if !IsBound( CAP_INTERNAL_CONSTRUCTIVE_CATEGORIES_RECORD[string] )
      
      Error( "the given string is !a property of a category" );
    
    end;
    
    result_list = [];
    
    for category_property in CAP_INTERNAL_CONSTRUCTIVE_CATEGORIES_RECORD[string]
      
      if !CanCompute( category, category_property )
        
        Add( result_list, category_property );
        
      end;
      
    end;
    
    return result_list;
    
end );

####################################
##
## Sanity checks
##
####################################
@InstallGlobalFunction( "DisableInputSanityChecks",
  function( category )
    
    category.input_sanity_check_level = 0;
    
end );
@InstallGlobalFunction( "DisableOutputSanityChecks", 
  function( category )
    
    category.output_sanity_check_level = 0;
    
end );
@InstallGlobalFunction( "EnablePartialInputSanityChecks" ,
  function( category )
  
    category.input_sanity_check_level = 1;
    
end );
@InstallGlobalFunction( "EnablePartialOutputSanityChecks" ,
  function( category )
    
    category.output_sanity_check_level = 1;
    
end );
@InstallGlobalFunction( "EnableFullInputSanityChecks" ,
  function( category )
  
    category.input_sanity_check_level = 2;
     
end );
@InstallGlobalFunction( "EnableFullOutputSanityChecks" ,
  function( category )
    
    category.output_sanity_check_level = 2;
    
end );

@InstallGlobalFunction( "DisableSanityChecks" ,
  function( category )
    
    DisableInputSanityChecks( category );
    DisableOutputSanityChecks( category );
     
end );
@InstallGlobalFunction( "EnablePartialSanityChecks" ,
  function( category )
    
    EnablePartialInputSanityChecks( category );
    EnablePartialOutputSanityChecks( category );
    
end );
@InstallGlobalFunction( "EnableFullSanityChecks" ,
  function( category )
    
    EnableFullInputSanityChecks( category );
    EnableFullOutputSanityChecks( category );
    
end );

####################################
##
## Timing statistics
##
####################################

@InstallGlobalFunction( "EnableTimingStatistics",
  function( category )
    
    if category.overhead != true
        
        Display( "WARNING: <category> was created with `overhead = false` && thus can!collect timing statistics." );
        
    end;
    
    category.timing_statistics_enabled = true;
    
end );

@InstallGlobalFunction( "DisableTimingStatistics",
  function( category )
    
    if category.overhead != true
        
        Display( "WARNING: <category> was created with `overhead = false` && thus can!collect timing statistics." );
        
    end;
    
    category.timing_statistics_enabled = false;
    
end );

@InstallGlobalFunction( "ResetTimingStatistics",
  function( category )
    local recname;
    
    if category.overhead != true
        
        Display( "WARNING: <category> was created with `overhead = false` && thus can!collect timing statistics." );
        
    end;
    
    for recname in RecNames( category.timing_statistics )
        
        category.timing_statistics[recname] = [ ];
        
    end;
    
end );

@BindGlobal( "CAP_INTERNAL_PREPARE_TIMING_STATISTICS_FOR_DISPLAY",
  function( category )
    local header, warning, operations, total_time_global, times, execs, total_time, time_per_exec, recname;
    
    if category.overhead != true
        
        Display( "WARNING: <category> was created with `overhead = false` && thus can!collect timing statistics." );
        
    end;
    
    header = Concatenation( "Timing statistics for the primitive operations of the category ", Name( category ), ":" );
    
    operations = [ ];
    
    total_time_global = 0;
    
    for recname in SortedList( RecNames( category.timing_statistics ) )
        
        times = category.timing_statistics[recname];
        
        if Length( times ) > 0
            
            execs = Length( times );
            total_time = Sum( times );
            time_per_exec = int( total_time / execs * 1000 );
            
            Add( operations, rec(
                name = recname,
                execs = execs,
                total_time = total_time,
                time_per_exec = time_per_exec,
            ) );
            
            total_time_global = total_time_global + total_time;
            
        end;
        
    end;
    
    if IsEmpty( operations )
        
        warning = "No timing statistics recorded, use `EnableTimingStatistics( <category> )` to enable timing statistics.";
        
    elseif !category.timing_statistics_enabled
        
        warning = "WARNING: timing statistics for this category are disabled, so the results shown may !be up to date. Use `EnableTimingStatistics( <category> )` to enable timing statistics.";
        
    else
        
        warning = fail;
        
    end;
    
    return rec(
        header = header,
        warning = warning,
        total_time_global = total_time_global,
        operations = operations,
    );
    
end );

@InstallGlobalFunction( "DisplayTimingStatistics",
  function( category )
    local info, operation;
    
    info = CAP_INTERNAL_PREPARE_TIMING_STATISTICS_FOR_DISPLAY( category );
    
    Display( "####" );
    
    if IsEmpty( info.operations )
        
        Display( info.warning );
        
        return;
        
    end;
    
    Display( info.header );
    
    if info.warning != fail
        
        Display( info.warning );
        
    end;
    
    Display( Concatenation( "Total time spent ??? primitive operations of this category: ", string( info.total_time_global ) , " ms" ) );
    
    for operation in info.operations
        
        Print(
            operation.name,
            " was called ",
            operation.execs,
            " times with a total runtime of ",
            operation.total_time,
            " ms ( == ",
            operation.time_per_exec,
            " ??s per execution)\n"
        );
        
    end;
    
end );

if IsPackageMarkedForLoading( "Browse", ">=0" ) && IsBound( NCurses ) && IsBound( NCurses.BrowseDenseList )
    
    @InstallGlobalFunction( "BrowseTimingStatistics",
      function( category )
        local info, header, value_matrix, labelsRow, labelsCol, operation;
        
        info = CAP_INTERNAL_PREPARE_TIMING_STATISTICS_FOR_DISPLAY( category );
        
        if IsEmpty( info.operations )
            
            Display( info.warning );
            
            return;
            
        end;
        
        header = [ info.header ];
        
        if info.warning != fail
            
            Add( header, info.warning );
            
        end;
        
        Add( header, Concatenation( "Total time spent ??? primitive operations of this category: ", string( info.total_time_global ) , " ms" ) );
        Add( header, "" );
        
        value_matrix = [ ];
        labelsRow = [ ];
        labelsCol = [ [ "times called", "total time (ms)", "time per execution (??s)"  ] ];
        
        for operation in info.operations
            
            Add( labelsRow, [ operation.name ] );
            
            Add( value_matrix, [ operation.execs, operation.total_time, operation.time_per_exec ] );
            
        end;
        
        NCurses.BrowseDenseList( value_matrix, rec( header = header, labelsCol = labelsCol, labelsRow = labelsRow ) );
        
    end );
    
else
    
    @InstallGlobalFunction( "BrowseTimingStatistics",
      function( category )
        
        Display( "`BrowseTimingStatistics` needs the function `NCurses.BrowseDenseList`, which should be available ??? the package \"Browse\"." );
        Display( "Please load \"Browse\" before/together with \"CAP\" || use `DisplayTimingStatistics( <category> )` instead." );
        
    end );
    
end;

#######################################
##
## Logic
##
#######################################

@InstallGlobalFunction( CapCategorySwitchLogicPropagationForObjectsOn,
  
  function( category )
    
    category.predicate_logic_propagation_for_objects = true;
    
end );

@InstallGlobalFunction( CapCategorySwitchLogicPropagationForObjectsOff,
  
  function( category )
    
    category.predicate_logic_propagation_for_objects = false;
    
end );

@InstallGlobalFunction( CapCategorySwitchLogicPropagationForMorphismsOn,
  
  function( category )
    
    category.predicate_logic_propagation_for_morphisms = true;
    
end );

@InstallGlobalFunction( CapCategorySwitchLogicPropagationForMorphismsOff,
  
  function( category )
    
    category.predicate_logic_propagation_for_morphisms = false;
    
end );

@InstallGlobalFunction( CapCategorySwitchLogicPropagationOn,
  
  function( category )
    
    CapCategorySwitchLogicPropagationForObjectsOn( category );
    CapCategorySwitchLogicPropagationForMorphismsOn( category );
    
end );

@InstallGlobalFunction( CapCategorySwitchLogicPropagationOff,
  
  function( category )
    
    CapCategorySwitchLogicPropagationForObjectsOff( category );
    CapCategorySwitchLogicPropagationForMorphismsOff( category );
    
end );

@InstallGlobalFunction( CapCategorySwitchLogicOn,
  
  function( category )
    
    category.predicate_logic = true;
    
end );

@InstallGlobalFunction( CapCategorySwitchLogicOff,
  
  function( category )
    
    category.predicate_logic = false;
    
end );

#######################################
##
## Unpacking data structures
##
#######################################

##
InstallMethod( @__MODULE__,  Down, [ IsObject ], IdFunc );

##
InstallMethod( @__MODULE__,  Down, [ IsCapCategoryObject ], x -> "unknown object data" );

##
InstallMethod( @__MODULE__,  Down2, [ IsObject ], x -> Down( Down( x ) ) );

##
InstallMethod( @__MODULE__,  Down3, [ IsObject ], x -> Down( Down( Down( x ) ) ) );

##
InstallMethod( @__MODULE__,  DownOnlyMorphismData, [ IsCapCategoryMorphism ], x -> "unknown morphism data" );

##
InstallMethod( @__MODULE__,  Down,
               [ IsCapCategoryMorphism ],
  function( mor )
    
    return [ Source( mor ), DownOnlyMorphismData( mor ), Range( mor ) ];
    
end );

##
InstallMethod( @__MODULE__,  Down,
               [ IsList ],
               
  function( obj )
    
    return List( obj, Down );
    
end );

##
InstallMethod( @__MODULE__,  DownToBottom,
               [ IsObject ],
               
  function( obj )
    local objp, equality_func;
    
    objp = obj;
    
    equality_func = function( a, b )
      
      if IsList( a ) && IsList( b ) && Size( a ) == Size( b )
        
        return ForAll( (1):(Size( a )), i -> equality_func(a[i], b[i]) );
        
      else
        
        return IsIdenticalObj( a, b );
        
      end;
      
    end;
    
    while !equality_func( objp, Down( objp ) )
      
      objp = Down( objp );
      
    end;
    
    return objp;
    
end );

#######################################
##
## ViewObj
##
#######################################

# fallback methods for Julia
InstallMethod( @__MODULE__,  ViewObj,
               [ IsCapCategory ],
               
  function ( category )
    
    Print( Name( category ) );
    
end );

InstallMethod( @__MODULE__,  Display,
               [ IsCapCategory ],
               
  function ( category )
    
    Print( "A CAP category with name ", Name( category ), "\n" );
    
end );

@InstallGlobalFunction( CAP_INTERNAL_INSTALL_PRINT_FUNCTION,
               
  function( )
    local print_graph, category_function, i, internal_list;
    
    category_function = function( category )
      local string;
      
      string = "CAP category";
      
      if HasName( category )
          
          Append( string, " with name " );
          
          Append( string, Name( category ) );
          
      end;
      
      return string;
      
    end;
    
    print_graph = CreatePrintingGraph( IsCapCategory, category_function );
    
    internal_list = Concatenation( CAP_INTERNAL_CATEGORICAL_PROPERTIES_LIST );
    
    for i in internal_list
        
        AddNodeToGraph( print_graph, rec( Conditions = i,
                                          TypeOfView = 3,
                                          ComputeLevel = 5 ) );
        
    end;
    
    InstallPrintFunctionsOutOfPrintingGraph( print_graph );
    
end );

InstallMethod( @__MODULE__,  String,
               [ IsCapCategory ],
    Name );

#= comment for Julia
CAP_INTERNAL_INSTALL_PRINT_FUNCTION( );
# =#

@InstallGlobalFunction( DisableAddForCategoricalOperations,
  
  function( category )
    
    if !IsCapCategory( category )
        Error( "Argument must be a category" );
    end;
    
    category.add_primitive_output = false;
    
end );

@InstallGlobalFunction( EnableAddForCategoricalOperations,
  
  function( category )
    
    if !IsCapCategory( category )
        Error( "Argument must be a category" );
    end;
    
    category.add_primitive_output = true;
    
end );

InstallMethod( @__MODULE__,  CellFilter,
               [ IsCapCategory ],

  function ( category )
    
    Error( "Categories do !have an attribute `CellFilter` anymore." );
    
end );
