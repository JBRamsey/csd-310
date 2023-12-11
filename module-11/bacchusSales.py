# Joshua Ramsey
# 12/09/2023
# CSD 310


import mysql.connector
from mysql.connector import errorcode

# Connect to the MySQL server

config = {
    "user": "root",
    "password": "Big69Qua",
    "host": "localhost",
    "database": "bacchus",
    "raise_on_warnings": True
}

try:

    # Create a cursor object to interact with the database

    db = mysql.connector.connect(**config)

    cursor = db.cursor()

    print("\n Database user {} connected to MySQL on host {} with database {}".format(config["user"], config["host"], config["database"]))

    input("\n\n Press any key to continue...")

    query = """
        SELECT
            od.order_distribution_id,
            od.order_date,
            od.distribution_id,
            d.company_name,
            odd.quantity,
            odd.subtotal_cost
        FROM
            order_distribution_t od
        JOIN distribution_t d ON od.distribution_id = d.distribution_id
        JOIN order_distribution_details_t odd ON od.order_distribution_id = odd.order_distribution_id
    """

    cursor.execute(query)
    result = cursor.fetchall()

    for row in result:
        order_distribution_id, order_date, distribution_id, company_name, quantity, subtotal_cost = row
        
        print(f"Distribution Order ID: {order_distribution_id}")
        print(f"Order Date: {order_date}")
        print(f"Distribution Company ID: {distribution_id}")
        print(f"Company Name: {company_name}")
        print(f"Quantity: {quantity}")
        print(f"Subtotal Cost: {subtotal_cost}")
        print("-" * 30)  # Separating each record with a line


except mysql.connector.Error as err:
    if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
        print(" The supplied username or password is invalid")

    elif err.errno == errorcode.ER_BAD_DB_ERROR:
        print(" The specified database does not exist")

    else:
        print(err) 

finally:
    cursor.close()
    db.close()