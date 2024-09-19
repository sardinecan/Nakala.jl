# Nakala.jl

The Nakala.jl package is a Julia library designed to interact with the [Nakala API](https://api.nakala.fr/doc), a platform dedicated to the management, storage and sharing of research data in the humanities and social sciences in France.

Nakala.jl simplifies access to the API for depositing, publishing, managing and downloading datasets. This package is particularly useful for handling large datasets. It is primarily aimed at engineers and researchers who have access to [Nakala](https://nakala.fr/) and wish to share their data in compliance with [FAIR](https://fr.wikipedia.org/wiki/Fair_data) principles.

Nakala.jl is built around 7 modules corresponding to the API endpoints:

- Search
- Datas
- Collections
- Users
- Groups
- Vocabularies
- Default

An eighth module, Extras, includes a series of functions for uploading data and files based on information contained in a CSV file.

To execute requests, you must have a Nakala API key or use a public key with [Nakala's Test API](https://test.nakala.fr/).

The documentation (in French) is available online: [sardinecan.github.io/Nakala.jl](https://sardinecan.github.io/Nakala.jl).
