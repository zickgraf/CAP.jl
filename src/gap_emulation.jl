import Base.==
import Base.*
import Base.-
import Base.+
import Base./
import Base.getindex
import Base.copy
import Base.in

# In GAP, `not` binds loser than anything except `and` and `or`.
# We emulate this behaviour via a macro. However, a macro binds loser
# than `&&` or `||`, so we have to manually terminate the macro
# at the first `&&` or `||`. Additionally, in expressions of the form
# `a and not b or c`, `@not` would capture `c` and we would get
# `a and (! b or c)` instead of `(a and ! b) or c`. Thus, we display
# an error if we encounter an `||` in `@not`.
# TODO: `[ a, not b, c ]` and `func( a : optionA := not b, optionB := not c )` also cause problems
macro not(expr)
	if expr isa Expr && expr.head === :||
		throw("Found expression of the form `not ... or ...`. This is not supported because `not` in GAP has a different precedence than `!` in Julia. Please use parenthesis, i.e. write `not (...) or ...`.")
	elseif expr isa Expr && expr.head === :&&
		esc(:(!($(expr.args[1])) && $(expr.args[2])))
	else
		esc(:(!($expr)))
	end
end

export @not

macro FunctionWithNamedArguments(specification, func)
	@assert specification.head === :vect
	@assert func.head === :function
	@assert all(a -> a.head === :vect && length(a.args) == 2 && a.args[1] isa String, specification.args)
	@assert length(func.args[1].args) > 0
	@assert func.args[1].args[1] === :CAP_NAMED_ARGUMENTS
	
	options = map(s -> Expr(:kw, Symbol(s.args[1]), s.args[2]), specification.args)
	func.args[1].args[1] = Expr(:parameters, options...)
	esc(func)
end

export @FunctionWithNamedArguments

function PrintString end
function DirectSum end
global const DirectSumOp = DirectSum
function DirectProduct(arg...)
	
    if IsCapCategory( arg[1] ) then
        
		Error( "this case should never be triggered" )
        
    end;
    
    if Length( arg ) == 1 &&
       IsList( arg[1] ) &&
       ForAll( arg[1], IsCapCategoryObject ) then
       
       return DirectProduct( CapCategory( arg[1][1] ), arg[1] );
       
    end;
    
    return DirectProduct( CapCategory( arg[1] ), arg );
	
end
global const DirectProductOp = DirectProduct
function IsEqualForCache end
function Inverse end
function Equalizer end
global const EqualizerOp = Equalizer
function Coequalizer end
global const CoequalizerOp = Coequalizer
function FiberProduct end
global const FiberProductOp = FiberProduct

function TensorProductOp end
function TensorProduct(arg...)
    if Length(arg) == 0
        Error("<arg> must be nonempty");
    elseif Length(arg) == 1 && IsList(arg[1])
        if IsEmpty(arg[1])
            Error("<arg>[1] must be nonempty");
        end;
        arg = arg[1];
    end;
    d = TensorProductOp(arg,arg[1]);
    return d;
end

function Filtered end
function FilteredOp end

function CreateWeakCachingObject( args... )
	"weak_caching_object"
end

function CreateCrispCachingObject( args... )
	"crisp_caching_object"
end

function CacheValue(cache, key_list)
	[ ]
end

function SetCacheValue(cache, key_list, value)
	return;
end

function SSortedList(list::Union{Vector, UnitRange, StepRange})
	unique(sort(list))
end

SetGAP = SSortedList

function UnionGAP(args...)
	if length(args) == 1
		args = args[1]
	end
	if length(args) == 0
		[ ]
	elseif length(args) == 1
		args[1]
	else
		sort(union(args...))
	end
end

function ListWithKeys(list, func)
	map(p -> func(p...), enumerate(list))
end

function FilteredWithKeys(list, func)
	map(p -> p[2], filter(p -> func(p...), collect(enumerate(list))))
end

macro NTupleGAP(n, args...)
	@assert n isa Int
	@assert n == length(args)
	esc(:([$(args...)]))
end

export @NTupleGAP

function NTupleGAP(n, args...)
	@assert n == length(args)
	[args...]
end

Iterator = iterate

struct Fail end

fail = Fail()

function Base.show(io::IO, fail::Fail)
	print(io, "fail")
end

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
	dict[key]
end

function Base.setindex!(obj::CAPDict, value, key::String)
	setproperty!(obj, Symbol(key), value)
end

function Base.setproperty!(obj::CAPDict, key::Symbol, value)
	dict = getfield(obj, :dict)
	dict[key] = value
end

function Base.propertynames(obj::CAPDict)
	dict = getfield(obj, :dict)
	keys(dict)
end

macro Unbind(expr)
	if expr isa Expr && expr.head === :.
		obj = expr.args[1]
		key = expr.args[2]
		esc(quote
			delete!(getfield($obj, :dict), $key); nothing
		end)
	elseif expr isa Expr && expr.head === :ref
		obj = expr.args[1]
		string = expr.args[2]
		esc(quote
			delete!(getfield($obj, :dict), Symbol($string)); nothing
		end)
	else
		throw("unsupported Unbind")
	end
end

export @Unbind

macro IsBound(expr)
	if expr isa Expr && expr.head === :.
		obj = expr.args[1]
		key = expr.args[2]
		esc(quote
			haskey(getfield($obj, :dict), $key)
		end)
	elseif expr isa Expr && expr.head === :ref
		obj = expr.args[1]
		string = expr.args[2]
		esc(quote
			haskey(getfield($obj, :dict), Symbol($string))
		end)
	else
		throw("unsupported IsBound")
	end
end

export @IsBound

# records
function rec(; named_arguments...)
	CAPRecord(Dict{Symbol,Any}(named_arguments))
end

macro rec(keyvalues...)
	pairs = map(function( x )
		@assert x isa Expr
		@assert x.head === :(=)
		key = x.args[1]
		value = x.args[2]
		@assert key isa Symbol
		# turn dual_pre/postprocessor_func's into strings immediately
		if key in [:dual_preprocessor_func, :dual_postprocessor_func]
			# work around https://github.com/JuliaLang/julia/pull/49874
			if value isa Expr && value.head === :function && length(value.args) === 2 && value.args[1] isa Expr && value.args[1].head === :...
				value.args[1] = Expr(:tuple, value.args[1])
			end
			:($(Meta.quot(Symbol(key, "_string"))) => $(string(value)))
		else
			:($(Meta.quot(key)) => $value)
		end
	end, keyvalues)
	esc(quote
		CAPRecord(Dict{Symbol,Any}($(pairs...)))
	end)
end

export @rec

function RecNames(obj::CAPDict)
	dict = getfield(obj, :dict)
	# the order of element of `keys` may vary -> we have to sort
	sort([string(key) for key in keys(dict)])
end

function ==(rec1::CAPRecord, rec2::CAPRecord)
	RecNames( rec1 ) == RecNames( rec2 ) && ForAll(RecNames(rec1), name -> rec1[name] == rec2[name])
end

function copy(record::CAPRecord)
	CAPRecord(copy(getfield(record, :dict)))
end

# GAP String, Print, View, Display
const DEFAULTDISPLAYSTRING = "<object>\n"
const DEFAULTVIEWSTRING = "<object>"

function DisplayString(obj::CAPDict)
	DEFAULTDISPLAYSTRING
end

function ViewString(obj::CAPDict)
	DEFAULTVIEWSTRING
end

function Display(obj::CAPDict)
	string = DisplayString(obj)
	if string == DEFAULTDISPLAYSTRING
		PrintObj(obj)
		println()
	else
		print(string)
	end
end

function ViewObj(obj::CAPDict)
	string = ViewString(obj)
	if string == DEFAULTVIEWSTRING
		PrintObj(obj)
	else
		print(string)
	end
end

function PrintObj(obj::CAPDict)
	print(PrintString(obj))
end

function PrintString(obj::CAPDict)
	StringGAP_OPERATION(obj)
end

function StringGAP_OPERATION(obj::CAPDict)
	"<object>"
end

# String, Print, View, Display for native types
function Display(list::Union{Vector, UnitRange, StepRange})
	print(DisplayString(list))
end

function DisplayString(int::Union{Int, BigInt})
	string(int, "\n")
end

# DisplayString of a non-empty list in GAP returns "<object>"
# This is obviously not what we want.
function DisplayString(list::Union{Vector, UnitRange, StepRange})
	# https://github.com/gap-system/gap/pull/5418
	if length(list) == 0
		"[  ]"
	else
		string(PrintString(list), "\n")
	end
end

function PrintString(int::Union{Int, BigInt})
	string(int)
end

function PrintString(c::Char)
	string("'", c, "'")
end

function QuotedPrintString(x::Any)
	PrintString(x)
end

function QuotedPrintString(x::String)
	string("\"", x, "\"")
end

# PrintString for lists in GAP simply returns String.
# Here, we want to actually simulate the output of PrintObj.
function PrintString(list::Vector)
	# https://github.com/gap-system/gap/pull/5418
	if length(list) == 0
		"[ ]"
	else
		string("[ ", join(map(x -> QuotedPrintString(x), list), ", "), " ]")
	end
end

function PrintString(list::UnitRange)
	StringGAP_OPERATION(list)
end

function StringGAP_OPERATION(x::Union{Int, BigInt})
	string(x)
end

function QuotedStringGAP_OPERATION(x::Any)
	StringGAP_OPERATION(x)
end

function QuotedStringGAP_OPERATION(x::String)
	string("\"", x, "\"")
end

function StringGAP_OPERATION(list::Vector)
	# https://github.com/gap-system/gap/pull/5418
	if length(list) == 0
		"[ ]"
	else
		string("[ ", join(map(x -> QuotedStringGAP_OPERATION(x), list), ", "), " ]")
	end
end

function StringGAP_OPERATION(range::UnitRange)
	if range.stop < range.start
		# https://github.com/gap-system/gap/pull/5418
		string("[ ]")
	elseif range.stop == range.start
		string("[ ", range.stop, " ]")
	else
		string("[ ", range.start, " .. ", range.stop, " ]")
	end
end

function Base.show(io::IO, obj::CAPDict)
	print(io, ViewString(obj))
end

# filters

struct Filter <: Function
	name::String
	abstract_type::Type
	concrete_type::Type
	subtypable::Bool
end

function Filter(name::String, abstract_type::Type)
	Filter(name, abstract_type, Any, true)
end

function (filter::Filter)(obj)
	isa(obj, filter.abstract_type)
end

function IsFilter( obj )
	obj isa Filter
end

macro DeclareFilter(name::String, parent_filter::Union{Symbol,Expr} = :IsObject)
	filter_symbol = Symbol(name)
	abstract_type_symbol = Symbol("TheJuliaAbstractType" * name)
	concrete_type_symbol = Symbol("TheJuliaConcreteType" * name)
	# all our macros are meant to fully execute in the context where the macro is called -> always fully escape them
	esc(quote
		@assert $parent_filter.subtypable
		abstract type $abstract_type_symbol <: $parent_filter.abstract_type end
		struct $concrete_type_symbol{T} <: $abstract_type_symbol
			dict::Dict
		end
		global const $filter_symbol = Filter($name, $abstract_type_symbol, $concrete_type_symbol, true)
		if !isdefined(CAP, $(Meta.quot(filter_symbol)))
			setglobal!(CAP, $(Meta.quot(filter_symbol)), $filter_symbol)
		end
	end)
end

export @DeclareFilter

function NewFilter( name, parent_filter )
	if !parent_filter.subtypable
		throw("cannot create NewFilter with a parent filter which was itself created by NewFilter")
	end
	type_symbol = Symbol(name, gensym())
	concrete_type = parent_filter.concrete_type{type_symbol}
	Filter(name, concrete_type, concrete_type, false)
end

const NewCategory = NewFilter

# GAP filters
abstract type AttributeStoringRep <: CAPDict end
const IsAttributeStoringRep = Filter("IsAttributeStoringRep", AttributeStoringRep)

const IsIO = Filter("IsIO", IO)
const IsObject = Filter("IsObject", Any)
const IsString = Filter("IsString", AbstractString)
const IsStringRep = IsString
const IsList = Filter("IsList", Union{Vector, UnitRange, StepRange, Tuple})
const IsDenseList = IsList
const IsFunction = Filter("IsFunction", Function)
const IsOperation = IsFunction
const IsChar = Filter("IsChar", Char)
const IsInt = Filter("IsInt", Int)
const IsBigInt = Filter("IsBigInt", BigInt)
const IsRat = Filter("IsRat", Rational{BigInt})
const IsBool = Filter("IsBool", Bool)
const IsPosInt = Filter("IsPosInt", Int) # TODO
const IsRecord = Filter("IsRecord", CAPRecord)
# integer or infinity (a float)
const IsCyclotomic = Filter("IsCyclotomic", Union{Int,Float64}) # TODO

# AbstractAlgebra
const IsRing = Filter("IsRing", Ring)
const IsRingElement = Filter("IsRingElement", AbstractAlgebra.NCRingElement)

function HasIsCommutative(R::AbstractAlgebra.NCRing)
	R isa Ring
end

function IsCommutative(R::AbstractAlgebra.NCRing)
	R isa Ring
end

Integers = ZZ
Rationals = QQ

const IsIntegers = Filter("IsIntegers", AbstractAlgebra.Integers{BigInt})

function HasRingFilter(R::Ring)
	if R === ZZ
		return true
	else
		return false
	end
end

function RingFilter(R::Ring)
	if R === ZZ
		return IsIntegers
	else
		throw("ring has no ring filter")
	end
end

function HasRingElementFilter(R::Ring)
	if R === ZZ
		return true
	else
		return false
	end
end

function RingElementFilter(R::Ring)
	if R === ZZ
		return IsBigInt
	else
		throw("ring has no ring element filter")
	end
end

# Objectify
function ObjectifyWithAttributes( record::CAPRecord, type::DataType, attributes_and_values... )
	if !iseven(length(attributes_and_values))
		throw("odd number of attributes and values")
	end
	@assert type <: CAPDict
	obj = type(getfield(record, :dict))
	for i in 1:2:length(attributes_and_values)-1
		@assert attributes_and_values[i] isa Attribute
		symbol_setter = Setter(attributes_and_values[i])
		value = attributes_and_values[i + 1]
		symbol_setter(obj, value)
	end
	obj
end

function NewType(family, filter::Filter)
	if filter.concrete_type == Any
		throw(string("the concrete type of ", filter.name, " is Any, cannot create objects from this"))
	end
	if filter.subtypable
		filter.concrete_type{:generic}
	else
		filter.concrete_type
	end
end

function Objectify(type, record)
	ObjectifyWithAttributes( record, type )
end

# global variables
DeclareGlobalVariable = function( name )
	# noop
end;

macro InstallValueConst(name::Symbol, value)
	esc(:(global const $name = $value))
end

export @InstallValueConst

macro InstallValue(name::Symbol, value)
	esc(:(global $name = $value))
end

export @InstallValue

# global functions
macro DeclareGlobalFunction(name::String)
	esc(:(@DeclareOperation($name)))
end

export @DeclareGlobalFunction

macro InstallGlobalFunction(name::String, func)
	symbol = Symbol(name)
	esc(:(@InstallGlobalFunction($symbol, $func)))
end

macro InstallGlobalFunction(name::Symbol, func)
	esc(:(InstallMethod($name, nothing, $func)))
end

export @InstallGlobalFunction

# global names
DeclareGlobalName = function( name )
	# noop
end

macro BindGlobalConst(name::String, value)
	if value isa Expr && (value.head === :function || value.head === :->)
		esc(quote
			@DeclareGlobalFunction($name)
			@InstallGlobalFunction($name, $value)
		end)
	else
		symbol = Symbol(name)
		esc(:(@InstallValueConst($symbol, $value)))
	end
end

export @BindGlobalConst

macro BindGlobal(name::String, value)
	if value isa Expr && (value.head === :function || value.head === :->)
		esc(quote
			@DeclareGlobalFunction($name)
			@InstallGlobalFunction($name, $value)
		end)
	else
		symbol = Symbol(name)
		esc(:(@InstallValue($symbol, $value)))
	end
end

export @BindGlobal

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
		if @IsBound( options[name] )
			return options[name]
		end
	end
	return fail
end

# operations

macro DeclareOperation(name::String, filter_list = [])
	# prevent attributes from being redefined as operations
	if isdefined(__module__, Symbol(name))
		return nothing
	end
	symbol = Symbol(name)
	esc(quote
		function $symbol end
		if !isdefined(CAP, $(Meta.quot(symbol)))
			setglobal!(CAP, $(Meta.quot(symbol)), $symbol)
		end
	end)
end

export @DeclareOperation

macro KeyDependentOperation(name::String, filter1, filter2, func)
	symbol = Symbol(name)
	symbol_op = Symbol(name * "Op")
	esc(quote
		@DeclareOperation($name)
		global const $symbol_op = $symbol
	end)
end

export @KeyDependentOperation

function with_additional_dropped_first_argument(f)
	(arg1, args...) -> f(args...)
end

function InstallMethod(operation, filter_list, func)
	if IsAttribute( operation )
		mod = parentmodule(operation.operation)
	elseif isa(operation, Function)
		mod = parentmodule(operation)
	else
		mod = CAP
	end
	
	if mod === Base
		mod = CAP
	end
	
	InstallMethod(mod, operation, filter_list, func)
end

function InstallMethod(mod::Module, operation, filter_list, func::Function)
	if operation == ViewObj
		println("ignoring installation for ViewObj, use ViewString instead")
		return
	elseif operation == Display
		println("ignoring installation for Display, use DisplayString instead")
		return
	end
	
	if !isa(operation, Function)
		display(operation)
	end
	
	if operation === Iterator
		@assert length(filter_list) == 1
		filter_list = [ filter_list[1], IsObject ];
		nargs = 2
		isva = true
	elseif !isnothing(filter_list)
		nargs = length(filter_list)
		isva = false
	elseif length(methods(func)) == 1
		nargs = methods(func)[1].nargs - 1
		isva = methods(func)[1].isva
	else
		println("Cannot determine number of arguments for the following operation:")
		display(operation)
		nargs = 1
		isva = true
	end
	
	vars = Vector{Any}(map(i -> Symbol("arg" * string(i)), 1:nargs))
	if isnothing(filter_list)
		vars_with_types = copy(vars)
	else
		vars_with_types = map(function(i)
			arg_symbol = vars[i]
			type = filter_list[i].abstract_type
			:($arg_symbol::$type)
		end, 1:length(filter_list))
	end
	if IsAttribute( operation )
		funcref = Symbol(operation.operation)
	elseif operation === CallFuncList
		@assert !isva
		@assert length(vars_with_types) === 2
		@assert filter_list[2] === IsList
		funcref = popfirst!(vars_with_types)
		vars_with_types[1] = Expr(:..., vars[nargs])
	else
		funcref = Symbol(operation)
	end
	
	if funcref isa Symbol && !isdefined(mod, funcref)
		print("WARNING: installing method in module ", mod, " for undefined symbol ", funcref, "\n")
	end
	
	if isva
		vars[nargs] = Expr(:..., vars[nargs])
		vars_with_types[nargs] = Expr(:..., vars_with_types[nargs])
	end
	
	Base.eval(mod, :(
		function $funcref($(vars_with_types...); kwargs...)
			$func($(vars...); kwargs...)
		end
	))
	if funcref isa Symbol
		Base.eval(mod, :(export $funcref))
	end
end

function InstallMethod(operation, description::String, filter_list, func)
	InstallMethod(operation, filter_list, func)
end

function InstallMethod(mod, operation, description::String, filter_list, func)
	InstallMethod(mod, operation, filter_list, func)
end

InstallOtherMethod = InstallMethod
function InstallMethodWithCacheFromObject( operation, filter_list, func; ArgumentNumber = 1 )
	InstallMethod( operation, filter_list, func )
end
function InstallMethodWithCache( operation, filter_list, func; InstallMethod = InstallMethod, Cache = "cache" )
	InstallMethod( operation, filter_list, func )
end
function InstallMethodWithCache( operation, description, filter_list, func; InstallMethod = InstallMethod, Cache = "cache" )
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

function (attr::Attribute)(obj::CAPDict; kwargs...)
	if !Tester(attr)(obj)
		Setter(attr)(obj, attr.operation(obj; kwargs...))
	end
	attr.getter(obj)
end

function (attr::Attribute)(args...; kwargs...)
	attr.operation(args...; kwargs...)
end

function StringGAP_OPERATION(attr::Attribute)
	string("<Attribute \"", attr.name, "\">")
end

function declare_attribute_or_property(mod, name::String, is_property::Bool)
	# attributes and properties might be installed for different parent filters
	# since we do not take the parent filter into account here, we only have to install
	# the attribute or property once
	if isdefined(mod, Symbol(name))
		return nothing
	end
	symbol = Symbol(name)
	symbol_op = Symbol(name, "_OPERATION")
	symbol_tester = Symbol("Has", name)
	symbol_getter = Symbol("Get", name)
	symbol_setter = Symbol("Set", name)
	esc(quote
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
		if !isdefined(CAP, $(Meta.quot(symbol)))
			setglobal!(CAP, $(Meta.quot(symbol)), $symbol)
		end
	end)
end

macro DeclareAttribute(name::String, parent_filter, mutability = missing)
	declare_attribute_or_property(__module__, name, false)
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

macro DeclareSynonymAttr(name::String, attr)
	symbol = Symbol(name)
	esc(:(global const $symbol = $attr))
end

macro DeclareProperty(name::String, parent_filter)
	declare_attribute_or_property(__module__, name, true)
end

export @DeclareProperty

IsProperty = function( obj )
	obj isa Attribute && obj.is_property
end

function InstallTrueMethod(prop1, prop2)
	@assert IsProperty( prop1 ) && IsProperty( prop2 )
	push!(prop2.implied_properties, prop1)
end

function ListImpliedFilters(prop)
	@assert IsProperty( prop )
	
	flatten = prop -> union([prop], map(flatten, prop.implied_properties)...)
	sort(map(attr -> attr.name, flatten(prop)))
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

macro Info(infoclass, required_level, args...)
	esc(quote
		if InfoLevel( $infoclass ) >= $required_level
			Print("#I  ", $(args...), "\n")
		end
	end)
end

export @Info

# GAP functions
function IsDigitChar(x::Char)
	x in "0123456789"
end

function SizeScreen()
	dim = displaysize(stdout)
	[dim[2], dim[1]]
end

function ListWithIdenticalEntries(n, obj)
	list = fill(obj, n)
	if obj isa Char
		String(list)
	else
		list
	end
end

Perform = function( list, func )
	for elm in list
		func(elm)
	end
end

function Product(list::Union{Vector, UnitRange, StepRange, Tuple})
	if length(list) == 0
		1
	else
		prod(list)
	end
end

function Sum(list::Union{Vector, UnitRange, StepRange, Tuple})
	if length(list) == 0
		0
	else
		sum(list)
	end
end

function Sum(list::Union{Vector, UnitRange, StepRange, Tuple}, func)
	Sum(map(func, list))
end

function QuoInt(a::Union{Int, BigInt}, b::Union{Int, BigInt})
	a ÷ b
end

function QUO_INT(a::Union{Int, BigInt}, b::Union{Int, BigInt})
	a ÷ b
end

function RemInt(a::Union{Int, BigInt}, b::Union{Int, BigInt})
	a % b
end

function REM_INT(a::Union{Int, BigInt}, b::Union{Int, BigInt})
	a % b
end

function Cartesian(args...)
	if length(args) == 1
		args = args[1]
	end
	
	map(collect,vec(permutedims(collect(Iterators.product(args...)), reverse(1:length(args)))))
end

@DeclareAttribute("Length", IsAttributeStoringRep)

function Length_OPERATION(x::Union{Vector, UnitRange, StepRange, Tuple, String})
	length(x)
end

@DeclareAttribute("IntGAP", IsAttributeStoringRep)

function IntGAP_OPERATION(string::String)
	parse(Int, string)
end

function IntGAP_OPERATION(float::Float64)
	Int(floor(float))
end

@DeclareAttribute("StringGAP", IsAttributeStoringRep)
StringMutable = StringGAP

function Add( list::Vector, element::Any )
	push!(list, element)
end

function Add( list::Vector, element::Any, pos::Int )
	insert!(list, pos, element)
end

function Remove( list::Vector )
	pop!(list)
end

function Remove( list::Vector, index::Int )
	popat!(list, index)
end

function Concatenation(lists...)
	if length(lists) == 1
		lists = lists[1]
	end
	
	if !isempty(lists) && isa(lists[1], String)
		string(lists...)
	else
		vcat(map(collect, lists)...)
	end
end

# converting tuples to lists via splatting is much faster then via "collect" -> handle this via a macro
macro Concatenation(lists...)
	if length(lists) > 1 && any(x -> x isa Expr && x.head === :vect, lists)
		# we are certainly dealing with multiple lists -> use splatting
		splatted_lists = map(x -> :($x...), lists)
		esc(quote
			[$(splatted_lists...)]
		end)
	else
		# fallback for other cases (single argument, strings, etc.)
		esc(quote
			Concatenation($(lists...))
		end)
	end
end

export @Concatenation

function ReplacedString( string::String, search::String, val::String )
	replace(string, search => val)
end

function JoinStringsWithSeparator( strings, sep )
	join(strings, sep)
end

function IsBoundGlobal( name )
	isdefined(CAP, Symbol(name))
end

ValueGlobal = function(name)
	@assert IsBoundGlobal(name)
	getglobal(CAP, Symbol(name))
end

function List(tuple::Tuple)
	collect(tuple)
end

function ListOp(list::Union{Vector, UnitRange, StepRange, Tuple}, func)
	map(func, list)
end

function ListOp end

function List(obj, func)
	ListOp(obj, func)
end

function ListN(args...)
	f = args[end]
	lists = args[1:end-1]
	@assert ForAll( lists, l -> length(l) == length(lists[1]) )
	map(x -> f(x...), zip(lists...))
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
Positions(list, elm) = findall(e -> e == elm, list)

function Filtered(list::Union{Vector, UnitRange, StepRange, Tuple}, func)
	filter(func, list)
end

function Filtered(list::Any, func)
	FilteredOp(list, func)
end

INTERNAL_AssertionLevel = 0

function SetAssertionLevel(new_level::Int)
	@assert new_level >= 0
	global INTERNAL_AssertionLevel = new_level
end

function AssertionLevel()
	INTERNAL_AssertionLevel
end

macro Assert(level, assertion)
	esc(quote
		if $level <= INTERNAL_AssertionLevel && !$assertion
			throw("assertion failed")
		end
	end)
end

export @Assert

ShallowCopy = copy
StructuralCopy = deepcopy

function Display(string::String)
	print(string, "\n")
end

function Display(func::Function)
	display(func)
end

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

function DuplicateFreeList(list::Vector)
	unique(list)
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

function Position(list::UnitRange, element::Any)
	if element in list
		element - list.start + 1
	else
		fail
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
	error(string(args...))
end

LowercaseString = lowercase

function StartsWith(string::String, substring::String)
	startswith(string, substring)
end

function StartsWith(list::Vector, sublist::Vector)
	Length(list) >= Length(sublist) && ForAll(1:Length(sublist), i -> list[i] == sublist[i])
end

function EndsWith(string::String, substring::String)
	endswith(string, substring)
end

ModulesForEvaluationStack = [ CAP ]

function EvalString(string::String)
	if string[1] == '['
		pos = PositionSublist(string, "] -> ")
		if pos != fail
		string = "(" * string[2:pos-1] * ")" * string[pos+1:end]
		end
	end
	Base.eval(last(ModulesForEvaluationStack), Meta.parse(string))
end

SortedList = sort
AsSortedList = sort

function IsPackageMarkedForLoading( name, version )
	if name == "JuliaInterface"
		return false
	end
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

function ReturnFirst( arg1, args... )
	arg1
end

IdFunc = identity

Append = append!

function CallFuncList( func, list; kwargs...)
	if length(kwargs) > 0
		PushOptions(CAPRecord(Dict(kwargs)))
	end
	result = func(list...)
	if length(kwargs) > 0
		PopOptions()
	end
	result
end

IsEmpty = isempty

function NameFunction(attr::Attribute)
	attr.name
end

function NameFunction(f::Function)
	string(f)
end

function SetNameFunction(f, name)
	# noop
end

IsIdenticalObj = ===

function Immutable(L::Vector)
	# Julia has no immutable lists
	L
end

function Immutable(R::CAPRecord)
	# TODO: mark record as immutable?
	R
end

function First(list)
	if isempty(list)
		fail
	else
		first(list)
	end
end

function First(list, func)
	pos = findfirst(func, list)
	if isnothing(pos)
		fail
	else
		list[pos]
	end
end

function Last(list)
	if isempty(list)
		fail
	else
		last(list)
	end
end

function IsSubset(list1::Vector, list2::Vector)
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
	println("trying to set the following filter for an object")
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
	filter1.abstract_type <: filter2.abstract_type
end

StableSortBy = function( list, func )
	sort!(list, alg=Base.Sort.MergeSort, by=func)
end

function Maximum(int1::Union{Int, BigInt}, int2::Union{Int, BigInt})
	max(int1, int2)
end

infinity = Inf

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

function Binomial( n, k )
	binomial(n, k)
end

function TuplesK( set, k, tup, i )
    if k == 0
        tup = ShallowCopy( tup );
        tups = [ tup ];
    else
        tups = [ ];
        for l in set
            if Length( tup ) < i - 1
				Error( "this should never happen" );
			elseif Length( tup ) == i - 1
				Add( tup, l );
			else
				tup[i] = l;
			end
            Append( tups, TuplesK( set, k-1, tup, i+1 ) );
        end;
    end;
    return tups;
end;

function Iterated( list, f )
	foldl(f, list)
end

# Julia macros

macro init_CAP_package()
	symbol = Symbol("init_" * string(__module__))
	if isdefined(__module__, symbol)
		esc(:($symbol()))
	else
		nothing
	end
end

export @init_CAP_package
