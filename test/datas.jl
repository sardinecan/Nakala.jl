using Test
using JSON
using Downloads
using Nakala.Utilities

path = @__DIR__
apikey = "01234567-89ab-cdef-0123-456789abcdef" # tnakala user public key for Nakala test api
userid = "c7e9bb15-6b4e-4e09-b234-ae7b13ac1f3b" # unakala1 public user id

#==
Beaucoup de fonctions nécessitent au préalable de créer une donnée sur nakala afin d'être testées. 
la fonction createData est là à cet effet. 
elle retourne une identifier fichier et un identifiant donnée.
==#
function createData()
  # dépôt d'un fichier
  headers = Dict( "X-API-KEY" => apikey, :accept => "application/json" )
  file = "$path/testdata/file.txt"
  postdatas_uploads_response = Nakala.Datas.postdatas_uploads(file, headers, apitest=true)
  sha1 = postdatas_uploads_response["body"]["sha1"]

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
  postdata_response = Nakala.Datas.postdatas(headers, body, apitest=true)
  identifier = postdata_response["body"]["payload"]["id"] 

  return Dict(
    :fileIdentifier => sha1,
    :dataIdentifier => identifier
  )
end



## Dépôt de fichier.
headers = Dict( "X-API-KEY" => apikey, :accept => "application/json" )
file = "$path/testdata/file.txt"
postdatas_uploads_response = Nakala.postdatas_uploads(file, headers, apitest=true)
sha1 = postdatas_uploads_response["body"]["sha1"]

#test
@test postdatas_uploads_response["status"] == 201



## Dépôt d'une nouvelle donnée.
# Dépôt d'un fichier
headers = Dict( "X-API-KEY" => apikey, :accept => "application/json" )
file = "$path/testdata/file.txt"
postdatas_uploads_response = Nakala.postdatas_uploads(file, headers, apitest=true)
sha1 = postdatas_uploads_response["body"]["sha1"]

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
postdatas_response = Nakala.Datas.postdatas(headers, body, apitest=true)

#test
@test postdatas_response["status"] == 201


## Récupération des informations d'une donnée
identifier = createData()[:dataIdentifier]
getdatas_response = Nakala.Datas.getdatas(identifier, headers, apitest=true)
@test Nakala.Datas.getdatas(identifier, headers, apitest=true)["status"] == 200



## Modification des informations d'une donnée.==#
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
putdatas_response = Nakala.Datas.putdatas(identifier, headers, body, apitest=true)

# test
@test putdatas_response["status"] == 204
#Nakala.Datas.getdatas(identifier, headers, apitest=true)["body"]["metas"]



## Supprimer une donnée
identifier = createData()[:dataIdentifier]
headers = Dict( "X-API-KEY" => apikey, :accept => "application/json" )
deletedatas_response = Nakala.Datas.deletedatas(identifier, headers, apitest=true)
@test deletedatas_response["status"] == 204



## Récupération des métadonnées des fichiers associés à une donnée.
identifier = createData()[:dataIdentifier]
headers = Dict( "X-API-KEY" => apikey, :accept => "application/json" )
getdatas_files_response = Nakala.Datas.getdatas_files(identifier, headers, apitest=true)
getdatas_files_response["body"]
@test getdatas_files_response["status"] == 200



## Ajout d'un fichier à une donnée.
# création d'une donnée
identifier = createData()[:dataIdentifier]

# envoi d'un nouveau fichier sur l'espace temporaire
headers = Dict( "X-API-KEY" => apikey, :accept => "application/json" )
file = "$path/testdata/file2.txt"
postfile_response = Nakala.Datas.postdatas_uploads(file, headers, apitest=true)
sha1 = postfile_response["body"]["sha1"]

# ajout du nouveau fichier dans la donnée
headers = Dict( "X-API-KEY" => apikey, "Content-Type" => "application/json" )
body = Dict( "description" => "Greetings.", "sha1" => sha1, "embargoed" => "2024-09-01" )
postdatas_files_reponse = Nakala.Datas.postdatas_files(identifier, headers, body, apitest=true)

@test postdatas_files_reponse["status"] == 200



## Suppression de fichier à une donnée.
# création d'une donnée
identifier = createData()[:dataIdentifier]
fileIdentifier = createData()[:fileIdentifier]

# envoi d'un nouveau fichier sur l'espace temporaire
headers = Dict( "X-API-KEY" => apikey, :accept => "application/json" )
file = "$path/testdata/file2.txt"
postfile_response = Nakala.Datas.postdatas_uploads(file, headers, apitest=true)
sha1 = postfile_response["body"]["sha1"]

# ajout du nouveau fichier dans la donnée
headers = Dict( "X-API-KEY" => apikey, "Content-Type" => "application/json" )
body = Dict( "description" => "Greetings.", "sha1" => sha1, "embargoed" => "2024-09-01" )
postdatas_files_reponse = Nakala.Datas.postdatas_files(identifier, headers, body, apitest=true)
headers = Dict( "X-API-KEY" => apikey, :accept => "application/json" )

# suppression du premier fichier
deletedatas_files_response = Nakala.Datas.deletedatas_files(identifier, fileIdentifier, headers, apitest=true)
@test deletedatas_files_response["status"] == 204



## Récupération de la liste des métadonnées d'une donnée.
identifier = createData()[:dataIdentifier]
headers = Dict( "X-API-KEY" => apikey, "Content-Type" => "application/json" )
getdatas_metadatas_response = Nakala.Datas.getdatas_metadatas(identifier, headers, apitest=true)
@test getdatas_metadatas_response["status"] == 200



## Ajout d'une nouvelle métadonnée à une donnée
identifier = createData()[:dataIdentifier]
headers = Dict( "X-API-KEY" => apikey, :accept => "application/json" )
body = Dict( :value => "My Data", :propertyUri => "http://nakala.fr/terms#title", :lang => "en", :typeUri => "http://www.w3.org/2001/XMLSchema#string" )
postdatas_metadatas_response = Nakala.Datas.postdatas_metadatas(identifier, headers, body, apitest=true)

@test postdatas_metadatas_response["status"] == 201



## Suppression de métadonnées pour une donnée.
# création d'une donnée
identifier = createData()[:dataIdentifier]

# ajout d'une métadonnée (titre en anglais)
headers = Dict( "X-API-KEY" => apikey, :accept => "application/json" )
body = Dict( :value => "My Data", :propertyUri => "http://nakala.fr/terms#title", :lang => "en", :typeUri => "http://www.w3.org/2001/XMLSchema#string" )
postdatas_metadatas_response = Nakala.Datas.postdatas_metadatas(identifier, headers, body, apitest=true)

# suppression de la métadonnée ajoutée
headers = Dict( "X-API-KEY" => apikey, :accept => "application/json" )
body = Dict( :propertyUri => "http://nakala.fr/terms#title", :lang => "en" )
deletedatas_metadatas_response = Nakala.Datas.deletedatas_metadatas(identifier, headers, body, apitest=true)

#test
@test deletedatas_metadatas_response["status"] == 200



## Récupération de la liste des relations d'une donnée
identifier = createData()[:dataIdentifier]
headers = Dict( "X-API-KEY" => apikey, "Content-Type" => "application/json" )
getdatas_relations_response = Nakala.Datas.getdatas_relations(identifier, headers, apitest=true)
@test getdatas_relations_response["status"] == 200



## Ajout de relations sur une donnée
# NB la donnée doit être publiée pour qu'on puisse modifier ses relations
# Dépôt d'un fichier
headers = Dict( "X-API-KEY" => apikey, :accept => "application/json" )
file = "$path/testdata/file.txt"
postdatas_uploads_response = Nakala.postdatas_uploads(file, headers, apitest=true)
sha1 = postdatas_uploads_response["body"]["sha1"]

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
postdatas_response = Nakala.Datas.postdatas(headers, body, apitest=true)

# ajout d'une relations
identifier = postdatas_response["body"]["payload"]["id"]
headers = Dict( "X-API-KEY" => apikey, :accept => "application/json" )
body = [ Dict(:type => "Cites", :repository => "hal", :target => "hal-02464318v1", :comment => "relation test") ]
postdatas_relations_response = Nakala.Datas.postdatas_relations(identifier, headers, body, apitest=true)

# test
@test postdatas_relations_response["status"] == 200



## Suppression des relations sur une donnée
# Dépôt d'un fichier
headers = Dict( "X-API-KEY" => apikey, :accept => "application/json" )
file = "$path/testdata/file.txt"
postdatas_uploads_response = Nakala.postdatas_uploads(file, headers, apitest=true)
sha1 = postdatas_uploads_response["body"]["sha1"]

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
postdatas_response = Nakala.Datas.postdatas(headers, body, apitest=true)

# ajout d'une relations
identifier = postdatas_response["body"]["payload"]["id"]
headers = Dict( "X-API-KEY" => apikey, :accept => "application/json" )
body = [ Dict(:type => "Cites", :repository => "hal", :target => "hal-02464318v1", :comment => "relation test") ]
postdatas_relations_response = Nakala.Datas.postdatas_relations(identifier, headers, body, apitest=true)

# suppression de la relation
headers = Dict( "X-API-KEY" => apikey, "Content-Type" => "application/json" )
body = Dict(:type => "Cites", :repository => "hal", :target => "hal-02464318v1", :comment => "relation test")
deletedatas_relations_response = Nakala.Datas.deletedatas_relations(identifier, headers, body, apitest=true)

# test
@test deletedatas_relations_response["status"] == 200




## Récupération des groupes et des utilisateurs ayant des droits sur la donnée.
# création d'une donnée
identifier = createData()[:dataIdentifier]
getdatas_rights_response = Nakala.Datas.getdatas_rights(identifier, headers, apitest=true)

#test
@test getdatas_rights_response["status"] == 200



## Ajout de droits sur une donnée.
# création d'une donnée
identifier = createData()[:dataIdentifier]

# ajout des droits à la donnée
headers = Dict( "X-API-KEY" => apikey, "Content-Type" => "application/json" )
body = [ Dict( :id => userid, :role => "ROLE_READER" ) ]
postdatas_rights_response = Nakala.Datas.postdatas_rights(identifier, headers, body, apitest=true)

#test
@test postdatas_rights_response["status"] == 200



## Suppression des droits pour un utilisateur ou un groupe d'utilisateurs sur une donnée.
# création d'une donnée
identifier = createData()[:dataIdentifier]

# ajout des droits à la donnée
headers = Dict( "X-API-KEY" => apikey, "Content-Type" => "application/json" )
body = [ Dict( :id => userid, :role => "ROLE_READER" ) ]
postdatas_rights_response = Nakala.Datas.postdatas_rights(identifier, headers, body, apitest=true)

# suppression des droits
headers = Dict( "X-API-KEY" => apikey, "Content-Type" => "application/json" )
body = Dict( :id => userid, :role => "ROLE_READER" ) # ou Dict(:role => "ROLE_READER") pour supprimer tous les lecteurs.
deletedatas_rights_response = Nakala.Datas.deletedatas_rights(identifier, headers, body, apitest=true)

#test
@test deletedatas_rights_response["status"] == 200



## Récupération de la liste des collections contenant la donnée.
identifier = createData()[:dataIdentifier]
getdatas_collections_response = Nakala.Datas.getdatas_collections(identifier, headers, apitest=true)

#test
@test getdatas_collections_response["status"] == 200



## Ajout d'une donnée dans un ensemble de collections.
# Dépôt d'un fichier
headers = Dict( "X-API-KEY" => apikey, :accept => "application/json" )
file = "$path/testdata/file.txt"
postdatas_uploads_response = Nakala.postdatas_uploads(file, headers, apitest=true)
sha1 = postdatas_uploads_response["body"]["sha1"]

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
postdatas_response = Nakala.Datas.postdatas(headers, body, apitest=true)
identifier = postdatas_response["body"]["payload"]["id"]

# creation de la collection et récupération de l'id la collection doit être publique pour être liée à une donnée publique
headers = Dict( "X-API-KEY" => apikey, "Content-Type" => "application/json" )
body = Dict(
  :status => "public",
  :metas => [ Dict(:value => "New Collection", :propertyUri => "http://nakala.fr/terms#title", :lang => "en", :typeUri => "http://www.w3.org/2001/XMLSchema#string") ],
  :datas => [],
  :rights => []
)
newcollectionid = Nakala.Collections.postcollections(headers, body, apitest=true)["body"]["payload"]["id"]

# ajout de la donnée dans une collection
body = [ newcollectionid ]
postdatas_collections_response = Nakala.Datas.postdatas_collections(identifier, headers, body, apitest=true)

# test
@test postdatas_collections_response["status"] == 201



## Remplacement de l'ensemble des collections d'une donnée.
# Dépôt d'un fichier
headers = Dict( "X-API-KEY" => apikey, :accept => "application/json" )
file = "$path/testdata/file.txt"
postdatas_uploads_response = Nakala.postdatas_uploads(file, headers, apitest=true)
sha1 = postdatas_uploads_response["body"]["sha1"]

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
postdatas_response = Nakala.Datas.postdatas(headers, body, apitest=true)
identifier = postdatas_response["body"]["payload"]["id"]

# creation de la collection et récupération de l'id la collection doit être publique pour être liée à une donnée publique
headers = Dict( "X-API-KEY" => apikey, "Content-Type" => "application/json" )
body = Dict(
  :status => "public",
  :metas => [ Dict(:value => "New Collection", :propertyUri => "http://nakala.fr/terms#title", :lang => "en", :typeUri => "http://www.w3.org/2001/XMLSchema#string") ],
  :datas => [],
  :rights => []
)
newcollectionid = Nakala.Collections.postcollections(headers, body, apitest=true)["body"]["payload"]["id"]

# ajout de la donnée dans une collection
body = [ newcollectionid ]
postdatas_collections_response = Nakala.Datas.postdatas_collections(identifier, headers, body, apitest=true)["body"]

# creation d'une autre collection pour remplacer la première
body = Dict(
  :status => "public",
  :metas => [ Dict(:value => "Nouvelle collection", :propertyUri => "http://nakala.fr/terms#title", :lang => "fr", :typeUri => "http://www.w3.org/2001/XMLSchema#string") ],
  :datas => [],
  :rights => []
)
nouvellecollectionid = Nakala.Collections.postcollections(headers, body, apitest=true)["body"]["payload"]["id"]

# remplacement de la collection par la nouvelle
headers = Dict( "X-API-KEY" => apikey, "Content-Type" => "application/json" )
body = [ nouvellecollectionid ]
putdatas_collections_response = Nakala.Datas.putdatas_collections(identifier, headers, body, apitest=true)

# test
@test putdatas_collections_response["status"] == 204



## Suppression d'une donnée d'un ensemble de collections.
# Dépôt d'un fichier
headers = Dict( "X-API-KEY" => apikey, :accept => "application/json" )
file = "$path/testdata/file.txt"
postdatas_uploads_response = Nakala.postdatas_uploads(file, headers, apitest=true)
sha1 = postdatas_uploads_response["body"]["sha1"]

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
postdatas_response = Nakala.Datas.postdatas(headers, body, apitest=true)
identifier = postdatas_response["body"]["payload"]["id"]

# creation de la collection et récupération de l'id la collection doit être publique pour être liée à une donnée publique
headers = Dict( "X-API-KEY" => apikey, "Content-Type" => "application/json" )
body = Dict(
  :status => "public",
  :metas => [ Dict(:value => "New Collection", :propertyUri => "http://nakala.fr/terms#title", :lang => "en", :typeUri => "http://www.w3.org/2001/XMLSchema#string") ],
  :datas => [],
  :rights => []
)
newcollectionid = Nakala.Collections.postcollections(headers, body, apitest=true)["body"]["payload"]["id"]

# ajout de la donnée dans une collection
headers = Dict( "X-API-KEY" => apikey, "Content-Type" => "application/json" )
body = [ newcollectionid ]
postdatas_collections_response = Nakala.Datas.postdatas_collections(identifier, headers, body, apitest=true)["body"]

# suppression de la donnée dans la collection
deletedatas_collections_response = Nakala.Datas.deletedatas_collections(identifier, headers, body, apitest=true)

@test deletedatas_collections_response["status"] == 200



## Récupération du statut d'une donnée.
identifier = createData()[:dataIdentifier]
headers = Dict( "X-API-KEY" => apikey, "Content-Type" => "application/json" )
getdatas_status_response = Nakala.Datas.getdatas_status(identifier, headers, apitest=true)

# test
@test getdatas_status_response["status"] == 200 



## Changement du statut d'une donnée.
identifier = createData()[:dataIdentifier]
headers = Dict( "X-API-KEY" => apikey, "Content-Type" => "application/json" )
putdatas_status_response = Nakala.Datas.putdatas_status(identifier, "published", headers, apitest=true)
@test putdatas_status_response["status"] == 204



## Récupération pour un utilisateur de la liste des objets fichiers déposés non encore associés à une donnée.
headers = Dict( "X-API-KEY" => apikey, "Content-Type" => "application/json" )
getdatas_uploads_response = Nakala.Datas.getdatas_uploads(headers, apitest=true)

@test getdatas_uploads_response["status"] == 200


## Suppression d'un fichier déposé dans l'espace temporaire
# dépôt d'un fichier
headers = Dict( "X-API-KEY" => apikey, :accept => "application/json" )
file = "$path/testdata/file.txt"
postdatas_uploads_response = Nakala.Datas.postdatas_uploads(file, headers, apitest=true)
sha1 = postdatas_uploads_response["body"]["sha1"]

# lister les fichiers en attente
headers = Dict( "X-API-KEY" => apikey, "Content-Type" => "application/json" )
getdatas_uploads_response = Nakala.Datas.getdatas_uploads(headers, apitest=true)

# supprimer les fichiers en attente
headers = Dict( "X-API-KEY" => apikey, "Content-Type" => "application/json" )
deletedatas_uploads_response = Nakala.Datas.deletedatas_uploads(sha1, headers, apitest=true)

#test
@test deletedatas_uploads_response["status"] == 200



## Téléchargement des fichiers déposés associés à une donnée.
identifier = createData()[:dataIdentifier]
header = Dict( "X-API-KEY" => apikey, "Content-Type" => "application/json" )
output = "$path/download"
Nakala.Datas.downloaddatas_files(identifier,  output, header, apitest=true)