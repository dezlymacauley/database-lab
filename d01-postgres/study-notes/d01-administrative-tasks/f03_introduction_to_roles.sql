/*
    ABOUT: Introduction to roles

    A `role` can be a source of confusion for those who are new to Postgres,
    because many tutorials skip this, 
    and immediately jump into running SQL commands.

    It also doesn't help that in certain situations the word `role` and `user`
    are used interchangeably, 
    and that there is a command called `CREATE USER` which does the same
    thing as `CREATE ROLE`... 

    because `CREATE USER` is an alias for `CREATE ROLE` 
    ---------------------------------------------------------------------------

    SECTION: 1 => Keeping things simple and consistent

    So going forward, to keep things clear:
    1. I will only use the term `role`
    2. I will only use the command `CREATE ROLE`
    ---------------------------------------------------------------------------

    SECTION: 2 => Types of Roles 

    There are two types of roles that can be created

    ___________________________________________________________________________

    1. Login roles
    These are roles that have the have the ability to log into in Postgres
    and connect to a database.

    You can then set the permissions of what databases the role is allowed
    to connect to, and whether that role can perform admininistrative tasks
    on the Postgres cluster, such as creating new databases.

    When you create a new Postgres cluster, 
    the login role called `postgres` is created.

    You can use this `postgres` role to create other roles like:
    `dezly_macauley` or `kate_kendall`

    You can also directly customize what actions each of those two roles
    are allowed to perform but that's not best practice.

    This is where `non-login` roles come into play
    ___________________________________________________________________________

    2. Non-login roles:
    These roles do not have the ability to log into Postgres.

    You can use non-login roles as a group membership card.

    E.g. `postgres_lab_developer_group`, `postgres_lab_readonly_group`

    Then you'd customize the permissions of what each non-login role can
    grant its members.

    -- EXAMPLE: 1 

    E.g. I can customize the `postgres_lab_readonly_group` to only allow its
    members to have read-only access to the `postgres_lab` database.

    Then I can add `kate_kendall` to the group.

    ---------------------------------------------------------------------------

    -- EXAMPLE: 2

    E.g. I can customize the `postgres_lab_developer_group` to only allow its
    members to have the ability to read and make changes 
    to the `postgres_lab` database.

    Then I can add `dezly_macauley` to the group.

    ---------------------------------------------------------------------------
   
    -- SECTION: Summary of the roles

    1. `postgres` (login role / unrestricted access to the Postgres cluster):
    - Has the permission to login to Postgres.
    - Has full access to the Postgres cluster so it can delete databases,
    create databases, create roles etc.

    2. `postgres_lab_developer_group` (non-login role / membership group):
    - You can't use this to log into Postgres.
    - It only grants read and write permissions to roles that are members.

    3. `postgres_lab_readonly_group` (non-login role / membership group):
    - You can't use this to log into Postgres.
    - It only grants read permissions to roles that are members.

    4. `dezly_macauley` (login role / restricted access to specific databases) 
    - Can be used to login to postgres
    - Can read and modify the postgres_lab database
    -  Inherits permissions from the role `postgres_lab_developer_group`

    4. `kate_kendall` (login role / restricted access to specific databases) 
    - Can be used to login to postgres
    - Can only read from the postgres_lab database
    -  Inherits permissions from the role `postgres_lab_readonly_group`
    ---------------------------------------------------------------------------
*/
