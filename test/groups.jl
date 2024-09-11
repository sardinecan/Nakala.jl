using Test, Nakala

apikey = "01234567-89ab-cdef-0123-456789abcdef" #public key for test api
privateapikey = ""  #private key for api for status test

#==
Créer un groupe d'utilisateurs
==#
headers = Dict(
  "X-API-KEY" => apikey,
  "Content-Type" => "application/json"
)
body = Dict(
  :name => "Nakala.jl",
  :users => [Dict(
      :username => "unakala1",
      :role => "ROLE_USER"
  )]
)
postgroups_response = Nakala.Groups.postgroups(headers, body, apitest=true)
postgroups_response["body"]["payload"]["id"]
@test postgroups_response["status"] == 201


#==
Récupération des informations sur un groupe d'utilisateurs.
==#
# création d'un groupe
headers = Dict(
  "X-API-KEY" => apikey,
  "Content-Type" => "application/json"
)
body = Dict(
  :name => "Nakala.jl",
  :users => [Dict(
      :username => "unakala1",
      :role => "ROLE_USER"
  )]
)
postgroups_response = Nakala.Groups.postgroups(headers, body, apitest=true)
groupid = postgroups_response["body"]["payload"]["id"]

# récupération des informations du groupe
getgroups_response = Nakala.Groups.getgroups(groupid, headers, apitest=true)
@test getgroups_response["body"]["name"] == "Nakala.jl_2"


#==
Modification d'un groupe d'utilisateurs.
==#
# création d'un groupe
headers = Dict(
  "X-API-KEY" => apikey,
  "Content-Type" => "application/json"
)
body = Dict(
  :name => "Nakala.jl",
  :users => [Dict(
      :username => "unakala2",
      :role => "ROLE_USER"
  )]
)
postgroups_response = Nakala.Groups.postgroups(headers, body, apitest=true)
groupid = postgroups_response["body"]["payload"]["id"]

# modification du groupe
body = Dict(
  :name => "Nakala.jl",
  :users => [
    Dict( :username => "unakala1", :role => "ROLE_USER" ),
    Dict( :username => "unakala2", :role => "ROLE_USER" ),
  ]
)
putgroups_response = Nakala.Groups.putgroups(groupid, headers, body, apitest=true)

getgroups_response = Nakala.Groups.getgroups(groupid, headers, apitest=true)
getgroups_response["body"]["users"]
@test length(getgroups_response["body"]["users"]) == 3


#==
Récupération des utilisateurs et groupes d'utilisateurs.
==#
headers = Dict(
  "X-API-KEY" => apikey,
  "Content-Type" => "application/json"
)
params = [
  :q => "Nakala",
  :order => "asc",
  :page => 1,
  :limit => 10
]
getgroups_search_response = Nakala.Groups.getgroups_search(params, headers, apitest=true)

@test getgroups_search_response["status"] == 200

#==
Suppression d'un groupe d'utilisateurs.
==#
# creation d'un groupe
headers = Dict(
  "X-API-KEY" => apikey,
  "Content-Type" => "application/json"
)
body = Dict(
  :name => "Nakala.jl",
  :users => [Dict(
      :username => "unakala1",
      :role => "ROLE_USER"
  )]
)
postgroups_response = Nakala.Groups.postgroups(headers, body, apitest=true)
groupid = postgroups_response["body"]["payload"]["id"]

# suppression du groupe
deletegroups_response = Nakala.Groups.deletegroups(groupid, headers, apitest=true)
@test deletegroups_response["status"] == 200