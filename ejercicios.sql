---JOINS

--INNER JOIN

----Encuentra los nombres de los proyectos junto con los nombres de los 
--investigadores principales asociados.

---DATOS
---nombre_proyectos PROYECTOS
---nombre, apellido INVESTIGADORES

select p.nombre_proyecto, i.nombre, i.apellido
from proyectos p
inner join investigadores i on i.investigador_id = p.investigador_principal_id;

--Selecciona todos los investigadores y sus proyectos asociados, 
--incluyendo aquellos investigadores que no tienen proyectos asignados.

select p.nombre_proyecto, i.nombre, i.apellido
from investigadores i
left join proyectos p ON i.investigador_id = p.investigador_principal_id;

--Selecciona todos los proyectos y sus investigadores principales, 
--incluyendo aquellos proyectos que no tienen investigadores asignados.

select p.nombre_proyecto, i.nombre, i.apellido
from investigadores i
right join proyectos p ON i.investigador_id = p.investigador_principal_id;



select p.nombre_proyecto, i.nombre, i.apellido
from investigadores i
full join proyectos p ON i.investigador_id = p.investigador_principal_id;