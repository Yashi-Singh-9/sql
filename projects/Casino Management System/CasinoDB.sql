-- MS SQL Project
CREATE DATABASE CasinoDB;
USE CasinoDB;

-- Players Table
CREATE TABLE Players (
    PlayerID INT IDENTITY(1,1) PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Phone VARCHAR(15) UNIQUE NOT NULL,
    Balance DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    RegisteredDate DATETIME
);

-- Games Table
CREATE TABLE Games (
    GameID INT IDENTITY(1,1) PRIMARY KEY,
    GameName VARCHAR(100) UNIQUE NOT NULL,
    GameType VARCHAR(50) NOT NULL,
    MinBet DECIMAL(10,2) NOT NULL,
    MaxBet DECIMAL(10,2) NOT NULL
);

-- Transactions Table
CREATE TABLE Transactions (
    TransactionID INT IDENTITY(1,1) PRIMARY KEY,
    PlayerID INT,
    TransactionType VARCHAR(15) CHECK (TransactionType IN ('Deposit', 'Withdrawal', 'Bet', 'Winning')) NOT NULL,
    Amount DECIMAL(10,2) NOT NULL,
    TransactionDate DATETIME,
    FOREIGN KEY (PlayerID) REFERENCES Players(PlayerID) ON DELETE CASCADE
);

-- Bets Table
CREATE TABLE Bets (
    BetID INT IDENTITY(1,1) PRIMARY KEY,
    PlayerID INT,
    GameID INT,
    BetAmount DECIMAL(10,2) NOT NULL,
    BetResult VARCHAR(10) CHECK (BetResult IN ('Win', 'Lose', 'Pending')) DEFAULT 'Pending',
    Payout DECIMAL(10,2) DEFAULT 0.00,
    BetTime DATETIME,
    FOREIGN KEY (PlayerID) REFERENCES Players(PlayerID) ON DELETE CASCADE,
    FOREIGN KEY (GameID) REFERENCES Games(GameID) ON DELETE CASCADE
);

-- Staff Table
CREATE TABLE Staff (
    StaffID INT IDENTITY(1,1) PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Role VARCHAR(10) CHECK (Role IN ('Dealer', 'Manager', 'Cashier')) NOT NULL,
    Salary DECIMAL(10,2) NOT NULL,
    ContactNumber VARCHAR(15) UNIQUE NOT NULL,
    HireDate DATE NOT NULL
);

-- Tables 
CREATE TABLE CasinoTables (
    TableID INT IDENTITY(1,1) PRIMARY KEY,
    GameID INT,
    TableNumber INT UNIQUE NOT NULL,
    MaxPlayers INT NOT NULL,
    AssignedDealer INT,
    FOREIGN KEY (GameID) REFERENCES Games(GameID) ON DELETE CASCADE,
    FOREIGN KEY (AssignedDealer) REFERENCES Staff(StaffID) ON DELETE SET NULL
);

-- Insert Players
INSERT INTO Players (Name, Email, Phone, Balance, RegisteredDate) VALUES
('Alice Johnson', 'alice@example.com', '1234567890', 500.00, '2024-02-01 10:00:00'),
('Bob Smith', 'bob@example.com', '1234567891', 300.00, '2024-02-02 11:00:00'),
('Charlie Davis', 'charlie@example.com', '1234567892', 200.00, '2024-02-03 12:00:00'),
('David Wilson', 'david@example.com', '1234567893', 100.00, '2024-02-04 13:00:00'),
('Eve Adams', 'eve@example.com', '1234567894', 50.00, '2024-02-05 14:00:00'),
('Franklin White', 'frank@example.com', '1234567895', 600.00, '2024-02-06 15:00:00'),
('Grace Hall', 'grace@example.com', '1234567896', 400.00, '2024-02-07 16:00:00'),
('Hannah Scott', 'hannah@example.com', '1234567897', 700.00, '2024-02-08 17:00:00');

-- Insert Games
INSERT INTO Games (GameName, GameType, MinBet, MaxBet) VALUES
('Blackjack', 'Card', 5.00, 500.00),
('Roulette', 'Table', 1.00, 1000.00),
('Poker', 'Card', 10.00, 2000.00),
('Baccarat', 'Card', 5.00, 500.00),
('Craps', 'Dice', 1.00, 1500.00),
('Slots', 'Machine', 0.50, 100.00),
('Keno', 'Lottery', 1.00, 500.00),
('Sic Bo', 'Dice', 2.00, 1000.00);

-- Insert Transactions
INSERT INTO Transactions (PlayerID, TransactionType, Amount, TransactionDate) VALUES
(1, 'Deposit', 100.00, '2024-02-10 18:00:00'),
(2, 'Withdrawal', 50.00, '2024-02-11 19:00:00'),
(3, 'Bet', 20.00, '2024-02-12 20:00:00'),
(4, 'Winning', 200.00, '2024-02-13 21:00:00'),
(5, 'Deposit', 300.00, '2024-02-14 22:00:00'),
(6, 'Withdrawal', 100.00, '2024-02-15 23:00:00'),
(7, 'Bet', 15.00, '2024-02-16 00:00:00'),
(8, 'Winning', 500.00, '2024-02-17 01:00:00');

-- Insert Bets
INSERT INTO Bets (PlayerID, GameID, BetAmount, BetResult, Payout, BetTime) VALUES
(1, 1, 10.00, 'Win', 20.00, '2024-02-10 18:30:00'),
(2, 2, 15.00, 'Lose', 0.00, '2024-02-11 19:30:00'),
(3, 3, 25.00, 'Win', 50.00, '2024-02-12 20:30:00'),
(4, 4, 5.00, 'Lose', 0.00, '2024-02-13 21:30:00'),
(5, 5, 30.00, 'Win', 60.00, '2024-02-14 22:30:00'),
(6, 6, 2.00, 'Pending', NULL, '2024-02-15 23:30:00'),
(7, 7, 12.00, 'Lose', 0.00, '2024-02-16 00:30:00'),
(8, 8, 8.00, 'Pending', NULL, '2024-02-17 01:30:00');

-- Insert Staff
INSERT INTO Staff (Name, Role, Salary, ContactNumber, HireDate) VALUES
('John Dealer', 'Dealer', 4000.00, '2233445566', '2023-01-01'),
('Sarah Manager', 'Manager', 6000.00, '2233445567', '2023-02-01'),
('Mark Cashier', 'Cashier', 3500.00, '2233445568', '2023-03-01'),
('Lucy Dealer', 'Dealer', 4200.00, '2233445569', '2023-04-01'),
('Paul Manager', 'Manager', 6200.00, '2233445570', '2023-05-01'),
('Anna Cashier', 'Cashier', 3600.00, '2233445571', '2023-06-01'),
('James Dealer', 'Dealer', 4300.00, '2233445572', '2023-07-01'),
('Emily Cashier', 'Cashier', 3700.00, '2233445573', '2023-08-01');

-- Insert Casino Tables
INSERT INTO CasinoTables (GameID, TableNumber, MaxPlayers, AssignedDealer) VALUES
(1, 101, 5, 1),
(2, 102, 6, 2),
(3, 103, 7, NULL),
(4, 104, 5, 4),
(5, 105, 6, NULL),
(6, 106, 4, 6),
(7, 107, 8, NULL),
(8, 108, 5, 8);

-- Retrieve the total balance of all players in the casino.
SELECT SUM(Balance) AS TotalCasinoBalance 
FROM Players;

-- Find all players who have placed bets but never won.
SELECT DISTINCT P.PlayerID, P.Name 
FROM Players P
JOIN Bets B ON P.PlayerID = B.PlayerID
WHERE P.PlayerID NOT IN (
    SELECT DISTINCT PlayerID FROM Bets WHERE BetResult = 'Win'
);

-- Get the top 5 players who have spent the most money on bets.
SELECT TOP 5 P.PlayerID, P.Name, SUM(B.BetAmount) AS TotalBetAmount
FROM Bets B
JOIN Players P ON B.PlayerID = P.PlayerID
GROUP BY P.PlayerID, P.Name
ORDER BY TotalBetAmount DESC;

-- Retrieve the highest bet amount placed on each game.
SELECT G.GameID, G.GameName, MAX(B.BetAmount) AS HighestBet
FROM Bets B
JOIN Games G ON B.GameID = G.GameID
GROUP BY G.GameID, G.GameName;

-- Find the total amount deposited and withdrawn by each player.
SELECT 
    P.PlayerID, P.Name,
    COALESCE(SUM(CASE WHEN T.TransactionType = 'Deposit' THEN T.Amount ELSE 0 END), 0) AS TotalDeposited,
    COALESCE(SUM(CASE WHEN T.TransactionType = 'Withdrawal' THEN T.Amount ELSE 0 END), 0) AS TotalWithdrawn
FROM Players P
LEFT JOIN Transactions T ON P.PlayerID = T.PlayerID
GROUP BY P.PlayerID, P.Name;

-- List all transactions of a particular player sorted by date.
SELECT TransactionID, TransactionType, Amount, TransactionDate
FROM Transactions
WHERE PlayerID = 6
ORDER BY TransactionDate ASC;

-- Get the dealer assigned to each casino table along with the game being played.
SELECT C.TableID, C.TableNumber, G.GameName, S.Name AS DealerName
FROM CasinoTables C
JOIN Games G ON C.GameID = G.GameID
LEFT JOIN Staff S ON C.AssignedDealer = S.StaffID;

-- Find the number of games available in the casino.
SELECT COUNT(*) AS TotalGames
FROM Games;

-- Retrieve all players who registered in the last 7 days.
SELECT PlayerID, Name, Email, RegisteredDate
FROM Players
WHERE RegisteredDate >= DATEADD(DAY, -7, GETDATE());

-- Find the total winnings of each player.
SELECT P.PlayerID, P.Name, COALESCE(SUM(B.Payout), 0) AS TotalWinnings
FROM Players P
LEFT JOIN Bets B ON P.PlayerID = B.PlayerID
WHERE B.BetResult = 'Win'
GROUP BY P.PlayerID, P.Name;
