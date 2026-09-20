-- console database university_main
--Task 2.1
CREATE TABLE IF NOT EXISTS students(
    student_id  SERIAL PRIMARY KEY,
    first_name varchar(50),
    last_name varchar(50),
    email varchar(100),
    phone char(15),
    date_of_birth date,
    enrollment_date date,
    gpa decimal(10, 2),
    is_active bool,
    graduation_year smallint
);

select * from students;

CREATE TABLE IF NOT EXISTS professors(
    professor_id  SERIAL PRIMARY KEY,
    first_name varchar(50),
    last_name varchar(50),
    email varchar(100),
    office_number varchar(20),
    hire_date date,
    salary decimal(10, 2),
    is_tenured bool,
    years_experience int
);

select * from professors;

CREATE TABLE IF NOT EXISTS courses(
    course_id SERIAL PRIMARY KEY,
    course_code char(8),
    course_title varchar(100),
    description text,
    credits smallint,
    max_enrollment int,
    course_fee decimal(10, 2),
    is_online bool,
    created_at timestamp without time zone
);

select * from courses;

--Task 2.2

CREATE TABLE IF NOT EXISTS class_schedule(
    schedule_id SERIAL PRIMARY KEY,
    course_id int,
    professor_id int,
    classroom varchar (20),
    class_date date,
    start_time time without time zone,
    end_time time without time zone,
    duration interval
);

select * from class_schedule;

CREATE TABLE IF NOT EXISTS student_records(
    record_id SERIAL PRIMARY KEY,
    student_id int,
    course_id int,
    semester varchar(20),
    year int,
    grade char(2),
    attendance_percentage decimal(4, 1),
    submission_timestamp timestamp,
    last_updated timestamp
);

select * from student_records;

--Task 3.1

ALTER TABLE students
    ADD COLUMN middle_name varchar(30),
    ADD COLUMN student_status varchar(20),
    ALTER COLUMN phone SET DATA TYPE char(20),
    ALTER COLUMN student_status SET DEFAULT 'ACTIVE',
    ALTER COLUMN gpa SET DEFAULT 0.00;

select * from students;

ALTER TABLE professors
    ADD COLUMN department_code char(5),
    ADD COLUMN research_area text,
    ALTER COLUMN years_experience SET DATA TYPE smallint,
    ALTER COLUMN is_tenured SET DEFAULT false,
    ADD COLUMN promotion_date date;

select * from professors;

ALTER TABLE courses
    ADD COLUMN prerequisite_course_id int,
    ADD COLUMN difficulty_level smallint,
    ALTER COLUMN course_code SET DATA TYPE varchar(10),
    ALTER COLUMN credits SET DEFAULT 3,
    ADD COLUMN lab_required bool DEFAULT false;

select  * from courses;

--Task 3.2

ALTER TABLE class_schedule
    ADD COLUMN room_capacity int,
    DROP COLUMN duration,
    ADD COLUMN session_type varchar(15),
    ALTER COLUMN classroom SET DATA TYPE varchar(30),
    ADD COLUMN equipment_needed text;

select * from class_schedule;

ALTER TABLE student_records
    ADD COLUMN extra_credit_points decimal(4, 1),
    ALTER COLUMN grade SET DATA TYPE char(5),
    ALTER COLUMN extra_credit_points SET DEFAULT 0.0,
    ADD COLUMN final_exam_date date,
    DROP COLUMN last_updated;

select * from student_records;

--Task 4.1

CREATE TABLE IF NOT EXISTS departments(
    department_id SERIAL PRIMARY KEY,
    department_name varchar(100),
    department_code char(5),
    building varchar(50),
    phone varchar(15),
    budget decimal(10, 2),
    established_year int
);

select * from departments;

CREATE TABLE IF NOT EXISTS library_books(
    book_id SERIAL PRIMARY KEY,
    isbn char(13),
    title varchar(200),
    author varchar(100),
    publisher varchar(100),
    publication_date date,
    price decimal(10, 2),
    is_available bool,
    acquisition_timestamp timestamp without time zone
);

select * from library_books;

CREATE TABLE IF NOT EXISTS student_book_loans(
    loan_id SERIAL PRIMARY KEY,
    student_id int,
    book_id int,
    loan_date date,
    due_date date,
    return_date date,
    fine_amount decimal (10, 2),
    loan_status varchar(20)
);

select * from student_book_loans;

--Task 4.2

ALTER TABLE professors
    ADD COLUMN department_id int;

ALTER TABLE students
    ADD COLUMN advisor_id int;

ALTER TABLE courses
    ADD COLUMN department_id int;

CREATE TABLE IF NOT EXISTS grade_scale(
    grade_id SERIAL PRIMARY KEY,
    letter_grade char(2),
    min_percentage decimal(4, 1),
    max_percentage decimal(4, 1),
    gpa_points decimal(4, 2)
);

select * from grade_scale;

CREATE TABLE IF NOT EXISTS semester_calendar(
    semester_id SERIAL PRIMARY KEY,
    semester_name varchar(20),
    academic_year int,
    start_date date,
    end_date date,
    registration_deadline timestamp,
    is_current bool
);

select * from semester_calendar;

--Task 5.1
DROP TABLE IF EXISTS student_book_loans, library_books, grade_scale;

CREATE TABLE IF NOT EXISTS semester_calendar(
    semester_id SERIAL PRIMARY KEY,
    semester_name varchar(20),
    academic_year int,
    start_date date,
    end_date date,
    registration_deadline timestamp,
    is_current bool,
    description text
);

DROP TABLE IF EXISTS semester_calendar CASCADE;
CREATE TABLE IF NOT EXISTS semester_calendar(
    semester_id SERIAL PRIMARY KEY,
    semester_name varchar(20),
    academic_year int,
    start_date date,
    end_date date,
    registration_deadline timestamp,
    is_current bool
);
--Task 5.2
ALTER DATABASE university_test IS_TEMPLATE false;
DROP DATABASE IF EXISTS university_test;
DROP DATABASE IF EXISTS university_destributed;
CREATE DATABASE university_backup
TEMPLATE = university_main;
