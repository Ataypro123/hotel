// screens/my_bookings_screen.dart
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import '../models/booking.dart';
import 'dart:convert';
import 'dart:html' as html;

class MyBookingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Мои бронирования'),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Booking>('bookings').listenable(),
        builder: (context, Box<Booking> box, _) {
          if (box.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.hotel_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'У вас пока нет бронирований',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/booking');
                    },
                    child: Text('Создать бронирование'),
                  ),
                ],
              ),
            );
          }
          
          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: box.length,
            itemBuilder: (context, index) {
              final booking = box.getAt(box.length - 1 - index);
              
              if (booking == null) return SizedBox();
              
              return BookingCard(
                booking: booking,
                index: box.length - 1 - index,
              );
            },
          );
        },
      ),
    );
  }
}

class BookingCard extends StatelessWidget {
  final Booking booking;
  final int index;
  
  BookingCard({required this.booking, required this.index});
  
  @override
  Widget build(BuildContext context) {
    // Retrieve the image from localStorage
    String? base64Image;
    try {
      base64Image = html.window.localStorage['image_${booking.passportImagePath}'];
    } catch (e) {
      print('Error retrieving image: $e');
    }
    
    return Card(
      elevation: 4,
      margin: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: Colors.blue,
            padding: EdgeInsets.all(12),
            child: Text(
              'Бронирование #${index + 1}',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.hotel, color: Colors.blue),
                    SizedBox(width: 8),
                    Text(
                      'Тип номера: ${booking.roomType}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.calendar_today, color: Colors.blue),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Даты: ${DateFormat('dd.MM.yyyy').format(booking.checkInDate)} - ${DateFormat('dd.MM.yyyy').format(booking.checkOutDate)}',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.access_time, color: Colors.blue),
                    SizedBox(width: 8),
                    Text(
                      'Количество ночей: ${booking.checkOutDate.difference(booking.checkInDate).inDays}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.date_range, color: Colors.blue),
                    SizedBox(width: 8),
                    Text(
                      'Создано: ${DateFormat('dd.MM.yyyy HH:mm').format(booking.bookingDate)}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  'Фото паспорта:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: base64Image != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.memory(
                            base64Decode(base64Image),
                            fit: BoxFit.cover,
                          ),
                        )
                      : Center(child: Text('Изображение недоступно')),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      icon: Icon(Icons.delete, color: Colors.red),
                      label: Text(
                        'Отменить бронирование',
                        style: TextStyle(color: Colors.red),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Подтверждение'),
                            content: Text('Вы действительно хотите отменить бронирование?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('Нет'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  // Delete the image from localStorage
                                  try {
                                    html.window.localStorage.remove('image_${booking.passportImagePath}');
                                  } catch (e) {
                                    print('Error removing image: $e');
                                  }
                                  
                                  // Delete the booking
                                  final bookingsBox = Hive.box<Booking>('bookings');
                                  bookingsBox.deleteAt(index);
                                  
                                  Navigator.pop(context);
                                  
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Бронирование отменено'))
                                  );
                                },
                                child: Text('Да'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}