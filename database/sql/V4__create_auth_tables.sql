CREATE TABLE IF NOT EXISTS auth.roles (
    id               BIGINT GENERATED ALWAYS AS IDENTITY,
    name             VARCHAR(20) NOT NULL,
    createdby        VARCHAR(10),
    createdat        TIMESTAMPTZ NOT NULL DEFAULT now(),
    updatedat        TIMESTAMPTZ NOT NULL DEFAULT now(),
    updatedby        VARCHAR(10),
    isactive         BOOLEAN NOT NULL DEFAULT false,
    description      VARCHAR(500),
    normalizedname   VARCHAR(100),
    concurrencystamp VARCHAR(100),

    CONSTRAINT roles_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS auth.users
(
    id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    userid character varying(36) COLLATE pg_catalog."default" NOT NULL,
    firstname character varying(20) COLLATE pg_catalog."default" NOT NULL,
    middlename character varying(20) COLLATE pg_catalog."default",
    lastname character varying(20) COLLATE pg_catalog."default" NOT NULL,
    companyname character varying(100) COLLATE pg_catalog."default" NOT NULL,
    profileimageurl character varying(2000) COLLATE pg_catalog."default",
    createdat timestamp with time zone NOT NULL DEFAULT now(),
    updatedat timestamp with time zone NOT NULL DEFAULT now(),
    lastloginat timestamp with time zone NOT NULL DEFAULT now(),
    isactive boolean NOT NULL DEFAULT false,
    username character varying(100) COLLATE pg_catalog."default",
    accessfailedcount integer,
    lockoutend timestamp with time zone NOT NULL DEFAULT '0001-12-31 18:09:24-05:50:36 BC'::timestamp with time zone,
    lockoutenabled boolean NOT NULL DEFAULT false,
    twofactorenabled boolean NOT NULL DEFAULT false,
    securitystamp character varying(36) COLLATE pg_catalog."default",
    concurrencystamp character varying(36) COLLATE pg_catalog."default",
    email character varying(250) COLLATE pg_catalog."default",
    phonenumber character varying(20) COLLATE pg_catalog."default",
    phonenumberconfirmed boolean NOT NULL DEFAULT false,
    emailconfirmed boolean NOT NULL DEFAULT false,
    normalizedemail character varying(500) COLLATE pg_catalog."default",
    normalizedusername character varying(500) COLLATE pg_catalog."default",
    passwordhash character varying(500) COLLATE pg_catalog."default",
    usernumber character varying(6) COLLATE pg_catalog."default",
    usertitle character varying(20) COLLATE pg_catalog."default",
    CONSTRAINT users_pkey PRIMARY KEY (id),
    CONSTRAINT users_usernumber_key UNIQUE (usernumber)
);

CREATE TABLE IF NOT EXISTS auth.userroles (
    id       BIGINT GENERATED ALWAYS AS IDENTITY,
    userid   INTEGER NOT NULL,
    roleid   INTEGER NOT NULL,

    CONSTRAINT userroles_pkey PRIMARY KEY (id),
    CONSTRAINT userroles_userid_roleid_key UNIQUE (userid, roleid),

    CONSTRAINT userroles_roleid_fkey
        FOREIGN KEY (roleid) REFERENCES auth.roles(id) ON DELETE CASCADE,

    CONSTRAINT userroles_userid_fkey
        FOREIGN KEY (userid) REFERENCES auth.users(id) ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS auth.userclaims (
    id        INTEGER GENERATED ALWAYS AS IDENTITY,
    userid    BIGINT NOT NULL,
    claimtype VARCHAR(256),
    claimvalue VARCHAR(256),
    CONSTRAINT userclaims_pkey PRIMARY KEY (id),
    CONSTRAINT userclaims_userid_fkey
        FOREIGN KEY (userid) REFERENCES auth.users(id)
);