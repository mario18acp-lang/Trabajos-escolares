select * from autores;
select * from libros;

UPDATE autores
SET fecha_nacimiento = ' 1892-01-03 '
WHERE autor_id = 5;

select l.titulo, a.nombre, a.apellido
from libros l
join autores a on l.autor_id = a.autor_id; 

select nombre from autores
union all
select titulo from libros;

SELECT libros.titulo AS "Libros", CONCAT(autores.nombre, ' ', autores.apellido) AS "Autores"
FROM libros
JOIN autores ON libros.autor_id = autores.autor_id;
