using Test, Nakala

@testset "vocabularies" begin
    getvocabularies_licenses_response = Nakala.Vocabularies.getvocabularies_licenses(["q" => "public"], apitest=true)
    @test getvocabularies_licenses_response["status"] == 200
    
    getvocabularies_languages_response = Nakala.getvocabularies_languages([:code => "fr"], apitest=true)
    @test getvocabularies_languages_response["status"] == 200
    
    
    getvocabularies_countryCodes_response = Nakala.getvocabularies_countryCodes([:q => "fr"], apitest=true)
    @test getvocabularies_countryCodes_response["status"] == 200
    
    getvocabularies_dataStatuses_response = Nakala.getvocabularies_dataStatuses(apitest=true)
    @test getvocabularies_dataStatuses_response["status"] == 200
    
    
    getvocabularies_collectionStatuses_response = Nakala.getvocabularies_collectionStatuses(apitest=true)
    @test getvocabularies_collectionStatuses_response["status"] == 200
    
    getvocabularies_properties_response = Nakala.getvocabularies_properties(apitest=true)
    @test getvocabularies_properties_response["status"] == 200
    
    Nakala.getvocabularies_datatypes(apitest=true)
    @test Nakala.getvocabularies_datatypes(apitest=true)["status"] == 200
    
    getvocabularies_metadatatypes_response = Nakala.getvocabularies_metadatatypes(apitest=true)
    @test getvocabularies_metadatatypes_response["status"] == 200
    
    getvocabularies_dcmitypes_response = Nakala.getvocabularies_dcmitypes(apitest=true)
    @test getvocabularies_dcmitypes_response["status"] == 200
end