set foreign_key_checks = 0;

delete
from mooc_page_block_data
where id < 12;
delete
from mooc_page_blocks
where id in (1, 2, 3, 4, 5);
insert into mooc_page_blocks (id,
                              type,
                              sort,
                              config,
                              page_layout_id)
values (1,
        'Banner',
        1,
        '{
          "blockHeight": 120.0,
          "horizontalPadding": 8.0,
          "verticalPadding": 8.0,
          "horizontalSpacing": 8.0
        }',
        1);
insert into mooc_page_blocks (id,
                              type,
                              sort,
                              config,
                              page_layout_id)
values (2,
        'ImageRow',
        2,
        '{
          "blockHeight": 200.0,
          "horizontalPadding": 16.0,
          "verticalPadding": 8.0,
          "horizontalSpacing": 8.0
        }',
        1);
insert into mooc_page_blocks (id,
                              type,
                              sort,
                              config,
                              page_layout_id)
values (3,
        'ProductRow',
        3,
        '{
          "blockHeight": 120.0,
          "horizontalPadding": 8.0,
          "verticalPadding": 8.0,
          "horizontalSpacing": 8.0,
          "verticalSpacing": 4.0
        }',
        1);
insert into mooc_page_blocks (id,
                              type,
                              sort,
                              config,
                              page_layout_id)
values (4,
        'ProductRow',
        4,
        '{
          "blockHeight": 300.0,
          "horizontalPadding": 16.0,
          "verticalPadding": 8.0,
          "horizontalSpacing": 8.0,
          "verticalSpacing": 4.0
        }',
        1);
insert into mooc_page_blocks (id,
                              type,
                              sort,
                              config,
                              page_layout_id)
values (5,
        'Waterfall',
        5,
        '{
          "horizontalPadding": 16.0,
          "verticalPadding": 8.0,
          "horizontalSpacing": 8.0,
          "verticalSpacing": 4.0
        }',
        1);

insert into mooc_page_block_data (id,
                                  sort,
                                  content,
                                  page_block_id)
values (1,
        1,
        '{
          "title": "Banner Image 1",
          "image": "https://picsum.photos/seed/1/200/300",
          "link": {
            "type": "url",
            "value": "https://www.baidu.com"
          }
        }',
        1);

insert into mooc_page_block_data (id,
                                  sort,
                                  content,
                                  page_block_id)
values (2,
        2,
        '{
          "title": "Banner Image 2",
          "image": "https://picsum.photos/seed/2/200/300",
          "link": {
            "type": "url",
            "value": "https://www.bing.com"
          }
        }',
        1);

insert into mooc_page_block_data (id,
                                  sort,
                                  content,
                                  page_block_id)
values (3,
        3,
        '{
          "title": "Banner Image 3",
          "image": "https://picsum.photos/seed/3/200/300",
          "link": {
            "type": "url",
            "value": "https://www.google.com"
          }
        }',
        1);

insert into mooc_page_block_data (id,
                                  sort,
                                  content,
                                  page_block_id)
values (4,
        4,
        '{
          "title": "Banner Image 4",
          "image": "https://picsum.photos/seed/4/200/300",
          "link": {
            "type": "url",
            "value": "https://www.163.com"
          }
        }',
        1);

insert into mooc_page_block_data (id,
                                  sort,
                                  content,
                                  page_block_id)
values (5,
        1,
        '{
          "title": "Image Row Image 1",
          "image": "https://picsum.photos/seed/1/200/300",
          "link": {
            "type": "url",
            "value": "https://www.google.com"
          }
        }',
        2);

insert into mooc_page_block_data (id,
                                  sort,
                                  content,
                                  page_block_id)
values (6,
        2,
        '{
          "title": "Image Row Image 2",
          "image": "https://picsum.photos/seed/2/200/300",
          "link": {
            "type": "url",
            "value": "https://www.bing.com"
          }
        }',
        2);

insert into mooc_page_block_data (id,
                                  sort,
                                  content,
                                  page_block_id)
values (7,
        3,
        '{
          "title": "Image Row Image 3",
          "image": "https://picsum.photos/seed/3/200/300",
          "link": {
            "type": "url",
            "value": "https://www.baidu.com"
          }
        }',
        2);

insert into mooc_page_block_data (id,
                                  sort,
                                  content,
                                  page_block_id)
values (8,
        1,
        '{
          "id": 1,
          "name": "Product 1 very very very very very very very very very very long",
          "description": "Product 1 description very very very very very very very very very very long",
          "price": "¥100.00",
          "images": [
            "https://picsum.photos/seed/1/200/300"
          ]
        }',
        3);

insert into mooc_page_block_data (id,
                                  sort,
                                  content,
                                  page_block_id)
values (9,
        1,
        '{
          "id": 1,
          "name": "Product 1 very very very very very very very very very very long",
          "description": "Product 1 description very very very very very very very very very very long",
          "price": "¥100.00",
          "images": [
            "https://picsum.photos/seed/1/200/300"
          ]
        }',
        4);

insert into mooc_page_block_data (id,
                                  sort,
                                  content,
                                  page_block_id)
values (10,
        2,
        '{
          "id": 2,
          "name": "Product 2",
          "description": "Product 2 description",
          "price": "¥100.00",
          "images": [
            "https://picsum.photos/seed/2/200/300"
          ]
        }',
        4);

insert into mooc_page_block_data (id,
                                  sort,
                                  content,
                                  page_block_id)
values (11,
        1,
        '{
          "id": 1,
          "name": "Category 1",
          "code": "cat_1"
        }',
        5);

ALTER TABLE `mooc_page_blocks` AUTO_INCREMENT = 6;
ALTER TABLE `mooc_page_block_data` AUTO_INCREMENT = 12;

set foreign_key_checks = 1;