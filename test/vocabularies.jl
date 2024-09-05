using Test
@test Nakala.getvocabularies_licenses(["q" => "public"], true)["status"] == 200
@test Nakala.getvocabularies_languages([:code => "fr"], true)["status"] == 200
@test Nakala.getvocabularies_countryCodes([:q => "fr"], true)["status"] == 200
@test Nakala.getvocabularies_dataStatuses(true)["status"] == 200
@test Nakala.getvocabularies_collectionStatuses(true)["status"] == 200
@test Nakala.getvocabularies_properties(true)["status"] == 200
@test Nakala.getvocabularies_datatypes(true)["status"] == 200
@test Nakala.getvocabularies_metadatatypes(true)["status"] == 200
@test Nakala.getvocabularies_dcmitypes(true)["status"] == 200
