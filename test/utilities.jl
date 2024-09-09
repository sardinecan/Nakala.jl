using Test
using HTTP, JSON

datas = Nakala.Search.search([:size=>"100"], true)
datas["body"]["datas"][1]
println(Nakala.Utilities.getdatas_resume(datas["body"]["datas"]))