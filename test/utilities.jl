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

for (root, dirs, files) in walkdir("/home/josselin/files/dh/Nakala.jl/test/testdata")
    filter!(x -> startswith(x, ".") == false, dirs)
    for dir in dirs
      touch(joinpath(root, dir, "files.csv"))
      f = open(joinpath(root, dir, "files.csv"), "w")
        write(f, "filename")
      close(f)

      println(dir)
      push!(directories, dir)

      list = readdir(joinpath(root, dir))

      for file in list
        f = open(joinpath(root, dir, "files.csv"), "a")
          write(f, "\n"*file)
        close(f)
      end
    end
  end


  using CSV
using DataFrames

# Fonction pour lister les fichiers dans un dossier et écrire dans un fichier CSV
function listfiles(dir::String)
    # Liste pour stocker les chemins complets des fichiers
    files = []

    # Parcourir les entrées du dossier, sans entrer dans les sous-dossiers
    for entry in readdir(dir, join=true)
        if isfile(entry)  # Vérifie que c'est un fichier
            push!(files, entry)
        end
    end

    # Si aucun fichier n'est trouvé, on retourne un message d'erreur
    if isempty(files)
        println("Aucun fichier trouvé dans le dossier : $dir")
        return
    end

    # Créer un DataFrame avec les chemins des fichiers
    df = DataFrame(FilePath = files)

    # Écrire dans le fichier CSV
    CSV.write(joinpath(dir, "files.csv"), df)

    println("Le fichier files.csv a été créé avec succès.")
end

apikey = "01234567-89ab-cdef-0123-456789abcdef" # tnakala user public key for Nakala test api


function uploadfiles_from_csv(path::String)
    df = CSV.read(path, DataFrame)
    df.SHA1 = Vector{Union{String, Missing}}(undef, nrow(df))
    for i in 1:nrow(df)
        file_path = df.FilePath[i]
        # Vérifier que le fichier existe
        if isfile(file_path)
            headers = Dict( "X-API-KEY" => apikey, :accept => "application/json" )
            postdatas_uploads_response = Nakala.postdatas_uploads(file_path, headers, true)
            sha1 = postdatas_uploads_response["body"]["sha1"]
            df.SHA1[i] = sha1
        else
            println("Fichier introuvable : $file_path")
            df.SHA1[i] = missing
        end
    end

    # Sauvegarder le CSV avec la colonne SHA1
    CSV.write("files_with_sha1.csv", df)
    println("Le fichier files_with_sha1.csv a été mis à jour avec les codes SHA1.")
    return df
end

uploadfiles_from_csv("/home/josselin/files/dh/Nakala.jl/test/testdata/files.csv")

function process_files_and_add_sha1(csv_file::String, api_url::String)
    # Lire le fichier CSV
    

    # Ajouter une nouvelle colonne pour les SHA1
    

    # Boucler sur chaque fichier et envoyer à l'API Nakala
    for i in 1:nrow(df)
        file_path = df.FilePath[i]

        # Vérifier que le fichier existe
        if isfile(file_path)
            # Envoyer le fichier à l'API et récupérer le SHA1
            sha1 = send_to_nakala(file_path, api_url)
            df.SHA1[i] = sha1
        else
            println("Fichier introuvable : $file_path")
            df.SHA1[i] = missing
        end
    end

    # Sauvegarder le CSV avec la colonne SHA1
    CSV.write("files_with_sha1.csv", df)
    println("Le fichier files_with_sha1.csv a été mis à jour avec les codes SHA1.")
end

listfiles("/home/josselin/files/dh/Nakala.jl/test/testdata/")