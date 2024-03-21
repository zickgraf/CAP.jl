macro DeclareOperation(name::String, filter_list = [])
	# prevent attributes from being redefined as operations
	if isdefined(__module__, Symbol(name))
		return nothing
	end
	symbol = Symbol(name)
	esc(quote
		function $symbol end
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

macro InstallMethod(operation::Symbol, description::String, filter_list, func)
	esc(:(@InstallMethod($operation, $filter_list, $func)))
end

macro InstallMethod(operation::Symbol, filter_list, func)
	if operation === :ViewObj
		println("ignoring installation for ViewObj, use ViewString instead")
		return
	elseif operation === :Display
		println("ignoring installation for Display, use DisplayString instead")
		return
	elseif operation === :Iterator
		println("ignoring installation for Iterator, install iterator in Julia instead")
		return
	end
	
	@assert filter_list === :nothing || (filter_list isa Expr && filter_list.head === :vect)
	
	if !(func isa Expr)
		if filter_list === :nothing
			func = :((args...) -> $func(args...))
		else
			vars = Vector{Any}(map(i -> Symbol("arg", i), 1:length(filter_list.args)))
			func = :(($(vars...),) -> $func($(vars...),))
		end
	end
	
	if func.head === :macrocall
		func = macroexpand(__module__, func; recursive = false)
	end
	
	if func.head === :->
		func.head = :function
		if func.args[1] isa Symbol
			func.args[1] = Expr(:tuple, func.args[1])
		end
	end
	
	@assert func.head === :function
	
	is_attribute = IsBoundGlobal( string(operation) ) && IsAttribute( ValueGlobal( string(operation) ) )
	
	if is_attribute
		@assert filter_list !== :nothing
		@assert isempty(filter_list.args) || filter_list.args[1] isa Symbol
		
		attr = ValueGlobal( string(operation) )
		
		if length(filter_list.args) === 1 && ValueGlobal( string(filter_list.args[1]) ).abstract_type <: IsAttributeStoringRep.abstract_type
			callable = Symbol(attr.operation)
			operation_to_precompile = callable
		else
			callable = :(::typeof($operation))
			operation_to_precompile = operation
		end
	else
		callable = operation
		operation_to_precompile = callable
	end
	
	if func.args[1].head === :tuple
		func.args[1] = Expr(:call, callable, func.args[1].args...)
	elseif func.args[1].head === :...
		@assert filter_list === :nothing # InstallMethod in GAP cannot be used for functions with varargs
		func.args[1] = Expr(:call, callable, func.args[1])
	else
		error("unsupported head: ", func.args[1].head)
	end
	
	is_kwarg = length(func.args[1].args) >= 2 && func.args[1].args[2] isa Expr && func.args[1].args[2].head === :parameters
	
	if filter_list !== :nothing
		if is_kwarg
			offset = 2
		else
			offset = 1
		end
		
		types = map(x -> Expr(:., x, :(:abstract_type)), filter_list.args)
		
		@assert length(filter_list.args) == length(func.args[1].args) - offset
		for i in 1:length(filter_list.args)
			func.args[1].args[i + offset] = Expr(:(::), func.args[1].args[i + offset], types[i])
		end
	end
	
	block = quote
		$func
	end
	
	if filter_list !== :nothing
		push!(block.args, :(CAP_precompile($operation_to_precompile, ($(types...),))))
	end
	
	esc(block)
end

export @InstallMethod

function InstallMethod(operation, filter_list, func)
	InstallMethod(last(ModulesForEvaluationStack), operation, filter_list, func)
end

function InstallMethod(mod::Module, operation::Function, filter_list, func::Function)
	if Symbol(operation) === :ViewObj
		println("ignoring installation for ViewObj, use ViewString instead")
		return
	elseif Symbol(operation) === :Display
		println("ignoring installation for Display, use DisplayString instead")
		return
	elseif Symbol(operation) === :Iterator
		println("ignoring installation for Iterator, install iterate in Julia instead")
		return
	end
	
	nargs = length(filter_list)
	vars = Vector{Any}(map(i -> Symbol("arg", i), 1:nargs))
	types = map(filter -> filter.abstract_type, filter_list)
	vars_with_types = map(function(i)
		arg_symbol = vars[i]
		type = types[i]
		:($arg_symbol::$type)
	end, 1:length(filter_list))
	if IsAttribute( operation )
		if length(filter_list) === 1 && filter_list[1].abstract_type <: IsAttributeStoringRep.abstract_type
			funcref = Symbol(operation.operation)
			operation_to_precompile = funcref
		else
			funcref = :(::typeof($(Symbol(operation.name))))
			operation_to_precompile = Symbol(operation.name)
		end
	else
		funcref = Symbol(operation)
		operation_to_precompile = funcref
	end
	
	if funcref isa Symbol && !isdefined(mod, funcref)
		print("WARNING: installing method in module ", mod, " for undefined symbol ", funcref, "\n")
	end
	
	is_kwarg = any(m -> !isempty(Base.kwarg_decl(m)), methods(func))
	
	if is_kwarg
		Base.eval(mod, :(
			function $funcref($(vars_with_types...); kwargs...)
				$func($(vars...); kwargs...)
			end
		))
	else
		Base.eval(mod, :(
			function $funcref($(vars_with_types...))
				$func($(vars...))
			end
		))
	end
	
	if funcref isa Symbol
		Base.eval(mod, :(export $funcref))
	end
	
	Base.eval(mod, :(CAP_precompile($operation_to_precompile,($(types...),))))
end

function InstallMethod(operation, description::String, filter_list, func)
	InstallMethod(operation, filter_list, func)
end

function InstallMethod(mod, operation, description::String, filter_list, func)
	InstallMethod(mod, operation, filter_list, func)
end

global const InstallOtherMethod = InstallMethod
function InstallMethodWithCacheFromObject( operation, filter_list, func; ArgumentNumber = 1 )
	InstallMethod( operation, filter_list, func )
end
function InstallMethodWithCache( operation, filter_list, func; InstallMethod = InstallMethod, Cache = "cache" )
	InstallMethod( operation, filter_list, func )
end
function InstallMethodWithCache( operation, description, filter_list, func; InstallMethod = InstallMethod, Cache = "cache" )
	InstallMethod( operation, filter_list, func )
end
global const InstallMethodWithCrispCache = InstallMethod
