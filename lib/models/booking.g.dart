// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BookingAdapter extends TypeAdapter<Booking> {
  @override
  final int typeId = 0;

  @override
  Booking read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Booking(
      roomType: fields[0] as String,
      checkInDate: fields[1] as DateTime,
      checkOutDate: fields[2] as DateTime,
      passportImagePath: fields[3] as String,
      bookingDate: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Booking obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.roomType)
      ..writeByte(1)
      ..write(obj.checkInDate)
      ..writeByte(2)
      ..write(obj.checkOutDate)
      ..writeByte(3)
      ..write(obj.passportImagePath)
      ..writeByte(4)
      ..write(obj.bookingDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
