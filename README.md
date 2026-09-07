# Sales Funnel Analysis

An end-to-end SQL analytics project that explores customer behavior across an e-commerce sales funnel. The project uses event-level user activity data to measure funnel performance, traffic-source conversion, time to purchase, and revenue efficiency.

## Project Overview

This project answers practical business questions using SQL:

- How many users reach each stage of the sales funnel?
- Where do users drop off between viewing a product and completing a purchase?
- Which traffic sources drive the strongest purchase conversion?
- How long does it take users to move from product view to cart and purchase?
- What are the key revenue metrics for buyers, orders, and visitors?

The analysis focuses on Q1 2026 activity, using events from January 1, 2026 through March 31, 2026.

## Dataset

The dataset contains user interaction events from an e-commerce journey. Each row represents a user event, such as viewing a product, adding an item to cart, starting checkout, entering payment information, or purchasing.

### Table: `user_events`

| Column | Description |
| --- | --- |
| `event_id` | Unique identifier for each event |
| `user_id` | Unique identifier for each user |
| `event_type` | Type of user action, such as `page_view`, `add_to_cart`, `checkout_start`, `payment_info`, or `purchase` |
| `event_date` | Timestamp when the event occurred |
| `product_id` | Product associated with the event |
| `amount` | Purchase amount, populated for purchase events |
| `traffic_source` | Acquisition source for the user event, such as organic, social, or other channels |

## Tools Used

- SQL
- PostgreSQL-compatible syntax
- CSV data import

## How to Run the Project

1. Clone the repository:

```bash
git clone https://github.com/juliepe/e-commerce_data_analytics.git
cd e-commerce_data_analytics
```

2. Create the database table and import the CSV data:

```sql
\i database_creation.sql
```

The import script creates the `user_events` table and loads `data/user_events.csv`.

3. Run the analysis queries:

```sql
\i analysis.sql
```

## Analysis Included

### 1. Sales Funnel Counts

Counts the number of distinct users who reached each funnel stage:

- Page view
- Add to cart
- Checkout start
- Payment information
- Purchase

### 2. Funnel Conversion Rates

Calculates conversion rates between each step of the funnel:

- View to cart
- Cart to checkout
- Checkout to payment
- Payment to purchase

### 3. Traffic Source Performance

Groups funnel activity by `traffic_source` to compare:

- Total viewers
- Cart additions
- Purchases
- Cart conversion rate
- Purchase conversion rate

### 4. Time to Conversion

Measures how long converted users take to move through the buying journey:

- Average minutes from view to cart
- Average minutes from cart to purchase
- Average minutes from view to purchase

### 5. Revenue Funnel Metrics

Summarizes key revenue indicators:

- Total visitors
- Total buyers
- Total revenue
- Total orders
- Average price per order
- Revenue per buyer
- Revenue per visitor
