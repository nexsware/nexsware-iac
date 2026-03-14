CREATE TABLE IF EXISTS people.addresses (
    id               BIGINT GENERATED ALWAYS AS IDENTITY,
    countryname      VARCHAR(500) NOT NULL,
    stateName        VARCHAR(500) NOT NULL,
    cityname         VARCHAR(500) NOT NULL,
    zipcode          VARCHAR(20) NOT NULL,
    countyname       VARCHAR(500) NOT NULL,
    streetaddress    VARCHAR(500) NOT NULL,
    createdby        VARCHAR(10),
    createdat        TIMESTAMPTZ NOT NULL DEFAULT now(),
    updatedat        TIMESTAMPTZ NOT NULL DEFAULT now(),
    updatedby        VARCHAR(10),

    CONSTRAINT addresses_pkey PRIMARY KEY (id)

);

CREATE INDEX IF NOT EXISTS idx_addresses_countryname
    ON people.addresses (countryname);

CREATE INDEX IF NOT EXISTS idx_addresses_createdby
    ON people.addresses (createdby);

CREATE INDEX IF NOT EXISTS idx_addresses_createdat
    ON people.addresses (createdat);

CREATE INDEX IF NOT EXISTS idx_addresses_updatedby
    ON people.addresses (updatedby);


CREATE TABLE IF NOT EXISTS people.contacts (
    id               BIGINT GENERATED ALWAYS AS IDENTITY,
    emailaddress            VARCHAR(500) NOT NULL,
    phonenumber      VARCHAR(20) NOT NULL,
    createdby        VARCHAR(10),
    createdat        TIMESTAMPTZ NOT NULL DEFAULT now(),
    updatedat        TIMESTAMPTZ NOT NULL DEFAULT now(),
    updatedby        VARCHAR(10),

    CONSTRAINT contacts_pkey PRIMARY KEY (id)
);

CREATE INDEX IF NOT EXISTS idx_contacts_createdby
    ON people.contacts (createdby);

CREATE INDEX IF NOT EXISTS idx_contacts_createdat
    ON people.contacts (createdat);

CREATE INDEX IF NOT EXISTS idx_contacts_updatedby
    ON people.contacts (updatedby);

CREATE INDEX IF NOT EXISTS idx_contacts_updatedat
    ON people.contacts (updatedat);


CREATE TABLE IF NOT EXISTS people.companies (
    id               BIGINT GENERATED ALWAYS AS IDENTITY,
    addressid        BIGINT NOT NULL,
    contactsid        BIGINT NOT NULL,
    companyname      VARCHAR(500) NOT NULL,
    createdby        VARCHAR(10),
    createdat        TIMESTAMPTZ NOT NULL DEFAULT now(),
    updatedat        TIMESTAMPTZ NOT NULL DEFAULT now(),
    updatedby        VARCHAR(10),
    companydescription VARCHAR(1000),

    CONSTRAINT companies_pkey PRIMARY KEY (id),
    CONSTRAINT companies_addressid_fkey FOREIGN KEY (addressid)
        REFERENCES people.addresses (id),
    CONSTRAINT companies_contactsid_fkey FOREIGN KEY (contactsid)
        REFERENCES people.contacts (id)
);

CREATE INDEX IF NOT EXISTS idx_companies_createdby
    ON people.companies (createdby);

CREATE INDEX IF NOT EXISTS idx_companies_createdat
    ON people.companies (createdat);

CREATE INDEX IF NOT EXISTS idx_companies_updatedby
    ON people.companies (updatedby);

CREATE INDEX IF NOT EXISTS idx_companies_updatedat
    ON people.companies (updatedat);


CREATE TABLE IF NOT EXISTS people.employees (
    id          BIGINT      NOT NULL,
    contactsid  BIGINT      NOT NULL,
    addressid   BIGINT      NOT NULL,

    CONSTRAINT pk_employees         PRIMARY KEY (id),
    CONSTRAINT fk_employees_users   FOREIGN KEY (id)
        REFERENCES auth.users (id)
        ON DELETE CASCADE,
    CONSTRAINT fk_employees_contacts FOREIGN KEY (contactsid)
        REFERENCES people.contacts (id)
        ON DELETE CASCADE,
    CONSTRAINT fk_employees_address  FOREIGN KEY (addressid)
        REFERENCES people.addresses (id)
        ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS people.clients (
    id                  BIGINT      NOT NULL,
    clientcontactsid    BIGINT      NOT NULL,
    companyid           BIGINT      NOT NULL,

    CONSTRAINT pk_clients               PRIMARY KEY (id),
    CONSTRAINT fk_clients_users         FOREIGN KEY (id)
        REFERENCES auth.users (id)
        ON DELETE CASCADE,
    CONSTRAINT fk_clients_contacts      FOREIGN KEY (clientcontactsid)
        REFERENCES people.contacts (id)
        ON DELETE CASCADE,
    CONSTRAINT fk_clients_companies     FOREIGN KEY (companyid)
        REFERENCES people.companies (id)
        ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS projects.projects
(
    id                  BIGINT                      NOT NULL    GENERATED ALWAYS AS IDENTITY,
    universalid         UUID                        NOT NULL    DEFAULT gen_random_uuid(),
    createdat           TIMESTAMPTZ                 NOT NULL    DEFAULT NOW(),
    updatedat           TIMESTAMPTZ                 NOT NULL    DEFAULT NOW(),
    createdby           VARCHAR(255)                NULL,
    updatedby           VARCHAR(255)                NULL,
    name                VARCHAR(255)                NOT NULL,
    description         TEXT                        NOT NULL,
    status              VARCHAR(50)                 NOT NULL    DEFAULT 'New',
    projectmanagerid    BIGINT                      NOT NULL,
    clientid            BIGINT                      NOT NULL,

    CONSTRAINT pk_projects                  PRIMARY KEY (id),
    CONSTRAINT uq_projects_universalid      UNIQUE (universalid),
    CONSTRAINT fk_projects_manager          FOREIGN KEY (projectmanagerid)
        REFERENCES people.employees (id)
        ON DELETE RESTRICT,
    CONSTRAINT fk_projects_client           FOREIGN KEY (clientid)
        REFERENCES people.clients (id)
        ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_projects_createdby
    ON projects.projects (createdby);

CREATE INDEX IF NOT EXISTS idx_projects_updatedby
    ON projects.projects (updatedby);

CREATE INDEX IF NOT EXISTS idx_projects_createdat
    ON projects.projects (createdat);

CREATE INDEX IF NOT EXISTS idx_projects_updatedat
    ON projects.projects (updatedat);

CREATE INDEX IF NOT EXISTS idx_projects_status
    ON projects.projects (status);

CREATE INDEX IF NOT EXISTS idx_projects_universalid
    ON projects.projects (universalid); 


CREATE TABLE IF NOT EXISTS projects.milestones
(
    id              BIGINT          NOT NULL    GENERATED ALWAYS AS IDENTITY,
    universalid     UUID            NOT NULL    DEFAULT gen_random_uuid(),
    createdat       TIMESTAMPTZ     NOT NULL    DEFAULT NOW(),
    updatedat       TIMESTAMPTZ     NOT NULL    DEFAULT NOW(),
    createdby       VARCHAR(255)    NULL,
    updatedby       VARCHAR(255)    NULL,
    name            VARCHAR(255)    NOT NULL,
    description     TEXT            NOT NULL,
    projectid       BIGINT          NOT NULL,

    CONSTRAINT pk_milestones                PRIMARY KEY (id),
    CONSTRAINT uq_milestones_universalid    UNIQUE (universalid),
    CONSTRAINT fk_milestones_project        FOREIGN KEY (projectid)
        REFERENCES projects.projects (id)
        ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_milestones_createdby
    ON projects.milestones (createdby);

CREATE INDEX IF NOT EXISTS idx_milestones_updatedby
    ON projects.milestones (updatedby);

CREATE INDEX IF NOT EXISTS idx_milestones_createdat
    ON projects.milestones (createdat);

CREATE INDEX IF NOT EXISTS idx_milestones_updatedat
    ON projects.milestones (updatedat);

CREATE INDEX IF NOT EXISTS idx_milestones_universalid
    ON projects.milestones (universalid);


CREATE TABLE IF NOT EXISTS projects.features
(
    id              BIGINT          NOT NULL    GENERATED ALWAYS AS IDENTITY,
    universalid     UUID            NOT NULL    DEFAULT gen_random_uuid(),
    createdat       TIMESTAMPTZ     NOT NULL    DEFAULT NOW(),
    updatedat       TIMESTAMPTZ     NOT NULL    DEFAULT NOW(),
    createdby       VARCHAR(255)    NULL,
    updatedby       VARCHAR(255)    NULL,
    name            VARCHAR(255)    NOT NULL,
    description     TEXT            NOT NULL,
    status          VARCHAR(50)     NOT NULL    DEFAULT 'New',
    cost            VARCHAR(50)     NOT NULL,
    milestoneid     BIGINT          NOT NULL,

    CONSTRAINT pk_features                  PRIMARY KEY (id),
    CONSTRAINT uq_features_universalid      UNIQUE (universalid),
    CONSTRAINT fk_features_milestone        FOREIGN KEY (milestoneid)
        REFERENCES projects.milestones (id)
        ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_features_createdby
    ON projects.features (createdby);

CREATE INDEX IF NOT EXISTS idx_features_updatedby
    ON projects.features (updatedby);

CREATE INDEX IF NOT EXISTS idx_features_createdat
    ON projects.features (createdat);

CREATE INDEX IF NOT EXISTS idx_features_updatedat
    ON projects.features (updatedat);

CREATE INDEX IF NOT EXISTS idx_features_universalid
    ON projects.features (universalid);


CREATE TABLE IF NOT EXISTS projects.documents
(
    id              BIGINT          NOT NULL    GENERATED ALWAYS AS IDENTITY,
    universalid     UUID            NOT NULL    DEFAULT gen_random_uuid(),
    createdat       TIMESTAMPTZ     NOT NULL    DEFAULT NOW(),
    updatedat       TIMESTAMPTZ     NOT NULL    DEFAULT NOW(),
    createdby       VARCHAR(255)    NULL,
    updatedby       VARCHAR(255)    NULL,
    name            VARCHAR(255)    NOT NULL,
    description     TEXT            NOT NULL,
    storageurl      TEXT            NOT NULL,
    projectid       BIGINT          NOT NULL,

    CONSTRAINT pk_documents                 PRIMARY KEY (id),
    CONSTRAINT uq_documents_universalid     UNIQUE (universalid),
    CONSTRAINT fk_documents_project         FOREIGN KEY (projectid)
        REFERENCES projects.projects (id)
        ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_documents_createdby
    ON projects.documents (createdby);

CREATE INDEX IF NOT EXISTS idx_documents_updatedby
    ON projects.documents (updatedby);

CREATE INDEX IF NOT EXISTS idx_documents_createdat
    ON projects.documents (createdat);

CREATE INDEX IF NOT EXISTS idx_documents_updatedat
    ON projects.documents (updatedat);

CREATE INDEX IF NOT EXISTS idx_documents_universalid
    ON projects.documents (universalid);
