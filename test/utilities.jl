using Test
using HTTP, JSON


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
    Lister le contenu d'un dossier
==#
Nakala.Utilities.listfiles("/home/josselin/files/dh/Nakala.jl/test/testdata")

  using CSV
using DataFrames

#==
étape
- lister les fichiers à envoyer dans un csv => OK
- ajouter une description pour les fichiers (nouvelle colonne dans le csv facultatif)

- déposer les fichiers sur l'espace temporaire et récupérer les sha1, les mettre dans le csv => OK
- ajouter les métadonnées de la donnée dans un fichier metadatas.csv => faire une fonction qui transforme le csv en json 
- créer la donnée et attacher les fichiers en ajoutant les métadonnée
==#

uploadfiles_from_csv("/home/josselin/files/dh/Nakala.jl/test/testdata/files.csv")


listfiles("/home/josselin/files/dh/Nakala.jl/test/testdata/")