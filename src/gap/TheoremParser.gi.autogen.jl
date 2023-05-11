# SPDX-License-Identifier: GPL-2.0-or-later
# CAP: Categories, Algorithms, Programming
#
# Implementations
#

#################################
##
## Tool methods
##
#################################

## Returns true if string represents an integer &&
## converting is save, false otherwise.
@InstallGlobalFunction( STRING_REPRESENTS_INTEGER,
            
  i -> ForAll( i, j -> j ⥉ "0123456789" )
  
);

## Converts to int if string is an int,
## returns fail otherwise
@InstallGlobalFunction( Int_SAVE,
            
  function( string )
    
    if STRING_REPRESENTS_INTEGER( string )
        
        return IntGAP( string );
        
    else
        
        return fail;
        
    end;
    
end );

##Splits string at occourences of substring
@BindGlobal( "SPLIT_STRING_MULTIPLE",
            
  function( string, substring )
    local list, lenght_substring, current_pos;
    
    list = [ ];
    
    lenght_substring = Length( substring );
    
    current_pos = PositionSublist( string, substring );
    
    while true
        
        current_pos = PositionSublist( string, substring );
        
        if current_pos == fail
            
            Add( list, string );
            
            break;
            
        end;
        
        Add( list, string[(1):(current_pos - 1)] );
        
        string = string[(current_pos + lenght_substring):(Length( string ))];
        
    end;
    
    return list;
    
end );

## If string is true || false, method returns
## the corresponding bool. If string represents an int,
## method returns this int. Fail otherwise.
@BindGlobal( "CONVERT_STRING_TO_BOOL_OR_INT",
            
  function( string )
    
    string = LowercaseString( NormalizedWhitespace( string ) );
    
    if string == "true"
        
        return true;
        
    elseif string == "false"
        
        return false;
        
    else
        
        return Int_SAVE( string );
        
    end;
    
end );

## Splits theorem at | && vdash,
## returns a list with three entries,
## && throws an error otherwise.
@BindGlobal( "SPLIT_THEOREM",
            
  function( theorem_string )
    local return_rec;
    
    return_rec = @rec( );
    
    theorem_string = SplitString( theorem_string, "|" );
    
    if Length( theorem_string ) != 2
        
        return "no unique | found";
        
    end;
    
    return_rec.context = NormalizedWhitespace( theorem_string[ 1 ] );
    
    theorem_string = SPLIT_STRING_MULTIPLE( theorem_string[ 2 ], "vdash" );
    
    if Length( theorem_string ) != 2
        
        return "no unique vdash found";
        
    end;
    
    return_rec.source = NormalizedWhitespace( theorem_string[ 1 ] );
    
    return_rec.range = NormalizedWhitespace( theorem_string[ 2 ] );
    
    return return_rec;
    
end );

## Returns an empty list if string is empty.
## Splits string at ',' if !in ( ) || [ ].
@BindGlobal( "SPLIT_KOMMAS_NOT_IN_BRACKETS",
            
  function( string )
    local positions, bracket_count, return_list, first, last, i;
    
    if Length( string ) == 0
        
        return [ ];
        
    end;
    
    positions = [ 0 ]; ## Yes
    
    bracket_count = 0;
    
    for i in (1):(Length( string ))
        
        if string[ i ] ⥉ [ '(', '[' ]
            
            bracket_count = bracket_count + 1;
            
        elseif string[ i ] ⥉ [ ')', ']' ]
            
            bracket_count = bracket_count - 1;
            
        elseif bracket_count == 0 && string[ i ] == ','
            
            Add( positions, i );
            
        end;
        
    end;
    
    Add( positions, Length( string ) + 1 ); ## Yes
    
    return_list = [ ];
    
    for i in (1):(Length( positions ) - 1)
        
        first = positions[ i ] + 1;
        last = positions[ i + 1 ] - 1;
        
        Add( return_list, string[(first):(last)] );
        
    end;
    
    return return_list;
    
end );

## If string is of form command( some ) it returns
## a record with command entry is the command string
## && arguments is the list of arguments
@BindGlobal( "COMMAND_AND_ARGUMENTS",
            
  function( command_string )
    local command, arguments, first_pos, i;
    
    i = PositionSublist( command_string, "(" );
    
    if i == fail
        
        return fail;
        
    end;
    
    command = command_string[(1):(i - 1)];
    
    first_pos = i;
    
    while PositionSublist( command_string, ")", i ) != fail
        
        i = PositionSublist( command_string, ")", i );
        
    end;
    
    arguments = command_string[(first_pos + 1):(i - 1)];
    
    return @rec( command = command, arguments = SPLIT_KOMMAS_NOT_IN_BRACKETS( arguments ) );
    
end );

## If string is [ some ] then it returns the corresponding list. Fail otherwise
@BindGlobal( "FIND_LISTING",
            
  function( string )
    
    NormalizeWhitespace( string );
    
    if string[ 1 ] == '[' && string[ Length( string ) ] == ']'
        
        return SPLIT_KOMMAS_NOT_IN_BRACKETS( string[(2):(Length( string ) - 1)] );
        
    end;
    
    return fail;
    
end );

@InstallGlobalFunction( "SPLIT_SINGLE_PART_RECURSIVE",
                       
  function( single_part )
    local listing;
    
    NormalizeWhitespace( single_part );
    
    listing = FIND_LISTING( single_part );
    
    if listing != fail
        
        return List( listing, SPLIT_SINGLE_PART_RECURSIVE );
        
    end;
    
    listing = SPLIT_KOMMAS_NOT_IN_BRACKETS( single_part );
    
    if listing == [ ]
        
        return List( listing, SPLIT_SINGLE_PART_RECURSIVE );
        
    end;
    
    listing = COMMAND_AND_ARGUMENTS( single_part );
    
    if listing == fail
        
        return single_part;
        
    end;
    
    Apply( listing.arguments, SPLIT_SINGLE_PART_RECURSIVE );
    
    return listing;
    
end );

@BindGlobal( "SPLIT_SINGLE_PART",
            
  function( part )
    local return_rec, temp_rec;
    
    return_rec = @rec( );
    
    part = SplitString( part, ":" );
    
    Perform( part, NormalizedWhitespace );
    
    if Length( part ) == 2
        
        return_rec.bound_variables = part[ 1 ];
        
        part = part[ 2 ];
        
    else
        
        return_rec.bound_variables = fail;
        
        part = part[ 1 ];
        
    end;
    
    temp_rec = SPLIT_SINGLE_PART_RECURSIVE( part );
    
    return_rec.command = temp_rec.command;
    
    return_rec.arguments = temp_rec.arguments;
    
    return return_rec;
    
end );

@BindGlobal( "SANITIZE_ARGUMENT_LIST",
            
  function( string )
    local list, arg, tmp_list, new_list, position;
    
    NormalizeWhitespace( string );
    
    list = SplitString( string, "," );
    
    ## collect lists
    
    arg = 1;
    
    new_list = [ ];
    
    while arg <= Length( list )
        
        position = PositionSublist( list[ arg ], "[" );
        
        if position == fail
            
            Add( new_list, NormalizedWhitespace( list[ arg ] ) );
            
        else
            
            tmp_list = [ ];
            
            Remove( list[ arg ], position );
            
            position = fail;
            
            while position == fail
                
                Add( tmp_list, NormalizedWhitespace( list[ arg ] ) );
                
                arg = arg + 1;
                
                position = PositionSublist( list[ arg ], "]" );
                
            end;
            
            Remove( list[ arg ], position );
            
            Add( tmp_list, NormalizedWhitespace( list[ arg ] ) );
            
            Add( new_list, tmp_list );
            
        end;
        
        arg = arg + 1;
        
    end;
    
    return new_list;
    
end );

## Returns the part of string before the first occourence of substring.
## If substring is !present, the whole string is returned
@BindGlobal( "REMOVE_PART_AFTER_FIRST_SUBSTRING",
            
  function( string, substring )
    local position;
    
    position = PositionSublist( string, substring );
    
    if position == fail
        
        return string;
        
    else
        
        return string[(1):(position - 1)];
        
    end;
    
end );

## Returns the number of occourences of substring ⥉ string
@BindGlobal( "COUNT_SUBSTRING_APPEARANCE",
            
  function( string, substring )
    
    string = SPLIT_STRING_MULTIPLE( string, substring );
    
    return Length( string ) - 1;
    
end );

@BindGlobal( "FIND_PART_WHICH_CONTAINS_FUNCTION",
            
  function( part )
    local nr_substring_close_bracket, return_record, splitted_part, predicate, func, variables, position_equal, value, position_close_bracket;
    
    nr_substring_close_bracket = COUNT_SUBSTRING_APPEARANCE( part, "(" );
    
    if nr_substring_close_bracket < 2
        
        return fail;
        
    end;
    
    if nr_substring_close_bracket > 2
        
        part = @Concatenation( "this is !a valid part: ", part );
        
        Error( part );
        
    end;
    
    return_record = @rec( );
    
    splitted_part = SplitString( part, "(" );
    
    predicate = NormalizedWhitespace( splitted_part[ 1 ] );
    
    func = NormalizedWhitespace( splitted_part[ 2 ] );
    
    variables = NormalizedWhitespace( splitted_part[ 3 ] );
    
    position_equal = PositionSublist( variables, "=" );
    
    if position_equal != fail
        
        variables = SplitString( variables, "=" );
        
        value = variables[ 2 ];
        
        variables = variables[ 1 ];
        
        value = CONVERT_STRING_TO_BOOL_OR_INT( value );
        
    else
        
        value = true;
        
    end;
    
    position_close_bracket = PositionSublist( variables, ")" );
    
    if position_close_bracket == fail
        
        Error( "some ) should have been found" );
        
    else
        
        variables = variables[(1):(position_close_bracket - 1)];
        
    end;
    
    return_record.TheoremPart = @rec( Value = value, ValueFunction = ValueGlobal( NormalizedWhitespace( predicate ) ), Object = "result" );
    
    return_record.Variables = SANITIZE_ARGUMENT_LIST( variables );
    
    return_record.Function = func;
    
    if @IsBound( CAP_INTERNAL_METHOD_NAME_RECORD[func] )
        
        if Length( return_record.Variables ) != Length( CAP_INTERNAL_METHOD_NAME_RECORD[func].filter_list ) - 1
            
            Error( "in logic file: ", func, " gets ", Length( return_record.Variables ), " arguments but ", Length( CAP_INTERNAL_METHOD_NAME_RECORD[func].filter_list ) - 1, " were expected" );
            
        end;
        
    elseif func != "Source" && func != "Range"
        
        Error( "in logic file: ", func, " is neither a CAP operation nor `Source` || `Range`" );
        
    end;
    
    return return_record;
    
end );

@BindGlobal( "FIND_PREDICATE_VARIABLES",
            
  function( source_part, range_variables )
    local split_source_part, func, predicate, variables, source_rec, first, bound_variable, value,
          position_exists, position_forall, i;
    
    split_source_part = SplitString( source_part, "(" );
    
    if Length( split_source_part ) != 2
        
        Error( "this should !happen, too many (" );
        
    end;
    
    source_rec = @rec( );
    
    ## find bound variables
    predicate = split_source_part[ 1 ];
    
    variables = SplitString( split_source_part[ 2 ], "=" );
    
    if Length( variables ) == 2
        
        value = CONVERT_STRING_TO_BOOL_OR_INT( variables[ 2 ] );
        
        variables = variables[ 1 ];
        
    else
        
        value = true;
        
        variables = variables[ 1 ];
        
    end;
    
    position_forall = PositionSublist( predicate, "forall" );
    
    position_exists = PositionSublist( predicate, "exists" );
    
    if Minimum( [ position_forall, position_exists ] ) != fail
        
        first = Minimum( [ position_forall, position_exists ] ) + 7;
        
        predicate = predicate[(first):(Length( predicate ))];
        
        predicate = SplitString( predicate, ":" );
        
        bound_variable = predicate[ 1 ];
        
        predicate = predicate[ 2 ];
        
        bound_variable = SPLIT_STRING_MULTIPLE( bound_variable, "in" );
        
        bound_variable = List( bound_variable, NormalizedWhitespace );
        
        bound_variable = Position( range_variables, bound_variable[ 2 ] );
        
        if position_forall != fail
            
            bound_variable = [ bound_variable, "all" ];
            
        else
            
            bound_variable = [ bound_variable, "any" ];
            
        end;
        
    else
        
        predicate = split_source_part[ 1 ];
        
        variables = NormalizedWhitespace( variables[(1):(PositionSublist( variables, ")" ) - 1)] );
        
        for i in (1):(Length( range_variables ))
            
            if IsString( range_variables[ i ] )
                
                if variables == range_variables[ i ]
                    
                    bound_variable = i;
                    
                    break;
                    
                end;
                
            else
                
                bound_variable = Position( range_variables[ i ], variables );
                
                if bound_variable != fail
                    
                    bound_variable = [ i, bound_variable ];
                    
                    break;
                    
                else
                    
                    @Unbind( bound_variable );
                    
                end;
                
            end;
            
        end;
        
        if !@IsBound( bound_variable )
            
            variables = @Concatenation( "variable ", variables, " was !recognized" );
            
        end;
        
    end;
    
    return @rec( Object = bound_variable, ValueFunction = ValueGlobal( NormalizedWhitespace( predicate ) ), Value = value );
    
end );

@InstallGlobalFunction( PARSE_THEOREM_FROM_LATEX,
                       
  function( theorem_string )
    local variable_part, source_part, range_part, range_value, range_command,
          range_predicate, range_variables, position, i, current_source_rec, source_part_split,
          sources_list, int_conversion, length, theorem_record, result_function_variables, to_be_removed,
          source_part_copy;
    
    source_part = PositionSublist( theorem_string, "|" );
    
    if source_part == fail
        
        Error( "no | found" );
        
    end;
    
    range_part = PositionSublist( theorem_string, "vdash" );
    
    if range_part == fail
        
        Error( "no \vdash found" );
        
    end;
    
    theorem_string = SplitString( theorem_string, "|" );
    
    theorem_string[ 2 ] = SPLIT_STRING_MULTIPLE( theorem_string[ 2 ], "\vdash" );
    
    variable_part = NormalizedWhitespace( theorem_string[ 1 ] );
    
    source_part = NormalizedWhitespace( theorem_string[ 2 ][ 1 ] );
    
    range_part = NormalizedWhitespace( theorem_string[ 2 ][ 2 ] );
    
    ##Sanitize variables
    
    variable_part = SplitString( variable_part, "," );
    
    variable_part = List( variable_part, i -> SplitString( i, ":" ) );
    
    variable_part = List( variable_part, i -> List( i, j -> NormalizedWhitespace( j ) ) );
    
    ## split source part
    
    source_part_copy = ShallowCopy( source_part );
    
    RemoveCharacters( source_part_copy, " \n\t\r" );
    
    if source_part_copy == "()"
        
        source_part = [ ];
        
    else
        
        source_part = SplitString( source_part, "," );
        
    end;
    
    ## Rebuild Sourcepart, remove brackets
    
    source_part = List( source_part, NormalizedWhitespace );
    
    i = 1;
    
    while i < Length( source_part )
        
        if COUNT_SUBSTRING_APPEARANCE( source_part[ i ], "(" ) > COUNT_SUBSTRING_APPEARANCE( source_part[ i ], ")" )
            
            source_part[ i ] = @Concatenation( source_part[ i ], source_part[ i + 1 ] );
            
            Remove( source_part, [ i + 1 ] );
            
        else
            
            i = i + 1;
            
        end;
        
    end;
    
    for i in (1):(Length( source_part ))
        
        if source_part[ i ][ 1 ] == '('
            
            length = Length( source_part[ i ] );
            
            source_part[ i ] = source_part[ i ][(2):(length - 1)];
            
        end;
        
    end;
    
    ## find function, && therefore return variables
    ## check range first
    
    theorem_record = FIND_PART_WHICH_CONTAINS_FUNCTION( range_part );
    
    sources_list = [ ];
    
    if theorem_record != fail
        ## Range contains the function
        
        theorem_record.Range = theorem_record.TheoremPart;
        
        @Unbind( theorem_record.TheoremPart );
        
        result_function_variables = theorem_record.Variables;
        
        @Unbind( theorem_record.Variables );
        
    else
        
        theorem_record = @rec( );
        
    end;
    
    to_be_removed = [ ];
    
    for i in source_part
        
        current_source_rec = FIND_PART_WHICH_CONTAINS_FUNCTION( i );
        
        if current_source_rec != fail
            
            result_function_variables = current_source_rec.Variables;
            
            theorem_record.Function = current_source_rec.Function;
            
            Add( sources_list, current_source_rec.TheoremPart );
            
            Add( to_be_removed, i );
            
        end;
        
    end;
    
    for i in to_be_removed
        
        Remove( source_part, Position( source_part, i ) );
        
    end;
    
    if !@IsBound( theorem_record.Function )
        
        Error( "no function found. This is the wrong parser" );
        
    end;
    
    if !@IsBound( theorem_record.Range )
        
        theorem_record.Range = FIND_PREDICATE_VARIABLES( range_part, result_function_variables );
        
    end;
    
    for i in source_part
        
        Add( sources_list, FIND_PREDICATE_VARIABLES( i, result_function_variables ) );
        
    end;
    
    for i in (1):(Length( result_function_variables ))
        
        if !IsString( result_function_variables[ i ] )
            
            continue;
            
        end;
        
        int_conversion = STRING_REPRESENTS_INTEGER( result_function_variables[ i ] );
        
        if int_conversion == false
            
            continue;
            
        end;
        
        Add( sources_list, @rec( Type = "testdirect", Object = i, Value = IntGAP( result_function_variables[ i ] ) ) );
        
    end;
    
    theorem_record.Source = sources_list;
    
    for i in (1):(Length( result_function_variables ))
        
        if IsList( result_function_variables[ i ] ) && !IsString( result_function_variables[ i ] )
            
            result_function_variables[ i ] = Length( result_function_variables[ i ] );
            
        else
            
            result_function_variables[ i ] = 0;
            
        end;
        
    end;
    
    theorem_record.Variable_list = result_function_variables;
    
    return theorem_record;
    
end );

@BindGlobal( "RETURN_STRING_BETWEEN_SUBSTRINGS",
            
  function( string, substring_begin, substring_end )
    local substring, rest_of_string, position_begin, position_end;
    
    position_begin = PositionSublist( string, substring_begin );
    
    position_end = PositionSublist( string, substring_end );
    
    if position_begin == fail || position_end == fail
        
        return fail;
        
    end;
    
    substring = string[(position_begin + Length( substring_begin )):(position_end - 1)];
    
    rest_of_string = string[(position_end + Length( substring_end )):(Length( string ))];
    
    return [ substring, rest_of_string ];
    
end );

#= comment for Julia
# "$" ⥉ strings triggers interpolation ⥉ Julia
@BindGlobal( "REMOVE_CHARACTERS_FROM_LATEX",
            
  function( string )
    local i;
    
    for i in [ "&", "\\", "big", "\big", "$", "mathrm", "~" ]
        
        string = @Concatenation( SPLIT_STRING_MULTIPLE( string, i ) );
        
    end;
    
    return string;
    
end );
# =#

@InstallGlobalFunction( "READ_LOGIC_FILE",
                       
  function( filename, type )
    local parser, file, lines, theorem_list, substring, without_align;
    
    if LowercaseString( type ) == "implication"
        
        parser = PARSE_PREDICATE_IMPLICATION_FROM_LATEX;
        
    elseif LowercaseString( type ) == "theorem"
        
        parser = PARSE_THEOREM_FROM_LATEX;
        
    elseif LowercaseString( type ) == "eval_rule"
        
        parser = PARSE_EVAL_RULE_FROM_LATEX;
        
    else
        
        Error( "wrong parsing type" );
        
    end;
    
    file = ReadFileForHomalg( filename );
    
    lines = SplitString( file, "\n" );
    
    lines = List( lines, l -> REMOVE_PART_AFTER_FIRST_SUBSTRING( l, "%" ) );
    
    file = JoinStringsWithSeparator( lines, "\n" );
    
    NormalizeWhitespace( file );
    
    file = REMOVE_CHARACTERS_FROM_LATEX( file );
    
    theorem_list = [ ];
    
    while true
        
        substring = RETURN_STRING_BETWEEN_SUBSTRINGS( file, "begin[sequent]", "end[sequent]" );
        
        if substring == fail
            
            break;
            
        end;
        
        file = substring[ 2 ];
        
        without_align = RETURN_STRING_BETWEEN_SUBSTRINGS( substring[ 1 ], "begin[align*]", "end[align*]" );
        
        if without_align == fail
            
            without_align = substring[ 1 ];
            
        else
            
            without_align = without_align[ 1 ];
            
        end;
        
        Add( theorem_list, parser( without_align ) );
        
    end;
    
    return theorem_list;
    
end );

@InstallGlobalFunction( READ_THEOREM_FILE,
                       
  function( theorem_file )
    
    return READ_LOGIC_FILE( theorem_file, "theorem" );
    
end );

##############################
##
## True methods
##
##############################

@InstallGlobalFunction( "PARSE_PREDICATE_IMPLICATION_FROM_LATEX",
                       
  function( theorem_string )
    local variable_part, source_part, range_part, source_filter, range_filter, i;
    
    variable_part = SplitString( theorem_string, "|" );
    
    source_part = SPLIT_STRING_MULTIPLE( variable_part[ 2 ], "vdash" );
    
    range_part = source_part[ 2 ];
    
    source_part = source_part[ 1 ];
    
    variable_part = variable_part[ 1 ];
    
    variable_part = NormalizedWhitespace( SplitString( variable_part, ":" )[ 2 ] );
    
    source_part = SplitString( source_part, "," );
    
    source_part = List( source_part, i -> NormalizedWhitespace( REMOVE_PART_AFTER_FIRST_SUBSTRING( i, "(" ) ) );
    
    if Length( source_part ) == 0
        
        Error( "no source part found" );
        
    end;
    
    source_filter = ValueGlobal( source_part[ 1 ] );
    
    Remove( source_part, 1 );
    
    for i in source_part
        
        source_filter = source_filter && ValueGlobal( i );
        
    end;
    
    range_part = NormalizedWhitespace( REMOVE_PART_AFTER_FIRST_SUBSTRING( range_part, "(" ) );
    
    range_part = ValueGlobal( range_part );
    
    return @rec( CellType = variable_part, Source = source_filter, Range = range_part );
    
end );

@InstallGlobalFunction( READ_PREDICATE_IMPLICATION_FILE,
                       
  function( predicate_file )
    
    return READ_LOGIC_FILE( predicate_file, "implication" );
    
end );

## PARSE_THEOREM_FROM_LATEX( "A:\Obj ~|~ \IsZero( A ) \vdash \IsProjective( A )" );

@InstallGlobalFunction( SEARCH_FOR_VARIABLE_NAME_APPEARANCE,
            
  function( tree, names )
    local appearance_list, current_result, i, j, name_position, return_list;
    
    ## command_case
    if IsRecord( tree )
        
        return SEARCH_FOR_VARIABLE_NAME_APPEARANCE( tree.arguments, names );
        
    end;
    
    if IsString( tree )
        
        name_position = Position( names, tree );
        
        return_list = List( names, i -> [ ] );
        
        if name_position != fail
            
            return_list[ name_position ] = [ [ ] ];
            
        end;
        
        return return_list;
        
    end;
    
    if IsList( tree ) && !IsString( tree )
        
        return_list = List( names, i -> [ ] );
        
        for i in (1):(Length( tree ))
            
            current_result = SEARCH_FOR_VARIABLE_NAME_APPEARANCE( tree[ i ], names );
            
            for j in (1):(Length( current_result ))
                
                current_result[ j ] = List( current_result[ j ], k -> @Concatenation( [ i ], k ) );
                
                return_list[ j ] = @Concatenation( current_result[ j ], return_list[ j ] );
                
            end;
            
        end;
        
        return return_list;
        
    end;
    
end );

##
@InstallGlobalFunction( REPLACE_VARIABLE,
                       
  function( tree, names, replacements )
    local return_rec, entry;
    
    if IsString( tree ) && Position( names, tree ) != fail
        
        return replacements[ Position( names, tree ) ];
        
    end;
    
    if IsList( tree )
        
        return List( tree, i -> REPLACE_VARIABLE( i, names, replacements ) );
        
    end;
    
    if IsRecord( tree )
        
        return_rec = ShallowCopy( tree );
        
        return_rec.arguments = REPLACE_VARIABLE( tree.arguments, names, replacements );
        
        return return_rec;
        
    end;
    
    return tree;
    
end );

@InstallGlobalFunction( REPLACE_INTEGER_VARIABLE,
                       
  function( tree )
    local int;

    if IsString( tree )
       
       int = STRING_REPRESENTS_INTEGER( tree );
       
       if int == false
           
           return tree;
           
       else
           
           return IntGAP( tree );
           
       end;
       
    end;

    if IsList( tree )
       
       return List( tree, REPLACE_INTEGER_VARIABLE );
       
    end;
    
    if IsRecord( tree )
        
        int = ShallowCopy( tree );
        
        int.arguments = REPLACE_INTEGER_VARIABLE( tree.arguments );
        
        return int;
        
    end;

    return tree;
    
end );

@InstallGlobalFunction( SEARCH_FOR_INT_VARIABLE_APPEARANCE,
            
  function( tree )
    local appearance_list, current_result, i, j, int;
    
    if IsList( tree ) && Length( tree ) == 2 && IsString( tree[ 1 ] ) && IsList( tree[ 2 ] ) && !IsString( tree[ 2 ] )
        
        return SEARCH_FOR_INT_VARIABLE_APPEARANCE( tree[ 2 ] );
        
    end;
    
    if IsList( tree )
        
        appearance_list = [ ];
        
        for i in (1):(Length( tree ))
            
            if IsString( tree[ i ] )
                
                int = STRING_REPRESENTS_INTEGER( tree[ i ] );
                
                if int != false
                    
                    Add( appearance_list, [ [ i ], IntGAP( tree[ i ] ) ] );
                    
                end;
                
            elseif IsList( tree[ i ] )
                
                current_result = SEARCH_FOR_INT_VARIABLE_APPEARANCE( tree[ i ] );
                
                for j in current_result
                    
                    Add( appearance_list, [ @Concatenation( [ i ], j[ 1 ] ), j[ 2 ] ] );
                    
                end;
                
            end;
            
        end;
        
        return appearance_list;
        
    end;
    
end );

##
@InstallGlobalFunction( FIND_COMMAND_POSITIONS,
                       
  function( tree, variable_names )
    local current_command, command_list, i, current_return, j, return_list;
    
    command_list = [ ];
    
    if IsList( tree ) && Length( tree ) == 2 && IsString( tree[ 1 ] ) && IsList( tree[ 2 ] ) && Position( variable_names, tree[ 1 ] ) == fail 
        
        command_list = [ [ [ ], tree[ 1 ] ] ];
        
        tree = tree[ 2 ];
        
    end;
    
    if IsList( tree )
        
        for i in (1):(Length( tree ))
            
            current_return = FIND_COMMAND_POSITIONS( tree[ i ], variable_names );
            
            for j in current_return
                
                Add( command_list, [ @Concatenation( [ i ], j[ 1 ] ), j[ 2 ] ] );
                
            end;
            
        end;
        
    end;
    
    return command_list;
    
end );

@BindGlobal( "FIND_VARIABLE_TYPES",
            
  function( var_list )
    local i, j, next_type;
    
    var_list = List( var_list, i -> SplitString( i, ":" ) );
    
    Perform( var_list, i -> List( i, NormalizedWhitespace ) );
    
    for i in (1):(Length( var_list ))
        
        if Length( var_list[ i ] ) == 1
            
            for j in (i + 1):(Length( var_list ))
                
                if @IsBound( var_list[ j ][ 2 ] )
                    
                    var_list[ i ][ 2 ] = var_list[ j ][ 2 ];
                    
                    break;
                    
                end;
                
            end;
            
        end;
        
        if !@IsBound( var_list[ i ][ 2 ] )
            
            Error( "no type for variable found" );
            
        end;
        
        var_list[ i ][ 2 ] = LowercaseString( NormalizedWhitespace( var_list[ i ][ 2 ] ) );
        
        NormalizeWhitespace( var_list[ i ][ 1 ] );
        
    end;
    
    return var_list;
    
end );

@InstallGlobalFunction( GIVE_VARIABLE_NAMES_WITH_POSITIONS_RECURSIVE,
                       
  function( tree )
    local i, var_list, current_var;
    
    if IsString( tree )
        
        return [ [ [ ], tree ] ];
        
    elseif IsList( tree )
        
        var_list = [ ];
        
        for i in (1):(Length( tree ))
            
            current_var = GIVE_VARIABLE_NAMES_WITH_POSITIONS_RECURSIVE( tree[ i ] );
            
            current_var = List( current_var, j -> [ @Concatenation( [ i ], j[ 1 ] ), j[ 2 ] ] );
            
            Append( var_list, current_var );
            
        end;
        
        return var_list;
        
    elseif IsRecord( tree )
        
        return GIVE_VARIABLE_NAMES_WITH_POSITIONS_RECURSIVE( tree.arguments );
        
    end;
    
    return [ ];
    
end );

@InstallGlobalFunction( "IS_LIST_WITH_INDEX",
            
  function( variable_name )
    
    if PositionSublist( variable_name, "[" ) == fail
        
        return false;
        
    end;
    
    return true;
    
end );

@InstallGlobalFunction( "SPLIT_INTO_LIST_NAME_AND_INDEX",
            
  function( variable_name )
    local length;
    
    if !IS_LIST_WITH_INDEX( variable_name )
        
        return [ variable_name ];
        
    end;
    
    NormalizeWhitespace( variable_name );
    
    variable_name = SplitString( variable_name, "[" );
    
    length = Length( variable_name[ 2 ] );
    
    variable_name[ 2 ] = variable_name[ 2 ][(1):(length - 1)];
    
    return List( variable_name, NormalizedWhitespace );
    
end );

@InstallGlobalFunction( REPLACE_INTEGER_STRINGS_BY_INTS_AND_VARIABLES_BY_FAIL_RECURSIVE,
            
  function( record )
    
    if IsRecord( record )
        
        return @rec( command = record.command, arguments = REPLACE_INTEGER_STRINGS_BY_INTS_AND_VARIABLES_BY_FAIL_RECURSIVE( record.arguments ) );
        
    elseif IsList( record ) && !IsString( record )
        
        return List( record, REPLACE_INTEGER_STRINGS_BY_INTS_AND_VARIABLES_BY_FAIL_RECURSIVE );
        
    elseif IsString( record ) && STRING_REPRESENTS_INTEGER( record )
        
        return Int_SAVE( record );
        
    end;
    
    return fail;
    
end );


##
@InstallGlobalFunction( PARSE_EVAL_RULE_FROM_LATEX,
                       
  function( rule )
    local split_record, variables, source, range, object_variables, list_variables, int_variables,
          range_source, range_replace, range_source_tree, variables_with_positions, variable_record,
          variable, possible_positions, equal_variable_pairs, current_variable_and_index, additional_position,
          range_replace_list_and_index, new_source_list, bound_variable_string, bound_variable_name,
          bound_variable_list_content, bound_variable_list_boundaries, i, return_rec, source_list, j;
    
    RemoveCharacters( rule, " \n\t\r" );
    
    split_record = SPLIT_THEOREM( rule );
    
    if IsString( split_record )
        
        Error( @Concatenation( split_record ), " ⥉ ", rule );
        
    end;
    
    variables = split_record.context;
    
    source = split_record.source;
    
    range = split_record.range;
    
    ## Sanitize variables && find type
    variables = SPLIT_KOMMAS_NOT_IN_BRACKETS( variables );
    
    variables = FIND_VARIABLE_TYPES( variables );
    
    object_variables = Filtered( variables, i -> i[ 2 ] ⥉ [ "obj", "mor" ] );
    
    list_variables = Filtered( variables, i -> i[ 2 ] ⥉ [ "listobj", "listmor" ] );
    
    int_variables = Filtered( variables, i -> i[ 2 ] ⥉ [ "int" ] );
    
    list_variables = List( list_variables, i -> i[ 1 ] );
    
    int_variables = List( int_variables, i -> i[ 1 ] );
    
    ## Sanitize range, find positions of variables
    
    range = SplitString( range, "=" );
    
    if Length( range ) != 2
        
        Error( "range must contain exactly one =" );
        
    end;
    
    range_source = range[ 1 ];
    
    range_replace = range[ 2 ];
    
    range_replace = ReplacedString( range_replace, "_[Mor]", "" );
    
    range_replace = ReplacedString( range_replace, "_[Obj]", "" );
    
    range_source_tree = SPLIT_SINGLE_PART( range_source );
    
    ## Find variable positions
    
    variables_with_positions = GIVE_VARIABLE_NAMES_WITH_POSITIONS_RECURSIVE( range_source_tree );
    
    ## Build complete variable record:
    
    variable_record = @rec( );
    
    for variable in variables
        
        possible_positions = Filtered( variables_with_positions, i -> i[ 2 ] == variable[ 1 ] );
        
        if possible_positions == [ ]
            
            continue;
            
        end;
        
        variable_record[variable[ 1 ]] = possible_positions[ 1 ][ 1 ];
        
    end;
    
    return_rec = @rec( );
    
    return_rec.command_tree = REPLACE_INTEGER_STRINGS_BY_INTS_AND_VARIABLES_BY_FAIL_RECURSIVE( range_source_tree );
    
    return_rec.variable_record = variable_record;
    
    ## find matching variables
    equal_variable_pairs = List( variables_with_positions, i -> [ i[ 1 ] ] );
    
    for i in (1):(Length( variables_with_positions ))
        
        for j in (i + 1):(Length( variables_with_positions ))
            
            if variables_with_positions[ i ][ 2 ] == variables_with_positions[ j ][ 2 ]
                
                Add( equal_variable_pairs[ i ], variables_with_positions[ j ][ 1 ] );
                
            end;
            
        end;
        
    end;
    
    equal_variable_pairs = Filtered( equal_variable_pairs, i -> Length( i ) > 1 );
    
    for variable in variables_with_positions
        
        if IS_LIST_WITH_INDEX( variable[ 2 ] )
            
            current_variable_and_index = SPLIT_INTO_LIST_NAME_AND_INDEX( variable[ 2 ] );
            
            if STRING_REPRESENTS_INTEGER( current_variable_and_index[ 2 ] )
                
                additional_position = Int_SAVE( current_variable_and_index[ 2 ] );
                
            else
                
                additional_position = current_variable_and_index[ 2 ];
                
            end;
            
            Add( equal_variable_pairs, [ variable[ 1 ], @Concatenation( variable_record[current_variable_and_index[ 1 ]], additional_position ) ] );
            
        end;
        
    end;
    
    return_rec.equal_variable_positions = equal_variable_pairs;
    
    if IS_LIST_WITH_INDEX( range_replace )
        
        range_replace_list_and_index = SPLIT_INTO_LIST_NAME_AND_INDEX( range_replace );
        
        return_rec.replace = @Concatenation( variable_record[range_replace_list_and_index[ 1 ]], [ range_replace_list_and_index[ 2 ] ] );
        
    else
        
        return_rec.replace = variable_record[range_replace];
        
    end;
    
    return_rec.starting_command = range_source_tree.command;
    
    ## Starting with sources
    
    if source == "()"
        
        source_list = [ ];
        
    else
        
        source_list = SPLIT_KOMMAS_NOT_IN_BRACKETS( source );
        
    end;
    
    source_list = List( source_list, SPLIT_SINGLE_PART );
    
    ## create test function for source
    
    new_source_list = [ ];
    
    for source in source_list
        
        if source.bound_variables != fail
           
            bound_variable_string = source.bound_variables;
            
            bound_variable_string = RETURN_STRING_BETWEEN_SUBSTRINGS( bound_variable_string, "forall", "in" );
            
            bound_variable_name = bound_variable_string[ 1 ];
            
            if COUNT_SUBSTRING_APPEARANCE( bound_variable_string[ 2 ], "[" ) == 0
                
                source.bound_variable_list_name = bound_variable_string[ 2 ];
                
            else
                
                bound_variable_list_content = RETURN_STRING_BETWEEN_SUBSTRINGS( bound_variable_string[ 2 ], "[", "]" )[ 1 ];
                
                for i in [ "..", ",dots,", "dots" ]
                    
                    bound_variable_list_content = SPLIT_STRING_MULTIPLE( bound_variable_list_content, i );
                    
                    if Length( bound_variable_list_content ) > 1
                        
                        break;
                        
                    else
                        
                        bound_variable_list_content = bound_variable_list_content[ 1 ];
                        
                    end;
                    
                end;
                
                if Length( bound_variable_list_content ) < 2
                    
                    Error( "could !split bound variable list correctly" );
                    
                end;
                
                bound_variable_list_boundaries = [ ];
                
                for i in [ 1, 2 ]
                    
                    if STRING_REPRESENTS_INTEGER( bound_variable_list_content[ i ] )
                        
                        bound_variable_list_boundaries[ i ] = Int_SAVE( bound_variable_list_content[ i ] );
                        
                    else
                        
                        bound_variable_list_boundaries[ i ] = bound_variable_list_content[ i ];
                        
                    end;
                    
                end;
                
                source.bound_variable_list_boundaries = bound_variable_list_boundaries;
            
            end;
            
            source.bound_variable_name = bound_variable_name;
            
        end;
        
        Add( new_source_list, source );
        
    end;
    
    return_rec.source_list = new_source_list;
    
    return return_rec;
    
end );

@InstallGlobalFunction( READ_EVAL_RULE_FILE,
                       
  function( eval_rule_file )
    
    return READ_LOGIC_FILE( eval_rule_file, "eval_rule" );
    
end );

