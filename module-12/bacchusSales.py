# Joshua Ramsey
# 12/0/2023
# CSD 310

import mysql.connector
from mysql.connector import errorcode

# Create variables and initialize them to None
db = None
cursor = None

# Connect to the MySQL server
config = {
    "user": "bacchus_user",
    "password": "finewine",
    "host": "localhost",
    "database": "bacchus",
    "raise_on_warnings": True
}

try:
    # Create a cursor object to interact with the database
    db = mysql.connector.connect(**config)
    cursor = db.cursor()

    print("\nDatabase user {} connected to MySQL on host {} with database {}".format(config["user"], config["host"], config["database"]))

    input("\n\nPress any key to continue...")

    query = """
        SELECT
            od.order_distribution_id,
            od.order_date,
            d.company_name,
            p.product_name,  -- Include the product name from the product_t table
            odd.quantity,
            odd.subtotal_cost
        FROM
            order_distribution_t od
        JOIN distribution_t d ON od.distribution_id = d.distribution_id
        JOIN order_distribution_details_t odd ON od.order_distribution_id = odd.order_distribution_id
        JOIN product_t p ON odd.product_id = p.product_id  -- Join with the product_t table
    """

    cursor.execute(query)
    result = cursor.fetchall()

    for row in result:
        order_distribution_id, order_date, company_name, product_name, quantity, subtotal_cost = row

        print(f"Distribution Order ID: {order_distribution_id}")
        print(f"Order Date: {order_date}")
        print(f"Company Name: {company_name}")
        print(f"Product: {product_name}")
        print(f"Quantity: {quantity}")
        print(f"Subtotal Cost: {subtotal_cost}")
        print("-" * 30)  # Separating each record with a line

except mysql.connector.Error as err:
    if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
        print("The supplied username or password is invalid")

    elif err.errno == errorcode.ER_BAD_DB_ERROR:
        print("The specified database does not exist")

    else:
        print(err)

finally:
    # Check if cursor and db are defined before attempting to close them
    if cursor:
        cursor.close()
    if db:
        db.close()