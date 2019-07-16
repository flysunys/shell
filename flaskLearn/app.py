from flask import Flask,render_template
from flask_sqlalchemy import SQLAlchemy
import pymysql
app=Flask(__name__)
#app.config['SQLALCHEMY_DATABASE_URI']='mysql://root:1234@localhost:3306/test' #这里登陆的是root用户，要填上自己的密码，MySQL的默认端口是3306，填上之前创建的数据库名text1
#app.config['SQLALCHEMY_TRACK_MODIFICATIONS']=True #设置这一项是每次请求结束后都会自动提交数据库中的变动
#db = SQLAlchemy(app) #实例化
def queryByname(name):
	conn = pymysql.connect(host="localhost",user="root",password="1234",database="test",charset="utf8")
	cursor=conn.cursor()

	sql="SELECT * FROM `student` WHERE `studentName` = %s"

	cursor.execute(sql,name)
	result = cursor.fetchone()
	return result


# class Student(db.Model):
    # __tablename__ = 'student'
    # studentId = db.Column(db.Integer, primary_key=True)
    # studentName = db.Column(db.String(64), unique=True)
    # age = db.Column(db.Integer, unique=True)
    # def __repr__(self):
        # return '<Role %r>' % self.name
@app.route('/<username>',methods=['GET'])
def indexone(username):
    user_info1 = queryByname(username)
    if user_info1 == "" or user_info1 == None:
        print("不存在这个人，请重新输入")
        return "<h1>不存在这个人，%s  请重新输入用户名称 </h1>" % username
    print(user_info1)
    #return "<h1>{{user_info1}}</h1>"
    return render_template('index.html',user_info1=user_info1[1])
    #return user_info1
	
@app.route('/')
def index():
	return '<h1>hello flask</h1>'
	
if __name__ == '__main__':
	app.run(debug=True)