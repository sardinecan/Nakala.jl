module Collections

using HTTP
using JSON

function postcollection(headers::Dict, body::Dict, apiTest::Bool=false)
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

end # end module