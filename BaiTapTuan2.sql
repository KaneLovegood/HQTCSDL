
--1)  Liệt kê danh sách các hóa đơn (SalesOrderID) lập trong tháng  6  năm 2008  có 
--tổng tiền >70000, thông tin gồm SalesOrderID, Orderdate,  SubTotal,  trong đó 
--SubTotal  =SUM(OrderQty*UnitPrice).
select oh.SalesOrderID, Orderdate,sum(OrderQty*UnitPrice) as SubTotal
from Sales.SalesOrderDetail od join 
Sales.SalesOrderHeader oh on od.SalesOrderID = oh.SalesOrderID
where month(OrderDate) = 6 and year(OrderDate) = 2008
group by oh.SalesOrderID, Orderdate
having sum(OrderQty*UnitPrice) > 70000
--2)  Đếm tổng số khách hàng và tổng tiền của những khách hàng thuộc các quốc gia 
--có  mã  vùng  là  US  (lấy  thông  tin  từ  các  bảng  Sales.SalesTerritory, 
--Sales.Customer,  Sales.SalesOrderHeader,  Sales.SalesOrderDetail).  Thông  tin 
--bao  gồm  TerritoryID,  tổng  số  khách  hàng  (CountOfCust),  tổng  tiền 
--(SubTotal) với  SubTotal = SUM(OrderQty*UnitPrice)
select st.TerritoryID, count(c.CustomerID) as countOfCus,  SUM(OrderQty*UnitPrice) as subTotal
from Sales.SalesOrderDetail od join Sales.SalesOrderHeader oh on (od.SalesOrderID = oh.SalesOrderID)
join Sales.Customer c on (c.CustomerID = oh.CustomerID) 
join Sales.SalesTerritory st on (st.TerritoryID = c.TerritoryID)
where st.CountryRegionCode like 'US'
group by  st.TerritoryID
order by st.TerritoryID 


--3)  Tính  tổng  trị  giá  của  những  hóa  đơn  với  Mã  theo  dõi  giao  hàng
--(CarrierTrackingNumber)  có  3  ký  tự  đầu  là  4BD,  thông  tin  bao  gồm 
--SalesOrderID, CarrierTrackingNumber,  SubTotal=SUM(OrderQty*UnitPrice)
select od.SalesOrderID, CarrierTrackingNumber, SUM(OrderQty*UnitPrice) as subTotal
from Sales.SalesOrderDetail od 
join Sales.SalesOrderHeader oh on od.SalesOrderID = oh.SalesOrderID
where CarrierTrackingNumber like '4BD%'
group by od.SalesOrderID, CarrierTrackingNumber
--4)  Liệt  kê  các  sản  phẩm  (Product)  có  đơn  giá  (UnitPrice)<25  và  số  lượng  bán 
--trung bình >5, thông tin gồm ProductID, Name,  AverageOfQty.

select p.ProductID, Name, avg(OrderQty) as averageOfQty
from Production.Product p join Sales.SalesOrderDetail od on (p.ProductID = od.ProductID)
where UnitPrice <25 
group by p.ProductID, name
having avg(OrderQty) > 5

--5)  Liệt kê các công việc (JobTitle) có tổng số nhân viên >20 người, thông tin gồm 
--JobTitle,  C ountOfPerson=Count(*)

select e.JobTitle, count(*) as countOfPerson
from HumanResources.Employee e
group by e.JobTitle
having count(*) > 20
--6)  Tính tổng số lượng và tổng trị giá của các sản phẩm do các nhà cung cấp có tên 
--kết  thúc  bằng  ‘Bicycles’  và  tổng  trị  giá  >  800000,  thông  tin  gồm 
--BusinessEntityID, Vendor_Name, ProductID, SumOfQty,  SubTotal
--(sử dụng các bảng [Purchasing].[Vendor] , [Purchasing].[PurchaseOrderHeader] và 
--[Purchasing].[PurchaseOrderDetail])
select BusinessEntityID,v.Name as Vendor_Name, ProductID,
sum(pod.OrderQty) as SumOfQty,SUM(OrderQty*UnitPrice) as subTotal 
from Purchasing.PurchaseOrderDetail pod join Purchasing.PurchaseOrderHeader poh on (pod.PurchaseOrderID = poh.PurchaseOrderID)
join Purchasing.Vendor v on (v.BusinessEntityID = poh.VendorID)
where v.Name like '%Bicycles' 
group by BusinessEntityID,v.Name, ProductID
having SUM(OrderQty*UnitPrice) >800000
--7)  Liệt kê các sản phẩm có trên 500 đơn đặt hàng trong quí 1 năm 2008 và có tổng 
--trị giá >10000, thông tin gồm ProductID, Product_Name, CountOfOrderID và 
--SubTotal
select p.ProductID, p.Name as Product_Name, count(od.SalesOrderID) as CountOfOrderID,SUM(OrderQty*UnitPrice) as subTotal
from Production.Product p join Sales.SalesOrderDetail od on (p.ProductID = od.ProductID) join Sales.SalesOrderHeader oh 
on (oh.SalesOrderID = od.SalesOrderID)
where datepart(QUARTER,oh.OrderDate) = 1 and YEAR(oh.OrderDate) = 2008
group by p.ProductID, p.Name
having count(od.SalesOrderID) > 500 and SUM(OrderQty*UnitPrice) >10000


--8)  Liệt kê danh sách các khách hàng có trên 25 hóa đơn đặt hàng từ năm 2007 đến 
--2008, thông tin gồm mã khách (PersonID) , họ tên (FirstName +'   '+ LastName 
--as FullName), Số hóa đơn  (CountOfOrders).
select c.PersonID, (p.FirstName +' '+ p.LastName) as Full_Name, count(oh.SalesOrderID) as CountOfOrders
from Sales.Customer c join Sales.SalesOrderHeader oh on c.CustomerID = oh.CustomerID join Person.Person p on p.BusinessEntityID = c.PersonID
where oh.SalesOrderID > 25 and year(oh.OrderDate) >= 2007 and year(oh.OrderDate) <= 2008
group by c.PersonID,p.FirstName, p.LastName


--9)  Liệt kê những sản phẩm có tên bắt đầu với ‘Bike’ và ‘Sport’ có tổng số lượng 
--bán  trong  mỗi  năm  trên  500  sản  phẩm,  thông  tin  gồm  ProductID,  Name, 
--CountOfOrderQty,  Year.  (Dữ  liệu  lấy  từ  các  bảng  Sales.SalesOrderHeader, 
--Sales.SalesOrderDetail  và Production.Product)
select p.ProductID, p.Name, COUNT(od.OrderQty) as CountOfOrderQty, year(oh.OrderDate) 
from Sales.SalesOrderDetail od 
join Sales.SalesOrderHeader oh on od.SalesOrderID = oh.SalesOrderID 
join Production.Product p on p.ProductID = od.ProductID
where p.name like 'Bike%' or p.name like 'Sport%' 
group by p.ProductID, p.Name,oh.OrderDate
having COUNT(od.OrderQty) > 500
--10)  Liệt kê những phòng ban có lương (Rate: lương theo giờ) trung bình >30, thông 
--tin  gồm  Mã  phòng  ban  (DepartmentID),  tên  phòng  ban  (Name),  Lương  trung
--bình (AvgofRate).  Dữ  liệu  từ  các  bảng
--[HumanResources].[Department], 
--[HumanResources].[EmployeeDepartmentHistory], 
--[HumanResources].[EmployeePayHistory].
--II)  Subquery 
--1)  Liệt kê các sản phẩm  gồm các thông tin  Product  Names  và  Product ID  có 
--trên 100 đơn đặt hàng trong tháng 7 năm  2008
--2)  Liệt  kê  các  sản  phẩm  (ProductID,  Name)  có  số  hóa  đơn  đặt  hàng  nhiều  nhất
--trong tháng  7/2008
--3)  Hiển thị thông tin của khách hàng có số đơn đặt hàng nhiều nhất, thông tin gồm: 
--CustomerID, Name,  CountOfOrder
--4)  Liệt kê các sản phẩm (ProductID, Name) thuộc mô hình sản phẩm áo dài tay với 
--tên bắt đầu với “Long-Sleeve Logo Jersey”, dùng phép IN và EXISTS, (sử dụng 
--bảng Production.Product và  Production.ProductModel) 
--Bài tập Thực hành  Hệ Quản Trị Cơ sở Dữ Liệu
---  11-5)  Tìm các  mô hình  sản phẩm (ProductModelID)  mà giá niêm  yết (list price) tối
--đa cao hơn giá trung bình của tất cả các mô  hình.
--6)  Liệt kê các sản phẩm gồm các thông tin ProductID, Name, có tổng số lượng 
--đặt hàng > 5000 (dùng IN,  EXISTS)
--7)  Liệt kê những sản phẩm (ProductID, UnitPrice) có đơn giá (UnitPrice) cao 
--nhất trong bảng  Sales.SalesOrderDetail
--8)  Liệt kê các sản  phẩm không có đơn đặt hàng nào thông tin gồm ProductID, 
--Nam; dùng 3 cách Not in, Not exists và Left  join.
--9)  Liệt kê các nhân viên không lập hóa đơn từ sau ngày 1/5/2008, thông tin gồm 
--EmployeeID,  FirstName,  LastName  (dữ  liệu  từ  2  bảng 
--HumanResources.Employees và Sales.SalesOrdersHeader)
--10)  Liệt  kê  danh  sách  các  khách  hàng  (CustomerID,  Name)  có  hóa  đơn  dặt  hàng
--trong năm 2007 nhưng không có hóa đơn đặt hàng trong năm  2008  