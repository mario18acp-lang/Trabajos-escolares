--1. Diseñar una Nueva Tabla: editoriales
--Diseñar una Nueva Tabla: Diseñen una tabla editoriales 
--que contenga los siguientes campos:
--• editorial_id: ID de la editorial.
--• nombre: Nombre de la editorial.
--• direccion: Dirección de la editorial.
--• telefono: Teléfono de contacto.

create table editoriales1 (
	editorial_id serial primary key,
	nombre varchar(100),
	direccion varchar (150),
	telefono varchar (50)
);

--2. Agregar una relación a libros
--Agregar una relación a libros: 
--Modificar la tabla libros para que incluya 
--un campo editorial_id que haga referencia a la tabla editoriales.

alter table libros1
add column editorial_id int;

select * from libros1;

--2.1 Actualizar datos a la columna editorial_id de libros

update libros1 
set editorial_id = 1
where libro_id in (101, 102, 103, 104, 105, 106);

update libros1 
set editorial_id = 1
where libro_id in (107, 108, 109, 110, 111, 112);

update libros1 
set editorial_id = 1
where libro_id in (113, 114, 115, 116, 117, 118);

update libros1 
set editorial_id = 1
where libro_id in (119, 120, 121, 122, 123, 124);

INSERT INTO editoriales1 (nombre, direccion, telefono) VALUES
('Editorial A', 'Direccion A', '1234567890'),
('Editorial B', 'Direccion B', '0987654321'),
('Editorial C', 'Direccion C', '7894561231'),
('Editorial D', 'Direccion D', '4658612153'),
('Editorial E', 'Direccion E', '5786846351');

select * from editoriales1;

--4. Consultas con Joins
--Consultas con Joins: Solicitar una consulta que retorne 
--todos los libros junto con el nombre de su autor 
--y la editorial que lo publicó.

select l.titulo as libros, a.nombre || ''|| a.apellido as autor, e.nombre as editorial
from libros1 l
left join autores1 a on l.autor_id = a.autor_id
inner join editoriales1 e on l.editorial_id = e.editorial_id;
