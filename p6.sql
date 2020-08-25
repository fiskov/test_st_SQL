select customers.customer_name 'ФИО покупателя',
		customers.customer_phone 'Номер телефона покупателя', 
		r.q 'Количество' 
from customers 
	inner join
		(select customer_id, sum(order_quantity) q from orders group by customer_id) r
		on r.customer_id = customers.customer_id
order by r.customer_id
