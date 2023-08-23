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

-- THIRD PART --

-- What animals belong to Melody Pond? --
SELECT full_name, name FROM owners
JOIN animals ON owners.id = animals.owner_id
WHERE full_name = 'Melody Pond';

-- List of all animals that are pokemon (their type is Pokemon). --
SELECT animals.name, species.name FROM animals
JOIN species ON animals.species_id = species.id
WHERE species.name = 'Pokemon'
ORDER BY animals.id;

-- List all owners and their animals, remember to include those that don't own any animal. --
SELECT owners.full_name, animals.name FROM owners
LEFT JOIN animals ON owners.id = animals.owner_id;

-- How many animals are there per species? --
SELECT species.name, COUNT(animals.id) FROM species
JOIN animals ON species.id = animals.species_id
GROUP BY species.name;

-- List all Digimon owned by Jennifer Orwell. --
SELECT owners.full_name, animals.name FROM owners
JOIN animals ON owners.id = animals.owner_id
JOIN species ON animals.species_id = species.id
WHERE owners.full_name = 'Jennifer Orwell' AND species.name = 'Digimon';


-- List all animals owned by Dean Winchester that haven't tried to escape. --
SELECT owners.full_name, animals.name FROM owners
JOIN animals ON owners.id = animals.owner_id
WHERE owners.full_name = 'Dean Winchester' AND animals.escape_attempts = 0;


-- Who owns the most animals? --
SELECT owners.full_name, COUNT(animals.id) FROM owners
JOIN animals ON owners.id = animals.owner_id
GROUP BY owners.full_name
ORDER BY COUNT(animals.id) DESC
LIMIT 1;

-- FOURTH PART --

-- Who was the last animal seen by William Tatcher? --
SELECT animals.name FROM animals
JOIN visits ON animals.id = visits.animal_id
JOIN vets ON visits.vet_id = vets.id
WHERE vets.name = 'William Tatcher'
ORDER BY visits.date_of_visit DESC
LIMIT 1;


-- How many different animals did Stephanie Mendez see? --

SELECT COUNT(species_id)
FROM specializations
WHERE vet_id = 3;

-- List all vets and their specialties, including vets with no specialties. --
SELECT vets.name, species.name FROM vets
LEFT JOIN specializations ON vets.id = specializations.vet_id
LEFT JOIN species ON specializations.species_id = species.id;


-- List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020. --
SELECT animals.name FROM animals
JOIN visits ON animals.id = visits.animal_id
JOIN vets ON visits.vet_id = vets.id
WHERE vets.name = 'Stephanie Mendez' AND visits.date_of_visit BETWEEN '2020-04-01' AND '2020-08-30';


-- What animal has the most visits to vets? --
SELECT animals.name, COUNT(visits.id) FROM animals
JOIN visits ON animals.id = visits.animal_id
GROUP BY animals.name
ORDER BY COUNT(visits.id) DESC
LIMIT 1;


-- Who was Maisy Smith's first visit? --
SELECT animals.name FROM animals
JOIN visits ON animals.id = visits.animal_id
JOIN vets ON visits.vet_id = vets.id
WHERE vets.name = 'Maisy Smith'
ORDER BY visits.date_of_visit ASC
LIMIT 1;


-- Details for most recent visit: animal information, vet information, and date of visit. --
SELECT animals.name, vets.name, visits.date_of_visit FROM animals
JOIN visits ON animals.id = visits.animal_id
JOIN vets ON visits.vet_id = vets.id
ORDER BY visits.date_of_visit DESC
LIMIT 1;

-- How many visits were with a vet that did not specialize in that animal's species? --
SELECT COUNT(visits.vet_id) from visits
INNER JOIN animals ON animals.id = visits.animal_id
INNER JOIN vets ON vets.id = visits.vet_id
LEFT JOIN specializations ON specializations.vet_id = vets.id
WHERE specializations.vet_id IS NULL;


-- What specialty should Maisy Smith consider getting? Look for the species she gets the most. --
SELECT vets.name, species.name, COUNT(species.name) total
FROM vets
JOIN visits ON vets.id = visits.vet_id
JOIN animals ON visits.animal_id = animals.id
JOIN species ON species.id = animals.species_id
WHERE vets.name = 'Maisy Smith'
GROUP BY species.name, vets.name
ORDER BY total DESC LIMIT 1;

-- FIFTH PART --
SELECT COUNT(*) FROM visits where animal_id = 4;
SELECT * FROM visits where vet_id = 2;
SELECT * FROM owners where email = 'owner_18327@mail.com';




