ALTER TABLE mooc_categories
    ADD COLUMN name VARCHAR(100) NOT NULL DEFAULT 'DEFAULT' AFTER id;
ALTER TABLE mooc_categories
    ADD COLUMN code VARCHAR(50) NOT NULL DEFAULT 'DEFAULT_CODE' AFTER name;
ALTER TABLE mooc_categories
    ADD COLUMN parent_id BIGINT NULL AFTER code;
ALTER TABLE mooc_categories
    ADD CONSTRAINT uk_mooc_categories_code UNIQUE (code);
ALTER TABLE mooc_categories
    ADD CONSTRAINT fk_mooc_categories_parent_id FOREIGN KEY (parent_id) REFERENCES mooc_categories (id);

