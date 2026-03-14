ALTER TABLE IF EXISTS enquiries.contactmessages
    ADD COLUMN createdby VARCHAR(10),
    ADD COLUMN updatedby VARCHAR(10),
    ADD COLUMN updatedat TIMESTAMPTZ NOT NULL DEFAULT now();

ALTER TABLE IF EXISTS enquiries.contactmessageresponses
    ADD COLUMN createdby VARCHAR(10),
    ADD COLUMN updatedby VARCHAR(10),
    ADD COLUMN updatedat TIMESTAMPTZ NOT NULL DEFAULT now();