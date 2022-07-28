CREATE DATABASE Social

USE Social



CREATE TABLE Users
(
Id INT PRIMARY KEY IDENTITY,
Login NVARCHAR(100) NOT NULL UNIQUE,
Password nvarchar(100) NOT NULL,
Mail nvarchar(100) NOT NULL UNIQUE
)

create table People
(
Id INT PRIMARY KEY IDENTITY,
Name NVARCHAR(25) NOT NULL,
Surname NVARCHAR(30) NOT NULL,
Age INT NOT NULL,
userId INT REFERENCES Users(Id)
)

CREATE TABLE Post
(
Id INT PRIMARY KEY IDENTITY,
userId INT REFERENCES Users(Id),
Content NVARCHAR(500),
LikeCountPost INT,
ShareDate DATETIME DEFAULT GETDATE(),
isDeleted BIT NOT NULL DEFAULT 0
)


CREATE TABLE Comments
(
Id INT PRIMARY KEY IDENTITY,
PostId INT REFERENCES Post(Id),
userId INT REFERENCES Users(Id),
likeCountComment INT,
isDeleted BIT NOT NULL DEFAULT 0
)

SELECT * FROM Users

INSERT INTO Users VALUES
('orxan01',123456,'orxan@mail.com'),
('seymur01',123456,'seymur@mail.com'),
('islam01',123456,'islam@mail.com'),
('taleh01',123456,'taleh@mail.com')

SELECT * FROM People

INSERT INTO People VALUES
('Orxan','Hesenli',29,1),
('Seymur','Salmanov',25,2),
('Taleh','Musayev',34,4),
('Islam','Tagizade',16,3)

SELECT * FROM Post

INSERT INTO Post (userId,Content,LikeCountPost) 
VALUES
(1,'example...1',5),
(1,'example...2',10),
(4,'example...5',12)

SELECT * FROM Comments

INSERT INTO Comments (PostId,userId,likeCountComment)
VALUES
(1,2,6),(3,3,7),(2,4,10)

--Postlara gələn comment sayların göstərin (Group by)
SELECT Post.Id,COUNT(Comments.PostId) as 'Comment Count' FROM Users
JOIN Post
ON Post.userId = Users.Id
JOIN Comments
ON Post.Id = Comments.PostId
JOIN People 
ON People.userId = Users.Id
GROUP BY Post.Id

SELECT * FROM Users
JOIN Post
ON Post.userId = Users.Id
JOIN Comments
ON Post.Id = Comments.PostId
JOIN People 
ON People.userId = Users.Id

--butun datalar
CREATE VIEW FullDataView
as
SELECT CONCAT(People.Name, ' ', People.Surname) as Fullname, Users.Id as 'user ID',Users.Login,
Post.Content,Post.LikeCountPost as 'Like Count',Post.ShareDate,Comments.userId,Comments.likeCountComment as 'like comment'
FROM Users
JOIN Post
ON Post.userId = Users.Id
JOIN Comments
ON Post.Id = Comments.PostId
JOIN People 
ON People.userId = Users.Id

select * from Comments
select * from Post

--rey ve paylasimi silen zaman boolean deyerin deyisilmesi

CREATE TRIGGER UpdatedInsteadOfDelete
ON Post
INSTEAD OF DELETE
AS
BEGIN
DECLARE @Id INT
SELECT @Id = Id FROM deleted
UPDATE Post SET isDeleted = 1 WHERE Id = @Id
END

DELETE Post
WHERE Id = 2


-- post table-deki id-ni daxil eden zaman uygun olan likepost artmasi
CREATE PROCEDURE usp_LikePost (@PostId INT)
AS
BEGIN
UPDATE Post
SET LikeCountPost = LikeCountPost + 1
WHERE Post.Id = @PostId
END

EXEC usp_LikePost @PostId = 1


--daxil edilen logine gore passwordun deisdirilmesi
CREATE PROCEDURE usp_ResetPasswords (@Login NVARCHAR(100), @Password NVARCHAR(100))
AS
BEGIN
UPDATE Users
SET Users.Password = @Password
WHERE Users.Login = @Login
END

EXEC usp_ResetPasswords seymur01, '654321'



