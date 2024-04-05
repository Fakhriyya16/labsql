
create table Countries(
	[Id] int primary key identity(1,1),
	[Name] nvarchar(100),
	[Population] int,
	[Area] int
)

create table Author(
	[Id] int primary key identity(1,1),
	[FullName] nvarchar(100),
	[Age] int
)


create table Users(
	[Id] int primary key identity(1,1),
	[FullName] nvarchar(100),
	[Age] int
)

create table Cities(
	[Id] int primary key identity(1,1),
	[Name] nvarchar(50),
	[CountryId] int,
	[Population] int,
	[Area] int
	foreign key ([CountryId]) references Countries
)

create table Streets(
	[Id] int primary key identity(1,1),
	[Name] nvarchar(100),
	[CityId] int
	foreign key ([CityId]) references Cities
)

create table Libraries(
	[Id] int primary key identity(1,1),
	[Name] nvarchar(100),
	[StreetId] int,
	[MaxBookCount] int
	foreign key ([StreetId]) references Streets
)

create table Books(
	[Id] int primary key identity(1,1),
	[Name] nvarchar(100),
	[Price] int,
	[Count] int,
	[AuthorId] int,
	[LibraryId] int
	foreign key ([AuthorId]) references Authors,
	foreign key ([LibraryId]) references Libraries
)

create table UserBooks(
	[Id] int primary key identity(1,1),
	[UserId] int,
	[BookId] int
	foreign key ([UserId]) references Users,
	foreign key ([BookId]) references Books
)

--adding data to tables

insert into Countries([Name],[Population],[Area])
values  ('Azerbaijan',10000000,86600),
		('Turkey',84980000,783562),
		('Netherlands',17700000,41850),
		('Italy',58940000,302073)

insert into Countries([Name],[Population],[Area])
values ('Italy',58940000,302073)

insert into Cities([Name],[CountryId],[Population],[Area])
values  ('Baku',1,2236000,2200),
		('Istanbul',2,15460000,5461),
		('Amsterdam',3,821752,220)


insert into Cities([Name],[CountryId],[Population],[Area])
values ('Rome',4,2873000,1285)

create procedure usp_createAuthor
@Fullname nvarchar(100),
@Age int
as
begin
	insert into Authors([FullName],[Age])
	values (@Fullname,@Age)
end

exec usp_createAuthor 'Robert Green',64

select * from Authors

create procedure usp_createStreet
@Name nvarchar(100),
@CityId int
as
begin
	insert into Streets([Name],[CityId])
	values (@Name,@CityId)
end

exec usp_createStreet 'Via Veneto',4

select * from Streets

create procedure usp_createLibrary
@Name nvarchar(100),
@StreetId int,
@MaxBookCount int
as
begin
	insert into Libraries([Name],[StreetId],[MaxBookCount])
	values (@Name,@StreetId,@MaxBookCount)
end

exec usp_createLibrary 'Biblioteca Angelica',8,4500

select * from Libraries

create procedure usp_createBook
@Name nvarchar(100),
@Price int,
@Count int,
@AuthorId int,
@LibraryId int
as
begin
	insert into Books([Name],[Price],[Count],[AuthorId],[LibraryId])
	values (@Name,@Price,@Count,@AuthorId,@LibraryId)
end

exec usp_createBook 'Mastery',18,13,5,2

select * from Books

create procedure usp_createUser
@FulName nvarchar(100),
@Age int
as
begin
	insert into Users([FullName],[Age])
	values  (@FulName,@Age)
end

exec usp_createUser 'Hacixan Hacixanov',19

select * from Users
select * from Books

create procedure usp_createUserBooks
@UserId int,
@BookId int
as
begin
	 insert into UserBooks([UserId],[BookId])
	 values (@UserId,@BookId)
end

exec usp_createUserBooks 1,2


create view BookLibraryView
as
select b.Id,b.[Name] 'Book Name',b.[Count],b.Price, a.[FullName] 'Author Name',a.[Age], l.Name 'Library Name', s.Name + ',' + c.Name + ',' + ctr.Name 'Location'
from Books b
join Authors a on b.AuthorId = a.Id
join Libraries l on b.LibraryId = l.Id
join Streets s on l.StreetId = s.Id
join Cities c on s.CityId = c.Id
join Countries ctr on c.CountryId = ctr.Id

select * from BookLibraryView