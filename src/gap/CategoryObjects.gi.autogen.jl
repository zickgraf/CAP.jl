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

# backwards compatibility
@BindGlobal( "IsCapCategoryObjectRep", IsCapCategoryObject );

#######################################
##
## Technical implications
##
#######################################

@InstallValueConst( PROPAGATION_LIST_FOR_EQUAL_OBJECTS,
              [  
                 "IsTerminal",
                 "IsInitial",
                 "IsProjective",
                 "IsInjective",
                 "IsZeroForObjects",
                 # ..
              ] );

###################################
##
## Constructive Object-sets
##
###################################

# This method should not be selected when the two objects belong to the same category and the category can compute IsEqualForObjects.
InstallMethod( @__MODULE__,  IsEqualForObjects,
                    [ IsCapCategory, IsCapCategoryObject, IsCapCategoryObject ],

  function( cat, object_1, object_2 )
    
    if (@not HasCapCategory( object_1 ))
        
        Error( @Concatenation( "the object \"", StringGAP( object_1 ), "\" has no CAP category" ) );
        
    end;
    
    if (@not HasCapCategory( object_2 ))
        
        Error( @Concatenation( "the object \"", StringGAP( object_2 ), "\" has no CAP category" ) );
        
    end;
    
    if (@not IsIdenticalObj( CapCategory( object_1 ), cat ))
        
        Error( @Concatenation( "the object \"", StringGAP( object_1 ), "\" does not belong to the CAP category <cat>" ) );
        
    elseif (@not IsIdenticalObj( CapCategory( object_2 ), cat ))
        
        Error( @Concatenation( "the object \"", StringGAP( object_2 ), "\" does not belong to the CAP category <cat>" ) );
        
    else
        
        # convenience: as long as the objects are identical, everything "just works"
        if (IsIdenticalObj( object_1, object_2 ))
            
            return true;
            
        else
            
            Error( "Cannot decide whether the object \"", StringGAP( object_1 ), "\" and the object \"", StringGAP( object_2 ), "\" are equal. You can fix this error by installing `IsEqualForObjects` in <cat> or possibly avoid it by enabling strict caching." );
            
        end;
        
    end;
    
end );

##
InstallMethod( @__MODULE__,  ==,
               [ IsCapCategoryObject, IsCapCategoryObject ],
  function( object_1, object_2 )

    if (CapCategory( object_1 ).input_sanity_check_level > 0 || CapCategory( object_2 ).input_sanity_check_level > 0 )
        if (@not IsIdenticalObj( CapCategory( object_1 ), CapCategory( object_2 ) ))
            Error( @Concatenation( "the object \"", StringGAP( object_1 ), "\" and the object \"", StringGAP( object_2 ), "\" do not belong to the same CAP category" ) );
        end;
    end;
               
  return IsEqualForObjects( object_1, object_2 );
end );

##
@InstallGlobalFunction( INSTALL_TODO_LIST_FOR_EQUAL_OBJECTS,
                       
  function( object_1, object_2 )
    local category, i, entry;
    
    category = CapCategory( object_1 );
    
    for i in PROPAGATION_LIST_FOR_EQUAL_OBJECTS
        
        AddToToDoList( ToDoListEntryForEqualAttributes( object_1, i, object_2, i ) );
        
    end;
    
    if (@IsBound( category.PROPAGATION_LIST_FOR_EQUAL_OBJECTS ))
        
        for i in category.PROPAGATION_LIST_FOR_EQUAL_OBJECTS
            
            AddToToDoList( ToDoListEntryForEqualAttributes( object_1, i, object_2, i ) );
            
        end;
        
    end;
    
end );

##
InstallMethod( @__MODULE__,  AddPropertyToMatchAtIsEqualForObjects,
               [ IsCapCategory, IsString ],
               
  function( category, name )
    
    if (@not @IsBound( category.PROPAGATION_LIST_FOR_EQUAL_OBJECTS ))
        
        category.PROPAGATION_LIST_FOR_EQUAL_OBJECTS = [ ];
        
    end;
    
    if (Position( category.PROPAGATION_LIST_FOR_EQUAL_OBJECTS, name ) == fail)
        
        Add( category.PROPAGATION_LIST_FOR_EQUAL_OBJECTS, name );
        
    end;
    
end );

#######################################
##
## Operations
##
#######################################

InstallMethod( @__MODULE__,  Add,
               [ IsCapCategory, IsCapCategoryObject ],
               
  function( category, object )
    local filter;
    
    filter = ObjectFilter( category );
    
    if (@not filter( object ))
        
        SetFilterObj( object, filter );
        
    end;
        
    if (HasCapCategory( object ))
        
        if (IsIdenticalObj( CapCategory( object ), category ))
            
            return;
            
        else
            
            Error(
                @Concatenation(
                    "an object that lies in the CAP-category with the name\n",
                    Name( CapCategory( object ) ),
                    "\n",
                    "was tried to be added to a different CAP-category with the name\n",
                    Name( category ), ".\n",
                    "(Please note that it is possible for different CAP-categories to have the same name)"
                )
            );
            
        end;
        
    end;
    
    SetCapCategory( object, category );
    
end );

InstallMethod( @__MODULE__,  AddObject,
               [ IsCapCategory, IsCapCategoryObject ],
               
  function( category, object )
    
    Add( category, object );
    
end );

InstallMethod( @__MODULE__,  AddObject,
               [ IsCapCategory, IsAttributeStoringRep ],
               
  function( category, object )
    
    SetFilterObj( object, IsCapCategoryObject );
    
    Add( category, object );
    
end );

##
InstallMethod( @__MODULE__,  /,
               [ IsObject, IsCapCategory ],
               
  function( object_datum, cat )
    
    if (@not CanCompute( cat, "ObjectConstructor" ))
        
        Error( "You are calling the generic \"/\" method, but <cat> does not have an object constructor. Please add one or install a special version of \"/\"." );
        
    end;
    
    return ObjectConstructor( cat, object_datum );
    
end );

##
InstallMethod( @__MODULE__,  IsWellDefined,
               [ IsCapCategoryObject ],
  IsWellDefinedForObjects
);

##
InstallMethod( @__MODULE__,  IsZero,
               [ IsCapCategoryObject ],
                  
IsZeroForObjects );

##
InstallMethod( @__MODULE__,  IsEqualForCache,
               [ IsCapCategoryObject, IsCapCategoryObject ],
               
  ( obj1, obj2 ) -> IsEqualForCacheForObjects( CapCategory( obj1 ), obj1, obj2 ) );

##
# generic fallback to IsIdenticalObj
InstallMethod( @__MODULE__,  IsEqualForCacheForObjects,
               [ IsCapCategory, IsCapCategoryObject, IsCapCategoryObject ],
               
  ( cat, obj1, obj2 ) -> IsIdenticalObj( obj1, obj2 ) );

##
InstallMethod( @__MODULE__,  AddObjectRepresentation,
               [ IsCapCategory, IsObject ],
               
  function( category, representation )
    
    Print( "WARNING: AddObjectRepresentation is deprecated and will not be supported after 2024.08.21. Please use CreateCapCategory with four arguments instead.\n" );
    
    if (@not IsSpecializationOfFilter( IsCapCategoryObject, representation ))
        
        Error( "the object representation must imply IsCapCategoryObject" );
        
    end;
    
    if (@IsBound( category.initially_known_categorical_properties ))
        
        Error( "calling AddObjectRepresentation after adding functions to the category is not supported" );
        
    end;
    
    InstallTrueMethod( representation, ObjectFilter( category ) );
    
end );

##
InstallMethod( @__MODULE__,  RandomObject, [ IsCapCategory, IsInt ], RandomObjectByInteger );

##
InstallMethod( @__MODULE__,  RandomObject, [ IsCapCategory, IsList ], RandomObjectByList );

##
@InstallGlobalFunction( ObjectifyObjectForCAPWithAttributes,
                       
  function( object, category, additional_arguments_list... )
    local arg_list, obj;
    
    Print( "WARNING: ObjectifyObjectForCAPWithAttributes is deprecated and will not be supported after 2024.08.29. Please use CreateCapCategoryObjectWithAttributes instead.\n" );
    
    arg_list = @Concatenation(
        [ object, category.object_type, CapCategory, category ], additional_arguments_list
    );
    
    obj = CallFuncList( ObjectifyWithAttributes, arg_list );
    
    #= comment for Julia
    # This can be removed once AddObjectRepresentation is removed.
    # work around https://github.com/gap-system/gap/issues/3642:
    # New implications of `ObjectFilter( category )` (e.g. installed via `AddObjectRepresentation`)
    # are not automatically set in `category.object_type`.
    SetFilterObj( obj, ObjectFilter( category ) );
    # =#
    
    return obj;
    
end );

##
@InstallGlobalFunction( CreateCapCategoryObjectWithAttributes,
                       
  function( category, additional_arguments_list... )
    local arg_list, obj;
    
    arg_list = @Concatenation(
        [ @rec( ), category.object_type, CapCategory, category ], additional_arguments_list
    );
    
    obj = CallFuncList( ObjectifyWithAttributes, arg_list );
    
    #= comment for Julia
    # This can be removed once AddObjectRepresentation is removed.
    # work around https://github.com/gap-system/gap/issues/3642:
    # New implications of `ObjectFilter( category )` (e.g. installed via `AddObjectRepresentation`)
    # are not automatically set in `category.object_type`.
    SetFilterObj( obj, ObjectFilter( category ) );
    # =#
    
    return obj;
    
end );

##
@InstallGlobalFunction( AsCapCategoryObject,
                       
  function( category, object_datum )
    local object_datum_type, obj;
    
    object_datum_type = CAP_INTERNAL_GET_DATA_TYPE_FROM_STRING( "object_datum", category );
    
    if (object_datum_type != fail)
        
        CAP_INTERNAL_ASSERT_VALUE_IS_OF_TYPE_GETTER( object_datum_type, [ "the second argument of `AsCapCategoryObject`" ] )( object_datum );
        
    end;
    
    obj = ObjectifyWithAttributes( @rec( ), category.object_type, CapCategory, category, category.object_attribute, object_datum );
    
    if (@not IsIdenticalObj( category.object_attribute( obj ), object_datum ))
        
        Print( "WARNING: <object_datum> is not identical to `", category.object_attribute_name, "( <obj> )`. You might want to make <object_datum> immutable.\n" );
        
    end;
    
    return obj;
    
end );

##
InstallMethod( @__MODULE__,  Simplify,
               [ IsCapCategoryObject ],
  function( object )
    
    return SimplifyObject( object, infinity );
    
end );

###########################
##
## Print
##
###########################

InstallMethod( @__MODULE__,  StringGAP,
               [ IsCapCategoryObject ],
               
  function( object )
    
    return @Concatenation( "An object in ", Name( CapCategory( object ) ) );
    
end );

# fallback methods for Julia
InstallMethod( @__MODULE__,  ViewString,
               [ IsCapCategoryObject ],
               
  function ( object )
    
    # do not reuse `StringGAP` because objects might use `StringGAP` as the attribute storing the object datum
    return @Concatenation( "<An object in ", Name( CapCategory( object ) ), ">" );
    
end );

InstallMethod( @__MODULE__,  DisplayString,
               [ IsCapCategoryObject ],
               
  function ( object )
    
    # do not reuse `StringGAP` because objects might use `StringGAP` as the attribute storing the object datum
    return @Concatenation( "An object in ", Name( CapCategory( object ) ), ".\n" );
    
end );

##
@InstallGlobalFunction( CAP_INTERNAL_CREATE_OBJECT_PRINT,
                       
  function( )
    local print_graph, object_function;
    
    object_function = function( object )
      local string;
        
        string = "object in ";
        
        Append( string, Name( CapCategory( object ) ) );
        
        return string;
        
    end;
    
    print_graph = CreatePrintingGraph( IsCapCategoryObject && HasCapCategory, object_function );
    
    AddRelationToGraph( print_graph,
                        @rec( Source = [ @rec( Conditions = "IsZeroForObjects",
                                              PrintString = "zero",
                                              Adjective = true ) ],
                             Range = [ @rec( Conditions = "IsInjective",
                                             PrintString = "injective",
                                             Adjective = true ),
                                        @rec( Conditions = "IsProjective",
                                             PrintString = "projective",
                                             Adjective = true ) ] ) );
    
    
    InstallPrintFunctionsOutOfPrintingGraph( print_graph, -1 );
    
end );

#= comment for Julia
CAP_INTERNAL_CREATE_OBJECT_PRINT( );
# =#
