WITH date_series AS (
  SELECT generate_series(
    DATE '2021-01-01',
    DATE '2021-01-31',
    INTERVAL '1 day'
  ) AS date
),
transactions_filtered AS (
  SELECT
    DATE(transaction_time) AS transaction_date,
    transaction_amount
  FROM
    transactions
  WHERE
    transaction_time >= '2021-01-01' AND
    transaction_time < '2021-02-01'
),
rolling_averages AS (
  SELECT
    ds.date,
    ROUND(AVG(t.transaction_amount)::numeric, 2) AS avg_transaction_amount
  FROM
    date_series ds
    LEFT JOIN transactions_filtered t ON t.transaction_date BETWEEN ds.date - INTERVAL '2 days' AND ds.date
  GROUP BY
    ds.date
  ORDER BY
    ds.date
)
SELECT * FROM rolling_averages;