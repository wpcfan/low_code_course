INSERT INTO "MOOC_PAGE_LAYOUTS" ("ID",
                                 "CREATED_AT",
                                 "UPDATED_AT",
                                 "TITLE",
                                 "CONFIG",
                                 "START_TIME",
                                 "END_TIME",
                                 "PAGE_TYPE",
                                 "PLATFORM",
                                 "STATUS")
VALUES (1,
        TIMESTAMP '2023-08-28 15:01:17.712484',
        TIMESTAMP '2023-08-28 15:01:22.745',
        U&'\9996\9875618\6d3b\52a8',
        JSON '{"baselineScreenWidth":375.0}',
        TIMESTAMP '2023-08-28 15:01:22.745',
        TIMESTAMP '2030-08-28 23:01:26.421522',
        'Home',
        'APP',
        'PUBLISHED'
       );
ALTER TABLE "MOOC_PAGE_LAYOUTS" ALTER COLUMN "ID" RESTART WITH 2;