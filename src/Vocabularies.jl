module Vocabularies
using HTTP, JSON

"""
    getvocabularies_licenses(params::Array; apitest::Bool=false)

Récupère les licences des données de Nakala.

# exemple
```julia-repl
julia> Nakala.Vocabularies.getvocabularies_licenses(["q" => "public"], apitest=true)
Dict{String, Any} with 3 entries:
  "body"      => Any[Dict{String, Any}("name"=>"Affero General Public License v1.0", "code"=>"AGPL-1.0", "url"=>"https://spdx.org/licenses/AGPL-1.0.html#licenseText"),…
  "status"    => 200
  "isSuccess" => true
```
"""
function getvocabularies_licenses(params::Array; apitest::Bool=false)
  apitest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "vocabularies", "licenses?") * HTTP.URIs.escapeuri(params)
  headers = Dict( :accept => "application/json" )
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
export getvocabularies_licenses


"""
    getvocabularies_languages(params::Array; apitest::Bool=false)

Récupère les langues des métadonnées.

# exemple
```julia-repl
julia> Nakala.getvocabularies_languages([:code => "fr"], apitest=true)
Dict{String, Any} with 3 entries:
  "body"      => Any[Dict{String, Any}("label"=>"French", "id"=>"fr")]
  "status"    => 200
  "isSuccess" => true
```
"""
function getvocabularies_languages(params::Array; apitest::Bool=false)
  # @todo problème avec les caractères spéciaux, malgré l'utilisation de escapeuri
  apitest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"
  url = joinpath(apiurl, "vocabularies", "languages?") * HTTP.escapeuri(params)
  headers = Dict( :accept => "application/json" )
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
export getvocabularies_languages


"""
    getvocabularies_countryCodes(params::Array; apitest::Bool=false)

Récupère les codes pays ISO 3166 (alpha-2).

# exemple
```julia-repl
julia> Nakala.getvocabularies_countryCodes([:q => "fr"], apitest=true)
Dict{String, Any} with 3 entries:
  "body"      => Any[Dict{String, Any}("label"=>"Central African Republic (the)", "id"=>"CF"), Dict{String, Any}("label"=>"France", "id"=>"FR"), Dict{String, Any}("lab…
  "status"    => 200
  "isSuccess" => true
```
"""
function getvocabularies_countryCodes(params::Array; apitest::Bool=false)
  apitest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "vocabularies", "countryCodes?") * HTTP.URIs.escapeuri(params)
  headers = Dict( :accept => "application/json" )

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
export getvocabularies_countryCodes


"""
    getvocabularies_dataStatuses(;apitest::Bool=false)

Récupère les statuts des données de Nakala.

# exemple
```julia-repl
julia> Nakala.getvocabularies_dataStatuses(apitest=true)
Dict{String, Any} with 3 entries:
  "body"      => Dict{String, Any}("pending"=>"pending data", "moderated"=>"moderated data", "deleted"=>"deleted data", "old"=>"old version", "published"=>"published d…
  "status"    => 200
  "isSuccess" => true
```
"""
function getvocabularies_dataStatuses(;apitest::Bool=false)
  apitest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "vocabularies", "dataStatuses")
  headers = Dict( :accept => "application/json" )

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
export getvocabularies_dataStatuses


"""
    getvocabularies_collectionStatuses(;apitest::Bool=false)

Récupère les statuts des collections de Nakala.

# exemple
```julia-repl
julia> Nakala.getvocabularies_collectionStatuses(apitest=true)
Dict{String, Any} with 3 entries:
  "body"      => Dict{String, Any}("public"=>"public collection", "private"=>"private collection")
  "status"    => 200
  "isSuccess" => true
```
"""
function getvocabularies_collectionStatuses(;apitest::Bool=false)
  apitest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "vocabularies", "collectionStatuses")
  headers = Dict( :accept => "application/json" )

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
export getvocabularies_collectionStatuses


"""
    getvocabularies_datatypes(;apitest::Bool=false)

Récupère les types des données de Nakala.

# exemple
```julia-repl
julia> Nakala.getvocabularies_datatypes(apitest=true)
Dict{String, Any} with 3 entries:
  "body"      => Any["http://purl.org/coar/resource_type/c_c513", "http://purl.org/coar/resource_type/c_12ce", "http://purl.org/coar/resource_type/c_18cc", "http://pur…
  "status"    => 200
  "isSuccess" => true
```
"""
function getvocabularies_datatypes(;apitest::Bool=false)
  apitest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "vocabularies", "datatypes")
  headers = Dict( :accept => "application/json" )

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
export getvocabularies_datatypes


"""
    getvocabularies_properties(;apitest::Bool=false)

Récupère les propriétés des métadonnées.

# exemple
```julia-repl
julia> Nakala.getvocabularies_properties(apitest=true)
Dict{String, Any} with 3 entries:
  "body"      => Any["http://nakala.fr/terms#title", "http://nakala.fr/terms#creator", "http://nakala.fr/terms#created", "http://nakala.fr/terms#license", "http://naka…
  "status"    => 200
  "isSuccess" => true
```
"""
function getvocabularies_properties(;apitest::Bool=false)
  apitest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "vocabularies", "properties")
  headers = Dict( :accept => "application/json" )

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
export getvocabularies_properties


"""
    getvocabularies_metadatatypes(;apitest::Bool=false)

Récupère les types des métadonnées.

# exemple
```julia-repl
julia> Nakala.getvocabularies_metadatatypes(apitest=true)
Dict{String, Any} with 3 entries:
  "body"      => Any["http://purl.org/dc/terms/Box", "http://purl.org/dc/terms/ISO3166", "http://purl.org/dc/terms/Period", "http://purl.org/dc/terms/Point", "http://p…
  "status"    => 200
  "isSuccess" => true
```
"""
function getvocabularies_metadatatypes(;apitest::Bool=false)
  apitest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "vocabularies", "metadatatypes")
  headers = Dict( :accept => "application/json" )

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
export getvocabularies_metadatatypes


"""
    getvocabularies_dcmitypes(;apitest::Bool=false)

Récupère les types DCMI.

# exemple
```julia-repl
julia> Nakala.getvocabularies_dcmitypes(apitest=true)
Dict{String, Any} with 3 entries:
  "body"      => Any["http://purl.org/dc/dcmitype/Collection", "http://purl.org/dc/dcmitype/Dataset", "http://purl.org/dc/dcmitype/Event", "http://purl.org/dc/dcmitype…
  "status"    => 200
  "isSuccess" => true
```
"""
function getvocabularies_dcmitypes(;apitest::Bool=false)
  apitest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "vocabularies", "dcmitypes")
  headers = Dict( :accept => "application/json" )

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
export getvocabularies_dcmitypes


end #end module
