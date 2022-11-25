# SPDX-License-Identifier: GPL-2.0-or-later
# CAP: Categories, Algorithms, Programming
#
# Implementations
#
@InstallGlobalFunction( InfoStringOfInstalledOperationsOfCategory,
  
  function( category )
    local list_of_mathematical_properties, list_of_potential_algorithmic_properties,
          list_of_algorithmic_properties, list_of_maximal_algorithmic_properties, property, result;
    
    if !IsCapCategory( category )
        Error( "first argument must be a category" );
        return;
    end;
    
    list_of_mathematical_properties = ListKnownCategoricalProperties( category );

    list_of_potential_algorithmic_properties = RecNames( CAP_INTERNAL_CONSTRUCTIVE_CATEGORIES_RECORD );
    
    list_of_algorithmic_properties = Intersection( list_of_mathematical_properties, list_of_potential_algorithmic_properties );
    
    list_of_algorithmic_properties = Filtered( list_of_algorithmic_properties, p -> IsEmpty( CheckConstructivenessOfCategory( category, p ) ) );
    
    list_of_maximal_algorithmic_properties = MaximalObjects( list_of_algorithmic_properties, ( p1, p2 ) ->
                                               IsSubset( CAP_INTERNAL_CONSTRUCTIVE_CATEGORIES_RECORD[p2], CAP_INTERNAL_CONSTRUCTIVE_CATEGORIES_RECORD[p1] ) ||
                                               p1 ⥉ ListImpliedFilters( ValueGlobal( p2 ) ) );
    
    StableSortBy( list_of_maximal_algorithmic_properties, p -> Length( CAP_INTERNAL_CONSTRUCTIVE_CATEGORIES_RECORD[p] ) );
    
    result = string( Length( ListPrimitivelyInstalledOperationsOfCategory( category ) ) );
    result = Concatenation( result, " primitive operations were used to derive " );
    result = Concatenation( result, string( Length( ListInstalledOperationsOfCategory( category ) ) ) );
    result = Concatenation( result, " operations for this category" );
    if !IsEmpty( list_of_maximal_algorithmic_properties )
        result = Concatenation( result, " which algorithmically" );
    end;
    for property in list_of_maximal_algorithmic_properties
        result = Concatenation( result, "\n* " );
        result = Concatenation( result, property );
    end;
    
    list_of_mathematical_properties = Difference( list_of_mathematical_properties, list_of_algorithmic_properties );
    
    list_of_mathematical_properties = MaximalObjects( list_of_mathematical_properties, ( p1, p2 ) -> p1 ⥉ ListImpliedFilters( ValueGlobal( p2 ) ) );
    
    if !IsEmpty( list_of_mathematical_properties )
        if !IsEmpty( list_of_algorithmic_properties )
            result = Concatenation( result, "\nand furthermore" );
        else
            result = Concatenation( result, " which" );
        end;
        result = Concatenation( result, " mathematically" );
    end;
    for property in list_of_mathematical_properties
        result = Concatenation( result, "\n* " );
        result = Concatenation( result, property );
        if property ⥉ Difference( list_of_potential_algorithmic_properties, list_of_algorithmic_properties )
            result = Concatenation( result, " (but !yet algorithmically)" );
        end;
    end;
    
    return result;
    
end );

@InstallGlobalFunction( InfoOfInstalledOperationsOfCategory,
  
  function( category )

    Display( InfoStringOfInstalledOperationsOfCategory( category ) );
    
end );
