# Nakala.jl

Le package Nakala.jl est une bibliothèque Julia conçue pour interagir avec l'[API](https://fr.wikipedia.org/wiki/Interface_de_programmation) de Nakala, une plateforme dédiée à la gestion, au stockage et au partage des données de la recherche en sciences humaines et sociales.

Nakala.jl facilite l'accès à l'API pour déposer, publier, gérer et télécharger des jeux de données. Ce package est particulièrement utile pour manipuler des ensembles de données volumineux. Il s'adresse principalement aux ingénieurs et chercheurs disposant d'un accès à Nakala, et souhaitant partager leurs données dans le respect des principes [*FAIR*](https://fr.wikipedia.org/wiki/Fair_data) 

Nakala.jl est construit autour de 7 modules correspondant aux *end-points* de l'API :

- Search
- Datas
- Collections
- Users
- Groups
- Vocabularies
- Default

Les fonctions retournent généralement un dictionnaire qui contient les entrées suivantes :

- `isSuccess`, indiquant la réussite ou l'échec de la requête (`true`|`false`) ;
- `status`, le code HTTP renvoyé par l'API Nakala, afin savoir si la requête a été traitée correctement (par exemple, `200` pour succès, `404` pour une ressource non trouvée, ou `500` pour une erreur serveur, etc.) ;
- `body`, le corps de la réponse renvoyée par l'API, qui peut inclure des métadonnées ou un message d'erreur détaillé en cas d'échec.

La gestion des erreurs repose sur l'utilisation de `try/catch` afin de traiter les exceptions. Les erreurs HTTP (renvoyant un code et un message explicatif) sont distinguées des autres types d'erreurs, comme les échecs de connexion par exemple. Cette approche autorise une gestion efficace et claire des erreurs, facilitant ainsi la résolution des problèmes.

## Liens et lectures utiles

- La [documentation Nakala](https://documentation.huma-num.fr/nakala/) en ligne ;
- [interface web](https://nakala.fr/) et [API](https://api.nakala.fr/doc) de production ;
- [interface web](https://test.nakala.fr/) et [API](https://apitest.nakala.fr/doc) de test ;
- [NakalaPycon](https://gitlab.huma-num.fr/mshs-poitiers/plateforme/nakalapycon), une librairie Python pour interagir avec l’API Nakala ;
- [NakalaPyConnect](https://gitlab.huma-num.fr/mnauge/nakalapyconnect), dépôt facilitant l'appropriation de Nakala et de son API ; 
- [Notebook Api Nakala](https://gitlab.huma-num.fr/huma-num-public/notebook-api-nakala), une présentation de l'API de NAKALA sous forme d'un notebook Jupyter.
 
