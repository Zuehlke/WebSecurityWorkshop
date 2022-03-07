import sqlite3
import hashlib
from flask import Flask,request, render_template

app = Flask(__name__)

db = sqlite3.connect(":memory:", check_same_thread=False)
cur = db.cursor()

cur.execute("create table user (username, pw)")
cur.execute("insert into user VALUES ('admin@test.ch', 'd63dc919e201d7bc4c825630d2cf25fdc93d4b2f0d46706d29038d01')")
cur.execute("insert into user VALUES ('user@test.ch', '99fb2f48c6af4761f904fc85f95eb56190e5d40b1f44ec3a9c1fa319')")

cur.execute("create table secrets (key, value)")
cur.execute("insert into secrets VALUES ('db-password', 'pa$$word')")


db.commit()

def hash(password):
    data = password.encode('ascii')
    return hashlib.sha224(data).hexdigest()

@app.route("/login", methods = ['POST'])
def login():
    
    username = request.form['username']
    password = hash(request.form['password'])

    sql = f"SELECT username FROM user WHERE username=? and pw=?"
    print("SQL: " + sql)

    row = None
    msg = "fail"

    try:
        cur = db.cursor()
        cur.execute(sql, [username, password])
        row = cur.fetchone()
    except Exception as e:
        msg = f"SQL error: {e}"

    if row is not None:

        username_db = row[0]
        msg = f"You are logged in as {username_db}"

    return render_template('index.html', msg=msg, username=username, sql=sql)



@app.route("/")
@app.route("/login", methods = ['GET'])
def home():
    return render_template('index.html')

if __name__ == '__main__':  
   app.run(debug = True)