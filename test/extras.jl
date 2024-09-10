using Test
using HTTP, JSON, CSV, DataFrames


path = @__DIR__
apikey = "01234567-89ab-cdef-0123-456789abcdef" # tnakala user public key for Nakala test api
userid = "c7e9bb15-6b4e-4e09-b234-ae7b13ac1f3b" # unakala1 public user id

#==
    Obtenir des paires titre - identifiant à partir d'une liste de données
==#
datas = Nakala.Search.search([:q => "édition", :size=>"20"], true)
Nakala.Utilities.getdatas_resume(datas["body"]["datas"])


#==
    Obtenir les urls de téléchargement d'une liste de fichiers dans une donnée
==#
# obtenir d'un donnée
identifier = "10.34847/nkl.a5505848"
headers = Dict(
    "X-API-KEY" => apikey,
    "Content-Type" => "application/json"
)
getdatas_response = Nakala.Datas.getdatas(identifier, headers, true)

wanted_files = [ "guepes-TEI--trad-Lobineau--XVIIIe.xml" ]
getfiles_urls_from_data_response = Nakala.Utilities.getfiles_urls_from_data(getdatas_response["body"], wanted_files, true)
println(getfiles_urls_from_data_response)

#==
    Envoyer une donnée à partir d'une liste de fichiers.
==#
path = "/home/josselin/files/dh/Nakala.jl/test/testdata/"

fileslist = Nakala.Extras.listfiles(path, true)
uploadedfiles = Nakala.Extras.postdatas_from_folder(path, headers)
df = DataFrame(a=[1,2,4], b=missing)
df.b = ['a', 'b', 'c']

println(df)