module Collections

using HTTP
using JSON

"""
"""
function getcollections(identifier::String, headers::Dict, apiTest=false)
  apiTest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "collections", identifier)
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
function putcollections(identifier::String, headers::Dict, body::Dict, apiTest=false)
  apiTest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "collections", identifier)
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

function deletecollections(identifier::String, headers::Dict, apiTest=false)
  apiTest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "collections", identifier)
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

function postcollections(headers::Dict, body::Dict, apiTest::Bool=false)
  apiTest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "collections")
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
function getcollections_datas(identifier::String, params::Array, headers::Dict, apiTest::Bool=false)
   apiTest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "collections", identifier, "datas?") * HTTP.URIs.escapeuri(params)
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
function postcollections_datas(identifier::String, headers::Dict, body::Array, apiTest::Bool=false)
   apiTest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "collections", identifier, "datas")
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
function deletecollections_datas(identifier::String, headers::Dict, body::Array, apiTest::Bool=false)
   apiTest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "collections", identifier, "datas")
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
function getcollections_metadatas(identifier::String, headers::Dict, apiTest::Bool=false)
   apiTest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "collections", identifier, "metadatas")
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
function postcollections_metadatas(identifier::String, headers::Dict, body::Dict, apiTest::Bool=false)
   apiTest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "collections", identifier, "metadatas")
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
function deletecollections_metadatas(identifier::String, headers::Dict, body::Dict, apiTest::Bool=false)
   apiTest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "collections", identifier, "metadatas")
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
function getcollections_rights(identifier::String, headers::Dict, apiTest::Bool=false)
   apiTest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "collections", identifier, "rights")
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
function postcollections_rights(identifier::String, headers::Dict, body::Array, apiTest::Bool=false)
   apiTest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "collections", identifier, "rights")
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
function deletecollections_rights(identifier::String, headers::Dict, body::Dict, apiTest::Bool=false)
   apiTest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "collections", identifier, "rights")
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
function getcollections_status(identifier::String, headers::Dict, apiTest::Bool=false)
   apiTest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "collections", identifier, "status")
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
function putcollections_status(identifier::String, status::String, headers::Dict, apiTest::Bool=false)
   apiTest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "collections", identifier, "status", status)
  try
    # Envoi de la requête
    query = HTTP.request("put", url, headers)
    code = HTTP.status(query)
    # response = JSON.parse(String(HTTP.payload(query)))
    
    #response = JSON.parse(String(HTTP.payload(query)))
    return code
  catch e
    # Gestion spécifique des erreurs HTTP
    if isa(e, HTTP.ExceptionRequest.StatusError)
      return e.status
    else
      # Gestion des autres types d'erreurs
      return "An unexpected error occurred: $(e)"
    end
  end
end

end # end module