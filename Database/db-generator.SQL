/*
Created: 9. 03. 2021
Modified: 9. 03. 2021
Model: PostgreSQL 10
Database: PostgreSQL 10
*/


-- Create functions section -------------------------------------------------

CREATE FUNCTION "Function1"()
 LANGUAGE sql
 VOLATILE
AS
$$
BEGIN
    /*function_body*/
END
$$
;

CREATE FUNCTION "Function2"()
 LANGUAGE sql
 VOLATILE
AS
$$
BEGIN
    /*function_body*/
END
$$
;

-- Create tables section -------------------------------------------------

-- Table regions

CREATE TABLE "regions"(
 "id" Serial NOT NULL,
 "name" Character varying(100) NOT NULL,
 "postcode" Character varying(20) NOT NULL
)
WITH (
 autovacuum_enabled=true)
;

-- Add keys for table regions

ALTER TABLE "regions" ADD CONSTRAINT "PK_regions" PRIMARY KEY ("id")
;

-- Table users

CREATE TABLE "users"(
 "id" Serial NOT NULL,
 "name" Character varying(100) NOT NULL,
 "surname" Character varying(100) NOT NULL,
 "email" Character varying(255) NOT NULL,
 "phone" Character varying(20),
 "password" Character varying(255) NOT NULL,
 "bdate" Timestamp NOT NULL,
 "created_at" Timestamp NOT NULL,
 "updated_at" Timestamp NOT NULL
)
WITH (
 autovacuum_enabled=true)
;

-- Add keys for table users

ALTER TABLE "users" ADD CONSTRAINT "PK_users" PRIMARY KEY ("id")
;

ALTER TABLE "users" ADD CONSTRAINT "email" UNIQUE ("email")
;

-- Table playfields

CREATE TABLE "playfields"(
 "id" Serial NOT NULL,
 "title" Character varying(255) NOT NULL,
 "description" Text NOT NULL,
 "phone" Character varying(20),
 "email" Character varying(255),
 "website" Character varying(255),
 "address" Character varying(255) NOT NULL,
 "region_id" Integer NOT NULL,
 "owner_id" Integer NOT NULL,
 "title_image_id" Integer NOT NULL,
 "type_id" Integer,
 "avg_score" Real,
 "price_per_hour" Real NOT NULL,
 "created_at" Timestamp NOT NULL,
 "updated_at" Timestamp NOT NULL,
 "pending_reservations" Bigint DEFAULT 0 NOT NULL
)
WITH (
 autovacuum_enabled=true)
;

-- Create indexes for table playfields

CREATE INDEX "IX_Relationship1" ON "playfields" ("region_id")
;

CREATE INDEX "IX_Relationship4" ON "playfields" ("owner_id")
;

CREATE INDEX "IX_Relationship7" ON "playfields" ("type_id")
;

CREATE INDEX "IX_Relationship5" ON "playfields" ("title_image_id")
;

-- Add keys for table playfields

ALTER TABLE "playfields" ADD CONSTRAINT "PK_playfields" PRIMARY KEY ("id")
;

-- Table images

CREATE TABLE "images"(
 "id" Serial NOT NULL,
 "url" Bigint NOT NULL,
 "caption" Text,
 "playfield_id" Integer NOT NULL
)
WITH (
 autovacuum_enabled=true)
;

-- Create indexes for table images

CREATE INDEX "IX_Relationship6" ON "images" ("playfield_id")
;

-- Add keys for table images

ALTER TABLE "images" ADD CONSTRAINT "PK_images" PRIMARY KEY ("id")
;

ALTER TABLE "images" ADD CONSTRAINT "url" UNIQUE ("url")
;

-- Table playfield_types

CREATE TABLE "playfield_types"(
 "id" Serial NOT NULL,
 "name" Character varying(255) NOT NULL,
 "description" Text NOT NULL
)
WITH (
 autovacuum_enabled=true)
;

-- Add keys for table playfield_types

ALTER TABLE "playfield_types" ADD CONSTRAINT "PK_playfield_types" PRIMARY KEY ("id")
;

ALTER TABLE "playfield_types" ADD CONSTRAINT "name" UNIQUE ("name")
;

-- Table reservations

CREATE TABLE "reservations"(
 "id" Serial NOT NULL,
 "order_date" Timestamp NOT NULL,
 "from_date" Timestamp NOT NULL,
 "to_date" Timestamp NOT NULL,
 "status_id" Integer NOT NULL,
 "user_id" Integer NOT NULL,
 "playfield_id" Integer NOT NULL,
 "paid" Boolean DEFAULT false NOT NULL
)
WITH (
 autovacuum_enabled=true)
;

-- Create indexes for table reservations

CREATE INDEX "IX_Relationship8" ON "reservations" ("status_id")
;

CREATE INDEX "IX_Relationship9" ON "reservations" ("user_id")
;

CREATE INDEX "IX_Relationship10" ON "reservations" ("playfield_id")
;

-- Add keys for table reservations

ALTER TABLE "reservations" ADD CONSTRAINT "PK_reservations" PRIMARY KEY ("id")
;

-- Table reservation_statuses

CREATE TABLE "reservation_statuses"(
 "id" Serial NOT NULL,
 "title" Character varying(20) NOT NULL,
 "description" Text
)
WITH (
 autovacuum_enabled=true)
;

-- Add keys for table reservation_statuses

ALTER TABLE "reservation_statuses" ADD CONSTRAINT "PK_reservation_statuses" PRIMARY KEY ("id")
;

-- Table reviews

CREATE TABLE "reviews"(
 "id" Serial NOT NULL,
 "message" Text NOT NULL,
 "score" Integer DEFAULT 3 NOT NULL
        CHECK (VALUE BETWEEN 1 AND 5),
 "playfield_id" Integer NOT NULL,
 "user_id" Integer NOT NULL,
 "created_at" Timestamp NOT NULL,
 "updated_at" Bigint NOT NULL
)
WITH (
 autovacuum_enabled=true)
;

-- Create indexes for table reviews

CREATE INDEX "IX_Relationship11" ON "reviews" ("playfield_id")
;

CREATE INDEX "IX_Relationship12" ON "reviews" ("user_id")
;

-- Add keys for table reviews

ALTER TABLE "reviews" ADD CONSTRAINT "PK_reviews" PRIMARY KEY ("id")
;

-- Table archive_reservations

CREATE TABLE "archive_reservations"(
 "id" Serial NOT NULL,
 "order_date" Timestamp NOT NULL,
 "from_date" Timestamp NOT NULL,
 "to_date" Timestamp NOT NULL,
 "paid" Boolean DEFAULT false NOT NULL,
 "playfield_id" Integer NOT NULL,
 "user_id" Integer,
 "original_id" Integer,
 "created_at" Timestamp NOT NULL
)
WITH (
 autovacuum_enabled=true)
;

-- Create indexes for table archive_reservations

CREATE INDEX "IX_Relationship14" ON "archive_reservations" ("playfield_id")
;

CREATE INDEX "IX_Relationship15" ON "archive_reservations" ("user_id")
;

CREATE INDEX "IX_Relationship16" ON "archive_reservations" ("original_id")
;

-- Add keys for table archive_reservations

ALTER TABLE "archive_reservations" ADD CONSTRAINT "PK_archive_reservations" PRIMARY KEY ("id")
;
-- Create foreign keys (relationships) section ------------------------------------------------- 

ALTER TABLE "playfields" ADD CONSTRAINT "Relationship1" FOREIGN KEY ("region_id") REFERENCES "regions" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
;

ALTER TABLE "playfields" ADD CONSTRAINT "Relationship4" FOREIGN KEY ("owner_id") REFERENCES "users" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION
;

ALTER TABLE "playfields" ADD CONSTRAINT "Relationship5" FOREIGN KEY ("title_image_id") REFERENCES "images" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION
;

ALTER TABLE "images" ADD CONSTRAINT "Relationship6" FOREIGN KEY ("playfield_id") REFERENCES "playfields" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION
;

ALTER TABLE "playfields" ADD CONSTRAINT "Relationship7" FOREIGN KEY ("type_id") REFERENCES "playfield_types" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
;

ALTER TABLE "reservations" ADD CONSTRAINT "Relationship8" FOREIGN KEY ("status_id") REFERENCES "reservation_statuses" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
;

ALTER TABLE "reservations" ADD CONSTRAINT "Relationship9" FOREIGN KEY ("user_id") REFERENCES "users" ("id") ON DELETE CASCADE ON UPDATE CASCADE
;

ALTER TABLE "reservations" ADD CONSTRAINT "Relationship10" FOREIGN KEY ("playfield_id") REFERENCES "playfields" ("id") ON DELETE CASCADE ON UPDATE CASCADE
;

ALTER TABLE "reviews" ADD CONSTRAINT "Relationship11" FOREIGN KEY ("playfield_id") REFERENCES "playfields" ("id") ON DELETE CASCADE ON UPDATE CASCADE
;

ALTER TABLE "reviews" ADD CONSTRAINT "Relationship12" FOREIGN KEY ("user_id") REFERENCES "users" ("id") ON DELETE CASCADE ON UPDATE CASCADE
;

ALTER TABLE "archive_reservations" ADD CONSTRAINT "Relationship14" FOREIGN KEY ("playfield_id") REFERENCES "playfields" ("id") ON DELETE CASCADE ON UPDATE CASCADE
;

ALTER TABLE "archive_reservations" ADD CONSTRAINT "Relationship15" FOREIGN KEY ("user_id") REFERENCES "users" ("id") ON DELETE SET NULL ON UPDATE CASCADE
;

ALTER TABLE "archive_reservations" ADD CONSTRAINT "Relationship16" FOREIGN KEY ("original_id") REFERENCES "reservations" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION
;




