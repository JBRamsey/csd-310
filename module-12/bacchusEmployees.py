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
            e.employee_name,
            e.employee_id,
            e.employee_position_name,
            tq.timeclock_year,
            tq.quarter_1_hours,
            tq.quarter_2_hours,
            tq.quarter_3_hours,
            tq.quarter_4_hours
        FROM
            employees_t e
        JOIN timeclock_quarterly_t tq ON e.employee_id = tq.employee_id
    """


    cursor.execute(query)
    result = cursor.fetchall()

    for row in result:
        employee_id, employee_name, employee_position_name, timeclock_year, quarter_1_Hours, quarter_2_Hours, quarter_3_Hours, quarter_4_Hours = row
        
        print(f"Employee ID: {employee_id}")
        print(f"Employee Name: {employee_name}")
        print(f"Year: {timeclock_year}")
        print(f"Company Position: {employee_position_name}")
        print(f"Quarter 1 Hours: {quarter_1_Hours}")
        print(f"Quarter 2 Hours: {quarter_2_Hours}")
        print(f"Quarter 3 Hours: {quarter_3_Hours}")
        print(f"Quarter 4 Hours: {quarter_4_Hours}")
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