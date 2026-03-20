USE DrilllogDB;
GO

/*
  Seed data for major tables (except Employee).
  Assumes Employee rows already exist for SSN:
  1101, 1102, 1103, 1104, 1105
*/

-- Quarry (5 rows)
IF NOT EXISTS (SELECT 1 FROM dbo.Quarry WHERE Name = 'North Ridge')
INSERT INTO dbo.Quarry (Name, Location, Company, RockType, AnnualProduction)
VALUES ('North Ridge', 'Reno, NV', 'GraniteWorks', 'Granite', 120000);

IF NOT EXISTS (SELECT 1 FROM dbo.Quarry WHERE Name = 'Silver Basin')
INSERT INTO dbo.Quarry (Name, Location, Company, RockType, AnnualProduction)
VALUES ('Silver Basin', 'Boise, ID', 'StoneCore', 'Limestone', 98000);

IF NOT EXISTS (SELECT 1 FROM dbo.Quarry WHERE Name = 'Red Canyon')
INSERT INTO dbo.Quarry (Name, Location, Company, RockType, AnnualProduction)
VALUES ('Red Canyon', 'Moab, UT', 'GeoMinerals', 'Sandstone', 88000);

IF NOT EXISTS (SELECT 1 FROM dbo.Quarry WHERE Name = 'Pine Valley')
INSERT INTO dbo.Quarry (Name, Location, Company, RockType, AnnualProduction)
VALUES ('Pine Valley', 'Bend, OR', 'TerraRock', 'Basalt', 110000);

IF NOT EXISTS (SELECT 1 FROM dbo.Quarry WHERE Name = 'Eagle Peak')
INSERT INTO dbo.Quarry (Name, Location, Company, RockType, AnnualProduction)
VALUES ('Eagle Peak', 'Helena, MT', 'Rockline', 'Dolomite', 76000);

-- Drill (5 rows)
IF NOT EXISTS (SELECT 1 FROM dbo.Drill WHERE MachineId = 2001)
INSERT INTO dbo.Drill (MachineId, Manufacture, ModelType, Age, TotalHours, Rebuilts)
VALUES (2001, 'Atlas Copco', 'ROC D7', 6, 4200, 1);

IF NOT EXISTS (SELECT 1 FROM dbo.Drill WHERE MachineId = 2002)
INSERT INTO dbo.Drill (MachineId, Manufacture, ModelType, Age, TotalHours, Rebuilts)
VALUES (2002, 'Sandvik', 'DI550', 4, 3100, 0);

IF NOT EXISTS (SELECT 1 FROM dbo.Drill WHERE MachineId = 2003)
INSERT INTO dbo.Drill (MachineId, Manufacture, ModelType, Age, TotalHours, Rebuilts)
VALUES (2003, 'Epiroc', 'SmartROC T45', 3, 2700, 0);

IF NOT EXISTS (SELECT 1 FROM dbo.Drill WHERE MachineId = 2004)
INSERT INTO dbo.Drill (MachineId, Manufacture, ModelType, Age, TotalHours, Rebuilts)
VALUES (2004, 'Furukawa', 'HCR1200', 8, 5600, 2);

IF NOT EXISTS (SELECT 1 FROM dbo.Drill WHERE MachineId = 2005)
INSERT INTO dbo.Drill (MachineId, Manufacture, ModelType, Age, TotalHours, Rebuilts)
VALUES (2005, 'Komatsu', 'ZR950', 5, 3900, 1);

-- DrillLog (5 rows, depends on Employee + Quarry)
IF NOT EXISTS (SELECT 1 FROM dbo.DrillLog WHERE ShotID = 3001)
INSERT INTO dbo.DrillLog (ShotID, TimeBegan, TimeLastSaved, TimeSubmitted, DrillerSSN, QuarryName)
VALUES (3001, '2026-03-19T06:30:00', '2026-03-19T07:15:00', '2026-03-19T08:00:00', 1101, 'North Ridge');

IF NOT EXISTS (SELECT 1 FROM dbo.DrillLog WHERE ShotID = 3002)
INSERT INTO dbo.DrillLog (ShotID, TimeBegan, TimeLastSaved, TimeSubmitted, DrillerSSN, QuarryName)
VALUES (3002, '2026-03-19T08:30:00', '2026-03-19T09:00:00', '2026-03-19T09:40:00', 1102, 'Silver Basin');

IF NOT EXISTS (SELECT 1 FROM dbo.DrillLog WHERE ShotID = 3003)
INSERT INTO dbo.DrillLog (ShotID, TimeBegan, TimeLastSaved, TimeSubmitted, DrillerSSN, QuarryName)
VALUES (3003, '2026-03-19T10:00:00', '2026-03-19T10:35:00', '2026-03-19T11:10:00', 1103, 'Red Canyon');

IF NOT EXISTS (SELECT 1 FROM dbo.DrillLog WHERE ShotID = 3004)
INSERT INTO dbo.DrillLog (ShotID, TimeBegan, TimeLastSaved, TimeSubmitted, DrillerSSN, QuarryName)
VALUES (3004, '2026-03-19T11:30:00', '2026-03-19T12:05:00', '2026-03-19T12:45:00', 1104, 'Pine Valley');

IF NOT EXISTS (SELECT 1 FROM dbo.DrillLog WHERE ShotID = 3005)
INSERT INTO dbo.DrillLog (ShotID, TimeBegan, TimeLastSaved, TimeSubmitted, DrillerSSN, QuarryName)
VALUES (3005, '2026-03-19T13:00:00', '2026-03-19T13:30:00', '2026-03-19T14:15:00', 1105, 'Eagle Peak');

-- DrillPattern (5 rows)
IF NOT EXISTS (SELECT 1 FROM dbo.DrillPattern WHERE PatternId = 4001)
INSERT INTO dbo.DrillPattern
  (PatternId, ShotNo, HoleDiameter, Burden, Spacing, FaceHeight, SubDrill, ShotType, NoHoles, DesignDate, ShotDate, BlasterSSN, ShotId)
VALUES
  (4001, 101, 6.5, 12.0, 14.0, 38.0, 2.0, 'Production', 28, '2026-03-18T15:00:00', '2026-03-19T08:15:00', 1103, 3001);

IF NOT EXISTS (SELECT 1 FROM dbo.DrillPattern WHERE PatternId = 4002)
INSERT INTO dbo.DrillPattern
  (PatternId, ShotNo, HoleDiameter, Burden, Spacing, FaceHeight, SubDrill, ShotType, NoHoles, DesignDate, ShotDate, BlasterSSN, ShotId)
VALUES
  (4002, 102, 6.0, 11.5, 13.5, 36.0, 1.8, 'Buffer', 24, '2026-03-18T16:00:00', '2026-03-19T09:45:00', 1103, 3002);

IF NOT EXISTS (SELECT 1 FROM dbo.DrillPattern WHERE PatternId = 4003)
INSERT INTO dbo.DrillPattern
  (PatternId, ShotNo, HoleDiameter, Burden, Spacing, FaceHeight, SubDrill, ShotType, NoHoles, DesignDate, ShotDate, BlasterSSN, ShotId)
VALUES
  (4003, 103, 6.25, 12.5, 14.5, 40.0, 2.2, 'Production', 30, '2026-03-18T17:00:00', '2026-03-19T11:15:00', 1103, 3003);

IF NOT EXISTS (SELECT 1 FROM dbo.DrillPattern WHERE PatternId = 4004)
INSERT INTO dbo.DrillPattern
  (PatternId, ShotNo, HoleDiameter, Burden, Spacing, FaceHeight, SubDrill, ShotType, NoHoles, DesignDate, ShotDate, BlasterSSN, ShotId)
VALUES
  (4004, 104, 6.75, 13.0, 15.0, 42.0, 2.4, 'Trim', 26, '2026-03-18T18:00:00', '2026-03-19T12:50:00', 1103, 3004);

IF NOT EXISTS (SELECT 1 FROM dbo.DrillPattern WHERE PatternId = 4005)
INSERT INTO dbo.DrillPattern
  (PatternId, ShotNo, HoleDiameter, Burden, Spacing, FaceHeight, SubDrill, ShotType, NoHoles, DesignDate, ShotDate, BlasterSSN, ShotId)
VALUES
  (4005, 105, 6.5, 12.2, 14.2, 39.0, 2.1, 'Production', 27, '2026-03-18T19:00:00', '2026-03-19T14:20:00', 1103, 3005);

-- DrillHole (5 rows, depends on Drill + DrillLog)
IF NOT EXISTS (SELECT 1 FROM dbo.DrillHole WHERE HoleId = 5001)
INSERT INTO dbo.DrillHole
  (HoleId, HoleNo, Easting, Northing, Elevation, Degrees, BrokenMaterial, CompetentRock, TotalDepth, WaterDepth, Notes, StartTime, EndTime, MachineID, ShotID)
VALUES
  (5001, 1, 1200.5, 3400.8, 865.2, 90, 12.0, 25.0, 37.0, 3, 'Normal penetration', '2026-03-19T06:45:00', '2026-03-19T07:20:00', 2001, 3001);

IF NOT EXISTS (SELECT 1 FROM dbo.DrillHole WHERE HoleId = 5002)
INSERT INTO dbo.DrillHole
  (HoleId, HoleNo, Easting, Northing, Elevation, Degrees, BrokenMaterial, CompetentRock, TotalDepth, WaterDepth, Notes, StartTime, EndTime, MachineID, ShotID)
VALUES
  (5002, 2, 1210.1, 3412.3, 866.0, 88, 10.5, 24.0, 34.5, 2, 'Slight deviation corrected', '2026-03-19T08:40:00', '2026-03-19T09:10:00', 2002, 3002);

IF NOT EXISTS (SELECT 1 FROM dbo.DrillHole WHERE HoleId = 5003)
INSERT INTO dbo.DrillHole
  (HoleId, HoleNo, Easting, Northing, Elevation, Degrees, BrokenMaterial, CompetentRock, TotalDepth, WaterDepth, Notes, StartTime, EndTime, MachineID, ShotID)
VALUES
  (5003, 3, 1222.7, 3425.9, 867.1, 92, 11.8, 26.0, 37.8, 4, 'Water inflow observed', '2026-03-19T10:05:00', '2026-03-19T10:42:00', 2003, 3003);

IF NOT EXISTS (SELECT 1 FROM dbo.DrillHole WHERE HoleId = 5004)
INSERT INTO dbo.DrillHole
  (HoleId, HoleNo, Easting, Northing, Elevation, Degrees, BrokenMaterial, CompetentRock, TotalDepth, WaterDepth, Notes, StartTime, EndTime, MachineID, ShotID)
VALUES
  (5004, 4, 1231.4, 3436.2, 868.4, 87, 12.3, 27.0, 39.3, 1, 'Hard band near bottom', '2026-03-19T11:40:00', '2026-03-19T12:18:00', 2004, 3004);

IF NOT EXISTS (SELECT 1 FROM dbo.DrillHole WHERE HoleId = 5005)
INSERT INTO dbo.DrillHole
  (HoleId, HoleNo, Easting, Northing, Elevation, Degrees, BrokenMaterial, CompetentRock, TotalDepth, WaterDepth, Notes, StartTime, EndTime, MachineID, ShotID)
VALUES
  (5005, 5, 1240.2, 3448.0, 869.0, 90, 11.0, 25.5, 36.5, 2, 'Completed as designed', '2026-03-19T13:10:00', '2026-03-19T13:48:00', 2005, 3005);

-- Drilling (5 rows; current schema PK is SSN only)
IF NOT EXISTS (SELECT 1 FROM dbo.Drilling WHERE SSN = 1101)
INSERT INTO dbo.Drilling (SSN, MachineId, [Date], Duration)
VALUES (1101, 2001, '2026-03-19T07:30:00', 2.5);

IF NOT EXISTS (SELECT 1 FROM dbo.Drilling WHERE SSN = 1102)
INSERT INTO dbo.Drilling (SSN, MachineId, [Date], Duration)
VALUES (1102, 2002, '2026-03-19T09:20:00', 2.0);

IF NOT EXISTS (SELECT 1 FROM dbo.Drilling WHERE SSN = 1103)
INSERT INTO dbo.Drilling (SSN, MachineId, [Date], Duration)
VALUES (1103, 2003, '2026-03-19T10:50:00', 2.8);

IF NOT EXISTS (SELECT 1 FROM dbo.Drilling WHERE SSN = 1104)
INSERT INTO dbo.Drilling (SSN, MachineId, [Date], Duration)
VALUES (1104, 2004, '2026-03-19T12:25:00', 2.2);

IF NOT EXISTS (SELECT 1 FROM dbo.Drilling WHERE SSN = 1105)
INSERT INTO dbo.Drilling (SSN, MachineId, [Date], Duration)
VALUES (1105, 2005, '2026-03-19T13:55:00', 2.4);

-- Quick verification
SELECT 'Employee' AS TableName, COUNT(*) AS RowsCount FROM dbo.Employee
UNION ALL SELECT 'Quarry', COUNT(*) FROM dbo.Quarry
UNION ALL SELECT 'Drill', COUNT(*) FROM dbo.Drill
UNION ALL SELECT 'DrillLog', COUNT(*) FROM dbo.DrillLog
UNION ALL SELECT 'DrillPattern', COUNT(*) FROM dbo.DrillPattern
UNION ALL SELECT 'DrillHole', COUNT(*) FROM dbo.DrillHole
UNION ALL SELECT 'Drilling', COUNT(*) FROM dbo.Drilling;
GO
