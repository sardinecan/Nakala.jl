# Nakala.jl

Le package Nakala.jl est une bibliothèque Julia conçue pour interagir avec l'[API de Nakala](https://api.nakala.fr/doc), une plateforme dédiée à la gestion, au stockage et au partage des données de la recherche en sciences humaines et sociales en France.

Nakala.jl facilite l'accès à l'API pour déposer, publier, gérer et télécharger des jeux de données. Ce package est particulièrement utile pour manipuler des ensembles de données volumineux. Il s'adresse principalement aux ingénieurs et chercheurs disposant d'un accès à Nakala, et souhaitant partager leurs données dans le respect des principes [*FAIR*](https://fr.wikipedia.org/wiki/Fair_data) 

Nakala.jl est construit autour de 7 modules correspondant aux *end-points* de l'API :

- `Search`
- `Datas`
- `Collections`
- `Users`
- `Groups`
- `Vocabularies`
- `Default`

Un huitième module `Extras` comprend une série de fonctions pour le dépôt de données et de fichiers à partir d'informations contenues dans un fichier `csv`.

Pour exécuter les requêtes vous devez disposer d'une clé d'API Nakala, ou utiliser une clé publique avec l'API de Test de Nakala. La clé doit être indiquée dans les `headers`, par exemple : 

```julia
headers = Dict(
    "X-API-KEY" => apikey,
    "Content-Type" => "application/json",
    "accept" => "application/json"
)
```

La très grande majorité des fonctions de ce package dispose d'un *keyword argument* `apitest`. Par défaut, les requêtes sont envoyées sur l'API de production. Cependant, si vous ajoutez l'argument `apitest=true` à votre fonction, la requête sera envoyée à l'API de Test.

Les fonctions retournent un dictionnaire Julia :

- succès ou erreur HTTP
```julia
Dict(
    "isSuccess" => true|false,
    "status" => "String", # code http
    "body" => "String" # réponse du serveur et message d'erreur
)
```

- autre erreur
```julia
Dict(
    "isSuccess" => false,
    "message" => "An unexpected error occurred: $(message)"
)
```

La gestion des erreurs repose sur l'utilisation de `try/catch` afin de traiter les exceptions. Les erreurs HTTP (renvoyant un code et un message explicatif) sont distinguées des autres types d'erreurs, comme les échecs de connexion par exemple. Cette approche autorise une gestion efficace et claire des erreurs, facilitant ainsi la résolution des problèmes.

## Lectures utiles

- La [documentation Nakala](https://documentation.huma-num.fr/nakala/) en ligne ;
- [interface web](https://nakala.fr/) et [API](https://api.nakala.fr/doc) de production ;
- [interface web](https://test.nakala.fr/) et [API](https://apitest.nakala.fr/doc) de test ;
- [NakalaPycon](https://gitlab.huma-num.fr/mshs-poitiers/plateforme/nakalapycon), une librairie Python pour interagir avec l’API Nakala ;
- [NakalaPyConnect](https://gitlab.huma-num.fr/mnauge/nakalapyconnect), dépôt facilitant l'appropriation de Nakala et de son API ; 
- [Notebook Api Nakala](https://gitlab.huma-num.fr/huma-num-public/notebook-api-nakala), une présentation de l'API de NAKALA sous forme d'un notebook Jupyter.
 
