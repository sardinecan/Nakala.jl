"""
  searchAuthors(q::String="", order::String="asc", page::Int=1, limit::Int=100, searchOperator::String="", searchField::String="", header::Dict, apiTest::Bool=false)

Retourne des auteurs associés aux données de Nakala en fonction de critères de recherche.

- q::string : mot clé pour la recherche
- order::String="asc" : sens du tri (basé le prénom puis le nom de famille)
- page::Int=1 : page courante
- limit::Int=100 : Nombre de résultats par page
- searchOperator::String="" : Permet de selectionner la recherche en début, fin ou contenu dans l'élément (start, end, partial(default))
-searchField::String="" : Permet de sélectionner le champ de recherche (surname, givenname, orcid, all(default))

- @todo header::Dict : permet de définir le format de la réponse
- apiTest::Bool=false : permet de lancer la requête sur l'api test de Nakala
"""
function searchAuthors(q::String, order::String="asc", page::Int=1, limit::Int=100, searchOperator::String="partial", searchField::String="all", apiTest::Bool=false)
  query = "q=$q&oder=$order&page=$page&limit=$limit&searchOperator=$searchOperator&searchField=$searchField"

  apiTest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "authors/search?$query")

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
    return [response, code]

  catch e
    # Gestion spécifique des erreurs HTTP
    if isa(e, HTTP.ExceptionRequest.StatusError)
      return "Request failed with status code $(e.status): $(e.response)"
    else
      # Gestion des autres types d'erreurs
      return "An unexpected error occurred: $(e)"
    end
  end
end


"""
search(q::String, apiTest::Bool=false)

Retourne des données Nakala en fonction de critères de recherche

- q::string : mot clé pour la recherche
- apiTest::Bool=false : permet de lancer la requête sur l'api test de Nakala
"""
function search(q::String, apiTest::Bool=false)
  query = "q=$q"
  apiTest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"  
  url = joinpath(apiurl, "search?$query")

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
    return [response, code]

  catch e
    # Gestion spécifique des erreurs HTTP
    if isa(e, HTTP.ExceptionRequest.StatusError)
      return "Request failed with status code $(e.status): $(e.response)"
    else
      # Gestion des autres types d'erreurs
      return "An unexpected error occurred: $(e)"
    end
  end
end
