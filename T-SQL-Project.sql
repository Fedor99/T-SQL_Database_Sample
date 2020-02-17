/*
DROP TABLE S_T;
DROP TABLE Trainer;
DROP TABLE History_Status;
DROP TABLE Status;
DROP TABLE Registration;
DROP TABLE SwimmingStyle;
DROP TABLE Competition;
DROP TABLE Country;
DROP TABLE Swimmer;
*/


-- tables
-- Table: Competition
CREATE TABLE Competition (
    ID int  NOT NULL,
    Date1 date  NOT NULL,
    Date2 date  NOT NULL,
    Price int  NOT NULL,
    Country_ID int  NOT NULL,
    CONSTRAINT Competition_pk PRIMARY KEY  (ID)
);

-- Table: Country
CREATE TABLE Country (
    ID int  NOT NULL,
    Name varchar(50)  NOT NULL,
    CONSTRAINT Country_pk PRIMARY KEY  (ID)
);

-- Table: History_Status
CREATE TABLE History_Status (
    Registration_ID int  NOT NULL,
    Status_ID int  NOT NULL,
    ID int  NOT NULL,
    Date date  NOT NULL,
    CONSTRAINT History_Status_pk PRIMARY KEY  (ID)
);

-- Table: Registration
CREATE TABLE Registration (
    ID int  NOT NULL,
    Time_From_Competition float(3)  NOT NULL,
    Place int  NULL,
    Swimmer_ID int  NOT NULL,
    SwimmingStyle_ID int  NOT NULL,
    Competition_ID int  NOT NULL,
    PrizeSet bit  NOT NULL,
    CONSTRAINT Registration_pk PRIMARY KEY  (ID)
);

-- Table: S_T
CREATE TABLE S_T (
    ID int  NOT NULL,
    Swimmer_ID int  NOT NULL,
    Trainer_ID int  NOT NULL,
    Sport_Level int  NOT NULL,
    CONSTRAINT S_T_pk PRIMARY KEY  (ID)
);

-- Table: Status
CREATE TABLE Status (
    ID int  NOT NULL,
    Description varchar(50)  NOT NULL,
    CONSTRAINT Status_pk PRIMARY KEY  (ID)
);

-- Table: Swimmer
CREATE TABLE Swimmer (
    ID int  NOT NULL,
    Name varchar(50)  NOT NULL,
    Surname varchar(50)  NOT NULL,
    Prize money  NOT NULL,
    CONSTRAINT Swimmer_pk PRIMARY KEY  (ID)
);

-- Table: SwimmingStyle
CREATE TABLE SwimmingStyle (
    ID int  NOT NULL,
    Style_Name varchar(50)  NOT NULL,
    Specification varchar(50)  NOT NULL,
    CONSTRAINT SwimmingStyle_pk PRIMARY KEY  (ID)
);

-- Table: Trainer
CREATE TABLE Trainer (
    ID int  NOT NULL,
    Name varchar(50)  NOT NULL,
    Surname varchar(50)  NOT NULL,
    Prize money  NOT NULL,
    CONSTRAINT Trainer_pk PRIMARY KEY  (ID)
);

-- foreign keys
-- Reference: Competition_Country (table: Competition)
ALTER TABLE Competition ADD CONSTRAINT Competition_Country
    FOREIGN KEY (Country_ID)
    REFERENCES Country (ID);

-- Reference: History_Status_Registration (table: History_Status)
ALTER TABLE History_Status ADD CONSTRAINT History_Status_Registration
    FOREIGN KEY (Registration_ID)
    REFERENCES Registration (ID);

-- Reference: History_Status_Status (table: History_Status)
ALTER TABLE History_Status ADD CONSTRAINT History_Status_Status
    FOREIGN KEY (Status_ID)
    REFERENCES Status (ID);

-- Reference: Registration_Competition (table: Registration)
ALTER TABLE Registration ADD CONSTRAINT Registration_Competition
    FOREIGN KEY (Competition_ID)
    REFERENCES Competition (ID);

-- Reference: Registration_Swimmer (table: Registration)
ALTER TABLE Registration ADD CONSTRAINT Registration_Swimmer
    FOREIGN KEY (Swimmer_ID)
    REFERENCES Swimmer (ID);

-- Reference: Registration_SwimmingStyle (table: Registration)
ALTER TABLE Registration ADD CONSTRAINT Registration_SwimmingStyle
    FOREIGN KEY (SwimmingStyle_ID)
    REFERENCES SwimmingStyle (ID);

-- Reference: S_T_Swimmer (table: S_T)
ALTER TABLE S_T ADD CONSTRAINT S_T_Swimmer
    FOREIGN KEY (Swimmer_ID)
    REFERENCES Swimmer (ID);

-- Reference: S_T_Trainer (table: S_T)
ALTER TABLE S_T ADD CONSTRAINT S_T_Trainer
    FOREIGN KEY (Trainer_ID)
    REFERENCES Trainer (ID);

-- End of file.





----------------------------------------------------------------------------
--Add data
INSERT INTO Trainer VALUES (1, 'Jason', 'Smith', 0);
INSERT INTO Trainer VALUES (2, 'Miles', 'Adams', 0);
INSERT INTO Trainer VALUES (3, 'Robert', 'Morgan', 0);

INSERT INTO Swimmer VALUES (1, 'Zoe', 'Sanders', 0);
INSERT INTO Swimmer VALUES (2, 'Emily', 'Clark', 0);
INSERT INTO Swimmer VALUES (3, 'Alexander', 'Ross', 0);
INSERT INTO Swimmer VALUES (4, 'Oliver', 'Morris', 0);
INSERT INTO Swimmer VALUES (5, 'Maya', 'Jones', 0);

INSERT INTO S_T VALUES (1, 1, 1, 3);
INSERT INTO S_T VALUES (2, 2, 1, 3);
INSERT INTO S_T VALUES (3, 3, 2, 3);
INSERT INTO S_T VALUES (4, 4, 3, 3);
INSERT INTO S_T VALUES (5, 5, 3, 3);

INSERT INTO SwimmingStyle VALUES (1, 'Crawl', 'Front');
INSERT INTO SwimmingStyle VALUES (2, 'Stroke', 'Back');
INSERT INTO SwimmingStyle VALUES (3, 'Stroke', 'Butterfly');
INSERT INTO SwimmingStyle VALUES (4, 'Freestyle', '-');

INSERT INTO Country VALUES (1, 'Australia');
INSERT INTO Country VALUES (2, 'Brazil');
INSERT INTO Country VALUES (3, 'Spain');
INSERT INTO Country VALUES (4, 'Slovakia');
INSERT INTO Country VALUES (5, 'Morocco');

INSERT INTO Competition VALUES (1, CONVERT(DATE, '10-09-2019', 105), CONVERT(DATE, '01-09-2019', 105), 499.99, 2);
INSERT INTO Competition VALUES (2, CONVERT(DATE, '01-05-2020', 105), CONVERT(DATE, '01-06-2020', 105), 250.00, 2);
INSERT INTO Competition VALUES (3, CONVERT(DATE, '07-06-2020', 105), CONVERT(DATE, '28-06-2019', 105), 190.50, 2);

INSERT INTO Status VALUES (1, 'Planning');
INSERT INTO Status VALUES (2, 'Active');
INSERT INTO Status VALUES (3, 'Closed');

INSERT INTO Registration VALUES (1, 1.35, NULL, 3, 4, 2, 'FALSE');
INSERT INTO Registration VALUES (2, 0.99, NULL, 4, 4, 2, 'FALSE');
INSERT INTO Registration VALUES (3, 3.15, NULL, 5, 1, 1, 'FALSE');
INSERT INTO Registration VALUES (4, 2.46, NULL, 2, 1, 1, 'FALSE');
INSERT INTO Registration VALUES (5, 1.33, NULL, 1, 1, 1, 'FALSE');

INSERT INTO History_Status VALUES (1, 2, 1, CONVERT(DATE, '08-05-2018', 105));
INSERT INTO History_Status VALUES (2, 2, 2, CONVERT(DATE, '01-04-2018', 105));
INSERT INTO History_Status VALUES (3, 2, 3, CONVERT(DATE, '25-03-2018', 105));
INSERT INTO History_Status VALUES (4, 2, 4, CONVERT(DATE, '08-08-2018', 105));
INSERT INTO History_Status VALUES (5, 2, 5, CONVERT(DATE, '02-02-2019', 105));

-----------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------
-- Create Array type---------------------------------------------------------------------------------
CREATE TYPE ARRAY AS TABLE(_index INT, _data INT);

-- 1

CREATE OR ALTER PROCEDURE SetPrize
	@competitionID INT, @prize MONEY, @bestSwimmerID INT OUT, @bestSwimmersTrainer INT OUT
AS
BEGIN
	-- Find the winner --------------------------------------------------------------------
	DECLARE @worstResult FLOAT = (SELECT MAX(r.time_from_competition) FROM Registration r);
	DECLARE @bestSwimmer INT, @bestResult FLOAT = @worstResult;
	DECLARE registrationCur CURSOR 
			FOR SELECT r.ID FROM Registration r
								WHERE r.Competition_ID = @competitionID;
	DECLARE @registrationID INT;
	OPEN registrationCur;
	FETCH NEXT FROM registrationCur INTO @registrationID;
	WHILE @@FETCH_STATUS = 0
	BEGIN
		DECLARE @thisResult FLOAT;
		SET @thisResult = (SELECT r.time_from_competition FROM Registration r WHERE r.ID = @registrationID);

		IF @thisResult < @bestResult
		BEGIN
			SET @bestResult = @thisResult;
			SET @bestSwimmer = (SELECT r.swimmer_ID FROM Registration r WHERE r.ID = @registrationID);
		END;
		FETCH NEXT FROM registrationCur INTO @registrationID;
	END;
	CLOSE registrationCur;
	DEALLOCATE registrationCur;

	IF (SELECT r.PrizeSet FROM Registration r WHERE r.ID = @registrationID) = 'FALSE'
	BEGIN
		SET @bestSwimmerID = @bestSwimmer;
		SET @bestSwimmersTrainer = (SELECT st.Trainer_ID FROM S_T st WHERE st.Swimmer_ID  = @bestSwimmerID);
		PRINT 'BEST TIME in competition number' + CAST(@competitionID AS VARCHAR) + ' : ' + CAST(@bestResult AS VARCHAR);
		PRINT 'Best swimmer: ' + CONVERT(VARCHAR, @bestSwimmerID);
		---------------------------------------------------------------------------------------
		-- Find swimmer`s trainer -------------------------------------------------------------
		DECLARE @trainerID INT;
		SET @trainerID = (SELECT st.Trainer_ID FROM S_T st WHERE st.Swimmer_ID = @bestSwimmerID);
		PRINT 'Trainer: ' + CAST(@trainerID AS VARCHAR);
		---------------------------------------------------------------------------------------

		-- Set Prize ------------------------------------------------------------------------------
		DECLARE @swimmersPrize MONEY = @prize * 0.7;
		DECLARE @trainersPrize MONEY = @prize * 0.3;
		UPDATE Swimmer SET Prize = Prize + @swimmersPrize WHERE ID = @bestSwimmerID;
		UPDATE Trainer SET Prize = Prize + @trainersPrize WHERE ID = @bestSwimmersTrainer;
		UPDATE Registration SET PrizeSet = 'TRUE' WHERE ID = @registrationID;
		PRINT 'Prize Set';
	END;
	ELSE 
	BEGIN
		PRINT 'Prize has already been set'
	END;
END;

-- Test -----------------------------------------------------
BEGIN TRANSACTION
DECLARE @bestSwimmer INT, @bestSwimmersTrainer INT;
EXEC SetPrize 1, 10000, @bestSwimmer OUT, @bestSwimmersTrainer OUT;
PRINT 'Best swimmer: ' + CAST(@bestSwimmer AS VARCHAR) + ', Trainer: ' + CAST(@bestSwimmersTrainer AS VARCHAR);
SELECT* FROM Swimmer;
SELECT * FROM Trainer;
SELECT * FROM Registration;
ROLLBACK TRANSACTION

SELECT * FROM Trainer;
SELECT * FROM Swimmer;
SELECT * FROM Registration;
-------------------------------------------------------------

GO
-- End of task 1. T-SQL ---------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

--2
CREATE OR ALTER TRIGGER AfterInsert
ON Registration
AFTER INSERT
AS
BEGIN  
	DECLARE @swimmerID INT = (SELECT swimmer_ID FROM inserted);
	DECLARE @competitionID INT = (SELECT competition_ID FROM inserted);

	DECLARE @count INT = (SELECT COUNT(0) FROM Registration r, inserted i
										WHERE 
											r.swimmer_ID = i.swimmer_ID
											AND
											r.Competition_ID = i.competition_ID);
	Print 'Count: ' + CAST(@count AS VARCHAR);
	IF @count > 1
	BEGIN
		ROLLBACK TRANSACTION;
		DECLARE @errorMessage VARCHAR(100) = 'Swimmer (ID)' + CAST(@swimmerID AS VARCHAR) + 
						' has already been registered for this competition (ID)' 
						+ CAST(@competitionID AS VARCHAR) + '.';
		RAISERROR (@errorMessage, 1, 1);
	END;
	ELSE
	BEGIN
		DECLARE @successMessage VARCHAR(100) = 'Swimmer (ID)' + CAST(@swimmerID AS VARCHAR) + 
						' registered successfully.';
		Print @successMessage;
	END;
END;

-- Test -----------------------------------------------------
BEGIN TRANSACTION
INSERT INTO Registration VALUES (7, 2.46, NULL, 2, 1, 2, 'FALSE');

SELECT * FROM Registration;
ROLLBACK TRANSACTION
-------------------------------------------------------------

GO

-- End of task 2. T-SQL ---------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

--3
CREATE OR ALTER FUNCTION dbo.GetWinner(@competitionID INT, @excludeSwimmers ARRAY READONLY)
RETURNS INT AS
BEGIN 
	-- In AFTER INSERT Trigger we make sure that there is only one Registration for the same Competition_ID and Swimmer_ID
	DECLARE @swimmerCount INT;
	SET @swimmerCount = (SELECT COUNT(0) FROM Registration WHERE Competition_ID = @competitionID);

	DECLARE @errorMessage VARCHAR(150);
	
	IF NOT EXISTS (SELECT * FROM Registration WHERE Time_From_Competition = null)
	BEGIN
		IF @swimmerCount > 0
		BEGIN
			return (SELECT TOP(1) r.Swimmer_ID
					FROM Registration r
					WHERE
					r.Time_From_Competition = (SELECT MIN(r1.Time_From_Competition)
												FROM Registration r1
												WHERE r1.Swimmer_ID NOT IN (SELECT _data FROM @excludeSwimmers)
												AND 
												r1.Competition_ID = @competitionID));
		END;
		
		SET @errorMessage = 'No swimmers registered for competition number ' + CONVERT(VARCHAR, @competitionID);
		RETURN -1;
	END;

	SET @errorMessage = 'Time_From_Competition is NULL at Registration.ID = ' + 
				CONVERT(VARCHAR, (SELECT ID FROM Registration WHERE Time_From_Competition = null));
	RETURN -1;
END;

GO

--3.1
CREATE OR ALTER PROCEDURE PrintProcedure @text VARCHAR
AS
BEGIN
	Print @text;
END;


-- Test -----------------------------------------------------
-- Exclude Swimmers data
DECLARE @data ARRAY;
-- VALUES (arrayIndex, arrayData)
INSERT INTO @data VALUES (1, 1);

Print 'result: ' + CAST(dbo.GetWinner(1, @data) AS VARCHAR);

SELECT * FROM Swimmer WHERE ID = dbo.GetWinner(1, @data);
-------------------------------------------------------------

GO

SELECT * FROM Registration WHERE Competition_ID = 1;

-- End of task 3. T-SQL ---------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------


-- End of file