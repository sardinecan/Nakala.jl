using Test
using JSON

path = @__DIR__
apikey = "01234567-89ab-cdef-0123-456789abcdef" #public key for test api
privateapikey = ""  #private key for api for status test

#==
Créer une collection
==#
headers = Dict(
  "X-API-KEY" => apikey,
  "Content-Type" => "application/json"
)
body = Dict(
  :status => "public",
  :metas => [Dict(:value => "Collection", :propertyUri => "http://nakala.fr/terms#title", :lang => "fr", :typeUri => "http://www.w3.org/2001/XMLSchema#string"),],
  :datas => [],
  :rights => []
)

postcollections_response = Nakala.Collections.postcollections(headers, body, true)
@test postcollections_response["code"] == 201

#Nakala.Collections.postcollection(headers, body, true)["response"]["payload"]["id"]


#==
Récupération des informations sur une collection
==#
# création d'une collection
headers = Dict(
  "X-API-KEY" => apikey,
  "Content-Type" => "application/json"
)
body = Dict(
  :status => "public",
  :metas => [Dict(:value => "Get collections test", :propertyUri => "http://nakala.fr/terms#title", :lang => "en", :typeUri => "http://www.w3.org/2001/XMLSchema#string"),],
  :datas => [],
  :rights => []
)
postcollections_response = Nakala.Collections.postcollections(headers, body, true)
identifier = postcollections_response["response"]["payload"]["id"]

# récupération des informations de la collection
getcollections_response = Nakala.Collections.getcollections(identifier, headers, true)

#test
@test getcollections_response["code"] == 200
@test getcollections_response["response"]["metas"][1]["value"] == "Get collections test"

#==
Modification des informations d'une collection
==#
# creation d'une collection
headers = Dict(
  "X-API-KEY" => apikey,
  "Content-Type" => "application/json"
)
body = Dict(
  :status => "public",
  :metas => [Dict(:value => "Get collections test", :propertyUri => "http://nakala.fr/terms#title", :lang => "en", :typeUri => "http://www.w3.org/2001/XMLSchema#string"),],
  :datas => [],
  :rights => []
)
postcollections_response = Nakala.Collections.postcollections(headers, body, true)
identifier = postcollections_response["response"]["payload"]["id"]

# modification des informations
body = Dict(
  :status => "public",
  :metas => [Dict(:value => "Test de postcollections", :propertyUri => "http://nakala.fr/terms#title", :lang => "fr", :typeUri => "http://www.w3.org/2001/XMLSchema#string"),],
  :datas => [],
  :rights => []
)
putcollections_response = Nakala.Collections.putcollections(identifier, headers, body, true)
getcollections_response = Nakala.Collections.getcollections(identifier, headers, true)

#test
@test putcollections_response == 204
@test getcollections_response["response"]["metas"][1]["value"] == "Test de postcollections"


#==
Suppression d'une collection.
==#
# création d'une collection
headers = Dict(
  "X-API-KEY" => apikey,
  "Content-Type" => "application/json"
)
body = Dict(
  :status => "public",
  :metas => [Dict(:value => "Get collections test", :propertyUri => "http://nakala.fr/terms#title", :lang => "en", :typeUri => "http://www.w3.org/2001/XMLSchema#string"),],
  :datas => [],
  :rights => []
)
postcollections_response = Nakala.Collections.postcollections(headers, body, true)
identifier = postcollections_response["response"]["payload"]["id"]

# suppression de la collection
deletecollections_response = Nakala.Collections.deletecollections(identifier, headers, true)
getcollections_response = Nakala.Collections.getcollections(identifier, headers, true)

@test deletecollections_response == 204
@test getcollections_response["code"] == 404


#==
Ajout d'une liste de données dans une collection.
==#
# dépot d'un fichier
headers = Dict( "X-API-KEY" => apikey, :accept => "application/json" )
file = "$path/file.txt"
postfiles_response = Nakala.postfiles(file, headers, true)
sha1 = postfiles_response["response"]["sha1"]

# création d'une donnée
headers = Dict( "X-API-KEY" => apikey, "Content-Type" => "application/json" )
body = Dict(
  :collectionsIds => [],
  :files => [
    Dict("name" => "file.txt", "sha1" => sha1, "embargoed" => "2024-09-01")
  ],
  :status => "published",
  :metas => [
    Dict(:value => "Ma donnée", :propertyUri => "http://nakala.fr/terms#title", :lang => "fr", :typeUri => "http://www.w3.org/2001/XMLSchema#string"),
    Dict(:value => "http://purl.org/coar/resource_type/c_18cf", :propertyUri => "http://nakala.fr/terms#type", :typeUri => "http://www.w3.org/2001/XMLSchema#anyURI"),
    Dict(:value => Dict(:surname => "unknown", :givenname => "user"), :propertyUri => "http://nakala.fr/terms#creator", :typeUri => "http://www.w3.org/2001/XMLSchema#string"),
    Dict(:value => "2024-09-01", :propertyUri => "http://nakala.fr/terms#created", :typeUri => "http://www.w3.org/2001/XMLSchema#string"),
    Dict(:value => "PDM", :propertyUri => "http://nakala.fr/terms#license", :typeUri => "http://www.w3.org/2001/XMLSchema#string"),
    Dict(:value => "Description", :propertyUri => "http://purl.org/dc/terms/description", :lang => "fr", :typeUri => "http://www.w3.org/2001/XMLSchema#string"),
    Dict(
      :value => Dict(
        :surname => "Rémi",
        :givenname => "Fassol"
      ),
      :propertyUri => "http://nakala.fr/terms#creator"
    )
  ],
  :rights => []
)
postdatas_response = Nakala.postdatas(headers, body, true)
data_identifier = postdatas_response["response"]["payload"]["id"]

# création d'une collection
headers = Dict(
  "X-API-KEY" => apikey,
  "Content-Type" => "application/json"
)
body = Dict(
  :status => "public",
  :metas => [Dict(:value => "Ma collection", :propertyUri => "http://nakala.fr/terms#title", :lang => "en", :typeUri => "http://www.w3.org/2001/XMLSchema#string"),],
  :datas => [],
  :rights => []
)
postcollections_response = Nakala.Collections.postcollections(headers, body, true)
identifier = postcollections_response["response"]["payload"]["id"]

# ajout de la donnée dans la collection
headers = Dict(
  "X-API-KEY" => apikey,
  "Content-Type" => "application/json"
)
body = [ data_identifier ]
postcollections_datas_response = Nakala.Collections.postcollections_datas(identifier, headers, body, true) 

# test
@test postcollections_datas_response["code"] == 201

#==
Récupération de la liste paginée des données contenues dans la collection.
==#
# dépot d'un fichier
headers = Dict( "X-API-KEY" => apikey, :accept => "application/json" )
file = "$path/file.txt"
postfiles_response = Nakala.postfiles(file, headers, true)
sha1 = postfiles_response["response"]["sha1"]

# création d'une donnée
headers = Dict( "X-API-KEY" => apikey, "Content-Type" => "application/json" )
body = Dict(
  :collectionsIds => [],
  :files => [
    Dict("name" => "file.txt", "sha1" => sha1, "embargoed" => "2024-09-01")
  ],
  :status => "published",
  :metas => [
    Dict(:value => "Ma donnée", :propertyUri => "http://nakala.fr/terms#title", :lang => "fr", :typeUri => "http://www.w3.org/2001/XMLSchema#string"),
    Dict(:value => "http://purl.org/coar/resource_type/c_18cf", :propertyUri => "http://nakala.fr/terms#type", :typeUri => "http://www.w3.org/2001/XMLSchema#anyURI"),
    Dict(:value => Dict(:surname => "unknown", :givenname => "user"), :propertyUri => "http://nakala.fr/terms#creator", :typeUri => "http://www.w3.org/2001/XMLSchema#string"),
    Dict(:value => "2024-09-01", :propertyUri => "http://nakala.fr/terms#created", :typeUri => "http://www.w3.org/2001/XMLSchema#string"),
    Dict(:value => "PDM", :propertyUri => "http://nakala.fr/terms#license", :typeUri => "http://www.w3.org/2001/XMLSchema#string"),
    Dict(:value => "Description de ma donnée", :propertyUri => "http://purl.org/dc/terms/description", :lang => "fr", :typeUri => "http://www.w3.org/2001/XMLSchema#string"),
    Dict(
      :value => Dict(
        :surname => "Rémi",
        :givenname => "Fassol"
      ),
      :propertyUri => "http://nakala.fr/terms#creator"
    )
  ],
  :rights => []
)
postdatas_response = Nakala.postdatas(headers, body, true)
data_identifier = postdatas_response["response"]["payload"]["id"]

# création d'une collection
headers = Dict(
  "X-API-KEY" => apikey,
  "Content-Type" => "application/json"
)
body = Dict(
  :status => "public",
  :metas => [Dict(:value => "Ma collection", :propertyUri => "http://nakala.fr/terms#title", :lang => "en", :typeUri => "http://www.w3.org/2001/XMLSchema#string"),],
  :datas => [],
  :rights => []
)
postcollections_response = Nakala.Collections.postcollections(headers, body, true)
identifier = postcollections_response["response"]["payload"]["id"]

# ajout de la donnée dans la collection
headers = Dict(
  "X-API-KEY" => apikey,
  "Content-Type" => "application/json"
)
body = [ data_identifier ]
postcollections_datas_response = Nakala.Collections.postcollections_datas(identifier, headers, body, true) 

# Récupération de la liste paginée des données contenues dans la collection.
params = [ :page => 1, :limit => 10 ]
getcollections_datas_response = Nakala.Collections.getcollections_datas(identifier, params, headers, true) 
getcollections_datas_response["response"]["data"][1]["identifier"]

@test getcollections_datas_response["code"] == 200
@test getcollections_datas_response["response"]["data"][1]["identifier"] == data_identifier


#==
Suppression d'une liste de données d'une collection.
==#
# dépot d'un fichier
headers = Dict( "X-API-KEY" => apikey, :accept => "application/json" )
file = "$path/file.txt"
postfiles_response = Nakala.postfiles(file, headers, true)
sha1 = postfiles_response["response"]["sha1"]

# création d'une donnée
headers = Dict( "X-API-KEY" => apikey, "Content-Type" => "application/json" )
body = Dict(
  :collectionsIds => [],
  :files => [
    Dict("name" => "file.txt", "sha1" => sha1, "embargoed" => "2024-09-01")
  ],
  :status => "published",
  :metas => [
    Dict(:value => "Ma donnée", :propertyUri => "http://nakala.fr/terms#title", :lang => "fr", :typeUri => "http://www.w3.org/2001/XMLSchema#string"),
    Dict(:value => "http://purl.org/coar/resource_type/c_18cf", :propertyUri => "http://nakala.fr/terms#type", :typeUri => "http://www.w3.org/2001/XMLSchema#anyURI"),
    Dict(:value => Dict(:surname => "unknown", :givenname => "user"), :propertyUri => "http://nakala.fr/terms#creator", :typeUri => "http://www.w3.org/2001/XMLSchema#string"),
    Dict(:value => "2024-09-01", :propertyUri => "http://nakala.fr/terms#created", :typeUri => "http://www.w3.org/2001/XMLSchema#string"),
    Dict(:value => "PDM", :propertyUri => "http://nakala.fr/terms#license", :typeUri => "http://www.w3.org/2001/XMLSchema#string"),
    Dict(:value => "Description de ma donnée", :propertyUri => "http://purl.org/dc/terms/description", :lang => "fr", :typeUri => "http://www.w3.org/2001/XMLSchema#string"),
    Dict(
      :value => Dict(
        :surname => "Rémi",
        :givenname => "Fassol"
      ),
      :propertyUri => "http://nakala.fr/terms#creator"
    )
  ],
  :rights => []
)
postdatas_response = Nakala.postdatas(headers, body, true)
data_identifier = postdatas_response["response"]["payload"]["id"]

# création d'une collection
headers = Dict(
  "X-API-KEY" => apikey,
  "Content-Type" => "application/json"
)
body = Dict(
  :status => "public",
  :metas => [Dict(:value => "Ma collection", :propertyUri => "http://nakala.fr/terms#title", :lang => "en", :typeUri => "http://www.w3.org/2001/XMLSchema#string"),],
  :datas => [],
  :rights => []
)
postcollections_response = Nakala.Collections.postcollections(headers, body, true)
identifier = postcollections_response["response"]["payload"]["id"]

# ajout de la donnée dans la collection
headers = Dict(
  "X-API-KEY" => apikey,
  "Content-Type" => "application/json"
)
body = [ data_identifier ]
postcollections_datas_response = Nakala.Collections.postcollections_datas(identifier, headers, body, true) 

# suppression de la donnée de la collection
headers = Dict(
  "X-API-KEY" => apikey,
  "Content-Type" => "application/json"
)
body = [ data_identifier ]
deletecollections_datas_response = Nakala.Collections.deletecollections_datas(identifier, headers, body, true)

# Récupération de la liste paginée des données contenues dans la collection.
params = [ :page => 1, :limit => 10 ]
getcollections_datas_response = Nakala.Collections.getcollections_datas(identifier, params, headers, true) 

@test deletecollections_datas_response["code"] == 200
@test getcollections_datas_response["response"]["total"] == 0



#==
Récupération des métadonnées d'une collection.
==#
# création d'une collection
headers = Dict(
  "X-API-KEY" => apikey,
  "Content-Type" => "application/json"
)
body = Dict(
  :status => "public",
  :metas => [Dict(:value => "Ma collection", :propertyUri => "http://nakala.fr/terms#title", :lang => "fr", :typeUri => "http://www.w3.org/2001/XMLSchema#string"),],
  :datas => [],
  :rights => []
)
postcollections_response = Nakala.Collections.postcollections(headers, body, true)
identifier = postcollections_response["response"]["payload"]["id"]

# récupération des métadonnées
headers = Dict(
  "X-API-KEY" => apikey,
  "Content-Type" => "application/json"
)
getcollections_metadatas_response = Nakala.Collections.getcollections_metadatas(identifier, headers, true)

#test
@test getcollections_metadatas_response["code"] == 200

#==
Ajout d'une nouvelle métadonnée à une collection.
==#
# création d'une collection
headers = Dict(
  "X-API-KEY" => apikey,
  "Content-Type" => "application/json"
)
body = Dict(
  :status => "public",
  :metas => [Dict(:value => "Ma collection", :propertyUri => "http://nakala.fr/terms#title", :lang => "fr", :typeUri => "http://www.w3.org/2001/XMLSchema#string")],
  :datas => [],
  :rights => []
)
postcollections_response = Nakala.Collections.postcollections(headers, body, true)
identifier = postcollections_response["response"]["payload"]["id"]

# ajout d'une nouvelle métadonnée
headers = Dict(
  "X-API-KEY" => apikey,
  "Content-Type" => "application/json"
)
body = Dict(:value => "My collection", :propertyUri => "http://nakala.fr/terms#title", :lang => "en", :typeUri => "http://www.w3.org/2001/XMLSchema#string")
postcollections_metadatas_response = Nakala.Collections.postcollections_metadatas(identifier, headers, body, true)
getcollections_metadatas_response = Nakala.Collections.getcollections_metadatas(identifier, headers, true)

@test postcollections_metadatas_response["code"] == 201
@test length(getcollections_metadatas_response["response"]) == 2


#==
Ajout de droits sur une collection.
==#
# creation d'une collection
headers = Dict(
  "X-API-KEY" => apikey,
  "Content-Type" => "application/json"
)
body = Dict(
  :status => "public",
  :metas => [Dict(:value => "Ma collection", :propertyUri => "http://nakala.fr/terms#title", :lang => "fr", :typeUri => "http://www.w3.org/2001/XMLSchema#string"),],
  :datas => [],
  :rights => []
)
postcollections_response = Nakala.Collections.postcollections(headers, body, true)
identifier = postcollections_response["response"]["payload"]["id"]

# ajout de droits sur une collection
body = [ Dict( :id => "c7e9bb15-6b4e-4e09-b234-ae7b13ac1f3b", :role => "ROLE_READER" ) ] # id of public profile unakala1
postcollections_rights_response = Nakala.Collections.postcollections_rights(identifier, headers, body, true)

#test
@test postcollections_rights_response["code"] == 200

#==
Récupération des utilisateurs et des groupes ayant des droits sur la collection.
==#
# creation d'une collection
headers = Dict(
  "X-API-KEY" => apikey,
  "Content-Type" => "application/json"
)
body = Dict(
  :status => "public",
  :metas => [Dict(:value => "Ma collection", :propertyUri => "http://nakala.fr/terms#title", :lang => "fr", :typeUri => "http://www.w3.org/2001/XMLSchema#string"),],
  :datas => [],
  :rights => []
)
postcollections_response = Nakala.Collections.postcollections(headers, body, true)
identifier = postcollections_response["response"]["payload"]["id"]

# récupération des utilisateurs / groupes ayant des droits sur la collection
getcollections_rights_response = Nakala.Collections.getcollections_rights(identifier, headers, true)
@test getcollections_rights_response["code"] == 200

#==
Suppression des droits pour utilisateur ou un groupe d'utilisateurs sur une collection.
==#
headers = Dict(
  "X-API-KEY" => apikey,
  "Content-Type" => "application/json"
)
body = Dict(
  :status => "public",
  :metas => [Dict(:value => "Ma collection", :propertyUri => "http://nakala.fr/terms#title", :lang => "fr", :typeUri => "http://www.w3.org/2001/XMLSchema#string"),],
  :datas => [],
  :rights => []
)
postcollections_response = Nakala.Collections.postcollections(headers, body, true)
identifier = postcollections_response["response"]["payload"]["id"]

# ajout de droits sur la collection
body = [ Dict( :id => "c7e9bb15-6b4e-4e09-b234-ae7b13ac1f3b", :role => "ROLE_READER" ) ] # id of public profile unakala1
postcollections_rights_response = Nakala.Collections.postcollections_rights(identifier, headers, body, true)

# suppression des droits sur la collection
headers = Dict( "X-API-KEY" => apikey, "Content-Type" => "application/json" )
body = Dict( :id => "c7e9bb15-6b4e-4e09-b234-ae7b13ac1f3b", :role => "ROLE_READER" )
deletecollections_rights_response = Nakala.Collections.deletecollections_rights(identifier, headers, body, true)
@test deletecollections_rights_response["code"] == 200

#==
Récupération du statut d'une collection.
NB : nécessite d'être testé avec une clé personnelle
==#
# creation d'une collection
headers = Dict(
  "X-API-KEY" => privateapikey,
  "Content-Type" => "application/json"
)
body = Dict(
  :status => "private",
  :metas => [Dict(:value => "Ma collection", :propertyUri => "http://nakala.fr/terms#title", :lang => "fr", :typeUri => "http://www.w3.org/2001/XMLSchema#string"),],
  :datas => [],
  :rights => []
)
postcollections_response = Nakala.Collections.postcollections(headers, body)
postcollections_response["response"]
identifier = postcollections_response["response"]["payload"]["id"]

# récupération du statut de la collection
getcollections_status_response = Nakala.Collections.getcollections_status(identifier, headers)
getcollections_status_response["response"]
getcollections_status_response["code"]


#==
Changement du statut d'une collection.
NB : nécessite d'être testé avec une clé personnelle
==#
# creation d'une collection
headers = Dict(
  "X-API-KEY" => privateapikey,
  "Content-Type" => "application/json"
)
body = Dict(
  :status => "private",
  :metas => [Dict(:value => "Ma collection", :propertyUri => "http://nakala.fr/terms#title", :lang => "fr", :typeUri => "http://www.w3.org/2001/XMLSchema#string"),],
  :datas => [],
  :rights => []
)
postcollections_response = Nakala.Collections.postcollections(headers, body)
postcollections_response["response"]
identifier = postcollections_response["response"]["payload"]["id"]

# récupération du statut de la collection
getcollections_status_response = Nakala.Collections.getcollections_status(identifier, headers)
getcollections_status_response["response"]
getcollections_status_response["code"]

#changement du statut
putcollections_status_response = Nakala.Collections.putcollections_status(identifier, "public", headers)
@test putcollections_status_response == 204