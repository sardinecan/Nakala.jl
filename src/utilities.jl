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
  #==
function contains_key_value(d::Dict, key::Union{String, Symbol}, value::String)
  if isa(key, String)
    return check_key_value(d, key, value) || check_key_value(d, Symbol(key), value)
  elseif isa(key, Symbol)
    return check_key_value(d, key) || check_key_value(d, string(key))
  else
    return false
  end
end
export contains_key_value

function check_key_value(d::Dict, key::Union{String, Symbol}, value::String)
  return haskey(d, key) && d[key] == value
end
==#
end # end module
