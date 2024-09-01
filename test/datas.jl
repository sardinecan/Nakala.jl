using Test
apikey = "01234567-89ab-cdef-0123-456789abcdef" #public key for test api
#==
Dépôt de fichier
==#
headers = Dict(
  "X-API-KEY" => apikey,
  :accept => "application/json"
)
file = "/Users/josselinmorvan/files/dh/Nakala.jl/test/file.txt"
postedFile = Nakala.postFile(file, headers, true)
sha1 = postedFile["response"]["sha1"]
@test response = get(postedFile, "code", "") == 201

#==
Dépôt d'une donnée
==#
headers = Dict(
  "X-API-KEY" => apikey,
  "Content-Type" => "application/json"
)

body = Dict(
  :collectionsIds => [],
  :files => [
    Dict("name" => "file.txt", "sha1" => sha1, "embargoed" => "2024-09-01")
  ],
  :status => "pending",
  :metas => [
    Dict(:value => "title", :propertyUri => "http://nakala.fr/terms#title", :lang => "fr", :typeUri => "http://www.w3.org/2001/XMLSchema#string"),
    Dict(:value => "http://purl.org/coar/resource_type/c_18cf", :propertyUri => "http://nakala.fr/terms#type", :typeUri => "http://www.w3.org/2001/XMLSchema#anyURI"),
    Dict(:value => "2024-09-01", :propertyUri => "http://nakala.fr/terms#created", :typeUri => "http://www.w3.org/2001/XMLSchema#string"),
    Dict(:value => "PDM", :propertyUri => "http://nakala.fr/terms#license", :typeUri => "http://www.w3.org/2001/XMLSchema#string"),
    Dict(:value => "Description", :propertyUri => "http://purl.org/dc/terms/description", :lang => "fr", :typeUri => "http://www.w3.org/2001/XMLSchema#string")
  ],
  :rights => []
)
postedData = Nakala.postDatas(headers, body, true)
@test postedData["code"] == 201
identifier = postedData["response"]["payload"]["id"] 

#==
Récupération des informations d'une donnée
==#
@test get(Nakala.getDatas(identifier, headers, true), "code", "") == 200
d = Nakala.getDatas(identifier, headers, true)
#==
Modifier les métadonnées d'une donnée
==#
identifier
headers
body = Dict(
  "metas" => [
    Dict("value" => "New title test", "propertyUri" => "http://nakala.fr/terms#title", "lang" => "fr", "typeUri" => "http://www.w3.org/2001/XMLSchema#string"),
    Dict("value" => "http://purl.org/coar/resource_type/c_18cf", "propertyUri" => "http://nakala.fr/terms#type", "typeUri" => "http://www.w3.org/2001/XMLSchema#anyURI"),
    Dict("value" => "2024-09-01", "propertyUri" => "http://nakala.fr/terms#created", "typeUri" => "http://www.w3.org/2001/XMLSchema#string"),
    Dict("value" => "PDM", "propertyUri" => "http://nakala.fr/terms#license", "typeUri" => "http://www.w3.org/2001/XMLSchema#string"),
    Dict("value" => "Description modifiée 2.", "propertyUri" => "http://purl.org/dc/terms/description", "lang" => "fr", "typeUri" => "http://www.w3.org/2001/XMLSchema#string")
  ]
)
@test Nakala.putDatas(identifier, headers, body, true) == 204


#==
Supprimer une donnée
==#
headers = Dict(
  "X-API-KEY" => apikey,
  :accept => "application/json"
)

@test Nakala.deleteDatas(identifier, headers, true) == 204



