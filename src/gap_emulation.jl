import Base.==
import Base.*
import Base.-
import Base.+
import Base./
import Base.string
import Base.getindex
import Base.show
import Base.copy
import Base.in


function PrintString end
function DirectSum end
function DirectProduct end
function IsEqualForCache end
function Inverse end

function CreateWeakCachingObject( args... )
	"weak_caching_object"
end

function CreateCrispCachingObject( args... )
	"crisp_caching_object"
end

# we want "in" to bind stronger than "!"
⥉ = in

# CAPDict

abstract type CAPDict end

struct CAPRecord <: CAPDict
	dict::Dict
end

function Base.getindex(obj::CAPDict, key::String)
	getproperty(obj, Symbol(key))
end

function Base.getproperty(obj::CAPDict, key::Symbol)
	dict = getfield(obj, :dict)
	if haskey(dict, key)
		dict[key]
	else
		nothing
	end
end

function Base.setindex!(obj::CAPDict, value, key::String)
	setproperty!(obj, Symbol(key), value)
end

function Base.setproperty!(obj::CAPDict, key::Symbol, value)
	getfield(obj, :dict)[key] = value
end

function copy(record::CAPRecord)
	CAPRecord(copy(getfield(record, :dict)))
end

# Objectify
function ObjectifyWithAttributes( record::CAPRecord, type::DataType, attributes_and_values... )
	if !iseven(length(attributes_and_values))
		throw("odd number of attributes and values")
	end
	# https://docs.julialang.org/en/v1/manual/methods/#Redefining-Methods
	obj = Base.invokelatest(type, getfield(record, :dict))
	for i in 1:2:length(attributes_and_values)-1
		symbol_setter = Setter(attributes_and_values[i])
		value = attributes_and_values[i + 1]
		symbol_setter(obj, value)
	end
	obj
end

function NewType( family, filter )
	type_symbol = Symbol("TheJuliaConcreteType" * string(filter) * string(gensym()))
	eval(:(
		struct $type_symbol <: $(filter.data_type)
			dict::Dict
		end
	))
	eval(:(export $type_symbol))
	eval(type_symbol)
end

function Objectify(type, record)
	ObjectifyWithAttributes( record, type )
end

# filters

struct Filter <: Function
	name::String
	data_type::Type
end

function (filter::Filter)(obj)
	isa(obj, filter.data_type)
end

function IsFilter( obj )
	obj isa Filter
end

function DeclareFilter( name, parent_filter )
	filter_symbol = Symbol(name)
	type_symbol = Symbol("TheJuliaAbstractType" * string(filter_symbol))
	eval(:(abstract type $type_symbol <: $(parent_filter.data_type) end))
	eval(:(global const $filter_symbol = Filter($name, $type_symbol)))
	eval(:(export $type_symbol))
	eval(:(export $filter_symbol))
end

function DeclareFilter( name )
	DeclareFilter(name, IsObject)
end

DeclareCategory = DeclareFilter

function NewFilter( name, parent_filter )
	type_symbol = Symbol("TheJuliaAbstractType" * name * string(gensym()))
	eval(:(abstract type $type_symbol <: $(parent_filter.data_type) end))
	type = eval(type_symbol)
	filter = Filter(name, type)
	eval(:(export $type_symbol))
	filter
end

function NewFilter( name )
	NewFilter(name, IsObject)
end

const NewCategory = NewFilter

# GAP filters
abstract type AttributeStoringRep <: CAPDict end
const IsAttributeStoringRep = Filter("IsAttributeStoringRep", AttributeStoringRep)

abstract type CachingObject end
const IsCachingObject = Filter("IsCachingObject", CachingObject )

const IsIO = Filter("IsIO", IO)
const IsObject = Filter("IsObject", Any)
const IsString = Filter("IsString", String)
const IsStringRep = IsString
const IsList = Filter("IsList", Union{Vector, UnitRange, StepRange, Set})
const IsDenseList = IsList
const IsFunction = Filter("IsFunction", Function)
const IsOperation = IsFunction
const IsChar = Filter("IsChar", Char)
const IsInt = Filter("IsInt", Int)
const IsRat = Filter("IsRat", Rational)
const IsBool = Filter("IsBool", Bool)
const IsPosInt = Filter("IsPosInt", Int) # TODO
const IsRingElement = Filter("IsRingElement", Int) # TODO
const IsRecord = Filter("IsRecord", CAPRecord)
# integer or infinity (a float)
const IsCyclotomic = Filter("IsCyclotomic", Union{Int,Float64}) # TODO

# global functions
DeclareGlobalFunction = function( name )
	DeclareOperation( name )
end;

InstallGlobalFunction = function( name, func )
	@assert length(methods(func)) == 1
	InstallMethod( name, nothing, func )
end

# global variables
DeclareGlobalVariable = function( name )
	symbol = Symbol(name)
	eval(:(global $symbol = $name))
	eval(:(export $symbol))
end;

InstallValue = function( name, value )
	eval(:(global $(Symbol(name)) = $value))
end

# global names
DeclareGlobalName = function( name )
	# noop
end

BindGlobal = function( name, value )
	if isa( value, Function )
		DeclareGlobalFunction(name)
		InstallGlobalFunction(name, value)
	else
		symbol = Symbol(name)
		eval(:(global $symbol = $value))
		eval(:(export $symbol))
	end
end

# options

options_stack = []

function PushOptions(options::CAPRecord)
	push!(options_stack, options)
end

function PopOptions()
	pop!(options_stack)
end

function ValueOption( name )
	for options in reverse(options_stack)
		value = options[name]
		if !isnothing(value)
			return value
		end
	end
	return fail
end

# operations
function DeclareOperation( name )
	if isdefined(@__MODULE__, Symbol(name))
		return
	end
	symbol = Symbol(name)
	eval(:(function $symbol end))
	eval(:(export $symbol))
end

function DeclareOperation( name, filter_list )
	DeclareOperation( name )
end

DeclareOperationWithCache = DeclareOperation

function KeyDependentOperation( name, filter1, filter2, func )
	DeclareOperation( name )
	symbol = Symbol(name)
	symbol_op = Symbol(name * "Op")
	eval(:(global $symbol_op = $symbol))
	eval(:(export $symbol_op))
end

function InstallMethod( operation, filter_list, func )
	if operation == Pair
		return
	elseif operation == String
		operation = string
	elseif operation == ViewObj
		operation = show
		@assert length(filter_list) == 1
		filter_list = [IsIO, filter_list[1]]
		func = eval(:((io, obj) -> $func(obj)))
	end
	
	if !isnothing(filter_list)
		nargs = length(filter_list)
		isva = false
	elseif length(methods(func)) == 1
		nargs = methods(func)[1].nargs - 1
		isva = methods(func)[1].isva
	else
		display("Cannot determine number of arguments for the following operation:")
		display(operation)
		nargs = 1
		isva = true
	end
	
	vars = Vector{Any}(map(i -> Symbol("arg" * string(i)), 1:nargs))
	if isva
		vars[nargs] = Expr(:..., vars[nargs])
	end
	if isnothing(filter_list)
		vars_with_types = vars
	else
		vars_with_types = map(function(i)
			arg_symbol = vars[i]
			type = filter_list[i].data_type
			:($arg_symbol::$type)
		end, 1:length(filter_list))
	end
	if IsAttribute( operation )
		symbol = Symbol(operation.name * "Operation")
	else
		symbol = Symbol(string(operation))
	end
	
	if !isdefined(@__MODULE__, symbol)
		print("WARNING: installing method in module ", @__MODULE__, " for undefined symbol ", symbol, "\n")
	end
	
	eval(:(
		function $symbol($(vars_with_types...); keywords...)
			if length(keywords) > 0
				PushOptions(CAPRecord(Dict(keywords)))
			end
			result = $func($(vars...))
			if length(keywords) > 0
				PopOptions()
			end
			result
		end
	))
	eval(:(export $symbol))
end

function InstallMethod( operation, description, filter_list, func )
	InstallMethod(operation, filter_list, func)
end

InstallOtherMethod = InstallMethod
function InstallMethodWithCacheFromObject( operation, filter_list, func; ArgumentNumber = 1 )
	InstallMethod( operation, filter_list, func )
end
function InstallMethodWithCache( operation, filter_list, func; Cache = "cache" )
	InstallMethod( operation, filter_list, func )
end
function InstallMethodWithCache( operation, description, filter_list, func; Cache = "cache" )
	InstallMethod( operation, filter_list, func )
end
InstallMethodWithCrispCache = InstallMethod

# attributes

mutable struct Attribute <: Function
	name::String
	operation::Function
	tester::Function
	getter::Function
	setter::Function
	is_property::Bool
	implied_properties::Vector{Attribute}
end

function ==(attr1::Attribute, attr2::Attribute)
	isequal(attr1.name, attr2.name)
end

function (attr::Attribute)(obj::CAPDict)
	if !Tester(attr)(obj)
		Setter(attr)(obj, attr.operation(obj))
	end
	attr.getter(obj)
end

function (attr::Attribute)(args...)
	attr.operation(args...)
end

function declare_attribute_or_property(name::String, is_property::Bool, esc)
	# attributes and properties might be installed for different parent filters
	# since we do not take the parent filter into account here, we only have to install
	# the attribute or property once
	if isdefined(@__MODULE__, Symbol(name))
		return nothing
	end
	symbol = esc(Symbol(name))
	symbol_op = esc(Symbol(name * "Operation"))
	symbol_tester = esc(Symbol("Has" * name))
	symbol_getter = esc(Symbol("Get" * name))
	symbol_setter = esc(Symbol("Set" * name))
	quote
		function $symbol_op end
		function $symbol_tester(obj::CAPDict)
			dict = getfield(obj, :dict)
			haskey(dict, Symbol($name))
		end
		function $symbol_getter(obj::CAPDict)
			dict = getfield(obj, :dict)
			dict[Symbol($name)]
		end
		function $symbol_setter(obj::CAPDict, value)
			dict = getfield(obj, :dict)
			dict[Symbol($name)] = value
			if IsProperty( $symbol ) && value === true
				for implied_property in $symbol.implied_properties
					Setter(implied_property)(obj, true)
				end
			end
		end
		$symbol = Attribute($name, $symbol_op, $symbol_tester, $symbol_getter, $symbol_setter, $is_property, [])
	end
end

macro DeclareAttribute(name::String, parent_filter, mutability = missing)
	declare_attribute_or_property(name, false, esc)
end

export @DeclareAttribute

IsAttribute = function( obj )
	obj isa Attribute
end

function Tester( attribute::Attribute )
	attribute.tester
end

function Setter(attribute::Attribute)
	attribute.setter
end

DeclareSynonymAttr = function( name, attr )
	# TODO
end

macro DeclareProperty(name::String, parent_filter)
	declare_attribute_or_property(name, true, esc)
end

export @DeclareProperty

function DeclareProperty(name::String, parent_filter)
	eval(declare_attribute_or_property(name, true, identity))
end

IsProperty = function( obj )
	obj isa Attribute && obj.is_property
end

function InstallTrueMethod(prop1, prop2)
	@assert IsProperty( prop1 ) && IsProperty( prop2 )
	push!(prop2.implied_properties, prop1)
end

function ListImpliedFilters(prop)
	@assert IsProperty( prop )
	prop.implied_properties
end

# families
function NewFamily( name::String )
	name
end

# info classes

mutable struct InfoClass
	name::String
	level::Int
end

macro DeclareInfoClass(name::String)
	symbol = Symbol(name)
	:(global const $symbol = InfoClass($name, 0))
end

export @DeclareInfoClass

function InfoLevel(infoclass::InfoClass)
	infoclass.level
end

function SetInfoLevel(infoclass::InfoClass, level::Int)
	infoclass.level = level
end

function Info(infoclass::InfoClass, required_level::Int, args...)
	if InfoLevel( infoclass ) >= required_level
		Print("#I  ", args..., "\n")
	end
end

# records
function rec(; named_arguments...)
	CAPRecord(Dict{Symbol,Any}(named_arguments))
end

function RecNames(obj::CAPDict)
	dict = getfield(obj, :dict)
	[string(key) for key in filter(key -> dict[key] != nothing, keys(dict))]
end

function ==(rec1::CAPRecord, rec2::CAPRecord)
	RecNames( rec1 ) == RecNames( rec2 ) && ForAll(RecNames(rec1), name -> rec1[name] == rec2[name])
end

# GAP functions
Perform = function( list, func )
	for elm in list
		func(elm)
	end
end

@DeclareAttribute("Length", IsAttributeStoringRep)

function LengthOperation(list::Vector)
	length(list)
end

function LengthOperation(list::UnitRange)
	length(list)
end

function LengthOperation(list::StepRange)
	length(list)
end

function LengthOperation(list::Tuple)
	length(list)
end

function LengthOperation(list::Set)
	length(list)
end

function Add( list::Vector, element::Any )
	push!(list, element)
end

function Remove( list::Vector )
	pop!(list)
end

function Remove( list::Vector, index::Int )
	popat!(list, index)
end

function IsBound( value )
	!isnothing(value)
end

function Concatenation(lists...)
	if length(lists) == 1
		lists = lists[1]
	end
	
	if isa(lists[1], String)
		string(lists...)
	else
		vcat(map(collect, lists)...)
	end
end

function ReplacedString( string::String, search::String, val::String )
	replace(string, search => val)
end

function JoinStringsWithSeparator( strings, sep )
	join(strings, sep)
end

ValueGlobal = function(name)
	eval(Meta.parse(name))
end

IdFunc = identity

function List(tuple::Tuple)
	collect(tuple)
end

function List(list::Union{Vector,UnitRange,StepRange}, func::Function)
	map(func, list)
end

function List(obj, func)
	ListOp(obj, func)
end

ForAll(list, func) = all(func, list)
ForAny(list, func) = any(func, list)
PositionsProperty(list, func) = findall(func, list)
function PositionProperty(list, func)
	pos = findfirst(func, list)
	if isnothing(pos)
		fail
	else
		pos
	end
end
Positions(list, elm) = findall(e -> e === elm, list)
Filtered(list, func) = filter(func, list)

function ⟷(obj1, obj2)
	if isa(obj1, Function) && isa(obj2, Function)
		x -> obj1(x) ⟷ obj2(x)
	else
		obj1 && obj2
	end
end

function ⇿(obj1, obj2)
	if isa(obj1, Function) || isa(obj2, Function)
		x -> obj1(x) ⇿ obj2(x)
	else
		obj1 || obj2
	end
end

fail = Symbol("fail")

function Assert( level, assertion )
	if !assertion
		throw("assertion failed")
	end
end

ShallowCopy = copy
StructuralCopy = deepcopy

function Display(string::String)
	print(string, "\n")
end

function Display(func::Function)
	display(func)
end

ViewObj = show
Print = print

Reversed = reverse

function NumberArgumentsFunction(attr::Attribute)
	1
end

function NumberArgumentsFunction(func::Function)
	m = methods(func)
	if isempty(m)
		throw("no methods installed for this function")
	elseif length(m) > 1
		display(string(func))
		throw("more than one method installed for this function, cannot determine number of arguments")
	else
		m = m[1]
		nargs = m.nargs - 1
		if m.isva
			nargs = -nargs
		end
		return nargs
	end
end

# fallback for unbound record entries
function NumberArgumentsFunction(func::Nothing)
	-1
end

function IsDuplicateFreeList(list::Vector)
	allunique(list)
end

function SplitString(str::String, sep::String)
	map(x -> string(x), split(str, sep))
end

function Position(list::Vector, element::Any)
	pos = findfirst(x -> x == element, list)
	if isnothing(pos)
		fail
	else
		pos
	end
end

function PositionSublist(string::String, substring::String)
	range = findfirst(substring, string)
	if isnothing(range)
		fail
	else
		range[1]
	end
end

function Error(args...)
	display(string(args...))
	throw("Error")
end

LowercaseString = lowercase

function int(string::String)
	parse(Int, string)
end

function int(float::Float64)
	Int(floor(float))
end

function Base.getindex(obj::Nothing, index::Int)
	nothing
end

function StartsWith(string::String, substring::String)
	startswith(string, substring)
end

function StartsWith(list::Vector, sublist::Vector)
	Length(list) >= Length(sublist) && ForAll(1:Length(sublist), i -> list[i] == sublist[i])
end

function EndsWith(string::String, substring::String)
	endswith(string, substring)
end

function EvalString(string::String)
	if string[1] == '['
		pos = PositionSublist(string, "] -> ")
		if pos != fail
		string = "(" * string[2:pos-1] * ")" * string[pos+1:length(string)]
		end
	end
	eval(Meta.parse(string))
end

SortedList = sort
AsSortedList = sort

function IsPackageMarkedForLoading( name, version )
	# TODO
	false
end

function ReturnTrue( args... )
	true
end

function ReturnFalse( args... )
	false
end

function ReturnFail( args... )
	fail
end

Append = append!

function CallFuncList( func, list )
	func(list...)
end

IsEmpty = isempty

function NameFunction(attr::Attribute)
	attr.name
end

function NameFunction(f::Function)
	string(f)
end

IsIdenticalObj = ===

function First(list)
	if isempty(list)
		fail
	else
		first(list)
	end
end

function Last(list)
	if isempty(list)
		fail
	else
		last(list)
	end
end

function IsSubset(list1::Union{Vector,Set}, list2::Union{Vector,Set})
	issubset(list2, list1)
end

function Difference(set::Vector, subset::Vector)
	sort(setdiff(set, subset))
end

function Difference(set::UnitRange, subset::Vector)
	sort(setdiff(set, subset))
end

function Intersection(set1::Vector, set2::Vector)
	sort(intersect(set1, set2))
end

function SuspendMethodReordering()
end

function ResumeMethodReordering()
end

function SetFilterObj(obj, filter)
	display("trying to set the following filter for an object")
	display(filter)
	display(string(filter))
end

function FilenameFunc(func)
	@assert length(methods(func)) == 1
	string(methods(func)[1].file)
end

function StartlineFunc(func)
	@assert length(methods(func)) == 1
	methods(func)[1].line
end

function NamesFilter(filter)
	[string(filter)]
end

TextAttr = rec(; f0 = "\033[30m", f1 = "\033[31m", f2 = "\033[32m", f3 = "\033[33m", f4 = "\033[34m", f5 = "\033[35m", f6 = "\033[36m", f7 = "\033[37m", CSI = "\033[", b0 = "\033[40m", b1 = "\033[41m", b2 = "\033[42m", b3 = "\033[43m", b4 = "\033[44m", b5 = "\033[45m", b6 = "\033[46m", b7 = "\033[47m", blink = "\033[5m", bold = "\033[1m", delline = "\033[2K", home = "\033[1G", normal = "\033[22m", reset = "\033[0m", reverse = "\033[7m", underscore = "\033[4m" )

function FLAGS_FILTER(filter)
	filter
end

function WITH_IMPS_FLAGS(filter)
	filter
end

function IS_SUBSET_FLAGS( filter1, filter2 )
	filter1.data_type <: filter2.data_type
end

StableSortBy = function( list, func )
	sort!(list, alg=Base.Sort.MergeSort, by=func)
end

function Maximum(int1::Int, int2::Int)
	max(int1, int2)
end

# manually imported from ToolsForHomalg
function ReplacedStringViaRecord( string, record )
  local name;
    
    for name in RecNames( record )
        
        # use IsStringRep instead of IsString to differentiate between `""` and `[]`
        if IsStringRep( record[name] )
            
            string = ReplacedString( string, name, record[name] );
            
        elseif IsList( record[name] )
            
            string = ReplacedString( string, Concatenation( name, "..." ), JoinStringsWithSeparator( record[name], ", " ) );
            
        else
            
            Error( "the record's values must be strings or lists of strings" );
            
        end;
        
    end;
    
    return string;
    
end

function PositionsOfMaximalObjects( L, f )
    local l, r, i, p;
    
    l = 1:Length( L );
    
    r = [ ];
    
    for i in l
        
        if i in r
            continue;
        end;
        
        p = PositionProperty( l, j -> j != i && !(j in r) && f( L[i], L[j] ) );
        
        if p != fail
            Add( r, i );
        end;
        
    end;
    
    return Difference( l, r );
    
end

function MaximalObjects( L, f )
    
    return L[PositionsOfMaximalObjects( L, f )];
    
end
