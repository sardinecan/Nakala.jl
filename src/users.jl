module users

"""
"""
function getusers_me(headers::Dict, apiTest=false)
  apiTest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "users", "me")
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
"""
function putusers_me(headers::Dict, body::Dict, apiTest=false)
  apiTest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "users", "me")
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
"""
function putusers_me_apikey(headers::Dict, body::Dict, apiTest=false)
  apiTest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "users", "me")
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
"""
function postusers_datas(scope::String, headers::Dict, body::Dict, apiTest::Bool=false)
  apiTest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "users", "data", scope)

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
"""
function getusers_datas_datatypes(params::Array, headers::Dict, apiTest=false)
  apiTest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "users", "datas", "datatypes") * HTTP.URIs.escapeuri(params)
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

function getusers_datas_createdyears(params::Array, headers::Dict, apiTest=false)
  apiTest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "users", "datas", "createdyears") * HTTP.URIs.escapeuri(params)
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

function getusers_datas_statuses(params::Array, headers::Dict, apiTest=false)
  apiTest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "users", "datas", "statuses") * HTTP.URIs.escapeuri(params)
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

function getusers_groups(scope::String, params::Array, headers::Dict, apiTest=false)
  apiTest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "users", "groups", scope) * HTTP.URIs.escapeuri(params)
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
"""
function postusers_collections(scope::String, headers::Dict, body::Dict, apiTest::Bool=false)
  apiTest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "users", "collections", scope)

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

function getusers_collections_createdyears(params::Array, headers::Dict, apiTest=false)
  apiTest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "users", "collections", "createdyears") * HTTP.URIs.escapeuri(params)
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

function getusers_collections_statuses(params::Array, headers::Dict, apiTest=false)
  apiTest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "users", "collections", "statuses") * HTTP.URIs.escapeuri(params)
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

end