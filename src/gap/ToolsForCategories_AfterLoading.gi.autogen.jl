# SPDX-License-Identifier: GPL-2.0-or-later
# CAP: Categories, Algorithms, Programming
#
# Implementations
#

## This file contains installations for ToolsForCategories functions
## that can only be installed after all dependencies have been loaded.

if IsPackageMarkedForLoading( "Browse", ">=0" ) && IsBound( NCurses ) && IsBound( NCurses.BrowseDenseList )

    @InstallGlobalFunction( BrowseCachingStatistic,
      
      function( category )
        local operations, current_cache_name, current_cache, value_matrix, names, cols, current_list;
        
        value_matrix = [ ];
        names = [ ];
        cols = [ [ "status", "hits", "misses", "stored" ] ];
        
        operations = ShallowCopy( RecNames( category.caches ) );
        Sort( operations );
        
        for current_cache_name in operations
            Add( names, [ current_cache_name ] );
            if !IsBound( category.caches[current_cache_name] )
                Add( value_matrix, [ "!installed", "-", "-", "-" ] );
                continue;
            end;
            current_cache = category.caches[current_cache_name];
            if current_cache == "none" || IsDisabledCache( current_cache )
                Add( value_matrix, [ "deactivated", "-", "-", "-" ] );
                continue;
            end;
            current_list = [ ];
            if IsWeakCache( current_cache )
                Add( current_list, "weak" );
            elseif IsCrispCache( current_cache )
                Add( current_list, "crisp" );
            end;
            
            Append( current_list, [ current_cache.hit_counter, current_cache.miss_counter, Length( PositionsProperty( current_cache.value, ReturnTrue ) ) ] );
            Add( value_matrix, current_list );
        end;
        
        NCurses.BrowseDenseList( value_matrix, rec( labelsCol = cols, labelsRow = names ) );
        
    end );

end;

##
@InstallGlobalFunction( CAP_INTERNAL_ASSERT_IS_CELL_OF_CATEGORY,
  
  function( cell, category, human_readable_identifier_getter )
    local generic_help_string;
    
    generic_help_string = " You can access the category cell && category via the local variables 'cell' && 'category' ⥉ a break loop.";
    
    if !IsCapCategoryCell( cell )
        Error( Concatenation( human_readable_identifier_getter(), " does !lie ⥉ the filter IsCapCategoryCell.", generic_help_string ) );
    end;
    
    if !HasCapCategory( cell )
        Error( Concatenation( human_readable_identifier_getter(), " has no CAP category.", generic_help_string ) );
    end;
    
    if category != false && !IsIdenticalObj( CapCategory( cell ), category )
        Error( Concatenation( "The CapCategory of ", human_readable_identifier_getter(), " is !identical to the category named \033[1m", Name( category ), "\033[0m.", generic_help_string ) );
    end;
    
end );

##
@InstallGlobalFunction( CAP_INTERNAL_ASSERT_IS_OBJECT_OF_CATEGORY,
  
  function( object, category, human_readable_identifier_getter )
    local generic_help_string;
    
    generic_help_string = " You can access the object && category via the local variables 'object' && 'category' ⥉ a break loop.";
    
    if !IsCapCategoryObject( object )
        Error( Concatenation( human_readable_identifier_getter(), " does !lie ⥉ the filter IsCapCategoryObject.", generic_help_string ) );
    end;
    
    if !HasCapCategory( object )
        Error( Concatenation( human_readable_identifier_getter(), " has no CAP category.", generic_help_string ) );
    end;
    
    if category != false && !IsIdenticalObj( CapCategory( object ), category )
        Error( Concatenation( "The CapCategory of ", human_readable_identifier_getter(), " is !identical to the category named \033[1m", Name( category ), "\033[0m.", generic_help_string ) );
    end;
    
    if category != false && !ObjectFilter( category )( object )
        Error( Concatenation( human_readable_identifier_getter(), " does !lie ⥉ the object filter of the category named \033[1m", Name( category ), "\033[0m.", generic_help_string ) );
    end;
    
end );

##
@InstallGlobalFunction( CAP_INTERNAL_ASSERT_IS_MORPHISM_OF_CATEGORY,
  
  function( morphism, category, human_readable_identifier_getter )
    local generic_help_string;
    
    generic_help_string = " You can access the morphism && category via the local variables 'morphism' && 'category' ⥉ a break loop.";
    
    if !IsCapCategoryMorphism( morphism )
        Error( Concatenation( human_readable_identifier_getter(), " does !lie ⥉ the filter IsCapCategoryMorphism.", generic_help_string ) );
    end;
    
    if !HasCapCategory( morphism )
        Error( Concatenation( human_readable_identifier_getter(), " has no CAP category.", generic_help_string ) );
    end;
    
    if category != false && !IsIdenticalObj( CapCategory( morphism ), category )
        Error( Concatenation( "the CAP-category of ", human_readable_identifier_getter(), " is !identical to the category named \033[1m", Name( category ), "\033[0m.", generic_help_string ) );
    end;
    
    if category != false && !MorphismFilter( category )( morphism )
        Error( Concatenation( human_readable_identifier_getter(), " does !lie ⥉ the morphism filter of the category named \033[1m", Name( category ), "\033[0m.", generic_help_string ) );
    end;
    
    if !HasSource( morphism )
        Error( Concatenation( human_readable_identifier_getter(), " has no source.", generic_help_string ) );
    end;
    
    CAP_INTERNAL_ASSERT_IS_OBJECT_OF_CATEGORY( Source( morphism ), category, function( ) return Concatenation( "the source of ", human_readable_identifier_getter() ); end );
    
    if !HasRange( morphism )
        Error( Concatenation( human_readable_identifier_getter(), " has no range.", generic_help_string ) );
    end;
    
    CAP_INTERNAL_ASSERT_IS_OBJECT_OF_CATEGORY( Range( morphism ), category, function( ) return Concatenation( "the range of ", human_readable_identifier_getter() ); end );
    
end );

##
@InstallGlobalFunction( CAP_INTERNAL_ASSERT_IS_TWO_CELL_OF_CATEGORY,
  
  function( two_cell, category, human_readable_identifier_getter )
    local generic_help_string;
    
    generic_help_string = " You can access the 2-cell && category via the local variables 'two_cell' && 'category' ⥉ a break loop.";
    
    if !IsCapCategoryTwoCell( two_cell )
        Error( Concatenation( human_readable_identifier_getter(), " does !lie ⥉ the filter IsCapCategoryTwoCell.", generic_help_string ) );
    end;
    
    if !HasCapCategory( two_cell )
        Error( Concatenation( human_readable_identifier_getter(), " has no CAP category.", generic_help_string ) );
    end;
    
    if category != false && !IsIdenticalObj( CapCategory( two_cell ), category )
        Error( Concatenation( "the CapCategory of ", human_readable_identifier_getter(), " is !identical to the category named \033[1m", Name( category ), "\033[0m.", generic_help_string ) );
    end;
    
    if category != false && !TwoCellFilter( category )( two_cell )
        Error( Concatenation( human_readable_identifier_getter(), " does !lie ⥉ the 2-cell filter of the category named \033[1m", Name( category ), "\033[0m.", generic_help_string ) );
    end;
    
    if !HasSource( two_cell )
        Error( Concatenation( human_readable_identifier_getter(), " has no source.", generic_help_string ) );
    end;
    
    CAP_INTERNAL_ASSERT_IS_MORPHISM_OF_CATEGORY( Source( two_cell ), category, function( ) return Concatenation( "the source of ", human_readable_identifier_getter() ); end );
    
    if !HasRange( two_cell )
        Error( Concatenation( human_readable_identifier_getter(), " has no range.", generic_help_string ) );
    end;
    
    CAP_INTERNAL_ASSERT_IS_MORPHISM_OF_CATEGORY( Range( two_cell ), category, function( ) return Concatenation( "the range of ", human_readable_identifier_getter() ); end );
    
end );

##
@InstallGlobalFunction( CAP_INTERNAL_ASSERT_IS_LIST_OF_OBJECTS_OF_CATEGORY,
  
  function( list_of_objects, category, human_readable_identifier_getter )
    local generic_help_string, list_entry_human_readable_identifier_getter, i;
    
    generic_help_string = " You can access the list && category via the local variables 'list_of_objects' && 'category' ⥉ a break loop.";
    
    list_entry_human_readable_identifier_getter = function( i )
        
        return Concatenation( "the ", string(i), "-th entry of ", human_readable_identifier_getter() );
        
    end;
    
    if !IsList( list_of_objects )
        Error( Concatenation( human_readable_identifier_getter(), " does !lie ⥉ the filter IsList.", generic_help_string ) );
    end;
    
    for i in (1):(Length( list_of_objects ))
        
        if !IsBound( list_of_objects[i] )
            Error( Concatenation( list_entry_human_readable_identifier_getter( i ), " is !bound.", generic_help_string ) );
        end;
        
        CAP_INTERNAL_ASSERT_IS_OBJECT_OF_CATEGORY( list_of_objects[i], category, function( ) return list_entry_human_readable_identifier_getter( i ); end );
        
    end;
    
end );

##
@InstallGlobalFunction( CAP_INTERNAL_ASSERT_IS_LIST_OF_MORPHISMS_OF_CATEGORY,
  
  function( list_of_morphisms, category, human_readable_identifier_getter )
    local generic_help_string, list_entry_human_readable_identifier_getter, i;
    
    generic_help_string = " You can access the list && category via the local variables 'list_of_morphisms' && 'category' ⥉ a break loop.";
    
    list_entry_human_readable_identifier_getter = function( i )
        
        return Concatenation( "the ", string(i), "-th entry of ", human_readable_identifier_getter() );
        
    end;
    
    if !IsList( list_of_morphisms )
        Error( Concatenation( human_readable_identifier_getter(), " does !lie ⥉ the filter IsList.", generic_help_string ) );
    end;
    
    for i in (1):(Length( list_of_morphisms ))
        
        if !IsBound( list_of_morphisms[i] )
            Error( Concatenation( list_entry_human_readable_identifier_getter( i ), " is !bound.", generic_help_string ) );
        end;
        
        CAP_INTERNAL_ASSERT_IS_MORPHISM_OF_CATEGORY( list_of_morphisms[i], category, function( ) return list_entry_human_readable_identifier_getter( i ); end );
        
    end;
    
end );

##
@InstallGlobalFunction( CAP_INTERNAL_ASSERT_IS_LIST_OF_TWO_CELLS_OF_CATEGORY,
  
  function( list_of_twocells, category, human_readable_identifier_getter )
    local generic_help_string, list_entry_human_readable_identifier_getter, i;
    
    generic_help_string = " You can access the list && category via the local variables 'list_of_twocells' && 'category' ⥉ a break loop.";
    
    list_entry_human_readable_identifier_getter = function( i )
        
        return Concatenation( "the ", string(i), "-th entry of ", human_readable_identifier_getter() );
        
    end;
    
    if !IsList( list_of_twocells )
        Error( Concatenation( human_readable_identifier_getter(), " does !lie ⥉ the filter IsList.", generic_help_string ) );
    end;
    
    for i in (1):(Length( list_of_twocells ))
        
        if !IsBound( list_of_twocells[i] )
            Error( Concatenation( list_entry_human_readable_identifier_getter( i ), " is !bound.", generic_help_string ) );
        end;
        
        CAP_INTERNAL_ASSERT_IS_TWO_CELL_OF_CATEGORY( list_of_twocells[i], category, function( ) return list_entry_human_readable_identifier_getter( i ); end );
        
    end;
    
end );

##
@InstallGlobalFunction( CAP_INTERNAL_ASSERT_IS_NON_NEGATIVE_INTEGER_OR_INFINITY,
  
  function( nnintorinf, human_readable_identifier_getter )
    local generic_help_string;
    
    generic_help_string = " You can access the object && category via the local variable 'nnintorinf' ⥉ a break loop.";
    
    if !( IsInfinity( nnintorinf ) || ( IsInt( nnintorinf ) && nnintorinf >= 0 ) )
        Error( Concatenation( human_readable_identifier_getter(), " is !a nonnegative integer || Inf.", generic_help_string ) );
    end;
    
end );

##
@InstallGlobalFunction( PackageOfCAPOperation, function ( operation_name )
  local packages;
    
    if !IsBound( CAP_INTERNAL_METHOD_NAME_RECORD[operation_name] )
        
        # COVERAGE_IGNORE_NEXT_LINE
        Error( operation_name, " is !a CAP operation" );
        
    end;
    
    packages = Filtered( RecNames( CAP_INTERNAL_METHOD_NAME_RECORDS_BY_PACKAGE ), package -> IsBound( CAP_INTERNAL_METHOD_NAME_RECORDS_BY_PACKAGE[package][operation_name] ) );
    
    if Length( packages ) == 0
        
        return fail;
        
    elseif Length( packages ) > 1
        
        # COVERAGE_IGNORE_NEXT_LINE
        Error( "Found multiple packages for CAP operation ", operation_name );
        
    end;
    
    return packages[1];
    
end );
