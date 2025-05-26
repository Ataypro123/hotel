// models/booking.dart
import 'package:hive/hive.dart';
import 'dart:typed_data';

part 'booking.g.dart';

@HiveType(typeId: 0)
class Booking extends HiveObject {
  @HiveField(0)
  String roomType;
  
  @HiveField(1)
  DateTime checkInDate;
  
  @HiveField(2)
  DateTime checkOutDate;
  
  @HiveField(3)
  String passportImagePath;
  
  @HiveField(4)
  DateTime bookingDate;
  
  Booking({
    required this.roomType,
    required this.checkInDate,
    required this.checkOutDate,
    required this.passportImagePath,
    required this.bookingDate,
  });
}