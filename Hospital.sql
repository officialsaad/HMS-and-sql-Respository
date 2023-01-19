drop database Hospital_Management;

create database Hospital_Management

use Hospital_Management;


create table patient(pid int primary key ,
firstname varchar(50) not null,lastname varchar(50) null,phoneno varchar(11),email varchar(320) null ,dateonhospitaal date,
gender varchar(6),patientcinic varchar(17) ,landlineo varchar(45),address varchar(320))


create procedure updatepatients(
@did int, @firstname varchar(50),@lastname varchar(50),@ph varchar(11),@email varchar(320),
@date date, @gender varchar(6),@cnic varchar(17),@lan varchar(45),@ad varchar(320))
as
update patient set firstname=@firstname, lastname=@lastname,phoneno=@ph,email=@email,dateonhospitaal=@date,gender=@gender, patientcinic=@cnic,landlineo=@lan, address = @ad where pid= @did
return


create table doctor(did int primary key,firstname varchar(50) not null,lastname varchar(50) null,phoneno varchar(11),email varchar(320),
dateofjoining date, gender varchar(6),dcinic varchar(17),landlineo varchar(45),qualification varchar(210),speciality varchar(210),
dsalary float)


create procedure updatedocs
@did int, @firstname varchar(50),@lastname varchar(50),@ph varchar(11),@email varchar(320),
@date date, @gender varchar(6),@cnic varchar(17),@lan varchar(45),@qual varchar(210),@spec varchar(210),
@salary float
as
update doctor set firstname=@firstname, lastname=@lastname,phoneno=@ph,email=@email,dateofjoining=@date,gender=@gender,qualification=@qual,dcinic=@cnic,speciality=@spec,dsalary=@salary,landlineo=@lan where did= @did
return

create procedure adddoc
@id int,@fn varchar(50),@ln varchar(50),@ph varchar(11),@email varchar(320),@doj date,@gender varchar(6), @dcnic varchar(17),
@landlineno varchar(45),@q varchar(210),@S varchar(210),@sal float
as 
insert into doctor(did,firstname,lastname,phoneno,email,dateofjoining,gender,dcinic,landlineo,qualification,speciality,dsalary) values(@id,
@fn,@ln,@ph,@email,@doj,@gender,@dcnic,@landlineno,@q,@S,@sal)
return


create table Appoitment(aid int primary key identity(1,1),  appointmentreason varchar(100),appointmentcharges float,
did int foreign key references doctor(did),pid int foreign key references patient(pid),dateofappointment datetime,)
--EXEC sp_rename 'wards.wame','wname','COLUMN';

create procedure viewappoint

as
select patient.firstname,patient.lastname,patient.gender,doctor.firstname,doctor.lastname,doctor.speciality
from doctor join Appoitment on Appoitment.did=doctor.did join  patient on Appoitment.pid=patient.pid
return
EXEC viewappoint

create procedure viewapoints

as
select patient.firstname,patient.lastname,patient.gender,doctor.firstname,doctor.lastname,doctor.speciality,
Appoitment.dateofappointment
from doctor join Appoitment on Appoitment.did=doctor.did join  patient on Appoitment.pid=patient.pid
return
EXEC viewapoints

EXEC viewappoint

create procedure viewapointments
@aid int
as
select patient.firstname,patient.lastname,patient.gender,doctor.firstname,doctor.lastname,doctor.speciality,
Appoitment.dateofappointment
from doctor join Appoitment on Appoitment.did=doctor.did join  patient on Appoitment.pid=patient.pid
where Appoitment.aid=@aid
return

create procedure updateAppoitments
@aid int, @time datetime, @pid int,@did int,@charges float,@des varchar(100)
as
update Appoitment set appointmentreason=@des, appointmentcharges=@charges,did=@did,pid=@pid where aid =@aid
return


drop table Appoitment

create table Bill(bid int identity(1,1),roomcharges float,doctorcharges float,wardcharges float,servicecharges float,appoitmentcharges float,
insureance varchar(45),totalcharges float,dateofbilling datetime,description varchar(100),pid int foreign key references patient(pid),
)
create table wards(wid int primary key identity(1,1),wname varchar(45),floorno varchar(3),wtype varchar(45))


create procedure updatewards 
@wid int,@name varchar(45),@type varchar(45), @floor varchar(3)
as 
update wards set wname = @name, wtype = @type,floorno = @floor where wid =@wid
return

Drop table employees
create table employees(eid int primary key identity(1,1),firstname varchar(50) not null,lastname varchar(50) null,phoneno varchar(11),email varchar(320),
--password varchar(320),
ecinic varchar(17),landlineo varchar(45),qualification varchar(100),address varchar(100),
salary float,dateofjoining date, gender varchar(6),type varchar(100)) --,wid int foreign key references wards(wid))


create procedure updateemployees
@firstname varchar(50),@lastname varchar(50),@ph varchar(11),@email varchar(320),
@date date, @gender varchar(6),@cnic varchar(17),@lan varchar(45),@qual varchar(210),@type varchar(100),
@salary float,@address varchar(100),@did int
as
update employees set firstname=@firstname, lastname=@lastname,phoneno=@ph,
email=@email,dateofjoining=@date,gender=@gender,qualification=@qual,type=@type,
ecinic=@cnic,salary=@salary,landlineo=@lan where eid = @did
return





create table wardshaspatient(wid int primary key identity(1,1),admitingdate datetime,wardchargesperday float,
waid int foreign key references wards(wid),paid int foreign key references patient(pid))

create procedure addpatientwithward
@charges float, @date date, @waid int,@pid int
as
insert into wardshaspatient(admitingdate,wardchargesperday,waid,paid)
values(@date,@charges,@waid,@pid)
return

create procedure updatepatientwithward
@wid int,
@charges float, @date date, @waid int,@pid int
as
update wardshaspatient set admitingdate = @date,waid= @waid,paid= @pid
,wardchargesperday=@charges where wardshaspatient.waid=@wid
return

create procedure readepatientwithward 
as
select wardshaspatient.wid, wardshaspatient.wardchargesperday,wards.wname as wardname,
patient.firstname,patient.lastname,patient.gender from wardshaspatient join wards on 
wardshaspatient.waid=wards.wid join patient on wardshaspatient.paid=patient.pid
return

EXEC readepatientwithward 

create procedure deletepatientwithward 
@wid int
as
delete from wardshaspatient where wardshaspatient.wid = @wid
return

create table rooms(rid int primary key identity(1,1),rname varchar(45),floorno varchar(3),rtype varchar(45))
--empid int foreign key references employees(eid))

create procedure updaterooms 
@rid int,@rname varchar(45),@rtype varchar(45), @rfloor varchar(3)
as 
update rooms set rname = @rname, rtype = @rtype,floorno = @rfloor where rid =@rid
return

create table patienthasroom(rid int primary key identity(1,1),rname varchar(50),admitingdate datetime,roomchargesperday float,
raid int foreign key references rooms(rid),paid int foreign key references patient(pid))


create procedure addpatientwithroom
@charges float, @date date, @raid int,@paid int
as
insert into dbo.patienthasroom(admitingdate,roomchargesperday,raid,paid)
values(@date,@charges,@raid,@paid)
return

create procedure updatepatientwithroom
@rid int,
@charges float, @date date, @raid int,@paid int
as
update dbo.patienthasroom set admitingdate= @date , roomchargesperday= @charges,raid =@raid,paid=@paid
where rid = @rid
return

create procedure readpatientwithroom 
as
select patienthasroom.rid,patienthasroom.roomchargesperday,rooms.rname as roomname,
patient.firstname,patient.lastname,patient.gender from patienthasroom join rooms on 
patienthasroom.raid= rooms.rid join patient on patient.pid=patienthasroom.paid;
return

EXEC readpatientwithroom


create procedure deletepatientwithroom
@rid int
as
delete from patienthasroom where patienthasroom.rid=@rid
return


create table Regis(Email varchar(320) primary Key, Password varchar(320) not null,Type varchar(6) not null);

create table Admin(Email varchar(320) primary Key, Password varchar(320) not null);

create procedure logindatabase
@Email varchar(320),@Pass varchar(320),@Type varchar(320)
as
if(@Type = 'Admin')
select* from Admin where Email=@Email and Password=@Pass
else if (@Type ='Doctor')
select* from doctor where Email=@Email and Password=@Pass
else if (@Type ='Receptionist')
select* from employees where Email=@Email
return

create procedure signupdatabase
@Email varchar(320),@Pass varchar(320),@Type varchar(320)
as
if(@Type = 'Admin')
insert into Admin(Email,Password)values(@Email,@Pass)
else if (@Type ='Doctor')
update doctor set password=@Pass where email=@Email
--insert into doctor(email,password) where Email=@Email and Password=@Pass
else if (@Type ='Receptionist')
update employees set password=@pass where Email=@Email
return


select *from patient;

delete from patient;

INSERT INTO patient( pid,firstname,lastname,phoneno,email,dateonhospitaal,gender,address,patientcinic) VALUES(1,'Awais','Ali','03338406301','awaisali92@gmail.com'
,'2022-03-23','Male','street 11,home 9, Gujtat Punjab Pakistan','342178985567')


INSERT INTO patient( pid,firstname,lastname,phoneno,email,dateonhospitaal,gender,address,patientcinic) VALUES(2,'Awais','Ahmad','03248404301','awaisahmad92@gmail.com'
,'2022-03-23','Male','street 11,home 9, Gujtat Punjab Pakistan','342178084567')



INSERT INTO patient( pid,firstname,lastname,phoneno,email,dateonhospitaal,gender,address,patientcinic) VALUES(3,'Waqar','Hassan','03447832125','official.waqarhassan@gmail.com'
,'2021-08-28','Male','street 1,home 19, kunjah Gujtat Punjab Pakistan','3421455887419')



select *from doctor;

delete from doctor;



INSERT INTO doctor( did,firstname,lastname,phoneno,email,dateofjoining,gender,qualification,dcinic,speciality,dsalary) VALUES(1,'Ikramr','Hassan','03447123425','official.ikramhassan@gmail.com'
,'2021-08-28','Male',' MBBS GOLD MEDALIST','3478945887419','Eye Specialist',9000.0)


INSERT INTO doctor( did,firstname,lastname,phoneno,email,dateofjoining,gender,qualification,dcinic,speciality,dsalary) VALUES(2,'Ikram','Sabir','03117923405','official.ikramsabir@gmail.com'
,'2021-08-28','Male',' MBBS MS GOLD MEDALIST','3478945845619','Eye Specialist',120000.0),(3,'Hassan','Sabir','03231523400','official.hassansabir@gmail.com'
,'2021-08-28','Male',' MBBS MS GOLD MEDALIST','3213654845619','Ear Specialist',120000.0)


select * from Admin




select *from Appoitment;

delete from Appoitment;


DROP TABLE patient
DROP TABLE Appoitment


INSERT INTO Appoitment( aid,dateofappointment,appointmentreason,appointmentcharges,did,pid) VALUES(5,'2022-03-24 10:03:59 AM',
'Eye problem',1500.0,1,1)

INSERT INTO Appoitment( aid,dateofappointment,appointmentreason,appointmentcharges,did,pid) VALUES(7,'2022-03-24 10:03:59 AM',
'Eye problem',1500.0,2,3)
INSERT INTO Appoitment( aid,dateofappointment,appointmentreason,appointmentcharges,did,pid) VALUES(6,'2022-03-24 10:03:59 AM',
'Eye problem',1500.0,1,3)
insert into Appoitment(aid,dateofappointment) values (3,'2022-03-24 08:45:59 PM')
insert into Appoitment(aid,dateofappointment) values (4,'2022-03-24 08:45:59 AM')
insert into Appoitment(aid,dateofappointment) values (2,'2022-03-24 08:45:00')

CREATE TABLE G(PID INT PRIMARY KEY IDENTITY(1,1), NAME VARCHAR(320) NOT nULL UNIQUE)
INSERT INTO G(NAME) VALUES('NULL')

