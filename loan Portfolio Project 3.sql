create database loan_analysis;
use loan_analysis;
select * from loan_portfolio_project;
-- Q1. Write a SQL query to display all records where annual income is greater than 100000 ?
SELECT customer_id,annual_income FROM loan_portfolio_project WHERE annual_income > 100000;

-- Q2. What is the average loan amount ?
SELECT AVG(loan_amount) AS avg_loan
FROM loan_portfolio_project;

-- Q3. How can customers be classified by credit score ?
SELECT credit_score,
CASE
    WHEN credit_score < 600 THEN 'Low'
    ELSE 'High'
END AS credit_group
FROM loan_portfolio_project;

-- Q.4 What is the average interest rate for each loan product ?
SELECT product_type, AVG(interest_rate)
FROM loan_portfolio_project
GROUP BY product_type;

-- Q5 Which products have an average interest rate above 15% ?
SELECT product_type, AVG(interest_rate)
FROM loan_portfolio_project
GROUP BY product_type
HAVING AVG(interest_rate) > 15;

-- Q6 How many customers belong to each age group ?
SELECT age_group, COUNT(*)
FROM loan_portfolio_project
GROUP BY age_group;

-- Q7 Which customers have a high debt ratio ?
SELECT customer_id, debt_ratio
FROM loan_portfolio_project
WHERE debt_ratio > 0.40;

-- Q8 Which customers have requested more than the average loan amount ?
SELECT customer_id, loan_amount
FROM loan_portfolio_project
WHERE loan_amount > (
    SELECT AVG(loan_amount)
    FROM loan_portfolio_project
);

-- Q9 Which customers have a credit score above the portfolio average ?
SELECT customer_id, credit_score
FROM loan_portfolio_project
WHERE credit_score > (
    SELECT AVG(credit_score)
    FROM loan_portfolio_project
);

-- Q10 How many customers have previous defaults on file ?
SELECT COUNT(*) AS default_customers
FROM loan_portfolio_project
WHERE Defaults_on_File > 0;

-- Q11 What is the average loan amount for each product ?
WITH loans AS (
    SELECT product_type, AVG(loan_amount) AS avg_loan
    FROM loan_portfolio_project
    GROUP BY product_type
)
SELECT * FROM loans;

-- Q12 Which customers have a credit score below 600 ?
WITH risk AS (
    SELECT *
    FROM loan_portfolio_project
    WHERE credit_score < 600
)
SELECT customer_id, credit_score
FROM risk;

-- Q13 What is the total requested loan amount for each loan purpose ?
WITH totals AS (
    SELECT loan_intent, SUM(loan_amount) AS total
    FROM loan_portfolio_project
    GROUP BY loan_intent
)
SELECT * FROM totals;

-- Q14 What is the average loan amount for rejected applications ?
WITH rejected AS (
    SELECT loan_amount
    FROM loan_portfolio_project
    WHERE `approved/rejected` = 'Rejected'
)
SELECT AVG(loan_amount) AS avg_rejected_loan
FROM rejected;

-- Q15 What are the five largest loan applications ?
SELECT customer_id, loan_amount,
ROW_NUMBER() OVER (
    ORDER BY loan_amount DESC
) AS ranking
FROM loan_portfolio_project
LIMIT 5;

-- Q16 How can customers be ranked by credit score ?
SELECT customer_id, credit_score,
RANK() OVER (
    ORDER BY credit_score DESC
) AS ranking
FROM loan_portfolio_project;

-- Q17 How does each loan amount compare with its product's average ?
SELECT product_type, loan_amount,
AVG(loan_amount) OVER (
    PARTITION BY product_type
) AS avg_product_loan
FROM loan_portfolio_project;

-- Q18 Which five loans have the highest interest rates ?
SELECT customer_id, interest_rate,
DENSE_RANK() OVER (
    ORDER BY interest_rate DESC
) AS ranking
FROM loan_portfolio_project
LIMIT 5;

-- Q19 What is the cumulative loan amount by customer age ?
SELECT age, loan_amount,
SUM(loan_amount) OVER (
    ORDER BY age
) AS cumulative_amount
FROM loan_portfolio_project;

-- Q20 What is the approval rate for each loan product ?
SELECT product_type,
ROUND(100 * AVG(
    CASE WHEN `approved/rejected` = 'Approved'
    THEN 1.0 ELSE 0.0 END
), 2) AS approval_rate
FROM loan_portfolio_project
GROUP BY product_type;

-- Q21. Which loan products receive the most applications ?
SELECT
    product_type,
    COUNT(*) AS applications,
    SUM(loan_amount) AS total_requested_amount,
    ROUND(AVG(loan_amount), 2) AS avg_loan_amount,
    ROUND(AVG(interest_rate), 2) AS avg_interest_rate
FROM loan_portfolio_project
GROUP BY product_type
ORDER BY applications DESC;

-- Q22. Which customers have a low credit score and high debt ratio ?
SELECT
    customer_id,
    credit_score,
    debt_ratio,
    loan_amount,
    `approved/rejected`
FROM loan_portfolio_project
WHERE credit_score < 600
  AND debt_ratio > 0.40
ORDER BY debt_ratio DESC, credit_score ASC;

-- Q23. Which loan purposes have the highest average loan amount ?
SELECT loan_intent, COUNT(*) AS applications,
    ROUND(AVG(loan_amount), 2) AS avg_loan_amount,
    SUM(loan_amount) AS total_requested_amount,
    ROUND(AVG(annual_income), 2) AS avg_annual_income
FROM loan_portfolio_project
GROUP BY loan_intent
ORDER BY avg_loan_amount DESC;

-- Q24 Which loan purposes have the highest average interest rate ?
SELECT loan_intent, AVG(interest_rate) AS avg_interest
FROM loan_portfolio_project
GROUP BY loan_intent
ORDER BY avg_interest DESC;

-- Q25 Which customers have a loan amount higher than their annual income ?
SELECT customer_id, annual_income, loan_amount
FROM loan_portfolio_project
WHERE loan_amount > annual_income;

