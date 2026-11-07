SET NAMES utf8mb4;

DROP DATABASE IF EXISTS revente;
CREATE DATABASE revente CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE revente;

CREATE TABLE membre (
    id_membre        INT           AUTO_INCREMENT,
    pseudo           VARCHAR(30)   NOT NULL,
    nom              VARCHAR(50)   NOT NULL,
    prenom           VARCHAR(50)   NOT NULL,
    email            VARCHAR(100)  NOT NULL,
    mot_de_passe     VARCHAR(255)  NOT NULL,
    adresse_rue      VARCHAR(100)  NOT NULL,
    code_postal      CHAR(5)       NOT NULL,
    ville            VARCHAR(50)   NOT NULL,
    date_inscription DATE          NOT NULL,
    solde            DECIMAL(8,2)  NOT NULL,
    CONSTRAINT pk_membre PRIMARY KEY (id_membre)
);

CREATE TABLE marque (
    id_marque   INT          AUTO_INCREMENT,
    nom_marque  VARCHAR(50)  NOT NULL,
    CONSTRAINT pk_marque PRIMARY KEY (id_marque)
);

CREATE TABLE transporteur (
    id_transporteur   INT          AUTO_INCREMENT,
    nom_transporteur  VARCHAR(30)  NOT NULL,
    CONSTRAINT pk_transporteur PRIMARY KEY (id_transporteur)
);

CREATE TABLE point_relais (
    id_point_relais       INT           AUTO_INCREMENT,
    nom_point_relais      VARCHAR(80)   NOT NULL,
    adresse_point_relais  VARCHAR(150)  NOT NULL,
    CONSTRAINT pk_point_relais PRIMARY KEY (id_point_relais)
);

CREATE TABLE categorie (
    id_categorie       INT          AUTO_INCREMENT,
    nom_categorie      VARCHAR(50)  NOT NULL,
    id_categorie_mere  INT          NULL,
    CONSTRAINT pk_categorie PRIMARY KEY (id_categorie),
    CONSTRAINT fk_categorie_mere FOREIGN KEY (id_categorie_mere)
        REFERENCES categorie (id_categorie)
        ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE commande (
    num_commande      VARCHAR(12)   NOT NULL,
    date_commande     DATE          NOT NULL,
    frais_protection  DECIMAL(6,2)  NOT NULL,
    frais_port        DECIMAL(5,2)  NOT NULL,
    moyen_paiement    VARCHAR(20)   NOT NULL,
    id_acheteur       INT           NOT NULL,
    CONSTRAINT pk_commande PRIMARY KEY (num_commande),
    CONSTRAINT fk_commande_acheteur FOREIGN KEY (id_acheteur)
        REFERENCES membre (id_membre)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE annonce (
    id_annonce        INT            AUTO_INCREMENT,
    titre             VARCHAR(80)    NOT NULL,
    description       VARCHAR(2000)  NOT NULL,
    prix_vente        DECIMAL(7,2)   NOT NULL,
    etat              VARCHAR(30)    NOT NULL,
    taille            VARCHAR(10)    NULL,
    date_publication  DATE           NOT NULL,
    statut            VARCHAR(10)    NOT NULL,
    id_vendeur        INT            NOT NULL,
    id_categorie      INT            NOT NULL,
    id_marque         INT            NULL,
    num_commande      VARCHAR(12)    NULL,
    CONSTRAINT pk_annonce PRIMARY KEY (id_annonce),
    CONSTRAINT fk_annonce_vendeur FOREIGN KEY (id_vendeur)
        REFERENCES membre (id_membre)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_annonce_categorie FOREIGN KEY (id_categorie)
        REFERENCES categorie (id_categorie)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_annonce_marque FOREIGN KEY (id_marque)
        REFERENCES marque (id_marque)
        ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT fk_annonce_commande FOREIGN KEY (num_commande)
        REFERENCES commande (num_commande)
        ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE photo (
    id_annonce  INT           NOT NULL,
    num_ordre   TINYINT       NOT NULL,
    url_photo   VARCHAR(255)  NOT NULL,
    CONSTRAINT pk_photo PRIMARY KEY (id_annonce, num_ordre),
    CONSTRAINT fk_photo_annonce FOREIGN KEY (id_annonce)
        REFERENCES annonce (id_annonce)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE mise_en_avant (
    id_annonce   INT           NOT NULL,
    date_debut   DATE          NOT NULL,
    duree_jours  TINYINT       NOT NULL,
    prix_option  DECIMAL(5,2)  NOT NULL,
    CONSTRAINT pk_mise_en_avant PRIMARY KEY (id_annonce, date_debut),
    CONSTRAINT fk_mise_en_avant_annonce FOREIGN KEY (id_annonce)
        REFERENCES annonce (id_annonce)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE met_en_favori (
    id_membre   INT  NOT NULL,
    id_annonce  INT  NOT NULL,
    CONSTRAINT pk_met_en_favori PRIMARY KEY (id_membre, id_annonce),
    CONSTRAINT fk_met_en_favori_membre FOREIGN KEY (id_membre)
        REFERENCES membre (id_membre)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_met_en_favori_annonce FOREIGN KEY (id_annonce)
        REFERENCES annonce (id_annonce)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE message (
    id_message        INT            AUTO_INCREMENT,
    contenu           VARCHAR(1000)  NOT NULL,
    date_heure_envoi  DATETIME       NOT NULL,
    prix_propose      DECIMAL(7,2)   NULL,
    reponse_offre     VARCHAR(10)    NULL,
    id_annonce        INT            NOT NULL,
    id_expediteur     INT            NOT NULL,
    id_destinataire   INT            NOT NULL,
    CONSTRAINT pk_message PRIMARY KEY (id_message),
    CONSTRAINT fk_message_annonce FOREIGN KEY (id_annonce)
        REFERENCES annonce (id_annonce)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_message_expediteur FOREIGN KEY (id_expediteur)
        REFERENCES membre (id_membre)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_message_destinataire FOREIGN KEY (id_destinataire)
        REFERENCES membre (id_membre)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE livraison (
    num_suivi        VARCHAR(30)  NOT NULL,
    mode_livraison   VARCHAR(15)  NOT NULL,
    date_envoi       DATE         NULL,
    date_livraison   DATE         NULL,
    num_commande     VARCHAR(12)  NOT NULL,
    id_transporteur  INT          NOT NULL,
    id_point_relais  INT          NULL,
    CONSTRAINT pk_livraison PRIMARY KEY (num_suivi),
    CONSTRAINT uq_livraison_commande UNIQUE (num_commande),
    CONSTRAINT fk_livraison_commande FOREIGN KEY (num_commande)
        REFERENCES commande (num_commande)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_livraison_transporteur FOREIGN KEY (id_transporteur)
        REFERENCES transporteur (id_transporteur)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_livraison_point_relais FOREIGN KEY (id_point_relais)
        REFERENCES point_relais (id_point_relais)
        ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE evaluation (
    id_evaluation    INT           AUTO_INCREMENT,
    note             TINYINT       NOT NULL,
    commentaire      VARCHAR(500)  NULL,
    date_evaluation  DATE          NOT NULL,
    id_auteur        INT           NOT NULL,
    id_evalue        INT           NOT NULL,
    num_commande     VARCHAR(12)   NOT NULL,
    CONSTRAINT pk_evaluation PRIMARY KEY (id_evaluation),
    CONSTRAINT fk_evaluation_auteur FOREIGN KEY (id_auteur)
        REFERENCES membre (id_membre)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_evaluation_evalue FOREIGN KEY (id_evalue)
        REFERENCES membre (id_membre)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_evaluation_commande FOREIGN KEY (num_commande)
        REFERENCES commande (num_commande)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE litige (
    id_litige       INT            AUTO_INCREMENT,
    motif           VARCHAR(30)    NOT NULL,
    description     VARCHAR(1000)  NOT NULL,
    date_ouverture  DATE           NOT NULL,
    decision        VARCHAR(30)    NULL,
    date_cloture    DATE           NULL,
    num_commande    VARCHAR(12)    NOT NULL,
    CONSTRAINT pk_litige PRIMARY KEY (id_litige),
    CONSTRAINT uq_litige_commande UNIQUE (num_commande),
    CONSTRAINT fk_litige_commande FOREIGN KEY (num_commande)
        REFERENCES commande (num_commande)
        ON DELETE CASCADE ON UPDATE CASCADE
);
