CREATE SCHEMA P3;
USE P3;

CREATE TABLE Titles (
    Title_ID INT AUTO_INCREMENT PRIMARY KEY,
    Title_Name VARCHAR(100) NOT NULL UNIQUE,
    Title_Description TEXT NOT NULL
);

CREATE TABLE Pet (
    Pet_ID INT AUTO_INCREMENT PRIMARY KEY,
    Pet_image CHAR(36) NOT NULL,  -- UUID for the pet image
    Rarity VARCHAR(50) NOT NULL,
    GenderType ENUM('Male', 'Female', 'Unknown') NOT NULL
);

CREATE TABLE Player (
    Player_ID INT AUTO_INCREMENT PRIMARY KEY,
    Player_Name VARCHAR(100) NOT NULL,
    Player_Email VARCHAR(100) NOT NULL UNIQUE,
    Player_Password VARCHAR(255) NOT NULL,
    Mode1_highest INT DEFAULT 0,
    Mode2_highest INT DEFAULT 0,
    Mode1_trial_count INT DEFAULT 0,
    Title_ID_activated INT,
    FOREIGN KEY (Title_ID_activated) REFERENCES Titles(Title_ID),
    Pet_ID_activated INT,
    FOREIGN KEY (Pet_ID_activated) REFERENCES Pet(Pet_ID)
);

CREATE TABLE Friend (
    Player1_ID INT NOT NULL,
    Player2_ID INT NOT NULL,
    PRIMARY KEY (Player1_ID, Player2_ID),
    FOREIGN KEY (Player1_ID) REFERENCES Player(Player_ID),
    FOREIGN KEY (Player2_ID) REFERENCES Player(Player_ID),
    CHECK (Player1_ID <> Player2_ID)  -- Prevent a player from being friends with themselves
);


CREATE TABLE Title_Unlocked (-- 储存Player和Title的对应关系
    Player_ID INT NOT NULL,
    Title_ID INT NOT NULL,
    PRIMARY KEY (Player_ID, Title_ID),
    FOREIGN KEY (Player_ID) REFERENCES Player(Player_ID),
    FOREIGN KEY (Title_ID) REFERENCES Titles(Title_ID)
);

CREATE TABLE Pet_Unlocked (-- 储存Player的Pet的名字
    Pet_ID INT NOT NULL,
    Player_ID INT NOT NULL,
    Pet_name VARCHAR(100),
    PRIMARY KEY (Pet_ID, Player_ID),
    FOREIGN KEY (Pet_ID) REFERENCES Pet(Pet_ID),
    FOREIGN KEY (Player_ID) REFERENCES Player(Player_ID)
);

CREATE TABLE AI_voice (
    Voice_ID INT AUTO_INCREMENT PRIMARY KEY,
    Voice_file CHAR(36) NOT NULL, -- UUID
    Voice_Description TEXT
);

CREATE TABLE Tool (
    Tool_ID INT AUTO_INCREMENT PRIMARY KEY,
    Tool_image CHAR(36) NOT NULL, -- UUID
    Tool_description TEXT
);

CREATE TABLE Difficulty (
    Difficulty_ID INT AUTO_INCREMENT PRIMARY KEY,
    Tool_probability DECIMAL(5, 2) NOT NULL,  -- Percentage probability, e.g., 75.00%
    AI_voice_probability DECIMAL(5, 2) NOT NULL,  -- Percentage probability, e.g., 75.00%
    Total_card_num INT NOT NULL,
    Good_card_num INT NOT NULL
);

CREATE TABLE Mode_2_level ( -- 难度
    M2_level INT AUTO_INCREMENT PRIMARY KEY,
    Difficulty_ID INT NOT NULL,
    FOREIGN KEY (Difficulty_ID) REFERENCES Difficulty(Difficulty_ID)
);

CREATE TABLE Mode_1_level ( -- Title
    M1_Level INT AUTO_INCREMENT PRIMARY KEY,
    Title_ID INT DEFAULT NULL,
    FOREIGN KEY (Title_ID) REFERENCES Titles(Title_ID)
);

-- 加三个check constrain
ALTER TABLE Difficulty
ADD CONSTRAINT chk_tool_probability CHECK (Tool_probability BETWEEN 0 AND 100);

ALTER TABLE Difficulty
ADD CONSTRAINT chk_good_card_num CHECK (Good_card_num <= Total_card_num);

ALTER TABLE Player
ADD CONSTRAINT chk_mode1_trial_count CHECK (Mode1_trial_count <= 3);


INSERT INTO Titles (Title_Name, Title_Description) VALUES
('THE CHALLANGER', 'Awarded to the player who reached the number 1 spot in both modes.'),
('THE ONE', 'Awarded to the player who reached the number 1 spot in both modes in the same leaderboard season.'),
('UNTOUCHABLE', 'Awarded to the player who reached the number 1 spot in hardcore mode.'),
('TOOL SAVANT', 'Awarded to the player who reached the number 1 spot in entertainment mode.'),
('DEFENDER', 'Awarded to the player who are in top 5 of hardcore leaderboard for two consecutive times.'),
('POP STAR', 'Awarded to the player who are in top 5 of entertainment leaderboard for two consecutive times.'),
('Ooops...', 'Given to the player who dies in the first level in hardcore mode.'),
('Broken tools...', 'Given to the player who dies in the first level in entertainment mode.'),
('No longer rookie', 'Awarded to the player who passes level 10 in hardcore mode'),
('Tool kit', 'Awarded to the player who passes level 10 in entertainment mode'),
('Collector', 'Awarded to the player who encountered all tools'),
('Free will', 'Awarded to the player who refuse to use tools'),
('Bragger', 'Awarded for topping the friends leaderboard in both modes.'),
('Just went lucky', 'Awarded for topping the friends leaderboard in hardcore modes.'),
('The Dude', 'Awarded for topping the friends leaderboard in hardcore modes.'),
('Last Stand', 'Awarded for being saved by tool in entertainment mode.'),
('Untargetable', 'Awarded for being saved by tool in entertainment mode in one game.'),
('Long shot', 'Awarded for getting a 5-level boosted in entertainment mode.'),
('Rocket rider', 'Awarded for getting a 10-level boosted in entertainment mode.'),
('Wrong Mode?', 'Awarded for dieing before encountering a tool in entertainment mode.'),
('Risk taker', 'Awarded for using all three trials in hardcore mode.'),
('The Future', 'Awarded for triggering an AI-voice.'),
('Lucky', 'Given when creating account.'),
('IDK', 'Xiang Bu Chu Lai Le.'),
('IDK', 'Xiang Bu Chu Lai Le.'),
('IDK', 'Xiang Bu Chu Lai Le.'),
('IDK', 'Xiang Bu Chu Lai Le.'),
('IDK', 'Xiang Bu Chu Lai Le.'),
('IDK', 'Xiang Bu Chu Lai Le.'),
('IDK', 'Xiang Bu Chu Lai Le.'),
('Creater', 'Given to the developers.');


INSERT INTO Tool (Tool_image, Tool_description) VALUES
('123e4567-e89b-12d3-a456-426614174000', '1 level boost'),
('123ef567-e89b-12d3-a456-426614174000', '2 level boost'),
('123eg567-e89b-12d3-a456-426614174000', '3 level boost'),
('123er567-e89b-12d3-a456-426614174000', '4 level boost'),
('1r3e4567-e89b-12d3-a456-426614174000', '5 level boost'),
('123e4567-e89b-12d3-a456-426614174000', '6 level boost'),
('123ef567-e89b-12d3-a456-426614174000', '7 level boost'),
('123eg567-e89b-12d3-a456-426614174000', '8 level boost'),
('123er567-e89b-12d3-a456-426614174000', '9 level boost'),
('1r3e4567-e89b-12d3-a456-426614174000', '10 level boost'),
('123e4567-e89b-1253-a456-426614174000', '1 level drop'),
('123ef567-e89b-1273-a456-426614174000', '2 level drop'),
('123eg567-e89b-18d3-a456-426614174000', '3 level drop'),
('123er567-e89b-12d8-a456-426614174000', '4 level drop'),
('1r3e4567-e89b-12r3-a456-426614174000', '5 level drop'),
('123e4567-e89b-1253-a456-426614174000', '6 level drop'),
('123ef567-e89b-1273-a456-426614174000', '7 level drop'),
('123eg567-e89b-18d3-a456-426614174000', '8 level drop'),
('123er567-e89b-12d8-a456-426614174000', '9 level drop'),
('1r3e4567-e89b-12r3-a456-426614174000', '10 level drop'),
('123e4597-e89b-1253-a456-426614184000', 'Exclude a wrong choice in next level'),
('123e4507-e89b-1253-a456-426614184000', 'Exclude a correct choice in next level'),
('121ef567-e89b-1273-a456-426614174090', 'Prevent next drop'),
('223ef567-e89b-1273-a456-426614174090', 'Prevent next boost'),
('163eg567-e89b-18d3-a456-426614674000', 'Double next drop'),
('193eg567-e89b-18d3-a456-426614674000', 'Double next boost'),
('123er567-e89b-12d8-a456-420054174900', 'Prevent next death'),
('1r3e4567-e89b-12r3-a456-426614104500', 'Die'),
('923c7519-a45b-78de-b965-214514396013', 'Decrease chance of getting a tool'),
('923c7419-a45b-78de-b965-214514396013', 'Increase chance of getting a tool');





