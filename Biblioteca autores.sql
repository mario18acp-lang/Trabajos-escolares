--CREAR LA TABLA AUTORES

create table autores (
	autor_id int primary key,
	nombre varchar (50),
	apellido varchar (50),
	fecha_nacimiento date
);

--Crear tabla libros
create table libros (
	libro_id int primary key,
	titulo varchar (100),
	autor_id int,
	precop decimal (10,2),
	foreign key (autor_id) references autores (autor_id)
);