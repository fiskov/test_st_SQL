--выполняется пол минуты
DELETE FROM orders
GO

DECLARE @store_id int
DECLARE @product_sum int

--проходим курсором таблицу с магазинами из остатков
DECLARE store_cur CURSOR FOR 
	SELECT store_id, sum(quantity) product_sum FROM stocks GROUP BY store_id ORDER BY store_id
OPEN store_cur

FETCH NEXT FROM store_cur INTO @store_id, @product_sum
WHILE @@FETCH_STATUS = 0
BEGIN
	DECLARE @prod_id int
	DECLARE @cust_id int

	--проходим курсором всех покупателей	
	DECLARE customer_cur CURSOR FOR 
		SELECT customer_id FROM customers
	OPEN customer_cur

	FETCH NEXT FROM customer_cur INTO @cust_id
	WHILE @@FETCH_STATUS = 0
	BEGIN
		DECLARE @product_37 int
		DECLARE @quantity int
		DECLARE @quantity_temp int
		
		--кол-во у этого покупателя в этом магазине товара от 3% до 7%
		SET @product_37 = CEILING((RAND() * 0.04 + 0.03) * @product_sum)
		SET @quantity_temp = 0

		--проходим курсором таблицу с товарами с остатков для каждого магазина
		--будет куплем не менее 1 единицы товара
		DECLARE product_cur CURSOR FOR 
			select product_id, CEILING(RAND()*(quantity-1)+1) 
				from stocks where store_id=@store_id order by NEWID()
		OPEN product_cur

		FETCH NEXT FROM product_cur INTO @prod_id, @quantity
		WHILE (@@FETCH_STATUS = 0) AND (@quantity_temp < @product_37)
		BEGIN
			--генерируем случайную дату-время за 2019 год
			DECLARE @dt datetime
			set @dt = DATEADD(SECOND, rand()*(24*3600*365), '2019-01-01')
			--добавляем полное кол-во товара на остатке, если в сумме не будет превышения 3-7% 
			DECLARE @q int
			SET @q = IIF(@product_37-@quantity_temp > @quantity, @quantity, @product_37-@quantity_temp)
			
			INSERT INTO orders (customer_id, store_id, product_id, order_quantity, datetime)
				VALUES (@cust_id, @store_id, @prod_id, @q, @dt)
			
			--увеличиваем счетчик товара для покупателя
			SET @quantity_temp = @quantity_temp + @quantity
			FETCH NEXT FROM product_cur INTO @prod_id, @quantity
		END
		CLOSE product_cur  
		DEALLOCATE product_cur

		FETCH NEXT FROM customer_cur INTO @cust_id
	END
	CLOSE customer_cur  
	DEALLOCATE customer_cur 

	FETCH NEXT FROM store_cur INTO @store_id, @product_sum
END

CLOSE store_cur  
DEALLOCATE store_cur 