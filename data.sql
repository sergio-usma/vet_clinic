/* Populate database with data. */

INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight_kg)

VALUES ('Agumon', '2020-02-03', 0, TRUE, 10.23), ('Gabumon', '2018-11-15', 2, TRUE, 8.00), ('Pikachu', '2021-01-07', 1, FALSE, 15.04), ('Devimon', '2017-05-12', 5, TRUE, 11.00);

-- SECOND PART --
INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight_kg)

VALUES ('Charmander', '2020-2-8', 0, FALSE, 11), ('Plantmon', '2021-11-15', 2, TRUE, -5.7), ('Squirtle', '1993-04-02', 3, FALSE, -12.13), ('Angemon', '2005-06-12', 1, TRUE, -45), ('Boarmon', '2005-06-07', 7, TRUE, 20.4), ('Blossom', '1998-10-13', 3, TRUE, 17), ('Ditto', '2022-05-14', 4, TRUE, 22);

-- THIRD PART --

-- Insert the following data into the owners table: --
INSERT INTO owners (full_name, age)
VALUES ('Sam Smith', 34), ('Jennifer Orwell', 19), ('Bob', 45), ('Melody Pond', 77), ('Dean Winchester', 14), ('Jodie Whittaker', 38);


-- Insert the following data into the species table: --
INSERT INTO species (name)
VALUES ('Pokemon'), ('Digimon');


-- Modify animals so it includes the species_id value: If the name ends in "mon" it will be Digimon All other animals are Pokemon --

UPDATE animals
SET species_id = 2
WHERE name LIKE '%mon';

UPDATE animals
SET species_id = 1
WHERE name NOT LIKE '%mon';

-- Modify animals so it includes the owner_id value: --

-- Sam Smith owns Agumon. --
UPDATE animals SET owner_id = 1 WHERE id = 1;

-- Jennifer Orwell owns Gabumon and Pikachu. --
UPDATE animals SET owner_id = 2 WHERE id = 2;
UPDATE animals SET owner_id = 2 WHERE id = 3;

-- Bob owns Devimon and Plantmon. --
UPDATE animals SET owner_id = 3 WHERE id = 4;
UPDATE animals SET owner_id = 3 WHERE id = 6;

-- Melody Pond owns Charmander, Squirtle, and Blossom. --
UPDATE animals SET owner_id = 4 WHERE id = 5;
UPDATE animals SET owner_id = 4 WHERE id = 7;
UPDATE animals SET owner_id = 4 WHERE id = 10;

-- Dean Winchester owns Angemon and Boarmon. --
UPDATE animals SET owner_id = 5 WHERE id = 8;
UPDATE animals SET owner_id = 5 WHERE id = 9;

-- FOURTH PART --

INSERT INTO vets (name, age, date_of_graduation)
VALUES ('William Tatcher', 45, '2000-4-23'), ('Maisy Smith', 26, '2019-1-17'), ('Stephanie Mendez', 64, '1981-5-4'), ('Jack Harkness', 38, '2008-6-8');

INSERT INTO specializations (vet_id, species_id)
VALUES (1, 1), (3, 1), (3, 2), (4, 2);

INSERT INTO visits (animal_id, vet_id, date_of_visit)
VALUES
    (1, 1, '2020-5-24'),
	(1, 3, '2020-6-22'),
	(2, 4, '2021-2-2-'),
	(3, 2, '2020-1-5'),
	(3, 2, '2020-3-8'),
	(3, 2, '2020-5-14'),
	(4, 3, '2021-5-4'),
	(5, 4, '2021-2-24'),
	(6, 2, '2019-12-21'),
	(6, 1, '2020-8-10'),
	(6, 2, '2021-4-7'),
	(7, 3, '2019-9-29'),
	(8, 4, '2020-10-3'), 
	(8, 4, '2020-11-4'),
	(9, 2, '2019-1-24'),
	(9, 2, '2019-5-15'),
	(9, 2, '2020-2-27'),
	(9, 2, '2020-8-3'),
	(10, 3, '2020-5-24'),
	(10, 1, '2021-1-11');

-- FIFTH PART --

-- This will add 3.594.280 visits considering you have 10 animals, 4 vets, and it will use around ~87.000 timestamps (~4min approx.)
INSERT INTO visits (animal_id, vet_id, date_of_visit) SELECT * FROM (SELECT id FROM animals) animal_ids, (SELECT id FROM vets) vets_ids, generate_series('1980-01-01'::timestamp, '2021-01-01', '4 hours') visit_timestamp;

-- This will add 2.500.000 owners with full_name = 'Owner <X>' and email = 'owner_<X>@email.com' (~2min approx.)
insert into owners (full_name, email) select 'Owner ' || generate_series(1,2500000), 'owner_' || generate_series(1,2500000) || '@mail.com';
