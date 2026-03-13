--Subconsultas correlacionadas
--para cada proyecto, cuenta el numero total de entradas de datos asociados

select p.nombre_proyecto, (select count(*) from datos d where d.proyecto_id = p.proyecto_id)
from proyectos p;

select p.nombre_proyecto, count(d.dato_id) as total_datos
from proyectos p
join datos d on d.proyecto_id = p.proyecto_id
group by p.nombre_proyecto;

---Subconsultas en from
---Seleccione los nombres y apellidos
---de los investigadores que tienen mas de 5 años de experiencia y menores de 10 años

select nombre, apellido
from investigadores 
where años_experiencia > 5 and años_experiencia < 10;

select nombre, apellido
from (select nombre, apellido, años_experiencia from investigadores where años_experiencia > 5)
where años_experiencia < 10;

----Obten el promedio general de variable1 y variable 2 por proyecto
--usando una subconsulta en from

select resumen.proyecto_id, p.nombre_proyecto, resumen.pv1, resumen.pv2
from (select proyecto_id, avg(variable1) as pv1, avg(variable2) as pv2 
from datos
group by proyecto_id) as resumen
inner join proyectos p on p.proyecto_id = resumen.proyecto_id;

---Muestra los proyectos que iniciaron despues del proyecto
---con la fecha de inicio mas antiguo de toda la base

select proyecto_id, nombre_proyecto, fecha_inicio
from proyectos
where fecha_inicio > (select min(fecha_inicio)from proyectos)
order by fecha_inicio asc;

---crea una vista que selecciones los nombres de los proyectos
--- y los nombres de los investigadores principales que tienen mas de 10 años de experiencia

create view vistaproyectos as
select p.nombre_proyecto, i.nombre
from proyectos p
join investigadores i on i.investigador_id = p.investigador_principal_id
where i.años_experiencia > 10;


select * from vistaproyectos;

create or replace view vistaproyectos as
select p.nombre_proyecto, i.nombre, i.apellido
from proyectos p
join investigadores i on i.investigador_id = p.investigador_principal_id
where i.años_experiencia > 10;