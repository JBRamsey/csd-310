# Joshua Ramsey
# 12/03/2023
# CSD 310


import mysql.connector
from mysql.connector import errorcode

# Connect to the MySQL server

config = {
    "user": "bacchus_user",
    "password": "finewine",
    "host": "127.0.0.1",
    "database": "bacchus",
    "raise_on_warnings": True
}

try:

    # Create a cursor object to interact with the database

    db = mysql.connector.connect(**config)

    cursor = db.cursor()

    print("\n Database user {} connected to MySQL on host {} with database {}".format(config["user"], config["host"], config["database"]))

    input("\n\n Press any key to continue...")

    # Retrieve and display table names
    cursor.execute("SHOW TABLES")
    tables = cursor.fetchall()

    for table in tables:
        table_name = table[0]
        print(f"\nTable: {table_name}")
    
        # Retrieve and display table contents
        cursor.execute(f"SELECT * FROM {table_name}")
        rows = cursor.fetchall()

        # Get column names
        column_names = [desc[0] for desc in cursor.description]

        # Display column names
        print(", ".join(column_names))

        # Display table contents
        for row in rows:
            print(", ".join(map(str, row)))

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