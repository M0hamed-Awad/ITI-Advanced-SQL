Use SD 

------ [1] ------
-- Created By Wizard with 2 File Groups
-- { SeconderyFG (has two data files) and ThirdFG (has two data files) } 

-- (1).

create table Department
(
	DeptNo INT NOT NULL PRIMARY KEY IDENTITY,
	DeptName varchar(50),
	Location varchar(20)
)

GO
CREATE DEFAULT def_loc AS 'NY';

GO
sp_addtype loc, 'nchar(2)';

GO
CREATE RULE loc_rule
AS @loc IN ('NY','DS','KW');

GO
sp_bindefault def_loc, 'loc';

GO
sp_bindrule loc_rule, 'loc';

ALTER TABLE Department
ALTER COLUMN Location loc;

INSERT INTO Department (DeptName, Location)
VALUES 
('Research', 'NY'),
('Accounting', 'DS'),
('Markiting', 'KW');

--------------------------------------------------------------------------------

-- (2).

create table Employee
(
	EmpNo INT NOT NULL,
	EmpFname varchar(25) NOT NULL,
	EmpLname varchar(25) NOT NULL,
	DeptNo INT,
	Salary INT,
	CONSTRAINT PK_Employee PRIMARY KEY (EmpNo),
	CONSTRAINT FK_Employee_Department  FOREIGN KEY(DeptNo) 
		REFERENCES Department(DeptNo),
	CONSTRAINT UQ_Employee_Salary UNIQUE (Salary),
)

Go
CREATE RULE sal_rule
AS @x < 6000;

Go
sp_bindrule sal_rule, 'Employee.Salary';

INSERT INTO Employee (EmpNo, EmpFname, EmpLname, DeptNo, Salary)
VALUES
(25348, 'Mathew', 'Smith', 3, 2500),
(10102, 'Ann', 'Jones', 3, 3000),
(18316, 'John', 'Barrimore', 1, 2400),
(29346, 'James', 'James', 2, 2800),
(9031,  'Lisa', 'Bertoni', 2, 4000),
(2581,  'Elisa', 'Hansel', 2, 3600),
(28559, 'Sybl', 'Moser', 1, 2900);


--------------------------------------------------------------------------------

-- (3).
-- This Table is Created by Wizard:
-- ProjectName can't contain null values
-- Budget allow null

Go
INSERT INTO Project(ProjectName, Budget)
VALUES
('Apollo', 120000),
('Gemini', 95000),
('Mercury', 185600)

--------------------------------------------------------------------------------

-- (4).
-- This Table is Created by Wizard:
-- EmpNo INTEGER NOT NULL
-- ProjectNo doesn't accept null values
-- Job can accept null
-- Enter_Date can’t accept null and has the current system date as a default value[visually]
-- The primary key will be EmpNo,ProjectNo) 
-- There is a relation between works_on and employee, Project  tables

GO
INSERT INTO Works_on (EmpNo, ProjectNo, Job, Enter_Date)
VALUES
(10102, 1, 'Analyst', '2006-10-01'),
(10102, 3, 'Manager', '2012-01-01'),
(25348, 2, 'Clerk', '2007-02-15'),
(18316, 2, NULL, '2007-06-01'),
(29346, 2, NULL, '2006-12-15'),
(2581, 3, 'Analyst', '2007-10-15'),
(9031, 1, 'Manager', '2007-04-15'),
(28559, 1, NULL, '2007-08-01'),
(28559, 2, 'Clerk', '2012-02-01'),
(9031, 3, 'Clerk', '2006-11-15'),
(29346, 1, 'Clerk', '2007-01-04');

--------------------------------------------------------------------------------

-- (5).

---------- Testing Referential Integrity ----------

-- 1- Add new employee with EmpNo =11111 In the works_on table [what will happen]
INSERT INTO Works_on (EmpNo, ProjectNo, Job, Enter_Date)
VALUES (11111, 1, 'Analyst', '2025-12-21');
-- 11111 does not exist in Employee

-- 2- Change the employee number 10102  to 11111  in the works on table [what will happen]
UPDATE Works_on
	SET EmpNo = 11111
WHERE EmpNo = 10102;
-- 11111 does not exist in Employee

-- 3- Modify the employee number 10102 in the employee table to 22222. [what will happen]
UPDATE Human_Resource.Employee
	SET EmpNo = 22222
WHERE EmpNo = 10102;
-- Employee is referenced in Works_on so we cannot change the PK

-- 4-Delete the employee with id 10102
DELETE FROM Human_Resource.Employee
WHERE EmpNo = 10102;
-- Employee is referenced in Works_on

---------- Table modification ----------

-- (6).

-- 1- Add  TelephoneNumber column to the employee table[programmatically]
ALTER TABLE Human_Resource.Employee
ADD TelephoneNumber VARCHAR(15) NULL;

-- 2- drop this column[programmatically]
ALTER TABLE Human_Resource.Employee
DROP COLUMN TelephoneNumber;

-- 3-Bulid A diagram to show Relations between tables

--------------------------------------------------------------------------------

---------- (2).	Create the following schema and transfer the following tables to it ----------

---- [a]. Company Schema ----
GO
create schema Company

-- i.	Department table (Programmatically)
GO
alter schema Company transfer Department

-- ii.	Project table (using wizard) --

---- [b]. Human Resource Schema ----
Go
create schema Human_Resource

-- i. Employee table (Programmatically) --
alter schema Human_Resource transfer Employee

--------------------------------------------------------------------------------

---------- (3). Write query to display the constraints for the Employee table. ----------
Go
sp_helpconstraint 'Human_Resource.Employee'

--------------------------------------------------------------------------------

---------- (4). Create Synonym for table Employee as Emp and then run the ----------
---------- following queries and describe the results ----------

Create Synonym Emp 
for Human_Resource.Employee

----- [a] -----
Select * from Employee
-- no Table named Employee in the dbo Schema

----- [b] -----
Select * from Human_Resource.Employee

----- [c] -----
Select * from Emp

----- [c] -----
Select * from Human_Resource.Emp
-- Synonyms do not belong to schemas

--------------------------------------------------------------------------------

---------- (5). Increase the budget of the project where the manager number is 10102 by 10%.

Go
Update p
	Set Budget = Budget * 1.10
From Company.Project p
Join Works_On w
	On p.ProjectNo = w.ProjectNo
Where w.EmpNo = 10102 AND w.Job = 'Manager'

--------------------------------------------------------------------------------

---------- (6).	Change the name of the department for which the employee ----------
--------------- named James works.The new department name is Sales. ---------------

Go
Update d
	Set d.DeptName = 'Sales'
From Company.Department d
Join Human_Resource.Employee e
	On d.DeptNo = e.DeptNo
Where e.EmpLname = 'James'

--------------------------------------------------------------------------------

---------- (7). Change the enter date for the projects for those employees who work
----------  in project p1 and belong to department ‘Sales’. The new date is 12.12.2007.

Go
Update w
	Set w.Enter_Date = '12.12.2007'
From Works_On w
Join Human_Resource.Employee e
	On e.EmpNo = w.EmpNo
Join Company.Department d
	On d.DeptNo = e.DeptNo
Where w.ProjectNo = 1 AND d.DeptName = 'Sales'

--------------------------------------------------------------------------------

---------- (8). Delete the information in the works_on table  ----------
---------- for all employees who work for the department located in KW. ----------

Delete w
From Works_On w
Join Human_Resource.Employee e
	On e.EmpNo = w.EmpNo
Join Company.Department d
	On d.DeptNo = e.DeptNo
Where d.Location = 'KW'

--------------------------------------------------------------------------------

-- (9).	Try to Create Login Named(ITIStud) who can access Only student and Course tablesfrom ITI DB 
-- then allow him to select and insert data into tables and deny Delete and update .(Use ITI DB)
-- Done Using the Wizard