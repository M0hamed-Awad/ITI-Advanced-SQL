Use ITI
-- (1). Create a scalar function that takes date and returns Month name of that date.
Go
Create Function getMonthName(@dateParam Date)
Returns varchar(15)
Begin
	Declare @monthName varchar(15)
	Set @monthName = FORMAT(@dateParam, 'MMMM')
	Return @monthName
End

Go
Select dbo.getMonthName(getDate())

-----------------------------------------------------------------------------------------------------

-- (2). Create a multi-statements table-valued function that takes 2 integers and returns the values between them.
Go
Create Function getValuesBetween(@firstNumber int, @secondNumber int)
Returns @Range Table(number int)
As
Begin
	Declare @start int = @firstNumber + 1
	While @start < @secondNumber
	Begin
		Insert Into @Range
		Values(@start)
		Set @start = @start + 1
	End
	Return
End

Go
Select * From getValuesBetween(0, 6)

-----------------------------------------------------------------------------------------------------

-- (3). Create inline function that takes Student No and returns Department Name with Student full name.
Go
Create Function getDepartmentNameAndStudentName(@st_id int)
Returns Table
As
Return
(
	Select d.Dept_Name As [Department Name], CONCAT(s.St_Fname, ' ', s.St_Lname) As [Student Full Name]
	From Department d
	Join Student s
		On d.Dept_Id = s.Dept_Id
	Where s.St_Id = @st_id
)

Go
Select * From getDepartmentNameAndStudentName(7)

-----------------------------------------------------------------------------------------------------

-- (4).	Create a scalar function that takes Student ID and returns a message to user 
Go
Create Function getStudentNameMessage(@st_id int)
Returns varchar(40)
As
Begin
	Declare @msg varchar(40)
	Select @msg =
		Case
			--[a]. If first name and Last name are null then display 'First name & last name are null'
			When s.St_Fname IS NULL AND s.St_Lname IS NULL
				Then 'First name & last name are null'
			--[b]. If First name is null then display 'first name is null'
			When s.St_Fname IS NULL
				Then 'first name is null'
			--[c]. If Last name is null then display 'last name is null'
			When s.St_Lname IS NULL
				Then 'last name is null'
			--[d]. Else display 'First name & last name are not null'
			Else 'First name & last name are not null'
		End
	From Student s
	Where s.St_Id = @st_id

	If @msg IS NULL
		Set @msg = 'Student not found'
	Return @msg
End

Go
Select dbo.getStudentNameMessage(1)
Select dbo.getStudentNameMessage(13)
Select dbo.getStudentNameMessage(14)
Select dbo.getStudentNameMessage(15)

-----------------------------------------------------------------------------------------------------

-- (5).	Create inline function that takes integer which represents manager ID and displays department name, Manager Name and hiring date 
Go
Create Function getManagerInfo(@manager_id int)
Returns Table
As
Return
(
	Select d.Dept_Name As [Department Name], i.Ins_Name As [Manager Name], d.Manager_hiredate As [Hiring Date]
	From Instructor i
	Join Department d
		On i.Ins_Id = d.Dept_Manager
	Where d.Dept_Manager = @manager_id
)

Go
Select * From getManagerInfo(9)

-----------------------------------------------------------------------------------------------------

-- (6).	Create multi-statements table-valued function that takes a string
Go
Create Function getStudentName(@msg varchar(20))
Returns @StudentName Table (student_name varchar(50))
As
Begin
	Insert Into @StudentName
	Select 
	Case
		-- If string='first name' returns student first name
		When @msg = 'first name'
			Then ISNULL(s.St_Fname, '(No Data)')
		-- If string='last name' returns student last name 
		When @msg = 'last name'
			Then ISNULL(s.St_Lname, '(No Data)')
		-- If string='full name' returns Full Name from student table 
		When @msg = 'full name'
			Then CONCAT_WS(' ', ISNULL(s.St_Fname, '(No Data)'), ISNULL(s.St_Lname, '(No Data)'))
	End
	From Student s
	Return
End

Go
-- Get first names
SELECT * FROM getStudentName('first name');

-- Get last names
SELECT * FROM getStudentName('last name');

-- Get full names
SELECT * FROM getStudentName('full name');

-----------------------------------------------------------------------------------------------------

-- (7).	Write a query that returns the Student No and Student first name without the last char
Select s.St_Id As [Student No], 
	SUBSTRING(s.St_Lname, 1, LEN(s.St_Lname) - 1) As [First Name Without Last Character]
From Student s

-----------------------------------------------------------------------------------------------------

-- (8).	Wirte query to delete all grades for the students Located in SD Department
Delete sc
From Stud_Course sc
Join Student s
	On s.St_Id =sc.St_Id
Join Department d
	On d.Dept_Id = s.Dept_Id
Where d.Dept_Name = 'SD'

-- ================================================================================================ --

-- (1) Give an example for hierarchyid Data type

Create Table StudentHierarchy
(
    St_Id int PRIMARY KEY,
    St_Name varchar(50),
    St_Hierarchy hierarchyid
);

-- Root node
Insert Into StudentHierarchy(St_Id, St_Name, St_Hierarchy)
Values (1, 'Alice', hierarchyid::GetRoot());

-- Child node
Insert Into StudentHierarchy(St_Id, St_Name, St_Hierarchy)
Values (2, 'Bob', hierarchyid::GetRoot().GetDescendant(NULL, NULL));

Select St_Id, St_Name, St_Hierarchy.ToString() AS HierarchyPath
From StudentHierarchy;

-----------------------------------------------------------------------------------------------------

-- (2).	Create a batch that inserts 3000 rows in the student table(ITI database). 
-- The values of the st_id column should be unique and between 3000 and 6000. 
-- All values of the columns st_fname, st_lname, should be set to 'Jane', ' Smith' respectively.

Go
Declare @start int = 3001
While @start <= 6000
Begin
	Insert Into Student(St_Id, St_Fname, St_Lname)
	Values(@start, 'Jane', ' Smith')
	Set @start = @start + 1
End
