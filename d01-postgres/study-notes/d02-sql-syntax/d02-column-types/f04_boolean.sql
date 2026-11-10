/*

    ABOUT: Boolean

    This is used to store the values `True` and `False`
*/

-------------------------------------------------------------------------------

CREATE TABLE (
    user_name TEXT,
    is_online BOOLEAN 
);
-------------------------------------------------------------------------------
-- Internally, PostgreSQL stores boolean values in this format:
-- 0 = False
-- 1 = True

-- _______________________________________________________________________________


-- _______________________________________________________________________________

-- When it comes to entering a value in a boolean column,
-- Postgres will accept:
--
-- TRUE, FALSE
-- 't', 'f'
-- 'yes', 'no'
-- '1', '0'
--
-- Also Note: Boolean input in PostgreSQL is case-insensitive.

INSERT INTO player_status (
    user_name, is_online
) 
VALUES
    ('Dave', true),
    ('Ken', false),
    ('Lee', '1'),
    ('Jin', '0'),
    ('Max', 't'),
    ('Jane', 'f'),
    ('Gojo', 'yes'),
    ('Bruce', 'no'),
    ('Lee', 'off'),
    ('Kate', 'on');

-- _______________________________________________________________________________

SELECT * FROM player_status;

-- This will be the output

-- +-----------+-----------+
-- | user_name | is_online |
-- |-----------+-----------|
-- | Dave      | True      |
-- | Ken       | False     |
-- | Lee       | True      |
-- | Jin       | False     |
-- | Max       | True      |
-- | Jane      | False     |
-- | Gojo      | True      |
-- | Bruce     | False     |
-- | Lee       | False     |
-- | Kate      | True      |
-- +-----------+-----------+

-- _______________________________________________________________________________
