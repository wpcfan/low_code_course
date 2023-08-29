SET REFERENTIAL_INTEGRITY FALSE; // 禁用外键约束

DELETE
FROM "MOOC_PAGE_BLOCK_DATA"
WHERE "ID" < 12;
DELETE
FROM "MOOC_PAGE_BLOCKS"
WHERE "ID" IN (1, 2, 3, 4, 5);
INSERT INTO "MOOC_PAGE_BLOCKS" ("ID",
                              "TYPE",
                              "SORT",
                              "CONFIG",
                              "PAGE_LAYOUT_ID")
VALUES (1,
        'Banner',
        1,
        JSON '{
          "blockHeight": 120.0,
          "horizontalPadding": 8.0,
          "verticalPadding": 8.0,
          "horizontalSpacing": 8.0
        }',
        1);
INSERT INTO "MOOC_PAGE_BLOCKS" ("ID",
                              "TYPE",
                              "SORT",
                              "CONFIG",
                              "PAGE_LAYOUT_ID")
VALUES (2,
        'ImageRow',
        2,
        JSON '{
          "blockHeight": 200.0,
          "horizontalPadding": 16.0,
          "verticalPadding": 8.0,
          "horizontalSpacing": 8.0
        }',
        1);
INSERT INTO "MOOC_PAGE_BLOCKS" (ID,
                              TYPE,
                              SORT,
                              CONFIG,
                              PAGE_LAYOUT_ID)
VALUES (3,
        'ProductRow',
        3,
        JSON '{
          "blockHeight": 120.0,
          "horizontalPadding": 8.0,
          "verticalPadding": 8.0,
          "horizontalSpacing": 8.0,
          "verticalSpacing": 4.0
        }',
        1);
INSERT INTO "MOOC_PAGE_BLOCKS" (ID,
                              TYPE,
                              SORT,
                              CONFIG,
                              PAGE_LAYOUT_ID)
VALUES (4,
        'ProductRow',
        4,
        JSON '{
          "blockHeight": 300.0,
          "horizontalPadding": 16.0,
          "verticalPadding": 8.0,
          "horizontalSpacing": 8.0,
          "verticalSpacing": 4.0
        }',
        1);
INSERT INTO "MOOC_PAGE_BLOCKS" (ID,
                              TYPE,
                              SORT,
                              CONFIG,
                              PAGE_LAYOUT_ID)
VALUES (5,
        'Waterfall',
        5,
        JSON '{
          "horizontalPadding": 16.0,
          "verticalPadding": 8.0,
          "horizontalSpacing": 8.0,
          "verticalSpacing": 4.0
        }',
        1);

INSERT INTO "MOOC_PAGE_BLOCK_DATA" (ID,
                                  SORT,
                                  CONTENT,
                                  PAGE_BLOCK_ID)
VALUES (1,
        1,
        JSON '{
          "title": "Banner Image 1",
          "image": "https://picsum.photos/seed/1/200/300",
          "link": {
            "type": "url",
            "value": "https://www.baidu.com"
          }
        }',
        1);

INSERT INTO "MOOC_PAGE_BLOCK_DATA" (ID,
                                  SORT,
                                  CONTENT,
                                  PAGE_BLOCK_ID)
VALUES (2,
        2,
        JSON '{
          "title": "Banner Image 2",
          "image": "https://picsum.photos/seed/2/200/300",
          "link": {
            "type": "url",
            "value": "https://www.bing.com"
          }
        }',
        1);

INSERT INTO "MOOC_PAGE_BLOCK_DATA" (ID,
                                  SORT,
                                  CONTENT,
                                  PAGE_BLOCK_ID)
VALUES (3,
        3,
        JSON '{
          "title": "Banner Image 3",
          "image": "https://picsum.photos/seed/3/200/300",
          "link": {
            "type": "url",
            "value": "https://www.google.com"
          }
        }',
        1);

INSERT INTO "MOOC_PAGE_BLOCK_DATA" (ID,
                                  SORT,
                                  CONTENT,
                                  PAGE_BLOCK_ID)
VALUES (4,
        4,
        JSON '{
          "title": "Banner Image 4",
          "image": "https://picsum.photos/seed/4/200/300",
          "link": {
            "type": "url",
            "value": "https://www.163.com"
          }
        }',
        1);

INSERT INTO "MOOC_PAGE_BLOCK_DATA" (ID,
                                  SORT,
                                  CONTENT,
                                  PAGE_BLOCK_ID)
VALUES (5,
        1,
        JSON '{
          "title": "Image Row Image 1",
          "image": "https://picsum.photos/seed/1/200/300",
          "link": {
            "type": "url",
            "value": "https://www.google.com"
          }
        }',
        2);

INSERT INTO "MOOC_PAGE_BLOCK_DATA" (ID,
                                  SORT,
                                  CONTENT,
                                  PAGE_BLOCK_ID)
VALUES (6,
        2,
        JSON '{
          "title": "Image Row Image 2",
          "image": "https://picsum.photos/seed/2/200/300",
          "link": {
            "type": "url",
            "value": "https://www.bing.com"
          }
        }',
        2);

INSERT INTO "MOOC_PAGE_BLOCK_DATA" (ID,
                                  SORT,
                                  CONTENT,
                                  PAGE_BLOCK_ID)
VALUES (7,
        3,
        JSON '{
          "title": "Image Row Image 3",
          "image": "https://picsum.photos/seed/3/200/300",
          "link": {
            "type": "url",
            "value": "https://www.baidu.com"
          }
        }',
        2);

INSERT INTO "MOOC_PAGE_BLOCK_DATA" (ID,
                                  SORT,
                                  CONTENT,
                                  PAGE_BLOCK_ID)
VALUES (8,
        1,
        JSON '{
          "id": 1,
          "name": "Product 1 very very very very very very very very very very long",
          "description": "Product 1 description very very very very very very very very very very long",
          "price": "¥100.00",
          "images": [
            "https://picsum.photos/seed/1/200/300"
          ]
        }',
        3);

INSERT INTO "MOOC_PAGE_BLOCK_DATA" (ID,
                                  SORT,
                                  CONTENT,
                                  PAGE_BLOCK_ID)
VALUES (9,
        1,
        JSON '{
          "id": 1,
          "name": "Product 1 very very very very very very very very very very long",
          "description": "Product 1 description very very very very very very very very very very long",
          "price": "¥100.00",
          "images": [
            "https://picsum.photos/seed/1/200/300"
          ]
        }',
        4);

INSERT INTO "MOOC_PAGE_BLOCK_DATA" (ID,
                                  SORT,
                                  CONTENT,
                                  PAGE_BLOCK_ID)
VALUES (10,
        2,
        JSON '{
          "id": 2,
          "name": "Product 2",
          "description": "Product 2 description",
          "price": "¥100.00",
          "images": [
            "https://picsum.photos/seed/2/200/300"
          ]
        }',
        4);

INSERT INTO MOOC_PAGE_BLOCK_DATA (ID,
                                  SORT,
                                  CONTENT,
                                  PAGE_BLOCK_ID)
VALUES (11,
        1,
        JSON '{
          "id": 1,
          "name": "Category 1",
          "code": "cat_1"
        }',
        5);

ALTER TABLE "MOOC_PAGE_BLOCKS" ALTER COLUMN "ID" RESTART WITH 6;
ALTER TABLE "MOOC_PAGE_BLOCK_DATA" ALTER COLUMN "ID" RESTART WITH 12;

SET REFERENTIAL_INTEGRITY TRUE; // 启用外键约束 