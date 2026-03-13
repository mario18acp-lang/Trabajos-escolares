---crear un procedimiento

--contar el numero de investigadores en la especialidad dada

create procedure contgarinvestigadores(espec varchar)
as $$
declare
	contador int;
begin
	select count(*) into contador
	from investigadores
	where especialidad =espec;

	raise notice 'el numero de investigadores en la especialidad %: es de:%', espec, contador;
end;
$$ language plpgsql;

call contgarinvestigadores('Física');

select * from investigadores;


--Ejercicio Integral:
--En este ejercicio, vamos a crear un procedimiento almacenado que 
--genere un reporte detallado de un investigador específico. Este reporte incluirá:
--Número total de proyectos en los que ha sido investigador principal.
--Duración promedio de estos proyectos.
--Suma total de la variable1 de todos los datos asociados a sus proyectos.
--Crear una vista temporal con esta información.
--Seleccionar la información de la vista creada y presentarla.

create procedure reporte3 (iid int)
as $$
declare	
	contar int;
	promedio float;
	sumavar1 int;
begin
	select count (*) into contar
	from proyectos
	where investigador_principal_id = iid;

	select avg(fecha_fin - fecha_inicio) into promedio
	from proyectos
	where investigador_principal_id = iid;

	select sum(variable1) into sumavar1
	from datos d
	inner join proyectos p on p.proyecto_id = d.proyecto_id
	where p.investigador_principal_id = iid;
	raise notice 'total de proyectos %: promedio:% suma de variable 1 %:',contar, promedio,sumavar1;	
	drop table if exists reporte_temporal cascade;
	create table reporte_temporal (
	investigador_id int,
	total_proyectos int,
	duracion_promedio numeric (10,2),
	suma_total_variable1 numeric (15,2));
	insert into reporte_temporal (
	investigador_id,
	total_proyectos.
	duracion_promedio,
	suma_total_variable1)
	values (iid,contar,promedio,sumavar1);
	drop view if exists vista_reporte;
	create view vista_reporte as
	select investigador_id,total_proyectos,duracion_promedio,suma_total_variable1
	from reporte_temporal;

end;

$$ language plpgsql;

call reporte3 (5);

select * from reporte_temporal;
select * from vista_reporte;

	
	

