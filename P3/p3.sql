CREATE DATABASE P3
GO
Use P3
GO


--1. Create All Tables & 2. Create 3+ Check Constraints


-- Title Table
CREATE TABLE Title (
    Title_ID INT IDENTITY(1,1) PRIMARY KEY,
    Title_Name VARCHAR(100) NOT NULL UNIQUE,
    Title_Description TEXT NOT NULL
);


-- Player Table
CREATE TABLE Player (
    Player_ID INT IDENTITY(1,1) PRIMARY KEY,
    Player_Name VARCHAR(255) NOT NULL,
    Player_Email VARCHAR(255) NOT NULL UNIQUE,
    Player_Password VARCHAR(255) NOT NULL,
    Mode1_highest INT DEFAULT 0,
    Mode2_highest INT DEFAULT 0,
    Mode1_trial_count INT DEFAULT 0 CHECK (Mode1_trial_count <= 3),
    Title_ID_activated INT,
    FOREIGN KEY (Title_ID_activated) REFERENCES Title(Title_ID)
);

-- Friend Table
CREATE TABLE Friend (
    Player_ID INT NOT NULL,
    Friend_ID INT NOT NULL,
    PRIMARY KEY (Player_ID, Friend_ID),
    FOREIGN KEY (Player_ID) REFERENCES Player(Player_ID),
    FOREIGN KEY (Friend_ID) REFERENCES Player(Player_ID),
    CHECK (Player_ID <> Friend_ID)  -- Prevent a player from being friends with themselves
);

-- Pet Table
CREATE TABLE Pet (
    Pet_ID INT IDENTITY(1,1) PRIMARY KEY,
    Pet_image VARCHAR(255) NOT NULL, -- UUID for the pet image
    Rarity INT CHECK (Rarity >= 1 AND Rarity <= 5),
    GenderType VARCHAR(50) CHECK (GenderType IN ('Male', 'Female', 'Unknown'))
);

-- Player_pet Table
CREATE TABLE Player_pet (
    Pet_ID INT NOT NULL,
    Player_ID INT NOT NULL,
    Pet_name VARCHAR(255) NOT NULL,
    PRIMARY KEY (Pet_ID, Player_ID),
    FOREIGN KEY (Pet_ID) REFERENCES Pet(Pet_ID),
    FOREIGN KEY (Player_ID) REFERENCES Player(Player_ID)
);


-- Mode1_level Table
CREATE TABLE Mode1_level (
    M1_Level INT IDENTITY(1,1) PRIMARY KEY,
    Title_ID INT DEFAULT NULL,
    FOREIGN KEY (Title_ID) REFERENCES Title(Title_ID)
);


-- Difficulty Table
CREATE TABLE Difficulty (
    Difficulty_ID INT IDENTITY(1,1) PRIMARY KEY,
    Tool_probability DECIMAL(5, 2) CHECK (Tool_probability >= 0 AND Tool_probability <= 1), -- Percentage probability, e.g., 75.00%
    AI_voice_probability DECIMAL(5, 2) CHECK (AI_voice_probability >= 0 AND AI_voice_probability <= 1), -- Percentage probability, e.g., 75.00%
    Total_card_num INT NOT NULL,
    Good_card_num INT NOT NULL,
    CHECK (Good_card_num <= Total_card_num)
);


-- Mode2_level Table
CREATE TABLE Mode2_level (
    M2_level INT IDENTITY(1,1) PRIMARY KEY,
    Difficulty_ID INT NOT NULL,
    FOREIGN KEY (Difficulty_ID) REFERENCES Difficulty(Difficulty_ID)
);

CREATE TABLE AI_voice (
    Voice_ID INT IDENTITY(1,1) PRIMARY KEY,
    Voice_file CHAR(36) NOT NULL UNIQUE, -- UUID
    Voice_Description TEXT NOT NULL
);

CREATE TABLE Tool (
    Tool_ID INT IDENTITY(1,1) PRIMARY KEY,
    Tool_image CHAR(36) NOT NULL UNIQUE, -- UUID
    Tool_description TEXT NOT NULL
);

-- Leaderboard_all Table
CREATE TABLE Leaderboard_all (
    PlayerID INT,
    Ranking INT CHECK (Ranking > 0),
    Mode VARCHAR(20),
    Pet_ID INT,
    PRIMARY KEY (PlayerID, Mode),
    FOREIGN KEY (PlayerID) REFERENCES Player(Player_ID),
    FOREIGN KEY (Pet_ID) REFERENCES Pet(Pet_ID)
);

-- Leaderboard_friend Table
CREATE TABLE Leaderboard_friend (
    PlayerID INT,
    Ranking_in_friend INT CHECK (Ranking_in_friend > 0),
    Mode VARCHAR(20),
    PRIMARY KEY (PlayerID, Mode),
    FOREIGN KEY (PlayerID) REFERENCES Player(Player_ID)
);


-- 3. Insert Data into All Tables
INSERT INTO Title (Title_Name, Title_Description) VALUES
('THE CHALLENGER', 'Awarded to the player who reached the number 1 spot in both modes.'),
('THE ONE', 'Awarded to the player who reached the number 1 spot in both modes in the same leaderboard season.'),
('UNTOUCHABLE', 'Awarded to the player who reached the number 1 spot in hardcore mode.'),
('TOOL SAVANT', 'Awarded to the player who reached the number 1 spot in entertainment mode.'),
('DEFENDER', 'Awarded to the player who is in the top 5 of the hardcore leaderboard for two consecutive times.'),
('POP STAR', 'Awarded to the player who is in the top 5 of the entertainment leaderboard for two consecutive times.'),
('Oops...', 'Given to the player who dies in the first level in hardcore mode.'),
('Broken tools...', 'Given to the player who dies in the first level in entertainment mode.'),
('No longer a rookie', 'Awarded to the player who passes level 10 in hardcore mode.'),
('Tool kit', 'Awarded to the player who passes level 10 in entertainment mode.'),
('Collector', 'Awarded to the player who encounters all tools.'),
('Free will', 'Awarded to the player who refuses to use tools.'),
('Bragger', 'Awarded for topping the friends leaderboard in both modes.'),
('Just went lucky', 'Awarded for topping the friends leaderboard in hardcore modes.'),
('The Dude', 'Awarded for topping the friends leaderboard in hardcore modes.'),
('Last Stand', 'Awarded for being saved by a tool in entertainment mode.'),
('Untargetable', 'Awarded for being saved by a tool in entertainment mode in one game.'),
('Long shot', 'Awarded for getting a 5-level boost in entertainment mode.'),
('Rocket rider', 'Awarded for getting a 10-level boost in entertainment mode.'),
('Wrong Mode?', 'Awarded for dying before encountering a tool in entertainment mode.'),
('Risk taker', 'Awarded for using all three trials in hardcore mode.'),
('The Future', 'Awarded for triggering an AI-voice.'),
('Lucky', 'Given when creating an account.'),
('Game Master', 'Given to the developers.'); 




INSERT INTO Tool (Tool_image, Tool_description) VALUES
('123e4567-e89b-12d3-a456-426614174000', '1 level boost'),
('123ef567-e89b-12d3-a456-426614174000', '2 level boost'),
('123eg567-e89b-12d3-a456-426614174000', '3 level boost'),
('123er567-e89b-12d3-a456-426614174000', '4 level boost'),
('1r3e4567-e89b-12d3-a456-426614174000', '5 level boost'),  
('2r3e4567-e89b-12d3-a456-426614174000', '6 level boost'),  
('3r3e4567-e89b-12d3-a456-426614174000', '7 level boost'),  
('4r3e4567-e89b-12d3-a456-426614174000', '8 level boost'),  
('5r3e4567-e89b-12d3-a456-426614174000', '9 level boost'),  
('6r3e4567-e89b-12d3-a456-426614174000', '10 level boost'),
('123e4567-e89b-1253-a456-426614174000', '1 level drop'),
('123ef567-e89b-1273-a456-426614174000', '2 level drop'),
('123eg567-e89b-18d3-a456-426614174000', '3 level drop'),
('123er567-e89b-12d8-a456-426614174000', '4 level drop'),
('1r3e4567-e89b-12r3-a456-426614174000', '5 level drop'),
('223e4567-e89b-1253-a456-426614174000', '6 level drop'),
('223ef567-e89b-1273-a456-426614174000', '7 level drop'),
('223eg567-e89b-18d3-a456-426614174000', '8 level drop'),
('223er567-e89b-12d8-a456-426614174000', '9 level drop'),
('2r3e4567-e89b-12r3-a456-426614174001', '10 level drop'), 
('423e4597-e89b-1253-a456-426614184000', 'Exclude a wrong choice in next level'),
('423e4507-e89b-1253-a456-426614184000', 'Exclude a correct choice in next level'),
('421ef567-e89b-1273-a456-426614174090', 'Prevent next drop'),
('423ef567-e89b-1273-a456-426614174090', 'Prevent next boost'),
('463eg567-e89b-18d3-a456-426614674000', 'Double next drop'),
('493eg567-e89b-18d3-a456-426614674000', 'Double next boost'),
('323er567-e89b-12d8-a456-420054174900', 'Prevent next death'),
('2r3e4567-e89b-12r3-a456-426614104500', 'Die'),
('923c7519-a45b-78de-b965-214514396013', 'Decrease chance of getting a tool'),
('923c7419-a45b-78de-b965-214514396013', 'Increase chance of getting a tool');


INSERT INTO Player (Player_Name, Player_Email, Player_Password, Mode1_highest, Mode2_highest, Mode1_trial_count, Title_ID_activated) VALUES
('Alice', 'alice@example.com', 'hashedpassword123', 5, 7, 2, 1),
('Bob', 'bob@example.com', 'hashedpassword456', 8, 10, 3, 3),
('Charlie', 'charlie@example.com', 'hashedpassword789', 2, 4, 1, 2),
('David', 'david@example.com', 'hashedpassword321', 7, 6, 2, NULL),
('Eva', 'eva@example.com', 'hashedpassword654', 10, 15, 1, 4);


INSERT INTO Pet (Pet_image, Rarity, GenderType) VALUES
('a1b2c3d4-1234-5678-9101-abcdefabcdef', 5, 'Male'),
('a2b3c4d5-1234-5678-9101-abcdefabcdef', 4, 'Female'),
('b2c3d4e5-1234-5678-9101-abcdefabcdef', 3, 'Unknown'),
('c3d4e5f6-1234-5678-9101-abcdefabcdef', 2, 'Male'),
('d4e5f6g7-1234-5678-9101-abcdefabcdef', 1, 'Female');


INSERT INTO Player_pet (Pet_ID, Player_ID, Pet_name) VALUES
(1, 1, 'Fluffy'),  -- Alice's pet
(2, 2, 'Shadow'),  -- Bob's pet
(3, 3, 'Misty'),   -- Charlie's pet
(4, 4, 'Rex'),     -- David's pet
(5, 5, 'Bella');   -- Eva's pet



-- 4. Write 10 Descriptive Aggregate, Joins, Subqueries

SELECT AVG(Mode1_highest) AS Avg_Mode1_Highest_Score
FROM Player;

SELECT COUNT(Player_ID) AS Players_With_Titles
FROM Player
WHERE Title_ID_activated IS NOT NULL;


SELECT COUNT(Tool_ID) AS Total_Tools
FROM Tool;


SELECT MAX(Mode2_highest) AS Max_Mode2_Highest_Score
FROM Player;

SELECT Player_Name, Player_Email
FROM Player
WHERE Title_ID_activated = (
    SELECT TOP 1 Title_ID_activated
    FROM Player
    GROUP BY Title_ID_activated
    ORDER BY COUNT(Player_ID) DESC
);

SELECT Rarity, COUNT(Pet_ID) AS Total
FROM Pet
GROUP BY Rarity
ORDER BY Total DESC;

SELECT Player_Name
FROM Player
WHERE Mode1_trial_count = 3;

SELECT Title_Name
FROM Title
WHERE Title_ID NOT IN (
    SELECT DISTINCT Title_ID_activated
    FROM Player
    WHERE Title_ID_activated IS NOT NULL
);

SELECT p.Player_Name, t.Title_Name
FROM Player p
LEFT JOIN Title t ON p.Title_ID_activated = t.Title_ID
ORDER BY p.Player_Name;

SELECT p.Player_Name, pt.Pet_name, pet.Rarity
FROM Player p
JOIN Player_pet pt ON p.Player_ID = pt.Player_ID
JOIN Pet pet ON pt.Pet_ID = pet.Pet_ID
ORDER BY p.Player_Name;

