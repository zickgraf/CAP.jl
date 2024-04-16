import Base.==
import Base.*
import Base.-
import Base.+
import Base./
import Base.getindex
import Base.copy
import Base.in

IS_PRECOMPILING = true

function CAP_precompile(args...)
	if IS_PRECOMPILING
		precompile(args...)
	end
end

global const ModulesForEvaluationStack = [ CAP ]

function IsBoundGlobal( name )
	any(m -> isdefined(m, Symbol(name)), ModulesForEvaluationStack)
end

function ValueGlobal(name)
	for m in ModulesForEvaluationStack
		if isdefined(m, Symbol(name))
			return getglobal(m, Symbol(name))
		end
	end
	error(name, " is not bound in any module of the stack")
end

function EvalString(string::String)
	if string[1] == '['
		pos = PositionSublist(string, "] -> ")
		if pos != fail
			string = "(" * string[2:pos-1] * ")" * string[pos+1:end]
		end
	end
	Base.eval(last(ModulesForEvaluationStack), Meta.parse(string))
end

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

global const Log10 = log10

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

global const SetGAP = SSortedList

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

function NumberGAP(list, func)
	count(func, list)
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

struct Fail end

global const fail = Fail()

function Base.show(io::IO, fail::Fail)
	print(io, "fail")
end

# CAPDict

abstract type CAPDict end

struct CAPRecord <: CAPDict
	dict::Dict
end

function Base.getindex(obj::CAPDict, key::Union{String, Int64})
	getproperty(obj, Symbol(key))
end

function Base.getproperty(obj::CAPDict, key::Symbol)
	dict = getfield(obj, :dict)
	dict[key]
end

function Base.setindex!(obj::CAPDict, value, key::Union{String, Int64})
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

# json
include("gap_emulation/json.jl")

# filters
include("gap_emulation/filters.jl")

# operations
include("gap_emulation/operations.jl")

# attributes
include("gap_emulation/attributes.jl")

# GAP filters
global const IsIO = Filter("IsIO", IO)
global const IsObject = Filter("IsObject", Any)
global const IsString = Filter("IsString", AbstractString)
global const IsStringRep = IsString
global const IsList = Filter("IsList", Union{Vector, UnitRange, StepRange, Tuple})
global const IsDenseList = IsList
global const IsFunction = Filter("IsFunction", Function)
global const IsOperation = IsFunction
global const IsChar = Filter("IsChar", Char)
global const IsInt = Filter("IsInt", Int)
global const IsBigInt = Filter("IsBigInt", BigInt)
global const IsRat = Filter("IsRat", Rational{BigInt})
global const IsBool = Filter("IsBool", Bool)
global const IsPosInt = Filter("IsPosInt", Int) # TODO
global const IsRecord = Filter("IsRecord", CAPRecord)
# integer or infinity (a float)
global const IsCyclotomic = Filter("IsCyclotomic", Union{Int,Float64}) # TODO

global const Float = Float64

# AbstractAlgebra
global const IsRing = Filter("IsRing", Ring)
global const IsRingElement = Filter("IsRingElement", AbstractAlgebra.NCRingElement)

function HasIsCommutative(R::AbstractAlgebra.NCRing)
	R isa Ring
end

function IsCommutative(R::AbstractAlgebra.NCRing)
	R isa Ring
end

global const Integers = ZZ
global const Rationals = QQ

global const IsIntegers = Filter("IsIntegers", AbstractAlgebra.Integers{BigInt})

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

## GAP String, Print, View, Display

function Base.show(io::IO, obj::CAPDict)
	print(io, ViewString(obj))
end

function Print(args...)
	for obj in args
		if obj isa String
			print(obj)
		else
			PrintObj(obj)
		end
	end
end

function View(args...)
	for obj in args
		ViewObj(obj)
	end
end

# fallback
global const DEFAULTDISPLAYSTRING = "<object>\n"
global const DEFAULTVIEWSTRING = "<object>"

function Display(obj)
	string = DisplayString(obj)
	if string === DEFAULTDISPLAYSTRING
		Print(obj, "\n")
	else
		print(string)
	end
end

function DisplayString(obj)
	DEFAULTDISPLAYSTRING
end

function ViewObj(obj)
	string = ViewString(obj)
	if string !== DEFAULTVIEWSTRING
		print(string)
	else
		PrintObj(obj)
	end
end

function ViewString(obj)
	DEFAULTVIEWSTRING
end

function PrintObj(obj)
	print(PrintString(obj))
end

function PrintString(obj)
	StringGAP(obj)
end

@InstallMethod( StringGAP, [ IsObject ], obj -> "<object>" );

# booleans
@InstallMethod( StringGAP, [ IsBool ], bool -> string(bool) );

# integers
@InstallMethod( ViewString, [ IsInt ], n -> StringGAP( n ) );

@InstallMethod( ViewString, [ IsBigInt ], n -> StringGAP( n ) );

@InstallMethod( StringGAP, [ IsInt ], n -> string(n) );

@InstallMethod( StringGAP, [ IsBigInt ], n -> string(n) );

# characters
@InstallMethod( ViewString, [ IsChar ], c -> string("'", c, "'") );

@InstallMethod( StringGAP, [ IsChar ], c -> string("'", c, "'") );

# strings
function Display(s::String)
	print(s, "\n")
end

function DisplayString(s::String)
	string(s, "\n")
end

function ViewObj(s::String)
	print("\"", s, "\"")
end

function ViewString(s::String)
	string("\"", s, "\"")
end

function PrintObj(s::String)
	print("\"", s, "\"")
end

@InstallMethod( StringGAP, [ IsString ], s -> s );

# lists
function ViewObj(list::Vector)
	print("[ ")
	for i in 1:length(list)
		ViewObj(list[i])
		if i < length(list)
			print(", ")
		end
	end
	ViewObj(last(list))
	print(" ]")
end

function ViewString(list::Vector)
	string("[ ", join(map(x -> ViewString(x), list), ", "), " ]")
end

function PrintObj(list::Vector)
	print("[ ")
	for i in 1:length(list)
		PrintObj(list[i])
		if i < length(list)
			print(", ")
		end
	end
	print(" ]")
end

function QuotedStringGAP(x::Any)
	StringGAP(x)
end

function QuotedStringGAP(x::String)
	string("\"", x, "\"")
end

# we cannot use @InstallMethod because we distinguish between vectors and ranges
function (::typeof(StringGAP))(list::Vector)
	string("[ ", join(map(x -> QuotedStringGAP(x), list), ", "), " ]")
end

# ranges
function DisplayString(range::UnitRange)
	StringGAP(range)
end

function ViewString(range::UnitRange)
	StringGAP(range)
end

# we cannot use @InstallMethod because we distinguish between vectors and ranges
function (::typeof(StringGAP))(range::UnitRange)
	if range.stop < range.start
		string("[  ]")
	elseif range.stop == range.start
		string("[ ", range.stop, " ]")
	else
		string("[ ", range.start, " .. ", range.stop, " ]")
	end
end

# functions (incomplete)
function Display(func::Function)
	display(func)
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
function DeclareGlobalVariable( name )
	# noop
end

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
	esc(:(@InstallMethod($name, nothing, $func)))
end

export @InstallGlobalFunction

# global names
function DeclareGlobalName( name )
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

function ValueOption( name )
	# we can safely return fail since there is no way to set an option anyway
	fail
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
			print("#I  ", $(args...), "\n")
		end
	end)
end

export @Info

# GAP functions
function IsDigitChar(x::Char)
	x in "0123456789"
end

function (::typeof(StringGAP))(obj, length)
	if length >= 0
		lpad(StringGAP(obj), length)
	else
		rpad(StringGAP(obj), -length)
	end
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

function Perform( list, func )
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

@DeclareAttribute( "Length", IsAttributeStoringRep )

@InstallMethod( Length, [ IsList ], length );
@InstallMethod( Length, [ IsString ], length );

@DeclareAttribute("IntGAP", IsAttributeStoringRep)

function (::typeof(IntGAP))(string::String)
	parse(Int, string)
end

function (::typeof(IntGAP))(float::Float64)
	Int(floor(float))
end

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

global const ShallowCopy = copy
global const StructuralCopy = deepcopy

global const Reversed = reverse

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

global const LowercaseString = lowercase

function StartsWith(string::String, substring::String)
	startswith(string, substring)
end

function StartsWith(list::Vector, sublist::Vector)
	Length(list) >= Length(sublist) && ForAll(1:Length(sublist), i -> list[i] == sublist[i])
end

function EndsWith(string::String, substring::String)
	endswith(string, substring)
end

global const SortedList = sort
global const AsSortedList = sort

function IsPackageMarkedForLoading( name, version )
	if name == "JuliaInterface"
		return false
	end
	if name == "json"
		return true
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

global const IdFunc = identity

global const Append = append!

function CallFuncList( func::Function, list )
	func(list...)
end

global const IsEmpty = isempty

function NameFunction(attr::Attribute)
	attr.name
end

function NameFunction(f::Function)
	string(f)
end

function SetNameFunction(f, name)
	# noop
end

global const IsIdenticalObj = ===

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

global const TextAttr = rec(; f0 = "\033[30m", f1 = "\033[31m", f2 = "\033[32m", f3 = "\033[33m", f4 = "\033[34m", f5 = "\033[35m", f6 = "\033[36m", f7 = "\033[37m", CSI = "\033[", b0 = "\033[40m", b1 = "\033[41m", b2 = "\033[42m", b3 = "\033[43m", b4 = "\033[44m", b5 = "\033[45m", b6 = "\033[46m", b7 = "\033[47m", blink = "\033[5m", bold = "\033[1m", delline = "\033[2K", home = "\033[1G", normal = "\033[22m", reset = "\033[0m", reverse = "\033[7m", underscore = "\033[4m" )

function FLAGS_FILTER(filter)
	filter
end

function WITH_IMPS_FLAGS(filter)
	filter
end

function IS_SUBSET_FLAGS( filter1, filter2 )
	filter1.abstract_type <: filter2.abstract_type
end

function StableSortBy( list, func )
	sort!(list, alg=Base.Sort.MergeSort, by=func)
end

function Maximum(int1::Union{Int, BigInt}, int2::Union{Int, BigInt})
	max(int1, int2)
end

global const infinity = Inf

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
	symbol = Symbol("init_", string(__module__))
	if isdefined(__module__, symbol)
		esc(:($symbol()))
	else
		nothing
	end
end

export @init_CAP_package

# CAP state

function SAVE_CAP_STATE()
	derivations_by_target = @rec()
	for recname in RecNames( CAP_INTERNAL_DERIVATION_GRAPH.derivations_by_target )
		derivations_by_target[recname] = ShallowCopy( CAP_INTERNAL_DERIVATION_GRAPH.derivations_by_target[recname] )
	end
	
	derivations_by_used_ops = @rec()
	for recname in RecNames( CAP_INTERNAL_DERIVATION_GRAPH.derivations_by_used_ops )
		derivations_by_used_ops[recname] = ShallowCopy( CAP_INTERNAL_DERIVATION_GRAPH.derivations_by_used_ops[recname] )
	end
	
	state = (
		CAP_INTERNAL_METHOD_NAME_RECORD = ShallowCopy( CAP_INTERNAL_METHOD_NAME_RECORD ),
		CAP_INTERNAL_METHOD_NAME_RECORDS_BY_PACKAGE = ShallowCopy( CAP_INTERNAL_METHOD_NAME_RECORDS_BY_PACKAGE ),
		CAP_INTERNAL_CATEGORICAL_PROPERTIES_LIST = ShallowCopy( CAP_INTERNAL_CATEGORICAL_PROPERTIES_LIST ),
		CAP_INTERNAL_CONSTRUCTIVE_CATEGORIES_RECORD = ShallowCopy( CAP_INTERNAL_CONSTRUCTIVE_CATEGORIES_RECORD ),
		CAP_INTERNAL_DERIVATION_GRAPH_operations = ShallowCopy( Operations( CAP_INTERNAL_DERIVATION_GRAPH ) ),
		CAP_INTERNAL_DERIVATION_GRAPH_derivations_by_target = derivations_by_target,
		CAP_INTERNAL_DERIVATION_GRAPH_derivations_by_used_ops = derivations_by_used_ops,
		CAP_INTERNAL_FINAL_DERIVATION_LIST = ShallowCopy( CAP_INTERNAL_FINAL_DERIVATION_LIST )
	)
end

function RESTORE_CAP_STATE(state)
	##
	for recname in RecNames( state.CAP_INTERNAL_METHOD_NAME_RECORD )
		
		if !(@IsBound( CAP_INTERNAL_METHOD_NAME_RECORD[recname] ))
			
			CAP_INTERNAL_METHOD_NAME_RECORD[recname] = state.CAP_INTERNAL_METHOD_NAME_RECORD[recname];
			
		end
		
	end
	
	##
	for recname in RecNames( state.CAP_INTERNAL_METHOD_NAME_RECORDS_BY_PACKAGE )
		
		if !(@IsBound( CAP_INTERNAL_METHOD_NAME_RECORDS_BY_PACKAGE[recname] ))
			
			CAP_INTERNAL_METHOD_NAME_RECORDS_BY_PACKAGE[recname] = state.CAP_INTERNAL_METHOD_NAME_RECORDS_BY_PACKAGE[recname];
			
		end
		
	end
	
	##
	for pair in state.CAP_INTERNAL_CATEGORICAL_PROPERTIES_LIST
		
		if !(pair in CAP_INTERNAL_CATEGORICAL_PROPERTIES_LIST )
			
			Add( CAP_INTERNAL_CATEGORICAL_PROPERTIES_LIST, pair );
			
		end
		
	end
	
	##
	for recname in RecNames( state.CAP_INTERNAL_CONSTRUCTIVE_CATEGORIES_RECORD )
		
		if !(@IsBound( CAP_INTERNAL_CONSTRUCTIVE_CATEGORIES_RECORD[recname] ))
			
			CAP_INTERNAL_CONSTRUCTIVE_CATEGORIES_RECORD[recname] = state.CAP_INTERNAL_CONSTRUCTIVE_CATEGORIES_RECORD[recname];
			
		end
		
	end
	
	##
	for operation in state.CAP_INTERNAL_DERIVATION_GRAPH_operations
		
		if !(operation in Operations( CAP_INTERNAL_DERIVATION_GRAPH ) )
			
			Add( Operations( CAP_INTERNAL_DERIVATION_GRAPH ), operation );
			
		end
		
	end
	
	##
	for recname in RecNames( state.CAP_INTERNAL_DERIVATION_GRAPH_derivations_by_target )
		
		if @IsBound( CAP_INTERNAL_DERIVATION_GRAPH.derivations_by_target[recname] )
			
			for derivation in state.CAP_INTERNAL_DERIVATION_GRAPH_derivations_by_target[recname]
				
				if !ForAny( CAP_INTERNAL_DERIVATION_GRAPH.derivations_by_target[recname], x -> x === derivation )
					
					Add( CAP_INTERNAL_DERIVATION_GRAPH.derivations_by_target[recname], derivation );
					
				end
				
			end
			
		else
			
			CAP_INTERNAL_DERIVATION_GRAPH.derivations_by_target[recname] = ShallowCopy( state.CAP_INTERNAL_DERIVATION_GRAPH_derivations_by_target[recname] )
			
		end
		
	end
	
	##
	for recname in RecNames( state.CAP_INTERNAL_DERIVATION_GRAPH_derivations_by_used_ops )
		
		if @IsBound( CAP_INTERNAL_DERIVATION_GRAPH.derivations_by_used_ops[recname] )
			
			for derivation in state.CAP_INTERNAL_DERIVATION_GRAPH_derivations_by_used_ops[recname]
				
				if !ForAny( CAP_INTERNAL_DERIVATION_GRAPH.derivations_by_used_ops[recname], x -> x === derivation )
					
					Add( CAP_INTERNAL_DERIVATION_GRAPH.derivations_by_used_ops[recname], derivation );
					
				end
				
			end
			
		else
			
			CAP_INTERNAL_DERIVATION_GRAPH.derivations_by_used_ops[recname] = ShallowCopy( state.CAP_INTERNAL_DERIVATION_GRAPH_derivations_by_used_ops[recname] )
			
		end
		
	end
	
	##
	for derivation in state.CAP_INTERNAL_FINAL_DERIVATION_LIST
		
		if !ForAny( CAP_INTERNAL_FINAL_DERIVATION_LIST, x -> x === derivation )
			
			Add( CAP_INTERNAL_FINAL_DERIVATION_LIST, derivation );
			
		end
		
	end
end

macro IMPORT_CAP_OPERATIONS()
	if !IsBoundGlobal( "CAP_INTERNAL_METHOD_NAME_RECORDS_BY_PACKAGE" )
		return nothing
	end
	
	imports = Concatenation( List(
		RecNames( CAP_INTERNAL_METHOD_NAME_RECORDS_BY_PACKAGE ),
		function ( package )
			
			if isdefined(__module__, Symbol(package))
				
				return List(
					RecNames( CAP_INTERNAL_METHOD_NAME_RECORDS_BY_PACKAGE[package] ),
					function ( recname )
						
						operation = ValueGlobal( CAP_INTERNAL_METHOD_NAME_RECORD[recname].installation_name )
						
						if IsAttribute( operation )
							
							:(import $(Symbol(package)).$(Symbol(CAP_INTERNAL_METHOD_NAME_RECORD[recname].installation_name, "_OPERATION")))
							
						else
							
							:(import $(Symbol(package)).$(Symbol(CAP_INTERNAL_METHOD_NAME_RECORD[recname].installation_name)))
						
						end
						
					end
				);
				
			else
				
				return [ ];
				
			end
			
		end
	) )
	
	esc(quote
		$(imports...)
	end)
end

export @IMPORT_CAP_OPERATIONS
