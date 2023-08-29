CREATE TABLE mooc_page_layouts
(
    id         BIGINT AUTO_INCREMENT NOT NULL,
    created_at datetime              NULL,
    updated_at datetime              NULL,
    title      VARCHAR(50)           NOT NULL,
    config     JSON                  NOT NULL,
    start_time datetime              NULL,
    end_time   datetime              NULL,
    status     VARCHAR(20)           NOT NULL,
    page_type  VARCHAR(20)           NOT NULL,
    platform   VARCHAR(20)           NOT NULL,
    CONSTRAINT pk_mooc_page_layouts PRIMARY KEY (id)
);

CREATE TABLE mooc_page_blocks
(
    id             BIGINT AUTO_INCREMENT NOT NULL,
    type           VARCHAR(255)          NOT NULL,
    sort           INT                   NOT NULL,
    config         JSON                  NOT NULL,
    page_layout_id BIGINT                NULL,
    CONSTRAINT pk_mooc_page_blocks PRIMARY KEY (id)
);

ALTER TABLE mooc_page_blocks
    ADD CONSTRAINT FK_MOOC_PAGE_BLOCKS_ON_PAGE_LAYOUT FOREIGN KEY (page_layout_id) REFERENCES mooc_page_layouts (id);

CREATE TABLE mooc_page_block_data
(
    id            BIGINT AUTO_INCREMENT NOT NULL,
    sort          INT                   NOT NULL,
    content       JSON                  NOT NULL,
    page_block_id BIGINT                NULL,
    CONSTRAINT pk_mooc_page_block_data PRIMARY KEY (id)
);

ALTER TABLE mooc_page_block_data
    ADD CONSTRAINT FK_MOOC_PAGE_BLOCK_DATA_ON_PAGE_BLOCK FOREIGN KEY (page_block_id) REFERENCES mooc_page_blocks (id);
