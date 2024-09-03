using Test
using JSON
apikey = "01234567-89ab-cdef-0123-456789abcdef" #public key for test api
#==
Dépôt de fichier
==#
headers = Dict(
  "X-API-KEY" => apikey,
  :accept => "application/json"
)
file = "/Users/josselinmorvan/files/dh/Nakala.jl/test/file.txt"
postedFile = Nakala.postfiles(file, headers, true)
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
    Dict(:value => Dict(:surname => "unknown", :givenname => "user"), :propertyUri => "http://nakala.fr/terms#creator", :typeUri => "http://www.w3.org/2001/XMLSchema#string"),
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
postedData = Nakala.postdatas(headers, body, true)
postedData["response"]
@test postedData["code"] == 201
identifier = postedData["response"]["payload"]["id"] 

#==
Récupération des informations d'une donnée
==#
@test get(Nakala.getdatas(identifier, headers, true), "code", "") == 200
d = Nakala.getdatas(identifier, headers, true)

#==
Modifier les informations d'une donnée
==#
identifier
headers
body = Dict(
  "metas" => [
    Dict("value" => "New title test", "propertyUri" => "http://nakala.fr/terms#title", "lang" => "fr", "typeUri" => "http://www.w3.org/2001/XMLSchema#string"),
    Dict("value" => "http://purl.org/coar/resource_type/c_18cf", "propertyUri" => "http://nakala.fr/terms#type", "typeUri" => "http://www.w3.org/2001/XMLSchema#anyURI"),
    Dict(:value => Dict(:surname => "unknown", :givenname => "user"), :propertyUri => "http://nakala.fr/terms#creator", :typeUri => "http://www.w3.org/2001/XMLSchema#string"),
    Dict("value" => "2024-09-01", "propertyUri" => "http://nakala.fr/terms#created", "typeUri" => "http://www.w3.org/2001/XMLSchema#string"),
    Dict("value" => "PDM", "propertyUri" => "http://nakala.fr/terms#license", "typeUri" => "http://www.w3.org/2001/XMLSchema#string"),
    Dict("value" => "Description modifiée 2.", "propertyUri" => "http://purl.org/dc/terms/description", "lang" => "fr", "typeUri" => "http://www.w3.org/2001/XMLSchema#string")
  ]
)
@test Nakala.putdatas(identifier, headers, body, true) == 204


#==
Lister les fichiers d'une donnée
==#
headers = Dict(
  "X-API-KEY" => apikey,
  :accept => "application/json"
)

@test Nakala.getdatas_files(identifier, headers, true)["code"] == 200
Nakala.getdatas_files(identifier, headers, true)["response"]

#==
Ajouter un fichier à une donnée
==#
headers = Dict(
  "X-API-KEY" => apikey,
  :accept => "application/json"
)
file = "/Users/josselinmorvan/files/dh/Nakala.jl/test/file2.txt"
postedFile = Nakala.postfiles(file, headers, true)
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
postedDatasFile = Nakala.postdatas_files(identifier, headers, body, true)
postedDatasFile["response"]
@test postedDatasFile["code"] == 200

#==
Supprimer un fichier d'une donnée
==#
headers = Dict(
  "X-API-KEY" => apikey,
  :accept => "application/json"
)
fileIdentifier = Nakala.getdatas_files(identifier, headers, true)["response"][2]["sha1"]
@test Nakala.deletedatas_files(identifier, fileIdentifier, headers, true) == 204

#==
Récupération de la liste des métadonnées
==#
headers = Dict(
  "X-API-KEY" => apikey,
  "Content-Type" => "application/json"
)
Nakala.getdatas_metadatas(identifier, headers, true)
@test Nakala.getdatas_metadatas(identifier, headers, true)["code"] == 200

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
Nakala.postdatas_metadatas(identifier, headers, body, true)
@test Nakala.postdatas_metadatas(identifier, headers, body, true)["code"] == 201

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
Nakala.deletedatas_metadatas(identifier, headers, body, true)
@test Nakala.deletedatas_metadatas(identifier, headers, body, true)["code"] == 200

Nakala.getdatas_metadatas(identifier, headers, true)["response"]

#==
Récupération de la liste des relations d'une donnée
==#
headers = Dict(
  "X-API-KEY" => apikey,
  "Content-Type" => "application/json"
)
@test Nakala.getdatas_relations(identifier, headers, true)["code"] == 200

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
@test Nakala.postdatas_relations(identifier, headers, body, true)["code"] == 200

#==
Suppression des relations sur une donnée
==#
headers = Dict(
  "X-API-KEY" => apikey,
  "Content-Type" => "application/json"
)
body = Dict(:type => "Cites", :repository => "hal", :target => "hal-02464318v1", :comment => "test")
@test Nakala.deletedatas_relations(identifier, headers, body, true)["code"] == 200

Nakala.getdatas_relations(identifier, headers, true)

#==
récupération des droits sur une donnée
==#
Nakala.getdatas_rights(identifier, headers, true)["response"]
@test Nakala.getdatas_rights(identifier, headers, true)["code"] == 200

#==
Ajout des droits sur une donnée
==#
body = [
  Dict(
    :id => "c7e9bb15-6b4e-4e09-b234-ae7b13ac1f3b", # id of public profile unakala1
    :role => "ROLE_READER"
  )
]
Nakala.postdatas_rights(identifier, headers, body, true)["response"]
@test Nakala.postdatas_rights(identifier, headers, body, true)["code"] == 200
#==
Supprimer des droits sur une donnée
==#
headers = Dict(
  "X-API-KEY" => apikey,
  "Content-Type" => "application/json"
)
body = Dict(
  :id => "c7e9bb15-6b4e-4e09-b234-ae7b13ac1f3b",
  :role => "ROLE_READER"
)
# ou Dict(:role => "ROLE_READER") pour supprimer tous les lecteurs.
#Nakala.deletedatas_rights(identifier, headers, body, true)["response"]
@test Nakala.deletedatas_rights(identifier, headers, body, true)["code"] == 200

#==
récupération des collections d'une donnée
==#
Nakala.getdatas_collections(identifier, headers, true)

#==
Ajout d'une donnée dans un ensemble de collections.
==#
#creation de la collection et récupération de l'id
# la collection doit être publique pour être liée à une donnée publique
headers = Dict(
  "X-API-KEY" => apikey,
  "Content-Type" => "application/json"
)
body = Dict(
  :status => "public",
  :metas => [
    Dict(:value => "New Collection", :propertyUri => "http://nakala.fr/terms#title", :lang => "en", :typeUri => "http://www.w3.org/2001/XMLSchema#string")
    ],
  :datas => [],
  :rights => []
)

newcollectionid = Nakala.Collections.postcollection(headers, body, true)["response"]["payload"]["id"]

body = [newcollectionid]
Nakala.postdatas_collections(identifier, headers, body, true)["response"]

#==
Remplacement de l'ensemble des collections d'une donnée.
==#
#creation d'une autre collection pour remplacer la première
body = Dict(
  :status => "public",
  :metas => [
    Dict(:value => "Nouvelle collection", :propertyUri => "http://nakala.fr/terms#title", :lang => "fr", :typeUri => "http://www.w3.org/2001/XMLSchema#string")
    ],
  :datas => [],
  :rights => []
)
nouvellecollectionid = Nakala.Collections.postcollection(headers, body, true)["response"]["payload"]["id"]

headers = Dict(
  "X-API-KEY" => apikey,
  :accept => "application/json",
  "Content-Type" => "application/json"
)
body = [
  nouvellecollectionid
]
b = ["10.34847/nkl.a94di1v6"]
identifier

Nakala.putdatas_collections(identifier, headers, body, true)

#==
Suppression d'une donnée d'un ensemble de collections.
==#
Nakala.deletedatas_collections(identifier, headers, body, true)

#Nakala.getdatas_status(identifier, headers, true)
#Nakala.putdatas_status(identifier, headers, "published", true)

Nakala.getdatas_uploads(headers, true)

Nakala.deletedatas_uploads(sha1, headers, true)


#==
Supprimer une donnée
==#
headers = Dict(
  "X-API-KEY" => apikey,
  :accept => "application/json"
)

@test Nakala.deletedatas(identifier, headers, true) == 204







