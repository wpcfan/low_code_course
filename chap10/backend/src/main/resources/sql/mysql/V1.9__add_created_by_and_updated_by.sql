ALTER TABLE `mooc_page_layouts` ADD COLUMN `created_by` VARCHAR(255) NULL DEFAULT NULL AFTER `created_at`;
ALTER TABLE `mooc_page_layouts` ADD COLUMN `updated_by` VARCHAR(255) NULL DEFAULT NULL AFTER `updated_at`;
