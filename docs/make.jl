using Documenter, Nakala

makedocs(;
    format = Documenter.HTML(;
        prettyurls = get(ENV, "CI", nothing) == "true"
    ),
    pages = [
        "Nakala.jl" => "index.md",
        "Modules" => [
            "Datas" => "modules/datas.md",
            "Collections" => "modules/collections.md",
            "Users" => "modules/users.md",
            "Groups" => "modules/groups.md",
            "Search" => "modules/search.md",
            "Vocabularies" => "modules/vocabularies.md",
            "Default" => "modules/default.md",
            
        ]
    ],
    sitename = "Nakala.jl"
)


deploydocs(
    repo = "https://github.com/sardinecan/Nakala.jl.git",
)   