# SPDX-License-Identifier: GPL-2.0-or-later
# CAP: Categories, Algorithms, Programming
#
# Implementations
#

##
# some options should affect the whole function stack and should hence not be consumed by @FunctionWithNamedArguments
@BindGlobal( "CAP_INTERNAL_GLOBAL_OPTIONS", [ "no_precompiled_code" ] );

@InstallGlobalFunction( "@FunctionWithNamedArguments", function ( specification, func )
    
    @Assert( 0, IsList( specification ) );
    @Assert( 0, IsFunction( func ) );
    @Assert( 0, ForAll( specification, x -> IsList( x ) && Length( x ) == 2 && IsString( x[1] ) && @not IsMutable( x[2] ) ) );
    @Assert( 0, NumberArgumentsFunction( func ) >= 1 || NumberArgumentsFunction( func ) <= -2 );
    @Assert( 0, NamesLocalVariablesFunction( func )[1] == "CAP_NAMED_ARGUMENTS" );
    
    return function ( args... )
      local CAP_NAMED_ARGUMENTS, current_options, result, s;
        
        CAP_NAMED_ARGUMENTS = @rec( );
        
        if (IsEmpty( OptionsStack ))
            
            current_options = @rec( );
            
        else
            
            current_options = Last( OptionsStack );
            
        end;
        
        for s in specification
            
            if (@IsBound( current_options[s[1]] ))
                
                CAP_NAMED_ARGUMENTS[s[1]] = current_options[s[1]];
                
                if (@not s[1] in CAP_INTERNAL_GLOBAL_OPTIONS)
                    
                    @Unbind( current_options[s[1]] );
                    
                end;
                
            else
                
                CAP_NAMED_ARGUMENTS[s[1]] = s[2];
                
            end;
            
        end;
        
        result = CallFuncListWrap( func, @Concatenation( [ CAP_NAMED_ARGUMENTS ], args ) );
        
        if (Length( result ) == 1)
            
            return result[1];
            
        end;
        
        @Assert( 0, Length( result ) == 0 );
        
    end;
    
end );

#####################################
##
## Install add
##
#####################################

@InstallGlobalFunction( "CAP_INTERNAL_GET_DATA_TYPE_FROM_STRING", function ( string, args... )
  local category, is_ring_element, ring, n;
    
    if (@not IsString( string ))
        
        Error( string, " is not a string" );
        
    end;
    
    if (Length( args ) > 1)
        
        Error( "CAP_INTERNAL_GET_DATA_TYPE_FROM_STRING must be called with at most two arguments" );
        
    elseif (Length( args ) == 1)
        
        category = args[1];
        
    else
        
        category = false;
        
    end;
    
    if (string == "pair_of_morphisms")
        
        string = "2_tuple_of_morphisms";
        
    end;
    
    if (string == "bool")
        
        return @rec( filter = IsBool );
        
    elseif (string == "integer")
        
        return @rec( filter = IsInt );
        
    elseif (string == "nonneg_integer_or_infinity")
        
        return @rec( filter = IsCyclotomic );
        
    elseif (string == "category")
        
        return CapJitDataTypeOfCategory( category );
        
    elseif (string == "object")
        
        return CapJitDataTypeOfObjectOfCategory( category );
        
    elseif (string == "morphism")
        
        return CapJitDataTypeOfMorphismOfCategory( category );
        
    elseif (string == "twocell")
        
        return CapJitDataTypeOfTwoCellOfCategory( category );
        
    elseif (string == "list_of_objects")
        
        return CapJitDataTypeOfListOf( CapJitDataTypeOfObjectOfCategory( category ) );
        
    elseif (string == "list_of_morphisms")
        
        return CapJitDataTypeOfListOf( CapJitDataTypeOfMorphismOfCategory( category ) );
        
    elseif (string == "list_of_lists_of_morphisms")
        
        return CapJitDataTypeOfListOf( CapJitDataTypeOfListOf( CapJitDataTypeOfMorphismOfCategory( category ) ) );
        
    elseif (string == "list_of_twocells")
        
        return CapJitDataTypeOfListOf( CapJitDataTypeOfTwoCellOfCategory( category ) );
        
    elseif (string == "object_in_range_category_of_homomorphism_structure")
        
        if (category != false && @not HasRangeCategoryOfHomomorphismStructure( category ))
            
            Display( @Concatenation( "WARNING: You are calling an Add function for a CAP operation for \"", Name( category ), "\" which is part of a homomorphism structure but the category has no RangeCategoryOfHomomorphismStructure (yet)" ) );
            
        end;
        
        if (category == false || @not HasRangeCategoryOfHomomorphismStructure( category ))
            
            return CAP_INTERNAL_GET_DATA_TYPE_FROM_STRING( "object" );
            
        else
            
            return CAP_INTERNAL_GET_DATA_TYPE_FROM_STRING( "object", RangeCategoryOfHomomorphismStructure( category ) );
            
        end;
        
    elseif (string == "morphism_in_range_category_of_homomorphism_structure")
        
        if (category != false && @not HasRangeCategoryOfHomomorphismStructure( category ))
            
            Display( @Concatenation( "WARNING: You are calling an Add function for a CAP operation for \"", Name( category ), "\" which is part of a homomorphism structure but the category has no RangeCategoryOfHomomorphismStructure (yet)" ) );
            
        end;
        
        if (category == false || @not HasRangeCategoryOfHomomorphismStructure( category ))
            
            return CAP_INTERNAL_GET_DATA_TYPE_FROM_STRING( "morphism" );
            
        else
            
            return CAP_INTERNAL_GET_DATA_TYPE_FROM_STRING( "morphism", RangeCategoryOfHomomorphismStructure( category ) );
            
        end;
        
    elseif (string == "object_datum")
        
        if (category != false)
            
            # might be `fail`
            return ObjectDatumType( category );
            
        else
            
            return fail;
            
        end;
        
    elseif (string == "morphism_datum")
        
        if (category != false)
            
            # might be `fail`
            return MorphismDatumType( category );
            
        else
            
            return fail;
            
        end;
        
    elseif (string == "object_or_fail" || string == "morphism_or_fail" || string == "list_or_morphisms_or_fail")
        
        # cannot be express "or fail" yet
        return fail;
        
    elseif (string == "element_of_commutative_ring_of_linear_structure")
        
        if (category != false && @not HasCommutativeRingOfLinearCategory( category ))
            
            Print( "WARNING: You are calling an Add function for a CAP operation for \"", Name( category ), "\" which is part of the linear structure over a commutative ring but the category has no CommutativeRingOfLinearCategory (yet).\n" );
            
        end;
        
        if (category == false || @not HasCommutativeRingOfLinearCategory( category ))
            
            is_ring_element = IsRingElement;
            
        else
            
            ring = CommutativeRingOfLinearCategory( category );
            
            if (HasRingElementFilter( ring ))
                
                is_ring_element = RingElementFilter( ring );
                
            else
                
                is_ring_element = IsRingElement;
                
            end;
            
        end;
        
        return @rec(
            filter = is_ring_element,
        );
        
    elseif (string == "list_of_elements_of_commutative_ring_of_linear_structure")
        
        if (category != false && @not HasCommutativeRingOfLinearCategory( category ))
            
            Print( "WARNING: You are calling an Add function for a CAP operation for \"", Name( category ), "\" which is part of the linear structure over a commutative ring but the category has no CommutativeRingOfLinearCategory (yet).\n" );
            
        end;
        
        if (category == false || @not HasCommutativeRingOfLinearCategory( category ))
            
            is_ring_element = IsRingElement;
            
        else
            
            ring = CommutativeRingOfLinearCategory( category );
            
            if (HasRingElementFilter( ring ))
                
                is_ring_element = RingElementFilter( ring );
                
            else
                
                is_ring_element = IsRingElement;
                
            end;
            
        end;
        
        return CapJitDataTypeOfListOf( is_ring_element );
        
    elseif (string == "list_of_integers_and_list_of_morphisms")
        
        return CapJitDataTypeOfNTupleOf( 2,
                       CapJitDataTypeOfListOf( @rec( filter = IsInt ) ),
                       CapJitDataTypeOfListOf( CapJitDataTypeOfMorphismOfCategory( category ) ) );
        
    elseif (string == "arbitrary_list")
        
        return CapJitDataTypeOfListOf( IsObject );
        
    elseif (EndsWith( string, "_tuple_of_morphisms" ) && ForAll( string[(1):(Length( string ) - Length( "_tuple_of_morphisms" ))], IsDigitChar ))
        
        n = IntGAP( string[(1):(Length( string ) - Length( "_tuple_of_morphisms" ))] );
        
        return @rec(
            filter = IsNTuple,
            element_types = ListWithIdenticalEntries( n, CapJitDataTypeOfMorphismOfCategory( category ) ),
        );
        
    else
        
        Error( "filter type ", string, " is not recognized, see the documentation for allowed values" );
        
    end;
    
end );

@InstallGlobalFunction( CAP_INTERNAL_GET_DATA_TYPES_FROM_STRINGS,
  
  function( list, args... )
    local category;
    
    if (Length( args ) > 1)
        
        Error( "CAP_INTERNAL_GET_DATA_TYPES_FROM_STRINGS must be called with at most two arguments" );
        
    elseif (Length( args ) == 1)
        
        category = args[1];
        
    else
        
        category = false;
        
    end;
    
    return List( list, l -> CAP_INTERNAL_GET_DATA_TYPE_FROM_STRING( l, category ) );
    
end );

@InstallGlobalFunction( CAP_INTERNAL_REPLACED_STRING_WITH_FILTER,
  
  function( filter_string, args... )
    local category, data_type;
    
    if (Length( args ) > 1)
        
        Error( "CAP_INTERNAL_REPLACED_STRING_WITH_FILTER must be called with at most two arguments" );
        
    elseif (Length( args ) == 1)
        
        category = args[1];
        
    else
        
        category = false;
        
    end;
    
    data_type = CAP_INTERNAL_GET_DATA_TYPE_FROM_STRING( filter_string, category );
    
    if (data_type == fail)
        
        return IsObject;
        
    elseif (IsSpecializationOfFilter( IsNTuple, data_type.filter ))
        
        # `IsNTuple` deliberately does not imply `IsList` because we want to treat tuples and lists in different ways in CompilerForCAP.
        # However, on the GAP level tuples are just dense lists.
        return IsDenseList;
        
    else
        
        return data_type.filter;
        
    end;
    
end );

@InstallGlobalFunction( CAP_INTERNAL_REPLACED_STRINGS_WITH_FILTERS,
  
  function( list, args... )
    local category;
    
    if (Length( args ) > 1)
        
        Error( "CAP_INTERNAL_REPLACED_STRINGS_WITH_FILTERS must be called with at most two arguments" );
        
    elseif (Length( args ) == 1)
        
        category = args[1];
        
    else
        
        category = false;
        
    end;
    
    return List( list, l -> CAP_INTERNAL_REPLACED_STRING_WITH_FILTER( l, category ) );
    
end );

@InstallGlobalFunction( CAP_INTERNAL_REPLACED_STRINGS_WITH_FILTERS_FOR_JULIA,
  
  function( list, args... )
    local category;
    
    if (Length( args ) > 1)
        
        Error( "CAP_INTERNAL_REPLACED_STRINGS_WITH_FILTERS_FOR_JULIA must be called with at most two arguments" );
        
    elseif (Length( args ) == 1)
        
        category = args[1];
        
    else
        
        category = false;
        
    end;
    
    return List( list, function ( l )
      local filter;
        
        filter = CAP_INTERNAL_REPLACED_STRING_WITH_FILTER( l, category );
        
        if (filter == IsList)
            
            return ValueGlobal( "IsJuliaObject" );
            
        else
            
            return filter;
            
        end;
        
    end );
    
end );

@InstallGlobalFunction( "CAP_INTERNAL_MERGE_FILTER_LISTS",
  
  function( filter_list, additional_filters )
    local i;
    filter_list = ShallowCopy( filter_list );
    
    if (Length( filter_list ) < Length( additional_filters ))
        Error( "too many additional filters" );
    end;
    
    for i in (1):(Length( additional_filters ))
        if (@IsBound( additional_filters[ i ] ))
            filter_list[ i ] = filter_list[ i ] && additional_filters[ i ];
        end;
    end;
    
    return filter_list;
end );

@InstallGlobalFunction( "CAP_INTERNAL_ASSERT_VALUE_IS_OF_TYPE_GETTER",
  
  function( data_type, human_readable_identifier_list )
    local generic_help_string, filter, asserts_value_is_of_element_type, generic_assert_value_is_of_element_type;
    
    generic_help_string = " You can access the value via the local variable 'value' in a break loop.";
    
    filter = data_type.filter;
    
    # `IsBool( fail ) == true`, but we do not want to include `fail`
    if (IsSpecializationOfFilter( IsBool, filter ))
        
        return function( value )
            
            if (!(value == true || value == false))
                
                CallFuncList( Error, @Concatenation( human_readable_identifier_list, [ " is neither `true` nor `false`.", generic_help_string ] ) );
                
            end;
            
        end;
        
    elseif (IsSpecializationOfFilter( IsFunction, filter ))
        
        return function( value )
            
            if (@not filter( value ))
                
                CallFuncList( Error, @Concatenation( human_readable_identifier_list, [ " does not lie in the expected filter ", filter, ".", generic_help_string ] ) );
                
            end;
            
            if (NumberArgumentsFunction( value ) >= 0 && NumberArgumentsFunction( value ) != Length( data_type.signature[1] ))
                
                CallFuncList( Error, @Concatenation( human_readable_identifier_list, [ " has ", NumberArgumentsFunction( value ), " arguments but ", Length( data_type.signature[1] ), " were expected.", generic_help_string ] ) );
                
            end;
            
        end;
        
    elseif (IsSpecializationOfFilter( IsList, filter ))
        
        # In principle, we have to create an assertion function for each integer to get the human readable identifier correct.
        # The "correct" approach would be to generate those on demand but that would imply that we have to create assertion functions at runtime.
        # Thus, we take the pragmatic approach: We generate an assertion function for the first few entries, and a generic assertion function for all other entries.
        # For nested lists the number of assertion functions grows exponentially, so we choose a quite small number (4).
        asserts_value_is_of_element_type = List( (1):(4), i -> CAP_INTERNAL_ASSERT_VALUE_IS_OF_TYPE_GETTER( data_type.element_type, @Concatenation( [ "the ", i, "-th entry of " ], human_readable_identifier_list ) ) );
        
        generic_assert_value_is_of_element_type = CAP_INTERNAL_ASSERT_VALUE_IS_OF_TYPE_GETTER( data_type.element_type, @Concatenation( [ "some entry of " ], human_readable_identifier_list )  );
        
        return function( value )
          local i;
            
            if (@not filter( value ))
                
                CallFuncList( Error, @Concatenation( human_readable_identifier_list, [ " does not lie in the expected filter ", filter, ".", generic_help_string ] ) );
                
            end;
            
            for i in (1):(Length( value ))
                
                #= comment for Julia
                # Julia does not have non-dense lists
                if (@not @IsBound( value[i] ))
                    
                    CallFuncList( Error, @Concatenation( [ "the ", i, "-th entry of " ], human_readable_identifier_list, [ " is not bound.", generic_help_string ] ) );
                    
                end;
                # =#
                
                if (i <= 4)
                    
                    asserts_value_is_of_element_type[i]( value[i] );
                    
                else
                    
                    generic_assert_value_is_of_element_type( value[i] );
                    
                end;
                
            end;
            
        end;
        
    elseif (IsSpecializationOfFilter( IsNTuple, filter ))
        
        asserts_value_is_of_element_type = List( (1):(Length( data_type.element_types )), i -> CAP_INTERNAL_ASSERT_VALUE_IS_OF_TYPE_GETTER( data_type.element_types[i], @Concatenation( [ "the ", i, "-th entry of " ], human_readable_identifier_list ) ) );
        
        return function( value )
          local i;
            
            # tuples are modeled as lists
            if (@not IsDenseList( value ))
                
                CallFuncList( Error, @Concatenation( human_readable_identifier_list, [ " does not lie in the expected filter IsDenseList (implementation filter of IsNTuple).", generic_help_string ] ) );
                
            end;
            
            if (Length( value ) != Length( data_type.element_types ))
                
                CallFuncList( Error, @Concatenation( human_readable_identifier_list, [ " has length ", Length( value ), " but ", Length( data_type.element_types ), " was expected.", generic_help_string ] ) );
                
            end;
            
            for i in (1):(Length( value ))
                
                asserts_value_is_of_element_type[i]( value[i] );
                
            end;
            
        end;
        
    elseif (IsSpecializationOfFilter( IsCapCategory, filter ))
        
        return function( value )
            
            if (@not filter( value ))
                
                CallFuncList( Error, @Concatenation( human_readable_identifier_list, [ " does not lie in the expected filter ", filter, ".", generic_help_string ] ) );
                
            end;
            
            if (@not IsIdenticalObj( value, data_type.category ))
                
                CallFuncList( Error, @Concatenation( human_readable_identifier_list, [ " is not the expected category although it lies in the category filter of the expected category. This should never happen, please report this using the CAP_project's issue tracker.", generic_help_string ] ) );
                
            end;
            
        end;
        
    elseif (IsSpecializationOfFilter( IsCapCategoryObject, filter ))
        
        return function( value )
            
            if (@not filter( value ))
                
                CallFuncList( Error, @Concatenation( human_readable_identifier_list, [ " does not lie in the expected filter ", filter, ".", generic_help_string ] ) );
                
            end;
            
            CAP_INTERNAL_ASSERT_IS_OBJECT_OF_CATEGORY( value, data_type.category, human_readable_identifier_list );
            
        end;
        
    elseif (IsSpecializationOfFilter( IsCapCategoryMorphism, filter ))
        
        return function( value )
            
            if (@not filter( value ))
                
                CallFuncList( Error, @Concatenation( human_readable_identifier_list, [ " does not lie in the expected filter ", filter, ".", generic_help_string ] ) );
                
            end;
            
            CAP_INTERNAL_ASSERT_IS_MORPHISM_OF_CATEGORY( value, data_type.category, human_readable_identifier_list );
            
        end;
        
    elseif (IsSpecializationOfFilter( IsCapCategoryTwoCell, filter ))
        
        return function( value )
            
            if (@not filter( value ))
                
                CallFuncList( Error, @Concatenation( human_readable_identifier_list, [ " does not lie in the expected filter ", filter, ".", generic_help_string ] ) );
                
            end;
            
            CAP_INTERNAL_ASSERT_IS_TWO_CELL_OF_CATEGORY( value, data_type.category, human_readable_identifier_list );
            
        end;
        
    else
        
        return function( value )
            
            if (@not filter( value ))
                
                CallFuncList( Error, @Concatenation( human_readable_identifier_list, [ " does not lie in the expected filter ", filter, ".", generic_help_string ] ) );
                
            end;
            
        end;
        
    end;
    
end );

@InstallGlobalFunction( CAP_INTERNAL_RETURN_OPTION_OR_DEFAULT,
    
  function( option_name, default )
    local value;
    
    value = ValueOption( option_name );
    
    if (value == fail)
        return default;
    end;
    
    return value;
end );

@BindGlobal( "CAP_INTERNAL_REPLACE_ADDITIONAL_SYMBOL_APPEARANCE",
  
  function( appearance_list, replacement_record )
    local remove_list, new_appearances, current_appearance, pos, current_appearance_nr, current_replacement, i;
    
    appearance_list = StructuralCopy( appearance_list );
    
    remove_list = [];
    new_appearances = [];
    
    for current_appearance_nr in (1):(Length( appearance_list ))
        
        current_appearance = appearance_list[ current_appearance_nr ];
        
        if (@IsBound( replacement_record[current_appearance[1]] ))
            
            Add( remove_list, current_appearance_nr );
            
            for current_replacement in replacement_record[current_appearance[1]]
                
                pos = PositionProperty( appearance_list, x -> x[1] == current_replacement[1] && x[3] == current_appearance[3] );
                
                if (pos == fail)
                    
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
    
    return @Concatenation( appearance_list, new_appearances );
    
end );

##
@InstallGlobalFunction( "CAP_INTERNAL_FIND_APPEARANCE_OF_SYMBOL_IN_FUNCTION",
  
  function( func, symbol_list, loop_multiple, replacement_record, category_getters )
    local func_as_string, func_stream, func_as_list, loop_power, symbol_appearance_list, current_symbol, category_getter, pos, i;
    
    if (IsOperation( func ))
        
        func_as_string = NameFunction( func );
        
    else
        
        func_as_string = "";
        
        func_stream = OutputTextString( func_as_string, false );
        
        SetPrintFormattingStatus( func_stream, false );
        
        PrintTo( func_stream, func );
        
        CloseStream( func_stream );
        
    end;
    
    RemoveCharacters( func_as_string, "()[];," );
    
    NormalizeWhitespace( func_as_string );
    
    func_as_list = SplitString( func_as_string, " " );
    
    loop_power = 0;
    
    symbol_appearance_list = [ ];
    
    symbol_list = @Concatenation( symbol_list, RecNames( replacement_record ) );
    
    # remove first "function" and last "end"
    @Assert( 0, func_as_list[1] == "function" );
    @Assert( 0, Last( func_as_list ) == "end" );
    
    func_as_list = func_as_list[(2):(Length( func_as_list ) - 1)];
    
    for i in (1):(Length( func_as_list ))
        
        current_symbol = func_as_list[i];
        
        if (current_symbol in symbol_list)
            
            # function cannot end with a symbol
            @Assert( 0, i < Length( func_as_list ) );
            
            if (@IsBound( category_getters[func_as_list[i + 1]] ))
                
                category_getter = category_getters[func_as_list[i + 1]];
                
            else
                
                category_getter = fail;
                
            end;
            
            pos = PositionProperty( symbol_appearance_list, x -> x[1] == current_symbol && x[3] == category_getter );
            
            if (pos == fail)
                
                Add( symbol_appearance_list, [ current_symbol, loop_multiple^loop_power, category_getter ] );
                
            else
                
                symbol_appearance_list[pos][2] = symbol_appearance_list[pos][2] + loop_multiple^loop_power;
                
            end;
            
        # Technically, the head of a "for" loop is only executed once.
        # We could simply start the detection at "do", but this would exclude the header of "while" loops
        # which indeed is executed multiple times.
        elseif (current_symbol in [ "for", "while", "repeat", "function" ])
            
            loop_power = loop_power + 1;
            
        # Technically, the part after "until" is also executed multiple times.
        elseif (current_symbol in [ "od", "until", "end" ])
            
            loop_power = loop_power - 1;
            
        end;
        
    end;
    
    if (loop_power != 0)
        
        Error( "The automated detection of CAP operations could not detect loops properly. If the reserved word `for` appears in <func_as_string> (e.g. in a string), this is probably the cause. If not, please report this as a bug mentioning <func_as_string>." );
        
    end;
    
    symbol_appearance_list = CAP_INTERNAL_REPLACE_ADDITIONAL_SYMBOL_APPEARANCE( symbol_appearance_list, replacement_record );
    return symbol_appearance_list;
    
end );

##
@InstallGlobalFunction( CAP_INTERNAL_MERGE_PRECONDITIONS_LIST,
  
  function( list1, list2 )
    local pos, current_precondition;
    
    list2 = StructuralCopy( list2 );
    
    for current_precondition in list1
        
        pos = PositionProperty( list2, x -> x[1] == current_precondition[1] && x[3] == current_precondition[3] );
        
        if (pos == fail)
            
            Add( list2, current_precondition );
            
        else
            
            list2[pos][2] = Maximum( list2[pos][2], current_precondition[2] );
            
        end;
        
    end;
    
    return list2;
    
end );

##
@InstallGlobalFunction( ListKnownCategoricalProperties,
                      
  function( category )
    local list, name;
    
    if (@not IsCapCategory( category ))
      
      Error( "the input is not a category" );
      
    end;
    
    list = [ ];
    
    for name in SetGAP( Filtered( @Concatenation( CAP_INTERNAL_CATEGORICAL_PROPERTIES_LIST ), x -> x != fail ) )
      
      if (Tester( ValueGlobal( name ) )( category ) && ValueGlobal( name )( category ))
        
        Add( list, name );
      
      end;
      
    end;
    
    return list;
    
end );

@InstallGlobalFunction( HelpForCAP,
  
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

@InstallGlobalFunction( CachingStatistic,
  
  function( category, arg... )
    local operations, current_cache_name, current_cache;
    
    operations = arg;
    
    if (Length( operations ) == 0)
        operations = RecNames( category.caches );
    end;
    
    operations = ShallowCopy( operations );
    Sort( operations );
    
    Print( "Caching statistics for category ", Name( category ), "\n" );
    Print( "===============================================\n" );
    
    for current_cache_name in operations
        Print( current_cache_name, ": " );
        if (@not @IsBound( category.caches[current_cache_name] ))
            Print( "not installed yet\n" );
            continue;
        end;
        current_cache = category.caches[current_cache_name];
        if (IsDisabledCache( current_cache ))
            Print( "disabled\n" );
            continue;
        end;
        if (IsWeakCache( current_cache ))
            Print( "weak cache, " );
        elseif (IsCrispCache( current_cache ))
            Print( "crisp cache, " );
        end;
        Print( "hits: ", StringGAP( current_cache.hit_counter ), ", misses: ", StringGAP( current_cache.miss_counter ), ", " );
        Print( StringGAP( Length( PositionsProperty( current_cache.value, ReturnTrue ) ) ), " objects stored\n" );
    end;
    
end );

@InstallGlobalFunction( InstallDeprecatedAlias,
  
  function( alias_name, function_name, deprecation_date )
    
    #= comment for Julia
    @BindGlobal( alias_name, function ( args... )
      local result;
        
        Print(
          @Concatenation(
          "WARNING: ", alias_name, " is deprecated and will not be supported after ", deprecation_date, ". Please use ", function_name, " instead.\n"
          )
        );
        
        result = CallFuncListWrap( ValueGlobal( function_name ), args );
        
        if (@not IsEmpty( result ))
            
            return result[1];
            
        end;
        
    end );
    # =#
    
end );

##
@InstallGlobalFunction( "IsSpecializationOfFilter", function ( filter_1, filter_2 )
  local data_type_1, data_type_2;
    
    if (IsString( filter_1 ))
        
        data_type_1 = CAP_INTERNAL_GET_DATA_TYPE_FROM_STRING( filter_1 );
        
        if (data_type_1 == fail)
            
            filter_1 = IsObject;
            
        else
            
            filter_1 = data_type_1.filter;
            
        end;
        
    end;
    
    if (IsString( filter_2 ))
        
        data_type_2 = CAP_INTERNAL_GET_DATA_TYPE_FROM_STRING( filter_2 );
        
        if (data_type_2 == fail)
            
            filter_2 = IsObject;
            
        else
            
            filter_2 = data_type_2.filter;
            
        end;
        
    end;
    
    return IS_SUBSET_FLAGS( WITH_IMPS_FLAGS( FLAGS_FILTER( filter_2 ) ), WITH_IMPS_FLAGS( FLAGS_FILTER( filter_1 ) ) );
    
end );

##
@InstallGlobalFunction( "IsSpecializationOfFilterList", function ( filter_list1, filter_list2 )
    
    if (filter_list1 == "any")
        
        return true;
        
    elseif (filter_list2 == "any")
        
        return false;
        
    end;
    
    return Length( filter_list1 ) == Length( filter_list2 ) && ForAll( (1):(Length( filter_list1 )), i -> IsSpecializationOfFilter( filter_list1[i], filter_list2[i] ) );
    
end );

##
@InstallGlobalFunction( InstallMethodForCompilerForCAP,
  
  function( args... )
    local operation, method, filters;
    
    # let InstallMethod do the type checking
    CallFuncList( InstallMethod, args );
    
    operation = First( args );
    method = Last( args );
    
    if (IsList( args[Length( args ) - 1] ))
        
        filters = args[Length( args ) - 1];
        
    elseif (IsList( args[Length( args ) - 2] ))
        
        filters = args[Length( args ) - 2];
        
    else
        
        # COVERAGE_IGNORE_NEXT_LINE
        Error( "this should never happen" );
        
    end;
    
    CapJitAddKnownMethod( operation, filters, method );
    
end );

##
@InstallGlobalFunction( InstallOtherMethodForCompilerForCAP,
  
  function( args... )
    local operation, method, filters;
    
    # let InstallOtherMethod do the type checking
    CallFuncList( InstallOtherMethod, args );
    
    operation = First( args );
    method = Last( args );
    
    if (IsList( args[Length( args ) - 1] ))
        
        filters = args[Length( args ) - 1];
        
    elseif (IsList( args[Length( args ) - 2] ))
        
        filters = args[Length( args ) - 2];
        
    else
        
        # COVERAGE_IGNORE_NEXT_LINE
        Error( "this should never happen" );
        
    end;
    
    CapJitAddKnownMethod( operation, filters, method );
    
end );

##
@BindGlobal( "CAP_JIT_INTERNAL_KNOWN_METHODS", @rec( ) );

@InstallGlobalFunction( CapJitAddKnownMethod,
  
  function( operation, filters, method )
    local operation_name, wrapper_operation_name, known_methods;
    
    if (!(IsOperation( operation )) || !(IsList( filters )) || @not IsFunction( method ))
        
        # COVERAGE_IGNORE_NEXT_LINE
        Error( "usage: CapJitAddKnownMethod( <operation>, <list of filters>, <method> )" );
        
    end;
    
    if (IsEmpty( filters ))
        
        # COVERAGE_IGNORE_NEXT_LINE
        Error( "installing methods without filters is currently not supported" );
        
    end;
    
    operation_name = NameFunction( operation );
    
    if (@IsBound( CAP_INTERNAL_METHOD_NAME_RECORD[operation_name] ) && Length( filters ) == Length( CAP_INTERNAL_METHOD_NAME_RECORD[operation_name].filter_list ))
        
        # COVERAGE_IGNORE_NEXT_LINE
        Error( operation_name, " is already installed as a CAP operation with the same number of arguments" );
        
    end;
    
    # check if we deal with a KeyDependentOperation
    if (EndsWith( operation_name, "Op" ))
        
        wrapper_operation_name = operation_name[(1):(Length( operation_name ) - 2)];
        
        if (IsBoundGlobal( wrapper_operation_name ) && ValueGlobal( wrapper_operation_name ) in WRAPPER_OPERATIONS)
            
            operation_name = wrapper_operation_name;
            
        end;
        
    end;
    
    if (@not @IsBound( CAP_JIT_INTERNAL_KNOWN_METHODS[operation_name] ))
        
        CAP_JIT_INTERNAL_KNOWN_METHODS[operation_name] = [ ];
        
    end;
    
    known_methods = CAP_JIT_INTERNAL_KNOWN_METHODS[operation_name];
    
    if (IsSpecializationOfFilter( "category", filters[1] ))
        
        if (ForAny( known_methods, m -> Length( m.filters ) == Length( filters ) && ( IsSpecializationOfFilter( m.filters[1], filters[1] ) || IsSpecializationOfFilter( filters[1], m.filters[1] ) ) ))
            
            # COVERAGE_IGNORE_NEXT_LINE
            Error( "there is already a method known for ", operation_name, " with a category filter which implies the current category filter or is implied by it" );
            
        end;
        
    else
        
        if (IsSpecializationOfFilter( filters[1], "category" ))
            
            # COVERAGE_IGNORE_NEXT_LINE
            Error( "The first filter is implied by `IsCapCategory`, this is not supported." );
            
        end;
        
        if (ForAny( known_methods,
            m -> Length( m.filters ) == Length( filters ) && ForAll( (1):(Length( filters )), i -> IsSpecializationOfFilter( m.filters[i], filters[i] ) || IsSpecializationOfFilter( filters[i], m.filters[i] ) )
        ))
            
            # COVERAGE_IGNORE_NEXT_LINE
            Error( "there is already a method known for ", operation_name, " with a comparable filter list (see documentation of `CapJitAddKnownMethod`)" );
            
        end;
        
    end;
    
    Add( known_methods, @rec( filters = filters, method = method ) );
    
end );

##
@BindGlobal( "CAP_JIT_INTERNAL_TYPE_SIGNATURES", @rec( ) );

@InstallGlobalFunction( "CapJitAddTypeSignature", function ( name, input_filters, output_data_type )
    
    #= comment for Julia
    if (IsCategory( ValueGlobal( name ) ) && Length( input_filters ) == 1)
        
        Error( "adding type signatures for GAP categories applied to a single argument is not supported" );
        
    end;
    
    if (input_filters != "any")
        
        if (@not IsList( input_filters ))
            
            # COVERAGE_IGNORE_NEXT_LINE
            Error( "<input_filters> must be a list or the string \"any\"" );
            
        end;
        
        if (@not ForAll( input_filters, filter -> IsFilter( filter ) ))
            
            # COVERAGE_IGNORE_NEXT_LINE
            Error( "<input_filters> must be a list of filters or the string \"any\"" );
            
        end;
        
        if (ForAny( input_filters, f -> IsSpecializationOfFilter( IsFunction, f ) ) && (!(IsFunction( output_data_type )) || NumberArgumentsFunction( output_data_type ) != 2))
            
            if (@not name in [ "CreateCapCategoryObjectWithAttributes", "CreateCapCategoryMorphismWithAttributes" ])
                
                # COVERAGE_IGNORE_BLOCK_START
                Print(
                    "WARNING: You are adding a type signature for ", name, " which can get a function as input but you do not compute the signature of the function. ",
                    "This will work for references to global functions but not for literal functions. ",
                    "See `List` in `CompilerForCAP/gap/InferDataTypes.gi` for an example of how to handle the signature of functions properly.\n"
                );
                # COVERAGE_IGNORE_BLOCK_END
                
            end;
            
        end;
        
    end;
    
    if (@not @IsBound( CAP_JIT_INTERNAL_TYPE_SIGNATURES[name] ))
        
        CAP_JIT_INTERNAL_TYPE_SIGNATURES[name] = [ ];
        
    end;
    
    if (ForAny( CAP_JIT_INTERNAL_TYPE_SIGNATURES[name], signature -> IsSpecializationOfFilterList( signature[1], input_filters ) || IsSpecializationOfFilterList( input_filters, signature[1] ) ))
        
        # COVERAGE_IGNORE_NEXT_LINE
        Error( "there already exists a signature for ", name, " with filters implying the current filters or being implied by them" );
        
    end;
    
    if (@not ForAny( [ IsFilter, IsRecord, IsFunction ], f -> f( output_data_type ) ))
        
        # COVERAGE_IGNORE_NEXT_LINE
        Error( "<output_data_type> must be a filter, a record, or a function" );
        
    end;
    
    if (IsFilter( output_data_type ))
        
        output_data_type = @rec( filter = output_data_type );
        
    end;
    
    Add( CAP_JIT_INTERNAL_TYPE_SIGNATURES[name], [ input_filters, output_data_type ] );
    # =#
    
end );

##
@BindGlobal( "CAP_JIT_INTERNAL_TYPE_SIGNATURES_DEFERRED", @rec( ) );

@InstallGlobalFunction( "CapJitAddTypeSignatureDeferred", function ( package_name, name, input_filters, output_data_type )
    
    if (input_filters != "any")
        
        if (@not IsList( input_filters ))
            
            # COVERAGE_IGNORE_NEXT_LINE
            Error( "<input_filters> must be a list or the string \"any\"" );
            
        end;
        
        if (@not ForAll( input_filters, filter -> IsString( filter ) ))
            
            # COVERAGE_IGNORE_NEXT_LINE
            Error( "<input_filters> must be a list of strings or the string \"any\"" );
            
        end;
        
    end;
    
    if (@not IsString( output_data_type ))
        
        # COVERAGE_IGNORE_NEXT_LINE
        Error( "<output_data_type> must be a string" );
        
    end;
    
    if (@not @IsBound( CAP_JIT_INTERNAL_TYPE_SIGNATURES_DEFERRED[package_name] ))
        
        CAP_JIT_INTERNAL_TYPE_SIGNATURES_DEFERRED[package_name] = [ ];
        
    end;
    
    Add( CAP_JIT_INTERNAL_TYPE_SIGNATURES_DEFERRED[package_name], [ name, input_filters, output_data_type ] );
    
end );

##
@InstallGlobalFunction( CapJitDataTypeOfListOf, function ( element_type )
    
    if (IsFilter( element_type ))
        
        element_type = @rec( filter = element_type );
        
    end;
    
    if (@not IsRecord( element_type ))
        
        # COVERAGE_IGNORE_NEXT_LINE
        Error( "<element_type> must be a filter or a record" );
        
    end;
    
    return @rec( filter = IsList, element_type = element_type );
    
end );

##
@InstallGlobalFunction( CapJitDataTypeOfNTupleOf, function ( n, element_types... )
    
    @Assert( 0, Length( element_types ) == n );
    
    element_types = List( element_types, function ( t )
        
        if (IsFilter( t ))
            
            return @rec( filter = t );
            
        else
            
            return t;
            
        end;
        
    end );
    
    if (@not ForAll( element_types, t -> IsRecord( t ) ))
        
        # COVERAGE_IGNORE_NEXT_LINE
        Error( "<element_types...> must be filters or records" );
        
    end;
    
    return @rec( filter = IsNTuple, element_types = element_types );
    
end );

##
@InstallGlobalFunction( CapJitDataTypeOfCategory, function ( cat )
  local type;
    
    if (cat == false)
        
        type = @rec(
            filter = IsCapCategory,
        );
        
    else
        
        type = @rec(
            filter = CategoryFilter( cat ),
            category = cat,
        );
        
    end;
    
    return type;
    
end );

##
@InstallGlobalFunction( CapJitDataTypeOfObjectOfCategory, function ( cat )
  local type;
    
    if (cat == false)
        
        type = @rec(
            filter = IsCapCategoryObject,
        );
        
    else
        
        type = @rec(
            filter = ObjectFilter( cat ),
            category = cat,
        );
        
    end;
    
    return type;
    
end );

##
@InstallGlobalFunction( CapJitDataTypeOfMorphismOfCategory, function ( cat )
  local type;
    
    if (cat == false)
        
        type = @rec(
            filter = IsCapCategoryMorphism,
        );
        
    else
        
        type = @rec(
            filter = MorphismFilter( cat ),
            category = cat,
        );
        
    end;
    
    return type;
    
end );

##
@InstallGlobalFunction( CapJitDataTypeOfTwoCellOfCategory, function ( cat )
  local type;
    
    if (cat == false)
        
        type = @rec(
            filter = IsCapCategoryTwoCell,
        );
        
    else
        
        type = @rec(
            filter = TwoCellFilter( cat ),
            category = cat,
        );
        
    end;
    
    return type;
    
end );

##
@InstallGlobalFunction( CapJitTypedExpression, ReturnFirst );

##
@InstallGlobalFunction( CapFixpoint, function ( predicate, func, initial_value )
  local x, y;
    
    y = initial_value;
    
    while true
        x = y;
        y = func( x );
        if (predicate( x, y ))
            break;
        end;
    end;
    
    return y;
    
end );

##
@InstallMethod( Iterated,
               [ IsList, IsFunction, IsObject ],
               
  function( list, func, initial_value )
    
    return Iterated( @Concatenation( [ initial_value ], list ), func );
    
end );

##
@InstallMethod( Iterated,
               [ IsList, IsFunction, IsObject, IsObject ],
               
  function( list, func, initial_value, terminal_value )
    
    return Iterated( @Concatenation( [ initial_value ], list, [ terminal_value ] ), func );
    
end );

##
@InstallGlobalFunction( TransitivelyNeededOtherPackages, function ( package_name )
  local collected_dependencies, package_info, dep, p;
    
    collected_dependencies = [ package_name ];
    
    for dep in collected_dependencies
        
        package_info = First( PackageInfo( dep ) );
        
        if (package_info == fail)
            
            # COVERAGE_IGNORE_NEXT_LINE
            Error( dep, " is not the name of an available package" );
            
        end;
        
        for p in package_info.Dependencies.NeededOtherPackages
            
            if (@not p[1] in collected_dependencies)
                
                Add( collected_dependencies, p[1] );
                
            end;
            
        end;
        
    end;
    
    return collected_dependencies;
    
end );

##
@InstallMethod( SafePosition,
               [ IsList, IsObject ],
               
  function( list, obj )
    local pos;
    
    pos = Position( list, obj );
    
    @Assert( 0, pos != fail );
    
    return pos;
    
end );

##
@InstallMethod( SafeUniquePosition,
               [ IsList, IsObject ],
               
  function( list, obj )
    local positions;
    
    positions = Positions( list, obj );
    
    @Assert( 0, Length( positions ) == 1 );
    
    return positions[1];
    
end );

##
@InstallMethod( SafePositionProperty,
               [ IsList, IsFunction ],
               
  function( list, func )
    local pos;
    
    pos = PositionProperty( list, func );
    
    @Assert( 0, pos != fail );
    
    return pos;
    
end );

##
@InstallMethod( SafeUniquePositionProperty,
               [ IsList, IsFunction ],
               
  function( list, func )
    local positions;
    
    positions = PositionsProperty( list, func );
    
    @Assert( 0, Length( positions ) == 1 );
    
    return positions[1];
    
end );

##
@InstallMethod( SafeFirst,
               [ IsList, IsFunction ],
               
  function( list, func )
    local entry;
    
    entry = First( list, func );
    
    @Assert( 0, entry != fail );
    
    return entry;
    
end );

##
@InstallMethod( SafeUniqueEntry,
               [ IsList, IsFunction ],
               
  function( list, func )
    local positions;
    
    positions = PositionsProperty( list, func );
    
    @Assert( 0, Length( positions ) == 1 );
    
    return list[positions[1]];
    
end );

##
#= comment for Julia
# We want `args` to be a list but in Julia it's a tuple -> we need a separate implementation for Julia
@InstallGlobalFunction( @NTupleGAP, function ( n, args... )
    
    @Assert( 0, Length( args ) == n );
    
    return args;
    
end );
# =#

##
@InstallGlobalFunction( PairGAP, function ( first, second )
    #% CAP_JIT_RESOLVE_FUNCTION
    
    return @NTupleGAP( 2, first, second );
    
end );

##
@InstallGlobalFunction( Triple, function ( first, second, third )
    #% CAP_JIT_RESOLVE_FUNCTION
    
    return @NTupleGAP( 3, first, second, third );
    
end );

##
@InstallGlobalFunction( TransposedMatWithGivenDimensions, function ( nr_rows, nr_cols, listlist )
    
    if (!( Length( listlist ) == nr_rows && ForAll( listlist, row -> Length( row ) == nr_cols ) ))
        Error( "the arguments passed to 'TransposedMatWithGivenDimensions' are inconsistent!\n" );
    end;
    
    if (nr_rows == 0)
        return List( (1):(nr_cols), i -> [ ] );
    else
        return TransposedMat( listlist );
    end;
    
end );

##
@InstallGlobalFunction( HandlePrecompiledTowers, @FunctionWithNamedArguments(
  [
    [ "no_precompiled_code", false ],
  ],
  function ( CAP_NAMED_ARGUMENTS, category, underlying_category, constructor_name )
    local precompiled_towers, remaining_constructors_in_tower, precompiled_functions_adder, info;
    
    if (!(@IsBound( underlying_category.compiler_hints )) || @not @IsBound( underlying_category.compiler_hints.precompiled_towers ))
        
        return;
        
    end;
    
    if (@not IsList( underlying_category.compiler_hints.precompiled_towers ))
        
        # COVERAGE_IGNORE_NEXT_LINE
        Error( "`underlying_category.compiler_hints.precompiled_towers` must be a list" );
        
    end;
    
    precompiled_towers = [ ];
    
    for info in underlying_category.compiler_hints.precompiled_towers
        
        if (!(IsRecord( info ) && @IsBound( info.remaining_constructors_in_tower ) && @IsBound( info.precompiled_functions_adder )))
            
            # COVERAGE_IGNORE_NEXT_LINE
            Error( "the entries of `underlying_category.compiler_hints.precompiled_towers` must be records with components `remaining_constructors_in_tower` and `precompiled_functions_adder`" );
            
        end;
        
        remaining_constructors_in_tower = info.remaining_constructors_in_tower;
        precompiled_functions_adder = info.precompiled_functions_adder;
        
        if (!(IsList( remaining_constructors_in_tower )) || IsEmpty( remaining_constructors_in_tower ))
            
            # COVERAGE_IGNORE_NEXT_LINE
            Error( "`remaining_constructors_in_tower` must be a non-empty list" );
            
        end;
        
        if (!(IsFunction( precompiled_functions_adder )) || NumberArgumentsFunction( precompiled_functions_adder ) != 1)
            
            # COVERAGE_IGNORE_NEXT_LINE
            Error( "`precompiled_functions_adder` must be a function accepting a single argument" );
            
        end;
        
        if (remaining_constructors_in_tower[1] == constructor_name)
            
            if (Length( remaining_constructors_in_tower ) == 1)
                
                if (@not no_precompiled_code)
                    
                    # add precompiled functions
                    CallFuncList( precompiled_functions_adder, [ category ] );
                    
                end;
                
            else
                
                # pass information on to the next level
                Add( precompiled_towers, @rec(
                    remaining_constructors_in_tower = remaining_constructors_in_tower[(2):(Length( remaining_constructors_in_tower ))],
                    precompiled_functions_adder = precompiled_functions_adder,
                ) );
                
            end;
            
        end;
        
    end;
    
    if (@not IsEmpty( precompiled_towers ))
        
        if (@not @IsBound( category.compiler_hints ))
            
            category.compiler_hints = @rec( );
            
        end;
        
        if (@not @IsBound( category.compiler_hints.precompiled_towers ))
            
            category.compiler_hints.precompiled_towers = [ ];
            
        end;
        
        category.compiler_hints.precompiled_towers = @Concatenation( category.compiler_hints.precompiled_towers, precompiled_towers );
        
    end;
    
    # return void for Julia
    return;
    
end ) );

@InstallGlobalFunction( CAP_JIT_INCOMPLETE_LOGIC, IdFunc );
@InstallGlobalFunction( CAP_JIT_EXPR_CASE_WRAPPER, IdFunc );

##
#= comment for Julia
# Julia does not have non-dense lists and thus needs a separate implementation
@InstallGlobalFunction( ListWithKeys, function ( list, func )
  local res, i;
    
    # see implementation of `List`
    
    res = EmptyPlist( Length( list ) );
    
    # hack to save type adjustments and conversions (e.g. to blist)
    if (Length( list ) > 0)
        
        res[Length( list )] = 1;
        
    end;
    
    for i in (1):(Length( list ))
        
        res[i] = func( i, list[i] );
        
    end;
    
    return res;
    
end );
# =#

##
@InstallGlobalFunction( SumWithKeys, function ( list, func )
  local sum, i;
    
    # see implementation of `Sum`
    
    if (IsEmpty( list ))
        
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
@InstallGlobalFunction( ProductWithKeys, function ( list, func )
  local product, i;
    
    # adapted implementation of `Product`
    
    if (IsEmpty( list ))
        
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
@InstallGlobalFunction( ForAllWithKeys, function ( list, func )
  local i;
    
    # adapted implementation of `ForAll`
    
    for i in (1):(Length( list ))
        
        if (@not func( i, list[i] ))
            
            return false;
            
        end;
        
    end;
    
    return true;
    
end );

##
@InstallGlobalFunction( ForAnyWithKeys, function ( list, func )
  local i;
    
    # adapted implementation of `ForAny`
    
    for i in (1):(Length( list ))
        
        if (func( i, list[i] ))
            
            return true;
            
        end;
        
    end;
    
    return false;
    
end );

##
@InstallGlobalFunction( NumberWithKeys, function ( list, func )
  local nr, i;
    
    # adapted implementation of `Number`
    
    nr = 0;
    
    for i in (1):(Length( list ))
        
        if (func( i, list[i] ))
            
            nr = nr + 1;
            
        end;
        
    end;
    
    return nr;
    
end );

##
#= comment for Julia
# Julia does not have non-dense lists and thus needs a separate implementation
@InstallGlobalFunction( FilteredWithKeys, function ( list, func )
  local res, i, elm, j;
    
    # adapted implementation of `Filtered`
    
    res = list[[ ]];
    
    i = 0;
    
    for j in (1):(Length( list ))
        
        elm = list[j];
        
        if (func( j, elm ))
            
            i = i + 1;
            
            res[i] = elm;
            
        end;
        
    end;
    
    return res;
    
end );
# =#

##
@InstallGlobalFunction( FirstWithKeys, function ( list, func )
  local elm, i;
    
    # adapted implementation of `First`
    
    for i in (1):(Length( list ))
        
        elm = list[i];
        
        if (func( i, elm ))
            
            return elm;
            
        end;
        
    end;
    
    return fail;
    
end );

##
@InstallGlobalFunction( LastWithKeys, function ( list, func )
  local elm, i;
    
    # adapted implementation of `Last`
    
    for i in Reversed( (1):(Length( list )) )
        
        elm = list[i];
        
        if (func( i, elm ))
            
            return elm;
            
        end;
        
    end;
    
    return fail;
    
end );
