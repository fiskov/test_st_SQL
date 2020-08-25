select products.product_name '������������ ������',
		stores.store_name '������������ ��������', 
		r.dt '���� � ����� �������' 
from orders 
	inner join
		(select product_id, max(datetime) dt from orders group by product_id) r
		on r.product_id = orders.product_id and r.dt = orders.datetime
	inner join stores on orders.store_id = stores.store_id
	inner join products on products.product_id = r.product_id
order by r.product_id