-- load time table
CREATE TABLE TimeTable(
    Character_Name varchar(100),
    Planet_Name varchar(100),
    Movie integer,
    Time_of_Arrival integer,
    Time_of_Departure integer
);

-- show tables; (show all the tables)
-- desc TimeTable; (show table titles and types)
-- select * from TimeTable; (select query)

LOAD DATA LOCAL INFILE "TimeTable.csv" INTO TABLE TimeTable
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(Character_Name, Planet_Name, Movie, Time_of_Arrival, Time_of_Departure);

-- load characters
CREATE TABLE Characters(
    Name varchar(100),
    Race varchar(100),
    Homeworld varchar(100),
    Affiliation varchar(100)
);

LOAD DATA LOCAL INFILE "Characters.csv" INTO TABLE Characters
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(Name, Race, Homeworld, Affiliation);

-- load planets
CREATE TABLE Planets(
    Name varchar(100),
    Type varchar(100),
    Affiliation varchar(100)
);

LOAD DATA LOCAL INFILE "Planets.csv" INTO TABLE Planets
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(Name, Type, Affiliation);
/*
select 'Exercise 1';
select distinct T.Character_Name from TimeTable as T
where T.Planet_Name = "Endor" and T.movie = 3; 


select 'Exercise 2';
select distinct T.Character_Name from TimeTable as T, Characters as c
where T.Character_Name = c.Name and T.movie = 3 and T.Planet_Name = c.Homeworld;


select 'Exercise 3';
select T.Character_Name, sum(T.Time_of_Departure - T.Time_of_Arrival) from TimeTable T
group by T.Character_Name;

select 'Exercise 4';
select T_luke.Planet_Name, T_luke.movie from TimeTable as T_luke
where T_luke.Character_Name = 'Luke Skywalker' and 
exists(
    select * from TimeTable T
    where
    T.Character_name != 'Luke Skywalker' and
    T.Movie = T_luke.Movie and
    T.Planet_Name = T_luke.Planet_Name and
    T.Time_of_Arrival <= T_luke.Time_of_Departure and
    T.Time_of_Departure >= T_luke.Time_of_Arrival and
    T.Character_Name IN (
        select c.Name from Characters as c
        where c.Race = 'Human'
        )

    );




1. Since the answer of the homework might not release before finals,
   We prepare some exercises for you to practice:
2. DO NOT MODIFY anything TAs provide to you, including tables.

Exercise1: Who had been to Endor in movie 3?

TA reference answer 1:

SELECT DISTINCT T.Character_Name FROM TimeTable AS T
WHERE T.Planet_Name = "Endor" AND T.Movie = 3;


Exercise2: Who visited his/her homeworld in movie 3?

TA reference answer 2:

SELECT DISTINCT T.Character_Name FROM TimeTable T, Characters C
WHERE C.Name = T.Character_Name AND T.Planet_Name = C.Homeworld AND T.Movie = 3;

TA reference answer 3:

SELECT T.Character_Name, SUM(T.Time_of_Departure - T.Time_of_Arrival) FROM TimeTable T
GROUP BY T.Character_Name;


Exercise4: List the planets and movies Luke Skywalker has been to at the same time there is at least one human on the planet, too?

TA reference answer 4:

select ' ';
SELECT T_Luke.Planet_Name, T_Luke.Movie
FROM 
    TimeTable T_Luke
WHERE 
    T_Luke.Character_Name = 'Luke Skywalker' AND 
    EXISTS (
        SELECT * FROM TimeTable T
        WHERE
        T.Character_Name != 'Luke Skywalker' AND 
        T.Planet_Name = T_Luke.Planet_Name AND 
        T.Movie = T_Luke.Movie AND
        T.Time_of_Departure >= T_Luke.Time_of_Arrival AND 
        T.Time_of_Arrival <= T_Luke.Time_of_Departure AND
        T.Character_Name IN (SELECT C.Name FROM Characters C
                             WHERE C.Race = 'Human')
    )
;


Some more instructions you might use: JOIN, COUNT, NOT and MAX.
Best Luck to you!
*/

-- Your codes start from here

-- Q1: What planets did Princess Leia visit in movie 3?
SELECT 'Q1:'; -- To print number of questions for auto-judging. DO NOT REMOVE!
-- Your answer
select T.Planet_Name from TimeTable T
where T.Character_Name = 'Princess Leia' and T.movie = 3;

-- Q2: Who visited planets of his/her affiliation in movie 2?
SELECT 'Q2:';

select T.Character_Name from TimeTable T, Characters c, Planets p
where T.Character_Name = c.Name and T.movie = 2 and T.Planet_Name = p.Name and c.Affiliation = p.Affiliation;


-- Q3: Find all characters that never visited any empire planets.
SELECT 'Q3:';

select distinct T.Character_Name from TimeTable T
where T.Character_Name NOT IN(
    select distinct T.Character_Name from TimeTable T, Planets p
    where T.Planet_Name = p.Name and p.Affiliation = 'empire'
);


-- Q4: How many times for each character to visit his/her homeworld? show character names and times appeared in TimeTable.
SELECT 'Q4:';

select T.Character_Name, COUNT(T.Character_Name) from TimeTable T, Characters c
where T.Character_Name = c.Name and T.Planet_Name = c.homeworld
group by T.Character_Name;

-- Q5: For each movie, which character(s) visited the highest number of planets?
SELECT 'Q5:';

select CharacterReference.tmovie, CharacterReference.tcname from 
    (
    select T.Movie as tmovie, T.Character_Name as tcname, COUNT(distinct T.Planet_Name) as Cnt from TimeTable T
    group by T.Movie, T.Character_Name
    ) as CharacterReference
    ,
    (
    select Reference.tmovie as rmovie, MAX(Reference.Cnt) as Maximum
    from
        (
        select T.Movie as tmovie, T.Character_Name as tcname, COUNT(distinct T.Planet_Name) as Cnt from TimeTable T
        group by T.Movie, T.Character_Name
        ) as Reference
    group by rmovie
    ) as MaxReference
where CharacterReference.tmovie = MaxReference.rmovie and CharacterReference.Cnt = MaxReference.Maximum;








