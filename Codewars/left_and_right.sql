-- Instructions

-- You are given a table named repositories, format as below:

-- ** repositories table schema **

-- project
-- commits
-- contributors
-- address

-- The table shows project names of major cryptocurrencies, their numbers of commits and contributors and also a random donation address ( not linked in any way :) ).

-- For each row: Return first x characters of the project name where x = commits. Return last y characters of each address where y = contributors.

-- Return project and address columns only, as follows:

-- ** output table schema **

-- project
-- address
-- Case should be maintained.

-- SQL Query

-- Postgre SQL

SELECT
  SUBSTR(project, 1, commits) AS project,
  CASE
    WHEN contributors > 0 THEN SUBSTR(address, LENGTH(address) - contributors + 1)
    ELSE ''
  END AS address
FROM repositories;
