SET SERVEROUTPUT ON;
CREATE TABLE prueba (nro INTEGER PRIMARY KEY, dato VARCHAR2(80));
select * from prueba
BEGIN
FOR i IN 1..500 LOOP
    INSERT INTO prueba
    VALUES (i, 'Comenzando');
END LOOP;
END;

--Declare/seccion de declaracion
--BEGIN/seccion ejecutable
--EXCEPTION/Seccion de manejo de excepciones
--END;/ Todo ciclo termina en end y cada ejecucion termina con ;
-- /**/ comentar parrafo
--SET SERVEROUTPUT ON; ejecutar primero
DECLARE
a NUMBER(2);
BEGIN
a := &Ingrese_valora;
DBMS_OUTPUT.PUT_LINE('Valor de a externa '|| a);
    DECLARE
    a NUMBER(3) :=20;
    BEGIN
    DBMS_OUTPUT.PUT_LINE('Valor de a interna '|| a);
    END;
DBMS_OUTPUT.PUT_LINE('Valor de a  '|| a);
END;

CREATE TABLE emp (
    cod INTEGER PRIMARY KEY,
    nom VARCHAR2 (8) NOT NULL,
    fecha_ing DATE,
    sueldo INTEGER CHECK (sueldo > 0 )
);

DECLARE
fi emp.fecha_ing%TYPE;
nom VARCHAR2(20) := INITCAP ( 'paz ortiz' );
BEGIN
fi := ADD_MONTHS (SYSDATE, -14);
INSERT INTO emp VALUES (4329, SUBSTR(nom, 1,8),fi,10000);
END;
select * from emp

DECLARE
    nom emp.nom%TYPE;
    sue emp.sueldo%TYPE;
    cuantos NUMBER(8);
BEGIN
    Select nom, sueldo INTO nom, sue
    From emp WHERE cod =4329;
    DBMS_OUTPUT.PUT_LINE('El empleado' || nom || ' tiene sueldo ' || sue);
    Select Count(*) Into cuantos
    From emp;
DBMS_OUTPUT.PUT_LINE ('Total empleados' || cuantos);
END;

DECLARE
    a NUMBER := NULL;
BEGIN
    IF a = a THEN
        DBMS_OUTPUT.PUT_LINE('0 sea que NULL = NULL');
    ELSIF a <> a THEN
        DBMS_OUTPUT.PUT_LINE('0 sea que NULL <> NULL');
    ELSE 
        DBMS_OUTPUT.PUT_LINE('Indefinido, NULL no es ni = ni <> a NULL');
    END IF;
END;

DECLARE
    a NUMBER := NULL;
BEGIN
CASE
    WHEN a = a THEN
        DBMS_OUTPUT.PUT_LINE('O sea que NULL = NULL');
    WHEN a <> a THEN
        DBMS_OUTPUT.PUT_LINE('O sea que NULL <> NULL');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Indefinido, NULL no es ni = ni <> a NULL');
    END CASE;
END;
-- se puede ocupar el IF o CASE

--loop--
DECLARE
    cont NUMBER(4) := 0;
BEGIN
DELETE FROM prueba;
    LOOP
        INSERT INTO prueba VALUES(cont, 'Usando LOOP'||
        CEIL(DBMS_RANDOM.VALUE(1,100000))); --ceil=Redondea n hasta el valor superior
        cont := cont + 1;
    EXIT WHEN cont = 1000;
END LOOP;
END;

SELECT * FROM prueba

BEGIN
DELETE FROM prueba;
FOR i IN REVERSE 1..500 LOOP
    INSERT INTO prueba
    VALUES (i, 'Aprendiendo FOR');
END LOOP;
END;

--Pregunta y despues pega

DECLARE
    cont NUMBER(3) := 500;
BEGIN
Delete from prueba;
WHILE cont > 0 LOOP
    INSERT INTO PRUEBA VALUES
    (cont, DBMS_RANDOM.STRING('u',60) || cont);
    cont := cont - 1;
END LOOP;
END;

SELECT * FROM prueba


DECLARE
cantidad INTEGER;
BEGIN
SELECT count(1)INTO cantidad
FROM emp;
DBMS_OUTPUT.PUT_LINE('la cantidad de empleados es:'|| cantidad);
END;

INSERT INTO emp VALUES(); 


select * from emp;
drop table Departamento;

create table Departamento (
cod_depto integer primary key, 
nombre_depto varchar2(20)
);

create table Empleado (
cod_emp integer primary key,
nombre varchar2(20),
salario integer,
cod_dep integer, 
foreign key (cod_dep) REFERENCES departamento
);


insert into Departamento values(1,'sistemas');
insert into Departamento values (2,'auditoria');


insert into Empleado values(11,'Francisca',100,1);
insert into Empleado values(12,'eduardo',200,1);
insert into Empleado values(13,'soledad',100,2);


--realice  un cursos que imprima por pantallan el nombre de los departamentos y de los empleados que recibe los salarios mas altos


declare
cursor c_de_emp is
select nombre_Depto, nombre 
from Departamento d, Empleado e
where d.cod_depto=e.cod_dep and salario= (select max(salario) from Empleado);
nom_dep Departamento.nombre_depto%type;
nom_emp Empleado.nombre%type;
begin
    open c_de_emp;
    fetch c_de_emp into nom_dep, nom_emp;--fetch recorrer y sacar los datos de nuestra consulta
    while c_de_emp%found
    loop  
        DBMS_OUTPUT.PUT_LINE('El empleado es '||nom_emp || ' del departamento '||nom_dep); 
        fetch c_de_emp into nom_dep,nom_emp;
    end loop;
    close c_de_emp;    
end;
    
-- Realice un cursos que permita caltular la cantidad de empleados de cada departamento, que reciban menos del suelodo por teclado, meostrando el resutlado por pantalla 
DECLARE
cursor cant_emp (sal_con in number) is
select nombre_depto, count(*)
from Empleado E, Departamento D where E.cod_dep=D.cod_depto and
E.salario<=sal_con group by nombre_depto;
depto Departamento.nombre_depto%TYPE;
Cant number;
Sal_con number;

BEGIN
Sal_con:= &Ingrese_valor;
open cant_emp(Sal_con);
fetch cant_emp into depto, cant;
while cant_emp%found
LOOP
dbms_output.put_line(depto || ' ' || cant);
fetch cant_emp into depto, cant;
end loop;
close cant_emp;
end;



-- CREE UN CURSOR QUE ÉRMITA MOSTRAR POR PANTALLA LA CANTIDAD DE EMPLEADOS QUE TIENE CADA UNO DE LOS DEPARTAMENTOS
select d.nombre_depto, count(1)
from departamento d, empleado e
where d.cod_depto=e.cod_dep


declare
cursor c_emp is
select d.nombre_depto, count(1)
from departamento d, empleado e
where d.cod_depto =e.cod_dep
group by d.nombre_depto;
nombre varchar2(20);
cantidad integer;

begin
open c_emp;
fetch c_emp into nombre, cantidad;
while c_emp%found
loop
    dbms_output.put_line(nombre || ' ' || cantidad);
    fetch c_emp into nombre, cantidad;
end loop;
close c_emp;
end;




--FOR tipo 1


declare
cursor c_emp is
select d.nombre_depto, count(1) as cantidad
from departamento d, empleado e
where d.cod_depto =e.cod_dep
group by d.nombre_depto;

begin
    for i in c_emp
    loop
    dbms_output.put_line(i.nombre_depto || ' ' || i.cantidad);
    end loop;
    end;
    
-- FOR tipo 2


begin
    for i in (select d.nombre_depto, count(1) as cantidad
             from departamento d, empleado e
             where d.cod_depto =e.cod_dep
             group by d.nombre_depto)
             
group by d.nombre_depto;
    loop
    dbms_output.put_line(i.nombre_depto || ' ' || i.cantidad);
    end loop;
    end;
    
    


---TAREA CURSORES--------------------------------------------------------------------------------------------------------------------------------]
-- CREE UN PROGRAMA QUE PERMITA DEFINIR EL CUARTIL DE CADA DEPARTAMENTO SEGUN LA CANTIDAD DE EMPLEADOS, DE ACUERDO A LA SIGUIENTE CLASIFICACION

--forma 1

declare
cursor c_emp is
select d.nombre_depto, count(1)
from departamento d, empleado e
where d.cod_depto =e.cod_dep
group by d.nombre_depto;
nombre varchar2(20);
cantidad integer;

begin
open c_emp;
fetch c_emp into nombre, cantidad;
while c_emp%found

loop
    if cantidad <=10 then
    dbms_output.put_line(nombre || 'es cuartil 1');
    elsif cantidad >10 and cantidad <=30 then
    dbms_output.put_line(nombre || ' es cuartil 2');
    elsif cantidad >30 and cantidad <=40 then
    dbms_output.put_line(nombre|| 'es cuartil 3');
    else 
    dbms_output.put_line(nombre || 'es cuartil 4');
     end if;
    fetch c_emp into nombre, cantidad;
end loop;
close c_emp;
end;
    

-- forma 2 




declare
cursor c_emp is
select d.nombre_depto, count(1)
from departamento d, empleado e
where d.cod_depto =e.cod_dep
group by d.nombre_depto;
nombre varchar2(20);
cantidad integer;
Q1 integer:=0;
Q2 integer:=Q|+1;
Q3 integer:=Q2+1;
Q4 integer:=Q3+1;
Q5 integer:=Q4+1;
Q6 integer:=Q5+1;

begin
open c_emp;
fetch c_emp into nombre, cantidad;
while c_emp%found

loop
    if cantidad <=10 then
    q1+a2......
    elsif cantidad >10 and cantidad <=30 then
    
    elsif cantidad >30 and cantidad <=40 then
    
    else 
   
     end if;
    fetch c_emp into nombre, cantidad;
end loop;
close c_emp;
dbms_output.put_line(nombre || 'es cuartil 1');
dbms_output.put_line(nombre || ' es cuartil 2');
dbms_output.put_line(nombre|| 'es cuartil 3');
 dbms_output.put_line(nombre || 'es cuartil 4');

end;




--CREE UN PROGRAMA QUE PERMITA AUMENTAR EL SALARIO UN 15% A LAS PERSONAS QUE GANAN MENOS DE 300

declare
cursor c_sal is 
select cod_emp, salario from empleado where salario<300 for update;
codigo integer;
cant_sal integer;
begin
    open c_sal;
    fetch c_sal into codigo, cant_sal;
    while c_sal%found
    loop
        update empleado set salario = salario*1.15 where current of c_sal;
        fetch c_sal into codigo, cant_sal;
    end loop;
    close c_sal;
end;

select * from empleado;



