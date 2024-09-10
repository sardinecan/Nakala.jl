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
using CSV
using DataFrames

path = "/home/josselin/files/dh/Nakala.jl/test/testdata"

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

listfiles("/home/josselin/files/dh/Nakala.jl/test/testdata")

function uploadfiles_from_csv(path::String)
    listfiles = joinpath(path, "files.csv")
    df = CSV.read(listfiles, DataFrame)
    df.sha1 = Vector{Union{String, Missing}}(undef, nrow(df))
    for i in 1:nrow(df)
        file_path = df.FilePath[i]
        # Vérifier que le fichier existe
        if isfile(file_path)
            headers = Dict( "X-API-KEY" => apikey, :accept => "application/json" )
            postdatas_uploads_response = Nakala.postdatas_uploads(file_path, headers, true)
            sha1 = postdatas_uploads_response["body"]["sha1"]
            df.sha1[i] = sha1
        else
            println("Fichier introuvable : $file_path")
            df.sha1[i] = missing
        end
    end
  
    # Sauvegarder le CSV avec la colonne SHA1
    CSV.write(joinpath(path, "files_with_sha1.csv"), df)
    println("Le fichier files_with_sha1.csv a été mis à jour avec les codes SHA1.")
    return df
  end

  uploadfiles_from_csv("/home/josselin/files/dh/Nakala.jl/test/testdata")

  function metadata_from_csv(path::String)
    metadata = CSV.read(path, DataFrame, header=1) # fichier de métadonnées 
  
    title = metadata[!, :title][1] 
    metadata[!, :collections][1] !== missing  ? collections = split(metadata[!, :collections][1], ";") : collections = nothing
    authors = split(metadata[!, :authors][1], ";")
    date = metadata[!, :date][1]
    license = metadata[!, :licence][1]
    status = metadata[!, :status][1]
    metadata[!, :datatype][1] !== missing ? datatypes = split(metadata[!, :datatype][1], ";") : datatypes = nothing
    description = metadata[!, :description][1]
    metadata[!, :keywords][1] !== missing  ? keywords = split(metadata[!, :keywords][1], ";") : keywords = nothing
    metadata[!, :rights][1] !== missing  ? datarights = split(metadata[!, :rights][1], ";") : datarights = nothing
    lang = metadata[!, :lang][1]
    
    # métadonnées de la ressource
    meta = Vector()
  
    # titre (obligatoire)
    metaTitle = Dict(
      :value => title,
      :typeUri => "http://www.w3.org/2001/XMLSchema#string",
      :propertyUri => "http://nakala.fr/terms#title",
      :lang => lang
  
    )
    push!(meta, metaTitle)
    
    
    # datatype (obligatoire)
    if datatypes !== nothing
      for datatype in datatypes
        metaType = Dict(
          :value => datatype,
          :typeUri => "http://www.w3.org/2001/XMLSchema#anyURI",
          :propertyUri => "http://nakala.fr/terms#type"
        )
        push!(meta, metaType)
      end
    end
  
    
  
    # authorité/creator (obligatoire, mais accepte la valeur null)
    for author in authors   
      if length(split(author, ",")) > 1
        identity = split(author, ",")
        metaAuthor = Dict(
          :value => Dict(
            :givenname => identity[2],
            :surname => identity[1]
          ),
          :propertyUri => "http://nakala.fr/terms#creator"
        )
        push!(meta, metaAuthor)
      else
        metaAuthor = Dict(
          :value => Dict(
            :givenname => author,
            :surname => author
          ),
          :propertyUri => "http://nakala.fr/terms#creator"
        )
        push!(meta, metaAuthor)
      end
    end
  
    # date (obligatoire, mais accepte la valeur null)    
    metaCreated = Dict(
      :value => date,
      :typeUri => "http://www.w3.org/2001/XMLSchema#string",
      :propertyUri => "http://nakala.fr/terms#created"
    )
    push!(meta, metaCreated)
      
    # licence (obligatoire pour une donnée publiée)
    metaLicense = Dict(
      :value => license,
      :typeUri => "http://www.w3.org/2001/XMLSchema#string",
      :propertyUri => "http://nakala.fr/terms#license"
    )
    push!(meta, metaLicense)
  
    # Droits (facultatif)
    rights = []
    if datarights !== nothing
      for dataright in datarights
        right = Dict(
          :id => split(dataright, ",")[1],
          :role => split(dataright, ",")[2]
        )
        push!(rights, right)
      end
    end
  
    # Description (facultatif)
    metaDescription = Dict(
      :value => description,
      :lang => lang,
      :typeUri => "http://www.w3.org/2001/XMLSchema#string",
      :propertyUri => "http://purl.org/dc/terms/description"
    )
    push!(meta, metaDescription)
  
    # Mots-clés
    if keywords !== nothing
      for keyword in keywords
        metaKeyword = Dict(
          :value => keyword,
          :lang => lang,
          :typeUri => "http://www.w3.org/2001/XMLSchema#string",
          :propertyUri => "http://purl.org/dc/terms/subject"
        )
        push!(meta, metaKeyword)
      end
    end
  
    # assemblage des métadonnées avant envoi de la ressource
    body = Dict{Symbol, Any}(
      :collectionsIds => collections,
      :status => status,
      :metas => meta,
      :rights => rights
    )
  
    return body
  end

  body = metadata_from_csv("/home/josselin/files/dh/Nakala.jl/test/testdata/metadata.csv")


  function files_metadatas_from_csv(path::String)
    metadata = CSV.read(path, DataFrame, header=1)
    
    files = []
    # Boucler sur chaque ligne du DataFrame
    for row in eachrow(metadata)

        name = basename(row[:FilePath])
        sha1 = row[:sha1]
        embargoed = haskey(row, :embargoed) ? row[:embargoed] : ""
        description = haskey(row, :description) ? row[:description] : ""

        # Créer un dictionnaire pour la ligne actuelle
        file = Dict(
            "name" => name,
            "sha1" => sha1,
            "embargoed" => embargoed,
            "description" => description
        )

        #==
        # Ajouter les colonnes et valeurs dans le dictionnaire
        for col in names(df)
            row_dict[col] = row[col]
        end
        ==#

        # Ajouter le dictionnaire à la liste
        push!(files, file)
    end

    return Dict(:files => files)
    #==
    
    filesInfo = postedFilesFromList[2]

  metadata = metadataFromCsv(joinpath(path, directory, "metadata.csv"))

  merge!(metadata, files)
  ==# 
  end  
  files_metadatas = files_metadatas_from_csv("/home/josselin/files/dh/Nakala.jl/test/testdata/files_with_sha1.csv")

Nakala.postdatas(headers, merge!(body, files_metadatas), true)
Nakala.getdatas("10.34847/nkl.e4ca9n19", headers, true)["body"]["files"]
  #==
étape
- lister les fichiers à envoyer dans un csv => OK
- ajouter une description pour les fichiers (nouvelle colonne dans le csv facultatif)

- déposer les fichiers sur l'espace temporaire et récupérer les sha1, les mettre dans le csv => OK
- ajouter les métadonnées de la donnée dans un fichier metadatas.csv => faire une fonction qui transforme le csv en json 
- créer la donnée et attacher les fichiers en ajoutant les métadonnée
==#




listfiles("/home/josselin/files/dh/Nakala.jl/test/testdata/")