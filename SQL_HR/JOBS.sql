CREATE TABLE JOBS
(
  JOB_ID      VARCHAR2(10 BYTE),
  JOB_TITLE   VARCHAR2(35 BYTE) CONSTRAINT JOB_TITLE_NN NOT NULL,
  MIN_SALARY  NUMBER(6),
  MAX_SALARY  NUMBER(6)
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

COMMENT ON TABLE JOBS IS 'jobs table with job titles and salary ranges. Contains 19 rows.
References with employees and job_history table.';

COMMENT ON COLUMN JOBS.JOB_ID IS 'Primary key of jobs table.';

COMMENT ON COLUMN JOBS.JOB_TITLE IS 'A not null column that shows job title, e.g. AD_VP, FI_ACCOUNTANT';

COMMENT ON COLUMN JOBS.MIN_SALARY IS 'Minimum salary for a job title.';

COMMENT ON COLUMN JOBS.MAX_SALARY IS 'Maximum salary for a job title';



CREATE UNIQUE INDEX JOB_ID_PK ON JOBS
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


ALTER TABLE JOBS ADD (
  CONSTRAINT JOB_ID_PK
  PRIMARY KEY
  (JOB_ID)
  USING INDEX JOB_ID_PK
  ENABLE VALIDATE);
