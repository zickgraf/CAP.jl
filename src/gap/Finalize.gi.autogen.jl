# SPDX-License-Identifier: GPL-2.0-or-later
# CAP: Categories, Algorithms, Programming
#
# Implementations
#
@InstallValueConst( CAP_INTERNAL_FINAL_DERIVATION_LIST,
              rec( final_derivation_list = [ ] ) );

@BindGlobal( "CAP_INTERNAL_FINAL_DERIVATION_SANITY_CHECK",
  
  function( final_derivation )
    local method_name, filter_list, number_of_proposed_arguments, current_function_argument_number, derivation;
    
    if IsEmpty( final_derivation.derivations )
        
        Error( "trying to add a final derivation without any functions to install" );
        
    end;
    
    if StartsWith( TargetOperation( final_derivation.derivations[1] ), "IsomorphismFrom" ) && Length( final_derivation.derivations ) == 1
        
        Print( "WARNING: You are installing a final derivation for ", TargetOperation( final_derivation.derivations[1] ), " which does !include its inverse. You should probably use a bundled final derivation to also install its inverse.\n" );
        
    end;
    
    for derivation in final_derivation.derivations
        
        if !TargetOperation( derivation ) ⥉ final_derivation.cannot_compute
            
            Print( "WARNING: A final derivation for ", TargetOperation( final_derivation.derivations[1] ), " installs ", TargetOperation( derivation ), " but does !list it in its exclude list.\n" );
            
        end;
        
        # see AddDerivation ⥉ Derivations.gi
        method_name = TargetOperation( derivation );
        
        if !IsBound( CAP_INTERNAL_METHOD_NAME_RECORD[method_name] )
            
            Error( "trying to add a final derivation for a method !in CAP_INTERNAL_METHOD_NAME_RECORD" );
            
        end;
        
        filter_list = CAP_INTERNAL_METHOD_NAME_RECORD[method_name].filter_list;
        
        number_of_proposed_arguments = Length( filter_list );
        
        current_function_argument_number = NumberArgumentsFunction( DerivationFunction( derivation ) );
        
        if current_function_argument_number >= 0 && current_function_argument_number != number_of_proposed_arguments
            Error( "While adding a final derivation for ", method_name, ": given function has ", StringGAP( current_function_argument_number ),
                   " arguments but should have ", StringGAP( number_of_proposed_arguments ) );
        end;
        
    end;
    
end );

@InstallGlobalFunction( AddFinalDerivation,
               
  function( target_op, args... )
    local description, can_compute, cannot_compute, func, additional_functions;
    
    if IsString( args[1] )
        
        description = args[1];
        can_compute = args[2];
        cannot_compute = args[3];
        func = args[4];
        additional_functions = args[(5):(Length( args ))];
        
    else
        
        Print( "WARNING: Calling AddFinalDerivation without a description as the second argument is deprecated && will !be supported after 2024.03.31.\n" );
        
        description = CAP_INTERNAL_RETURN_OPTION_OR_DEFAULT( "Description", "" );
        can_compute = args[1];
        cannot_compute = args[2];
        func = args[3];
        additional_functions = args[(4):(Length( args ))];
        
    end;
    
    if !IsEmpty( additional_functions )
        
        Display( "WARNING: AddFinalDerivation with additional functions is deprecated && will !be supported after 2023.10.28. Please use AddFinalDerivationBundle instead." );
        
    end;
    
    CallFuncList( AddFinalDerivationBundle, Concatenation( [ description, can_compute, cannot_compute, [ target_op, can_compute, func ] ], additional_functions ) );
    
end );

@InstallGlobalFunction( AddFinalDerivationBundle,
               
  function( args... )
    local description, can_compute, cannot_compute, additional_functions, weight, category_filter, loop_multiplier, category_getters, function_called_before_installation, operations_in_graph, operations_to_install, union_of_collected_lists, derivations, used_op_names_with_multiples_and_category_getters, collected_list, dummy_func, dummy_derivation, final_derivation, i, current_additional_func, x;
    
    if IsString( args[1] )
        
        description = args[1];
        can_compute = args[2];
        cannot_compute = args[3];
        additional_functions = args[(4):(Length( args ))];
        
    else
        
        Print( "WARNING: Calling AddFinalDerivationBundle without a description as the first argument is deprecated && will !be supported after 2024.03.31.\n" );
        
        description = CAP_INTERNAL_RETURN_OPTION_OR_DEFAULT( "Description", "" );
        can_compute = args[1];
        cannot_compute = args[2];
        additional_functions = args[(3):(Length( args ))];
        
    end;
    
    if IsEmpty( additional_functions )
        
        Error( "trying to add a final derivation without any functions to install" );
        
    end;
    
    weight = CAP_INTERNAL_RETURN_OPTION_OR_DEFAULT( "Weight", 1 );
    category_filter = CAP_INTERNAL_RETURN_OPTION_OR_DEFAULT( "CategoryFilter", IsCapCategory );
    loop_multiplier = CAP_INTERNAL_RETURN_OPTION_OR_DEFAULT( "WeightLoopMultiple", 2 );
    category_getters = CAP_INTERNAL_RETURN_OPTION_OR_DEFAULT( "CategoryGetters", rec( ) );
    function_called_before_installation = CAP_INTERNAL_RETURN_OPTION_OR_DEFAULT( "FunctionCalledBeforeInstallation", false );
    
    for i in (1):(Length( additional_functions ))
        
        if !(IsList( additional_functions[i] ) && Length( additional_functions[i] ) ⥉ [ 2, 3 ])
            
            Error( "additional functions must be given as pairs [ <operation>, <function> ] || triples [ <operation>, <function>, <preconditions> ]" );
            
        end;
        
        if IsList( Last( additional_functions[i] ) )
            
            Error( "passing lists of functions to `AddFinalDerivation` is !supported anymore" );
            
        end;
        
    end;
    
    operations_in_graph = Operations( CAP_INTERNAL_DERIVATION_GRAPH );
    
    ## Find symbols ⥉ functions
    operations_to_install = [ ];
    
    union_of_collected_lists = [ ];
    
    derivations = [ ];
    
    for current_additional_func in additional_functions
        
        used_op_names_with_multiples_and_category_getters = fail;
        
        # see AddDerivation ⥉ Derivations.gi
        #= comment for Julia
        collected_list = CAP_INTERNAL_FIND_APPEARANCE_OF_SYMBOL_IN_FUNCTION( Last( current_additional_func ), operations_in_graph, loop_multiplier, CAP_INTERNAL_METHOD_RECORD_REPLACEMENTS, category_getters );
        
        if Length( current_additional_func ) == 2
            
            Print( "WARNING: a final derivation for ", NameFunction( current_additional_func[1] ), " has no explicit preconditions. Calling AddFinalDerivation(Bundle) without explicit preconditions is deprecated && will !be supported after 2024.03.31.\n" );
            
            current_additional_func = [ current_additional_func[1], collected_list, current_additional_func[2] ];
            
        end;
        # =#
        
        @Assert( 0, Length( current_additional_func ) == 3 );
        
        used_op_names_with_multiples_and_category_getters = [ ];
        
        for x in current_additional_func[2]
            
            if Length( x ) < 2 || !IsFunction( x[1] ) || !IsInt( x[2] )
                
                Error( "preconditions must be of the form `[op, mult, getter]`, where `getter` is optional" );
                
            end;
            
            if (Length( x ) == 2 || (Length( x ) == 3 && x[3] == fail)) && x[1] == current_additional_func[1]
                
                Error( "A final derivation for ", NameFunction( current_additional_func[1] ), " has itself as a precondition. This is !supported because we can!compute a well-defined weight.\n" );
                
            end;
            
            if Length( x ) == 2
                
                Add( used_op_names_with_multiples_and_category_getters, [ NameFunction( x[1] ), x[2], fail ] );
                
            elseif Length( x ) == 3
                
                if x != fail && !(IsFunction( x[3] ) && NumberArgumentsFunction( x[3] ) == 1)
                    
                    Error( "the category getter must be a single-argument function" );
                    
                end;
                
                Add( used_op_names_with_multiples_and_category_getters, [ NameFunction( x[1] ), x[2], x[3] ] );
                
            else
                
                Error( "The list of preconditions must be a list of pairs || triples." );
                
            end;
            
        end;
        
        #= comment for Julia
        if Length( collected_list ) != Length( used_op_names_with_multiples_and_category_getters ) || !ForAll( collected_list, c -> c ⥉ used_op_names_with_multiples_and_category_getters )
            
            SortBy( used_op_names_with_multiples_and_category_getters, x -> x[1] );
            SortBy( collected_list, x -> x[1] );
            
            Print(
                "WARNING: You have installed a final derivation for ", NameFunction( current_additional_func[1] ), " with preconditions ", used_op_names_with_multiples_and_category_getters,
                " but the automated detection has detected the following list of preconditions: ", collected_list, ".\n",
                "If this is a bug ⥉ the automated detection, please report it.\n"
            );
            
        end;
        # =#
        
        Add( derivations, MakeDerivation(
            Concatenation( description, " (final derivation)" ),
            current_additional_func[1],
            used_op_names_with_multiples_and_category_getters,
            weight,
            current_additional_func[3],
            category_filter
        ) );
        
        # Operations may use operations from the same final derivation as long as the latter are installed before the former.
        # In this case, the used operations are no preconditions && thus should !go into union_of_collected_lists.
        used_op_names_with_multiples_and_category_getters = Filtered( used_op_names_with_multiples_and_category_getters, x -> !x[1] ⥉ operations_to_install );
        
        Add( operations_to_install, NameFunction( current_additional_func[1] ) );
        
        union_of_collected_lists = CAP_INTERNAL_MERGE_PRECONDITIONS_LIST( union_of_collected_lists, used_op_names_with_multiples_and_category_getters );
        
    end;
    
    # see AddDerivation ⥉ Derivations.gi
    used_op_names_with_multiples_and_category_getters = [ ];
    
    for x in can_compute
        
        if Length( x ) < 2 || !IsFunction( x[1] ) || !IsInt( x[2] )
            
            Error( "preconditions must be of the form `[op, mult, getter]`, where `getter` is optional" );
            
        end;
        
        # CAP_INTERNAL_FINAL_DERIVATION_SANITY_CHECK ensures that all installed operations appear ⥉ cannot_compute
        if (Length( x ) == 2 || (Length( x ) == 3 && x[3] == fail)) && x[1] ⥉ cannot_compute
            
            Error( "A final derivation for ", TargetOperation( derivations[1] ), " has precondition ", x[1], " which is also in its exclude list.\n" );
            
        end;
        
        if Length( x ) == 2
            
            Add( used_op_names_with_multiples_and_category_getters, [ NameFunction( x[1] ), x[2], fail ] );
            
        elseif Length( x ) == 3
            
            if x != fail && !(IsFunction( x[3] ) && NumberArgumentsFunction( x[3] ) == 1)
                
                Error( "the category getter must be a single-argument function" );
                
            end;
            
            Add( used_op_names_with_multiples_and_category_getters, [ NameFunction( x[1] ), x[2], x[3] ] );
            
        else
            
            Error( "The list of preconditions must be a list of pairs || triples." );
            
        end;
        
    end;
    
    if Length( union_of_collected_lists ) != Length( used_op_names_with_multiples_and_category_getters ) || !ForAll( union_of_collected_lists, c -> c ⥉ used_op_names_with_multiples_and_category_getters )
        
        SortBy( used_op_names_with_multiples_and_category_getters, x -> x[1] );
        SortBy( union_of_collected_lists, x -> x[1] );
        
        Print(
            "WARNING: You have installed a final derivation for ", TargetOperation( derivations[1] ), " with preconditions ", used_op_names_with_multiples_and_category_getters,
            " but the following list of preconditions was expected: ", union_of_collected_lists, ".\n",
            "If this is a bug ⥉ the automated detection, please report it.\n"
        );
        
    end;
    
    dummy_func = x -> x;
    #= comment for Julia
    SetNameFunction( dummy_func, "internal dummy function of a final derivation" );
    # =#
    
    # only used to check if we can install all the derivations ⥉ `derivations`
    dummy_derivation = MakeDerivation(
        "dummy derivation",
        dummy_func,
        used_op_names_with_multiples_and_category_getters,
        1,
        ReturnTrue,
        category_filter
    );
    
    final_derivation = rec(
        dummy_derivation = dummy_derivation,
        cannot_compute = List( cannot_compute, x -> NameFunction( x ) ),
        derivations = derivations,
        function_called_before_installation = function_called_before_installation,
    );
    
    CAP_INTERNAL_FINAL_DERIVATION_SANITY_CHECK( final_derivation );
    
    Add( CAP_INTERNAL_FINAL_DERIVATION_LIST.final_derivation_list, final_derivation );
    
end );

InstallMethod( @__MODULE__,  Finalize,
               [ IsCapCategory ],
  
  function( category )
    local derivation_list, weight_list, current_install, current_final_derivation, filter, category_operation_weights, weight, operation_weights, operation_name, operation_weight, add_name, old_weights, categorical_properties, diff, properties_with_logic, property, i, x, derivation, property_name;
    
    if IsFinalized( category )
        
        return true;
        
    end;
    
    if ValueOption( "FinalizeCategory" ) == false
        
        return false;
        
    end;
    
    # prepare for the checks below (usually this is done when the first add function is called, but we support the case that no add function is called at all)
    if !IsBound( category.initially_known_categorical_properties )
        
        category.initially_known_categorical_properties = ShallowCopy( ListKnownCategoricalProperties( category ) );
        
        InstallDerivationsUsingOperation( category.derivations_weight_list, "none" );
        
    end;
    
    derivation_list = ShallowCopy( CAP_INTERNAL_FINAL_DERIVATION_LIST.final_derivation_list );
    
    if !category.is_computable
        
        derivation_list = Filtered( derivation_list, der -> !ForAny( der.derivations, x -> TargetOperation( x ) == "IsCongruentForMorphisms" ) );
        
    end;
    
    weight_list = category.derivations_weight_list;
    
    while true
        
        current_install = fail;
        
        for i in (1):(Length( derivation_list ))
            
            current_final_derivation = derivation_list[ i ];
            
            # check if all conditions for installing the final derivation are met
            
            if !IsApplicableToCategory( current_final_derivation.dummy_derivation, category )
                
                continue;
                
            end;
            
            if ForAny( current_final_derivation.cannot_compute, operation_name -> CurrentOperationWeight( weight_list, operation_name ) < Inf )
                
                continue;
                
            end;
            
            if OperationWeightUsingDerivation( weight_list, current_final_derivation.dummy_derivation ) == Inf
                
                continue;
                
            end;
            
            # if we get here, everything matched
            current_install = i;
            break;
            
        end;
        
        if current_install == fail
            
            break;
            
        else
            
            current_final_derivation = Remove( derivation_list, current_install );
            
            ## call function before adding the method
            
            if current_final_derivation.function_called_before_installation != false
                
                current_final_derivation.function_called_before_installation( category );
                
            end;
            
            for derivation in current_final_derivation.derivations
                
                weight = OperationWeightUsingDerivation( weight_list, derivation );
                
                @Assert( 0, weight != Inf );
                
                InstallDerivationForCategory( derivation, weight, category; IsFinalDerivation = true );
                
            end;
            
        end;
        
    end;
    
    if category.overhead
        
        # Check if reevaluation triggers new derivations. Derivations are installed recursively by `InstallDerivationsUsingOperation`, so this should never happen.
        # See the WARNING below for possible causes why it still might happen.
        old_weights = StructuralCopy( weight_list.operation_weights );
        
        Info( DerivationInfo, 1, "Starting reevaluation of derivation weight list of the category name \"", Name( category ), "\"\n" );
        
        Reevaluate( weight_list );
        
        Info( DerivationInfo, 1, "Finished reevaluation of derivation weight list of the category name \"", Name( category ), "\"\n" );
        
        categorical_properties = ListKnownCategoricalProperties( category );
        
        if !IsSubset( categorical_properties, category.initially_known_categorical_properties )
            
            Print( "WARNING: The category named \"", Name( category ), "\" has lost the following categorical properties since installation of the first function:\n" );
            Display( Difference( category.initially_known_categorical_properties, categorical_properties ) );
            
        end;
        
        if weight_list.operation_weights != old_weights
            
            Print( "WARNING: The installed derivations of the category named \"", Name( category ), "\" have changed by reevaluation, which is !expected at this point.\n" );
            Print( "This might be due to one of the following reasons:\n" );
            Print( "* The category might have gained a new setting like `supports_empty_limits` since adding the first function. Such settings should always be set before adding functions.\n" );
            Print( "* The category filter of some derivation might !fulfill the specification.\n" );
            
            diff = Difference( categorical_properties, category.initially_known_categorical_properties );
            
            if !IsEmpty( diff )
                
                Print( "* The category has gained the following new categorical properties since adding the first function: ", diff, ". Properties should always be set before adding functions for operations which might trigger derivations involving the properties.\n" );
                
            end;
            
            Print( "For debugging, call `ActivateDerivationInfo( )`, retry, && look at the derivations between \"Starting reevaluation of ...\" && \"Finished reevaluation of ...\".\n" );
            
        end;
        
    end;
    
    SetIsFinalized( category, true );
    
    if category.overhead
        
        properties_with_logic = RecNames( category.logical_implication_files.Propositions );
        
        # INSTALL_LOGICAL_IMPLICATIONS_HELPER indirectly calls `InstallTrueMethod` many times -> suspend method reordering
        SuspendMethodReordering( );
        
        for property_name in properties_with_logic
            
            property = ValueGlobal( property_name );
            
            if Tester( property )( category ) && property( category )
                
                INSTALL_LOGICAL_IMPLICATIONS_HELPER( category, property_name );
                
            end;
            
        end;
        
        ResumeMethodReordering( );
        
    end;
    
    return true;
    
end );
