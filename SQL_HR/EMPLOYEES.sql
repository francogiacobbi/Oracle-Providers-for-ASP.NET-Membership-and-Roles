
CREATE TABLE EMPLOYEES
(
  EMPLOYEE_ID     NUMBER(6),
  FIRST_NAME      VARCHAR2(20 BYTE),
  LAST_NAME       VARCHAR2(25 BYTE) CONSTRAINT EMP_LAST_NAME_NN NOT NULL,
  EMAIL           VARCHAR2(25 BYTE) CONSTRAINT EMP_EMAIL_NN NOT NULL,
  PHONE_NUMBER    VARCHAR2(20 BYTE),
  HIRE_DATE       DATE CONSTRAINT EMP_HIRE_DATE_NN NOT NULL,
  JOB_ID          VARCHAR2(10 BYTE) CONSTRAINT EMP_JOB_NN NOT NULL,
  SALARY          NUMBER(8,2),
  COMMISSION_PCT  NUMBER(2,2),
  MANAGER_ID      NUMBER(6),
  DEPARTMENT_ID   NUMBER(4)
)
TABLESPACE USERS
RESULT_CACHE (MODE DEFAULT)
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
            FLASH_CACHE      DEFAULT
            CELL_FLASH_CACHE DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE EMPLOYEES IS 'employees table. Contains 107 rows. References with departments,
jobs, job_history tables. Contains a self reference.';

COMMENT ON COLUMN EMPLOYEES.EMPLOYEE_ID IS 'Primary key of employees table.';

COMMENT ON COLUMN EMPLOYEES.FIRST_NAME IS 'First name of the employee. A not null column.';

COMMENT ON COLUMN EMPLOYEES.LAST_NAME IS 'Last name of the employee. A not null column.';

COMMENT ON COLUMN EMPLOYEES.EMAIL IS 'Email id of the employee';

COMMENT ON COLUMN EMPLOYEES.PHONE_NUMBER IS 'Phone number of the employee; includes country code and area code';

COMMENT ON COLUMN EMPLOYEES.HIRE_DATE IS 'Date when the employee started on this job. A not null column.';

COMMENT ON COLUMN EMPLOYEES.JOB_ID IS 'Current job of the employee; foreign key to job_id column of the
jobs table. A not null column.';

COMMENT ON COLUMN EMPLOYEES.SALARY IS 'Monthly salary of the employee. Must be greater
than zero (enforced by constraint emp_salary_min)';

COMMENT ON COLUMN EMPLOYEES.COMMISSION_PCT IS 'Commission percentage of the employee; Only employees in sales
department elgible for commission percentage';

COMMENT ON COLUMN EMPLOYEES.MANAGER_ID IS 'Manager id of the employee; has same domain as manager_id in
departments table. Foreign key to employee_id column of employees table.
(useful for reflexive joins and CONNECT BY query)';

COMMENT ON COLUMN EMPLOYEES.DEPARTMENT_ID IS 'Department id where employee works; foreign key to department_id
column of the departments table';



CREATE INDEX EMP_DEPARTMENT_IX ON EMPLOYEES
(DEPARTMENT_ID)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
            FLASH_CACHE      DEFAULT
            CELL_FLASH_CACHE DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX EMP_EMAIL_UK ON EMPLOYEES
(EMAIL)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
            FLASH_CACHE      DEFAULT
            CELL_FLASH_CACHE DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX EMP_EMP_ID_PK ON EMPLOYEES
(EMPLOYEE_ID)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
            FLASH_CACHE      DEFAULT
            CELL_FLASH_CACHE DEFAULT
           )
NOPARALLEL;


CREATE INDEX EMP_JOB_IX ON EMPLOYEES
(JOB_ID)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
            FLASH_CACHE      DEFAULT
            CELL_FLASH_CACHE DEFAULT
           )
NOPARALLEL;


CREATE INDEX EMP_MANAGER_IX ON EMPLOYEES
(MANAGER_ID)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
            FLASH_CACHE      DEFAULT
            CELL_FLASH_CACHE DEFAULT
           )
NOPARALLEL;


CREATE INDEX EMP_NAME_IX ON EMPLOYEES
(LAST_NAME, FIRST_NAME)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
            FLASH_CACHE      DEFAULT
            CELL_FLASH_CACHE DEFAULT
           )
NOPARALLEL;


CREATE OR REPLACE TRIGGER secure_employees
  BEFORE INSERT OR UPDATE OR DELETE ON employees
DISABLE
BEGIN
  secure_dml;
END secure_employees;
/


CREATE OR REPLACE TRIGGER update_job_history
  AFTER UPDATE OF job_id, department_id ON employees
  FOR EACH ROW
BEGIN
  add_job_history(:old.employee_id, :old.hire_date, sysdate,
                  :old.job_id, :old.department_id);
END;
/


ALTER TABLE EMPLOYEES ADD (
  CONSTRAINT EMP_SALARY_MIN
  CHECK (salary > 0)
  ENABLE VALIDATE,
  CONSTRAINT EMP_EMP_ID_PK
  PRIMARY KEY
  (EMPLOYEE_ID)
  USING INDEX EMP_EMP_ID_PK
  ENABLE VALIDATE,
  CONSTRAINT EMP_EMAIL_UK
  UNIQUE (EMAIL)
  USING INDEX EMP_EMAIL_UK
  ENABLE VALIDATE);

ALTER TABLE EMPLOYEES ADD (
  CONSTRAINT EMP_DEPT_FK 
  FOREIGN KEY (DEPARTMENT_ID) 
  REFERENCES DEPARTMENTS (DEPARTMENT_ID)
  ENABLE VALIDATE,
  CONSTRAINT EMP_JOB_FK 
  FOREIGN KEY (JOB_ID) 
  REFERENCES JOBS (JOB_ID)
  ENABLE VALIDATE,
  CONSTRAINT EMP_MANAGER_FK 
  FOREIGN KEY (MANAGER_ID) 
  REFERENCES EMPLOYEES (EMPLOYEE_ID)
  ENABLE VALIDATE);
