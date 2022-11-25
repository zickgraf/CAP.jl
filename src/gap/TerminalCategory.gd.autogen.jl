# SPDX-License-Identifier: GPL-2.0-or-later
# CAP: Categories, Algorithms, Programming
#
# Declarations
#
#! @Chapter Terminal category

########################################
#
#! @Section &GAP; Categories
#
########################################

#! @Description
#!  The &GAP; type of a terminal category with a single object.
#! @Arguments T
@DeclareFilter( "IsCapTerminalCategoryWithSingleObject",
        IsCapCategory );

#! @Description
#!  The &GAP; type of an object ⥉ a terminal category with a single object.
#! @Arguments T
@DeclareFilter( "IsObjectInCapTerminalCategoryWithSingleObject",
        IsCapCategoryObject );

#! @Description
#!  The &GAP; type of a morphism ⥉ a terminal category with a single object.
#! @Arguments T
@DeclareFilter( "IsMorphismInCapTerminalCategoryWithSingleObject",
        IsCapCategoryMorphism );

#! @Description
#!  The &GAP; type of a terminal category with multiple objects.
#! @Arguments T
@DeclareFilter( "IsCapTerminalCategoryWithMultipleObjects",
        IsCapCategory );

#! @Description
#!  The &GAP; type of an object ⥉ a terminal category with multiple objects.
#! @Arguments T
@DeclareFilter( "IsObjectInCapTerminalCategoryWithMultipleObjects",
        IsCapCategoryObject );

#! @Description
#!  The &GAP; type of a morphism ⥉ a terminal category with multiple objects.
#! @Arguments T
@DeclareFilter( "IsMorphismInCapTerminalCategoryWithMultipleObjects",
        IsCapCategoryMorphism );

#! @Description
#!  The property of the category <A>C</A> being terminal.
#! @Arguments C
@DeclareProperty( "IsTerminalCategory", IsCapCategory );

AddCategoricalProperty( [ "IsTerminalCategory", "IsTerminalCategory" ] );

########################################
#
#! @Section Constructors
#
########################################

#! @Description
#!  Construct a terminal category with a single object.
@DeclareGlobalFunction( "TerminalCategoryWithSingleObject" );

#! @Description
#!  Construct a terminal category with multiple objects.
@DeclareGlobalFunction( "TerminalCategoryWithMultipleObjects" );

#! @Description
#!  This function takes a record of options suited for CategoryConstructor. 
#!  It makes common adjustments for TerminalCategoryWithSingleObject && TerminalCategoryWithMultipleObjects
#!  to the list of operations to install && the categorical properties of the given record,
#!  before passing it on to CategoryConstructor.
#! @Arguments options
#! @Returns a &CAP; category
@DeclareGlobalFunction( "CAP_INTERNAL_CONSTRUCTOR_FOR_TERMINAL_CATEGORY" );

#########################################
#
#! @Section Attributes
#
#########################################

#! @Description
#!  The unique object ⥉ a terminal category with a single object.
#! @Returns a &CAP; object
@DeclareAttribute( "UniqueObject",
                  IsCapTerminalCategoryWithSingleObject );

#! @Description
#!  The unique morphism ⥉ a terminal category with a single object.
#! @Returns a &CAP; morphism
@DeclareAttribute( "UniqueMorphism",
                  IsCapTerminalCategoryWithSingleObject );

#########################################
##
## Functors
##
#########################################

#! @Description
#!  A functor from `AsCapCategory( TerminalObject( CapCat ) )` mapping the unique object to <A>object</A>.
#! @Arguments object
#! @Returns a &CAP; functor
@DeclareAttribute( "FunctorFromTerminalCategory",
                  IsCapCategoryObject );
