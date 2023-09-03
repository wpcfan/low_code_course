ALTER TABLE mooc_products
    ALTER COLUMN price DECIMAL(10,2) NOT NULL;
ALTER TABLE mooc_products
    ALTER COLUMN original_price DECIMAL(10,2) NULL;
ALTER TABLE mooc_products
    ALTER COLUMN name VARCHAR(255) NOT NULL;
ALTER TABLE mooc_products
    ALTER COLUMN sku VARCHAR(50) NOT NULL;
ALTER TABLE mooc_products
    ADD CONSTRAINT uk_mooc_products_sku UNIQUE (sku);