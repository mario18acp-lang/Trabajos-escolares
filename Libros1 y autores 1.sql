-- Creación de la tabla de autores
CREATE TABLE autores1 (
    autor_id INT PRIMARY KEY,
    nombre VARCHAR(50),
    apellido VARCHAR(50),
    fecha_nacimiento DATE
);

-- Creación de la tabla de libros
CREATE TABLE libros1 (
    libro_id INT PRIMARY KEY,
    titulo VARCHAR(100),
    autor_id INT,
    año_publicacion INT,
    precio DECIMAL(10,2),
    FOREIGN KEY (autor_id) REFERENCES autores1(autor_id)
);

-- Inserción de datos en la tabla de autores
INSERT INTO autores1 (autor_id, nombre, apellido, fecha_nacimiento) VALUES
(1, 'Gabriel', 'García Márquez', '1927-03-06'),
(2, 'Isabel', 'Allende', '1942-08-02'),
(3, 'Jorge', 'Luis Borges', '1899-08-24'),
(4, 'Jane', 'Austen', '1775-12-16'),
(5, 'Mark', 'Twain', '1835-11-30'),
(6, 'Virginia', 'Woolf', '1882-01-25'),
(7, 'Ernest', 'Hemingway', '1899-07-21'),
(8, 'Leo', 'Tolstoy', '1828-09-09'),
(9, 'Agatha', 'Christie', '1890-09-15'),
(10, 'F. Scott', 'Fitzgerald', '1896-09-24'),
(11, 'Haruki', 'Murakami', '1949-01-12'),
(12, 'George', 'Orwell', '1903-06-25'),
(13, 'Kurt', 'Vonnegut', '1922-11-11'),
(14, 'Sylvia', 'Plath', '1932-10-27'),
(15, 'Ray', 'Bradbury', '1920-08-22'),
(16, 'J.D.', 'Salinger', '1919-01-01'),
(17, 'Franz', 'Kafka', '1883-07-03'),
(18, 'John', 'Steinbeck', '1902-02-27'),
(19, 'William', 'Golding', '1911-09-19'),
(20, 'Aldous', 'Huxley', '1894-07-26'),
(21, 'Margaret', 'Atwood', '1939-11-18'),
(22, 'James', 'Joyce', '1882-02-02'),
(23, 'Charles', 'Dickens', '1812-02-07');

-- Inserción de datos en la tabla de libros
INSERT INTO libros1 (libro_id, titulo, autor_id, año_publicacion, precio) VALUES
(101, 'Cien años de soledad', 1, 1967, 19.99),
(102, 'La casa de los espíritus', 2, 1982, 17.50),
(103, 'Ficciones', 3, 1944, 15.00),
(104, 'El amor en los tiempos del cólera', 1, 1985, 20.50),
(105, 'Orgullo y prejuicio', 4, 1813, 18.00),
(106, 'Las aventuras de Tom Sawyer', 5, 1876, 16.50),
(107, 'Mrs Dalloway', 6, 1925, 14.50),
(108, 'El viejo y el mar', 7, 1952, 12.99),
(109, 'Guerra y paz', 8, 1869, 22.00),
(110, 'Diez negritos', 9, 1939, 13.99),
(111, 'El gran Gatsby', 10, 1925, 15.00),
(112, 'Kafka en la orilla', 11, 2002, 19.50),
(113, '1984', 12, 1949, 17.50),
(114, 'Matadero cinco', 13, 1969, 16.00),
(115, 'La campana de cristal', 14, 1963, 14.50),
(116, 'Fahrenheit 451', 15, 1953, 13.99),
(117, 'El guardián entre el centeno', 16, 1951
, 18.00),
(118, 'La metamorfosis', 17, 1915, 12.50),
(119, 'Las uvas de la ira', 18, 1939, 16.99),
(120, 'El señor de las moscas', 19, 1954, 15.50),
(121, 'Un mundo feliz', 20, 1932, 14.99),
(122, 'El cuento de la criada', 21, 1985, 18.50),
(123, 'Ulises', 22, 1922, 21.00),
(124, 'Oliver Twist', 23, 1837, 17.00);


select * from autores1;
select * from libros1;
--- 1) Obtener todos los libros y sus autores

select l.titulo, a.nombre, a.apellido
from libros1 l
join autores1 a on l.autor_id = a.autor_id; 

select nombre from autores1
union all
select titulo from libros1

SELECT libros1.titulo AS "Libros", CONCAT(autores1.nombre, ' ', autores1.apellido) AS "Autores"
FROM libros1
JOIN autores1 ON libros1.autor_id = autores1.autor_id;

--- 2. libros publicados despues de 1980

select titulo as "Libros", año_publicacion as "Año"
from libros1
where año_publicacion <= 1980