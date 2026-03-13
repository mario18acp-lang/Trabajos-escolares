alter table libros rename column precop to precio;

insert into libros values ('1', 'Patas Arriba: la escuela del mundo al reves','1','370.00');

insert into libros (libro_id,titulo,autor_id, precio) values
('2', 'Harry Potter y la camara secreta', '2', '300.00'),
('3', 'Cien años de soledad', '3', '298.00'),
('4', 'It', '4', '439.00'),
('5', 'El Hobbit', '5', '448.00'),
('6', 'La fiesta del chivo', '6', '409.00'),
('7', 'Don Quijote de la Mancha', '7','315.00'),
('8', 'El Conde de Montecristo', '8', '109.00'),
('9', 'Los Miserables', '9', '84.00'),
('10', 'Crimen y castigo', '10', '194.00');

select * from libros;