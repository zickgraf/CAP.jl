# SPDX-License-Identifier: GPL-2.0-or-later
# CAP: Categories, Algorithms, Programming
#
# Implementations
#
@InstallValueConst( CAP_INTERNAL_VALID_RETURN_TYPES,
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
        "list_of_objects",
        "list_of_morphisms",
        "list_of_morphisms_or_fail",
        "list_of_lists_of_morphisms",
        "object_datum",
        "morphism_datum",
        "nonneg_integer_or_infinity",
        "list_of_elements_of_commutative_ring_of_linear_structure",
    ]
#! @EndCode
);

@BindGlobal( "CAP_INTERNAL_VALID_METHOD_NAME_RECORD_COMPONENTS",
#! @BeginCode CAP_INTERNAL_VALID_METHOD_NAME_RECORD_COMPONENTS
    [
        "filter_list",
        "input_arguments_names",
        "return_type",
        "output_source_getter_string",
        "output_source_getter_preconditions",
        "output_range_getter_string",
        "output_range_getter_preconditions",
        "with_given_object_position",
        "dual_operation",
        "dual_arguments_reversed",
        "dual_with_given_objects_reversed",
        "dual_preprocessor_func",
        "dual_preprocessor_func_string",
        "dual_postprocessor_func",
        "dual_postprocessor_func_string",
        "functorial",
        "compatible_with_congruence_of_morphisms",
        "redirect_function",
        "pre_function",
        "pre_function_full",
        "post_function",
    ]
#! @EndCode
);

# additional components which are deprecated or undocumented
@BindGlobal( "CAP_INTERNAL_LEGACY_METHOD_NAME_RECORD_COMPONENTS",
    [
        "is_merely_set_theoretic",
        "is_reflected_by_faithful_functor",
    ]
);

@InstallValueConst( CAP_INTERNAL_METHOD_NAME_RECORD, @rec(
ObjectConstructor = @rec(
  filter_list = [ "category", "object_datum" ],
  return_type = "object",
  compatible_with_congruence_of_morphisms = false,
),

ObjectDatum = @rec(
  filter_list = [ "category", "object" ],
  return_type = "object_datum",
),

MorphismConstructor = @rec(
  filter_list = [ "category", "object", "morphism_datum", "object" ],
  return_type = "morphism",
  compatible_with_congruence_of_morphisms = false,
),

MorphismDatum = @rec(
  filter_list = [ "category", "morphism" ],
  return_type = "morphism_datum",
  compatible_with_congruence_of_morphisms = false,
),

LiftAlongMonomorphism = @rec(
  filter_list = [ "category", "morphism", "morphism" ],
  input_arguments_names = [ "cat", "iota", "tau" ],
  output_source_getter_string = "Source( tau )",
  output_source_getter_preconditions = [ ],
  output_range_getter_string = "Source( iota )",
  output_range_getter_preconditions = [ ],
  pre_function = function( cat, iota, tau )
    
    if (@not IsEqualForObjects( cat, Range( iota ), Range( tau ) ))
        
        return [ false, "the two morphisms must have equal ranges" ];
        
    end;
    
    return [ true ];
  end,
  return_type = "morphism",
  dual_operation = "ColiftAlongEpimorphism",
  compatible_with_congruence_of_morphisms = true,
),

IsLiftableAlongMonomorphism = @rec(
  filter_list = [ "category", "morphism", "morphism" ],
  pre_function = function( cat, iota, tau )
    
    if (@not IsEqualForObjects( cat, Range( iota ), Range( tau ) ))
        
        return [ false, "the two morphisms must have equal ranges" ];
        
    end;
    
    return [ true ];
  end,
  return_type = "bool",
  dual_operation = "IsColiftableAlongEpimorphism",
  compatible_with_congruence_of_morphisms = true,
),

ColiftAlongEpimorphism = @rec(
  filter_list = [ "category", "morphism", "morphism" ],
  input_arguments_names = [ "cat", "epsilon", "tau" ],
  output_source_getter_string = "Range( epsilon )",
  output_source_getter_preconditions = [ ],
  output_range_getter_string = "Range( tau )",
  output_range_getter_preconditions = [ ],
  pre_function = function( cat, epsilon, tau )
    
    if (@not IsEqualForObjects( cat, Source( epsilon ), Source( tau ) ))
        
        return [ false, "the two morphisms must have equal sources" ];
        
    end;
    
    return [ true ];
  end,
  return_type = "morphism",
  dual_operation = "LiftAlongMonomorphism",
  compatible_with_congruence_of_morphisms = true,
),

IsColiftableAlongEpimorphism = @rec(
  filter_list = [ "category", "morphism", "morphism" ],
  pre_function = function( cat, epsilon, tau )
    
    if (@not IsEqualForObjects( cat, Source( epsilon ), Source( tau ) ))
        
        return [ false, "the two morphisms must have equal sources" ];
        
    end;
    
    return [ true ];
  end,
  return_type = "bool",
  dual_operation = "IsLiftableAlongMonomorphism",
  compatible_with_congruence_of_morphisms = true,
),

Lift = @rec(
  filter_list = [ "category", "morphism", "morphism" ],
  input_arguments_names = [ "cat", "alpha", "beta" ],
  output_source_getter_string = "Source( alpha )",
  output_source_getter_preconditions = [ ],
  output_range_getter_string = "Source( beta )",
  output_range_getter_preconditions = [ ],
  pre_function = function( cat, iota, tau )
    
    if (@not IsEqualForObjects( cat, Range( iota ), Range( tau ) ))
        
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

LiftOrFail = @rec(
  filter_list = [ "category", "morphism", "morphism" ],
  input_arguments_names = [ "cat", "alpha", "beta" ],
  output_source_getter_string = "Source( alpha )",
  output_source_getter_preconditions = [ ],
  output_range_getter_string = "Source( beta )",
  output_range_getter_preconditions = [ ],
  pre_function = "Lift",
  return_type = "morphism_or_fail",
  dual_operation = "ColiftOrFail",
  dual_arguments_reversed = true,
  is_merely_set_theoretic = true,
  compatible_with_congruence_of_morphisms = false,
),

IsLiftable = @rec(
  filter_list = [ "category", "morphism", "morphism" ],
  pre_function = "Lift",
  return_type = "bool",
  dual_operation = "IsColiftable",
  dual_arguments_reversed = true,
  compatible_with_congruence_of_morphisms = false,
),

Colift = @rec(
  filter_list = [ "category", "morphism", "morphism" ],
  input_arguments_names = [ "cat", "alpha", "beta" ],
  output_source_getter_string = "Range( alpha )",
  output_source_getter_preconditions = [ ],
  output_range_getter_string = "Range( beta )",
  output_range_getter_preconditions = [ ],
  pre_function = function( cat, epsilon, tau )
    
    if (@not IsEqualForObjects( cat, Source( epsilon ), Source( tau ) ))
        
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

ColiftOrFail = @rec(
  filter_list = [ "category", "morphism", "morphism" ],
  input_arguments_names = [ "cat", "alpha", "beta" ],
  output_source_getter_string = "Range( alpha )",
  output_source_getter_preconditions = [ ],
  output_range_getter_string = "Range( beta )",
  output_range_getter_preconditions = [ ],
  pre_function = "Colift",
  return_type = "morphism_or_fail",
  dual_operation = "LiftOrFail",
  dual_arguments_reversed = true,
  is_merely_set_theoretic = true,
  compatible_with_congruence_of_morphisms = false,
),

IsColiftable = @rec(
  filter_list = [ "category", "morphism", "morphism" ],
  pre_function = "Colift",
  return_type = "bool",
  dual_operation = "IsLiftable",
  dual_arguments_reversed = true,
  compatible_with_congruence_of_morphisms = false,
),

ProjectiveLift = @rec(
  filter_list = [ "category", "morphism", "morphism" ],
  input_arguments_names = [ "cat", "alpha", "beta" ],
  output_source_getter_string = "Source( alpha )",
  output_source_getter_preconditions = [ ],
  output_range_getter_string = "Source( beta )",
  output_range_getter_preconditions = [ ],
  pre_function = function( cat, iota, tau )
    
    if (@not IsEqualForObjects( cat, Range( iota ), Range( tau ) ))
        
        return [ false, "the two morphisms must have equal ranges" ];
        
    end;
    
    return [ true ];
  end,
  return_type = "morphism",
  dual_arguments_reversed = true,
  dual_operation = "InjectiveColift",
  compatible_with_congruence_of_morphisms = false,
),

InjectiveColift = @rec(
  filter_list = [ "category", "morphism", "morphism" ],
  input_arguments_names = [ "cat", "alpha", "beta" ],
  output_source_getter_string = "Range( alpha )",
  output_source_getter_preconditions = [ ],
  output_range_getter_string = "Range( beta )",
  output_range_getter_preconditions = [ ],
  pre_function = function( cat, epsilon, tau )
    
    if (@not IsEqualForObjects( cat, Source( epsilon ), Source( tau ) ))
        
        return [ false, "the two morphisms must have equal sources" ];
        
    end;
    
    return [ true ];
  end,
  return_type = "morphism",
  dual_arguments_reversed = true,
  dual_operation = "ProjectiveLift",
  compatible_with_congruence_of_morphisms = false,
),

IdentityMorphism = @rec(
  filter_list = [ "category", "object" ],
  input_arguments_names = [ "cat", "a" ],
  output_source_getter_string = "a",
  output_source_getter_preconditions = [ ],
  output_range_getter_string = "a",
  output_range_getter_preconditions = [ ],
  return_type = "morphism",
  dual_operation = "IdentityMorphism" ),

InverseForMorphisms = @rec(
# Type check for IsIsomorphism
  filter_list = [ "category", "morphism" ],
  input_arguments_names = [ "cat", "alpha" ],
  output_source_getter_string = "Range( alpha )",
  output_source_getter_preconditions = [ ],
  output_range_getter_string = "Source( alpha )",
  output_range_getter_preconditions = [ ],
  return_type = "morphism",
  dual_operation = "InverseForMorphisms",
  compatible_with_congruence_of_morphisms = true,
),

PreInverseForMorphisms = @rec(
  filter_list = [ "category", "morphism" ],
  input_arguments_names = [ "cat", "alpha" ],
  output_source_getter_string = "Range( alpha )",
  output_source_getter_preconditions = [ ],
  output_range_getter_string = "Source( alpha )",
  output_range_getter_preconditions = [ ],
  return_type = "morphism",
  dual_operation = "PostInverseForMorphisms",
  is_merely_set_theoretic = true
),

PostInverseForMorphisms = @rec(
  filter_list = [ "category", "morphism" ],
  input_arguments_names = [ "cat", "alpha" ],
  output_source_getter_string = "Range( alpha )",
  output_source_getter_preconditions = [ ],
  output_range_getter_string = "Source( alpha )",
  output_range_getter_preconditions = [ ],
  return_type = "morphism",
  dual_operation = "PreInverseForMorphisms",
  is_merely_set_theoretic = true
),

KernelObject = @rec(
  filter_list = [ "category", "morphism" ],
  input_arguments_names = [ "cat", "alpha" ],
  return_type = "object",
  dual_operation = "CokernelObject",
  compatible_with_congruence_of_morphisms = false,
  functorial = "KernelObjectFunctorial",
),

KernelEmbedding = @rec(
  filter_list = [ "category", "morphism" ],
  input_arguments_names = [ "cat", "alpha" ],
  output_range_getter_string = "Source( alpha )",
  output_range_getter_preconditions = [ ],
  with_given_object_position = "Source",
  return_type = "morphism",
  dual_operation = "CokernelProjection",
  compatible_with_congruence_of_morphisms = false,
),

KernelEmbeddingWithGivenKernelObject = @rec(
  filter_list = [ "category", "morphism", "object" ],
  input_arguments_names = [ "cat", "alpha", "P" ],
  output_source_getter_string = "P",
  output_source_getter_preconditions = [ ],
  output_range_getter_string = "Source( alpha )",
  output_range_getter_preconditions = [ ],
  return_type = "morphism",
  dual_operation = "CokernelProjectionWithGivenCokernelObject",
  compatible_with_congruence_of_morphisms = false,
),

MorphismFromKernelObjectToSink = @rec(
  filter_list = [ "category", "morphism" ],
  input_arguments_names = [ "cat", "alpha" ],
  output_range_getter_string = "Range( alpha )",
  output_range_getter_preconditions = [ ],
  with_given_object_position = "Source",
  dual_operation = "MorphismFromSourceToCokernelObject",
  return_type = "morphism",
  compatible_with_congruence_of_morphisms = false,
),

MorphismFromKernelObjectToSinkWithGivenKernelObject = @rec(
  filter_list = [ "category", "morphism", "object" ],
  input_arguments_names = [ "cat", "alpha", "P" ],
  output_source_getter_string = "P",
  output_source_getter_preconditions = [ ],
  output_range_getter_string = "Range( alpha )",
  output_range_getter_preconditions = [ ],
  dual_operation = "MorphismFromSourceToCokernelObjectWithGivenCokernelObject",
  return_type = "morphism",
  compatible_with_congruence_of_morphisms = false,
),

KernelLift = @rec(
  filter_list = [ "category", "morphism", "object", "morphism" ],
  input_arguments_names = [ "cat", "alpha", "T", "tau" ],
  output_source_getter_string = "T",
  output_source_getter_preconditions = [ ],
  with_given_object_position = "Range",
  return_type = "morphism",
  dual_operation = "CokernelColift",
  compatible_with_congruence_of_morphisms = false,
),

KernelLiftWithGivenKernelObject = @rec(
  filter_list = [ "category", "morphism", "object", "morphism", "object" ],
  input_arguments_names = [ "cat", "alpha", "T", "tau", "P" ],
  output_source_getter_string = "T",
  output_source_getter_preconditions = [ ],
  output_range_getter_string = "P",
  output_range_getter_preconditions = [ ],
  return_type = "morphism",
  dual_operation = "CokernelColiftWithGivenCokernelObject",
  compatible_with_congruence_of_morphisms = false,
),

CokernelObject = @rec(
  filter_list = [ "category", "morphism" ],
  input_arguments_names = [ "cat", "alpha" ],
  return_type = "object",
  dual_operation = "KernelObject",
  compatible_with_congruence_of_morphisms = false,
  functorial = "CokernelObjectFunctorial",
),

CokernelProjection = @rec(
  filter_list = [ "category", "morphism" ],
  input_arguments_names = [ "cat", "alpha" ],
  output_source_getter_string = "Range( alpha )",
  output_source_getter_preconditions = [ ],
  with_given_object_position = "Range",
  return_type = "morphism",
  dual_operation = "KernelEmbedding",
  compatible_with_congruence_of_morphisms = false,
),

CokernelProjectionWithGivenCokernelObject = @rec(
  filter_list = [ "category", "morphism", "object" ],
  input_arguments_names = [ "cat", "alpha", "P" ],
  output_source_getter_string = "Range( alpha )",
  output_source_getter_preconditions = [ ],
  output_range_getter_string = "P",
  output_range_getter_preconditions = [ ],
  return_type = "morphism",
  dual_operation = "KernelEmbeddingWithGivenKernelObject",
  compatible_with_congruence_of_morphisms = false,
),

MorphismFromSourceToCokernelObject = @rec(
  filter_list = [ "category", "morphism" ],
  input_arguments_names = [ "cat", "alpha" ],
  output_source_getter_string = "Source( alpha )",
  output_source_getter_preconditions = [ ],
  with_given_object_position = "Range",
  dual_operation = "MorphismFromKernelObjectToSink",
  return_type = "morphism",
  compatible_with_congruence_of_morphisms = false,
),

MorphismFromSourceToCokernelObjectWithGivenCokernelObject = @rec(
  filter_list = [ "category", "morphism", "object" ],
  input_arguments_names = [ "cat", "alpha", "P" ],
  output_source_getter_string = "Source( alpha )",
  output_source_getter_preconditions = [ ],
  output_range_getter_string = "P",
  output_range_getter_preconditions = [ ],
  dual_operation = "MorphismFromKernelObjectToSinkWithGivenKernelObject",
  return_type = "morphism",
  compatible_with_congruence_of_morphisms = false,
),

CokernelColift = @rec(
  filter_list = [ "category", "morphism", "object", "morphism" ],
  input_arguments_names = [ "cat", "alpha", "T", "tau" ],
  output_range_getter_string = "T",
  output_range_getter_preconditions = [ ],
  with_given_object_position = "Source",
  return_type = "morphism",
  dual_operation = "KernelLift",
  compatible_with_congruence_of_morphisms = false,
),

CokernelColiftWithGivenCokernelObject = @rec(
  filter_list = [ "category", "morphism", "object", "morphism", "object" ],
  input_arguments_names = [ "cat", "alpha", "T", "tau", "P" ],
  output_source_getter_string = "P",
  output_source_getter_preconditions = [ ],
  output_range_getter_string = "T",
  output_range_getter_preconditions = [ ],
  return_type = "morphism",
  dual_operation = "KernelLiftWithGivenKernelObject",
  compatible_with_congruence_of_morphisms = false,
),

PreCompose = @rec(
  filter_list = [ "category", "morphism", "morphism" ],
  input_arguments_names = [ "cat", "alpha", "beta" ],
  output_source_getter_string = "Source( alpha )",
  output_source_getter_preconditions = [ ],
  output_range_getter_string = "Range( beta )",
  output_range_getter_preconditions = [ ],
  
  pre_function = function( cat, mor_left, mor_right )
    
    if (@not IsEqualForObjects( cat, Range( mor_left ), Source( mor_right ) ))
        
        return [ false, "morphisms not composable" ];
        
    end;
    
    return [ true ];
  end,
  return_type = "morphism",
  dual_operation = "PostCompose",
  compatible_with_congruence_of_morphisms = true,
),

SumOfMorphisms = @rec(
  filter_list = [ "category", "object", "list_of_morphisms", "object" ],
  input_arguments_names = [ "cat", "source", "list_of_morphisms", "range" ],
  pre_function = function( cat, source, list_of_morphisms, range )
    local m;
    
    for m in list_of_morphisms
        
        if (!(IsEqualForObjects( cat, source, Source( m ) )) || @not IsEqualForObjects( cat, range, Range( m ) ))
            
            return [ false, "some of the morphisms are not compatible with the provided source and range objects" ];
            
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

LinearCombinationOfMorphisms = @rec(
  filter_list = [ "category", "object", "list_of_elements_of_commutative_ring_of_linear_structure", "list_of_morphisms", "object" ],
  input_arguments_names = [ "cat", "source", "list_of_ring_elements", "list_of_morphisms", "range" ],
  pre_function = function( cat, source, list_of_ring_elements, list_of_morphisms, range )
    local m;
    
    if (@not Length( list_of_ring_elements ) == Length( list_of_morphisms ))
        
        return [ false, "the length of the lists of coefficients and morphisms must be the same" ];
        
    end;
    
    for m in list_of_morphisms
        
        if (!(IsEqualForObjects( cat, source, Source( m ) )) || @not IsEqualForObjects( cat, range, Range( m ) ))
            
            return [ false, "some of the morphisms are not compatible with the provided source and range objects" ];
            
        end;
        
    end;
    
    return [ true ];
    
  end,
  return_type = "morphism",
  output_source_getter_string = "source",
  output_range_getter_string = "range",
  dual_operation = "LinearCombinationOfMorphisms",
  dual_preprocessor_func = function( arg... )
      local list;
      list = CAP_INTERNAL_OPPOSITE_RECURSIVE( arg );
      return @NTupleGAP( 5, list[1], list[5], list[3], list[4], list[2] );
  end,
  compatible_with_congruence_of_morphisms = true,
),

PreComposeList = @rec(
  filter_list = [ "category", "object", "list_of_morphisms", "object" ],
  input_arguments_names = [ "cat", "source", "list_of_morphisms", "range" ],
  pre_function = function( cat, source, list_of_morphisms, range )
    local i;
    
    if (IsEmpty( list_of_morphisms ))
        
        if (@not IsEqualForObjects( cat, source, range ))
            
            return [ false, "the given source and range are not equal while the given list of morphisms to compose is empty" ];
            
        end;
        
    else
        
        if (@not IsEqualForObjects( cat, source, Source( First( list_of_morphisms ) ) ))
            
            return [ false, "the given source is not equal to the source of the first morphism" ];
            
        elseif (@not IsEqualForObjects( cat, range, Range( Last( list_of_morphisms ) ) ))
            
            return [ false, "the given range is not equal to the range of the last morphism" ];
            
        end;
        
    end;
    
    for i in (1):(Length( list_of_morphisms ) - 1)
        
        if (@not IsEqualForObjects( cat, Range( list_of_morphisms[i] ), Source( list_of_morphisms[i + 1] ) ))
            
            return [ false, "morphisms not composable" ];
            
        end;
        
    end;
    
    return [ true ];
    
  end,
  return_type = "morphism",
  output_source_getter_string = "source",
  output_range_getter_string = "range",
  dual_operation = "PostComposeList",
  dual_arguments_reversed = true,
  compatible_with_congruence_of_morphisms = true,
),

PostCompose = @rec(
  filter_list = [ "category", "morphism", "morphism" ],
  input_arguments_names = [ "cat", "beta", "alpha" ],
  output_source_getter_string = "Source( alpha )",
  output_source_getter_preconditions = [ ],
  output_range_getter_string = "Range( beta )",
  output_range_getter_preconditions = [ ],
  
  pre_function = function( cat, mor_right, mor_left )
    
    if (@not IsEqualForObjects( cat, Range( mor_left ), Source( mor_right ) ))
        
        return [ false, "morphisms not composable" ];
        
    end;
    
    return [ true ];
  end,
  
  return_type = "morphism",
  dual_operation = "PreCompose",
  compatible_with_congruence_of_morphisms = true,
),

PostComposeList = @rec(
  filter_list = [ "category", "object", "list_of_morphisms", "object" ],
  input_arguments_names = [ "cat", "source", "list_of_morphisms", "range" ],
  pre_function = function( cat, source, list_of_morphisms, range )
    local i;
    
    if (IsEmpty( list_of_morphisms ))
        
        if (@not IsEqualForObjects( cat, source, range ))
            
            return [ false, "the given source and range are not equal while the given list of morphisms to compose is empty" ];
            
        end;
        
    else
        
        if (@not IsEqualForObjects( cat, source, Source( Last( list_of_morphisms ) ) ))
            
            return [ false, "the given source is not equal to the source of the last morphism" ];
            
        elseif (@not IsEqualForObjects( cat, range, Range( First( list_of_morphisms ) ) ))
            
            return [ false, "the given range is not equal to the range of the first morphism" ];
            
        end;
        
    end;
    
    for i in (1):(Length( list_of_morphisms ) - 1)
        
        if (@not IsEqualForObjects( cat, Range( list_of_morphisms[i + 1] ), Source( list_of_morphisms[i] ) ))
            
            return [ false, "morphisms not composable" ];
            
        end;
        
    end;
    
    return [ true ];
    
  end,
  return_type = "morphism",
  output_source_getter_string = "source",
  output_range_getter_string = "range",
  dual_operation = "PreComposeList",
  dual_arguments_reversed = true,
  compatible_with_congruence_of_morphisms = true,
),

ZeroObject = @rec(
  filter_list = [ "category" ],
  input_arguments_names = [ "cat" ],
  return_type = "object",
  dual_operation = "ZeroObject",
  functorial = "ZeroObjectFunctorial",
),

ZeroObjectFunctorial = @rec(
  filter_list = [ "category" ],
  input_arguments_names = [ "cat" ],
  return_type = "morphism",
  output_source_getter_string = "ZeroObject( cat )",
  output_source_getter_preconditions = [ [ "ZeroObject", 1 ] ],
  output_range_getter_string = "ZeroObject( cat )",
  output_range_getter_preconditions = [ [ "ZeroObject", 1 ] ],
  with_given_object_position = "both",
  dual_operation = "ZeroObjectFunctorial",
  dual_arguments_reversed = true
),

ZeroObjectFunctorialWithGivenZeroObjects = @rec(
  filter_list = [ "category", "object", "object" ],
  input_arguments_names = [ "cat", "P", "Pp" ],
  output_source_getter_string = "P",
  output_source_getter_preconditions = [ ],
  output_range_getter_string = "Pp",
  output_range_getter_preconditions = [ ],
  return_type = "morphism",
  dual_operation = "ZeroObjectFunctorialWithGivenZeroObjects",
  dual_arguments_reversed = true
),

UniversalMorphismFromZeroObject = @rec(
  filter_list = [ "category", "object" ],
  input_arguments_names = [ "cat", "T" ],
  output_range_getter_string = "T",
  output_range_getter_preconditions = [ ],
  with_given_object_position = "Source",
  return_type = "morphism",
  dual_operation = "UniversalMorphismIntoZeroObject" ),
  
UniversalMorphismFromZeroObjectWithGivenZeroObject = @rec(
  filter_list = [ "category", "object", "object" ],
  input_arguments_names = [ "cat", "T", "P" ],
  output_source_getter_string = "P",
  output_source_getter_preconditions = [ ],
  output_range_getter_string = "T",
  output_range_getter_preconditions = [ ],
  return_type = "morphism",
  dual_operation = "UniversalMorphismIntoZeroObjectWithGivenZeroObject" ),

UniversalMorphismIntoZeroObject = @rec(
  filter_list = [ "category", "object" ],
  input_arguments_names = [ "cat", "T" ],
  output_source_getter_string = "T",
  output_source_getter_preconditions = [ ],
  with_given_object_position = "Range",
  return_type = "morphism",
  dual_operation = "UniversalMorphismFromZeroObject" ),

UniversalMorphismIntoZeroObjectWithGivenZeroObject = @rec(
  filter_list = [ "category", "object", "object" ],
  input_arguments_names = [ "cat", "T", "P" ],
  output_source_getter_string = "T",
  output_source_getter_preconditions = [ ],
  output_range_getter_string = "P",
  output_range_getter_preconditions = [ ],
  return_type = "morphism",
  dual_operation = "UniversalMorphismFromZeroObjectWithGivenZeroObject" ),

IsomorphismFromZeroObjectToInitialObject = @rec(
  filter_list = [ "category" ],
  return_type = "morphism",
  dual_operation = "IsomorphismFromTerminalObjectToZeroObject",
),

IsomorphismFromInitialObjectToZeroObject = @rec(
  filter_list = [ "category" ],
  return_type = "morphism",
  dual_operation = "IsomorphismFromZeroObjectToTerminalObject",
),

IsomorphismFromZeroObjectToTerminalObject = @rec(
  filter_list = [ "category" ],
  return_type = "morphism",
  dual_operation = "IsomorphismFromInitialObjectToZeroObject",
),

IsomorphismFromTerminalObjectToZeroObject = @rec(
  filter_list = [ "category" ],
  return_type = "morphism",
  dual_operation = "IsomorphismFromZeroObjectToInitialObject",
),

ZeroMorphism = @rec(
  filter_list = [ "category", "object", "object" ],
  input_arguments_names = [ "cat", "a", "b" ],
  output_source_getter_string = "a",
  output_source_getter_preconditions = [ ],
  output_range_getter_string = "b",
  output_range_getter_preconditions = [ ],
  return_type = "morphism",
  dual_arguments_reversed = true,
  dual_operation = "ZeroMorphism" ),

DirectSum = @rec(
  filter_list = [ "category", "list_of_objects" ],
  input_arguments_names = [ "cat", "objects" ],
  return_type = "object",
  dual_operation = "DirectSum",
  functorial = "DirectSumFunctorial",
),

ProjectionInFactorOfDirectSum = @rec(
  filter_list = [ "category", "list_of_objects", "integer" ],
  input_arguments_names = [ "cat", "objects", "k" ],
  output_range_getter_string = "objects[k]",
  output_range_getter_preconditions = [ ],
  with_given_object_position = "Source",
  return_type = "morphism",
  dual_operation = "InjectionOfCofactorOfDirectSum" ),

ProjectionInFactorOfDirectSumWithGivenDirectSum = @rec(
  filter_list = [ "category", "list_of_objects", "integer", "object" ],
  input_arguments_names = [ "cat", "objects", "k", "P" ],
  output_source_getter_string = "P",
  output_source_getter_preconditions = [ ],
  output_range_getter_string = "objects[k]",
  output_range_getter_preconditions = [ ],
  return_type = "morphism",
  dual_operation = "InjectionOfCofactorOfDirectSumWithGivenDirectSum" ),

UniversalMorphismIntoDirectSum = @rec(
  filter_list = [ "category", "list_of_objects", "object", "list_of_morphisms" ],
  input_arguments_names = [ "cat", "objects", "T", "tau" ],
  output_source_getter_string = "T",
  output_source_getter_preconditions = [ ],
  with_given_object_position = "Range",
  dual_operation = "UniversalMorphismFromDirectSum",
  
  pre_function = function( cat, diagram, test_object, source )
    local current_morphism;
    
    for current_morphism in source
        
        if (@not IsEqualForObjects( cat, Source( current_morphism ), test_object ))
            
            return [ false, "sources of morphisms must be equal to the test object in given source diagram" ];
            
        end;
        
    end;
    
    return [ true ];
    
  end,
  return_type = "morphism",
  compatible_with_congruence_of_morphisms = true,
),

UniversalMorphismIntoDirectSumWithGivenDirectSum = @rec(
  filter_list = [ "category", "list_of_objects", "object", "list_of_morphisms", "object" ],
  input_arguments_names = [ "cat", "objects", "T", "tau", "P" ],
  output_source_getter_string = "T",
  output_source_getter_preconditions = [ ],
  output_range_getter_string = "P",
  output_range_getter_preconditions = [ ],
  dual_operation = "UniversalMorphismFromDirectSumWithGivenDirectSum",
  
  pre_function = function( cat, diagram, test_object, source, direct_sum )
    local current_morphism;
    
    for current_morphism in source
        
        if (@not IsEqualForObjects( cat, Source( current_morphism ), test_object ))
            
            return [ false, "sources of morphisms must be equal to the test object in given source diagram" ];
            
        end;
        
    end;
    
    return [ true ];
    
  end,
  return_type = "morphism",
  compatible_with_congruence_of_morphisms = true,
),

InjectionOfCofactorOfDirectSum = @rec(
  filter_list = [ "category", "list_of_objects", "integer" ],
  input_arguments_names = [ "cat", "objects", "k" ],
  output_source_getter_string = "objects[k]",
  output_source_getter_preconditions = [ ],
  with_given_object_position = "Range",
  return_type = "morphism",
  dual_operation = "ProjectionInFactorOfDirectSum" ),

InjectionOfCofactorOfDirectSumWithGivenDirectSum = @rec(
  filter_list = [ "category", "list_of_objects", "integer", "object" ],
  input_arguments_names = [ "cat", "objects", "k", "P" ],
  output_source_getter_string = "objects[k]",
  output_source_getter_preconditions = [ ],
  output_range_getter_string = "P",
  output_range_getter_preconditions = [ ],
  return_type = "morphism",
  dual_operation = "ProjectionInFactorOfDirectSumWithGivenDirectSum" ),

UniversalMorphismFromDirectSum = @rec(
  filter_list = [ "category", "list_of_objects", "object", "list_of_morphisms" ],
  input_arguments_names = [ "cat", "objects", "T", "tau" ],
  output_range_getter_string = "T",
  output_range_getter_preconditions = [ ],
  with_given_object_position = "Source",
  dual_operation = "UniversalMorphismIntoDirectSum",
  
  pre_function = function( cat, diagram, test_object, sink )
    local current_morphism;
    
    for current_morphism in sink
        
        if (@not IsEqualForObjects( cat, Range( current_morphism ), test_object ))
            
            return [ false, "ranges of morphisms must be equal to the test object in given sink diagram" ];
            
        end;
        
    end;
    
    return [ true ];
    
  end,
  return_type = "morphism",
  compatible_with_congruence_of_morphisms = true,
),

UniversalMorphismFromDirectSumWithGivenDirectSum = @rec(
  filter_list = [ "category", "list_of_objects", "object", "list_of_morphisms", "object" ],
  input_arguments_names = [ "cat", "objects", "T", "tau", "P" ],
  output_source_getter_string = "P",
  output_source_getter_preconditions = [ ],
  output_range_getter_string = "T",
  output_range_getter_preconditions = [ ],
  dual_operation = "UniversalMorphismIntoDirectSumWithGivenDirectSum",
  
  pre_function = function( cat, diagram, test_object, sink, direct_sum )
    local current_morphism;
    
    for current_morphism in sink
        
        if (@not IsEqualForObjects( cat, Range( current_morphism ), test_object ))
            
            return [ false, "ranges of morphisms must be equal to the test object in given sink diagram" ];
            
        end;
        
    end;
    
    return [ true ];
    
  end,
  return_type = "morphism",
  compatible_with_congruence_of_morphisms = true,
),

TerminalObject = @rec(
  filter_list = [ "category" ],
  input_arguments_names = [ "cat" ],
  return_type = "object",
  dual_operation = "InitialObject",
  functorial = "TerminalObjectFunctorial",
),

UniversalMorphismIntoTerminalObject = @rec(
  filter_list = [ "category", "object" ],
  input_arguments_names = [ "cat", "T" ],
  output_source_getter_string = "T",
  output_source_getter_preconditions = [ ],
  with_given_object_position = "Range",
  return_type = "morphism",
  dual_operation = "UniversalMorphismFromInitialObject" ),

UniversalMorphismIntoTerminalObjectWithGivenTerminalObject = @rec(
  filter_list = [ "category", "object", "object" ],
  input_arguments_names = [ "cat", "T", "P" ],
  output_source_getter_string = "T",
  output_source_getter_preconditions = [ ],
  output_range_getter_string = "P",
  output_range_getter_preconditions = [ ],
  return_type = "morphism",
  dual_operation = "UniversalMorphismFromInitialObjectWithGivenInitialObject" ),

InitialObject = @rec(
  filter_list = [ "category" ],
  input_arguments_names = [ "cat" ],
  return_type = "object",
  dual_operation = "TerminalObject",
  functorial = "InitialObjectFunctorial",
),

UniversalMorphismFromInitialObject = @rec(
  filter_list = [ "category", "object" ],
  input_arguments_names = [ "cat", "T" ],
  output_range_getter_string = "T",
  output_range_getter_preconditions = [ ],
  with_given_object_position = "Source",
  return_type = "morphism",
  dual_operation = "UniversalMorphismIntoTerminalObject" ),

UniversalMorphismFromInitialObjectWithGivenInitialObject = @rec(
  filter_list = [ "category", "object", "object" ],
  input_arguments_names = [ "cat", "T", "P" ],
  output_source_getter_string = "P",
  output_source_getter_preconditions = [ ],
  output_range_getter_string = "T",
  output_range_getter_preconditions = [ ],
  return_type = "morphism",
  dual_operation = "UniversalMorphismIntoTerminalObjectWithGivenTerminalObject" ),

DirectProduct = @rec(
  filter_list = [ "category", "list_of_objects" ],
  input_arguments_names = [ "cat", "objects" ],
  return_type = "object",
  dual_operation = "Coproduct",
  functorial = "DirectProductFunctorial",
),

ProjectionInFactorOfDirectProduct = @rec(
  filter_list = [ "category", "list_of_objects", "integer" ],
  input_arguments_names = [ "cat", "objects", "k" ],
  output_range_getter_string = "objects[k]",
  output_range_getter_preconditions = [ ],
  with_given_object_position = "Source",
  return_type = "morphism",
  dual_operation = "InjectionOfCofactorOfCoproduct" ),

ProjectionInFactorOfDirectProductWithGivenDirectProduct = @rec(
  filter_list = [ "category", "list_of_objects", "integer", "object" ],
  input_arguments_names = [ "cat", "objects", "k", "P" ],
  output_source_getter_string = "P",
  output_source_getter_preconditions = [ ],
  output_range_getter_string = "objects[k]",
  output_range_getter_preconditions = [ ],
  return_type = "morphism",
  dual_operation = "InjectionOfCofactorOfCoproductWithGivenCoproduct" ),

UniversalMorphismIntoDirectProduct = @rec(
  filter_list = [ "category", "list_of_objects", "object", "list_of_morphisms" ],
  input_arguments_names = [ "cat", "objects", "T", "tau" ],
  output_source_getter_string = "T",
  output_source_getter_preconditions = [ ],
  with_given_object_position = "Range",
  dual_operation = "UniversalMorphismFromCoproduct",
  
  pre_function = function( cat, diagram, test_object, source )
    local current_morphism;
    
    for current_morphism in source
        
        if (@not IsEqualForObjects( cat, Source( current_morphism ), test_object ))
            
            return [ false, "sources of morphisms must be equal to the test object in given source diagram" ];
            
        end;
        
    end;
    
    return [ true ];
    
  end,
  return_type = "morphism",
  compatible_with_congruence_of_morphisms = true,
),

UniversalMorphismIntoDirectProductWithGivenDirectProduct = @rec(
  filter_list = [ "category", "list_of_objects", "object", "list_of_morphisms", "object" ],
  input_arguments_names = [ "cat", "objects", "T", "tau", "P" ],
  output_source_getter_string = "T",
  output_source_getter_preconditions = [ ],
  output_range_getter_string = "P",
  output_range_getter_preconditions = [ ],
  dual_operation = "UniversalMorphismFromCoproductWithGivenCoproduct",
  
  pre_function = function( cat, diagram, test_object, source, direct_product )
    local current_morphism;
    
    for current_morphism in source
        
        if (@not IsEqualForObjects( cat, Source( current_morphism ), test_object ))
            
            return [ false, "sources of morphisms must be equal to the test object in given source diagram" ];
            
        end;
        
    end;
    
    return [ true ];
    
  end,
  return_type = "morphism",
  compatible_with_congruence_of_morphisms = true,
),

ComponentOfMorphismIntoDirectProduct = @rec(
  filter_list = [ "category", "morphism", "list_of_objects", "integer" ],
  input_arguments_names = [ "cat", "alpha", "P", "i" ],
  output_source_getter_string = "Source( alpha )",
  output_source_getter_preconditions = [ ],
  output_range_getter_string = "P[i]",
  output_range_getter_preconditions = [ ],
  return_type = "morphism",
  dual_operation = "ComponentOfMorphismFromCoproduct" ),

IsCongruentForMorphisms = @rec(
  filter_list = [ "category", "morphism", "morphism" ],
  dual_operation = "IsCongruentForMorphisms",
  
  pre_function = function( cat, morphism_1, morphism_2 )
    
    if (@not IsEqualForObjects( cat, Source( morphism_1 ), Source( morphism_2 ) ))
        
        return [ false, "sources are not equal" ];
        
    end;
        
    if (@not IsEqualForObjects( cat, Range( morphism_1 ), Range( morphism_2 ) ))
        
        return [ false, "ranges are not equal" ];
        
    end;
    
    return [ true ];
    
  end,
  
  redirect_function = function( cat, morphism_1, morphism_2 )
    
    if (IsIdenticalObj( morphism_1, morphism_2 ))
      
      return [ true, true ];
      
    else
      
      return [ false ];
      
    end;
    
  end,
  
  post_function = function( cat, morphism_1, morphism_2, return_value )
    
    if (cat.predicate_logic_propagation_for_morphisms &&
       cat.predicate_logic && return_value == true)
          
          INSTALL_TODO_LIST_FOR_EQUAL_MORPHISMS( morphism_1, morphism_2 );
          
    end;
    
  end,
  
  return_type = "bool",
  compatible_with_congruence_of_morphisms = true,
),

IsEqualForMorphisms = @rec(
  filter_list = [ "category", "morphism", "morphism" ],
  dual_operation = "IsEqualForMorphisms",
  
  pre_function = function( cat, morphism_1, morphism_2 )
    
    if (@not IsEqualForObjects( cat, Source( morphism_1 ), Source( morphism_2 ) ))
        
        return [ false, "sources are not equal" ];
        
    end;
        
    if (@not IsEqualForObjects( cat, Range( morphism_1 ), Range( morphism_2 ) ))
        
        return [ false, "ranges are not equal" ];
        
    end;
    
    return [ true ];
    
  end,
  
  redirect_function = function( cat, morphism_1, morphism_2 )
    
    if (IsIdenticalObj( morphism_1, morphism_2 ))
      
      return [ true, true ];
      
    else
      
      return [ false ];
      
    end;
    
  end,
  
  return_type = "bool",
  compatible_with_congruence_of_morphisms = false,
),

IsEqualForMorphismsOnMor = @rec(
  filter_list = [ "category", "morphism", "morphism" ],
  dual_operation = "IsEqualForMorphismsOnMor",
  
  redirect_function = function( cat, morphism_1, morphism_2 )
    
    if (IsIdenticalObj( morphism_1, morphism_2 ))
      
      return [ true, true ];
      
    else
      
      return [ false ];
      
    end;
    
  end,
  
  return_type = "bool",
  compatible_with_congruence_of_morphisms = false,
),

IsEqualForObjects = @rec(
  filter_list = [ "category", "object", "object" ],
  dual_operation = "IsEqualForObjects",
  
  redirect_function = function( cat, object_1, object_2 )
    
    if (IsIdenticalObj( object_1, object_2 ))
      
      return [ true, true ];
      
    else
      
      return [ false ];
      
    end;
    
  end,
  
  post_function = function( cat, object_1, object_2, return_value )
    
    if (cat.predicate_logic_propagation_for_objects &&
       cat.predicate_logic && return_value == true && @not IsIdenticalObj( object_1, object_2 ))
        
        INSTALL_TODO_LIST_FOR_EQUAL_OBJECTS( object_1, object_2 );
        
    end;
    
  end,
  
  return_type = "bool" ),
  
IsEqualForCacheForObjects = @rec(
  filter_list = [ "category", "object", "object" ],
  dual_operation = "IsEqualForCacheForObjects",
  return_type = "bool" ),

IsEqualForCacheForMorphisms = @rec(
  filter_list = [ "category", "morphism", "morphism" ],
  dual_operation = "IsEqualForCacheForMorphisms",
  return_type = "bool",
  compatible_with_congruence_of_morphisms = false,
),

IsIsomorphicForObjects = @rec(
  filter_list = [ "category", "object", "object" ],
  input_arguments_names = [ "cat", "object_1", "object_2" ],
  return_type = "bool",
  dual_operation = "IsIsomorphicForObjects",
  # The witness SomeIsomorphismBetweenObjects needs reversed arguments.
  # This shows that reversing the arguments is the correct dualization,
  # even if the relation is symmetric.
  dual_arguments_reversed = true,
  redirect_function = function( cat, object_1, object_2 )
    
    # As any CAP operation, IsIsomorphicForObjects must be compatible with IsEqualForObjects.
    # This implies that IsIsomorphicForObjects must be coarser than IsEqualForObjects:
    # One can see this by first choosing object_2 = object_1 and the varying one argument with regard to IsEqualForObjects.
    if (IsEqualForObjects( object_1, object_2 ))
        
        return [ true, true ];
        
    else
        
        return [ false ];
        
    end;
    
  end,
),

SomeIsomorphismBetweenObjects = @rec(
  filter_list = [ "category", "object", "object" ],
  input_arguments_names = [ "cat", "object_1", "object_2" ],
  return_type = "morphism",
  output_source_getter_string = "object_1",
  output_source_getter_preconditions = [ ],
  output_range_getter_string = "object_2",
  output_range_getter_preconditions = [ ],
  dual_operation = "SomeIsomorphismBetweenObjects",
  dual_arguments_reversed = true,
),

IsZeroForMorphisms = @rec(
  filter_list = [ "category", "morphism" ],
  return_type = "bool",
  dual_operation = "IsZeroForMorphisms",
  is_reflected_by_faithful_functor = true,
  compatible_with_congruence_of_morphisms = true,
),

AdditionForMorphisms = @rec(
  filter_list = [ "category", "morphism", "morphism" ],
  input_arguments_names = [ "cat", "alpha", "beta" ],
  output_source_getter_string = "Source( alpha )",
  output_source_getter_preconditions = [ ],
  output_range_getter_string = "Range( alpha )",
  output_range_getter_preconditions = [ ],
  dual_operation = "AdditionForMorphisms",
  
  pre_function = function( cat, morphism_1, morphism_2 )
    
    if (@not IsEqualForObjects( cat, Source( morphism_1 ), Source( morphism_2 ) ))
        
        return [ false, "sources are not equal" ];
        
    end;
        
    if (@not IsEqualForObjects( cat, Range( morphism_1 ), Range( morphism_2 ) ))
        
        return [ false, "ranges are not equal" ];
        
    end;
    
    return [ true ];
    
  end,
  return_type = "morphism",
  compatible_with_congruence_of_morphisms = true,
),

SubtractionForMorphisms = @rec(
  filter_list = [ "category", "morphism", "morphism" ],
  input_arguments_names = [ "cat", "alpha", "beta" ],
  output_source_getter_string = "Source( alpha )",
  output_source_getter_preconditions = [ ],
  output_range_getter_string = "Range( alpha )",
  output_range_getter_preconditions = [ ],
  dual_operation = "SubtractionForMorphisms",
  
  pre_function = function( cat, morphism_1, morphism_2 )
    
    if (@not IsEqualForObjects( cat, Source( morphism_1 ), Source( morphism_2 ) ))
        
        return [ false, "sources are not equal" ];
        
    end;
        
    if (@not IsEqualForObjects( cat, Range( morphism_1 ), Range( morphism_2 ) ))
        
        return [ false, "ranges are not equal" ];
        
    end;
    
    return [ true ];
    
  end,
  return_type = "morphism",
  compatible_with_congruence_of_morphisms = true,
),

MultiplyWithElementOfCommutativeRingForMorphisms = @rec(
  filter_list = [ "category", "element_of_commutative_ring_of_linear_structure", "morphism" ],
  input_arguments_names = [ "cat", "r", "alpha" ],
  output_source_getter_string = "Source( alpha )",
  output_source_getter_preconditions = [ ],
  output_range_getter_string = "Range( alpha )",
  output_range_getter_preconditions = [ ],
  
  pre_function = function( cat, r, morphism )
    
    if (@not r in CommutativeRingOfLinearCategory( cat ))
      
      return [ false, "the first argument is not an element of the ring of the category of the morphism" ];
      
    end;
    
    return [ true ];
  end,
  dual_operation = "MultiplyWithElementOfCommutativeRingForMorphisms",
  return_type = "morphism",
  compatible_with_congruence_of_morphisms = true,
),

AdditiveInverseForMorphisms = @rec(
  filter_list = [ "category", "morphism" ],
  input_arguments_names = [ "cat", "alpha" ],
  output_source_getter_string = "Source( alpha )",
  output_source_getter_preconditions = [ ],
  output_range_getter_string = "Range( alpha )",
  output_range_getter_preconditions = [ ],
  dual_operation = "AdditiveInverseForMorphisms",
  return_type = "morphism",
  compatible_with_congruence_of_morphisms = true,
),

Coproduct = @rec(
  filter_list = [ "category", "list_of_objects" ],
  input_arguments_names = [ "cat", "objects" ],
  return_type = "object",
  dual_operation = "DirectProduct",
  functorial = "CoproductFunctorial",
),

InjectionOfCofactorOfCoproduct = @rec(
  filter_list = [ "category", "list_of_objects", "integer" ],
  input_arguments_names = [ "cat", "objects", "k" ],
  output_source_getter_string = "objects[k]",
  output_source_getter_preconditions = [ ],
  with_given_object_position = "Range",
  return_type = "morphism",
  dual_operation = "ProjectionInFactorOfDirectProduct" ),

InjectionOfCofactorOfCoproductWithGivenCoproduct = @rec(
  filter_list = [ "category", "list_of_objects", "integer", "object" ],
  input_arguments_names = [ "cat", "objects", "k", "P" ],
  output_source_getter_string = "objects[k]",
  output_source_getter_preconditions = [ ],
  output_range_getter_string = "P",
  output_range_getter_preconditions = [ ],
  return_type = "morphism",
  dual_operation = "ProjectionInFactorOfDirectProductWithGivenDirectProduct" ),

UniversalMorphismFromCoproduct = @rec(
  filter_list = [ "category", "list_of_objects", "object", "list_of_morphisms" ],
  input_arguments_names = [ "cat", "objects", "T", "tau" ],
  output_range_getter_string = "T",
  output_range_getter_preconditions = [ ],
  with_given_object_position = "Source",
  dual_operation = "UniversalMorphismIntoDirectProduct",
  
  pre_function = function( cat, diagram, test_object, sink )
    local current_morphism;
    
    for current_morphism in sink
        
        if (@not IsEqualForObjects( cat, Range( current_morphism ), test_object ))
            
            return [ false, "ranges of morphisms must be equal to the test object in given sink diagram" ];
            
        end;
        
    end;
    
    return [ true ];
    
  end,
  return_type = "morphism",
  compatible_with_congruence_of_morphisms = true,
),

UniversalMorphismFromCoproductWithGivenCoproduct = @rec(
  filter_list = [ "category", "list_of_objects", "object", "list_of_morphisms", "object" ],
  input_arguments_names = [ "cat", "objects", "T", "tau", "P" ],
  output_source_getter_string = "P",
  output_source_getter_preconditions = [ ],
  output_range_getter_string = "T",
  output_range_getter_preconditions = [ ],
  dual_operation = "UniversalMorphismIntoDirectProductWithGivenDirectProduct",
  
  pre_function = function( cat, diagram, test_object, sink, coproduct )
    local current_morphism;
    
    for current_morphism in sink
        
        if (@not IsEqualForObjects( cat, Range( current_morphism ), test_object ))
            
            return [ false, "ranges of morphisms must be equal to the test object in given sink diagram" ];
            
        end;
        
    end;
    
    return [ true ];
    
  end,
  return_type = "morphism",
  compatible_with_congruence_of_morphisms = true,
),

ComponentOfMorphismFromCoproduct = @rec(
  filter_list = [ "category", "morphism", "list_of_objects", "integer" ],
  input_arguments_names = [ "cat", "alpha", "I", "i" ],
  output_source_getter_string = "I[i]",
  output_source_getter_preconditions = [ ],
  output_range_getter_string = "Range( alpha )",
  output_range_getter_preconditions = [ ],
  return_type = "morphism",
  dual_operation = "ComponentOfMorphismIntoDirectProduct" ),

IsEqualAsSubobjects = @rec(
  filter_list = [ "category", "morphism", "morphism" ],
  return_type = "bool",
  dual_operation = "IsEqualAsFactorobjects",
  compatible_with_congruence_of_morphisms = true,
),

IsEqualAsFactorobjects = @rec(
  filter_list = [ "category", "morphism", "morphism" ],
  return_type = "bool",
  dual_operation = "IsEqualAsSubobjects",
  compatible_with_congruence_of_morphisms = true,
),

IsDominating = @rec(
  filter_list = [ "category", "morphism", "morphism" ],
  dual_operation = "IsCodominating",
  
  pre_function = function( cat, sub1, sub2 )
    
    if (@not IsEqualForObjects( cat, Range( sub1 ), Range( sub2 ) ))
        
        return [ false, "subobjects of different objects are not comparable by dominates" ];
        
    end;
    
    return [ true ];
  end,
  return_type = "bool",
  compatible_with_congruence_of_morphisms = true,
),

IsCodominating = @rec(
  filter_list = [ "category", "morphism", "morphism" ],
  dual_operation = "IsDominating",
  
  pre_function = function( cat, factor1, factor2 )
    
    if (@not IsEqualForObjects( cat, Source( factor1 ), Source( factor2 ) ))
        
        return [ false, "factors of different objects are not comparable by codominates" ];
        
    end;
    
    return [ true ];
  end,
  return_type = "bool",
  compatible_with_congruence_of_morphisms = true,
),

Equalizer = @rec(
  filter_list = [ "category", "object", "list_of_morphisms" ],
  input_arguments_names = [ "cat", "Y", "morphisms" ],
  return_type = "object",
  dual_operation = "Coequalizer",
  
  pre_function = function( cat, cobase, diagram )
    local base, current_morphism;
    
    if (IsEmpty( diagram ))
        
        return [ true ];
        
    end;
    
    for current_morphism in diagram[(1):(Length( diagram ))]
        
        if (@not IsEqualForObjects( cat, Source( current_morphism ), cobase ))
            return [ false, "the given morphisms of the equalizer diagram must have equal sources" ];
        end;
        
    end;
    
    base = Range( diagram[1] );
    
    for current_morphism in diagram[(2):(Length( diagram ))]
        
        if (@not IsEqualForObjects( cat, Range( current_morphism ), base ))
            return [ false, "the given morphisms of the equalizer diagram must have equal ranges" ];
        end;
        
    end;
    
    return [ true ];
  end,
  compatible_with_congruence_of_morphisms = false,
  functorial = "EqualizerFunctorial",
),

EmbeddingOfEqualizer = @rec(
  filter_list = [ "category", "object", "list_of_morphisms" ],
  return_type = "morphism",
  input_arguments_names = [ "cat", "Y", "morphisms" ],
  output_range_getter_string = "Y",
  output_range_getter_preconditions = [ ],
  with_given_object_position = "Source",
  dual_operation = "ProjectionOntoCoequalizer",
  
  pre_function = "Equalizer",
  compatible_with_congruence_of_morphisms = false,
),

EmbeddingOfEqualizerWithGivenEqualizer = @rec(
  filter_list = [ "category", "object", "list_of_morphisms", "object" ],
  return_type = "morphism",
  input_arguments_names = [ "cat", "Y", "morphisms", "P" ],
  output_source_getter_string = "P",
  output_source_getter_preconditions = [ ],
  output_range_getter_string = "Y",
  output_range_getter_preconditions = [ ],
  dual_operation = "ProjectionOntoCoequalizerWithGivenCoequalizer",
  compatible_with_congruence_of_morphisms = false,
),

MorphismFromEqualizerToSink = @rec(
  filter_list = [ "category", "object", "list_of_morphisms" ],
  input_arguments_names = [ "cat", "Y", "morphisms" ],
  output_range_getter_string = "Range( morphisms[1] )",
  output_range_getter_preconditions = [ ],
  with_given_object_position = "Source",
  dual_operation = "MorphismFromSourceToCoequalizer",
  return_type = "morphism",
  compatible_with_congruence_of_morphisms = false,
),

MorphismFromEqualizerToSinkWithGivenEqualizer = @rec(
  filter_list = [ "category", "object", "list_of_morphisms", "object" ],
  input_arguments_names = [ "cat", "Y", "morphisms", "P" ],
  output_source_getter_string = "P",
  output_source_getter_preconditions = [ ],
  output_range_getter_string = "Range( morphisms[1] )",
  output_range_getter_preconditions = [ ],
  dual_operation = "MorphismFromSourceToCoequalizerWithGivenCoequalizer",
  return_type = "morphism",
  compatible_with_congruence_of_morphisms = false,
),

UniversalMorphismIntoEqualizer = @rec(
  filter_list = [ "category", "object", "list_of_morphisms", "object", "morphism" ],
  input_arguments_names = [ "cat", "Y", "morphisms", "T", "tau" ],
  output_source_getter_string = "T",
  output_source_getter_preconditions = [ ],
  with_given_object_position = "Range",
  return_type = "morphism",
  dual_operation = "UniversalMorphismFromCoequalizer",
  
  pre_function = function( cat, cobase, diagram, test_object, tau )
    local base, current_morphism, current_morphism_position;
    
    if (IsEmpty( diagram ))
        
        return [ true ];
        
    end;
    
    for current_morphism in diagram[(1):(Length( diagram ))]
        
        if (@not IsEqualForObjects( cat, Source( current_morphism ), cobase ))
            return [ false, "the given morphisms of the equalizer diagram must have equal sources" ];
        end;
        
    end;
    
    base = Range( diagram[1] );
    
    for current_morphism in diagram[(2):(Length( diagram ))]
        
        if (@not IsEqualForObjects( cat, Range( current_morphism ), base ))
            return [ false, "the given morphisms of the equalizer diagram must have equal ranges" ];
        end;
        
    end;
    
    for current_morphism_position in (1):(Length( diagram ))
        
        if (@not IsEqualForObjects( cat, Source( diagram[ current_morphism_position ] ), Range( tau ) ))
            return [ false, @Concatenation( "in diagram position ", StringGAP( current_morphism_position ), ": source and range are not equal" ) ];
        end;
        
    end;
    
    return [ true ];
  end,
  compatible_with_congruence_of_morphisms = false,
),

UniversalMorphismIntoEqualizerWithGivenEqualizer = @rec(
  filter_list = [ "category", "object", "list_of_morphisms", "object", "morphism", "object" ],
  input_arguments_names = [ "cat", "Y", "morphisms", "T", "tau", "P" ],
  output_source_getter_string = "T",
  output_source_getter_preconditions = [ ],
  output_range_getter_string = "P",
  output_range_getter_preconditions = [ ],
  return_type = "morphism",
  dual_operation = "UniversalMorphismFromCoequalizerWithGivenCoequalizer",
  compatible_with_congruence_of_morphisms = false,
),

IsomorphismFromEqualizerToKernelOfJointPairwiseDifferencesOfMorphismsIntoDirectProduct = @rec(
  filter_list = [ "category", "object", "list_of_morphisms" ],
  input_arguments_names = [ "cat", "A", "D" ],
  return_type = "morphism",
  dual_operation = "IsomorphismFromCokernelOfJointPairwiseDifferencesOfMorphismsFromCoproductToCoequalizer",
),

IsomorphismFromKernelOfJointPairwiseDifferencesOfMorphismsIntoDirectProductToEqualizer = @rec(
  filter_list = [ "category", "object", "list_of_morphisms" ],
  input_arguments_names = [ "cat", "A", "D" ],
  return_type = "morphism",
  dual_operation = "IsomorphismFromCoequalizerToCokernelOfJointPairwiseDifferencesOfMorphismsFromCoproduct",
),

FiberProduct = @rec(
  filter_list = [ "category", "list_of_morphisms" ],
  input_arguments_names = [ "cat", "morphisms" ],
  dual_operation = "Pushout",
  
  pre_function = function( cat, diagram )
    local base, current_morphism;
    
    if (IsEmpty( diagram ))
        
        return [ true ];
        
    end;
    
    base = Range( diagram[1] );
    
    for current_morphism in diagram[(2):(Length( diagram ))]
        
        if (@not IsEqualForObjects( cat, Range( current_morphism ), base ))
            return [ false, "the given morphisms of the fiber product diagram must have equal ranges" ];
        end;
        
    end;
    
    return [ true ];
  end,
  return_type = "object",
  compatible_with_congruence_of_morphisms = false,
  functorial = "FiberProductFunctorial",
),

ProjectionInFactorOfFiberProduct = @rec(
  filter_list = [ "category", "list_of_morphisms", "integer" ],
  input_arguments_names = [ "cat", "morphisms", "k" ],
  output_range_getter_string = "Source( morphisms[k] )",
  output_range_getter_preconditions = [ ],
  with_given_object_position = "Source",
  dual_operation = "InjectionOfCofactorOfPushout",
  
  pre_function = function( cat, diagram, projection_number )
    local base, current_morphism;
    
    if (projection_number < 1 || projection_number > Length( diagram ))
        return[ false, @Concatenation( "there does not exist a ", StringGAP( projection_number ), "th projection" ) ];
    end;
    
    base = Range( diagram[1] );
    
    for current_morphism in diagram[(2):(Length( diagram ))]
        
        if (@not IsEqualForObjects( cat, Range( current_morphism ), base ))
            return [ false, "the given morphisms of the fiber product diagram must have equal ranges" ];
        end;
        
    end;
    
    return [ true ];
  end,
  return_type = "morphism",
  compatible_with_congruence_of_morphisms = false,
),

ProjectionInFactorOfFiberProductWithGivenFiberProduct = @rec(
  filter_list = [ "category", "list_of_morphisms", "integer", "object" ],
  input_arguments_names = [ "cat", "morphisms", "k", "P" ],
  output_source_getter_string = "P",
  output_source_getter_preconditions = [ ],
  output_range_getter_string = "Source( morphisms[k] )",
  output_range_getter_preconditions = [ ],
  dual_operation = "InjectionOfCofactorOfPushoutWithGivenPushout",
  
  pre_function = function( cat, diagram, projection_number, pullback )
    local base, current_morphism;
    
    if (projection_number < 1 || projection_number > Length( diagram ))
        return[ false, @Concatenation( "there does not exist a ", StringGAP( projection_number ), "th projection" ) ];
    end;
    
    base = Range( diagram[1] );
    
    for current_morphism in diagram[(2):(Length( diagram ))]
        
        if (@not IsEqualForObjects( cat, Range( current_morphism ), base ))
            return [ false, "the given morphisms of the fiber product diagram must have equal ranges" ];
        end;
        
    end;
    
    return [ true ];
  end,
  return_type = "morphism",
  compatible_with_congruence_of_morphisms = false,
),

MorphismFromFiberProductToSink = @rec(
  filter_list = [ "category", "list_of_morphisms" ],
  input_arguments_names = [ "cat", "morphisms" ],
  output_range_getter_string = "Range( morphisms[1] )",
  output_range_getter_preconditions = [ ],
  with_given_object_position = "Source",
  dual_operation = "MorphismFromSourceToPushout",
  
  pre_function = function( cat, diagram )
    local base, current_morphism;
    
    base = Range( diagram[1] );
    
    for current_morphism in diagram[(2):(Length( diagram ))]
        
        if (@not IsEqualForObjects( cat, Range( current_morphism ), base ))
            return [ false, "the given morphisms of the fiber product diagram must have equal ranges" ];
        end;
        
    end;
    
    return [ true ];
  end,
  return_type = "morphism",
  compatible_with_congruence_of_morphisms = false,
),

MorphismFromFiberProductToSinkWithGivenFiberProduct = @rec(
  filter_list = [ "category", "list_of_morphisms", "object" ],
  input_arguments_names = [ "cat", "morphisms", "P" ],
  output_source_getter_string = "P",
  output_source_getter_preconditions = [ ],
  output_range_getter_string = "Range( morphisms[1] )",
  output_range_getter_preconditions = [ ],
  dual_operation = "MorphismFromSourceToPushoutWithGivenPushout",
  
  pre_function = function( cat, diagram, pullback )
    local base, current_morphism;
    
    base = Range( diagram[1] );
    
    for current_morphism in diagram[(2):(Length( diagram ))]
        
        if (@not IsEqualForObjects( cat, Range( current_morphism ), base ))
            return [ false, "the given morphisms of the fiber product diagram must have equal ranges" ];
        end;
        
    end;
    
    return [ true ];
  end,
  return_type = "morphism",
  compatible_with_congruence_of_morphisms = false,
),

UniversalMorphismIntoFiberProduct = @rec(
  filter_list = [ "category", "list_of_morphisms", "object", "list_of_morphisms" ],
  input_arguments_names = [ "cat", "morphisms", "T", "tau" ],
  output_source_getter_string = "T",
  output_source_getter_preconditions = [ ],
  with_given_object_position = "Range",
  dual_operation = "UniversalMorphismFromPushout",
  
  pre_function = function( cat, diagram, test_object, source )
    local base, current_morphism, current_morphism_position;
    
    if (Length( diagram ) != Length( source ))
        return [ false, "fiber product diagram and test diagram must have equal length" ];
    end;
    
    if (IsEmpty( diagram ))
        
        return [ true ];
        
    end;
    
    base = Range( diagram[1] );
    
    for current_morphism in diagram[(2):(Length( diagram ))]
        
        if (@not IsEqualForObjects( cat, Range( current_morphism ), base ))
            return [ false, "the given morphisms of the fiber product diagram must have equal ranges" ];
        end;
        
    end;
    
    for current_morphism in source
        
        if (@not IsEqualForObjects( cat, Source( current_morphism ), test_object ))
            return [ false, "the given morphisms of the test source do not have sources equal to the test object" ];
        end;
        
    end;
    
    for current_morphism_position in (1):(Length( diagram ))
        
        if (@not IsEqualForObjects( cat, Source( diagram[ current_morphism_position ] ), Range( source[ current_morphism_position ] ) ))
            return [ false, @Concatenation( "in diagram position ", StringGAP( current_morphism_position ), ": source and range are not equal" ) ];
        end;
        
    end;
    
    return [ true ];
  end,
  return_type = "morphism",
  compatible_with_congruence_of_morphisms = false,
),

UniversalMorphismIntoFiberProductWithGivenFiberProduct = @rec(
  filter_list = [ "category", "list_of_morphisms", "object", "list_of_morphisms", "object" ],
  input_arguments_names = [ "cat", "morphisms", "T", "tau", "P" ],
  output_source_getter_string = "T",
  output_source_getter_preconditions = [ ],
  output_range_getter_string = "P",
  output_range_getter_preconditions = [ ],
  dual_operation = "UniversalMorphismFromPushoutWithGivenPushout",
  
  pre_function = function( cat, diagram, test_object, source, pullback )
    local base, current_morphism, current_morphism_position;
    
    if (Length( diagram ) != Length( source ))
        return [ false, "fiber product diagram and test diagram must have equal length" ];
    end;
    
    if (IsEmpty( diagram ))
        
        return [ true ];
        
    end;
    
    base = Range( diagram[1] );
    
    for current_morphism in diagram[(2):(Length( diagram ))]
        
        if (@not IsEqualForObjects( cat, Range( current_morphism ), base ))
            return [ false, "the given morphisms of the fiber product diagram must have equal ranges" ];
        end;
        
    end;
    
    for current_morphism in source
        
        if (@not IsEqualForObjects( cat, Source( current_morphism ), test_object ))
            return [ false, "the given morphisms of the test source do not have sources equal to the test object" ];
        end;
        
    end;
    
    for current_morphism_position in (1):(Length( diagram ))
        
        if (@not IsEqualForObjects( cat, Source( diagram[ current_morphism_position ] ), Range( source[ current_morphism_position ] ) ))
            return [ false, @Concatenation( "in diagram position ", StringGAP( current_morphism_position ), ": source and range are not equal" ) ];
        end;
        
    end;
    
    return [ true ];
  end,
  return_type = "morphism",
  compatible_with_congruence_of_morphisms = false,
),

Coequalizer = @rec(
  filter_list = [ "category", "object", "list_of_morphisms" ],
  input_arguments_names = [ "cat", "Y", "morphisms" ],
  return_type = "object",
  dual_operation = "Equalizer",
  
  pre_function = function( cat, cobase, diagram )
    local base, current_morphism;
    
    if (IsEmpty( diagram ))
        
        return [ true ];
        
    end;
    
    base = Source( diagram[1] );
    
    for current_morphism in diagram[(2):(Length( diagram ))]
        
        if (@not IsEqualForObjects( cat, Source( current_morphism ), base ))
            return [ false, "the given morphisms of the coequalizer diagram must have equal sources" ];
        end;
        
    end;
    
    for current_morphism in diagram[(1):(Length( diagram ))]
        
        if (@not IsEqualForObjects( cat, Range( current_morphism ), cobase ))
            return [ false, "the given morphisms of the coequalizer diagram must have equal ranges" ];
        end;
        
    end;
    
    return [ true ];
  end,
  compatible_with_congruence_of_morphisms = false,
  functorial = "CoequalizerFunctorial",
),

ProjectionOntoCoequalizer = @rec(
  filter_list = [ "category", "object", "list_of_morphisms" ],
  return_type = "morphism",
  input_arguments_names = [ "cat", "Y", "morphisms" ],
  output_source_getter_string = "Y",
  output_source_getter_preconditions = [ ],
  with_given_object_position = "Range",
  dual_operation = "EmbeddingOfEqualizer",
  
  pre_function = "Coequalizer",
  compatible_with_congruence_of_morphisms = false,
),

ProjectionOntoCoequalizerWithGivenCoequalizer = @rec(
  filter_list = [ "category", "object", "list_of_morphisms", "object" ],
  return_type = "morphism",
  input_arguments_names = [ "cat", "Y", "morphisms", "P" ],
  output_source_getter_string = "Y",
  output_source_getter_preconditions = [ ],
  output_range_getter_string = "P",
  output_range_getter_preconditions = [ ],
  dual_operation = "EmbeddingOfEqualizerWithGivenEqualizer",
  compatible_with_congruence_of_morphisms = false,
),

MorphismFromSourceToCoequalizer = @rec(
  filter_list = [ "category", "object", "list_of_morphisms" ],
  input_arguments_names = [ "cat", "Y", "morphisms" ],
  output_source_getter_string = "Source( morphisms[1] )",
  output_source_getter_preconditions = [ ],
  with_given_object_position = "Range",
  dual_operation = "MorphismFromEqualizerToSink",
  return_type = "morphism",
  compatible_with_congruence_of_morphisms = false,
),

MorphismFromSourceToCoequalizerWithGivenCoequalizer = @rec(
  filter_list = [ "category", "object", "list_of_morphisms", "object" ],
  input_arguments_names = [ "cat", "Y", "morphisms", "P" ],
  output_source_getter_string = "Source( morphisms[1] )",
  output_source_getter_preconditions = [ ],
  output_range_getter_string = "P",
  output_range_getter_preconditions = [ ],
  dual_operation = "MorphismFromEqualizerToSinkWithGivenEqualizer",
  return_type = "morphism",
  compatible_with_congruence_of_morphisms = false,
),

UniversalMorphismFromCoequalizer = @rec(
  filter_list = [ "category", "object", "list_of_morphisms", "object", "morphism" ],
  input_arguments_names = [ "cat", "Y", "morphisms", "T", "tau" ],
  output_range_getter_string = "T",
  output_range_getter_preconditions = [ ],
  with_given_object_position = "Source",
  return_type = "morphism",
  dual_operation = "UniversalMorphismIntoEqualizer",
  
  pre_function = function( cat, cobase, diagram, test_object, tau )
    local base, current_morphism, current_morphism_position;
    
    if (IsEmpty( diagram ))
        
        return [ true ];
        
    end;
    
    base = Source( diagram[1] );
    
    for current_morphism in diagram[(2):(Length( diagram ))]
        
        if (@not IsEqualForObjects( cat, Source( current_morphism ), base ))
            return [ false, "the given morphisms of the coequalizer diagram must have equal sources" ];
        end;
        
    end;
    
    for current_morphism in diagram[(1):(Length( diagram ))]
        
        if (@not IsEqualForObjects( cat, Range( current_morphism ), cobase ))
            return [ false, "the given morphisms of the coequalizer diagram must have equal ranges" ];
        end;
        
    end;
    
    for current_morphism_position in (1):(Length( diagram ))
        
        if (@not IsEqualForObjects( cat, Range( diagram[ current_morphism_position ] ), Source( tau ) ))
            return [ false, @Concatenation( "in diagram position ", StringGAP( current_morphism_position ), ": range and source are not equal" ) ];
        end;
        
    end;
    
    return [ true ];
  end,
  compatible_with_congruence_of_morphisms = false,
),

UniversalMorphismFromCoequalizerWithGivenCoequalizer = @rec(
  filter_list = [ "category", "object", "list_of_morphisms", "object", "morphism", "object" ],
  input_arguments_names = [ "cat", "Y", "morphisms", "T", "tau", "P" ],
  output_source_getter_string = "P",
  output_source_getter_preconditions = [ ],
  output_range_getter_string = "T",
  output_range_getter_preconditions = [ ],
  return_type = "morphism",
  dual_operation = "UniversalMorphismIntoEqualizerWithGivenEqualizer",
  compatible_with_congruence_of_morphisms = false,
),

IsomorphismFromCoequalizerToCokernelOfJointPairwiseDifferencesOfMorphismsFromCoproduct = @rec(
  filter_list = [ "category", "object", "list_of_morphisms" ],
  input_arguments_names = [ "cat", "A", "D" ],
  return_type = "morphism",
  dual_operation = "IsomorphismFromKernelOfJointPairwiseDifferencesOfMorphismsIntoDirectProductToEqualizer",
),

IsomorphismFromCokernelOfJointPairwiseDifferencesOfMorphismsFromCoproductToCoequalizer = @rec(
  filter_list = [ "category", "object", "list_of_morphisms" ],
  input_arguments_names = [ "cat", "A", "D" ],
  return_type = "morphism",
  dual_operation = "IsomorphismFromEqualizerToKernelOfJointPairwiseDifferencesOfMorphismsIntoDirectProduct",
),

Pushout = @rec(
  filter_list = [ "category", "list_of_morphisms" ],
  input_arguments_names = [ "cat", "morphisms" ],
  dual_operation = "FiberProduct",
  
  pre_function = function( cat, diagram )
    local cobase, current_morphism;
    
    if (IsEmpty( diagram ))
        
        return [ true ];
        
    end;
    
    cobase = Source( diagram[1] );
    
    for current_morphism in diagram[(2):(Length( diagram ))]
        
        if (@not IsEqualForObjects( cat, Source( current_morphism ), cobase ))
            return [ false, "the given morphisms of the pushout diagram must have equal sources" ];
        end;
        
    end;
    
    return [ true ];
  end,
  return_type = "object",
  compatible_with_congruence_of_morphisms = false,
  functorial = "PushoutFunctorial",
),

InjectionOfCofactorOfPushout = @rec(
  filter_list = [ "category", "list_of_morphisms", "integer" ],
  input_arguments_names = [ "cat", "morphisms", "k" ],
  output_source_getter_string = "Range( morphisms[k] )",
  output_source_getter_preconditions = [ ],
  with_given_object_position = "Range",
  dual_operation = "ProjectionInFactorOfFiberProduct",
  
  pre_function = function( cat, diagram, injection_number )
    local cobase, current_morphism;
    
    if (injection_number < 1 || injection_number > Length( diagram ))
        return[ false, @Concatenation( "there does not exist a ", StringGAP( injection_number ), "th injection" ) ];
    end;
    
    cobase = Source( diagram[1] );
    
    for current_morphism in diagram[(2):(Length( diagram ))]
        
        if (@not IsEqualForObjects( cat, Source( current_morphism ), cobase ))
            return [ false, "the given morphisms of the pushout diagram must have equal sources" ];
        end;
        
    end;
    
    return [ true ];
  end,
  return_type = "morphism",
  compatible_with_congruence_of_morphisms = false,
),

InjectionOfCofactorOfPushoutWithGivenPushout = @rec(
  filter_list = [ "category", "list_of_morphisms", "integer", "object" ],
  input_arguments_names = [ "cat", "morphisms", "k", "P" ],
  output_source_getter_string = "Range( morphisms[k] )",
  output_source_getter_preconditions = [ ],
  output_range_getter_string = "P",
  output_range_getter_preconditions = [ ],
  dual_operation = "ProjectionInFactorOfFiberProductWithGivenFiberProduct",
  
  pre_function = function( cat, diagram, injection_number, pushout )
    local cobase, current_morphism;
    
    if (injection_number < 1 || injection_number > Length( diagram ))
        return[ false, @Concatenation( "there does not exist a ", StringGAP( injection_number ), "th injection" ) ];
    end;
    
    cobase = Source( diagram[1] );
    
    for current_morphism in diagram[(2):(Length( diagram ))]
        
        if (@not IsEqualForObjects( cat, Source( current_morphism ), cobase ))
            return [ false, "the given morphisms of the pushout diagram must have equal sources" ];
        end;
        
    end;
    
    return [ true ];
  end,
  return_type = "morphism",
  compatible_with_congruence_of_morphisms = false,
),

MorphismFromSourceToPushout = @rec(
  filter_list = [ "category", "list_of_morphisms" ],
  input_arguments_names = [ "cat", "morphisms" ],
  output_source_getter_string = "Source( morphisms[1] )",
  output_source_getter_preconditions = [ ],
  with_given_object_position = "Range",
  dual_operation = "MorphismFromFiberProductToSink",
  
  pre_function = function( cat, diagram )
    local cobase, current_morphism;
    
    cobase = Source( diagram[1] );
    
    for current_morphism in diagram[(2):(Length( diagram ))]
        
        if (@not IsEqualForObjects( cat, Source( current_morphism ), cobase ))
            return [ false, "the given morphisms of the pushout diagram must have equal sources" ];
        end;
        
    end;
    
    return [ true ];
  end,
  return_type = "morphism",
  compatible_with_congruence_of_morphisms = false,
),

MorphismFromSourceToPushoutWithGivenPushout = @rec(
  filter_list = [ "category", "list_of_morphisms", "object" ],
  input_arguments_names = [ "cat", "morphisms", "P" ],
  output_source_getter_string = "Source( morphisms[1] )",
  output_source_getter_preconditions = [ ],
  output_range_getter_string = "P",
  output_range_getter_preconditions = [ ],
  dual_operation = "MorphismFromFiberProductToSinkWithGivenFiberProduct",
  
  pre_function = function( cat, diagram, pushout )
    local cobase, current_morphism;
    
    cobase = Source( diagram[1] );
    
    for current_morphism in diagram[(2):(Length( diagram ))]
        
        if (@not IsEqualForObjects( cat, Source( current_morphism ), cobase ))
            return [ false, "the given morphisms of the pushout diagram must have equal sources" ];
        end;
        
    end;
    
    return [ true ];
  end,
  return_type = "morphism",
  compatible_with_congruence_of_morphisms = false,
),

UniversalMorphismFromPushout = @rec(
  filter_list = [ "category", "list_of_morphisms", "object", "list_of_morphisms" ],
  input_arguments_names = [ "cat", "morphisms", "T", "tau" ],
  output_range_getter_string = "T",
  output_range_getter_preconditions = [ ],
  with_given_object_position = "Source",
  dual_operation = "UniversalMorphismIntoFiberProduct",
  
  pre_function = function( cat, diagram, test_object, sink )
    local cobase, current_morphism, current_morphism_position;
    
    if (Length( diagram ) != Length( sink ))
        return [ false, "pushout diagram and test diagram must have equal length" ];
    end;
    
    if (IsEmpty( diagram ))
        
        return [ true ];
        
    end;
    
    cobase = Source( diagram[1] );
    
    for current_morphism in diagram[(2):(Length( diagram ))]
        
        if (@not IsEqualForObjects( cat, Source( current_morphism ), cobase ))
            return [ false, "the given morphisms of the fiber pushout must have equal sources" ];
        end;
        
    end;
    
    for current_morphism in sink
        
        if (@not IsEqualForObjects( cat, Range( current_morphism ), test_object ))
            return [ false, "the given morphisms of the test sink do not have ranges equal to the test object" ];
        end;
        
    end;
    
    for current_morphism_position in (1):(Length( diagram ))
        
        if (@not IsEqualForObjects( cat, Range( diagram[ current_morphism_position ] ), Source( sink[ current_morphism_position ] ) ))
            return [ false, @Concatenation( "in diagram position ", StringGAP( current_morphism_position ), ": source and range are not equal" ) ];
        end;
        
    end;
    
    return [ true ];
  end,
  return_type = "morphism",
  compatible_with_congruence_of_morphisms = false,
),

UniversalMorphismFromPushoutWithGivenPushout = @rec(
  filter_list = [ "category", "list_of_morphisms", "object", "list_of_morphisms", "object" ],
  input_arguments_names = [ "cat", "morphisms", "T", "tau", "P" ],
  output_source_getter_string = "P",
  output_source_getter_preconditions = [ ],
  output_range_getter_string = "T",
  output_range_getter_preconditions = [ ],
  dual_operation = "UniversalMorphismIntoFiberProductWithGivenFiberProduct",
  
  pre_function = function( cat, diagram, test_object, sink, pushout )
    local cobase, current_morphism, current_morphism_position;
    
    if (Length( diagram ) != Length( sink ))
        return [ false, "pushout diagram and test diagram must have equal length" ];
    end;
    
    if (IsEmpty( diagram ))
        
        return [ true ];
        
    end;
    
    cobase = Source( diagram[1] );
    
    for current_morphism in diagram[(2):(Length( diagram ))]
        
        if (@not IsEqualForObjects( cat, Source( current_morphism ), cobase ))
            return [ false, "the given morphisms of the fiber pushout must have equal sources" ];
        end;
        
    end;
    
    for current_morphism in sink
        
        if (@not IsEqualForObjects( cat, Range( current_morphism ), test_object ))
            return [ false, "the given morphisms of the test sink do not have ranges equal to the test object" ];
        end;
        
    end;
    
    for current_morphism_position in (1):(Length( diagram ))
        
        if (@not IsEqualForObjects( cat, Range( diagram[ current_morphism_position ] ), Source( sink[ current_morphism_position ] ) ))
            return [ false, @Concatenation( "in diagram position ", StringGAP( current_morphism_position ), ": source and range are not equal" ) ];
        end;
        
    end;
    
    return [ true ];
  end,
  return_type = "morphism",
  compatible_with_congruence_of_morphisms = false,
),

ImageObject = @rec(
  filter_list = [ "category", "morphism" ],
  return_type = "object",
  dual_operation = "CoimageObject",
  functorial = "ImageObjectFunctorial",
),

ImageEmbedding = @rec(
  filter_list = [ "category", "morphism" ],
  input_arguments_names = [ "cat", "alpha" ],
  output_range_getter_string = "Range( alpha )",
  output_range_getter_preconditions = [ ],
  with_given_object_position = "Source",
  return_type = "morphism",
  dual_operation = "CoimageProjection" ),

ImageEmbeddingWithGivenImageObject = @rec(
  filter_list = [ "category", "morphism", "object" ],
  input_arguments_names = [ "cat", "alpha", "I" ],
  output_source_getter_string = "I",
  output_source_getter_preconditions = [ ],
  output_range_getter_string = "Range( alpha )",
  output_range_getter_preconditions = [ ],
  return_type = "morphism",
  dual_operation = "CoimageProjectionWithGivenCoimageObject" ),

CoimageObject = @rec(
  filter_list = [ "category", "morphism" ],
  return_type = "object",
  dual_operation = "ImageObject",
  functorial = "CoimageObjectFunctorial",
),

CoimageProjection = @rec(
  filter_list = [ "category", "morphism" ],
  input_arguments_names = [ "cat", "alpha" ],
  output_source_getter_string = "Source( alpha )",
  output_source_getter_preconditions = [ ],
  with_given_object_position = "Range",
  return_type = "morphism",
  dual_operation = "ImageEmbedding" ),

CoimageProjectionWithGivenCoimageObject = @rec(
  filter_list = [ "category", "morphism", "object" ],
  input_arguments_names = [ "cat", "alpha", "C" ],
  output_source_getter_string = "Source( alpha )",
  output_source_getter_preconditions = [ ],
  output_range_getter_string = "C",
  output_range_getter_preconditions = [ ],
  return_type = "morphism",
  dual_operation = "ImageEmbeddingWithGivenImageObject" ),

AstrictionToCoimage = @rec(
  filter_list = [ "category", "morphism" ],
  input_arguments_names = [ "cat", "alpha" ],
  output_range_getter_string = "Range( alpha )",
  output_range_getter_preconditions = [ ],
  with_given_object_position = "Source",
  return_type = "morphism",
  dual_operation = "CoastrictionToImage" ),

AstrictionToCoimageWithGivenCoimageObject = @rec(
  filter_list = [ "category", "morphism", "object" ],
  input_arguments_names = [ "cat", "alpha", "C" ],
  output_source_getter_string = "C",
  output_source_getter_preconditions = [ ],
  output_range_getter_string = "Range( alpha )",
  output_range_getter_preconditions = [ ],
  return_type = "morphism",
  dual_operation = "CoastrictionToImageWithGivenImageObject" ),

UniversalMorphismIntoCoimage = @rec(
  filter_list = [ "category", "morphism", "pair_of_morphisms" ],
  input_arguments_names = [ "cat", "alpha", "tau" ],
  output_source_getter_string = "Range( tau[1] )",
  output_source_getter_preconditions = [ ],
  with_given_object_position = "Range",
  dual_preprocessor_func = function( cat, alpha, tau )
    return Triple( OppositeCategory( cat ), Opposite( alpha ), PairGAP( Opposite( tau[2] ), Opposite( tau[1] ) ) );
  end,
  pre_function = function( cat, morphism, test_factorization )
    
    if (@not IsEqualForObjects( cat, Source( morphism ), Source( test_factorization[ 1 ] ) ))
        return [ false, "source of morphism and test factorization are not equal" ];
    end;
    
    if (@not IsEqualForObjects( cat, Range( morphism ), Range( test_factorization[ 2 ] ) ))
        return [ false, "range of morphism and test factorization are not equal" ];
    end;
    
    if (@not IsEqualForObjects( cat, Range( test_factorization[ 1 ] ), Source( test_factorization[ 2 ] ) ))
        return [ false, "source and range of test factorization are not equal" ];
    end;
    
    return [ true ];
  end,
  return_type = "morphism",
  dual_operation = "UniversalMorphismFromImage" ),

UniversalMorphismIntoCoimageWithGivenCoimageObject = @rec(
  filter_list = [ "category", "morphism", "pair_of_morphisms", "object" ],
  input_arguments_names = [ "cat", "alpha", "tau", "C" ],
  output_source_getter_string = "Range( tau[1] )",
  output_source_getter_preconditions = [ ],
  output_range_getter_string = "C",
  output_range_getter_preconditions = [ ],
  dual_preprocessor_func = function( cat, alpha, tau, C )
    return @NTupleGAP( 4, OppositeCategory( cat ), Opposite( alpha ), PairGAP( Opposite( tau[2] ), Opposite( tau[1] ) ), Opposite( C ) );
  end,
  pre_function = function( cat, morphism, test_factorization, image )
    
    if (@not IsEqualForObjects( cat, Source( morphism ), Source( test_factorization[ 1 ] ) ))
        return [ false, "source of morphism and test factorization are not equal" ];
    end;
    
    if (@not IsEqualForObjects( cat, Range( morphism ), Range( test_factorization[ 2 ] ) ))
        return [ false, "range of morphism and test factorization are not equal" ];
    end;
    
    if (@not IsEqualForObjects( cat, Range( test_factorization[ 1 ] ), Source( test_factorization[ 2 ] ) ))
        return [ false, "source and range of test factorization are not equal" ];
    end;
    
    return [ true ];
  end,
  return_type = "morphism",
  dual_operation = "UniversalMorphismFromImageWithGivenImageObject" ),

MorphismFromCoimageToImage = @rec(
  filter_list = [ "category", "morphism" ],
  input_arguments_names = [ "cat", "alpha" ],
  output_source_getter_string = "CoimageObject( cat, alpha )",
  output_source_getter_preconditions = [ [ "CoimageObject", 1 ] ],
  output_range_getter_string = "ImageObject( cat, alpha )",
  output_range_getter_preconditions = [ [ "ImageObject", 1 ] ],
  with_given_object_position = "both",
  dual_operation = "MorphismFromCoimageToImage",
  return_type = "morphism" ),

MorphismFromCoimageToImageWithGivenObjects = @rec(
  filter_list = [ "category", "object", "morphism", "object" ],
  input_arguments_names = [ "cat", "C", "alpha", "I" ],
  output_source_getter_string = "C",
  output_source_getter_preconditions = [ ],
  output_range_getter_string = "I",
  output_range_getter_preconditions = [ ],
  dual_operation = "MorphismFromCoimageToImageWithGivenObjects",
  dual_arguments_reversed = true,
  return_type = "morphism" ),

InverseOfMorphismFromCoimageToImage = @rec(
  filter_list = [ "category", "morphism" ],
  input_arguments_names = [ "cat", "alpha" ],
  output_source_getter_string = "ImageObject( cat, alpha )",
  output_source_getter_preconditions = [ [ "ImageObject", 1 ] ],
  output_range_getter_string = "CoimageObject( cat, alpha )",
  output_range_getter_preconditions = [ [ "CoimageObject", 1 ] ],
  with_given_object_position = "both",
  dual_operation = "InverseOfMorphismFromCoimageToImage",
  return_type = "morphism" ),

InverseOfMorphismFromCoimageToImageWithGivenObjects = @rec(
  filter_list = [ "category", "object", "morphism", "object" ],
  input_arguments_names = [ "cat", "I", "alpha", "C" ],
  output_source_getter_string = "I",
  output_source_getter_preconditions = [ ],
  output_range_getter_string = "C",
  output_range_getter_preconditions = [ ],
  dual_operation = "InverseOfMorphismFromCoimageToImageWithGivenObjects",
  dual_arguments_reversed = true,
  return_type = "morphism" ),

IsWellDefinedForMorphisms = @rec(
  filter_list = [ "category", "morphism" ],
  input_arguments_names = [ "cat", "alpha" ],
  dual_operation = "IsWellDefinedForMorphisms",
  
  redirect_function = function( cat, morphism )
    local source, range;
    
    source = Source( morphism );
    
    range = Range( morphism );
    
    if (!( IsWellDefinedForObjects( cat, source ) && IsWellDefinedForObjects( cat, range ) ))
      
      return [ true, false ];
      
      
    else
      
      return [ false ];
      
    end;
    
  end,
  
  return_type = "bool" ),

IsWellDefinedForMorphismsWithGivenSourceAndRange = @rec(
  filter_list = [ "category", "object", "morphism", "object" ],
  input_arguments_names = [ "cat", "source", "alpha", "range" ],
  return_type = "bool",
  dual_operation = "IsWellDefinedForMorphismsWithGivenSourceAndRange",
  dual_arguments_reversed = true,
),

IsWellDefinedForObjects = @rec(
  filter_list = [ "category", "object" ],
  dual_operation = "IsWellDefinedForObjects",
  return_type = "bool" ),

IsZeroForObjects = @rec(
  filter_list = [ "category", "object" ],
  return_type = "bool",
  dual_operation = "IsZeroForObjects",
),

IsMonomorphism = @rec(
  filter_list = [ "category", "morphism" ],
  return_type = "bool",
  dual_operation = "IsEpimorphism",
  is_reflected_by_faithful_functor = true,
),

IsEpimorphism = @rec(
  filter_list = [ "category", "morphism" ],
  return_type = "bool",
  dual_operation = "IsMonomorphism",
  is_reflected_by_faithful_functor = true,
),

IsIsomorphism = @rec(
  filter_list = [ "category", "morphism" ],
  dual_operation = "IsIsomorphism",
  return_type = "bool",
),

IsEndomorphism = @rec(
  filter_list = [ "category", "morphism" ],
  return_type = "bool",
  dual_operation = "IsEndomorphism",
),

IsAutomorphism = @rec(
  filter_list = [ "category", "morphism" ],
  return_type = "bool",
  dual_operation = "IsAutomorphism",
),

IsOne = @rec(
  filter_list = [ "category", "morphism" ],
  return_type = "bool",
  dual_operation = "IsOne",
  pre_function = function( cat, morphism )
    
    if (@not IsEqualForObjects( cat, Source( morphism ), Range( morphism ) ))
        
        return [ false, "source and range of the given morphism are not equal" ];
        
    end;
    
    return [ true ];
  end,
),

IsSplitMonomorphism = @rec(
  filter_list = [ "category", "morphism" ],
  return_type = "bool",
  dual_operation = "IsSplitEpimorphism",
),

IsSplitEpimorphism = @rec(
  filter_list = [ "category", "morphism" ],
  return_type = "bool",
  dual_operation = "IsSplitMonomorphism",
),

IsIdempotent = @rec(
   pre_function = function( cat, morphism )
    
    # do not use IsEndomorphism( morphism ) here because you don't know if
    # the user has given an own IsEndomorphism function
    if (@not IsEqualForObjects( cat, Source( morphism ), Range( morphism ) ))
      
      return [ false, "the given morphism has to be an endomorphism" ];
      
    end;
    
    return [ true ];
  end,
  filter_list = [ "category", "morphism" ],
  return_type = "bool",
  dual_operation = "IsIdempotent",
),

IsBijectiveObject = @rec(
  filter_list = [ "category", "object" ],
  return_type = "bool",
  dual_operation = "IsBijectiveObject",
),

IsProjective = @rec(
  filter_list = [ "category", "object" ],
  return_type = "bool",
  dual_operation = "IsInjective",
),

IsInjective = @rec(
  filter_list = [ "category", "object" ],
  return_type = "bool",
  dual_operation = "IsProjective",
),

IsTerminal = @rec(
  filter_list = [ "category", "object" ],
  return_type = "bool",
  dual_operation = "IsInitial",
),

IsInitial = @rec(
  filter_list = [ "category", "object" ],
  return_type = "bool",
  dual_operation = "IsTerminal",
),

IsEqualToIdentityMorphism = @rec(
  filter_list = [ "category", "morphism" ],
  return_type = "bool",
  dual_operation = "IsEqualToIdentityMorphism",
),

IsEqualToZeroMorphism = @rec(
  filter_list = [ "category", "morphism" ],
  return_type = "bool",
  dual_operation = "IsEqualToZeroMorphism",
),

CoastrictionToImage = @rec(
  filter_list = [ "category", "morphism" ],
  input_arguments_names = [ "cat", "alpha" ],
  output_source_getter_string = "Source( alpha )",
  output_source_getter_preconditions = [ ],
  with_given_object_position = "Range",
  return_type = "morphism",
  dual_operation = "AstrictionToCoimage" ),

CoastrictionToImageWithGivenImageObject = @rec(
  filter_list = [ "category", "morphism", "object" ],
  input_arguments_names = [ "cat", "alpha", "I" ],
  output_source_getter_string = "Source( alpha )",
  output_source_getter_preconditions = [ ],
  output_range_getter_string = "I",
  output_range_getter_preconditions = [ ],
  return_type = "morphism",
  dual_operation = "AstrictionToCoimageWithGivenCoimageObject" ),

UniversalMorphismFromImage = @rec(
  filter_list = [ "category", "morphism", "pair_of_morphisms" ],
  input_arguments_names = [ "cat", "alpha", "tau" ],
  output_range_getter_string = "Range( tau[1] )",
  output_range_getter_preconditions = [ ],
  with_given_object_position = "Source",
  dual_operation = "UniversalMorphismIntoCoimage",
  dual_preprocessor_func = function( cat, alpha, tau )
    return Triple( OppositeCategory( cat ), Opposite( alpha ), PairGAP( Opposite( tau[2] ), Opposite( tau[1] ) ) );
  end,
  pre_function = function( cat, morphism, test_factorization )
    
    if (@not IsEqualForObjects( cat, Source( morphism ), Source( test_factorization[ 1 ] ) ))
        return [ false, "source of morphism and test factorization are not equal" ];
    end;
    
    if (@not IsEqualForObjects( cat, Range( morphism ), Range( test_factorization[ 2 ] ) ))
        return [ false, "range of morphism and test factorization are not equal" ];
    end;
    
    if (@not IsEqualForObjects( cat, Range( test_factorization[ 1 ] ), Source( test_factorization[ 2 ] ) ))
        return [ false, "source and range of test factorization are not equal" ];
    end;
    
    return [ true ];
  end,
  return_type = "morphism" ),

UniversalMorphismFromImageWithGivenImageObject = @rec(
  filter_list = [ "category", "morphism", "pair_of_morphisms", "object" ],
  input_arguments_names = [ "cat", "alpha", "tau", "I" ],
  output_source_getter_string = "I",
  output_source_getter_preconditions = [ ],
  output_range_getter_string = "Range( tau[1] )",
  output_range_getter_preconditions = [ ],
  dual_operation = "UniversalMorphismIntoCoimageWithGivenCoimageObject",
  dual_preprocessor_func = function( cat, alpha, tau, I )
    return @NTupleGAP( 4, OppositeCategory( cat ), Opposite( alpha ), PairGAP( Opposite( tau[2] ), Opposite( tau[1] ) ), Opposite( I ) );
  end,
  pre_function = function( cat, morphism, test_factorization, image )
    
    if (@not IsEqualForObjects( cat, Source( morphism ), Source( test_factorization[ 1 ] ) ))
        return [ false, "source of morphism and test factorization are not equal" ];
    end;
    
    if (@not IsEqualForObjects( cat, Range( morphism ), Range( test_factorization[ 2 ] ) ))
        return [ false, "range of morphism and test factorization are not equal" ];
    end;
    
    if (@not IsEqualForObjects( cat, Range( test_factorization[ 1 ] ), Source( test_factorization[ 2 ] ) ))
        return [ false, "source and range of test factorization are not equal" ];
    end;
    
    return [ true ];
  end,
  return_type = "morphism" ),

KernelObjectFunctorial = @rec(
  filter_list = [ "category", "morphism", "morphism", "morphism" ],
  input_arguments_names = [ "cat", "alpha", "mu", "alphap" ],
  return_type = "morphism",
  output_source_getter_string = "KernelObject( cat, alpha )",
  output_source_getter_preconditions = [ [ "KernelObject", 1 ] ],
  output_range_getter_string = "KernelObject( cat, alphap )",
  output_range_getter_preconditions = [ [ "KernelObject", 1 ] ],
  with_given_object_position = "both",
  dual_operation = "CokernelObjectFunctorial",
  dual_arguments_reversed = true,
  compatible_with_congruence_of_morphisms = false,
),

KernelObjectFunctorialWithGivenKernelObjects = @rec(
  filter_list = [ "category", "object", "morphism", "morphism", "morphism", "object" ],
  input_arguments_names = [ "cat", "P", "alpha", "mu", "alphap", "Pp" ],
  output_source_getter_string = "P",
  output_source_getter_preconditions = [ ],
  output_range_getter_string = "Pp",
  output_range_getter_preconditions = [ ],
  return_type = "morphism",
  dual_operation = "CokernelObjectFunctorialWithGivenCokernelObjects",
  dual_arguments_reversed = true,
  compatible_with_congruence_of_morphisms = false,
),

CokernelObjectFunctorial = @rec(
  filter_list = [ "category", "morphism", "morphism", "morphism" ],
  input_arguments_names = [ "cat", "alpha", "mu", "alphap" ],
  return_type = "morphism",
  output_source_getter_string = "CokernelObject( cat, alpha )",
  output_source_getter_preconditions = [ [ "CokernelObject", 1 ] ],
  output_range_getter_string = "CokernelObject( cat, alphap )",
  output_range_getter_preconditions = [ [ "CokernelObject", 1 ] ],
  with_given_object_position = "both",
  dual_operation = "KernelObjectFunctorial",
  dual_arguments_reversed = true,
  compatible_with_congruence_of_morphisms = false,
),

CokernelObjectFunctorialWithGivenCokernelObjects = @rec(
  filter_list = [ "category", "object", "morphism", "morphism", "morphism", "object" ],
  input_arguments_names = [ "cat", "P", "alpha", "mu", "alphap", "Pp" ],
  output_source_getter_string = "P",
  output_source_getter_preconditions = [ ],
  output_range_getter_string = "Pp",
  output_range_getter_preconditions = [ ],
  return_type = "morphism",
  dual_operation = "KernelObjectFunctorialWithGivenKernelObjects",
  dual_arguments_reversed = true,
  compatible_with_congruence_of_morphisms = false,
),

TerminalObjectFunctorial = @rec(
  filter_list = [ "category" ],
  input_arguments_names = [ "cat" ],
  return_type = "morphism",
  output_source_getter_string = "TerminalObject( cat )",
  output_source_getter_preconditions = [ [ "TerminalObject", 1 ] ],
  output_range_getter_string = "TerminalObject( cat )",
  output_range_getter_preconditions = [ [ "TerminalObject", 1 ] ],
  with_given_object_position = "both",
  dual_operation = "InitialObjectFunctorial",
  dual_arguments_reversed = true,
),

TerminalObjectFunctorialWithGivenTerminalObjects = @rec(
  filter_list = [ "category", "object", "object" ],
  input_arguments_names = [ "cat", "P", "Pp" ],
  output_source_getter_string = "P",
  output_source_getter_preconditions = [ ],
  output_range_getter_string = "Pp",
  output_range_getter_preconditions = [ ],
  return_type = "morphism",
  dual_operation = "InitialObjectFunctorialWithGivenInitialObjects",
  dual_arguments_reversed = true,
),

InitialObjectFunctorial = @rec(
  filter_list = [ "category" ],
  input_arguments_names = [ "cat" ],
  return_type = "morphism",
  output_source_getter_string = "InitialObject( cat )",
  output_source_getter_preconditions = [ [ "InitialObject", 1 ] ],
  output_range_getter_string = "InitialObject( cat )",
  output_range_getter_preconditions = [ [ "InitialObject", 1 ] ],
  with_given_object_position = "both",
  dual_operation = "TerminalObjectFunctorial",
  dual_arguments_reversed = true,
),

InitialObjectFunctorialWithGivenInitialObjects = @rec(
  filter_list = [ "category", "object", "object" ],
  input_arguments_names = [ "cat", "P", "Pp" ],
  output_source_getter_string = "P",
  output_source_getter_preconditions = [ ],
  output_range_getter_string = "Pp",
  output_range_getter_preconditions = [ ],
  return_type = "morphism",
  dual_operation = "TerminalObjectFunctorialWithGivenTerminalObjects",
  dual_arguments_reversed = true,
),

DirectProductFunctorial = @rec(
  filter_list = [ "category", "list_of_objects", "list_of_morphisms", "list_of_objects" ],
  input_arguments_names = [ "cat", "objects", "L", "objectsp" ],
  return_type = "morphism",
  output_source_getter_string = "DirectProduct( cat, objects )",
  output_source_getter_preconditions = [ [ "DirectProduct", 1 ] ],
  output_range_getter_string = "DirectProduct( cat, objectsp )",
  output_range_getter_preconditions = [ [ "DirectProduct", 1 ] ],
  with_given_object_position = "both",
  dual_operation = "CoproductFunctorial",
  dual_arguments_reversed = true,
  compatible_with_congruence_of_morphisms = true,
),

DirectProductFunctorialWithGivenDirectProducts = @rec(
  filter_list = [ "category", "object", "list_of_objects", "list_of_morphisms", "list_of_objects", "object" ],
  input_arguments_names = [ "cat", "P", "objects", "L", "objectsp", "Pp" ],
  output_source_getter_string = "P",
  output_source_getter_preconditions = [ ],
  output_range_getter_string = "Pp",
  output_range_getter_preconditions = [ ],
  return_type = "morphism",
  dual_operation = "CoproductFunctorialWithGivenCoproducts",
  dual_arguments_reversed = true,
  compatible_with_congruence_of_morphisms = true,
),

CoproductFunctorial = @rec(
  filter_list = [ "category", "list_of_objects", "list_of_morphisms", "list_of_objects" ],
  input_arguments_names = [ "cat", "objects", "L", "objectsp" ],
  return_type = "morphism",
  output_source_getter_string = "Coproduct( cat, objects )",
  output_source_getter_preconditions = [ [ "Coproduct", 1 ] ],
  output_range_getter_string = "Coproduct( cat, objectsp )",
  output_range_getter_preconditions = [ [ "Coproduct", 1 ] ],
  with_given_object_position = "both",
  dual_operation = "DirectProductFunctorial",
  dual_arguments_reversed = true,
  compatible_with_congruence_of_morphisms = true,
),

CoproductFunctorialWithGivenCoproducts = @rec(
  filter_list = [ "category", "object", "list_of_objects", "list_of_morphisms", "list_of_objects", "object" ],
  input_arguments_names = [ "cat", "P", "objects", "L", "objectsp", "Pp" ],
  output_source_getter_string = "P",
  output_source_getter_preconditions = [ ],
  output_range_getter_string = "Pp",
  output_range_getter_preconditions = [ ],
  return_type = "morphism",
  dual_operation = "DirectProductFunctorialWithGivenDirectProducts",
  dual_arguments_reversed = true,
  compatible_with_congruence_of_morphisms = true,
),

DirectSumFunctorial = @rec(
  filter_list = [ "category", "list_of_objects", "list_of_morphisms", "list_of_objects" ],
  input_arguments_names = [ "cat", "objects", "L", "objectsp" ],
  return_type = "morphism",
  output_source_getter_string = "DirectSum( cat, objects )",
  output_source_getter_preconditions = [ [ "DirectSum", 1 ] ],
  output_range_getter_string = "DirectSum( cat, objectsp )",
  output_range_getter_preconditions = [ [ "DirectSum", 1 ] ],
  with_given_object_position = "both",
  dual_operation = "DirectSumFunctorial",
  dual_arguments_reversed = true,
  compatible_with_congruence_of_morphisms = true,
),

DirectSumFunctorialWithGivenDirectSums = @rec(
  filter_list = [ "category", "object", "list_of_objects", "list_of_morphisms", "list_of_objects", "object" ],
  input_arguments_names = [ "cat", "P", "objects", "L", "objectsp", "Pp" ],
  output_source_getter_string = "P",
  output_source_getter_preconditions = [ ],
  output_range_getter_string = "Pp",
  output_range_getter_preconditions = [ ],
  return_type = "morphism",
  dual_operation = "DirectSumFunctorialWithGivenDirectSums",
  dual_arguments_reversed = true,
  compatible_with_congruence_of_morphisms = true,
),

EqualizerFunctorial = @rec(
  filter_list = [ "category", "list_of_morphisms", "morphism", "list_of_morphisms" ],
  input_arguments_names = [ "cat", "morphisms", "mu", "morphismsp" ],
  return_type = "morphism",
  output_source_getter_string = "Equalizer( cat, Source( mu ), morphisms )",
  output_source_getter_preconditions = [ [ "Equalizer", 1 ] ],
  output_range_getter_string = "Equalizer( cat, Range( mu ), morphismsp )",
  output_range_getter_preconditions = [ [ "Equalizer", 1 ] ],
  with_given_object_position = "both",
  dual_operation = "CoequalizerFunctorial",
  dual_arguments_reversed = true,
  compatible_with_congruence_of_morphisms = false,
),

EqualizerFunctorialWithGivenEqualizers = @rec(
  filter_list = [ "category", "object", "list_of_morphisms", "morphism", "list_of_morphisms", "object" ],
  input_arguments_names = [ "cat", "P", "morphisms", "mu", "morphismsp", "Pp" ],
  output_source_getter_string = "P",
  output_source_getter_preconditions = [ ],
  output_range_getter_string = "Pp",
  output_range_getter_preconditions = [ ],
  return_type = "morphism",
  dual_operation = "CoequalizerFunctorialWithGivenCoequalizers",
  dual_arguments_reversed = true,
  compatible_with_congruence_of_morphisms = false,
),

CoequalizerFunctorial = @rec(
  filter_list = [ "category", "list_of_morphisms", "morphism", "list_of_morphisms" ],
  input_arguments_names = [ "cat", "morphisms", "mu", "morphismsp" ],
  return_type = "morphism",
  output_source_getter_string = "Coequalizer( cat, Source( mu ), morphisms )",
  output_source_getter_preconditions = [ [ "Coequalizer", 1 ] ],
  output_range_getter_string = "Coequalizer( cat, Range( mu ), morphismsp )",
  output_range_getter_preconditions = [ [ "Coequalizer", 1 ] ],
  with_given_object_position = "both",
  dual_operation = "EqualizerFunctorial",
  dual_arguments_reversed = true,
  compatible_with_congruence_of_morphisms = false,
),

CoequalizerFunctorialWithGivenCoequalizers = @rec(
  filter_list = [ "category", "object", "list_of_morphisms", "morphism", "list_of_morphisms", "object" ],
  input_arguments_names = [ "cat", "P", "morphisms", "mu", "morphismsp", "Pp" ],
  output_source_getter_string = "P",
  output_source_getter_preconditions = [ ],
  output_range_getter_string = "Pp",
  output_range_getter_preconditions = [ ],
  return_type = "morphism",
  dual_operation = "EqualizerFunctorialWithGivenEqualizers",
  dual_arguments_reversed = true,
  compatible_with_congruence_of_morphisms = false,
),

FiberProductFunctorial = @rec(
  filter_list = [ "category", "list_of_morphisms", "list_of_morphisms", "list_of_morphisms" ],
  input_arguments_names = [ "cat", "morphisms", "L", "morphismsp" ],
  return_type = "morphism",
  output_source_getter_string = "FiberProduct( cat, morphisms )",
  output_source_getter_preconditions = [ [ "FiberProduct", 1 ] ],
  output_range_getter_string = "FiberProduct( cat, morphismsp )",
  output_range_getter_preconditions = [ [ "FiberProduct", 1 ] ],
  with_given_object_position = "both",
  dual_operation = "PushoutFunctorial",
  dual_arguments_reversed = true,
  compatible_with_congruence_of_morphisms = false,
),

FiberProductFunctorialWithGivenFiberProducts = @rec(
  filter_list = [ "category", "object", "list_of_morphisms", "list_of_morphisms", "list_of_morphisms", "object" ],
  input_arguments_names = [ "cat", "P", "morphisms", "L", "morphismsp", "Pp" ],
  output_source_getter_string = "P",
  output_source_getter_preconditions = [ ],
  output_range_getter_string = "Pp",
  output_range_getter_preconditions = [ ],
  return_type = "morphism",
  dual_operation = "PushoutFunctorialWithGivenPushouts",
  dual_arguments_reversed = true,
  compatible_with_congruence_of_morphisms = false,
),

PushoutFunctorial = @rec(
  filter_list = [ "category", "list_of_morphisms", "list_of_morphisms", "list_of_morphisms" ],
  input_arguments_names = [ "cat", "morphisms", "L", "morphismsp" ],
  return_type = "morphism",
  output_source_getter_string = "Pushout( cat, morphisms )",
  output_source_getter_preconditions = [ [ "Pushout", 1 ] ],
  output_range_getter_string = "Pushout( cat, morphismsp )",
  output_range_getter_preconditions = [ [ "Pushout", 1 ] ],
  with_given_object_position = "both",
  dual_operation = "FiberProductFunctorial",
  dual_arguments_reversed = true,
  compatible_with_congruence_of_morphisms = false,
),

PushoutFunctorialWithGivenPushouts = @rec(
  filter_list = [ "category", "object", "list_of_morphisms", "list_of_morphisms", "list_of_morphisms", "object" ],
  input_arguments_names = [ "cat", "P", "morphisms", "L", "morphismsp", "Pp" ],
  output_source_getter_string = "P",
  output_source_getter_preconditions = [ ],
  output_range_getter_string = "Pp",
  output_range_getter_preconditions = [ ],
  return_type = "morphism",
  dual_operation = "FiberProductFunctorialWithGivenFiberProducts",
  dual_arguments_reversed = true,
  compatible_with_congruence_of_morphisms = false,
),

ImageObjectFunctorial = @rec(
  filter_list = [ "category", "morphism", "morphism", "morphism" ],
  input_arguments_names = [ "cat", "alpha", "nu", "alphap" ],
  return_type = "morphism",
  output_source_getter_string = "ImageObject( cat, alpha )",
  output_source_getter_preconditions = [ [ "ImageObject", 1 ] ],
  output_range_getter_string = "ImageObject( cat, alphap )",
  output_range_getter_preconditions = [ [ "ImageObject", 1 ] ],
  with_given_object_position = "both",
  dual_operation = "CoimageObjectFunctorial",
  dual_arguments_reversed = true,
),

ImageObjectFunctorialWithGivenImageObjects = @rec(
  filter_list = [ "category", "object", "morphism", "morphism", "morphism", "object" ],
  input_arguments_names = [ "cat", "I", "alpha", "nu", "alphap", "Ip" ],
  output_source_getter_string = "I",
  output_source_getter_preconditions = [ ],
  output_range_getter_string = "Ip",
  output_range_getter_preconditions = [ ],
  return_type = "morphism",
  dual_operation = "CoimageObjectFunctorialWithGivenCoimageObjects",
  dual_arguments_reversed = true,
),

CoimageObjectFunctorial = @rec(
  filter_list = [ "category", "morphism", "morphism", "morphism" ],
  input_arguments_names = [ "cat", "alpha", "mu", "alphap" ],
  return_type = "morphism",
  output_source_getter_string = "CoimageObject( cat, alpha )",
  output_source_getter_preconditions = [ [ "CoimageObject", 1 ] ],
  output_range_getter_string = "CoimageObject( cat, alphap )",
  output_range_getter_preconditions = [ [ "CoimageObject", 1 ] ],
  with_given_object_position = "both",
  dual_operation = "ImageObjectFunctorial",
  dual_arguments_reversed = true,
),

CoimageObjectFunctorialWithGivenCoimageObjects = @rec(
  filter_list = [ "category", "object", "morphism", "morphism", "morphism", "object" ],
  input_arguments_names = [ "cat", "C", "alpha", "mu", "alphap", "Cp" ],
  output_source_getter_string = "C",
  output_source_getter_preconditions = [ ],
  output_range_getter_string = "Cp",
  output_range_getter_preconditions = [ ],
  return_type = "morphism",
  dual_operation = "ImageObjectFunctorialWithGivenImageObjects",
  dual_arguments_reversed = true,
),

HorizontalPreCompose = @rec(
  filter_list = [ "category", "twocell", "twocell" ],
  dual_operation = "HorizontalPostCompose",
  
  pre_function = function( cat, twocell_1, twocell_2 )
    
    if (@not IsEqualForObjects( cat, Range( Source( twocell_1 ) ), Source( Source( twocell_2 ) ) ))
        return [ false, "2-cells are not horizontally composable" ];
    end;
    
    return [ true ];
  end,
  return_type = "twocell" ),

HorizontalPostCompose = @rec(
  filter_list = [ "category", "twocell", "twocell" ],
  dual_operation = "HorizontalPreCompose",
  
  pre_function = function( cat, twocell_2, twocell_1 )
    
    if (@not IsEqualForObjects( cat, Range( Source( twocell_1 ) ), Source( Source( twocell_2 ) ) ))
        return [ false, "2-cells are not horizontally composable" ];
    end;
    
    return [ true ];
  end,
  return_type = "twocell" ),

VerticalPreCompose = @rec(
  filter_list = [ "category", "twocell", "twocell" ],
  dual_operation = "VerticalPostCompose",
  
  pre_function = function( cat, twocell_1, twocell_2 )
    
    if (@not IsEqualForMorphisms( Range( twocell_1 ), Source( twocell_2 ) ))
        return [ false, "2-cells are not vertically composable" ];
    end;
    
    return [ true ];
  end,
  return_type = "twocell" ),

VerticalPostCompose = @rec(
  filter_list = [ "category", "twocell", "twocell" ],
  dual_operation = "VerticalPreCompose",
  
  pre_function = function( cat, twocell_2, twocell_1 )
    
    if (@not IsEqualForMorphisms( Range( twocell_1 ), Source( twocell_2 ) ))
        return [ false, "2-cells are not vertically composable" ];
    end;
    
    return [ true ];
  end,
  return_type = "twocell" ),

IdentityTwoCell = @rec(
  filter_list = [ "category", "morphism" ],
  dual_operation = "IdentityTwoCell",
  return_type = "twocell" ),

IsWellDefinedForTwoCells = @rec(
  filter_list = [ "category", "twocell" ],
  dual_operation = "IsWellDefinedForTwoCells",
  
  redirect_function = function( cat, twocell )
    
    if (!( IsWellDefined( Source( twocell ) ) && IsWellDefined( Range( twocell ) ) ))
      
      return [ true, false ];
      
    end;
    
    return [ false ];
    
  end,
  
  return_type = "bool" ),
  
JointPairwiseDifferencesOfMorphismsIntoDirectProduct = @rec(
  filter_list = [ "category", "object", "list_of_morphisms" ],
  input_arguments_names = [ "cat", "A", "D" ],
  output_source_getter_string = "A",
  output_source_getter_preconditions = [ ],
  return_type = "morphism",
  dual_operation = "JointPairwiseDifferencesOfMorphismsFromCoproduct",
),

IsomorphismFromFiberProductToEqualizerOfDirectProductDiagram = @rec(
  filter_list = [ "category", "list_of_morphisms" ],
  input_arguments_names = [ "cat", "D" ],
  return_type = "morphism",
  dual_operation = "IsomorphismFromCoequalizerOfCoproductDiagramToPushout",
),
  
IsomorphismFromEqualizerOfDirectProductDiagramToFiberProduct = @rec(
  filter_list = [ "category", "list_of_morphisms" ],
  input_arguments_names = [ "cat", "D" ],
  return_type = "morphism",
  dual_operation = "IsomorphismFromPushoutToCoequalizerOfCoproductDiagram",
),
  
IsomorphismFromPushoutToCoequalizerOfCoproductDiagram = @rec(
  filter_list = [ "category", "list_of_morphisms" ],
  input_arguments_names = [ "cat", "D" ],
  return_type = "morphism",
  dual_operation = "IsomorphismFromEqualizerOfDirectProductDiagramToFiberProduct",
),
  
IsomorphismFromCoequalizerOfCoproductDiagramToPushout = @rec(
  filter_list = [ "category", "list_of_morphisms" ],
  input_arguments_names = [ "cat", "D" ],
  return_type = "morphism",
  dual_operation = "IsomorphismFromFiberProductToEqualizerOfDirectProductDiagram",
),

IsomorphismFromImageObjectToKernelOfCokernel = @rec(
  filter_list = [ "category", "morphism" ],
  input_arguments_names = [ "cat", "alpha" ],
  return_type = "morphism",
  dual_operation = "IsomorphismFromCokernelOfKernelToCoimage",
),

IsomorphismFromKernelOfCokernelToImageObject = @rec(
  filter_list = [ "category", "morphism" ],
  input_arguments_names = [ "cat", "alpha" ],
  return_type = "morphism",
  dual_operation = "IsomorphismFromCoimageToCokernelOfKernel",
),

IsomorphismFromCoimageToCokernelOfKernel = @rec(
  filter_list = [ "category", "morphism" ],
  input_arguments_names = [ "cat", "alpha" ],
  return_type = "morphism",
  dual_operation = "IsomorphismFromKernelOfCokernelToImageObject",
),

IsomorphismFromCokernelOfKernelToCoimage = @rec(
  filter_list = [ "category", "morphism" ],
  input_arguments_names = [ "cat", "alpha" ],
  return_type = "morphism",
  dual_operation = "IsomorphismFromImageObjectToKernelOfCokernel",
),

IsomorphismFromDirectSumToDirectProduct = @rec(
  filter_list = [ "category", "list_of_objects" ],
  input_arguments_names = [ "cat", "D" ],
  return_type = "morphism",
  dual_operation = "IsomorphismFromCoproductToDirectSum",
),

IsomorphismFromDirectSumToCoproduct = @rec(
  filter_list = [ "category", "list_of_objects" ],
  input_arguments_names = [ "cat", "D" ],
  return_type = "morphism",
  dual_operation = "IsomorphismFromDirectProductToDirectSum",
),

IsomorphismFromDirectProductToDirectSum = @rec(
  filter_list = [ "category", "list_of_objects" ],
  input_arguments_names = [ "cat", "D" ],
  return_type = "morphism",
  dual_operation = "IsomorphismFromDirectSumToCoproduct",
),

IsomorphismFromCoproductToDirectSum = @rec(
  filter_list = [ "category", "list_of_objects" ],
  input_arguments_names = [ "cat", "D" ],
  return_type = "morphism",
  dual_operation = "IsomorphismFromDirectSumToDirectProduct",
),

JointPairwiseDifferencesOfMorphismsFromCoproduct = @rec(
  filter_list = [ "category", "object", "list_of_morphisms" ],
  input_arguments_names = [ "cat", "A", "D" ],
  output_range_getter_string = "A",
  output_range_getter_preconditions = [ ],
  return_type = "morphism",
  dual_operation = "JointPairwiseDifferencesOfMorphismsIntoDirectProduct",
),

SomeProjectiveObject = @rec(
  filter_list = [ "category", "object" ],
  return_type = "object",
  dual_operation = "SomeInjectiveObject",
  is_merely_set_theoretic = true ),

EpimorphismFromSomeProjectiveObject = @rec(
  filter_list = [ "category", "object" ],
  input_arguments_names = [ "cat", "A" ],
  output_range_getter_string = "A",
  output_range_getter_preconditions = [ ],
  with_given_object_position = "Source",
  return_type = "morphism",
  dual_operation = "MonomorphismIntoSomeInjectiveObject",
  is_merely_set_theoretic = true ),

EpimorphismFromSomeProjectiveObjectWithGivenSomeProjectiveObject = @rec(
  filter_list = [ "category", "object", "object" ],
  input_arguments_names = [ "cat", "A", "P" ],
  output_source_getter_string = "P",
  output_source_getter_preconditions = [ ],
  output_range_getter_string = "A",
  output_range_getter_preconditions = [ ],
  return_type = "morphism",
  dual_operation = "MonomorphismIntoSomeInjectiveObjectWithGivenSomeInjectiveObject",
  is_merely_set_theoretic = true ),

SomeInjectiveObject = @rec(
  filter_list = [ "category", "object" ],
  return_type = "object",
  dual_operation = "SomeProjectiveObject",
  is_merely_set_theoretic = true ),

MonomorphismIntoSomeInjectiveObject = @rec(
  filter_list = [ "category", "object" ],
  input_arguments_names = [ "cat", "A" ],
  output_source_getter_string = "A",
  output_source_getter_preconditions = [ ],
  with_given_object_position = "Range",
  return_type = "morphism",
  dual_operation = "EpimorphismFromSomeProjectiveObject",
  is_merely_set_theoretic = true ),

MonomorphismIntoSomeInjectiveObjectWithGivenSomeInjectiveObject = @rec(
  filter_list = [ "category", "object", "object" ],
  input_arguments_names = [ "cat", "A", "I" ],
  output_source_getter_string = "A",
  output_source_getter_preconditions = [ ],
  output_range_getter_string = "I",
  output_range_getter_preconditions = [ ],
  return_type = "morphism",
  dual_operation = "EpimorphismFromSomeProjectiveObjectWithGivenSomeProjectiveObject",
  is_merely_set_theoretic = true ),

ComponentOfMorphismIntoDirectSum = @rec(
  filter_list = [ "category", "morphism", "list_of_objects", "integer" ],
  input_arguments_names = [ "cat", "alpha", "S", "i" ],
  output_source_getter_string = "Source( alpha )",
  output_source_getter_preconditions = [ ],
  output_range_getter_string = "S[i]",
  output_range_getter_preconditions = [ ],
  return_type = "morphism",
  dual_operation = "ComponentOfMorphismFromDirectSum" ),

ComponentOfMorphismFromDirectSum = @rec(
  filter_list = [ "category", "morphism", "list_of_objects", "integer" ],
  input_arguments_names = [ "cat", "alpha", "S", "i" ],
  output_source_getter_string = "S[i]",
  output_source_getter_preconditions = [ ],
  output_range_getter_string = "Range( alpha )",
  output_range_getter_preconditions = [ ],
  return_type = "morphism",
  dual_operation = "ComponentOfMorphismIntoDirectSum" ),

MorphismBetweenDirectSums = @rec(
  filter_list = [ "category", "list_of_objects", "list_of_lists_of_morphisms", "list_of_objects" ],
  input_arguments_names = [ "cat", "source_diagram", "mat", "range_diagram" ],
  return_type = "morphism",
  output_source_getter_string = "DirectSum( cat, source_diagram )",
  output_source_getter_preconditions = [ [ "DirectSum", 1 ] ],
  output_range_getter_string = "DirectSum( cat, range_diagram )",
  output_range_getter_preconditions = [ [ "DirectSum", 1 ] ],
  with_given_object_position = "both",
  pre_function = function( cat, source_diagram, listlist, range_diagram )
    local i, j;
      
      if (Length( listlist ) != Length( source_diagram ))
          
          return [ false, "the number of rows does not match the length of the source diagram" ];
          
      end;
      
      for i in (1):(Length( listlist ))
          
          if (Length( listlist[i] ) != Length( range_diagram ))
              
              return [ false, @Concatenation( "the ", StringGAP(i), "-th row has not the same length as the range diagram" ) ];
              
          end;
          
          for j in (1):(Length( range_diagram ))
              
              if (@not IsEqualForObjects( cat, source_diagram[i], Source( listlist[i][j] ) ))
                  
                  return [ false, @Concatenation( "the sources of the morphisms in the ", StringGAP(i), "-th row must be equal to the ", StringGAP(i), "-th entry of the source diagram" ) ];
                  
              end;
              
              if (@not IsEqualForObjects( cat, range_diagram[j], Range( listlist[i][j] ) ))
                  
                  return [ false, @Concatenation( "the ranges of the morphisms in the ", StringGAP(j), "-th column must be equal to the ", StringGAP(j), "-th entry of the range diagram" ) ];
                  
              end;
              
          end;
          
      end;
      
      return [ true ];
      
  end,
  dual_operation = "MorphismBetweenDirectSums",
  dual_preprocessor_func = function( arg... )
      local list;
      list = CAP_INTERNAL_OPPOSITE_RECURSIVE( arg );
      
      return @NTupleGAP( 4, list[1], list[4], TransposedMatWithGivenDimensions( Length( list[2] ), Length( list[4] ), list[3] ), list[2] );
  end
),

MorphismBetweenDirectSumsWithGivenDirectSums = @rec(
  filter_list = [ "category", "object", "list_of_objects", "list_of_lists_of_morphisms", "list_of_objects", "object" ],
  input_arguments_names = [ "cat", "S", "source_diagram", "mat", "range_diagram", "T" ],
  output_source_getter_string = "S",
  output_source_getter_preconditions = [ ],
  output_range_getter_string = "T",
  output_range_getter_preconditions = [ ],
  return_type = "morphism",
  dual_operation = "MorphismBetweenDirectSumsWithGivenDirectSums",
  dual_preprocessor_func = function( arg... )
      local list;
      list = CAP_INTERNAL_OPPOSITE_RECURSIVE( arg );
      return @NTupleGAP( 6, list[1], list[6], list[5], TransposedMatWithGivenDimensions( Length( list[3] ), Length( list[5] ), list[4] ), list[3], list[2] );
  end
),

IsHomSetInhabited = @rec(
  filter_list = [ "category", "object", "object" ],
  return_type = "bool",
  dual_operation = "IsHomSetInhabited",
  dual_arguments_reversed = true,
),

HomomorphismStructureOnObjects = @rec(
  filter_list = [ "category", "object", "object" ],
  return_type = "object_in_range_category_of_homomorphism_structure",
  dual_operation = "HomomorphismStructureOnObjects",
  dual_arguments_reversed = true,
  dual_postprocessor_func = IdFunc
),

HomomorphismStructureOnMorphisms = @rec(
  filter_list = [ "category", "morphism", "morphism" ],
  input_arguments_names = [ "cat", "alpha", "beta" ],
  output_source_getter_string = "HomomorphismStructureOnObjects( cat, Range( alpha ), Source( beta ) )",
  output_source_getter_preconditions = [ [ "HomomorphismStructureOnObjects", 1 ] ],
  output_range_getter_string = "HomomorphismStructureOnObjects( cat, Source( alpha ), Range( beta ) )",
  output_range_getter_preconditions = [ [ "HomomorphismStructureOnObjects", 1 ] ],
  with_given_object_position = "both",
  return_type = "morphism_in_range_category_of_homomorphism_structure",
  dual_operation = "HomomorphismStructureOnMorphisms",
  dual_preprocessor_func = function( cat, alpha, beta )
    return Triple( OppositeCategory( cat ), Opposite( beta ), Opposite( alpha ) );
  end,
  dual_postprocessor_func = IdFunc,
),

HomomorphismStructureOnMorphismsWithGivenObjects = @rec(
  filter_list = [ "category", "object_in_range_category_of_homomorphism_structure", "morphism", "morphism", "object_in_range_category_of_homomorphism_structure" ],
  input_arguments_names = [ "cat", "source", "alpha", "beta", "range" ],
  output_source_getter_string = "source",
  output_range_getter_string = "range",
  return_type = "morphism_in_range_category_of_homomorphism_structure",
  dual_operation = "HomomorphismStructureOnMorphismsWithGivenObjects",
  dual_preprocessor_func = function( cat, source, alpha, beta, range )
    return @NTupleGAP( 5, OppositeCategory( cat ), source, Opposite( beta ), Opposite( alpha ), range );
  end,
  dual_postprocessor_func = IdFunc,
),

DistinguishedObjectOfHomomorphismStructure = @rec(
  filter_list = [ "category" ],
  return_type = "object_in_range_category_of_homomorphism_structure",
  dual_operation = "DistinguishedObjectOfHomomorphismStructure",
  dual_postprocessor_func = IdFunc ),

InterpretMorphismAsMorphismFromDistinguishedObjectToHomomorphismStructure = @rec(
  filter_list = [ "category", "morphism" ],
  input_arguments_names = [ "cat", "alpha" ],
  output_source_getter_string = "DistinguishedObjectOfHomomorphismStructure( cat )",
  output_source_getter_preconditions = [ [ "DistinguishedObjectOfHomomorphismStructure", 1 ] ],
  output_range_getter_string = "HomomorphismStructureOnObjects( cat, Source( alpha ), Range( alpha ) )",
  output_range_getter_preconditions = [ [ "HomomorphismStructureOnObjects", 1 ] ],
  with_given_object_position = "both",
  return_type = "morphism_in_range_category_of_homomorphism_structure",
  dual_operation = "InterpretMorphismAsMorphismFromDistinguishedObjectToHomomorphismStructure",
  dual_postprocessor_func = IdFunc
),

InterpretMorphismAsMorphismFromDistinguishedObjectToHomomorphismStructureWithGivenObjects = @rec(
  filter_list = [ "category", "object_in_range_category_of_homomorphism_structure", "morphism", "object_in_range_category_of_homomorphism_structure" ],
  input_arguments_names = [ "cat", "source", "alpha", "range" ],
  return_type = "morphism_in_range_category_of_homomorphism_structure",
  output_source_getter_string = "source",
  output_range_getter_string = "range",
  dual_operation = "InterpretMorphismAsMorphismFromDistinguishedObjectToHomomorphismStructureWithGivenObjects",
  dual_preprocessor_func = function( cat, distinguished_object, alpha, hom_source_range )
    return @NTupleGAP( 4, OppositeCategory( cat ), distinguished_object, Opposite( alpha ), hom_source_range );
  end,
  dual_postprocessor_func = IdFunc
),

InterpretMorphismFromDistinguishedObjectToHomomorphismStructureAsMorphism = @rec(
  filter_list = [ "category", "object", "object", "morphism_in_range_category_of_homomorphism_structure" ],
  input_arguments_names = [ "cat", "source", "range", "alpha" ],
  return_type = "morphism",
  output_source_getter_string = "source",
  output_range_getter_string = "range",
  dual_operation = "InterpretMorphismFromDistinguishedObjectToHomomorphismStructureAsMorphism",
  dual_preprocessor_func = function( cat, A, B, morphism )
    return @NTupleGAP( 4, OppositeCategory( cat ), Opposite( B ), Opposite( A ), morphism );
  end
),

SolveLinearSystemInAbCategory = @rec(
  filter_list = [ "category", "list_of_lists_of_morphisms", "list_of_lists_of_morphisms", "list_of_morphisms" ],
  return_type = "list_of_morphisms",
  pre_function = function( cat, left_coeffs, right_coeffs, rhs )
    
    if (@not Length( left_coeffs ) > 0)
        return [ false, "the list of left coefficients is empty" ];
    end;
    
    if (@not Length( left_coeffs ) == Length( right_coeffs ))
        return [ false, "the list of left coefficients and the list of right coefficients do not have the same length" ];
    end;
    
    if (@not Length( left_coeffs ) == Length( rhs ))
        return [ false, "the list of left coefficients does not have the same length as the right hand side" ];
    end;
    
    if (@not ForAll( @Concatenation( left_coeffs, right_coeffs ), x -> IsList( x ) && Length( x ) == Length( left_coeffs[1] ) ))
        return [ false, "the left coefficients and the right coefficients must be given by lists of lists of the same length containing morphisms in the current category" ];
    end;
    
    return [ true ];
    
  end,
  pre_function_full = function( cat, left_coeffs, right_coeffs, rhs )
    local nr_columns_left, nr_columns_right;
    
    if (@not ForAll( (1):(Length( left_coeffs )), i -> ForAll( left_coeffs[i], coeff -> IsEqualForObjects( cat, Source( coeff ), Source( rhs[i] ) ) != false ) ))
        return [ false, "the sources of the left coefficients must correspond to the sources of the right hand side" ];
    end;
    
    if (@not ForAll( (1):(Length( right_coeffs )), i -> ForAll( right_coeffs[i], coeff -> IsEqualForObjects( cat, Range( coeff ), Range( rhs[i] ) ) != false ) ))
        return [ false, "the ranges of the right coefficients must correspond to the ranges of the right hand side" ];
    end;
    
    nr_columns_left = Length( left_coeffs[1] );
    
    if (@not ForAll( (1):(nr_columns_left), j -> ForAll( left_coeffs, x -> IsEqualForObjects( cat, Range( x[j] ), Range( left_coeffs[1][j] ) ) != false ) ))
        return [ false, "all ranges in a column of the left coefficients must be equal" ];
    end;
    
    nr_columns_right = Length( right_coeffs[1] );
    
    if (@not ForAll( (1):(nr_columns_right), j -> ForAll( right_coeffs, x -> IsEqualForObjects( cat, Source( x[j] ), Source( right_coeffs[1][j] ) ) != false ) ))
        return [ false, "all sources in a column of the right coefficients must be equal" ];
    end;
    
    return [ true ];
    
  end,
),

SolveLinearSystemInAbCategoryOrFail = @rec(
  filter_list = [ "category", "list_of_lists_of_morphisms", "list_of_lists_of_morphisms", "list_of_morphisms" ],
  return_type = "list_of_morphisms_or_fail",
  pre_function = "SolveLinearSystemInAbCategory",
  pre_function_full = "SolveLinearSystemInAbCategory"
),

MereExistenceOfSolutionOfLinearSystemInAbCategory = @rec(
  filter_list = [ "category", "list_of_lists_of_morphisms", "list_of_lists_of_morphisms", "list_of_morphisms" ],
  return_type = "bool",
  pre_function = "SolveLinearSystemInAbCategory",
  pre_function_full = "SolveLinearSystemInAbCategory"
),

MorphismsOfExternalHom = @rec(
  filter_list = [ "category", "object", "object" ],
  return_type = "list_of_morphisms",
  dual_operation = "MorphismsOfExternalHom",
  dual_arguments_reversed = true
),

BasisOfExternalHom = @rec(
  filter_list = [ "category", "object", "object" ],
  return_type = "list_of_morphisms",
  dual_operation = "BasisOfExternalHom",
  dual_arguments_reversed = true
),

CoefficientsOfMorphism = @rec(
  filter_list = [ "category", "morphism" ],
  return_type = "list_of_elements_of_commutative_ring_of_linear_structure",
  dual_operation = "CoefficientsOfMorphism",
  dual_postprocessor_func = IdFunc
),

RandomObjectByInteger = @rec(
  filter_list = [ "category", "integer" ],
  input_arguments_names = [ "cat", "n" ],
  return_type = "object",
  dual_operation = "RandomObjectByInteger",
),

RandomMorphismByInteger = @rec(
  filter_list = [ "category", "integer" ],
  input_arguments_names = [ "cat", "n" ],
  return_type = "morphism",
  dual_operation = "RandomMorphismByInteger",
),

RandomMorphismWithFixedSourceByInteger = @rec(
  filter_list = [ "category", "object", "integer" ],
  input_arguments_names = [ "cat", "A", "n" ],
  output_source_getter_string = "A",
  output_source_getter_preconditions = [ ],
  return_type = "morphism",
  dual_operation = "RandomMorphismWithFixedRangeByInteger",
),

RandomMorphismWithFixedRangeByInteger = @rec(
  filter_list = [ "category", "object", "integer" ],
  input_arguments_names = [ "cat", "B", "n" ],
  output_range_getter_string = "B",
  output_range_getter_preconditions = [ ],
  return_type = "morphism",
  dual_operation = "RandomMorphismWithFixedSourceByInteger",
),

RandomMorphismWithFixedSourceAndRangeByInteger = @rec(
  filter_list = [ "category", "object", "object", "integer" ],
  input_arguments_names = [ "cat", "A", "B", "n" ],
  output_source_getter_string = "A",
  output_source_getter_preconditions = [ ],
  output_range_getter_string = "B",
  output_range_getter_preconditions = [ ],
  return_type = "morphism",
  dual_operation = "RandomMorphismWithFixedSourceAndRangeByInteger",
  dual_preprocessor_func = function( cat, A, B, n )
      return @NTupleGAP( 4, OppositeCategory( cat ), Opposite( B ), Opposite( A ), n );
  end
),

RandomObjectByList = @rec(
  filter_list = [ "category", "arbitrary_list" ],
  input_arguments_names = [ "cat", "L" ],
  return_type = "object"
),

RandomMorphismByList = @rec(
  filter_list = [ "category", "arbitrary_list" ],
  input_arguments_names = [ "cat", "L" ],
  return_type = "morphism"
),

RandomMorphismWithFixedSourceByList = @rec(
  filter_list = [ "category", "object", "arbitrary_list" ],
  input_arguments_names = [ "cat", "A", "L" ],
  output_source_getter_string = "A",
  output_source_getter_preconditions = [ ],
  return_type = "morphism",
),

RandomMorphismWithFixedRangeByList = @rec(
  filter_list = [ "category", "object", "arbitrary_list" ],
  input_arguments_names = [ "cat", "B", "L" ],
  output_range_getter_string = "B",
  output_range_getter_preconditions = [ ],
  return_type = "morphism"
),

RandomMorphismWithFixedSourceAndRangeByList = @rec(
  filter_list = [ "category", "object", "object", "arbitrary_list" ],
  input_arguments_names = [ "cat", "A", "B", "L" ],
  output_source_getter_string = "A",
  output_source_getter_preconditions = [ ],
  output_range_getter_string = "B",
  output_range_getter_preconditions = [ ],
  return_type = "morphism"
),

HomologyObject = @rec(
  filter_list = [ "category", "morphism", "morphism" ],
  input_arguments_names = [ "cat", "alpha", "beta" ],
  return_type = "object",
  pre_function = function( cat, alpha, beta )
      if (@not IsEqualForObjects( cat, Range( alpha ), Source( beta ) ))
            
            return [ false, "the range of the first morphism has to be equal to the source of the second morphism" ];
            
      end;
      
      return [ true ];
      
  end,
  dual_operation = "HomologyObject",
  dual_arguments_reversed = true
),

HomologyObjectFunctorialWithGivenHomologyObjects = @rec(
  filter_list = [ "category", "object", "5_tuple_of_morphisms", "object" ],
  input_arguments_names = [ "cat", "H_1", "L", "H_2" ],
  return_type = "morphism",
  pre_function = function( cat, H_1, L, H2 )
      local alpha, beta, epsilon, gamma, delta;
      
      alpha = L[1];
      
      beta = L[2];
      
      epsilon = L[3];
      
      gamma = L[4];
      
      delta = L[5];
      
      if (@not IsEqualForObjects( cat, Range( alpha ), Source( beta ) ))
            
            return [ false, "the range of the first morphism has to be equal to the source of the second morphism" ];
            
      end;
      
      if (@not IsEqualForObjects( cat, Range( gamma ), Source( delta ) ))
            
            return [ false, "the range of the fourth morphism has to be equal to the source of the fifth morphism" ];
            
      end;
      
      if (@not IsEqualForObjects( cat, Source( epsilon ), Source( beta ) ))
            
            return [ false, "the source of the third morphism has to be equal to the source of the second morphism" ];
            
      end;
      
      if (@not IsEqualForObjects( cat, Range( epsilon ), Range( gamma ) ))
            
            return [ false, "the range of the third morphism has to be equal to the range of the fourth morphism" ];
            
      end;
      
      return [ true ];
      
  end,
  dual_operation = "HomologyObjectFunctorialWithGivenHomologyObjects",
  dual_preprocessor_func = function( arg... )
      local list;
      list = CAP_INTERNAL_OPPOSITE_RECURSIVE( arg );
      return @NTupleGAP( 4, list[1], list[4], Reversed( list[3] ), list[2] );
  end
),

IsomorphismFromHomologyObjectToItsConstructionAsAnImageObject = @rec(
  filter_list = [ "category", "morphism", "morphism" ],
  input_arguments_names = [ "cat", "alpha", "beta" ],
  return_type = "morphism" ),

IsomorphismFromItsConstructionAsAnImageObjectToHomologyObject = @rec(
  filter_list = [ "category", "morphism", "morphism" ],
  input_arguments_names = [ "cat", "alpha", "beta" ],
  return_type = "morphism" ),
  
## SimplifyObject*
SimplifyObject = @rec(
  filter_list = [ "category", "object", "nonneg_integer_or_infinity" ],
  input_arguments_names = [ "cat", "A", "n" ],
  return_type = "object",
  dual_operation = "SimplifyObject",
  redirect_function = function( cat, A, n )
    
    if (n == 0)
        return [ true, A ];
    end;
    
    return [ false ];
    
  end,
  pre_function = function( cat, A, n )
    
    if (!( IsPosInt( n ) || IsInfinity( n ) ))
        return [ false, "the second argument must be a non-negative integer or infinity" ];
    end;
    
    return [ true ];
    
  end 
  ),

SimplifyObject_IsoFromInputObject = @rec(
  filter_list = [ "category", "object", "nonneg_integer_or_infinity" ],
  input_arguments_names = [ "cat", "A", "n" ],
  output_source_getter_string = "A",
  output_source_getter_preconditions = [ ],
  return_type = "morphism",
  dual_operation = "SimplifyObject_IsoToInputObject",
  redirect_function = function( cat, A, n )
    
    if (n == 0)
        return [ true, IdentityMorphism( A ) ];
    end;
    
    return [ false ];
    
  end,
  pre_function = "SimplifyObject"
  ),

SimplifyObject_IsoToInputObject = @rec(
  filter_list = [ "category", "object", "nonneg_integer_or_infinity" ],
  input_arguments_names = [ "cat", "A", "n" ],
  output_range_getter_string = "A",
  output_range_getter_preconditions = [ ],
  return_type = "morphism",
  dual_operation = "SimplifyObject_IsoFromInputObject",
  redirect_function = "SimplifyObject_IsoFromInputObject",
  pre_function = "SimplifyObject"
  ),

## SimplifyMorphism
SimplifyMorphism = @rec(
  filter_list = [ "category", "morphism", "nonneg_integer_or_infinity" ],
  input_arguments_names = [ "cat", "mor", "n" ],
  output_source_getter_string = "Source( mor )",
  output_source_getter_preconditions = [ ],
  output_range_getter_string = "Range( mor )",
  output_range_getter_preconditions = [ ],
  return_type = "morphism",
  dual_operation = "SimplifyMorphism",
  redirect_function = "SimplifyObject",
  pre_function = "SimplifyObject"
  ),

## SimplifySource*
SimplifySource = @rec(
  filter_list = [ "category", "morphism", "nonneg_integer_or_infinity" ],
  input_arguments_names = [ "cat", "mor", "n" ],
  output_range_getter_string = "Range( mor )",
  output_range_getter_preconditions = [ ],
  return_type = "morphism",
  dual_operation = "SimplifyRange",
  redirect_function = "SimplifyObject",
  pre_function = "SimplifyObject"
  ),

SimplifySource_IsoToInputObject = @rec(
  filter_list = [ "category", "morphism", "nonneg_integer_or_infinity" ],
  input_arguments_names = [ "cat", "mor", "n" ],
  output_range_getter_string = "Source( mor )",
  output_range_getter_preconditions = [ ],
  return_type = "morphism",
  dual_operation = "SimplifyRange_IsoFromInputObject",
  redirect_function = function( cat, alpha, n )
    
    if (n == 0)
        return [ true, IdentityMorphism( Source( alpha ) ) ];
    end;
    
    return [ false ];
    
  end,
  pre_function = "SimplifyObject"
  ),
  
SimplifySource_IsoFromInputObject = @rec(
  filter_list = [ "category", "morphism", "nonneg_integer_or_infinity" ],
  input_arguments_names = [ "cat", "mor", "n" ],
  output_source_getter_string = "Source( mor )",
  output_source_getter_preconditions = [ ],
  return_type = "morphism",
  dual_operation = "SimplifyRange_IsoToInputObject",
  redirect_function = "SimplifySource_IsoToInputObject",
  pre_function = "SimplifyObject"
  ),

## SimplifyRange*
SimplifyRange = @rec(
  filter_list = [ "category", "morphism", "nonneg_integer_or_infinity" ],
  input_arguments_names = [ "cat", "mor", "n" ],
  output_source_getter_string = "Source( mor )",
  output_source_getter_preconditions = [ ],
  return_type = "morphism",
  dual_operation = "SimplifySource",
  redirect_function = "SimplifyObject",
  pre_function = "SimplifyObject"
  ),

SimplifyRange_IsoToInputObject = @rec(
  filter_list = [ "category", "morphism", "nonneg_integer_or_infinity" ],
  input_arguments_names = [ "cat", "mor", "n" ],
  output_range_getter_string = "Range( mor )",
  output_range_getter_preconditions = [ ],
  return_type = "morphism",
  dual_operation = "SimplifySource_IsoFromInputObject",
  redirect_function = function( cat, alpha, n )
    
    if (n == 0)
        return [ true, IdentityMorphism( Range( alpha ) ) ];
    end;
    
    return [ false ];
    
  end,
  pre_function = "SimplifyObject"
  ),
  
SimplifyRange_IsoFromInputObject = @rec(
  filter_list = [ "category", "morphism", "nonneg_integer_or_infinity" ],
  input_arguments_names = [ "cat", "mor", "n" ],
  output_source_getter_string = "Range( mor )",
  output_source_getter_preconditions = [ ],
  return_type = "morphism",
  dual_operation = "SimplifySource_IsoToInputObject",
  redirect_function = "SimplifySource_IsoToInputObject",
  pre_function = "SimplifyObject"
  ),

## SimplifySourceAndRange*
SimplifySourceAndRange = @rec(
  filter_list = [ "category", "morphism", "nonneg_integer_or_infinity" ],
  input_arguments_names = [ "cat", "mor", "n" ],
  return_type = "morphism",
  dual_operation = "SimplifySourceAndRange",
  redirect_function = "SimplifyObject",
  pre_function = "SimplifyObject"
  ),

SimplifySourceAndRange_IsoToInputSource = @rec(
  filter_list = [ "category", "morphism", "nonneg_integer_or_infinity" ],
  input_arguments_names = [ "cat", "mor", "n" ],
  output_range_getter_string = "Source( mor )",
  output_range_getter_preconditions = [ ],
  return_type = "morphism",
  dual_operation = "SimplifySourceAndRange_IsoFromInputRange",
  redirect_function = "SimplifySource_IsoToInputObject",
  pre_function = "SimplifyObject"
  ),
  
SimplifySourceAndRange_IsoFromInputSource = @rec(
  filter_list = [ "category", "morphism", "nonneg_integer_or_infinity" ],
  input_arguments_names = [ "cat", "mor", "n" ],
  output_source_getter_string = "Source( mor )",
  output_source_getter_preconditions = [ ],
  return_type = "morphism",
  dual_operation = "SimplifySourceAndRange_IsoToInputRange",
  redirect_function = "SimplifySource_IsoToInputObject",
  pre_function = "SimplifyObject"
  ),

SimplifySourceAndRange_IsoToInputRange = @rec(
  filter_list = [ "category", "morphism", "nonneg_integer_or_infinity" ],
  input_arguments_names = [ "cat", "mor", "n" ],
  output_range_getter_string = "Range( mor )",
  output_range_getter_preconditions = [ ],
  return_type = "morphism",
  dual_operation = "SimplifySourceAndRange_IsoFromInputSource",
  redirect_function = "SimplifySource_IsoToInputObject",
  pre_function = "SimplifyObject"
  ),
  
SimplifySourceAndRange_IsoFromInputRange = @rec(
  filter_list = [ "category", "morphism", "nonneg_integer_or_infinity" ],
  input_arguments_names = [ "cat", "mor", "n" ],
  output_source_getter_string = "Range( mor )",
  output_source_getter_preconditions = [ ],
  return_type = "morphism",
  dual_operation = "SimplifySourceAndRange_IsoToInputSource",
  redirect_function = "SimplifySource_IsoToInputObject",
  pre_function = "SimplifyObject"
  ),

## SimplifyEndo*
SimplifyEndo = @rec(
  filter_list = [ "category", "morphism", "nonneg_integer_or_infinity" ],
  input_arguments_names = [ "cat", "mor", "n" ],
  return_type = "morphism",
  dual_operation = "SimplifyEndo",
  redirect_function = "SimplifyObject",
  pre_function = function( cat, endo, n )
    
    if (!( IsPosInt( n ) || IsInfinity( n ) ))
        return [ false, "the second argument must be a non-negative integer or infinity" ];
    end;
    
    if (@not IsEndomorphism( endo ))
        return [ false, "the first argument must be an endomorphism" ];
    end;
    
    return [ true ];
    
  end 
  ),

SimplifyEndo_IsoFromInputObject = @rec(
  filter_list = [ "category", "morphism", "nonneg_integer_or_infinity" ],
  input_arguments_names = [ "cat", "mor", "n" ],
  output_source_getter_string = "Source( mor )",
  output_source_getter_preconditions = [ ],
  return_type = "morphism",
  dual_operation = "SimplifyEndo_IsoToInputObject",
  redirect_function = "SimplifySource_IsoToInputObject",
  pre_function = "SimplifyEndo"
  ),

SimplifyEndo_IsoToInputObject = @rec(
  filter_list = [ "category", "morphism", "nonneg_integer_or_infinity" ],
  input_arguments_names = [ "cat", "mor", "n" ],
  output_range_getter_string = "Range( mor )",
  output_range_getter_preconditions = [ ],
  return_type = "morphism",
  dual_operation = "SimplifyEndo_IsoFromInputObject",
  redirect_function = "SimplifySource_IsoToInputObject",
  pre_function = "SimplifyEndo"
  ),

SomeReductionBySplitEpiSummand = @rec(
  filter_list = [ "category", "morphism" ],
  input_arguments_names = [ "cat", "alpha" ],
  return_type = "morphism",
  ),

SomeReductionBySplitEpiSummand_MorphismToInputRange = @rec(
  filter_list = [ "category", "morphism" ],
  input_arguments_names = [ "cat", "alpha" ],
  return_type = "morphism",
  ),

SomeReductionBySplitEpiSummand_MorphismFromInputRange = @rec(
  filter_list = [ "category", "morphism" ],
  input_arguments_names = [ "cat", "alpha" ],
  return_type = "morphism",
  ),

ProjectiveDimension = @rec(
  filter_list = [ "category", "object" ],
  return_type = "nonneg_integer_or_infinity",
  dual_operation = "InjectiveDimension",
  ),

InjectiveDimension = @rec(
  filter_list = [ "category", "object" ],
  return_type = "nonneg_integer_or_infinity",
  dual_operation = "ProjectiveDimension",
  ),

AdditiveGenerators = @rec(
  filter_list = [ "category" ],
  return_type = "list_of_objects",
  dual_operation = "AdditiveGenerators",
),

IndecomposableProjectiveObjects = @rec(
  filter_list = [ "category" ],
  return_type = "list_of_objects",
  dual_operation = "IndecomposableInjectiveObjects",
),

IndecomposableInjectiveObjects = @rec(
  filter_list = [ "category" ],
  return_type = "list_of_objects",
  dual_operation = "IndecomposableProjectiveObjects",
),

ProjectiveCoverObject = @rec(
  filter_list = [ "category", "object" ],
  return_type = "object",
  dual_operation = "InjectiveEnvelopeObject",
  is_merely_set_theoretic = true ),

EpimorphismFromProjectiveCoverObject = @rec(
  filter_list = [ "category", "object" ],
  input_arguments_names = [ "cat", "A" ],
  output_range_getter_string = "A",
  output_range_getter_preconditions = [ ],
  with_given_object_position = "Source",
  return_type = "morphism",
  dual_operation = "MonomorphismIntoInjectiveEnvelopeObject",
  is_merely_set_theoretic = true ),

EpimorphismFromProjectiveCoverObjectWithGivenProjectiveCoverObject = @rec(
  filter_list = [ "category", "object", "object" ],
  input_arguments_names = [ "cat", "A", "P" ],
  output_source_getter_string = "P",
  output_source_getter_preconditions = [ ],
  output_range_getter_string = "A",
  output_range_getter_preconditions = [ ],
  return_type = "morphism",
  dual_operation = "MonomorphismIntoInjectiveEnvelopeObjectWithGivenInjectiveEnvelopeObject",
  is_merely_set_theoretic = true ),

InjectiveEnvelopeObject = @rec(
  filter_list = [ "category", "object" ],
  return_type = "object",
  dual_operation = "ProjectiveCoverObject",
  is_merely_set_theoretic = true ),

MonomorphismIntoInjectiveEnvelopeObject = @rec(
  filter_list = [ "category", "object" ],
  input_arguments_names = [ "cat", "A" ],
  output_source_getter_string = "A",
  output_source_getter_preconditions = [ ],
  with_given_object_position = "Range",
  return_type = "morphism",
  dual_operation = "EpimorphismFromProjectiveCoverObject",
  is_merely_set_theoretic = true ),

MonomorphismIntoInjectiveEnvelopeObjectWithGivenInjectiveEnvelopeObject = @rec(
  filter_list = [ "category", "object", "object" ],
  input_arguments_names = [ "cat", "A", "I" ],
  output_source_getter_string = "A",
  output_source_getter_preconditions = [ ],
  output_range_getter_string = "I",
  output_range_getter_preconditions = [ ],
  return_type = "morphism",
  dual_operation = "EpimorphismFromProjectiveCoverObjectWithGivenProjectiveCoverObject",
  is_merely_set_theoretic = true ),

) );

@InstallValueConst( CAP_INTERNAL_METHOD_NAME_RECORD_LIMITS, [
@rec(
  object_specification = [ "varobject" ],
  morphism_specification = [  ],
  limit_object_name = "DirectProduct",
  colimit_object_name = "Coproduct",
),

@rec(
  object_specification = [ "varobject" ],
  morphism_specification = [  ],
  limit_object_name = "DirectSum",
  colimit_object_name = "DirectSum",
),

@rec(
  object_specification = [ "fixedobject", "varobject" ],
  morphism_specification = [ [ 2, "varmorphism", 1 ] ],
  limit_object_name = "FiberProduct",
  colimit_object_name = "Pushout",
),

@rec(
  object_specification = [ "fixedobject", "fixedobject" ],
  morphism_specification = [ [ 1, "varmorphism", 2 ] ],
  limit_object_name = "Equalizer",
  limit_projection_name = "EmbeddingOfEqualizer",
  colimit_object_name = "Coequalizer",
  colimit_injection_name = "ProjectionOntoCoequalizer",
),

@rec(
  object_specification = [ "fixedobject", "fixedobject" ],
  morphism_specification = [ [ 1, "fixedmorphism", 2 ], [ 1, "zeromorphism", 2 ] ],
  limit_object_name = "KernelObject",
  limit_projection_name = "KernelEmbedding",
  limit_universal_morphism_name = "KernelLift",
  colimit_object_name = "CokernelObject",
  colimit_injection_name = "CokernelProjection",
  colimit_universal_morphism_name = "CokernelColift",
),

@rec(
  object_specification = [ ],
  morphism_specification = [ ],
  limit_object_name = "TerminalObject",
  colimit_object_name = "InitialObject",
),

@rec(
  object_specification = [ ],
  morphism_specification = [ ],
  limit_object_name = "ZeroObject",
  colimit_object_name = "ZeroObject",
)

] );

@InstallGlobalFunction( "CAP_INTERNAL_ENHANCE_NAME_RECORD_LIMITS",
  function ( limits )
    local object_specification, morphism_specification, source_position, type, range_position, unbound_morphism_positions, number_of_unbound_morphisms, unbound_objects, morphism, unbound_object_positions, number_of_unbound_objects, targets, target_positions, nontarget_positions, number_of_targets, number_of_nontargets, diagram_filter_list, diagram_arguments_names, limit, position;
    
    for limit in limits
        object_specification = limit.object_specification;
        morphism_specification = limit.morphism_specification;
        
        #### check that given diagram is well-defined
        if (!(IsDenseList( object_specification ) && IsDenseList( morphism_specification )))
            Error( "the given diagram is not well-defined" );
        end;

        if (Length( object_specification ) == 0 && Length( morphism_specification ) > 0)
            Error( "the given diagram is not well-defined" );
        end;
        
        if (!(ForAll( object_specification, object -> object in [ "fixedobject", "varobject" ] )))
            Error( "the given diagram is not well-defined" );
        end;

        for morphism in morphism_specification
            if (!(IsList( morphism ) && Length( morphism ) == 3))
                Error( "the given diagram is not well-defined" );
            end;
            source_position = morphism[1];
            type = morphism[2];
            range_position = morphism[3];

            if (!(IsInt( source_position ) && source_position >= 1 && source_position <= Length( object_specification )))
                Error( "the given diagram is not well-defined" );
            end;

            if (!(IsInt( range_position ) && range_position >= 1 && range_position <= Length( object_specification )))
                Error( "the given diagram is not well-defined" );
            end;

            if (@not type in [ "fixedmorphism", "varmorphism", "zeromorphism" ])
                Error( "the given diagram is not well-defined" );
            end;

            if (type == "fixedmorphism" && (object_specification[source_position] == "varobject" || object_specification[range_position] == "varobject"))
                Error( "the given diagram is not well-defined" );
            end;
        end;

        #### get number of variables
        # morphisms
        unbound_morphism_positions = PositionsProperty( morphism_specification, x -> x[2] == "varmorphism" || x[2] == "fixedmorphism" );
        if (Length( unbound_morphism_positions ) == 0)
            number_of_unbound_morphisms = 0;
        elseif (Length( unbound_morphism_positions ) == 1 && morphism_specification[unbound_morphism_positions[1]][2] == "fixedmorphism")
            number_of_unbound_morphisms = 1;
        else
            number_of_unbound_morphisms = 2;
        end;

        limit.unbound_morphism_positions = unbound_morphism_positions;
        limit.number_of_unbound_morphisms = number_of_unbound_morphisms;

        if (@not ForAll( unbound_morphism_positions, i -> morphism_specification[i][2] == "fixedmorphism" || i == Length( unbound_morphism_positions ) ))
            Error( "diagrams of the given type are not supported" );
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
        if (Length( unbound_object_positions ) == 0)
            number_of_unbound_objects = 0;
        elseif (Length( unbound_object_positions ) == 1 && object_specification[unbound_object_positions[1]] == "fixedobject")
            number_of_unbound_objects = 1;
        else
            number_of_unbound_objects = 2;
        end;

        limit.unbound_object_positions = unbound_object_positions;
        limit.number_of_unbound_objects = number_of_unbound_objects;

        if (@not ForAll( unbound_object_positions, i -> object_specification[i] == "fixedobject" || i == Length( unbound_object_positions ) ))
            Error( "diagrams of the given type are not supported" );
        end;

        # (non-)targets
        targets = StructuralCopy( object_specification );
        for morphism in morphism_specification
            range_position = morphism[3];
            
            targets[range_position] = "";
        end;
        target_positions = PositionsProperty( targets, x -> x != "" );
        nontarget_positions = PositionsProperty( targets, x -> x == "" );
        if (Length( target_positions ) == 0)
            number_of_targets = 0;
        elseif (Length( target_positions ) == 1 && object_specification[target_positions[1]] == "fixedobject")
            number_of_targets = 1;
        else
            number_of_targets = 2;
        end;
        if (Length( nontarget_positions ) == 0)
            number_of_nontargets = 0;
        elseif (Length( nontarget_positions ) == 1 && object_specification[nontarget_positions[1]] == "fixedobject")
            number_of_nontargets = 1;
        else
            number_of_nontargets = 2;
        end;

        limit.target_positions = target_positions;
        limit.number_of_targets = number_of_targets;
        limit.nontarget_positions = nontarget_positions;
        limit.number_of_nontargets = number_of_nontargets;

        #### get filter list and names of input arguments of the diagram
        diagram_filter_list = [ ];
        diagram_arguments_names = [ ];
        if (number_of_unbound_objects == 1)
            Add( diagram_filter_list, "object" );
            Add( diagram_arguments_names, "X" );
        elseif (number_of_unbound_objects > 1)
            Add( diagram_filter_list, "list_of_objects" );
            Add( diagram_arguments_names, "objects" );
        end;
        if (number_of_unbound_morphisms == 1)
            Add( diagram_filter_list, "morphism" );
            Add( diagram_arguments_names, "alpha" );
        elseif (number_of_unbound_morphisms > 1)
            if (number_of_targets == 1)
                Add( diagram_filter_list, "object" );
                Add( diagram_arguments_names, "Y" );
            end;
            Add( diagram_filter_list, "list_of_morphisms" );
            Add( diagram_arguments_names, "morphisms" );
        end;

        limit.diagram_filter_list = diagram_filter_list;
        limit.diagram_arguments_names = diagram_arguments_names;
        
        #### set default projection/injection/universal morphism names
        if (number_of_targets > 0 && @not @IsBound( limit.limit_projection_name ))
            limit.limit_projection_name = @Concatenation( "ProjectionInFactorOf", limit.limit_object_name );
        end;
        if (@not @IsBound( limit.limit_universal_morphism_name ))
            limit.limit_universal_morphism_name = @Concatenation( "UniversalMorphismInto", limit.limit_object_name );
        end;

        if (number_of_targets > 0 && @not @IsBound( limit.colimit_injection_name ))
            limit.colimit_injection_name = @Concatenation( "InjectionOfCofactorOf", limit.colimit_object_name );
        end;
        if (@not @IsBound( limit.colimit_universal_morphism_name ))
            limit.colimit_universal_morphism_name = @Concatenation( "UniversalMorphismFrom", limit.colimit_object_name );
        end;
        
        if (number_of_targets > 0)
            limit.limit_projection_with_given_name = @Concatenation( limit.limit_projection_name, "WithGiven", limit.limit_object_name );
            limit.colimit_injection_with_given_name = @Concatenation( limit.colimit_injection_name, "WithGiven", limit.colimit_object_name );
        end;
        
        limit.limit_universal_morphism_with_given_name = @Concatenation( limit.limit_universal_morphism_name, "WithGiven", limit.limit_object_name );
        limit.colimit_universal_morphism_with_given_name = @Concatenation( limit.colimit_universal_morphism_name, "WithGiven", limit.colimit_object_name );
        
        limit.limit_functorial_name = @Concatenation( limit.limit_object_name, "Functorial" );
        limit.colimit_functorial_name = @Concatenation( limit.colimit_object_name, "Functorial" );

        limit.limit_functorial_with_given_name = @Concatenation( limit.limit_functorial_name, "WithGiven", limit.limit_object_name, "s" );
        limit.colimit_functorial_with_given_name = @Concatenation( limit.colimit_functorial_name, "WithGiven", limit.colimit_object_name, "s" );

        if (limit.number_of_nontargets == 1)
            limit.limit_morphism_to_sink_name = @Concatenation( "MorphismFrom", limit.limit_object_name, "ToSink" );
            limit.colimit_morphism_from_source_name = @Concatenation( "MorphismFromSourceTo", limit.colimit_object_name );
        end;

        if (Length( diagram_filter_list ) > 0)
            if (limit.number_of_targets == 1)
                limit.diagram_morphism_filter_list = [ "morphism" ];
                limit.diagram_morphism_arguments_names = [ "mu" ];
            else
                limit.diagram_morphism_filter_list = [ "list_of_morphisms" ];
                limit.diagram_morphism_arguments_names = [ "L" ];
            end;
        else
            limit.diagram_morphism_filter_list = [ ];
            limit.diagram_morphism_arguments_names = [ ];
        end;
        
        limit.functorial_source_diagram_arguments_names = limit.diagram_arguments_names;
        limit.functorial_range_diagram_arguments_names = List( limit.diagram_arguments_names, x -> @Concatenation( x, "p" ) );
        
    end;
end );

CAP_INTERNAL_ENHANCE_NAME_RECORD_LIMITS( CAP_INTERNAL_METHOD_NAME_RECORD_LIMITS );


@BindGlobal( "CAP_INTERNAL_IS_EQUAL_FOR_METHOD_RECORD_ENTRIES", @FunctionWithNamedArguments(
  [
    [ "subset_only", false ],
  ],
  function ( CAP_NAMED_ARGUMENTS, method_record, entry_name, generated_entry )
  local excluded_names, method_record_entry, name;
    
    excluded_names = [ "function_name", "pre_function", "pre_function_full", "post_function" ];
    
    if (@not @IsBound( method_record[entry_name] ))
        Display( @Concatenation( "WARNING: The method record is missing a component named \"", entry_name, "\" which is expected by the validator.\n" ) );
        return;
    end;
    
    method_record_entry = method_record[entry_name];
    
    for name in RecNames( method_record_entry )
        if (name in excluded_names)
            continue;
        end;
        if (@not @IsBound( generated_entry[name] ))
            if (subset_only)
                continue;
            else
                Display( @Concatenation( "WARNING: The entry \"", entry_name, "\" in the method record has a component named \"", name, "\" which is not expected by the validator.\n" ) );
            end;
        elseif (method_record_entry[name] != generated_entry[name])
            Display( @Concatenation( "WARNING: The entry \"", entry_name, "\" in the method record has a component named \"", name, "\" with value \"", StringGAP( method_record_entry[name] ), "\". The value expected by the validator is \"", StringGAP( generated_entry[name] ), "\".\n" ) );
        end;
    end;
    for name in RecNames( generated_entry )
        if (name in excluded_names)
            continue;
        end;
        if (@not @IsBound( method_record_entry[name] ))
            Display( @Concatenation( "WARNING: The entry \"", entry_name, "\" in the method record is missing a component named \"", name, "\" which is expected by the validator.\n" ) );
        end;
    end;
end ) );

@InstallGlobalFunction( CAP_INTERNAL_VALIDATE_LIMITS_IN_NAME_RECORD,
  function ( method_name_record, limits )
    local make_record_with_given, make_colimit, object_filter_list, object_input_arguments_names, projection_filter_list, projection_input_arguments_names, projection_range_getter_string, morphism_to_sink_filter_list, morphism_to_sink_input_arguments_names, morphism_to_sink_range_getter_string, universal_morphism_filter_list, universal_morphism_input_arguments_names, object_record, projection_record, morphism_to_sink_record, universal_morphism_record, functorial_record, functorial_with_given_record, limit;
    
    #### helper functions
    make_record_with_given = function ( record, object_name, coobject_name )
        record = StructuralCopy( record );
        
        record.function_name = @Concatenation( record.function_name, "WithGiven", object_name );
        Add( record.filter_list, "object" );
        Add( record.input_arguments_names, "P" );
        if (record.with_given_object_position == "Source")
            record.output_source_getter_string = "P";
            record.output_source_getter_preconditions = [ ];
        else
            record.output_range_getter_string = "P";
            record.output_range_getter_preconditions = [ ];
        end;
        record.dual_operation = @Concatenation( record.dual_operation, "WithGiven", coobject_name );
        @Unbind( record.with_given_object_position );

        return record;
    end;

    make_colimit = function ( limit, record )
      local orig_function_name, orig_output_source_getter_string, orig_output_source_getter_preconditions;
        
        record = StructuralCopy( record );
        
        orig_function_name = record.function_name;
        record.function_name = record.dual_operation;
        record.dual_operation = orig_function_name;
        
        if (@IsBound( record.functorial ))
            
            @Assert( 0, record.functorial == limit.limit_functorial_name );
            
            record.functorial = limit.colimit_functorial_name;
            
        end;
        
        if (@IsBound( record.with_given_object_position ))
            if (record.with_given_object_position == "Source")
                record.with_given_object_position = "Range";
            elseif (record.with_given_object_position == "Range")
                record.with_given_object_position = "Source";
            end;
        end;
        
        # reverse output getters, except if the input is reversed
        if (!(@IsBound( record.dual_arguments_reversed ) && record.dual_arguments_reversed))
            
            orig_output_source_getter_string = fail;
            
            if (@IsBound( record.output_source_getter_string ))
                
                orig_output_source_getter_string = record.output_source_getter_string;
                orig_output_source_getter_preconditions = record.output_source_getter_preconditions;
                
            end;
            
            if (@IsBound( record.output_range_getter_string ))
                
                record.output_source_getter_string = record.output_range_getter_string;
                record.output_source_getter_preconditions = record.output_range_getter_preconditions;
                
            else
                
                @Unbind( record.output_source_getter_string );
                @Unbind( record.output_source_getter_preconditions );
                
            end;
            
            if (orig_output_source_getter_string != fail)
                
                record.output_range_getter_string = orig_output_source_getter_string;
                record.output_range_getter_preconditions = orig_output_source_getter_preconditions;
                
            else
                
                @Unbind( record.output_range_getter_string );
                @Unbind( record.output_range_getter_preconditions );
                
            end;
            
        end;
        
        if (@IsBound( record.output_source_getter_string ))
            
            record.output_source_getter_string = ReplacedString( record.output_source_getter_string, "Source", "tmp" );
            record.output_source_getter_string = ReplacedString( record.output_source_getter_string, "Range", "Source" );
            record.output_source_getter_string = ReplacedString( record.output_source_getter_string, "tmp", "Range" );
            
            if (IsEmpty( record.output_source_getter_preconditions ))
                # do nothing
            elseif (record.output_source_getter_preconditions == [ [ limit.limit_object_name, 1 ] ])
                record.output_source_getter_string = ReplacedString( record.output_source_getter_string, limit.limit_object_name, limit.colimit_object_name );
                record.output_source_getter_preconditions = [ [ limit.colimit_object_name, 1 ] ];
            else
                Error( "this case is not supported yet" );
            end;
            
        end;
        
        if (@IsBound( record.output_range_getter_string ))
            
            record.output_range_getter_string = ReplacedString( record.output_range_getter_string, "Source", "tmp" );
            record.output_range_getter_string = ReplacedString( record.output_range_getter_string, "Range", "Source" );
            record.output_range_getter_string = ReplacedString( record.output_range_getter_string, "tmp", "Range" );
            
            if (IsEmpty( record.output_range_getter_preconditions ))
                # do nothing
            elseif (record.output_range_getter_preconditions == [ [ limit.limit_object_name, 1 ] ])
                record.output_range_getter_string = ReplacedString( record.output_range_getter_string, limit.limit_object_name, limit.colimit_object_name );
                record.output_range_getter_preconditions = [ [ limit.colimit_object_name, 1 ] ];
            else
                Error( "this case is not supported yet" );
            end;
            
        end;
        
        return record;
    end;

    for limit in limits
        
        #### get filter lists and io types
        object_filter_list = @Concatenation( [ "category" ], StructuralCopy( limit.diagram_filter_list ) );
        object_input_arguments_names = @Concatenation( [ "cat" ], limit.diagram_arguments_names );
        
        # only used if limit.number_of_targets > 0
        projection_filter_list = @Concatenation( [ "category" ], StructuralCopy( limit.diagram_filter_list ) );
        projection_input_arguments_names = @Concatenation( [ "cat" ], limit.diagram_arguments_names );
        if (limit.number_of_targets > 1)
            Add( projection_filter_list, "integer" );
            Add( projection_input_arguments_names, "k" );
        end;
        if (limit.target_positions == limit.unbound_object_positions)
            # range can be derived from the objects
            if (limit.number_of_targets == 1)
                projection_range_getter_string = "X";
            else
                projection_range_getter_string = "objects[k]";
            end;
        elseif (limit.target_positions == List( limit.unbound_morphism_positions, i -> limit.morphism_specification[i][1] ))
            # range can be derived from the morphisms as sources
            if (limit.number_of_unbound_morphisms == 1)
                projection_range_getter_string = "Source( alpha )";
            elseif (limit.number_of_targets == 1)
                projection_range_getter_string = "Y";
            else
                projection_range_getter_string = "Source( morphisms[k] )";
            end;
        elseif (limit.target_positions == List( limit.unbound_morphism_positions, i -> limit.morphism_specification[i][3] ))
            # range can be derived from the morphisms as ranges
            if (limit.number_of_unbound_morphisms == 1)
                projection_range_getter_string = "Range( alpha )";
            elseif (limit.number_of_targets == 1)
                projection_range_getter_string = "Y";
            else
                projection_range_getter_string = "Range( morphisms[k] )";
            end;
        else
            Error( "Warning: cannot express range getter" );
        end;

        # only used if limit.number_of_nontargets == 1
        morphism_to_sink_filter_list = @Concatenation( [ "category" ], StructuralCopy( limit.diagram_filter_list ) );
        morphism_to_sink_input_arguments_names = @Concatenation( [ "cat" ], limit.diagram_arguments_names );
        morphism_to_sink_range_getter_string = [ StructuralCopy( limit.diagram_arguments_names ), [ ] ];
        if (limit.number_of_unbound_morphisms == 1)
            morphism_to_sink_range_getter_string = "Range( alpha )";
        elseif (limit.number_of_unbound_morphisms > 1)
            morphism_to_sink_range_getter_string = "Range( morphisms[1] )";
        end;

        universal_morphism_filter_list = @Concatenation( [ "category" ], StructuralCopy( limit.diagram_filter_list ), [ "object" ] );
        universal_morphism_input_arguments_names = @Concatenation( [ "cat" ], limit.diagram_arguments_names, [ "T" ] );
        if (limit.number_of_targets == 1)
            Add( universal_morphism_filter_list, "morphism" );
            Add( universal_morphism_input_arguments_names, "tau" );
        elseif (limit.number_of_targets > 1)
            Add( universal_morphism_filter_list, "list_of_morphisms" );
            Add( universal_morphism_input_arguments_names, "tau" );
        end;

        
        #### get base records
        object_record =  @rec(
            function_name = limit.limit_object_name,
            filter_list = object_filter_list,
            input_arguments_names = object_input_arguments_names,
            return_type = "object",
            dual_operation = limit.colimit_object_name,
            functorial = limit.limit_functorial_name,
        );

        if (limit.number_of_targets > 0)
            projection_record = @rec(
                function_name = limit.limit_projection_name,
                filter_list = projection_filter_list,
                input_arguments_names = projection_input_arguments_names,
                return_type = "morphism",
                output_range_getter_string = projection_range_getter_string,
                output_range_getter_preconditions = [ ],
                with_given_object_position = "Source",
                dual_operation = limit.colimit_injection_name,
            );
        end;

        if (limit.number_of_nontargets == 1)
            morphism_to_sink_record = @rec(
                function_name = @Concatenation( "MorphismFrom", limit.limit_object_name, "ToSink" ),
                filter_list = morphism_to_sink_filter_list,
                input_arguments_names = morphism_to_sink_input_arguments_names,
                return_type = "morphism",
                output_range_getter_string = morphism_to_sink_range_getter_string,
                output_range_getter_preconditions = [ ],
                with_given_object_position = "Source",
                dual_operation = limit.colimit_morphism_from_source_name,
            );
        end;

        universal_morphism_record = @rec(
            function_name = limit.limit_universal_morphism_name,
            filter_list = universal_morphism_filter_list,
            input_arguments_names = universal_morphism_input_arguments_names,
            return_type = "morphism",
            output_source_getter_string = "T",
            output_source_getter_preconditions = [ ],
            with_given_object_position = "Range",
            dual_operation = limit.colimit_universal_morphism_name,
        );
        
        functorial_record = @rec(
            function_name = limit.limit_functorial_name,
            filter_list = @Concatenation( [ "category" ], limit.diagram_filter_list, limit.diagram_morphism_filter_list, limit.diagram_filter_list ),
            input_arguments_names = @Concatenation( [ "cat" ], limit.functorial_source_diagram_arguments_names, limit.diagram_morphism_arguments_names, limit.functorial_range_diagram_arguments_names ),
            return_type = "morphism",
            # object_name
            output_source_getter_string = ReplacedStringViaRecord(
                "object_name( arguments... )",
                @rec( object_name = limit.limit_object_name, arguments = @Concatenation( [ "cat" ], limit.functorial_source_diagram_arguments_names ) )
            ),
            output_source_getter_preconditions = [ [ limit.limit_object_name, 1 ] ],
            output_range_getter_string = ReplacedStringViaRecord(
                "object_name( arguments... )",
                @rec( object_name = limit.limit_object_name, arguments = @Concatenation( [ "cat" ], limit.functorial_range_diagram_arguments_names ) )
            ),
            output_range_getter_preconditions = [ [ limit.limit_object_name, 1 ] ],
            with_given_object_position = "both",
            dual_operation = limit.colimit_functorial_name,
            dual_arguments_reversed = true,
        );
        
        functorial_with_given_record = @rec(
            function_name = limit.limit_functorial_with_given_name,
            filter_list = @Concatenation( [ "category", "object" ], limit.diagram_filter_list, limit.diagram_morphism_filter_list, limit.diagram_filter_list, [ "object" ] ),
            input_arguments_names = @Concatenation( [ "cat", "P" ], limit.functorial_source_diagram_arguments_names, limit.diagram_morphism_arguments_names, limit.functorial_range_diagram_arguments_names, [ "Pp" ] ),
            return_type = "morphism",
            output_source_getter_string = "P",
            output_source_getter_preconditions = [ ],
            output_range_getter_string = "Pp",
            output_range_getter_preconditions = [ ],
            dual_operation = limit.colimit_functorial_with_given_name,
            dual_arguments_reversed = true,
        );
        
        if (limit.number_of_unbound_morphisms == 0)
            
            # The diagram has only objects as input -> all operations are compatible with the congruence of morphisms:
            # For the universal morphisms and functorials, this follows from the universal property.
            # All other operations are automatically compatible because they do not have morphisms as input.
            
            # if limit.number_of_targets == 0, the universal morphism has no test morphism as input anyway
            if (limit.number_of_targets > 0)
                
                universal_morphism_record.compatible_with_congruence_of_morphisms = true;
                functorial_record.compatible_with_congruence_of_morphisms = true;
                functorial_with_given_record.compatible_with_congruence_of_morphisms = true;
                
            end;
            
        else
            
            # The universal object might depend on the morphism datum.
            # Thus, the operations are in general not compatible with the congruence of morphisms.
            
            object_record.compatible_with_congruence_of_morphisms = false;
            projection_record.compatible_with_congruence_of_morphisms = false;
            morphism_to_sink_record.compatible_with_congruence_of_morphisms = false;
            universal_morphism_record.compatible_with_congruence_of_morphisms = false;
            functorial_record.compatible_with_congruence_of_morphisms = false;
            functorial_with_given_record.compatible_with_congruence_of_morphisms = false;
            
        end;
        
        #### validate limit records
        CAP_INTERNAL_IS_EQUAL_FOR_METHOD_RECORD_ENTRIES( method_name_record, limit.limit_object_name, object_record );
        
        if (limit.number_of_targets > 0)
            CAP_INTERNAL_IS_EQUAL_FOR_METHOD_RECORD_ENTRIES( method_name_record, limit.limit_projection_name, projection_record );
            CAP_INTERNAL_IS_EQUAL_FOR_METHOD_RECORD_ENTRIES( method_name_record, limit.limit_projection_with_given_name, make_record_with_given( projection_record, limit.limit_object_name, limit.colimit_object_name ) );
        end;
        
        if (limit.number_of_nontargets == 1)
            CAP_INTERNAL_IS_EQUAL_FOR_METHOD_RECORD_ENTRIES( method_name_record, limit.limit_morphism_to_sink_name, morphism_to_sink_record );
            CAP_INTERNAL_IS_EQUAL_FOR_METHOD_RECORD_ENTRIES( method_name_record, @Concatenation( limit.limit_morphism_to_sink_name, "WithGiven", limit.limit_object_name ), make_record_with_given( morphism_to_sink_record, limit.limit_object_name, limit.colimit_object_name ) );
        end;
        
        CAP_INTERNAL_IS_EQUAL_FOR_METHOD_RECORD_ENTRIES( method_name_record, limit.limit_universal_morphism_name, universal_morphism_record );
        CAP_INTERNAL_IS_EQUAL_FOR_METHOD_RECORD_ENTRIES( method_name_record, limit.limit_universal_morphism_with_given_name, make_record_with_given( universal_morphism_record, limit.limit_object_name, limit.colimit_object_name ) );
        
        # GAP has a limit of 6 arguments per operation -> operations which would have more than 6 arguments have to work around this
        if (Length( functorial_with_given_record.filter_list ) <= 6)
            
            CAP_INTERNAL_IS_EQUAL_FOR_METHOD_RECORD_ENTRIES( method_name_record, functorial_record.function_name, functorial_record );
            CAP_INTERNAL_IS_EQUAL_FOR_METHOD_RECORD_ENTRIES( method_name_record, functorial_with_given_record.function_name, functorial_with_given_record );
            
        end;
        
        #### validate colimit records
        CAP_INTERNAL_IS_EQUAL_FOR_METHOD_RECORD_ENTRIES( method_name_record, limit.colimit_object_name, make_colimit( limit, object_record ) );
        
        if (limit.number_of_targets > 0)
            CAP_INTERNAL_IS_EQUAL_FOR_METHOD_RECORD_ENTRIES( method_name_record, limit.colimit_injection_name, make_colimit( limit, projection_record ) );
            CAP_INTERNAL_IS_EQUAL_FOR_METHOD_RECORD_ENTRIES( method_name_record, limit.colimit_injection_with_given_name, make_record_with_given( make_colimit( limit, projection_record ), limit.colimit_object_name, limit.limit_object_name ) );
        end;
        
        if (limit.number_of_nontargets == 1)
            CAP_INTERNAL_IS_EQUAL_FOR_METHOD_RECORD_ENTRIES( method_name_record, limit.colimit_morphism_from_source_name, make_colimit( limit, morphism_to_sink_record ) );
            CAP_INTERNAL_IS_EQUAL_FOR_METHOD_RECORD_ENTRIES( method_name_record, @Concatenation( limit.colimit_morphism_from_source_name, "WithGiven", limit.colimit_object_name ), make_record_with_given( make_colimit( limit, morphism_to_sink_record ), limit.colimit_object_name, limit.limit_object_name ) );
        end;
        
        CAP_INTERNAL_IS_EQUAL_FOR_METHOD_RECORD_ENTRIES( method_name_record, limit.colimit_universal_morphism_name, make_colimit( limit, universal_morphism_record ) );
        CAP_INTERNAL_IS_EQUAL_FOR_METHOD_RECORD_ENTRIES( method_name_record, limit.colimit_universal_morphism_with_given_name, make_record_with_given( make_colimit( limit, universal_morphism_record ), limit.colimit_object_name, limit.limit_object_name ) );
        
        # GAP has a limit of 6 arguments per operation -> operations which would have more than 6 arguments have to work around this
        if (Length( functorial_with_given_record.filter_list ) <= 6)
            
            CAP_INTERNAL_IS_EQUAL_FOR_METHOD_RECORD_ENTRIES( method_name_record, functorial_record.dual_operation, make_colimit( limit, functorial_record ) );
            CAP_INTERNAL_IS_EQUAL_FOR_METHOD_RECORD_ENTRIES( method_name_record, functorial_with_given_record.dual_operation, make_colimit( limit, functorial_with_given_record ) );
            
        end;
        
    end;
    
end );

CAP_INTERNAL_VALIDATE_LIMITS_IN_NAME_RECORD( CAP_INTERNAL_METHOD_NAME_RECORD, CAP_INTERNAL_METHOD_NAME_RECORD_LIMITS );


@InstallValueConst( CAP_INTERNAL_METHOD_RECORD_REPLACEMENTS, @rec() );

@InstallGlobalFunction( CAP_INTERNAL_ADD_REPLACEMENTS_FOR_METHOD_RECORD,
  function( replacement_data )
    local current_name;

    for current_name in RecNames( replacement_data )
        if (@IsBound( CAP_INTERNAL_METHOD_RECORD_REPLACEMENTS[current_name] ))
            Error( @Concatenation( current_name, " already has a replacement" ) );
        end;
        CAP_INTERNAL_METHOD_RECORD_REPLACEMENTS[current_name] = replacement_data[current_name];
    end;
    
end );

@InstallValueConst( CAP_INTERNAL_OPPOSITE_PROPERTY_PAIRS_FOR_OBJECTS, [ ] );

@InstallValueConst( CAP_INTERNAL_OPPOSITE_PROPERTY_PAIRS_FOR_MORPHISMS, [ ] );

@InstallValueConst( CAP_INTERNAL_FIND_OPPOSITE_PROPERTY_PAIRS_IN_METHOD_NAME_RECORD,
  function( method_name_record )
    local recnames, current_recname, current_entry, current_rec, category_property_list, elem;
    
    recnames = RecNames( method_name_record );
    
    for current_recname in recnames
        
        current_rec = method_name_record[current_recname];
        
        if (!(current_rec.return_type == "bool" && Length( current_rec.filter_list ) == 2))
            continue;
        end;
        
        if (current_recname in [ "IsWellDefinedForObjects", "IsWellDefinedForMorphisms", "IsWellDefinedForTwoCells" ])
            continue;
        end;
        
        if (!(@IsBound( current_rec.dual_operation )) || current_rec.dual_operation == current_recname)
            
            current_entry = current_rec.installation_name;
            
        else
            
            current_entry = [ current_rec.installation_name, method_name_record[current_rec.dual_operation].installation_name ];
            current_entry = [ @Concatenation( current_entry[ 1 ], " vs ", current_entry[ 2 ] ), current_entry ];
            
        end;
        
        if (current_rec.filter_list[2] == "object")
            
            if (@not current_entry in CAP_INTERNAL_OPPOSITE_PROPERTY_PAIRS_FOR_OBJECTS)
                
                Add( CAP_INTERNAL_OPPOSITE_PROPERTY_PAIRS_FOR_OBJECTS, current_entry );
                
            end;
            
        elseif (current_rec.filter_list[2] == "morphism")
            
            if (@not current_entry in CAP_INTERNAL_OPPOSITE_PROPERTY_PAIRS_FOR_MORPHISMS)
                
                Add( CAP_INTERNAL_OPPOSITE_PROPERTY_PAIRS_FOR_MORPHISMS, current_entry );
                
            end;
            
        end;
        
    end;
    
end );

@BindGlobal( "CAP_INTERNAL_PREPARE_INHERITED_PRE_FUNCTION",
  function( func, drop_both )
    
    if (drop_both)
        
        return function( arg_list... )
            # drop second and last argument
            return CallFuncList( func, arg_list[@Concatenation( [ 1 ], (3):(Length( arg_list ) - 1) )] );
        end;
        
    else
        
        return function( arg_list... )
            # drop last argument
            return CallFuncList( func, arg_list[(1):(Length( arg_list ) - 1)] );
        end;
        
    end;
    
end );

@BindGlobal( "CAP_INTERNAL_CREATE_REDIRECTION",
  
  function( without_given_name, with_given_name, object_function_name, object_filter_list, object_arguments_positions )
    local object_function, with_given_name_function, is_attribute, attribute_tester;
    
    object_function = ValueGlobal( object_function_name );
    
    with_given_name_function = ValueGlobal( with_given_name );
    
    # Check if `object_function` is declared as an attribute and can actually be used as one in our context.
    # We do not print a warning if somethings is declared as an attribute but cannot be used as one in our context because this might actually happen, see for example `UniqueMorphism`.
    is_attribute = IsAttribute( object_function ) && Length( object_filter_list ) <= 2 && IsSpecializationOfFilter( IsAttributeStoringRep, CAP_INTERNAL_REPLACED_STRING_WITH_FILTER( Last( object_filter_list ) ) );
    
    if (@not is_attribute)
        
        return function( arg... )
          local category, without_given_weight, with_given_weight, object_args, cache, cache_value;
            
            category = arg[ 1 ];
            
            without_given_weight = CurrentOperationWeight( category.derivations_weight_list, without_given_name );
            with_given_weight = CurrentOperationWeight( category.derivations_weight_list, with_given_name );
            
            # If the WithGiven version is more expensive than the WithoutGiven version, redirection makes no sense and
            # might even lead to inifite loops if the WithGiven version is derived from the WithoutGiven version.
            if (with_given_weight > without_given_weight)
                
                return [ false ];
                
            end;
            
            object_args = arg[ object_arguments_positions ];
            
            cache = GET_METHOD_CACHE( category, object_function_name, Length( object_arguments_positions ) );
            
            cache_value = CallFuncList( CacheValue, [ cache, object_args ] );
            
            if (cache_value == [ ])
                
                return [ false ];
                
            end;
            
            return [ true, CallFuncList( with_given_name_function, @Concatenation( arg, [ cache_value[ 1 ] ] ) ) ];
            
        end;
        
    else
        
        if (@not Length( object_arguments_positions ) in [ 1, 2 ])
            
            Error( "we can only handle attributes of the category or of a single object/morphism/twocell" );
            
        end;
        
        attribute_tester = Tester( object_function );
        
        return function( arg... )
          local category, without_given_weight, with_given_weight, object_args, cache_value, cache;
            
            category = arg[ 1 ];
            
            without_given_weight = CurrentOperationWeight( category.derivations_weight_list, without_given_name );
            with_given_weight = CurrentOperationWeight( category.derivations_weight_list, with_given_name );
            
            # If the WithGiven version is more expensive than the WithoutGiven version, redirection makes no sense and
            # might even lead to inifite loops if the WithGiven version is derived from the WithoutGiven version.
            if (with_given_weight > without_given_weight)
                
                return [ false ];
                
            end;
            
            object_args = arg[ object_arguments_positions ];

            if (attribute_tester( object_args[ Length( object_args ) ] ))
                
                cache_value = [ object_function( object_args[ Length( object_args ) ] ) ];
                
            else
                
                cache = GET_METHOD_CACHE( category, object_function_name, Length( object_arguments_positions ) );
                
                cache_value = CallFuncList( CacheValue, [ cache, object_args ] );
                
                if (cache_value == [ ])
                    
                    return [ false ];
                    
                end;
                
            end;
            
            return [ true, CallFuncList( with_given_name_function, @Concatenation( arg, [ cache_value[ 1 ] ] ) ) ];
            
        end;
        
    end;
    
end );

@BindGlobal( "CAP_INTERNAL_CREATE_POST_FUNCTION",
  
  function( source_range_object, object_function_name, object_filter_list, object_arguments_positions )
    local object_getter, object_function, cache_key_length, is_attribute, setter_function;
    
    if (source_range_object == "Source")
        object_getter = Source;
    elseif (source_range_object == "Range")
        object_getter = Range;
    else
        Error( "the first argument of CAP_INTERNAL_CREATE_POST_FUNCTION must be 'Source' or 'Range'" );
    end;
    
    object_function = ValueGlobal( object_function_name );
    
    cache_key_length = Length( object_arguments_positions );
    
    # Check if `object_function` is declared as an attribute and can actually be used as one in our context.
    # We do not print a warning if somethings is declared as an attribute but cannot be used as one in our context because this might actually happen, see for example `UniqueMorphism`.
    is_attribute = IsAttribute( object_function ) && Length( object_filter_list ) <= 2 && IsSpecializationOfFilter( IsAttributeStoringRep, CAP_INTERNAL_REPLACED_STRING_WITH_FILTER( Last( object_filter_list ) ) );
    
    if (@not is_attribute)
    
        return function( arg... )
          local category, object_args, result, object;
            
            category = arg[ 1 ];
            
            object_args = arg[ object_arguments_positions ];
            
            result = arg[ Length( arg ) ];
            object = object_getter( result );
            
            SET_VALUE_OF_CATEGORY_CACHE( category, object_function_name, cache_key_length, object_args, object );
            
        end;
        
    else
        
        if (@not Length( object_arguments_positions ) in [ 1, 2 ])
            
            Error( "we can only handle attributes of the category or of a single object/morphism/twocell" );
            
        end;
        
        setter_function = Setter( object_function );
        
        return function( arg... )
          local category, object_args, result, object;
            
            category = arg[ 1 ];

            object_args = arg[ object_arguments_positions ];
            
            result = arg[ Length( arg ) ];
            object = object_getter( result );
            
            SET_VALUE_OF_CATEGORY_CACHE( category, object_function_name, cache_key_length, object_args, object );
            setter_function( object_args[ Length( object_args ) ], object );
            
        end;
        
    end;
    
end );

@BindGlobal( "CAP_INTERNAL_CREATE_NEW_FUNC_WITH_ONE_MORE_ARGUMENT_WITH_RETURN",
  
  function( func )
    
    return function( arg... ) return CallFuncList( func, arg[(2):(Length( arg ))] ); end;
    
end );

@BindGlobal( "CAP_INTERNAL_CREATE_NEW_FUNC_WITH_ONE_MORE_ARGUMENT_WITHOUT_RETURN",
  
  function( func )
    
    return function( arg... ) CallFuncList( func, arg[(2):(Length( arg ))] ); end;
    
end );

@InstallGlobalFunction( CAP_INTERNAL_ENHANCE_NAME_RECORD,
  function( record )
    local recnames, current_recname, current_rec, diff, number_of_arguments,
          without_given_name, with_given_prefix, with_given_names, with_given_name, without_given_rec, with_given_object_position, object_name,
          object_filter_list, with_given_object_filter, given_source_argument_name, given_range_argument_name, with_given_rec,
          collected_list, preconditions, can_always_compute_output_source_getter, can_always_compute_output_range_getter;
    
    recnames = RecNames( record );
    
    # loop before detecting With(out)Given pairs
    for current_recname in recnames
        
        current_rec = record[current_recname];
        
        diff = Difference( RecNames( current_rec ), CAP_INTERNAL_VALID_METHOD_NAME_RECORD_COMPONENTS );
        diff = Difference( diff, CAP_INTERNAL_LEGACY_METHOD_NAME_RECORD_COMPONENTS );
        
        if (@not IsEmpty( diff ))
            
            Print( "WARNING: The following method name record components are not known: " );
            Display( diff );
            
        end;
        
        # validity checks
        if (@not @IsBound( current_rec.return_type ))
            Error( "<current_rec> has no return_type" );
        end;
        
        if (current_rec.return_type in [ "other_object", "other_morphism" ])
            Error( "The return types \"other_object\" and \"other_morphism\" are not supported anymore. If you need those, please report this using the CAP_projects's issue tracker." );
        end;
        
        if (@not current_rec.return_type in CAP_INTERNAL_VALID_RETURN_TYPES)
            Error( "The return_type of <current_rec> does not appear in CAP_INTERNAL_VALID_RETURN_TYPES. Note that proper filters are not supported anymore." );
        end;
        
        if (current_rec.filter_list[1] != "category")
            
            Error( "The first entry of `filter_list` must be the string \"category\"." );
            
        end;
        
        if (ForAny( current_rec.filter_list, x -> x in [ "other_category", "other_object", "other_morphism", "other_twocell" ] ))
            Error( "The filters \"other_category\", \"other_object\", \"other_morphism\", and \"other_twocell\" are not supported anymore. If you need those, please report this using the CAP_projects's issue tracker." );
        end;
        
        if (@IsBound( current_rec.output_source_getter_preconditions ) && @not @IsBound( current_rec.output_source_getter_string ))
            
            Error( "output_source_getter_preconditions may only be set if output_source_getter_string is set" );
            
        end;
        
        if (@IsBound( current_rec.output_range_getter_preconditions ) && @not @IsBound( current_rec.output_range_getter_string ))
            
            Error( "output_range_getter_preconditions may only be set if output_range_getter_string is set" );
            
        end;
        
        current_rec.function_name = current_recname;
        
        if (@IsBound( current_rec.pre_function ) && IsString( current_rec.pre_function ))
            
            if (@IsBound( record[current_rec.pre_function] ) && @IsBound( record[current_rec.pre_function].pre_function ) && IsFunction( record[current_rec.pre_function].pre_function ))
                
                current_rec.pre_function = record[current_rec.pre_function].pre_function;
                
            else
                
                Error( "Could not find pre function for ", current_recname, ". ", current_rec.pre_function, " is not the name of an operation in the record, has no pre function, or has itself a string as pre function." );
                
            end;
            
        end;
        
        if (@IsBound( current_rec.pre_function_full ) && IsString( current_rec.pre_function_full ))
            
            if (@IsBound( record[current_rec.pre_function_full] ) && @IsBound( record[current_rec.pre_function_full].pre_function_full ) && IsFunction( record[current_rec.pre_function_full].pre_function_full ))
                
                current_rec.pre_function_full = record[current_rec.pre_function_full].pre_function_full;
                
            else
                
                Error( "Could not find full pre function for ", current_recname, ". ", current_rec.pre_function_full, " is not the name of an operation in the record, has no full pre function, or has itself a string as full pre function." );
                
            end;
            
        end;
        
        if (@IsBound( current_rec.redirect_function ) && IsString( current_rec.redirect_function ))
            
            if (@IsBound( record[current_rec.redirect_function] ) && @IsBound( record[current_rec.redirect_function].redirect_function ) && IsFunction( record[current_rec.redirect_function].redirect_function ))
                
                current_rec.redirect_function = record[current_rec.redirect_function].redirect_function;
                
            else
                
                Error( "Could not find redirect function for ", current_recname, ". ", current_rec.redirect_function, " is not the name of an operation in the record, has no redirect function, or has itself a string as redirect function." );
                
            end;
            
        end;
        
        number_of_arguments = Length( current_rec.filter_list );
        
        if (@IsBound( current_rec.pre_function ) && NumberArgumentsFunction( current_rec.pre_function ) >= 0 && NumberArgumentsFunction( current_rec.pre_function ) != number_of_arguments)
            Error( "the pre function of <current_rec> has the wrong number of arguments" );
        end;
        
        if (@IsBound( current_rec.pre_function_full ) && NumberArgumentsFunction( current_rec.pre_function_full ) >= 0 && NumberArgumentsFunction( current_rec.pre_function_full ) != number_of_arguments)
            Error( "the full pre function of <current_rec> has the wrong number of arguments" );
        end;
        
        if (@IsBound( current_rec.redirect_function ) && NumberArgumentsFunction( current_rec.redirect_function ) >= 0 && NumberArgumentsFunction( current_rec.redirect_function ) != number_of_arguments)
            Error( "the redirect function of <current_rec> has the wrong number of arguments" );
        end;
        
        if (@IsBound( current_rec.post_function ) && NumberArgumentsFunction( current_rec.post_function ) >= 0 && NumberArgumentsFunction( current_rec.post_function ) != number_of_arguments + 1)
            Error( "the post function of <current_rec> has the wrong number of arguments" );
        end;
        
        if (@IsBound( current_rec.dual_preprocessor_func ) && NumberArgumentsFunction( current_rec.dual_preprocessor_func ) >= 0 && NumberArgumentsFunction( current_rec.dual_preprocessor_func ) != number_of_arguments)
            Error( "the dual preprocessor function of ", current_recname, " has the wrong number of arguments" );
        end;
        
        if (@not ForAll( current_rec.filter_list, IsString ))
            Error( "Not all entries of filter_list of ", current_recname, " are strings. This is not supported anymore." );
        end;
        
        if (@not @IsBound( current_rec.install_convenience_without_category ))
            
            if (ForAny( [ "object", "morphism", "twocell", "list_of_objects", "list_of_morphisms", "list_of_twocells" ], filter -> filter in current_rec.filter_list ))
                
                current_rec.install_convenience_without_category = true;
                
            else
                
                current_rec.install_convenience_without_category = false;
                
            end;
            
        end;
        
        if (@IsBound( current_rec.universal_object_position ))
            
            Display( "WARNING: universal_object_position was renamed to with_given_object_position" );
            
            current_rec.with_given_object_position = current_rec.universal_object_position;
            
        end;
        
        if (@IsBound( current_rec.with_given_object_position ) && @not current_rec.with_given_object_position in [ "Source", "Range", "both" ])
            
            Error( "with_given_object_position must be one of the strings \"Source\", \"Range\", or \"both\", not ", current_rec.with_given_object_position );
            
        end;
        
        if (@not @IsBound( current_rec.is_with_given ))
            
            current_rec.is_with_given = false;
            
        end;
        
        if (@not @IsBound( current_rec.with_given_without_given_name_pair ))
            
            current_rec.with_given_without_given_name_pair = fail;
            
        end;
        
        if (@IsBound( current_rec.dual_operation ))
            
            # check that dual of the dual is the original operation
            
            if (@not @IsBound( record[current_rec.dual_operation] ))
                
                Error( "the dual operation must be added in the same call to `CAP_INTERNAL_ENHANCE_NAME_RECORD`" );
                
            end;
            
            if (@not @IsBound( record[current_rec.dual_operation].dual_operation ))
                
                Error( "the dual operation of ", current_recname, ", i.e. ", current_rec.dual_operation, ", has no dual operation"  );
                
            end;
            
            if (record[current_rec.dual_operation].dual_operation != current_recname)
                
                Error( "the dual operation of ", current_recname, ", i.e. ", current_rec.dual_operation, ", has the unexpected dual operation ", record[current_rec.dual_operation].dual_operation  );
                
            end;
            
        end;
        
        if (@not @IsBound( current_rec.dual_arguments_reversed ))
            
            current_rec.dual_arguments_reversed = false;
            
        end;
        
        if (Length( Filtered( [ "dual_preprocessor_func", "dual_arguments_reversed", "dual_with_given_objects_reversed" ],
                             name -> @IsBound( current_rec[name] ) && ( IsFunction( current_rec[name] ) || current_rec[name] == true )
                           ) ) >= 2)
            
            Error( "dual_preprocessor_func, dual_arguments_reversed == true and dual_with_given_objects_reversed == true are mutually exclusive" );
            
        end;
        
        if (@IsBound( current_rec.dual_preprocessor_func ))
            
            if (@IsBound( current_rec.dual_preprocessor_func_string ))
                
                Error( "dual_preprocessor_func and dual_preprocessor_func_string are mutually exclusive" );
                
            end;
            
            if (IsOperation( current_rec.dual_preprocessor_func ) || IsKernelFunction( current_rec.dual_preprocessor_func ))
                
                current_rec.dual_preprocessor_func_string = NameFunction( current_rec.dual_preprocessor_func );
                
            else
                
                current_rec.dual_preprocessor_func_string = StringGAP( current_rec.dual_preprocessor_func );
                
            end;
            
        end;
        
        if (@IsBound( current_rec.dual_postprocessor_func ))
            
            if (@IsBound( current_rec.dual_postprocessor_func_string ))
                
                Error( "dual_postprocessor_func and dual_postprocessor_func_string are mutually exclusive" );
                
            end;
            
            if (IsOperation( current_rec.dual_postprocessor_func ) || IsKernelFunction( current_rec.dual_postprocessor_func ))
                
                current_rec.dual_postprocessor_func_string = NameFunction( current_rec.dual_postprocessor_func );
                
            else
                
                current_rec.dual_postprocessor_func_string = StringGAP( current_rec.dual_postprocessor_func );
                
            end;
            
        end;
        
        if (IsOperation( ValueGlobal( current_recname ) ))
            
            current_rec.installation_name = current_recname;
            
        elseif (IsFunction( ValueGlobal( current_recname ) ))
            
            current_rec.installation_name = @Concatenation( current_recname, "Op" );
            
        else
            
            Error( "`ValueGlobal( current_recname )` is neither an operation nor a function" );
            
        end;
        
        if (@not @IsBound( current_rec.input_arguments_names ))
            
            current_rec.input_arguments_names = @Concatenation( [ "cat" ], List( (2):(Length( current_rec.filter_list )), i -> @Concatenation( "arg", StringGAP( i ) ) ) );
            
        end;
        
        if (current_rec.input_arguments_names[1] != "cat")
            
            Error( "the category argument must always be called \"cat\", please adjust the method record entry of ", current_recname );
            
        end;
        
        if (@not ForAll( current_rec.input_arguments_names, x -> IsString( x ) ))
            
            Error( "the entries of input_arguments_names must be strings, please adjust the method record entry of ", current_recname );
            
        end;
        
        if (@not IsDuplicateFreeList( current_rec.input_arguments_names ))
            
            Error( "input_arguments_names must be duplicate free, please adjust the method record entry of ", current_recname );
            
        end;
        
        if (ForAll( current_rec.filter_list, x -> x in [ "element_of_commutative_ring_of_linear_structure", "integer", "nonneg_integer_or_infinity", "category", "object", "object_in_range_category_of_homomorphism_structure", "list_of_objects" ] ))
            
            if (@not @IsBound( current_rec.compatible_with_congruence_of_morphisms ))
                
                current_rec.compatible_with_congruence_of_morphisms = true;
                
            end;
            
            if (current_rec.compatible_with_congruence_of_morphisms != true)
                
                Error( current_recname, " does not depend on morphisms but is still marked as not compatible with the congruence of morphisms" );
                
            end;
            
        end;
        
    end;
    
    # detect With(out)Given pairs
    for current_recname in recnames
        
        current_rec = record[current_recname];
        
        if (@IsBound( current_rec.with_given_object_position ))
            
            if (PositionSublist( current_recname, "WithGiven" ) != fail)
                
                Error( "WithGiven operations must NOT have the component with_given_object_position set, please adjust the method record entry of ", current_recname );
                
            end;
            
            without_given_name = current_recname;
            
            with_given_prefix = @Concatenation( without_given_name, "WithGiven" );
            
            with_given_names = Filtered( recnames, x -> StartsWith( x, with_given_prefix ) );
            
            if (Length( with_given_names ) != 1)
                
                Error( "Could not find unique WithGiven version for ", without_given_name );
                
            end;
            
            with_given_name = with_given_names[1];
            
            without_given_rec = record[without_given_name];
            
            with_given_object_position = without_given_rec.with_given_object_position;
            
            object_name = ReplacedString( with_given_name, with_given_prefix, "" );
            
            # generate output_source_getter_string resp. output_range_getter_string automatically if possible
            if (object_name in recnames)
                
                object_filter_list = record[object_name].filter_list;
                
                if (with_given_object_position == "Source")
                    
                    if (@not @IsBound( without_given_rec.output_source_getter_string ))
                        
                        without_given_rec.output_source_getter_string = @Concatenation( object_name, "( ", JoinStringsWithSeparator( without_given_rec.input_arguments_names[(1):(Length( object_filter_list ))], ", " ), " )" );
                        without_given_rec.output_source_getter_preconditions = [ [ object_name, 1 ] ];
                        
                    end;
                    
                end;
                
                if (with_given_object_position == "Range")
                    
                    if (@not @IsBound( without_given_rec.output_range_getter_string ))
                        
                        without_given_rec.output_range_getter_string = @Concatenation( object_name, "( ", JoinStringsWithSeparator( without_given_rec.input_arguments_names[(1):(Length( object_filter_list ))], ", " ), " )" );
                        without_given_rec.output_range_getter_preconditions = [ [ object_name, 1 ] ];
                        
                    end;
                    
                end;
                
            end;
            
            # plausibility checks for without_given_rec
            if (with_given_object_position in [ "Source", "both" ])
                
                if (@not @IsBound( without_given_rec.output_source_getter_string ))
                    
                    Error( "This is a WithoutGiven record, but output_source_getter_string is not set. This is not supported." );
                    
                end;
                
            end;
            
            if (with_given_object_position in [ "Range", "both" ])
                
                if (@not @IsBound( without_given_rec.output_range_getter_string ))
                    
                    Error( "This is a WithoutGiven record, but output_range_getter_string is not set. This is not supported." );
                    
                end;
                
            end;
            
            if (@not without_given_rec.return_type in [ "morphism", "morphism_in_range_category_of_homomorphism_structure" ])
                
                Error( "This is a WithoutGiven record, but return_type is neither \"morphism\" nor \"morphism_in_range_category_of_homomorphism_structure\". This is not supported." );
                
            end;
            
            # generate with_given_rec
            if (without_given_rec.return_type == "morphism")
                
                with_given_object_filter = "object";
                
            elseif (without_given_rec.return_type == "morphism_in_range_category_of_homomorphism_structure")
                
                with_given_object_filter = "object_in_range_category_of_homomorphism_structure";
                
            else
                
                Error( "this should never happen" );
                
            end;
            
            if (with_given_object_position == "Source")
                
                given_source_argument_name = Last( record[with_given_name].input_arguments_names );
                
            elseif (with_given_object_position == "Range")
                
                given_range_argument_name = Last( record[with_given_name].input_arguments_names );
                
            else
                
                given_source_argument_name = record[with_given_name].input_arguments_names[2];
                given_range_argument_name = Last( record[with_given_name].input_arguments_names );
                
            end;
            
            with_given_rec = @rec(
                return_type = without_given_rec.return_type,
            );
            
            if (with_given_object_position == "Source")
                
                with_given_rec.filter_list = @Concatenation( without_given_rec.filter_list, [ with_given_object_filter ] );
                with_given_rec.input_arguments_names = @Concatenation( without_given_rec.input_arguments_names, [ given_source_argument_name ] );
                with_given_rec.output_source_getter_string = given_source_argument_name;
                
                if (@IsBound( without_given_rec.output_range_getter_string ))
                    
                    with_given_rec.output_range_getter_string = without_given_rec.output_range_getter_string;
                    
                end;
                
                if (@IsBound( without_given_rec.output_range_getter_preconditions ))
                    
                    with_given_rec.output_range_getter_preconditions = without_given_rec.output_range_getter_preconditions;
                    
                end;
                
            elseif (with_given_object_position == "Range")
                
                with_given_rec.filter_list = @Concatenation( without_given_rec.filter_list, [ with_given_object_filter ] );
                with_given_rec.input_arguments_names = @Concatenation( without_given_rec.input_arguments_names, [ given_range_argument_name ] );
                with_given_rec.output_range_getter_string = given_range_argument_name;
                
                if (@IsBound( without_given_rec.output_source_getter_string ))
                    
                    with_given_rec.output_source_getter_string = without_given_rec.output_source_getter_string;
                    
                end;
                
                if (@IsBound( without_given_rec.output_source_getter_preconditions ))
                    
                    with_given_rec.output_source_getter_preconditions = without_given_rec.output_source_getter_preconditions;
                    
                end;
                
            elseif (with_given_object_position == "both")
                
                with_given_rec.filter_list = @Concatenation(
                    [ without_given_rec.filter_list[1] ],
                    [ with_given_object_filter ],
                    without_given_rec.filter_list[(2):(Length( without_given_rec.filter_list ))],
                    [ with_given_object_filter ]
                );
                with_given_rec.input_arguments_names = @Concatenation(
                    [ without_given_rec.input_arguments_names[1] ],
                    [ given_source_argument_name ],
                    without_given_rec.input_arguments_names[(2):(Length( without_given_rec.input_arguments_names ))],
                    [ given_range_argument_name ]
                );
                
                with_given_rec.output_source_getter_string = given_source_argument_name;
                with_given_rec.output_range_getter_string = given_range_argument_name;
                
            else
                
                Error( "this should never happen" );
                
            end;
            
            CAP_INTERNAL_IS_EQUAL_FOR_METHOD_RECORD_ENTRIES( record, with_given_name, with_given_rec; subset_only = true );
            
            # now enhance the actual with_given_rec
            with_given_rec = record[with_given_name];
            
            if (@IsBound( without_given_rec.pre_function ) && @not @IsBound( with_given_rec.pre_function ))
                with_given_rec.pre_function = CAP_INTERNAL_PREPARE_INHERITED_PRE_FUNCTION( record[without_given_name].pre_function, with_given_object_position == "both" );
            end;
            
            if (@IsBound( without_given_rec.pre_function_full ) && @not @IsBound( with_given_rec.pre_function_full ))
                with_given_rec.pre_function_full = CAP_INTERNAL_PREPARE_INHERITED_PRE_FUNCTION( record[without_given_name].pre_function_full, with_given_object_position == "both" );
            end;
            
            with_given_rec.is_with_given = true;
            with_given_rec.with_given_without_given_name_pair = [ without_given_name, with_given_name ];
            without_given_rec.with_given_without_given_name_pair = [ without_given_name, with_given_name ];
            
            if (object_name in recnames)
                
                if (with_given_object_position == "both")
                    
                    Error( "with_given_object_position is \"both\", but the WithGiven name suggests that only a single object of name ", object_name, " is given. This is not supported." );
                    
                end;
                
                with_given_rec.with_given_object_name = object_name;
                
                object_filter_list = record[object_name].filter_list;
                
                if (with_given_object_position == "Source")
                    
                    if (@not StartsWith( without_given_rec.output_source_getter_string, object_name ))
                        
                        Error( "the output_source_getter_string of the WithoutGiven record does not call the detected object ", object_name );
                        
                    end;
                    
                end;
                
                if (with_given_object_position == "Range")
                    
                    if (@not StartsWith( without_given_rec.output_range_getter_string, object_name ))
                        
                        Error( "the output_range_getter_string of the WithoutGiven record does not call the detected object ", object_name );
                        
                    end;
                    
                end;
                
                if (@not StartsWith( without_given_rec.filter_list, object_filter_list ))
                    
                    Error( "the object arguments must be the first arguments of the without given method, but the corresponding filters do not match" );
                    
                end;
                
                if (@not @IsBound( without_given_rec.redirect_function ))
                    
                    if (Length( record[without_given_name].filter_list ) + 1 != Length( record[with_given_name].filter_list ))
                        
                        Display( @Concatenation(
                            "WARNING: You seem to be relying on automatically installed redirect functions. ",
                            "For this, the with given method must have exactly one additional argument compared to the without given method. ",
                            "This is not the case, so no automatic redirect function will be installed. ",
                            "Install a custom redirect function to prevent this warning."
                        ) );
                        
                    else
                        
                        without_given_rec.redirect_function = CAP_INTERNAL_CREATE_REDIRECTION( without_given_name, with_given_name, object_name, object_filter_list, (1):(Length( object_filter_list )) );
                        
                    end;
                    
                end;
                
                if (@not @IsBound( without_given_rec.post_function ))
                    
                    without_given_rec.post_function = CAP_INTERNAL_CREATE_POST_FUNCTION( with_given_object_position, object_name, object_filter_list, (1):(Length( object_filter_list )) );
                    
                end;
                
            end;
            
        end;
        
    end;
    
    # loop after detecting With(out)Given pairs
    for current_recname in recnames
        
        current_rec = record[current_recname];
        
        if (@IsBound( current_rec.dual_with_given_objects_reversed ) && current_rec.dual_with_given_objects_reversed)
            
            if (@not current_rec.is_with_given)
                
                Error( "dual_with_given_objects_reversed may only be set for with given records" );
                
            end;
            
            without_given_rec = record[current_rec.with_given_without_given_name_pair[1]];
            
            with_given_object_position = without_given_rec.with_given_object_position;
            
            if (with_given_object_position != "both")
                
                Error( "dual_with_given_objects_reversed may only be set if both source and range are given" );
                
            end;
            
        end;
        
        # set `output_source_getter` and `output_range_getter`
        if (@IsBound( current_rec.output_source_getter_string ))
            
            current_rec.output_source_getter = EvalString( ReplacedStringViaRecord(
                "( arguments... ) -> getter",
                @rec(
                    arguments = current_rec.input_arguments_names,
                    getter = current_rec.output_source_getter_string,
                )
            ) );
            
            if (current_rec.output_source_getter_string in current_rec.input_arguments_names)
                
                if (@not @IsBound( current_rec.output_source_getter_preconditions ))
                    
                    current_rec.output_source_getter_preconditions = [ ];
                    
                end;
                
                if (@not IsEmpty( current_rec.output_source_getter_preconditions ))
                    
                    Error( "<current_rec.output_source_getter_preconditions> does not match the automatically detected value" );
                    
                end;
                
            end;
            
            #= comment for Julia
            if (@IsBound( current_rec.output_source_getter_preconditions ))
                
                if (ForAny( current_rec.output_source_getter_preconditions, x -> IsList( x ) && Length( x ) == 3 ))
                    
                    Print( "WARNING: preconditions in other categories are not yet supported, please report this using the CAP_projects's issue tracker.\n" );
                    
                end;
                
                if (ForAny( current_rec.output_source_getter_preconditions, x -> !(IsList( x )) || Length( x ) != 2 || !(IsString( x[1] )) || @not IsInt( x[2] ) ))
                    
                    Error( "Preconditions must be pairs of names of CAP operations and integers." );
                    
                end;
                
                collected_list = CAP_INTERNAL_FIND_APPEARANCE_OF_SYMBOL_IN_FUNCTION(
                        current_rec.output_source_getter,
                        @Concatenation( recnames, RecNames( CAP_INTERNAL_METHOD_NAME_RECORD ) ),
                        2,
                        CAP_INTERNAL_METHOD_RECORD_REPLACEMENTS,
                        @rec( )
                );
                
                @Assert( 0, ForAll( collected_list, x -> Length( x ) == 3 && x[3] == fail ) );
                
                preconditions = SetGAP( List( collected_list, x -> [ x[1], x[2] ] ) );
                
                if (SetGAP( current_rec.output_source_getter_preconditions ) != preconditions)
                    
                    Error( "output_source_getter_preconditions of ", current_recname, " is ", current_rec.output_source_getter_preconditions, " but expected ", preconditions );
                    
                end;
                
            end;
            # =#
            
            if (@IsBound( current_rec.output_source_getter_preconditions ))
                
                can_always_compute_output_source_getter = IsEmpty( current_rec.output_source_getter_preconditions );
                
                if (@IsBound( current_rec.can_always_compute_output_source_getter ))
                    
                    if (current_rec.can_always_compute_output_source_getter != can_always_compute_output_source_getter)
                        
                        Error( "<current_rec.can_always_compute_output_source_getter> does not match the automatically detected value" );
                        
                    end;
                    
                else
                    
                    current_rec.can_always_compute_output_source_getter = can_always_compute_output_source_getter;
                    
                end;
                
            end;
            
        end;
        
        if (@IsBound( current_rec.output_range_getter_string ))
            
            current_rec.output_range_getter = EvalString( ReplacedStringViaRecord(
                "( arguments... ) -> getter",
                @rec(
                    arguments = current_rec.input_arguments_names,
                    getter = current_rec.output_range_getter_string,
                )
            ) );
            
            if (current_rec.output_range_getter_string in current_rec.input_arguments_names)
                
                if (@not @IsBound( current_rec.output_range_getter_preconditions ))
                    
                    current_rec.output_range_getter_preconditions = [ ];
                    
                end;
                
                if (@not IsEmpty( current_rec.output_range_getter_preconditions ))
                    
                    Error( "<current_rec.output_range_getter_preconditions> does not match the automatically detected value" );
                    
                end;
                
            end;
            
            #= comment for Julia
            if (@IsBound( current_rec.output_range_getter_preconditions ))
                
                if (ForAny( current_rec.output_range_getter_preconditions, x -> IsList( x ) && Length( x ) == 3 ))
                    
                    Print( "WARNING: preconditions in other categories are not yet supported, please report this using the CAP_projects's issue tracker.\n" );
                    
                end;
                
                if (ForAny( current_rec.output_range_getter_preconditions, x -> !(IsList( x )) || Length( x ) != 2 || !(IsString( x[1] )) || @not IsInt( x[2] ) ))
                    
                    Error( "Preconditions must be pairs of names of CAP operations and integers." );
                    
                end;
                
                collected_list = CAP_INTERNAL_FIND_APPEARANCE_OF_SYMBOL_IN_FUNCTION(
                        current_rec.output_range_getter,
                        @Concatenation( recnames, RecNames( CAP_INTERNAL_METHOD_NAME_RECORD ) ),
                        2,
                        CAP_INTERNAL_METHOD_RECORD_REPLACEMENTS,
                        @rec( )
                );
                
                @Assert( 0, ForAll( collected_list, x -> Length( x ) == 3 && x[3] == fail ) );
                
                preconditions = SetGAP( List( collected_list, x -> [ x[1], x[2] ] ) );
                
                if (SetGAP( current_rec.output_range_getter_preconditions ) != preconditions)
                    
                    Error( "output_range_getter_preconditions of ", current_recname, " is ", current_rec.output_range_getter_preconditions, " but expected ", preconditions );
                    
                end;
                
            end;
            # =#
            
            if (@IsBound( current_rec.output_range_getter_preconditions ))
                
                can_always_compute_output_range_getter = IsEmpty( current_rec.output_range_getter_preconditions );
                
                if (@IsBound( current_rec.can_always_compute_output_range_getter ))
                    
                    if (current_rec.can_always_compute_output_range_getter != can_always_compute_output_range_getter)
                        
                        Error( "<current_rec.can_always_compute_output_range_getter> does not match the automatically detected value" );
                        
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
# CAP_INTERNAL_METHOD_NAME_RECORD should be an empty record at the beginning, which is populated in CAP_INTERNAL_INSTALL_ADDS_FROM_RECORD
@BindGlobal( "CAP_INTERNAL_CORE_METHOD_NAME_RECORD", StructuralCopy( CAP_INTERNAL_METHOD_NAME_RECORD ) );

##
@InstallGlobalFunction( CAP_INTERNAL_GENERATE_DOCUMENTATION_FROM_METHOD_NAME_RECORD,
  function ( record, package_name, filename, chapter_name, section_name )
    local recnames, output_string, package_info, current_string, current_recname, current_rec, output_path;
    
    #= comment for Julia
    recnames = SortedList( RecNames( record ) );
    
    output_string = "";
    
    package_info = First( PackageInfo( package_name ) );
    
    if (package_info == fail)
        
        Error( "could not find package info" );
        
    end;
    
    # the space between # and ! prevents AutoDoc from parsing these strings and is removed below
    current_string = ReplacedStringViaRecord(
"""# SPDX-License-Identifier: GPL-2.0-or-later
# package_name: package_subtitle
#
# Declarations
#
# THIS FILE IS AUTOMATICALLY GENERATED, SEE CAP_project/CAP/gap/MethodRecord.gi

# ! @Chapter chapter_name

# ! @Section section_name
""",
        @rec(
            package_name = package_name,
            package_subtitle = package_info.Subtitle,
            chapter_name = chapter_name,
            section_name = section_name,
        )
    );
    
    # see comment above
    current_string = ReplacedString( current_string, "# !", "#!" );
    
    output_string = @Concatenation( output_string, current_string );
    
    for current_recname in recnames
        
        current_rec = record[current_recname];
        
        # the space between # and ! prevents AutoDoc from parsing these strings and is removed below
        current_string = ReplacedStringViaRecord(
"""
# ! @Description
# ! The arguments are a category $C$ and a function $F$.
# ! This operation adds the given function $F$
# ! to the category for the basic operation `function_name`.
# ! $F: ( input_arguments... ) \mapsto \mathtt[function_name](input_arguments...)$.
# ! @Returns nothing
# ! @Arguments C, F
@DeclareOperation( "Addfunction_name",
                  [ IsCapCategory, IsFunction ] );

@DeclareOperation( "Addfunction_name",
                  [ IsCapCategory, IsFunction, IsInt ] );

@DeclareOperation( "Addfunction_name",
                  [ IsCapCategory, IsList, IsInt ] );

@DeclareOperation( "Addfunction_name",
                  [ IsCapCategory, IsList ] );
""",
            @rec(
                function_name = current_recname,
                input_arguments = current_rec.input_arguments_names[(2):(Length( current_rec.input_arguments_names ))],
            )
        );
        
        # see comment above
        current_string = ReplacedString( current_string, "# !", "#!" );
        
        output_string = @Concatenation( output_string, current_string );
        
    end;
    
    if (!(IsExistingFileInPackageForHomalg( package_name, filename )) || output_string != ReadFileFromPackageForHomalg( package_name, filename ))
        
        output_path = Filename( DirectoryTemporary( ), filename );
        
        WriteFileForHomalg( output_path, output_string );
        
        Display( @Concatenation(
            "WARNING: The file ", filename, " in package ", package_name, " differs from the automatically generated one. ",
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

@BindGlobal( "CAP_INTERNAL_METHOD_NAME_RECORDS_BY_PACKAGE", @rec( ) );

##
@InstallGlobalFunction( CAP_INTERNAL_REGISTER_METHOD_NAME_RECORD_OF_PACKAGE,
  function ( record, package_name )
    local recname;
    
    if (@not @IsBound( CAP_INTERNAL_METHOD_NAME_RECORDS_BY_PACKAGE[package_name] ))
        
        CAP_INTERNAL_METHOD_NAME_RECORDS_BY_PACKAGE[package_name] = @rec( );
        
    end;
    
    for recname in RecNames( record )
        
        if (@IsBound( CAP_INTERNAL_METHOD_NAME_RECORDS_BY_PACKAGE[package_name][recname] ))
            
            Error( recname, " is already registered for this package" );
            
        end;
        
        CAP_INTERNAL_METHOD_NAME_RECORDS_BY_PACKAGE[package_name][recname] = record[recname];
        
    end;
    
end );

CAP_INTERNAL_REGISTER_METHOD_NAME_RECORD_OF_PACKAGE( CAP_INTERNAL_METHOD_NAME_RECORD, "CAP" );

##
@InstallGlobalFunction( CAP_INTERNAL_GENERATE_DOCUMENTATION_FOR_CATEGORY_INSTANCES,
  function ( subsections, package_name, filename, chapter_name, section_name )
    local output_string, package_info, current_string, transitively_needed_other_packages, previous_operations, subsection, category, subsection_title, operations, bookname, info, label, match, nr, res, test_string, test_string_legacy, output_path, i, name;
    
    output_string = "";
    
    package_info = First( PackageInfo( package_name ) );
    
    if (package_info == fail)
        
        Error( "could not find package info" );
        
    end;
    
    # the space between # and ! prevents AutoDoc from parsing these strings and is removed below
    current_string = ReplacedStringViaRecord(
"""# SPDX-License-Identifier: GPL-2.0-or-later
# package_name: package_subtitle
#
# Declarations
#
# THIS FILE IS AUTOMATICALLY GENERATED, SEE CAP_project/CAP/gap/MethodRecord.gi

# ! @Chapter chapter_name

# ! @Section section_name
""",
        @rec(
            package_name = package_name,
            package_subtitle = package_info.Subtitle,
            chapter_name = chapter_name,
            section_name = section_name,
        )
    );
    
    output_string = @Concatenation( output_string, current_string );
    
    # We do not want to include operations from optional dependencies because those might not be available.
    transitively_needed_other_packages = TransitivelyNeededOtherPackages( package_name );
    
    previous_operations = [ ];
    
    for i in (1):(Length( subsections ))
        
        subsection = subsections[i];
        
        @Assert( 0, IsList( subsection ) && Length( subsection ) == 2 );
        
        category = subsection[1];
        subsection_title = subsection[2];
        
        @Assert( 0, IsCapCategory( category ) );
        @Assert( 0, IsString( subsection_title ) );
        
        # the space between # and ! prevents AutoDoc from parsing these strings and is removed below
        current_string = @Concatenation( "\n# ! @Subsection ", subsection_title );
        output_string = @Concatenation( output_string, current_string );
        
        if (i == 1)
            
            operations = AsSortedList( ListInstalledOperationsOfCategory( category ) );
            
            current_string = "\n\n# ! The following CAP operations are supported:";
            
        else
            
            if (@not IsSubset( ListInstalledOperationsOfCategory( category ), previous_operations ))
                
                Error( "the operations of the ", i - 1, "-th category are not a subset of the operations of the ", i, "-th category" );
                
            end;
            
            operations = AsSortedList( Difference( ListInstalledOperationsOfCategory( category ), previous_operations ) );
            
            current_string = "\n\n# ! The following additional CAP operations are supported:";
            
        end;
        
        if (IsEmpty( operations ))
            
            Display( "WARNING: No operations found, skipping subection" );
            
        end;
        
        output_string = @Concatenation( output_string, current_string );
        
        for name in operations
            
            # find package name == bookname
            bookname = PackageOfCAPOperation( name );
            
            if (bookname == fail)
                
                Display( @Concatenation( "WARNING: Could not find package for CAP operation ", name, ", skipping." ) );
                continue;
                
            end;
            
            # skip operation if it comes from an optional dependency
            if (@not bookname in transitively_needed_other_packages)
                
                continue;
                
            end;
            
            # simulate GAPDoc's `ResolveExternalRef` to make sure we get a correct reference
            info = HELP_BOOK_INFO( bookname );
            
            if (info == fail)
                
                Error( "Could not get HELP_BOOK_INFO for book ", bookname, ". You probably have to execute `make doc` for the corresponding package." );
                
            end;
            
            if (IsOperation( ValueGlobal( name ) ))
                
                # the "for Is" makes sure we only match operations with a filter and not functions
                label = "for Is";
                
            else
                
                label = "";
                
            end;
            
            match = @Concatenation( HELP_GET_MATCHES( info, SIMPLE_STRING( @Concatenation( name, " (", label, ")" ) ), true ) );
            
            nr = 1;
            
            if (Length(match) < nr)
                
                Error( "Could not get HELP_GET_MATCHES for book ", bookname, ", operation ", name, ", and label ", SIMPLE_STRING( label ) );
                
            end;
            
            res = GetHelpDataRef(info, match[nr][2]);
            res[1] = SubstitutionSublist(res[1], " (not loaded): ", ": ", "one");
            
            if (IsOperation( ValueGlobal( name ) ))
                
                test_string = @Concatenation( bookname, ": ", name, " for Is" );
                # needed for GAPDoc < 1.6.5
                test_string_legacy = @Concatenation( bookname, ": ", name, " for is" );
                
                if (!(StartsWith( res[1], test_string ) || StartsWith( res[1], test_string_legacy )))
                    
                    Error( res[1], " does not start with ", test_string, ", matching wrong operation?" );
                    
                end;
                
            else
                
                test_string = @Concatenation( bookname, ": ", name );
                
                if (@not res[1] == test_string)
                    
                    Error( res[1], " is not equal to ", test_string, ", matching wrong function?" );
                    
                end;
                
            end;
            
            current_string = ReplacedStringViaRecord(
                "\n# ! * <Ref BookName=\"bookname\" Func=\"operation_name\" Label=\"label\" />", # GAPDoc does @not care if we use `Func` || `Oper` for external refs
                @rec(
                    bookname = bookname,
                    operation_name = name,
                    label = label,
                )
            );
            output_string = @Concatenation( output_string, current_string );
            
            Add( previous_operations, name );
            
        end;
        
        output_string = @Concatenation( output_string, "\n" );
        
    end;
    
    # see comments above
    output_string = ReplacedString( output_string, "# !", "#!" );
    
    if (!(IsExistingFileInPackageForHomalg( package_name, filename )) || output_string != ReadFileFromPackageForHomalg( package_name, filename ))
        
        output_path = Filename( DirectoryTemporary( ), filename );
        
        WriteFileForHomalg( output_path, output_string );
        
        Display( @Concatenation(
            "WARNING: The file ", filename, " in package ", package_name, " differs from the automatically generated one. ",
            "You can view the automatically generated file at the following path: ",
            output_path
        ) );
        
    end;
    
end );
