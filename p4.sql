SELECT store_name '������������ ��������', product_name '������������ ������',
		 quantity '���������� �� �������', unit_name '��. ���.'
FROM stores 
	INNER JOIN stocks ON stores.store_id = stocks.store_id 
	INNER JOIN products ON stocks.product_id = products.product_id 
	INNER JOIN units ON products.unit_id = units.unit_id
