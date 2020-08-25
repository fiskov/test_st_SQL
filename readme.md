# Тестовое задание для компании СТ...


## 1. Создайте следующие таблицы: 

- Магазины 
```SQL
CREATE TABLE [dbo].[stores](
	[store_id] [int] IDENTITY(1,1) NOT NULL,
	[store_name] [nvarchar](150) NOT NULL,
	[store_address] [nvarchar](250) NOT NULL,
	[store_phone] [nvarchar](30) NULL,
 CONSTRAINT [PK_stores] PRIMARY KEY CLUSTERED 
(
	[store_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
```
![p011.png](https://github.com/fiskov/test_st_SQL/blob/master/Image/p011.png)

- Товары- Остатки товара в магазинах

```SQL
CREATE TABLE [dbo].[products](
	[product_id] [int] IDENTITY(1,1) NOT NULL,
	[vendor_id] [nvarchar](30) NULL,
	[product_name] [nvarchar](250) NOT NULL,
	[unit_id] [int] NOT NULL,
	[price] [decimal](18, 4) NOT NULL,
 CONSTRAINT [PK_products] PRIMARY KEY CLUSTERED 
(
	[product_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[products]  WITH CHECK ADD  CONSTRAINT [FK_products_units] FOREIGN KEY([unit_id])
REFERENCES [dbo].[units] ([unit_id])
GO

ALTER TABLE [dbo].[products] CHECK CONSTRAINT [FK_products_units]
GO
```
![p012.png](https://github.com/fiskov/test_st_SQL/blob/master/Image/p012.png)
![p013.png](https://github.com/fiskov/test_st_SQL/blob/master/Image/p013.png)

- Остатки товара в магазинах

```SQL
CREATE TABLE [dbo].[stocks](
	[stock_id] [int] IDENTITY(1,1) NOT NULL,
	[product_id] [int] NOT NULL,
	[store_id] [int] NOT NULL,
	[quantity] [int] NOT NULL,
 CONSTRAINT [PK_stocks] PRIMARY KEY CLUSTERED 
(
	[stock_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[stocks]  WITH CHECK ADD  CONSTRAINT [FK_stocks_products] FOREIGN KEY([product_id])
REFERENCES [dbo].[products] ([product_id])
GO

ALTER TABLE [dbo].[stocks] CHECK CONSTRAINT [FK_stocks_products]
GO

ALTER TABLE [dbo].[stocks]  WITH CHECK ADD  CONSTRAINT [FK_stocks_stores] FOREIGN KEY([store_id])
REFERENCES [dbo].[stores] ([store_id])
GO

ALTER TABLE [dbo].[stocks] CHECK CONSTRAINT [FK_stocks_stores]
GO
```
![p014.png](https://github.com/fiskov/test_st_SQL/blob/master/Image/p014.png)

- Покупатели

```SQL
CREATE TABLE [dbo].[customers](
	[customer_id] [int] IDENTITY(1,1) NOT NULL,
	[customer_phone] [nvarchar](50) NOT NULL,
	[customer_name] [nvarchar](150) NOT NULL,
 CONSTRAINT [PK_customers] PRIMARY KEY CLUSTERED 
(
	[customer_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

```
![p015.png](https://github.com/fiskov/test_st_SQL/blob/master/Image/p015.png)

- Документы
```SQL
CREATE TABLE [dbo].[orders](
	[order_id] [int] IDENTITY(1,1) NOT NULL,
	[consumer_id] [int] NOT NULL,
	[store_id] [int] NOT NULL,
	[product_id] [int] NOT NULL,
	[order_quantity] [int] NOT NULL,
	[datetime] [datetime] NOT NULL,
 CONSTRAINT [PK_orders] PRIMARY KEY CLUSTERED 
(
	[order_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[orders]  WITH CHECK ADD  CONSTRAINT [FK_orders_customers] FOREIGN KEY([consumer_id])
REFERENCES [dbo].[customers] ([customer_id])
GO

ALTER TABLE [dbo].[orders] CHECK CONSTRAINT [FK_orders_customers]
GO

ALTER TABLE [dbo].[orders]  WITH CHECK ADD  CONSTRAINT [FK_orders_products] FOREIGN KEY([product_id])
REFERENCES [dbo].[products] ([product_id])
GO

ALTER TABLE [dbo].[orders] CHECK CONSTRAINT [FK_orders_products]
GO

ALTER TABLE [dbo].[orders]  WITH CHECK ADD  CONSTRAINT [FK_orders_stores] FOREIGN KEY([store_id])
REFERENCES [dbo].[stores] ([store_id])
GO

ALTER TABLE [dbo].[orders] CHECK CONSTRAINT [FK_orders_stores]
GO

```
![p016.png](https://github.com/fiskov/test_st_SQL/blob/master/Image/p016.png)

## 2. Заполните таблицы:

- Магазины: не менее 100 объектов
Перечень магазинов взят из портала открытых данных в Интернете.

- Товары: не менее 1000 объектов
Перечень товаров – прайс какого-то компьютерного магазина.

- Покупатели: не менее 100 объектов
Генератор имен и телефоны случайным числом

- Остатки товара: в каждом магазине должно оказаться на остатке не
менее 15% и не более 30% позиций товара от общей номенклатуры
(1000 товаров всего / В каждый магазин не менее 150 и не более 300
позиций товара на остаток). Количество каждого товара не более 15 шт.
Без курсора лишь одним сложным запросом создать не удалось, т.к. при использовании вложенного подзапроса кол-во выбранных строк товаров выдает одинаковое для всех магазинов.

```SQL
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
	--на каждую итерацию цикла дописываем в stocks случайное кол-во строк из products
	insert into stocks (store_id, product_id, quantity) 
		
		select @id store_id, t_quantity.product_id, t_quantity.quantity from (
		select t_prod.*, (ABS(CHECKSUM(NewId())) % 16) quantity
			from (
				SELECT TOP (FLOOR(RAND()*15+15)) percent product_id FROM products
				ORDER BY NEWID()
			) as t_prod
		) as t_quantity		

	FETCH NEXT FROM store_cur INTO @id
END
   
CLOSE store_cur  
DEALLOCATE store_cur
```
Без курсора лишь одним сложным запросом создать не удалось, т.к. при использовании вложенного подзапроса кол-во выбранных строк товаров выдает одинаковое для всех магазинов.

## 3. Инициация покупок.
В результате должен получиться скрипт, который создаст документы по следующему алгоритму:
- Каждый покупатель должен купить в каждом магазине не менее 3% и не более 7% от находящегося на остатке товара

Если считать, что в каждом магазине должны побывать все «не менее 100» покупателей и купить по 3-7% от общего кол-ва товара, и товар неделим и не пополняется, то части покупателей не удастся совершить сделку. Например, в том случае, когда у нас в магазине 15*150 единиц товаров, а покупатели берут по 7% (с округлением вверх, т.к. нельзя половину монитора купить), уже на 78 покупателе магазин опустеет и остальные покупатели ничего не купят. 
Буду считать, то магазины оперативно пополняются, но таким же количеством, что были изначально.

Не совсем понятно, каким образом распределять покупки одного покупателя в одном магазине. Буду считать, что покупает случайным образом любое количество любого товара до тех пор в пределах остатка на складе, пока не достигнет ранее полученного значения от 3% до 7% от общего количества товара на остатках.

```SQL
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
```

## 4. Напишите запрос, который покажет количество товара оставшегося на остатке и его количество, на каждый магазин:
“Наименование магазина | Наименование товара | Количество на остатке”
(Не может быть более 1 строки с одинаковым значением: Наименование магазина | Наименование товара)

```SQL
select store_name 'Наименование магазина', product_name 'Наименование товара',
		 quantity 'Количество на остатке', unit_name 'Ед. изм.'
from stores 
	inner join stocks ON stores.store_id = stocks.store_id 
	inner join products ON stocks.product_id = products.product_id 
	inner join units ON products.unit_id = units.unit_id
```
![p040.png](https://github.com/fiskov/test_st_SQL/blob/master/Image/p040.png)

## 5. Напишите запрос, который вернет информацию о последней покупке каждого товара:
“Наименование товара | Наименование Магазина| Дата и время покупки”.
(Не может быть более 1 строки с одинаковым значением: Наименование товара)

```SQL
select products.product_name 'Наименование товара',
		stores.store_name 'Наименование Магазина', 
		r.dt 'Дата и время покупки' 
from orders 
	inner join
		(select product_id, max(datetime) dt from orders group by product_id) r
		on r.product_id = orders.product_id and r.dt = orders.datetime
	inner join stores on orders.store_id = stores.store_id
	inner join products on products.product_id = r.product_id
order by r.product_id
```
![p050.png](https://github.com/fiskov/test_st_SQL/blob/master/Image/p050.png)

## 6. Напишите запрос, который вернет количество купленного товара во всех магазинах, относительно Покупателя:
“ФИО покупателя | Номер телефона покупателя | Количество”
(Не может быть более 1 строки с одинаковым значением: ФИО покупателя)

```SQL
select customers.customer_name 'ФИО покупателя',
		customers.customer_phone 'Номер телефона покупателя', 
		r.q 'Количество' 
from customers 
	inner join
		(select customer_id, sum(order_quantity) q from orders group by customer_id) r
		on r.customer_id = customers.customer_id
order by r.customer_id
```
![p060.png](https://github.com/fiskov/test_st_SQL/blob/master/Image/p060.png)

## 7. Напишите запрос, который вернет все товары, которые никогда не продавались ни в одном магазинов, но есть на остатках.

```SQL
select product_name 'Наименование' 
from products p inner join stocks s on p.product_id=s.product_id
where not exists
	(select orders.product_id from orders where s.product_id = orders.product_id)
```
![p070.png](https://github.com/fiskov/test_st_SQL/blob/master/Image/p070.png)

## 8. Напишите запрос, который покажет все товары, которые никогда не смогут быть проданы относительно произведенных ранее действий.
Не менее 100 раз брался диапазон более 15% из списка. Вероятность того, что хотя бы один товар не был задействован крайне мала.

Если имеется в виду – «показать товары, которые не попали в таблицу остатки», то запрос будет следующим:
```SQL
select product_name 'Наименование' 
from products p
where not exists
	(select s.product_id from stocks s where p.product_id=s.product_id)
```


## Схема базы данных
![Схема базы данных](https://github.com/fiskov/test_st_SQL/blob/master/Image/scheme.png)
