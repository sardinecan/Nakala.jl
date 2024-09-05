module Vocabularies

"""
# example

params = [
"q" => "public",
"response_status" => "PDM"
]
```julia-repl
```
"""
function getvocabularies_licenses(params::Array, apiTest::Bool=false)
  apiTest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
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
params = [
q => "Fran",
response_status => "fr",
order => "asc",
page => 1,
limit => 20,
]
"""
function getvocabularies_languages(params::Array, apiTest::Bool=false)
  # @todo problème avec les caractères spéciaux, malgré l'utilisation de escapeuri
  apiTest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"
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


function getvocabularies_countryCodes(params::Array, apiTest::Bool=false)
  apiTest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
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


function getvocabularies_dataStatuses(apiTest::Bool=false)
  apiTest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
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


function getvocabularies_collectionStatuses(apiTest::Bool=false)
  apiTest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
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


function getvocabularies_datatypes(apiTest::Bool=false)
  apiTest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
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


function getvocabularies_properties(apiTest::Bool=false)
  apiTest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
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


function getvocabularies_metadatatypes(apiTest::Bool=false)
  apiTest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
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
# example
```julia-repl
```
"""
function getvocabularies_dcmitypes(apiTest::Bool=false)
  apiTest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
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
