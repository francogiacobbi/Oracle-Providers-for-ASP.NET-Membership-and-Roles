-- Copyright (c) 2002, 2008, Oracle. All rights reserved.  
Rem
Rem    NAME
Rem      InstallOracleMembership.sql
Rem
Rem    DESCRIPTION
Rem      Create table, view, roles, and public synonyms, run a PLB file and   
Rem      grant privileges for the installation of the OracleMembershipProvider.
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

-- Create ora_aspnet_Membership table for Oracle Membership provider
BEGIN
     IF ( ora_aspnet_TableExists('ORA_ASPNET_MEMBERSHIP') = 0)  THEN

execute immediate 'CREATE TABLE ora_aspnet_Membership
(
  ApplicationId                    RAW (16) NOT NULL,
  UserId                           RAW (16) NOT NULL PRIMARY KEY,
  Password                         NVARCHAR2 (128) NOT NULL,
  PasswordFormat                   INTEGER DEFAULT 0 NOT NULL,
  PasswordSalt                     NVARCHAR2 (128) NOT NULL,
  MobilePIN                        NVARCHAR2 (16),
  Email                            NVARCHAR2 (256),
  LoweredEmail                     NVARCHAR2 (256),
  PasswordQuestion                 NVARCHAR2 (256),
  PasswordAnswer                   NVARCHAR2 (128),
  IsApproved                       INTEGER   NOT NULL,
  IsLockedOut                      INTEGER   NOT NULL,
  CreateDate                       DATE      NOT NULL,
  LastLoginDate                    DATE      NOT NULL,
  LastPasswordChangedDate	   DATE      NOT NULL,
  LastLockoutDate                  DATE      NOT NULL,
  FailedPwdAttemptCount            INTEGER   NOT NULL,
  FailedPwdAttemptWinStart         DATE      NOT NULL,
  FailedPwdAnswerAttemptCount      INTEGER   NOT NULL,
  FailedPwdAnswerAttemptWinStart   DATE      NOT NULL,
  Comments                         NCLOB
)';

-- Add constraints for data integrity
execute immediate 'ALTER TABLE ora_aspnet_Membership ADD CONSTRAINT fk_membership_Appid FOREIGN KEY (ApplicationId) 
    REFERENCES ora_aspnet_Applications(ApplicationId)';

execute immediate 'ALTER TABLE ora_aspnet_Membership ADD CONSTRAINT fk_membership_userid FOREIGN KEY (UserId) 
    REFERENCES ora_aspnet_Users (UserId)';


-- Create read-only view
execute immediate 'CREATE OR REPLACE VIEW ora_vw_aspnet_MemUsers AS
SELECT m.UserId,
       m.PasswordFormat,
       m.MobilePIN,
       m.Email,
       m.LoweredEmail,
       m.PasswordQuestion,
       m.PasswordAnswer,
       m.IsApproved,
       m.IsLockedOut,
       m.CreateDate,
       m.LastLoginDate,
       m.LastPasswordChangedDate,
       m.LastLockoutDate,
       m.FailedPwdAttemptCount,
       m.FailedPwdAttemptWinStart,
       m.FailedPwdAnswerAttemptCount,
       m.FailedPwdAnswerAttemptWinStart,
       m.Comments,
       u.ApplicationId,
       u.UserName,
       u.MobileAlias,
       u.IsAnonymous,
       u.LastActivityDate 
FROM ora_aspnet_Membership m, ora_aspnet_Users u
WHERE m.UserId = u.UserId 
WITH READ ONLY';

-- Create roles. create role privilege is required.
execute immediate 'CREATE ROLE ora_aspnet_Mem_BasicAccess';
execute immediate 'CREATE ROLE ora_aspnet_Mem_ReportAccess';
execute immediate 'CREATE ROLE ora_aspnet_Mem_FullAccess';


-- Create public synonym. Create public synonym privilege is required.
execute immediate 'CREATE PUBLIC SYNONYM ora_aspnet_Users_DeleteUser FOR &CurrentUser..ora_aspnet_Users_DeleteUser';
execute immediate 'CREATE PUBLIC SYNONYM ora_aspnet_Mem_DeleteUser FOR &CurrentUser..ora_aspnet_Mem_DeleteUser';
execute immediate 'CREATE PUBLIC SYNONYM ora_aspnet_Mem_GetUserByUid FOR &CurrentUser..ora_aspnet_Mem_GetUserByUid';
execute immediate 'CREATE PUBLIC SYNONYM ora_aspnet_Mem_GetUserByName FOR &CurrentUser..ora_aspnet_Mem_GetUserByName';
execute immediate 'CREATE PUBLIC SYNONYM ora_aspnet_Mem_GetUserByEml FOR &CurrentUser..ora_aspnet_Mem_GetUserByEml';
execute immediate 'CREATE PUBLIC SYNONYM ora_aspnet_Mem_GetPassword FOR &CurrentUser..ora_aspnet_Mem_GetPassword';
execute immediate 'CREATE PUBLIC SYNONYM ora_aspnet_Mem_GetPwdWithFmt FOR &CurrentUser..ora_aspnet_Mem_GetPwdWithFmt';
execute immediate 'CREATE PUBLIC SYNONYM ora_aspnet_Mem_UpdateUserInfo FOR &CurrentUser..ora_aspnet_Mem_UpdateUserInfo';
execute immediate 'CREATE PUBLIC SYNONYM ora_aspnet_Mem_GetNumOfUsersOn FOR &CurrentUser..ora_aspnet_Mem_GetNumOfUsersOn';
execute immediate 'CREATE PUBLIC SYNONYM ora_aspnet_Mem_GetAllUsers FOR &CurrentUser..ora_aspnet_Mem_GetAllUsers';
execute immediate 'CREATE PUBLIC SYNONYM ora_aspnet_Mem_FindUsersByName FOR &CurrentUser..ora_aspnet_Mem_FindUsersByName';
execute immediate 'CREATE PUBLIC SYNONYM ora_aspnet_Mem_FindUsersByEml FOR &CurrentUser..ora_aspnet_Mem_FindUsersByEml';
execute immediate 'CREATE PUBLIC SYNONYM ora_aspnet_Mem_CreateUser FOR &CurrentUser..ora_aspnet_Mem_CreateUser';
execute immediate 'CREATE PUBLIC SYNONYM ora_aspnet_Mem_SetPassword FOR &CurrentUser..ora_aspnet_Mem_SetPassword';
execute immediate 'CREATE PUBLIC SYNONYM ora_aspnet_Mem_ResetPassword FOR &CurrentUser..ora_aspnet_Mem_ResetPassword';
execute immediate 'CREATE PUBLIC SYNONYM ora_aspnet_Mem_UpdateUser FOR &CurrentUser..ora_aspnet_Mem_UpdateUser';
execute immediate 'CREATE PUBLIC SYNONYM ora_aspnet_Mem_ChangePwdQAndA FOR &CurrentUser..ora_aspnet_Mem_ChangePwdQAndA';
execute immediate 'CREATE PUBLIC SYNONYM ora_aspnet_Mem_UnlockUser FOR &CurrentUser..ora_aspnet_Mem_UnlockUser';
  
      END IF;
END;
/

-- Run the plb file to create stored functions/procedures or packages
@@InstallOracleMembershipSP.plb

-- Grant view access previlege to roles
GRANT SELECT ON ora_vw_aspnet_Applications TO ora_aspnet_Mem_ReportAccess;
GRANT SELECT ON ora_vw_aspnet_Users TO ora_aspnet_Mem_ReportAccess;
GRANT SELECT ON ora_vw_aspnet_MemUsers TO ora_aspnet_Mem_ReportAccess;

-- Grant role to role. ora_aspnet_Mem_FullAccess has privileges from 
-- ora_aspnet_Mem_BasicAccess and ora_aspnet_Mem_ReportAccess.
GRANT ora_aspnet_Mem_BasicAccess TO ora_aspnet_Mem_FullAccess;
GRANT ora_aspnet_Mem_ReportAccess TO ora_aspnet_Mem_FullAccess;

-- Grant execution privilege to ora_aspnet_Mem_BasicAccess role
GRANT EXECUTE ON ora_aspnet_Mem_GetUserByUid TO ora_aspnet_Mem_BasicAccess;
GRANT EXECUTE ON ora_aspnet_Mem_GetUserByName TO ora_aspnet_Mem_BasicAccess;
GRANT EXECUTE ON ora_aspnet_Mem_GetUserByEml TO ora_aspnet_Mem_BasicAccess;
GRANT EXECUTE ON ora_aspnet_Mem_GetPassword TO ora_aspnet_Mem_BasicAccess;
GRANT EXECUTE ON ora_aspnet_Mem_GetPwdWithFmt TO ora_aspnet_Mem_BasicAccess;
GRANT EXECUTE ON ora_aspnet_Mem_GetNumOfUsersOn TO ora_aspnet_Mem_BasicAccess;
GRANT EXECUTE ON ora_aspnet_Mem_UpdateUserInfo TO ora_aspnet_Mem_BasicAccess;

-- Grant execution privilege to ora_aspnet_Mem_ReportAccess role
GRANT EXECUTE ON ora_aspnet_Mem_GetUserByUid TO ora_aspnet_Mem_ReportAccess;
GRANT EXECUTE ON ora_aspnet_Mem_GetUserByName TO ora_aspnet_Mem_ReportAccess;
GRANT EXECUTE ON ora_aspnet_Mem_GetUserByEml TO ora_aspnet_Mem_ReportAccess;
GRANT EXECUTE ON ora_aspnet_Mem_GetAllUsers TO ora_aspnet_Mem_ReportAccess;
GRANT EXECUTE ON ora_aspnet_Mem_GetNumOfUsersOn TO ora_aspnet_Mem_ReportAccess;
GRANT EXECUTE ON ora_aspnet_Mem_FindUsersByName TO ora_aspnet_Mem_ReportAccess;
GRANT EXECUTE ON ora_aspnet_Mem_FindUsersByEml TO ora_aspnet_Mem_ReportAccess;

-- Grant execution privilege to ora_aspnet_Mem_FullAccess role
GRANT EXECUTE ON ora_aspnet_Users_DeleteUser TO ora_aspnet_Mem_FullAccess;
GRANT EXECUTE ON ora_aspnet_Mem_DeleteUser TO ora_aspnet_Mem_FullAccess;
GRANT EXECUTE ON ora_aspnet_Mem_CreateUser TO ora_aspnet_Mem_FullAccess;
GRANT EXECUTE ON ora_aspnet_Mem_SetPassword TO ora_aspnet_Mem_FullAccess;
GRANT EXECUTE ON ora_aspnet_Mem_ResetPassword TO ora_aspnet_Mem_FullAccess;
GRANT EXECUTE ON ora_aspnet_Mem_UpdateUser TO ora_aspnet_Mem_FullAccess;
GRANT EXECUTE ON ora_aspnet_Mem_ChangePwdQAndA TO ora_aspnet_Mem_FullAccess;
GRANT EXECUTE ON ora_aspnet_Mem_UnlockUser TO ora_aspnet_Mem_FullAccess;
