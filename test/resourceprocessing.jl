using Test

path = @__DIR__
apikey = "01234567-89ab-cdef-0123-456789abcdef" #public key for test api

#==
État d'une ressource dans ElasticSearch et Datacite.
==#
# dépot d'un fichier
headers = Dict( "X-API-KEY" => apikey, :accept => "application/json" )
file = "$path/testdata/file.txt"
postfiles_response = Nakala.Datas.postfiles(file, headers, true)
sha1 = postfiles_response["body"]["sha1"]

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
postdatas_response = Nakala.Datas.postdatas(headers, body, true)
identifier = postdatas_response["body"]["payload"]["id"]


getresourceprocessing_response = Nakala.getresourceprocessing(identifier, headers, true)
@test getresourceprocessing_response["status"] == 200