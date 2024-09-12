# Getting started

## Installation

## Nakala.jl et API Nakala

La librairie Nakala.jl permet d'envoyer des requêtes à l'API Nakala afin de créer, modifier ou supprimer des données, ainsi que toutes les informations et métadonnées qui les accompagnent.

Chaque fonction du package permet d'envoyer une requête à un *endpoint* spécifique de l’API et est nommée d'après ce dernier.

Pour dialoguer avec l’API, les fonctions peuvent prendre jusqu'à 3 voire 4 arguments obligatoires :

- `identifier` : identifiant de la donnée, de la collection, etc. que l’on souhaite requêter ;
- `headers` : l'entête HTTP, contenant généralement votre clé API et, selon la requête, le type de données envoyées et le type de données acceptées en retour ;
- `body` : le corps de votre requête contenant des informations structurées
- `params` : des paramètres qui sont passés dans l’url de la requête, afin, souvent, de filtrer les résultats.

Le contenu attendu des éléments `headers`, `body` et `params` et l'objet retourné par la requête sont fournis par la [documentation de l’API](https://api.nakala.fr/doc).

![api Nakala](assets/api.png)

