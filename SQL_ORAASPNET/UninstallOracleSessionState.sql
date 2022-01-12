-- For Oracle 10gR1(10.1.0.2) database and higher
-- For Oracle 9iR2(9.2.x) database, run UninstallOracleSessionState92.sql instead

-- Remove job that cleans up expired session items
-- For Oracle 10gR1(10.1.0.2) database and higher
BEGIN
DBMS_SCHEDULER.DROP_JOB ('REMOVEEXPIRED_ASPNET_SESSITEMS');
END;
/

-- Drop public synonyms. Drop public synonym privilege is required.
DROP PUBLIC SYNONYM ora_aspnet_SessnApp_GetAppID;
DROP PUBLIC SYNONYM ora_aspnet_Sessn_InsUninitItem;
DROP PUBLIC SYNONYM ora_aspnet_Sessn_RelStateItmEx;
DROP PUBLIC SYNONYM ora_aspnet_Sessn_RmStateItem;
DROP PUBLIC SYNONYM ora_aspnet_Sessn_ResetTimeout;
DROP PUBLIC SYNONYM ora_aspnet_Sessn_UpdStateItem;
DROP PUBLIC SYNONYM ora_aspnet_Sessn_InsStateItem;
DROP PUBLIC SYNONYM ora_aspnet_Sessn_GetStateItem;
DROP PUBLIC SYNONYM ora_aspnet_Sessn_GetStateItmEx;


-- Drop role
DROP ROLE ora_aspnet_Sessn_FullAccess;


-- Drop functions
DROP FUNCTION ora_aspnet_SessnApp_GetAppID;
DROP FUNCTION ora_aspnet_Sessn_InsUninitItem;
DROP FUNCTION ora_aspnet_Sessn_RelStateItmEx;
DROP FUNCTION ora_aspnet_Sessn_RmStateItem;
DROP FUNCTION ora_aspnet_Sessn_ResetTimeout;
DROP FUNCTION ora_aspnet_Sessn_UpdStateItem;
DROP FUNCTION ora_aspnet_Sessn_InsStateItem;
DROP FUNCTION ora_aspnet_Sessn_GetStateItem;
DROP FUNCTION ora_aspnet_Sessn_GetStateItmEx;


-- Drop view
DROP VIEW ora_vw_aspnet_Sessions;


-- Drop tables
DROP TABLE ora_aspnet_Sessions;
DROP TABLE ora_aspnet_SessionApplications;