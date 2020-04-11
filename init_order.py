#! /usr/bin/env	python
# -*- coding: utf-8 -*- 
#
#用途:用于初始化order_master及order_detail表数据
#
import MySQLdb,string,sys
from faker import Faker

reload(sys)
sys.setdefaultencoding('utf-8')

try:
	conn = MySQLdb.connect(host ='127.0.0.1',port=3306,user ='root',passwd = '123456',db = 'imooc_db',charset="utf8")
	cursor = conn.cursor(MySQLdb.cursors.DictCursor)
	order_conn= MySQLdb.connect(host ='127.0.0.1',port=3306,user ='root',passwd = '123456',db = 'order_db',charset="utf8")
	order_custor=order_conn.cursor(MySQLdb.cursors.DictCursor)	
except MySQLdb.Error, e:
	print "Error %d: %s \n" % (e.args[0], e.args[1])

try:
	faker=Faker()
	#write data
	for i in range(0,10):
		#生产订单主表信息
		#在customer_login表中随机获取一个用户ID
		GetUserID="""
			select customer_id,concat(DATE_FORMAT(now(),'%Y%m%d'),left(rand()*1000000,3),right(concat('000',customer_id),3)) as order_sn
			from customer_login 
			order by rand()
			limit 1 
		"""
		cursor.execute(GetUserID)
		result=cursor.fetchone()
		customer_id=int(result["customer_id"])
		#生成order_sn格式yyyymmdd+3位随机数+userid后三位不足补0
		order_sn=result["order_sn"]
		#生成省，市，区ID
		GetAreaID="""
			select a.region_id as province,a.region_name as province_name,
			       b.region_id as city,b.region_name as city_name,
			       c.region_id as district,c.region_name as district_name
			from region_info a 
			join region_info b on b.parent_id=a.region_id
			join region_info c on c.parent_id=b.region_id
			where a.region_id>1
			order by rand()
			limit 1
		"""
		cursor.execute(GetAreaID)
		result=cursor.fetchone()
		province=int(result["province"])
		city=int(result["city"])		
		district=int(result["district"])

		InSQL="""
             insert into order_master(order_sn,customer_id,shipping_user,province,city,district,address
               ,payment_method,order_money,district_money,shipping_money,payment_money,create_time)
             values('%s',%d,'%s',%d,%d,%d,'%s',3,0,0,0,0,now())
		"""%(order_sn,customer_id,faker.name(),province,city,district,faker.address())
		#print InSQL
		order_custor.execute(InSQL)
		order_custor.execute('commit')
		#get order_id
		GetID="SELECT LAST_INSERT_ID() as id"
		order_custor.execute(GetID)
		result=order_custor.fetchone()
		order_id=int(result["id"])
		#生成订单明细数据
		##随机获取一条商品信息
		GetPro="""
			select product_id,product_name,price,average_cost
			from product_info 
			order by rand()
			limit 1
			"""
		cursor.execute(GetPro)
		result=cursor.fetchone()
		product_id=int(result["product_id"])
		product_name=str(result["product_name"])
		price=float(result["price"])
		average_cost=float(result["average_cost"])
		InsSQL="""
          insert into order_detail(order_id,product_id,product_name,product_cnt,product_price,average_cost,w_id)
          values(%d,%d,'%s',1,%f,%f,1)
        """%(order_id,product_id,product_name,price,average_cost)
		#print InsSQL
		order_custor.execute(InsSQL)
		order_custor.execute('commit')
		#回写订单主表相关数据
		UpdSQL="""
		Update order_master set order_money=%f where order_id=%d
		;
		"""%(price,order_id)
		order_custor.execute(UpdSQL)
		order_custor.execute('commit')

except MySQLdb.Error,e:
	print "Error %d: %s \n" % (e.args[0], e.args[1])
finally:
	cursor.close()
	conn.close()
