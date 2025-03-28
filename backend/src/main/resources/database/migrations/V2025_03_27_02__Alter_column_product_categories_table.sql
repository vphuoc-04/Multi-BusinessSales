ALTER TABLE product_categories
DROP FOREIGN KEY product_categories_ibfk_1,
DROP FOREIGN KEY fk_updated_by;

ALTER TABLE product_categories
CHANGE COLUMN created_by added_by BIGINT UNSIGNED,
CHANGE COLUMN updated_by edited_by BIGINT UNSIGNED DEFAULT NULL;

ALTER TABLE product_categories
ADD CONSTRAINT fk_product_categories_added_by
FOREIGN KEY (added_by)
REFERENCES users(id)
ON DELETE CASCADE,
ADD CONSTRAINT fk_product_categories_edited_by
FOREIGN KEY (edited_by)
REFERENCES users(id)
ON DELETE SET NULL;