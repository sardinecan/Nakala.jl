using Test

@test Nakala.Search.searchAuthors([:q=>"Nakala"], true)["code"] == 200
@test Nakala.search([:q=>"Nakala", :fq => "scope=depositor"], true)["code"] == 200
