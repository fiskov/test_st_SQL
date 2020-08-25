# �������� ������� ��� �������� ��...


## 1. �������� ��������� �������: 

- �������� 
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

- ������- ������� ������ � ���������

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

- ������� ������ � ���������

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
![p013.png](https://github.com/fiskov/test_st_SQL/blob/master/Image/p013.png)

- ����������

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
![p014.png](https://github.com/fiskov/test_st_SQL/blob/master/Image/p014.png)

- ���������
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
![p015.png](https://github.com/fiskov/test_st_SQL/blob/master/Image/p015.png)

## 2. ��������� �������:

- ��������: �� ����� 100 ��������
�������� ��������� ���� �� ������� �������� ������ � ���������.

- ������: �� ����� 1000 ��������
�������� ������� � ����� ������-�� ������������� ��������.

- ����������: �� ����� 100 ��������
��������� ���� � �������� ��������� ������

- ������� ������: � ������ �������� ������ ��������� �� ������� ��
����� 15% � �� ����� 30% ������� ������ �� ����� ������������
(1000 ������� ����� / � ������ ������� �� ����� 150 � �� ����� 300
������� ������ �� �������). ���������� ������� ������ �� ����� 15 ��.
��� ������� ���� ����� ������� �������� ������� �� �������, �.�. ��� ������������� ���������� ���������� ���-�� ��������� ����� ������� ������ ���������� ��� ���� ���������.

```SQL
DELETE FROM stocks;

DECLARE @id int
   
DECLARE store_cur CURSOR FOR 
	SELECT store_id 
	FROM stores
   
--�������� �������� ������� � ����������
OPEN store_cur

FETCH NEXT FROM store_cur INTO @id
WHILE @@FETCH_STATUS = 0
BEGIN
	--�� ������ �������� ����� ���������� � stocks ��������� ���-�� ����� �� products
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
��� ������� ���� ����� ������� �������� ������� �� �������, �.�. ��� ������������� ���������� ���������� ���-�� ��������� ����� ������� ������ ���������� ��� ���� ���������.

## 3. ��������� �������.
� ���������� ������ ���������� ������, ������� ������� ��������� �� ���������� ���������:
- ������ ���������� ������ ������ � ������ �������� �� ����� 3% � �� ����� 7% �� ������������ �� ������� ������

���� �������, ��� � ������ �������� ������ �������� ��� ��� ����� 100� ����������� � ������ �� 3-7% �� ������ ���-�� ������, � ����� ������� � �� �����������, �� ����� ����������� �� ������� ��������� ������. ��������, � ��� ������, ����� � ��� � �������� 15*150 ������ �������, � ���������� ����� �� 7% (� ����������� �����, �.�. ������ �������� �������� ������), ��� �� 78 ���������� ������� �������� � ��������� ���������� ������ �� �����. 
���� �������, �� �������� ���������� �����������, �� ����� �� �����������, ��� ���� ����������.

�� ������ �������, ����� ������� ������������ ������� ������ ���������� � ����� ��������. ���� �������, ��� �������� ��������� ������� ����� ���������� ������ ������ �� ��� ��� � �������� ������� �� ������, ���� �� ��������� ����� ����������� �������� �� 3% �� 7% �� ������ ���������� ������ �� ��������.

```SQL
--����������� ��� ������
DELETE FROM orders
GO

DECLARE @store_id int
DECLARE @product_sum int

--�������� �������� ������� � ���������� �� ��������
DECLARE store_cur CURSOR FOR 
	SELECT store_id, sum(quantity) product_sum FROM stocks GROUP BY store_id ORDER BY store_id
OPEN store_cur

FETCH NEXT FROM store_cur INTO @store_id, @product_sum
WHILE @@FETCH_STATUS = 0
BEGIN
	DECLARE @prod_id int
	DECLARE @cust_id int

	--�������� �������� ���� �����������	
	DECLARE customer_cur CURSOR FOR 
		SELECT customer_id FROM customers
	OPEN customer_cur

	FETCH NEXT FROM customer_cur INTO @cust_id
	WHILE @@FETCH_STATUS = 0
	BEGIN
		DECLARE @product_37 int
		DECLARE @quantity int
		DECLARE @quantity_temp int
		
		--���-�� � ����� ���������� � ���� �������� ������ �� 3% �� 7%
		SET @product_37 = CEILING((RAND() * 0.04 + 0.03) * @product_sum)
		SET @quantity_temp = 0

		--�������� �������� ������� � �������� � �������� ��� ������� ��������
		--����� ������ �� ����� 1 ������� ������
		DECLARE product_cur CURSOR FOR 
			select product_id, CEILING(RAND()*(quantity-1)+1) 
				from stocks where store_id=@store_id order by NEWID()
		OPEN product_cur

		FETCH NEXT FROM product_cur INTO @prod_id, @quantity
		WHILE (@@FETCH_STATUS = 0) AND (@quantity_temp < @product_37)
		BEGIN
			--���������� ��������� ����-����� �� 2019 ���
			DECLARE @dt datetime
			set @dt = DATEADD(SECOND, rand()*(24*3600*365), '2019-01-01')
			--��������� ������ ���-�� ������ �� �������, ���� � ����� �� ����� ���������� 3-7% 
			DECLARE @q int
			SET @q = IIF(@product_37-@quantity_temp > @quantity, @quantity, @product_37-@quantity_temp)
			
			INSERT INTO orders (customer_id, store_id, product_id, order_quantity, datetime)
				VALUES (@cust_id, @store_id, @prod_id, @q, @dt)
			
			--����������� ������� ������ ��� ����������
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

## 4. �������� ������, ������� ������� ���������� ������ ����������� �� ������� � ��� ����������, �� ������ �������:
������������� �������� | ������������ ������ | ���������� �� �������
(�� ����� ���� ����� 1 ������ � ���������� ���������: ������������ �������� | ������������ ������)

```SQL
select store_name '������������ ��������', product_name '������������ ������',
		 quantity '���������� �� �������', unit_name '��. ���.'
from stores 
	inner join stocks ON stores.store_id = stocks.store_id 
	inner join products ON stocks.product_id = products.product_id 
	inner join units ON products.unit_id = units.unit_id
```
![p040.png](https://github.com/fiskov/test_st_SQL/blob/master/Image/p040.png)

## 5. �������� ������, ������� ������ ���������� � ��������� ������� ������� ������:
������������� ������ | ������������ ��������| ���� � ����� �������.
(�� ����� ���� ����� 1 ������ � ���������� ���������: ������������ ������)

```SQL
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
```
![p050.png](https://github.com/fiskov/test_st_SQL/blob/master/Image/p050.png)

## 6. �������� ������, ������� ������ ���������� ���������� ������ �� ���� ���������, ������������ ����������:
���� ���������� | ����� �������� ���������� | ����������
(�� ����� ���� ����� 1 ������ � ���������� ���������: ��� ����������)

```SQL
select customers.customer_name '��� ����������',
		customers.customer_phone '����� �������� ����������', 
		r.q '����������' 
from customers 
	inner join
		(select customer_id, sum(order_quantity) q from orders group by customer_id) r
		on r.customer_id = customers.customer_id
order by r.customer_id
```
![p060.png](https://github.com/fiskov/test_st_SQL/blob/master/Image/p060.png)

## 7. �������� ������, ������� ������ ��� ������, ������� ������� �� ����������� �� � ����� ���������, �� ���� �� ��������.

```SQL
select product_name '������������' 
from products p inner join stocks s on p.product_id=s.product_id
where not exists
	(select orders.product_id from orders where s.product_id = orders.product_id)
```
![p070.png](https://github.com/fiskov/test_st_SQL/blob/master/Image/p070.png)

## 8. �������� ������, ������� ������� ��� ������, ������� ������� �� ������ ���� ������� ������������ ������������� ����� ��������.
�� ����� 100 ��� ������ �������� ����� 15% �� ������. ����������� ����, ��� ���� �� ���� ����� �� ��� ������������ ������ ����.

���� ������� � ���� � ��������� ������, ������� �� ������ � ������� �������, �� ������ ����� ���������:
```SQL
select product_name '������������' 
from products p
where not exists
	(select s.product_id from stocks s where p.product_id=s.product_id)
```


## ����� ���� ������
![����� ���� ������](https://github.com/fiskov/test_st_SQL/blob/master/Image/scheme.png)
