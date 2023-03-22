# SPDX-License-Identifier: GPL-2.0-or-later
# CAP: Categories, Algorithms, Programming
#
# Implementations
#
#! @Chapter Opposite category

###################################
##
#! @Section Functor is an involution
##
###################################


##################################
##
## Construtor
##
##################################

##
InstallMethod( @__MODULE__,  Opposite,
               [ IsCapCategoryObject ],
               
  function( object )
    
    return ObjectConstructor( Opposite( CapCategory( object ) ), object );
    
end );

##
InstallMethod( @__MODULE__,  Opposite,
               [ IsCapCategoryMorphism ],
               
  function( morphism )
    
    return MorphismConstructor( Opposite( CapCategory( morphism ) ), Opposite( Range( morphism ) ), morphism, Opposite( Source( morphism ) ) );
    
end );

@InstallGlobalFunction( CAP_INTERNAL_OPPOSITE_RECURSIVE,
  
  function( obj )
    
    if IsCapCategory( obj )
        return OppositeCategory( obj );
    elseif IsCapCategoryObject( obj )
        return ObjectDatum( CapCategory( obj ), obj );
    elseif IsCapCategoryMorphism( obj )
        return MorphismDatum( CapCategory( obj ), obj );
    elseif IsList( obj )
        return List( obj, CAP_INTERNAL_OPPOSITE_RECURSIVE );
    else
        return obj;
    end;
    
end );

@BindGlobal( "CAP_INTERNAL_INSTALL_OPPOSITE_ADDS_FROM_CATEGORY",
  
  function( opposite_category, category )
    local only_primitive_operations, recnames, list_of_underlying_operations,
          operations_of_homomorphism_structure, operations_of_external_hom,
          current_recname, current_entry, dual_operation_name, filter_list, input_arguments_names, return_type, func_string,
          dual_preprocessor_func_string, preprocessor_string, dual_arguments, tmp,
          dual_postprocessor_func_string, postprocessor_string, output_source_getter_string, output_range_getter_string, return_statement,
          func, weight, current_add, list_of_attributes, attr, tester, setter, getter;
    
    only_primitive_operations = ValueOption( "only_primitive_operations" ) == true;
    
    ## Take care of attributes
    ## TODO: if there are more instances, set markers ⥉ the MethodRecord
    list_of_attributes = [ "CommutativeRingOfLinearCategory" ];
    
    for attr in list_of_attributes
        
        tester = ValueGlobal( Concatenation( "Has", attr ) );
        
        if !tester( opposite_category ) && tester( category )
            
            setter = ValueGlobal( Concatenation( "Set", attr ) );
            
            getter = ValueGlobal( attr );
            
            setter( opposite_category, getter( category ) );
            
        end;
        
    end;
    
    recnames = AsSortedList( RecNames( CAP_INTERNAL_METHOD_NAME_RECORD ) );
    
    ## No support for twocells
    recnames = Difference( recnames,
                        [ "HorizontalPreCompose",
                          "HorizontalPostCompose",
                          "VerticalPreCompose",
                          "VerticalPostCompose",
                          "IdenticalTwoCell" ] );
    
    if only_primitive_operations
        list_of_underlying_operations = ListPrimitivelyInstalledOperationsOfCategory( category );
    else
        list_of_underlying_operations = ListInstalledOperationsOfCategory( category );
    end;
    
    operations_of_homomorphism_structure =
      [ "DistinguishedObjectOfHomomorphismStructure",
        "HomomorphismStructureOnObjects",
        "HomomorphismStructureOnMorphisms",
        "HomomorphismStructureOnMorphismsWithGivenObjects",
        "InterpretMorphismAsMorphismFromDistinguishedObjectToHomomorphismStructure",
        "InterpretMorphismAsMorphismFromDistinguishedObjectToHomomorphismStructureWithGivenObjects",
        "InterpretMorphismFromDistinguishedObjectToHomomorphismStructureAsMorphism",
        ];
    
    if !IsEmpty( Intersection( list_of_underlying_operations, operations_of_homomorphism_structure ) )
        
        if !HasRangeCategoryOfHomomorphismStructure( category )
            
            Error( "<category> has operations related to the homomorphism structure but no range category is set. This is !supported." );
            
        end;
        
        SetRangeCategoryOfHomomorphismStructure( opposite_category, RangeCategoryOfHomomorphismStructure( category ) );
        SetIsEquippedWithHomomorphismStructure( opposite_category, true );
        
    end;
    
    for current_recname in recnames
        
        current_entry = CAP_INTERNAL_METHOD_NAME_RECORD[current_recname];
        
        ## Conservative
        if !IsBound( current_entry.dual_operation )
            continue;
        end;
        
        dual_operation_name = current_entry.dual_operation;
        
        if !dual_operation_name ⥉ list_of_underlying_operations
            continue;
        end;
        
        filter_list = current_entry.filter_list;
        input_arguments_names = current_entry.input_arguments_names;
        return_type = current_entry.return_type;
        
        func_string =
            """
            function ( input_arguments... )
              local dual_preprocessor_func, prep_arg, result, dual_postprocessor_func;
                
                preprocessor_string
                
                result = dual_operation_name( dual_arguments... );
                
                postprocessor_string
                
                return_statement;
                
            end
            """;
        
        if IsBound( current_entry.dual_preprocessor_func )
            
            if IsOperation( current_entry.dual_preprocessor_func ) || IsKernelFunction( current_entry.dual_preprocessor_func )
                
                dual_preprocessor_func_string = NameFunction( current_entry.dual_preprocessor_func );
                
            else
                
                dual_preprocessor_func_string = StringGAP( current_entry.dual_preprocessor_func );
                
            end;
            
            preprocessor_string = ReplacedStringViaRecord(
                """
                dual_preprocessor_func = dual_preprocessor_func_string;
                prep_arg = dual_preprocessor_func( input_arguments... );
                #% CAP_JIT_DROP_NEXT_STATEMENT
                Assert( 0, IsIdenticalObj( prep_arg[1], OppositeCategory( cat ) ) );
                """,
                rec(
                    dual_preprocessor_func_string = dual_preprocessor_func_string,
                    input_arguments = input_arguments_names,
                )
            );
            
            Assert( 0, filter_list[1] == "category" );
            
            dual_arguments = List( (2):(Length( filter_list )), i -> Concatenation( "prep_arg[", StringGAP( i ), "]" ) );
            
        else
            
            preprocessor_string = "";
            
            Assert( 0, filter_list[1] == "category" );
            
            dual_arguments = List( (2):(Length( filter_list )), function( i )
              local filter, argument_name;
                
                filter = filter_list[i];
                argument_name = input_arguments_names[i];
                
                if filter == "object"
                    
                    return Concatenation( "ObjectDatum( cat, ", argument_name, " )" );
                    
                elseif filter == "morphism"
                    
                    return Concatenation( "MorphismDatum( cat, ", argument_name, " )" );
                    
                elseif filter == "integer" || filter == IsRingElement
                    
                    return argument_name;
                    
                elseif filter == "list_of_objects"
                    
                    return Concatenation( "List( ", argument_name, ", x -> ObjectDatum( cat, x ) )" );
                    
                elseif filter == "list_of_morphisms"
                    
                    return Concatenation( "List( ", argument_name, ", x -> MorphismDatum( cat, x ) )" );
                    
                elseif filter == "nonneg_integer_or_Inf"
                    
                    return argument_name;
                    
                else
                    
                    Error( "this case is !handled yet" );
                    
                end;
                
            end );
            
            if current_entry.dual_arguments_reversed
                
                dual_arguments = Reversed( dual_arguments );
                
            end;
            
            if current_entry.is_with_given && IsBound( current_entry.dual_with_given_objects_reversed ) && current_entry.dual_with_given_objects_reversed
                
                tmp = dual_arguments[1];
                dual_arguments[1] = dual_arguments[Length( dual_arguments)];
                dual_arguments[Length( dual_arguments)] = tmp;
                
            end;
            
        end;
        
        dual_arguments = Concatenation( [ "OppositeCategory( cat )" ], dual_arguments );
        
        if IsBound( current_entry.dual_postprocessor_func )
            
            if IsOperation( current_entry.dual_postprocessor_func ) || IsKernelFunction( current_entry.dual_postprocessor_func )
                
                dual_postprocessor_func_string = NameFunction( current_entry.dual_postprocessor_func );
                
            else
                
                dual_postprocessor_func_string = StringGAP( current_entry.dual_postprocessor_func );
                
            end;
            
            postprocessor_string = Concatenation( "dual_postprocessor_func = ", dual_postprocessor_func_string, ";" );
            
            return_statement = "return dual_postprocessor_func( result )";
            
        else
            
            postprocessor_string = "";
            
            if return_type == "object"
                
                return_statement = "return ObjectConstructor( cat, result )";
                
            elseif return_type == "morphism"
                
                return_statement = "return MorphismConstructor( cat, output_source_getter, result, output_range_getter )";
                
                if IsBound( current_entry.output_source_getter_string ) && IsBound( current_entry.can_always_compute_output_source_getter ) && current_entry.can_always_compute_output_source_getter
                    
                    output_source_getter_string = current_entry.output_source_getter_string;
                    
                else
                    
                    output_source_getter_string = "ObjectConstructor( cat, Range( result ) )";
                    
                end;
                
                if IsBound( current_entry.output_range_getter_string ) && IsBound( current_entry.can_always_compute_output_range_getter ) && current_entry.can_always_compute_output_range_getter
                    
                    output_range_getter_string = current_entry.output_range_getter_string;
                    
                else
                    
                    output_range_getter_string = "ObjectConstructor( cat, Source( result ) )";
                    
                end;
                
                return_statement = ReplacedStringViaRecord( return_statement, rec(
                    output_source_getter = output_source_getter_string,
                    output_range_getter = output_range_getter_string,
                ) );
                
            elseif return_type == "object_or_fail"
                
                return_statement = "if result == fail then return fail; else return ObjectConstructor( cat, result ); fi";
                
            elseif return_type == "morphism_or_fail"
                
                return_statement = "if result == fail then return fail; else return MorphismConstructor( cat, ObjectConstructor( cat, Range( result ) ), result, ObjectConstructor( cat, Source( result ) ) ); fi";
                
            elseif return_type == "list_of_morphisms"
                
                return_statement = "return List( result, mor -> MorphismConstructor( cat, ObjectConstructor( cat, Range( mor ) ), mor, ObjectConstructor( cat, Source( mor ) ) ) )";
                
            elseif return_type == "list_of_objects"
                
                return_statement = "return List( result, obj -> ObjectConstructor( cat, obj ) )";
                
            elseif return_type == "bool"
                
                return_statement = "return result";
                
            elseif return_type == "nonneg_integer_or_Inf"
                
                return_statement = "return result";

            else
                
                Error( "this case is !handled yet" );
                
            end;
            
        end;
        
        func_string = ReplacedStringViaRecord( func_string, rec(
            input_arguments = input_arguments_names,
            preprocessor_string = preprocessor_string,
            dual_arguments = dual_arguments,
            dual_operation_name = dual_operation_name,
            postprocessor_string = postprocessor_string,
            return_statement = return_statement
        ) );
        
        func = EvalString( func_string );
        
        weight = CurrentOperationWeight( category.derivations_weight_list, dual_operation_name );
        
        Assert( 0, weight < Inf );
        
        current_add = ValueGlobal( Concatenation( "Add", current_recname ) );
        
        current_add( opposite_category, func, weight );
        
    end;
    
end );


##
InstallMethod( @__MODULE__,  Opposite,
               [ IsCapCategory, IsString ],
               
  function( category, name )
    local opposite_category, known_properties, opposite_property_pairs, pair;
    
    if !IsFinalized( category )
        Error( "Input category must be finalized to create opposite category" );
    end;
    
    opposite_category = CreateCapCategory( name, WasCreatedAsOppositeCategory, IsCapCategoryOppositeObject, IsCapCategoryOppositeMorphism, IsCapCategoryTwoCell );
    
    opposite_category.category_as_first_argument = true;
    
    if IsBound( category.supports_empty_limits )
        
        opposite_category.supports_empty_limits = category.supports_empty_limits;
        
    end;
    
    opposite_category.compiler_hints = rec(
        category_attribute_names = [
            "OppositeCategory",
        ],
    );
    
    SetOppositeCategory( opposite_category, category );
    
    SetOpposite( opposite_category, category );
    SetOpposite( category, opposite_category );
    
    known_properties = ListKnownCategoricalProperties( category );
    
    opposite_property_pairs = Filtered( CAP_INTERNAL_CATEGORICAL_PROPERTIES_LIST, x -> x[2] != fail );
    
    for pair in opposite_property_pairs
        
        # plausibility check
        if !Reversed( pair ) ⥉ opposite_property_pairs
            
            Error( "The pair of categorical properties <pair> was registered using `AddCategoricalProperty`, but the reversed pair was not." );
            
        end;
        
        if pair[1] ⥉ known_properties
            
            Setter( ValueGlobal( pair[2] ) )( opposite_category, true );
            
        end;
        
    end;
    
    AddObjectConstructor( opposite_category, function( cat, object )
      local opposite_object;
        
        #% CAP_JIT_DROP_NEXT_STATEMENT
        CAP_INTERNAL_ASSERT_IS_OBJECT_OF_CATEGORY( object, OppositeCategory( cat ), [ "the object datum given to the object constructor of <cat>" ] );
        
        #% CAP_JIT_DROP_NEXT_STATEMENT
        if HasOpposite( object )
            
            return Opposite( object );
            
        end;
        
        opposite_object = ObjectifyObjectForCAPWithAttributes( rec( ), cat,
                                                                Opposite, object );
        
        #% CAP_JIT_DROP_NEXT_STATEMENT
        if CapCategory( object ).predicate_logic
            
            #= comment for Julia
            INSTALL_TODO_LIST_ENTRIES_FOR_OPPOSITE_OBJECT( object );
            # =#
            
        end;
        
        #% CAP_JIT_DROP_NEXT_STATEMENT
        SetOpposite( object, opposite_object );
        
        return opposite_object;
        
    end );
    
    AddObjectDatum( opposite_category, function( cat, opposite_object )
        
        return Opposite( opposite_object );
        
    end );
    
    AddMorphismConstructor( opposite_category, function( cat, source, morphism, range )
      local opposite_morphism;
        
        #% CAP_JIT_DROP_NEXT_STATEMENT
        CAP_INTERNAL_ASSERT_IS_MORPHISM_OF_CATEGORY( morphism, OppositeCategory( cat ), [ "the morphism datum given to the morphism constructor of <cat>" ] );
        
        if IsEqualForObjects( OppositeCategory( cat ), Source( morphism ), Opposite( range ) ) == false
            
            Error( "the source of the morphism datum must be equal to <Opposite( range )>" );
            
        end;
        
        if IsEqualForObjects( OppositeCategory( cat ), Range( morphism ), Opposite( source ) ) == false
            
            Error( "the range of the morphism datum must be equal to <Opposite( source )>" );
            
        end;
        
        #% CAP_JIT_DROP_NEXT_STATEMENT
        if HasOpposite( morphism )
            
            return Opposite( morphism );
            
        end;
        
        opposite_morphism = ObjectifyMorphismWithSourceAndRangeForCAPWithAttributes( rec( ), cat,
                                                                                      source, range,
                                                                                      Opposite, morphism );
        
        #% CAP_JIT_DROP_NEXT_STATEMENT
        if CapCategory( morphism ).predicate_logic
            
            #= comment for Julia
            INSTALL_TODO_LIST_ENTRIES_FOR_OPPOSITE_MORPHISM( morphism );
            # =#
            
        end;
        
        #% CAP_JIT_DROP_NEXT_STATEMENT
        SetOpposite( morphism, opposite_morphism );
        
        return opposite_morphism;
        
    end );
    
    AddMorphismDatum( opposite_category, function( cat, opposite_morphism )
        
        return Opposite( opposite_morphism );
        
    end );
    
    CAP_INTERNAL_INSTALL_OPPOSITE_ADDS_FROM_CATEGORY( opposite_category, category );
    
    Finalize( opposite_category );
    
    if category.predicate_logic
        
        #= comment for Julia
        INSTALL_TODO_LIST_ENTRIES_FOR_OPPOSITE_CATEGORY( category );
        # =#
        
    end;
    
    return opposite_category;
    
end );

##
InstallMethod( @__MODULE__,  Opposite,
               [ IsCapCategory ],
               
  function( category )
    local opposite_category;
    
    opposite_category = Concatenation( "Opposite( ", Name( category ), " )" );
    
    return Opposite( category, opposite_category );
    
end );

##################################
##
## Methods
##
##################################

@InstallGlobalFunction( INSTALL_TODO_LIST_ENTRIES_FOR_OPPOSITE_CATEGORY,
                       
  function( category )
    local opposite_property_pairs, entry, pair;
    
    opposite_property_pairs = Filtered( CAP_INTERNAL_CATEGORICAL_PROPERTIES_LIST, x -> x[2] != fail );
    
    # prepare special format for ToDoListEntryToMaintainFollowingAttributes
    opposite_property_pairs = List( opposite_property_pairs, x -> [ "", x ] );
    
    entry = ToDoListEntryToMaintainFollowingAttributes( [ [ category, "Opposite" ] ],
                                                         [ category, [ Opposite, category ] ],
                                                         opposite_property_pairs );
    
    AddToToDoList( entry );
    
    entry = ToDoListEntryToMaintainFollowingAttributes( [ [ category, "Opposite" ] ],
                                                         [ [ Opposite, category ], category ],
                                                         opposite_property_pairs );
    
    AddToToDoList( entry );
    
end );

@InstallGlobalFunction( INSTALL_TODO_LIST_ENTRIES_FOR_OPPOSITE_MORPHISM,
                       
  function( morphism )
    local entry;
    
    entry = ToDoListEntryToMaintainFollowingAttributes( [ [ morphism, "Opposite" ] ],
                                                         [ morphism, [ Opposite, morphism ] ],
                                                         CAP_INTERNAL_OPPOSITE_PROPERTY_PAIRS_FOR_MORPHISMS );
    
    AddToToDoList( entry );
    
    entry = ToDoListEntryToMaintainFollowingAttributes( [ [ morphism, "Opposite" ] ],
                                                         [ [ Opposite, morphism ], morphism ],
                                                         CAP_INTERNAL_OPPOSITE_PROPERTY_PAIRS_FOR_MORPHISMS );
    
    AddToToDoList( entry );
    
end );

@InstallGlobalFunction( INSTALL_TODO_LIST_ENTRIES_FOR_OPPOSITE_OBJECT,
                       
  function( object )
    local entry_list, entry;
    
    entry = ToDoListEntryToMaintainFollowingAttributes( [ [ object, "Opposite" ] ],
                                                         [ object, [ Opposite, object ] ],
                                                         CAP_INTERNAL_OPPOSITE_PROPERTY_PAIRS_FOR_OBJECTS );

    AddToToDoList( entry );
    
    entry = ToDoListEntryToMaintainFollowingAttributes( [ [ object, "Opposite" ] ],
                                                         [ [ Opposite, object ], object ],
                                                         CAP_INTERNAL_OPPOSITE_PROPERTY_PAIRS_FOR_OBJECTS );
    
    AddToToDoList( entry );
    
end );

##
InstallMethod( @__MODULE__,  DisplayString,
        [ IsCapCategoryOppositeObject ],
        
  function( object )
    
    return Concatenation( DisplayString( Opposite( object ) ), "\nAn object ⥉ ", Name( CapCategory( object ) ), " given by the above data\n" );
    
end );

##
InstallMethod( @__MODULE__,  DisplayString,
        [ IsCapCategoryOppositeMorphism ],
        
  function( morphism )
    
    return Concatenation( DisplayString( Opposite( morphism ) ), "\nA morphism ⥉ ", Name( CapCategory( morphism ) ), " given by the above data\n" );
    
end );
