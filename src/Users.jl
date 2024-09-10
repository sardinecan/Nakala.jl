module Users
using HTTP
using JSON


"""
    getusers_me(headers::Dict, apiTest=false)

Récupération des informations sur l'utilisateur courant.

# exemple
```julia-repl
```
"""
function getusers_me(headers::Dict, apiTest=false)
  apiTest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
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
    putusers_me(headers::Dict, body::Dict, apiTest=false)

Mise à jour des informations sur l'utilisateur courant.

# exemple
```julia-repl
```
"""
function putusers_me(headers::Dict, body::Dict, apiTest=false)
  apiTest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
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
    putusers_me_apikey(headers::Dict, apiTest=false)

Mise à jour de la clé d'API de l'utilisateur courant.

# exemple
```julia-repl
```
"""
function putusers_me_apikey(headers::Dict, apiTest=false)
  apiTest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
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
    postusers_datas(scope::String, headers::Dict, body::Dict, apiTest::Bool=false)

Récupération des données accessibles par un utilisateur.

# exemple
```julia-repl
```
"""
function postusers_datas(scope::String, headers::Dict, body::Dict, apiTest::Bool=false)
  apiTest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
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
    getusers_datas_datatypes(params::Array, headers::Dict, apiTest=false)

Récupération des types des données accessibles par un utilisateur.

# exemple
```julia-repl
```
"""
function getusers_datas_datatypes(params::Array, headers::Dict, apiTest=false)
  apiTest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
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
    getusers_datas_createdyears(params::Array, headers::Dict, apiTest=false)

Récupération des différentes années de création des données accessibles par un utilisateur.

# exemple
```julia-repl
```
"""
function getusers_datas_createdyears(params::Array, headers::Dict, apiTest=false)
  apiTest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
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
    getusers_datas_statuses(params::Array, headers::Dict, apiTest=false)

Récupération des différents statuts des données accessibles par un utilisateur.

# exemple
```julia-repl
```
"""
function getusers_datas_statuses(params::Array, headers::Dict, apiTest=false)
  apiTest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
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
    getusers_groups(scope::String, params::Array, headers::Dict, apiTest=false)

Récupération des groupes d'un utilisateur.

# exemple
```julia-repl
```
"""
function getusers_groups(scope::String, params::Array, headers::Dict, apiTest=false)
  apiTest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
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
    postusers_collections(scope::String, headers::Dict, body::Dict, apiTest::Bool=false)

Récupération des collections accessibles par un utilisateur.

# exemple
```julia-repl
```
"""
function postusers_collections(scope::String, headers::Dict, body::Dict, apiTest::Bool=false)
  apiTest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
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
    getusers_collections_createdyears(params::Array, headers::Dict, apiTest=false)

Récupération des différentes années de création des collections accessibles par un utilisateur.

# exemple
```julia-repl
```
"""
function getusers_collections_createdyears(params::Array, headers::Dict, apiTest=false)
  apiTest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
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
    getusers_collections_statuses(params::Array, headers::Dict, apiTest=false)

Récupération des différents statuts des collections accessibles par un utilisateur.

# exemple
```julia-repl
```
"""
function getusers_collections_statuses(params::Array, headers::Dict, apiTest=false)
  apiTest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
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
