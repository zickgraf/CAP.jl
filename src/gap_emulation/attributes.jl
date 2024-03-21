abstract type AttributeStoringRep <: CAPDict end
global const IsAttributeStoringRep = Filter("IsAttributeStoringRep", AttributeStoringRep)

abstract type Attribute <: Function end

function ==(attr1::Attribute, attr2::Attribute)
	isequal(attr1.name, attr2.name)
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
	symbol_setter = Symbol("Set", name)
	type_symbol = Symbol("TheJuliaAttributeType", name)
	esc(quote
		function $symbol_op end
		
		function $symbol_tester(obj::AttributeStoringRep)
			dict = getfield(obj, :dict)
			haskey(dict, Symbol($name))
		end
		CAP_precompile($symbol_tester, (AttributeStoringRep, ))
		
		function $symbol_setter(obj::AttributeStoringRep, value)
			dict = getfield(obj, :dict)
			dict[Symbol($name)] = value
			if IsProperty( $symbol ) && value === true
				for implied_property in $symbol.implied_properties
					Setter(implied_property)(obj, true)
				end
			end
		end
		CAP_precompile($symbol_setter, (AttributeStoringRep, Any))
		
		mutable struct $type_symbol <: Attribute
			name::String
			operation::Function
			tester::Function
			setter::Function
			is_property::Bool
			implied_properties::Vector{Attribute}
		end
		
		global const $symbol = $type_symbol($name, $symbol_op, $symbol_tester, $symbol_setter, $is_property, [])
		
		function (::$type_symbol)(obj::IsAttributeStoringRep.abstract_type; kwargs...)
			if !$symbol_tester(obj)
				$symbol_setter(obj, $symbol_op(obj; kwargs...))
			end
			dict = getfield(obj, :dict)
			dict[Symbol($name)]
		end
	end)
end

macro DeclareAttribute(name::String, parent_filter, mutability = missing)
	declare_attribute_or_property(__module__, name, false)
end

export @DeclareAttribute

function IsAttribute( obj )
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

function IsProperty( obj )
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

@DeclareAttribute( "StringGAP", IsObject );
global const StringMutable = StringGAP

function (::typeof(StringGAP))(attr::Attribute)
	string("<Attribute \"", attr.name, "\">")
end
