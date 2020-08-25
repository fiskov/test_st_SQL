select product_name 'Наименование' 
from products p
where not exists
	(select s.product_id from stocks s where p.product_id=s.product_id)