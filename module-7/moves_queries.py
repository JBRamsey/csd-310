import mysql.connector
from mysql.connector import errorcode

config = {
    "user": "root",
    "password": "OmegaBlack911!",
    "host": "127.0.0.1",
    "database": "movies",
    "raise_on_warnings": True
}

try:
    db = mysql.connector.connect(**config)
    cursor = db.cursor()

    print("\n Database user {} connected to MySQL on host {} with databse {}".format(config["user"], config["host"], config["database"]))

    input("\n\n Press any key to continue...")

    cursor.execute("SELECT * FROM studio")
    studios = cursor.fetchall()
    print("All fields from the studio table:")
    for studio in studios:
        print(studio)

    cursor.execute("SELECT * FROM genre")
    genres = cursor.fetchall()
    print("\nAll fields from the genre table:")
    for genre in genres:
        print(genre)

    cursor.execute("SELECT film_name FROM film WHERE film_runtime < 120")
    short_movies = cursor.fetchall()
    print("\nMovies with a runtime of less than two hours:")
    for film in short_movies:
        print(film[0])

    cursor.execute("SELECT film_name, film_director FROM film ORDER BY film_director")
    movies_directors = cursor.fetchall()
    print("\nList of film names and directors, ordered by director:")
    for film in movies_directors:
        print(f"Movie: {film[0]}, Director: {film[1]}")


except mysql.connector.Error as err:
    if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
        print(" The supplied username or password are invalid")

    elif err.errno == errorcode.ER_BAD_DB_ERROR:
        print(" The specified database does not exist")

    else:
        print(err) 

finally:
    db.close()   