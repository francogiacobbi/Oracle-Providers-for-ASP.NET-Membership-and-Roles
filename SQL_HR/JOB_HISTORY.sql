
CREATE TABLE JOB_HISTORY
(
  EMPLOYEE_ID    NUMBER(6) CONSTRAINT JHIST_EMPLOYEE_NN NOT NULL,
  START_DATE     DATE CONSTRAINT JHIST_START_DATE_NN NOT NULL,
  END_DATE       DATE CONSTRAINT JHIST_END_DATE_NN NOT NULL,
  JOB_ID         VARCHAR2(10 BYTE) CONSTRAINT JHIST_JOB_NN NOT NULL,
  DEPARTMENT_ID  NUMBER(4)
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

COMMENT ON TABLE JOB_HISTORY IS 'Table that stores job history of the employees. If an employee
changes departments within the job or changes jobs within the department,
new rows get inserted into this table with old job information of the
employee. Contains a complex primary key: employee_id+start_date.
Contains 25 rows. References with jobs, employees, and departments tables.';

COMMENT ON COLUMN JOB_HISTORY.EMPLOYEE_ID IS 'A not null column in the complex primary key employee_id+start_date.
Foreign key to employee_id column of the employee table';

COMMENT ON COLUMN JOB_HISTORY.START_DATE IS 'A not null column in the complex primary key employee_id+start_date.
Must be less than the end_date of the job_history table. (enforced by
constraint jhist_date_interval)';

COMMENT ON COLUMN JOB_HISTORY.END_DATE IS 'Last day of the employee in this job role. A not null column. Must be
greater than the start_date of the job_history table.
(enforced by constraint jhist_date_interval)';

COMMENT ON COLUMN JOB_HISTORY.JOB_ID IS 'Job role in which the employee worked in the past; foreign key to
job_id column in the jobs table. A not null column.';

COMMENT ON COLUMN JOB_HISTORY.DEPARTMENT_ID IS 'Department id in which the employee worked in the past; foreign key to deparment_id column in the departments table';



CREATE INDEX JHIST_DEPARTMENT_IX ON JOB_HISTORY
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


CREATE UNIQUE INDEX JHIST_EMP_ID_ST_DATE_PK ON JOB_HISTORY
(EMPLOYEE_ID, START_DATE)
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


CREATE INDEX JHIST_EMPLOYEE_IX ON JOB_HISTORY
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


CREATE INDEX JHIST_JOB_IX ON JOB_HISTORY
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


ALTER TABLE JOB_HISTORY ADD (
  CONSTRAINT JHIST_DATE_INTERVAL
  CHECK (end_date > start_date)
  ENABLE VALIDATE,
  CONSTRAINT JHIST_EMP_ID_ST_DATE_PK
  PRIMARY KEY
  (EMPLOYEE_ID, START_DATE)
  USING INDEX JHIST_EMP_ID_ST_DATE_PK
  ENABLE VALIDATE);

ALTER TABLE JOB_HISTORY ADD (
  CONSTRAINT JHIST_DEPT_FK 
  FOREIGN KEY (DEPARTMENT_ID) 
  REFERENCES DEPARTMENTS (DEPARTMENT_ID)
  ENABLE VALIDATE,
  CONSTRAINT JHIST_EMP_FK 
  FOREIGN KEY (EMPLOYEE_ID) 
  REFERENCES EMPLOYEES (EMPLOYEE_ID)
  ENABLE VALIDATE,
  CONSTRAINT JHIST_JOB_FK 
  FOREIGN KEY (JOB_ID) 
  REFERENCES JOBS (JOB_ID)
  ENABLE VALIDATE);
