using Test
using JSON, Downloads

path = @__DIR__
apikey = "01234567-89ab-cdef-0123-456789abcdef" #public key for Nakala test api

#==
Beaucoup de fonctions nécessitent au préalable de créer une donnée sur nakala afin d'être testées. 
la fonction createData est là à cet effet. 
elle retourne une identifier fichier et un identifiant donnée.
==#
function createData()
  # dépôt d'un fichier
  headers = Dict( "X-API-KEY" => apikey, :accept => "application/json" )
  file = "$path/testdata/file.txt"
  postfiles_response = Nakala.Datas.postfiles(file, headers, true)
  sha1 = postfiles_response["response"]["sha1"]

  # création de la donnée
  headers = Dict( "X-API-KEY" => apikey, "Content-Type" => "application/json" )
  body = Dict(
    :collectionsIds => [],
    :files => [ Dict("name" => "file.txt", "sha1" => sha1, "embargoed" => "2024-09-01") ],
    :status => "pending",
    :metas => [
      Dict(:value => "Ma donnée", :propertyUri => "http://nakala.fr/terms#title", :lang => "fr", :typeUri => "http://www.w3.org/2001/XMLSchema#string"),
      Dict(:value => "http://purl.org/coar/resource_type/c_18cf", :propertyUri => "http://nakala.fr/terms#type", :typeUri => "http://www.w3.org/2001/XMLSchema#anyURI"),
      Dict(:value => Dict(:surname => "Rémi", :givenname => "Fassol"), :propertyUri => "http://nakala.fr/terms#creator", :typeUri => "http://www.w3.org/2001/XMLSchema#string"),
      Dict(:value => "2024-09-01", :propertyUri => "http://nakala.fr/terms#created", :typeUri => "http://www.w3.org/2001/XMLSchema#string"),
      Dict(:value => "PDM", :propertyUri => "http://nakala.fr/terms#license", :typeUri => "http://www.w3.org/2001/XMLSchema#string"),
      Dict(:value => "Description", :propertyUri => "http://purl.org/dc/terms/description", :lang => "fr", :typeUri => "http://www.w3.org/2001/XMLSchema#string"),
      Dict( :value => Dict( :surname => "Rémi", :givenname => "Fassol" ), :propertyUri => "http://nakala.fr/terms#creator" )
    ],
    :rights => []
  )
  postdata_response = Nakala.Datas.postdatas(headers, body, true)
  identifier = postdata_response["response"]["payload"]["id"] 

  return Dict(
    :fileIdentifier => sha1,
    :dataIdentifier => identifier
  )
end

#==
Dépôt de fichier.
==#
headers = Dict( "X-API-KEY" => apikey, :accept => "application/json" )
file = "$path/testdata/file.txt"
postfiles_response = Nakala.postfiles(file, headers, true)
sha1 = postedFile["response"]["sha1"]

#test
@test response = get(postedFile, "code", "") == 201

#==
Dépôt d'une nouvelle donnée.
==#
# Dépôt d'un fichier
headers = Dict( "X-API-KEY" => apikey, :accept => "application/json" )
file = "$path/testdata/file.txt"
postfiles_response = Nakala.postfiles(file, headers, true)
sha1 = postedFile["response"]["sha1"]

# Création de la donnée
headers = Dict( "X-API-KEY" => apikey, "Content-Type" => "application/json" )
body = Dict(
  :collectionsIds => [],
  :files => [ Dict("name" => "file.txt", "sha1" => sha1, "embargoed" => "2024-09-01") ],
  :status => "pending",
  :metas => [
    Dict(:value => "Ma données", :propertyUri => "http://nakala.fr/terms#title", :lang => "fr", :typeUri => "http://www.w3.org/2001/XMLSchema#string"),
    Dict(:value => "http://purl.org/coar/resource_type/c_18cf", :propertyUri => "http://nakala.fr/terms#type", :typeUri => "http://www.w3.org/2001/XMLSchema#anyURI"),
    Dict(:value => Dict(:surname => "Rémi", :givenname => "Fassol"), :propertyUri => "http://nakala.fr/terms#creator", :typeUri => "http://www.w3.org/2001/XMLSchema#string"),
    Dict(:value => "2024-09-01", :propertyUri => "http://nakala.fr/terms#created", :typeUri => "http://www.w3.org/2001/XMLSchema#string"),
    Dict(:value => "PDM", :propertyUri => "http://nakala.fr/terms#license", :typeUri => "http://www.w3.org/2001/XMLSchema#string"),
    Dict(:value => "Description", :propertyUri => "http://purl.org/dc/terms/description", :lang => "fr", :typeUri => "http://www.w3.org/2001/XMLSchema#string"),
    Dict( :value => Dict( :surname => "Rémi", :givenname => "Fassol" ), :propertyUri => "http://nakala.fr/terms#creator" )
  ],
  :rights => []
)
postdatas_response = Nakala.Datas.postdatas(headers, body, true)

#test
@test postdatas_response["code"] == 201


#==
Récupération des informations d'une donnée
==#
identifier = createData()[:dataIdentifier]
@test Nakala.Datas.getdatas(identifier, headers, true)["code"] == 200


#==
Modification des informations d'une donnée.
==#
identifier = createData()[:dataIdentifier]
body = Dict(
  "metas" => [
    Dict("value" => "My data", "propertyUri" => "http://nakala.fr/terms#title", "lang" => "en", "typeUri" => "http://www.w3.org/2001/XMLSchema#string"),
    Dict("value" => "http://purl.org/coar/resource_type/c_18cf", "propertyUri" => "http://nakala.fr/terms#type", "typeUri" => "http://www.w3.org/2001/XMLSchema#anyURI"),
    Dict(:value => Dict(:surname => "Rémi", :givenname => "Fassol"), :propertyUri => "http://nakala.fr/terms#creator", :typeUri => "http://www.w3.org/2001/XMLSchema#string"),
    Dict("value" => "2024-09-01", "propertyUri" => "http://nakala.fr/terms#created", "typeUri" => "http://www.w3.org/2001/XMLSchema#string"),
    Dict("value" => "PDM", "propertyUri" => "http://nakala.fr/terms#license", "typeUri" => "http://www.w3.org/2001/XMLSchema#string"),
    Dict("value" => "New description.", "propertyUri" => "http://purl.org/dc/terms/description", "lang" => "en", "typeUri" => "http://www.w3.org/2001/XMLSchema#string")
  ]
)

@test Nakala.Datas.putdatas(identifier, headers, body, true) == 204
#Nakala.Datas.getdatas(identifier, headers, true)["response"]["metas"]


#==
Supprimer une donnée
==#
identifier = createData()[:dataIdentifier]
headers = Dict( "X-API-KEY" => apikey, :accept => "application/json" )

@test Nakala.Datas.deletedatas(identifier, headers, true) == 204


#==
Récupération des métadonnées des fichiers associés à une donnée.
==#
identifier = createData()[:dataIdentifier]
headers = Dict( "X-API-KEY" => apikey, :accept => "application/json" )
getdatas_files_response = Nakala.Datas.getdatas_files(identifier, headers, true)
getdatas_files_response["response"]
@test getdatas_files_response["code"] == 200


#==
Ajout d'un fichier à une donnée.
==#
# création d'une donnée
identifier = createData()[:dataIdentifier]

# envoi d'un nouveau fichier sur l'espace temporaire
headers = Dict( "X-API-KEY" => apikey, :accept => "application/json" )
file = "$path/testdata/file2.txt"
postfile_response = Nakala.Datas.postfiles(file, headers, true)
sha1 = postfile_response["response"]["sha1"]

# ajout du nouveau fichier dans la donnée
headers = Dict( "X-API-KEY" => apikey, "Content-Type" => "application/json" )
body = Dict( "description" => "Greetings.", "sha1" => sha1, "embargoed" => "2024-09-01" )
postdatas_files_reponse = Nakala.Datas.postdatas_files(identifier, headers, body, true)

@test postdatas_files_reponse["code"] == 200

#==
Suppression de fichier à une donnée.
==#
# création d'une donnée
identifier = createData()[:dataIdentifier]
fileIdentifier = createData()[:fileIdentifier]

# envoi d'un nouveau fichier sur l'espace temporaire
headers = Dict( "X-API-KEY" => apikey, :accept => "application/json" )
file = "$path/testdata/file2.txt"
postfile_response = Nakala.Datas.postfiles(file, headers, true)
sha1 = postfile_response["response"]["sha1"]

# ajout du nouveau fichier dans la donnée
headers = Dict( "X-API-KEY" => apikey, "Content-Type" => "application/json" )
body = Dict( "description" => "Greetings.", "sha1" => sha1, "embargoed" => "2024-09-01" )
postdatas_files_reponse = Nakala.Datas.postdatas_files(identifier, headers, body, true)
headers = Dict( "X-API-KEY" => apikey, :accept => "application/json" )

# suppression du premier fichier
deletedatas_files_response = Nakala.Datas.deletedatas_files(identifier, fileIdentifier, headers, true)
@test deletedatas_files_response == 204


#==
Récupération de la liste des métadonnées d'une donnée.
==#
identifier = createData()[:dataIdentifier]
headers = Dict( "X-API-KEY" => apikey, "Content-Type" => "application/json" )
getdatas_metadatas_response = Nakala.Datas.getdatas_metadatas(identifier, headers, true)
@test getdatas_metadatas_response["code"] == 200


#==
Ajout d'une nouvelle métadonnée à une donnée
==#
identifier = createData()[:dataIdentifier]
headers = Dict( "X-API-KEY" => apikey, :accept => "application/json" )
body = Dict( :value => "My Data", :propertyUri => "http://nakala.fr/terms#title", :lang => "en", :typeUri => "http://www.w3.org/2001/XMLSchema#string" )
postdatas_metadatas_response = Nakala.Datas.postdatas_metadatas(identifier, headers, body, true)

@test postdatas_metadatas_response["code"] == 201

#==
Suppression de métadonnées pour une donnée.
==#
# création d'une donnée
identifier = createData()[:dataIdentifier]

# ajout d'une métadonnée (titre en anglais)
headers = Dict( "X-API-KEY" => apikey, :accept => "application/json" )
body = Dict( :value => "My Data", :propertyUri => "http://nakala.fr/terms#title", :lang => "en", :typeUri => "http://www.w3.org/2001/XMLSchema#string" )
postdatas_metadatas_response = Nakala.Datas.postdatas_metadatas(identifier, headers, body, true)

# suppression de la métadonnée ajoutée
headers = Dict( "X-API-KEY" => apikey, :accept => "application/json" )
body = Dict( :propertyUri => "http://nakala.fr/terms#title", :lang => "en" )
deletedatas_metadatas_response = Nakala.Datas.deletedatas_metadatas(identifier, headers, body, true)

#test
@test deletedatas_metadatas_response["code"] == 200

#==
Récupération de la liste des relations d'une donnée
==#
identifier = createData()[:dataIdentifier]
headers = Dict( "X-API-KEY" => apikey, "Content-Type" => "application/json" )
getdatas_relations_response = Nakala.Datas.getdatas_relations(identifier, headers, true)
@test getdatas_relations_response["code"] == 200

#==
Ajout de relations sur une donnée
NB la donnée doit être publiée pour qu'on puisse modifier ses relations
==#
# Dépôt d'un fichier
headers = Dict( "X-API-KEY" => apikey, :accept => "application/json" )
file = "$path/testdata/file.txt"
postfiles_response = Nakala.postfiles(file, headers, true)
sha1 = postedFile["response"]["sha1"]

# Création de la donnée publique
headers = Dict( "X-API-KEY" => apikey, "Content-Type" => "application/json" )
body = Dict(
  :collectionsIds => [],
  :files => [ Dict("name" => "file.txt", "sha1" => sha1, "embargoed" => "2024-09-01") ],
  :status => "published",
  :metas => [
    Dict(:value => "Ma données", :propertyUri => "http://nakala.fr/terms#title", :lang => "fr", :typeUri => "http://www.w3.org/2001/XMLSchema#string"),
    Dict(:value => "http://purl.org/coar/resource_type/c_18cf", :propertyUri => "http://nakala.fr/terms#type", :typeUri => "http://www.w3.org/2001/XMLSchema#anyURI"),
    Dict(:value => Dict(:surname => "Rémi", :givenname => "Fassol"), :propertyUri => "http://nakala.fr/terms#creator", :typeUri => "http://www.w3.org/2001/XMLSchema#string"),
    Dict(:value => "2024-09-01", :propertyUri => "http://nakala.fr/terms#created", :typeUri => "http://www.w3.org/2001/XMLSchema#string"),
    Dict(:value => "PDM", :propertyUri => "http://nakala.fr/terms#license", :typeUri => "http://www.w3.org/2001/XMLSchema#string"),
    Dict(:value => "Description", :propertyUri => "http://purl.org/dc/terms/description", :lang => "fr", :typeUri => "http://www.w3.org/2001/XMLSchema#string"),
    Dict( :value => Dict( :surname => "Rémi", :givenname => "Fassol" ), :propertyUri => "http://nakala.fr/terms#creator" )
  ],
  :rights => []
)
postdatas_response = Nakala.Datas.postdatas(headers, body, true)

# ajout d'une relations
identifier = postdatas_response["response"]["payload"]["id"]
headers = Dict( "X-API-KEY" => apikey, :accept => "application/json" )
body = [ Dict(:type => "Cites", :repository => "hal", :target => "hal-02464318v1", :comment => "relation test") ]
postdatas_relations_response = Nakala.Datas.postdatas_relations(identifier, headers, body, true)

# test
@test postdatas_relations_response["code"] == 200

#==
Suppression des relations sur une donnée
==#
# Dépôt d'un fichier
headers = Dict( "X-API-KEY" => apikey, :accept => "application/json" )
file = "$path/testdata/file.txt"
postfiles_response = Nakala.postfiles(file, headers, true)
sha1 = postedFile["response"]["sha1"]

# Création de la donnée publique
headers = Dict( "X-API-KEY" => apikey, "Content-Type" => "application/json" )
body = Dict(
  :collectionsIds => [],
  :files => [ Dict("name" => "file.txt", "sha1" => sha1, "embargoed" => "2024-09-01") ],
  :status => "published",
  :metas => [
    Dict(:value => "Ma données", :propertyUri => "http://nakala.fr/terms#title", :lang => "fr", :typeUri => "http://www.w3.org/2001/XMLSchema#string"),
    Dict(:value => "http://purl.org/coar/resource_type/c_18cf", :propertyUri => "http://nakala.fr/terms#type", :typeUri => "http://www.w3.org/2001/XMLSchema#anyURI"),
    Dict(:value => Dict(:surname => "Rémi", :givenname => "Fassol"), :propertyUri => "http://nakala.fr/terms#creator", :typeUri => "http://www.w3.org/2001/XMLSchema#string"),
    Dict(:value => "2024-09-01", :propertyUri => "http://nakala.fr/terms#created", :typeUri => "http://www.w3.org/2001/XMLSchema#string"),
    Dict(:value => "PDM", :propertyUri => "http://nakala.fr/terms#license", :typeUri => "http://www.w3.org/2001/XMLSchema#string"),
    Dict(:value => "Description", :propertyUri => "http://purl.org/dc/terms/description", :lang => "fr", :typeUri => "http://www.w3.org/2001/XMLSchema#string"),
    Dict( :value => Dict( :surname => "Rémi", :givenname => "Fassol" ), :propertyUri => "http://nakala.fr/terms#creator" )
  ],
  :rights => []
)
postdatas_response = Nakala.Datas.postdatas(headers, body, true)

# ajout d'une relations
identifier = postdatas_response["response"]["payload"]["id"]
headers = Dict( "X-API-KEY" => apikey, :accept => "application/json" )
body = [ Dict(:type => "Cites", :repository => "hal", :target => "hal-02464318v1", :comment => "relation test") ]
postdatas_relations_response = Nakala.Datas.postdatas_relations(identifier, headers, body, true)

# suppression de la relation
headers = Dict( "X-API-KEY" => apikey, "Content-Type" => "application/json" )
body = Dict(:type => "Cites", :repository => "hal", :target => "hal-02464318v1", :comment => "relation test")
deletedatas_relations_response = Nakala.Datas.deletedatas_relations(identifier, headers, body, true)

# test
@test deletedatas_relations_response["code"] == 200


#==
@todo reprendre ici
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

newcollectionid = Nakala.Collections.postcollections(headers, body, true)["response"]["payload"]["id"]

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


header = Dict(
  "X-API-KEY" => apikey,
  "Content-Type" => "application/json"
)
output = "/home/josselin/Téléchargements"
Nakala.downloaddatas_files(identifier,  output, header, true)