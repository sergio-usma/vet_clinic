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