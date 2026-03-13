---Crear una funcion que devuelva el numero total 
---de dias que duro un proyecto dado su proyecto_id

create function duracionproyecto(pid int) returns int
as $$
declare 
	duracion int;
begin
	select fecha_fin - fecha_inicio into duracion
	from proyectos
	where proyecto_id = pid;

	return duracion;
end;
$$ language plpgsql;

select duracionproyecto(9)

select proyecto_id, nombre_proyecto, duracionproyecto(proyecto_id) as duracion_dias
from proyectos
order by duracion_dias desc;

select fecha_fin - fecha_inicio
from proyectos;


---crear una funcion que dado un investigador_id,
---devuelva la suma total de variable1 de todos los datos asociados
---a los proyectos en los que el investigador es el principal

create function sumavariable1 (iid int) returns float
as $$
declare 
	total float;
begin
	select sum(d.variable1) into total
	from datos d
	inner join proyectos p on d.proyecto_id = p.proyecto_id
	where p.investigador_principal_id =iid;

	return total;
end;
$$ language plpgsql;

select sumavariable1(1);

create function sumavariable2(iid int) returns table (nombre_proyecto varchar, total float)
as $$
begin
	return query
	select p.nombre_proyecto, sum(d.variable1) as total
	from datos d
	inner join proyectos p on d.proyecto_id = p.proyecto_id
	where p.investigador_principal_id = iid
	group by p.nombre_proyecto;
end;
$$ language plpgsql;

select * from sumavariable2(5);


