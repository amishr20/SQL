
--1.
 -- The following query fetches the vendor name that sells 'Walnut' at a price less than 14 units.

--2. 

--3. 
	select distinct Vendor_name
	 from (select RM.Material_ID, S.Vendor_ID from Raw_Materials_t as RM, Supplies_t as S  
							where RM.Material_ID=S.Material_ID and Material_description = 'Walnut' and S.Unit_price<14) as T1, Vendor_t as T2
							where T1.Vendor_ID=T2.Vendor_ID 
--4.
 select Order_ID
from (select Order_ID, O1.Product_ID, Product_Name 
  from Order_line_t O1, Product_t P1
  where O1.Product_ID=P1.Product_ID and Product_Name in ('End Table','Coffee Table')) as Temp
  group by Order_ID 
  having count(Temp.Product_ID)>=2 


  select Order_ID 
  from Order_line_t O1, Product_t P1
  where O1.Product_ID=P1.Product_ID and Product_Name='End Table'
  intersect
  select Order_ID 
  from Order_line_t O1, Product_t P1
  where O1.Product_ID=P1.Product_ID and Product_Name='Coffee Table'

--5. 
select R.Material_ID, R.Material_description, V.Vendor_ID, Vendor_name, S.Unit_price
from (select Temp.*, row_number() over (partition by Temp.material_ID order by Temp.material_ID, Temp.Unit_price) as Ranking
from Supplies_t as Temp) as S, Raw_Materials_t as R, Vendor_t as V
where S.Material_ID=R.Material_ID and S.Vendor_ID=V.Vendor_ID and S.Ranking in (1,2)
order by R.Material_ID, S.Unit_price

 --Compose an SQL statement to generate a list of two least expensive vendors (suppliers) for each raw material

select S1.Material_ID
from Supplies_t as S1
where S1.Unit_price IN (select Top 2 Unit_price 
       from Supplies_t as S2 
	   where S2.Material_ID=S1.Material_ID
	   order by Unit_price desc)

