using Test
@test Nakala.getvocabularies_licenses(["q" => "public"], true)["code"] == 200
@test Nakala.getvocabularies_languages([:code => "fr"], true)["code"] == 200
@test Nakala.getvocabularies_countryCodes([:q => "fr"], true)["code"] == 200
@test Nakala.getvocabularies_dataStatuses(true)["code"] == 200
@test Nakala.getvocabularies_collectionStatuses(true)["code"] == 200
@test Nakala.getvocabularies_properties(true)["code"] == 200
@test Nakala.getvocabularies_datatypes(true)["code"] == 200
@test Nakala.getvocabularies_metadatatypes(true)["code"] == 200
@test Nakala.getvocabularies_dcmitypes(true)["code"] == 200
