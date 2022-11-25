# SPDX-License-Identifier: GPL-2.0-or-later
# CAP: Categories, Algorithms, Programming
#
# Implementations
#
# backwards compatibility
@BindGlobal( "IsCapCategoryTwoCellRep", IsCapCategoryTwoCell );

####################################
##
## Add function
##
####################################

##
InstallMethod( @__MODULE__,  Add,
               [ IsCapCategory, IsCapCategoryTwoCell ],
               
  function( category, twocell )
    local obj_filter, filter;
    
    if HasCapCategory( twocell )
        
        if IsIdenticalObj( CapCategory( twocell ), category )
            
            return;
            
        else
            
            Error( "this 2-cell already has a category" );
            
        end;
        
    end;
    
    AddMorphism( category, Source( twocell ) );
    
    AddMorphism( category, Range( twocell ) );
    
    filter = TwoCellFilter( category );
    
    SetFilterObj( twocell, filter );
    
    SetCapCategory( twocell, category );
    
end );

##
InstallMethod( @__MODULE__,  AddTwoCell,
               [ IsCapCategory, IsObject ],
               
  function( category, twocell )
    
    SetFilterObj( twocell, IsCapCategoryTwoCell );
    
    Add( category, twocell );
    
end );

###########################
##
## IsWellDefined
##
###########################

##
InstallMethod( @__MODULE__,  IsWellDefined,
               [ IsCapCategoryTwoCell ],
               
  IsWellDefinedForTwoCells
);

