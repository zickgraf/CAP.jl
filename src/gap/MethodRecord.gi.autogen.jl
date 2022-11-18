# SPDX-License-Identifier: GPL-2.0-or-later
# CAP: Categories, Algorithms, Programming
#
# Implementations
#
InstallValue( CAP_INTERNAL_VALID_RETURN_TYPES,
#! @BeginCode CAP_INTERNAL_VALID_RETURN_TYPES
    [
        "object",
        "object_or_fail",
        "morphism",
        "morphism_or_fail",
        "twocell",
        "object_in_range_category_of_homomorphism_structure",
        "morphism_in_range_category_of_homomorphism_structure",
        "bool",
        "other_object",
        "other_morphism",
        "list_of_morphisms",
        "list_of_morphisms_or_fail",
        "nonneg_integer_or_Inf",
        "list_of_objects"
    ]
#! @EndCode
);

##
InstallGlobalFunction( CAP_INTERNAL_REVERSE_LISTS_IN_ARGUMENTS_FOR_OPPOSITE,
  function( args... )
    local list;
      
    list = CAP_INTERNAL_OPPOSITE_RECURSIVE( args );
      
    return List( list, function( l )
        if IsList( l )
            return Reversed( l );
        else
            return l;
        end;
    end );

end );

InstallValue( CAP_INTERNAL_METHOD_NAME_RECORD, rec(
ObjectConstructor = rec(
  filter_list = [ "category", IsObject ],
  return_type = "object",
  compatible_with_congruence_of_morphisms = false,
),

ObjectDatum = rec(
  filter_list = [ "category", "object" ],
  return_type = IsObject,
),

MorphismConstructor = rec(
  filter_list = [ "category", "object", IsObject, "object" ],
  return_type = "morphism",
  compatible_with_congruence_of_morphisms = false,
),

MorphismDatum = rec(
  filter_list = [ "category", "morphism" ],
  return_type = IsObject,
  compatible_with_congruence_of_morphisms = false,
),

LiftAlongMonomorphism = rec(
  filter_list = [ "category", "morphism", "morphism" ],
  io_type = [ [ "iota", "tau" ], [ "tau_source", "iota_source" ] ],
  pre_function = function( cat, iota, tau )
    local value, category;
    
    value = IsEqualForObjects( Range( iota ), Range( tau ) );
    
    if value == fail
        
        return [ false, "can!decide whether the two morphisms have equal ranges" ];
        
    elseif value == false
        
        return [ false, "the two morphisms must have equal ranges" ];
        
    end;
    
    return [ true ];
  end,
  return_type = "morphism",
  dual_operation = "ColiftAlongEpimorphism",
  compatible_with_congruence_of_morphisms = true,
),

IsLiftableAlongMonomorphism = rec(
  filter_list = [ "category", "morphism", "morphism" ],
  pre_function = function( cat, iota, tau )
    local value;
    
    value = IsEqualForObjects( Range( iota ), Range( tau ) );
    
    if value == fail
        
        return [ false, "can!decide whether the two morphisms have equal ranges" ];
        
    elseif value == false
        
        return [ false, "the two morphisms must have equal ranges" ];
        
    end;
    
    return [ true ];
  end,
  return_type = "bool",
  dual_operation = "IsColiftableAlongEpimorphism",
  compatible_with_congruence_of_morphisms = true,
),

ColiftAlongEpimorphism = rec(
  filter_list = [ "category", "morphism", "morphism" ],
  io_type = [ [ "epsilon", "tau" ], [ "epsilon_range", "tau_range" ] ],
  pre_function = function( cat, epsilon, tau )
    local value, category;
    
    value = IsEqualForObjects( Source( epsilon ), Source( tau ) );
    
    if value == fail
        
        return [ false, "can!decide whether the two morphisms have equal sources" ];
        
    elseif value == false
        
        return [ false, "the two morphisms must have equal sources" ];
        
    end;
    
    return [ true ];
  end,
  return_type = "morphism",
  dual_operation = "LiftAlongMonomorphism",
  compatible_with_congruence_of_morphisms = true,
),

IsColiftableAlongEpimorphism = rec(
  filter_list = [ "category", "morphism", "morphism" ],
  pre_function = function( cat, epsilon, tau )
    local value;
    
    value = IsEqualForObjects( Source( epsilon ), Source( tau ) );
    
    if value == fail
        
        return [ false, "can!decide whether the two morphisms have equal sources" ];
        
    elseif value == false
        
        return [ false, "the two morphisms must have equal sources" ];
        
    end;
    
    return [ true ];
  end,
  return_type = "bool",
  dual_operation = "IsLiftableAlongMonomorphism",
  compatible_with_congruence_of_morphisms = true,
),

Lift = rec(
  filter_list = [ "category", "morphism", "morphism" ],
  io_type = [ [ "alpha", "beta" ], [ "alpha_source", "beta_source" ] ],
  pre_function = function( cat, iota, tau )
    local value;
    
    value = IsEqualForObjects( Range( iota ), Range( tau ) );
    
    if value == fail
        
        return [ false, "can!decide whether the two morphisms have equal ranges" ];
        
    elseif value == false
        
        return [ false, "the two morphisms must have equal ranges" ];
        
    end;
    
    return [ true ];
  end,
  return_type = "morphism",
  dual_operation = "Colift",
  dual_arguments_reversed = true,
  is_merely_set_theoretic = true,
  compatible_with_congruence_of_morphisms = false,
),

LiftOrFail = rec(
  filter_list = [ "category", "morphism", "morphism" ],
  io_type = [ [ "alpha", "beta" ], [ "alpha_source", "beta_source" ] ],
  pre_function = "Lift",
  return_type = "morphism_or_fail",
  dual_operation = "ColiftOrFail",
  dual_arguments_reversed = true,
  is_merely_set_theoretic = true,
  compatible_with_congruence_of_morphisms = false,
),

IsLiftable = rec(
  filter_list = [ "category", "morphism", "morphism" ],
  pre_function = "Lift",
  return_type = "bool",
  dual_operation = "IsColiftable",
  dual_arguments_reversed = true,
  compatible_with_congruence_of_morphisms = false,
),

Colift = rec(
  filter_list = [ "category", "morphism", "morphism" ],
  io_type = [ [ "alpha", "beta" ], [ "alpha_range", "beta_range" ] ],
  pre_function = function( cat, epsilon, tau )
    local value;
    
    value = IsEqualForObjects( Source( epsilon ), Source( tau ) );
    
    if value == fail
        
        return [ false, "can!decide whether the two morphisms have equal sources" ];
        
    elseif value == false
        
        return [ false, "the two morphisms must have equal sources" ];
        
    end;
    
    return [ true ];
  end,
  return_type = "morphism",
  dual_operation = "Lift",
  dual_arguments_reversed = true,
  is_merely_set_theoretic = true,
  compatible_with_congruence_of_morphisms = false,
),

ColiftOrFail = rec(
  filter_list = [ "category", "morphism", "morphism" ],
  io_type = [ [ "alpha", "beta" ], [ "alpha_range", "beta_range" ] ],
  pre_function = "Colift",
  return_type = "morphism_or_fail",
  dual_operation = "LiftOrFail",
  dual_arguments_reversed = true,
  is_merely_set_theoretic = true,
  compatible_with_congruence_of_morphisms = false,
),

IsColiftable = rec(
  filter_list = [ "category", "morphism", "morphism" ],
  pre_function = "Colift",
  return_type = "bool",
  dual_operation = "IsLiftable",
  dual_arguments_reversed = true,
  compatible_with_congruence_of_morphisms = false,
),

ProjectiveLift = rec(
  filter_list = [ "category", "morphism", "morphism" ],
  io_type = [ [ "alpha", "beta" ], [ "alpha_source", "beta_source" ] ],
  pre_function = function( cat, iota, tau )
    local value;
    
    value = IsEqualForObjects( Range( iota ), Range( tau ) );
    
    if value == fail
        
        return [ false, "can!decide whether the two morphisms have equal ranges" ];
        
    elseif value == false
        
        return [ false, "the two morphisms must have equal ranges" ];
        
    end;
    
    return [ true ];
  end,
  return_type = "morphism",
  dual_arguments_reversed = true,
  dual_operation = "InjectiveColift",
  compatible_with_congruence_of_morphisms = false,
),

InjectiveColift = rec(
  filter_list = [ "category", "morphism", "morphism" ],
  io_type = [ [ "alpha", "beta" ], [ "alpha_range", "beta_range" ] ],
  pre_function = function( cat, epsilon, tau )
    local value;
    
    value = IsEqualForObjects( Source( epsilon ), Source( tau ) );
    
    if value == fail
        
        return [ false, "can!decide whether the two morphisms have equal sources" ];
        
    elseif value == false
        
        return [ false, "the two morphisms must have equal sources" ];
        
    end;
    
    return [ true ];
  end,
  return_type = "morphism",
  dual_arguments_reversed = true,
  dual_operation = "ProjectiveLift",
  compatible_with_congruence_of_morphisms = false,
),

IdentityMorphism = rec(
  filter_list = [ "category", "object" ],
  io_type = [ [ "a" ], [ "a", "a" ] ],
  return_type = "morphism",
  dual_operation = "IdentityMorphism" ),

InverseForMorphisms = rec(
# Type check for IsIsomorphism
  filter_list = [ "category", "morphism" ],
  io_type = [ [ "alpha" ], [ "alpha_range", "alpha_source" ] ],
  return_type = "morphism",
  dual_operation = "InverseForMorphisms",
  compatible_with_congruence_of_morphisms = true,
),

PreInverseForMorphisms = rec(
  filter_list = [ "category", "morphism" ],
  io_type = [ [ "alpha" ], [ "alpha_range", "alpha_source" ] ],
  return_type = "morphism",
  dual_operation = "PostInverseForMorphisms",
  is_merely_set_theoretic = true
),

PostInverseForMorphisms = rec(
  filter_list = [ "category", "morphism" ],
  io_type = [ [ "alpha" ], [ "alpha_range", "alpha_source" ] ],
  return_type = "morphism",
  dual_operation = "PreInverseForMorphisms",
  is_merely_set_theoretic = true
),

KernelObject = rec(
  filter_list = [ "category", "morphism" ],
  return_type = "object",
  dual_operation = "CokernelObject",
  compatible_with_congruence_of_morphisms = false,
  functorial = "KernelObjectFunctorial",
),

KernelEmbedding = rec(
  filter_list = [ "category", "morphism" ],
  io_type = [ [ "alpha" ], [ "P", "alpha_source" ] ],
  with_given_object_position = "Source",
  return_type = "morphism",
  dual_operation = "CokernelProjection",
  compatible_with_congruence_of_morphisms = false,
),

KernelEmbeddingWithGivenKernelObject = rec(
  filter_list = [ "category", "morphism", "object" ],
  io_type = [ [ "alpha", "P" ], [ "P", "alpha_source" ] ],
  return_type = "morphism",
  dual_operation = "CokernelProjectionWithGivenCokernelObject",
  compatible_with_congruence_of_morphisms = false,
),

MorphismFromKernelObjectToSink = rec(
  filter_list = [ "category", "morphism" ],
  io_type = [ [ "alpha" ], [ "P", "alpha_range" ] ],
  with_given_object_position = "Source",
  dual_operation = "MorphismFromSourceToCokernelObject",
  return_type = "morphism",
  compatible_with_congruence_of_morphisms = false,
),

MorphismFromKernelObjectToSinkWithGivenKernelObject = rec(
  filter_list = [ "category", "morphism", "object" ],
  io_type = [ [ "alpha", "P" ], [ "P", "alpha_range" ] ],
  dual_operation = "MorphismFromSourceToCokernelObjectWithGivenCokernelObject",
  return_type = "morphism",
  compatible_with_congruence_of_morphisms = false,
),

KernelLift = rec(
  filter_list = [ "category", "morphism", "object", "morphism" ],
  io_type = [ [ "alpha", "T", "tau" ], [ "T", "P" ] ],
  with_given_object_position = "Range",
  return_type = "morphism",
  dual_operation = "CokernelColift",
  compatible_with_congruence_of_morphisms = false,
),

KernelLiftWithGivenKernelObject = rec(
  filter_list = [ "category", "morphism", "object", "morphism", "object" ],
  io_type = [ [ "alpha", "T", "tau", "P" ], [ "T", "P" ] ],
  return_type = "morphism",
  dual_operation = "CokernelColiftWithGivenCokernelObject",
  compatible_with_congruence_of_morphisms = false,
),

CokernelObject = rec(
  filter_list = [ "category", "morphism" ],
  return_type = "object",
  dual_operation = "KernelObject",
  compatible_with_congruence_of_morphisms = false,
  functorial = "CokernelObjectFunctorial",
),

CokernelProjection = rec(
  filter_list = [ "category", "morphism" ],
  io_type = [ [ "alpha" ], [ "alpha_range", "P" ] ],
  with_given_object_position = "Range",
  return_type = "morphism",
  dual_operation = "KernelEmbedding",
  compatible_with_congruence_of_morphisms = false,
),

CokernelProjectionWithGivenCokernelObject = rec(
  filter_list = [ "category", "morphism", "object" ],
  io_type = [ [ "alpha", "P" ], [ "alpha_range", "P" ] ],
  return_type = "morphism",
  dual_operation = "KernelEmbeddingWithGivenKernelObject",
  compatible_with_congruence_of_morphisms = false,
),

MorphismFromSourceToCokernelObject = rec(
  filter_list = [ "category", "morphism" ],
  io_type = [ [ "alpha" ], [ "alpha_source", "P" ] ],
  with_given_object_position = "Range",
  dual_operation = "MorphismFromKernelObjectToSink",
  return_type = "morphism",
  compatible_with_congruence_of_morphisms = false,
),

MorphismFromSourceToCokernelObjectWithGivenCokernelObject = rec(
  filter_list = [ "category", "morphism", "object" ],
  io_type = [ [ "alpha", "P" ], [ "alpha_source", "P" ] ],
  dual_operation = "MorphismFromKernelObjectToSinkWithGivenKernelObject",
  return_type = "morphism",
  compatible_with_congruence_of_morphisms = false,
),

CokernelColift = rec(
  filter_list = [ "category", "morphism", "object", "morphism" ],
  io_type = [ [ "alpha", "T", "tau" ], [ "P", "T" ] ],
  with_given_object_position = "Source",
  return_type = "morphism",
  dual_operation = "KernelLift",
  compatible_with_congruence_of_morphisms = false,
),

CokernelColiftWithGivenCokernelObject = rec(
  filter_list = [ "category", "morphism", "object", "morphism", "object" ],
  io_type = [ [ "alpha", "T", "tau", "P" ], [ "P", "T" ] ],
  return_type = "morphism",
  dual_operation = "KernelLiftWithGivenKernelObject",
  compatible_with_congruence_of_morphisms = false,
),

PreCompose = rec(
  filter_list = [ "category", "morphism", "morphism" ],
  io_type = [ [ "alpha", "beta" ], [ "alpha_source", "beta_range" ] ],
  
  pre_function = function( cat, mor_left, mor_right )
    local is_equal_for_objects;
    
    is_equal_for_objects = IsEqualForObjects( Range( mor_left ), Source( mor_right ) );
    
    if is_equal_for_objects == fail
      
      return [ false, "can!decide whether morphisms are composable" ];
      
    elseif is_equal_for_objects == false
        
        return [ false, "morphisms !composable" ];
        
    end;
    
    return [ true ];
  end,
  return_type = "morphism",
  dual_operation = "PostCompose",
  compatible_with_congruence_of_morphisms = true,
),

SumOfMorphisms = rec(
  filter_list = [ "category", "object", "list_of_morphisms", "object" ],
  input_arguments_names = [ "cat", "source", "list_of_morphisms", "range" ],
  pre_function = function( cat, source, list_of_morphisms, range )
    local m, is_equal_for_sources, is_equal_for_ranges;
    
    for m in list_of_morphisms
        
        is_equal_for_sources = IsEqualForObjects( cat, source, Source( m ) );
        is_equal_for_ranges = IsEqualForObjects( cat, range, Range( m ) );
        
        if is_equal_for_sources == fail || is_equal_for_ranges == fail
            
            return [ false, "can!decide whether morphisms are compatible with the provided source && range objects" ];
            
        elseif is_equal_for_sources == false || is_equal_for_ranges == false
            
            return [ false, "some of the morphisms are !compatible with the provided source && range objects" ];
            
        end;
        
    end;
    
    return [ true ];
    
  end,
  return_type = "morphism",
  output_source_getter_string = "source",
  output_range_getter_string = "range",
  dual_operation = "SumOfMorphisms",
  dual_arguments_reversed = true,
  compatible_with_congruence_of_morphisms = true,
),

PreComposeList = rec(
  filter_list = [ "category", "list_of_morphisms" ],
  input_arguments_names = [ "cat", "list_of_morphisms" ],
  pre_function = function( cat, list_of_morphisms )
    local is_equal_for_objects, i;
    
    if IsEmpty( list_of_morphisms )
        
        return [ false, "the list of morphisms must !be empty" ];
        
    end;
    
    for i in (1):(Length( list_of_morphisms ) - 1)
        
        is_equal_for_objects = IsEqualForObjects( Range( list_of_morphisms[i] ), Source( list_of_morphisms[i + 1] ) );
        
        if is_equal_for_objects == fail
            
            return [ false, "can!decide whether morphisms are composable" ];
            
        elseif is_equal_for_objects == false
            
            return [ false, "morphisms !composable" ];
            
        end;
        
    end;
    
    return [ true ];
    
  end,
  return_type = "morphism",
  output_source_getter_string = "Source( list_of_morphisms[1] )",
  can_always_compute_output_source_getter = true,
  output_range_getter_string = "Range( Last( list_of_morphisms ) )",
  can_always_compute_output_range_getter = true,
  dual_operation = "PostComposeList",
  compatible_with_congruence_of_morphisms = true,
),

PostCompose = rec(
  filter_list = [ "category", "morphism", "morphism" ],
  io_type = [ [ "beta", "alpha" ], [ "alpha_source", "beta_range" ] ],
  
  pre_function = function( cat, mor_right, mor_left )
    local is_equal_for_objects;
    
    is_equal_for_objects = IsEqualForObjects( Range( mor_left ), Source( mor_right ) );
    
    if is_equal_for_objects == fail
      
      return [ false, "can!decide whether morphisms are composable" ];
      
    elseif is_equal_for_objects == false
        
        return [ false, "morphisms !composable" ];
        
    end;
    
    return [ true ];
  end,
  
  return_type = "morphism",
  dual_operation = "PreCompose",
  compatible_with_congruence_of_morphisms = true,
),

PostComposeList = rec(
  filter_list = [ "category", "list_of_morphisms" ],
  input_arguments_names = [ "cat", "list_of_morphisms" ],
  pre_function = function( cat, list_of_morphisms )
    local is_equal_for_objects, i;
    
    if IsEmpty( list_of_morphisms )
        
        return [ false, "the list of morphisms must !be empty" ];
        
    end;
    
    for i in (1):(Length( list_of_morphisms ) - 1)
        
        is_equal_for_objects = IsEqualForObjects( Range( list_of_morphisms[i + 1] ), Source( list_of_morphisms[i] ) );
        
        if is_equal_for_objects == fail
            
            return [ false, "can!decide whether morphisms are composable" ];
            
        elseif is_equal_for_objects == false
            
            return [ false, "morphisms !composable" ];
            
        end;
        
    end;
    
    return [ true ];
    
  end,
  return_type = "morphism",
  output_source_getter_string = "Source( Last( list_of_morphisms ) )",
  can_always_compute_output_source_getter = true,
  output_range_getter_string = "Range( list_of_morphisms[1] )",
  can_always_compute_output_range_getter = true,
  dual_operation = "PreComposeList",
  compatible_with_congruence_of_morphisms = true,
),

ZeroObject = rec(
  filter_list = [ "category" ],
  return_type = "object",
  dual_operation = "ZeroObject",
  functorial = "ZeroObjectFunctorial",
),

ZeroObjectFunctorial = rec(
  filter_list = [ "category" ],
  input_arguments_names = [ "cat" ],
  return_type = "morphism",
  output_source_getter_string = "ZeroObject( cat )",
  output_range_getter_string = "ZeroObject( cat )",
  with_given_object_position = "both",
  dual_operation = "ZeroObjectFunctorial",
  dual_arguments_reversed = true
),

ZeroObjectFunctorialWithGivenZeroObjects = rec(
  filter_list = [ "category", "object", "object" ],
  io_type = [ [ "P", "Pp" ], [ "P", "Pp" ] ],
  return_type = "morphism",
  dual_operation = "ZeroObjectFunctorialWithGivenZeroObjects",
  dual_arguments_reversed = true
),

UniversalMorphismFromZeroObject = rec(
  filter_list = [ "category", "object" ],
  io_type = [ [ "T" ], [ "P", "T" ] ],
  with_given_object_position = "Source",
  return_type = "morphism",
  dual_operation = "UniversalMorphismIntoZeroObject" ),
  
UniversalMorphismFromZeroObjectWithGivenZeroObject = rec(
  filter_list = [ "category", "object", "object" ],
  io_type = [ [ "T", "P" ], [ "P", "T" ] ],
  return_type = "morphism",
  dual_operation = "UniversalMorphismIntoZeroObjectWithGivenZeroObject" ),

UniversalMorphismIntoZeroObject = rec(
  filter_list = [ "category", "object" ],
  io_type = [ [ "T" ], [ "T", "P" ] ],
  with_given_object_position = "Range",
  return_type = "morphism",
  dual_operation = "UniversalMorphismFromZeroObject" ),

UniversalMorphismIntoZeroObjectWithGivenZeroObject = rec(
  filter_list = [ "category", "object", "object" ],
  io_type = [ [ "T", "P" ], [ "T", "P" ] ],
  return_type = "morphism",
  dual_operation = "UniversalMorphismFromZeroObjectWithGivenZeroObject" ),

IsomorphismFromZeroObjectToInitialObject = rec(
  filter_list = [ "category" ],
  ## TODO: io_type?
  return_type = "morphism",
  dual_operation = "IsomorphismFromTerminalObjectToZeroObject",
),

IsomorphismFromInitialObjectToZeroObject = rec(
  filter_list = [ "category" ],
  ## TODO: io_type?
  return_type = "morphism",
  dual_operation = "IsomorphismFromZeroObjectToTerminalObject",
),

IsomorphismFromZeroObjectToTerminalObject = rec(
  filter_list = [ "category" ],
  ## TODO: io_type?
  return_type = "morphism",
  dual_operation = "IsomorphismFromInitialObjectToZeroObject",
),

IsomorphismFromTerminalObjectToZeroObject = rec(
  filter_list = [ "category" ],
  ## TODO: io_type?
  return_type = "morphism",
  dual_operation = "IsomorphismFromZeroObjectToInitialObject",
),

ZeroMorphism = rec(
  filter_list = [ "category", "object", "object" ],
  io_type = [ [ "a", "b" ], [ "a", "b" ] ],
  return_type = "morphism",
  dual_arguments_reversed = true,
  dual_operation = "ZeroMorphism" ),

DirectSum = rec(
  filter_list = [ "category", "list_of_objects" ],
  return_type = "object",
  dual_operation = "DirectSum",
  functorial = "DirectSumFunctorial",
),

ProjectionInFactorOfDirectSum = rec(
  filter_list = [ "category", "list_of_objects", IsInt ],
  io_type = [ [ "objects", "k" ], [ "P", "objects_k" ] ],
  with_given_object_position = "Source",
  return_type = "morphism",
  dual_operation = "InjectionOfCofactorOfDirectSum" ),

ProjectionInFactorOfDirectSumWithGivenDirectSum = rec(
  filter_list = [ "category", "list_of_objects", IsInt, "object" ],
  io_type = [ [ "objects", "k", "P" ], [ "P", "objects_k" ] ],
  return_type = "morphism",
  dual_operation = "InjectionOfCofactorOfDirectSumWithGivenDirectSum" ),

UniversalMorphismIntoDirectSum = rec(
  filter_list = [ "category", "list_of_objects", "object", "list_of_morphisms" ],
  io_type = [ [ "objects", "T", "tau" ], [ "T", "P" ] ],
  with_given_object_position = "Range",
  dual_operation = "UniversalMorphismFromDirectSum",
  
  pre_function = function( cat, diagram, test_object, source )
    local current_morphism, current_return;
    
    for current_morphism in source
        
        current_return = IsEqualForObjects( Source( current_morphism ), test_object );
        
        if current_return == fail
            
            return [ false, "can!decide whether sources of morphisms ⥉ given source diagram are equal to the test object" ];
            
        elseif current_return == false
            
            return [ false, "sources of morphisms must be equal to the test object ⥉ given source diagram" ];
            
        end;
        
    end;
    
    return [ true ];
    
  end,
  return_type = "morphism",
  compatible_with_congruence_of_morphisms = true,
),

UniversalMorphismIntoDirectSumWithGivenDirectSum = rec(
  filter_list = [ "category", "list_of_objects", "object", "list_of_morphisms", "object" ],
  io_type = [ [ "objects", "T", "tau", "P" ], [ "T", "P" ] ],
  dual_operation = "UniversalMorphismFromDirectSumWithGivenDirectSum",
  
  pre_function = function( cat, diagram, test_object, source, direct_sum )
    local current_morphism, current_return;
    
    for current_morphism in source
        
        current_return = IsEqualForObjects( Source( current_morphism ), test_object );
        
        if current_return == fail
            
            return [ false, "can!decide whether sources of morphisms ⥉ given source diagram are equal to the test object" ];
            
        elseif current_return == false
            
            return [ false, "sources of morphisms must be equal to the test object ⥉ given source diagram" ];
            
        end;
        
    end;
    
    return [ true ];
    
  end,
  return_type = "morphism",
  compatible_with_congruence_of_morphisms = true,
),

InjectionOfCofactorOfDirectSum = rec(
  filter_list = [ "category", "list_of_objects", IsInt ],
  io_type = [ [ "objects", "k" ], [ "objects_k", "P" ] ],
  with_given_object_position = "Range",
  return_type = "morphism",
  dual_operation = "ProjectionInFactorOfDirectSum" ),

InjectionOfCofactorOfDirectSumWithGivenDirectSum = rec(
  filter_list = [ "category", "list_of_objects", IsInt, "object" ],
  io_type = [ [ "objects", "k", "P" ], [ "objects_k", "P" ] ],
  return_type = "morphism",
  dual_operation = "ProjectionInFactorOfDirectSumWithGivenDirectSum" ),

UniversalMorphismFromDirectSum = rec(
  filter_list = [ "category", "list_of_objects", "object", "list_of_morphisms" ],
  io_type = [ [ "objects", "T", "tau" ], [ "P", "T" ] ],
  with_given_object_position = "Source",
  dual_operation = "UniversalMorphismIntoDirectSum",
  
  pre_function = function( cat, diagram, test_object, sink )
    local current_morphism, current_return;
    
    for current_morphism in sink
        
        current_return = IsEqualForObjects( Range( current_morphism ), test_object );
        
        if current_return == fail
            
            return [ false, "can!decide whether ranges of morphisms ⥉ given sink diagram are equal to the test object" ];
            
        elseif current_return == false
            
            return [ false, "ranges of morphisms must be equal to the test object ⥉ given sink diagram" ];
            
        end;
        
    end;
    
    return [ true ];
    
  end,
  return_type = "morphism",
  compatible_with_congruence_of_morphisms = true,
),

UniversalMorphismFromDirectSumWithGivenDirectSum = rec(
  filter_list = [ "category", "list_of_objects", "object", "list_of_morphisms", "object" ],
  io_type = [ [ "objects", "T", "tau", "P" ], [ "P", "T" ] ],
  dual_operation = "UniversalMorphismIntoDirectSumWithGivenDirectSum",
  
  pre_function = function( cat, diagram, test_object, sink, direct_sum )
    local current_morphism, current_return;
    
    for current_morphism in sink
        
        current_return = IsEqualForObjects( Range( current_morphism ), test_object );
        
        if current_return == fail
            
            return [ false, "can!decide whether ranges of morphisms ⥉ given sink diagram are equal to the test object" ];
            
        elseif current_return == false
            
            return [ false, "ranges of morphisms must be equal to the test object ⥉ given sink diagram" ];
            
        end;
        
    end;
    
    return [ true ];
    
  end,
  return_type = "morphism",
  compatible_with_congruence_of_morphisms = true,
),

TerminalObject = rec(
  filter_list = [ "category" ],
  return_type = "object",
  dual_operation = "InitialObject",
  functorial = "TerminalObjectFunctorial",
),

UniversalMorphismIntoTerminalObject = rec(
  filter_list = [ "category", "object" ],
  io_type = [ [ "T" ], [ "T", "P" ] ],
  with_given_object_position = "Range",
  return_type = "morphism",
  dual_operation = "UniversalMorphismFromInitialObject" ),

UniversalMorphismIntoTerminalObjectWithGivenTerminalObject = rec(
  filter_list = [ "category", "object", "object" ],
  io_type = [ [ "T", "P" ], [ "T", "P" ] ],
  return_type = "morphism",
  dual_operation = "UniversalMorphismFromInitialObjectWithGivenInitialObject" ),

InitialObject = rec(
  filter_list = [ "category" ],
  return_type = "object",
  dual_operation = "TerminalObject",
  functorial = "InitialObjectFunctorial",
),

UniversalMorphismFromInitialObject = rec(
  filter_list = [ "category", "object" ],
  io_type = [ [ "T" ], [ "P", "T" ] ],
  with_given_object_position = "Source",
  return_type = "morphism",
  dual_operation = "UniversalMorphismIntoTerminalObject" ),

UniversalMorphismFromInitialObjectWithGivenInitialObject = rec(
  filter_list = [ "category", "object", "object" ],
  io_type = [ [ "T", "P" ], [ "P", "T" ] ],
  return_type = "morphism",
  dual_operation = "UniversalMorphismIntoTerminalObjectWithGivenTerminalObject" ),

DirectProduct = rec(
  filter_list = [ "category", "list_of_objects" ],
  return_type = "object",
  dual_operation = "Coproduct",
  functorial = "DirectProductFunctorial",
),

ProjectionInFactorOfDirectProduct = rec(
  filter_list = [ "category", "list_of_objects", IsInt ],
  io_type = [ [ "objects", "k" ], [ "P", "objects_k" ] ],
  with_given_object_position = "Source",
  return_type = "morphism",
  dual_operation = "InjectionOfCofactorOfCoproduct" ),

ProjectionInFactorOfDirectProductWithGivenDirectProduct = rec(
  filter_list = [ "category", "list_of_objects", IsInt, "object" ],
  io_type = [ [ "objects", "k", "P" ], [ "P", "objects_k" ] ],
  return_type = "morphism",
  dual_operation = "InjectionOfCofactorOfCoproductWithGivenCoproduct" ),

UniversalMorphismIntoDirectProduct = rec(
  filter_list = [ "category", "list_of_objects", "object", "list_of_morphisms" ],
  io_type = [ [ "objects", "T", "tau" ], [ "T", "P" ] ],
  with_given_object_position = "Range",
  dual_operation = "UniversalMorphismFromCoproduct",
  
  pre_function = function( cat, diagram, test_object, source )
    local current_morphism, current_return;
    
    for current_morphism in source
        
        current_return = IsEqualForObjects( Source( current_morphism ), test_object );
        
        if current_return == fail
            
            return [ false, "can!decide whether sources of morphisms ⥉ given source diagram are equal to the test object" ];
            
        elseif current_return == false
            
            return [ false, "sources of morphisms must be equal to the test object ⥉ given source diagram" ];
            
        end;
        
    end;
    
    return [ true ];
    
  end,
  return_type = "morphism",
  compatible_with_congruence_of_morphisms = true,
),

UniversalMorphismIntoDirectProductWithGivenDirectProduct = rec(
  filter_list = [ "category", "list_of_objects", "object", "list_of_morphisms", "object" ],
  io_type = [ [ "objects", "T", "tau", "P" ], [ "T", "P" ] ],
  dual_operation = "UniversalMorphismFromCoproductWithGivenCoproduct",
  
  pre_function = function( cat, diagram, test_object, source, direct_product )
    local current_morphism, current_return;
    
    for current_morphism in source
        
        current_return = IsEqualForObjects( Source( current_morphism ), test_object );
        
        if current_return == fail
            
            return [ false, "can!decide whether sources of morphisms ⥉ given source diagram are equal to the test object" ];
            
        elseif current_return == false
            
            return [ false, "sources of morphisms must be equal to the test object ⥉ given source diagram" ];
            
        end;
        
    end;
    
    return [ true ];
    
  end,
  return_type = "morphism",
  compatible_with_congruence_of_morphisms = true,
),

IsCongruentForMorphisms = rec(
  filter_list = [ "category", "morphism", "morphism" ],
  well_defined_todo = false,
  dual_operation = "IsCongruentForMorphisms",
  
  pre_function = function( cat, morphism_1, morphism_2 )
    local value_1, value_2;
    
    value_1 = IsEqualForObjects( Source( morphism_1 ), Source( morphism_2 ) );
    
    if value_1 == fail
      
      return [ false, "can!decide whether sources are equal" ];
      
    end;
    
    value_2 = IsEqualForObjects( Range( morphism_1 ), Range( morphism_2 ) );
    
    if value_2 == fail
      
      return [ false, "can!decide whether ranges are equal" ];
      
    end;
    
    
    if value_1 && value_2
        
        return [ true ];
        
    elseif value_1
        
        return [ false, "ranges are !equal" ];
        
    else
        
        return [ false, "sources are !equal" ];
        
    end;
    
  end,
  
  redirect_function = function( cat, morphism_1, morphism_2 )
    
    if IsIdenticalObj( morphism_1, morphism_2 )
      
      return [ true, true ];
      
    else
      
      return [ false ];
      
    end;
    
  end,
  
  post_function = function( cat, morphism_1, morphism_2, return_value )
    
    if cat.predicate_logic_propagation_for_morphisms &&
       cat.predicate_logic && return_value == true
          
          INSTALL_TODO_LIST_FOR_EQUAL_MORPHISMS( morphism_1, morphism_2 );
          
    end;
    
  end,
  
  return_type = "bool",
  compatible_with_congruence_of_morphisms = true,
),

IsEqualForMorphisms = rec(
  filter_list = [ "category", "morphism", "morphism" ],
  well_defined_todo = false,
  dual_operation = "IsEqualForMorphisms",
  
  pre_function = function( cat, morphism_1, morphism_2 )
    local value_1, value_2;
    
    value_1 = IsEqualForObjects( Source( morphism_1 ), Source( morphism_2 ) );
    
    if value_1 == fail
      
      return [ false, "can!decide whether sources are equal" ];
      
    end;
    
    value_2 = IsEqualForObjects( Range( morphism_1 ), Range( morphism_2 ) );
    
    if value_2 == fail
      
      return [ false, "can!decide whether ranges are equal" ];
      
    end;
    
    
    if value_1 && value_2
        
        return [ true ];
        
    elseif value_1
        
        return [ false, "ranges are !equal" ];
        
    else
        
        return [ false, "sources are !equal" ];
        
    end;
    
  end,
  
  redirect_function = function( cat, morphism_1, morphism_2 )
    
    if IsIdenticalObj( morphism_1, morphism_2 )
      
      return [ true, true ];
      
    else
      
      return [ false ];
      
    end;
    
  end,
  
  return_type = "bool",
  compatible_with_congruence_of_morphisms = false,
),

IsEqualForMorphismsOnMor = rec(
  filter_list = [ "category", "morphism", "morphism" ],
  well_defined_todo = false,
  dual_operation = "IsEqualForMorphismsOnMor",
  
  redirect_function = function( cat, morphism_1, morphism_2 )
    
    if IsIdenticalObj( morphism_1, morphism_2 )
      
      return [ true, true ];
      
    else
      
      return [ false ];
      
    end;
    
  end,
  
  return_type = "bool",
  compatible_with_congruence_of_morphisms = false,
),

IsEqualForObjects = rec(
  filter_list = [ "category", "object", "object" ],
  well_defined_todo = false,
  dual_operation = "IsEqualForObjects",
  
  redirect_function = function( cat, object_1, object_2 )
    
    if IsIdenticalObj( object_1, object_2 )
      
      return [ true, true ];
      
    else
      
      return [ false ];
      
    end;
    
  end,
  
  post_function = function( cat, object_1, object_2, return_value )
    
    if cat.predicate_logic_propagation_for_objects &&
       cat.predicate_logic && return_value == true && !IsIdenticalObj( object_1, object_2 )
        
        INSTALL_TODO_LIST_FOR_EQUAL_OBJECTS( object_1, object_2 );
        
    end;
    
  end,
  
  return_type = "bool" ),
  
IsEqualForCacheForObjects = rec(
  filter_list = [ "category", "object", "object" ],
  dual_operation = "IsEqualForCacheForObjects",
  well_defined_todo = false,
  return_type = "bool" ),

IsEqualForCacheForMorphisms = rec(
  filter_list = [ "category", "morphism", "morphism" ],
  dual_operation = "IsEqualForCacheForMorphisms",
  well_defined_todo = false,
  return_type = "bool",
  compatible_with_congruence_of_morphisms = false,
),
  
IsZeroForMorphisms = rec(
  filter_list = [ "category", "morphism" ],
  well_defined_todo = false,
  return_type = "bool",
  dual_operation = "IsZeroForMorphisms",
  property_of = "morphism",
  is_reflected_by_faithful_functor = true,
  compatible_with_congruence_of_morphisms = true,
),

AdditionForMorphisms = rec(
  filter_list = [ "category", "morphism", "morphism" ],
  io_type = [ [ "a", "b" ], [ "a_source", "a_range" ] ],
  dual_operation = "AdditionForMorphisms",
  
  pre_function = function( cat, morphism_1, morphism_2 )
    local value_1, value_2;
    
    value_1 = IsEqualForObjects( Source( morphism_1 ), Source( morphism_2 ) );
    
    if value_1 == fail
      
      return [ false, "can!decide whether sources are equal" ];
      
    end;
    
    value_2 = IsEqualForObjects( Range( morphism_1 ), Range( morphism_2 ) );
    
    if value_2 == fail
      
      return [ false, "can!decide whether ranges are equal" ];
      
    end;
    
    
    if value_1 && value_2
        
        return [ true ];
        
    elseif value_1
        
        return [ false, "ranges are !equal" ];
        
    else
        
        return [ false, "sources are !equal" ];
        
    end;
    
  end,
  return_type = "morphism",
  compatible_with_congruence_of_morphisms = true,
),

SubtractionForMorphisms = rec(
  filter_list = [ "category", "morphism", "morphism" ],
  io_type = [ [ "a", "b" ], [ "a_source", "a_range" ] ],
  dual_operation = "SubtractionForMorphisms",
  
  pre_function = function( cat, morphism_1, morphism_2 )
    local value_1, value_2;
    
    value_1 = IsEqualForObjects( Source( morphism_1 ), Source( morphism_2 ) );
    
    if value_1 == fail
      
      return [ false, "can!decide whether sources are equal" ];
      
    end;
    
    value_2 = IsEqualForObjects( Range( morphism_1 ), Range( morphism_2 ) );
    
    if value_2 == fail
      
      return [ false, "can!decide whether ranges are equal" ];
      
    end;
    
    
    if value_1 && value_2
        
        return [ true ];
        
    elseif value_1
        
        return [ false, "ranges are !equal" ];
        
    else
        
        return [ false, "sources are !equal" ];
        
    end;
    
  end,
  return_type = "morphism",
  compatible_with_congruence_of_morphisms = true,
),

MultiplyWithElementOfCommutativeRingForMorphisms = rec(
  filter_list = [ "category", IsRingElement, "morphism" ],
  io_type = [ [ "r", "a" ], [ "a_source", "a_range" ] ],
  
  pre_function = function( cat, r, morphism )
    
    if !r ⥉ CommutativeRingOfLinearCategory( CapCategory( morphism ) )
      
      return [ false, "the first argument is !an element of the ring of the category of the morphism" ];
      
    end;
    
    return [ true ];
  end,
  dual_operation = "MultiplyWithElementOfCommutativeRingForMorphisms",
  return_type = "morphism",
  compatible_with_congruence_of_morphisms = true,
),

AdditiveInverseForMorphisms = rec(
  filter_list = [ "category", "morphism" ],
  io_type = [ [ "a" ], [ "a_source", "a_range" ] ],
  dual_operation = "AdditiveInverseForMorphisms",
  return_type = "morphism",
  compatible_with_congruence_of_morphisms = true,
),

Coproduct = rec(
  filter_list = [ "category", "list_of_objects" ],
  return_type = "object",
  dual_operation = "DirectProduct",
  functorial = "CoproductFunctorial",
),

InjectionOfCofactorOfCoproduct = rec(
  filter_list = [ "category", "list_of_objects", IsInt ],
  io_type = [ [ "objects", "k" ], [ "objects_k", "P" ] ],
  with_given_object_position = "Range",
  return_type = "morphism",
  dual_operation = "ProjectionInFactorOfDirectProduct" ),

InjectionOfCofactorOfCoproductWithGivenCoproduct = rec(
  filter_list = [ "category", "list_of_objects", IsInt, "object" ],
  io_type = [ [ "objects", "k", "P" ], [ "objects_k", "P" ] ],
  return_type = "morphism",
  dual_operation = "ProjectionInFactorOfDirectProductWithGivenDirectProduct" ),

UniversalMorphismFromCoproduct = rec(
  filter_list = [ "category", "list_of_objects", "object", "list_of_morphisms" ],
  io_type = [ [ "objects",  "T", "tau" ], [ "P", "T" ] ],
  with_given_object_position = "Source",
  dual_operation = "UniversalMorphismIntoDirectProduct",
  
  pre_function = function( cat, diagram, test_object, sink )
    local current_morphism, current_return;
    
    for current_morphism in sink
        
        current_return = IsEqualForObjects( Range( current_morphism ), test_object );
        
        if current_return == fail
            
            return [ false, "can!decide whether ranges of morphisms ⥉ given sink diagram are equal to the test object" ];
            
        elseif current_return == false
            
            return [ false, "ranges of morphisms must be equal to the test object ⥉ given sink diagram" ];
            
        end;
        
    end;
    
    return [ true ];
    
  end,
  return_type = "morphism",
  compatible_with_congruence_of_morphisms = true,
),

UniversalMorphismFromCoproductWithGivenCoproduct = rec(
  filter_list = [ "category", "list_of_objects", "object", "list_of_morphisms", "object" ],
  io_type = [ [ "objects", "T", "tau", "P" ], [ "P", "T" ] ],
  dual_operation = "UniversalMorphismIntoDirectProductWithGivenDirectProduct",
  
  pre_function = function( cat, diagram, test_object, sink, coproduct )
    local current_morphism, current_return;
    
    for current_morphism in sink
        
        current_return = IsEqualForObjects( Range( current_morphism ), test_object );
        
        if current_return == fail
            
            return [ false, "can!decide whether ranges of morphisms ⥉ given sink diagram are equal to the test object" ];
            
        elseif current_return == false
            
            return [ false, "ranges of morphisms must be equal to the test object ⥉ given sink diagram" ];
            
        end;
        
    end;
    
    return [ true ];
    
  end,
  return_type = "morphism",
  compatible_with_congruence_of_morphisms = true,
),

IsEqualAsSubobjects = rec(
  filter_list = [ "category", "morphism", "morphism" ],
  well_defined_todo = false,
  return_type = "bool",
  dual_operation = "IsEqualAsFactorobjects",
  compatible_with_congruence_of_morphisms = true,
),

IsEqualAsFactorobjects = rec(
  filter_list = [ "category", "morphism", "morphism" ],
  well_defined_todo = false,
  return_type = "bool",
  dual_operation = "IsEqualAsSubobjects",
  compatible_with_congruence_of_morphisms = true,
),

IsDominating = rec(
  filter_list = [ "category", "morphism", "morphism" ],
  well_defined_todo = false,
  dual_operation = "IsCodominating",
  
  pre_function = function( cat, sub1, sub2 )
    local is_equal_for_objects;
    
    is_equal_for_objects = IsEqualForObjects( Range( sub1 ), Range( sub2 ) );
    
    if is_equal_for_objects == fail
        
        return [ false, "can!decide whether those are subobjects of the same object" ];
    
    elseif is_equal_for_objects == false
        
        return [ false, "subobjects of different objects are !comparable by dominates" ];
        
    end;
    
    return [ true ];
  end,
  return_type = "bool",
  compatible_with_congruence_of_morphisms = true,
),

IsCodominating = rec(
  filter_list = [ "category", "morphism", "morphism" ],
  well_defined_todo = false,
  dual_operation = "IsDominating",
  
  pre_function = function( cat, factor1, factor2 )
    local is_equal_for_objects;
    
    is_equal_for_objects = IsEqualForObjects( Source( factor1 ), Source( factor2 ) );
    
    if is_equal_for_objects == fail
        
        return [ false, "can!decide whether those are factors of the same object" ];
    
    elseif is_equal_for_objects == false
        
        return [ false, "factors of different objects are !comparable by codominates" ];
        
    end;
    
    return [ true ];
  end,
  return_type = "bool",
  compatible_with_congruence_of_morphisms = true,
),

Equalizer = rec(
  filter_list = [ "category", "object", "list_of_morphisms" ],
  return_type = "object",
  dual_operation = "Coequalizer",
  
  pre_function = function( cat, cobase, diagram )
    local base, current_morphism, current_value;
    
    if IsEmpty( diagram )
        
        return [ true ];
        
    end;
    
    for current_morphism in diagram[(2):(Length( diagram ))]
        
        current_value = IsEqualForObjects( Source( current_morphism ), cobase );
        
        if current_value == fail
            return [ false, "can!decide whether the given morphisms of the equalizer diagram have equal sources" ];
        elseif current_value == false
            return [ false, "the given morphisms of the equalizer diagram must have equal sources" ];
        end;
        
    end;
    
    base = Range( diagram[1] );
    
    for current_morphism in diagram[(2):(Length( diagram ))]
        
        current_value = IsEqualForObjects( Range( current_morphism ), base );
        
        if current_value == fail
            return [ false, "can!decide whether the given morphisms of the equalizer diagram have equal ranges" ];
        elseif current_value == false
            return [ false, "the given morphisms of the equalizer diagram must have equal ranges" ];
        end;
        
    end;
    
    return [ true ];
  end,
  compatible_with_congruence_of_morphisms = false,
  functorial = "EqualizerFunctorial",
),

EmbeddingOfEqualizer = rec(
  filter_list = [ "category", "object", "list_of_morphisms" ],
  return_type = "morphism",
  io_type = [ [ "Y", "morphisms" ], [ "P", "Y" ] ],
  with_given_object_position = "Source",
  dual_operation = "ProjectionOntoCoequalizer",
  
  pre_function = "Equalizer",
  compatible_with_congruence_of_morphisms = false,
),

EmbeddingOfEqualizerWithGivenEqualizer = rec(
  filter_list = [ "category", "object", "list_of_morphisms", "object" ],
  return_type = "morphism",
  io_type = [ [ "Y", "morphisms", "P" ], [ "P", "Y" ] ],
  dual_operation = "ProjectionOntoCoequalizerWithGivenCoequalizer",
  compatible_with_congruence_of_morphisms = false,
),

MorphismFromEqualizerToSink = rec(
  filter_list = [ "category", "object", "list_of_morphisms" ],
  io_type = [ [ "Y", "morphisms" ], [ "P", "morphisms_1_range" ] ],
  with_given_object_position = "Source",
  dual_operation = "MorphismFromSourceToCoequalizer",
  return_type = "morphism",
  compatible_with_congruence_of_morphisms = false,
),

MorphismFromEqualizerToSinkWithGivenEqualizer = rec(
  filter_list = [ "category", "object", "list_of_morphisms", "object" ],
  io_type = [ [ "Y", "morphisms", "P" ], [ "P", "morphisms_1_range" ] ],
  dual_operation = "MorphismFromSourceToCoequalizerWithGivenCoequalizer",
  return_type = "morphism",
  compatible_with_congruence_of_morphisms = false,
),

UniversalMorphismIntoEqualizer = rec(
  filter_list = [ "category", "object", "list_of_morphisms", "object", "morphism" ],
  io_type = [ [ "Y", "morphisms", "T", "tau" ], [ "T", "P" ] ],
  with_given_object_position = "Range",
  return_type = "morphism",
  dual_operation = "UniversalMorphismFromCoequalizer",
  
  pre_function = function( cat, cobase, diagram, test_object, tau )
    local base, current_morphism, current_value, current_morphism_position;
    
    if IsEmpty( diagram )
        
        return [ true ];
        
    end;
    
    for current_morphism in diagram[(2):(Length( diagram ))]
        
        current_value = IsEqualForObjects( Source( current_morphism ), cobase );
        
        if current_value == fail
            return [ false, "can!decide whether the given morphisms of the equalizer diagram have equal sources" ];
        elseif current_value == false
            return [ false, "the given morphisms of the equalizer diagram must have equal sources" ];
        end;
        
    end;
    
    base = Range( diagram[1] );
    
    for current_morphism in diagram[(2):(Length( diagram ))]
        
        current_value = IsEqualForObjects( Range( current_morphism ), base );
        
        if current_value == fail
            return [ false, "can!decide whether the given morphisms of the equalizer diagram have equal ranges" ];
        elseif current_value == false
            return [ false, "the given morphisms of the equalizer diagram must have equal ranges" ];
        end;
        
    end;
    
    for current_morphism_position in (1):(Length( diagram ))
        
        current_value = IsEqualForObjects( Source( diagram[ current_morphism_position ] ), Range( tau ) );
        
        if current_value == fail
            return [ false, Concatenation( "in diagram position ", string( current_morphism_position ), ": can!decide whether source && range are equal" ) ];
        elseif current_value == false
            return [ false, Concatenation( "in diagram position ", string( current_morphism_position ), ": source && range are !equal" ) ];
        end;
        
    end;
    
    return [ true ];
  end,
  compatible_with_congruence_of_morphisms = false,
),

UniversalMorphismIntoEqualizerWithGivenEqualizer = rec(
  filter_list = [ "category", "object", "list_of_morphisms", "object", "morphism", "object" ],
  io_type = [ [ "Y", "morphisms", "T", "tau", "P" ], [ "T", "P" ] ],
  return_type = "morphism",
  dual_operation = "UniversalMorphismFromCoequalizerWithGivenCoequalizer",
  compatible_with_congruence_of_morphisms = false,
),

FiberProduct = rec(
  filter_list = [ "category", "list_of_morphisms" ],
  dual_operation = "Pushout",
  
  pre_function = function( cat, diagram )
    local base, current_morphism, current_value;
    
    if IsEmpty( diagram )
        
        return [ true ];
        
    end;
    
    base = Range( diagram[1] );
    
    for current_morphism in diagram[(2):(Length( diagram ))]
        
        current_value = IsEqualForObjects( Range( current_morphism ), base );
        
        if current_value == fail
            return [ false, "can!decide whether the given morphisms of the fiber product diagram have equal ranges" ];
        elseif current_value == false
            return [ false, "the given morphisms of the fiber product diagram must have equal ranges" ];
        end;
        
    end;
    
    return [ true ];
  end,
  return_type = "object",
  compatible_with_congruence_of_morphisms = false,
  functorial = "FiberProductFunctorial",
),

ProjectionInFactorOfFiberProduct = rec(
  filter_list = [ "category", "list_of_morphisms", IsInt ],
  io_type = [ [ "morphisms", "k" ], [ "P", "morphisms_k_source" ] ],
  with_given_object_position = "Source",
  dual_operation = "InjectionOfCofactorOfPushout",
  
  pre_function = function( cat, diagram, projection_number )
    local base, current_morphism, current_value;
    
    if projection_number < 1 || projection_number > Length( diagram )
        return[ false, Concatenation( "there does !exist a ", string( projection_number ), "th projection" ) ];
    end;
    
    base = Range( diagram[1] );
    
    for current_morphism in diagram[(2):(Length( diagram ))]
        
        current_value = IsEqualForObjects( Range( current_morphism ), base );
        
        if current_value == fail
            return [ false, "can!decide whether the given morphisms of the fiber product diagram have equal ranges" ];
        elseif current_value == false
            return [ false, "the given morphisms of the fiber product diagram must have equal ranges" ];
        end;
        
    end;
    
    return [ true ];
  end,
  return_type = "morphism",
  compatible_with_congruence_of_morphisms = false,
),

ProjectionInFactorOfFiberProductWithGivenFiberProduct = rec(
  filter_list = [ "category", "list_of_morphisms", IsInt, "object" ],
  io_type = [ [ "morphisms", "k", "P" ], [ "P", "morphisms_k_source" ] ],
  dual_operation = "InjectionOfCofactorOfPushoutWithGivenPushout",
  
  pre_function = function( cat, diagram, projection_number, pullback )
    local base, current_morphism, current_value;
    
    if projection_number < 1 || projection_number > Length( diagram )
        return[ false, Concatenation( "there does !exist a ", string( projection_number ), "th projection" ) ];
    end;
    
    base = Range( diagram[1] );
    
    for current_morphism in diagram[(2):(Length( diagram ))]
        
        current_value = IsEqualForObjects( Range( current_morphism ), base );
        
        if current_value == fail
            return [ false, "can!decide whether the given morphisms of the fiber product diagram have equal ranges" ];
        elseif current_value == false
            return [ false, "the given morphisms of the fiber product diagram must have equal ranges" ];
        end;
        
    end;
    
    return [ true ];
  end,
  return_type = "morphism",
  compatible_with_congruence_of_morphisms = false,
),

MorphismFromFiberProductToSink = rec(
  filter_list = [ "category", "list_of_morphisms" ],
  io_type = [ [ "morphisms" ], [ "P", "morphisms_1_range" ] ],
  with_given_object_position = "Source",
  dual_operation = "MorphismFromSourceToPushout",
  
  pre_function = function( cat, diagram )
    local base, current_morphism, current_value;
    
    base = Range( diagram[1] );
    
    for current_morphism in diagram[(2):(Length( diagram ))]
        
        current_value = IsEqualForObjects( Range( current_morphism ), base );
        
        if current_value == fail
            return [ false, "can!decide whether the given morphisms of the fiber product diagram have equal ranges" ];
        elseif current_value == false
            return [ false, "the given morphisms of the fiber product diagram must have equal ranges" ];
        end;
        
    end;
    
    return [ true ];
  end,
  return_type = "morphism",
  compatible_with_congruence_of_morphisms = false,
),

MorphismFromFiberProductToSinkWithGivenFiberProduct = rec(
  filter_list = [ "category", "list_of_morphisms", "object" ],
  io_type = [ [ "morphisms", "P" ], [ "P", "morphisms_1_range" ] ],
  dual_operation = "MorphismFromSourceToPushoutWithGivenPushout",
  
  pre_function = function( cat, diagram, pullback )
    local base, current_morphism, current_value;
    
    base = Range( diagram[1] );
    
    for current_morphism in diagram[(2):(Length( diagram ))]
        
        current_value = IsEqualForObjects( Range( current_morphism ), base );
        
        if current_value == fail
            return [ false, "can!decide whether the given morphisms of the fiber product diagram have equal ranges" ];
        elseif current_value == false
            return [ false, "the given morphisms of the fiber product diagram must have equal ranges" ];
        end;
        
    end;
    
    return [ true ];
  end,
  return_type = "morphism",
  compatible_with_congruence_of_morphisms = false,
),

UniversalMorphismIntoFiberProduct = rec(
  filter_list = [ "category", "list_of_morphisms", "object", "list_of_morphisms" ],
  io_type = [ [ "morphisms", "T", "tau" ], [ "T", "P" ] ],
  with_given_object_position = "Range",
  dual_operation = "UniversalMorphismFromPushout",
  
  pre_function = function( cat, diagram, test_object, source )
    local base, current_morphism, current_value, current_morphism_position;
    
    if Length( diagram ) != Length( source )
        return [ false, "fiber product diagram && test diagram must have equal length" ];
    end;
    
    if IsEmpty( diagram )
        
        return [ true ];
        
    end;
    
    base = Range( diagram[1] );
    
    for current_morphism in diagram[(2):(Length( diagram ))]
        
        current_value = IsEqualForObjects( Range( current_morphism ), base );
        
        if current_value == fail
            return [ false, "can!decide whether the given morphisms of the fiber product diagram have equal ranges" ];
        elseif current_value == false
            return [ false, "the given morphisms of the fiber product diagram must have equal ranges" ];
        end;
        
    end;
    
    for current_morphism in source
        
        current_value = IsEqualForObjects( Source( current_morphism ), test_object );
        
        if current_value == fail
            return [ false, "can!decide whether the given morphisms of the test source have sources equal to the test object" ];
        elseif current_value == false
            return [ false, "the given morphisms of the test source do !have sources equal to the test object" ];
        end;
        
    end;
    
    for current_morphism_position in (1):(Length( diagram ))
        
        current_value = IsEqualForObjects( Source( diagram[ current_morphism_position ] ), Range( source[ current_morphism_position ] ) );
        
        if current_value == fail
            return [ false, Concatenation( "in diagram position ", string( current_morphism_position ), ": can!decide whether source && range are equal" ) ];
        elseif current_value == false
            return [ false, Concatenation( "in diagram position ", string( current_morphism_position ), ": source && range are !equal" ) ];
        end;
        
    end;
    
    return [ true ];
  end,
  return_type = "morphism",
  compatible_with_congruence_of_morphisms = false,
),

UniversalMorphismIntoFiberProductWithGivenFiberProduct = rec(
  filter_list = [ "category", "list_of_morphisms", "object", "list_of_morphisms", "object" ],
  io_type = [ [ "morphisms", "T", "tau", "P" ], [ "T", "P" ] ],
  dual_operation = "UniversalMorphismFromPushoutWithGivenPushout",
  
  pre_function = function( cat, diagram, test_object, source, pullback )
    local base, current_morphism, current_value, current_morphism_position;
    
    if Length( diagram ) != Length( source )
        return [ false, "fiber product diagram && test diagram must have equal length" ];
    end;
    
    if IsEmpty( diagram )
        
        return [ true ];
        
    end;
    
    base = Range( diagram[1] );
    
    for current_morphism in diagram[(2):(Length( diagram ))]
        
        current_value = IsEqualForObjects( Range( current_morphism ), base );
        
        if current_value == fail
            return [ false, "can!decide whether the given morphisms of the fiber product diagram have equal ranges" ];
        elseif current_value == false
            return [ false, "the given morphisms of the fiber product diagram must have equal ranges" ];
        end;
        
    end;
    
    for current_morphism in source
        
        current_value = IsEqualForObjects( Source( current_morphism ), test_object );
        
        if current_value == fail
            return [ false, "can!decide whether the given morphisms of the test source have sources equal to the test object" ];
        elseif current_value == false
            return [ false, "the given morphisms of the test source do !have sources equal to the test object" ];
        end;
        
    end;
    
    for current_morphism_position in (1):(Length( diagram ))
        
        current_value = IsEqualForObjects( Source( diagram[ current_morphism_position ] ), Range( source[ current_morphism_position ] ) );
        
        if current_value == fail
            return [ false, Concatenation( "in diagram position ", string( current_morphism_position ), ": can!decide whether source && range are equal" ) ];
        elseif current_value == false
            return [ false, Concatenation( "in diagram position ", string( current_morphism_position ), ": source && range are !equal" ) ];
        end;
        
    end;
    
    return [ true ];
  end,
  return_type = "morphism",
  compatible_with_congruence_of_morphisms = false,
),

Coequalizer = rec(
  filter_list = [ "category", "object", "list_of_morphisms" ],
  return_type = "object",
  dual_operation = "Equalizer",
  
  pre_function = function( cat, cobase, diagram )
    local base, current_morphism, current_value;
    
    if IsEmpty( diagram )
        
        return [ true ];
        
    end;
    
    base = Source( diagram[1] );
    
    for current_morphism in diagram[(2):(Length( diagram ))]
        
        current_value = IsEqualForObjects( Source( current_morphism ), base );
        
        if current_value == fail
            return [ false, "can!decide whether the given morphisms of the coequalizer diagram have equal sources" ];
        elseif current_value == false
            return [ false, "the given morphisms of the coequalizer diagram must have equal sources" ];
        end;
        
    end;
    
    for current_morphism in diagram[(2):(Length( diagram ))]
        
        current_value = IsEqualForObjects( Range( current_morphism ), cobase );
        
        if current_value == fail
            return [ false, "can!decide whether the given morphisms of the coequalizer diagram have equal ranges" ];
        elseif current_value == false
            return [ false, "the given morphisms of the coequalizer diagram must have equal ranges" ];
        end;
        
    end;
    
    return [ true ];
  end,
  compatible_with_congruence_of_morphisms = false,
  functorial = "CoequalizerFunctorial",
),

ProjectionOntoCoequalizer = rec(
  filter_list = [ "category", "object", "list_of_morphisms" ],
  return_type = "morphism",
  io_type = [ [ "Y", "morphisms" ], [ "Y", "P" ] ],
  with_given_object_position = "Range",
  dual_operation = "EmbeddingOfEqualizer",
  
  pre_function = "Coequalizer",
  compatible_with_congruence_of_morphisms = false,
),

ProjectionOntoCoequalizerWithGivenCoequalizer = rec(
  filter_list = [ "category", "object", "list_of_morphisms", "object" ],
  return_type = "morphism",
  io_type = [ [ "Y", "morphisms", "P" ], [ "Y", "P" ] ],
  dual_operation = "EmbeddingOfEqualizerWithGivenEqualizer",
  compatible_with_congruence_of_morphisms = false,
),

MorphismFromSourceToCoequalizer = rec(
  filter_list = [ "category", "object", "list_of_morphisms" ],
  io_type = [ [ "Y", "morphisms" ], [ "morphisms_1_source", "P" ] ],
  with_given_object_position = "Range",
  dual_operation = "MorphismFromEqualizerToSink",
  return_type = "morphism",
  compatible_with_congruence_of_morphisms = false,
),

MorphismFromSourceToCoequalizerWithGivenCoequalizer = rec(
  filter_list = [ "category", "object", "list_of_morphisms", "object" ],
  io_type = [ [ "Y", "morphisms", "P" ], [ "morphisms_1_source", "P" ] ],
  dual_operation = "MorphismFromEqualizerToSinkWithGivenEqualizer",
  return_type = "morphism",
  compatible_with_congruence_of_morphisms = false,
),

UniversalMorphismFromCoequalizer = rec(
  filter_list = [ "category", "object", "list_of_morphisms", "object", "morphism" ],
  io_type = [ [ "Y", "morphisms", "T", "tau" ], [ "P", "T" ] ],
  with_given_object_position = "Source",
  return_type = "morphism",
  dual_operation = "UniversalMorphismIntoEqualizer",
  
  pre_function = function( cat, cobase, diagram, test_object, tau )
    local base, current_morphism, current_value, current_morphism_position;
    
    if IsEmpty( diagram )
        
        return [ true ];
        
    end;
    
    base = Source( diagram[1] );
    
    for current_morphism in diagram[(2):(Length( diagram ))]
        
        current_value = IsEqualForObjects( Source( current_morphism ), base );
        
        if current_value == fail
            return [ false, "can!decide whether the given morphisms of the coequalizer diagram have equal sources" ];
        elseif current_value == false
            return [ false, "the given morphisms of the coequalizer diagram must have equal sources" ];
        end;
        
    end;
    
    for current_morphism in diagram[(2):(Length( diagram ))]
        
        current_value = IsEqualForObjects( Range( current_morphism ), cobase );
        
        if current_value == fail
            return [ false, "can!decide whether the given morphisms of the coequalizer diagram have equal ranges" ];
        elseif current_value == false
            return [ false, "the given morphisms of the coequalizer diagram must have equal ranges" ];
        end;
        
    end;
    
    for current_morphism_position in (1):(Length( diagram ))
        
        current_value = IsEqualForObjects( Range( diagram[ current_morphism_position ] ), Source( tau ) );
        
        if current_value == fail
            return [ false, Concatenation( "in diagram position ", string( current_morphism_position ), ": can!decide whether range && source are equal" ) ];
        elseif current_value == false
            return [ false, Concatenation( "in diagram position ", string( current_morphism_position ), ": range && source are !equal" ) ];
        end;
        
    end;
    
    return [ true ];
  end,
  compatible_with_congruence_of_morphisms = false,
),

UniversalMorphismFromCoequalizerWithGivenCoequalizer = rec(
  filter_list = [ "category", "object", "list_of_morphisms", "object", "morphism", "object" ],
  io_type = [ [ "Y", "morphisms", "T", "tau", "P" ], [ "P", "T" ] ],
  return_type = "morphism",
  dual_operation = "UniversalMorphismIntoEqualizerWithGivenEqualizer",
  compatible_with_congruence_of_morphisms = false,
),

Pushout = rec(
  filter_list = [ "category", "list_of_morphisms" ],
  dual_operation = "FiberProduct",
  
  pre_function = function( cat, diagram )
    local cobase, current_morphism, current_value;
    
    if IsEmpty( diagram )
        
        return [ true ];
        
    end;
    
    cobase = Source( diagram[1] );
    
    for current_morphism in diagram[(2):(Length( diagram ))]
        
        current_value = IsEqualForObjects( Source( current_morphism ), cobase );
        
        if current_value == fail
            return [ false, "can!decide whether the given morphisms of the pushout diagram have equal sources" ];
        elseif current_value == false
            return [ false, "the given morphisms of the pushout diagram must have equal sources" ];
        end;
        
    end;
    
    return [ true ];
  end,
  return_type = "object",
  compatible_with_congruence_of_morphisms = false,
  functorial = "PushoutFunctorial",
),

InjectionOfCofactorOfPushout = rec(
  filter_list = [ "category", "list_of_morphisms", IsInt ],
  io_type = [ [ "morphisms", "k" ], [ "morphisms_k_range", "P" ] ],
  with_given_object_position = "Range",
  dual_operation = "ProjectionInFactorOfFiberProduct",
  
  pre_function = function( cat, diagram, injection_number )
    local cobase, current_morphism, current_value;
    
    if injection_number < 1 || injection_number > Length( diagram )
        return[ false, Concatenation( "there does !exist a ", string( injection_number ), "th injection" ) ];
    end;
    
    cobase = Source( diagram[1] );
    
    for current_morphism in diagram[(2):(Length( diagram ))]
        
        current_value = IsEqualForObjects( Source( current_morphism ), cobase );
        
        if current_value == fail
            return [ false, "can!decide whether the given morphisms of the pushout diagram have equal sources" ];
        elseif current_value == false
            return [ false, "the given morphisms of the pushout diagram must have equal sources" ];
        end;
        
    end;
    
    return [ true ];
  end,
  return_type = "morphism",
  compatible_with_congruence_of_morphisms = false,
),

InjectionOfCofactorOfPushoutWithGivenPushout = rec(
  filter_list = [ "category", "list_of_morphisms", IsInt, "object" ],
  io_type = [ [ "morphisms", "k", "P" ], [ "morphisms_k_range", "P" ] ],
  dual_operation = "ProjectionInFactorOfFiberProductWithGivenFiberProduct",
  
  pre_function = function( cat, diagram, injection_number, pushout )
    local cobase, current_morphism, current_value;
    
    if injection_number < 1 || injection_number > Length( diagram )
        return[ false, Concatenation( "there does !exist a ", string( injection_number ), "th injection" ) ];
    end;
    
    cobase = Source( diagram[1] );
    
    for current_morphism in diagram[(2):(Length( diagram ))]
        
        current_value = IsEqualForObjects( Source( current_morphism ), cobase );
        
        if current_value == fail
            return [ false, "can!decide whether the given morphisms of the pushout diagram have equal sources" ];
        elseif current_value == false
            return [ false, "the given morphisms of the pushout diagram must have equal sources" ];
        end;
        
    end;
    
    return [ true ];
  end,
  return_type = "morphism",
  compatible_with_congruence_of_morphisms = false,
),

MorphismFromSourceToPushout = rec(
  filter_list = [ "category", "list_of_morphisms" ],
  io_type = [ [ "morphisms" ], [ "morphisms_1_source", "P" ] ],
  with_given_object_position = "Range",
  dual_operation = "MorphismFromFiberProductToSink",
  
  pre_function = function( cat, diagram )
    local cobase, current_morphism, current_value;
    
    cobase = Source( diagram[1] );
    
    for current_morphism in diagram[(2):(Length( diagram ))]
        
        current_value = IsEqualForObjects( Source( current_morphism ), cobase );
        
        if current_value == fail
            return [ false, "can!decide whether the given morphisms of the pushout diagram have equal sources" ];
        elseif current_value == false
            return [ false, "the given morphisms of the pushout diagram must have equal sources" ];
        end;
        
    end;
    
    return [ true ];
  end,
  return_type = "morphism",
  compatible_with_congruence_of_morphisms = false,
),

MorphismFromSourceToPushoutWithGivenPushout = rec(
  filter_list = [ "category", "list_of_morphisms", "object" ],
  io_type = [ [ "morphisms", "P" ], [ "morphisms_1_source", "P" ] ],
  dual_operation = "MorphismFromFiberProductToSinkWithGivenFiberProduct",
  
  pre_function = function( cat, diagram, pushout )
    local cobase, current_morphism, current_value;
    
    cobase = Source( diagram[1] );
    
    for current_morphism in diagram[(2):(Length( diagram ))]
        
        current_value = IsEqualForObjects( Source( current_morphism ), cobase );
        
        if current_value == fail
            return [ false, "can!decide whether the given morphisms of the pushout diagram have equal sources" ];
        elseif current_value == false
            return [ false, "the given morphisms of the pushout diagram must have equal sources" ];
        end;
        
    end;
    
    return [ true ];
  end,
  return_type = "morphism",
  compatible_with_congruence_of_morphisms = false,
),

UniversalMorphismFromPushout = rec(
  filter_list = [ "category", "list_of_morphisms", "object", "list_of_morphisms" ],
  io_type = [ [ "morphisms", "T", "tau" ], [ "P", "T" ] ],
  with_given_object_position = "Source",
  dual_operation = "UniversalMorphismIntoFiberProduct",
  
  pre_function = function( cat, diagram, test_object, sink )
    local cobase, current_morphism, current_value, current_morphism_position;
    
    if Length( diagram ) != Length( sink )
        return [ false, "pushout diagram && test diagram must have equal length" ];
    end;
    
    if IsEmpty( diagram )
        
        return [ true ];
        
    end;
    
    cobase = Source( diagram[1] );
    
    for current_morphism in diagram[(2):(Length( diagram ))]
        
        current_value = IsEqualForObjects( Source( current_morphism ), cobase );
        
        if current_value == fail
            return [ false, "can!decide whether the given morphisms of the pushout diagram have equal sources" ];
        elseif current_value == false
            return [ false, "the given morphisms of the fiber pushout must have equal sources" ];
        end;
        
    end;
    
    for current_morphism in sink
        
        current_value = IsEqualForObjects( Range( current_morphism ), test_object );
        
        if current_value == fail
            return [ false, "can!decide whether the given morphisms of the test sink have ranges equal to the test object" ];
        elseif current_value == false
            return [ false, "the given morphisms of the test sink do !have ranges equal to the test object" ];
        end;
        
    end;
    
    for current_morphism_position in (1):(Length( diagram ))
        
        current_value = IsEqualForObjects( Range( diagram[ current_morphism_position ] ), Source( sink[ current_morphism_position ] ) );
        
        if current_value == fail
            return [ false, Concatenation( "in diagram position ", string( current_morphism_position ), ": can!decide whether source && range are equal" ) ];
        elseif current_value == false
            return [ false, Concatenation( "in diagram position ", string( current_morphism_position ), ": source && range are !equal" ) ];
        end;
        
    end;
    
    return [ true ];
  end,
  return_type = "morphism",
  compatible_with_congruence_of_morphisms = false,
),

UniversalMorphismFromPushoutWithGivenPushout = rec(
  filter_list = [ "category", "list_of_morphisms", "object", "list_of_morphisms", "object" ],
  io_type = [ [ "morphisms", "T", "tau", "P" ], [ "P", "T" ] ],
  dual_operation = "UniversalMorphismIntoFiberProductWithGivenFiberProduct",
  
  pre_function = function( cat, diagram, test_object, sink, pushout )
    local cobase, current_morphism, current_value, current_morphism_position;
    
    if Length( diagram ) != Length( sink )
        return [ false, "pushout diagram && test diagram must have equal length" ];
    end;
    
    if IsEmpty( diagram )
        
        return [ true ];
        
    end;
    
    cobase = Source( diagram[1] );
    
    for current_morphism in diagram[(2):(Length( diagram ))]
        
        current_value = IsEqualForObjects( Source( current_morphism ), cobase );
        
        if current_value == fail
            return [ false, "can!decide whether the given morphisms of the pushout diagram have equal sources" ];
        elseif current_value == false
            return [ false, "the given morphisms of the fiber pushout must have equal sources" ];
        end;
        
    end;
    
    for current_morphism in sink
        
        current_value = IsEqualForObjects( Range( current_morphism ), test_object );
        
        if current_value == fail
            return [ false, "can!decide whether the given morphisms of the test sink have ranges equal to the test object" ];
        elseif current_value == false
            return [ false, "the given morphisms of the test sink do !have ranges equal to the test object" ];
        end;
        
    end;
    
    for current_morphism_position in (1):(Length( diagram ))
        
        current_value = IsEqualForObjects( Range( diagram[ current_morphism_position ] ), Source( sink[ current_morphism_position ] ) );
        
        if current_value == fail
            return [ false, Concatenation( "in diagram position ", string( current_morphism_position ), ": can!decide whether source && range are equal" ) ];
        elseif current_value == false
            return [ false, Concatenation( "in diagram position ", string( current_morphism_position ), ": source && range are !equal" ) ];
        end;
        
    end;
    
    return [ true ];
  end,
  return_type = "morphism",
  compatible_with_congruence_of_morphisms = false,
),

ImageObject = rec(
  filter_list = [ "category", "morphism" ],
  return_type = "object",
  dual_operation = "CoimageObject" ),

ImageEmbedding = rec(
  filter_list = [ "category", "morphism" ],
  io_type = [ [ "alpha" ], [ "I", "alpha_range" ] ],
  with_given_object_position = "Source",
  return_type = "morphism",
  dual_operation = "CoimageProjection" ),

ImageEmbeddingWithGivenImageObject = rec(
  filter_list = [ "category", "morphism", "object" ],
  io_type = [ [ "alpha", "I" ], [ "I", "alpha_range" ] ],
  return_type = "morphism",
  dual_operation = "CoimageProjectionWithGivenCoimageObject" ),

CoimageObject = rec(
  filter_list = [ "category", "morphism" ],
  return_type = "object",
  dual_operation = "ImageObject" ),

CoimageProjection = rec(
  filter_list = [ "category", "morphism" ],
  io_type = [ [ "alpha" ], [ "alpha_source", "C" ] ],
  with_given_object_position = "Range",
  return_type = "morphism",
  dual_operation = "ImageEmbedding" ),

CoimageProjectionWithGivenCoimageObject = rec(
  filter_list = [ "category", "morphism", "object" ],
  io_type = [ [ "alpha", "C" ], [ "alpha_source", "C" ] ],
  return_type = "morphism",
  dual_operation = "ImageEmbeddingWithGivenImageObject" ),

AstrictionToCoimage = rec(
  filter_list = [ "category", "morphism" ],
  io_type = [ [ "alpha" ], [ "C", "alpha_range" ] ],
  with_given_object_position = "Source",
  return_type = "morphism",
  dual_operation = "CoastrictionToImage" ),

AstrictionToCoimageWithGivenCoimageObject = rec(
  filter_list = [ "category", "morphism", "object" ],
  io_type = [ [ "alpha", "C" ], [ "C", "alpha_range" ] ],
  return_type = "morphism",
  dual_operation = "CoastrictionToImageWithGivenImageObject" ),

UniversalMorphismIntoCoimage = rec(
  filter_list = [ "category", "morphism", "list_of_morphisms" ],
  io_type = [ [ "alpha", "tau" ], [ "tau_1_range", "C" ] ],
  with_given_object_position = "Range",
  dual_preprocessor_func = CAP_INTERNAL_REVERSE_LISTS_IN_ARGUMENTS_FOR_OPPOSITE,
  pre_function = function( cat, morphism, test_factorization )
    local value;
    
    value = IsEqualForObjects( Source( morphism ), Source( test_factorization[ 1 ] ) );
    if value == fail
        return [ false, "can!decide whether source of morphism && test factorization are equal" ];
    elseif value == false
        return [ false, "source of morphism && test factorization are !equal" ];
    end;
    
    value = IsEqualForObjects( Range( morphism ), Range( test_factorization[ 2 ] ) );
    if value == fail
        return [ false, "can!decide whether range of morphism && test factorization are equal" ];
    elseif value == false
        return [ false, "range of morphism && test factorization are !equal" ];
    end;
    
    value = IsEqualForObjects( Range( test_factorization[ 1 ] ), Source( test_factorization[ 2 ] ) );
    if value == fail
        return [ false, "can!decide whether source && range of test factorization are equal" ];
    elseif value == false
        return [ false, "source && range of test factorization are !equal" ];
    end;
    
    return [ true ];
  end,
  return_type = "morphism",
  dual_operation = "UniversalMorphismFromImage" ),

UniversalMorphismIntoCoimageWithGivenCoimageObject = rec(
  filter_list = [ "category", "morphism", "list_of_morphisms", "object" ],
  io_type = [ [ "alpha", "tau", "C" ], [ "tau_1_range", "C" ] ],
  dual_preprocessor_func = CAP_INTERNAL_REVERSE_LISTS_IN_ARGUMENTS_FOR_OPPOSITE,
  pre_function = function( cat, morphism, test_factorization, image )
    local value;
    
    value = IsEqualForObjects( Source( morphism ), Source( test_factorization[ 1 ] ) );
    if value == fail
        return [ false, "can!decide whether source of morphism && test factorization are equal" ];
    elseif value == false
        return [ false, "source of morphism && test factorization are !equal" ];
    end;
    
    value = IsEqualForObjects( Range( morphism ), Range( test_factorization[ 2 ] ) );
    if value == fail
        return [ false, "can!decide whether range of morphism && test factorization are equal" ];
    elseif value == false
        return [ false, "range of morphism && test factorization are !equal" ];
    end;
    
    value = IsEqualForObjects( Range( test_factorization[ 1 ] ), Source( test_factorization[ 2 ] ) );
    if value == fail
        return [ false, "can!decide whether source && range of test factorization are equal" ];
    elseif value == false
        return [ false, "source && range of test factorization are !equal" ];
    end;
    
    return [ true ];
  end,
  return_type = "morphism",
  dual_operation = "UniversalMorphismFromImageWithGivenImageObject" ),

MorphismFromCoimageToImageWithGivenObjects = rec(
  filter_list = [ "category", "object", "morphism", "object" ],
  io_type = [ [ "C", "alpha", "I" ], [ "C", "I" ] ],
  dual_operation = "MorphismFromCoimageToImageWithGivenObjects",
  dual_arguments_reversed = true,
  return_type = "morphism" ),

InverseMorphismFromCoimageToImageWithGivenObjects = rec(
  filter_list = [ "category", "object", "morphism", "object" ],
  io_type = [ [ "C", "alpha", "I" ], [ "I", "C" ] ],
  dual_operation = "InverseMorphismFromCoimageToImageWithGivenObjects",
  dual_arguments_reversed = true,
  return_type = "morphism" ),

IsWellDefinedForMorphisms = rec(
  filter_list = [ "category", "morphism" ],
  well_defined_todo = false,
  dual_operation = "IsWellDefinedForMorphisms",
  
  redirect_function = function( cat, morphism )
    local category, source, range;
    
    source = Source( morphism );
    
    range = Range( morphism );
    
    category = CapCategory( morphism );
    
    if !( IsWellDefined( source ) && IsWellDefined( range ) ) ||
       !( IsIdenticalObj( CapCategory( source ), category ) && IsIdenticalObj( CapCategory( range ), category ) )
      
      return [ true, false ];
      
      
    else
      
      return [ false ];
      
    end;
    
  end,
  
  return_type = "bool" ),

IsWellDefinedForObjects = rec(
  filter_list = [ "category", "object" ],
  well_defined_todo = false,
  dual_operation = "IsWellDefinedForObjects",
  return_type = "bool" ),

IsZeroForObjects = rec(
  filter_list = [ "category", "object" ],
  well_defined_todo = false,
  return_type = "bool",
  dual_operation = "IsZeroForObjects",
  property_of = "object" ),

IsMonomorphism = rec(
  filter_list = [ "category", "morphism" ],
  well_defined_todo = false,
  return_type = "bool",
  dual_operation = "IsEpimorphism",
  property_of = "morphism",
  is_reflected_by_faithful_functor = true ),

IsEpimorphism = rec(
  filter_list = [ "category", "morphism" ],
  well_defined_todo = false,
  return_type = "bool",
  dual_operation = "IsMonomorphism",
  property_of = "morphism",
  is_reflected_by_faithful_functor = true ),

IsIsomorphism = rec(
  filter_list = [ "category", "morphism" ],
  well_defined_todo = false,
  dual_operation = "IsIsomorphism",
  return_type = "bool",
  property_of = "morphism" ),

IsEndomorphism = rec(
  filter_list = [ "category", "morphism" ],
  well_defined_todo = false,
  return_type = "bool",
  dual_operation = "IsEndomorphism",
  property_of = "morphism" ),

IsAutomorphism = rec(
  filter_list = [ "category", "morphism" ],
  well_defined_todo = false,
  return_type = "bool",
  dual_operation = "IsAutomorphism",
  property_of = "morphism" ),

IsOne = rec(
  filter_list = [ "category", "morphism" ],
  well_defined_todo = false,
  return_type = "bool",
  property_of = "morphism",
  dual_operation = "IsOne",
  pre_function = function( cat, morphism )
    local is_equal_for_objects;
    
    is_equal_for_objects = IsEqualForObjects( Source( morphism ), Range( morphism ) );
    
    if is_equal_for_objects == fail
      
      return [ false, "can!decide whether morphism is the identity" ];
      
    end;
    
    if is_equal_for_objects == false
        
        return [ false, "source && range of the given morphism are !equal" ];
        
    end;
    
    return [ true ];
  end ),

IsSplitMonomorphism = rec(
  filter_list = [ "category", "morphism" ],
  well_defined_todo = false,
  return_type = "bool",
  dual_operation = "IsSplitEpimorphism",
  property_of = "morphism" ),

IsSplitEpimorphism = rec(
  filter_list = [ "category", "morphism" ],
  well_defined_todo = false,
  return_type = "bool",
  dual_operation = "IsSplitMonomorphism",
  property_of = "morphism" ),

IsIdempotent = rec(
   pre_function = function( cat, morphism )
    
    # do !use IsEndomorphism( morphism ) here because you don't know if
    # the user has given an own IsEndomorphism function
    if !IsEqualForObjects( Source( morphism ), Range( morphism ) )
      
      return [ false, "the given morphism has to be an endomorphism" ];
      
    end;
    
    return [ true ];
  end,
  filter_list = [ "category", "morphism" ],
  well_defined_todo = false,
  return_type = "bool",
  dual_operation = "IsIdempotent",
  property_of = "morphism" ),

IsBijectiveObject = rec(
  filter_list = [ "category", "object" ],
  well_defined_todo = false,
  return_type = "bool",
  dual_operation = "IsBijectiveObject",
  property_of = "object" ),

IsProjective = rec(
  filter_list = [ "category", "object" ],
  well_defined_todo = false,
  return_type = "bool",
  dual_operation = "IsInjective",
  property_of = "object" ),

IsInjective = rec(
  filter_list = [ "category", "object" ],
  well_defined_todo = false,
  return_type = "bool",
  dual_operation = "IsProjective",
  property_of = "object" ),

IsTerminal = rec(
  filter_list = [ "category", "object" ],
  well_defined_todo = false,
  return_type = "bool",
  dual_operation = "IsInitial",
  property_of = "object" ),

IsInitial = rec(
  filter_list = [ "category", "object" ],
  well_defined_todo = false,
  return_type = "bool",
  dual_operation = "IsTerminal",
  property_of = "object" ),

IsEqualToIdentityMorphism = rec(
  filter_list = [ "category", "morphism" ],
  well_defined_todo = false,
  return_type = "bool",
  dual_operation = "IsEqualToIdentityMorphism",
  property_of = "morphism" ),

IsEqualToZeroMorphism = rec(
  filter_list = [ "category", "morphism" ],
  well_defined_todo = false,
  return_type = "bool",
  dual_operation = "IsEqualToZeroMorphism",
  property_of = "morphism" ),

CoastrictionToImage = rec(
  filter_list = [ "category", "morphism" ],
  io_type = [ [ "alpha" ], [ "alpha_source", "I" ] ],
  with_given_object_position = "Range",
  return_type = "morphism",
  dual_operation = "AstrictionToCoimage" ),

CoastrictionToImageWithGivenImageObject = rec(
  filter_list = [ "category", "morphism", "object" ],
  io_type = [ [ "alpha", "I" ], [ "alpha_source", "I" ] ],
  return_type = "morphism",
  dual_operation = "AstrictionToCoimageWithGivenCoimageObject" ),

UniversalMorphismFromImage = rec(
  filter_list = [ "category", "morphism", "list_of_morphisms" ],
  io_type = [ [ "alpha", "tau" ], [ "I", "tau_1_range" ] ],
  with_given_object_position = "Source",
  dual_operation = "UniversalMorphismIntoCoimage",
  dual_preprocessor_func = CAP_INTERNAL_REVERSE_LISTS_IN_ARGUMENTS_FOR_OPPOSITE,
  pre_function = function( cat, morphism, test_factorization )
    local value;
    
    value = IsEqualForObjects( Source( morphism ), Source( test_factorization[ 1 ] ) );
    if value == fail
        return [ false, "can!decide whether source of morphism && test factorization are equal" ];
    elseif value == false
        return [ false, "source of morphism && test factorization are !equal" ];
    end;
    
    value = IsEqualForObjects( Range( morphism ), Range( test_factorization[ 2 ] ) );
    if value == fail
        return [ false, "can!decide whether range of morphism && test factorization are equal" ];
    elseif value == false
        return [ false, "range of morphism && test factorization are !equal" ];
    end;
    
    value = IsEqualForObjects( Range( test_factorization[ 1 ] ), Source( test_factorization[ 2 ] ) );
    if value == fail
        return [ false, "can!decide whether source && range of test factorization are equal" ];
    elseif value == false
        return [ false, "source && range of test factorization are !equal" ];
    end;
    
    return [ true ];
  end,
  return_type = "morphism" ),

UniversalMorphismFromImageWithGivenImageObject = rec(
  filter_list = [ "category", "morphism", "list_of_morphisms", "object" ],
  io_type = [ [ "alpha", "tau", "I" ], [ "I", "tau_1_range" ] ],
  dual_operation = "UniversalMorphismIntoCoimageWithGivenCoimageObject",
  dual_preprocessor_func = CAP_INTERNAL_REVERSE_LISTS_IN_ARGUMENTS_FOR_OPPOSITE,
  pre_function = function( cat, morphism, test_factorization, image )
    local value;
    
    value = IsEqualForObjects( Source( morphism ), Source( test_factorization[ 1 ] ) );
    if value == fail
        return [ false, "can!decide whether source of morphism && test factorization are equal" ];
    elseif value == false
        return [ false, "source of morphism && test factorization are !equal" ];
    end;
    
    value = IsEqualForObjects( Range( morphism ), Range( test_factorization[ 2 ] ) );
    if value == fail
        return [ false, "can!decide whether range of morphism && test factorization are equal" ];
    elseif value == false
        return [ false, "range of morphism && test factorization are !equal" ];
    end;
    
    value = IsEqualForObjects( Range( test_factorization[ 1 ] ), Source( test_factorization[ 2 ] ) );
    if value == fail
        return [ false, "can!decide whether source && range of test factorization are equal" ];
    elseif value == false
        return [ false, "source && range of test factorization are !equal" ];
    end;
    
    return [ true ];
  end,
  return_type = "morphism" ),

KernelObjectFunctorial = rec(
  filter_list = [ "category", "morphism", "morphism", "morphism" ],
  input_arguments_names = [ "cat", "alpha", "mu", "alphap" ],
  return_type = "morphism",
  output_source_getter_string = "KernelObject( cat, alpha )",
  output_range_getter_string = "KernelObject( cat, alphap )",
  with_given_object_position = "both",
  dual_operation = "CokernelObjectFunctorial",
  dual_arguments_reversed = true,
  compatible_with_congruence_of_morphisms = false,
),

KernelObjectFunctorialWithGivenKernelObjects = rec(
  filter_list = [ "category", "object", "morphism", "morphism", "morphism", "object" ],
  io_type = [ [ "P", "alpha", "mu", "alphap", "Pp" ], [ "P", "Pp" ] ],
  return_type = "morphism",
  dual_operation = "CokernelObjectFunctorialWithGivenCokernelObjects",
  dual_arguments_reversed = true,
  compatible_with_congruence_of_morphisms = false,
),

CokernelObjectFunctorial = rec(
  filter_list = [ "category", "morphism", "morphism", "morphism" ],
  input_arguments_names = [ "cat", "alpha", "mu", "alphap" ],
  return_type = "morphism",
  output_source_getter_string = "CokernelObject( cat, alpha )",
  output_range_getter_string = "CokernelObject( cat, alphap )",
  with_given_object_position = "both",
  dual_operation = "KernelObjectFunctorial",
  dual_arguments_reversed = true,
  compatible_with_congruence_of_morphisms = false,
),

CokernelObjectFunctorialWithGivenCokernelObjects = rec(
  filter_list = [ "category", "object", "morphism", "morphism", "morphism", "object" ],
  io_type = [ [ "P", "alpha", "mu", "alphap", "Pp" ], [ "P", "Pp" ] ],
  return_type = "morphism",
  dual_operation = "KernelObjectFunctorialWithGivenKernelObjects",
  dual_arguments_reversed = true,
  compatible_with_congruence_of_morphisms = false,
),

TerminalObjectFunctorial = rec(
  filter_list = [ "category" ],
  input_arguments_names = [ "cat" ],
  return_type = "morphism",
  output_source_getter_string = "TerminalObject( cat )",
  output_range_getter_string = "TerminalObject( cat )",
  with_given_object_position = "both",
  dual_operation = "InitialObjectFunctorial",
  dual_arguments_reversed = true,
),

TerminalObjectFunctorialWithGivenTerminalObjects = rec(
  filter_list = [ "category", "object", "object" ],
  io_type = [ [ "P", "Pp" ], [ "P", "Pp" ] ],
  return_type = "morphism",
  dual_operation = "InitialObjectFunctorialWithGivenInitialObjects",
  dual_arguments_reversed = true,
),

InitialObjectFunctorial = rec(
  filter_list = [ "category" ],
  input_arguments_names = [ "cat" ],
  return_type = "morphism",
  output_source_getter_string = "InitialObject( cat )",
  output_range_getter_string = "InitialObject( cat )",
  with_given_object_position = "both",
  dual_operation = "TerminalObjectFunctorial",
  dual_arguments_reversed = true,
),

InitialObjectFunctorialWithGivenInitialObjects = rec(
  filter_list = [ "category", "object", "object" ],
  io_type = [ [ "P", "Pp" ], [ "P", "Pp" ] ],
  return_type = "morphism",
  dual_operation = "TerminalObjectFunctorialWithGivenTerminalObjects",
  dual_arguments_reversed = true,
),

DirectProductFunctorial = rec(
  filter_list = [ "category", "list_of_objects", "list_of_morphisms", "list_of_objects" ],
  input_arguments_names = [ "cat", "objects", "L", "objectsp" ],
  return_type = "morphism",
  output_source_getter_string = "DirectProduct( cat, objects )",
  output_range_getter_string = "DirectProduct( cat, objectsp )",
  with_given_object_position = "both",
  dual_operation = "CoproductFunctorial",
  dual_arguments_reversed = true,
  compatible_with_congruence_of_morphisms = true,
),

DirectProductFunctorialWithGivenDirectProducts = rec(
  filter_list = [ "category", "object", "list_of_objects", "list_of_morphisms", "list_of_objects", "object" ],
  io_type = [ [ "P", "objects", "L", "objectsp", "Pp" ], [ "P", "Pp" ] ],
  return_type = "morphism",
  dual_operation = "CoproductFunctorialWithGivenCoproducts",
  dual_arguments_reversed = true,
  compatible_with_congruence_of_morphisms = true,
),

CoproductFunctorial = rec(
  filter_list = [ "category", "list_of_objects", "list_of_morphisms", "list_of_objects" ],
  input_arguments_names = [ "cat", "objects", "L", "objectsp" ],
  return_type = "morphism",
  output_source_getter_string = "Coproduct( cat, objects )",
  output_range_getter_string = "Coproduct( cat, objectsp )",
  with_given_object_position = "both",
  dual_operation = "DirectProductFunctorial",
  dual_arguments_reversed = true,
  compatible_with_congruence_of_morphisms = true,
),

CoproductFunctorialWithGivenCoproducts = rec(
  filter_list = [ "category", "object", "list_of_objects", "list_of_morphisms", "list_of_objects", "object" ],
  io_type = [ [ "P", "objects", "L", "objectsp", "Pp" ], [ "P", "Pp" ] ],
  return_type = "morphism",
  dual_operation = "DirectProductFunctorialWithGivenDirectProducts",
  dual_arguments_reversed = true,
  compatible_with_congruence_of_morphisms = true,
),

DirectSumFunctorial = rec(
  filter_list = [ "category", "list_of_objects", "list_of_morphisms", "list_of_objects" ],
  input_arguments_names = [ "cat", "objects", "L", "objectsp" ],
  return_type = "morphism",
  output_source_getter_string = "DirectSum( cat, objects )",
  output_range_getter_string = "DirectSum( cat, objectsp )",
  with_given_object_position = "both",
  dual_operation = "DirectSumFunctorial",
  dual_arguments_reversed = true,
  compatible_with_congruence_of_morphisms = true,
),

DirectSumFunctorialWithGivenDirectSums = rec(
  filter_list = [ "category", "object", "list_of_objects", "list_of_morphisms", "list_of_objects", "object" ],
  io_type = [ [ "P", "objects", "L", "objectsp", "Pp" ], [ "P", "Pp" ] ],
  return_type = "morphism",
  dual_operation = "DirectSumFunctorialWithGivenDirectSums",
  dual_arguments_reversed = true,
  compatible_with_congruence_of_morphisms = true,
),

EqualizerFunctorial = rec(
  filter_list = [ "category", "list_of_morphisms", "morphism", "list_of_morphisms" ],
  input_arguments_names = [ "cat", "morphisms", "mu", "morphismsp" ],
  return_type = "morphism",
  output_source_getter_string = "Equalizer( cat, morphisms )",
  output_range_getter_string = "Equalizer( cat, morphismsp )",
  with_given_object_position = "both",
  dual_operation = "CoequalizerFunctorial",
  dual_arguments_reversed = true,
  compatible_with_congruence_of_morphisms = false,
),

EqualizerFunctorialWithGivenEqualizers = rec(
  filter_list = [ "category", "object", "list_of_morphisms", "morphism", "list_of_morphisms", "object" ],
  io_type = [ [ "P", "morphisms", "mu", "morphismsp", "Pp" ], [ "P", "Pp" ] ],
  return_type = "morphism",
  dual_operation = "CoequalizerFunctorialWithGivenCoequalizers",
  dual_arguments_reversed = true,
  compatible_with_congruence_of_morphisms = false,
),

CoequalizerFunctorial = rec(
  filter_list = [ "category", "list_of_morphisms", "morphism", "list_of_morphisms" ],
  input_arguments_names = [ "cat", "morphisms", "mu", "morphismsp" ],
  return_type = "morphism",
  output_source_getter_string = "Coequalizer( cat, morphisms )",
  output_range_getter_string = "Coequalizer( cat, morphismsp )",
  with_given_object_position = "both",
  dual_operation = "EqualizerFunctorial",
  dual_arguments_reversed = true,
  compatible_with_congruence_of_morphisms = false,
),

CoequalizerFunctorialWithGivenCoequalizers = rec(
  filter_list = [ "category", "object", "list_of_morphisms", "morphism", "list_of_morphisms", "object" ],
  io_type = [ [ "P", "morphisms", "mu", "morphismsp", "Pp" ], [ "P", "Pp" ] ],
  return_type = "morphism",
  dual_operation = "EqualizerFunctorialWithGivenEqualizers",
  dual_arguments_reversed = true,
  compatible_with_congruence_of_morphisms = false,
),

FiberProductFunctorial = rec(
  filter_list = [ "category", "list_of_morphisms", "list_of_morphisms", "list_of_morphisms" ],
  input_arguments_names = [ "cat", "morphisms", "L", "morphismsp" ],
  return_type = "morphism",
  output_source_getter_string = "FiberProduct( cat, morphisms )",
  output_range_getter_string = "FiberProduct( cat, morphismsp )",
  with_given_object_position = "both",
  dual_operation = "PushoutFunctorial",
  dual_arguments_reversed = true,
  compatible_with_congruence_of_morphisms = false,
),

FiberProductFunctorialWithGivenFiberProducts = rec(
  filter_list = [ "category", "object", "list_of_morphisms", "list_of_morphisms", "list_of_morphisms", "object" ],
  io_type = [ [ "P", "morphisms", "L", "morphismsp", "Pp" ], [ "P", "Pp" ] ],
  return_type = "morphism",
  dual_operation = "PushoutFunctorialWithGivenPushouts",
  dual_arguments_reversed = true,
  compatible_with_congruence_of_morphisms = false,
),

PushoutFunctorial = rec(
  filter_list = [ "category", "list_of_morphisms", "list_of_morphisms", "list_of_morphisms" ],
  input_arguments_names = [ "cat", "morphisms", "L", "morphismsp" ],
  return_type = "morphism",
  output_source_getter_string = "Pushout( cat, morphisms )",
  output_range_getter_string = "Pushout( cat, morphismsp )",
  with_given_object_position = "both",
  dual_operation = "FiberProductFunctorial",
  dual_arguments_reversed = true,
  compatible_with_congruence_of_morphisms = false,
),

PushoutFunctorialWithGivenPushouts = rec(
  filter_list = [ "category", "object", "list_of_morphisms", "list_of_morphisms", "list_of_morphisms", "object" ],
  io_type = [ [ "P", "morphisms", "L", "morphismsp", "Pp" ], [ "P", "Pp" ] ],
  return_type = "morphism",
  dual_operation = "FiberProductFunctorialWithGivenFiberProducts",
  dual_arguments_reversed = true,
  compatible_with_congruence_of_morphisms = false,
),

HorizontalPreCompose = rec(
  filter_list = [ "category", "twocell", "twocell" ],
  dual_operation = "HorizontalPostCompose",
  
  pre_function = function( cat, twocell_1, twocell_2 )
    local value;
    
    value = IsEqualForObjects( Range( Source( twocell_1 ) ), Source( Source( twocell_2 ) ) );
    if value == fail
        return [ false, "can!decide whether 2-cells are horizontally composable" ];
    elseif value == false
        return [ false, "2-cells are !horizontally composable" ];
    end;
    
    return [ true ];
  end,
  return_type = "twocell" ),

HorizontalPostCompose = rec(
  filter_list = [ "category", "twocell", "twocell" ],
  dual_operation = "HorizontalPreCompose",
  
  pre_function = function( cat, twocell_2, twocell_1 )
    local value;
    
    value = IsEqualForObjects( Range( Source( twocell_1 ) ), Source( Source( twocell_2 ) ) );
    if value == fail
        return [ false, "can!decide whether 2-cells are horizontally composable" ];
    elseif value == false
        return [ false, "2-cells are !horizontally composable" ];
    end;
    
    return [ true ];
  end,
  return_type = "twocell" ),

VerticalPreCompose = rec(
  filter_list = [ "category", "twocell", "twocell" ],
  dual_operation = "VerticalPostCompose",
  
  pre_function = function( cat, twocell_1, twocell_2 )
    local value;
    
    value = IsEqualForMorphisms( Range( twocell_1 ), Source( twocell_2 ) );
    if value == fail
        return [ false, "can!decide whether 2-cells are vertically composable" ];
    elseif value == false
        return [ false, "2-cells are !vertically composable" ];
    end;
    
    return [ true ];
  end,
  return_type = "twocell" ),

VerticalPostCompose = rec(
  filter_list = [ "category", "twocell", "twocell" ],
  dual_operation = "VerticalPreCompose",
  
  pre_function = function( cat, twocell_2, twocell_1 )
    local value;
    
    value = IsEqualForMorphisms( Range( twocell_1 ), Source( twocell_2 ) );
    if value == fail
        return [ false, "can!decide whether 2-cells are vertically composable" ];
    elseif value == false
        return [ false, "2-cells are !vertically composable" ];
    end;
    
    return [ true ];
  end,
  return_type = "twocell" ),

IdentityTwoCell = rec(
  filter_list = [ "category", "morphism" ],
  dual_operation = "IdentityTwoCell",
  return_type = "twocell" ),

IsWellDefinedForTwoCells = rec(
  filter_list = [ "category", "twocell" ],
  well_defined_todo = false,
  dual_operation = "IsWellDefinedForTwoCells",
  
  redirect_function = function( cat, twocell )
    
    if not( IsWellDefined( Source( twocell ) ) && IsWellDefined( Range( twocell ) ) )
      
      return [ true, false ];
      
    end;
    
    return [ false ];
    
  end,
  
  return_type = "bool" ),
  
DirectSumDiagonalDifference = rec(
  filter_list = [ "category", "list_of_morphisms" ],
  io_type = [ [ "D" ], [ "S", "D_1_range" ] ],
  return_type = "morphism",
  dual_operation = "DirectSumCodiagonalDifference",
),
  
FiberProductEmbeddingInDirectSum = rec(
  filter_list = [ "category", "list_of_morphisms" ],
  io_type = [ [ "D" ], [ "P", "S" ] ],
  return_type = "morphism",
  dual_operation = "DirectSumProjectionInPushout",
),
  
IsomorphismFromFiberProductToKernelOfDiagonalDifference = rec(
  filter_list = [ "category", "list_of_morphisms" ],
  io_type = [ [ "D" ], [ "P", "Delta" ] ],
  return_type = "morphism",
  dual_operation = "IsomorphismFromCokernelOfDiagonalDifferenceToPushout",
),
  
IsomorphismFromKernelOfDiagonalDifferenceToFiberProduct = rec(
  filter_list = [ "category", "list_of_morphisms" ],
  io_type = [ [ "D" ], [ "Delta", "P" ] ],
  return_type = "morphism",
  dual_operation = "IsomorphismFromPushoutToCokernelOfDiagonalDifference",
),
  
IsomorphismFromFiberProductToEqualizerOfDirectProductDiagram = rec(
  filter_list = [ "category", "list_of_morphisms" ],
  io_type = [ [ "D" ], [ "P", "Delta" ] ],
  return_type = "morphism",
  dual_operation = "IsomorphismFromCoequalizerOfCoproductDiagramToPushout",
),
  
IsomorphismFromEqualizerOfDirectProductDiagramToFiberProduct = rec(
  filter_list = [ "category", "list_of_morphisms" ],
  io_type = [ [ "D" ], [ "Delta", "P" ] ],
  return_type = "morphism",
  dual_operation = "IsomorphismFromPushoutToCoequalizerOfCoproductDiagram",
),
  
IsomorphismFromPushoutToCokernelOfDiagonalDifference = rec(
  filter_list = [ "category", "list_of_morphisms" ],
  io_type = [ [ "D" ], [ "I", "Delta" ] ],
  return_type = "morphism",
  dual_operation = "IsomorphismFromKernelOfDiagonalDifferenceToFiberProduct",
),
  
IsomorphismFromCokernelOfDiagonalDifferenceToPushout = rec(
  filter_list = [ "category", "list_of_morphisms" ],
  io_type = [ [ "D" ], [ "Delta", "I" ] ],
  return_type = "morphism",
  dual_operation = "IsomorphismFromFiberProductToKernelOfDiagonalDifference",
),
  
IsomorphismFromPushoutToCoequalizerOfCoproductDiagram = rec(
  filter_list = [ "category", "list_of_morphisms" ],
  io_type = [ [ "D" ], [ "P", "Delta" ] ],
  return_type = "morphism",
  dual_operation = "IsomorphismFromEqualizerOfDirectProductDiagramToFiberProduct",
),
  
IsomorphismFromCoequalizerOfCoproductDiagramToPushout = rec(
  filter_list = [ "category", "list_of_morphisms" ],
  io_type = [ [ "D" ], [ "Delta", "P" ] ],
  return_type = "morphism",
  dual_operation = "IsomorphismFromFiberProductToEqualizerOfDirectProductDiagram",
),

IsomorphismFromImageObjectToKernelOfCokernel = rec(
  filter_list = [ "category", "morphism" ],
  io_type = [ [ "alpha" ], [ "I", "P" ] ],
  return_type = "morphism",
  dual_operation = "IsomorphismFromCokernelOfKernelToCoimage",
),

IsomorphismFromKernelOfCokernelToImageObject = rec(
  filter_list = [ "category", "morphism" ],
  io_type = [ [ "alpha" ], [ "P", "I" ] ],
  return_type = "morphism",
  dual_operation = "IsomorphismFromCoimageToCokernelOfKernel",
),

IsomorphismFromCoimageToCokernelOfKernel = rec(
  filter_list = [ "category", "morphism" ],
  io_type = [ [ "alpha" ], [ "CI", "C" ] ],
  return_type = "morphism",
  dual_operation = "IsomorphismFromKernelOfCokernelToImageObject",
),

IsomorphismFromCokernelOfKernelToCoimage = rec(
  filter_list = [ "category", "morphism" ],
  io_type = [ [ "alpha" ], [ "I", "CI" ] ],
  return_type = "morphism",
  dual_operation = "IsomorphismFromImageObjectToKernelOfCokernel",
),

CanonicalIdentificationFromImageObjectToCoimage = rec(
  filter_list = [ "category", "morphism" ],
  io_type = [ [ "alpha" ], [ "I", "C" ] ],
  return_type = "morphism",
  dual_operation = "CanonicalIdentificationFromCoimageToImageObject",
),

CanonicalIdentificationFromCoimageToImageObject = rec(
  filter_list = [ "category", "morphism" ],
  io_type = [ [ "alpha" ], [ "C", "I" ] ],
  return_type = "morphism",
  dual_operation = "CanonicalIdentificationFromImageObjectToCoimage",
),

IsomorphismFromDirectSumToDirectProduct = rec(
  filter_list = [ "category", "list_of_objects" ],
  io_type = [ [ "D" ], [ "S", "P" ] ],
  return_type = "morphism",
  dual_operation = "IsomorphismFromCoproductToDirectSum",
),

IsomorphismFromDirectSumToCoproduct = rec(
  filter_list = [ "category", "list_of_objects" ],
  io_type = [ [ "D" ], [ "S", "C" ] ],
  return_type = "morphism",
  dual_operation = "IsomorphismFromDirectProductToDirectSum",
),

IsomorphismFromDirectProductToDirectSum = rec(
  filter_list = [ "category", "list_of_objects" ],
  io_type = [ [ "D" ], [ "P", "S" ] ],
  return_type = "morphism",
  dual_operation = "IsomorphismFromDirectSumToCoproduct",
),

IsomorphismFromCoproductToDirectSum = rec(
  filter_list = [ "category", "list_of_objects" ],
  io_type = [ [ "D" ], [ "C", "S" ] ],
  return_type = "morphism",
  dual_operation = "IsomorphismFromDirectSumToDirectProduct",
),

DirectSumCodiagonalDifference = rec(
  io_type = [ [ "D" ], [ "D_1_source", "S" ] ],
  filter_list = [ "category", "list_of_morphisms" ],
  return_type = "morphism",
  dual_operation = "DirectSumDiagonalDifference",
),

DirectSumProjectionInPushout = rec(
  filter_list = [ "category", "list_of_morphisms" ],
  io_type = [ [ "D" ], [ "S", "I" ] ],
  return_type = "morphism",
  dual_operation = "FiberProductEmbeddingInDirectSum",
),

SomeProjectiveObject = rec(
  filter_list = [ "category", "object" ],
  return_type = "object",
  dual_operation = "SomeInjectiveObject",
  is_merely_set_theoretic = true ),

EpimorphismFromSomeProjectiveObject = rec(
  filter_list = [ "category", "object" ],
  io_type = [ [ "A" ], [ "P", "A" ] ],
  with_given_object_position = "Source",
  return_type = "morphism",
  dual_operation = "MonomorphismIntoSomeInjectiveObject",
  is_merely_set_theoretic = true ),

EpimorphismFromSomeProjectiveObjectWithGivenSomeProjectiveObject = rec(
  filter_list = [ "category", "object", "object" ],
  io_type = [ [ "A", "P" ], [ "P", "A" ] ],
  return_type = "morphism",
  dual_operation = "MonomorphismIntoSomeInjectiveObjectWithGivenSomeInjectiveObject",
  is_merely_set_theoretic = true ),

SomeInjectiveObject = rec(
  filter_list = [ "category", "object" ],
  return_type = "object",
  dual_operation = "SomeProjectiveObject",
  is_merely_set_theoretic = true ),

MonomorphismIntoSomeInjectiveObject = rec(
  filter_list = [ "category", "object" ],
  io_type = [ [ "A" ], [ "A", "I" ] ],
  with_given_object_position = "Range",
  return_type = "morphism",
  dual_operation = "EpimorphismFromSomeProjectiveObject",
  is_merely_set_theoretic = true ),

MonomorphismIntoSomeInjectiveObjectWithGivenSomeInjectiveObject = rec(
  filter_list = [ "category", "object", "object" ],
  io_type = [ [ "A", "I" ], [ "A", "I" ] ],
  return_type = "morphism",
  dual_operation = "EpimorphismFromSomeProjectiveObjectWithGivenSomeProjectiveObject",
  is_merely_set_theoretic = true ),

ComponentOfMorphismIntoDirectSum = rec(
  filter_list = [ "category", "morphism", "list_of_objects", IsInt ],
  io_type = [ [ "alpha", "S", "i" ], [ "alpha_source", "S_i" ] ],
  return_type = "morphism",
  dual_operation = "ComponentOfMorphismFromDirectSum" ),

ComponentOfMorphismFromDirectSum = rec(
  filter_list = [ "category", "morphism", "list_of_objects", IsInt ],
  io_type = [ [ "alpha", "S", "i" ], [ "S_i", "alpha_range" ] ],
  return_type = "morphism",
  dual_operation = "ComponentOfMorphismIntoDirectSum" ),

MorphismBetweenDirectSums = rec(
  filter_list = [ "category", "list_of_objects", IsList, "list_of_objects" ],
  input_arguments_names = [ "cat", "source_diagram", "mat", "range_diagram" ],
  return_type = "morphism",
  output_source_getter_string = "DirectSum( cat, source_diagram )",
  output_range_getter_string = "DirectSum( cat, range_diagram )",
  with_given_object_position = "both",
  pre_function = function( cat, source_diagram, listlist, range_diagram )
    local result, i, j;
      
      if Length( listlist ) != Length( source_diagram )
          
          return [ false, "the number of rows does !match the length of the source diagram" ];
          
      end;
      
      for i in (1):(Length( listlist ))
          
          if Length( listlist[i] ) != Length( range_diagram )
              
              return [ false, Concatenation( "the ", string(i), "-th row has !the same length as the range diagram" ) ];
              
          end;
          
          for j in (1):(Length( range_diagram ))
              
              result = IsEqualForObjects( source_diagram[i], Source( listlist[i][j] ) );
              
              if result == fail
                  
                  return [ false, Concatenation( "can!decide whether the sources of the morphisms ⥉ the ", string(i), "-th row are equal to the ", string(i), "-th entry of the source diagram" ) ];
                  
              elseif result == false
                  
                  return [ false, Concatenation( "the sources of the morphisms ⥉ the ", string(i), "-th row must be equal to the ", string(i), "-th entry of the source diagram" ) ];
                  
              end;
              
              result = IsEqualForObjects( range_diagram[j], Range( listlist[i][j] ) );
              
              if result == fail
                  
                  return [ false, Concatenation( "can!decide whether the ranges of the morphisms ⥉ the ", string(j), "-th column are equal to the ", string(j), "-th entry of the range diagram" ) ];
                  
              elseif result == false
                  
                  return [ false, Concatenation( "the ranges of the morphisms ⥉ the ", string(j), "-th column must be equal to the ", string(j), "-th entry of the range diagram" ) ];
                  
              end;
              
          end;
          
      end;
      
      return [ true ];
      
  end,
  dual_operation = "MorphismBetweenDirectSums",
  dual_preprocessor_func = function( arg... )
      local list;
      list = CAP_INTERNAL_OPPOSITE_RECURSIVE( arg );
      return NTuple( 4, list[1], list[4], TransposedMat( list[3] ), list[2] );
  end
),

MorphismBetweenDirectSumsWithGivenDirectSums = rec(
  filter_list = [ "category", "object", "list_of_objects", IsList, "list_of_objects", "object" ],
  io_type = [ [ "S", "source_diagram", "mat", "range_diagram", "T" ], [ "S", "T" ] ],
  return_type = "morphism",
  dual_operation = "MorphismBetweenDirectSumsWithGivenDirectSums",
  dual_preprocessor_func = function( arg... )
      local list;
      list = CAP_INTERNAL_OPPOSITE_RECURSIVE( arg );
      return NTuple( 6, list[1], list[6], list[5], TransposedMat( list[4] ), list[3], list[2] );
  end
),

IsHomSetInhabited = rec(
  filter_list = [ "category", "object", "object" ],
  return_type = "bool",
  dual_operation = "IsHomSetInhabited",
  dual_arguments_reversed = true,
),

HomomorphismStructureOnObjects = rec(
  filter_list = [ "category", "object", "object" ],
  return_type = "object_in_range_category_of_homomorphism_structure",
  dual_operation = "HomomorphismStructureOnObjects",
  dual_arguments_reversed = true,
  dual_postprocessor_func = IdFunc
),

HomomorphismStructureOnMorphisms = rec(
  filter_list = [ "category", "morphism", "morphism" ],
  input_arguments_names = [ "cat", "alpha", "beta" ],
  output_source_getter_string = "HomomorphismStructureOnObjects( cat, Range( alpha ), Source( beta ) )",
  output_range_getter_string = "HomomorphismStructureOnObjects( cat, Source( alpha ), Range( beta ) )",
  with_given_object_position = "both",
  return_type = "morphism_in_range_category_of_homomorphism_structure",
  dual_operation = "HomomorphismStructureOnMorphisms",
  dual_preprocessor_func = function( cat, alpha, beta )
    return Triple( OppositeCategory( cat ), Opposite( beta ), Opposite( alpha ) );
  end,
  dual_postprocessor_func = IdFunc,
),

HomomorphismStructureOnMorphismsWithGivenObjects = rec(
  filter_list = [ "category", "object_in_range_category_of_homomorphism_structure", "morphism", "morphism", "object_in_range_category_of_homomorphism_structure" ],
  input_arguments_names = [ "cat", "source", "alpha", "beta", "range" ],
  output_source_getter_string = "source",
  output_range_getter_string = "range",
  return_type = "morphism_in_range_category_of_homomorphism_structure",
  dual_operation = "HomomorphismStructureOnMorphismsWithGivenObjects",
  dual_preprocessor_func = function( cat, source, alpha, beta, range )
    return NTuple( 5, OppositeCategory( cat ), source, Opposite( beta ), Opposite( alpha ), range );
  end,
  dual_postprocessor_func = IdFunc,
),

DistinguishedObjectOfHomomorphismStructure = rec(
  filter_list = [ "category" ],
  return_type = "object_in_range_category_of_homomorphism_structure",
  dual_operation = "DistinguishedObjectOfHomomorphismStructure",
  dual_postprocessor_func = IdFunc ),

InterpretMorphismAsMorphismFromDistinguishedObjectToHomomorphismStructure = rec(
  filter_list = [ "category", "morphism" ],
  input_arguments_names = [ "cat", "alpha" ],
  output_source_getter_string = "DistinguishedObjectOfHomomorphismStructure( cat )",
  output_range_getter_string = "HomomorphismStructureOnObjects( cat, Source( alpha ), Range( alpha ) )",
  with_given_object_position = "both",
  return_type = "morphism_in_range_category_of_homomorphism_structure",
  dual_operation = "InterpretMorphismAsMorphismFromDistinguishedObjectToHomomorphismStructure",
  dual_postprocessor_func = IdFunc
),

InterpretMorphismAsMorphismFromDistinguishedObjectToHomomorphismStructureWithGivenObjects = rec(
  filter_list = [ "category", "object_in_range_category_of_homomorphism_structure", "morphism", "object_in_range_category_of_homomorphism_structure" ],
  input_arguments_names = [ "cat", "source", "alpha", "range" ],
  output_source_getter_string = "source",
  output_range_getter_string = "range",
  return_type = "morphism_in_range_category_of_homomorphism_structure",
  dual_operation = "InterpretMorphismAsMorphismFromDistinguishedObjectToHomomorphismStructureWithGivenObjects",
  dual_preprocessor_func = function( cat, distinguished_object, alpha, hom_source_range )
    return NTuple( 4, OppositeCategory( cat ), distinguished_object, Opposite( alpha ), hom_source_range );
  end,
  dual_postprocessor_func = IdFunc
),

InterpretMorphismFromDistinguishedObjectToHomomorphismStructureAsMorphism = rec(
  filter_list = [ "category", "object", "object", "morphism_in_range_category_of_homomorphism_structure" ],
  return_type = "morphism",
  dual_operation = "InterpretMorphismFromDistinguishedObjectToHomomorphismStructureAsMorphism",
  dual_preprocessor_func = function( cat, A, B, morphism )
    return NTuple( 4, OppositeCategory( cat ), Opposite( B ), Opposite( A ), morphism );
  end
),

SolveLinearSystemInAbCategory = rec(
  filter_list = [ "category", IsList, IsList, "list_of_morphisms" ],
  return_type = "list_of_morphisms",
  pre_function = function( cat, left_coeffs, right_coeffs, rhs )
    
    if !Length( left_coeffs ) > 0
        return [ false, "the list of left coefficients is empty" ];
    end;
    
    if !Length( left_coeffs ) == Length( right_coeffs )
        return [ false, "the list of left coefficients && the list of right coefficients do !have the same length" ];
    end;
    
    if !Length( left_coeffs ) == Length( rhs )
        return [ false, "the list of left coefficients does !have the same length as the right hand side" ];
    end;
    
    if !ForAll( Concatenation( left_coeffs, right_coeffs ), x -> IsList( x ) && Length( x ) == Length( left_coeffs[1] ) && ForAll( x, y -> IsCapCategoryMorphism( y ) && IsIdenticalObj( CapCategory( y ), cat ) ) )
        return [ false, "the left coefficients && the right coefficients must be given by lists of lists of the same length containing morphisms ⥉ the current category" ];
    end;
    
    return [ true ];
    
  end,
  pre_function_full = function( cat, left_coeffs, right_coeffs, rhs )
    local nr_columns_left, nr_columns_right;
    
    if !ForAll( (1):(Length( left_coeffs )), i -> ForAll( left_coeffs[i], coeff -> IsEqualForObjects( Source( coeff ), Source( rhs[i] ) ) != false ) )
        return [ false, "the sources of the left coefficients must correspond to the sources of the right hand side" ];
    end;
    
    if !ForAll( (1):(Length( right_coeffs )), i -> ForAll( right_coeffs[i], coeff -> IsEqualForObjects( Range( coeff ), Range( rhs[i] ) ) != false ) )
        return [ false, "the ranges of the right coefficients must correspond to the ranges of the right hand side" ];
    end;
    
    nr_columns_left = Length( left_coeffs[1] );
    
    if !ForAll( (1):(nr_columns_left), j -> ForAll( left_coeffs, x -> IsEqualForObjects( Range( x[j] ), Range( left_coeffs[1][j] ) ) != false ) )
        return [ false, "all ranges ⥉ a column of the left coefficients must be equal" ];
    end;
    
    nr_columns_right = Length( right_coeffs[1] );
    
    if !ForAll( (1):(nr_columns_right), j -> ForAll( right_coeffs, x -> IsEqualForObjects( Source( x[j] ), Source( right_coeffs[1][j] ) ) != false ) )
        return [ false, "all sources ⥉ a column of the right coefficients must be equal" ];
    end;
    
    return [ true ];
    
  end,
),

SolveLinearSystemInAbCategoryOrFail = rec(
  filter_list = [ "category", IsList, IsList, "list_of_morphisms" ],
  return_type = "list_of_morphisms_or_fail",
  pre_function = "SolveLinearSystemInAbCategory",
  pre_function_full = "SolveLinearSystemInAbCategory"
),

MereExistenceOfSolutionOfLinearSystemInAbCategory = rec(
  filter_list = [ "category", IsList, IsList, "list_of_morphisms" ],
  return_type = "bool",
  pre_function = "SolveLinearSystemInAbCategory",
  pre_function_full = "SolveLinearSystemInAbCategory"
),

BasisOfExternalHom = rec(
  filter_list = [ "category", "object", "object" ],
  return_type = "list_of_morphisms",
  dual_operation = "BasisOfExternalHom",
  dual_arguments_reversed = true
),

CoefficientsOfMorphism = rec(
  filter_list = [ "category", "morphism" ],
  return_type = IsList,
  dual_operation = "CoefficientsOfMorphism",
  dual_postprocessor_func = IdFunc
),

RandomObjectByInteger = rec(
  filter_list = [ "category", IsInt ],
  io_type = [ [ "n" ], [ "A" ] ],
  return_type = "object",
  dual_operation = "RandomObjectByInteger",
),

RandomMorphismByInteger = rec(
  filter_list = [ "category", IsInt ],
  io_type = [ [ "n" ], [ "A", "B" ] ],
  return_type = "morphism",
  dual_operation = "RandomMorphismByInteger",
),

RandomMorphismWithFixedSourceByInteger = rec(
  filter_list = [ "category", "object", IsInt ],
  io_type = [ [ "A", "n" ], [ "A", "B" ] ],
  return_type = "morphism",
  dual_operation = "RandomMorphismWithFixedRangeByInteger",
),

RandomMorphismWithFixedRangeByInteger = rec(
  filter_list = [ "category", "object", IsInt ],
  io_type = [ [ "B", "n" ], [ "A", "B" ] ],
  return_type = "morphism",
  dual_operation = "RandomMorphismWithFixedSourceByInteger",
),

RandomMorphismWithFixedSourceAndRangeByInteger = rec(
  filter_list = [ "category", "object", "object", IsInt ],
  io_type = [ [ "A", "B", "n" ], [ "A", "B" ] ],
  return_type = "morphism",
  dual_operation = "RandomMorphismWithFixedSourceAndRangeByInteger",
  dual_preprocessor_func = function( cat, A, B, n )
      return NTuple( 4, OppositeCategory( cat ), Opposite( B ), Opposite( A ), n );
  end
),

RandomObjectByList = rec(
  filter_list = [ "category", IsList ],
  io_type = [ [ "L" ], [ "A" ] ],
  return_type = "object"
),

RandomMorphismByList = rec(
  filter_list = [ "category", IsList ],
  io_type = [ [ "L" ], [ "A", "B" ] ],
  return_type = "morphism"
),

RandomMorphismWithFixedSourceByList = rec(
  filter_list = [ "category", "object", IsList ],
  io_type = [ [ "A", "L" ], [ "A", "B" ] ],
  return_type = "morphism",
),

RandomMorphismWithFixedRangeByList = rec(
  filter_list = [ "category", "object", IsList ],
  io_type = [ [ "B", "L" ], [ "A", "B" ] ],
  return_type = "morphism"
),

RandomMorphismWithFixedSourceAndRangeByList = rec(
  filter_list = [ "category", "object", "object", IsList ],
  io_type = [ [ "A", "B", "L" ], [ "A", "B" ] ],
  return_type = "morphism"
),

HomologyObject = rec(
  filter_list = [ "category", "morphism", "morphism" ],
  io_type = [ [ "alpha", "beta" ], [ "H" ] ],
  return_type = "object",
  pre_function = function( cat, alpha, beta )
      if !IsEqualForObjects( Range( alpha ), Source( beta ) )
            
            return [ false, "the range of the first morphism has to be equal to the source of the second morphism" ];
            
      end;
      
      return [ true ];
      
  end,
  dual_operation = "HomologyObject",
  dual_arguments_reversed = true
),

HomologyObjectFunctorialWithGivenHomologyObjects = rec(
  filter_list = [ "category", "object", IsList, "object" ],
  io_type = [ [ "H_1", "L", "H_2" ], [ "H_1", "H_2" ] ],
  return_type = "morphism",
  pre_function = function( cat, H_1, L, H2 )
      local alpha, beta, epsilon, gamma, delta;
      
      alpha = L[1];
      
      beta = L[2];
      
      epsilon = L[3];
      
      gamma = L[4];
      
      delta = L[5];
      
      if !IsEqualForObjects( Range( alpha ), Source( beta ) )
            
            return [ false, "the range of the first morphism has to be equal to the source of the second morphism" ];
            
      end;
      
      if !IsEqualForObjects( Range( gamma ), Source( delta ) )
            
            return [ false, "the range of the fourth morphism has to be equal to the source of the fifth morphism" ];
            
      end;
      
      if !IsEqualForObjects( Source( epsilon ), Source( beta ) )
            
            return [ false, "the source of the third morphism has to be equal to the source of the second morphism" ];
            
      end;
      
      if !IsEqualForObjects( Range( epsilon ), Range( gamma ) )
            
            return [ false, "the range of the third morphism has to be equal to the range of the fourth morphism" ];
            
      end;
      
      return [ true ];
      
  end,
  dual_operation = "HomologyObjectFunctorialWithGivenHomologyObjects",
  dual_preprocessor_func = function( arg... )
      local list;
      list = CAP_INTERNAL_OPPOSITE_RECURSIVE( arg );
      return NTuple( 4, list[1], list[4], Reversed( list[3] ), list[2] );
  end
),

IsomorphismFromHomologyObjectToItsConstructionAsAnImageObject = rec(
  filter_list = [ "category", "morphism", "morphism" ],
  io_type = [ [ "alpha", "beta" ], [ "A", "B" ] ],
  return_type = "morphism" ),

IsomorphismFromItsConstructionAsAnImageObjectToHomologyObject = rec(
  filter_list = [ "category", "morphism", "morphism" ],
  io_type = [ [ "alpha", "beta" ], [ "A", "B" ] ],
  return_type = "morphism" ),
  
## SimplifyObject*
SimplifyObject = rec(
  filter_list = [ "category", "object", "nonneg_integer_or_Inf" ],
  io_type = [ [ "A", "n" ], [ "B" ] ],
  return_type = "object",
  dual_operation = "SimplifyObject",
  redirect_function = function( cat, A, n )
    
    if n == 0
        return [ true, A ];
    end;
    
    return [ false ];
    
  end,
  pre_function = function( cat, A, n )
    
    if !( IsPosInt( n ) || IsInfinity( n ) )
        return [ false, "the second argument must be a non-negative integer || Inf" ];
    end;
    
    return [ true ];
    
  end 
  ),

SimplifyObject_IsoFromInputObject = rec(
  filter_list = [ "category", "object", "nonneg_integer_or_Inf" ],
  io_type = [ [ "A", "n" ], [ "A", "B" ] ],
  return_type = "morphism",
  dual_operation = "SimplifyObject_IsoToInputObject",
  redirect_function = function( cat, A, n )
    
    if n == 0
        return [ true, IdentityMorphism( A ) ];
    end;
    
    return [ false ];
    
  end,
  pre_function = "SimplifyObject"
  ),

SimplifyObject_IsoToInputObject = rec(
  filter_list = [ "category", "object", "nonneg_integer_or_Inf" ],
  io_type = [ [ "A", "n" ], [ "B", "A" ] ],
  return_type = "morphism",
  dual_operation = "SimplifyObject_IsoFromInputObject",
  redirect_function = "SimplifyObject_IsoFromInputObject",
  pre_function = "SimplifyObject"
  ),

## SimplifyMorphism
SimplifyMorphism = rec(
  filter_list = [ "category", "morphism", "nonneg_integer_or_Inf" ],
  io_type = [ [ "mor", "n" ], [ "mor_source", "mor_range" ] ],
  return_type = "morphism",
  dual_operation = "SimplifyMorphism",
  redirect_function = "SimplifyObject",
  pre_function = "SimplifyObject"
  ),

## SimplifySource*
SimplifySource = rec(
  filter_list = [ "category", "morphism", "nonneg_integer_or_Inf" ],
  io_type = [ [ "mor", "n" ], [ "Ap", "mor_range" ] ],
  return_type = "morphism",
  dual_operation = "SimplifyRange",
  redirect_function = "SimplifyObject",
  pre_function = "SimplifyObject"
  ),

SimplifySource_IsoToInputObject = rec(
  filter_list = [ "category", "morphism", "nonneg_integer_or_Inf" ],
  io_type = [ [ "mor", "n" ], [ "Ap", "mor_source" ] ],
  return_type = "morphism",
  dual_operation = "SimplifyRange_IsoFromInputObject",
  redirect_function = function( cat, alpha, n )
    
    if n == 0
        return [ true, IdentityMorphism( Source( alpha ) ) ];
    end;
    
    return [ false ];
    
  end,
  pre_function = "SimplifyObject"
  ),
  
SimplifySource_IsoFromInputObject = rec(
  filter_list = [ "category", "morphism", "nonneg_integer_or_Inf" ],
  io_type = [ [ "mor", "n" ], [ "mor_source", "Ap" ] ],
  return_type = "morphism",
  dual_operation = "SimplifyRange_IsoToInputObject",
  redirect_function = "SimplifySource_IsoToInputObject",
  pre_function = "SimplifyObject"
  ),

## SimplifyRange*
SimplifyRange = rec(
  filter_list = [ "category", "morphism", "nonneg_integer_or_Inf" ],
  io_type = [ [ "mor", "n" ], [ "mor_source", "Bp" ] ],
  return_type = "morphism",
  dual_operation = "SimplifySource",
  redirect_function = "SimplifyObject",
  pre_function = "SimplifyObject"
  ),

SimplifyRange_IsoToInputObject = rec(
  filter_list = [ "category", "morphism", "nonneg_integer_or_Inf" ],
  io_type = [ [ "mor", "n" ], [ "Bp", "mor_range" ] ],
  return_type = "morphism",
  dual_operation = "SimplifySource_IsoFromInputObject",
  redirect_function = function( cat, alpha, n )
    
    if n == 0
        return [ true, IdentityMorphism( Range( alpha ) ) ];
    end;
    
    return [ false ];
    
  end,
  pre_function = "SimplifyObject"
  ),
  
SimplifyRange_IsoFromInputObject = rec(
  filter_list = [ "category", "morphism", "nonneg_integer_or_Inf" ],
  io_type = [ [ "mor", "n" ], [ "mor_range", "Bp" ] ],
  return_type = "morphism",
  dual_operation = "SimplifySource_IsoToInputObject",
  redirect_function = "SimplifySource_IsoToInputObject",
  pre_function = "SimplifyObject"
  ),

## SimplifySourceAndRange*
SimplifySourceAndRange = rec(
  filter_list = [ "category", "morphism", "nonneg_integer_or_Inf" ],
  io_type = [ [ "mor", "n" ], [ "Ap", "Bp" ] ],
  return_type = "morphism",
  dual_operation = "SimplifySourceAndRange",
  redirect_function = "SimplifyObject",
  pre_function = "SimplifyObject"
  ),

SimplifySourceAndRange_IsoToInputSource = rec(
  filter_list = [ "category", "morphism", "nonneg_integer_or_Inf" ],
  io_type = [ [ "mor", "n" ], [ "Ap", "mor_source" ] ],
  return_type = "morphism",
  dual_operation = "SimplifySourceAndRange_IsoFromInputRange",
  redirect_function = "SimplifySource_IsoToInputObject",
  pre_function = "SimplifyObject"
  ),
  
SimplifySourceAndRange_IsoFromInputSource = rec(
  filter_list = [ "category", "morphism", "nonneg_integer_or_Inf" ],
  io_type = [ [ "mor", "n" ], [ "mor_source", "Ap" ] ],
  return_type = "morphism",
  dual_operation = "SimplifySourceAndRange_IsoToInputRange",
  redirect_function = "SimplifySource_IsoToInputObject",
  pre_function = "SimplifyObject"
  ),

SimplifySourceAndRange_IsoToInputRange = rec(
  filter_list = [ "category", "morphism", "nonneg_integer_or_Inf" ],
  io_type = [ [ "mor", "n" ], [ "Bp", "mor_range" ] ],
  return_type = "morphism",
  dual_operation = "SimplifySourceAndRange_IsoFromInputSource",
  redirect_function = "SimplifySource_IsoToInputObject",
  pre_function = "SimplifyObject"
  ),
  
SimplifySourceAndRange_IsoFromInputRange = rec(
  filter_list = [ "category", "morphism", "nonneg_integer_or_Inf" ],
  io_type = [ [ "mor", "n" ], [ "mor_range", "Bp" ] ],
  return_type = "morphism",
  dual_operation = "SimplifySourceAndRange_IsoToInputSource",
  redirect_function = "SimplifySource_IsoToInputObject",
  pre_function = "SimplifyObject"
  ),

## SimplifyEndo*
SimplifyEndo = rec(
  filter_list = [ "category", "morphism", "nonneg_integer_or_Inf" ],
  io_type = [ [ "mor", "n" ], [ "Ap", "Ap" ] ],
  return_type = "morphism",
  dual_operation = "SimplifyEndo",
  redirect_function = "SimplifyObject",
  pre_function = function( cat, endo, n )
    
    if !( IsPosInt( n ) || IsInfinity( n ) )
        return [ false, "the second argument must be a non-negative integer || Inf" ];
    end;
    
    if !IsEndomorphism( endo )
        return [ false, "the first argument must be an endomorphism" ];
    end;
    
    return [ true ];
    
  end 
  ),

SimplifyEndo_IsoFromInputObject = rec(
  filter_list = [ "category", "morphism", "nonneg_integer_or_Inf" ],
  io_type = [ [ "mor", "n" ], [ "mor_source", "Ap" ] ],
  return_type = "morphism",
  dual_operation = "SimplifyEndo_IsoToInputObject",
  redirect_function = "SimplifySource_IsoToInputObject",
  pre_function = "SimplifyEndo"
  ),

SimplifyEndo_IsoToInputObject = rec(
  filter_list = [ "category", "morphism", "nonneg_integer_or_Inf" ],
  io_type = [ [ "mor", "n" ], [ "Ap", "mor_range" ] ],
  return_type = "morphism",
  dual_operation = "SimplifyEndo_IsoFromInputObject",
  redirect_function = "SimplifySource_IsoToInputObject",
  pre_function = "SimplifyEndo"
  ),

SomeReductionBySplitEpiSummand = rec(
  filter_list = [ "category", "morphism" ],
  io_type = [ [ "alpha" ], [ "Ap", "Bp" ] ],
  return_type = "morphism",
  ),

SomeReductionBySplitEpiSummand_MorphismToInputRange = rec(
  filter_list = [ "category", "morphism" ],
  io_type = [ [ "alpha" ], [ "Bp", "B" ] ],
  return_type = "morphism",
  ),

SomeReductionBySplitEpiSummand_MorphismFromInputRange = rec(
  filter_list = [ "category", "morphism" ],
  io_type = [ [ "alpha" ], [ "B", "Bp" ] ],
  return_type = "morphism",
  ),

ProjectiveDimension = rec(
  filter_list = [ "category", "object" ],
  return_type = "nonneg_integer_or_Inf",
  dual_operation = "InjectiveDimension",
  ),

InjectiveDimension = rec(
  filter_list = [ "category", "object" ],
  return_type = "nonneg_integer_or_Inf",
  dual_operation = "ProjectiveDimension",
  ),

AdditiveGenerators = rec(
  filter_list = [ "category" ],
  return_type = "list_of_objects",
  dual_operation = "AdditiveGenerators",
),

IndecomposableProjectiveObjects = rec(
  filter_list = [ "category" ],
  return_type = "list_of_objects",
  dual_operation = "IndecomposableInjectiveObjects",
),

IndecomposableInjectiveObjects = rec(
  filter_list = [ "category" ],
  return_type = "list_of_objects",
  dual_operation = "IndecomposableProjectiveObjects",
),

) );

InstallValue( CAP_INTERNAL_METHOD_NAME_RECORD_LIMITS, [
rec(
  object_specification = [ "varobject" ],
  morphism_specification = [  ],
  limit_object_name = "DirectProduct",
  colimit_object_name = "Coproduct",
),

rec(
  object_specification = [ "varobject" ],
  morphism_specification = [  ],
  limit_object_name = "DirectSum",
  colimit_object_name = "DirectSum",
),

rec(
  object_specification = [ "fixedobject", "varobject" ],
  morphism_specification = [ [ 2, "varmorphism", 1 ] ],
  limit_object_name = "FiberProduct",
  colimit_object_name = "Pushout",
),

rec(
  object_specification = [ "fixedobject", "fixedobject" ],
  morphism_specification = [ [ 1, "varmorphism", 2 ] ],
  limit_object_name = "Equalizer",
  limit_projection_name = "EmbeddingOfEqualizer",
  colimit_object_name = "Coequalizer",
  colimit_injection_name = "ProjectionOntoCoequalizer",
),

rec(
  object_specification = [ "fixedobject", "fixedobject" ],
  morphism_specification = [ [ 1, "fixedmorphism", 2 ], [ 1, "zeromorphism", 2 ] ],
  limit_object_name = "KernelObject",
  limit_projection_name = "KernelEmbedding",
  limit_universal_morphism_name = "KernelLift",
  colimit_object_name = "CokernelObject",
  colimit_injection_name = "CokernelProjection",
  colimit_universal_morphism_name = "CokernelColift",
),

rec(
  object_specification = [ ],
  morphism_specification = [ ],
  limit_object_name = "TerminalObject",
  colimit_object_name = "InitialObject",
),

rec(
  object_specification = [ ],
  morphism_specification = [ ],
  limit_object_name = "ZeroObject",
  colimit_object_name = "ZeroObject",
)

] );

InstallGlobalFunction( "CAP_INTERNAL_ENHANCE_NAME_RECORD_LIMITS",
  function ( limits )
    local object_specification, morphism_specification, source_position, type, range_position, unbound_morphism_positions, number_of_unbound_morphisms, unbound_objects, morphism, unbound_object_positions, number_of_unbound_objects, targets, target_positions, nontarget_positions, number_of_targets, number_of_nontargets, diagram_filter_list, diagram_input_type, limit, position;
    
    for limit in limits
        object_specification = limit.object_specification;
        morphism_specification = limit.morphism_specification;
        
        #### check that given diagram is well-defined
        if !(IsDenseList( object_specification ) && IsDenseList( morphism_specification ))
            Error( "the given diagram is !well-defined" );
        end;

        if Length( object_specification ) == 0 && Length( morphism_specification ) > 0
            Error( "the given diagram is !well-defined" );
        end;
        
        if !(ForAll( object_specification, object -> object ⥉ [ "fixedobject", "varobject" ] ))
            Error( "the given diagram is !well-defined" );
        end;

        for morphism in morphism_specification
            if !(IsList( morphism ) && Length( morphism ) == 3)
                Error( "the given diagram is !well-defined" );
            end;
            source_position = morphism[1];
            type = morphism[2];
            range_position = morphism[3];

            if !(IsInt( source_position ) && source_position >= 1 && source_position <= Length( object_specification ))
                Error( "the given diagram is !well-defined" );
            end;

            if !(IsInt( range_position ) && range_position >= 1 && range_position <= Length( object_specification ))
                Error( "the given diagram is !well-defined" );
            end;

            if !type ⥉ [ "fixedmorphism", "varmorphism", "zeromorphism" ]
                Error( "the given diagram is !well-defined" );
            end;

            if type == "fixedmorphism" && (object_specification[source_position] == "varobject" || object_specification[range_position] == "varobject")
                Error( "the given diagram is !well-defined" );
            end;
        end;

        #### get number of variables
        # morphisms
        unbound_morphism_positions = PositionsProperty( morphism_specification, x -> x[2] == "varmorphism" || x[2] == "fixedmorphism" );
        if Length( unbound_morphism_positions ) == 0
            number_of_unbound_morphisms = 0;
        elseif Length( unbound_morphism_positions ) == 1 && morphism_specification[unbound_morphism_positions[1]][2] == "fixedmorphism"
            number_of_unbound_morphisms = 1;
        else
            number_of_unbound_morphisms = 2;
        end;

        limit.unbound_morphism_positions = unbound_morphism_positions;
        limit.number_of_unbound_morphisms = number_of_unbound_morphisms;

        if !ForAll( unbound_morphism_positions, i -> morphism_specification[i][2] == "fixedmorphism" || i == Length( unbound_morphism_positions ) )
            Error( "diagrams of the given type are !supported" );
        end;

        # objects
        unbound_objects = StructuralCopy( object_specification );
        for position in unbound_morphism_positions
            morphism = morphism_specification[position];
            source_position = morphism[1];
            range_position = morphism[3];

            unbound_objects[source_position] = "";
            unbound_objects[range_position] = "";
        end;
        unbound_object_positions = PositionsProperty( unbound_objects, x -> x != "" );
        if Length( unbound_object_positions ) == 0
            number_of_unbound_objects = 0;
        elseif Length( unbound_object_positions ) == 1 && object_specification[unbound_object_positions[1]] == "fixedobject"
            number_of_unbound_objects = 1;
        else
            number_of_unbound_objects = 2;
        end;

        limit.unbound_object_positions = unbound_object_positions;
        limit.number_of_unbound_objects = number_of_unbound_objects;

        if !ForAll( unbound_object_positions, i -> object_specification[i] == "fixedobject" || i == Length( unbound_object_positions ) )
            Error( "diagrams of the given type are !supported" );
        end;

        # (non-)targets
        targets = StructuralCopy( object_specification );
        for morphism in morphism_specification
            range_position = morphism[3];
            
            targets[range_position] = "";
        end;
        target_positions = PositionsProperty( targets, x -> x != "" );
        nontarget_positions = PositionsProperty( targets, x -> x == "" );
        if Length( target_positions ) == 0
            number_of_targets = 0;
        elseif Length( target_positions ) == 1 && object_specification[target_positions[1]] == "fixedobject"
            number_of_targets = 1;
        else
            number_of_targets = 2;
        end;
        if Length( nontarget_positions ) == 0
            number_of_nontargets = 0;
        elseif Length( nontarget_positions ) == 1 && object_specification[nontarget_positions[1]] == "fixedobject"
            number_of_nontargets = 1;
        else
            number_of_nontargets = 2;
        end;

        limit.target_positions = target_positions;
        limit.number_of_targets = number_of_targets;
        limit.nontarget_positions = nontarget_positions;
        limit.number_of_nontargets = number_of_nontargets;

        #### get filter list && input type of the diagram
        diagram_filter_list = [ ];
        diagram_input_type = [ ];
        if number_of_unbound_objects == 1
            Add( diagram_filter_list, "object" );
            Add( diagram_input_type, "X" );
        elseif number_of_unbound_objects > 1
            Add( diagram_filter_list, "list_of_objects" );
            Add( diagram_input_type, "objects" );
        end;
        if number_of_unbound_morphisms == 1
            Add( diagram_filter_list, "morphism" );
            Add( diagram_input_type, "alpha" );
        elseif number_of_unbound_morphisms > 1
            if number_of_targets == 1
                Add( diagram_filter_list, "object" );
                Add( diagram_input_type, "Y" );
            end;
            Add( diagram_filter_list, "list_of_morphisms" );
            Add( diagram_input_type, "morphisms" );
        end;

        limit.diagram_filter_list = diagram_filter_list;
        limit.diagram_input_type = diagram_input_type;
        
        #### set default projection/injection/universal morphism names
        if number_of_targets > 0 && !IsBound( limit.limit_projection_name )
            limit.limit_projection_name = Concatenation( "ProjectionInFactorOf", limit.limit_object_name );
        end;
        if !IsBound( limit.limit_universal_morphism_name )
            limit.limit_universal_morphism_name = Concatenation( "UniversalMorphismInto", limit.limit_object_name );
        end;

        if number_of_targets > 0 && !IsBound( limit.colimit_injection_name )
            limit.colimit_injection_name = Concatenation( "InjectionOfCofactorOf", limit.colimit_object_name );
        end;
        if !IsBound( limit.colimit_universal_morphism_name )
            limit.colimit_universal_morphism_name = Concatenation( "UniversalMorphismFrom", limit.colimit_object_name );
        end;
        
        if number_of_targets > 0
            limit.limit_projection_with_given_name = Concatenation( limit.limit_projection_name, "WithGiven", limit.limit_object_name );
            limit.colimit_injection_with_given_name = Concatenation( limit.colimit_injection_name, "WithGiven", limit.colimit_object_name );
        end;
        
        limit.limit_universal_morphism_with_given_name = Concatenation( limit.limit_universal_morphism_name, "WithGiven", limit.limit_object_name );
        limit.colimit_universal_morphism_with_given_name = Concatenation( limit.colimit_universal_morphism_name, "WithGiven", limit.colimit_object_name );
        
        limit.limit_functorial_name = Concatenation( limit.limit_object_name, "Functorial" );
        limit.colimit_functorial_name = Concatenation( limit.colimit_object_name, "Functorial" );

        limit.limit_functorial_with_given_name = Concatenation( limit.limit_functorial_name, "WithGiven", limit.limit_object_name, "s" );
        limit.colimit_functorial_with_given_name = Concatenation( limit.colimit_functorial_name, "WithGiven", limit.colimit_object_name, "s" );

        if limit.number_of_nontargets == 1
            limit.limit_morphism_to_sink_name = Concatenation( "MorphismFrom", limit.limit_object_name, "ToSink" );
            limit.colimit_morphism_from_source_name = Concatenation( "MorphismFromSourceTo", limit.colimit_object_name );
        end;

        if Length( diagram_filter_list ) > 0
            if limit.number_of_targets == 1
                limit.diagram_morphism_filter_list = [ "morphism" ];
                limit.diagram_morphism_input_type = [ "mu" ];
            else
                limit.diagram_morphism_filter_list = [ "list_of_morphisms" ];
                limit.diagram_morphism_input_type = [ "L" ];
            end;
        else
            limit.diagram_morphism_filter_list = [ ];
            limit.diagram_morphism_input_type = [ ];
        end;
        
        limit.functorial_source_diagram_arguments_names = limit.diagram_input_type;
        limit.functorial_range_diagram_arguments_names = List( limit.diagram_input_type, x -> Concatenation( x, "p" ) );
        
    end;
end );

CAP_INTERNAL_ENHANCE_NAME_RECORD_LIMITS( CAP_INTERNAL_METHOD_NAME_RECORD_LIMITS );


BindGlobal( "CAP_INTERNAL_IS_EQUAL_FOR_METHOD_RECORD_ENTRIES", function ( method_record, entry_name, generated_entry )
  local excluded_names, subset_only, method_record_entry, name;
    
    excluded_names = [ "function_name", "pre_function", "pre_function_full", "post_function" ];
    
    subset_only = ValueOption( "subset_only" ) == true;
    
    if !IsBound( method_record[entry_name] )
        Display( Concatenation( "WARNING: The method record is missing a component named \"", entry_name, "\" which is expected by the validator.\n" ) );
        return;
    end;
    
    method_record_entry = method_record[entry_name];
    
    for name in RecNames( method_record_entry )
        if name ⥉ excluded_names
            continue;
        end;
        if !IsBound( generated_entry[name] )
            if subset_only
                continue;
            else
                Display( Concatenation( "WARNING: The entry \"", entry_name, "\" ⥉ the method record has a component named \"", name, "\" which is !expected by the validator.\n" ) );
            end;
        elseif method_record_entry[name] != generated_entry[name]
            Display( Concatenation( "WARNING: The entry \"", entry_name, "\" ⥉ the method record has a component named \"", name, "\" with value \"", string( method_record_entry[name] ), "\". The value expected by the validator is \"", string( generated_entry[name] ), "\".\n" ) );
        end;
    end;
    for name in RecNames( generated_entry )
        if name ⥉ excluded_names
            continue;
        end;
        if !IsBound( method_record_entry[name] )
            Display( Concatenation( "WARNING: The entry \"", entry_name, "\" ⥉ the method record is missing a component named \"", name, "\" which is expected by the validator.\n" ) );
        end;
    end;
end );

InstallGlobalFunction( CAP_INTERNAL_VALIDATE_LIMITS_IN_NAME_RECORD,
  function ( method_name_record, limits )
    local make_record_with_given, make_colimit, object_filter_list, projection_filter_list, projection_io_type, morphism_to_sink_filter_list, morphism_to_sink_io_type, universal_morphism_filter_list, universal_morphism_io_type, object_record, projection_record, morphism_to_sink_record, filter_list, io_type, with_given_object_position, return_type, dual_operation, universal_morphism_record, functorial_record, functorial_with_given_record, limit;
    
    #### helper functions
    make_record_with_given = function ( record, object_name, coobject_name )
        record = StructuralCopy( record );
        
        record.function_name = Concatenation( record.function_name, "WithGiven", object_name );
        Add( record.filter_list, "object" );
        if record.with_given_object_position == "Source"
            Add( record.io_type[1], record.io_type[2][1] );
        else
            Add( record.io_type[1], record.io_type[2][2] );
        end;
        record.dual_operation = Concatenation( record.dual_operation, "WithGiven", coobject_name );
        record.with_given_object_position = nothing;

        return record;
    end;

    make_colimit = function ( limit, record )
      local orig_function_name;
        
        record = StructuralCopy( record );
        
        orig_function_name = record.function_name;
        record.function_name = record.dual_operation;
        record.dual_operation = orig_function_name;
        
        # reverse the output type, except if the input is reversed
        if IsBound( record.io_type ) && !(IsBound( record.dual_arguments_reversed ) && record.dual_arguments_reversed)
            record.io_type[2] = Reversed( record.io_type[2] );
            record.io_type[2] = List( record.io_type[2], x -> ReplacedString( x, "source", "tmp" ) );
            record.io_type[2] = List( record.io_type[2], x -> ReplacedString( x, "range", "source" ) );
            record.io_type[2] = List( record.io_type[2], x -> ReplacedString( x, "tmp", "range" ) );
        end;
        
        if IsBound( record.functorial )
            
            Assert( 0, record.functorial == limit.limit_functorial_name );
            
            record.functorial = limit.colimit_functorial_name;
            
        end;
        
        if IsBound( record.with_given_object_position )
            if record.with_given_object_position == "Source"
                record.with_given_object_position = "Range";
            elseif record.with_given_object_position == "Range"
                record.with_given_object_position = "Source";
            end;
        end;

        if IsBound( record.output_source_getter_string )
            record.output_source_getter_string = ReplacedString( record.output_source_getter_string, limit.limit_object_name, limit.colimit_object_name );
        end;
        
        if IsBound( record.output_range_getter_string )
            record.output_range_getter_string = ReplacedString( record.output_range_getter_string, limit.limit_object_name, limit.colimit_object_name );
        end;
        
        return record;
    end;

    for limit in limits
        
        #### get filter lists && io types
        object_filter_list = Concatenation( [ "category" ], StructuralCopy( limit.diagram_filter_list ) );
        
        # only used if limit.number_of_targets > 0
        projection_filter_list = Concatenation( [ "category" ], StructuralCopy( limit.diagram_filter_list ) );
        projection_io_type = [ StructuralCopy( limit.diagram_input_type ), [ ] ];
        if limit.number_of_targets > 1
            Add( projection_filter_list, IsInt );
            Add( projection_io_type[1], "k" );
        end;
        if limit.target_positions == limit.unbound_object_positions
            # io_type can be derived from the objects
            if limit.number_of_targets == 1
                projection_io_type[2] = [ "P", "X" ];
            else
                projection_io_type[2] = [ "P", "objects_k" ];
            end;
        elseif limit.target_positions == List( limit.unbound_morphism_positions, i -> limit.morphism_specification[i][1] )
            # io_type can be derived from the morphisms as sources
            if limit.number_of_unbound_morphisms == 1
                projection_io_type[2] = [ "P", "alpha_source" ];
            elseif limit.number_of_targets == 1
                projection_io_type[2] = [ "P", "Y" ];
            else
                projection_io_type[2] = [ "P", "morphisms_k_source" ];
            end;
        elseif limit.target_positions == List( limit.unbound_morphism_positions, i -> limit.morphism_specification[i][3] )
            # io_type can be derived from the morphisms as ranges
            if limit.number_of_unbound_morphisms == 1
                projection_io_type[2] = [ "P", "alpha_range" ];
            elseif limit.number_of_targets == 1
                projection_io_type[2] = [ "P", "Y" ];
            else
                projection_io_type[2] = [ "P", "morphisms_k_range" ];
            end;
        else
            Error( "Warning: can!express io_type" );
        end;

        # only used if limit.number_of_nontargets == 1
        morphism_to_sink_filter_list = Concatenation( [ "category" ], StructuralCopy( limit.diagram_filter_list ) );
        morphism_to_sink_io_type = [ StructuralCopy( limit.diagram_input_type ), [ ] ];
        if limit.number_of_unbound_morphisms == 1
            morphism_to_sink_io_type[2] = [ "P", "alpha_range" ];
        elseif limit.number_of_unbound_morphisms > 1
            morphism_to_sink_io_type[2] = [ "P", "morphisms_1_range" ];
        end;

        universal_morphism_filter_list = Concatenation( [ "category" ], StructuralCopy( limit.diagram_filter_list ), [ "object" ] );
        universal_morphism_io_type = [ Concatenation( StructuralCopy( limit.diagram_input_type ), [ "T" ] ), [ "T", "P" ] ];
        if limit.number_of_targets == 1
            Add( universal_morphism_filter_list, "morphism" );
            Add( universal_morphism_io_type[1], "tau" );
        elseif limit.number_of_targets > 1
            Add( universal_morphism_filter_list, "list_of_morphisms" );
            Add( universal_morphism_io_type[1], "tau" );
        end;

        
        #### get base records
        object_record =  rec(
            function_name = limit.limit_object_name,
            filter_list = object_filter_list,
            return_type = "object",
            dual_operation = limit.colimit_object_name,
            functorial = limit.limit_functorial_name,
        );

        if limit.number_of_targets > 0
            projection_record = rec(
                function_name = limit.limit_projection_name,
                filter_list = projection_filter_list,
                io_type = projection_io_type,
                with_given_object_position = "Source",
                return_type = "morphism",
                dual_operation = limit.colimit_injection_name,
            );
        end;

        if limit.number_of_nontargets == 1
            morphism_to_sink_record = rec(
                function_name = Concatenation( "MorphismFrom", limit.limit_object_name, "ToSink" ),
                filter_list = morphism_to_sink_filter_list,
                io_type = morphism_to_sink_io_type,
                with_given_object_position = "Source",
                return_type = "morphism",
                dual_operation = limit.colimit_morphism_from_source_name,
            );
        end;

        universal_morphism_record = rec(
            function_name = limit.limit_universal_morphism_name,
            filter_list = universal_morphism_filter_list,
            io_type = universal_morphism_io_type,
            with_given_object_position = "Range",
            return_type = "morphism",
            dual_operation = limit.colimit_universal_morphism_name,
        );
        
        functorial_record = rec(
            function_name = limit.limit_functorial_name,
            filter_list = Concatenation( [ "category" ], limit.diagram_filter_list, limit.diagram_morphism_filter_list, limit.diagram_filter_list ),
            input_arguments_names = Concatenation( [ "cat" ], limit.functorial_source_diagram_arguments_names, limit.diagram_morphism_input_type, limit.functorial_range_diagram_arguments_names ),
            return_type = "morphism",
            # object_name
            output_source_getter_string = ReplacedStringViaRecord(
                "object_name( arguments... )",
                rec( object_name = limit.limit_object_name, arguments = Concatenation( [ "cat" ], limit.functorial_source_diagram_arguments_names ) )
            ),
            output_range_getter_string = ReplacedStringViaRecord(
                "object_name( arguments... )",
                rec( object_name = limit.limit_object_name, arguments = Concatenation( [ "cat" ], limit.functorial_range_diagram_arguments_names ) )
            ),
            with_given_object_position = "both",
            dual_operation = limit.colimit_functorial_name,
            dual_arguments_reversed = true,
        );
        
        functorial_with_given_record = rec(
            function_name = limit.limit_functorial_with_given_name,
            filter_list = Concatenation( [ "category", "object" ], limit.diagram_filter_list, limit.diagram_morphism_filter_list, limit.diagram_filter_list, [ "object" ] ),
            io_type = [ Concatenation( [ "P" ], limit.functorial_source_diagram_arguments_names, limit.diagram_morphism_input_type, limit.functorial_range_diagram_arguments_names, [ "Pp" ] ), [ "P", "Pp" ] ],
            return_type = "morphism",
            dual_operation = limit.colimit_functorial_with_given_name,
            dual_arguments_reversed = true,
        );
        
        if limit.number_of_unbound_morphisms == 0
            
            # The diagram has only objects as input -> all operations are compatible with the congruence of morphisms:
            # For the universal morphisms && functorials, this follows from the universal property.
            # All other operations are automatically compatible because they do !have morphisms as input.
            
            # if limit.number_of_targets == 0, the universal morphism has no test morphism as input anyway
            if limit.number_of_targets > 0
                
                universal_morphism_record.compatible_with_congruence_of_morphisms = true;
                functorial_record.compatible_with_congruence_of_morphisms = true;
                functorial_with_given_record.compatible_with_congruence_of_morphisms = true;
                
            end;
            
        else
            
            # The universal object might depend on the morphism datum.
            # Thus, the operations are ⥉ general !compatible with the congruence of morphisms.
            
            object_record.compatible_with_congruence_of_morphisms = false;
            projection_record.compatible_with_congruence_of_morphisms = false;
            morphism_to_sink_record.compatible_with_congruence_of_morphisms = false;
            universal_morphism_record.compatible_with_congruence_of_morphisms = false;
            functorial_record.compatible_with_congruence_of_morphisms = false;
            functorial_with_given_record.compatible_with_congruence_of_morphisms = false;
            
        end;
        
        #### validate limit records
        CAP_INTERNAL_IS_EQUAL_FOR_METHOD_RECORD_ENTRIES( method_name_record, limit.limit_object_name, object_record );
        
        if limit.number_of_targets > 0
            CAP_INTERNAL_IS_EQUAL_FOR_METHOD_RECORD_ENTRIES( method_name_record, limit.limit_projection_name, projection_record );
            CAP_INTERNAL_IS_EQUAL_FOR_METHOD_RECORD_ENTRIES( method_name_record, limit.limit_projection_with_given_name, make_record_with_given( projection_record, limit.limit_object_name, limit.colimit_object_name ) );
        end;
        
        if limit.number_of_nontargets == 1
            CAP_INTERNAL_IS_EQUAL_FOR_METHOD_RECORD_ENTRIES( method_name_record, limit.limit_morphism_to_sink_name, morphism_to_sink_record );
            CAP_INTERNAL_IS_EQUAL_FOR_METHOD_RECORD_ENTRIES( method_name_record, Concatenation( limit.limit_morphism_to_sink_name, "WithGiven", limit.limit_object_name ), make_record_with_given( morphism_to_sink_record, limit.limit_object_name, limit.colimit_object_name ) );
        end;
        
        CAP_INTERNAL_IS_EQUAL_FOR_METHOD_RECORD_ENTRIES( method_name_record, limit.limit_universal_morphism_name, universal_morphism_record );
        CAP_INTERNAL_IS_EQUAL_FOR_METHOD_RECORD_ENTRIES( method_name_record, limit.limit_universal_morphism_with_given_name, make_record_with_given( universal_morphism_record, limit.limit_object_name, limit.colimit_object_name ) );
        
        # GAP has a limit of 6 arguments per operation -> operations which would have more than 6 arguments have to work around this
        if Length( functorial_with_given_record.filter_list ) <= 6
            
            CAP_INTERNAL_IS_EQUAL_FOR_METHOD_RECORD_ENTRIES( method_name_record, functorial_record.function_name, functorial_record );
            CAP_INTERNAL_IS_EQUAL_FOR_METHOD_RECORD_ENTRIES( method_name_record, functorial_with_given_record.function_name, functorial_with_given_record );
            
        end;
        
        #### validate colimit records
        CAP_INTERNAL_IS_EQUAL_FOR_METHOD_RECORD_ENTRIES( method_name_record, limit.colimit_object_name, make_colimit( limit, object_record ) );
        
        if limit.number_of_targets > 0
            CAP_INTERNAL_IS_EQUAL_FOR_METHOD_RECORD_ENTRIES( method_name_record, limit.colimit_injection_name, make_colimit( limit, projection_record ) );
            CAP_INTERNAL_IS_EQUAL_FOR_METHOD_RECORD_ENTRIES( method_name_record, limit.colimit_injection_with_given_name, make_record_with_given( make_colimit( limit, projection_record ), limit.colimit_object_name, limit.limit_object_name ) );
        end;
        
        if limit.number_of_nontargets == 1
            CAP_INTERNAL_IS_EQUAL_FOR_METHOD_RECORD_ENTRIES( method_name_record, limit.colimit_morphism_from_source_name, make_colimit( limit, morphism_to_sink_record ) );
            CAP_INTERNAL_IS_EQUAL_FOR_METHOD_RECORD_ENTRIES( method_name_record, Concatenation( limit.colimit_morphism_from_source_name, "WithGiven", limit.colimit_object_name ), make_record_with_given( make_colimit( limit, morphism_to_sink_record ), limit.colimit_object_name, limit.limit_object_name ) );
        end;
        
        CAP_INTERNAL_IS_EQUAL_FOR_METHOD_RECORD_ENTRIES( method_name_record, limit.colimit_universal_morphism_name, make_colimit( limit, universal_morphism_record ) );
        CAP_INTERNAL_IS_EQUAL_FOR_METHOD_RECORD_ENTRIES( method_name_record, limit.colimit_universal_morphism_with_given_name, make_record_with_given( make_colimit( limit, universal_morphism_record ), limit.colimit_object_name, limit.limit_object_name ) );
        
        # GAP has a limit of 6 arguments per operation -> operations which would have more than 6 arguments have to work around this
        if Length( functorial_with_given_record.filter_list ) <= 6
            
            CAP_INTERNAL_IS_EQUAL_FOR_METHOD_RECORD_ENTRIES( method_name_record, functorial_record.dual_operation, make_colimit( limit, functorial_record ) );
            CAP_INTERNAL_IS_EQUAL_FOR_METHOD_RECORD_ENTRIES( method_name_record, functorial_with_given_record.dual_operation, make_colimit( limit, functorial_with_given_record ) );
            
        end;
        
    end;
    
end );

CAP_INTERNAL_VALIDATE_LIMITS_IN_NAME_RECORD( CAP_INTERNAL_METHOD_NAME_RECORD, CAP_INTERNAL_METHOD_NAME_RECORD_LIMITS );


InstallValue( CAP_INTERNAL_METHOD_RECORD_REPLACEMENTS, rec() );

InstallGlobalFunction( CAP_INTERNAL_ADD_REPLACEMENTS_FOR_METHOD_RECORD,
  function( replacement_data )
    local current_name;

    for current_name in RecNames( replacement_data )
        if IsBound( CAP_INTERNAL_METHOD_RECORD_REPLACEMENTS[current_name] )
            Error( Concatenation( current_name, " already has a replacement" ) );
        end;
        CAP_INTERNAL_METHOD_RECORD_REPLACEMENTS[current_name] = replacement_data[current_name];
    end;
    
end );

InstallValue( CAP_INTERNAL_OPPOSITE_PROPERTY_PAIRS_FOR_OBJECTS, [ ] );

InstallValue( CAP_INTERNAL_OPPOSITE_PROPERTY_PAIRS_FOR_MORPHISMS, [ ] );

InstallValue( CAP_INTERNAL_FIND_OPPOSITE_PROPERTY_PAIRS_IN_METHOD_NAME_RECORD,
  function( method_name_record )
    local recnames, current_recname, current_entry, current_rec, category_property_list, elem;
    
    recnames = RecNames( method_name_record );
    
    for current_recname in recnames
        
        current_rec = method_name_record[current_recname];
        
        if !IsBound( current_rec.property_of )
            continue;
        end;
        
        if !IsBound( current_rec.dual_operation ) || current_rec.dual_operation == current_recname
            
            current_entry = current_rec.installation_name;
            
        else
            
            current_entry = [ current_rec.installation_name, method_name_record[current_rec.dual_operation].installation_name ];
            current_entry = [ Concatenation( current_entry[ 1 ], " vs ", current_entry[ 2 ] ), current_entry ];
            
        end;
        
        if method_name_record[current_recname].property_of == "object"
            
            if !current_entry ⥉ CAP_INTERNAL_OPPOSITE_PROPERTY_PAIRS_FOR_OBJECTS
                
                Add( CAP_INTERNAL_OPPOSITE_PROPERTY_PAIRS_FOR_OBJECTS, current_entry );
                
            end;
            
        elseif method_name_record[current_recname].property_of == "morphism"
            
            if !current_entry ⥉ CAP_INTERNAL_OPPOSITE_PROPERTY_PAIRS_FOR_MORPHISMS
                
                Add( CAP_INTERNAL_OPPOSITE_PROPERTY_PAIRS_FOR_MORPHISMS, current_entry );
                
            end;
            
        else
            
            Error( "this should never happen" );
            
        end;
        
    end;
    
end );

BindGlobal( "CAP_INTERNAL_PREPARE_INHERITED_PRE_FUNCTION",
  function( func, drop_both )
    
    if drop_both
        
        return function( arg_list... )
            # drop second && last argument
            return CallFuncList( func, arg_list[Concatenation( [ 1 ], (3):(Length( arg_list ) - 1) )] );
        end;
        
    else
        
        return function( arg_list... )
            # drop last argument
            return CallFuncList( func, arg_list[(1):(Length( arg_list ) - 1)] );
        end;
        
    end;
    
end );

BindGlobal( "CAP_INTERNAL_CREATE_REDIRECTION",
  
  function( without_given_name, with_given_name, object_function_name, object_arguments_positions )
    local object_function, with_given_name_function, record, attribute_tester;
    
    object_function = ValueGlobal( object_function_name );
    
    with_given_name_function = ValueGlobal( with_given_name );
    
    if !IsAttribute( object_function )
        
        return function( arg... )
          local category, without_given_weight, with_given_weight, object_args, cache, cache_value;
            
            category = arg[ 1 ];
            
            without_given_weight = CurrentOperationWeight( category.derivations_weight_list, without_given_name );
            with_given_weight = CurrentOperationWeight( category.derivations_weight_list, with_given_name );
            
            # If the WithGiven version is more expensive than the WithoutGiven version, redirection makes no sense &&
            # might even lead to inifite loops if the WithGiven version is derived from the WithoutGiven version.
            if with_given_weight > without_given_weight
                
                return [ false ];
                
            end;
            
            object_args = arg[ object_arguments_positions ];
            
            cache = GET_METHOD_CACHE( category, object_function_name, Length( object_arguments_positions ) );
            
            cache_value = CallFuncList( CacheValue, [ cache, object_args ] );
            
            if cache_value == [ ]
                
                return [ false ];
                
            end;
            
            return [ true, CallFuncList( with_given_name_function, Concatenation( arg, [ cache_value[ 1 ] ] ) ) ];
            
        end;
        
    else
        
        if !Length( object_arguments_positions ) ⥉ [ 1, 2 ]
            
            Error( "we can only handle attributes of the category || of a single object/morphism/twocell" );
            
        end;
        
        attribute_tester = Tester( object_function );
        
        return function( arg... )
          local category, without_given_weight, with_given_weight, object_args, cache_value, cache;
            
            category = arg[ 1 ];
            
            without_given_weight = CurrentOperationWeight( category.derivations_weight_list, without_given_name );
            with_given_weight = CurrentOperationWeight( category.derivations_weight_list, with_given_name );
            
            # If the WithGiven version is more expensive than the WithoutGiven version, redirection makes no sense &&
            # might even lead to inifite loops if the WithGiven version is derived from the WithoutGiven version.
            if with_given_weight > without_given_weight
                
                return [ false ];
                
            end;
            
            object_args = arg[ object_arguments_positions ];

            if attribute_tester( object_args[ Length( object_args ) ] )
                
                cache_value = [ object_function( object_args[ Length( object_args ) ] ) ];
                
            else
                
                cache = GET_METHOD_CACHE( category, object_function_name, Length( object_arguments_positions ) );
                
                cache_value = CallFuncList( CacheValue, [ cache, object_args ] );
                
                if cache_value == [ ]
                    
                    return [ false ];
                    
                end;
                
            end;
            
            return [ true, CallFuncList( with_given_name_function, Concatenation( arg, [ cache_value[ 1 ] ] ) ) ];
            
        end;
        
    end;
    
end );

BindGlobal( "CAP_INTERNAL_CREATE_POST_FUNCTION",
  
  function( source_range_object, object_function_name, object_arguments_positions )
    local object_getter, object_function, setter_function, cache_key_length;
    
    if source_range_object == "Source"
        object_getter = Source;
    elseif source_range_object == "Range"
        object_getter = Range;
    else
        Error( "the first argument of CAP_INTERNAL_CREATE_POST_FUNCTION must be 'Source' || 'Range'" );
    end;
    
    object_function = ValueGlobal( object_function_name );
    
    cache_key_length = Length( object_arguments_positions );
    
    if !IsAttribute( object_function )
    
        return function( arg... )
            local result, object, category;
            
            category = arg[ 1 ];
            
            result = arg[ Length( arg ) ];
            Remove( arg );
            object = object_getter( result );
            
            SET_VALUE_OF_CATEGORY_CACHE( category, object_function_name, cache_key_length, arg[ object_arguments_positions ], object );
            
        end;
        
    else
        
        if !Length( object_arguments_positions ) ⥉ [ 1, 2 ]
            
            Error( "we can only handle attributes of the category || of a single object/morphism/twocell" );
            
        end;
        
        setter_function = Setter( object_function );
        
        return function( arg... )
          local category, object_args, result, object;
            
            category = arg[ 1 ];

            object_args = arg[ object_arguments_positions ];
            
            result = arg[ Length( arg ) ];
            Remove( arg );
            object = object_getter( result );
            
            SET_VALUE_OF_CATEGORY_CACHE( category, object_function_name, cache_key_length, arg[ object_arguments_positions ], object );
            setter_function( object_args[ Length( object_args ) ], object );
            
        end;
        
    end;
    
end );

BindGlobal( "CAP_INTERNAL_CREATE_NEW_FUNC_WITH_ONE_MORE_ARGUMENT_WITH_RETURN",
  
  function( func )
    
    return function( arg... ) return CallFuncList( func, arg[(2):(Length( arg ))] ); end;
    
end );

BindGlobal( "CAP_INTERNAL_CREATE_NEW_FUNC_WITH_ONE_MORE_ARGUMENT_WITHOUT_RETURN",
  
  function( func )
    
    return function( arg... ) CallFuncList( func, arg[(2):(Length( arg ))] ); end;
    
end );

InstallGlobalFunction( CAP_INTERNAL_ENHANCE_NAME_RECORD,
  function( record )
    local recnames, current_recname, current_rec, io_type, number_of_arguments, func_string,
          installation_name, output_list, input_list, argument_names, return_list, current_output, input_position, list_position,
          without_given_name, with_given_names, with_given_name, without_given_rec, with_given_object_position, object_name,
          object_filter_list, with_given_object_filter, given_source_argument_name, given_range_argument_name, with_given_rec, i,
          can_always_compute_output_source_getter, can_always_compute_output_range_getter;
    
    recnames = RecNames( record );
    
    # loop before detecting With(out)Given pairs
    for current_recname in recnames
        
        current_rec = record[current_recname];
        
        # validity checks
        if !IsBound( current_rec.return_type )
            Error( "<current_rec> has no return_type" );
        end;
        
        if !( IsFilter( current_rec.return_type ) || current_rec.return_type ⥉ CAP_INTERNAL_VALID_RETURN_TYPES )
            Error( "the return_type of <current_rec> is !a filter && does !appear ⥉ CAP_INTERNAL_VALID_RETURN_TYPES" );
        end;
        
        if IsBound( current_rec.argument_list )
            
            Display( Concatenation( 
                "WARNING: the functionality previously provided by `argument_list` was removed. You will probably run into errors. ",
                "Please use the category as the first argument instead of method selections objects/morphisms && adjust pre, post && redirect functions as well as derivations appropriately. ",
                "Search for `category_as_first_argument` in the documentation for more details."
            ) );
            
        end;
        
        if current_rec.filter_list[1] != "category"
            
            Error( "The first entry of `filter_list` must be the string \"category\". Search for `category_as_first_argument` in the documentation for more details." );
            
        end;
        
        if IsBound( current_rec.io_type )
            
            io_type = current_rec.io_type;
            
            if !IsList( io_type ) || Length( io_type ) != 2
                Error( "the io_type of <current_rec> is !a list of length 2" );
            end;
            
            if !ForAll( io_type[1], x -> IsString( x ) )
                Error( "the input type of <current_rec> contains non-strings" );
            end;
            
            # the category is excluded ⥉ the io_type
            if Length( io_type[1] ) != Length( current_rec.filter_list ) - 1
                
                Error( "the input type of <current_rec> has the wrong length" );
                
            end;
            
        end;
        
        current_rec.function_name = current_recname;
        
        if IsBound( current_rec.pre_function ) && IsString( current_rec.pre_function )
            
            if IsBound( record[current_rec.pre_function] ) && IsBound( record[current_rec.pre_function].pre_function ) && IsFunction( record[current_rec.pre_function].pre_function )
                
                current_rec.pre_function = record[current_rec.pre_function].pre_function;
                
            else
                
                Error( "Could !find pre function for ", current_recname, ". ", current_rec.pre_function, " is !the name of an operation in the record, has no pre function, || has itself a string as pre function." );
                
            end;
            
        end;
        
        if IsBound( current_rec.pre_function_full ) && IsString( current_rec.pre_function_full )
            
            if IsBound( record[current_rec.pre_function_full] ) && IsBound( record[current_rec.pre_function_full].pre_function_full ) && IsFunction( record[current_rec.pre_function_full].pre_function_full )
                
                current_rec.pre_function_full = record[current_rec.pre_function_full].pre_function_full;
                
            else
                
                Error( "Could !find full pre function for ", current_recname, ". ", current_rec.pre_function_full, " is !the name of an operation in the record, has no full pre function, || has itself a string as full pre function." );
                
            end;
            
        end;
        
        if IsBound( current_rec.redirect_function ) && IsString( current_rec.redirect_function )
            
            if IsBound( record[current_rec.redirect_function] ) && IsBound( record[current_rec.redirect_function].redirect_function ) && IsFunction( record[current_rec.redirect_function].redirect_function )
                
                current_rec.redirect_function = record[current_rec.redirect_function].redirect_function;
                
            else
                
                Error( "Could !find redirect function for ", current_recname, ". ", current_rec.redirect_function, " is !the name of an operation in the record, has no redirect function, || has itself a string as redirect function." );
                
            end;
            
        end;
        
        number_of_arguments = Length( current_rec.filter_list );
        
        if IsBound( current_rec.pre_function ) && NumberArgumentsFunction( current_rec.pre_function ) >= 0 && NumberArgumentsFunction( current_rec.pre_function ) != number_of_arguments
            Error( "the pre function of <current_rec> has the wrong number of arguments" );
        end;
        
        if IsBound( current_rec.pre_function_full ) && NumberArgumentsFunction( current_rec.pre_function_full ) >= 0 && NumberArgumentsFunction( current_rec.pre_function_full ) != number_of_arguments
            Error( "the full pre function of <current_rec> has the wrong number of arguments" );
        end;
        
        if IsBound( current_rec.redirect_function ) && NumberArgumentsFunction( current_rec.redirect_function ) >= 0 && NumberArgumentsFunction( current_rec.redirect_function ) != number_of_arguments
            Error( "the redirect function of <current_rec> has the wrong number of arguments" );
        end;
        
        if IsBound( current_rec.post_function ) && NumberArgumentsFunction( current_rec.post_function ) >= 0 && NumberArgumentsFunction( current_rec.post_function ) != number_of_arguments + 1
            Error( "the post function of <current_rec> has the wrong number of arguments" );
        end;
        
        if IsBound( current_rec.dual_preprocessor_func ) && NumberArgumentsFunction( current_rec.dual_preprocessor_func ) >= 0 && NumberArgumentsFunction( current_rec.dual_preprocessor_func ) != number_of_arguments
            Error( "the dual preprocessor function of ", current_recname, " has the wrong number of arguments" );
        end;
        
        if !ForAll( current_rec.filter_list, x -> IsString( x ) || IsFilter( x ) )
            Error( "the filter list of ", current_recname, " does !fulfill the requirements" );
        end;
        
        if !IsBound( current_rec.install_convenience_without_category )
            
            if ForAny( [ "object", "morphism", "twocell", "list_of_objects", "list_of_morphisms" ], filter -> filter ⥉ current_rec.filter_list )
                
                current_rec.install_convenience_without_category = true;
                
            else
                
                current_rec.install_convenience_without_category = false;
                
            end;
            
        end;
        
        if IsBound( current_rec.universal_object_position )
            
            Display( "WARNING: universal_object_position was renamed to with_given_object_position" );
            
            current_rec.with_given_object_position = current_rec.universal_object_position;
            
        end;
        
        if IsBound( current_rec.with_given_object_position ) && !current_rec.with_given_object_position ⥉ [ "Source", "Range", "both" ]
            
            Error( "with_given_object_position must be one of the strings \"Source\", \"Range\", || \"both\", !", current_rec.with_given_object_position );
            
        end;
        
        if !IsBound( current_rec.is_with_given )
            
            current_rec.is_with_given = false;
            
        end;
        
        if !IsBound( current_rec.with_given_without_given_name_pair )
            
            current_rec.with_given_without_given_name_pair = fail;
            
        end;
        
        if IsBound( current_rec.dual_operation )
            
            # check that dual of the dual is the original operation
            
            if !IsBound( record[current_rec.dual_operation] )
                
                Error( "the dual operation must be added ⥉ the same call to `CAP_INTERNAL_ENHANCE_NAME_RECORD`" );
                
            end;
            
            if !IsBound( record[current_rec.dual_operation].dual_operation )
                
                Error( "the dual operation of ", current_recname, ", i.e. ", current_rec.dual_operation, ", has no dual operation"  );
                
            end;
            
            if record[current_rec.dual_operation].dual_operation != current_recname
                
                Error( "the dual operation of ", current_recname, ", i.e. ", current_rec.dual_operation, ", has the unexpected dual operation ", record[current_rec.dual_operation].dual_operation  );
                
            end;
            
        end;
        
        if !IsBound( current_rec.dual_arguments_reversed )
            
            current_rec.dual_arguments_reversed = false;
            
        end;
        
        if Length( Filtered( [ "dual_preprocessor_func", "dual_arguments_reversed", "dual_with_given_objects_reversed" ],
                             name -> IsBound( current_rec[name] ) && ( IsFunction( current_rec[name] ) || current_rec[name] == true )
                           ) ) >= 2
            
            Error( "dual_preprocessor_func, dual_arguments_reversed == true && dual_with_given_objects_reversed == true are mutually exclusive" );
            
        end;
        
        if IsOperation( ValueGlobal( current_recname ) )
            
            installation_name = current_recname;
            
        elseif IsFunction( ValueGlobal( current_recname ) )
            
            installation_name = Concatenation( current_recname, "Op" );
            
        else
            
            Error( "`ValueGlobal( current_recname )` is neither an operation nor a function" );
            
        end;
        
        if IsBound( current_rec.installation_name )
            
            if current_rec.installation_name != installation_name
                
                Display( Concatenation(
                    "WARNING: Manually setting installation_name is !supported anymore. You will probably run into errors. ",
                    "To avoid this warning, remove installation_name from the method record ",
                    "and make sure your code supports the automatically chosen installation name \"", installation_name, "\"."
                ) );
                
            end;
            
        else
            
            current_rec.installation_name = installation_name;
            
        end;
        
        if IsBound( current_rec.cache_name ) && current_rec.cache_name != current_rec.function_name
            
            Display( Concatenation(
                "WARNING: Manually setting cache_name is !supported anymore. The function name will be used instead. ",
                "To avoid this warning, remove cache_name from the method record."
            ) );
            
        end;
        
        if IsBound( current_rec.zero_arguments_for_add_method )
            
            Display( "zero_arguments_for_add_method has no effect anymore, please remove it." );
            
        end;
        
        if IsBound( current_rec.number_of_diagram_arguments )
            
            Display( "number_of_diagram_arguments has no effect anymore, please remove it." );
            
        end;
        
        if !IsBound( current_rec.input_arguments_names )
            
            if IsBound( current_rec.io_type )
                
                current_rec.input_arguments_names = Concatenation( [ "cat" ], current_rec.io_type[1] );
                
            else
                
                current_rec.input_arguments_names = Concatenation( [ "cat" ], List( (2):(Length( current_rec.filter_list )), i -> Concatenation( "arg", string( i ) ) ) );
                
            end;
            
        end;
        
        if current_rec.input_arguments_names[1] != "cat"
            
            Error( "the category argument must always be called \"cat\", please adjust the method record entry of ", current_recname );
            
        end;
        
        if !ForAll( current_rec.input_arguments_names, x -> IsString( x ) )
            
            Error( "the entries of input_arguments_names must be strings, please adjust the method record entry of ", current_recname );
            
        end;
        
        if !IsDuplicateFreeList( current_rec.input_arguments_names )
            
            Error( "input_arguments_names must be duplicate free, please adjust the method record entry of ", current_recname );
            
        end;
        
        if IsBound( current_rec.io_type ) && current_rec.return_type == "morphism" && !IsString( current_rec.io_type[ 2 ] ) && IsList( current_rec.io_type[ 2 ] )
            
            output_list = current_rec.io_type[ 2 ];
            
            if Length( output_list ) != 2
                
                Error( "the output type is !a list of length 2" );
                
            end;
            
            output_list = List( output_list, i -> SplitString( i, "_" ) );
            
            input_list = current_rec.io_type[ 1 ];
            
            argument_names = input_list;
            
            return_list = List( (1):(Length( output_list )), function ( i )
              local current_output, input_position, list_position;
                
                current_output = output_list[ i ];
                
                input_position = Position( input_list, current_output[ 1 ] );
                
                if input_position == fail
                    
                    return fail;
                    
                end;
                
                if Length( current_output ) == 1
                    
                   return argument_names[ input_position ];
                   
                elseif Length( current_output ) == 2
                    
                    if LowercaseString( current_output[ 2 ] ) == "source"
                        return Concatenation( "Source( ", argument_names[ input_position ], " )" );
                    elseif LowercaseString( current_output[ 2 ] ) == "range"
                        return Concatenation( "Range( ", argument_names[ input_position ], " )" );
                    elseif Position( input_list, current_output[ 2 ] ) != fail
                        return Concatenation( argument_names[ input_position ], "[", argument_names[ Position( input_list, current_output[ 2 ] ) ], "]" );
                    else
                        Error( "wrong input type" );
                    end;
                    
                elseif Length( current_output ) == 3
                    
                    if ForAll( current_output[ 2 ], i -> i ⥉ "0123456789" )
                        list_position = string( int( current_output[ 2 ] ) );
                    else
                        list_position = Position( input_list, current_output[ 2 ] );
                        if list_position == fail
                            Error( "unable to find ", current_output[ 2 ], " ⥉ input_list" );
                        end;
                        list_position = argument_names[ list_position ];
                    end;
                    
                    if list_position == fail
                        Error( "list index variable !found" );
                    end;
                    
                    if LowercaseString( current_output[ 3 ] ) == "source"
                        return Concatenation( "Source( ", argument_names[ input_position ], "[", list_position, "] )" );
                    elseif LowercaseString( current_output[ 3 ] ) == "range"
                        return Concatenation( "Range( ", argument_names[ input_position ], "[", list_position, "] )" );
                    else
                        Error( "wrong output syntax" );
                    end;
                    
                else
                    
                    Error( "wrong entry length" );
                    
                end;
                
            end );
            
            if return_list[1] != fail
                
                current_rec.output_source_getter_string = return_list[1];
                current_rec.can_always_compute_output_source_getter = true;
                
            end;
            
            if return_list[2] != fail
                
                current_rec.output_range_getter_string = return_list[2];
                current_rec.can_always_compute_output_range_getter = true;
                
            end;
            
        end;
        
        if ForAll( current_rec.filter_list, x -> x ⥉ [ IsInt, IsRingElement, "category", "object", "object_in_range_category_of_homomorphism_structure", "other_object", "list_of_objects", "nonneg_integer_or_Inf" ] )
            
            if !IsBound( current_rec.compatible_with_congruence_of_morphisms )
                
                current_rec.compatible_with_congruence_of_morphisms = true;
                
            end;
            
            if current_rec.compatible_with_congruence_of_morphisms != true
                
                Error( current_recname, " does !depend on morphisms but is still marked as !compatible with the congruence of morphisms" );
                
            end;
            
        end;
        
    end;
    
    # detect With(out)Given pairs
    for current_recname in recnames
        
        current_rec = record[current_recname];
        
        if IsBound( current_rec.with_given_object_position )
            
            if PositionSublist( current_recname, "WithGiven" ) != fail
                
                Error( "WithGiven operations must NOT have the component with_given_object_position set, please adjust the method record entry of ", current_recname );
                
            end;
            
            without_given_name = current_recname;
            
            with_given_names = Filtered( recnames, x -> StartsWith( x, Concatenation( without_given_name, "WithGiven" ) ) );
            
            if Length( with_given_names ) != 1
                
                Error( "Could !find unique WithGiven version for ", without_given_name );
                
            end;
            
            with_given_name = with_given_names[1];
            
            without_given_rec = record[without_given_name];
            
            with_given_object_position = without_given_rec.with_given_object_position;
            
            object_name = ReplacedString( with_given_name, Concatenation( without_given_name, "WithGiven" ), "" );
            
            # generate output_source_getter_string resp. output_range_getter_string automatically if possible
            if object_name ⥉ recnames
                
                object_filter_list = record[object_name].filter_list;
                
                if with_given_object_position == "Source"
                    
                    if !IsBound( without_given_rec.output_source_getter_string )
                        
                        without_given_rec.output_source_getter_string = Concatenation( object_name, "( ", JoinStringsWithSeparator( without_given_rec.input_arguments_names[(1):(Length( object_filter_list ))], ", " ), " )" );
                        
                    end;
                    
                end;
                
                if with_given_object_position == "Range"
                    
                    if !IsBound( without_given_rec.output_range_getter_string )
                        
                        without_given_rec.output_range_getter_string = Concatenation( object_name, "( ", JoinStringsWithSeparator( without_given_rec.input_arguments_names[(1):(Length( object_filter_list ))], ", " ), " )" );
                        
                    end;
                    
                end;
                
            end;
            
            # plausibility checks for without_given_rec
            if with_given_object_position ⥉ [ "Source", "both" ]
                
                if !IsBound( without_given_rec.output_source_getter_string )
                    
                    Error( "This is a WithoutGiven record, but output_source_getter_string is !set. This is !supported." );
                    
                end;
                
            end;
            
            if with_given_object_position ⥉ [ "Range", "both" ]
                
                if !IsBound( without_given_rec.output_range_getter_string )
                    
                    Error( "This is a WithoutGiven record, but output_range_getter_string is !set. This is !supported." );
                    
                end;
                
            end;
            
            if !without_given_rec.return_type ⥉ [ "morphism", "morphism_in_range_category_of_homomorphism_structure", "other_morphism" ]
                
                Error( "This is a WithoutGiven record, but return_type is neither \"morphism\" nor \"morphism_in_range_category_of_homomorphism_structure\" nor \"other_morphism\". This is !supported." );
                
            end;
            
            # generate with_given_rec
            if without_given_rec.return_type == "morphism"
                
                with_given_object_filter = "object";
                
            elseif without_given_rec.return_type == "morphism_in_range_category_of_homomorphism_structure"
                
                with_given_object_filter = "object_in_range_category_of_homomorphism_structure";
                
            elseif without_given_rec.return_type == "other_morphism"
                
                with_given_object_filter = "other_object";
                
            else
                
                Error( "this should never happen" );
                
            end;
            
            if with_given_object_position == "Source"
                
                given_source_argument_name = Last( record[with_given_name].input_arguments_names );
                
            elseif with_given_object_position == "Range"
                
                given_range_argument_name = Last( record[with_given_name].input_arguments_names );
                
            else
                
                given_source_argument_name = record[with_given_name].input_arguments_names[2];
                given_range_argument_name = Last( record[with_given_name].input_arguments_names );
                
            end;
            
            with_given_rec = rec(
                return_type = without_given_rec.return_type,
            );
            
            if with_given_object_position == "Source"
                
                with_given_rec.filter_list = Concatenation( without_given_rec.filter_list, [ with_given_object_filter ] );
                with_given_rec.input_arguments_names = Concatenation( without_given_rec.input_arguments_names, [ given_source_argument_name ] );
                
                if IsBound( record[with_given_name].output_source_getter_string )
                    
                    with_given_rec.output_source_getter_string = given_source_argument_name;
                    
                end;
                
                if IsBound( without_given_rec.output_range_getter_string )
                    
                    with_given_rec.output_range_getter_string = without_given_rec.output_range_getter_string;
                    
                end;
                
            elseif with_given_object_position == "Range"
                
                with_given_rec.filter_list = Concatenation( without_given_rec.filter_list, [ with_given_object_filter ] );
                with_given_rec.input_arguments_names = Concatenation( without_given_rec.input_arguments_names, [ given_range_argument_name ] );
                
                if IsBound( record[with_given_name].output_range_getter_string )
                    
                    with_given_rec.output_range_getter_string = given_range_argument_name;
                    
                end;
                
                if IsBound( without_given_rec.output_source_getter_string )
                    
                    with_given_rec.output_source_getter_string = without_given_rec.output_source_getter_string;
                    
                end;
                
            elseif with_given_object_position == "both"
                
                with_given_rec.filter_list = Concatenation(
                    [ without_given_rec.filter_list[1] ],
                    [ with_given_object_filter ],
                    without_given_rec.filter_list[(2):(Length( without_given_rec.filter_list ))],
                    [ with_given_object_filter ]
                );
                with_given_rec.input_arguments_names = Concatenation(
                    [ without_given_rec.input_arguments_names[1] ],
                    [ given_source_argument_name ],
                    without_given_rec.input_arguments_names[(2):(Length( without_given_rec.input_arguments_names ))],
                    [ given_range_argument_name ]
                );
                
                if IsBound( record[with_given_name].output_source_getter_string )
                    
                    with_given_rec.output_source_getter_string = given_source_argument_name;
                    
                end;
                
                if IsBound( record[with_given_name].output_range_getter_string )
                    
                    with_given_rec.output_range_getter_string = given_range_argument_name;
                    
                end;
                
            else
                
                Error( "this should never happen" );
                
            end;
            
            CAP_INTERNAL_IS_EQUAL_FOR_METHOD_RECORD_ENTRIES( record, with_given_name, with_given_rec; subset_only = true );
            
            # now enhance the actual with_given_rec
            with_given_rec = record[with_given_name];
            
            if IsBound( without_given_rec.pre_function ) && !IsBound( with_given_rec.pre_function )
                with_given_rec.pre_function = CAP_INTERNAL_PREPARE_INHERITED_PRE_FUNCTION( record[without_given_name].pre_function, with_given_object_position == "both" );
            end;
            
            if IsBound( without_given_rec.pre_function_full ) && !IsBound( with_given_rec.pre_function_full )
                with_given_rec.pre_function_full = CAP_INTERNAL_PREPARE_INHERITED_PRE_FUNCTION( record[without_given_name].pre_function_full, with_given_object_position == "both" );
            end;
            
            with_given_rec.is_with_given = true;
            with_given_rec.with_given_without_given_name_pair = [ without_given_name, with_given_name ];
            without_given_rec.with_given_without_given_name_pair = [ without_given_name, with_given_name ];
            
            if object_name ⥉ recnames
                
                if with_given_object_position == "both"
                    
                    Error( "with_given_object_position is \"both\", but the WithGiven name suggests that only a single object of name ", object_name, " is given. This is !supported." );
                    
                end;
                
                with_given_rec.with_given_object_name = object_name;
                
                object_filter_list = record[object_name].filter_list;
                
                if with_given_object_position == "Source"
                    
                    if !StartsWith( without_given_rec.output_source_getter_string, object_name )
                        
                        Error( "the output_source_getter_string of the WithoutGiven record does !call the detected object ", object_name );
                        
                    end;
                    
                end;
                
                if with_given_object_position == "Range"
                    
                    if !StartsWith( without_given_rec.output_range_getter_string, object_name )
                        
                        Error( "the output_range_getter_string of the WithoutGiven record does !call the detected object ", object_name );
                        
                    end;
                    
                end;
                
                if !StartsWith( without_given_rec.filter_list, object_filter_list )
                    
                    Error( "the object arguments must be the first arguments of the without given method, but the corresponding filters do !match" );
                    
                end;
                
                if !IsBound( without_given_rec.redirect_function )
                    
                    if Length( record[without_given_name].filter_list ) + 1 != Length( record[with_given_name].filter_list )
                        
                        Display( Concatenation(
                            "WARNING: You seem to be relying on automatically installed redirect functions. ",
                            "For this, the with given method must have exactly one additional argument compared to the without given method. ",
                            "This is !the case, so no automatic redirect function will be installed. ",
                            "Install a custom redirect function to prevent this warning."
                        ) );
                        
                    else
                        
                        without_given_rec.redirect_function = CAP_INTERNAL_CREATE_REDIRECTION( without_given_name, with_given_name, object_name, (1):(Length( object_filter_list )) );
                        
                    end;
                    
                end;
                
                if !IsBound( without_given_rec.post_function )
                    
                    without_given_rec.post_function = CAP_INTERNAL_CREATE_POST_FUNCTION( with_given_object_position, object_name, (1):(Length( object_filter_list )) );
                    
                end;
                
            end;
            
        end;
        
    end;
    
    # loop after detecting With(out)Given pairs
    for current_recname in recnames
        
        current_rec = record[current_recname];
        
        if IsBound( current_rec.dual_with_given_objects_reversed ) && current_rec.dual_with_given_objects_reversed && !current_rec.is_with_given
            
            Error( "dual_with_given_objects_reversed may only be set for with given records" );
            
        end;
        
        # set `output_source_getter` && `output_range_getter`
        if IsBound( current_rec.output_source_getter_string )
            
            current_rec.output_source_getter = EvalString( ReplacedStringViaRecord(
                "( arguments... ) -> getter",
                rec(
                    arguments = current_rec.input_arguments_names,
                    getter = current_rec.output_source_getter_string,
                )
            ) );
            
            # Test if output_source_getter_string contains a CAP operation.
            # If not, it can always be computed (independent of the concrete category).
            
            can_always_compute_output_source_getter = fail;
            
            if current_rec.output_source_getter_string ⥉ current_rec.input_arguments_names
                
                can_always_compute_output_source_getter = true;
                
            else
                
                #= comment for Julia
                can_always_compute_output_source_getter = IsEmpty(
                    CAP_INTERNAL_FIND_APPEARANCE_OF_SYMBOL_IN_FUNCTION(
                        current_rec.output_source_getter,
                        Concatenation( recnames, RecNames( CAP_INTERNAL_METHOD_NAME_RECORD ) ),
                        2,
                        CAP_INTERNAL_METHOD_RECORD_REPLACEMENTS,
                        rec( )
                    )
                );
                # =#
                
            end;
            
            if can_always_compute_output_source_getter != fail
                
                if IsBound( current_rec.can_always_compute_output_source_getter )
                    
                    if current_rec.can_always_compute_output_source_getter != can_always_compute_output_source_getter
                        
                        Error( "<current_rec.can_always_compute_output_source_getter> does !match the automatically detected value" );
                        
                    end;
                    
                else
                    
                    current_rec.can_always_compute_output_source_getter = can_always_compute_output_source_getter;
                    
                end;
                
            end;
            
        end;
        
        if IsBound( current_rec.output_range_getter_string )
            
            current_rec.output_range_getter = EvalString( ReplacedStringViaRecord(
                "( arguments... ) -> getter",
                rec(
                    arguments = current_rec.input_arguments_names,
                    getter = current_rec.output_range_getter_string,
                )
            ) );
            
            # Test if output_range_getter_string contains a CAP operation.
            # If not, it can always be computed (independent of the concrete category).
            
            can_always_compute_output_range_getter = fail;
            
            if current_rec.output_range_getter_string ⥉ current_rec.input_arguments_names
                
                can_always_compute_output_range_getter = true;
                
            else
                
                #= comment for Julia
                can_always_compute_output_range_getter = IsEmpty(
                    CAP_INTERNAL_FIND_APPEARANCE_OF_SYMBOL_IN_FUNCTION(
                        current_rec.output_range_getter,
                        Concatenation( recnames, RecNames( CAP_INTERNAL_METHOD_NAME_RECORD ) ),
                        2,
                        CAP_INTERNAL_METHOD_RECORD_REPLACEMENTS,
                        rec( )
                    )
                );
                # =#
                
            end;
            
            if can_always_compute_output_range_getter != fail
                
                if IsBound( current_rec.can_always_compute_output_range_getter )
                    
                    if current_rec.can_always_compute_output_range_getter != can_always_compute_output_range_getter
                        
                        Error( "<current_rec.can_always_compute_output_range_getter> does !match the automatically detected value" );
                        
                    end;
                    
                else
                    
                    current_rec.can_always_compute_output_range_getter = can_always_compute_output_range_getter;
                    
                end;
                
            end;
            
        end;
        
    end;
    
    CAP_INTERNAL_FIND_OPPOSITE_PROPERTY_PAIRS_IN_METHOD_NAME_RECORD( record );
    
end );

CAP_INTERNAL_ENHANCE_NAME_RECORD( CAP_INTERNAL_METHOD_NAME_RECORD );

# TODO
# CAP_INTERNAL_METHOD_NAME_RECORD above should be renamed to CAP_INTERNAL_CORE_METHOD_NAME_RECORD.
# CAP_INTERNAL_METHOD_NAME_RECORD should be an empty record at the beginning, which is populated ⥉ CAP_INTERNAL_INSTALL_ADDS_FROM_RECORD
BindGlobal( "CAP_INTERNAL_CORE_METHOD_NAME_RECORD", StructuralCopy( CAP_INTERNAL_METHOD_NAME_RECORD ) );

##
InstallGlobalFunction( CAP_INTERNAL_GENERATE_DOCUMENTATION_FROM_METHOD_NAME_RECORD,
  function ( record, package_name, filename, chapter_name, section_name )
    local recnames, output_string, package_info, current_string, current_recname, current_rec, output_path;
    
    #= comment for Julia
    recnames = SortedList( RecNames( record ) );
    
    output_string = "";
    
    package_info = First( PackageInfo( package_name ) );
    
    if package_info == fail
        
        Error( "could !find package info" );
        
    end;
    
    # the space between # && ! prevents AutoDoc from parsing these strings && is removed below
    current_string = ReplacedStringViaRecord(
"""# SPDX-License-Identifier: GPL-2.0-or-later
# package_name: package_subtitle
#
# Declarations
#
# THIS FILE IS AUTOMATICALLY GENERATED, SEE CAP_project/CAP/gap/MethodRecord.gi

# @Chapter chapter_name

# @Section section_name
""",
        rec(
            package_name = package_name,
            package_subtitle = package_info.Subtitle,
            chapter_name = chapter_name,
            section_name = section_name,
        )
    );
    
    # see comment above
    current_string = ReplacedString( current_string, "#", "#!" );
    
    output_string = Concatenation( output_string, current_string );
    
    for current_recname in recnames
        
        current_rec = record[current_recname];
        
        # the space between # && ! prevents AutoDoc from parsing these strings && is removed below
        current_string = ReplacedStringViaRecord(
"""
# @Description
# The arguments are a category  C  && a function  F .
# This operation adds the given function  F 
# to the category for the basic operation `function_name`.
#  F: ( input_arguments... ) \\mapsto \\mathtt[function_name](input_arguments...) .
# @Returns nothing
# @Arguments C, F
DeclareOperation( "Addfunction_name",
                  [ IsCapCategory, IsFunction ] );

DeclareOperation( "Addfunction_name",
                  [ IsCapCategory, IsFunction, IsInt ] );

DeclareOperation( "Addfunction_name",
                  [ IsCapCategory, IsList, IsInt ] );

DeclareOperation( "Addfunction_name",
                  [ IsCapCategory, IsList ] );
""",
            rec(
                function_name = current_recname,
                input_arguments = current_rec.input_arguments_names[(2):(Length( current_rec.input_arguments_names ))],
            )
        );
        
        # see comment above
        current_string = ReplacedString( current_string, "#", "#!" );
        
        output_string = Concatenation( output_string, current_string );
        
    end;
    
    if !IsExistingFileInPackageForHomalg( package_name, filename ) || output_string != ReadFileFromPackageForHomalg( package_name, filename )
        
        output_path = Filename( DirectoryTemporary( ), filename );
        
        WriteFileForHomalg( output_path, output_string );
        
        Display( Concatenation(
            "WARNING: The file ", filename, " ⥉ package ", package_name, " differs from the automatically generated one. ",
            "You can view the automatically generated file at the following path: ",
            output_path
        ) );
        
    end;
    # =#
    
end );

CAP_INTERNAL_GENERATE_DOCUMENTATION_FROM_METHOD_NAME_RECORD(
    CAP_INTERNAL_METHOD_NAME_RECORD,
    "CAP",
    "AddFunctions.autogen.gd",
    "Add Functions",
    "Available Add functions"
);

BindGlobal( "CAP_INTERNAL_METHOD_NAME_RECORDS_BY_PACKAGE", rec( ) );

##
InstallGlobalFunction( CAP_INTERNAL_REGISTER_METHOD_NAME_RECORD_OF_PACKAGE,
  function ( record, package_name )
    local recname;
    
    if !IsBound( CAP_INTERNAL_METHOD_NAME_RECORDS_BY_PACKAGE[package_name] )
        
        CAP_INTERNAL_METHOD_NAME_RECORDS_BY_PACKAGE[package_name] = rec( );
        
    end;
    
    for recname in RecNames( record )
        
        if IsBound( CAP_INTERNAL_METHOD_NAME_RECORDS_BY_PACKAGE[package_name][recname] )
            
            Error( recname, " is already registered for this package" );
            
        end;
        
        CAP_INTERNAL_METHOD_NAME_RECORDS_BY_PACKAGE[package_name][recname] = record[recname];
        
    end;
    
end );

CAP_INTERNAL_REGISTER_METHOD_NAME_RECORD_OF_PACKAGE( CAP_INTERNAL_METHOD_NAME_RECORD, "CAP" );

##
InstallGlobalFunction( CAP_INTERNAL_GENERATE_DOCUMENTATION_FOR_CATEGORY_INSTANCES,
  function ( subsections, package_name, filename, chapter_name, section_name )
    local output_string, package_info, current_string, transitively_needed_other_packages, previous_operations, subsection, category, subsection_title, operations, bookname, info, label, match, nr, res, test_string, test_string_legacy, output_path, i, name;
    
    output_string = "";
    
    package_info = First( PackageInfo( package_name ) );
    
    if package_info == fail
        
        Error( "could !find package info" );
        
    end;
    
    # the space between # && ! prevents AutoDoc from parsing these strings && is removed below
    current_string = ReplacedStringViaRecord(
"""# SPDX-License-Identifier: GPL-2.0-or-later
# package_name: package_subtitle
#
# Declarations
#
# THIS FILE IS AUTOMATICALLY GENERATED, SEE CAP_project/CAP/gap/MethodRecord.gi

# @Chapter chapter_name

# @Section section_name
""",
        rec(
            package_name = package_name,
            package_subtitle = package_info.Subtitle,
            chapter_name = chapter_name,
            section_name = section_name,
        )
    );
    
    output_string = Concatenation( output_string, current_string );
    
    # We do !want to include operations from optional dependencies because those might !be available.
    transitively_needed_other_packages = TransitivelyNeededOtherPackages( package_name );
    
    previous_operations = [ ];
    
    for i in (1):(Length( subsections ))
        
        subsection = subsections[i];
        
        Assert( 0, IsList( subsection ) && Length( subsection ) == 2 );
        
        category = subsection[1];
        subsection_title = subsection[2];
        
        Assert( 0, IsCapCategory( category ) );
        Assert( 0, IsString( subsection_title ) );
        
        # the space between # && ! prevents AutoDoc from parsing these strings && is removed below
        current_string = Concatenation( "\n# @Subsection ", subsection_title );
        output_string = Concatenation( output_string, current_string );
        
        if i == 1
            
            operations = AsSortedList( ListInstalledOperationsOfCategory( category ) );
            
            current_string = "\n\n# The following CAP operations are supported:";
            
        else
            
            if !IsSubset( ListInstalledOperationsOfCategory( category ), previous_operations )
                
                Error( "the operations of the ", i - 1, "-th category are !a subset of the operations of the ", i, "-th category" );
                
            end;
            
            operations = AsSortedList( Difference( ListInstalledOperationsOfCategory( category ), previous_operations ) );
            
            current_string = "\n\n# The following additional CAP operations are supported:";
            
        end;
        
        if IsEmpty( operations )
            
            Display( "WARNING: No operations found, skipping subection" );
            
        end;
        
        output_string = Concatenation( output_string, current_string );
        
        for name in operations
            
            # find package name == bookname
            bookname = PackageOfCAPOperation( name );
            
            if bookname == fail
                
                Display( Concatenation( "WARNING: Could !find package for CAP operation ", name, ", skipping." ) );
                continue;
                
            end;
            
            # skip operation if it comes from an optional dependency
            if !bookname ⥉ transitively_needed_other_packages
                
                continue;
                
            end;
            
            # simulate GAPDoc's `ResolveExternalRef` to make sure we get a correct reference
            info = HELP_BOOK_INFO( bookname );
            
            if info == fail
                
                Error( "Could !get HELP_BOOK_INFO for book ", bookname, ". You probably have to execute `make doc` for the corresponding package." );
                
            end;
            
            if IsOperation( ValueGlobal( name ) )
                
                # the "for Is" makes sure we only match operations with a filter && !functions
                label = "for Is";
                
            else
                
                label = "";
                
            end;
            
            match = Concatenation( HELP_GET_MATCHES( info, SIMPLE_STRING( Concatenation( name, " (", label, ")" ) ), true ) );
            
            nr = 1;
            
            if Length(match) < nr
                
                Error( "Could !get HELP_GET_MATCHES for book ", bookname, ", operation ", name, ", && label ", SIMPLE_STRING( label ) );
                
            end;
            
            res = GetHelpDataRef(info, match[nr][2]);
            res[1] = SubstitutionSublist(res[1], " (!loaded): ", ": ", "one");
            
            if IsOperation( ValueGlobal( name ) )
                
                test_string = Concatenation( bookname, ": ", name, " for Is" );
                # needed for GAPDoc < 1.6.5
                test_string_legacy = Concatenation( bookname, ": ", name, " for is" );
                
                if !(StartsWith( res[1], test_string ) || StartsWith( res[1], test_string_legacy ))
                    
                    Error( res[1], " does !start with ", test_string, ", matching wrong operation?" );
                    
                end;
                
            else
                
                test_string = Concatenation( bookname, ": ", name );
                
                if !res[1] == test_string
                    
                    Error( res[1], " is !equal to ", test_string, ", matching wrong function?" );
                    
                end;
                
            end;
            
            current_string = ReplacedStringViaRecord(
                "\n# * <Ref BookName=\"bookname\" Func=\"operation_name\" Label=\"label\" />", # GAPDoc does !care if we use `Func` || `Oper` for external refs
                rec(
                    bookname = bookname,
                    operation_name = name,
                    label = label,
                )
            );
            output_string = Concatenation( output_string, current_string );
            
            Add( previous_operations, name );
            
        end;
        
        output_string = Concatenation( output_string, "\n" );
        
    end;
    
    # see comments above
    output_string = ReplacedString( output_string, "#", "#!" );
    
    if !IsExistingFileInPackageForHomalg( package_name, filename ) || output_string != ReadFileFromPackageForHomalg( package_name, filename )
        
        output_path = Filename( DirectoryTemporary( ), filename );
        
        WriteFileForHomalg( output_path, output_string );
        
        Display( Concatenation(
            "WARNING: The file ", filename, " ⥉ package ", package_name, " differs from the automatically generated one. ",
            "You can view the automatically generated file at the following path: ",
            output_path
        ) );
        
    end;
    
end );
