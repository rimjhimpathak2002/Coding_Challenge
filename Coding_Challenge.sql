                                               -- Coding Challenge --
-- created Database
create database crime_management

--Schema Creation
CREATE TABLE Crime (
    CrimeID INT PRIMARY KEY,
    IncidentType VARCHAR(255),
    IncidentDate DATE ,
    Location VARCHAR(255),
    Description TEXT,
    Status VARCHAR(20)
);

CREATE TABLE Victim (
    VictimID INT PRIMARY KEY,
    CrimeID INT,
    Name VARCHAR(255),
	Age int,
    ContactInfo VARCHAR(255),
    Injuries VARCHAR(255),
    FOREIGN KEY (CrimeID) REFERENCES Crime(CrimeID)
);

CREATE TABLE Suspect (
    SuspectID INT PRIMARY KEY ,
    CrimeID INT,
    Name VARCHAR(255),
	Age int,
    Description TEXT,
    CriminalHistory TEXT,
    FOREIGN KEY (CrimeID) REFERENCES Crime(CrimeID)
);

-- Insert sample data
INSERT INTO Crime (CrimeID, IncidentType, IncidentDate, Location, Description, Status)
VALUES
 (1, 'Robbery', '2023-09-15', '123 Main St, Cityville', 'Armed robbery at a convenience store', 'Open'),
 (2, 'Homicide', '2023-09-20', '456 Elm St, Townsville', 'Investigation into a murder case', 'Under
Investigation'),
 (3, 'Theft', '2023-09-10', '789 Oak St, Villagetown', 'Shoplifting incident at a mall', 'Closed');

 INSERT INTO Victim (VictimID, CrimeID, Name, Age, ContactInfo, Injuries)
VALUES
 (1, 1, 'John Doe', 45, 'johndoe@example.com', 'Minor injuries'),
 (2, 2, 'Jane Smith', 52, 'janesmith@example.com', 'Deceased'),
 (3, 3, 'Alice Johnson', 36, 'alicejohnson@example.com', 'None');

INSERT INTO Suspect (SuspectID, CrimeID, Name, Age, Description, CriminalHistory)
VALUES
 (1, 1, 'Robber 1', 32,'Armed and masked robber', 'Previous robbery convictions'),
 (2, 2, 'Unknown',54, 'Investigation ongoing', NULL),
 (3, 3, 'Suspect 1',57, 'Shoplifting suspect', 'Prior shoplifting arrests');

 select * from crime 
 select * from victim 
 select * from Suspect



 /* Solve the below queries:
1. Select all open incidents. */
 SELECT *
FROM Crime
WHERE Status = 'Open';

/*2. Find the total number of incidents.*/
SELECT COUNT(*) AS TotalIncidentCount
FROM Crime;

/*3. List all unique incident types.*/  
SELECT DISTINCT IncidentType
FROM Crime;

/*4. Retrieve incidents that occurred between '2023-09-01' and '2023-09-10'.*/
  SELECT *
FROM Crime
WHERE IncidentDate BETWEEN '2023-09-01' AND '2023-09-10';

/*5. List persons involved in incidents in descending order of age.*/ 
select VictimId,name, Age from Victim
union all
select SuspectId,name, Age as age from Suspect
order by age desc

--select * from Crime 
--select * from Suspect 
--select * from Victim


/*6. Find the average age of persons involved in incidents.*/
SELECT AVG(CAST(v.Age AS FLOAT)) AS AverageAge
FROM Victim v
UNION ALL
SELECT AVG(CAST(s.Age AS FLOAT)) AS AverageAge
FROM Suspect s;

/*7. List incident types and their counts, only for open cases.*/
SELECT IncidentType, COUNT(*) AS IncidentCount
FROM Crime
WHERE Status = 'Open'
GROUP BY IncidentType
ORDER BY IncidentCount DESC;

/*8. Find persons with names containing 'Doe'.*/
SELECT Name, PersonType
FROM (
  SELECT v.Name AS Name, 'Victim' AS PersonType
  FROM Victim v
  WHERE v.Name LIKE '%Doe%'
  UNION ALL
  SELECT s.Name AS Name, 'Suspect' AS PersonType
  FROM Suspect s
  WHERE s.Name LIKE '%Doe%'
) AS AllPersons
ORDER BY Name;

/*9. Retrieve the names of persons involved in open cases and closed cases.*/
SELECT PersonName, PersonType, CASE WHEN CrimeStatus = 'Open' THEN 'Open Cases' ELSE 'Closed Cases' END AS CaseStatus
FROM (
  SELECT v.Name AS PersonName, 'Victim' AS PersonType, c.Status AS CrimeStatus
  FROM Victim v
  INNER JOIN Crime c ON v.CrimeID = c.CrimeID
  UNION ALL
  SELECT s.Name AS PersonName, 'Suspect' AS PersonType, c.Status AS CrimeStatus
  FROM Suspect s
  INNER JOIN Crime c ON s.CrimeID = c.CrimeID
) AS AllPersons
ORDER BY PersonName, CaseStatus;

select * from crime 
select * from Victim
select * from Suspect

/*10. List incident types where there are persons aged 30 or 35 involved.*/ 
SELECT IncidentType 
FROM Crime 
WHERE CrimeID IN (
    SELECT CrimeID FROM Victim WHERE Age in(30,35)
    UNION 
    SELECT CrimeID FROM Suspect where Age in (30,35)
);  

--Update age in order to get result
Update Victim 
set Age = 30 
where VictimId = 4

--select * from Victim
--select * from Suspect
--select * from Crime
--Insert into Victim values(5,8,'Cristopher',32,'abs@gmail.com','None')
--Insert into Suspect values(5,5,'Cristopher2',31,'abs11@gmail.com','None')

/*11. Find persons involved in incidents of the same type as 'Robbery'.*/
SELECT s.Name AS PersonName, s.Age
FROM Suspect s
INNER JOIN Crime c ON s.CrimeID = c.CrimeID
WHERE c.IncidentType = 'Robbery'
ORDER BY PersonName;

/*12. List incident types with more than one open case.*/
SELECT c.IncidentType
FROM Crime c
WHERE c.Status = 'Open'
GROUP BY c.IncidentType
HAVING COUNT(*) > 1;

select * from Crime
--Inserted one record
Insert into Crime values(4,'Robbery','2023-05-10','101 main street','shoplifting inclident in hotel','Open')
delete from Crime where CrimeID=4

/*13. List all incidents with suspects whose names also appear as victims in other incidents.*/
select * from Crime 
select * from Victim
select * from Suspect
SELECT c1.CrimeID, c1.IncidentType, c1.IncidentDate, c1.Location
FROM Crime c1
INNER JOIN Suspect s ON c1.CrimeID = s.CrimeID
INNER JOIN Victim v2 ON s.Name = v2.Name  
WHERE c1.CrimeID <> v2.CrimeID; 

Insert into Suspect values(4,4,'Cristopher',32,'None','None')  --Inserted one Record

/*14. Retrieve all incidents along with victim and suspect details.*/
SELECT c.CrimeID, c.IncidentType, c.IncidentDate, c.Location, c.Description, c.Status,
       v.VictimID, v.Name AS VictimName, v.Age, v.ContactInfo, v.Injuries,
       s.SuspectID, s.Name AS SuspectName, s.Age, s.Description AS SuspectDescription, s.CriminalHistory
FROM Crime c
LEFT JOIN Victim v ON c.CrimeID = v.CrimeID  -- Include victims even if not present
LEFT JOIN Suspect s ON c.CrimeID = s.CrimeID  -- Include suspects even if not present;
ORDER BY c.CrimeID;

/*15. Find incidents where the suspect is older than any victim.*/
SELECT c.CrimeID, c.IncidentType, c.IncidentDate, c.Location
FROM Crime c
INNER JOIN Suspect s ON c.CrimeID = s.CrimeID
INNER JOIN Victim v ON c.CrimeID = v.CrimeID
WHERE s.Age > ALL (SELECT v2.Age FROM Victim v2 WHERE v2.CrimeID = c.CrimeID)
GROUP BY c.CrimeID, c.IncidentType, c.IncidentDate, c.Location;

select * from Crime
select * from Suspect 
select * from Victim

/*16. Find suspects involved in multiple incidents:*/  
SELECT s.Name AS SuspectName, s.Age, COUNT(*) AS IncidentCount
FROM Suspect s
INNER JOIN Crime c ON s.CrimeID = c.CrimeID
GROUP BY s.SuspectID, s.Name, s.Age
HAVING COUNT(*) > 1;

/*17. List incidents with no suspects involved.*/
SELECT c.CrimeID, c.IncidentType, c.IncidentDate, c.Location
FROM Crime c
LEFT JOIN Suspect s ON c.CrimeID = s.CrimeID
WHERE s.SuspectID is NULL;

select * from Suspect
/*18. List all cases where at least one incident is of type 'Homicide' and all other incidents are of type
'Robbery'.*/

SELECT c.CrimeID
FROM Crime c
GROUP BY c.CrimeID
HAVING SUM(CASE WHEN c.IncidentType = 'Homicide' THEN 1 ELSE 0 END) > 0
  AND SUM(CASE WHEN c.IncidentType = 'Robbery' THEN 1 ELSE 0 END) = (COUNT(*) - 1);


/*19. Retrieve a list of all incidents and the associated suspects, showing suspects for each incident, or
'No Suspect' if there are none.*/
SELECT c.CrimeID, c.IncidentType, c.IncidentDate, c.Location, s.[Name] AS SuspectName, s.Age
FROM Crime c
LEFT JOIN Suspect s ON c.CrimeID = s.CrimeID
ORDER BY c.CrimeID, s.SuspectID;

/*20. List all suspects who have been involved in incidents with incident types 'Robbery' or 'Assault */
SELECT s.Name AS SuspectName, s.Age
FROM Suspect s
INNER JOIN Crime c ON s.CrimeID = c.CrimeID
WHERE c.IncidentType IN ('Robbery', 'Assault');
