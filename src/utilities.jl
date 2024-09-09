module Utilities

function contains_key_value(d::Dict, key::Union{String, Symbol}, value::String)
  key_lower = lowercase(string(key))

  for k in keys(d)
    if lowercase(string(k)) == key_lower
      return d[k] == value
    end
  end

  return false
end
export contains_key_value



function getdatas_resume(datas::Vector{Any})
  list = Vector()
  for data in datas
    identifier = get(data, "identifier", "")
    metas = get(data, "metas", "")
    title = filter(x -> get(x, "propertyUri", "") == "http://nakala.fr/terms#title", metas)[1]
    item = Dict(get(title, "value", "noTitle") => identifier)
    push!(list, item)
  end

  return list
end
export getdatas_resume

end # end module
