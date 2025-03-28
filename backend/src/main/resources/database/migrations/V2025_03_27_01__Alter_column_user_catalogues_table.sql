ALTER TABLE user_catalogues
DROP FOREIGN KEY fk_user_catalogues_created_by,
DROP FOREIGN KEY fk_user_catalogues_updated_by;

ALTER TABLE user_catalogues
CHANGE COLUMN created_by added_by BIGINT UNSIGNED DEFAULT NULL,
CHANGE COLUMN updated_by edited_by BIGINT UNSIGNED DEFAULT NULL;

ALTER TABLE user_catalogues
ADD CONSTRAINT fk_user_catalogues_added_by
FOREIGN KEY (added_by)
REFERENCES users(id)
ON DELETE CASCADE,
ADD CONSTRAINT fk_user_catalogues_edited_by
FOREIGN KEY (edited_by)
REFERENCES users(id)
ON DELETE SET NULL;