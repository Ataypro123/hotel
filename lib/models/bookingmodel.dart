// Модель данных для бронирования
class BookingModel {
  final String id;
  final String roomNumber;
  final String roomType;
  final String guestName;
  final DateTime checkIn;
  final DateTime checkOut;
  final int guests;
  final double totalPrice;
  final BookingStatus status;
  final DateTime createdAt;
  final String phoneNumber;
  final String? notes;

  BookingModel({
    required this.id,
    required this.roomNumber,
    required this.roomType,
    required this.guestName,
    required this.checkIn,
    required this.checkOut,
    required this.guests,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
    required this.phoneNumber,
    this.notes,
  });
}

enum BookingStatus {
  active,
  upcoming,
  completed,
  cancelled,
}