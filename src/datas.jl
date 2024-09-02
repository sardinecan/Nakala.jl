"""
postFiles(file::String, headers::Dict, apiTest::Bool=false)

Permet de déposer une donnée dans Nakala.
Les fichiers associés à la donnée sont à déposer avant via POST /uploads.

# example
```julia-repl
julia> headers = Dict(
  "X-API-KEY" => apikey,
  :accept => "application/json"
)

julia> file = "/Users/josselinmorvan/files/dh/Nakala.jl/test/file.txt"

julia> postFiles(file, headers)
```
"""
function postFiles(file::String, headers::Dict, apiTest::Bool=false)
  apiTest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "datas", "uploads")

  f = open(file, "r")
  body = HTTP.Form(Dict(:file => f))

  try
    query = HTTP.post(url, headers, body)
    code = HTTP.status(query)
    response = JSON.parse(String(HTTP.payload(query)))
    return Dict(
      "code" => code,
      "response" => response
    )
  catch e
    # Gestion spécifique des erreurs HTTP
    if isa(e, HTTP.ExceptionRequest.StatusError)
      return Dict(
        "response" => "Request failed with status code $(e.status): $(e.response)",
        "code" => e.status
      )
    else
      # Gestion des autres types d'erreurs
      return "An unexpected error occurred: $(e)"
    end
  end
end

"""

Ajout d'un fichier à une donnée.

Permet d'ajouter un fichier à une donnée. Attention, le fichier doit être déposé avant à l'aide de la requête POST /uploads.

# example 
```julia-repl

```
"""
function postDatasFiles(identifier::String, headers::Dict, body::Dict, apiTest::Bool=false)
   apiTest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "datas", identifier, "files")
  
  try
    query = HTTP.post(url, headers, JSON.json(body))
    code = HTTP.status(query)
    response = JSON.parse(String(HTTP.payload(query)))
    return Dict(
      "code" => code,
      "response" => response
    )
  catch e
    if isa(e, HTTP.ExceptionRequest.StatusError)
      return Dict(
        "response" => "Request failed with status code $(e.status): $(e.response)",
        "code" => e.status
      )
    else
      # Gestion des autres types d'erreurs
      return "An unexpected error occurred: $(e)"
    end
  end
   
 end

"""
"""
function deleteDatasFiles(identifier::String, fileIdentifier::String, headers::Dict, apiTest::Bool=false)
   apiTest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "datas", identifier, "files", fileIdentifier)
  try
    # Envoi de la requête
    query = HTTP.request("DELETE", url, headers)
    code = HTTP.status(query)
    # response = JSON.parse(String(HTTP.payload(query)))
    return code
    
  catch e
    # Gestion spécifique des erreurs HTTP
    if isa(e, HTTP.ExceptionRequest.StatusError)
      return "Request failed with status code $(e.status)"
    else
      # Gestion des autres types d'erreurs
      return "An unexpected error occurred: $(e)"
    end
  end

end

"""
postDatas(headers, body, apiTest=false)

Permet de déposer une donnée dans Nakala
Les fichiers associés à la donnée sont à déposer avant via POST /uploads

Les identifiants sha1 sont fournis lors du dépôt des fichiers. 

Les métadonnées title, type, licence, description, et date de création sont obligatoires.
# Example
```julia-repl
julia> headers = Dict(
  "X-API-KEY" => apikey,
  "Content-Type" => "application/json"
)

julia> body = Dict(
  :collectionsIds => [],
  :files => [
    Dict("name" => "file.txt", "sha1" => sha1, "embargoed" => "2024-09-01")
  ],
  :status => "pending",
  :metas => [
    Dict(:value => "test", :propertyUri => "http://nakala.fr/terms#title", :lang => "fr", :typeUri => "http://www.w3.org/2001/XMLSchema#string"),
    Dict(:value => "http://purl.org/coar/resource_type/c_18cf", :propertyUri => "http://nakala.fr/terms#type", :typeUri => "http://www.w3.org/2001/XMLSchema#anyURI"),
    Dict(:value => "2024-09-01", :propertyUri => "http://nakala.fr/terms#created", :typeUri => "http://www.w3.org/2001/XMLSchema#string"),
    Dict(:value => "PDM", :propertyUri => "http://nakala.fr/terms#license", :typeUri => "http://www.w3.org/2001/XMLSchema#string"),
    Dict(:value => "Description", :propertyUri => "http://purl.org/dc/terms/description", :lang => "fr", :typeUri => "http://www.w3.org/2001/XMLSchema#string")
  ],
  :rights => []
)

julia> postDatas(headers, body)
```
"""
function postDatas(headers::Dict, body::Dict, apiTest=false)
  apiTest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "datas")
  try
    # Envoi de la requête
    query = HTTP.request("POST", url, headers, JSON.json(body))
    code = HTTP.status(query)
    response = JSON.parse(String(HTTP.payload(query)))
    return Dict(
      "code" => code,
      "response" => response
    )
  catch e
    # Gestion spécifique des erreurs HTTP
    if isa(e, HTTP.ExceptionRequest.StatusError)
      return Dict(
        "response" => "Request failed with status code $(e.status): $(e.response)",
        "code" => e.status
      )
    else
      # Gestion des autres types d'erreurs
      return "An unexpected error occurred: $(e)"
    end
  end
end

"""
getDatas(headers, dataId, apiTest=false)

Récupération des informations sur une donnée.

# Examples
```julia-repl
julia> headers = Dict(
  "X-API-KEY" => "01234567-89ab-cdef-0123-456789abcdef",
  "Content-Type" => "application/json"
)
julia> identifier =  "10.34847/nkl.12345678"

julia> Nakala.getDatas(headers, identifier)
```
"""
function getDatas(identifier::String, headers::Dict, apiTest=false)
  apiTest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "datas", identifier)
  try
    # Envoi de la requête
    query = HTTP.request("GET", url, headers)
    code = HTTP.status(query)
    response = JSON.parse(String(HTTP.payload(query)))
    return Dict(
      "code" => code,
      "response" => response
    )
  catch e
    # Gestion spécifique des erreurs HTTP
    if isa(e, HTTP.ExceptionRequest.StatusError)
      return Dict(
        "response" => "Request failed with status code $(e.status): $(e.response)",
        "code" => e.status
      )
    else
      # Gestion des autres types d'erreurs
      return "An unexpected error occurred: $(e)"
    end
  end
end

"""
putDatas(identifier, headers, body, apiTest=false)

Modification des informations d'une donnée.

NB : les métadonnées title, type, licence, description et created sont obligatoires.

# Example
```julia-repl
julia> identifier =  "10.34847/nkl.12345678"

julia> headers = Dict(
  "X-API-KEY" => "01234567-89ab-cdef-0123-456789abcdef",
  "Content-Type" => "application/json"
)

julia> body = Dict(
  "metas" => [
    Dict("value" => "New title", "propertyUri" => "http://nakala.fr/terms#title", "lang" => "fr", "typeUri" => "http://www.w3.org/2001/XMLSchema#string"),
    Dict("value" => "http://purl.org/coar/resource_type/c_18cf", "propertyUri" => "http://nakala.fr/terms#type", "typeUri" => "http://www.w3.org/2001/XMLSchema#anyURI"),
    Dict("value" => "2024-09-01", "propertyUri" => "http://nakala.fr/terms#created", "typeUri" => "http://www.w3.org/2001/XMLSchema#string"),
    Dict("value" => "PDM", "propertyUri" => "http://nakala.fr/terms#license", "typeUri" => "http://www.w3.org/2001/XMLSchema#string"),
    Dict("value" => "Modified description.", "propertyUri" => "http://purl.org/dc/terms/description", "lang" => "fr", "typeUri" => "http://www.w3.org/2001/XMLSchema#string")
  ]
)

julia> putDatas(identifier, headers, body, true)
```
"""
function putDatas(identifier::String, headers::Dict, body::Dict, apiTest=false)
  apiTest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "datas", identifier)
  try
    # Envoi de la requête
    query = HTTP.request("PUT", url, headers, JSON.json(body))
    code = HTTP.status(query)
    # response = JSON.parse(String(HTTP.payload(query)))
    return code
    
  catch e
    # Gestion spécifique des erreurs HTTP
    if isa(e, HTTP.ExceptionRequest.StatusError)
      return "Request failed with status code $(e.status)"
    else
      # Gestion des autres types d'erreurs
      return "An unexpected error occurred: $(e)"
    end
  end
end

"""
deleteDatas(identifier, headers, apiTest=false)

Suppression d'une donnée.

La suppression d'une donnée est autorisée uniquement si la donnée n'est pas publiée.

# Example
```julia-repl
julia> identifier =  "10.34847/nkl.12345678"

julia> headers = Dict(
  "X-API-KEY" => "01234567-89ab-cdef-0123-456789abcdef",
  :accept => "application/json"
)

julia> deleteDatas(identifier, headers)
```
"""
function deleteDatas(identifier::String, headers::Dict, apiTest=false)
  apiTest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "datas", identifier)
  try
    # Envoi de la requête
    query = HTTP.request("DELETE", url, headers)
    code = HTTP.status(query)
    # response = JSON.parse(String(HTTP.payload(query)))
    
    return code
    
  catch e
    # Gestion spécifique des erreurs HTTP
    if isa(e, HTTP.ExceptionRequest.StatusError)
      return "Request failed with status code $(e.status)"
    else
      # Gestion des autres types d'erreurs
      return "An unexpected error occurred: $(e)"
    end
  end
end

"""
 getDatasFiles (identifier::String, headers::Dict, apiTest::Bool=false)

Permet d'obtenir l'ensemble des informations sur les fichiers associés à une donnée. Pour accéder à la version spécifique d'une donnée, vous pouvez ajouter un numéro de version après l'identifiant de la donnée (ex: 10.34847/nkl.eabbbf68.v2 donne accès à la version 2 de la donnée 10.34847/nkl.eabbbf68)

# example
```julia-repl
julia> identifier = 

julia> headers = Dict(
  "X-API-KEY" => apikey,
  :accept => "application/json"
)

julia> getDatasFiles (identifier, headers)

```
"""
function getDatasFiles(identifier::String, headers::Dict, apiTest::Bool=false)
   apiTest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "datas", identifier, "files")
  try
    # Envoi de la requête
    query = HTTP.request("get", url, headers)
    code = HTTP.status(query)
    # response = JSON.parse(String(HTTP.payload(query)))
    
    response = JSON.parse(String(HTTP.payload(query)))
    return Dict(
      "code" => code,
      "response" => response
    )
  catch e
    # Gestion spécifique des erreurs HTTP
    if isa(e, HTTP.ExceptionRequest.StatusError)
      return Dict(
        "response" => "Request failed with status code $(e.status): $(e.response)",
        "code" => e.status
      )
    else
      # Gestion des autres types d'erreurs
      return "An unexpected error occurred: $(e)"
    end
  end
end


"""
# example
```julia-repl
```
"""
function getDatasMetadatas(identifier::String, headers::Dict, apiTest::Bool=false)
   apiTest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "datas", identifier, "metadatas")
  try
    # Envoi de la requête
    query = HTTP.request("get", url, headers)
    code = HTTP.status(query)
    # response = JSON.parse(String(HTTP.payload(query)))
    
    response = JSON.parse(String(HTTP.payload(query)))
    return Dict(
      "code" => code,
      "response" => response
    )
  catch e
    # Gestion spécifique des erreurs HTTP
    if isa(e, HTTP.ExceptionRequest.StatusError)
      return Dict(
        "response" => "Request failed with status code $(e.status): $(e.response)",
        "code" => e.status
      )
    else
      # Gestion des autres types d'erreurs
      return "An unexpected error occurred: $(e)"
    end
  end

end

"""
# example
```julia-repl
```
"""
function postDatasMetadatas(identifier::String, headers::Dict, body::Dict, apiTest::Bool=false)
   apiTest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "datas", identifier, "metadatas")
  try
    # Envoi de la requête
    query = HTTP.request("post", url, headers, JSON.json(body))
    code = HTTP.status(query)
    # response = JSON.parse(String(HTTP.payload(query)))
    
    response = JSON.parse(String(HTTP.payload(query)))
    return Dict(
      "code" => code,
      "response" => response
    )
  catch e
    # Gestion spécifique des erreurs HTTP
    if isa(e, HTTP.ExceptionRequest.StatusError)
      return Dict(
        "response" => "Request failed with status code $(e.status): $(e.response)",
        "code" => e.status
      )
    else
      # Gestion des autres types d'erreurs
      return "An unexpected error occurred: $(e)"
    end
  end

end

"""
# example
```julia-repl
```
"""
function deleteDatasMetadatas(identifier::String, headers::Dict, body::Dict, apiTest::Bool=false)
   apiTest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "datas", identifier, "metadatas")
  try
    # Envoi de la requête
    query = HTTP.request("delete", url, headers, JSON.json(body))
    code = HTTP.status(query)
    # response = JSON.parse(String(HTTP.payload(query)))
    
    response = JSON.parse(String(HTTP.payload(query)))
    return Dict(
      "code" => code,
      "response" => response
    )
  catch e
    # Gestion spécifique des erreurs HTTP
    if isa(e, HTTP.ExceptionRequest.StatusError)
      return Dict(
        "response" => "Request failed with status code $(e.status): $(e.response)",
        "code" => e.status
      )
    else
      # Gestion des autres types d'erreurs
      return "An unexpected error occurred: $(e)"
    end
  end

end

"""
# example
```julia-repl
```
"""
function getDatasRelations(identifier::String, headers::Dict, apiTest::Bool=false)
   apiTest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "datas", identifier, "relations")
  try
    # Envoi de la requête
    query = HTTP.request("get", url, headers)
    code = HTTP.status(query)
    # response = JSON.parse(String(HTTP.payload(query)))
    
    response = JSON.parse(String(HTTP.payload(query)))
    return Dict(
      "code" => code,
      "response" => response
    )
  catch e
    # Gestion spécifique des erreurs HTTP
    if isa(e, HTTP.ExceptionRequest.StatusError)
      return Dict(
        "response" => "Request failed with status code $(e.status): $(e.response)",
        "code" => e.status
      )
    else
      # Gestion des autres types d'erreurs
      return "An unexpected error occurred: $(e)"
    end
  end

end

"""
# example
```julia-repl
```
"""
function postDatasRelations(identifier::String, headers::Dict, body::Array, apiTest::Bool=false)
   apiTest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "datas", identifier, "relations")
  try
    # Envoi de la requête
    query = HTTP.request("post", url, headers, JSON.json(body))
    code = HTTP.status(query)
    # response = JSON.parse(String(HTTP.payload(query)))
    
    response = JSON.parse(String(HTTP.payload(query)))
    return Dict(
      "code" => code,
      "response" => response
    )
  catch e
    # Gestion spécifique des erreurs HTTP
    if isa(e, HTTP.ExceptionRequest.StatusError)
      return Dict(
        "response" => "Request failed with status code $(e.status): $(e.response)",
        "code" => e.status
      )
    else
      # Gestion des autres types d'erreurs
      return "An unexpected error occurred: $(e)"
    end
  end

end

"""
# example
```julia-repl
```
"""
function deleteDatasRelations(identifier::String, headers::Dict, body::Dict, apiTest::Bool=false)
   apiTest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "datas", identifier, "relations")
  try
    # Envoi de la requête
    query = HTTP.request("delete", url, headers, JSON.json(body))
    code = HTTP.status(query)
    # response = JSON.parse(String(HTTP.payload(query)))
    
    response = JSON.parse(String(HTTP.payload(query)))
    return Dict(
      "code" => code,
      "response" => response
    )
  catch e
    # Gestion spécifique des erreurs HTTP
    if isa(e, HTTP.ExceptionRequest.StatusError)
      return Dict(
        "response" => "Request failed with status code $(e.status): $(e.response)",
        "code" => e.status
      )
    else
      # Gestion des autres types d'erreurs
      return "An unexpected error occurred: $(e)"
    end
  end

end
