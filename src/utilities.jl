module Utilities

function contains_key_value(d::Dict, key::Union{String, Symbol}, value::String)
  key_lower = lowercase(string(key))

  for k in keys(d)
    if lowercase(string(k)) == key_lower
      return d[k] == value
    end
  end

  return false
end
export contains_key_value


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
      push!(urls, fileUrl)
  end

  return urls
end
export getfiles_urls_from_data

"""

liste les fichiers contenus dans un dossier (`path`) et écrit cette liste dans un `files.csv`. Si le dossier comporte des sous-dossier, leur contenu est listé de la même manière. 
"""
function listfiles(path)
  directories = []
  for (root, dirs, files) in walkdir(path)
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
  
  return directories
end

"""
dépot de fichiers sur Nakala à partir d'un liste csv
@arg directoryPath : chemin vers le dossier contenant les fichiers à déposer et la liste

@return : array [ métadonnées des fichiers déposés ]
"""
function postfiles_from_list(path::String, apiTest::Bool=false)
  files2upload = CSV.read(joinpath(path, "files.csv"), DataFrame, header=1) # fichier de métadonnées 

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
  datatype = metadata[!, :datatype][1]
  description = metadata[!, :description][1]
  metadata[!, :collections][1] !== missing  ? keywords = split(metadata[!, :keywords][1], ";") : keywords = nothing
  metadata[!, :collections][1] !== missing  ? datarights = split(metadata[!, :rights][1], ";") : datarights = nothing
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
  metaType = Dict(
    :value => datatype,
    :typeUri => "http://www.w3.org/2001/XMLSchema#anyURI",
    :propertyUri => "http://nakala.fr/terms#type"
  )
  push!(meta, metaType)

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
    :value => Dates.today(),
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
    :status => "pending"
    :metas => meta,
    :rights => rights
  )

  return body
end

#=
submitDataFromFolder : dépôt d'une donnée à partir d'un dossier contenant les fichiers constitutifs de la donnée et les métadonnées contenus dans un ficheir csv
@arg path : chemin vers le dossier contenant les données à déposer
@arg directory : nom du dossier constitutif de la donnée
=#
function postdatas_from_folder(path::String, directory::String)
  postedFilesFromList = postFilesFromList(joinpath(path, directory))
  files = Dict( :files => postedFilesFromList[1] )
  filesInfo = postedFilesFromList[2]

  metadata = metadataFromCsv(joinpath(path, directory, "metadata.csv"))

  merge!(metadata, files) 

  postedData = postData(metadata)
  dataIdentifier = postedData["payload"]["id"] # récupération de l'identifiant Nakala de la ressource (identifier)
  
  return dataIdentifier
  
  if isfile(joinpath(path, "datasUploaded.csv"))
    f = open(joinpath(path, "datasUploaded.csv"), "a")       
      write(f, "\n"*directory*","*dataIdentifier)
    close(f)      
  else
    touch(joinpath(path, "datasUploaded.csv"))
    f = open(joinpath(path, "datasUploaded.csv"), "w") 
      write(f, "ressource,identifiant")
      write(f, "\n"*directory*","*dataIdentifier)
    close(f)
  end

  
  touch(joinpath(path, directory, directory*".csv"))
  f = open(joinpath(path, directory, directory*".csv"), "w") 
    write(f, "filename,identifier,fileIdentifier")
    for file in filesInfo
      write(f, "\n"*file[1]*","*dataIdentifier*","*file[2])
    end
  close(f)
end

end # end module
