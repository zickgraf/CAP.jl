# SPDX-License-Identifier: GPL-2.0-or-later
# CAP: Categories, Algorithms, Programming
#
# Implementations
#
@InstallValueConst( CATEGORIES_LOGIC_FILES,
              
  rec(
      
      Propositions = rec(
          #= comment for Julia
          IsCapCategory = [
                       Filename( DirectoriesPackageLibrary( "CAP", "LogicForCategories" ), "PropositionsForGeneralCategories.tex" )
                     ],
          IsEnrichedOverCommutativeRegularSemigroup = [
                                                         Filename( DirectoriesPackageLibrary( "CAP", "LogicForCategories" ), "PropositionsForCategoriesEnrichedOverCommutativeRegularSemigroups.tex" )
                                                       ],
          IsAbCategory = [
                            Filename( DirectoriesPackageLibrary( "CAP", "LogicForCategories" ), "PropositionsForAbCategories.tex" )
                          ],
          IsAdditiveCategory = [
                                  Filename( DirectoriesPackageLibrary( "CAP", "LogicForCategories" ), "PropositionsForAdditiveCategories.tex" )
                                ],
          IsPreAbelianCategory = [
                                    Filename( DirectoriesPackageLibrary( "CAP", "LogicForCategories" ), "PropositionsForPreabelianCategories.tex" )
                                  ],
          IsAbelianCategory = [
                                  Filename( DirectoriesPackageLibrary( "CAP", "LogicForCategories" ), "PropositionsForAbelianCategories.tex" )
                               ],
          # =#
        ),
      Predicates = rec(
          #= comment for Julia
          IsCapCategory = [
                       Filename( DirectoriesPackageLibrary( "CAP", "LogicForCategories" ), "PredicateImplicationsForGeneralCategories.tex" )
                     ],
          IsEnrichedOverCommutativeRegularSemigroup = [
                                                         Filename( DirectoriesPackageLibrary( "CAP", "LogicForCategories" ), "PredicateImplicationsForCategoriesEnrichedOverCommutativeRegularSemigroups.tex" )
                                                       ],
          IsAbCategory = [
                            Filename( DirectoriesPackageLibrary( "CAP", "LogicForCategories" ), "PredicateImplicationsForAbCategories.tex" )
                          ],
          IsAdditiveCategory = [
                                  Filename( DirectoriesPackageLibrary( "CAP", "LogicForCategories" ), "PredicateImplicationsForAdditiveCategories.tex" )
                                ],
          IsPreAbelianCategory = [
                                    Filename( DirectoriesPackageLibrary( "CAP", "LogicForCategories" ), "PredicateImplicationsForPreabelianCategories.tex" )
                                  ],
          IsAbelianCategory = [
                                 Filename( DirectoriesPackageLibrary( "CAP", "LogicForCategories" ), "PredicateImplicationsForAbelianCategories.tex" )
                               ],
          # =#
        ),
      EvalRules = rec(
          #= comment for Julia
          IsCapCategory = [
                      Filename( DirectoriesPackageLibrary( "CAP", "LogicForCategories" ), "RelationsForGeneralCategories.tex" )
                     ],
          IsEnrichedOverCommutativeRegularSemigroup = [
                                                        Filename( DirectoriesPackageLibrary( "CAP", "LogicForCategories" ), "RelationsForCategoriesEnrichedOverCommutativeRegularSemigroups.tex" )
                                                       ],
          IsAbCategory = [
                           Filename( DirectoriesPackageLibrary( "CAP", "LogicForCategories" ), "RelationsForAbCategories.tex" )
                          ],
          IsAdditiveCategory = [
                                Filename( DirectoriesPackageLibrary( "CAP", "LogicForCategories" ), "RelationsForAdditiveCategories.tex" )
                                ],
          IsPreAbelianCategory = [
                                   Filename( DirectoriesPackageLibrary( "CAP", "LogicForCategories" ), "RelationsForPreabelianCategories.tex" )
                                  ],
          IsAbelianCategory = [
                                Filename( DirectoriesPackageLibrary( "CAP", "LogicForCategories" ), "RelationsForAbelianCategories.tex" )
                               ],
          # =#
        ),
     ) );

@InstallGlobalFunction( SetCapLogicInfo,
  
  function( arg... )
    local level;
    
    if Length( arg ) == 0
        level = 1;
    else
        level = arg[ 1 ];
    end;
    
    SetInfoLevel( CapLogicInfo, level );
    
end );

###################################
##
## Logic part 1: theorems
##
###################################


@InstallGlobalFunction( AddTheoremFileToCategory,
                       
  function( category, filename )
    local theorem_list, i;
    
    theorem_list = READ_THEOREM_FILE( filename );
    
    for i in theorem_list
        
        ADD_THEOREM_TO_CATEGORY( category, i );
        
    end;
    
end );

@InstallGlobalFunction( ADD_THEOREM_TO_CATEGORY,
                       
  function( category, implication_record )
    local theorem_record, name;
    
    theorem_record = TheoremRecord( category );
    
    name = implication_record.Function;
    
    if !IsBound( theorem_record[name] )
        
        theorem_record[name] = [ ];
        
    end;
    
    Add( theorem_record[name], implication_record );
    
end );

@InstallGlobalFunction( SANITIZE_RECORD,
                       
  function( record, arguments, result_object )
    local object, index_list, i, value_function, value;
    
    if !IsBound( record.Object )
        
        object = "result";
        
    else
        
        object = record.Object;
        
    end;
    
    if IsString( object ) && LowercaseString( object ) == "result"
        
        object = [ result_object ];
        
    elseif IsString( object ) && LowercaseString( object ) == "all"
        
        object = arguments;
        
    elseif IsInt( object )
        
        object = [ arguments[ object ] ];
        
    elseif IsList( object )
        
        index_list = object;
        
        object = [ arguments ];
        
        for i in index_list
            
            if IsInt( i )
                
                object = List( object, j -> j[ i ] );
                
            elseif IsString( i ) && LowercaseString( i ) == "all"
                
                object = @Concatenation( object );
                
            else
                
                Error( "wrong object format: only int && all" );
                
            end;
            
        end;
        
    else
        
        Error( "wrong object type" );
        
    end;
    
    if IsBound( record.ValueFunction )
        
        value_function = record.ValueFunction;
        
    else
        
        value_function = IdFunc;
        
    end;
    
    if IsBound( record.Value )
        
        value = record.Value;
        
    else
        
        value = true;
        
    end;
    
    if !IsBound( record.compare_function )
        
        return List( object, i -> [ i, value_function, value ] );
        
    else
        
        return List( object, i -> [ i, value_function, value, record.compare_function ] );
        
    end;
    
end );

@InstallGlobalFunction( INSTALL_TODO_FOR_LOGICAL_THEOREMS,
                       
  function( method_name, arguments, result_object, category )
    local current_argument, crisp_category, deductive_category, theorem_list,
          current_theorem, todo_list_source, range, is_valid_theorem, sanitized_source,
          entry, current_source, sanitized_source_list, current_argument_type, i;
    
    
    if !IsBound( TheoremRecord( category )[method_name] )
        
        return;
        
    end;
    
    Info( CapLogicInfo, 1, @Concatenation( "Creating todo list for operation ", method_name ) );
    
    theorem_list = TheoremRecord( category )[method_name];
    
    Info( CapLogicInfo, 1, @Concatenation( "Trying to create ", StringGAP( Length( theorem_list ) ), " theorems" ) );
    
    for current_theorem in theorem_list
        
        ## check wether argument list matches here
        current_argument_type = current_theorem.Variable_list;
        
        if Length( current_argument_type ) != Length( arguments )
            
            Error( "while installing todo for logical theorems: got ", Length( arguments ), " arguments but expected ", Length( current_argument_type ) );
            
        end;
        
        is_valid_theorem = true;
        
        for i in (1):(Length( current_argument_type ))
            
            if current_argument_type[ i ] == 0
                continue;
            end;
            
            if !IsList( arguments[ i ] ) || !Length( arguments[ i ] ) == current_argument_type[ i ]
                
                is_valid_theorem = false;
                
                break;
                
            end;
            
        end;
        
        if !is_valid_theorem
            continue;
        end;
        
        todo_list_source = [ ];
        
        is_valid_theorem = true;
        
        for current_source in current_theorem.Source
            
            sanitized_source_list = SANITIZE_RECORD( current_source, arguments, result_object );
            
            if IsBound( current_source.Type ) && LowercaseString( current_source.Type ) == "testdirect"
                
                for sanitized_source in sanitized_source_list
                    
                    if ( Length( sanitized_source ) == 3 && !sanitized_source[ 2 ]( sanitized_source[ 1 ] ) == sanitized_source[ 3 ] ) ||
                       ( Length( sanitized_source ) == 4 && !sanitized_source[ 4 ]( sanitized_source[ 2 ]( sanitized_source[ 1 ] ), sanitized_source[ 3 ] ) )
                        
                        is_valid_theorem = false;
                        
                        break;
                          
                    end;
                  
                end;
                
            else
                
                for sanitized_source in sanitized_source_list
                    
                    sanitized_source[ 2 ] = NameFunction( sanitized_source[ 2 ] );
                    
                    Add( todo_list_source, sanitized_source );
                    
                end;
                
            end;
            
        end;
        
        if is_valid_theorem == false
            
            Info( CapLogicInfo, 1, "Failed" );
            
            continue;
            
        end;
        
        Info( CapLogicInfo, 1, "Success" );
        
        range = SANITIZE_RECORD( current_theorem.Range, arguments, result_object );
        
        ## NO ALL ALLOWED HERE!
        range = range[ 1 ];
        
        if Length( todo_list_source ) == 0
            
            Setter( range[ 2 ] )( range[ 1 ], range[ 3 ] );
            
            continue;
            
        end;
        
        entry = ToDoListEntry( todo_list_source, range[ 1 ], NameFunction( range[ 2 ] ), range[ 3 ] );
        
        SetDescriptionOfImplication( entry, @Concatenation( "Implication from ", method_name ) );
        
        AddToToDoList( entry );
        
    end;
    
end );

##############################
##
## Logic part 2: predicates
##
##############################

@InstallGlobalFunction( AddPredicateImplicationFileToCategory,
                       
  function( category, filename )
    local theorem_list, i;
    
    theorem_list = READ_PREDICATE_IMPLICATION_FILE( filename );
    
    SuspendMethodReordering( );
    
    for i in theorem_list
        
        ADD_PREDICATE_IMPLICATIONS_TO_CATEGORY( category, i );
        
    end;
    
    ResumeMethodReordering( );
    
end );

##
@InstallGlobalFunction( ADD_PREDICATE_IMPLICATIONS_TO_CATEGORY,
                       
  function( category, immediate_record )
    
    INSTALL_PREDICATE_IMPLICATION( category, immediate_record );
    
    if !IsBound( category.predicate_implication )
        
        category.predicate_implication = [ ];
        
    end;
    
    Add( category.predicate_implication, immediate_record );
    
end );

##
@InstallGlobalFunction( INSTALL_PREDICATE_IMPLICATION,
                       
  function( category, immediate_record )
    local cell_filter;
    
    if LowercaseString( immediate_record.CellType ) == "obj"
        
        cell_filter = ObjectFilter( category );
        
    elseif LowercaseString( immediate_record.CellType ) == "mor"
        
        cell_filter = MorphismFilter( category );
        
    else
        
        cell_filter = TwoCellFilter( category );
        
    end;
    
    InstallTrueMethod( immediate_record.Range && cell_filter, immediate_record.Source && cell_filter );
    
end );

###############################
##
## Part 3: Eval rule API
##
###############################

##
@InstallGlobalFunction( AddEvalRuleFileToCategory,
                       
  function( category, filename )
    local theorem_list, i;
    
    Add( category.logical_implication_files.EvalRules.IsCapCategory, filename );
    
    if IsBound( category.logical_implication_files.EvalRules.general_rules_already_read ) &&
       category.logical_implication_files.EvalRules.general_rules_already_read == true
        
        theorem_list = READ_EVAL_RULE_FILE( filename );
        
        for i in theorem_list
            
            ADD_EVAL_RULES_TO_CATEGORY( category, i );
            
        end;
        
    end;
    
end );

##
@InstallGlobalFunction( ADD_EVAL_RULES_TO_CATEGORY,
                       
  function( category, rule_record )
    local command;
    
    if !IsBound( rule_record.starting_command )
        
        return;
        
    end;
    
    command = rule_record.starting_command ;
    
    if !IsBound( category.eval_rules )
        
        category.eval_rules = rec( );
        
    end;
    
    if !IsBound( category.eval_rules[command] )
        
        category.eval_rules[command] = [ ];
        
    end;
    
    Add( category.eval_rules[command], rule_record );
    
end );

###############################
##
## Technical functions
##
###############################

@InstallGlobalFunction( INSTALL_LOGICAL_IMPLICATIONS_HELPER,
                       
  function( category, current_filter )
    local i, theorem_list, current_theorem;

    for i in category.logical_implication_files.Propositions[current_filter]
        
        theorem_list = READ_THEOREM_FILE( i );
        
        for current_theorem in theorem_list
            
            ADD_THEOREM_TO_CATEGORY( category, current_theorem );
            
        end;
        
    end;
    
    for i in category.logical_implication_files.Predicates[current_filter]
        
        theorem_list = READ_PREDICATE_IMPLICATION_FILE( i );
        
        for current_theorem in theorem_list
            
            ADD_PREDICATE_IMPLICATIONS_TO_CATEGORY( category, current_theorem );
            
        end;
        
    end;
    
end );
