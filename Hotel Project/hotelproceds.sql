--Creates the hotel entry                                       
CREATE OR REPLACE PROCEDURE create_hotel(h_id IN number, h_name IN varchar, h_street IN varchar, h_city IN varchar, h_state IN varchar, h_zip IN varchar, h_phone IN varchar) AS
CURSOR check_cursor IS SELECT hotel_id FROM hotels;
check_row check_cursor%rowtype;
used_id exception;
check_id number;
BEGIN
SELECT MAX(hotel_id) INTO check_id FROM hotels; -- pulls the highest id from the table
FOR check_row IN check_cursor
LOOP
IF check_row.hotel_id = h_id THEN
RAISE used_id;
END IF;
END LOOP;
INSERT INTO hotels VALUES (h_id, h_name, h_street, h_city, h_state, h_zip, h_phone);
dbms_output.put_line('Hotel Inserted');
COMMIT;
EXCEPTION
WHEN USED_ID THEN -- tells user next available ID
dbms_output.put_line('Use an ID number after: ' ||check_id); 	
ROLLBACK;
WHEN OTHERS THEN
  dbms_output.put_line('Insertion Failed. Unknown Error');
  ROLLBACK;
END;                                       


--Finds hotel based on address
CREATE OR REPLACE PROCEDURE find_hotel (h_street IN varchar, h_city IN varchar, h_state IN varchar, h_zip IN number) AS
h_id number;
BEGIN
SELECT hotel_id into h_id FROM hotels WHERE hotel_street = h_street and hotel_city = h_city and hotel_state = h_state and hotel_zip = h_zip;
dbms_output.put_line('The hotel with that address is hotel: '|| h_id);
EXCEPTION
	WHEN NO_DATA_FOUND THEN
    	dbms_output.put_line('There is no hotel with that address');
    	ROLLBACK;
	WHEN OTHERS THEN
    	ROLLBACK;
END;

--Adds an event room entry to a hotel
CREATE OR REPLACE PROCEDURE add_eroom(r_id IN number, h_id IN number,r_type IN varchar, r_capacity IN number, r_price IN number, e_type IN varchar) AS
CURSOR check_cursor IS SELECT room_id FROM event_rooms;
check_row check_cursor%rowtype;
used_id exception;
check_id number;
check_h_id number;
BEGIN
SELECT MAX(room_id) INTO check_id FROM event_rooms;
SELECT hotel_id INTO check_h_id FROM hotels WHERE hotel_id = h_id;
IF check_h_id IS NOT NULL
FOR check_row IN check_cursor
LOOP
IF check_row.room_id = r_id THEN
	RAISE used_id;
END IF;
END LOOP;
INSERT INTO event_rooms VALUES (r_id, h_id, r_type, r_capacity, r_price, e_type);
dbms_output.put_line('Room Inserted into hotel:' ||h_id);
COMMIT; 
END IF;
EXCEPTION
WHEN USED_ID THEN
dbms_output.put_line('Use ID number after ' ||check_id);
ROLLBACK;
WHEN NO_DATA_FOUND THEN
dbms_output.put_line('Hotel not found');
ROLLBACK;
WHEN OTHERS THEN
dbms_output.put_line('Insertion failed. Unknown error');
ROLLBACK;
END;

--Displays hotel information. Shows the hotel name associated with the ID inserted along with the room ID, size, capacity, and the price of the rooms in the hotel.
CREATE OR REPLACE PROCEDURE hotel_info(h_id IN number) AS
CURSOR hotel_cursor1 IS SELECT * FROM hotels WHERE hotel_id = h_id;
CURSOR hotel_cursor2 IS SELECT * FROM event_rooms WHERE hotel_id = h_id;
hotel_row1 hotel_cursor1%rowtype;
hotwl_row2 hotel_cursor2%rowtype;
check_exist number;
BEGIN
SELECT hotel_id INTO check_exist FROM hotels WHERE hotel_id = h_id; 
FOR hotel_row1 IN hotel_cursor1 --hotel information
LOOP
dbms_output.put_line('Hotel Information');
dbms_output.put_line('Hotel Name: '|| hotel_row1.hotel_name ||' Hotel Address: '|| hotel_row1.hotel_street ||' '|| hotel_row1.hotel_city ||','|| hotel_row1.hotel_state ||' '|| hotel_row1.hotel_zip ||' Hotel Phone: '|| hotel_row1.hotel_phone);
END LOOP;
dbms_output.put_line('Rooms Provided by This Hotel:');
dbms_output.put_line('Room Type   	Room Capacity  	Room Price Per Day');
FOR hotel_row2 in hotel_cursor2 -- room information
LOOP
dbms_output.put_line(hotel_row2.room_id ||'    	'||hotel_row2.room_type  ||'    	'|| hotel_row2.room_capacity ||'               	'|| hotel_row2.room_price_per_day);
END LOOP;
EXCEPTION
WHEN NO_DATA_FOUND THEN
dbms_output.put_line('There is no Hotel with that ID');
ROLLBACK;
WHEN OTHERS THEN
dbms_output.put_line('Information request failed. Unknown failure');
ROLLBACK;
END;


--Create a new reservation entry
create or replace procedure insert_reservation
(hotel_id number,c_name varchar,st_date date,en_date date, num_attend number) as
CURSOR rids_and_prices IS SELECT room_id, room_price_per_day, room_capacity from event_rooms where room_id NOT IN(select room_id from reservations);
g_id number;
g_check number;
customer_id number;
h_id number;
avail_rid number;
res_total number;
BEGIN
  	Select MAX(res_id)into customer_id from reservations;
	customer_id := customer_id + 1;
  	dbms_output.put_line('Reservation ID is now: ' ||customer_id);
--selects available room based on number of attendees and puts the information from the customer into that room
  if num_attend between 1 and 100 then
Select MIN(room_id) into avail_rid from event_rooms where room_id IN rids_and_prices AND rids_and_prices.room_capacity = 100;
Select price_per_day into res_total from event_rooms where room_capacity = 100 LIMIT 1; --assumes that all rooms with 100 as a cap cost the same price
	if st_date != en_date then
	Res_total := res_total * (to_date(en_date) - to_date(st_date));
	dbms_output.put_line('The total would be: '||res_total);
	end if;
insert into reservations values(customer_id, g_name, avail_id, st_date, e_date,res_total,0,'N' );
   else
  if num_attend between 101 and 250 then
  Select MIN(room_id) into avail_rid from event_rooms where room_id IN rids_and_prices AND rids_and_prices.room_capacity = 250;
Select price_per_day into res_total from event_rooms where room_capacity = 250 LIMIT 1; --assumes that all rooms with 250 as a cap cost the same price
	if st_date != en_date then
	Res_total := res_total * (to_date(en_date) - to_date(st_date));
	dbms_output.put_line(‘The total would be: ‘||res_total);
	end if;
insert into reservations values(customer_id, g_name, avail_id, st_date, e_date,res_total,0,'N' );
   else
   if num_attend between 251 and 500 then
   Select MIN(room_id) into avail_rid from event_rooms where room_id IN rids_and_prices AND rids_and_prices.room_capacity = 500;
Select price_per_day into res_total from event_rooms where room_capacity = 500 LIMIT 1; --assumes that all rooms with 500 as a cap cost the same price
if st_date != en_date then
	Res_total := res_total * (to_date(en_date) - to_date(st_date));
	dbms_output.put_line(‘The total would be: ‘||res_total);
	end if;
insert into reservations values(customer_id, g_name, avail_id, st_date, e_date,res_total,0,'N' );
   end if;
	end if;
	end if;
   dbms_output.put_line('The Reservation is set');
	commit;
 exception
when no_data_found then
dbms_output.put_line('Invalid room or hotel.');
when others then
dbms_output.put_line('Unknown Error. Reservation couldn’t be made.');
End;


--Finds reservation based on customer name, reservation date, and hotel ID
CREATE OR REPLACE procedure find_reservation(g_name IN varchar,
res_date IN date, h_id IN number)as
cursor find_res IS
SELECT Res_ID FROM reservations r, event_rooms e
WHERE r.customer_name = g_name AND r.room_id = e.room_id AND r.res_start_date = res_date;
res_out find_res%rowtype;
BEGIN
for res_out in find_res
loop
dbms_output.put_line('Reservation ID: ' ||res_out.res_id);
end loop;
EXCEPTION
WHEN no_data_found
THEN
dbms_output.put_line('There are no reservations with this information');
END;