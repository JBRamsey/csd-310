import mysql.connector
from mysql.connector import errorcode

def show_films(cursor, title):
    print("\n" + title)
    query = (
        "SELECT film_name AS Name, film_director AS Director, genre_name AS Genre, studio_name AS 'Studio Name' from film INNER JOIN genre ON film.genre_id=genre.genre_id INNER JOIN studio ON film.studio_id=studio.studio_id"
    )

    cursor.execute(query)
    results = cursor.fetchall()

    print ("\n == {} ==".format(title))

    for film in results:
        print("Film Name: {}\nDirector: {}\nGenre Name ID: {}\nStudio Name: {}\n".format(film[0], film[1], film[2], film[3]))

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

    show_films(cursor, "DISPLAYING FILMS")

    insert_query = "INSERT INTO film (film_name, film_director, genre_id, studio_id, film_releaseDate, film_runtime) VALUES (%s, %s, %s, %s, %s, %s)"
    cursor.execute(insert_query, ('Independence Day', 'Roland Emmerich', 2, 1, '1996', 145))
    db.commit()
    show_films(cursor, "DISPLAYING FILMS AFTER INSERT")

    update_query = "UPDATE film SET genre_id = %s WHERE film_name = 'Alien'"
    cursor.execute(update_query, (1,))
    db.commit()
    show_films(cursor, "DISPLAYING FILMS AFTER UPDATE")

    delete_query = "DELETE FROM film WHERE film_name = 'Gladiator'"
    cursor.execute(delete_query)
    db.commit()
    show_films(cursor, "DISPLAYING FILMS AFTER DELETE")

except mysql.connector.Error as err:
    if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
        print(" The supplied username or password are invalid")

    elif err.errno == errorcode.ER_BAD_DB_ERROR:
        print(" The specified database does not exist")

    else:
        print(err) 

finally:
    db.close()   

