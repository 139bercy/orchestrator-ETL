# Orchestrator ETL

Ce projet représente le service d'orchestation utilisé avec data-upload et ELK sur les différents projets de datascience du BercyHub.

# ETL par défaut
Ce projet contient le dossier `default-ETL` qui définit l'ensemble des éléments nécessaires pour lancer **pypel** avec une configuration par défaut.
Une configuration, définie par le fichier `parameters.json`, identifie un process exécutable dans lequel les données sont chargées depuis le dossier `default` lui-même présent dans le dossier de stockage (dans le container docker `/data`).
Elles sont ensuite transformées avec une configuration minimale représentée par `pypel.processes.Process.Process` avec `pypel.processes.Process.MinimalTransformer` comme seul et unique transformer.
Enfin les données sont stocké dans un index nommé `pypel-default`.

Pour modifier cette configuration, il faut remplacer le fichier `parameters.json` en y intégrant les informations voulues.

## TODO
- [ ] Définition d'une interface graphique permettant de gérer les configurations
- [ ] Définition d'un backend capable de stocké les informations de configuration dans une base de données
- [x] Définition d'un ETL "par défaut" qui utilise PyPel et qui exécute les transformations minimales
  - Cet ETL prend donc un dossier en lecture
  - Pour chaque fichier dans ce dossier, il exécute `pypel.processes.Process.Process` avec `pypel.processes.Process.MinimalTransformer` comme seul et unique transformer
  - L'ensemble des données sont ensuite chargé dans un ELK dans l'index `default-ETL`
