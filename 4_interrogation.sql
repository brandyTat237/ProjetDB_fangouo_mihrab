USE revente;
SET NAMES utf8mb4;

-- A1. Annonces en ligne vendues entre 10 et 30 €, de la plus chère à la moins chère :
--     ce sont les petits prix qui seront mis en avant dans la campagne.
SELECT id_annonce, titre, prix_vente, etat
FROM annonce
WHERE statut = 'en ligne'
  AND prix_vente BETWEEN 10 AND 30
ORDER BY prix_vente DESC;

-- A2. Liste des villes (sans doublon) où habitent les membres, par ordre alphabétique :
--     pour cibler la campagne géographiquement.
SELECT DISTINCT ville
FROM membre
ORDER BY ville;

-- A3. Annonces dont le titre contient « Robe » ou commence par « Jean » (masques LIKE) :
--     la campagne portera sur ces deux produits phares.
SELECT id_annonce, titre, prix_vente, statut
FROM annonce
WHERE titre LIKE '%Robe%'
   OR titre LIKE 'Jean%'
ORDER BY titre, prix_vente;

-- A4. Articles neufs (avec ou sans étiquette) encore en ligne :
--     arguments « neuf » pour la campagne.
SELECT id_annonce, titre, etat, prix_vente
FROM annonce
WHERE etat IN ('neuf avec étiquette', 'neuf sans étiquette')
  AND statut = 'en ligne'
ORDER BY etat, prix_vente;

-- A5. Membres franciliens (code postal commençant par 75, 92, 93 ou 94)
--     inscrits en 2024, à contacter par e-mail.
SELECT pseudo, prenom, nom, email, code_postal, date_inscription
FROM membre
WHERE (code_postal LIKE '75%' OR code_postal LIKE '92%'
       OR code_postal LIKE '93%' OR code_postal LIKE '94%')
  AND date_inscription BETWEEN '2024-01-01' AND '2024-12-31'
ORDER BY date_inscription;

-- A6. Commandes de 2026 payées par PayPal ou avec le porte-monnaie :
--     pour mesurer l'usage des moyens de paiement alternatifs.
SELECT num_commande, date_commande, moyen_paiement
FROM commande
WHERE moyen_paiement IN ('PayPal', 'porte-monnaie')
  AND YEAR(date_commande) = 2026
ORDER BY date_commande;

-- B1. Nombre d'annonces, prix moyen, minimum et maximum par statut.
SELECT statut,
       COUNT(*)                  AS nb_annonces,
       ROUND(AVG(prix_vente), 2) AS prix_moyen,
       MIN(prix_vente)           AS prix_min,
       MAX(prix_vente)           AS prix_max
FROM annonce
GROUP BY statut
ORDER BY nb_annonces DESC;

-- B2. Note moyenne des membres évalués au moins 2 fois, de la meilleure à la moins bonne
--     (note moyenne affichée sur le profil, RG30).
SELECT id_evalue,
       COUNT(*)            AS nb_evaluations,
       ROUND(AVG(note), 2) AS note_moyenne
FROM evaluation
GROUP BY id_evalue
HAVING COUNT(*) >= 2
ORDER BY note_moyenne DESC, nb_evaluations DESC;

-- B3. Chiffre d'affaires des articles vendus par mois de commande.
SELECT DATE_FORMAT(c.date_commande, '%Y-%m') AS mois,
       COUNT(DISTINCT c.num_commande)          AS nb_commandes,
       SUM(a.prix_vente)                       AS ca_articles
FROM commande c
JOIN annonce a ON a.num_commande = c.num_commande
GROUP BY DATE_FORMAT(c.date_commande, '%Y-%m')
ORDER BY mois;

-- B4. Vendeurs ayant réalisé plus de 60 € de ventes :
--     candidats au programme « Vendeurs de confiance ».
SELECT id_vendeur,
       COUNT(*)        AS nb_articles_vendus,
       SUM(prix_vente) AS total_ventes
FROM annonce
WHERE statut = 'vendue'
GROUP BY id_vendeur
HAVING SUM(prix_vente) > 60
ORDER BY total_ventes DESC;

-- B5. Délai moyen de livraison (en jours) par transporteur,
--     pour les transporteurs ayant livré au moins 5 colis.
SELECT id_transporteur,
       COUNT(*)                                          AS nb_colis_livres,
       ROUND(AVG(DATEDIFF(date_livraison, date_envoi)), 1) AS delai_moyen_jours
FROM livraison
WHERE date_livraison IS NOT NULL
GROUP BY id_transporteur
HAVING COUNT(*) >= 5
ORDER BY delai_moyen_jours;

-- B6. Nombre de litiges par motif, et nombre de litiges encore en cours.
SELECT motif,
       COUNT(*)        AS nb_litiges,
       COUNT(decision) AS nb_clos,
       COUNT(*) - COUNT(decision) AS nb_en_cours
FROM litige
GROUP BY motif
ORDER BY nb_litiges DESC;

-- C1. Jointure interne multiple : annonces en ligne avec le pseudo du vendeur
--     et le nom de la catégorie.
SELECT a.id_annonce, a.titre, a.prix_vente, m.pseudo AS vendeur, c.nom_categorie
FROM annonce a
INNER JOIN membre m    ON m.id_membre = a.id_vendeur
INNER JOIN categorie c ON c.id_categorie = a.id_categorie
WHERE a.statut = 'en ligne'
ORDER BY c.nom_categorie, a.prix_vente;

-- C2. Auto-jointure externe : chaque catégorie avec sa catégorie mère
--     (la catégorie mère est vide pour les catégories principales).
SELECT fille.id_categorie, fille.nom_categorie,
       mere.nom_categorie AS categorie_mere
FROM categorie fille
LEFT JOIN categorie mere ON mere.id_categorie = fille.id_categorie_mere
ORDER BY mere.nom_categorie, fille.nom_categorie;

-- C3. Jointure externe gauche : toutes les marques avec leur nombre d'annonces,
--     y compris les marques sans aucune annonce.
SELECT mq.nom_marque, COUNT(a.id_annonce) AS nb_annonces
FROM marque mq
LEFT JOIN annonce a ON a.id_marque = mq.id_marque
GROUP BY mq.id_marque, mq.nom_marque
ORDER BY nb_annonces DESC;

-- C4. Jointure multiple avec externe : détail des commandes avec acheteur,
--     transporteur, mode de livraison et point relais (vide si livraison à domicile).
SELECT c.num_commande, c.date_commande, ach.pseudo AS acheteur,
       t.nom_transporteur, l.mode_livraison, pr.nom_point_relais,
       l.date_envoi, l.date_livraison
FROM commande c
INNER JOIN membre ach      ON ach.id_membre = c.id_acheteur
INNER JOIN livraison l     ON l.num_commande = c.num_commande
INNER JOIN transporteur t  ON t.id_transporteur = l.id_transporteur
LEFT JOIN point_relais pr  ON pr.id_point_relais = l.id_point_relais
ORDER BY c.date_commande DESC;

-- C5. Double jointure sur la même table : messages contenant une offre,
--     avec le pseudo de l'expéditeur et celui du destinataire.
SELECT msg.date_heure_envoi, exp.pseudo AS expediteur, dest.pseudo AS destinataire,
       a.titre, a.prix_vente, msg.prix_propose, msg.reponse_offre
FROM message msg
JOIN membre exp  ON exp.id_membre  = msg.id_expediteur
JOIN membre dest ON dest.id_membre = msg.id_destinataire
JOIN annonce a   ON a.id_annonce   = msg.id_annonce
WHERE msg.prix_propose IS NOT NULL
ORDER BY msg.date_heure_envoi;

-- C6. Jointure externe avec test de nullité : membres qui n'ont encore jamais
--     passé de commande (cible d'une offre de bienvenue).
SELECT m.id_membre, m.pseudo, m.email
FROM membre m
LEFT JOIN commande c ON c.id_acheteur = m.id_membre
WHERE c.num_commande IS NULL
ORDER BY m.pseudo;

-- D1. NOT IN : annonces en ligne que personne n'a mises en favori
--     (elles ont besoin de visibilité).
SELECT id_annonce, titre, prix_vente
FROM annonce
WHERE statut = 'en ligne'
  AND id_annonce NOT IN (SELECT id_annonce FROM met_en_favori)
ORDER BY date_publication;

-- D2. EXISTS : membres qui sont à la fois vendeurs et acheteurs (RG04).
SELECT m.id_membre, m.pseudo
FROM membre m
WHERE EXISTS (SELECT * FROM annonce a  WHERE a.id_vendeur  = m.id_membre AND a.statut = 'vendue')
  AND EXISTS (SELECT * FROM commande c WHERE c.id_acheteur = m.id_membre)
ORDER BY m.pseudo;

-- D3. NOT EXISTS : vendeurs ayant vendu au moins un article
--     et dont aucune commande n'a fait l'objet d'un litige.
SELECT DISTINCT m.id_membre, m.pseudo
FROM membre m
JOIN annonce a ON a.id_vendeur = m.id_membre AND a.statut = 'vendue'
WHERE NOT EXISTS (SELECT *
                  FROM annonce a2
                  JOIN litige l ON l.num_commande = a2.num_commande
                  WHERE a2.id_vendeur = m.id_membre)
ORDER BY m.pseudo;

-- D4. ALL : l'annonce en ligne la plus chère de la plateforme.
SELECT id_annonce, titre, prix_vente
FROM annonce
WHERE statut = 'en ligne'
  AND prix_vente >= ALL (SELECT prix_vente FROM annonce WHERE statut = 'en ligne');

-- D5. ANY : transporteurs ayant au moins une livraison qui a pris plus de 5 jours.
SELECT id_transporteur, nom_transporteur
FROM transporteur
WHERE id_transporteur = ANY (SELECT id_transporteur
                             FROM livraison
                             WHERE DATEDIFF(date_livraison, date_envoi) > 5);

-- D6. Sous-requête dans HAVING : vendeurs dont la note moyenne est supérieure
--     à la note moyenne de toute la plateforme (sélection finale du programme).
SELECT e.id_evalue, m.pseudo, ROUND(AVG(e.note), 2) AS note_moyenne
FROM evaluation e
JOIN membre m ON m.id_membre = e.id_evalue
GROUP BY e.id_evalue, m.pseudo
HAVING AVG(e.note) > (SELECT AVG(note) FROM evaluation)
ORDER BY note_moyenne DESC;

-- E1. Titres et prix des robes encore en ligne (requête étudiée dans le README).
SELECT a.titre, a.prix_vente
FROM annonce a
JOIN categorie c ON c.id_categorie = a.id_categorie
WHERE c.nom_categorie = 'Robes'
  AND a.statut = 'en ligne';