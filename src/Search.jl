module Search
using HTTP, JSON

"""
    search_authors(params::Array; apitest::Bool=false)

Recherche des auteurs associés aux données de Nakala et retourne un dictionnaire. La réponse du serveur correspond à la valeur de la clé `body`.

# exemple
```julia-repl
julia> Nakala.Search.search_authors([:q=>"Hugo"], apitest=true)
Dict{String, Any} with 3 entries:
  "body"      => Any[]
  "status"    => 200
  "isSuccess" => true
```
"""
function search_authors(params::Array; apitest::Bool=false)
  apitest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "authors/search?") * HTTP.URIs.escapeuri(params)

  try
    # Envoi de la requête
    response = HTTP.request("GET", url)
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
export search_authors


"""
    search(params::Array; apitest::Bool=false)

Recherche des données Nakala et retourne un dictionnaire. La réponse du serveur correspond à la valeur de la clé `body`.

# exemple
```julia-repl
julia> Nakala.Search.search([:q=>"édition", :fq => ""], apitest=true)
Dict{String, Any} with 3 entries:
  "body"      => Dict{String, Any}("totalResults"=>40, "datas"=>Any[Dict{String, Any}("collectionsIds"=>Any["10.34847/nkl.6d3ei1wy"], "stat…
  "status"    => 200
  "isSuccess" => true
```
"""
function search(params::Array; apitest::Bool=false)
  apitest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "search?") * HTTP.URIs.escapeuri(params)

  try
    # Envoi de la requête
    response = HTTP.request("GET", url)
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
export search

end # end module search
