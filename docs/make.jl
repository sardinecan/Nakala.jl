using Documenter, Nakala

makedocs(;
    format = Documenter.HTML(;
        prettyurls = get(ENV, "CI", nothing) == "true"
    ),
    authors = "J. Morvan <morvan.josselin@gmail.com>",
    pages = [
        "Nakala.jl" => "index.md",
        "Getting started" => "getting_started.md",
        "Modules" => [
            "Datas" => "modules/datas.md",
            "Collections" => "modules/collections.md",
            "Users" => "modules/users.md",
            "Groups" => "modules/groups.md",
            "Search" => "modules/search.md",
            "Vocabularies" => "modules/vocabularies.md",
            "Default" => "modules/default.md",
            "Extras" => "modules/extras.md"
        ]
    ],
    sitename = "Nakala.jl"
)


deploydocs(
    repo = "https://github.com/sardinecan/Nakala.jl.git",
)   
