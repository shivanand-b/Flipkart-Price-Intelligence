USE flipkart_pricing;

SELECT
    category_1,
    COUNT(*) AS product_count,
    ROUND(AVG(selling_price), 2) AS avg_selling_price,
    ROUND(AVG(mrp), 2) AS avg_mrp,
    ROUND(AVG(discount_percentage), 2) AS avg_discount
FROM flipkart_price_intelligence
GROUP BY category_1
ORDER BY avg_selling_price DESC;

SELECT
    category_1,
    COUNT(*) AS product_count,
    ROUND(AVG(discount_percentage), 2) AS avg_discount,
    ROUND(MIN(discount_percentage), 2) AS min_discount,
    ROUND(MAX(discount_percentage), 2) AS max_discount
FROM flipkart_price_intelligence
GROUP BY category_1
ORDER BY avg_discount DESC;

---Top Expensive Products
SELECT
    title,
    category_1,
    selling_price,
    mrp,
    discount_percentage,
    product_rating,
    seller_name
FROM flipkart_price_intelligence
ORDER BY selling_price DESC
LIMIT 10;

---Seller Performance Analysis

SELECT
    seller_name,
    COUNT(*) AS product_count,
    ROUND(AVG(selling_price), 2) AS avg_selling_price,
    ROUND(AVG(discount_percentage), 2) AS avg_discount,
    ROUND(AVG(seller_rating), 2) AS avg_seller_rating
FROM flipkart_price_intelligence
WHERE seller_name <> 'Unknown'
GROUP BY seller_name
HAVING COUNT(*) >= 20
ORDER BY product_count DESC
LIMIT 10;

--- Price Segment Analysis

SELECT
    price_segment,
    COUNT(*) AS product_count,
    ROUND(AVG(selling_price), 2) AS avg_selling_price,
    ROUND(AVG(discount_percentage), 2) AS avg_discount,
    ROUND(AVG(product_rating), 2) AS avg_product_rating
FROM flipkart_price_intelligence
GROUP BY price_segment
ORDER BY avg_selling_price DESC;


---High Discount and Low Rated Products

SELECT
    title,
    category_1,
    selling_price,
    mrp,
    discount_percentage,
    product_rating,
    seller_name
FROM flipkart_price_intelligence
WHERE discount_percentage >= 70
  AND product_rating < 4
ORDER BY discount_percentage DESC
LIMIT 20;

---Top 3 Most Expensive Products by Category

WITH ranked_products AS (
    SELECT
        title,
        category_1,
        selling_price,
        mrp,
        discount_percentage,
        product_rating,
        ROW_NUMBER() OVER (
            PARTITION BY category_1
            ORDER BY selling_price DESC
        ) AS price_rank
    FROM flipkart_price_intelligence
)

SELECT
    category_1,
    title,
    selling_price,
    mrp,
    discount_percentage,
    product_rating,
    price_rank
FROM ranked_products
WHERE price_rank <= 3
ORDER BY category_1, price_rank;


---Price and Discount Analysis

SELECT
    price_segment,
    COUNT(*) AS product_count,
    ROUND(AVG(selling_price), 2) AS avg_selling_price,
    ROUND(AVG(discount_percentage), 2) AS avg_discount,
    ROUND(MIN(discount_percentage), 2) AS min_discount,
    ROUND(MAX(discount_percentage), 2) AS max_discount
FROM flipkart_price_intelligence
GROUP BY price_segment
ORDER BY avg_discount DESC;


---Category Pricing Opportunity Analysis

WITH category_metrics AS (
    SELECT
        category_1,
        COUNT(*) AS product_count,
        AVG(selling_price) AS avg_selling_price,
        AVG(discount_percentage) AS avg_discount,
        AVG(product_rating) AS avg_rating
    FROM flipkart_price_intelligence
    GROUP BY category_1
)

SELECT
    category_1,
    product_count,
    ROUND(avg_selling_price, 2) AS avg_selling_price,
    ROUND(avg_discount, 2) AS avg_discount,
    ROUND(avg_rating, 2) AS avg_rating
FROM category_metrics
ORDER BY avg_discount DESC;


---Seller Pricing Comparison

SELECT
    seller_name,
    COUNT(*) AS product_count,
    ROUND(AVG(selling_price), 2) AS avg_selling_price,
    ROUND(AVG(discount_percentage), 2) AS avg_discount,
    ROUND(AVG(seller_rating), 2) AS avg_seller_rating
FROM flipkart_price_intelligence
WHERE seller_name <> 'Unknown'
GROUP BY seller_name
HAVING COUNT(*) >= 50
ORDER BY avg_selling_price DESC
LIMIT 10;