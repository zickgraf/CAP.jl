using JSON3

# JSON -> record

function json_object_to_GAP_record(obj::JSON3.Object)
	dict = Dict{Symbol,Any}()
	for key in keys(obj)
		dict[key] = json_object_to_GAP_record(obj[key])
	end
	CAPRecord(dict)
end

function json_object_to_GAP_record(obj::JSON3.Array)
	list = []
	for i in 1:length(obj)
		push!(list, json_object_to_GAP_record(obj[i]))
	end
	list
end

function json_object_to_GAP_record(obj::Union{Bool, Int64, Float64, String})
	obj
end

function JsonStringToGap(string)
	json_object_to_GAP_record(JSON3.read(string))
end

# record -> JSON

function GAP_record_to_dict(obj::CAPRecord)
	dict = Dict{Symbol,Any}()
	for key in RecNames(obj)
		dict[Symbol(key)] = GAP_record_to_dict(obj[key])
	end
	dict
end

function GAP_record_to_dict(obj::Union{Vector, UnitRange, StepRange})
	list = []
	for i in 1:length(obj)
		push!(list, GAP_record_to_dict(obj[i]))
	end
	list
end

function GAP_record_to_dict(obj::Union{Bool, Int64, Float64, String})
	obj
end

function GapToJsonString(obj)
	JSON3.write(GAP_record_to_dict(obj))
end
