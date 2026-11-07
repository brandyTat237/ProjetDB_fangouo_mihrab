USE revente;
SET NAMES utf8mb4;

ALTER TABLE membre ADD CONSTRAINT uq_membre_pseudo UNIQUE (pseudo);
ALTER TABLE membre ADD CONSTRAINT uq_membre_email  UNIQUE (email);
ALTER TABLE membre ADD CONSTRAINT chk_membre_email
    CHECK (email LIKE '%_@_%._%');
ALTER TABLE membre ADD CONSTRAINT chk_membre_code_postal
    CHECK (code_postal REGEXP '^[0-9]{5}$');
ALTER TABLE membre ADD CONSTRAINT chk_membre_solde CHECK (solde >= 0);
ALTER TABLE membre ALTER COLUMN solde SET DEFAULT 0;

ALTER TABLE categorie ADD CONSTRAINT uq_categorie_nom
    UNIQUE (nom_categorie, id_categorie_mere);
ALTER TABLE marque ADD CONSTRAINT uq_marque_nom UNIQUE (nom_marque);
ALTER TABLE transporteur ADD CONSTRAINT uq_transporteur_nom UNIQUE (nom_transporteur);

ALTER TABLE annonce ADD CONSTRAINT chk_annonce_prix CHECK (prix_vente > 0);
ALTER TABLE annonce ADD CONSTRAINT chk_annonce_etat
    CHECK (etat IN ('neuf avec étiquette', 'neuf sans étiquette',
                    'très bon état', 'bon état', 'satisfaisant'));
ALTER TABLE annonce ADD CONSTRAINT chk_annonce_statut
    CHECK (statut IN ('en ligne', 'réservée', 'vendue', 'retirée'));
ALTER TABLE annonce ALTER COLUMN statut SET DEFAULT 'en ligne';

ALTER TABLE photo ADD CONSTRAINT chk_photo_num_ordre CHECK (num_ordre BETWEEN 1 AND 20);
ALTER TABLE photo ADD CONSTRAINT chk_photo_url CHECK (url_photo LIKE 'https://%');

ALTER TABLE mise_en_avant ADD CONSTRAINT chk_mea_duree CHECK (duree_jours BETWEEN 1 AND 30);
ALTER TABLE mise_en_avant ADD CONSTRAINT chk_mea_prix  CHECK (prix_option > 0);

ALTER TABLE message ADD CONSTRAINT chk_message_prix CHECK (prix_propose > 0);
ALTER TABLE message ADD CONSTRAINT chk_message_reponse
    CHECK (reponse_offre IN ('acceptée', 'refusée'));
ALTER TABLE message ADD CONSTRAINT chk_message_offre
    CHECK (reponse_offre IS NULL OR prix_propose IS NOT NULL);

ALTER TABLE commande ADD CONSTRAINT chk_commande_num
    CHECK (num_commande REGEXP '^CMD-[0-9]{8}$');
ALTER TABLE commande ADD CONSTRAINT chk_commande_frais
    CHECK (frais_protection >= 0 AND frais_port >= 0);
ALTER TABLE commande ADD CONSTRAINT chk_commande_paiement
    CHECK (moyen_paiement IN ('carte bancaire', 'PayPal', 'porte-monnaie'));

ALTER TABLE livraison ADD CONSTRAINT chk_livraison_mode
    CHECK (mode_livraison IN ('domicile', 'point relais'));
ALTER TABLE livraison ADD CONSTRAINT chk_livraison_dates
    CHECK (date_livraison IS NULL
           OR (date_envoi IS NOT NULL AND date_livraison >= date_envoi));

ALTER TABLE evaluation ADD CONSTRAINT chk_evaluation_note CHECK (note BETWEEN 1 AND 5);
ALTER TABLE evaluation ADD CONSTRAINT uq_evaluation_auteur_commande
    UNIQUE (id_auteur, num_commande);

ALTER TABLE litige ADD CONSTRAINT chk_litige_motif
    CHECK (motif IN ('article non reçu', 'endommagé',
                     'non conforme à la description', 'contrefaçon'));
ALTER TABLE litige ADD CONSTRAINT chk_litige_decision
    CHECK (decision IN ('remboursement total', 'remboursement partiel', 'refus'));
ALTER TABLE litige ADD CONSTRAINT chk_litige_dates
    CHECK (date_cloture IS NULL OR date_cloture >= date_ouverture);
ALTER TABLE litige ADD CONSTRAINT chk_litige_cloture
    CHECK ((decision IS NULL AND date_cloture IS NULL)
        OR (decision IS NOT NULL AND date_cloture IS NOT NULL));