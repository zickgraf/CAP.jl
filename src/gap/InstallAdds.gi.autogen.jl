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
    
    Error( @Concatenation( "in function \033[1m", function_name,
        "\033[0m\n       of category \033[1m",
        Name( category ), ":\033[0m\n\033[1m       ", message, "\033[0m\n" ) );
    
end );

@InstallGlobalFunction( CapInternalInstallAdd,
  
  function( record )
    local function_name, CAP_operation, add_name, add_function, pre_function, pre_function_full,
          redirect_function, post_function, filter_list,
          add_value_to_category_function, replaced_filter_list,
          enhanced_filter_list, get_convenience_function;
    
    function_name = record.function_name;
    
    if !@IsBound( record.installation_name )
        
        CAP_operation = ValueGlobal( function_name );
        
    else
        
        CAP_operation = ValueGlobal( record.installation_name );
        
    end;
    
    add_name = @Concatenation( "Add", function_name );
    add_function = ValueGlobal( add_name );
    
    if @IsBound( record.pre_function )
        pre_function = record.pre_function;
    else
        pre_function = function( arg... ) return [ true ]; end;
    end;

    if @IsBound( record.pre_function_full )
        pre_function_full = record.pre_function_full;
    else
        pre_function_full = function( arg... ) return [ true ]; end;
    end;
    
    if @IsBound( record.redirect_function )
        redirect_function = record.redirect_function;
    else
        redirect_function = false;
    end;
    
    if @IsBound( record.post_function )
        post_function = record.post_function;
    else
        post_function = false;
    end;
    
    filter_list = record.filter_list;
    
    if record.return_type == "object"
        add_value_to_category_function = AddObject;
    elseif record.return_type == "morphism"
        add_value_to_category_function = AddMorphism;
    elseif record.return_type == "twocell"
        add_value_to_category_function = AddTwoCell;
    elseif record.return_type == "object_or_fail"
        add_value_to_category_function = CAP_INTERNAL_ADD_OBJECT_OR_FAIL;
    elseif record.return_type == "morphism_or_fail"
        add_value_to_category_function = CAP_INTERNAL_ADD_MORPHISM_OR_FAIL;
    else
        add_value_to_category_function = ReturnTrue;
    end;
    
    # declare operation with category as first argument && install convenience method
    if record.install_convenience_without_category
        
        replaced_filter_list = CAP_INTERNAL_REPLACED_STRINGS_WITH_FILTERS( filter_list );
        
        if filter_list[2] ⥉ [ "object", "morphism", "twocell" ]
            
            get_convenience_function = oper -> ( arg... ) -> CallFuncList( oper, @Concatenation( [ CapCategory( arg[1] ) ], arg ) );
            
        elseif filter_list[2] == "list_of_objects" || filter_list[2] == "list_of_morphisms"
            
            get_convenience_function = oper -> ( arg... ) -> CallFuncList( oper, @Concatenation( [ CapCategory( arg[1][1] ) ], arg ) );
            
        elseif filter_list[3] ⥉ [ "object", "morphism", "twocell" ]
            
            get_convenience_function = oper -> ( arg... ) -> CallFuncList( oper, @Concatenation( [ CapCategory( arg[2] ) ], arg ) );
            
        elseif filter_list[4] == "list_of_objects" || filter_list[4] == "list_of_morphisms"
            
            get_convenience_function = oper -> ( arg... ) -> CallFuncList( oper, @Concatenation( [ CapCategory( arg[3][1] ) ], arg ) );
            
        else
            
            Error( @Concatenation( "please add a way to derive the category from the arguments of ", function_name ) );
            
        end;
        
        InstallMethod( CAP_operation, replaced_filter_list[(2):(Length( replaced_filter_list ))], get_convenience_function( CAP_operation ) );
        
    end;
    
    # convenience for Julia lists
    #= comment for Julia
    if IsPackageMarkedForLoading( "JuliaInterface", ">= 0.2" )
        
        if "list_of_objects" ⥉ filter_list || "list_of_morphisms" ⥉ filter_list || "list_of_twocells" ⥉ filter_list
            
            replaced_filter_list = CAP_INTERNAL_REPLACED_STRINGS_WITH_FILTERS_FOR_JULIA( filter_list );
            
            @Assert( 0, ValueGlobal( "IsJuliaObject" ) ⥉ replaced_filter_list );
            
            InstallOtherMethod( CAP_operation,
                    replaced_filter_list,
                    ( arg... ) -> CallFuncList( CAP_operation,
                            List( arg, function( ar ) if ValueGlobal( "IsJuliaObject" )( ar ) then return ValueGlobal( "ConvertJuliaToGAP" )( ar ); fi; return ar; end ) ) );
            
            @Assert( 0, record.install_convenience_without_category );
            
            InstallOtherMethod( CAP_operation,
                    replaced_filter_list[(2):(Length( replaced_filter_list ))],
                    ( arg... ) -> CallFuncList( CAP_operation,
                            List( arg, function( ar ) if ValueGlobal( "IsJuliaObject" )( ar ) then return ValueGlobal( "ConvertJuliaToGAP" )( ar ); fi; return ar; end ) ) );
            
        end;
        
    end;
    # =#
    
    InstallMethod( add_function,
                   [ IsCapCategory, IsFunction ],
                   
      function( category, func )
        
        add_function( category, func, -1 );
        
    end );
    
    InstallMethod( add_function,
                   [ IsCapCategory, IsFunction, IsInt ],
                   
      function( category, func, weight )
        
        add_function( category, [ [ func, [ ] ] ], weight );
        
    end );
    
    InstallMethod( add_function,
                   [ IsCapCategory, IsList ],
                   
      function( category, func )
        
        add_function( category, func, -1 );
        
    end );
    
    InstallMethod( add_function,
                   [ IsCapCategory, IsList, IsInt ],
      
      function( category, method_list, weight )
        local is_derivation, is_final_derivation, is_precompiled_derivation, replaced_filter_list, needs_wrapping,
            number_of_proposed_arguments, current_function_argument_number, current_additional_filter_list_length,
            input_sanity_check_functions, output_human_readable_identifier_list, output_sanity_check_function,
            output_data_type, assert_is_value_of_return_type, install_func, name, current_function_number, i;
        
        if IsFinalized( category )
            Error( "can!add methods anymore, category is finalized" );
        end;
        
        if Length( method_list ) == 0
            Error( "you must pass at least one function to the add method" );
        end;
        
        # prepare for the checks in Finalize
        if !@IsBound( category.initially_known_categorical_properties )
            
            category.initially_known_categorical_properties = ShallowCopy( ListKnownCategoricalProperties( category ) );
            
            InstallDerivationsUsingOperation( category.derivations_weight_list, "none" );
            
        end;
        
        if weight == -1
            weight = 100;
        end;
        
        # If there already is a faster method: do nothing but display a warning because this should !happen usually.
        if weight > CurrentOperationWeight( category.derivations_weight_list, function_name )
            
            # * Not all derivations are properly dualized, so it can happen that a derivation for the dual of an operation is cheaper then the operation.
            #   This would automatically be fixed by https://github.com/homalg-project/CAP_project/issues/1078.
            # * There are some derivations of weight 1 for thin categories which are triggered immediately && which CategoryConstructor tries to overwrite with weight 100.
            if !WasCreatedAsOppositeCategory( category ) && CurrentOperationWeight( category.derivations_weight_list, function_name ) != 1
                
                Print( "WARNING: Ignoring a function added for ", function_name, " with weight ", weight, " to \"", Name( category ), "\" because there already is a function installed with weight ", CurrentOperationWeight( category.derivations_weight_list, function_name ), ".\n" );
                
            end;
            
            return;
            
        end;
        
        is_derivation = CAP_INTERNAL_RETURN_OPTION_OR_DEFAULT( "IsDerivation", false );
        
        is_final_derivation = CAP_INTERNAL_RETURN_OPTION_OR_DEFAULT( "IsFinalDerivation", false );
        
        if is_final_derivation
            
            @Assert( 0, is_derivation );
            
            # `is_derivation` is used below ⥉ the sense of a non-final derivation
            is_derivation = false;
            
        end;
        
        is_precompiled_derivation = CAP_INTERNAL_RETURN_OPTION_OR_DEFAULT( "IsPrecompiledDerivation", false );
        
        if Length( Positions( [ is_derivation, is_final_derivation, is_precompiled_derivation ], true ) ) > 1
            
            Error( "at most one of the options `IsDerivation`, `IsFinalDerivation` && `IsPrecompiledDerivation` may be set" );
            
        end;
        
        # Display a warning when overwriting primitive operations with derivations.
        if (is_derivation || is_final_derivation || is_precompiled_derivation) && @IsBound( category.primitive_operations[function_name] ) && category.primitive_operations[function_name]
            
            # * Not all derivations are properly dualized, so it can happen that a derivation for the dual of an operation is cheaper then the operation.
            #   This would automatically be fixed by https://github.com/homalg-project/CAP_project/issues/1078.
            # * There is a test ⥉ Locales creating a category via CategoryConstructor (which uses weight 100) && then installs a really cheap method for UniqueMorphism which triggers a bunch of cheap derivations.
            if !WasCreatedAsOppositeCategory( category ) && weight > 4
                
                Print( "WARNING: Overriding a function for ", function_name, " primitively added to \"", Name( category ), "\" with a derivation.\n" );
                
            end;
            
        end;
        
        replaced_filter_list = CAP_INTERNAL_REPLACED_STRINGS_WITH_FILTERS( filter_list, category );
        
        ## Nr arguments sanity check
        
        if !category.category_as_first_argument ⥉ [ false, true ]
            
            Print(
                "WARNING: Please set the component `category_as_first_argument` of the category with name \"", Name( category ), "\" explicitly to `true` || `false`. ",
                "Currently, the default value is `false` (which will now be set automatically), but this will change ⥉ the future.\n"
            );
            
            category.category_as_first_argument = false;
            
        end;
        
        # backwards compatibility for categories with `category.category_as_first_argument == false`
        needs_wrapping = category.category_as_first_argument == false && !(is_derivation || is_final_derivation);
        
        if needs_wrapping
            
            number_of_proposed_arguments = Length( filter_list ) - 1;
            
        else
            
            number_of_proposed_arguments = Length( filter_list );
            
        end;
        
        for current_function_number in (1):(Length( method_list ))
            
            current_function_argument_number = NumberArgumentsFunction( method_list[ current_function_number ][ 1 ] );
            
            if current_function_argument_number >= 0 && current_function_argument_number != number_of_proposed_arguments
                Error( "In ", add_name, ": given function ", StringGAP( current_function_number ), " has ", StringGAP( current_function_argument_number ),
                       " arguments but should have ", StringGAP( number_of_proposed_arguments ) );
            end;
            
            if !needs_wrapping
                
                current_additional_filter_list_length = Length( method_list[ current_function_number ][ 2 ] );
                
                if current_additional_filter_list_length > 0 && current_additional_filter_list_length != number_of_proposed_arguments
                    Error( "In ", add_name, ": the additional filter list of given function ", StringGAP( current_function_number ), " has length ",
                           StringGAP( current_additional_filter_list_length ), " but should have length ", StringGAP( number_of_proposed_arguments ), " (or 0)" );
                end;
                
            else
                
                method_list[ current_function_number ][ 1 ] = CAP_INTERNAL_CREATE_NEW_FUNC_WITH_ONE_MORE_ARGUMENT_WITH_RETURN( method_list[ current_function_number ][ 1 ] );
                
                if !IsEmpty( method_list[ current_function_number ][ 2 ] )
                    
                    method_list[ current_function_number ][ 2 ] = @Concatenation( [ IsCapCategory ], method_list[ current_function_number ][ 2 ] );
                    
                end;
                
            end;
            
        end;
        
        # prepare input sanity check
        input_sanity_check_functions = List( (1):(Length( record.filter_list )), function ( i )
          local filter_string, data_type, assert_is_value_of_type;
            
            filter_string = record.filter_list[ i ];
            
            data_type = CAP_INTERNAL_GET_DATA_TYPE_FROM_STRING( filter_string, category );
            
            if data_type != fail
                
                return CAP_INTERNAL_ASSERT_VALUE_IS_OF_TYPE_GETTER( data_type, [ "the ", i, "-th argument of the function \033[1m", record.function_name, "\033[0m of the category named \033[1m", Name( category ), "\033[0m" ] );
                
            else
                
                return ReturnTrue;
                
            end;
            
        end );
        
        # prepare output sanity check
        output_human_readable_identifier_list = [ "the result of the function \033[1m", record.function_name, "\033[0m of the category named \033[1m", Name( category ), "\033[0m" ];
        
        if EndsWith( record.return_type, "_or_fail" )
            
            output_data_type = CAP_INTERNAL_GET_DATA_TYPE_FROM_STRING( record.return_type[(1):(Length( record.return_type ) - 8)], category );
            
        else
            
            output_data_type = CAP_INTERNAL_GET_DATA_TYPE_FROM_STRING( record.return_type, category );
            
        end;
        
        if output_data_type != fail
            
            assert_is_value_of_return_type = CAP_INTERNAL_ASSERT_VALUE_IS_OF_TYPE_GETTER( output_data_type, output_human_readable_identifier_list );
            
            if EndsWith( record.return_type, "_or_fail" )
                
                output_sanity_check_function = function( result )
                    
                    if result != fail
                        
                        assert_is_value_of_return_type( result );
                        
                    end;
                    
                end;
                
            else
                
                output_sanity_check_function = assert_is_value_of_return_type;
                
            end;
            
        else
            
            output_sanity_check_function = ReturnTrue;
            
        end;
        
        install_func = function( func_to_install, additional_filters )
          local new_filter_list, index;
            
            Add( category.added_functions[function_name], [ func_to_install, additional_filters ] );
            
            new_filter_list = CAP_INTERNAL_MERGE_FILTER_LISTS( replaced_filter_list, additional_filters );
            
            if category.overhead
                
                InstallMethodWithCache( CAP_operation,
                                new_filter_list,
                                
                  function( arg... )
                    local redirect_return, pre_func_return, collect_timing_statistics, start_time, result, end_time, i;
                    
                    if !IsFinalized( category ) && !category.primitive_operations[function_name]
                        
                        Print(
                            "WARNING: You are calling an operation ⥉ an unfinalized category with name \"", Name( category ),
                            "\". This is fine for debugging purposes, but for production use you should finalize the category by calling `Finalize` (with the option `FinalizeCategory = true` if needed).\n"
                        );
                        
                    end;
                    
                    if redirect_function != false
                        redirect_return = CallFuncList( redirect_function, arg );
                        if redirect_return[ 1 ] == true
                            if category.predicate_logic
                                INSTALL_TODO_FOR_LOGICAL_THEOREMS( record.function_name, arg[(2):(Length( arg ))], redirect_return[ 2 ], category );
                            end;
                            return redirect_return[ 2 ];
                        end;
                    end;
                    
                    if category.input_sanity_check_level > 0
                        for i in (1):(Length( input_sanity_check_functions ))
                            input_sanity_check_functions[ i ]( arg[ i ] );
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
                        INSTALL_TODO_FOR_LOGICAL_THEOREMS( record.function_name, arg[(2):(Length( arg ))], result, category );
                    end;
                    
                    if !is_derivation && !is_final_derivation
                        if category.add_primitive_output
                            add_value_to_category_function( category, result );
                        elseif category.output_sanity_check_level > 0
                            output_sanity_check_function( result );
                        end;
                    end;
                    
                    if post_function != false
                        
                        CallFuncList( post_function, @Concatenation( arg, [ result ] ) );
                        
                    end;
                    
                    return result;
                    
                end; InstallMethod = InstallOtherMethod, Cache = GET_METHOD_CACHE( category, function_name, Length( filter_list ) ) );
            
            else #category.overhead == false
                
                InstallOtherMethod( CAP_operation,
                            new_filter_list,
                    
                    function( arg... )
                        
                        return CallFuncList( func_to_install, arg );
                        
                end );
                
            end;
            
        end;
        
        if !@IsBound( category.added_functions[function_name] )
            
            category.added_functions[function_name] = [ ];
            
        end;
        
        if !@IsBound( category.timing_statistics[function_name] )
            
            category.timing_statistics[function_name] = [ ];
            
        end;
        
        for i in method_list
            
            name = Name( category );
            
            # set name for debugging purposes
            if NameFunction( i[ 1 ] ) ⥉ [ "unknown", "_EVALSTRINGTMP" ]
                
                if is_derivation
                    
                    SetNameFunction( i[ 1 ], @Concatenation( "Derivation (first added to ", name, ") of ", function_name ) );
                    
                elseif is_final_derivation
                    
                    SetNameFunction( i[ 1 ], @Concatenation( "Final derivation (first added to ", name, ") of ", function_name ) );
                    
                elseif is_precompiled_derivation
                    
                    SetNameFunction( i[ 1 ], @Concatenation( "Precompiled derivation added to ", name, " for ", function_name ) );
                    
                else
                    
                    SetNameFunction( i[ 1 ], @Concatenation( "Function added to ", name, " for ", function_name ) );
                    
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
  local without_given_name, with_given_name, without_given_arguments_names, with_given_arguments_names, with_given_object_position, with_given_via_without_given_function, with_given_arguments_strings, additional_preconditions, x, pos, without_given_via_with_given_function;
    
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
        @rec(
            with_given_arguments = with_given_arguments_names,
            without_given_arguments = without_given_arguments_names,
            without_given_name = without_given_name,
        )
    ) );
    
    if with_given_object_position == "Source"
        
        with_given_arguments_strings = @Concatenation( without_given_arguments_names, [ without_given_rec.output_source_getter_string ] );
        
        if !@IsBound( without_given_rec.output_source_getter_preconditions )
            
            Print( "WARNING: Can!install with given derivation pair for ", without_given_name, " because <without_given_rec.output_source_getter_preconditions> is !set.\n" );
            return;
            
        end;
        
        additional_preconditions = without_given_rec.output_source_getter_preconditions;
        
    elseif with_given_object_position == "Range"
        
        with_given_arguments_strings = @Concatenation( without_given_arguments_names, [ without_given_rec.output_range_getter_string ] );
        
        if !@IsBound( without_given_rec.output_range_getter_preconditions )
            
            Print( "WARNING: Can!install with given derivation pair for ", without_given_name, " because <without_given_rec.output_range_getter_preconditions> is !set.\n" );
            return;
            
        end;
        
        additional_preconditions = without_given_rec.output_range_getter_preconditions;
        
    elseif with_given_object_position == "both"
        
        with_given_arguments_strings = @Concatenation(
            [ without_given_arguments_names[1] ],
            [ without_given_rec.output_source_getter_string ],
            without_given_arguments_names[(2):(Length( without_given_arguments_names ))],
            [ without_given_rec.output_range_getter_string ]
        );
        
        if !@IsBound( without_given_rec.output_source_getter_preconditions )
            
            Print( "WARNING: Can!install with given derivation pair for ", without_given_name, " because <without_given_rec.output_source_getter_preconditions> is !set.\n" );
            return;
            
        end;
        
        if !@IsBound( without_given_rec.output_range_getter_preconditions )
            
            Print( "WARNING: Can!install with given derivation pair for ", without_given_name, " because <without_given_rec.output_range_getter_preconditions> is !set.\n" );
            return;
            
        end;
        
        # merge output_source_getter_preconditions && output_range_getter_preconditions
        additional_preconditions = without_given_rec.output_source_getter_preconditions;
        
        for x in without_given_rec.output_range_getter_preconditions
            
            pos = PositionProperty( additional_preconditions, y -> y[1] == x[1] );
            
            if pos == fail
                
                Add( additional_preconditions, x );
                
            else
                
                additional_preconditions[pos][2] = additional_preconditions[pos][2] + x[2];
                
            end;
            
        end;
        
    else
        
        Error( "this should never happen" );
        
    end;
    
    without_given_via_with_given_function = EvalString( ReplacedStringViaRecord(
        """
        function( without_given_arguments... )
            
            return with_given_name( with_given_arguments... );
            
        end
        """,
        @rec(
            without_given_arguments = without_given_arguments_names,
            with_given_arguments = with_given_arguments_strings,
            with_given_name = with_given_name,
        )
    ) );
    
    AddDerivationToCAP(
        ValueGlobal( with_given_name ),
        @Concatenation( with_given_name, " by calling ", without_given_name, " with the WithGiven argument(s) dropped" ),
        [ [ ValueGlobal( without_given_name ), 1 ] ],
        with_given_via_without_given_function
    );
    
    AddDerivationToCAP(
        ValueGlobal( without_given_name ),
        @Concatenation( without_given_name, " by calling ", with_given_name, " with the WithGiven object(s)" ),
        @Concatenation( [ [ ValueGlobal( with_given_name ), 1 ] ], List( additional_preconditions, x -> [ ValueGlobal( x[1] ), x[2] ] ) ),
        without_given_via_with_given_function
    );
    
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
    
    recnames = RecNames( record );
    
    AddOperationsToDerivationGraph( CAP_INTERNAL_DERIVATION_GRAPH, recnames );
    
    for current_recname in recnames
        
        current_rec = record[current_recname];
        
        if !@IsBound( current_rec.function_name )
            
            Error( "the record has no entry `function_name`, probably you forgot to call CAP_INTERNAL_ENHANCE_NAME_RECORD" );
            
        end;
        
        ## keep track of it ⥉ method name rec
        CAP_INTERNAL_METHOD_NAME_RECORD[current_recname] = current_rec;
        
        CapInternalInstallAdd( current_rec );
        
    end;
    
    # for the sanity checks in AddDerivation, the record already has to be attached to CAP_INTERNAL_METHOD_NAME_RECORD at this point
    CAP_INTERNAL_INSTALL_WITH_GIVEN_DERIVATIONS( record );
    
end );

CAP_INTERNAL_INSTALL_ADDS_FROM_RECORD( CAP_INTERNAL_METHOD_NAME_RECORD );
