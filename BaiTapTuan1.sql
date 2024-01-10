create database SmallWorks
on primary
( name = 'SmallWorksPrimary',
filename = 'T:\LeNguyenDuyKhang\SmallWorks.mdf',
size = 10mb,
filegrowth = 20%,
maxsize = 50mb
),
filegroup SWUserData1
(name = 'SmallWorksData1',
filename = 'T:\LeNguyenDuyKhang\SmallWorksData1.ndf',
size = 10mb,
filegrowth = 20%,
maxsize = 50mb
),
FILEGROUP SWUserData2 
(
NAME = 'SmallWorksData2',
FILENAME = 'T:\LeNguyenDuyKhang\SmallWorksData2.ndf', 
SIZE = 10MB,
FILEGROWTH = 20%, 
MAXSIZE = 50MB
)
LOG ON 
(
NAME = 'SmallWorks_log',
FILENAME = 'T:\LeNguyenDuyKhang\SmallWorks_log.ldf', 
SIZE = 10MB,
FILEGROWTH = 10%, 
MAXSIZE = 20MB
) 



--3.  Dùng SSMS để xem kết quả: Click phải trên tên của CSDL vừa  tạo
--a.  Chọn filegroups, quan sát kết  quả:
--  Có bao nhiêu filegroup, liệt kê tên các filegroup hiện  tại
--  Filegroup mặc định là gì?

--co 3 filegroup va file group mac dinh la primary

--b.  Chọn file, quan sát có bao nhiêu database  file?

--co 4 file tat ca

--4.  Dùng T-SQL tạo thêm một filegroup tên Test1FG1 trong SmallWorks, sau đó add 
--thêm 2 file filedat1.ndf và filedat2.ndf dung lượng 5MB vào filegroup Test1FG1. 
--Dùng SSMS xem kết  quả.
alter database smallworks
add filegroup Test1FG1
alter database SmallWorks
add file (
name = 'filedat1.ndf',
filename ='T:\LeNguyenDuyKhang\filedat1.ndf',
size = 5mb, maxsize = 20mb, filegrowth = 1mb) 
 to filegroup Test1FG1;
 alter database SmallWorks
 add file (
name = 'filedat2.ndf',
filename ='T:\LeNguyenDuyKhang\filedat2.ndf',
size = 5mb, maxsize = 20mb, filegrowth = 1mb) 
 to filegroup Test1FG1;
--5.  Dùng T-SQL tạo thêm một một file thứ cấp  filedat3.ndf  dung lượng 3MB trong 
--filegroup Test1FG1. Sau đó sửa kích thước tập tin này lên 5MB. Dùng SSMS xem 
--kết quả. Dùng T-SQL xóa file thứ cấp filedat3.ndf. Dùng SSMS xem kết  quả

alter database SmallWorks
 add file (
name = 'filedat3.ndf',
filename ='T:\LeNguyenDuyKhang\filedat3.ndf',
size = 3mb, maxsize = 20mb, filegrowth = 1mb) 
 to filegroup Test1FG1;

 alter database smallworks
 modify file (
 name = 'filedat3.ndf',
 size = 5mb
 )

 alter database smallworks
 remove file "filedat3.ndf" 

--6.  Xóa  filegroup  Test1FG1?  Bạn  có  xóa  được  không?  Nếu  không  giải  thích?  Muốn  xóa 
--được bạn phải làm  gì?

alter database smallworks 
remove filegroup Test1FG1

--Khong remove duoc vi no co chua file. phai xoa cac file truoc

--7.  Xem  lại  thuộc  tính  (properties)  của  CSDL  SmallWorks  bằng  cửa  sổ  thuộc  tính 
--properties  và  bằng  thủ  tục  hệ  thống  sp_helpDb,  sp_spaceUsed,  sp_helpFile. 
--Quan sát và cho biết các trang thể hiện thông tin  gì?.

sp_helpDb
exec sp_spaceUsed
exec  sp_helpFile

--8.  Tại cửa sổ properties của CSDL SmallWorks, chọn thuộc tính ReadOnly, sau đó 
--đóng  cửa  sổ  properties.  Quan  sát  màu  sắc  của  CSDL.  Dùng  lệnh  T-SQL  gỡ  bỏ
--thuộc  tính  ReadOnly  và  đặt  thuộc  tính  cho  phép  nhiều  người  sử  dụng  CSDL
--SmallWorks.
alter database smallworks set read_only
alter database smallworks set read_write

--9.  Trong CSDL SmallWorks, tạo 2 bảng mới theo cấu trúc như  sau:
CREATE TABLE dbo.Person 
(
PersonID int NOT NULL, 
FirstName varchar(50) NOT NULL, 
MiddleName varchar(50) NULL, 
LastName varchar(50) NOT NULL, 
EmailAddress nvarchar(50) NULL
) ON SWUserData1
CREATE TABLE dbo.Product 
(
ProductID int NOT NULL, 
ProductName varchar(75) NOT NULL,
ProductNumber nvarchar(25) NOT NULL, 
StandardCost money NOT NULL, 
ListPrice money NOT NULL
) ON SWUserData2
--10.  Chèn dữ liệu vào 2 bảng trên, lấy dữ liệu từ bảng  Person  và bảng  Product  trong 
--AdventureWorks2008  (lưu  ý:  chỉ  rõ  tên  cơ  sở  dữ  liệu  và  lược  đồ),  dùng  lệnh 
--Insert…Select...  Dùng  lệnh  Select *  để  xem  dữ  liệu  trong  2  bảng  Person  và  bảng
--Product  trong SmallWorks.

insert into person(PersonID, FirstName, MiddleName,LastName,EmailAddress)
select BusinessEntityID, p.FirstName, p.MiddleName,p.LastName,p.EmailPromotion 
from AdventureWorks2008R2.Person.Person p

insert into product(ProductID, ProductName, ProductNumber,[StandardCost],ListPrice)
select p.ProductID, p.Name, p.ProductNumber, p.StandardCost, p.ListPrice 
from AdventureWorks2008R2.Production.Product p

--11.  Dùng SSMS, Detach cơ sở dữ liệu SmallWorks ra khỏi phiên làm việc của  SQL.

--12.  Dùng SSMS, Attach cơ sở dữ liệu SmallWorks vào  SQL