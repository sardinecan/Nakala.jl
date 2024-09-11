module Datas
using HTTP, JSON, Downloads
import ..Utilities: contains_key_value


"""
    postdatas_uploads(file::String, headers::Dict; apitest::Bool=false)

Dépose un fichier sur l'espace temporaire de Nakala et retourne un dictionnaire. La réponse du serveur correspond à la valeur de la clé `body`.

# exemple
```julia-repl
julia> headers = Dict( "X-API-KEY" => "01234567-89ab-cdef-0123", :accept => "application/json" )
Dict{Any, String} with 2 entries:
  :accept     => "application/json"
  "X-API-KEY" => "01234567-89ab-cdef-0123"

julia> Nakala.Datas.postdatas_uploads("path/to/file.txt", headers, apitest=true)
Dict{String, Any} with 3 entries:
  "body"      => Dict{String, Any}("name"=>"file.txt", "sha1"=>"a0b65939670bc2c010f4d5d6a0b3e")
  "status"    => 201
  "isSuccess" => true
```
"""
function postdatas_uploads(file::String, headers::Dict; apitest::Bool=false)
  apitest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "datas", "uploads")

  f = open(file, "r")
  body = HTTP.Form(Dict(:file => f))

  try
    response = HTTP.post(url, headers, body)
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
export postdatas_uploads


"""
    postdatas_files(identifier::String, headers::Dict, body::Dict; apitest::Bool=false)

Ajoute un fichier à une donnée Nakala dont l'identifiant correspond à l'argument `identifier`. Au préalable, le fichier doit avoir été déposé sur l'espace temporaire de Nakala (`postdatas_uploads()`) et vous devez disposer de son identifiant `sha1`.

# exemple
```julia-repl
julia> headers = Dict( "X-API-KEY" => "01234567-89ab-cdef-0123", :accept => "application/json" )
Dict{Any, String} with 2 entries:
  :accept     => "application/json"
  "X-API-KEY" => "01234567-89ab-cdef-0123"

julia> body = Dict( "description" => "Greetings.", "sha1" => sha1, "embargoed" => "2024-09-01" )
Dict{String, String} with 3 entries:
  "embargoed"   => "2024-09-01"
  "sha1"        => "49aaa64346f03598951ad578"
  "description" => "Greetings."

julia> Nakala.Datas.postdatas_files("10.34847/nkl.c61ej8x9", headers, body, apitest=true)
Dict{String, Any} with 3 entries:
  "body"      => Dict{String, Any}("message"=>"File added", "code"=>200)
  "status"    => 200
  "isSuccess" => true
```
"""
function postdatas_files(identifier::String, headers::Dict, body::Dict; apitest::Bool=false)
  apitest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "datas", identifier, "files")

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
export postdatas_files


"""
    deletedatas_files(identifier::String, fileIdentifier::String, headers::Dict; apitest::Bool=false)

Supprime un fichier (argument `fileIdentifier`) de la donnée Nakala dont l'identifiant correspond à `identifier`.

# exemple
```julia-repl
julia> Nakala.Datas.deletedatas_files("10.34847/nkl.b0ee", "a0b65939670bc2c01", headers, apitest=true)
Dict{String, Any} with 3 entries:
  "body"      => ""
  "status"    => 204
  "isSuccess" => true
```
"""
function deletedatas_files(identifier::String, fileIdentifier::String, headers::Dict; apitest::Bool=false)
  apitest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "datas", identifier, "files", fileIdentifier)
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
export deletedatas_files


"""
    postdatas(headers::Dict, body::Dict; apitest::Bool=false)

Dépose une nouvelle donnée sur Nakala. Les métadonnées nécessaires à la création de la donnée sont déclarées avec l'argument `body`

# exemple
```julia-repl
julia> headers = Dict( "X-API-KEY" => "01234567-89ab-cdef-0123", :accept => "application/json" )
Dict{Any, String} with 2 entries:
  :accept     => "application/json"
  "X-API-KEY" => "01234567-89ab-cdef-0123"

julia> body = Dict(
  :collectionsIds => [],
  :files => [ Dict("name" => "file.txt", "sha1" => sha1, "embargoed" => "2024-09-01") ],
  :status => "pending",
  :metas => [
    Dict(:value => "Ma données", :propertyUri => "http://nakala.fr/terms#title", :lang => "fr", :typeUri => "http://www.w3.org/2001/XMLSchema#string"),
    Dict(:value => "http://purl.org/coar/resource_type/c_18cf", :propertyUri => "http://nakala.fr/terms#type", :typeUri => "http://www.w3.org/2001/XMLSchema#anyURI"),
    Dict(:value => Dict(:surname => "Rémi", :givenname => "Fassol"), :propertyUri => "http://nakala.fr/terms#creator", :typeUri => "http://www.w3.org/2001/XMLSchema#string"),
    Dict(:value => "2024-09-01", :propertyUri => "http://nakala.fr/terms#created", :typeUri => "http://www.w3.org/2001/XMLSchema#string"),
    Dict(:value => "PDM", :propertyUri => "http://nakala.fr/terms#license", :typeUri => "http://www.w3.org/2001/XMLSchema#string"),
    Dict(:value => "Description", :propertyUri => "http://purl.org/dc/terms/description", :lang => "fr", :typeUri => "http://www.w3.org/2001/XMLSchema#string"),
    Dict( :value => Dict( :surname => "Rémi", :givenname => "Fassol" ), :propertyUri => "http://nakala.fr/terms#creator" )
  ],
  :rights => []
)

julia> Nakala.Datas.postdatas(headers, body, apitest=true)
Dict{String, Any} with 3 entries:
  "body"      => Dict{String, Any}("message"=>"Data created", "payload"=>Dict{String, Any}("id"=>"10.34847/nkl.35b5"), "code"=>201)
  "status"    => 201
  "isSuccess" => true
```
"""
function postdatas(headers::Dict, body::Dict; apitest::Bool=false)
  apitest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "datas")
  try
    # Envoi de la requête
    response = HTTP.request("POST", url, headers, JSON.json(body))
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
export postdatas


"""
    getdatas(identifier::String, headers::Dict; apitest::Bool=false)

Récupère les informations relatives à une donnée aynt pour identifiant `identifier`.

# exemple
```julia-repl
julia> headers = Dict( "X-API-KEY" => "01234567-89ab-cdef-0123", :accept => "application/json" )
Dict{Any, String} with 2 entries:
  :accept     => "application/json"
  "X-API-KEY" => "01234567-89ab-cdef-0123"

julia> Nakala.Datas.getdatas("10.34847/nkl.af219", headers)
Dict{String, Any} with 3 entries:
  "body"      => Dict{String, Any}("isDepositor"=>false, "isOwner"=>false, "depositor"=>Dict{String, Any}("name"=>"…,…", "photo"=>nothing, "surname"=>"…
  "status"    => 200
  "isSuccess" => true
```
"""
function getdatas(identifier::String, headers::Dict; apitest::Bool=false)
  apitest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "datas", identifier)
  try
    # Envoi de la requête
    response = HTTP.request("GET", url, headers)
    response_status = HTTP.status(response)
    if contains_key_value(headers, "Accept", "application/xml")
      response_body = """
        $(String(HTTP.payload(response)))
      """
    else
      response_body = JSON.parse(String(HTTP.payload(response)))
    end
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
export getdatas


"""
    getdatas_version(identifier::String, headers::Dict; apitest::Bool=false)

Récupère la liste des versions d'une donnée.

# exemple
```julia-repl
julia> headers = Dict( "X-API-KEY" => "123456789-abcdefghij", :accept => "application/json" )
Dict{Any, String} with 2 entries:
  :accept     => "application/json"
  "X-API-KEY" => "123456789-abcdefghij"

julia> Nakala.Datas.getdatas_version("10.34847/nkl.93aeeeee", headers)
Dict{String, Any} with 3 entries:
  "body"      => Dict{String, Any}("currentPage"=>1, "lastPage"=>1, "total"=>1, "data"=>Any[Dict{String, Any}("modDate"=>"2023-04-23T20:24:49+02:00", "versionIdentifie…
  "status"    => 200
  "isSuccess" => true
```
"""
function getdatas_version(identifier::String, headers::Dict; apitest::Bool=false)
  #==
  @todo gestion de params version et limits
  ==#
  apitest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "datas", identifier, "versions")
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
export getdatas_version


"""
    putdatas(identifier::String, headers::Dict, body::Dict; apitest::Bool=false)

Modifie informations d'une donnée.

# exemple
```julia-repl
julia> new_metadata = Dict(
  "metas" => [
    Dict("value" => "My data", "propertyUri" => "http://nakala.fr/terms#title", "lang" => "en", "typeUri" => "http://www.w3.org/2001/XMLSchema#string"),
    Dict("value" => "http://purl.org/coar/resource_type/c_18cf", "propertyUri" => "http://nakala.fr/terms#type", "typeUri" => "http://www.w3.org/2001/XMLSchema#anyURI"),
    Dict(:value => Dict(:surname => "Rémi", :givenname => "Fassol"), :propertyUri => "http://nakala.fr/terms#creator", :typeUri => "http://www.w3.org/2001/XMLSchema#string"),
    Dict("value" => "2024-09-01", "propertyUri" => "http://nakala.fr/terms#created", "typeUri" => "http://www.w3.org/2001/XMLSchema#string"),
    Dict("value" => "PDM", "propertyUri" => "http://nakala.fr/terms#license", "typeUri" => "http://www.w3.org/2001/XMLSchema#string"),
    Dict("value" => "New description.", "propertyUri" => "http://purl.org/dc/terms/description", "lang" => "en", "typeUri" => "http://www.w3.org/2001/XMLSchema#string")
  ]
)
Dict{String, Vector{Dict}} with 1 entry:
"metas" => [Dict("typeUri"=>"http://www.w3.org/2001/XMLSchema#string", "propertyUri"=>"http://nakala.fr/terms#title", "lang"=>"en", "value"=>"My data"), Dict("typeUr…

julia> Nakala.Datas.putdatas("10.34847/nkl.83409aze", headers, new_metadata, apitest=true)
Dict{String, Any} with 3 entries:
  "body"      => ""
  "status"    => 204
  "isSuccess" => true
```
"""
function putdatas(identifier::String, headers::Dict, body::Dict; apitest::Bool=false)
  apitest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "datas", identifier)
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
export putdatas


"""
    deletedatas(identifier::String, headers::Dict; apitest::Bool=false)

Suppression d'une donnée.

# exemple
```julia-repl
```
"""
function deletedatas(identifier::String, headers::Dict; apitest::Bool=false)
  apitest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "datas", identifier)
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
export deletedatas


"""
    getdatas_files(identifier::String, headers::Dict; apitest::Bool=false)

Récupération des métadonnées des fichiers associés à une donnée.

# exemple
```julia-repl
```
"""
function getdatas_files(identifier::String, headers::Dict; apitest::Bool=false)
  apitest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "datas", identifier, "files")
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
export getdatas_files


"""
    getdatas_metadatas(identifier::String, headers::Dict; apitest::Bool=false)

Récupération de la liste des métadonnées d'une donnée.

# exemple
```julia-repl
```
"""
function getdatas_metadatas(identifier::String, headers::Dict; apitest::Bool=false)
  apitest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "datas", identifier, "metadatas")
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
export getdatas_metadatas


"""
    postdatas_metadatas(identifier::String, headers::Dict, body::Dict; apitest::Bool=false)

Suppression de métadonnées pour une donnée.

# exemple
```julia-repl
```
"""
function postdatas_metadatas(identifier::String, headers::Dict, body::Dict; apitest::Bool=false)
  apitest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "datas", identifier, "metadatas")
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
export postdatas_metadatas


"""
    deletedatas_metadatas(identifier::String, headers::Dict, body::Dict; apitest::Bool=false)

Suppression de métadonnées pour une donnée.

# exemple
```julia-repl
```
"""
function deletedatas_metadatas(identifier::String, headers::Dict, body::Dict; apitest::Bool=false)
  apitest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "datas", identifier, "metadatas")
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
export deletedatas_metadatas


"""
    getdatas_relations(identifier::String, headers::Dict; apitest::Bool=false)

Récupération de la liste des relations d'une donnée.

# exemple
```julia-repl
```
"""
function getdatas_relations(identifier::String, headers::Dict; apitest::Bool=false)
  apitest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "datas", identifier, "relations")
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
export getdatas_relations


"""
    postdatas_relations(identifier::String, headers::Dict, body::Array; apitest::Bool=false)

Ajout de relations sur une donnée.

# exemple
```julia-repl
```
"""
function postdatas_relations(identifier::String, headers::Dict, body::Array; apitest::Bool=false)
  apitest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "datas", identifier, "relations")
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
export postdatas_relations


"""
    deletedatas_relations(identifier::String, headers::Dict, body::Dict; apitest::Bool=false)

Suppression des relations sur une donnée.

# exemple
```julia-repl
```
"""
function deletedatas_relations(identifier::String, headers::Dict, body::Dict; apitest::Bool=false)
  apitest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "datas", identifier, "relations")
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
export deletedatas_relations


"""
    getdatas_rights(identifier::String, headers::Dict; apitest::Bool=false)

Récupération des groupes et des utilisateurs ayant des droits sur la donnée.

# exemple
```julia-repl
```
"""
function getdatas_rights(identifier::String, headers::Dict; apitest::Bool=false)
  apitest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "datas", identifier, "rights")
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
export getdatas_rights


"""
    postdatas_rights(identifier::String, headers::Dict, body::Array; apitest::Bool=false)

Ajout de droits sur une donnée.

# exemple
```julia-repl
```
"""
function postdatas_rights(identifier::String, headers::Dict, body::Array; apitest::Bool=false)
  apitest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "datas", identifier, "rights")
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
export postdatas_rights


"""
    deletedatas_rights(identifier::String, headers::Dict, body::Dict; apitest::Bool=false)

Suppression des droits pour un utilisateur ou un groupe d'utilisateurs sur une donnée.

# exemple
```julia-repl
```
"""
function deletedatas_rights(identifier::String, headers::Dict, body::Dict; apitest::Bool=false)
  apitest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "datas", identifier, "rights")
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
export deletedatas_rights


"""
    getdatas_collections(identifier::String, headers::Dict; apitest::Bool=false)

Récupération de la liste des collections contenant la donnée.

# exemple
```julia-repl
```
"""
function getdatas_collections(identifier::String, headers::Dict; apitest::Bool=false)
  apitest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "datas", identifier, "collections")
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
export getdatas_collections


"""
    postdatas_collections(identifier::String, headers::Dict, body::Array; apitest::Bool=false)

Ajout d'une donnée dans un ensemble de collections.

# exemple
```julia-repl
```
"""
function postdatas_collections(identifier::String, headers::Dict, body::Array; apitest::Bool=false)
  apitest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "datas", identifier, "collections")
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
export postdatas_collections


"""
    putdatas_collections(identifier::String, headers::Dict, body::Array; apitest::Bool=false)

Remplacement de l'ensemble des collections d'une donnée.

# exemple
```julia-repl
```
"""
function putdatas_collections(identifier::String, headers::Dict, body::Array; apitest::Bool=false)
  apitest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "datas", identifier, "collections")
  try
    # Envoi de la requête
    response = HTTP.put(url, headers, JSON.json(body))
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
export putdatas_collections


"""
    deletedatas_collections(identifier::String, headers::Dict, body::Array; apitest::Bool=false)

Suppression d'une donnée d'un ensemble de collections.

# exemple
```julia-repl
```
"""
function deletedatas_collections(identifier::String, headers::Dict, body::Array; apitest::Bool=false)
  apitest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "datas", identifier, "collections")
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
export deletedatas_collections


"""
    getdatas_status(identifier::String, headers::Dict; apitest::Bool=false)

Récupération du statut d'une donnée.

# exemple
```julia-repl
```
"""
function getdatas_status(identifier::String, headers::Dict; apitest::Bool=false)
  apitest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "datas", identifier, "status")
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
export getdatas_status


"""
    putdatas_status(identifier::String, status::String, headers::Dict; apitest::Bool=false)

Changement du statut d'une donnée.

# exemple
```julia-repl
```
"""
function putdatas_status(identifier::String, status::String, headers::Dict; apitest::Bool=false)
  apitest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "datas", identifier, "status", status)
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
export putdatas_status


"""
    getdatas_uploads(headers::Dict; apitest::Bool=false)

Récupération pour un utilisateur de la liste des objets fichiers déposés non encore associés à une donnée.

# exemple
```julia-repl
```
"""
function getdatas_uploads(headers::Dict; apitest::Bool=false)
  apitest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "datas", "uploads")
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
export getdatas_uploads


"""
    deletedatas_uploads(fileIdentifier::String, headers::Dict; apitest::Bool=false)

Suppression d'un fichier déposé dans l'espace temporaire

# exemple
```julia-repl
```
"""
function deletedatas_uploads(fileIdentifier::String, headers::Dict; apitest::Bool=false)
  apitest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "datas", "uploads", fileIdentifier)
  try
    # Envoi de la requête
    response = HTTP.request("delete", url, headers)
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
export deletedatas_uploads


"""
    downloaddatas_files(identifier::String, outputDir::String, header::Dict; apitest::Bool=false)

Téléchargement des fichiers déposés associés à une donnée.

# exemple
```julia-repl
```
"""
function downloaddatas_files(identifier::String, outputDir::String, header::Dict; apitest::Bool=false)
  apitest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "download", "datas", identifier, "files?extension=zip")
  output = joinpath(outputDir, HTTP.escapeuri(identifier)*".zip")
  try
    # Envoi de la requête
    dl = Downloads.download(url, output, headers=header)
    return "Fichier enregistré sous $dl"
  catch e
    return "An unexpected error occurred: $(e)"  
  end
end
export downloaddatas_files

end # end module Datas
