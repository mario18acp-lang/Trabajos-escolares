---REVISAR BASE DE DATOS

SELECT * FROM investigadores;

select * from proyectos;

select * from datos;

--CRUD

--CREATE (CREAR)

insert into investigadores(nombre, apellido, especialidad, años, experiencia) values
('Ana', 'Pérez','Biologia', 5);

--READ (LEER)

select nombre, apellido from Investigadores where años_experiencia > 10;

--UPDATE (ACTUALIZAR)

update Investigadores set años_experiencia = 8 where investigador_id =1;

---DELETE (BORRAR)
----DELETE from Proyectos where fecha_fin < '2022-01-01'