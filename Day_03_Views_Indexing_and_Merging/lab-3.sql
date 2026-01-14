--------------- Part 1 ---------------

Use ITI

-- (1). Create a view that displays student full name, course name if the student has a grade more than 50. 
Go
Create View vStudentNameAndCourseName
As
	Select CONCAT_WS(' ', s.St_Fname, s.St_Lname) As [Student Full Name], c.Crs_Name As [Course Name]
	From Student s
	Join Stud_Course sc
		On s.St_Id = sc.St_Id
	Join Course c
		On c.Crs_Id = sc.Crs_Id
	Where sc.Grade > 50

Go
Select * From vStudentNameAndCourseName

-- (2). Create an Encrypted view that displays manager names and the topics they teach.
Go
Create View vManagerNameAndTopics([Manager Name], [Teached Topics])
With Encryption
As
	Select i.Ins_Name, t.Top_Name
	From Department d
	Join Instructor i
		On i.Ins_Id = d.Dept_Manager
	Join Ins_Course ic
		On i.Ins_Id = ic.Ins_Id
	Join Course c
		On c.Crs_Id = ic.Crs_Id
	Join Topic t
		On t.Top_Id = c.Top_Id

Go
Select * From vManagerNameAndTopics

-- (3). Create a view that will display Instructor Name, Department Name for the ‘SD’ or ‘Java’ Department 
Go
Create View vSDJavaInstuctors([Instructor Name], [Department Name])
As
	Select i.Ins_Name, d.Dept_Name
	From Instructor i
	Join Department d
		On d.Dept_Id = i.Dept_Id
	Where d.Dept_Name IN ('SD', 'Java')

Go
Select * From vSDJavaInstuctors

-- (4). Create a view “V1” that displays student data for student who lives in Alex or Cairo.
-- Note: Prevent the users to run the following query 
-- Update V1 set st_address=’tanta’
-- Where st_address=’alex’;
Go
Create View V1
As
	Select *
	From Student 
	Where St_Address IN ('Alex', 'Cairo')
	With Check Option

Go
Select * From V1

Go
Update V1 
	Set st_address='tanta'
Where st_address='alex'

-- (5). Create a view that will display the project name and the number of employees work on it. “Use SD database”
GO
Use Company_SD

Go
Create View vProjectEmployeesCount([Project Name], [Number of Employees])
As
	Select p.Pname, Count(w.ESSn) 
	From Project p
	Join Works_for w
		On p.Pnumber = w.Pno
	Group By p.Pname

Go
Select * From vProjectEmployeesCount

-- (6). Create index on column (Hiredate) that allow u to cluster the data in table Department. What will happen?
Go
Create Clustered Index iDepartment_Hiredate
On Departments([MGRStart Date])
-- Error -- We CANNOT have more than 1 Clustered Index per Table + Department does NOT have the (Hiredate) column 

Go
Create NonClustered Index iDepartment_Hiredate
On Departments([MGRStart Date])
-- We can have Multiple Nonclustered Indexes 

-- (7).	Create index that allow u to enter unique ages in student table. What will happen? 
Go
Use ITI

Go
Create Unique Index iAge
On Student(st_age)
-- Applied on the previous values ===> So Error

-- (8).	Using Merge statement between the following two tables 

CREATE TABLE Daily_Transactions (
    UserID INT PRIMARY KEY,
    Transaction_Amount INT
);

CREATE TABLE Last_Transactions (
    UserID INT PRIMARY KEY,
    Transaction_Amount INT
);

INSERT INTO Last_Transactions (UserID, Transaction_Amount)
VALUES 
(1, 100),
(3, 300);

Merge Into Last_Transactions As Target
Using Daily_Transactions As Source
On (Target.UserID = Source.UserID)
	-- 1. If UserID exists in both, update
	When Matched Then
		Update 
			Set Target.Transaction_Amount = Source.Transaction_Amount

	-- 2. If UserID is in Source but not Target, Insert itc
	When NOT Matched By Target Then
		Insert (UserID, Transaction_Amount)
		Values (Source.UserID, Source.Transaction_Amount)

	-- 3. If ID is in Target but NOT in Source, Delete it
	When NOT Matched By Source Then
		DELETE;

-- ============================================================================================= --

--------------- Part 2 ---------------
Go
Use SD_DB

-- (1).	Create view named   “v_clerk” that will display employee#,project#, 
------- the date of hiring of all the jobs of the type 'Clerk'.

Go
Create View v_clerk([Empolyee#], [Project#], [Hiring Date])
As
	Select	w.EmpNo, w.ProjectNo, w.Enter_Date
	From Works_On w
	Where w.Job = 'Clerk'

Select * From vClerk

-- (2).	Create view named  “v_without_budget” that will display all the projects data without budget

Create View vWithoutBudget
As
	Select p.ProjectName, p.ProjectNo
	From Company.Project p

Select * From vWithoutBudget

-- (3).	Create view named  “v_count “ that will display the project name and the # of jobs in it

Create View vCount
As
	Select p.ProjectName As [Project Name], COUNT(w.Job) As [Number Of Jobs]
	From Company.Project p
	Join Works_On w
		On p.ProjectNo = w.ProjectNo
	Group By p.ProjectName

Select * From vCount

-- (4).	Create view named ” v_project_p2” that will display the emp#  for the project# ‘p2’
------- use the previously created view  “v_clerk”

Create View vProjectP2
As
	Select vc.Empolyee#, vc.Project#
	From vClerk vc
	where vc.Project# = 2

Select * From vProjectP2

-- (5).	modifey the view named  “v_without_budget”  to display all DATA in project p1 and p2 

Alter View vWithoutBudget
As
	Select *
	From Company.Project p
	Where p.ProjectNo IN(1, 2)

Select * From vWithoutBudget

-- (6).	Delete the views  “v_ clerk” and “v_count”

Drop View vClerk
Drop View vCount


-- (7).	Create view that will display the emp# and emp lastname who works on dept# is ‘d2’

Create View vDepartment2Employees([Emp#], [Employee Lastname])
As
	Select e.EmpNo As [Emp#], e.EmpLname As [Employee Lastname]
	From Human_Resource.Employee e
	Where e.DeptNo = 2

Select * From vDepartment2Employees

-- (8).	Display the employee  lastname that contains letter “J” 
------- Use the previous view created in Q#7

Select vd2.Emp#, vd2.EmployeeLastname As [Employee Lastname]
From vDepartment2Employees vd2
Where vd2.EmployeeLastname Like '%J%'

-- (9).	Create view named “v_dept” that will display the department# and department name.

Create View vDepartment([Department#], [Department Name])
As
	Select d.DeptNo As [Department#], d.DeptName As [Department Name]
	From Company.Department d

Select * From vDepartment


-- (10). Using the previous view try enter new department data where dept# is ’d4’ and dept name is ‘Development’

-- Select * From Company.Department

Insert Into vDepartment
Values('Development')

-- (11). Create view name “v_2006_check” that will display employee#, the project #where he works 
------ and the date of joining the project which must be from the first of January and the last of December 2006.

Alter View v2006Check([Employee#], [Project#])
As
	Select e.EmpNo As [Employee#], p.ProjectNo As [Project#]
	From Company.Project p
	Join Works_On w
		On p.ProjectNo = w.ProjectNo
	Join Human_Resource.Employee e
		On e.EmpNo = w.EmpNo

	Where w.Enter_Date Between '2006-01-01' AND '2006-12-31' -- Year(w.Enter_Date) = 2006

Select * From v2006Check