import pymysql

conn = pymysql.connect(host="localhost",user="root",password="1234",database="test",charset="utf8")
cursor=conn.cursor()

sql="SELECT * FROM student"

cursor.execute(sql)
result = cursor.fetchall()
conn.commit()
print(result)
cursor.close()
conn.close()
#print(res)
for rr in result:
	print(rr)
	print(rr[0])
	print(rr[1])
	print(rr[2])