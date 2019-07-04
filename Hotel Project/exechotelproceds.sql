exec create_hotel(1,'Sample Hotel 1','4555 Hotel Street', 'Suitland', 'MD', '20746', '8885386281');
exec create_hotel(2,'Sample Hotel 2','5588 Hotel Street', 'Suitland', 'MD', '20748', '8005002545');
exec create_hotel(3,'Sample Hotel 3','5088 Hotel Street', 'Arlington', 'VA', '20948', '9003002885');

select * from hotels;

exec find_hotel('4555 Hotel Street','Suitland', 'MD', '20746');

exec add_eroom(1, 1, 'Large', 500, 500, 'General');
exec add_eroom(1, 2, 'Medium', 250, 500, 'Party');
exec add_eroom(2, 1, 'Small', 100, 150, 'Birthday');
exec add_eroom(2, 2, 'Small', 100, 200, 'Meeting');

select * from event_rooms;

exec hotel_info(2);

exec insert_reservation(1,'Johnny Doe','01-Mar-19','01-May-19',490);
exec insert_reservation(2,'Tommy Lee','03-Apr-19','01-May-19',50);
exec insert_reservation(1,'Jacky Davidson','01-May-19','25-May-19',120);
exec insert_reservation(2,'Jane Doe','05-Jun-19','01-Jul-19',70);

select * from reservations;

find_reservation('Johnny Doe','01-Mar-19', 1);
find_reservation('Jane Doe','05-Jun-19', 2);