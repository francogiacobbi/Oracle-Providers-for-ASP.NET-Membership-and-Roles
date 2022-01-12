-- Copyright (c) 2002, 2009, Oracle and/or its affiliates. 
-- All rights reserved. 

-- Drop tables. Tables that are referencing the following 
-- two tables must be droppred first.
DROP TABLE ora_aspnet_Users;
DROP TABLE ora_aspnet_Applications;

-- Drop views
DROP VIEW ora_vw_aspnet_Users;
DROP VIEW ora_vw_aspnet_Applications;

-- Drop functions
DROP FUNCTION ora_aspnet_TableExists;
DROP FUNCTION ora_aspnet_Users_DeleteUser;
DROP FUNCTION ora_aspnet_Users_CreateUser;
DROP FUNCTION ora_aspnet_Apps_CreateApp;


