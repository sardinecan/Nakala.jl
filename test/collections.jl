@testset "collections" begin
  @testset "collections.collection" begin
    ## Créer une collection
    headers = Dict( "X-API-KEY" => apikey, "Content-Type" => "application/json" )
    body = Dict(
      :status => "public",
      :metas => [Dict(:value => "Nakala.jl collection", :propertyUri => "http://nakala.fr/terms#title", :lang => "en", :typeUri => "http://www.w3.org/2001/XMLSchema#string"),],
      :datas => [],
      :rights => []
    )

    postcollections_response = Nakala.Collections.postcollections(headers, body, apitest=true)
    identifier = postcollections_response["body"]["payload"]["id"]
    @test postcollections_response["status"] == 201


    ## Récupération des informations sur une collection
    getcollections_response = Nakala.Collections.getcollections(identifier, headers, apitest=true)

    #test
    @test getcollections_response["status"] == 200
    @test getcollections_response["body"]["metas"][1]["value"] == "Nakala.jl collection"


    ## Modification des informations d'une collection
    body = Dict(
      :status => "public",
      :metas => [Dict(:value => "Collection Nakala.jl", :propertyUri => "http://nakala.fr/terms#title", :lang => "fr", :typeUri => "http://www.w3.org/2001/XMLSchema#string"),],
      :datas => [],
      :rights => []
    )
    putcollections_response = Nakala.Collections.putcollections(identifier, headers, body, apitest=true)
    getcollections_response = Nakala.Collections.getcollections(identifier, headers, apitest=true)

    #test
    @test putcollections_response["status"] == 204


    ## Suppression d'une collection.
    identifier = identifier
    deletecollections_response = Nakala.Collections.deletecollections(identifier, headers, apitest=true)
    getcollections_response = Nakala.Collections.getcollections(identifier, headers, apitest=true)

    @test deletecollections_response["status"] == 204
    @test getcollections_response["status"] == 404
  end

  @testset "collections.datas" begin
    ## Ajout d'une liste de données dans une collection.
    # dépot d'un fichier
    data_identifier = createData()[:dataIdentifier]

    # création d'une collection
    headers = Dict( "X-API-KEY" => apikey, "Content-Type" => "application/json" )
    body = Dict(
      :status => "private",
      :metas => [Dict(:value => "Ma collection", :propertyUri => "http://nakala.fr/terms#title", :lang => "en", :typeUri => "http://www.w3.org/2001/XMLSchema#string"),],
      :datas => [],
      :rights => []
    )
    postcollections_response = Nakala.Collections.postcollections(headers, body, apitest=true)
    identifier = postcollections_response["body"]["payload"]["id"]

    # ajout de la donnée dans la collection
    headers = Dict( "X-API-KEY" => apikey, "Content-Type" => "application/json" )
    body = [data_identifier]
    postcollections_datas_response = Nakala.Collections.postcollections_datas(identifier, headers, body, apitest=true)

    @test postcollections_datas_response["status"] == 201


    ## Récupération de la liste paginée des données contenues dans la collection.
    params = [:page => 1, :limit => 10]
    getcollections_datas_response = Nakala.Collections.getcollections_datas(identifier, params, headers, apitest=true)
    getcollections_datas_response["body"]["data"][1]["identifier"]

    @test getcollections_datas_response["status"] == 200
    @test getcollections_datas_response["body"]["data"][1]["identifier"] == data_identifier


    ## Suppression d'une liste de données d'une collection.
    headers = Dict( "X-API-KEY" => apikey, "Content-Type" => "application/json" )
    body = [data_identifier]
    deletecollections_datas_response = Nakala.Collections.deletecollections_datas(identifier, headers, body, apitest=true)

    # Récupération de la liste paginée des données contenues dans la collection.
    params = [:page => 1, :limit => 10]
    getcollections_datas_response = Nakala.Collections.getcollections_datas(identifier, params, headers, apitest=true)

    @test deletecollections_datas_response["status"] == 200
    @test getcollections_datas_response["body"]["total"] == 0

    # suppression de la collection
    deletecollections_response = Nakala.Collections.deletecollections(identifier, headers, apitest=true)
    @test deletecollections_response["status"] == 204

    # suppression de la donnée
    headers = Dict("X-API-KEY" => apikey, :accept => "application/json")
    deletedatas_response = Nakala.Datas.deletedatas(data_identifier, headers, apitest=true)
  end


  @testset "collections.metadatas" begin
    ## Récupération des métadonnées d'une collection.
    # création d'une collection
    headers = Dict( "X-API-KEY" => apikey, "Content-Type" => "application/json" )
    body = Dict(
      :status => "public",
      :metas => [Dict(:value => "Ma collection", :propertyUri => "http://nakala.fr/terms#title", :lang => "fr", :typeUri => "http://www.w3.org/2001/XMLSchema#string"),],
      :datas => [],
      :rights => []
    )
    postcollections_response = Nakala.Collections.postcollections(headers, body, apitest=true)
    identifier = postcollections_response["body"]["payload"]["id"]

    # récupération des métadonnées
    headers = Dict(
      "X-API-KEY" => apikey,
      "Content-Type" => "application/json"
    )
    getcollections_metadatas_response = Nakala.Collections.getcollections_metadatas(identifier, headers, apitest=true)

    #test
    @test getcollections_metadatas_response["status"] == 200



    ## Ajout d'une nouvelle métadonnée à une collection.
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
    postcollections_response = Nakala.Collections.postcollections(headers, body, apitest=true)
    identifier = postcollections_response["body"]["payload"]["id"]

    # ajout d'une nouvelle métadonnée
    headers = Dict(
      "X-API-KEY" => apikey,
      "Content-Type" => "application/json"
    )
    body = Dict(:value => "My collection", :propertyUri => "http://nakala.fr/terms#title", :lang => "en", :typeUri => "http://www.w3.org/2001/XMLSchema#string")
    postcollections_metadatas_response = Nakala.Collections.postcollections_metadatas(identifier, headers, body, apitest=true)
    getcollections_metadatas_response = Nakala.Collections.getcollections_metadatas(identifier, headers, apitest=true)

    @test postcollections_metadatas_response["status"] == 201
    @test length(getcollections_metadatas_response["body"]) == 2

    # suppression de la collection
    deletecollections_response = Nakala.Collections.deletecollections(identifier, headers, apitest=true)
    @test deletecollections_response["status"] == 204
  end

  @testset "collections.rights" begin
    ## Ajout de droits sur une collection.
    # creation d'une collection
    headers = Dict( "X-API-KEY" => apikey, "Content-Type" => "application/json" )
    body = Dict(
      :status => "public",
      :metas => [Dict(:value => "Ma collection", :propertyUri => "http://nakala.fr/terms#title", :lang => "fr", :typeUri => "http://www.w3.org/2001/XMLSchema#string"),],
      :datas => [],
      :rights => []
    )
    postcollections_response = Nakala.Collections.postcollections(headers, body, apitest=true)
    identifier = postcollections_response["body"]["payload"]["id"]

    # ajout de droits sur une collection
    body = [Dict(:id => userid, :role => "ROLE_READER")]
    postcollections_rights_response = Nakala.Collections.postcollections_rights(identifier, headers, body, apitest=true)

    #test
    @test postcollections_rights_response["status"] == 200



    ## Récupération des utilisateurs et des groupes ayant des droits sur la collection.
    getcollections_rights_response = Nakala.Collections.getcollections_rights(identifier, headers, apitest=true)
    @test getcollections_rights_response["status"] == 200



    ## Suppression des droits pour utilisateur ou un groupe d'utilisateurs sur une collection.
    headers = Dict("X-API-KEY" => apikey, "Content-Type" => "application/json")
    body = Dict(:id => userid, :role => "ROLE_READER")
    deletecollections_rights_response = Nakala.Collections.deletecollections_rights(identifier, headers, body, apitest=true)
    @test deletecollections_rights_response["status"] == 200

    # suppression de la collection
    deletecollections_response = Nakala.Collections.deletecollections(identifier, headers, apitest=true)
    @test deletecollections_response["status"] == 204
  end

  #==
  @testset "collections.status" begin
    ## Récupération du statut d'une collection.
    # NB : nécessite d'être testé avec une clé personnelle
    # creation d'une collection
    headers = Dict( "X-API-KEY" => privateapikey, "Content-Type" => "application/json" )
    body = Dict(
      :status => "private",
      :metas => [Dict(:value => "Ma collection", :propertyUri => "http://nakala.fr/terms#title", :lang => "fr", :typeUri => "http://www.w3.org/2001/XMLSchema#string"),],
      :datas => [],
      :rights => []
    )
    postcollections_response = Nakala.Collections.postcollections(headers, body)
    postcollections_response["body"]
    identifier = postcollections_response["body"]["payload"]["id"]

    # récupération du statut de la collection
    getcollections_status_response = Nakala.Collections.getcollections_status(identifier, headers)
    getcollections_status_response["body"]
    getcollections_status_response["status"]


    ## Changement du statut d'une collection.
    # NB : nécessite d'être testé avec une clé personnelle
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
    postcollections_response["body"]
    identifier = postcollections_response["body"]["payload"]["id"]

    # récupération du statut de la collection
    getcollections_status_response = Nakala.Collections.getcollections_status(identifier, headers)
    getcollections_status_response["body"]
    getcollections_status_response["status"]

    #changement du statut
    putcollections_status_response = Nakala.Collections.putcollections_status(identifier, "public", headers)
    @test putcollections_status_response == 204
  end
  ==#
end