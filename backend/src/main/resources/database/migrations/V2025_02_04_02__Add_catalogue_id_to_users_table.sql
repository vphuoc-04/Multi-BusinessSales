ALTER TABLE users 
ADD COLUMN catalogue_id BIGINT UNSIGNED DEFAULT NULL;

ALTER TABLE users 
ADD CONSTRAINT fk_catalogue_id 
FOREIGN KEY (catalogue_id) 
REFERENCES user_catalogues(id) 
ON DELETE CASCADE;
