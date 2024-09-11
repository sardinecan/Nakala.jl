module Collections
using HTTP, JSON

"""
    getcollections(identifier::String, headers::Dict; apitest::Bool=false)

Récupère les informations de la collection désignée par `identifier`.

# exemple
```julia-repl
julia> getcollections(identifier, headers, apitest=true)
Dict{String, Any} with 3 entries:
  "body"      => Dict{String, Any}("haveAccessibleData"=>false, "websitePrefix"=>"", "isDepositor"=>true, "isOwner"=>true, "depositor"=>Dic…
  "status"    => 200
  "isSuccess" => true
```
"""
function getcollections(identifier::String, headers::Dict; apitest::Bool=false)
  apitest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "collections", identifier)
  try
    # Envoi de la requête
    response = HTTP.request("get", url, headers)
    responsestatus = HTTP.status(response)
    responsebody = JSON.parse(String(HTTP.payload(response)))
    return Dict(
      "isSuccess" => true,
      "status" => responsestatus,
      "body" => responsebody
    )
  catch e
    # Gestion spécifique des erreurs HTTP
    if isa(e, HTTP.ExceptionRequest.StatusError)
      return Dict(
        "isSuccess" => false,
        "status" => e.status,
        "body" => e.response
      )
    else
      # Gestion des autres types d'erreurs
      return Dict(
        "isSuccess" => false,
        "message" => "An unexpected error occurred: $(e)"
      )
    end
  end
end
export getcollections

"""
    putcollections(identifier::String, headers::Dict, body::Dict; apitest::Bool=false)

Modifie les informations de la collection désignée par `ìdentifier.

# exemple
```julia-repl
julia> body = Dict(
  :status => "public",
  :metas => [Dict(:value => "Test de postcollections", :propertyUri => "http://nakala.fr/terms#title", :lang => "fr", :typeUri => "http://www.w3.org/2001/XMLSchema#string"),],
  :datas => [],
  :rights => []
)
Dict{Symbol, Any} with 4 entries:
  :status => "public"
  :datas  => Any[]
  :rights => Any[]
  :metas  => [Dict(:value=>"Test de putcollections", :propertyUri=>"http://nakala.fr/terms#title", :lang=>"en", :typeUri=>"http://www.w3.org/2001/XMLSchema#string")]

julia> Nakala.Collections.putcollections(identifier, headers, body, apitest=true)
Dict{String, Any} with 3 entries:
  "body"      => Dict{String, Any}("message"=>"Collection created", "payload"=>Dict{String, Any}("id"=>"10.34847/nkl.542485b0"), "code"=>201)
  "status"    => 201
  "isSuccess" => true
```
"""
function putcollections(identifier::String, headers::Dict, body::Dict; apitest::Bool=false)
  apitest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "collections", identifier)
  try
    # Envoi de la requête
    response = HTTP.request("PUT", url, headers, JSON.json(body))
    response_status = HTTP.status(response)
    return Dict(
      "isSuccess" => true,
      "status" => response_status,
      "body" => ""
    )
  catch e
    # Gestion spécifique des erreurs HTTP
    if isa(e, HTTP.ExceptionRequest.StatusError)
      return Dict(
        "isSuccess" => false,
        "status" => e.status,
        "body" => ""
      )
    else
      # Gestion des autres types d'erreurs
      return Dict(
        "isSuccess" => false,
        "message" => "An unexpected error occurred: $(e)"
      )
    end
  end
end
export putcollections


"""
    deletecollections(identifier::String, headers::Dict; apitest::Bool=false)

Supprime la collection désignée par `ìdentifier`.

# exemple
```julia-repl
julia> Nakala.Collections.deletecollections(identifier, headers, apitest=true)
Dict{String, Any} with 3 entries:
  "body"      => ""
  "status"    => 204
  "isSuccess" => true
```
"""
function deletecollections(identifier::String, headers::Dict; apitest::Bool=false)
  apitest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "collections", identifier)
  try
    # Envoi de la requête
    response = HTTP.request("DELETE", url, headers)
    response_status = HTTP.status(response)
    return Dict(
      "isSuccess" => true,
      "status" => response_status,
      "body" => ""
    )
  catch e
    # Gestion spécifique des erreurs HTTP
    if isa(e, HTTP.ExceptionRequest.StatusError)
      return Dict(
        "isSuccess" => false,
        "status" => e.status,
        "body" => ""
      )
    else
      # Gestion des autres types d'erreurs
      return Dict(
        "isSuccess" => false,
        "message" => "An unexpected error occurred: $(e)"
      )
    end
  end
end
export deletecollections


"""
    postcollections(headers::Dict, body::Dict; apitest::Bool=false)

Crée une nouvelle collection.

# exemple
```julia-repl
julia> headers = Dict(
  "X-API-KEY" => apikey,
  "Content-Type" => "application/json"
)

julia> body = Dict(
  :status => "public",
  :metas => [Dict(:value => "Collection", :propertyUri => "http://nakala.fr/terms#title", :lang => "fr", :typeUri => "http://www.w3.org/2001/XMLSchema#string"),],
  :datas => [],
  :rights => []
)

julia> Nakala.Collections.postcollections(headers, body, apitest=true)
Dict{String, Any} with 3 entries:
  "body"      => Dict{String, Any}("message"=>"Collection created", "payload"=>Dict{String, Any}("id"=>"10.34847/nkl.e73a86ab"), "code"=>201)
  "status"    => 201
  "isSuccess" => true
```
"""
function postcollections(headers::Dict, body::Dict; apitest::Bool=false)
  apitest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "collections")
  try
    # Envoi de la requête
    response = HTTP.request("post", url, headers, JSON.json(body))
    response_status = HTTP.status(response)
    response_body = JSON.parse(String(HTTP.payload(response)))
    return Dict(
      "isSuccess" => true,
      "status" => response_status,
      "body" => response_body
    )
  catch e
    # Gestion spécifique des erreurs HTTP
    if isa(e, HTTP.ExceptionRequest.StatusError)
      return Dict(
        "isSuccess" => false,
        "status" => e.status,
        "body" => e.response
      )
    else
      # Gestion des autres types d'erreurs
      return Dict(
        "isSuccess" => false,
        "message" => "An unexpected error occurred: $(e)"
      )
    end
  end
end
export postcollections


"""
    getcollections_datas(identifier::String, params::Array, headers::Dict; apitest::Bool=false)

Récupère la liste paginée des données contenues dans la collection désignée par `ìdentifier`.

# exemple
```julia-repl
julia> params = [ :page => 1, :limit => 10 ]

julia> Nakala.Collections.getcollections_datas(identifier, params, headers, apitest=true)
Dict{String, Any} with 3 entries:
  "body"      => Dict{String, Any}("currentPage"=>1, "lastPage"=>1, "total"=>1, "data"=>Any[Dict{String, Any}("uri"=>"https://doi.org/10.34847/nkl.bcdblt35", "status"=…
  "status"    => 200
  "isSuccess" => true
```
"""
function getcollections_datas(identifier::String, params::Array, headers::Dict; apitest::Bool=false)
  apitest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "collections", identifier, "datas?") * HTTP.URIs.escapeuri(params)
  try
    # Envoi de la requête
    response = HTTP.request("get", url, headers)
    response_status = HTTP.status(response)
    response_body = JSON.parse(String(HTTP.payload(response)))
    return Dict(
      "isSuccess" => true,
      "status" => response_status,
      "body" => response_body
    )
  catch e
    # Gestion spécifique des erreurs HTTP
    if isa(e, HTTP.ExceptionRequest.StatusError)
      return Dict(
        "isSuccess" => false,
        "status" => e.status,
        "body" => e.response
      )
    else
      # Gestion des autres types d'erreurs
      return Dict(
        "isSuccess" => false,
        "message" => "An unexpected error occurred: $(e)"
      )
    end
  end
end
export getcollections_datas


"""
    postcollections_datas(identifier::String, headers::Dict, body::Array; apitest::Bool=false)

Ajoute une liste de données à la collection désignée par `identifier`.

# exemple
```julia-repl
julia> body = [ data_identifier ]
1-element Vector{String}:
  "10.34847/nkl.bcdblt35"

julia> Nakala.Collections.postcollections_datas(identifier, headers, body, apitest=true)
Dict{String, Any} with 3 entries:
  "body"      => Dict{String, Any}("message"=>"Data added in the collection", "code"=>201)
  "status"    => 201
  "isSuccess" => true
```
"""
function postcollections_datas(identifier::String, headers::Dict, body::Array; apitest::Bool=false)
  apitest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "collections", identifier, "datas")
  try
    # Envoi de la requête
    response = HTTP.request("post", url, headers, JSON.json(body))
    response_status = HTTP.status(response)
    response_body = JSON.parse(String(HTTP.payload(response)))
    return Dict(
      "isSuccess" => true,
      "status" => response_status,
      "body" => response_body
    )
  catch e
    # Gestion spécifique des erreurs HTTP
    if isa(e, HTTP.ExceptionRequest.StatusError)
      return Dict(
        "isSuccess" => false,
        "status" => e.status,
        "body" => e.response
      )
    else
      # Gestion des autres types d'erreurs
      return Dict(
        "isSuccess" => false,
        "message" => "An unexpected error occurred: $(e)"
      )
    end
  end
end
export postcollections_datas

"""
    deletecollections_datas(identifier::String, headers::Dict, body::Array; apitest::Bool=false)

Supprime une liste de données de la collection désignée par `identifier`.

# exemple
```julia-repl
julia> body = [ data_identifier ]
1-element Vector{String}:
  "10.34847/nkl.bcdblt35"

julia> Nakala.Collections.deletecollections_datas(identifier, headers, body, apitest=true)
Dict{String, Any} with 3 entries:
  "body"      => Dict{String, Any}("message"=>"Data removed form the collection", "code"=>200)
  "status"    => 200
  "isSuccess" => true
```
"""
function deletecollections_datas(identifier::String, headers::Dict, body::Array; apitest::Bool=false)
  apitest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "collections", identifier, "datas")
  try
    # Envoi de la requête
    response = HTTP.request("delete", url, headers, JSON.json(body))
    response_status = HTTP.status(response)
    response_body = JSON.parse(String(HTTP.payload(response)))
    return Dict(
      "isSuccess" => true,
      "status" => response_status,
      "body" => response_body
    )
  catch e
    # Gestion spécifique des erreurs HTTP
    if isa(e, HTTP.ExceptionRequest.StatusError)
      return Dict(
        "isSuccess" => false,
        "status" => e.status,
        "body" => e.response
      )
    else
      # Gestion des autres types d'erreurs
      return Dict(
        "isSuccess" => false,
        "message" => "An unexpected error occurred: $(e)"
      )
    end
  end
end
export deletecollections_datas


"""
    getcollections_metadatas(identifier::String, headers::Dict; apitest::Bool=false)

Récupère les métadonnées de la collection désignée par `identifier`.

# exemple
```julia-repl
julia> Nakala.Collections.getcollections_metadatas(identifier, headers, apitest=true)
Dict{String, Any} with 3 entries:
  "body"      => Any[Dict{String, Any}("typeUri"=>nothing, "propertyUri"=>"http://nakala.fr/terms#title", "lang"=>"fr", "value"=>"Ma collection")]
  "status"    => 200
  "isSuccess" => true
```
"""
function getcollections_metadatas(identifier::String, headers::Dict; apitest::Bool=false)
  apitest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "collections", identifier, "metadatas")
  try
    # Envoi de la requête
    response = HTTP.request("get", url, headers)
    response_status = HTTP.status(response)
    response_body = JSON.parse(String(HTTP.payload(response)))
    return Dict(
      "isSuccess" => true,
      "status" => response_status,
      "body" => response_body
    )
  catch e
    # Gestion spécifique des erreurs HTTP
    if isa(e, HTTP.ExceptionRequest.StatusError)
      return Dict(
        "isSuccess" => false,
        "status" => e.status,
        "body" => e.response
      )
    else
      # Gestion des autres types d'erreurs
      return Dict(
        "isSuccess" => false,
        "message" => "An unexpected error occurred: $(e)"
      )
    end
  end
end
export getcollections_metadatas


"""
    postcollections_metadatas(identifier::String, headers::Dict, body::Dict; apitest::Bool=false)

Ajoute nouvelle métadonnée à la collection désignée par `identifier`.

# exemple
```julia-repl
julia> body = Dict(:value => "My collection", :propertyUri => "http://nakala.fr/terms#title", :lang => "en", :typeUri => "http://www.w3.org/2001/XMLSchema#string")
Dict{Symbol, String} with 4 entries:
  :value       => "My collection"
  :propertyUri => "http://nakala.fr/terms#title"
  :lang        => "en"
  :typeUri     => "http://www.w3.org/2001/XMLSchema#string"

julia> Nakala.Collections.postcollections_metadatas(identifier, headers, body, apitest=true)
Dict{String, Any} with 3 entries:
  "body"      => Dict{String, Any}("message"=>"1", "code"=>201)
  "status"    => 201
  "isSuccess" => true
```
"""
function postcollections_metadatas(identifier::String, headers::Dict, body::Dict; apitest::Bool=false)
  apitest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "collections", identifier, "metadatas")
  try
    # Envoi de la requête
    response = HTTP.request("post", url, headers, JSON.json(body))
    response_status = HTTP.status(response)
    response_body = JSON.parse(String(HTTP.payload(response)))
    return Dict(
      "isSuccess" => true,
      "status" => response_status,
      "body" => response_body
    )
  catch e
    # Gestion spécifique des erreurs HTTP
    if isa(e, HTTP.ExceptionRequest.StatusError)
      return Dict(
        "isSuccess" => false,
        "status" => e.status,
        "body" => e.response
      )
    else
      # Gestion des autres types d'erreurs
      return Dict(
        "isSuccess" => false,
        "message" => "An unexpected error occurred: $(e)"
      )
    end
  end
end
export postcollections_metadatas


"""
    deletecollections_metadatas(identifier::String, headers::Dict, body::Dict; apitest::Bool=false)

Supprime des métadonnées de la collection désignée par `identifier`.

# exemple
```julia-repl
julia> body = Dict(:value => "My collection", :propertyUri => "http://nakala.fr/terms#title", :lang => "en", :typeUri => "http://www.w3.org/2001/XMLSchema#string")
Dict{Symbol, String} with 4 entries:
  :value       => "My collection"
  :propertyUri => "http://nakala.fr/terms#title"
  :lang        => "en"
  :typeUri     => "http://www.w3.org/2001/XMLSchema#string"

julia> Nakala.Collections.deletecollections_metadatas(identifier, headers, body, apitest=true)
Dict{String, Any} with 3 entries:
  "body"      => ""
  "status"    => 200
  "isSuccess" => true
```
"""
function deletecollections_metadatas(identifier::String, headers::Dict, body::Dict; apitest::Bool=false)
  apitest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "collections", identifier, "metadatas")
  try
    # Envoi de la requête
    response = HTTP.request("delete", url, headers, JSON.json(body))
    response_status = HTTP.status(response)
    response_body = JSON.parse(String(HTTP.payload(response)))
    return Dict(
      "isSuccess" => true,
      "status" => response_status,
      "body" => response_body
    )
  catch e
    # Gestion spécifique des erreurs HTTP
    if isa(e, HTTP.ExceptionRequest.StatusError)
      return Dict(
        "isSuccess" => false,
        "status" => e.status,
        "body" => e.response
      )
    else
      # Gestion des autres types d'erreurs
      return Dict(
        "isSuccess" => false,
        "message" => "An unexpected error occurred: $(e)"
      )
    end
  end
end
export deletecollections_metadatas

"""
    getcollections_rights(identifier::String, headers::Dict; apitest::Bool=false)

Récupère les utilisateurs et les groupes ayant des droits sur la collection désignée par `identifier`.

# exemple
```julia-repl
julia> Nakala.Collections.getcollections_rights(identifier, headers, apitest=true)
Dict{String, Any} with 3 entries:
  "body"      => Any[Dict{String, Any}("role"=>"ROLE_DEPOSITOR", "name"=>"Test Nakala", "photo"=>"http://mynakala.photo", "id"=>"26cef362-5bef-11eb-99d1-5254000a365d",…
  "status"    => 200
  "isSuccess" => true
```
"""
function getcollections_rights(identifier::String, headers::Dict; apitest::Bool=false)
  apitest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "collections", identifier, "rights")
  try
    # Envoi de la requête
    response = HTTP.request("get", url, headers)
    response_status = HTTP.status(response)
    response_body = JSON.parse(String(HTTP.payload(response)))
    return Dict(
      "isSuccess" => true,
      "status" => response_status,
      "body" => response_body
    )
  catch e
    # Gestion spécifique des erreurs HTTP
    if isa(e, HTTP.ExceptionRequest.StatusError)
      return Dict(
        "isSuccess" => false,
        "status" => e.status,
        "body" => e.response
      )
    else
      # Gestion des autres types d'erreurs
      return Dict(
        "isSuccess" => false,
        "message" => "An unexpected error occurred: $(e)"
      )
    end
  end
end
export getcollections_rights


"""
    postcollections_rights(identifier::String, headers::Dict, body::Array; apitest::Bool=false)

Ajoute des droits sur la collection désignée par `identifier`.

# exemple
```julia-repl
julia> body = [ Dict( :id => "c7e9bb15-6b4e-4e09-b234-ae7b13ac1234", :role => "ROLE_READER" ) ]
1-element Vector{Dict{Symbol, String}}:
 Dict(:id => "c7e9bb15-6b4e-4e09-b234-ae7b13ac1f3b", :role => "ROLE_READER")

julia> Nakala.Collections.postcollections_rights(identifier, headers, body, apitest=true)
Dict{String, Any} with 3 entries:
  "body"      => Dict{String, Any}("message"=>"1 right added", "code"=>200)
  "status"    => 200
  "isSuccess" => true
```
"""
function postcollections_rights(identifier::String, headers::Dict, body::Array; apitest::Bool=false)
  apitest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "collections", identifier, "rights")
  try
    # Envoi de la requête
    response = HTTP.request("post", url, headers, JSON.json(body))
    response_status = HTTP.status(response)
    response_body = JSON.parse(String(HTTP.payload(response)))
    return Dict(
      "isSuccess" => true,
      "status" => response_status,
      "body" => response_body
    )
  catch e
    # Gestion spécifique des erreurs HTTP
    if isa(e, HTTP.ExceptionRequest.StatusError)
      return Dict(
        "isSuccess" => false,
        "status" => e.status,
        "body" => e.response
      )
    else
      # Gestion des autres types d'erreurs
      return Dict(
        "isSuccess" => false,
        "message" => "An unexpected error occurred: $(e)"
      )
    end
  end
end
export postcollections_rights


"""
    deletecollections_rights(identifier::String, headers::Dict, body::Dict; apitest::Bool=false)

Supprime les droits d'un utilisateur ou d'un groupe d'utilisateurs sur la collection désignée par `identifier`.

# exemple
```julia-repl
julia> body = Dict( :id => "c7e9bb15-6b4e-4e09-b234-ae7b13ac1f321", :role => "ROLE_READER" )
1-element Vector{Dict{Symbol, String}}:
 Dict(:id => "c7e9bb15-6b4e-4e09-b234-ae7b13ac1f321", :role => "ROLE_READER")

julia> Nakala.Collections.deletecollections_rights(identifier, headers, body, apitest=true)
Dict{String, Any} with 3 entries:
  "body"      => Dict{String, Any}("message"=>"1 right deleted", "code"=>200)
  "status"    => 200
  "isSuccess" => true
```
"""
function deletecollections_rights(identifier::String, headers::Dict, body::Dict; apitest::Bool=false)
  apitest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "collections", identifier, "rights")
  try
    # Envoi de la requête
    response = HTTP.request("delete", url, headers, JSON.json(body))
    response_status = HTTP.status(response)
    response_body = JSON.parse(String(HTTP.payload(response)))
    return Dict(
      "isSuccess" => true,
      "status" => response_status,
      "body" => response_body
    )
  catch e
    # Gestion spécifique des erreurs HTTP
    if isa(e, HTTP.ExceptionRequest.StatusError)
      return Dict(
        "isSuccess" => false,
        "status" => e.status,
        "body" => e.response
      )
    else
      # Gestion des autres types d'erreurs
      return Dict(
        "isSuccess" => false,
        "message" => "An unexpected error occurred: $(e)"
      )
    end
  end
end
export deletecollections_rights


"""
    getcollections_status(identifier::String, headers::Dict; apitest::Bool=false)

Récupère le statut de la collection désignée par `identifier`.

# exemple
```julia-repl
julia> Nakala.Collections.getcollections_status(identifier, headers)
Dict{String, Any} with 3 entries:
  "body"      => "private"
  "status"    => 200
  "isSuccess" => true
```
"""
function getcollections_status(identifier::String, headers::Dict; apitest::Bool=false)
  apitest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "collections", identifier, "status")
  try
    # Envoi de la requête
    response = HTTP.request("get", url, headers)
    response_status = HTTP.status(response)
    response_body = JSON.parse(String(HTTP.payload(response)))
    return Dict(
      "isSuccess" => true,
      "status" => response_status,
      "body" => response_body
    )
  catch e
    # Gestion spécifique des erreurs HTTP
    if isa(e, HTTP.ExceptionRequest.StatusError)
      return Dict(
        "isSuccess" => false,
        "status" => e.status,
        "body" => e.response
      )
    else
      # Gestion des autres types d'erreurs
      return Dict(
        "isSuccess" => false,
        "message" => "An unexpected error occurred: $(e)"
      )
    end
  end
end
export getcollections_status


"""
    putcollections_status(identifier::String, status::String, headers::Dict; apitest::Bool=false)

Modifie le statut de la collection désignée par `identifier`.

# exemple
```julia-repl
julia> Nakala.Collections.putcollections_status(identifier, "public", headers)
```
"""
function putcollections_status(identifier::String, status::String, headers::Dict; apitest::Bool=false)
  apitest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "collections", identifier, "status", status)
  try
    # Envoi de la requête
    response = HTTP.request("put", url, headers)
    response_status = HTTP.status(response)
    return Dict(
      "isSuccess" => true,
      "status" => response_status,
      "body" => ""
    )
  catch e
    # Gestion spécifique des erreurs HTTP
    if isa(e, HTTP.ExceptionRequest.StatusError)
      return Dict(
        "isSuccess" => false,
        "status" => e.status,
        "body" => ""
      )
    else
      # Gestion des autres types d'erreurs
      return Dict(
        "isSuccess" => false,
        "message" => "An unexpected error occurred: $(e)"
      )
    end
  end
end
export putcollections_status

end # end module
