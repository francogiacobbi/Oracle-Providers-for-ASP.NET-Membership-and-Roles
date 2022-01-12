Rem
Rem $Header: aspnetproviders/sql/InstallOraclePersonalization.sql /main/6 2008/7/09 07:00:41 aruns Exp $
Rem
Rem InstallOraclePersonalization.sql
Rem
Rem Copyright (c) 2007, Oracle. All rights reserved.  
Rem
Rem    NAME
Rem      InstallOraclePersonalization.sql - Creates tables in the Database.
Rem
Rem    DESCRIPTION
Rem      Creates OraclePersonalizationProvider specific tables in the Database.
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    aruns       07/03/08 - Fix for Upgrade errors.
Rem    aruns       03/14/07 - Fix path for calling plb file.
Rem    aruns       03/09/07 - Call SP plb file, create roles, grant privileges to SP's.
Rem    aruns       02/25/07 - Created
Rem

-- Get the user name from the current connection
col USER new_value CurrentUser;
select USER from dual;

-- Table for storing aspnet paths information.

BEGIN

  -- first check if the table already exists
  IF ( (ora_aspnet_TableExists('ORA_ASPNET_PATHS') = 0) OR
       (ora_aspnet_TableExists('ORA_ASPNET_PERSONALIZNPERUSER') = 0) OR
       (ora_aspnet_TableExists('ORA_ASPNET_PERSONALIZNALLUSERS') = 0)) THEN

    execute immediate 'CREATE TABLE ora_aspnet_Paths
    (
      ApplicationId    		RAW (16) NOT NULL,
      PathId           		RAW (16) DEFAULT SYS_GUID() NOT NULL PRIMARY KEY,
      Path             		NVARCHAR2 (256) NOT NULL,
      LoweredPath      	NVARCHAR2 (256) NOT NULL,
      CONSTRAINT fk_Paths_Appid FOREIGN KEY (ApplicationId) 
      REFERENCES ora_aspnet_Applications (ApplicationId)
    )';

    execute immediate 'CREATE UNIQUE INDEX ora_aspnet_Paths_index ON ora_aspnet_Paths(ApplicationId, LoweredPath)';

    -- table to store User specific personalization data.
    execute immediate 'CREATE TABLE ora_aspnet_PersonaliznPerUser
    (
      Id               		RAW (16) DEFAULT SYS_GUID() NOT NULL PRIMARY KEY,
      PathId          		RAW (16),
      UserId           		RAW (16),
      PageSettings     		BLOB NOT NULL,
      LastUpdatedDate  		DATE  NOT NULL
    )';

    execute immediate 'ALTER TABLE ora_aspnet_PersonaliznPerUser ADD CONSTRAINT PersonalizationPerUser_PathId FOREIGN KEY (PathId)   REFERENCES ora_aspnet_Paths (PathId)';
    execute immediate 'ALTER TABLE ora_aspnet_PersonaliznPerUser ADD CONSTRAINT PersonalizationPerUser_UserId FOREIGN KEY (UserId)   REFERENCES ora_aspnet_Users (UserId)';
    execute immediate 'CREATE UNIQUE INDEX PersonalizationPerUser_index2 ON ora_aspnet_PersonaliznPerUser(PathId, UserId)';


    -- table to store shared personalization data.
    execute immediate 'CREATE TABLE ora_aspnet_PersonaliznAllUsers
    (
      PathId           	RAW (16),
      PageSettings     	BLOB NOT NULL,
      LastUpdatedDate  	DATE NOT NULL
    )';

    execute immediate 'ALTER TABLE ora_aspnet_PersonaliznAllUsers ADD CONSTRAINT PersonalizationAllUsers_PathId FOREIGN KEY (PathId) REFERENCES ora_aspnet_Paths (PathId) ON DELETE CASCADE';

    -- Create roles. create role privilege is required.
    execute immediate 'CREATE ROLE ora_aspnet_Pers_BasicAccess';
    execute immediate 'CREATE ROLE ora_aspnet_Pers_ReportAccess';
    execute immediate 'CREATE ROLE ora_aspnet_Pers_FullAccess';

    -- Create public synonym. Create public synonym privilege is required.
    execute immediate 'CREATE PUBLIC SYNONYM ora_aspnet_CreatePage FOR &CurrentUser..ora_aspnet_CreatePage';
    execute immediate 'CREATE PUBLIC SYNONYM ora_aspnet_CreateUser FOR &CurrentUser..ora_aspnet_CreateUser';
    execute immediate 'CREATE PUBLIC SYNONYM ora_aspnet_PA_GetCountOfState FOR &CurrentUser..ora_aspnet_PA_GetCountOfState';
    execute immediate 'CREATE PUBLIC SYNONYM ora_aspnet_PA_ResetSharedState FOR &CurrentUser..ora_aspnet_PA_ResetSharedState';
    execute immediate 'CREATE PUBLIC SYNONYM ora_aspnet_PA_ResetUserState FOR &CurrentUser..ora_aspnet_PA_ResetUserState';
    execute immediate 'CREATE PUBLIC SYNONYM ora_aspnet_PAU_GetPgSettings FOR &CurrentUser..ora_aspnet_PAU_GetPgSettings';
    execute immediate 'CREATE PUBLIC SYNONYM ora_aspnet_PAU_ResetPgSettings FOR &CurrentUser..ora_aspnet_PAU_ResetPgSettings';
    execute immediate 'CREATE PUBLIC SYNONYM ora_aspnet_PPU_ResetPgSettings FOR &CurrentUser..ora_aspnet_PPU_ResetPgSettings';
    execute immediate 'CREATE PUBLIC SYNONYM ora_aspnet_PPU_GetPgSettings FOR &CurrentUser..ora_aspnet_PPU_GetPgSettings';
    execute immediate 'CREATE PUBLIC SYNONYM ora_aspnet_PAU_SetPgSettings FOR &CurrentUser..ora_aspnet_PAU_SetPgSettings';
    execute immediate 'CREATE PUBLIC SYNONYM ora_aspnet_PPU_SetPgSettings FOR &CurrentUser..ora_aspnet_PPU_SetPgSettings';
    execute immediate 'CREATE PUBLIC SYNONYM ora_aspnet_PA_FindState FOR &CurrentUser..ora_aspnet_PA_FindState';

  END IF;

END;

/

-- Run the plb file to create stored functions/procedures
@@InstallOraclePersonalizationSP.plb

-- Grant role to role.
-- ora_aspnet_Pers_FullAccess has privileges from ora_aspnet_Pers_BasicAccess and ora_aspnet_Pers_ReportAccess.
GRANT ora_aspnet_Pers_BasicAccess TO ora_aspnet_Pers_FullAccess;
GRANT ora_aspnet_Pers_ReportAccess TO ora_aspnet_Pers_FullAccess;

-- Grant execution privilege to ora_aspnet_Pers_BasicAccess role
GRANT EXECUTE ON ora_aspnet_CreatePage TO ora_aspnet_Pers_BasicAccess;
GRANT EXECUTE ON ora_aspnet_CreateUser TO ora_aspnet_Pers_BasicAccess;
GRANT EXECUTE ON ora_aspnet_PAU_GetPgSettings TO ora_aspnet_Pers_BasicAccess;
GRANT EXECUTE ON ora_aspnet_PPU_GetPgSettings TO ora_aspnet_Pers_BasicAccess;
GRANT EXECUTE ON ora_aspnet_PAU_SetPgSettings TO ora_aspnet_Pers_BasicAccess;
GRANT EXECUTE ON ora_aspnet_PPU_SetPgSettings TO ora_aspnet_Pers_BasicAccess;
GRANT EXECUTE ON ora_aspnet_PAU_ResetPgSettings TO ora_aspnet_Pers_BasicAccess;
GRANT EXECUTE ON ora_aspnet_PPU_ResetPgSettings TO ora_aspnet_Pers_BasicAccess;

-- Grant execution privilege to ora_aspnet_Pers_ReportAccess role
GRANT EXECUTE ON ora_aspnet_PA_GetCountOfState TO ora_aspnet_Pers_ReportAccess;
GRANT EXECUTE ON ora_aspnet_PA_FindState TO ora_aspnet_Pers_ReportAccess;

-- Grant execution privilege to ora_aspnet_Pers_FullAccess role
GRANT EXECUTE ON ora_aspnet_PA_ResetSharedState TO ora_aspnet_Pers_FullAccess;
GRANT EXECUTE ON ora_aspnet_PA_ResetUserState TO ora_aspnet_Pers_FullAccess;
