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
postedFile = Nakala.postFiles(file, headers, true)
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
    Dict(:value => "Description", :propertyUri => "http://purl.org/dc/terms/description", :lang => "fr", :typeUri => "http://www.w3.org/2001/XMLSchema#string"),
    Dict(
      :value => Dict(
        :surname => "John",
        :givenname => "Doe"
      ),
      :propertyUri => "http://nakala.fr/terms#creator"
    )
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
Modifier les informations d'une donnée
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
Lister les fichiers d'une donnée
==#
headers = Dict(
  "X-API-KEY" => apikey,
  :accept => "application/json"
)

@test Nakala.getDatasFiles(identifier, headers, true)["code"] == 200
Nakala.getDatasFiles(identifier, headers, true)["response"]

#==
Ajouter un fichier à une donnée
==#
headers = Dict(
  "X-API-KEY" => apikey,
  :accept => "application/json"
)
file = "/Users/josselinmorvan/files/dh/Nakala.jl/test/file2.txt"
postedFile = Nakala.postFiles(file, headers, true)
sha1 = postedFile["response"]["sha1"]


headers = Dict(
  "X-API-KEY" => apikey,
  "Content-Type" => "application/json"
)
body = Dict(
  "description" => "Greetings.",
  "sha1" => sha1,
  "embargoed" => "2024-09-01"
)
postedDatasFile = Nakala.postDatasFiles(identifier, headers, body, true)
postedDatasFile["response"]
@test postedDatasFile["code"] == 200

#==
Supprimer un fichier d'une donnée
==#
headers = Dict(
  "X-API-KEY" => apikey,
  :accept => "application/json"
)
fileIdentifier = Nakala.getDatasFiles(identifier, headers, true)["response"][2]["sha1"]
@test Nakala.deleteDatasFiles(identifier, fileIdentifier, headers, true) == 204

#==
Récupération de la liste des métadonnées
==#
headers = Dict(
  "X-API-KEY" => apikey,
  "Content-Type" => "application/json"
)
Nakala.getDatasMetadatas(identifier, headers, true)
@test Nakala.getDatasMetadatas(identifier, headers, true)["code"] == 200

#==
Ajout d'une nouvelle métadonnée à une donnée
==#
headers = Dict(
  "X-API-KEY" => apikey,
  :accept => "application/json"
)
body = Dict(
  :value => "title",
  :propertyUri => "http://nakala.fr/terms#title",
  :lang => "en",
  :typeUri => "http://www.w3.org/2001/XMLSchema#string"
)
Nakala.postDatasMetadatas(identifier, headers, body, true)
@test Nakala.postDatasMetadatas(identifier, headers, body, true)["code"] == 201

#==
Suppression de métadonnées pour une donnée
==#
headers = Dict(
  "X-API-KEY" => apikey,
  :accept => "application/json"
)
body = Dict(
  :propertyUri => "http://nakala.fr/terms#title",
  :lang => "en"
)
Nakala.deleteDatasMetadatas(identifier, headers, body, true)
@test Nakala.deleteDatasMetadatas(identifier, headers, body, true)["code"] == 200

Nakala.getDatasMetadatas(identifier, headers, true)["response"]

#==
Récupération de la liste des relations d'une donnée
==#
headers = Dict(
  "X-API-KEY" => apikey,
  "Content-Type" => "application/json"
)
@test Nakala.getDatasRelations(identifier, headers, true)["code"] == 200

#==
Ajout de relations sur une donnée
NB la donnée doit être publiée pour qu'on puisse modifier ses relations
==#
identifier
headers = Dict(
  "X-API-KEY" => apikey,
  :accept => "application/json"
)
body = [
  Dict(:type => "Cites", :repository => "hal", :target => "hal-02464318v1", :comment => "test")
]
@test Nakala.postDatasRelations(identifier, headers, body, true)["code"] == 200

#==
Suppression des relations sur une donnée
==#
headers = Dict(
  "X-API-KEY" => apikey,
  "Content-Type" => "application/json"
)
body = Dict(:type => "Cites", :repository => "hal", :target => "hal-02464318v1", :comment => "test")
@test Nakala.deleteDatasRelations(identifier, headers, body, true)["code"] == 200

Nakala.getDatasRelations(identifier, headers, true)

#==
Supprimer une donnée
==#
headers = Dict(
  "X-API-KEY" => apikey,
  :accept => "application/json"
)

@test Nakala.deleteDatas(identifier, headers, true) == 204







