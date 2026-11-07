# Mini-projet Bases de données : Plateforme de revente entre particuliers


**Binôme :** JORESSE BRANDY FANGOUO TATSING , ROUA MIHRAB

 ## Sommaire

1. Présentation du projet
2. Étape 1 : analyse des besoins
   - Prompt utilisé
   - Règles de gestion
   - Dictionnaire de données
   - Analyse du résultat
3. Étape 2 : MCD
4. Partie 2 

---

 ## 1. Présentation du projet

Nous concevons la base de données d'une entreprise qui exploite une plateforme web et mobile de revente d'articles d'occasion entre particuliers, sur le modèle de Vinted, Leboncoin ou Vestiaire Collective. Les membres y publient des annonces, échangent par messagerie, passent des commandes avec paiement sécurisé, se font livrer à domicile ou en point relais, puis s'évaluent mutuellement.

Le projet suit les étapes de la méthode MERISE :

| Partie | Étapes | Rendu |
|---|---|---|
| Partie 1 | 1. Analyse des besoins · 2. MCD | 16/10/26 |
| Partie 2 | 3. MLD et MPD · 4. Insertion des données · 5. Requêtes · 6. Vidéo | 09/11/26 |

---

## 2. Étape 1 : analyse des besoins

L'analyse des besoins a été réalisée avec une IA générative jouant le rôle de l'entreprise, à partir de la base de prompt fournie, complétée selon le framework RICARDO (ajout du **Contexte** et des **Références**).

### 2.1 Prompt utilisé

Le prompt est également disponible dans [`Prompts/prompt_analyse_besoins.txt`](Prompts/prompt_analyse_besoins.txt).

```text
Tu travailles dans le domaine du commerce en ligne de seconde main entre particuliers. Ton entreprise a comme activité d'exploiter une plateforme web et mobile de type marketplace, sur laquelle des particuliers inscrits mettent en vente des articles d'occasion (vêtements, chaussures, accessoires, articles pour la maison), discutent avec des acheteurs par messagerie, concluent des ventes avec paiement sécurisé via la plateforme, font livrer les articles par des transporteurs ou en point relais, puis s'évaluent mutuellement. Un même membre peut être à la fois vendeur et acheteur. L'entreprise se rémunère grâce à des frais de protection acheteur ajoutés à chaque commande et à des options payantes de mise en avant des annonces. C'est une entreprise comme Vinted, Leboncoin ou Vestiaire Collective. Les données ont été collectées sur les membres de la plateforme, les articles mis en vente et leurs annonces, les catégories et les marques, les photos des articles, les messages échangés entre membres, les commandes et les paiements, les livraisons et les points relais, les évaluations entre membres et les litiges. Inspire-toi des sites web suivants : https://www.vinted.fr (site principal), https://www.vinted.fr/help/550 (protection acheteurs), https://www.vinted.fr/help/342 (calcul des frais), https://www.leboncoin.fr et https://www.vestiairecollective.com.

Ton entreprise veut appliquer MERISE pour concevoir un système d'information. Tu es chargé de la partie analyse, c'est-à-dire de collecter les besoins auprès de l'entreprise. Elle a fait appel à un étudiant en ingénierie informatique pour réaliser ce projet, tu dois lui fournir les informations nécessaires pour qu'il applique ensuite lui-même les étapes suivantes de conception et développement de la base de données.

D'abord, établis les règles de gestions des données de ton entreprise, sous la forme d'une liste à puce. Elle doit correspondre aux informations que fournit quelqu'un qui connaît le fonctionnement de l'entreprise, mais pas comment se construit un système d'information.

Ensuite, à partir de ces règles, fournis un dictionnaire de données brutes avec les colonnes suivantes, regroupées dans un tableau : signification de la donnée, type, taille en nombre de caractères ou de chiffres. Il doit y avoir entre 25 et 35 données. Il sert à fournir des informations supplémentaires sur chaque donnée (taille et type) mais sans a priori sur comment les données vont être modélisées ensuite.

Fournis donc les règles de gestion et le dictionnaire de données.
```

**Éléments ajoutés à la base de prompt :**

- **Contexte :** domaine (commerce de seconde main entre particuliers), type de structure (entreprise), activité détaillée, modèle économique, exemples d'entreprises réelles (Vinted, Leboncoin, Vestiaire Collective), liste des sujets sur lesquels les données sont collectées, et précision qu'un membre peut être à la fois vendeur et acheteur.
- **Références :** pages du site Vinted (accueil, protection acheteurs, calcul des frais), Leboncoin et Vestiaire Collective.

### 2.2 Règles de gestion

Règles obtenues de l'IA, reproduites telles quelles.

#### Les membres

- **RG01** — Pour vendre ou acheter, une personne doit s'inscrire et devient membre. On lui demande un pseudo, son nom, son prénom, une adresse e-mail et un mot de passe. On enregistre la date de son inscription.
- **RG02** — Deux membres ne peuvent pas avoir le même pseudo ni la même adresse e-mail.
- **RG03** — Un membre renseigne une adresse postale (numéro et rue, code postal, ville). Elle est obligatoire pour recevoir un colis à domicile.
- **RG04** — Un même membre peut être vendeur, acheteur, ou les deux.
- **RG05** — L'argent de ses ventes est crédité sur un porte-monnaie (solde) lié à son compte. Il peut ensuite le virer sur son compte bancaire.

#### Les articles et les annonces

- **RG06** — Un membre met un article en vente en publiant une annonce. Chaque annonce concerne un seul article, et un seul membre en est le vendeur.
- **RG07** — Une annonce comporte un titre, une description, un prix de vente, l'état de l'article (neuf avec étiquette, neuf sans étiquette, très bon état, bon état, satisfaisant), une taille si c'est pertinent, et une date de publication.
- **RG08** — Une annonce a un statut : en ligne, réservée, vendue ou retirée.
- **RG09** — Chaque article d'occasion est unique et ne peut donc être vendu qu'une seule fois.
- **RG10** — Chaque article est rangé dans une seule catégorie. Les catégories sont emboîtées les unes dans les autres (par exemple Femmes > Vêtements > Robes).
- **RG11** — Un article peut être associé à une marque, mais ce n'est pas obligatoire. Une marque peut concerner de nombreux articles.
- **RG12** — Une annonce doit avoir au moins une photo et au maximum 20. La première photo sert de photo principale.
- **RG13** — Un membre peut ajouter des annonces d'autres membres à ses favoris.

#### La mise en avant (option payante)

- **RG14** — Un vendeur peut payer pour mettre une annonce en avant pendant une durée donnée, par exemple 3 ou 7 jours. On enregistre la durée, le prix payé et la date de début.
- **RG15** — Une même annonce peut être mise en avant plusieurs fois.

#### La messagerie

- **RG16** — Les membres échangent des messages au sujet d'une annonce précise. Chaque message a un expéditeur, un destinataire, un contenu, ainsi qu'une date et une heure d'envoi.
- **RG17** — Un acheteur peut proposer un prix inférieur par message. Le vendeur accepte ou refuse cette offre.

#### Les commandes et les paiements

- **RG18** — Une commande est passée par un seul acheteur auprès d'un seul vendeur. Elle peut regrouper plusieurs articles de ce vendeur (achat en lot).
- **RG19** — Chaque commande a un numéro unique et une date.
- **RG20** — Le montant payé par l'acheteur comprend trois éléments. Le premier est le prix des articles. Le deuxième est constitué des frais de protection acheteurs, composés d'une part fixe et d'un pourcentage du prix. Le troisième correspond aux frais de port.
- **RG21** — Le vendeur ne paie aucun frais sur sa vente. Il reçoit le prix des articles.
- **RG22** — L'acheteur paie obligatoirement via la plateforme, par carte bancaire, PayPal ou avec le solde de son porte-monnaie.
- **RG23** — L'argent reste bloqué par la plateforme. Il n'est versé au vendeur qu'une fois que l'acheteur a confirmé que tout est conforme, ou automatiquement 2 jours après la livraison si l'acheteur ne s'est pas manifesté.

#### Les livraisons

- **RG24** — Chaque commande donne lieu à un seul envoi. Il est confié à un transporteur (Mondial Relay, Colissimo, Relais Colis…) et se fait soit à domicile, soit en point relais.
- **RG25** — En point relais, l'acheteur choisit le point relais où il retirera son colis. On connaît le nom et l'adresse de ce point relais.
- **RG26** — Chaque envoi a un numéro de suivi. On enregistre la date d'envoi et la date de livraison.
- **RG27** — Le vendeur a 5 jours ouvrés pour expédier le colis. Passé ce délai, la commande est annulée et l'acheteur est remboursé.

#### Les évaluations

- **RG28** — Une fois la commande terminée, l'acheteur et le vendeur peuvent chacun évaluer l'autre. Une évaluation comprend une note de 1 à 5 étoiles, un commentaire facultatif et une date.
- **RG29** — Un membre ne peut laisser qu'une seule évaluation par commande.
- **RG30** — La note moyenne d'un membre est affichée sur son profil.

#### Les litiges

- **RG31** — L'acheteur peut ouvrir un litige dans les 2 jours qui suivent la livraison. Les motifs possibles sont : article non reçu, endommagé, non conforme à la description ou contrefaçon.
- **RG32** — Un litige concerne une seule commande, et une commande ne peut faire l'objet que d'un seul litige.
- **RG33** — Le litige comprend un motif, une description du problème et une date d'ouverture. Le service client le traite et rend une décision : remboursement total, remboursement partiel ou refus. On note ensuite la date de clôture.

### 2.3 Dictionnaire de données

Dictionnaire de données brutes obtenu de l'IA (35 données).

| N° | Signification de la donnée | Type | Taille |
|---|---|---|---|
| 1 | Pseudo du membre | Alphanumérique | 30 |
| 2 | Nom du membre | Alphabétique | 50 |
| 3 | Prénom du membre | Alphabétique | 50 |
| 4 | Adresse e-mail du membre | Alphanumérique | 100 |
| 5 | Adresse postale (numéro et rue) | Alphanumérique | 100 |
| 6 | Code postal | Alphanumérique | 5 |
| 7 | Ville | Alphabétique | 50 |
| 8 | Date d'inscription du membre | Date | 10 |
| 9 | Titre de l'annonce | Alphanumérique | 80 |
| 10 | Description de l'article | Alphanumérique | 2000 |
| 11 | Prix de vente de l'article (€) | Numérique | 7 (dont 2 décimales) |
| 12 | État de l'article | Alphabétique | 30 |
| 13 | Taille de l'article | Alphanumérique | 10 |
| 14 | Date de publication de l'annonce | Date | 10 |
| 15 | Statut de l'annonce | Alphabétique | 10 |
| 16 | Nom de la catégorie | Alphanumérique | 50 |
| 17 | Nom de la marque | Alphanumérique | 50 |
| 18 | Lien (URL) de la photo | Alphanumérique | 255 |
| 19 | Durée de la mise en avant (jours) | Numérique | 2 |
| 20 | Prix de l'option de mise en avant (€) | Numérique | 5 (dont 2 décimales) |
| 21 | Contenu du message | Alphanumérique | 1000 |
| 22 | Date et heure d'envoi du message | Date-heure | 19 |
| 23 | Numéro de la commande | Alphanumérique | 12 |
| 24 | Date de la commande | Date | 10 |
| 25 | Montant des frais de protection acheteurs (€) | Numérique | 6 (dont 2 décimales) |
| 26 | Montant des frais de port (€) | Numérique | 5 (dont 2 décimales) |
| 27 | Moyen de paiement | Alphabétique | 20 |
| 28 | Mode de livraison (domicile / point relais) | Alphabétique | 15 |
| 29 | Nom du transporteur | Alphanumérique | 30 |
| 30 | Numéro de suivi du colis | Alphanumérique | 30 |
| 31 | Nom du point relais | Alphanumérique | 80 |
| 32 | Note de l'évaluation (1 à 5) | Numérique | 1 |
| 33 | Commentaire de l'évaluation | Alphanumérique | 500 |
| 34 | Motif du litige | Alphabétique | 30 |
| 35 | Décision rendue sur le litige | Alphabétique | 30 |

**Remarques de l'IA :**

- Le code postal est en alphanumérique pour conserver le zéro initial (01000, par exemple).
- Le montant total d'une commande n'apparaît pas dans le dictionnaire, car c'est une donnée calculée à partir des données 11, 25 et 26.
- Les règles citent quelques informations absentes du dictionnaire (solde, date de livraison, date d'ouverture d'un litige, prix d'une offre). Elles en ont été écartées pour respecter la limite de 35 données.

### 2.4 Analyse du résultat

Nous avons vérifié l'adéquation de la réponse de l'IA avec les exigences du prompt.

| Critère | Résultat |
|---|---|
| Nombre de données entre 25 et 35 | ✅ 35 données |
| Règles de gestion sous forme de liste à puces | ✅ 33 règles, regroupées par thème |
| Dictionnaire en tableau (signification, type, taille) | ✅ |
| Tous les sujets du prompt sont couverts (membres, annonces, catégories, marques, photos, messages, commandes, paiements, livraisons, points relais, évaluations, litiges) | ✅ |
| Prise en compte des références (frais en part fixe + pourcentage, délai de réclamation de 2 jours) | ✅ |
| Types et tailles cohérents | ✅ |
| Toutes les données citées dans les règles figurent dans le dictionnaire | ⚠️ Non (voir ci-dessous) |

**Problème relevé :** en atteignant la limite de 35 données, l'IA a écarté plusieurs données pourtant citées dans ses propres règles de gestion. Elle en signale une partie dans ses remarques, mais pas toutes. Les données manquantes sont :

| Donnée manquante | Règle concernée | Signalée par l'IA |
|---|---|---|
| Mot de passe du membre | RG01 | Non |
| Solde du porte-monnaie | RG05 | Oui |
| Date de début de la mise en avant | RG14 | Non |
| Prix proposé dans une offre et réponse du vendeur | RG17 | En partie |
| Date d'envoi du colis | RG26 | Non |
| Date de livraison | RG26 | Oui |
| Adresse du point relais | RG25 | Non |
| Date de l'évaluation | RG28 | Non |
| Description du problème du litige | RG33 | Non |
| Date d'ouverture du litige | RG33 | Oui |
| Date de clôture du litige | RG33 | Non |

**Décision :** la réponse respectant toutes les exigences formulées dans le prompt, nous l'avons conservée sans la resoumettre. Une nouvelle soumission aurait obligé l'IA soit à dépasser 35 données, soit à appauvrir les règles de gestion. Le sujet autorisant l'ajout de données au MCD, **nous ajoutons ces données manquantes directement dans le MCD** afin qu'il soit cohérent avec l'ensemble des règles de gestion.

---

## 3. Étape 2 : MCD


Le MCD est réalisé avec **Looping** . Le fichier source se trouve dans ['mcd_revente.loo')et l'image du shéma se trouvent dans le dossier ['MCD /'](MCD/).

![MCD](MCD/mcd.png)

Il comporte **13 entités** (MEMBRE, ANNONCE, CATEGORIE, MARQUE, PHOTO, MISE_EN_AVANT, MESSAGE, COMMANDE, LIVRAISON, TRANSPORTEUR, POINT_RELAIS, EVALUATION, LITIGE) et **19 associations**. Il respecte la troisième forme normale : chaque attribut dépend uniquement de l'identifiant de son entité.

### 3.1 Éléments de modélisation avancée

- **Association récursive « sous_categorie_de »** sur CATEGORIE (RG10) : une catégorie peut être la sous-catégorie d'une catégorie mère (0,1), et une catégorie mère peut avoir plusieurs sous-catégories (0,n). Exemple : Femmes → Robes.
- **Entité faible PHOTO** (RG12) : une photo est identifiée par son numéro d'ordre *relativement à son annonce*. Le `num_ordre` seul n'est pas unique (chaque annonce a sa photo n°1) ; l'identifiant complet est le couple (id_annonce, num_ordre), d'où l'identifiant relatif (1,1) sur la patte « illustre ».
- **Entité faible MISE_EN_AVANT** (RG14-15) : une mise en avant est identifiée par sa date de début relativement à l'annonce promue. Une même annonce peut être mise en avant plusieurs fois, à des dates différentes.

### 3.2 Choix de modélisation

- **Annonce et article fusionnés** : un article correspond à une seule annonce et inversement (RG06). Deux entités reliées par une association 1,1–1,1 seraient redondantes ; nous avons donc gardé une seule entité ANNONCE.
- **Pas de lien direct entre la commande et le vendeur** : le vendeur se retrouve à partir des annonces contenues dans la commande. Un lien supplémentaire aurait créé une redondance.
- **Données calculées non stockées** : le montant total d'une commande (RG20) et la note moyenne d'un membre (RG30) se calculent à partir des autres données ; les stocker créerait un risque d'incohérence.
- **Cardinalité 0,1 côté ANNONCE dans « contient »** : un article ne peut être vendu qu'une seule fois (RG09).
- **Ternaire écartée pour EVALUATION** : comme un membre ne peut évaluer qu'une fois par commande (RG29), le membre évalué se déduit de la commande. Une association ternaire aurait été décomposable ; nous avons préféré trois associations binaires (« rédige », « est évalué par », « porte sur »).
- **Ville et code postal gardés dans MEMBRE** : il n'existe pas de dépendance fonctionnelle stricte entre les deux (un code postal peut couvrir plusieurs communes), donc la 3FN reste respectée.
- **Données ajoutées par rapport au dictionnaire** : les données citées dans les règles de gestion mais absentes du dictionnaire (voir section 2.4) ont été intégrées au MCD, par exemple `mot_de_passe`, `solde`, `prix_propose`, `date_envoi` ou `date_evaluation`.

---

## 4. Partie 2 : MLD et MPD

### 4.1 MLD

Le MLD a été généré automatiquement avec Looping à partir du MCD, en appliquant les règles de passage au modèle relationnel. Les clés primaires sont soulignées et les clés étrangères sont précédées de `#`.

![MLD](MCD/MLDminiprojet2.png)

Les clés étrangères en double générées par Looping (`id_membre`, `id_membre_1`, `id_categorie_1`) ont été renommées selon leur rôle dans le script SQL et dans la liste ci-dessous.

- **MEMBRE** (<u>id_membre</u>, pseudo, nom, prenom, email, mot_de_passe, adresse_rue, code_postal, ville, date_inscription, solde)
- **CATEGORIE** (<u>id_categorie</u>, nom_categorie, #id_categorie_mere)
- **MARQUE** (<u>id_marque</u>, nom_marque)
- **COMMANDE** (<u>num_commande</u>, date_commande, frais_protection, frais_port, moyen_paiement, #id_acheteur)
- **ANNONCE** (<u>id_annonce</u>, titre, description, prix_vente, etat, taille, date_publication, statut, #id_vendeur, #id_categorie, #id_marque, #num_commande)
- **PHOTO** (<u>#id_annonce, num_ordre</u>, url_photo)
- **MISE_EN_AVANT** (<u>#id_annonce, date_debut</u>, duree_jours, prix_option)
- **MET_EN_FAVORI** (<u>#id_membre, #id_annonce</u>)
- **MESSAGE** (<u>id_message</u>, contenu, date_heure_envoi, prix_propose, reponse_offre, #id_annonce, #id_expediteur, #id_destinataire)
- **TRANSPORTEUR** (<u>id_transporteur</u>, nom_transporteur)
- **POINT_RELAIS** (<u>id_point_relais</u>, nom_point_relais, adresse_point_relais)
- **LIVRAISON** (<u>num_suivi</u>, mode_livraison, date_envoi, date_livraison, #num_commande, #id_transporteur, #id_point_relais)
- **EVALUATION** (<u>id_evaluation</u>, note, commentaire, date_evaluation, #id_auteur, #id_evalue, #num_commande)
- **LITIGE** (<u>id_litige</u>, motif, description, date_ouverture, decision, date_cloture, #num_commande)

| Clé générée par Looping | Nom retenu | Rôle |
|---|---|---|
| `ANNONCE.id_membre` | `id_vendeur` | membre qui publie l'annonce |
| `COMMANDE.id_membre` | `id_acheteur` | membre qui passe la commande |
| `CATEGORIE.id_categorie_1` | `id_categorie_mere` | catégorie qui contient la sous-catégorie |
| `MESSAGE.id_membre` / `id_membre_1` | `id_expediteur` / `id_destinataire` | membre qui envoie / qui reçoit le message |
| `EVALUATION.id_membre` / `id_membre_1` | `id_auteur` / `id_evalue` | membre qui rédige / qui est évalué |

**Remarques sur le passage au MLD :**

- L'association n-n « met en favori » devient la table MET_EN_FAVORI, dont la clé primaire est composée des deux clés étrangères.
- Les entités faibles PHOTO et MISE_EN_AVANT ont une clé primaire composée de la clé de l'annonce et de leur identifiant relatif.
- L'association récursive « sous-catégorie de » devient la clé étrangère `id_categorie_mere`, qui référence CATEGORIE elle-même (vide pour une catégorie principale).
- Les cardinalités 0,1 donnent des clés étrangères facultatives : `id_marque`, `num_commande` dans ANNONCE (article non vendu) et `id_point_relais` (livraison à domicile).
- `num_commande` est unique dans LIVRAISON et dans LITIGE, car une commande donne lieu à une seule livraison et fait l'objet d'au plus un litige.
  
### 4.2 MPD : création des tables ([`1_creation.sql`](1_creation.sql))

Le MPD est implémenté en SQL pour MySQL 8. Le script crée la base `revente` et ses 14 tables, avec les contraintes d'intégrité :

- 14 clés primaires, dont trois composées : PHOTO (`id_annonce`, `num_ordre`), MISE_EN_AVANT (`id_annonce`, `date_debut`) et MET_EN_FAVORI (`id_membre`, `id_annonce`) ;
- 20 clés étrangères, dont une récursive sur CATEGORIE (`id_categorie_mere`) ;
- des `NOT NULL` sur toutes les données obligatoires ; les clés étrangères issues d'une cardinalité 0,1 (`id_marque`, `num_commande` dans ANNONCE, `id_point_relais`, `id_categorie_mere`) acceptent la valeur `NULL` ;
- deux contraintes `UNIQUE` sur `num_commande` dans LIVRAISON et dans LITIGE, qui traduisent les cardinalités 0,1 côté COMMANDE : une commande a au plus une livraison et au plus un litige.

Pour gérer automatiquement la modification et la suppression des enregistrements référencés sans déclencher d'erreur, chaque clé étrangère porte une action :

| Action | Clés étrangères concernées | Justification |
|---|---|---|
| `ON UPDATE CASCADE` | toutes | Si une clé primaire change, la nouvelle valeur est reportée partout où elle est utilisée. |
| `ON DELETE CASCADE` | photos, mises en avant, favoris et messages d'une annonce ; annonces, commandes, messages et évaluations d'un membre ; livraison, évaluations et litige d'une commande ; annonces d'une catégorie | Ces lignes n'ont pas de sens sans la ligne qu'elles référencent (une photo sans annonce, par exemple). |
| `ON DELETE SET NULL` | `id_marque` et `num_commande` dans ANNONCE, `id_point_relais` dans LIVRAISON, `id_categorie_mere` dans CATEGORIE | Le lien est facultatif (cardinalité 0,1) : la ligne reste, sans le lien. Une annonce dont la marque est supprimée reste en ligne sans marque ; une sous-catégorie dont la mère est supprimée devient une catégorie principale. |

### 4.3 Contraintes de validation ([`2_contraintes.sql`](2_contraintes.sql))

Le script ajoute 29 contraintes nommées (23 `CHECK` et 6 `UNIQUE`) et 2 valeurs par défaut. Elles traduisent les règles de gestion de l'étape 1 et couvrent les différents types vus en cours :

| Type | Exemples | Règle |
|---|---|---|
| `UNIQUE` | pseudo et e-mail d'un membre ; couple (auteur, commande) dans EVALUATION ; nom de marque, de transporteur, de sous-catégorie | RG02, RG29 |
| `CHECK … IN` | état de l'article (5 valeurs), statut de l'annonce, réponse à une offre, moyen de paiement, mode de livraison, motif et décision d'un litige | RG07, RG08, RG17, RG22, RG24, RG31, RG33 |
| `CHECK … BETWEEN` | note de 1 à 5, numéro de photo de 1 à 20, durée de mise en avant de 1 à 30 jours | RG28, RG12, RG14 |
| `CHECK … LIKE` | format de l'e-mail (`'%_@_%._%'`), URL des photos en `https://` | RG01, RG12 |
| `CHECK … REGEXP` | code postal à 5 chiffres, numéro de commande au format `CMD-` + 8 chiffres | RG03, RG19 |
| `CHECK` comparaisons | prix de vente, prix d'option et prix proposé positifs, frais positifs, solde jamais négatif | RG05, RG07, RG14, RG17, RG20 |
| `CHECK` entre colonnes | livraison après l'envoi ; clôture d'un litige après son ouverture ; un litige clos a une décision et une date de clôture, un litige en cours n'a ni l'une ni l'autre ; une réponse n'existe que s'il y a une offre | RG17, RG26, RG33 |
| `DEFAULT` | solde à 0 à l'inscription, statut « en ligne » à la publication | RG05, RG08 |

Certaines règles ne peuvent pas s'écrire avec un `CHECK` : celles qui comparent deux tables (une offre inférieure au prix de l'annonce, une évaluation postérieure à la livraison, une commande qui ne regroupe que des articles d'un même vendeur) et celles qui portent sur une clé étrangère, car MySQL interdit un `CHECK` sur une colonne qui a une action `ON DELETE` / `ON UPDATE` (par exemple, un membre ne s'évalue pas lui-même). Elles demanderaient des triggers.

### 4.4 Exécution des scripts

Les scripts sont à exécuter dans MySQL Workbench (MySQL 8), dans cet ordre, car chacun dépend du précédent :

1. [`1_creation.sql`](1_creation.sql) : création de la base `revente` et des 14 tables (le script supprime la base si elle existe déjà, il peut donc être relancé) ;
2. [`2_contraintes.sql`](2_contraintes.sql) : ajout des contraintes de validation ;
3. [`3_insertion.sql`](3_insertion.sql) : insertion des données ;
4. [`4_interrogation.sql`](4_interrogation.sql) : requêtes du scénario d'utilisation, à exécuter une par une (Ctrl + Entrée).

Pour repartir d'une base propre, il suffit de réexécuter les scripts 1, 2 puis 3.
---
## 5. Étape 4 : insertion des données

Les données ont été générées par une IA générative (Claude, d'Anthropic) à partir du prompt [`prompts/prompt_insertion.txt`](prompts/prompt_insertion.txt). Il reprend la forme du prompt du TP1 : modèle relationnel avec les clés, nombre de lignes attendues, ordre d'insertion, contraintes de validation à respecter, règles métier de cohérence et consignes de réalisme. Le résultat est dans [`3_insertion.sql`](3_insertion.sql), à exécuter après [`1_creation.sql`](1_creation.sql) et [`2_contraintes.sql`](2_contraintes.sql).

| Table | Lignes | Table | Lignes |
|---|---|---|---|
| membre | 40 | photo | 316 |
| categorie | 20 (3 niveaux) | mise_en_avant | 25 |
| marque | 15 | met_en_favori | 150 |
| transporteur | 4 | message | 150 |
| point_relais | 12 | livraison | 45 |
| commande | 45 | evaluation | 61 |
| annonce | 120 | litige | 8 |

## 5. Étape 5 : Interrogation de la BD

### 5.1. Scénario d'utilisation
**Rôle :** Le service marketing et qualité de la plateforme.
**Objectif :** Analyser l'activité pour préparer une campagne de communication et améliorer la satisfaction client. Le gestionnaire souhaite :
1. Identifier les membres les plus actifs (vendeurs avec le plus d'annonces).
2. Analyser le chiffre d'affaires généré par catégorie.
3. Surveiller les litiges et évaluer les transporteurs.
4. Trouver les annonces très populaires qui pourraient bénéficier d'une mise en avant.
5.  ([`4_interrogation.sql`](4_interrogation.sql))
   
### 5.2. Étude du plan d'exécution (Algèbre relationnelle)
**Requête étudiée :** *Trouver le pseudo des membres ayant publié une annonce dans la catégorie 'Robes' à un prix supérieur à 50€.*

**Algèbre relationnelle :**

$$
\pi_{pseudo} (\sigma_{prix\_vente > 50 \land nom\_categorie = 'Robes'} (MEMBRE \bowtie ANNONCE \bowtie CATEGORIE))
$$

**Estimations de lignes  :**
- `MEMBRE` : 50 lignes
- `ANNONCE` : 100 lignes
- `CATEGORIE` : 10 lignes

**Arbre 1 : Plan non optimisé **

```mermaid
graph TD
    A["Projection (pseudo)<br/>~5 lignes"] --> B["Sélection (prix > 50 ET nom='Robes')<br/>~5 lignes"]
    B --> C["Jointure (ANNONCE.id_membre = MEMBRE.id_membre)<br/>~5000 lignes"]
    C --> D["Jointure (ANNONCE.id_categorie = CATEGORIE.id_categorie)<br/>~50000 lignes"]
    D --> E["MEMBRE<br/>50 lignes"]
    D --> F["ANNONCE<br/>100 lignes"]
    D --> G["CATEGORIE<br/>10 lignes"]
```
**Arbre 2 : Plan optimisé (Sélections au plus tôt)**

```mermaid
graph TD
    A["Projection (pseudo)<br/>~1 ligne"] --> B["Jointure (ANNONCE.id_membre = MEMBRE.id_membre)<br/>~5 lignes"]
    B --> C["MEMBRE<br/>50 lignes"]
    B --> D["Jointure (ANNONCE.id_categorie = CATEGORIE.id_categorie)<br/>~5 lignes"]
    D --> E["Sélection (prix > 50)<br/>~10 lignes"]
    E --> F["ANNONCE<br/>100 lignes"]
    D --> G["Sélection (nom = 'Robes')<br/>1 ligne"]
    G --> H["CATEGORIE<br/>10 lignes"]
```
