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
	abstract_type_symbol = Symbol("TheJuliaAbstractType", name)
	concrete_type_symbol = Symbol("TheJuliaConcreteType", name)
	# all our macros are meant to fully execute in the context where the macro is called -> always fully escape them
	esc(quote
		@assert $parent_filter.subtypable
		abstract type $abstract_type_symbol <: $parent_filter.abstract_type end
		struct $concrete_type_symbol{T} <: $abstract_type_symbol
			dict::Dict
		end
		global const $filter_symbol = Filter($name, $abstract_type_symbol, $concrete_type_symbol, true)
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

global const NewCategory = NewFilter
