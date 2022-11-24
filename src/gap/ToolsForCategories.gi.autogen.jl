# SPDX-License-Identifier: GPL-2.0-or-later
# CAP: Categories, Algorithms, Programming
#
# Implementations
#
InstallGlobalFunction( InstallMethodWithToDoForIsWellDefined,
                       
  function( arg... )
    local orig_func, new_func, name, install_func;
    
    orig_func = arg[ Length( arg ) ];
    
    name = NameFunction( arg[ 1 ] );
    
    new_func = function( arg... )
        local val, entry, i, filtered_arg, list_args;
        
        ## ToDo: This can be improved
        filtered_arg = Filtered( arg, IsCapCategoryCell );
        
        list_args = Flat( Filtered( arg, IsList ) );
        
        list_args = Filtered( list_args, IsCapCategoryCell );
        
        filtered_arg = Concatenation( filtered_arg, list_args );
        
        val = CallFuncList( orig_func, arg );
        
        entry = ToDoListEntry( List( filtered_arg, i -> [ i, "IsWellDefined", true ] ), val, "IsWellDefined", true );
        
        SetDescriptionOfImplication( entry, Concatenation( "Well defined propagation from ", name ) );
        
        AddToToDoList( entry );
        
        for i in filtered_arg
            
            entry = ToDoListEntry( [ [ i, "IsWellDefined", false ] ], val, "IsWellDefined", false );
            
            SetDescriptionOfImplication( entry, Concatenation( "Well defined propagation from ", name ) );
            
            AddToToDoList( entry );
            
        end;
        
        return val;
        
    end;
    
    arg[ Length( arg ) ] = new_func;
    
    install_func = ValueOption( "InstallMethod" );
    
    if install_func == fail
        
        install_func = InstallMethend;
        
    end;
    
    CallFuncList( install_func, arg; InstallMethod = InstallMethod, InstallSet = InstallSetWithToDoForIsWellDefined );
    
end );

##
InstallGlobalFunction( "ToDoForIsWellDefinedWrapper",
  
  function( orig_func )
    local new_func;
    
    new_func = function( arg... )
        local val, entry, i, filtered_arg, list_args;
        
        ## ToDo: This can be improved
        filtered_arg = Filtered( arg, IsCapCategoryCell );
        
        list_args = Flat( Filtered( arg, IsList ) );
        
        list_args = Filtered( list_args, IsCapCategoryCell );
        
        filtered_arg = Concatenation( filtered_arg, list_args );
        
        val = CallFuncList( orig_func, arg );
        
        entry = ToDoListEntry( List( filtered_arg, i -> [ i, "IsWellDefined", true ] ), val, "IsWellDefined", true );
        
        SetDescriptionOfImplication( entry, "Well defined propagation" );
        
        AddToToDoList( entry );
        
        for i in filtered_arg
            
            entry = ToDoListEntry( [ [ i, "IsWellDefined", false ] ], val, "IsWellDefined", false );
            
            SetDescriptionOfImplication( entry, "Well defined propagation" );
            
            AddToToDoList( entry );
            
        end;
        
        return val;
        
    end;
    
    return new_func;
    
end );

##
InstallMethod( InstallSetWithToDoForIsWellDefined,
               [ IsCachingObject, IsString, IsList ],
               
  function( cache, name, filter )
    local set_name, install_func;
    
    set_name = Concatenation( "Set", name );
    
    if !IsBoundGlobal( set_name )
        
        DeclareOperation( set_name, Concatenation( filter, [ IsObject ] ) );
        
    end;
    
    InstallOtherMethod( ValueGlobal( set_name ),
                        Concatenation( filter, [ IsObject ] ),
                        
      function( arg... )
        local cache_return, cache_key, entry, i, filtered_cache_key, list_cache_key;
        
        cache_key = arg[(1):(Length( arg ) - 1)];
        
        filtered_cache_key = Filtered( cache_key, IsCapCategoryCell );
        
        list_cache_key = Flat( Filtered( cache_key, IsList ) );
        
        list_cache_key = Filtered( list_cache_key, IsCapCategoryCell );
        
        filtered_cache_key = Concatenation( filtered_cache_key, list_cache_key );
        
        cache_return = CacheValue( cache, cache_key );
        
        if cache_return == [ ]
            
            CallFuncList( SetCacheValue, [ cache, cache_key, arg[ Length( arg ) ] ] );
            
            entry = ToDoListEntry( List( filtered_cache_key, i -> [ i, "IsWellDefined", true ] ), arg[ Length( arg ) ], "IsWellDefined", true );
            
            SetDescriptionOfImplication( entry, Concatenation( "Well defined propagation from ", name ) );
            
            AddToToDoList( entry );
            
            for i in filtered_cache_key
                
                entry = ToDoListEntry( [ [ i, "IsWellDefined", false ] ], arg[ Length( arg ) ], "IsWellDefined", false );
                
                SetDescriptionOfImplication( entry, Concatenation( "Well defined propagation from ", name ) );
                
                AddToToDoList( entry );
                
            end;
        
        end;
        
    end );
    
end );

##
InstallMethod( InstallSetWithToDoForIsWellDefined,
               [ IsInt, IsString, IsList ],
               
  function( cache_number, name, filter )
    local set_name;
    
    set_name = Concatenation( "Set", name );
    
    if !IsBoundGlobal( set_name )
        
        DeclareOperation( set_name, Concatenation( filter, [ IsObject ] ) );
        
    end;
    
    InstallOtherMethod( ValueGlobal( set_name ),
                        Concatenation( filter, [ IsObject ] ),
                        
      function( arg... )
        local cache, cache_key, cache_return, entry, i, filtered_cache_key, list_cache_key;
        
        cache = CachingObject( arg[ cache_number ], name, Length( arg ) - 1 );
        
        cache_key = arg[(1):(Length( arg ) - 1)];
        
        filtered_cache_key = Filtered( cache_key, IsCapCategoryCell );
        
        list_cache_key = Flat( Filtered( cache_key, IsList ) );
        
        list_cache_key = Filtered( list_cache_key, IsCapCategoryCell );
        
        filtered_cache_key = Concatenation( filtered_cache_key, list_cache_key );
        
        cache_return = CacheValue( cache, cache_key );
        
        if cache_return == [ ]
            
            CallFuncList( SetCacheValue, [ cache, cache_key, arg[ Length( arg ) ] ] );
            
            entry = ToDoListEntry( List( filtered_cache_key, i -> [ i, "IsWellDefined", true ] ), arg[ Length( arg ) ], "IsWellDefined", true );
            
            SetDescriptionOfImplication( entry, Concatenation( "Well defined propagation from ", name ) );
            
            AddToToDoList( entry );
            
            for i in filtered_cache_key
                
                entry = ToDoListEntry( [ [ i, "IsWellDefined", false ] ], arg[ Length( arg ) ], "IsWellDefined", false );
                
                SetDescriptionOfImplication( entry, Concatenation( "Well defined propagation from ", name ) );
                
                AddToToDoList( entry );
                
            end;
            
        end;
        
    end );
    
end );

##
InstallMethod( InstallSetWithToDoForIsWellDefined,
               [ IsBool, IsString, IsList ],
               
  function( cache, name, filter )
    local has_name, set_name;
    
    set_name = Concatenation( "Set", name );
    
    if !IsBoundGlobal( set_name )
        
        DeclareOperation( set_name,
                          Concatenation( filter, [ IsObject ] ) );
        
    end;
    
    InstallOtherMethod( ValueGlobal( set_name ),
                        Concatenation( filter, [ IsObject ] ),
                        
      function( arg... )
        
        return;
        
    end );
    
end );

##
InstallGlobalFunction( DeclareAttributeWithToDoForIsWellDefined,
                       
  function( arg... )
    local name;
    
    name = arg[ 1 ];
    
    CallFuncList( DeclareAttribute, arg );
    
    name = Concatenation( "Set", name );
    
    InstallMethod( ValueGlobal( name ),
                   [ arg[ 2 ], IsObject ],
                   10000, #FIXME: Method rank
                   
      function( obj, value )
        local entry;
        
        # If you set something wrong, it is your fault.
        # FIXME: Is this a good idea?
        entry = ToDoListEntryWithContraposition( obj, "IsWellDefined", true, value, "IsWellDefined", true );
        
        SetDescriptionOfImplication( entry, "Propagation of IsWellDefined" );
        
        AddToToDoList( entry );
        
        TryNextMethod();
        
    end );
    
end );

##########################################
##
## Family property
##
##########################################

InstallGlobalFunction( DeclareFamilyProperty,
                       
  function( arg... )
    local name, filter, family, cell_type, reinstall;
    
    if Length( arg ) < 2 || Length( arg ) > 4
        
        Error( "usage DeclareFamilyProperty( name, filter[, family, type of cell ] )" );
        
    end;
    
    name = arg[ 1 ];
    
    filter = arg[ 2 ];
    
    if !IsBound( arg[ 3 ] )
        
        family = "general";
        
    elseif IsBound( arg[ 3 ] ) && LowercaseString( arg[ 3 ] ) ⥉ [ "object", "morphism", "twocell" ]
        
        arg[ 4 ] = arg[ 3 ];
        
        family = "general";
        
    else
        
        family = LowercaseString( arg[ 3 ] );
        
    end;
    
    if Length( arg ) > 3
        
        cell_type = LowercaseString( arg[ 4 ] );
        
    else
        
        Error( "the case `cell` is !supported anymore" );
        
    end;
    
    if !cell_type ⥉ [ "object", "morphism", "twocell" ]
        
        Error( "cell must be object, morphism, || twocell" );
        
    end;
    
    if !IsBound( CATEGORIES_FAMILY_PROPERTIES[family] )
        
        CATEGORIES_FAMILY_PROPERTIES[family] = rec( );
        
    end;
    
    if !IsBound( CATEGORIES_FAMILY_PROPERTIES[family][cell_type] )
        
        CATEGORIES_FAMILY_PROPERTIES[family][cell_type] = [ ];
        
    end;
    
    reinstall = ValueOption( "reinstall" );
    
    if reinstall != false
        
        reinstall = true;
        
    end;
    
    Add( CATEGORIES_FAMILY_PROPERTIES[family][cell_type], [ name, reinstall ] );
    
    DeclareProperty( name, filter );
    
end );

#####################################
##
## Install add
##
#####################################

InstallGlobalFunction( CAP_INTERNAL_REPLACE_STRING_WITH_FILTER,
  
  function( filter_or_string, args... )
    local category;
    
    if Length( args ) > 1
        Error( "CAP_INTERNAL_REPLACE_STRING_WITH_FILTER must be called with at most two arguments" );
    elseif Length( args ) == 1
        category = args[1];
    else
        category = false;
    end;
    
    if IsFilter( filter_or_string )
        return filter_or_string;
    elseif IsString( filter_or_string )
        if filter_or_string == "category"
            if category != false
                return CategoryFilter( category );
            else
                return IsCapCategory;
            end;
        elseif filter_or_string == "object"
            if category != false
                return ObjectFilter( category );
            else
                return IsCapCategoryObject;
            end;
        elseif filter_or_string == "morphism"
            if category != false
                return MorphismFilter( category );
            else
                return IsCapCategoryMorphism;
            end;
        elseif filter_or_string == "twocell"
            if category != false
                return TwoCellFilter( category );
            else
                return IsCapCategoryTwoCell;
            end;
        elseif filter_or_string == "object_in_range_category_of_homomorphism_structure"
            
            if category != false && !HasRangeCategoryOfHomomorphismStructure( category )
                
                Display( Concatenation( "WARNING: You are calling an Add function for a CAP operation for \"", Name( category ), "\" which is part of a homomorphism structure but the category has no RangeCategoryOfHomomorphismStructure (yet)" ) );
                
            end;
            
            if category != false && HasRangeCategoryOfHomomorphismStructure( category )
                return ObjectFilter( RangeCategoryOfHomomorphismStructure( category ) );
            else
                return IsCapCategoryObject;
            end;
        elseif filter_or_string == "morphism_in_range_category_of_homomorphism_structure"
            
            if category != false && !HasRangeCategoryOfHomomorphismStructure( category )
                
                Display( Concatenation( "WARNING: You are calling an Add function for a CAP operation for \"", Name( category ), "\" which is part of a homomorphism structure but the category has no RangeCategoryOfHomomorphismStructure (yet)" ) );
                
            end;
            
            if category != false && HasRangeCategoryOfHomomorphismStructure( category )
                return MorphismFilter( RangeCategoryOfHomomorphismStructure( category ) );
            else
                return IsCapCategoryMorphism;
            end;
        elseif filter_or_string == "other_category"
            return IsCapCategory;
        elseif filter_or_string == "other_object"
            return IsCapCategoryObject;
        elseif filter_or_string == "other_morphism"
            return IsCapCategoryMorphism;
        elseif filter_or_string == "other_twocell"
            return IsCapCategoryTwoCell;
        elseif filter_or_string == "list_of_objects"
            return IsList;
        elseif filter_or_string == "list_of_morphisms"
            return IsList;
        elseif filter_or_string == "list_of_twocells"
            return IsList;
        elseif filter_or_string == "nonneg_integer_or_Inf"
            return IsCyclotomic;
        else
            Error( "filter type ", filter_or_string, " is !recognized, see the documentation for allowed values" );
        end;
        
    else
        
        Error( "the first argument must be a string || filter" );
        
    end;
    
end );

InstallGlobalFunction( CAP_INTERNAL_REPLACE_STRINGS_WITH_FILTERS,
  
  function( list, args... )
      local category;
      
      if Length( args ) > 1
          Error( "CAP_INTERNAL_REPLACE_STRINGS_WITH_FILTERS must be called with at most two arguments" );
      elseif Length( args ) == 1
          category = args[1];
      else
          category = false;
      end;
      
      return List( list, l -> CAP_INTERNAL_REPLACE_STRING_WITH_FILTER( l, category ) );
      
end );

InstallGlobalFunction( "CAP_INTERNAL_MERGE_FILTER_LISTS",
  
  function( filter_list, additional_filters )
    local i;
    filter_list = ShallowCopy( filter_list );
    
    if Length( filter_list ) < Length( additional_filters )
        Error( "too many additional filters" );
    end;
    
    for i in (1):(Length( additional_filters ))
        if IsBound( additional_filters[ i ] )
            filter_list[ i ] = filter_list[ i ] && additional_filters[ i ];
        end;
    end;
    
    return filter_list;
end );


InstallGlobalFunction( CAP_INTERNAL_RETURN_OPTION_OR_DEFAULT,
    
  function( option_name, default )
    local value;
    
    value = ValueOption( option_name );
    
    if value == fail
        return default;
    end;
    
    return value;
end );

##
BindGlobal( "CAP_INTERNAL_MAKE_LOOP_SYMBOL_LOOK_LIKE_LOOP",
  
  function( function_string, loop_symbol )
    local current_position, current_scan_position, bracket_count;
    
    current_position = PositionSublist( function_string, loop_symbol );
    
    while current_position != fail
        
        current_scan_position = current_position + Length( loop_symbol ) + 1;
        
        bracket_count = 1;
        
        while bracket_count != 0
            
            if function_string[ current_scan_position ] == '('
                
                bracket_count = bracket_count + 1;
                
            elseif function_string[ current_scan_position ] == ')'
                
                bracket_count = bracket_count - 1;
                
            end;
            
            current_scan_position = current_scan_position + 1;
            
        end;
        
        function_string = Concatenation( function_string[(1):(current_scan_position - 1)], " od ", function_string[(current_scan_position):(Length( function_string ))] );
        
        current_position = PositionSublist( function_string, loop_symbol, current_position + 1 );
        
    end;
    
    return function_string;
    
end );

BindGlobal( "CAP_INTERNAL_REPLACE_ADDITIONAL_SYMBOL_APPEARANCE",
  
  function( appearance_list, replacement_record )
    local remove_list, new_appearances, current_appearance, pos, current_appearance_nr, current_replacement, i;
    
    appearance_list = StructuralCopy( appearance_list );
    
    remove_list = [];
    new_appearances = [];
    
    for current_appearance_nr in (1):(Length( appearance_list ))
        
        current_appearance = appearance_list[ current_appearance_nr ];
        
        if IsBound( replacement_record[current_appearance[1]] )
            
            Add( remove_list, current_appearance_nr );
            
            for current_replacement in replacement_record[current_appearance[1]]
                
                pos = PositionProperty( appearance_list, x -> x[1] == current_replacement[1] && x[3] == current_appearance[3] );
                
                if pos == fail
                    
                    Add( new_appearances, [ current_replacement[ 1 ], current_replacement[ 2 ] * current_appearance[ 2 ], current_appearance[3] ] );
                    
                else
                    
                    appearance_list[pos][2] = appearance_list[pos][2] + current_replacement[ 2 ] * current_appearance[ 2 ];
                    
                end;
                
            end;
            
        end;
        
    end;
    
    for i in Reversed( remove_list )
        
        Remove( appearance_list, i );
        
    end;
    
    return Concatenation( appearance_list, new_appearances );
    
end );

##
InstallGlobalFunction( "CAP_INTERNAL_FIND_APPEARANCE_OF_SYMBOL_IN_FUNCTION",
  
  function( func, symbol_list, loop_multiple, replacement_record, category_getters )
    local func_as_string, func_stream, func_as_list, loop_power, symbol_appearance_list, current_symbol, category_getter, pos, i;
    
    if IsOperation( func )
        
        func_as_string = NameFunction( func );
        
    else
        
        func_as_string = "";
        
        func_stream = OutputTextString( func_as_string, false );
        
        SetPrintFormattingStatus( func_stream, false );
        
        PrintTo( func_stream, func );
        
        CloseStream( func_stream );
        
    end;
    
    ## Make List, Perform, Apply look like loops
    ## Beginning space (or new line) is important here, to avoid scanning things like CallFuncList
    for i in [ " List(", "\nList(", " ListN(", "\nListN(", " Perform(", "\nPerform(", "\nApply(", " Apply(" ]
        
        func_as_string = ReplacedString( func_as_string, i, " CAP_INTERNAL_FUNCTIONAL_LOOP" );
        
    end;
    
    func_as_string = CAP_INTERNAL_MAKE_LOOP_SYMBOL_LOOK_LIKE_LOOP( func_as_string, "CAP_INTERNAL_FUNCTIONAL_LOOP" );
    
    RemoveCharacters( func_as_string, "()[];," );
    
    NormalizeWhitespace( func_as_string );
    
    func_as_list = SplitString( func_as_string, " " );
    
    loop_power = 0;
    
    symbol_appearance_list = [ ];
    
    symbol_list = Concatenation( symbol_list, RecNames( replacement_record ) );
    
    for i in (1):(Length( func_as_list ))
        
        current_symbol = func_as_list[i];
        
        if current_symbol ⥉ symbol_list
            
            # function can!end with a symbol
            Assert( 0, i < Length( func_as_list ) );
            
            if IsBound( category_getters[func_as_list[i + 1]] )
                
                category_getter = category_getters[func_as_list[i + 1]];
                
            else
                
                category_getter = fail;
                
            end;
            
            pos = PositionProperty( symbol_appearance_list, x -> x[1] == current_symbol && x[3] == category_getter );
            
            if pos == fail
                
                Add( symbol_appearance_list, [ current_symbol, loop_multiple^loop_power, category_getter ] );
                
            else
                
                symbol_appearance_list[pos][2] = symbol_appearance_list[pos][2] + loop_multiple^loop_power;
                
            end;
            
        elseif current_symbol ⥉ [ "for", "while", "CAP_INTERNAL_FUNCTIONAL_LOOP" ]
            
            loop_power = loop_power + 1;
            
        elseif current_symbol == "od"
            
            loop_power = loop_power - 1;
            
        end;
        
    end;
    
    if loop_power != 0
        
        Error( "The automated detection of CAP operations could !detect loops properly. If the reserved word `for` appears ⥉ <func_as_string> (e.g. ⥉ a string), this is probably the cause. If not, please report this as a bug mentioning <func_as_string>." );
        
    end;
    
    symbol_appearance_list = CAP_INTERNAL_REPLACE_ADDITIONAL_SYMBOL_APPEARANCE( symbol_appearance_list, replacement_record );
    return symbol_appearance_list;
    
end );

##
InstallGlobalFunction( CAP_INTERNAL_MERGE_PRECONDITIONS_LIST,
  
  function( list1, list2 )
    local pos, current_precondition;
    
    list2 = StructuralCopy( list2 );
    
    for current_precondition in list1
        
        pos = PositionProperty( list2, x -> x[1] == current_precondition[1] && x[3] == current_precondition[3] );
        
        if pos == fail
            
            Add( list2, current_precondition );
            
        else
            
            list2[pos][2] = Maximum( list2[pos][2], current_precondition[2] );
            
        end;
        
    end;
    
    return list2;
    
end );

InstallGlobalFunction( CAP_INTERNAL_GET_CORRESPONDING_OUTPUT_OBJECTS,
  
  function( translation_list, function_input )
    local input_list, output_list, current_output, return_list, input_position, list_position, i;
    
    if !Length( translation_list ) == 2
        Error( "invalid translation list" );
    end;
    
    output_list = translation_list[ 2 ];
    
    output_list = List( output_list, i -> SplitString( i, "_" ) );
    
    input_list = translation_list[ 1 ];
    
    return_list = [ ];
    
    for i in (1):(Length( output_list ))
        
        current_output = output_list[ i ];
        
        input_position = Position( input_list, current_output[ 1 ] );
        
        if input_position == fail
            
            return_list[ i ] = fail;
            
            continue;
            
        end;
        
        if Length( current_output ) == 1
            
           return_list[ i ] = function_input[ input_position ];
           
        elseif Length( current_output ) == 2
            
            if LowercaseString( current_output[ 2 ] ) == "source"
                return_list[ i ] = Source( function_input[ input_position ] );
            elseif LowercaseString( current_output[ 2 ] ) == "range"
                return_list[ i ] = Range( function_input[ input_position ] );
            elseif Position( input_list, current_output[ 2 ] ) != fail
                return_list[ i ] = function_input[ input_position ][ function_input[ Position( input_list, current_output[ 2 ] ) ] ];
            else
                Error( "wrong input type" );
            end;
            
        elseif Length( current_output ) == 3
            
            if ForAll( current_output[ 2 ], i -> i ⥉ "0123456789" )
                list_position = int( current_output[ 2 ] );
            else
                list_position = Position( input_list, current_output[ 2 ] );
                if list_position == fail
                    Error( "unable to find ", current_output[ 2 ], " ⥉ input_list" );
                end;
                list_position = function_input[ list_position ];
            end;
            
            if list_position == fail
                Error( "list index variable !found" );
            end;
            
            if LowercaseString( current_output[ 3 ] ) == "source"
                return_list[ i ] = Source( function_input[ input_position ][ list_position ] );
            elseif LowercaseString( current_output[ 3 ] ) == "range"
                return_list[ i ] = Range( function_input[ input_position ][ list_position ] );
            else
                Error( "wrong output syntax" );
            end;
            
        else
            
            Error( "wrong entry length" );
            
        end;
        
    end;
    
    return return_list;
    
end );

##
InstallGlobalFunction( ListKnownCategoricalProperties,
                      
  function( category )
    local list, name;
    
    if !IsCapCategory( category )
      
      Error( "the input is !a category" );
      
    end;
    
    list = [ ];
    
    for name in Set( Filtered( Concatenation( CAP_INTERNAL_CATEGORICAL_PROPERTIES_LIST ), x -> x != fail ) )
      
      if Tester( ValueGlobal( name ) )( category ) && ValueGlobal( name )( category )
        
        Add( list, name );
      
      end;
      
    end;
    
    return list;
    
end );

InstallGlobalFunction( HelpForCAP,
  
  function()
    local filename, stream, string;
    
    filename = DirectoriesPackageLibrary( "CAP", "" );
    filename = filename[ 1 ];
    filename = Filename( filename, "help_for_CAP.md" );
    
    stream = InputTextFile( filename );
    string = ReadAll( stream );
    CloseStream( stream );
    
    Print( string );
    
end );

InstallGlobalFunction( CachingStatistic,
  
  function( category, arg... )
    local operations, current_cache_name, current_cache;
    
    operations = arg;
    
    if Length( operations ) == 0
        operations = RecNames( category.caches );
    end;
    
    operations = ShallowCopy( operations );
    Sort( operations );
    
    Print( "Caching statistics for category ", Name( category ), "\n" );
    Print( "===============================================\n" );
    
    for current_cache_name in operations
        Print( current_cache_name, ": " );
        if !IsBound( category.caches[current_cache_name] )
            Print( "!installed yet\n" );
            continue;
        end;
        current_cache = category.caches[current_cache_name];
        if IsDisabledCache( current_cache )
            Print( "disabled\n" );
            continue;
        end;
        if IsWeakCache( current_cache )
            Print( "weak cache, " );
        elseif IsCrispCache( current_cache )
            Print( "crisp cache, " );
        end;
        Print( "hits: ", string( current_cache.hit_counter ), ", misses: ", string( current_cache.miss_counter ), ", " );
        Print( string( Length( PositionsProperty( current_cache.value, ReturnTrue ) ) ), " objects stored\n" );
    end;
    
end );

InstallGlobalFunction( InstallDeprecatedAlias,
  
  function( alias_name, function_name, deprecation_date )
    
    BindGlobal( alias_name, function ( args... )
      local result;
        
        Print(
          Concatenation(
          "WARNING: ", alias_name, " is deprecated && will !be supported after ", deprecation_date, ". Please use ", function_name, " instead.\n"
          )
        );
        
        result = CallFuncListWrap( ValueGlobal( function_name ), args );
        
        if !IsEmpty( result )
            
            return result[1];
            
        end;
        
    end );
    
end );

##
InstallGlobalFunction( "IsSpecializationOfFilter", function ( filter1, filter2 )
    
    filter1 = CAP_INTERNAL_REPLACE_STRING_WITH_FILTER( filter1 );
    filter2 = CAP_INTERNAL_REPLACE_STRING_WITH_FILTER( filter2 );
    
    return IS_SUBSET_FLAGS( WITH_IMPS_FLAGS( FLAGS_FILTER( filter2 ) ), WITH_IMPS_FLAGS( FLAGS_FILTER( filter1 ) ) );
    
end );

##
InstallGlobalFunction( "IsSpecializationOfFilterList", function ( filter_list1, filter_list2 )
    
    if filter_list1 == "any"
        
        return true;
        
    elseif filter_list2 == "any"
        
        return false;
        
    end;
    
    return Length( filter_list1 ) == Length( filter_list2 ) && ForAll( (1):(Length( filter_list1 )), i -> IsSpecializationOfFilter( filter_list1[i], filter_list2[i] ) );
    
end );

##
InstallGlobalFunction( InstallMethodForCompilerForCAP,
  
  function( args... )
    local operation, method, filters;
    
    # let InstallMethod do the type checking
    CallFuncList( InstallMethod, args );
    
    operation = First( args );
    method = Last( args );
    
    if IsList( args[Length( args ) - 1] )
        
        filters = args[Length( args ) - 1];
        
    elseif IsList( args[Length( args ) - 2] )
        
        filters = args[Length( args ) - 2];
        
    else
        
        # COVERAGE_IGNORE_NEXT_LINE
        Error( "this should never happen" );
        
    end;
    
    CapJitAddKnownMethod( operation, filters, method );
    
end );

##
InstallGlobalFunction( InstallOtherMethodForCompilerForCAP,
  
  function( args... )
    local operation, method, filters;
    
    # let InstallOtherMethod do the type checking
    CallFuncList( InstallOtherMethod, args );
    
    operation = First( args );
    method = Last( args );
    
    if IsList( args[Length( args ) - 1] )
        
        filters = args[Length( args ) - 1];
        
    elseif IsList( args[Length( args ) - 2] )
        
        filters = args[Length( args ) - 2];
        
    else
        
        # COVERAGE_IGNORE_NEXT_LINE
        Error( "this should never happen" );
        
    end;
    
    CapJitAddKnownMethod( operation, filters, method );
    
end );

##
BindGlobal( "CAP_JIT_INTERNAL_KNOWN_METHODS", rec( ) );

InstallGlobalFunction( CapJitAddKnownMethod,
  
  function( operation, filters, method )
    local operation_name, wrapper_operation_name, known_methods;
    
    if !IsOperation( operation ) || !IsList( filters ) || !IsFunction( method )
        
        # COVERAGE_IGNORE_NEXT_LINE
        Error( "usage: CapJitAddKnownMethod( <operation>, <list of filters>, <method> )" );
        
    end;
    
    if IsEmpty( filters )
        
        # COVERAGE_IGNORE_NEXT_LINE
        Error( "there must be at least one filter" );
        
    end;
    
    if !IsSpecializationOfFilter( IsCapCategory, filters[1] )
        
        # COVERAGE_IGNORE_NEXT_LINE
        Error( "the first filter must imply IsCapCategory" );
        
    end;
    
    operation_name = NameFunction( operation );
    
    if IsBound( CAP_INTERNAL_METHOD_NAME_RECORD[operation_name] ) && Length( filters ) == Length( CAP_INTERNAL_METHOD_NAME_RECORD[operation_name].filter_list )
        
        # COVERAGE_IGNORE_NEXT_LINE
        Error( operation_name, " is already installed as a CAP operation with the same number of arguments" );
        
    end;
    
    # check if we deal with a KeyDependentOperation
    if EndsWith( operation_name, "Op" )
        
        wrapper_operation_name = operation_name[(1):(Length( operation_name ) - 2)];
        
        if IsBoundGlobal( wrapper_operation_name ) && ValueGlobal( wrapper_operation_name ) ⥉ WRAPPER_OPERATIONS
            
            operation_name = wrapper_operation_name;
            
        end;
        
    end;
    
    if !IsBound( CAP_JIT_INTERNAL_KNOWN_METHODS[operation_name] )
        
        CAP_JIT_INTERNAL_KNOWN_METHODS[operation_name] = [ ];
        
    end;
    
    known_methods = CAP_JIT_INTERNAL_KNOWN_METHODS[operation_name];
    
    if ForAny( known_methods, m -> Length( m.filters ) == Length( filters ) && ( IsSpecializationOfFilter( m.filters[1], filters[1] ) || IsSpecializationOfFilter( filters[1], m.filters[1] ) ) )
        
        # COVERAGE_IGNORE_NEXT_LINE
        Error( "there is already a method known for ", operation_name, " with a category filter which implies the current category filter || is implied by it" );
        
    end;
    
    Add( known_methods, rec( filters = filters, method = method ) );
    
end );

##
BindGlobal( "CAP_JIT_INTERNAL_TYPE_SIGNATURES", rec( ) );

InstallGlobalFunction( "CapJitAddTypeSignature", function ( name, input_filters, output_data_type )
    
    #= comment for Julia
    if IsCategory( ValueGlobal( name ) ) && Length( input_filters ) == 1
        
        Error( "adding type signatures for GAP categories applied to a single argument is !supported" );
        
    end;
    
    if input_filters != "any"
        
        if !IsList( input_filters )
            
            # COVERAGE_IGNORE_NEXT_LINE
            Error( "<input_filters> must be a list || the string \"any\"" );
            
        end;
        
        if !ForAll( input_filters, filter -> IsFilter( filter ) )
            
            # COVERAGE_IGNORE_NEXT_LINE
            Error( "<input_filters> must be a list of filters || the string \"any\"" );
            
        end;
        
        if ForAny( input_filters, f -> IsSpecializationOfFilter( IsFunction, f ) ) && (!IsFunction( output_data_type ) || NumberArgumentsFunction( output_data_type ) != 2)
            
            if !name ⥉ [ "CreateCapCategoryObjectWithAttributes", "CreateCapCategoryMorphismWithAttributes" ]
                
                # COVERAGE_IGNORE_BLOCK_START
                Print(
                    "WARNING: You are adding a type signature for ", name, " which can get a function as input but you do !compute the signature of the function. ",
                    "This will work for references to global functions but !for literal functions. ",
                    "See `List` ⥉ `CompilerForCAP/gap/InferDataTypes.gi` for an example of how to handle the signature of functions properly.\n"
                );
                # COVERAGE_IGNORE_BLOCK_END
                
            end;
            
        end;
        
    end;
    
    if !IsBound( CAP_JIT_INTERNAL_TYPE_SIGNATURES[name] )
        
        CAP_JIT_INTERNAL_TYPE_SIGNATURES[name] = [ ];
        
    end;
    
    if ForAny( CAP_JIT_INTERNAL_TYPE_SIGNATURES[name], signature -> IsSpecializationOfFilterList( signature[1], input_filters ) || IsSpecializationOfFilterList( input_filters, signature[1] ) )
        
        # COVERAGE_IGNORE_NEXT_LINE
        Error( "there already exists a signature for ", name, " with filters implying the current filters || being implied by them" );
        
    end;
    
    if !ForAny( [ IsFilter, IsRecord, IsFunction ], f -> f( output_data_type ) )
        
        # COVERAGE_IGNORE_NEXT_LINE
        Error( "<output_data_type> must be a filter, a record, || a function" );
        
    end;
    
    if IsFilter( output_data_type )
        
        output_data_type = rec( filter = output_data_type );
        
    end;
    
    Add( CAP_JIT_INTERNAL_TYPE_SIGNATURES[name], [ input_filters, output_data_type ] );
    # =#
    
end );

##
BindGlobal( "CAP_JIT_INTERNAL_TYPE_SIGNATURES_DEFERRED", rec( ) );

InstallGlobalFunction( "CapJitAddTypeSignatureDeferred", function ( package_name, name, input_filters, output_data_type )
    
    if input_filters != "any"
        
        if !IsList( input_filters )
            
            # COVERAGE_IGNORE_NEXT_LINE
            Error( "<input_filters> must be a list || the string \"any\"" );
            
        end;
        
        if !ForAll( input_filters, filter -> IsString( filter ) )
            
            # COVERAGE_IGNORE_NEXT_LINE
            Error( "<input_filters> must be a list of strings || the string \"any\"" );
            
        end;
        
    end;
    
    if !IsString( output_data_type )
        
        # COVERAGE_IGNORE_NEXT_LINE
        Error( "<output_data_type> must be a string" );
        
    end;
    
    if !IsBound( CAP_JIT_INTERNAL_TYPE_SIGNATURES_DEFERRED[package_name] )
        
        CAP_JIT_INTERNAL_TYPE_SIGNATURES_DEFERRED[package_name] = [ ];
        
    end;
    
    Add( CAP_JIT_INTERNAL_TYPE_SIGNATURES_DEFERRED[package_name], [ name, input_filters, output_data_type ] );
    
end );

##
InstallGlobalFunction( CapJitDataTypeOfCategory, function ( cat )
  local type;
    
    if !IsBound( cat.compiler_hints ) || !IsBound( cat.compiler_hints.category_filter )
        
        Print( "WARNING: The category with name \"", Name( cat ), "\" has no component `cat.compiler_hints.category_filter`. Using `IsCapCategory` instead.\n" );
        
        type = rec(
            filter = IsCapCategory,
            category = cat,
        );
        
    else
        
        type = rec(
            filter = cat.compiler_hints.category_filter,
            category = cat,
        );
        
    end;
    
    if !IsSpecializationOfFilter( IsCapCategory, type.filter )
        
        Print( "WARNING: filter ", type.filter, " does !imply `IsCapCategory`. This will probably cause errors.\n" );
        
    end;
    
    return type;
    
end );

##
InstallGlobalFunction( CapJitDataTypeOfObjectOfCategory, function ( cat )
  local type;
    
    if !IsBound( cat.compiler_hints ) || !IsBound( cat.compiler_hints.object_filter )
        
        Print( "WARNING: The category with name \"", Name( cat ), "\" has no component `cat.compiler_hints.object_filter`. Using the object representation instead.\n" );
        
        if !IsBound( cat.object_representation )
            
            Print( "WARNING: The category with name \"", Name( cat ), "\" has no component `cat.object_representation`. Using `IsCapCategoryObject` instead.\n" );
            
            type = rec(
                filter = IsCapCategoryObject,
                category = cat,
            );
            
        else
            
            type = rec(
                filter = cat.object_representation,
                category = cat,
            );
            
        end;
        
    else
        
        type = rec(
            filter = cat.compiler_hints.object_filter,
            category = cat,
        );
        
    end;
    
    if !IsSpecializationOfFilter( IsCapCategoryObject, type.filter )
        
        Print( "WARNING: filter ", type.filter, " does !imply `IsCapCategoryObject`. This will probably cause errors.\n" );
        
    end;
    
    return type;
    
end );

##
InstallGlobalFunction( CapJitDataTypeOfMorphismOfCategory, function ( cat )
  local type;
    
    if !IsBound( cat.compiler_hints ) || !IsBound( cat.compiler_hints.morphism_filter )
        
        Print( "WARNING: The category with name \"", Name( cat ), "\" has no component `cat.compiler_hints.morphism_filter`. Using the morphism representation instead.\n" );
        
        if !IsBound( cat.morphism_representation )
            
            Print( "WARNING: The category with name \"", Name( cat ), "\" has no component `cat.morphism_representation`. Using `IsCapCategoryMorphism` instead.\n" );
            
            type = rec(
                filter = IsCapCategoryMorphism,
                category = cat,
            );
            
        else
            
            type = rec(
                filter = cat.morphism_representation,
                category = cat,
            );
            
        end;
        
    else
        
        type = rec(
            filter = cat.compiler_hints.morphism_filter,
            category = cat,
        );
        
    end;
    
    if !IsSpecializationOfFilter( IsCapCategoryMorphism, type.filter )
        
        Print( "WARNING: filter ", type.filter, " does !imply `IsCapCategoryMorphism`. This will probably cause errors.\n" );
        
    end;
    
    return type;
    
end );

##
InstallGlobalFunction( CapFixpoint, function ( predicate, func, initial_value )
  local x, y;
    
    y = initial_value;
    
    while true
        x = y;
        y = func( x );
        if predicate( x, y )
            break;
        end;
    end;
    
    return y;
    
end );

##
InstallMethod( Iterated,
               [ IsList, IsFunction, IsObject ],
               
  function( list, func, initial_value )
    
    return Iterated( Concatenation( [ initial_value ], list ), func );
    
end );

##
InstallGlobalFunction( TransitivelyNeededOtherPackages, function ( package_name )
  local collected_dependencies, package_info, dep, p;
    
    collected_dependencies = [ package_name ];
    
    for dep in collected_dependencies
        
        package_info = First( PackageInfo( dep ) );
        
        if package_info == fail
            
            # COVERAGE_IGNORE_NEXT_LINE
            Error( dep, " is !the name of an available package" );
            
        end;
        
        for p in package_info.Dependencies.NeededOtherPackages
            
            if !p[1] ⥉ collected_dependencies
                
                Add( collected_dependencies, p[1] );
                
            end;
            
        end;
        
    end;
    
    return collected_dependencies;
    
end );

##
InstallMethod( SafePosition,
               [ IsList, IsObject ],
               
  function( list, obj )
    local pos;
    
    pos = Position( list, obj );
    
    Assert( 0, pos != fail );
    
    return pos;
    
end );

##
InstallMethod( SafePositionProperty,
               [ IsList, IsFunction ],
               
  function( list, func )
    local pos;
    
    pos = PositionProperty( list, func );
    
    Assert( 0, pos != fail );
    
    return pos;
    
end );

##
InstallMethod( SafeFirst,
               [ IsList, IsFunction ],
               
  function( list, func )
    local entry;
    
    entry = First( list, func );
    
    Assert( 0, entry != fail );
    
    return entry;
    
end );

##
InstallGlobalFunction( nTuple, function ( n, args... )
    
    Assert( 0, Length( args ) == n );
    
    return args;
    
end );

##
InstallGlobalFunction( Pair, function ( first, second )
    #% CAP_JIT_RESOLVE_FUNCTION
    
    return nTuple( 2, first, second );
    
end );

##
InstallGlobalFunction( Triple, function ( first, second, third )
    #% CAP_JIT_RESOLVE_FUNCTION
    
    return nTuple( 3, first, second, third );
    
end );

##
InstallGlobalFunction( HandlePrecompiledTowers, function ( category, underlying_category, constructor_name )
  local precompiled_towers, remaining_constructors_in_tower, precompiled_functions_adder, info;
    
    if !IsBound( underlying_category.compiler_hints ) || !IsBound( underlying_category.compiler_hints.precompiled_towers )
        
        return;
        
    end;
    
    if !IsList( underlying_category.compiler_hints.precompiled_towers )
        
        # COVERAGE_IGNORE_NEXT_LINE
        Error( "`underlying_category.compiler_hints.precompiled_towers` must be a list" );
        
    end;
    
    precompiled_towers = [ ];
    
    for info in underlying_category.compiler_hints.precompiled_towers
        
        if !(IsRecord( info ) && IsBound( info.remaining_constructors_in_tower ) && IsBound( info.precompiled_functions_adder ))
            
            # COVERAGE_IGNORE_NEXT_LINE
            Error( "the entries of `underlying_category.compiler_hints.precompiled_towers` must be records with components `remaining_constructors_in_tower` && `precompiled_functions_adder`" );
            
        end;
        
        remaining_constructors_in_tower = info.remaining_constructors_in_tower;
        precompiled_functions_adder = info.precompiled_functions_adder;
        
        if !IsList( remaining_constructors_in_tower ) || IsEmpty( remaining_constructors_in_tower )
            
            # COVERAGE_IGNORE_NEXT_LINE
            Error( "`remaining_constructors_in_tower` must be a non-empty list" );
            
        end;
        
        if !IsFunction( precompiled_functions_adder ) || NumberArgumentsFunction( precompiled_functions_adder ) != 1
            
            # COVERAGE_IGNORE_NEXT_LINE
            Error( "`precompiled_functions_adder` must be a function accepting a single argument" );
            
        end;
        
        if remaining_constructors_in_tower[1] == constructor_name
            
            if Length( remaining_constructors_in_tower ) == 1
                
                if ValueOption( "no_precompiled_code" ) != true
                    
                    # add precompiled functions
                    CallFuncList( precompiled_functions_adder, [ category ] );
                    
                end;
                
            else
                
                # pass information on to the next level
                Add( precompiled_towers, rec(
                    remaining_constructors_in_tower = remaining_constructors_in_tower[(2):(Length( remaining_constructors_in_tower ))],
                    precompiled_functions_adder = precompiled_functions_adder,
                ) );
                
            end;
            
        end;
        
    end;
    
    if !IsEmpty( precompiled_towers )
        
        if !IsBound( category.compiler_hints )
            
            category.compiler_hints = rec( );
            
        end;
        
        if !IsBound( category.compiler_hints.precompiled_towers )
            
            category.compiler_hints.precompiled_towers = [ ];
            
        end;
        
        category.compiler_hints.precompiled_towers = Concatenation( category.compiler_hints.precompiled_towers, precompiled_towers );
        
    end;
    
end );

InstallGlobalFunction( CAP_JIT_INCOMPLETE_LOGIC, IdFunc );

##
InstallGlobalFunction( ListWithKeys, function ( list, func )
  local res, i;
    
    # see implementation of `List`
    
    res = EmptyPlist( Length( list ) );
    
    # hack to save type adjustments && conversions (e.g. to blist)
    if Length( list ) > 0
        
        res[Length( list )] = 1;
        
    end;
    
    for i in (1):(Length( list ))
        
        res[i] = func( i, list[i] );
        
    end;
    
    return res;
    
end );

##
InstallGlobalFunction( SumWithKeys, function ( list, func )
  local sum, i;
    
    # see implementation of `Sum`
    
    if IsEmpty( list )
        
        sum = 0;
        
    else
        
        sum = func( 1, list[1] );
        
        for i in (2):(Length( list ))
            
            sum = sum + func( i, list[i] );
            
        end;
        
    end;
    
    return sum;
    
end );

##
InstallGlobalFunction( ProductWithKeys, function ( list, func )
  local product, i;
    
    # adapted implementation of `Product`
    
    if IsEmpty( list )
        
        product = 1;
        
    else
        
        product = func( 1, list[1] );
        
        for i in (2):(Length( list ))
            
            product = product * func( i, list[i] );
            
        end;
        
    end;
    
    return product;
    
end );

##
InstallGlobalFunction( ForAllWithKeys, function ( list, func )
  local i;
    
    # adapted implementation of `ForAll`
    
    for i in (1):(Length( list ))
        
        if !func( i, list[i] )
            
            return false;
            
        end;
        
    end;
    
    return true;
    
end );

##
InstallGlobalFunction( ForAnyWithKeys, function ( list, func )
  local i;
    
    # adapted implementation of `ForAny`
    
    for i in (1):(Length( list ))
        
        if func( i, list[i] )
            
            return true;
            
        end;
        
    end;
    
    return false;
    
end );

##
InstallGlobalFunction( NumberWithKeys, function ( list, func )
  local nr, i;
    
    # adapted implementation of `Number`
    
    nr = 0;
    
    for i in (1):(Length( list ))
        
        if func( i, list[i] )
            
            nr = nr + 1;
            
        end;
        
    end;
    
    return nr;
    
end );

##
InstallGlobalFunction( FilteredWithKeys, function ( list, func )
  local res, i, elm, j;
    
    # adapted implementation of `Filtered`
    
    res = list[[ ]];
    
    i = 0;
    
    for j in (1):(Length( list ))
        
        elm = list[j];
        
        if func( j, elm )
            
            i = i + 1;
            
            res[i] = elm;
            
        end;
        
    end;
    
    return res;
    
end );

##
InstallGlobalFunction( FirstWithKeys, function ( list, func )
  local elm, i;
    
    # adapted implementation of `First`
    
    for i in (1):(Length( list ))
        
        elm = list[i];
        
        if func( i, elm )
            
            return elm;
            
        end;
        
    end;
    
    return fail;
    
end );

##
InstallGlobalFunction( LastWithKeys, function ( list, func )
  local elm, i;
    
    # adapted implementation of `Last`
    
    for i in Reversed( (1):(Length( list )) )
        
        elm = list[i];
        
        if func( i, elm )
            
            return elm;
            
        end;
        
    end;
    
    return fail;
    
end );
