ALTER TABLE `mooc_page_blocks` ADD COLUMN `title` VARCHAR(255) NULL DEFAULT NULL AFTER `id`;

UPDATE `mooc_page_blocks` SET `title` = '运营活动黄金轮播区块' WHERE `id` = 1;
UPDATE `mooc_page_blocks` SET `title` = 'XX 活动推广区块' WHERE `id` = 2;
UPDATE `mooc_page_blocks` SET `title` = 'YY 活动推广区块' WHERE `id` = 3;
UPDATE `mooc_page_blocks` SET `title` = 'ZZ 活动推广区块' WHERE `id` = 4;
UPDATE `mooc_page_blocks` SET `title` = '瀑布流区块' WHERE `id` = 5;

ALTER TABLE `mooc_page_blocks` CHANGE COLUMN `title` `title` VARCHAR(255) NOT NULL;