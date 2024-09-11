module Users
using HTTP, JSON


"""
    getusers_me(headers::Dict; apitest::Bool=false)

Récupère les informations de l'utilisateur courant.

# exemple
```julia-repl
julia> headers = Dict( "X-API-KEY" => apikey, "Content-Type" => "application/json" )
julia> Nakala.Users.getusers_me(headers, apitest=true)
Dict{String, Any} with 3 entries:
  "body"      => Dict{String, Any}("firstLogin"=>"2020-03-18T11:20:00+01:00", "username"=>"tnakala", "surname"=>"Nakala", "userGroupId"=>"26cef362-5bef-11eb-99d1…
  "status"    => 200
  "isSuccess" => true
```
"""
function getusers_me(headers::Dict; apitest::Bool=false)
  apitest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "users", "me")
  try
    # Envoi de la requête
    response = HTTP.request("GET", url, headers)
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
export getusers_me


"""
    putusers_me(headers::Dict, body::Dict; apitest::Bool=false)

Met à jour les informations de l'utilisateur courant.

# exemple
```julia-repl
julia> body = Dict( :givenname => "Test", :surname => "Nakala", :mail => "nakala@huma-num.fr", :photo => "http://mynakala.photo" )
julia> Nakala.Users.putusers_me(headers, body, apitest=true)
Dict{String, Any} with 3 entries:
  "body"      => ""
  "status"    => 200
  "isSuccess" => true
```
"""
function putusers_me(headers::Dict, body::Dict; apitest::Bool=false)
  apitest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "users", "me")
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
export putusers_me


"""
    putusers_me_apikey(headers::Dict; apitest::Bool=false)

Met à jour la clé d'API de l'utilisateur courant.
"""
function putusers_me_apikey(headers::Dict; apitest::Bool=false)
  apitest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "users", "me", "apikey")
  try
    # Envoi de la requête
    response = HTTP.request("PUT", url, headers)
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
export putusers_me_apikey


"""
    postusers_datas(scope::String, headers::Dict, body::Dict; apitest::Bool=false)

Récupère les données accessibles par un utilisateur. Retourne les données d'un utilisateur en fonction du périmètre choisi (`scope`) :
- deposited : les données déposées par l'utilisateur (ROLE_DEPOSITOR)
- owned : les données dont l'utilisateur est propriétaire (ROLE_OWNER)
- shared : les données partagées avec l'utilisateur (ROLE_ADMIN, ROLE_EDITOR ou ROLE_READER, mais pas ROLE_OWNER)
- editable : les données modifiables par l'utilisateur (ROLE_OWNER, ROLE_ADMIN ou ROLE_EDITOR)
- readable : les données lisibles par l'utilisateur (ROLE_OWNER, ROLE_ADMIN, ROLE_EDITOR ou ROLE_READER)
- all

# exemple
```julia-repl
julia> scope = "deposited"

julia> body = Dict(
  :page => 1,
  :orders => [ "creDate,desc" ],
  :titleSearchLang => "fr"
)

julia> Nakala.Users.postusers_datas(scope, headers, body, apitest=true)
Dict{String, Any} with 3 entries:
  "body"      => Dict{String, Any}("totalRecords"=>597, "data"=>Any[Dict{String, Any}("isDepositor"=>true, "isOwner"=>true, "depositor"=>Dict{String, Any}("name"=>"Tes…
  "status"    => 200
  "isSuccess" => true
```
"""
function postusers_datas(scope::String, headers::Dict, body::Dict; apitest::Bool=false)
  apitest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "users", "datas", scope)

  try
    response = HTTP.post(url, headers, JSON.json(body))
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
export postusers_datas


"""
    getusers_datas_datatypes(params::Array, headers::Dict; apitest::Bool=false)

Récupère les types des données accessibles par un utilisateur.
"""
function getusers_datas_datatypes(params::Array, headers::Dict; apitest::Bool=false)
  apitest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "users", "datas", "datatypes?") * HTTP.URIs.escapeuri(params)
  try
    # Envoi de la requête
    response = HTTP.request("GET", url, headers)
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
export getusers_datas_datatypes


"""
    getusers_datas_createdyears(params::Array, headers::Dict; apitest::Bool=false)

Récupère les différentes années de création des données accessibles par un utilisateur.

# exemple
```julia-repl
julia> params = [
  :scope =>"all",
  "collections[]" => "abc", # répéter pour que les collections passent dans l'url
  "collections[]" => "def"
]

julia> Nakala.Users.getusers_datas_createdyears(params, headers, apitest=true)
Dict{String, Any} with 3 entries:
  "body"      => Any[]
  "status"    => 200
  "isSuccess" => true
```
"""
function getusers_datas_createdyears(params::Array, headers::Dict; apitest::Bool=false)
  apitest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "users", "datas", "createdyears?") * HTTP.URIs.escapeuri(params)
  try
    # Envoi de la requête
    response = HTTP.request("GET", url, headers)
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
export getusers_datas_createdyears


"""
    getusers_datas_statuses(params::Array, headers::Dict; apitest::Bool=false)

Récupère les différents statuts des données accessibles par un utilisateur.

# exemple
```julia-repl
julia> params = [
  :scope =>"all"
]

julia> Nakala.Users.getusers_datas_statuses(params, headers, apitest=true)
Dict{String, Any} with 3 entries:
  "body"      => Any["embargoed", "moderated", "pending", "published"]
  "status"    => 200
  "isSuccess" => true
```
"""
function getusers_datas_statuses(params::Array, headers::Dict; apitest::Bool=false)
  apitest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "users", "datas", "statuses?") * HTTP.URIs.escapeuri(params)
  try
    # Envoi de la requête
    response = HTTP.request("GET", url, headers)
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
export getusers_datas_statuses


"""
    getusers_groups(scope::String, params::Array, headers::Dict; apitest::Bool=false)

Récupère les groupes d'un utilisateur.

# exemple
```julia-repl
julia> scope = "all"

julia> params = [
  :q => "nakala",
  :page => 1,
  :limit => 10,
  :order => "datemodify,desc"
]

julia> Nakala.Users.getusers_groups(scope, params, headers, apitest=true)
Dict{String, Any} with 3 entries:
  "body"      => Dict{String, Any}("totalRecords"=>3, "data"=>Any[Dict{String, Any}("isAdmin"=>true, "name"=>"Nakala.jl_2", "isMember"=>true, "users"=>Any[Dict{String,…
  "status"    => 200
  "isSuccess" => true
```
"""
function getusers_groups(scope::String, params::Array, headers::Dict; apitest::Bool=false)
  apitest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "users", "groups", scope*"?") * HTTP.URIs.escapeuri(params)
  try
    # Envoi de la requête
    response = HTTP.request("GET", url, headers)
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
export getusers_groups


"""
    postusers_collections(scope::String, headers::Dict, body::Dict; apitest::Bool=false)

Récupère les collections accessibles par un utilisateur.

# exemple
```julia-repl
julia> scope = "owned"

julia> body = Dict(
  :page => 1,
  :limit => 100
)

julia> Nakala.Users.postusers_collections(scope, headers, body, apitest=true)
Dict{String, Any} with 3 entries:
  "body"      => Dict{String, Any}("totalRecords"=>104, "data"=>Any[Dict{String, Any}("websitePrefix"=>"", "isDepositor"=>true, "isOwner"=>true, "depositor"=>Dict{Stri…
  "status"    => 200
  "isSuccess" => true
```
"""
function postusers_collections(scope::String, headers::Dict, body::Dict; apitest::Bool=false)
  apitest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "users", "collections", scope)

  try
    response = HTTP.post(url, headers, JSON.json(body))
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
export postusers_collections


"""
    getusers_collections_createdyears(params::Array, headers::Dict; apitest::Bool=false)

Récupère les différentes années de création des collections accessibles par un utilisateur.

# exemple
```julia-repl
julia> params = [ :scope =>"all" ]

julia> Nakala.Users.getusers_collections_createdyears(params, headers, apitest=true)
Dict{String, Any} with 3 entries:
  "body"      => Any["2024"]
  "status"    => 200
  "isSuccess" => true
```
"""
function getusers_collections_createdyears(params::Array, headers::Dict; apitest::Bool=false)
  apitest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "users", "collections", "createdyears?") * HTTP.URIs.escapeuri(params)
  try
    # Envoi de la requête
    response = HTTP.request("GET", url, headers)
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
export getusers_collections_createdyears


"""
    getusers_collections_statuses(params::Array, headers::Dict; apitest::Bool=false)

Récupère les différents statuts des collections accessibles par un utilisateur.

# exemple
```julia-repl
julia> params = [ :scope =>"all" ]

julia> Nakala.Users.getusers_collections_statuses(params, headers, apitest=true)
Dict{String, Any} with 3 entries:
  "body"      => Any["public", "private"]
  "status"    => 200
  "isSuccess" => true
```
"""
function getusers_collections_statuses(params::Array, headers::Dict; apitest::Bool=false)
  apitest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "users", "collections", "statuses?") * HTTP.URIs.escapeuri(params)
  try
    # Envoi de la requête
    response = HTTP.request("GET", url, headers)
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
export getusers_collections_statuses


end # end module
