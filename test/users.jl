@testset "users" begin
  #==
  Récupération des informations sur l'utilisateur courant.
  ==#
  headers = Dict("X-API-KEY" => apikey, "Content-Type" => "application/json")
  getusers_me_response = Nakala.Users.getusers_me(headers, apitest=true)

  @test getusers_me_response["status"] == 200
  getusers_me_response["body"]["photo"]

  #==
  Mise à jour des informations sur l'utilisateur courant.
  ==#
  headers = Dict("X-API-KEY" => apikey, "Content-Type" => "application/json")
  body = Dict(:givenname => "Test", :surname => "Nakala", :mail => "nakala@huma-num.fr", :photo => "http://mynakala.photo")

  putusers_me_response = Nakala.Users.putusers_me(headers, body, apitest=true)
  @test Nakala.Users.getusers_me(headers, apitest=true)["body"]["photo"] == "http://mynakala.photo"

  #==
  Mise à jour de la clé d'API de l'utilisateur courant.
  ==#
  apikey_user3 = "f41f5957-d396-3bb9-ce35-a4692773f636"
  headers = Dict("X-API-KEY" => apikey_user3, "Content-Type" => "application/json")
  putusers_me_apikey_response = Nakala.Users.putusers_me_apikey(headers, apitest=true)

  # retourne une erreur car pas de droit pour l'api test
  @test putusers_me_apikey_response["status"] == 403

  #==
  Récupération des données accessibles par un utilisateur.
  ==#
  headers = Dict("X-API-KEY" => apikey, "Content-Type" => "application/json")
  scope = "deposited"
  body = Dict(
    :page => 1,
    #:limit => 100,
    :orders => ["creDate,desc"],
    #:types => [ "http://purl.org/coar/resource_type/c_c513" ],
    #:status => [ "published" ],
    #:createdYears => [ "2020" ],
    #:collections => [ "11280/9f85fbd6" ],
    #:titleSearch => "",
    :titleSearchLang => "fr",
    #:orderLang => "fr"
  )

  postusers_datas_response = Nakala.Users.postusers_datas(scope, headers, body, apitest=true)

  @test postusers_datas_response["status"] == 200

  #==
  Récupération des types des données accessibles par un utilisateur.
  ==#
  headers = Dict("X-API-KEY" => apikey, "Content-Type" => "application/json")
  params = [
    :scope => "all",
    "collections[]" => "abc",
    "collections[]" => "def"
  ]

  getusers_datas_datatypes_response = Nakala.Users.getusers_datas_datatypes(params, headers, apitest=true)
  @test getusers_datas_datatypes_response["status"] == 200

  #==
  Récupération des différentes années de création des données accessibles par un utilisateur.
  ==#
  headers = Dict("X-API-KEY" => apikey, "Content-Type" => "application/json")
  params = [
    :scope => "all",
    "collections[]" => "abc",
    "collections[]" => "def"
  ]

  getusers_datas_createdyears_response = Nakala.Users.getusers_datas_createdyears(params, headers, apitest=true)
  @test getusers_datas_createdyears_response["status"] == 200

  #==
  Récupération des différents statuts des données accessibles par un utilisateur.
  ==#
  headers = Dict("X-API-KEY" => apikey, "Content-Type" => "application/json")
  params = [
    :scope => "all",
    "collections[]" => "abc",
    "collections[]" => "def"
  ]

  getusers_datas_statuses_response = Nakala.Users.getusers_datas_statuses(params, headers, apitest=true)
  @test getusers_datas_statuses_response["status"] == 200

  #==
  Récupération des groupes d'un utilisateur.
  ==#
  headers = Dict("X-API-KEY" => apikey, "Content-Type" => "application/json")
  scope = "all"
  params = [
    :q => "nakala",
    :page => 1,
    :limit => 10,
    :order => "datemodify,desc"
  ]

  getusers_groups_response = Nakala.Users.getusers_groups(scope, params, headers, apitest=true)
  @test getusers_groups_response["status"] == 200

  #==
  Récupération des différentes années de création des collections accessibles par un utilisateur.
  ==#
  headers = Dict("X-API-KEY" => apikey, "Content-Type" => "application/json")
  params = [:scope => "all"]

  getusers_collections_createdyears_response = Nakala.Users.getusers_collections_createdyears(params, headers, apitest=true)
  @test getusers_collections_createdyears_response["status"] == 200

  #==
  Récupération des différents statuts des collections accessibles par un utilisateur.
  ==#
  headers = Dict("X-API-KEY" => apikey, "Content-Type" => "application/json")
  params = [:scope => "all"]

  getusers_collections_statuses_response = Nakala.Users.getusers_collections_statuses(params, headers, apitest=true)
  @test getusers_collections_statuses_response["status"] == 200

  #==
  Récupération des collections accessibles par un utilisateur.
  ==#
  headers = Dict("X-API-KEY" => apikey, "Content-Type" => "application/json")
  scope = "owned"
  body = Dict(
    :page => 1,
    :limit => 100,
    #:orders => [ "creDate,desc" ],
    #:createdYears => [ "2020" ],
    #:status => [ "public" ],
    #:titleSearch => "",
    #:titleSearchLang => "fr",
    #:orderLang => "fr"
  )
  postusers_collections_response = Nakala.Users.postusers_collections(scope, headers, body, apitest=true)
  @test postusers_collections_response["status"] == 200
end