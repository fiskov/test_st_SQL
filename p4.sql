SELECT store_name 'Наименование магазина', product_name 'Наименование товара',
		 quantity 'Количество на остатке', unit_name 'Ед. изм.'
FROM stores 
	INNER JOIN stocks ON stores.store_id = stocks.store_id 
	INNER JOIN products ON stocks.product_id = products.product_id 
	INNER JOIN units ON products.unit_id = units.unit_id
