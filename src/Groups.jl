module Groups
using HTTP, JSON


"""
    getgroups_search(params::Array, headers::Dict; apitest::Bool=false)

Récupère les utilisateurs et groupes d'utilisateurs, retourne des utilisateurs et groupes d'utilisateurs en fonction de critères de recherche.

# exemple
```julia-repl
julia> params = [
  :q => "Nakala",
  :order => "asc",
  :page => 1,
  :limit => 10
]

julia> Nakala.Groups.getgroups_search(params, headers, apitest=true)
Dict{String, Any} with 3 entries:
  "body"      => Any[Dict{String, Any}("isAdmin"=>true, "name"=>"Nakala.jl_test", "isMember"=>true, "users"=>Any[Dict{String, Any}("role"=>"ROLE_USER", "photo"=>nothing, "f…
  "status"    => 200
  "isSuccess" => true
```
"""
function getgroups_search(params::Array, headers::Dict; apitest::Bool=false)
  apitest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "groups", "search?") * HTTP.URIs.escapeuri(params)
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
export getgroups_search


"""
    getgroups(identifier::String, headers::Dict; apitest::Bool=false)

Récupère les informations sur le groupe d'utilisateurs désigné par `identifier`.

# exemple
```julia-repl
julia> Nakala.Groups.getgroups(groupid, headers, apitest=true)
Dict{String, Any} with 3 entries:
  "body"      => Dict{String, Any}("isAdmin"=>true, "name"=>"Nakala.jl_test", "isMember"=>true, "users"=>Any[Dict{String, Any}("role"=>"ROLE_USER", "photo"=>nothing, "…
  "status"    => 200
  "isSuccess" => true
```
"""
function getgroups(identifier::String, headers::Dict; apitest::Bool=false)
  apitest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "groups", identifier)
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
export getgroups


"""
    putgroups(identifier::String, headers::Dict, body::Dict; apitest::Bool=false)

Modifie un groupe d'utilisateurs désigné par `identifier`.

# exemple
```julia-repl
julia> body = Dict(
  :name => "Nakala.jl_test",
  :users => [
    Dict( :username => "unakala1", :role => "ROLE_USER" ),
    Dict( :username => "unakala2", :role => "ROLE_USER" ),
  ]
)

julia> Nakala.Groups.putgroups(groupid, headers, body, apitest=true)
Dict{String, Any} with 3 entries:
  "body"      => ""
  "status"    => 200
  "isSuccess" => true
```
"""
function putgroups(identifier::String, headers::Dict, body::Dict; apitest::Bool=false)
  apitest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "groups", identifier)
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
export putgroups


"""
    deletegroups(identifier::String, headers::Dict; apitest::Bool=false)

Supprime le groupe d'utilisateurs désigné par `identifier`.

# exemple
```julia-repl
julia> Nakala.Groups.deletegroups("01734655-7079-11ef-b203-52540084ccd3", headers, apitest=true)
Dict{String, Any} with 3 entries:
  "body"      => ""
  "status"    => 200
  "isSuccess" => true
```
"""
function deletegroups(identifier::String, headers::Dict; apitest::Bool=false)
  apitest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "groups", identifier)
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
export deletegroups


"""
    postgroups(headers::Dict, body::Dict; apitest::Bool=false)

Crée un groupe d'utilisateurs

# exemple
```julia-repl
julia> body = Dict(
  :name => "Nakala.jl_test",
  :users => [Dict(
      :username => "unakala1",
      :role => "ROLE_USER"
  )]
)

julia> postgroups_response = Nakala.Groups.postgroups(headers, body, apitest=true)
Dict{String, Any} with 3 entries:
  "body"      => Dict{String, Any}("message"=>"Group created", "payload"=>Dict{String, Any}("id"=>"01734655-7079-11ef-b203-52540084ccd3"), "code"=>201)
  "status"    => 201
  "isSuccess" => true
```
"""
function postgroups(headers::Dict, body::Dict; apitest::Bool=false)
  apitest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "groups")
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
export postgroups


end # en module
