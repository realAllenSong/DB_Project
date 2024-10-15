CREATE DATABASE P3
GO
Use P3
GO

DROP DATABASE P3

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
('Master Strategist', 'Awarded for clearing 50 levels in entertainment mode.'),
('Fearless Warrior', 'Given to players who never use a tool in hardcore mode.'),
('Speedster', 'Cleared 5 levels in less than a minute.'),
('Conqueror', 'Cleared all levels in both modes.'),
('Lucky One', 'Cleared 10 levels with the use of AI voice.'),
('Invincible', 'Never lost a single trial in hardcore mode.'),
('Explorer', 'Visited all possible levels in entertainment mode.'),
('Socialite', 'Added 50 friends to the game.'),
('The Gambler', 'Won by chance multiple times.'),
('The Survivor', 'Survived difficult levels using only one tool.'),
('The Explorer', 'Discovered all hidden features of the game.'),
('Legend', 'Attained the highest possible level in the game.'),
('Sharpshooter', 'Achieved top ranking in a friend leaderboard.'),
('Ultimate Player', 'Maintained the highest score for more than 5 leaderboard seasons.'),
('The Resilient', 'Managed to complete a level even after multiple failures.'),
('Game Guru', 'Provided valuable feedback and got a special title.'),
('Weekend Warrior', 'Played continuously over the weekend.'),
('Night Owl', 'Logged in every night for a week.'),
('Morning Star', 'Logged in every morning for a week.'),
('The Unbeaten', 'Maintained a 100% win rate in hardcore mode.'),
('The Invader', 'Cleared 10 difficult levels in entertainment mode.'),
('The Protector', 'Used tools to save themselves 5 times.'),
('The Challenger', 'Beat 3 top players in friend mode.'),
('The Legend', 'Achieved status for having all top tier pets.'),
('Puzzle Master', 'Solved all tricky levels using strategic moves.'),
('Grandmaster', 'Highest achiever for 3 consecutive months.'),
('The Mentor', 'Helped other players in the friend mode.'),
('Code Cracker', 'Identified secret codes in the game.'),
('AI Master', 'Triggered AI voice interaction 50 times.'),
('The Savior', 'Prevented game failure using tools.'),
('Dynamic Player', 'Engaged actively in both hardcore and entertainment modes.'),
('Fearless', 'Completed 100 levels without using any tools.'),
('Tool Guru', 'Used every tool available in the game.'),
('Stealth Master', 'Completed a level without AI detection.');


INSERT INTO Tool (Tool_image, Tool_description) VALUES
('7r3e4567-e89b-12d3-a456-426614174000', 'Instant shield for 5 seconds'),
('8r3e4567-e89b-12d3-a456-426614174000', 'Slow down time for strategic advantage'),
('9r3e4567-e89b-12d3-a456-426614174000', 'Immediate teleport to the next level'),
('0r3e4567-e89b-12d3-a456-426614174000', 'Earn double points for 1 level'),
('er3e4567-e89b-12d3-a456-426614174000', 'Reveal all choices in the next level'),
('qr3e4567-e89b-12d3-a456-426614174000', 'Speed boost for 2 levels'),
('zr3e4567-e89b-12d3-a456-426614174000', 'Enhance luck by 20% for 5 levels'),
('xr3e4567-e89b-12d3-a456-426614174000', 'Increase resistance to AI tricks'),
('yr3e4567-e89b-12d3-a456-426614174000', 'Stealth mode for 1 game'),
('pr3e4567-e89b-12d3-a456-426614174000', 'Increase chance to find rare tools'),
('tr3e4567-e89b-12d3-a456-426614174000', 'Extend trial count by 1'),
('gr3e4567-e89b-12d3-a456-426614174000', 'Instant freeze on AI interactions'),
('wr3e4567-e89b-12d3-a456-426614174000', 'Extra attempt on hardcore mode'),
('sr3e4567-e89b-12d3-a456-426614174000', '1 level downshield for AI tricks'),
('vr3e4567-e89b-12d3-a456-426614174000', 'Temporary invisibility from AI tracking'),
('ur3e4567-e89b-12d3-a456-426614174000', 'Swap tools with another player'),
('ir3e4567-e89b-12d3-a456-426614174000', 'Immediate level completion'),
('or3e4567-e89b-12d3-a456-426614174000', 'Randomly increase 2 levels'),
('br3e4567-e89b-12d3-a456-426614174111', 'Decrease level drop by 1'), 
('nr3e4567-e89b-12d3-a456-426614174000', 'Protect level progress for 1 game'),
('mr3e4567-e89b-12d3-a456-426614174000', 'Auto-select correct option'),
('lr3e4567-e89b-12d3-a456-426614174000', 'Prevent one loss from affecting score'),
('kr3e4567-e89b-12d3-a456-426614174000', 'Multiply points by 2'),
('jr3e4567-e89b-12d3-a456-426614174000', 'Confuse AI for next 3 levels'),
('hr3e4567-e89b-12d3-a456-426614174000', 'Decrease tool activation time'),
('fr3e4567-e89b-12d3-a456-426614174000', 'Increase AI interaction by 10%'),
('dr3e4567-e89b-12d3-a456-426614174000', 'Neutralize AI trick for next game'),
('cr3e4567-e89b-12d3-a456-426614174000', 'Start game with a random boost'),
('br3e4567-e89b-12d3-a456-426614174112', 'Reveal one hidden feature'),
('ar3e4567-e89b-12d3-a456-426614174000', 'Random level jump up to 3 levels'),
('zr3e4597-e89b-1253-a456-426614184000', 'Triple next win score'),
('wr3e4507-e89b-1253-a456-426614184000', 'Double next win score'),
('xr1ef567-e89b-1273-a456-426614174090', 'Force AI to skip turn'),
('dr1ef567-e89b-1273-a456-426614174090', 'Pause tool feature for 2 turns');



INSERT INTO Player (Player_Name, Player_Email, Player_Password, Mode1_highest, Mode2_highest, Mode1_trial_count, Title_ID_activated) VALUES
('Frank', 'frank@example.com', 'hashedpassword001', 12, 14, 1, 5),
('Grace', 'grace@example.com', 'hashedpassword002', 7, 11, 3, 6),
('Hannah', 'hannah@example.com', 'hashedpassword003', 9, 13, 2, 7),
('Ivan', 'ivan@example.com', 'hashedpassword004', 15, 20, 2, 8),
('Jack', 'jack@example.com', 'hashedpassword005', 10, 16, 3, 9),
('Karen', 'karen@example.com', 'hashedpassword006', 4, 7, 1, 10),
('Leo', 'leo@example.com', 'hashedpassword007', 6, 8, 2, 11),
('Mona', 'mona@example.com', 'hashedpassword008', 5, 5, 2, 12),
('Nancy', 'nancy@example.com', 'hashedpassword009', 11, 15, 1, 13),
('Oscar', 'oscar@example.com', 'hashedpassword010', 7, 12, 2, 14),
('Paul', 'paul@example.com', 'hashedpassword011', 8, 9, 1, 15),
('Quincy', 'quincy@example.com', 'hashedpassword012', 9, 10, 2, 16),
('Rachel', 'rachel@example.com', 'hashedpassword013', 13, 18, 3, 17),
('Steve', 'steve@example.com', 'hashedpassword014', 14, 22, 1, 18),
('Tom', 'tom@example.com', 'hashedpassword015', 8, 11, 2, 19),
('Uma', 'uma@example.com', 'hashedpassword016', 12, 17, 3, 20),
('Vera', 'vera@example.com', 'hashedpassword017', 10, 18, 1, 21),
('Will', 'will@example.com', 'hashedpassword018', 5, 9, 1, 22),
('Xander', 'xander@example.com', 'hashedpassword019', 14, 20, 2, 23),
('Yara', 'yara@example.com', 'hashedpassword020', 11, 15, 2, 24),
('Zane', 'zane@example.com', 'hashedpassword021', 9, 14, 3, 25),
('Allison', 'allison@example.com', 'hashedpassword022', 7, 10, 2, 1), 
('Bruce', 'bruce@example.com', 'hashedpassword023', 13, 21, 1, 2),   
('Cindy', 'cindy@example.com', 'hashedpassword024', 6, 9, 1, 3),    
('Derek', 'derek@example.com', 'hashedpassword025', 8, 12, 3, 4),   
('Ethan', 'ethan@example.com', 'hashedpassword026', 10, 13, 2, 5),  
('Fiona', 'fiona@example.com', 'hashedpassword027', 14, 17, 3, 6),  
('George', 'george@example.com', 'hashedpassword028', 9, 11, 1, 7), 
('Helen', 'helen@example.com', 'hashedpassword029', 11, 14, 3, 8),  
('Ivy', 'ivy@example.com', 'hashedpassword030', 13, 18, 1, 9),      
('Jade', 'jade@example.com', 'hashedpassword031', 12, 16, 2, 10),
('Kim', 'kim@example.com', 'hashedpassword032', 10, 12, 1, 11),    
('Liam', 'liam@example.com', 'hashedpassword033', 11, 13, 2, 12),  
('Nina', 'nina@example.com', 'hashedpassword034', 13, 15, 3, 13);   



INSERT INTO Pet (Pet_image, Rarity, GenderType) VALUES
('e1f2g3h4-5678-9101-abcdefabcdef', 5, 'Female'),
('f2g3h4i5-5678-9101-abcdefabcdef', 4, 'Male'),
('g3h4i5j6-5678-9101-abcdefabcdef', 3, 'Unknown'),
('h4i5j6k7-5678-9101-abcdefabcdef', 2, 'Female'),
('i5j6k7l8-5678-9101-abcdefabcdef', 1, 'Male'),
('j6k7l8m9-5678-9101-abcdefabcdef', 5, 'Female'),
('k7l8m9n0-5678-9101-abcdefabcdef', 4, 'Unknown'),
('l8m9n0o1-5678-9101-abcdefabcdef', 2, 'Female'),
('m9n0o1p2-5678-9101-abcdefabcdef', 3, 'Male'),
('n0o1p2q3-5678-9101-abcdefabcdef', 1, 'Unknown'),
('o1p2q3r4-5678-9101-abcdefabcdef', 4, 'Female'),
('p2q3r4s5-5678-9101-abcdefabcdef', 5, 'Male'),
('q3r4s5t6-5678-9101-abcdefabcdef', 2, 'Unknown'),
('r4s5t6u7-5678-9101-abcdefabcdef', 3, 'Female'),
('s5t6u7v8-5678-9101-abcdefabcdef', 1, 'Male'),
('t6u7v8w9-5678-9101-abcdefabcdef', 4, 'Female'),
('u7v8w9x0-5678-9101-abcdefabcdef', 3, 'Male'),
('v8w9x0y1-5678-9101-abcdefabcdef', 5, 'Unknown'),
('w9x0y1z2-5678-9101-abcdefabcdef', 4, 'Male'),
('x0y1z2a3-5678-9101-abcdefabcdef', 3, 'Female'),
('y1z2a3b4-5678-9101-abcdefabcdef', 2, 'Unknown'),
('z2a3b4c5-5678-9101-abcdefabcdef', 5, 'Male'),
('a3b4c5d6-5678-9101-abcdefabcdef', 1, 'Female'),
('b4c5d6e7-5678-9101-abcdefabcdef', 3, 'Unknown'),
('c5d6e7f8-5678-9101-abcdefabcdef', 2, 'Male'),
('d6e7f8g9-5678-9101-abcdefabcdef', 5, 'Female'),
('e7f8g9h0-5678-9101-abcdefabcdef', 4, 'Unknown'),
('f8g9h0i1-5678-9101-abcdefabcdef', 1, 'Male'),
('g9h0i1j2-5678-9101-abcdefabcdef', 3, 'Female'),
('h0i1j2k3-5678-9101-abcdefabcdef', 2, 'Unknown'),
('i1j2k3l4-5678-9101-abcdefabcdef', 5, 'Female'),
('j2k3l4m5-5678-9101-abcdefabcdef', 4, 'Unknown'),
('k3l4m5n6-5678-9101-abcdefabcdef', 1, 'Female'),
('l4m5n6o7-5678-9101-abcdefabcdef', 3, 'Male');


INSERT INTO Player_pet (Pet_ID, Player_ID, Pet_name) VALUES
(1, 1, 'Fluffy'),  
(2, 2, 'Shadow'),  
(3, 3, 'Misty'),   
(4, 4, 'Rex'),     
(5, 5, 'Bella'),   
(6, 6, 'Max'),    
(7, 7, 'Luna'),    
(8, 8, 'Buddy'),   
(9, 9, 'Daisy'),   
(10, 10, 'Rocky'), 
(11, 11, 'Milo'),  
(12, 12, 'Zoe'),   
(13, 13, 'Charlie'), 
(14, 14, 'Lucy'),  
(15, 15, 'Cooper'),
(16, 16, 'Bailey'),
(17, 17, 'Stella'),
(18, 18, 'Maggie'),
(19, 19, 'Chloe'), 
(20, 20, 'Nala'), 
(21, 21, 'Finn'),  
(22, 22, 'Ruby'),  
(23, 23, 'Willow'),
(24, 24, 'Oscar'), 
(25, 25, 'Olive'), 
(26, 26, 'Harley'),
(27, 27, 'Piper'), 
(28, 28, 'Dexter'),
(29, 29, 'Jasper'),
(30, 30, 'Coco'),  
(31, 31, 'Moose'), 
(32, 32, 'Rosie'), 
(33, 33, 'Ellie'), 
(34, 34, 'Benji'); 




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

