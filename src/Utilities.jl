module Utilities

"""
  contains_key_value(d::Dict, key::Union{String, Symbol}, value::String)

Vérifie qu'un dictionnaire (`d`) dispose d'une clé `key` dont la valeur est `value`. La casse de la clé est ignorée, de même que son type (`string` ou `symbol`).

# Exemple
```julia-repl
julia> d = Dict(
  :Accept => "application/json"
)
Dict{Symbol, String} with 1 entry:
  :Accept => "application/json"

julia> key, value = "accept", "application/json"
("accept", "application/json")

julia> contains_key_value(d, key, value)
true
```
"""
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

d = Dict(
  :Accept => "application/json"
)

key, value = "accept", "application/json"

contains_key_value(d, key, value)

end # end module
