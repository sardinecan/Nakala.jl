module Search
using HTTP
using JSON
"""
  searchAuthors(params::Array, apiTest::Bool=false)

Retourne des auteurs associés aux données de Nakala en fonction de critères de recherche.

- q::string : mot clé pour la recherche
- order::String="asc" : sens du tri (basé le prénom puis le nom de famille)
- page::Int=1 : page courante
- limit::Int=100 : Nombre de résultats par page
- searchOperator::String="" : Permet de selectionner la recherche en début, fin ou contenu dans l'élément (start, end, partial(default))
-searchField::String="" : Permet de sélectionner le champ de recherche (surname, givenname, orcid, all(default))

param = [
  :q => "String",
  :order => "asc(default)|desc",
  :page => 1(default),
  :limit => 10(default),
  :searchOperator => "start|end|partial(default)",
  :searchField => "surname|givenname|orcid|all(default)"
]

- apiTest::Bool=false : permet de lancer la requête sur l'api test de Nakala
"""
function searchAuthors(params::Array, apiTest::Bool=false)
  apiTest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "authors/search?") * HTTP.URIs.escapeuri(params)

  try
    # Envoi de la requête
    getAuthorsSearch = HTTP.request("GET", url)

    #=== Vérification du code de statut de la réponse
status_code = HTTP.status(postCollectionQuery)
if status_code < 200 || status_code >= 300
error("Failed to create collection: HTTP status $status_code")
end
===#
    code = HTTP.status(getAuthorsSearch)
    response = JSON.parse(String(HTTP.payload(getAuthorsSearch)))
    return Dict(
      "response" => response,
      "code" => code
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
search(q::String, apiTest::Bool=false)

Retourne des données Nakala en fonction de critères de recherche

- apiTest::Bool=false : permet de lancer la requête sur l'api test de Nakala
param = [
  :q => "String",
  :fq => "scope=collection;status=public;year=2009,1889",
  :facet => "type,size=17,sort=item,order=asc;fileExt,size=7,sort=count,order=desc",
  :order => "relevance ou date,desc ou date,asc ou title,desc ou title,asc"
]
"""
function search(params::Array, apiTest::Bool=false)
  apiTest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "search?") * HTTP.URIs.escapeuri(params)

  try
    # Envoi de la requête
    getSearch = HTTP.request("GET", url)

    #=== Vérification du code de statut de la réponse
status_code = HTTP.status(postCollectionQuery)
if status_code < 200 || status_code >= 300
error("Failed to create collection: HTTP status $status_code")
end
===#
    code = HTTP.status(getSearch)
    response = JSON.parse(String(HTTP.payload(getSearch)))
    return Dict(
      "response" => response,
      "code" =>code
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

end # end module search