/* Database schema to keep the structure of entire database. */

CREATE DATABASE vet_clinic;

CREATE TABLE animals (
    ID INT GENERATED ALWAYS AS IDENTITY,
    NAME TEXT NOT NULL,
    DATE_OF_BIRTH DATE,
    ESCAPE_ATTEMPTS INT,
    NEUTERED BOOLEAN,
    WEIGHT_KG DECIMAL(10,2),
    PRIMARY KEY (ID)
);

-- SECOND PART --

ALTER TABLE animals
ADD COLUMN species VARCHAR(50);

-- THIRD PART --

CREATE TABLE owners (
    id INT GENERATED ALWAYS AS IDENTITY,
    full_name TEXT NOT NULL,
    age INT,
    PRIMARY KEY (id)
);

CREATE TABLE species (
    id INT GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(50) NOT NULL,
    PRIMARY KEY (id)
);

ALTER TABLE animals
DROP COLUMN species;

ALTER TABLE animals
ADD COLUMN species_id INT;

ALTER TABLE animals
ADD CONSTRAINT fk_species
FOREIGN KEY (species_id) REFERENCES species(id);

ALTER TABLE animals
ADD COLUMN owner_id INT;

ALTER TABLE animals
ADD CONSTRAINT fk_owner
FOREIGN KEY (owner_id) REFERENCES owners(id);
