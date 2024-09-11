module Default
using HTTP, JSON

"""
    getresourceprocessing(identifier::String, headers::Dict, apitest::Bool=false)

État d'une ressource désignée par `identifier` dans ElasticSearch et Datacite.

# exemple
```julia-repl
julia> Nakala.getresourceprocessing(identifier, headers, apitest=true)
Dict{String, Any} with 3 entries:
  "body"      => Any[Dict{String, Any}("action"=>"update", "status"=>"start", "service"=>"datacite", "datestamp"=>"2024-09-11T19:34:10+02:00"), Dict{String, Any}("acti…
  "status"    => 200
  "isSuccess" => true
```
"""
function getresourceprocessing(identifier::String, headers::Dict; apitest::Bool=false)
  apitest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "resourceprocessing", identifier)
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
export getresourceprocessing

end # end module
