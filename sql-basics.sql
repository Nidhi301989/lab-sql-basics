-- Query 1: Get the id values of the first 5 clients from district_id with a value equals to 1.
use bank;
SHOW TABLES;

SELECT client_id 
FROM client
WHERE district_id = 1 
ORDER BY client_id 
LIMIT 5;

-- Query 2 : Get the id value of the last client where the district_id equals to 72.

SELECT client_id
FROM client
WHERE district_id = 72
ORDER BY client_id DESC
LIMIT 1;

-- Query 3: Get the 3 lowest amounts in the loan table.

SELECT amount
FROM loan
ORDER BY amount ASC
LIMIT 3;

-- Query 4: Get the possible values for status, ordered alphabetically in ascending order in the loan table.

SELECT DISTINCT status
FROM loan
ORDER BY status ASC;

-- Query 5: Get the loan_id of the highest payment received in the loan table.

SELECT loan_id
FROM loan
ORDER BY payments DESC
LIMIT 1;


-- Query 6: Get the loan amount of the lowest 5 account_ids in the loan table. Show the account_id and the corresponding amount.

SELECT account_id, amount
FROM loan
ORDER BY account_id ASC
LIMIT 5;


-- Query 7: Get the account_ids with the lowest loan amount that have a loan duration of 60 in the loan table.

SELECT account_id
FROM loan
WHERE duration = 60
ORDER BY amount ASC;


-- Query 8: Get the unique values of k_symbol in the `order` table.

SELECT DISTINCT k_symbol
FROM `order`;

-- Query 9: Get the order_ids of the client with the account_id 34 in the `order` table.

SELECT order_id
FROM `order`
WHERE account_id = 34;

-- Query 10: Get the account_ids responsible for orders between order_id 29540 and 29560 (inclusive) in the `order` table.

SELECT DISTINCT account_id
FROM `order`
WHERE order_id BETWEEN 29540 AND 29560;


-- Query 11: Get the individual amounts sent to account_to id 30067122 in the `order` table.

SELECT amount
FROM `order`
WHERE account_to = 30067122;

-- Query 12: Show the trans_id, date, type, and amount of the first 10 transactions from account_id 793 in chronological order, from newest to oldest in the trans table.

SELECT trans_id, date, type, amount
FROM trans
WHERE account_id = 793
ORDER BY date DESC
LIMIT 10;

-- Query 13: Count the number of clients from each district_id where district_id is lower than 10, sorted by district_id in ascending order.

SELECT district_id, COUNT(*) AS client_count
FROM client
WHERE district_id < 10
GROUP BY district_id
ORDER BY district_id ASC;


-- Query 14: Count the number of cards for each type in the card table, ranked starting with the most frequent type.

SELECT type, COUNT(*) AS card_count
FROM card
GROUP BY type
ORDER BY card_count DESC;


-- Query 15: Get the top 10 account_ids based on the sum of all their loan amounts in the loan table.

SELECT account_id, SUM(amount) AS total_amount
FROM loan
GROUP BY account_id
ORDER BY total_amount DESC
LIMIT 10;


-- Query 16: Retrieve the number of loans issued for each day before (excluding) 930907, ordered by date in descending order.

SELECT date, COUNT(*) AS loan_count
FROM loan
WHERE date < 930907
GROUP BY date
ORDER BY date DESC;


-- Query 17: Count the number of loans issued for each unique loan duration for each day in December 1997, ordered by date and duration in ascending order.

SELECT date, duration, COUNT(*) AS loan_count
FROM loan
WHERE date BETWEEN 971201 AND 971231
GROUP BY date, duration
ORDER BY date ASC, duration ASC;


-- Query 18: Sum the amount of transactions for each type for account_id 396 in the trans table, with the output sorted alphabetically by type.

SELECT account_id, type, SUM(amount) AS total_amount
FROM trans
WHERE account_id = 396
GROUP BY type
ORDER BY type ASC;


-- Query 19: Translate transaction types to English, rename the column to transaction_type, and round the total_amount down to an integer.

SELECT 
    account_id,
    CASE 
        WHEN type = 'PRIJEM' THEN 'INCOMING'
        WHEN type = 'VYDAJ' THEN 'OUTGOING'
        ELSE 'UNKNOWN'
    END AS transaction_type,
    FLOOR(SUM(amount)) AS total_amount
FROM trans
WHERE account_id = 396
GROUP BY type
ORDER BY transaction_type ASC;


-- Query 20: Return a single row with columns for incoming amount, outgoing amount, and the difference.

SELECT 
    account_id,
    COALESCE(SUM(CASE WHEN type = 'PRIJEM' THEN amount ELSE 0 END), 0) AS incoming_amount,
    COALESCE(SUM(CASE WHEN type = 'VYDAJ' THEN amount ELSE 0 END), 0) AS outgoing_amount,
    COALESCE(SUM(CASE WHEN type = 'PRIJEM' THEN amount ELSE 0 END), 0) - 
    COALESCE(SUM(CASE WHEN type = 'VYDAJ' THEN amount ELSE 0 END), 0) AS difference
FROM trans
WHERE account_id = 396;


-- Query 21: Rank the top 10 account_ids based on their difference between incoming and outgoing amounts.

SELECT 
    account_id,
    COALESCE(SUM(CASE WHEN type = 'PRIJEM' THEN amount ELSE 0 END), 0) - 
    COALESCE(SUM(CASE WHEN type = 'VYDAJ' THEN amount ELSE 0 END), 0) AS difference
FROM trans
GROUP BY account_id
ORDER BY difference DESC
LIMIT 10;
