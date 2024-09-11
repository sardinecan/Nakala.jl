using Test, Nakala

Nakala.Vocabularies.getvocabularies_licenses(["q" => "public"], apitest=true)

@test Nakala.Vocabularies.getvocabularies_licenses(["q" => "public"], apitest=true)["status"] == 200
@test Nakala.getvocabularies_languages([:code => "fr"], apitest=true)["status"] == 200
@test Nakala.getvocabularies_countryCodes([:q => "fr"], apitest=true)["status"] == 200
@test Nakala.getvocabularies_dataStatuses(apitest=true)["status"] == 200
@test Nakala.getvocabularies_collectionStatuses(apitest=true)["status"] == 200
@test Nakala.getvocabularies_properties(apitest=true)["status"] == 200
@test Nakala.getvocabularies_datatypes(apitest=true)["status"] == 200
@test Nakala.getvocabularies_metadatatypes(apitest=true)["status"] == 200
@test Nakala.getvocabularies_dcmitypes(apitest=true)["status"] == 200
