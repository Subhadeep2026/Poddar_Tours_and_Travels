import MySQLdb

try:
    db = MySQLdb.connect(host="localhost", user="root", passwd="")
    cursor = db.cursor()
    cursor.execute("CREATE DATABASE IF NOT EXISTS poddar_travels;")
    print("Database 'poddar_travels' created or already exists.")
    db.close()
except Exception as e:
    print(f"Error: {e}")
    print("Trying with 'root' as password...")
    try:
        db = MySQLdb.connect(host="localhost", user="root", passwd="root")
        cursor = db.cursor()
        cursor.execute("CREATE DATABASE IF NOT EXISTS poddar_travels;")
        print("Database 'poddar_travels' created or already exists (using password 'root').")
        db.close()
    except Exception as e2:
        print(f"Error with 'root' password: {e2}")
