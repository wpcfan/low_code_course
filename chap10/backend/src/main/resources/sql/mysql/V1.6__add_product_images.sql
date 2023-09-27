SET foreign_key_checks = 0;
DROP TABLE IF EXISTS mooc_product_images;
CREATE TABLE mooc_product_images
(
    id         BIGINT AUTO_INCREMENT NOT NULL,
    url        VARCHAR(255)          NULL,
    product_id BIGINT                NULL,
    CONSTRAINT pk_mooc_product_images PRIMARY KEY (id)
);

ALTER TABLE mooc_product_images
    ADD CONSTRAINT FK_MOOC_PRODUCT_IMAGES_ON_PRODUCT FOREIGN KEY (product_id) REFERENCES mooc_products (id);
SET foreign_key_checks = 1;