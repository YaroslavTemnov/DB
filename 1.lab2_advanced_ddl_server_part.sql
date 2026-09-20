-- console server
--Task 1.1
SELECT version();

CREATE DATABASE university_main
OWNER = postgres
TEMPLATE = template0
ENCODING = 'UTF-8';

CREATE DATABASE university_archive
CONNECTION LIMIT = 50
TEMPLATE = template0;

CREATE DATABASE university_test
IS_TEMPLATE = true
CONNECTION LIMIT = 10;

--Task 1.2

CREATE TABLESPACE student_data LOCATION 'C:/Users/Arosl/Desktop/folder/uni/DB/lab2/data/students';

CREATE TABLESPACE course_data
OWNER postgres
LOCATION 'C:/Users/Arosl/Desktop/folder/uni/DB/lab2/data/courses';

CREATE DATABASE university_distributed
TEMPLATE = template0
LC_COLLATE = 'C'
LC_CTYPE  = 'C'
ENCODING = 'LATIN9'
TABLESPACE = student_data;

