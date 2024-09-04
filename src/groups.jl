module Groups
using HTTP, JSON

"""
"""
function getgroups_search(params::Array, headers::Dict, apiTest=false)
  apiTest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "groups", "search?") * HTTP.URIs.escapeuri(params)
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
function getgroups(identifier::String, headers::Dict, apiTest=false)
  apiTest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "groups", identifier)
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
function putgroups(identifier::String, headers::Dict, body::Dict, apiTest=false)
  apiTest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "groups", identifier)
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

function deletegroups(identifier::String, headers::Dict, apiTest=false)
  apiTest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "groups", identifier)
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

function postgroups(headers::Dict, body::Dict, apiTest::Bool=false)
  apiTest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "groups")
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

end # en module