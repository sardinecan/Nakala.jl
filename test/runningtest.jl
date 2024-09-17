using Test, Nakala

path = @__DIR__
apikey = "01234567-89ab-cdef-0123-456789abcdef" #public key for test api
userid = "c7e9bb15-6b4e-4e09-b234-ae7b13ac1f3b" # unakala1 public user id

#==
  Beaucoup de fonctions nécessitent au préalable de créer une donnée sur nakala afin d'être testées. 
  la fonction createData est là à cet effet. 
  elle retourne une identifier fichier et un identifiant donnée.
==#
include("./functions.jl")

include("./datas.jl")
include("./collections.jl")
include("./users.jl")
include("./groups.jl")
include("./search.jl")
include("./vocabularies.jl")
include("./default.jl")