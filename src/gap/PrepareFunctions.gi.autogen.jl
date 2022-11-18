# SPDX-License-Identifier: GPL-2.0-or-later
# CAP: Categories, Algorithms, Programming
#
# Implementations
#
#! @Chapter Add Functions

#! @Section Prepare functions

InstallValue( CAP_PREPARE_FUNCTION_RECORD, rec( ) );

InstallGlobalFunction( CAPOperationPrepareFunction,
  function( prepare_function, category, func )
    local current_prepare_function, prepare_function_symbol_list, current_operation;
    
    if !IsString( prepare_function )
        Error( "first argument must be a string" );
        return;
    end;
    
    if !IsCapCategory( category )
        Error( "second argument must be a category" );
        return;
    end;
    
    if !IsFunction( func )
        Error( "third argument must be a function" );
        return;
    end;
    
    if !IsBound( CAP_PREPARE_FUNCTION_RECORD[prepare_function] )
        Error( "No compatible prepare function found, see ListCAPPrepareFunctions(); for a list of prepare functions" );
        return;
    end;
    
    current_prepare_function = CAP_PREPARE_FUNCTION_RECORD[prepare_function];
    prepare_function_symbol_list = current_prepare_function[ 3 ];
    current_prepare_function = current_prepare_function[ 1 ];
    
    for current_operation in prepare_function_symbol_list
        if !CanCompute( category, current_operation )
            Print( "Warning: Operation ", current_operation, " is !installed for category ", Name( category ), "\n",
                   "         but is needed for another categorical operation\n" );
        end;
    end;
    
    return current_prepare_function( func, category );
    
end );

InstallGlobalFunction( CAPAddPrepareFunction,
  function( prepare_function, name, doc_string, arg... )
    local precondition_list, operation_names, used_symbol_list, current_precondition;
    
    #= comment for Julia
    if Length( arg ) == 1
        precondition_list = arg[ 1 ];
    else
        precondition_list = [ ];
    end;
    
    if !IsList( precondition_list )
        Error( "optional fourth argument must be a list" );
        return;
    end;
    
    operation_names = Operations( CAP_INTERNAL_DERIVATION_GRAPH );
    
    for current_precondition in precondition_list
        if !current_precondition ⥉ operation_names
            Error( Concatenation( "Precondition ", current_precondition, " !in list of known category functions" ) );
        end;
    end;
    
    used_symbol_list = CAP_INTERNAL_FIND_APPEARANCE_OF_SYMBOL_IN_FUNCTION( prepare_function, operation_names, 1, rec( ), rec( ) );
    used_symbol_list = List( used_symbol_list, i -> i[ 1 ] );
    used_symbol_list = Concatenation( used_symbol_list, precondition_list );
    used_symbol_list = DuplicateFreeList( used_symbol_list );
    
    CAP_PREPARE_FUNCTION_RECORD[name] = [ prepare_function, doc_string, used_symbol_list ];
    # =#
    
end );

InstallGlobalFunction( ListCAPPrepareFunctions,
  function( )
    local rec_names, current_entry, current_rec_name, current_precondition;
    
    rec_names = RecNames( CAP_PREPARE_FUNCTION_RECORD );
    
    for current_rec_name in rec_names
        current_entry = CAP_PREPARE_FUNCTION_RECORD[current_rec_name];
        Print( "Prepare function: ", current_rec_name, "\n" );
        Print( "  ", current_entry[ 2 ],"\n" );
        if Length( current_entry[ 3 ] ) > 0
            Print( "\nNeeds:\n" );
            for current_precondition in current_entry[ 3 ]
                Print( "* ", current_precondition, "\n" );
            end;
        end;
        Print( "\n" );
    end;
end );
