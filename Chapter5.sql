--1. Find names of sailors who’ve reserved boat #103
select S.sname,S.sid
from Sailors as S
Join Reserves as R
on S.sid = R.sid
where R.bid=103;

	SELECT S.sname
	FROM     Sailors S, Reserves R
	WHERE S.sid=R.sid AND R.bid=103

--2. Find names of sailors who’ve reserved a red boat
select *
From Sailors as S
Join Reserves as R
on S.sid = R.sid
where ( R.bid IN ( select B.bid
from Boats as B
where B.color = 'red'))

select *
From Boats as B
join Reserves as R
on B.bid=R.bid
join Sailors as S
on S.sid = R.sid
where B.color='red'

select * 
from (select * 
from Boats
where color='red') B, Reserves R, Sailors S
where B.bid = R.bid and R.sid = S.sid
 



--3. Find sailors who’ve reserved a red or a green boat
select *
from Boats as B
join Reserves as R
on B.bid = R.bid
join Sailors as S
on S.sid = R.sid
where b.color = 'red' or b.color='green'

select * 
from (select * from Boats where color='red' or color='green') B, Reserves R, Sailors S
where B.bid = R.bid and R.sid = S.sid

SELECT S.sid
FROM Sailors S, Boats B, Reserves R
WHERE  S.sid=R.sid AND R.bid=B.bid
AND (B.color='red' OR B.color='green')

SELECT S.sid
FROM  Sailors S, Boats B, Reserves R
WHERE S.sid=R.sid AND R.bid=B.bid
AND B.color='red'
except     ------- union (intersect for red AND green)
SELECT S.sid
FROM  Sailors S, Boats B, Reserves R
WHERE S.sid=R.sid AND R.bid=B.bid
AND B.color='green'

    ----------------- rewrite intersect using IN
select *
from (select S.sid
from Sailors S, Reserves R, Boats B
where S.sid=R.sid and R.bid=B.bid and B.color='red' ) RedOwners
where RedOwners.sid IN (select S.sid    ----- How do you use exists??
from Sailors S, Reserves R, Boats B
where S.sid=R.sid and R.bid=B.bid and B.color='green')

--4. Find the names of sailors who’ve reserved all boats
select S.sname
from Sailors S
where not exists
			(select B.bid from Boats B
			except
			select R.bid from Reserves R
			where R.sid = S.sid
			)
			
SELECT S.sname
FROM Sailors S
WHERE  NOT EXISTS  (SELECT B.bid
					FROM Boats B 
					WHERE  NOT EXISTS  (SELECT R.bid
										FROM Reserves R
										WHERE R.bid=B.bid
										AND R.sid=S.sid))


--5. Find sailors who’ve reserved at least one boat
Select distinct R.sid, S.sname
from Reserves R
join Sailors S 
on R.sid = S.sid

--6.Find name and age of the oldest sailor(s)
select S.sname
from Sailors S 
where S.age = (Select MAX(S.age) from Sailors S)

--7. Find the age of the youngest sailor for each rating level.
select S.rating, S.sname, min(S.age) as age
from Sailors S 
Group by S.rating,s.sname
having COUNT (*)>0

--8. Find the age of the youngest sailor with age >= 18, for each rating with at least 2 such sailors
SELECT S.rating,  MIN (S.age)
FROM Sailors S
WHERE  S.age >= 18
GROUP BY  S.rating
HAVING COUNT (*) > 1

SELECT S.rating,  MIN (S.age)
FROM Sailors S
WHERE S.age > 18
GROUP BY  S.rating
HAVING 1  <  (SELECT  COUNT (*)
FROM Sailors S2
WHERE S.rating=S2.rating)

select * from Sailors

--9 For each red boat, find the number of reservations for this boat
select B.bid, count(*) 
from Boats B, Reserves R
where B.bid=R.bid
group by B.bid 

SELECT B.bid,  COUNT (*) AS scount
FROM Sailors S, Boats B, Reserves R
WHERE  S.sid=R.sid AND R.bid=B.bid AND B.color='red'
GROUP BY  B.bid

SELECT B.bid,  COUNT (*) AS scount
FROM Boats B, Reserves R
WHERE  R.bid=B.bid AND B.color='red'
GROUP BY  B.bid

--10. Find the age of the youngest sailor with age > 18, for each rating with at least 2 sailors (of any age)

---------------------------------------------------
SELECT S.age, age1=S.age-5, 2*S.age AS age2
FROM Sailors S
WHERE S.sname LIKE 'H%'

/*----------------------------------------------------*/
SELECT S.sname, S.age, age1=S.age-5, 2*S.age AS age2
FROM Sailors S
WHERE S.sname LIKE 'H__________%O' 

select age,a.rating from (Select count(age)x,rating
from Sailors 
group by rating
having count(age) <= 1) a,(select * from sailors) b
where a.rating = b.rating

select * from Sailors

Select rating, age
from Sailors S1
where age in
(
  select top 1 S2.age
  From Sailors as S2
  Where S1.rating = S2.rating
  order by age asc)
  order by s1.rating

SELECT B.bid,  COUNT (*) AS scount
FROM Sailors S, Boats B, Reserves R
WHERE  S.sid=R.sid AND R.bid=B.bid AND B.color='red'
GROUP BY  B.bid

/* What is wrong with the code below??*/
SELECT B.bid, b.color, COUNT (*) AS scount
FROM Sailors S, Boats B, Reserves R
WHERE  S.sid=R.sid AND R.bid=B.bid 
GROUP BY  B.bid, b.color
Having B.color='red'

/* error !! Get correct from common table syntax expressions */ 
SELECT Temp.rating, Temp.avgage
FROM (SELECT S.rating, AVG (S.age) AS avgage
FROM Sailors S
GROUP BY  S.rating) AS Temp
WHERE Temp.avgage = (SELECT  MIN (Temp.avgage)
FROM Temp)

WITH TEMP (rating, avgage) AS
(
SELECT S.rating, AVG(S.age) AS avgage
FROM Sailors S
GROUP BY S.rating
)
SELECT TEMP.rating, TEMP.avgage
FROM TEMP
WHERE TEMP.avgage =
(SELECT MIN(TEMP.avgage)
FROM TEMP
)

select *
from Sailors
where rating>0

 -- When to use division ? 
 --Find sailors who have reserved all boats ?
 -- [A(X,Y) / B(Y)] Ch5_SQL Division slide

 -- Top 'n' per group ?
 -- For each sailor, what are the latest two reservations
 -- Here our group is sailors. In assgn 2 it is material_ID
 select * 
 from Reserves R1
 where R1.day in (select top 2 R2.day
				  from Reserves R2
				  where R1.sid=R2.sid )

-- Making the query ore efficient !!
 select * 
 from Reserves R1
 where R1.day in (select top 2 R2.day
				  from Reserves R2
				  where R1.sid=R2.sid 
				  order by R2.day desc)