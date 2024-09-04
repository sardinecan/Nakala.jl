using Test
using JSON

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
postgroups_response = Nakala.Groups.postgroups(headers, body, true)
postgroups_response["response"]["payload"]["id"]
@test postgroups_response["code"] == 201


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
postgroups_response = Nakala.Groups.postgroups(headers, body, true)
groupid = postgroups_response["response"]["payload"]["id"]

# récupération des informations du groupe
getgroups_response = Nakala.Groups.getgroups(groupid, headers, true)
@test getgroups_response["response"]["name"] == "Nakala.jl"


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
      :username => "unakala1",
      :role => "ROLE_USER"
  )]
)
postgroups_response = Nakala.Groups.postgroups(headers, body, true)
groupid = postgroups_response["response"]["payload"]["id"]

# modification du groupe
body = Dict(
  :name => "Nakala.jl",
  :users => [
    Dict( :username => "unakala1", :role => "ROLE_USER" ),
    Dict( :username => "unakala2", :role => "ROLE_USER" ),
  ]
)
putgroups_response = Nakala.Groups.putgroups(groupid, headers, body, true)

getgroups_response = Nakala.Groups.getgroups(groupid, headers, true)
getgroups_response["response"]["users"]
@test length(getgroups_response["response"]["users"]) == 3


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
getgroups_search_response = Nakala.Groups.getgroups_search(params, headers, true)

@test getgroups_search_response["code"] == 200

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
postgroups_response = Nakala.Groups.postgroups(headers, body, true)
groupid = postgroups_response["response"]["payload"]["id"]

# suppression du groupe
deletegroups_response = Nakala.Groups.deletegroups(groupid, headers, true)
@test deletegroups_response == 200