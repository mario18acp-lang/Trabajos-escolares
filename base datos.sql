--- insertar datos a una tabla

insert into datos values ('1', 'Mario','123456','Raul_Zarate');

insert into datos (id,nombre,direccion, cedula_profesional) values
('2', 'Mariana Gazcon', 'camino san blas tepic', 'X2432'),
('3', 'Sebatian Angeles', 'camino real de calacoya', '4077'),
('4', 'Karen Zetina', 'boulevares de lago', '22783');

select * from datos;

--- Actualizar datos en tabla

select * from datos;

update datos
set direccion = 'Fernando, Benito Juarez'
where cedula_profesional = '123456';


--- borrar un dato

select * from datos;

delete from datos
where id = 1;

