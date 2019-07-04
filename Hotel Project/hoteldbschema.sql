create table hotels
(hotel_id number, hotel_name  varchar(45), hotel_street varchar(25), hotel_city varchar(25),
hotel_state varchar(2), hotel_zip number, hotel_phone number,
constraint hotel_pk primary key (hotel_id));

create table event_rooms
(room_id number, hotel_id number, room_type varchar(25), room_capacity number, room_price_per_day number,  event_type varchar(40),
constraint room_pk primary key (room_id),
constraint foreign_room foreign key (hotel_id) references hotels(hotel_id));
create table reservations
(res_id number, customer_name varchar(50), room_id number, res_start_date date, res_end_date date, res_total number, num_attendees number, discount number, cancelled varchar(1),
constraint res_pk primary key (res_id),
constraint foreign_res foreign key (room_id) references event_rooms(room_id));
create table res_services
(service_id number, res_id number, service_date date, res_service_total number, service_completed varchar(1),
constraint res_service_pk primary key (service_id));