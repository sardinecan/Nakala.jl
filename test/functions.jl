function createData()
    # dépôt d'un fichier
    headers = Dict("X-API-KEY" => apikey, :accept => "application/json")
    file = "$path/testdata/file.txt"
    postdatas_uploads_response = Nakala.Datas.postdatas_uploads(file, headers, apitest=true)
    sha1 = postdatas_uploads_response["body"]["sha1"]

    # création de la donnée
    headers = Dict("X-API-KEY" => apikey, "Content-Type" => "application/json")
    body = Dict(
        :collectionsIds => [],
        :files => [Dict("name" => "file.txt", "sha1" => sha1, "embargoed" => "2024-09-01")],
        :status => "pending",
        :metas => [
            Dict(:value => "Ma donnée Nakala.jl", :propertyUri => "http://nakala.fr/terms#title", :lang => "fr", :typeUri => "http://www.w3.org/2001/XMLSchema#string"),
            Dict(:value => "http://purl.org/coar/resource_type/c_18cf", :propertyUri => "http://nakala.fr/terms#type", :typeUri => "http://www.w3.org/2001/XMLSchema#anyURI"),
            Dict(:value => Dict(:surname => "Rémi", :givenname => "Fassol"), :propertyUri => "http://nakala.fr/terms#creator", :typeUri => "http://www.w3.org/2001/XMLSchema#string"),
            Dict(:value => "2024-09-01", :propertyUri => "http://nakala.fr/terms#created", :typeUri => "http://www.w3.org/2001/XMLSchema#string"),
            Dict(:value => "PDM", :propertyUri => "http://nakala.fr/terms#license", :typeUri => "http://www.w3.org/2001/XMLSchema#string"),
            Dict(:value => "Description", :propertyUri => "http://purl.org/dc/terms/description", :lang => "fr", :typeUri => "http://www.w3.org/2001/XMLSchema#string"),
            Dict(:value => Dict(:surname => "Rémi", :givenname => "Fassol"), :propertyUri => "http://nakala.fr/terms#creator")
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