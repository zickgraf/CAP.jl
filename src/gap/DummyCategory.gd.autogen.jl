# SPDX-License-Identifier: GPL-2.0-or-later
# CAP: Categories, Algorithms, Programming
#
# Declarations
#

#! @Chapter Dummy categories
#! 
#! A dummy category pretends to support certain CAP operations but has !actual implementation.
#! This is useful for testing || compiling against a certain set of CAP operations.

####################################
#
#! @Section GAP categories
#
####################################

#! @Description
#!  The &GAP; category of a dummy CAP category.
@DeclareFilter( "IsDummyCategory",
        IsCapCategory );

#! @Description
#!  The &GAP; category of objects ⥉ a dummy CAP category.
@DeclareFilter( "IsDummyCategoryObject",
        IsCapCategoryObject );

#! @Description
#!  The &GAP; category of morphisms ⥉ a dummy CAP category.
@DeclareFilter( "IsDummyCategoryMorphism",
        IsCapCategoryMorphism );

####################################
#
#! @Section Constructors
#
####################################

#! @Description
#!  Creates a dummy category subject to the options given via <A>options</A>, which is a record passed on to <Ref Oper="CategoryConstructor" Label="for IsRecord" />.
#!  Note that the options `[category,object,morphism]_filter` will be set to `IsDummyCategory[,Object,Morphism]` && the options `[object,morphism]_[constructor,datum]` &&
#!  `create_func_*` will be set to dummy implementations (throwing errors when actually called).
#!  The dummy category will pretend to support empty limits by default.
#! @Arguments options
#! @Returns a category
DeclareOperation( "DummyCategory",
                  [ IsRecord ] );
