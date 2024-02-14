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

InstallTrueMethod( IsAbCategory, IsLinearCategoryOverCommutativeRing );

InstallTrueMethod( IsLinearCategoryOverCommutativeRing, IsLinearCategoryOverCommutativeRingWithFinitelyGeneratedFreeExternalHoms );

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
    if (@IsBound( category.caches[name] ) && IsCachingObject( category.caches[name] ))
        
        if (category.caches[name].nr_keys != number)
            
            Error( "you have requested a cache for \"", name, "\" with ", number,
                   " keys but the existing cache with the same name has ", category.caches[name].nr_keys, " keys" );
            
        end;
        
        return category.caches[name];
        
    end;
    
    if (@IsBound( category.caches[name] ) && IsString( category.caches[name] ))
        
        cache_type = category.caches[name];
        
    else
        
        cache_type = category.default_cache_type;
        
    end;
    
    if (cache_type == "weak")
        cache = CreateWeakCachingObject( number );
    elseif (cache_type == "crisp")
        cache = CreateCrispCachingObject( number );
    elseif (cache_type == "none")
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
@InstallGlobalFunction( "CreateCapCategoryWithDataTypes",
  function( name, category_filter, object_filter, morphism_filter, two_cell_filter, object_datum_type, morphism_datum_type, two_cell_datum_type )
    local get_attribute_name_for_data_type, filter, obj, operation_name;
    
    get_attribute_name_for_data_type = function ( data_type )
        
        if (data_type == fail)
            
            return "AsPrimitiveValue";
            
        elseif (data_type.filter == IsInt)
            
            return "AsInteger";
            
        elseif (IsBoundGlobal( "IsHomalgMatrix" ) && data_type.filter == ValueGlobal( "IsHomalgMatrix" ))
            
            return "AsHomalgMatrix";
            
        else
            
            return "AsPrimitiveValue";
            
        end;
        
    end;
    
    ## plausibility checks
    if (@not IsSpecializationOfFilter( IsCapCategory, category_filter ))
        
        Print( "WARNING: filter ", category_filter, " does not imply `IsCapCategory`. This will probably cause errors.\n" );
        
    end;
    
    if (@not IsSpecializationOfFilter( IsCapCategoryObject, object_filter ))
        
        Print( "WARNING: filter ", object_filter, " does not imply `IsCapCategoryObject`. This will probably cause errors.\n" );
        
    end;
    
    if (@not IsSpecializationOfFilter( IsCapCategoryMorphism, morphism_filter ))
        
        Print( "WARNING: filter ", morphism_filter, " does not imply `IsCapCategoryMorphism`. This will probably cause errors.\n" );
        
    end;
    
    if (@not IsSpecializationOfFilter( IsCapCategoryTwoCell, two_cell_filter ))
        
        Print( "WARNING: filter ", two_cell_filter, " does not imply `IsCapCategoryTwoCell`. This will probably cause errors.\n" );
        
    end;
    
    if (IsFilter( object_datum_type ))
        
        object_datum_type = @rec( filter = object_datum_type );
        
    end;
    
    if (IsFilter( morphism_datum_type ))
        
        morphism_datum_type = @rec( filter = morphism_datum_type );
        
    end;
    
    if (IsFilter( two_cell_datum_type ))
        
        two_cell_datum_type = @rec( filter = two_cell_datum_type );
        
    end;
    
    filter = NewFilter( @Concatenation( name, "InstanceCategoryFilter" ), category_filter );
    
    obj = ObjectifyWithAttributes( @rec( ), NewType( TheFamilyOfCapCategories, filter ), Name, name );
    
    ## filters
    SetCategoryFilter( obj, filter );
    
    # object filter
    filter = NewCategory( @Concatenation( name, "InstanceObjectFilter" ), object_filter );
    
    SetObjectFilter( obj, filter );
    SetObjectDatumType( obj, object_datum_type );
    
    obj.object_type = NewType( TheFamilyOfCapCategoryObjects, filter );
    
    obj.object_attribute_name = get_attribute_name_for_data_type( object_datum_type );
    obj.object_attribute = ValueGlobal( obj.object_attribute_name );
    
    # morphism filter
    filter = NewCategory( @Concatenation( name, "InstanceMorphismFilter" ), morphism_filter );
    
    SetMorphismFilter( obj, filter );
    SetMorphismDatumType( obj, morphism_datum_type );
    
    obj.morphism_type = NewType( TheFamilyOfCapCategoryMorphisms, filter );
    
    obj.morphism_attribute_name = get_attribute_name_for_data_type( morphism_datum_type );
    obj.morphism_attribute = ValueGlobal( obj.morphism_attribute_name );
    
    # two cell filter
    filter = NewCategory( @Concatenation( name, "InstanceTwoCellFilter" ), two_cell_filter );
    
    SetTwoCellFilter( obj, filter );
    SetTwoCellDatumType( obj, two_cell_datum_type );
    
    ## misc
    SetIsFinalized( obj, false );
    
    obj.is_computable = CAP_INTERNAL_RETURN_OPTION_OR_DEFAULT( "is_computable", true );
    
    if (ValueOption( "disable_derivations" ) == true)
        
        # use an empty derivation graph
        obj.derivations_weight_list = MakeOperationWeightList( obj, MakeDerivationGraph( Operations( CAP_INTERNAL_DERIVATION_GRAPH ) ) );
        
    else
        
        obj.derivations_weight_list = MakeOperationWeightList( obj, CAP_INTERNAL_DERIVATION_GRAPH );
        
    end;
    
    obj.caches = @rec( );
    
    for operation_name in CAP_INTERNAL.operation_names_with_cache_disabled_by_default
        
        obj.caches[operation_name] = "none";
        
    end;
    
    obj.primitive_operations = @rec( );
    
    obj.added_functions = @rec( );
    
    obj.timing_statistics = @rec( );
    obj.timing_statistics_enabled = false;
    
    obj.default_cache_type = CAP_INTERNAL.default_cache_type;
    
    obj.input_sanity_check_level = 1;
    obj.output_sanity_check_level = 1;
    
    obj.predicate_logic_propagation_for_objects = false;
    obj.predicate_logic_propagation_for_morphisms = false;
    
    obj.logical_implication_files = StructuralCopy( CATEGORIES_LOGIC_FILES );
    
    obj.overhead = CAP_INTERNAL_RETURN_OPTION_OR_DEFAULT( "overhead", true );
    
    if (obj.overhead)
        
        obj.predicate_logic = true;
        
    else
        
        obj.predicate_logic = false;
        
    end;
    
    obj.add_primitive_output = false;
    
    # convenience for Julia lists
    if (IsPackageMarkedForLoading( "JuliaInterface", ">= 0.2" ))
        
        if (object_datum_type != fail && object_datum_type.filter in [ IsList, IsNTuple ])
            
            InstallOtherMethod( ObjectConstructor,
                                [ CategoryFilter( obj ), ValueGlobal( "IsJuliaObject" ) ],
                                
              function( cat, julia_list )
                
                return ObjectConstructor( cat, ValueGlobal( "ConvertJuliaToGAP" )( julia_list ) );
                
            end );
            
        end;
        
        if (morphism_datum_type != fail && morphism_datum_type.filter in [ IsList, IsNTuple ])
            
            InstallOtherMethod( MorphismConstructor,
                                [ ObjectFilter( obj ), ValueGlobal( "IsJuliaObject" ), ObjectFilter( obj ) ],
                                
              function( source, julia_list, range )
                
                return MorphismConstructor( source, ValueGlobal( "ConvertJuliaToGAP" )( julia_list ), range );
                
            end );
            
            InstallOtherMethod( MorphismConstructor,
                                [ CategoryFilter( obj ), ObjectFilter( obj ), ValueGlobal( "IsJuliaObject" ), ObjectFilter( obj ) ],
                                
              function( cat, source, julia_list, range )
                
                return MorphismConstructor( cat, source, ValueGlobal( "ConvertJuliaToGAP" )( julia_list ), range );
                
            end );
            
        end;
        
    end;
    
    return obj;
    
end );

InstallMethod( @__MODULE__,  TheoremRecord,
               [ IsCapCategory ],
               
  function( category )
    
    return @rec( );
    
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
    
    if (@not caching_info in [ "weak", "crisp", "none" ])
        
        Error( "wrong caching type" );
        
    end;
    
    if (!(@IsBound( category.caches[function_name] )) || IsString( category.caches[function_name] ))
        
        category.caches[function_name] = caching_info;
        
    elseif (IsCachingObject( category.caches[function_name] ))
        
        current_cache = category.caches[function_name];
        
        if (caching_info == "weak")
            SetCachingObjectWeak( current_cache );
        elseif (caching_info == "crisp")
            SetCachingObjectCrisp( current_cache );
        elseif (caching_info == "none")
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
    
    if (@not type in [ "weak", "crisp", "none" ])
        Error( "wrong type for caching" );
    end;
    
    category.default_cache_type = type;
    
    for current_name in RecNames( category.caches )
        
        if (current_name in CAP_INTERNAL.operation_names_with_cache_disabled_by_default)
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

    if (@not type in [ "weak", "crisp", "none" ])
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
    
    name = @Concatenation( "AutomaticCapCategory", StringGAP( CAP_INTERNAL_NAME_COUNTER( ) ) );
    
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
    
    return CreateCapCategoryWithDataTypes( name, category_filter, object_filter, morphism_filter, two_cell_filter, fail, fail, fail );
    
end );

##
InstallMethod( @__MODULE__,  CanCompute,
               [ IsCapCategory, IsString ],
               
  function( category, string )
    local weight_list;
    
    if (@not @IsBound( CAP_INTERNAL_METHOD_NAME_RECORD[string] ))
        
        Error( string, " is not the name of a CAP operation" );
        
    end;
    
    weight_list = category.derivations_weight_list;
    
    return CurrentOperationWeight( weight_list, string ) != infinity;
    
end );

##
InstallMethod( @__MODULE__,  CanCompute,
               [ IsCapCategory, IsFunction ],
               
  function( category, operation )
    
    Display( "WARNING: calling `CanCompute` with a CAP operation as the second argument should only be done for debugging purposes." );
    
    return CanCompute( category, NameFunction( operation ) );
    
end );

##
InstallMethod( @__MODULE__,  MissingOperationsForConstructivenessOfCategory,
               [ IsCapCategory, IsString ],
               
  function( category, string )
    local category_property, result_list;
    
    if (@not @IsBound( CAP_INTERNAL_CONSTRUCTIVE_CATEGORIES_RECORD[string] ))
      
      Error( "the given string is not a property of a category" );
    
    end;
    
    result_list = [];
    
    for category_property in CAP_INTERNAL_CONSTRUCTIVE_CATEGORIES_RECORD[string]
      
      if (@not CanCompute( category, category_property ))
        
        Add( result_list, category_property );
        
      end;
      
    end;
    
    return result_list;
    
end );

InstallDeprecatedAlias( "CheckConstructivenessOfCategory", "MissingOperationsForConstructivenessOfCategory", "2024.12.18" );

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
    
    if (category.overhead != true)
        
        Display( "WARNING: <category> was created with `overhead = false` and thus cannot collect timing statistics." );
        
    end;
    
    category.timing_statistics_enabled = true;
    
end );

@InstallGlobalFunction( "DisableTimingStatistics",
  function( category )
    
    if (category.overhead != true)
        
        Display( "WARNING: <category> was created with `overhead = false` and thus cannot collect timing statistics." );
        
    end;
    
    category.timing_statistics_enabled = false;
    
end );

@InstallGlobalFunction( "ResetTimingStatistics",
  function( category )
    local recname;
    
    if (category.overhead != true)
        
        Display( "WARNING: <category> was created with `overhead = false` and thus cannot collect timing statistics." );
        
    end;
    
    for recname in RecNames( category.timing_statistics )
        
        category.timing_statistics[recname] = [ ];
        
    end;
    
end );

@BindGlobal( "CAP_INTERNAL_PREPARE_TIMING_STATISTICS_FOR_DISPLAY",
  function( category )
    local header, warning, operations, total_time_global, times, execs, total_time, time_per_exec, recname;
    
    if (category.overhead != true)
        
        Display( "WARNING: <category> was created with `overhead = false` and thus cannot collect timing statistics." );
        
    end;
    
    header = @Concatenation( "Timing statistics for the primitive operations of the category ", Name( category ), ":" );
    
    operations = [ ];
    
    total_time_global = 0;
    
    for recname in SortedList( RecNames( category.timing_statistics ) )
        
        times = category.timing_statistics[recname];
        
        if (Length( times ) > 0)
            
            execs = Length( times );
            total_time = Sum( times );
            time_per_exec = IntGAP( total_time / execs * 1000 );
            
            Add( operations, @rec(
                name = recname,
                execs = execs,
                total_time = total_time,
                time_per_exec = time_per_exec,
            ) );
            
            total_time_global = total_time_global + total_time;
            
        end;
        
    end;
    
    if (IsEmpty( operations ))
        
        warning = "No timing statistics recorded, use `EnableTimingStatistics( <category> )` to enable timing statistics.";
        
    elseif (@not category.timing_statistics_enabled)
        
        warning = "WARNING: timing statistics for this category are disabled, so the results shown may not be up to date. Use `EnableTimingStatistics( <category> )` to enable timing statistics.";
        
    else
        
        warning = fail;
        
    end;
    
    return @rec(
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
    
    if (IsEmpty( info.operations ))
        
        Display( info.warning );
        
        return;
        
    end;
    
    Display( info.header );
    
    if (info.warning != fail)
        
        Display( info.warning );
        
    end;
    
    Display( @Concatenation( "Total time spent in primitive operations of this category: ", StringGAP( info.total_time_global ) , " ms" ) );
    
    for operation in info.operations
        
        Print(
            operation.name,
            " was called ",
            operation.execs,
            " times with a total runtime of ",
            operation.total_time,
            " ms ( == ",
            operation.time_per_exec,
            " μs per execution)\n"
        );
        
    end;
    
end );

if (IsPackageMarkedForLoading( "Browse", ">= 1.5" ))
    
    @InstallGlobalFunction( "BrowseTimingStatistics",
      function( category )
        local info, header, value_matrix, labelsRow, labelsCol, operation;
        
        info = CAP_INTERNAL_PREPARE_TIMING_STATISTICS_FOR_DISPLAY( category );
        
        if (IsEmpty( info.operations ))
            
            Display( info.warning );
            
            return;
            
        end;
        
        header = [ info.header ];
        
        if (info.warning != fail)
            
            Add( header, info.warning );
            
        end;
        
        Add( header, @Concatenation( "Total time spent in primitive operations of this category: ", StringGAP( info.total_time_global ) , " ms" ) );
        Add( header, "" );
        
        value_matrix = [ ];
        labelsRow = [ ];
        labelsCol = [ [ "times called", "total time (ms)", "time per execution (μs)"  ] ];
        
        for operation in info.operations
            
            Add( labelsRow, [ operation.name ] );
            
            Add( value_matrix, [ operation.execs, operation.total_time, operation.time_per_exec ] );
            
        end;
        
        NCurses.BrowseDenseList( value_matrix, @rec( header = header, labelsCol = labelsCol, labelsRow = labelsRow ) );
        
    end );
    
else
    
    @InstallGlobalFunction( "BrowseTimingStatistics",
      function( category )
        
        Display( "`BrowseTimingStatistics` needs the function `NCurses.BrowseDenseList`, which should be available in the package \"Browse\"." );
        Display( "Please load \"Browse\" before/together with \"CAP\" or use `DisplayTimingStatistics( <category> )` instead." );
        
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
      
      if (IsList( a ) && IsList( b ) && Size( a ) == Size( b ))
        
        return ForAll( (1):(Size( a )), i -> equality_func(a[i], b[i]) );
        
      else
        
        return IsIdenticalObj( a, b );
        
      end;
      
    end;
    
    while @not equality_func( objp, Down( objp ) )
      
      objp = Down( objp );
      
    end;
    
    return objp;
    
end );

#######################################
##
## Print
##
#######################################

InstallMethod( @__MODULE__,  StringGAP,
               [ IsCapCategory ],
    Name );

InstallMethod( @__MODULE__,  ViewString,
               [ IsCapCategory ],
    Name );

InstallMethod( @__MODULE__,  DisplayString,
               [ IsCapCategory ],
               
  function ( category )
    
    return @Concatenation( "A CAP category with name ", Name( category ), ":\n\n", InfoStringOfInstalledOperationsOfCategory( category ), "\n" );
    
end );

@InstallGlobalFunction( DisableAddForCategoricalOperations,
  
  function( category )
    
    if (@not IsCapCategory( category ))
        Error( "Argument must be a category" );
    end;
    
    category.add_primitive_output = false;
    
end );

@InstallGlobalFunction( EnableAddForCategoricalOperations,
  
  function( category )
    
    if (@not IsCapCategory( category ))
        Error( "Argument must be a category" );
    end;
    
    category.add_primitive_output = true;
    
end );

InstallMethod( @__MODULE__,  CellFilter,
               [ IsCapCategory ],

  function ( category )
    
    Error( "Categories do not have an attribute `CellFilter` anymore." );
    
end );
