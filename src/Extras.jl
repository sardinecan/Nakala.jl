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
    getfiles_urls_from_data(data::Dict, filenames::Vector;  apitest::Bool=false)

À partir d'une liste de fichiers issue d'une donnée Nakala, retourne les urls de téléchargement.
"""
function getfiles_urls_from_data(data::Dict, filenames::Vector; apitest::Bool=false)
  apitest==false ? apiurl = "https://api.nakala.fr" : apiurl = "https://apitest.nakala.fr"
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


"""
#=
    postdatas_from_folder(dirpath::String, headers::Dict; apitest::Bool=false)

Dépose une donnée à partir d'un répertoire contenant les fichiers à envoyer et les métadonnées au format `csv`.
=#
"""
function postdatas_from_folder(dirpath::String, headers::Dict; apitest::Bool=false)
  fileslist_csv = joinpath(dirpath, "_.files.csv")
  uploadfiles_headers = Dict( 
    "X-API-KEY" => get(headers, "X-API-KEY", ""),
    :accept => "application/json"
  )
  uploadedfiles = uploadfiles_from_csv(fileslist_csv, uploadfiles_headers, true, apitest=apitest)
  
  # métadonnées de la donnée
  metadata_csv = metadata_from_csv(joinpath(dirpath, "_.metadata.csv"))
  # métadonnées des fichiers
  filesmetadata = files_metadatas_from_csv(joinpath(dirpath, "_.files_with_sha1.csv"))
  
  # envoi de la donnée
  body = merge!(metadata_csv, filesmetadata)
  postdata_response = postdatas(headers, body, apitest=apitest)
  return postdata_response
end
export postdatas_from_folder


"""
    listfiles(dirpath::String; writecsv::Bool=false)

liste les fichiers contenus dans un dossier (`dirpath`) et retourne un `DataFrame` contenant cette liste.

Si l'argument `writecsv=true` est indiqué, un fichier `_.files.csv` est écrit dans le répertoire.
"""
# Fonction pour lister les fichiers dans un dossier et écrire dans un fichier CSV
function listfiles(dirpath::String; writecsv::Bool=false)
  fileslist = []
  for entry in readdir(dirpath, join=true)
      if isfile(entry) && !startswith(basename(entry), "_.")
          push!(fileslist, entry)
      end
  end

  if isempty(fileslist)
      println("Aucun fichier trouvé dans le dossier : $dir")
      return
  end
  
  fileslist_dataframe = DataFrame(
    files = fileslist,
    embargoed=missing,
    description=missing
  )
  
  if writecsv == true
    CSV.write(joinpath(dirpath, "_.files.csv"), fileslist_dataframe)
    println("Le fichier _.files.csv a été créé avec succès.")
  end
  return fileslist_dataframe
end
export listfiles


"""
    uploadfiles_from_csv(fileslist_csv::String, headers::Dict; writecsv::Bool=false, apitest::Bool=false)

Envoie des fichiers dans l'espace temporaire de Nakala à partir d'une liste `csv`.

La liste peut être établie automatiquement avec la fonction `listfiles()`.
"""
function uploadfiles_from_csv(fileslist_csv::String, headers::Dict; writecsv::Bool=false, apitest::Bool=false)
  dirpath = abspath(dirname(fileslist_csv))
  fileslist = CSV.read(joinpath(dirpath, "_.files.csv"), DataFrame, header=1)
  fileslist.sha1 = Vector{Union{String, Missing}}(undef, nrow(fileslist))
  for i in 1:nrow(fileslist)
      filepath = fileslist.files[i]
      # Vérifier que le fichier existe
      if isfile(filepath)
          println("Envoi du fichier : ", filepath)
          postdatas_uploads_response = postdatas_uploads(string(filepath), headers, apitest=apitest)
          sha1 = postdatas_uploads_response["body"]["sha1"]
          fileslist.sha1[i] = sha1
          println("Identifiant", sha1)
      else
          println("Fichier introuvable : $filepath")
          fileslist.sha1[i] = missing
      end
  end

  if writecsv == true
      # Sauvegarder le CSV avec la colonne sha1
      CSV.write(joinpath(dirpath, "_.files_with_sha1.csv"), fileslist)
      println("Le fichier _.files_with_sha1.csv a été mis à jour avec les codes sha1.")
  end

  return fileslist
end
export uploadfiles_from_csv


"""
    metadata_from_csv(path::String)

Prépare les métadonnées pour la création d'une donnée sur Nakala à partir d'un fichier `csv` et retourne une dictionnaire.
"""
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

      # Ajouter le dictionnaire à la liste
      push!(files, file)
  end

  return Dict(:files => files)
end

end # end module

