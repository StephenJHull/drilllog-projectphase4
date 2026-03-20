CREATE TABLE [dbo].[Drilling]
(
	[SSN] INT NOT NULL , 
    [MachineId] INT NOT NULL, 
    [Date] DATETIME2 NOT NULL, 
    [Duration] DECIMAL NOT NULL, 
    PRIMARY KEY ([SSN])
)
