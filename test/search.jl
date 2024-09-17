@testset "search" begin
    search_author_response = Nakala.Search.search_authors([:q=>""], apitest=true)
    @test search_author_response["status"] == 200

    search_response = Nakala.Search.search([:q=>"édition", :fq => ""], apitest=true)
    @test search_response["status"] == 200
end
