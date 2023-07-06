# SPDX-License-Identifier: GPL-2.0-or-later
# CAP: Categories, Algorithms, Programming
#
# Implementations
#
@InstallGlobalFunction( InfoStringOfInstalledOperationsOfCategory,
  
  function( category )
    local MaximalPropertiesWithRegardToImplication, list_of_mathematical_properties, list_of_potential_algorithmic_properties,
          list_of_algorithmic_properties, list_of_maximal_algorithmic_properties, property, result,
          list_of_non_algorithmic_mathematical_properties, list_of_maximal_non_algorithmic_mathematical_properties;
    
    if (@not IsCapCategory( category ))
        Error( "first argument must be a category" );
        return;
    end;
    
    MaximalPropertiesWithRegardToImplication = function ( list_of_properties )
        
        return MaximalObjects( list_of_properties, ( p1, p2 ) -> p1 in ListImpliedFilters( ValueGlobal( p2 ) ) );
        
    end;
    
    list_of_mathematical_properties = ListKnownCategoricalProperties( category );
    
    list_of_potential_algorithmic_properties = RecNames( CAP_INTERNAL_CONSTRUCTIVE_CATEGORIES_RECORD );
    
    list_of_algorithmic_properties = Filtered( list_of_mathematical_properties, p -> p in list_of_potential_algorithmic_properties && IsEmpty( CheckConstructivenessOfCategory( category, p ) ) );
    
    list_of_maximal_algorithmic_properties = MaximalPropertiesWithRegardToImplication( list_of_algorithmic_properties );
    
    StableSortBy( list_of_maximal_algorithmic_properties, p -> Length( CAP_INTERNAL_CONSTRUCTIVE_CATEGORIES_RECORD[p] ) );
    
    result = StringGAP( Length( ListPrimitivelyInstalledOperationsOfCategory( category ) ) );
    result = @Concatenation( result, " primitive operations were used to derive " );
    result = @Concatenation( result, StringGAP( Length( ListInstalledOperationsOfCategory( category ) ) ) );
    result = @Concatenation( result, " operations for this category" );
    if (@not IsEmpty( list_of_maximal_algorithmic_properties ))
        result = @Concatenation( result, " which algorithmically" );
        for property in list_of_maximal_algorithmic_properties
            result = @Concatenation( result, "\n* " );
            result = @Concatenation( result, property );
        end;
    end;
    
    list_of_non_algorithmic_mathematical_properties = Difference( list_of_mathematical_properties, list_of_algorithmic_properties );
    
    list_of_maximal_non_algorithmic_mathematical_properties = MaximalPropertiesWithRegardToImplication( list_of_non_algorithmic_mathematical_properties );
    
    if (@not IsEmpty( list_of_maximal_non_algorithmic_mathematical_properties ))
        if (@not IsEmpty( list_of_maximal_algorithmic_properties ))
            result = @Concatenation( result, "\nand furthermore" );
        else
            result = @Concatenation( result, " which" );
        end;
        result = @Concatenation( result, " mathematically" );
        for property in list_of_maximal_non_algorithmic_mathematical_properties
            result = @Concatenation( result, "\n* " );
            result = @Concatenation( result, property );
            if (property in list_of_potential_algorithmic_properties)
                result = @Concatenation( result, " (but not yet algorithmically)" );
            end;
        end;
    end;
    
    return result;
    
end );

@InstallGlobalFunction( InfoOfInstalledOperationsOfCategory,
  
  function( category )

    Display( InfoStringOfInstalledOperationsOfCategory( category ) );
    
end );
