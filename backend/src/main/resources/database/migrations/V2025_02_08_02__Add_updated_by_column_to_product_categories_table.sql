ALTER TABLE product_categories
ADD COLUMN updated_by BIGINT UNSIGNED DEFAULT NULL;

ALTER TABLE product_categories
ADD CONSTRAINT fk_updated_by
FOREIGN KEY (updated_by)
REFERENCES users(id)
ON DELETE CASCADE;