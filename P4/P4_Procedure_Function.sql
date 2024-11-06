-- Q1. Create 3 Stored Procedures
--updates a player's highest score in Mode 1 if the new score is higher than the existing score.
--This procedure is essential for managing player progression. Whenever a player completes a session in Mode 1, the game can call this procedure to update their personal best score if they’ve surpassed their previous highest score.
--By keeping track of each player's highest score, the system can create leaderboards, issue rewards, or display personal progress to encourage engagement.
CREATE PROCEDURE UpdateMode1Highest
    @PlayerID INT,
    @NewMode1Highest INT
AS
BEGIN
    DECLARE @CurrentMode1Highest INT;

    SELECT @CurrentMode1Highest = Mode1_highest
    FROM dbo.Player
    WHERE Player_ID = @PlayerID;

    IF @NewMode1Highest > @CurrentMode1Highest
    BEGIN
        UPDATE dbo.Player
        SET Mode1_highest = @NewMode1Highest
        WHERE Player_ID = @PlayerID;
    END
    ELSE
    BEGIN
        PRINT 'New Mode1_highest is not greater than the current value. No update performed.';
    END
END;


--updates a player's highest score in Mode 2 if the new score is higher than the existing score.
--Similar to UpdateMode1Highest, this procedure helps track a player’s best performance in Mode 2, which could involve a different game mode or mechanics.
--Mode 2 might involve additional strategic elements (like AI interactions or tools), so this procedure allows the game to reward players who achieve high scores in more challenging scenarios.
CREATE PROCEDURE UpdateMode2Highest
    @PlayerID INT,
    @NewMode2Highest INT
AS
BEGIN
    DECLARE @CurrentMode2Highest INT;

    SELECT @CurrentMode2Highest = Mode2_highest
    FROM dbo.Player
    WHERE Player_ID = @PlayerID;

    IF @NewMode2Highest > @CurrentMode2Highest
    BEGIN
        UPDATE dbo.Player
        SET Mode2_highest = @NewMode2Highest
        WHERE Player_ID = @PlayerID;
    END
    ELSE
    BEGIN
        PRINT 'New Mode2_highest is not greater than the current value. No update performed.';
    END
END;


--updates the currently activated title for a player. 
--Titles can be a form of in-game recognition or achievement for players. This procedure allows the player to change their currently displayed title (e.g., switching from "Conqueror" to "Master Strategist").
--The ability to update titles enhances the social and visual aspects of the game, as players can choose which title to display based on their accomplishments.
CREATE PROCEDURE UpdateTitleIDActivated
    @PlayerID INT,
    @NewTitleID INT
AS
BEGIN
    UPDATE dbo.Player
    SET Title_ID_activated = @NewTitleID
    WHERE Player_ID = @PlayerID;
END;




-- Q2. Create 3 functions

--returns a table of all friends' highest scores in Mode 1 for a specific player. 
--This function enables the creation of friend leaderboards, allowing players to see how they stack up against their friends in Mode 1.
--The social aspect of comparing scores with friends can drive engagement, as players are motivated to improve their scores to maintain a higher rank among their peers.
CREATE FUNCTION dbo.GetFriendsMode1HighestScores
(
    @PlayerID INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT F.Friend_ID, P.Mode1_highest
    FROM dbo.Friend F
    INNER JOIN dbo.Player P ON F.Friend_ID = P.Player_ID
    WHERE F.Player_ID = @PlayerID
);



-- returns a table of all friends' highest scores in Mode 2 for a specific player.
--Similar to GetFriendsMode1HighestScores, this function supports friend leaderboards but for Mode 2.
--Mode 2 may be a more challenging or skill-based mode, so being able to compare scores with friends in this specific mode adds depth to the gameplay experience.
CREATE FUNCTION dbo.GetFriendsMode2HighestScores
(
    @PlayerID INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT F.Friend_ID, P.Mode2_highest
    FROM dbo.Friend F
    INNER JOIN dbo.Player P ON F.Friend_ID = P.Player_ID
    WHERE F.Player_ID = @PlayerID
);


--returns a table of all players' highest scores in Mode 1, which can be used to generate the global leaderboard for Mode 1.
--The global leaderboard is a powerful tool for engaging players, as it allows them to see where they stand in comparison to all players in the game.
--This function enables quick access to player scores, which is useful for generating the global leaderboard and updating it in real-time.
CREATE FUNCTION dbo.GetAllPlayersMode1Highest()
RETURNS TABLE
AS
RETURN
(
    SELECT Player_ID, Mode1_highest
    FROM dbo.Player
);




-- Q3. Create 3 views

-- A view that combines player names, Mode1 and Mode2 highest scores, for leaderboard use.
CREATE VIEW vPlayerLeaderboard AS
SELECT 
    Player_ID,
    Player_Name,
    Mode1_highest,
    Mode2_highest
FROM dbo.Player;

-- A view that shows player names and their pets' details, useful for displaying pets owned by each player.
CREATE VIEW vPlayerPets AS
SELECT 
    p.Player_Name,
    pp.Pet_name,
    pet.Rarity,
    pet.GenderType
FROM dbo.Player p
JOIN dbo.Player_pet pp ON p.Player_ID = pp.Player_ID
JOIN dbo.Pet pet ON pp.Pet_ID = pet.Pet_ID;

-- A view that shows each player's friend list, displaying the player and their friends' names.
CREATE VIEW vFriendList AS
SELECT 
    p.Player_Name AS Player,
    f.Player_ID,
    pf.Player_Name AS Friend
FROM dbo.Player p
JOIN dbo.Friend f ON p.Player_ID = f.Player_ID
JOIN dbo.Player pf ON f.Friend_ID = pf.Player_ID;


-- Q4. Create 1 Trigger
-- updates the Leaderboard_all table whenever a player's highest score in Mode1 or Mode2 is updated.
CREATE TRIGGER trg_UpdateLeaderboard
ON dbo.Player
AFTER UPDATE
AS
BEGIN
    IF UPDATE(Mode1_highest) OR UPDATE(Mode2_highest)
    BEGIN
        DECLARE @PlayerID INT, @NewMode VARCHAR(20), @Pet_ID INT;

        SELECT @PlayerID = Player_ID, 
               @NewMode = CASE WHEN Mode1_highest IS NOT NULL THEN 'Mode1' ELSE 'Mode2' END,
               @Pet_ID = (SELECT Pet_ID FROM dbo.Player_pet WHERE Player_ID = Player_ID);

        UPDATE Leaderboard_all
        SET Ranking = RANK() OVER (ORDER BY Mode1_highest DESC),
            Pet_ID = @Pet_ID
        WHERE PlayerID = @PlayerID AND Mode = @NewMode;
    END
END;


-- Q5. Implement 1 Column Encryption

-- Step 1: Create a database master key with a strong password
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'StrongPassword123!';

-- Step 2: Create a certificate for encrypting the symmetric key
CREATE CERTIFICATE PlayerCert 
WITH SUBJECT = 'Certificate for Player Password Encryption';

-- Step 3: Create a symmetric key with AES_256 encryption, protected by the certificate
CREATE SYMMETRIC KEY PlayerKey 
WITH ALGORITHM = AES_256 
ENCRYPTION BY CERTIFICATE PlayerCert;

-- Step 4: Add a new column for storing encrypted passwords
ALTER TABLE Player 
ADD EncryptedPassword VARBINARY(255);  

-- Step 5: Insert data with encryption
-- Open the symmetric key to encrypt data
OPEN SYMMETRIC KEY PlayerKey 
DECRYPTION BY CERTIFICATE PlayerCert;

-- Insert sample player data with encrypted password
INSERT INTO Player (Player_Name, Player_Email, EncryptedPassword, Mode1_highest, Mode2_highest, Mode1_trial_count, Title_ID_activated)
VALUES 
('Zhiyuan', 'Zhiyuan@example.com', EncryptByKey(Key_GUID('PlayerKey'), 'MySecretPassword'), 5, 8, 1, NULL),
('Weici', 'Weici@example.com', EncryptByKey(Key_GUID('PlayerKey'), 'AnotherMySecretPassword'), 6, 9, 1, NULL),
('Guancheng', 'Guancheng@example.com', EncryptByKey(Key_GUID('PlayerKey'), 'AnotherAnotherSecretPassword'), 7, 12, 2, NULL);

-- Close the symmetric key
CLOSE SYMMETRIC KEY PlayerKey;

-- Step 6: Query and decrypt the data
-- Open the symmetric key to decrypt data
OPEN SYMMETRIC KEY PlayerKey 
DECRYPTION BY CERTIFICATE PlayerCert;

-- Query to retrieve player data with decrypted password
SELECT 
    Player_ID, 
    Player_Name, 
    Player_Email, 
    Mode1_highest, 
    Mode2_highest, 
    CONVERT(VARCHAR(255), DecryptByKey(EncryptedPassword)) AS DecryptedPassword
FROM Player;

-- Close the symmetric key
CLOSE SYMMETRIC KEY PlayerKey;

-- Step 7: Verify encrypted data in the table
SELECT 
    Player_ID, 
    EncryptedPassword 
FROM Player;

-- Open the symmetric key for encryption
OPEN SYMMETRIC KEY PlayerKey 
DECRYPTION BY CERTIFICATE PlayerCert;

-- Update the encrypted password
UPDATE Player
SET EncryptedPassword = EncryptByKey(Key_GUID('PlayerKey'), 'UpdatedSecretPassword')
WHERE Player_ID = 1;

-- Close the symmetric key
CLOSE SYMMETRIC KEY PlayerKey;


-- Q6. Create 3 non-clustered indexes

--An index on Player_Email for faster lookups of players by email, which can speed up authentication processes.
CREATE NONCLUSTERED INDEX idx_Player_Email
ON dbo.Player(Player_Email);

-- An index on Mode1_highest for quicker retrieval of players by highest scores in Mode 1, useful for leaderboard queries.
CREATE NONCLUSTERED INDEX idx_Mode1_highest
ON dbo.Player(Mode1_highest);

--An index on Rarity in the Pet table to quickly retrieve pets by rarity, useful for pet collections or rewards.
CREATE NONCLUSTERED INDEX idx_Pet_Rarity
ON dbo.Pet(Rarity);








