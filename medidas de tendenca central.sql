---SUM
---calcular la suma total de años de experiencia de los investigadores
select sum (años_experiencia)from investigadores;

---AVERAGE promedio años de experiencia
select round (avg (años_experiencia),2) from investigadores;

select sum (años_experiencia), round (avg (años_experiencia),2) from investigadores;

---COUNT (+) CONTAR EL NUMERO TOTAL DE REGISTROS EN LA TABLA PROYECTOS

select count(nombre_proyecto) from proyectos;
select count (*) from proyectos;
select count(especialidad) from investigadores;

---encontrar el numero menor de años de experiencia de los investigadores

select min(años_experiencia) from investigadores;
select nombre, apellido
from investigadores
where años_experiencia <= 1;


-----mayor numero
select max(años_experiencia) from investigadores;
select nombre, apellido
from investigadores
where años_experiencia >= 12;

---STRING__AGG
----- CONCATENAR todos los nombres de los proyectos en una sola cadena separados por comas

select string_agg(nombre_proyecto, ',') from proyectos;

---stddev
---calcular desviacion estandar de años de experiencia de investigadores

select round (stddev(años_experiencia),2) from investigadores;

---variance (varianza)

select round (variance(años_experiencia),2) from investigadores;


---AVG con group by
--calcular el promedio de las variables de los datos, agupados por categoria

select categoria
select categoría, avg(variable1)
from datos
group by categoría;

--Obtén un resumen estadístico de los proyectos, incluyendo el número total de proyectos, 
--la duración promedio de los proyectos (en días), 
--la duración mínima y máxima de los proyectos, 
--y la desviación estándar de la duración de los proyectos. 
--Considera que la duración de un proyecto es la diferencia en días 
--entre fecha_fin y fecha_inicio.

select count (nombre_proyecto) from proyectos;
select round(avg(fecha_fin - fecha_inicio), 2) from proyectos;
select min(fecha_fin - fecha_inicio) from proyectos;
select max(fecha_fin - fecha_inicio) from proyectos;
select round (stddev(fecha_fin - fecha_inicio),2) from proyectos;