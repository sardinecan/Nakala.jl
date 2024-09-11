module Datas
using HTTP
using JSON
using Downloads
import ..Utilities: contains_key_value


"""
    postdatas_uploads(file::String, headers::Dict; apitest::Bool=false)

Dépôt de fichier.

# exemple
```julia-repl
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

Ajout d'un fichier à une donnée.

# exemple
```julia-repl
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

Suppression de fichier à une donnée.

# exemple
```julia-repl
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

Dépôt d'une nouvelle donnée.

# exemple
```julia-repl
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

Récupération des informations sur une donnée.

# exemple
```julia-repl
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

Récupération de la liste des versions d'une donnée.

# exemple
```julia-repl
```
"""
function getdatas_version(identifier::String, headers::Dict; apitest::Bool=false)
  apitest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "datas", identifier, "version")
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

Modification des informations d'une donnée.

# exemple
```julia-repl
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
