SET foreign_key_checks = 0;
DROP TABLE IF EXISTS mooc_products_categories;
DROP TABLE IF EXISTS mooc_products;
DROP TABLE IF EXISTS mooc_categories;
CREATE TABLE mooc_categories
(
    id BIGINT AUTO_INCREMENT NOT NULL,
    CONSTRAINT pk_mooc_categories PRIMARY KEY (id)
);

CREATE TABLE mooc_products
(
    id             BIGINT AUTO_INCREMENT NOT NULL,
    sku            VARCHAR(255)          NULL,
    name           VARCHAR(255)          NULL,
    `description`  VARCHAR(255)          NULL,
    price          DECIMAL               NULL,
    original_price DECIMAL               NULL,
    CONSTRAINT pk_mooc_products PRIMARY KEY (id)
);

CREATE TABLE mooc_products_categories
(
    categories_id BIGINT NOT NULL,
    product_id    BIGINT NOT NULL,
    CONSTRAINT pk_mooc_products_categories PRIMARY KEY (categories_id, product_id)
);

ALTER TABLE mooc_products_categories
    ADD CONSTRAINT fk_mooc_products_categories_on_category FOREIGN KEY (categories_id) REFERENCES mooc_categories (id);

ALTER TABLE mooc_products_categories
    ADD CONSTRAINT fk_mooc_products_categories_on_product FOREIGN KEY (product_id) REFERENCES mooc_products (id);
SET foreign_key_checks = 1;