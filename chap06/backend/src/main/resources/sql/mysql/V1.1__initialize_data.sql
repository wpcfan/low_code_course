SET foreign_key_checks = 0;
DELETE FROM `mooc_page_layouts` WHERE `id` = 1;
INSERT INTO `mooc_page_layouts` (`id`,
                                 `created_at`,
                                 `updated_at`,
                                 `title`,
                                 `config`,
                                 `start_time`,
                                 `end_time`,
                                 `status`,
                                 `page_type`,
                                 `platform`)
VALUES (1,
        '2023-08-28 15:34:48',
        '2023-08-28 15:35:36',
        '首页618活动',
        '{\"baselineScreenWidth\": 375.0}',
        '2023-08-28 07:01:23',
        '2030-08-28 07:01:23',
        'PUBLISHED',
        'Home',
        'APP');
ALTER TABLE `mooc_page_layouts` AUTO_INCREMENT = 2;
SET foreign_key_checks = 1;