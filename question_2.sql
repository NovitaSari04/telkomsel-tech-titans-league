-- query to create table
 create table country(
	id INT,
	country_name VARCHAR(128),
	primary key(id)
)

create table city(
	id INT,
	city_name VARCHAR(128),
	postal_code varchar(16),
	country_id INT,
	primary key(id),
	CONSTRAINT fk_country
      FOREIGN KEY(country_id) 
	  REFERENCES country(id)
)

create table customer(
	id INT,
	customer_name VARCHAR(255),
	city_id INT,
	customer_address VARCHAR(255),
	contact_person VARCHAR(255) NULL,
	email VARCHAR(255),
	phone VARCHAR(255),
	primary key(id),
	CONSTRAINT fk_city
      FOREIGN KEY(city_id) 
	  REFERENCES city(id)
)

-- insert value into tables
insert into country (id, country_name)
	VALUES
		(1,'Austria'),
		(2,'Germany'),
		(3,'United Kingdom')
		
insert into city (id, city_name, postal_code, country_id)
	VALUES
		(1,'Wien','1010',1),
		(2,'Berlin','10115',2),
		(3,'Hamburg','20095',2),
		(4,'London','EC4V4AD',3)

insert into customer (id, customer_name, city_id, customer_address, contact_person, email, phone)
	VALUES
		(1,'Drogerie Wien',1,'Deckergasse 15A','Emil Steinbach','emil@drogeriewien.com',094234234),
		(2,'Cosmetics Store',4,'Watling Street 347','Jeremy Corbyn','jeremy@c-store.org',093923923),
		(3,'Kosmetikstudio',3,'Rothenbaumchaussee 53','Willy Brandt','willy@kosmetikstudio.com',094152222),
		(4,'Neue Kosmetik',1,'Karisplatz 2',null,'info@neuekosmetik.com',094109253),
		(5,'Bio Kosmetik',2,'Motzstrabe 23','Clara Zetkin','clara@biokosmetik.org',093825825),
		(6,'K-Wien',1,'Kamtner Strabe 204','Maria Rauch-Kallat','maria@kwien.org',093427002),
		(7,'Natural Cosmetics',4,'Clerkenwell Road 14B','Glenda Jackson','glena.j@natural-cosmetics.com',093555123),
		(8,'Kosmetik Plus',2,'Unter den Linden 1','Angela Merkel','angela@k-plus.com',094727727),
		(9,'New Line Cosmetics',4,'Devonshine Street 92','Oliver Cromwell','oliver@nic.org',093202404)

/*
expected output column -> country name | city_name | number of customer
planning the query to solve the problem:
	- calculate average customer per city
	- join tables, select country name, city name, count(*) as number of customer
	- filter number of customer > average customer per city
	- group by country_name, city_name
	- order by country_name ascending
*/

select country_name, 
		city_name, 
		count(*) as number_of_customer
from country
join city 
	on country.id = city.country_id
join customer 
	on city.id = customer.city_id
group by country_name, city_name
having count(*) > 
			(select count(distinct id) / count(distinct city_id) as avg_cust from customer)
order by country_name;
