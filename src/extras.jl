module Extras
using HTTP, JSON, CSV, DataFrames

import ..Datas: postdatas, postdatas_uploads

"""
    getdatas_resume(datas::Vector{Any})

À partir d'un tableau de données issu de Nakala, retourne un autre tableau composé de paires `titre - identifiant de la donnée`.
"""
function getdatas_resume(datas::Vector{Any})
  list = Vector()
  for data in datas
    identifier = data["identifier"]
    metas = data["metas"]
    title = filter(x -> x["propertyUri"] == "http://nakala.fr/terms#title", metas)[1]
    item = get(title, "value", "noTitle") => identifier
    push!(list, item)
  end

  return list
end
export getdatas_resume


"""
    getfiles_urls_from_data(data::Dict, filenames::Vector,  apiTest::Bool=false)
À partir d'une liste de fichiers dans une donnée, retourne les urls de téléchargement.
"""
function getfiles_urls_from_data(data::Dict, filenames::Vector, apiTest::Bool=false)
  apiTest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"
  identifier = data["identifier"]
  filesList = data["files"]

  urls = Vector()
  for file in filenames
      item = filter(x -> x["name"] == file, filesList)[1]
      fileIdentifier = item["sha1"]

      fileUrl = joinpath(apiurl, "data", identifier, fileIdentifier)
      push!(urls, fileUrl)fileslist
  end

  return urls
end
export getfiles_urls_from_data


#=
submitDataFromFolder : dépôt d'une donnée à partir d'un dossier contenant les fichiers constitutifs de la donnée et les métadonnées contenus dans un ficheir csv
@arg path : chemin vers le dossier contenant les données à déposer
@arg directory : nom du dossier constitutif de la donnée
=#
function postdatas_from_folder(dirpath::String, headers::Dict, apiTest::Bool=false)
  fileslist = listfiles(dirpath)
  uploadedfiles = uploadfiles_from_list(fileslist, Dict( "X-API-KEY" => get(headers, "X-API-KEY", ""), :accept => "application/json"), true, path=dirpath)
  metadata = metadata_from_csv(joinpath(dirpath, "__.metadata.csv"))
  filesmetadata = files_metadatas_from_csv(joinpath(dirpath, "__.files_with_sha1.csv"))
  
  postdata_response = postdatas(headers, merge!(metadata, filesmetadata), true)
  return postdata_response
end
export postdatas_from_folder


"""

liste les fichiers contenus dans un dossier (`path`) et retourne un `DataFrame` contenant cette liste. Si `writecsv == true`, un fichier `files.csv` est écrit dans le répertoire. 
"""
# Fonction pour lister les fichiers dans un dossier et écrire dans un fichier CSV
function listfiles(dirpath::String, writecsv::Bool=false)
  fileslist = []
  for entry in readdir(dirpath, join=true)
      if isfile(entry)  # Vérifie que c'est un fichier
          push!(fileslist, entry)
      end
  end

  if isempty(fileslist)
      println("Aucun fichier trouvé dans le dossier : $dir")
      return
  end

  # Créer un DataFrame avec les chemins des fichiers
  fileslist_dataframe = DataFrame(files = fileslist)

  # Écrire dans le fichier CSV
  if writecsv == true
    CSV.write(joinpath(dirpath, "_.files.csv"), fileslist_dataframe)
    println("Le fichier files.csv a été créé avec succès.")
  end
  return fileslist_dataframe
end
export listfiles


"""
"""
function uploadfiles_from_list(fileslist::DataFrame, headers, writecsv::Bool=false; path::String="")
  fileslist.sha1 = Vector{Union{String, Missing}}(undef, nrow(fileslist))
  for i in 1:nrow(fileslist)
      filepath = fileslist.files[i]
      # Vérifier que le fichier existe
      if isfile(filepath)
          postdatas_uploads_response = postdatas_uploads(string(filepath), headers, true)
          println(postdatas_uploads_response)
          println(filepath)
          sha1 = postdatas_uploads_response["body"]["sha1"]
          println(sha1)
          fileslist.sha1[i] = sha1
      else
          println("Fichier introuvable : $filepath")
          fileslist.sha1[i] = missing
      end
  end

  if writecsv == true
      # Sauvegarder le CSV avec la colonne sha1
      CSV.write(joinpath(path, "_.files_with_sha1.csv"), fileslist)
      println("Le fichier _.files_with_sha1.csv a été mis à jour avec les codes sha1.")
  end

  return fileslist
end
export uploadfiles_from_list

#==
étape
- lister les fichiers à envoyer dans un csv => OK
- ajouter une description pour les fichiers (nouvelle colonne dans le csv facultatif)

- déposer les fichiers sur l'espace temporaire et récupérer les sha1, les mettre dans le csv => OK
- ajouter les métadonnées de la donnée dans un fichier metadatas.csv => faire une fonction qui transforme le csv en json 
- créer la donnée et attacher les fichiers en ajoutant les métadonnée
==#

"""
dépot de fichiers sur Nakala à partir d'un liste csv
@arg directoryPath : chemin vers le dossier contenant les fichiers à déposer et la liste

@return : array [ métadonnées des fichiers déposés ]
"""
function postfiles_from_list(path::String, apiTest::Bool=false)
  files2upload = CSV.read(joinpath(path, "_.files.csv"), DataFrame, header=1) # fichier de métadonnées 

  #%% Dépôt des fichiers
  files = Vector()
  filesInfo = []
  
  for (i, row) in enumerate(eachrow(files2upload))
    filename = row[:filename]
    
    println("Envoi du fichier n°", i, " - ", filename)
    fileResponse = postFile(joinpath(directoryPath, filename))
    fileIdentifier = fileResponse["sha1"]

    push!(files, fileResponse) # récupération de l'identifiant Nakala du fichier (fileIdentifier) pour le dépot des métadonnées et de la ressource
    push!(filesInfo, [filename, fileIdentifier])
  end
  
  return [files, filesInfo]
end


#=
metadataFromCsv : établissement des métadonnées d'une donnée à partir d'un fichier csv
@arg path : chemin vers le fichier de métadonnées
=#
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
    :status => "pending",
    :metas => meta,
    :rights => rights
  )

  return body
end

function files_metadatas_from_csv(path::String)
    metadata = CSV.read(path, DataFrame, header=1)
    
    files = []
    # Boucler sur chaque ligne du DataFrame
    for row in eachrow(metadata)

        name = basename(row[:files])
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


end # end module

