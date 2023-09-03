ALTER TABLE mooc_products
    MODIFY price DECIMAL(10,2) NOT NULL;
ALTER TABLE mooc_products
    MODIFY original_price DECIMAL(10,2) NULL;
ALTER TABLE mooc_products
    MODIFY name VARCHAR(255) NOT NULL;
ALTER TABLE mooc_products
    MODIFY sku VARCHAR(50) NOT NULL;
ALTER TABLE mooc_products
    ADD CONSTRAINT uk_mooc_products_sku UNIQUE (sku);