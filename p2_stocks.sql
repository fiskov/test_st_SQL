DELETE FROM stocks;

DECLARE @id int
   
DECLARE store_cur CURSOR FOR 
	SELECT store_id 
	FROM stores
   
--проходим курсором таблицу с магазинами
OPEN store_cur

FETCH NEXT FROM store_cur INTO @id
WHILE @@FETCH_STATUS = 0
BEGIN
	--на каждую итерацию цикла дописываем в stocks случайное кол-во строк из products (15-30%)
	--для каждого product берем случайно кол-во от 1 до 15
	insert into stocks (store_id, product_id, quantity) 
		select @id store_id, t_quantity.product_id, t_quantity.quantity from (
		select t_prod.*, (ABS(CHECKSUM(NewId())) % 15 + 1) quantity
			from (
				SELECT TOP (FLOOR(RAND()*15+15)) percent product_id FROM products
				ORDER BY NEWID()
			) as t_prod
		) as t_quantity		

	FETCH NEXT FROM store_cur INTO @id
END
   
CLOSE store_cur  
DEALLOCATE store_cur 