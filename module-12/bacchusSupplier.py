# Joshua Ramsey
# 12/09/2023
# CSD 310


import mysql.connector
from mysql.connector import errorcode

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

    print("\n Database user {} connected to MySQL on host {} with database {}".format(config["user"], config["host"], config["database"]))

    input("\n\n Press any key to continue...")

    query = """
        SELECT
            so.supply_order_id,
            s.supply_name,
            s.supply_inventory_current,
            s.supply_inventory_monthly_requirement,
            su.supplier_name,
            so.quantity,
            so.order_date,
            so.order_shipdate,
            so.order_expecteddate,
            so.order_arrivaldate
        FROM
            supply_orders_t so
        JOIN supply_inventory_t s ON so.supply_id = s.supply_id
        JOIN supplier_t su ON s.supplier_id = su.supplier_id
"""

    cursor.execute(query)
    result = cursor.fetchall()

    for row in result:
        supply_order_id, supply_name, supply_inventory_current, supply_inventory_monthly_requirement, supplier_name, quantity, order_date, order_shipdate, order_expecteddate, order_arrivaldate = row
        
        print(f"Supply Order ID: {supply_order_id}")
        print(f"Supply Name: {supply_name}")
        print(f"Current Inventory: {supply_inventory_current}")
        print(f"Monthly Requirement: {supply_inventory_monthly_requirement}")
        print(f"Supplier: {supplier_name}")
        print(f"Quantity: {quantity}")
        print(f"Order Date: {order_date}")
        print(f"Ship Date: {order_shipdate}")
        print(f"Expected Date: {order_expecteddate}")
        print(f"Arrival Date: {order_arrivaldate}")
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
