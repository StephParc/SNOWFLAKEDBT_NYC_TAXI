WITH improved_trips AS (
    SELECT
        VENDORID,
        TPEP_PICKUP_DATETIME,
        TPEP_DROPOFF_DATETIME,
        PICKUP_MONTH,
        PICKUP_DAY,
        PICKUP_HOUR,
        CASE 
            WHEN PICKUP_HOUR BETWEEN 6 AND 9
                THEN 'morning rush'
            WHEN PICKUP_HOUR BETWEEN 10 AND 15
                THEN 'day'
            WHEN PICKUP_HOUR BETWEEN 16 AND 19
                THEN 'evening rush'
            WHEN PICKUP_HOUR BETWEEN 20 AND 23
                THEN 'evening'
            ELSE 'night' 
        END AS TEMPORAL_PERIOD,
        CASE
            WHEN DAYOFWEEKISO(TPEP_PICKUP_DATETIME) BETWEEN 1 AND 5
                THEN 'working day'
            ELSE 'weekend'
        END AS DAY_TYPE,
        DATEDIFF('minute',TPEP_PICKUP_DATETIME, TPEP_DROPOFF_DATETIME) AS DURATION,
        PASSENGER_COUNT,
        TRIP_DISTANCE,
        CASE 
            WHEN TRIP_DISTANCE <= 1
                THEN 'short'
            WHEN TRIP_DISTANCE BETWEEN 1 AND 5
                THEN 'medium'
            WHEN TRIP_DISTANCE BETWEEN 5 AND 10
                THEN 'long'
            ELSE 'very long'
        END AS DISTANCE_CATEGORY,
        RATECODEID,
        STORE_AND_FWD_FLAG,
        PULOCATIONID,
        DOLOCATIONID,
        PAYMENT_TYPE,
        FARE_AMOUNT,
        EXTRA,
        MTA_TAX,
        TIP_AMOUNT,
        ROUND(
            CASE
                WHEN (TOTAL_AMOUNT - TIP_AMOUNT) = 0 THEN NULL
                ELSE TIP_AMOUNT * 100 / NULLIF(TOTAL_AMOUNT - TIP_AMOUNT, 0)
            END,
            2
            ) AS TIP_PART,
        TOLLS_AMOUNT,
        IMPROVEMENT_SURCHARGE,
        TOTAL_AMOUNT,
        CONGESTION_SURCHARGE,
        AIRPORT_FEE,
        CBD_CONGESTION_FEE
    FROM {{ ref('stg_yellow_taxi_trips') }}
)
SELECT 
    *,
    ROUND(
        CASE
            WHEN DURATION = 0 THEN NULL
            ELSE TRIP_DISTANCE / NULLIF(DURATION/60, 0)
        END,
        2
        ) AS AVERAGE_SPEED
FROM improved_trips