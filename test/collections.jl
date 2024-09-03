using Test
apikey = "01234567-89ab-cdef-0123-456789abcdef" #public key for test api

headers = Dict(
  "X-API-KEY" => apikey,
  "Content-Type" => "application/json"
)

body = Dict(
  :status => "public",
  :metas => [
    Dict(:value => "title", :propertyUri => "http://nakala.fr/terms#title", :lang => "fr", :typeUri => "http://www.w3.org/2001/XMLSchema#string"),
  ],
  :datas => [],
  :rights => []
)

Nakala.Collections.postcollection(headers, body, true)["response"]["payload"]["id"]