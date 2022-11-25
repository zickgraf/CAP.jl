# SPDX-License-Identifier: GPL-2.0-or-later
# CAP: Categories, Algorithms, Programming
#
# Implementations
#
@BindGlobal( "CAP_INTERNAL_ADD_OBJECT_OR_FAIL",
  
  function( category, object_or_fail )
    
    if object_or_fail == fail
        return;
    end;
    
    AddObject( category, object_or_fail );
    
end );

@BindGlobal( "CAP_INTERNAL_ADD_MORPHISM_OR_FAIL",
  
  function( category, morphism_or_fail )
    
    if morphism_or_fail == fail
        return;
    end;
    
    AddMorphism( category, morphism_or_fail );
    
end );

@BindGlobal( "CAP_INTERNAL_DISPLAY_ERROR_FOR_FUNCTION_OF_CATEGORY",
  
  function( function_name, category, message )
    
    Error( Concatenation( "in function \033[1m", function_name,
        "\033[0m\n       of category \033[1m",
        Name( category ), ":\033[0m\n\033[1m       ", message, "\033[0m\n" ) );
    
end );

@InstallGlobalFunction( CapInternalInstallAdd,
  
  function( record )
    local function_name, install_name, add_name, pre_function, pre_function_full,
          redirect_function, post_function, filter_list,
          add_function, replaced_filter_list,
          enhanced_filter_list, get_convenience_function;
    
    function_name = record.function_name;
    
    if !IsBound( record.installation_name )
        
        install_name = function_name;
        
    else
        
        install_name = record.installation_name;
        
    end;
    
    add_name = Concatenation( "Add", function_name );
    
    if IsBound( record.pre_function )
        pre_function = record.pre_function;
    else
        pre_function = function( arg... ) return [ true ]; end;
    end;

    if IsBound( record.pre_function_full )
        pre_function_full = record.pre_function_full;
    else
        pre_function_full = function( arg... ) return [ true ]; end;
    end;
    
    if IsBound( record.redirect_function )
        redirect_function = record.redirect_function;
    else
        redirect_function = false;
    end;
    
    if IsBound( record.post_function )
        post_function = record.post_function;
    else
        post_function = false;
    end;
    
    filter_list = record.filter_list;
    
    if record.return_type == "object"
        add_function = AddObject;
    elseif record.return_type == "morphism"
        add_function = AddMorphism;
    elseif record.return_type == "twocell"
        add_function = AddTwoCell;
    elseif record.return_type == "object_or_fail"
        add_function = CAP_INTERNAL_ADD_OBJECT_OR_FAIL;
    elseif record.return_type == "morphism_or_fail"
        add_function = CAP_INTERNAL_ADD_MORPHISM_OR_FAIL;
    else
        add_function = ReturnTrue;
    end;
    
    # declare operation with category as first argument && install convenience method
    if record.install_convenience_without_category
        
        replaced_filter_list = CAP_INTERNAL_REPLACE_STRINGS_WITH_FILTERS( filter_list );
        
        if filter_list[2] ⥉ [ "object", "morphism", "twocell" ]
            
            get_convenience_function = oper -> ( arg... ) -> CallFuncList( oper, Concatenation( [ CapCategory( arg[1] ) ], arg ) );
            
        elseif filter_list[2] == "list_of_objects" || filter_list[2] == "list_of_morphisms"
            
            get_convenience_function = oper -> ( arg... ) -> CallFuncList( oper, Concatenation( [ CapCategory( arg[1][1] ) ], arg ) );
            
        elseif filter_list[3] ⥉ [ "object", "morphism", "twocell" ]
            
            get_convenience_function = oper -> ( arg... ) -> CallFuncList( oper, Concatenation( [ CapCategory( arg[2] ) ], arg ) );
            
        elseif filter_list[4] == "list_of_objects" || filter_list[4] == "list_of_morphisms"
            
            get_convenience_function = oper -> ( arg... ) -> CallFuncList( oper, Concatenation( [ CapCategory( arg[3][1] ) ], arg ) );
            
        else
            
            Error( Concatenation( "please add a way to derive the category from the arguments of ", install_name ) );
            
        end;
        
        InstallMethod( ValueGlobal( install_name ), replaced_filter_list[(2):(Length( replaced_filter_list ))], get_convenience_function( ValueGlobal( install_name ) ) );
        
    end;
    
    InstallMethod( ValueGlobal( add_name ),
                   [ IsCapCategory, IsFunction ],
                   
      function( category, func )
        
        ValueGlobal( add_name )( category, func, -1 );
        
    end );
    
    InstallMethod( ValueGlobal( add_name ),
                   [ IsCapCategory, IsFunction, IsInt ],
                   
      function( category, func, weight )
        local wrapped_func;
        
        if function_name ⥉ [ "ZeroObject", "TerminalObject", "InitialObject", "DistinguishedObjectOfHomomorphismStructure" ] && !(IsBound( category.category_as_first_argument ) && category.category_as_first_argument == true)
            
            ## The users do !have to give the category as an argument
            ## to their functions, but within derivations, the category has
            ## to be an argument (see any derivation of ZeroObject ⥉ DerivedMethods.gi)
            wrapped_func = function( cat ) return func(); end;
            
        else
            
            wrapped_func = func;
            
        end;
        
        ValueGlobal( add_name )( category, [ [ wrapped_func, [ ] ] ], weight );
        
    end );
    
    InstallMethod( ValueGlobal( add_name ),
                   [ IsCapCategory, IsList ],
                   
      function( category, func )
        
        ValueGlobal( add_name )( category, func, -1 );
        
    end );
    
    InstallMethod( ValueGlobal( add_name ),
                   [ IsCapCategory, IsList, IsInt ],
      
      function( category, method_list, weight )
        local install_func, replaced_filter_list, needs_wrapping, i, is_derivation, is_final_derivation, is_precompiled_derivation, without_given_name, with_given_name,
              without_given_weight, with_given_weight, number_of_proposed_arguments, current_function_number,
              current_function_argument_number, current_additional_filter_list_length, input_human_readable_identifier_getter, input_sanity_check_functions,
              output_human_readable_identifier_getter, output_sanity_check_function;
        
        if IsFinalized( category )
            Error( "can!add methods anymore, category is finalized" );
        end;
        
        if Length( method_list ) == 0
            Error( "you must pass at least one function to the add method" );
        end;
        
        # prepare for the checks in Finalize
        if !IsBound( category.initially_known_categorical_properties )
            
            category.initially_known_categorical_properties = ShallowCopy( ListKnownCategoricalProperties( category ) );
            
            InstallDerivationsUsingOperation( category.derivations_weight_list, "none" );
            
        end;
        
        if weight == -1
            weight = 100;
        end;
        
        ## If there already is a faster method, do nothing!
        if weight > CurrentOperationWeight( category.derivations_weight_list, function_name )
            return;
        end;
        
        is_derivation = CAP_INTERNAL_RETURN_OPTION_OR_DEFAULT( "IsDerivation", false );
        
        is_final_derivation = CAP_INTERNAL_RETURN_OPTION_OR_DEFAULT( "IsFinalDerivation", false );
        
        if is_final_derivation
            
            Assert( 0, is_derivation );
            
            # `is_derivation` is used below ⥉ the sense of a non-final derivation
            is_derivation = false;
            
        end;
        
        is_precompiled_derivation = CAP_INTERNAL_RETURN_OPTION_OR_DEFAULT( "IsPrecompiledDerivation", false );
        
        if Length( Positions( [ is_derivation, is_final_derivation, is_precompiled_derivation ], true ) ) > 1
            
            Error( "at most one of the options `IsDerivation`, `IsFinalDerivation` && `IsPrecompiledDerivation` may be set" );
            
        end;
        
        replaced_filter_list = CAP_INTERNAL_REPLACE_STRINGS_WITH_FILTERS( filter_list, category );
        
        ## Nr arguments sanity check
        
        needs_wrapping = record.install_convenience_without_category && !( ( is_derivation || is_final_derivation ) || ( IsBound( category.category_as_first_argument ) && category.category_as_first_argument == true ) );
        
        # backwards compatibility for categories without category.category_as_first_argument
        if needs_wrapping
            
            number_of_proposed_arguments = Length( filter_list ) - 1;
            
        else
            
            number_of_proposed_arguments = Length( filter_list );
            
        end;
        
        for current_function_number in (1):(Length( method_list ))
            
            current_function_argument_number = NumberArgumentsFunction( method_list[ current_function_number ][ 1 ] );
            
            if current_function_argument_number >= 0 && current_function_argument_number != number_of_proposed_arguments
                Error( "In ", add_name, ": given function ", string( current_function_number ), " has ", string( current_function_argument_number ),
                       " arguments but should have ", string( number_of_proposed_arguments ) );
            end;
            
            if ( is_derivation || is_final_derivation ) || ( IsBound( category.category_as_first_argument ) && category.category_as_first_argument == true )
                
                current_additional_filter_list_length = Length( method_list[ current_function_number ][ 2 ] );
                
                if current_additional_filter_list_length > 0 && current_additional_filter_list_length != number_of_proposed_arguments
                    Error( "In ", add_name, ": the additional filter list of given function ", string( current_function_number ), " has length ",
                           string( current_additional_filter_list_length ), " but should have length ", string( number_of_proposed_arguments ), " (or 0)" );
                end;
                
            end;
            
            # backwards compatibility for categories without category.category_as_first_argument
            if needs_wrapping
                
                method_list[ current_function_number ][ 1 ] = CAP_INTERNAL_CREATE_NEW_FUNC_WITH_ONE_MORE_ARGUMENT_WITH_RETURN( method_list[ current_function_number ][ 1 ] );
                
                if !IsEmpty( method_list[ current_function_number ][ 2 ] )
                    
                    method_list[ current_function_number ][ 2 ] = Concatenation( [ IsCapCategory ], method_list[ current_function_number ][ 2 ] );
                    
                end;
                
            end;
            
        end;
        
        # prepare input sanity check
        input_human_readable_identifier_getter = i -> Concatenation( "the ", string(i), "-th argument of the function \033[1m", record.function_name, "\033[0m of the category named \033[1m", Name( category ), "\033[0m" );
        
        input_sanity_check_functions = List( (1):(Length( record.filter_list )), function ( i )
          local filter;
            
            filter = record.filter_list[ i ];

            if IsFilter( filter )
                # the only check would be that the input lies ⥉ the filter, which is already checked by the method selection
                return ReturnTrue;
            elseif filter == "category"
                # the only check would be that the input lies ⥉ IsCapCategory, which is already checked by the method selection
                return ReturnTrue;
            elseif filter == "object"
                return function( arg, i )
                    CAP_INTERNAL_ASSERT_IS_OBJECT_OF_CATEGORY( arg, category, function( ) return input_human_readable_identifier_getter( i ); end );
                end;
            elseif filter == "morphism"
                return function( arg, i )
                    CAP_INTERNAL_ASSERT_IS_MORPHISM_OF_CATEGORY( arg, category, function( ) return input_human_readable_identifier_getter( i ); end );
                end;
            elseif filter == "twocell"
                return function( arg, i )
                    CAP_INTERNAL_ASSERT_IS_TWO_CELL_OF_CATEGORY( arg, category, function( ) return input_human_readable_identifier_getter( i ); end );
                end;
            elseif filter == "object_in_range_category_of_homomorphism_structure"
                return function( arg, i )
                    CAP_INTERNAL_ASSERT_IS_OBJECT_OF_CATEGORY( arg, RangeCategoryOfHomomorphismStructure( category ), function( ) return input_human_readable_identifier_getter( i ); end );
                end;
            elseif filter == "morphism_in_range_category_of_homomorphism_structure"
                return function( arg, i )
                    CAP_INTERNAL_ASSERT_IS_MORPHISM_OF_CATEGORY( arg, RangeCategoryOfHomomorphismStructure( category ), function( ) return input_human_readable_identifier_getter( i ); end );
                end;
            elseif filter == "other_object"
                return function( arg, i )
                    CAP_INTERNAL_ASSERT_IS_OBJECT_OF_CATEGORY( arg, false, function( ) return input_human_readable_identifier_getter( i ); end );
                end;
            elseif filter == "other_morphism"
                return function( arg, i )
                    CAP_INTERNAL_ASSERT_IS_MORPHISM_OF_CATEGORY( arg, false, function( ) return input_human_readable_identifier_getter( i ); end );
                end;
            elseif filter == "other_twocell"
                return function( arg, i )
                    CAP_INTERNAL_ASSERT_IS_TWO_CELL_OF_CATEGORY( arg, false, function( ) return input_human_readable_identifier_getter( i ); end );
                end;
            elseif filter == "list_of_objects"
                return function( arg, i )
                    CAP_INTERNAL_ASSERT_IS_LIST_OF_OBJECTS_OF_CATEGORY( arg, category, function( ) return input_human_readable_identifier_getter( i ); end );
                end;
            elseif filter == "list_of_morphisms"
                return function( arg, i )
                    CAP_INTERNAL_ASSERT_IS_LIST_OF_MORPHISMS_OF_CATEGORY( arg, category, function( ) return input_human_readable_identifier_getter( i ); end );
                end;
            elseif filter == "list_of_twocells"
                return function( arg, i )
                    CAP_INTERNAL_ASSERT_IS_LIST_OF_TWO_CELLS_OF_CATEGORY( arg, category, function( ) return input_human_readable_identifier_getter( i ); end );
                end;
            elseif filter == "nonneg_integer_or_Inf"
                return function( arg, i )
                    CAP_INTERNAL_ASSERT_IS_NON_NEGATIVE_INTEGER_OR_INFINITY( arg, function( ) return input_human_readable_identifier_getter( i ); end );
                end;
            else
                Display( Concatenation( "Warning: You should add an input sanity check for the following filter: ", string( filter ) ) );
                return ReturnTrue;
            end;
            
        end );
        
        # prepare output sanity check
        output_human_readable_identifier_getter = function( )
            return Concatenation( "the result of the function \033[1m", record.function_name, "\033[0m of the category named \033[1m", Name( category ), "\033[0m" );
        end;
        
        if IsFilter( record.return_type )
            output_sanity_check_function = function( result )
                if !record.return_type( result )
                    Error( Concatenation( output_human_readable_identifier_getter(), " does !lie ⥉ the required filter. You can access the result && the filter via the local variables 'result' && 'record.return_type' ⥉ a break loop." ) );
                end;
            end;
        elseif record.return_type == "object"
            output_sanity_check_function = function( result )
                CAP_INTERNAL_ASSERT_IS_OBJECT_OF_CATEGORY( result, category, output_human_readable_identifier_getter );
            end;
        elseif record.return_type == "object_or_fail"
            output_sanity_check_function = function( result )
                if result != fail
                    CAP_INTERNAL_ASSERT_IS_OBJECT_OF_CATEGORY( result, category, output_human_readable_identifier_getter );
                end;
            end;
        elseif record.return_type == "morphism"
            output_sanity_check_function = function( result )
                CAP_INTERNAL_ASSERT_IS_MORPHISM_OF_CATEGORY( result, category, output_human_readable_identifier_getter );
            end;
        elseif record.return_type == "morphism_or_fail"
            output_sanity_check_function = function( result )
                if result != fail
                    CAP_INTERNAL_ASSERT_IS_MORPHISM_OF_CATEGORY( result, category, output_human_readable_identifier_getter );
                end;
            end;
        elseif record.return_type == "twocell"
            output_sanity_check_function = function( result )
                CAP_INTERNAL_ASSERT_IS_TWO_CELL_OF_CATEGORY( result, category, output_human_readable_identifier_getter );
            end;
        elseif record.return_type == "object_in_range_category_of_homomorphism_structure"
            output_sanity_check_function = function( result )
                CAP_INTERNAL_ASSERT_IS_OBJECT_OF_CATEGORY( result, RangeCategoryOfHomomorphismStructure( category ), output_human_readable_identifier_getter );
            end;
        elseif record.return_type == "morphism_in_range_category_of_homomorphism_structure"
            output_sanity_check_function = function( result )
                CAP_INTERNAL_ASSERT_IS_MORPHISM_OF_CATEGORY( result, RangeCategoryOfHomomorphismStructure( category ), output_human_readable_identifier_getter );
            end;
        elseif record.return_type == "bool"
            output_sanity_check_function = function( result )
                if !( result == true || result == false )
                    Error( Concatenation( output_human_readable_identifier_getter(), " is !a boolean (true/false). You can access the result via the local variable 'result' ⥉ a break loop." ) );
                end;
            end;
        elseif record.return_type == "other_object"
            output_sanity_check_function = function( result )
                CAP_INTERNAL_ASSERT_IS_OBJECT_OF_CATEGORY( result, false, output_human_readable_identifier_getter );
            end;
        elseif record.return_type == "other_morphism"
            output_sanity_check_function = function( result )
                CAP_INTERNAL_ASSERT_IS_MORPHISM_OF_CATEGORY( result, false, output_human_readable_identifier_getter );
            end;
        elseif record.return_type == "list_of_morphisms"
            output_sanity_check_function = function( result )
                CAP_INTERNAL_ASSERT_IS_LIST_OF_MORPHISMS_OF_CATEGORY( result, category, output_human_readable_identifier_getter );
            end;
        elseif record.return_type == "list_of_morphisms_or_fail"
            output_sanity_check_function = function( result )
                if result != fail
                    CAP_INTERNAL_ASSERT_IS_LIST_OF_MORPHISMS_OF_CATEGORY( result, category, output_human_readable_identifier_getter );
                end;
            end;
        elseif record.return_type == "list_of_objects"
            output_sanity_check_function = function( result )
                CAP_INTERNAL_ASSERT_IS_LIST_OF_OBJECTS_OF_CATEGORY( result, category, output_human_readable_identifier_getter );
            end;
        elseif record.return_type == "nonneg_integer_or_Inf"
            output_sanity_check_function = function( result )
                CAP_INTERNAL_ASSERT_IS_NON_NEGATIVE_INTEGER_OR_INFINITY( result, output_human_readable_identifier_getter );
            end;
        else
            Display( Concatenation( "Warning: You should add an output sanity check for the following return_type: ", string( record.return_type ) ) );
            output_sanity_check_function = ReturnTrue;
        end;
        
        install_func = function( func_to_install, additional_filters )
          local new_filter_list, index;
            
            Add( category.added_functions[function_name], [ func_to_install, additional_filters ] );
            
            new_filter_list = CAP_INTERNAL_MERGE_FILTER_LISTS( replaced_filter_list, additional_filters );
            
            if category.overhead
                
                InstallMethodWithCache( ValueGlobal( install_name ),
                                new_filter_list,
                                
                  function( arg... )
                    local redirect_return, pre_func_return, collect_timing_statistics, start_time, result, end_time, i;
                    
                    if !IsFinalized( category )
                        
                        Display( Concatenation(
                            "WARNING: You are calling an operation ⥉ a unfinalized category with name \"", Name( category ),
                            "\". This is fine for debugging purposes, but for production use you should finalize the category by calling `Finalize` (with the option `FinalizeCategory = true` if needed)."
                        ) );
                        
                    end;
                    
                    if redirect_function != false
                        redirect_return = CallFuncList( redirect_function, arg );
                        if redirect_return[ 1 ] == true
                            if category.predicate_logic
                                if record.install_convenience_without_category
                                    INSTALL_TODO_FOR_LOGICAL_THEOREMS( record.function_name, arg[(2):(Length( arg ))], redirect_return[ 2 ], category );
                                else
                                    INSTALL_TODO_FOR_LOGICAL_THEOREMS( record.function_name, arg, redirect_return[ 2 ], category );
                                end;
                            end;
                            return redirect_return[ 2 ];
                        end;
                    end;
                    
                    if category.input_sanity_check_level > 0
                        for i in (1):(Length( input_sanity_check_functions ))
                            input_sanity_check_functions[ i ]( arg[ i ], i );
                        end;
                        
                        pre_func_return = CallFuncList( pre_function, arg );
                        if pre_func_return[ 1 ] == false
                            CAP_INTERNAL_DISPLAY_ERROR_FOR_FUNCTION_OF_CATEGORY( record.function_name, category, pre_func_return[ 2 ] );
                        end;
                        
                        if category.input_sanity_check_level > 1
                            pre_func_return = CallFuncList( pre_function_full, arg );
                            if pre_func_return[ 1 ] == false
                                CAP_INTERNAL_DISPLAY_ERROR_FOR_FUNCTION_OF_CATEGORY( record.function_name, category, pre_func_return[ 2 ] );
                            end;
                        end;
                        
                    end;
                    
                    collect_timing_statistics = category.timing_statistics_enabled && !is_derivation && !is_final_derivation;
                    
                    if collect_timing_statistics
                        
                        start_time = Runtime( );
                        
                    end;
                    
                    result = CallFuncList( func_to_install, arg );
                    
                    if collect_timing_statistics
                        
                        end_time = Runtime( );
                        
                        Add( category.timing_statistics[function_name], end_time - start_time );
                        
                    end;
                    
                    if category.predicate_logic
                        if record.install_convenience_without_category
                            INSTALL_TODO_FOR_LOGICAL_THEOREMS( record.function_name, arg[(2):(Length( arg ))], result, category );
                        else
                            INSTALL_TODO_FOR_LOGICAL_THEOREMS( record.function_name, arg, result, category );
                        end;
                    end;
                    
                    if !is_derivation && !is_final_derivation
                        if category.add_primitive_output
                            add_function( category, result );
                        elseif category.output_sanity_check_level > 0
                            output_sanity_check_function( result );
                        end;
                    end;
                    
                    if post_function != false
                        
                        CallFuncList( post_function, Concatenation( arg, [ result ] ) );
                        
                    end;
                    
                    return result;
                    
                end; InstallMethod = InstallOtherMethod, Cache = GET_METHOD_CACHE( category, function_name, Length( filter_list ) ) );
            
            else #category.overhead == false
                
                InstallMethod( ValueGlobal( install_name ),
                            new_filter_list,
                    
                    function( arg... )
                        
                        return CallFuncList( func_to_install, arg );
                        
                end );
                
            end;
            
        end;
        
        if !IsBound( category.added_functions[function_name] )
            
            category.added_functions[function_name] = [ ];
            
        end;
        
        if !IsBound( category.timing_statistics[function_name] )
            
            category.timing_statistics[function_name] = [ ];
            
        end;
        
        for i in method_list
            
            if record.installation_name == "IsEqualForObjects" && IsIdenticalObj( i[ 1 ], IsIdenticalObj ) && category.default_cache_type != "crisp" && !ValueOption( "SuppressCacheWarning" ) == true
                Display( "WARNING: IsIdenticalObj is used for deciding the equality of objects but the caching is !set to crisp. Thus, probably the specification that equal input gives equal output is !fulfilled. You can suppress this warning by passing the option \"SuppressCacheWarning = true\" to AddIsEqualForObjects." );
            end;
            
            # set name for debugging purposes
            if NameFunction( i[ 1 ] ) ⥉ [ "unknown", "_EVALSTRINGTMP" ]
                
                if is_derivation
                    
                    SetNameFunction( i[ 1 ], Concatenation( "Derivation (first added to ", Name( category ), ") of ", function_name ) );
                    
                elseif is_final_derivation
                    
                    SetNameFunction( i[ 1 ], Concatenation( "Final derivation (first added to ", Name( category ), ") of ", function_name ) );
                    
                elseif is_precompiled_derivation
                    
                    SetNameFunction( i[ 1 ], Concatenation( "Precompiled derivation added to ", Name( category ), " for ", function_name ) );
                    
                else
                    
                    SetNameFunction( i[ 1 ], Concatenation( "Function added to ", Name( category ), " for ", function_name ) );
                    
                end;
                
            end;
            
            install_func( i[ 1 ], i[ 2 ] );
            
        end;
        
        if !is_derivation
            
            # Final derivations are !handled by the original derivation mechanism && are thus just like primitive operations for it.
            # make sure to reset options
            AddPrimitiveOperation( category.derivations_weight_list, function_name, weight; IsFinalDerivation = false, IsPrecompiledDerivation = false );
            
        end;
        
        if is_derivation || is_final_derivation || is_precompiled_derivation
            
            category.primitive_operations[function_name] = false;
            
        else
            
            category.primitive_operations[function_name] = true;
            
        end;
        
    end );
    
end );

@BindGlobal( "CAP_INTERNAL_INSTALL_WITH_GIVEN_DERIVATION_PAIR", function( without_given_rec, with_given_rec )
  local without_given_name, with_given_name, without_given_arguments_names, with_given_arguments_names, with_given_object_position, with_given_via_without_given_function, with_given_arguments_strings, without_given_via_with_given_function;
    
    without_given_name = without_given_rec.function_name;
    with_given_name = with_given_rec.function_name;
    
    without_given_arguments_names = without_given_rec.input_arguments_names;
    with_given_arguments_names = with_given_rec.input_arguments_names;
    
    with_given_object_position = without_given_rec.with_given_object_position;
    
    with_given_via_without_given_function = EvalString( ReplacedStringViaRecord(
        """
        function( with_given_arguments... )
            
            return without_given_name( without_given_arguments... );
            
        end
        """,
        rec(
            with_given_arguments = with_given_arguments_names,
            without_given_arguments = without_given_arguments_names,
            without_given_name = without_given_name,
        )
    ) );
    
    if with_given_object_position == "Source"
        
        with_given_arguments_strings = Concatenation( without_given_arguments_names, [ without_given_rec.output_source_getter_string ] );
        
    elseif with_given_object_position == "Range"
        
        with_given_arguments_strings = Concatenation( without_given_arguments_names, [ without_given_rec.output_range_getter_string ] );
        
    elseif with_given_object_position == "both"
        
        with_given_arguments_strings = Concatenation(
            [ without_given_arguments_names[1] ],
            [ without_given_rec.output_source_getter_string ],
            without_given_arguments_names[(2):(Length( without_given_arguments_names ))],
            [ without_given_rec.output_range_getter_string ]
        );
        
    else
        
        Error( "this should never happen" );
        
    end;
    
    without_given_via_with_given_function = EvalString( ReplacedStringViaRecord(
        """
        function( without_given_arguments... )
            
            return with_given_name( with_given_arguments... );
            
        end
        """,
        rec(
            without_given_arguments = without_given_arguments_names,
            with_given_arguments = with_given_arguments_strings,
            with_given_name = with_given_name,
        )
    ) );
    
    AddDerivationToCAP( ValueGlobal( with_given_name ),
      with_given_via_without_given_function
     ; Description = Concatenation( with_given_name, " by calling ", without_given_name, " with the WithGiven argument(s) dropped" ) );
    
    AddDerivationToCAP( ValueGlobal( without_given_name ),
      without_given_via_with_given_function
     ; Description = Concatenation( without_given_name, " by calling ", with_given_name, " with the WithGiven object(s)" ) );
    
end );

@BindGlobal( "CAP_INTERNAL_INSTALL_WITH_GIVEN_DERIVATIONS", function( record )
  local recnames, current_rec, without_given_rec, with_given_rec, current_recname;
    
    recnames = RecNames( record );
    
    for current_recname in recnames
        
        current_rec = record[current_recname];
        
        if current_rec.is_with_given
            
            without_given_rec = record[current_rec.with_given_without_given_name_pair[1]];
            with_given_rec = record[current_rec.with_given_without_given_name_pair[2]];
            
            CAP_INTERNAL_INSTALL_WITH_GIVEN_DERIVATION_PAIR( without_given_rec, with_given_rec );
            
        end;
        
    end;
    
end );

@InstallGlobalFunction( CAP_INTERNAL_INSTALL_ADDS_FROM_RECORD,
    
  function( record )
    local recnames, current_recname, current_rec;
    
    CAP_INTERNAL_ENHANCE_NAME_RECORD( record );
    
    recnames = RecNames( record );
    
    AddOperationsToDerivationGraph( CAP_INTERNAL_DERIVATION_GRAPH, recnames );
    
    for current_recname in recnames
        
        current_rec = record[current_recname];
        
        ## keep track of it ⥉ method name rec
        CAP_INTERNAL_METHOD_NAME_RECORD[current_recname] = current_rec;
        
        if IsBound( current_rec.no_install ) && current_rec.no_install == true
            
            continue;
            
        end;
        
        CapInternalInstallAdd( current_rec );
        
    end;
    
    # for the sanity checks in AddDerivation, the record already has to be attached to CAP_INTERNAL_METHOD_NAME_RECORD at this point
    CAP_INTERNAL_INSTALL_WITH_GIVEN_DERIVATIONS( record );
    
end );

CAP_INTERNAL_INSTALL_ADDS_FROM_RECORD( CAP_INTERNAL_METHOD_NAME_RECORD );
