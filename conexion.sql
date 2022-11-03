---TABLAS-------------------------]
create table socio(
soc_cod int primary key,
soc_nombre varchar2(20),
soc_tipo varchar2(20)
);

create table deporte(
dep_id int primary key,
dep_nombre varchar2(20),
dep_nivel varchar2(20)
);

create table asiste(
dep_id int ,
soc_cod int ,
asi_fecha date,
primary key (dep_id,soc_cod,asi_fecha),
foreign key (dep_id) references deporte,
foreign key (soc_cod)references socio
);

---INSERT VALUES---------------------------------------]
insert into socio values(1,'maria','inicial');
insert into socio values(2,'juan','permanente');
insert into socio values(3,'rocio','permanente');
insert into socio values(4,'luis','intermedio');

insert into deporte values(1,'natacion_ava','avanzado');
insert into deporte values(2,'natacion_bas','basico');
insert into deporte values(3,'zumba','general');
insert into deporte values(4,'patinaje','intermedio');

insert into asiste values(1,1,'02-07-2022');
insert into asiste values(1,1,'16-07-2022');
insert into asiste values(4,1,'12-07-2022');
insert into asiste values(1,1,'20-07-2022');
insert into asiste values(4,4,'02-07-2022');
insert into asiste values(2,2,'09-07-2022');
insert into asiste values(2,2,'15-07-2022');
insert into asiste values(2,3,'07-07-2022');
insert into asiste values(3,3,'15-07-2022');

---CONSULTAS-----------------------------------]

---1. Muestre el nombre de los deportes y de los socios que participan en deportes de tipo general.
select dep_nombre,soc_nombre
from socio s, deporte d, asiste a
where s.soc_cod = a.soc_cod and a.dep_id= d.dep_id and(dep_nivel= 'general')

---2. Muestre el nombre de los deportes y de los socios que participan en deportes de tipo general o avanzado.
select dep_nombre,soc_nombre
from socio s, deporte d, asiste a
where s.soc_cod = a.soc_cod and a.dep_id = d.dep_id
and(dep_nivel='general' or dep_nivel = 'avanzado')
---and dep_mivel in ('general','avanzado')


---3. Muestre el nombre de los socios que asistieron entre el 10 y 20 de julio.
select soc_nombre
from socio s, asiste a
where s.soc_cod = a.soc_cod and asi_fecha between '10/07/2022'and '20/07/2022' 

---4. Muestre el nombre de los socios que practican natación
select soc_nombre
from socio s, asiste a , deporte d
where s.soc_cod = a.soc_cod and a.dep_id = d.dep_id and dep_nombre like 'natacion%'

---5. Muestre el nombre de los deportes que no participan socios intermedios
select dep_nombre 
from deporte d, asiste a
where d.dep_id = a.dep_id and not exists 
    (select* from socio s where soc_tipo = 'intermedio' and a.soc_cod =s.soc_cod )
    
select dep_nombre
from deporte d, asiste a
where d.dep_id=a.dep_id and a.soc_cod not in 
    (select soc_cod from socio s where soc_tipo='intermedio');
---6. Muestre el nombre de los deportes que no participan socios intermedios ni permanente
select  dep_nombre
from deporte d, asiste a
where d.dep_id=a.dep_id and a.soc_cod not in 
    (select soc_cod from socio s where soc_tipo='intermedio' or soc_tipo='avanzado');

---7. Muestre el o los nombres de los socios que SÓLO practican deportes avanzados
select soc_nombre
from socio s, asiste a, deporte d
where s.soc_cod= a.soc_cod and d.dep_id = a.dep_id and dep_nivel ='avanzado' and 
not exists (select *from asiste a1, deporte d1 where d1.dep_id = a1.dep_id and dep_nivel <>'avanzado' and s.soc_cod= a1.soc_cod)



---8. Muestre el nombre de los deportes y de los socios y la cantidad de veces que asistieron durante el mes de julio del año 2022
select dep_nombre, soc_nombre , count(1)
from socio s, deporte d, asiste a 
where s.soc_cod=a.soc_cod and a.dep_id= d.dep_id and asi_fecha between '01/07/2022' and '30/07/2022'
group by dep_nombre, soc_nombre
having count (1)>2;

---9. Muestre el nombre del o los socios que más asistencia tuvo durante el mes de julio del 2022

create view asistencia(nombre_socio, veces) as(
CREATE VIEW ASISTENCIA(NOMBRE_SOCIO, VECES) AS (
SELECT SOC_NOMBRE, COUNT (1)
FROM SOCIO S, ASISTE A
WHERE S.SOC_COD=A.SOC_COD AND 
ASI_FECHA BETWEEN '01/07/2022' AND '30/07/2022'
GROUP BY SOC_NOMBRE)

SELECT NOMBRE_SOCIO FROM ASISTENCIA 
WHERE VECES = (SELECT MAX(VECES) FROM ASISTENCIA)

SELECT NOMBRE_SOCIO, MAX(VECES) FROM ASISTENCIA
GROUP BY NOMBRE_SOCIO;
