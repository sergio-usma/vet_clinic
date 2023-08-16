/*Queries that provide answers to the questions from all projects.*/

-- Find all animals whose name ends in "mon".
SELECT * FROM animals WHERE name LIKE '%mon';

-- List the name of all animals born between 2016 and 2019
SELECT name FROM animals WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-12-31';

-- List the name of all animals that are neutered and have less than 3 escape attempts
SELECT name FROM animals WHERE neutered = TRUE AND escape_attempts < 3;

-- List the date of birth of all animals named either "Agumon" or "Pikachu"
SELECT date_of_birth FROM animals WHERE name IN ('Agumon', 'Pikachu');

-- List name and escape attempts of animals that weigh more than 10.5kg
SELECT name, escape_attempts FROM animals WHERE weight_kg > 10.5;

-- Find all animals that are neutered
SELECT * FROM animals WHERE neutered = TRUE;

-- Find all animals not named Gabumon
SELECT * FROM animals WHERE name <> 'Gabumon';

-- Find all animals with a weight between 10.4kg and 17.3kg (including the animals with weights that equal precisely 10.4kg or 17.3kg)
SELECT * FROM animals WHERE weight_kg BETWEEN 10.4 AND 17.3;

-- SECOND PART --

-- Inside a transaction block, update the species of all animals to be 'unspecified', check and then rollback to the initial state --

BEGIN;
UPDATE animals SET species = 'unspecified';
SELECT * FROM animals;
ROLLBACK;

-- Modify animals table: set species to "digimon" for names ending in "mon" and "pokemon" for unspecified species. Confirm changes, commit, and verify persistence. --

BEGIN;
  UPDATE animals SET species = 'digimon ' WHERE NAME LIKE '%mon';
  UPDATE animals SET species = 'pokemon' WHERE species IS NULL;
  SELECT * FROM animals ORDER BY id;
COMMIT;
  SELECT * FROM animals ORDER BY id;

  -- Inside a transaction delete all records in the animals table, then roll back the transaction. ---

  BEGIN;
  DELETE FROM animals;
  SELECT COUNT(id) FROM animals;
ROLLBACK;
  SELECT COUNT(id) FROM animals;

 -- Inside a transaction: Remove animals born after Jan 1, 2022. Create savepoint. Change animal weights to negative. Rollback to savepoint. Adjust negative weights. Commit transaction.  --

 BEGIN;
  DELETE FROM animals WHERE date_of_birth > '2022-01-01';
SAVEPOINT my_savepoint;
  UPDATE animals SET weight_kg = weight_kg * -1;
  ROLLBACK TO my_savepoint;
  UPDATE animals SET weight_kg = weight_kg * -1 WHERE weight_kg < 0;
COMMIT;

-- AGREGATIONS --

-- How many animals are there? --
SELECT COUNT(id) FROM animals;


-- How many animals have never tried to escape? --
SELECT COUNT(id) FROM animals WHERE escape_attempts = 0;

-- What is the average weight of animals? --
SELECT AVG(weight_kg) AS average FROM animals;

-- Who escapes the most, neutered or not neutered animals? --
SELECT neutered, COUNT(*) AS escape_attempts FROM animals
GROUP BY neutered ORDER BY escape_attempts DESC;

-- What is the minimum and maximum weight of each type of animal? --
SELECT species, MAX(weight_kg) AS max_weight, MIN(weight_kg) AS min_weight
FROM animals GROUP BY species;

-- What is the average number of escape attempts per animal type of those born between 1990 and 2000? --
SELECT species, AVG(escape_attempts) FROM animals   
WHERE  date_of_birth >= '1990/01/01' AND date_of_birth <= '2000/12/31'
GROUP BY species;



