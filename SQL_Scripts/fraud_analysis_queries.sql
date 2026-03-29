SQL QUERIES FOR PROJECT credit_card_dataset

create database credit_card_fraud_detection;
use credit_card_fraud_detection;

-- check total rows --
select count(*)from credit_card_data_cleaning;

-- find out total count of total transaction and fraud transaction? --
select class, count(*) as total_transaction
from credit_card_data_cleaning
group by class;

----find out all frauds in amount_category?----
select amount_category, count(*) as fraud_count
from credit_card_data_cleaning
where class = 1
group by amount_category
order by fraud_count desc;

--find out minimun, maximum and average of fraud transactions?---
select avg(Amount) as Avg_Fraud, min(Amount) as Min_Fraud, max(Amount) as Max_Fraud
from credit_card_data_cleaning
where class =1;

--find top 10 highest transaction where class = 1(fraud)?--
select *From credit_card_data_cleaning
where class = 1
order by Amount desc
limit 10;

--find out difference between every transaction amount for previous transaction according to time?--
select time, amount,
amount- lag(Amount) over (order by time) as time_difference
from credit_card_data_cleaning;

-- percentage of fraud detection?--
SELECT 
    COUNT(*) AS Total_Transactions,
    SUM(CASE WHEN Class = 1 THEN 1 ELSE 0 END) AS Fraud_Count,
    (SUM(CASE WHEN Class = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS Fraud_Percentage
FROM credit_card_data_cleaning;

--High Value Transaction?--
SELECT 
    Amount, 
    Class, 
    CASE WHEN Class = 1 THEN 'Fraud' ELSE 'Genuine' END AS Status
FROM credit_card_data_cleaning
WHERE Amount > 10000
ORDER BY Amount DESC;

--Total Amount of Fraud v/s Non-Fraud?--
SELECT 
    CASE WHEN Class = 1 THEN 'Fraud' ELSE 'Non-Fraud' END AS Transaction_Type,
    COUNT(*) AS Number_of_Transactions,
    SUM(Amount) AS Total_Volume_Amount,
    AVG(Amount) AS Average_Transaction_Value
FROM credit_card_data_cleaning
GROUP BY Class;

CREATE TABLE CC_Final_Analysis AS
SELECT 
    Time,
    Amount,
    Class,
    amount_category,
    -- Calculation: Amount difference between consecutive transactions
    Amount - LAG(Amount) OVER (ORDER BY Time) AS Amount_Difference,
    -- Classification Label
    CASE 
        WHEN Class = 1 THEN 'Fraud' 
        ELSE 'Non-Fraud' 
    END AS Transaction_Status,
    -- High Value Flag --
    CASE 
        WHEN Amount > 10000 THEN 'High Value' 
        ELSE 'Regular' 
    END AS Value_Segment
FROM credit_card_data_cleaning;
