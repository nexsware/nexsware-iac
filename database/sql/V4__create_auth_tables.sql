CREATE TABLE IF NOT EXISTS auth.roles
(
    id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    name character varying(20) COLLATE pg_catalog."default" NOT NULL,
    createdby character varying(10) COLLATE pg_catalog."default",
    createdat timestamp with time zone NOT NULL DEFAULT now(),
    updatedat timestamp with time zone NOT NULL DEFAULT now(),
    updatedby character varying(10) COLLATE pg_catalog."default",
    isactive boolean NOT NULL DEFAULT false,
    description character varying(500) COLLATE pg_catalog."default",
    normalizedname character varying(100) COLLATE pg_catalog."default",
    concurrencystamp character varying(100) COLLATE pg_catalog."default",
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

CREATE TABLE IF NOT EXISTS auth.userroles
(
    id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    userid integer NOT NULL,
    roleid integer NOT NULL,
    CONSTRAINT userroles_pkey PRIMARY KEY (id),
    CONSTRAINT userroles_userid_roleid_key UNIQUE (userid, roleid),
    CONSTRAINT userroles_roleid_fkey FOREIGN KEY (roleid)
        REFERENCES auth.roles (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE,
    CONSTRAINT userroles_userid_fkey FOREIGN KEY (userid)
        REFERENCES auth.users (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS auth.userclaims
(
    id integer NOT NULL DEFAULT nextval('auth.userclaims_id_seq'::regclass),
    userid bigint NOT NULL,
    claimtype character varying(256) COLLATE pg_catalog."default",
    claimvalue character varying(256) COLLATE pg_catalog."default",
    CONSTRAINT userclaims_pkey PRIMARY KEY (id),
    CONSTRAINT userclaims_userid_fkey FOREIGN KEY (userid)
        REFERENCES auth.users (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);