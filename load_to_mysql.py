import pandas as pd
import mysql.connector

# 1. CSV file read karo
csv_path = "data/cleaned/flipkart_price_intelligence.csv"
df = pd.read_csv(csv_path)

print("CSV rows:", len(df))

# 2. MySQL se connect karo
conn = mysql.connector.connect(
    host="localhost",
    user="root",
    password="Shivanand@6969",
    database="flipkart_pricing"
)

cursor = conn.cursor()

# 3. Existing table ko empty karo
cursor.execute("TRUNCATE TABLE flipkart_price_intelligence")

# 4. Insert query
query = """
INSERT INTO flipkart_price_intelligence
(category_1, category_2, category_3, title,
 product_rating, selling_price, mrp,
 seller_name, seller_rating, discount_percentage, price_segment)
VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
"""

# 5. Data MySQL me insert karo
data = [tuple(row) for row in df.itertuples(index=False, name=None)]

cursor.executemany(query, data)
conn.commit()

print("Rows inserted:", cursor.rowcount)

# 6. Verify
cursor.execute("SELECT COUNT(*) FROM flipkart_price_intelligence")
total = cursor.fetchone()[0]

print("MySQL total rows:", total)

cursor.close()
conn.close()