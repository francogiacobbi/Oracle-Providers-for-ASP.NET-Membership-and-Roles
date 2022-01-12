Rem
Rem Copyright (c) 2002, 2008, Oracle. All rights reserved.  
Rem
Rem    NAME
Rem      InstallOracleProfile.sql
Rem
Rem    DESCRIPTION
Rem      Create table, view, roles, and public synonyms, run a PLB file and 
Rem      grant privileges for the installation of the OracleProfileProvider.
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    shsu       07/18/08 - Check if table exists before creating it and other objects
Rem    shsu       12/20/06 - Created
Rem

-- Get the user name from the current connection
col USER new_value CurrentUser;
select USER from dual;

-- Create ora_aspnet_Profile table for Oracle Profile provider

BEGIN
     IF ( ora_aspnet_TableExists('ORA_ASPNET_PROFILE') = 0)  THEN

execute immediate 'CREATE TABLE ora_aspnet_Profile
(
  UserId                   	RAW (16) NOT NULL PRIMARY KEY,
  PropertyNames            	NCLOB NOT NULL,
  PropertyValuesString     	NCLOB NOT NULL,
  PropertyValuesBinary          BLOB NOT NULL,
  LastUpdatedDate          	DATE  NOT NULL,
  CONSTRAINT fk_Profile_userid FOREIGN KEY (UserId) 
  REFERENCES ora_aspnet_Users (UserId)
)';


-- Create read-only view. Create view privilege is required
execute immediate 'CREATE OR REPLACE VIEW ora_vw_aspnet_Profiles AS
SELECT UserId,
       LastUpdatedDate,
       DBMS_LOB.GETLENGTH(PropertyNames) +
       DBMS_LOB.GETLENGTH(PropertyValuesString) +
       DBMS_LOB.GETLENGTH(PropertyValuesBinary) DataSize
FROM ora_aspnet_Profile
WITH READ ONLY';


-- Create roles. Create role privilege is required.
execute immediate 'CREATE ROLE ora_aspnet_Prof_BasicAccess';
execute immediate 'CREATE ROLE ora_aspnet_Prof_ReportAccess';
execute immediate 'CREATE ROLE ora_aspnet_Prof_FullAccess';

-- Create public synonym. Create public synonym privilege is required.
execute immediate 'CREATE PUBLIC SYNONYM ora_aspnet_Prof_GetProperties FOR &CurrentUser..ora_aspnet_Prof_GetProperties';
execute immediate 'CREATE PUBLIC SYNONYM ora_aspnet_Prof_SetProperties FOR &CurrentUser..ora_aspnet_Prof_SetProperties';
execute immediate 'CREATE PUBLIC SYNONYM ora_aspnet_Prof_GetNOfInactPf FOR &CurrentUser..ora_aspnet_Prof_GetNOfInactPf';
execute immediate 'CREATE PUBLIC SYNONYM ora_aspnet_Prof_GetProfiles FOR &CurrentUser..ora_aspnet_Prof_GetProfiles';
execute immediate 'CREATE PUBLIC SYNONYM ora_aspnet_Prof_DeleteProfiles FOR &CurrentUser..ora_aspnet_Prof_DeleteProfiles';
execute immediate 'CREATE PUBLIC SYNONYM ora_aspnet_Prof_DeleteInactPf FOR &CurrentUser..ora_aspnet_Prof_DeleteInactPf';
execute immediate 'CREATE PUBLIC SYNONYM ora_aspnet_Prof_pkg FOR &CurrentUser..ora_aspnet_Prof_pkg';

      END IF;
END;
/

-- Run the plb file to create stored functions/procedures or packages
@@InstallOracleProfileSP.plb


-- Grant view access previlege to roles
GRANT SELECT ON ora_vw_aspnet_Applications TO ora_aspnet_Prof_ReportAccess;
GRANT SELECT ON ora_vw_aspnet_Users TO ora_aspnet_Prof_ReportAccess;
GRANT SELECT ON ora_vw_aspnet_Profiles TO ora_aspnet_Prof_ReportAccess;

-- Grant role to role. ora_aspnet_Prof_FullAccess has privileges from 
-- ora_aspnet_Prof_BasicAccess and ora_aspnet_Prof_ReportAccess.
GRANT ora_aspnet_Prof_BasicAccess TO ora_aspnet_Prof_FullAccess;
GRANT ora_aspnet_Prof_ReportAccess TO ora_aspnet_Prof_FullAccess;

-- Grant execution privilege to ora_aspnet_Prof_BasicAccess role
GRANT EXECUTE ON ora_aspnet_Prof_GetProperties TO ora_aspnet_Prof_BasicAccess;
GRANT EXECUTE ON ora_aspnet_Prof_SetProperties TO ora_aspnet_Prof_BasicAccess;

-- Grant execution privilege to ora_aspnet_Prof_ReportAccess role
GRANT EXECUTE ON ora_aspnet_Prof_GetNOfInactPf TO ora_aspnet_Prof_ReportAccess;
GRANT EXECUTE ON ora_aspnet_Prof_GetProfiles TO ora_aspnet_Prof_BasicAccess;

-- Grant execution privilege to ora_aspnet_Prof_FullAccess role
GRANT EXECUTE ON ora_aspnet_Prof_DeleteProfiles TO ora_aspnet_Prof_FullAccess;
GRANT EXECUTE ON ora_aspnet_Prof_DeleteInactPf TO ora_aspnet_Prof_FullAccess;
