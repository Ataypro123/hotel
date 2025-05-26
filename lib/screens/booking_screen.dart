// screens/booking_screen.dart
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:intl/intl.dart';
import 'dart:typed_data';
import '../models/booking.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';
import 'dart:html' as html;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BookingScreen extends StatefulWidget {
  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final roomTypes = ['Стандарт', 'Комфорт', 'Люкс', 'Премиум'];
  String selectedRoomType = 'Стандарт';
  DateTime checkInDate = DateTime.now();
  DateTime checkOutDate = DateTime.now().add(Duration(days: 1));
  String? passportImagePath;
  Uint8List? _passportImageBytes;
  final _formKey = GlobalKey<FormState>();
  bool isProcessing = false;
  
  // New form controllers
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();
  
  // Email configuration - замените на ваши данные
  static const String ADMIN_EMAIL = 'jumabaevalihan55@gmail.com'; // Замените на вашу почту
  static const String EMAIL_SERVICE_API = 'https://api.emailjs.com/api/v1.0/email/send'; // EmailJS или другой сервис
  static const String SERVICE_ID = 'service_fbuoscc'; // ID сервиса EmailJS
  static const String TEMPLATE_ID = 'template_ivbjn5m'; // ID шаблона EmailJS
  static const String USER_ID = 'se5O3Sx2oOBHjgch4'; // User ID EmailJS
  
  // Room details mapping
  final Map<String, Map<String, dynamic>> roomDetails = {
    'Стандарт': {
      'price': '5000₽',
      'size': '25 м²',
      'bed': 'Двуспальная кровать',
      'capacity': '2 гостя',
      'amenities': ['Кондиционер', 'Бесплатный Wi-Fi', 'Телевизор', 'Мини-бар', 'Ванная комната']
    },
    'Комфорт': {
      'price': '7500₽',
      'size': '35 м²',
      'bed': 'Двуспальная кровать King-size',
      'capacity': '2 гостя',
      'amenities': ['Кондиционер', 'Бесплатный Wi-Fi', 'Телевизор', 'Мини-бар', 'Ванная комната', 'Рабочая зона', 'Сейф']
    },
    'Люкс': {
      'price': '12000₽',
      'size': '50 м²',
      'bed': 'Двуспальная кровать King-size',
      'capacity': '2-3 гостя',
      'amenities': ['Кондиционер', 'Бесплатный Wi-Fi', 'Телевизор', 'Мини-бар', 'Ванная комната с джакузи', 'Гостиная', 'Сейф', 'Кофемашина']
    },
    'Премиум': {
      'price': '20000₽',
      'size': '80 м²',
      'bed': 'Двуспальная кровать King-size',
      'capacity': '2-4 гостя',
      'amenities': ['Кондиционер', 'Бесплатный Wi-Fi', 'Телевизор', 'Мини-бар', 'Ванная комната с джакузи', 'Гостиная', 'Сейф', 'Кофемашина', 'Терраса', 'Персональный консьерж']
    },
  };

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _selectCheckInDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: checkInDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.indigo,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != checkInDate) {
      setState(() {
        checkInDate = picked;
        if (checkOutDate.isBefore(checkInDate)) {
          checkOutDate = checkInDate.add(Duration(days: 1));
        }
      });
    }
  }

  Future<void> _selectCheckOutDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: checkOutDate.isAfter(checkInDate) ? checkOutDate : checkInDate.add(Duration(days: 1)),
      firstDate: checkInDate.add(Duration(days: 1)),
      lastDate: DateTime.now().add(Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.indigo,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != checkOutDate) {
      setState(() {
        checkOutDate = picked;
      });
    }
  }

  Future<void> _pickPassportImage() async {
    final image = await ImagePickerWeb.getImageAsBytes();
    if (image != null) {
      final uuid = Uuid();
      final fileName = 'passport_${uuid.v4()}.png';
      
      setState(() {
        _passportImageBytes = image;
        passportImagePath = fileName;
      });
    }
  }

  // Функция отправки email уведомления с улучшенной обработкой ошибок
Future<bool> _sendEmailNotification() async {
  try {
    final details = roomDetails[selectedRoomType]!;
    final nights = checkOutDate.difference(checkInDate).inDays;
    final totalPrice = int.parse(details['price'].replaceAll('₽', '')) * nights;
    
    // Формируем данные для отправки
    final emailData = {
      'service_id': SERVICE_ID,
      'template_id': TEMPLATE_ID,
      'user_id': USER_ID,
      'template_params': {
        'to_email': ADMIN_EMAIL,
        'guest_name': _nameController.text,
        'guest_email': _emailController.text,
        'guest_phone': _phoneController.text,
        'room_type': selectedRoomType,
        'check_in_date': DateFormat('dd.MM.yyyy').format(checkInDate),
        'check_out_date': DateFormat('dd.MM.yyyy').format(checkOutDate),
        'nights_count': nights.toString(),
        'total_price': '$totalPrice₽',
        'booking_date': DateFormat('dd.MM.yyyy HH:mm').format(DateTime.now()),
      }
    };

    print('Отправка email данных: ${json.encode(emailData)}'); // Для отладки

    final response = await http.post(
      Uri.parse(EMAIL_SERVICE_API),
      headers: {
        'Content-Type': 'application/json',
        'Origin': html.window.location.origin, // Добавляем Origin header
      },
      body: json.encode(emailData),
    );

    print('Статус ответа: ${response.statusCode}'); // Для отладки
    print('Тело ответа: ${response.body}'); // Для отладки

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Ошибка EmailJS: ${response.statusCode} - ${response.body}');
      return false;
    }
  } catch (e) {
    print('Ошибка отправки email: $e');
    return false;
  }
}

// Альтернативная функция с использованием EmailJS SDK через JavaScript
Future<bool> _sendEmailNotificationJS() async {
  try {
    final details = roomDetails[selectedRoomType]!;
    final nights = checkOutDate.difference(checkInDate).inDays;
    final totalPrice = int.parse(details['price'].replaceAll('₽', '')) * nights;
    
    // Создаем JavaScript код для отправки через EmailJS SDK
    final jsCode = '''
      emailjs.init('$USER_ID');
      
      emailjs.send('$SERVICE_ID', '$TEMPLATE_ID', {
        to_email: '$ADMIN_EMAIL',
        guest_name: '${_nameController.text}',
        guest_email: '${_emailController.text}',
        guest_phone: '${_phoneController.text}',
        room_type: '$selectedRoomType',
        check_in_date: '${DateFormat('dd.MM.yyyy').format(checkInDate)}',
        check_out_date: '${DateFormat('dd.MM.yyyy').format(checkOutDate)}',
        nights_count: '$nights',
        total_price: '$totalPrice₽',
        booking_date: '${DateFormat('dd.MM.yyyy HH:mm').format(DateTime.now())}'
      }).then(function(response) {
        console.log('SUCCESS!', response.status, response.text);
        window.emailResult = 'success';
      }, function(error) {
        console.log('FAILED...', error);
        window.emailResult = 'error';
      });
    ''';

    // Создаем скрипт элемент и выполняем JavaScript
    final script = html.ScriptElement();
    script.innerHTML = jsCode;
    html.document.head!.append(script);
    
    // Ждем результат (примитивный способ)
    await Future.delayed(Duration(seconds: 3));
    
    // Проверяем результат
    final result = html.window.localStorage['emailResult'] ?? 'error';
    html.window.localStorage.remove('emailResult');
    
    return result == 'success';
  } catch (e) {
    print('Ошибка отправки email через JS: $e');
    return false;
  }
}

// Функция для отправки через альтернативный сервис (например, Formspree)
Future<bool> _sendEmailViaFormspree() async {
  try {
    const String FORMSPREE_URL = 'https://formspree.io/f/YOUR_FORM_ID'; // Замените на ваш ID
    
    final details = roomDetails[selectedRoomType]!;
    final nights = checkOutDate.difference(checkInDate).inDays;
    final totalPrice = int.parse(details['price'].replaceAll('₽', '')) * nights;
    
    final formData = {
      'email': _emailController.text,
      'subject': 'Новое бронирование - $selectedRoomType',
      'message': '''
Новое бронирование номера!

Информация о госте:
- Имя: ${_nameController.text}
- Email: ${_emailController.text}
- Телефон: ${_phoneController.text}

Детали бронирования:
- Тип номера: $selectedRoomType
- Дата заезда: ${DateFormat('dd.MM.yyyy').format(checkInDate)}
- Дата выезда: ${DateFormat('dd.MM.yyyy').format(checkOutDate)}
- Количество ночей: $nights
- Общая стоимость: $totalPrice₽
- Дата бронирования: ${DateFormat('dd.MM.yyyy HH:mm').format(DateTime.now())}
      ''',
    };

    final response = await http.post(
      Uri.parse(FORMSPREE_URL),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode(formData),
    );

    return response.statusCode == 200;
  } catch (e) {
    print('Ошибка отправки через Formspree: $e');
    return false;
  }
}

  // Альтернативная функция для простой отправки (если EmailJS недоступен)
  Future<bool> _sendSimpleEmailNotification() async {
    try {
      // Здесь можно использовать другие сервисы отправки email
      // Например, через Firebase Functions, собственный backend и т.д.
      
      final details = roomDetails[selectedRoomType]!;
      final nights = checkOutDate.difference(checkInDate).inDays;
      final totalPrice = int.parse(details['price'].replaceAll('₽', '')) * nights;
      
      // Пример с использованием mailto (откроет почтовый клиент)
      final emailSubject = 'Новое бронирование - ${selectedRoomType}';
      final emailBody = '''
Новое бронирование номера!

Информация о госте:
- Имя: ${_nameController.text}
- Email: ${_emailController.text}
- Телефон: ${_phoneController.text}

Детали бронирования:
- Тип номера: $selectedRoomType
- Дата заезда: ${DateFormat('dd.MM.yyyy').format(checkInDate)}
- Дата выезда: ${DateFormat('dd.MM.yyyy').format(checkOutDate)}
- Количество ночей: $nights
- Общая стоимость: $totalPrice₽
- Дата бронирования: ${DateFormat('dd.MM.yyyy HH:mm').format(DateTime.now())}

С уважением,
Система бронирования отеля
      ''';
      
      final mailtoUrl = 'mailto:$ADMIN_EMAIL?subject=${Uri.encodeComponent(emailSubject)}&body=${Uri.encodeComponent(emailBody)}';
      html.window.open(mailtoUrl, '_blank');
      
      return true;
    } catch (e) {
      print('Ошибка отправки уведомления: $e');
      return false;
    }
  }

  // Обновленная функция _saveBooking с несколькими попытками отправки
void _saveBooking() async {
  if (_formKey.currentState!.validate()) {
    if (passportImagePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Пожалуйста, добавьте изображение паспорта'),
          backgroundColor: Colors.red[700],
        )
      );
      return;
    }

    setState(() {
      isProcessing = true;
    });

    try {
      bool emailSent = false;
      String emailMethod = '';
      
      // Пробуем разные методы отправки
      // 1. Сначала пробуем основной метод EmailJS
      try {
        emailSent = await _sendEmailNotification();
        emailMethod = 'EmailJS API';
      } catch (e) {
        print('Основной метод EmailJS не сработал: $e');
      }
      
      // 2. Если не получилось, пробуем через JavaScript SDK
      if (!emailSent) {
        try {
          emailSent = await _sendEmailNotificationJS();
          emailMethod = 'EmailJS SDK';
        } catch (e) {
          print('JavaScript метод не сработал: $e');
        }
      }
      
      // 3. Если и это не сработало, используем Formspree
      if (!emailSent) {
        try {
          emailSent = await _sendEmailViaFormspree();
          emailMethod = 'Formspree';
        } catch (e) {
          print('Formspree метод не сработал: $e');
        }
      }
      
      // 4. В крайнем случае используем mailto
      if (!emailSent) {
        emailSent = await _sendSimpleEmailNotification();
        emailMethod = 'Mailto';
      }
      
      // Сохраняем бронирование в Hive
      final bookingsBox = Hive.box<Booking>('bookings');
      
      final booking = Booking(
        roomType: selectedRoomType,
        checkInDate: checkInDate,
        checkOutDate: checkOutDate,
        passportImagePath: passportImagePath!,
        bookingDate: DateTime.now(),
      );
      
      // Сохраняем изображение
      final localStorageKey = 'image_${passportImagePath!}';
      if (_passportImageBytes != null) {
        final base64Image = html.window.btoa(String.fromCharCodes(_passportImageBytes!));
        html.window.localStorage[localStorageKey] = base64Image;
      }
      
      await bookingsBox.add(booking);
      
      setState(() {
        isProcessing = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(emailSent 
            ? 'Бронирование сохранено! Уведомление отправлено через $emailMethod.' 
            : 'Бронирование сохранено! (Уведомление не отправлено)'),
          backgroundColor: emailSent ? Colors.green[700] : Colors.orange[700],
        )
      );
      
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        isProcessing = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка при сохранении: $e'),
          backgroundColor: Colors.red[700],
        )
      );
    }
  }
}

  @override
  Widget build(BuildContext context) {
    final details = roomDetails[selectedRoomType]!;
    final nights = checkOutDate.difference(checkInDate).inDays;
    final totalPrice = int.parse(details['price'].replaceAll('₽', '')) * nights;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Бронирование номера'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.indigo, Colors.indigo.shade50],
            stops: [0.0, 0.1],
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header section
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Создание бронирования',
                        style: TextStyle(
                          fontFamily: 'Playfair Display',
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo[900],
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Заполните информацию для бронирования номера',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: 24),
                
                // Guest information section
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.person, color: Colors.indigo),
                            SizedBox(width: 10),
                            Text(
                              'Контактная информация',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo[900],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: 'Полное имя',
                            hintText: 'Введите ваше полное имя',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                            prefixIcon: Icon(Icons.person, color: Colors.indigo),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Пожалуйста, введите ваше имя';
                            }
                            if (value.trim().length < 2) {
                              return 'Имя должно содержать минимум 2 символа';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Email адрес',
                            hintText: 'example@email.com',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                            prefixIcon: Icon(Icons.email, color: Colors.indigo),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Пожалуйста, введите email адрес';
                            }
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                              return 'Введите корректный email адрес';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: 'Номер телефона',
                            hintText: '+7 (xxx) xxx-xx-xx',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                            prefixIcon: Icon(Icons.phone, color: Colors.indigo),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Пожалуйста, введите номер телефона';
                            }
                            if (value.trim().length < 10) {
                              return 'Введите корректный номер телефона';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                
                SizedBox(height: 24),
                
                // Room selection section
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.hotel, color: Colors.indigo),
                            SizedBox(width: 10),
                            Text(
                              'Выберите тип номера',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo[900],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: selectedRoomType,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          ),
                          items: roomTypes.map((String type) {
                            return DropdownMenuItem<String>(
                              value: type,
                              child: Text(type),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                selectedRoomType = newValue;
                              });
                            }
                          },
                        ),
                        
                        SizedBox(height: 20),
                        
                        // Room details
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    selectedRoomType,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.indigo[900],
                                    ),
                                  ),
                                  Text(
                                    details['price'],
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.amber[800],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 4),
                              Text(
                                'за ночь',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Divider(height: 24),
                              _buildRoomDetailItem(FontAwesomeIcons.rulerCombined, 'Размер номера', details['size']),
                              SizedBox(height: 8),
                              _buildRoomDetailItem(FontAwesomeIcons.bed, 'Кровать', details['bed']),
                              SizedBox(height: 8),
                              _buildRoomDetailItem(FontAwesomeIcons.userGroup, 'Вместимость', details['capacity']),
                              SizedBox(height: 16),
                              Text(
                                'Удобства:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[700],
                                ),
                              ),
                              SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: (details['amenities'] as List).map((amenity) {
                                  return Chip(
                                    label: Text(
                                      amenity,
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    backgroundColor: Colors.grey.shade100,
                                    padding: EdgeInsets.zero,
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                SizedBox(height: 24),
                
                // Date selection section
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.calendar_today, color: Colors.indigo),
                            SizedBox(width: 10),
                            Text(
                              'Выберите даты проживания',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo[900],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                readOnly: true,
                                controller: TextEditingController(
                                  text: DateFormat('dd.MM.yyyy').format(checkInDate),
                                ),
                                decoration: InputDecoration(
                                  labelText: 'Дата заезда',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey.shade50,
                                  suffixIcon: Icon(Icons.calendar_today, color: Colors.indigo),
                                ),
                                onTap: () => _selectCheckInDate(context),
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: TextFormField(
                                readOnly: true,
                                controller: TextEditingController(
                                  text: DateFormat('dd.MM.yyyy').format(checkOutDate),
                                ),
                                decoration: InputDecoration(
                                  labelText: 'Дата выезда',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey.shade50,
                                  suffixIcon: Icon(Icons.calendar_today, color: Colors.indigo),
                                ),
                                onTap: () => _selectCheckOutDate(context),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.indigo.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Количество ночей:',
                                    style: TextStyle(
                                      color: Colors.indigo[900],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    '$nights',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.indigo[900],
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'Итоговая стоимость:',
                                    style: TextStyle(
                                      color: Colors.indigo[900],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    '$totalPrice₽',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.amber[800],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                SizedBox(height: 24),
                
                // Passport photo section
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.document_scanner, color: Colors.indigo),
                            SizedBox(width: 10),
                            Text(
                              'Фото паспорта',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo[900],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Загрузите фотографию паспорта для подтверждения личности',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 20),
                        Center(
                          child: _passportImageBytes != null
                              ? Container(
                                  width: 300,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 10,
                                        offset: Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.memory(
                                      _passportImageBytes!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                              : Container(
                                  width: 300,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey.shade300, width: 2, style: BorderStyle.solid),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.add_photo_alternate,
                                        size: 60,
                                        color: Colors.grey.shade400,
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        'Нет изображения',
                                        style: TextStyle(
                                          color: Colors.grey.shade500,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                        SizedBox(height: 20),
                        Center(
                          child: ElevatedButton.icon(
                            onPressed: _pickPassportImage,
                            icon: Icon(Icons.camera_alt),
                            label: Text('Загрузить фото паспорта'),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                SizedBox(height: 32),
                
                // Submit button
                ElevatedButton(
                  onPressed: isProcessing ? null : _saveBooking,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16), backgroundColor: Colors.amber[800],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isProcessing
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                          'ЗАБРОНИРОВАТЬ',
                          style: TextStyle(fontSize: 18, letterSpacing: 1),
                        ),
                ),
                
                SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  // Room detail item
  Widget _buildRoomDetailItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: Colors.grey[600],
        ),
        SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            color: Colors.grey[700],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey[900],
          ),
        ),
      ],
    );
  }

// import 'package:flutter/material.dart';
// import 'package:hotel_alihan_pwa/models/mailer.dart';
// import 'package:intl/intl.dart';
// import '../services/email_service.dart';

// class BookingScreen extends StatefulWidget {
//   final UserModel user; // Информация о пользователе после регистрации/входа

//   const BookingScreen({Key? key, required this.user}) : super(key: key);

//   @override
//   _BookingScreenState createState() => _BookingScreenState();
// }

// class _BookingScreenState extends State<BookingScreen> {
//   final _formKey = GlobalKey<FormState>();
  
//   DateTime? _checkInDate;
//   DateTime? _checkOutDate;
//   String _roomType = '';
//   int _guestCount = 1;
//   String _specialRequests = '';
  
//   bool _isLoading = false;
//   String _errorMessage = '';
//   String _successMessage = '';

//   // Список доступных типов номеров
//   final List<Map<String, dynamic>> _roomTypes = [
//     {'value': 'Стандартный', 'price': 5000},
//     {'value': 'Улучшенный', 'price': 7500},
//     {'value': 'Люкс', 'price': 12000},
//     {'value': 'Семейный', 'price': 15000},
//   ];

//   // Метод для выбора даты
//   Future<void> _selectDate(BuildContext context, bool isCheckIn) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: isCheckIn ? (DateTime.now()) : (_checkInDate?.add(Duration(days: 1)) ?? DateTime.now().add(Duration(days: 1))),
//       firstDate: isCheckIn ? DateTime.now() : (_checkInDate ?? DateTime.now()),
//       lastDate: DateTime.now().add(Duration(days: 365)),
//       locale: const Locale('ru', 'RU'),
//     );
    
//     if (picked != null) {
//       setState(() {
//         if (isCheckIn) {
//           _checkInDate = picked;
//           // Если дата выезда раньше новой даты заезда, сбрасываем дату выезда
//           if (_checkOutDate != null && _checkOutDate!.isBefore(_checkInDate!.add(Duration(days: 1)))) {
//             _checkOutDate = null;
//           }
//         } else {
//           _checkOutDate = picked;
//         }
//       });
//     }
//   }

//   // Метод для отправки бронирования
//   Future<void> _submitBooking() async {
//     if (_formKey.currentState!.validate()) {
//       if (_checkInDate == null || _checkOutDate == null) {
//         setState(() {
//           _errorMessage = 'Пожалуйста, выберите даты заезда и выезда';
//         });
//         return;
//       }
      
//       if (_roomType.isEmpty) {
//         setState(() {
//           _errorMessage = 'Пожалуйста, выберите тип номера';
//         });
//         return;
//       }
      
//       setState(() {
//         _isLoading = true;
//         _errorMessage = '';
//         _successMessage = '';
//       });

//       try {
//         // Форматирование дат для отображения
//         final dateFormat = DateFormat('dd.MM.yyyy');
//         final checkInFormatted = dateFormat.format(_checkInDate!);
//         final checkOutFormatted = dateFormat.format(_checkOutDate!);
        
//         // Генерация уникального ID бронирования (в реальном приложении можно получать от сервера)
//         final bookingId = 'BK-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
        
//         // Отправка уведомления администратору отеля
//         final notificationSent = await EmailService.sendBookingNotification(
//           userName: widget.user.fullName,
//           userEmail: widget.user.email,
//           userPhone: widget.user.phone,
//           checkInDate: checkInFormatted,
//           checkOutDate: checkOutFormatted,
//           roomType: _roomType,
//           guestCount: _guestCount,
//           specialRequests: _specialRequests,
//         );
        
//         // Отправка подтверждения пользователю
//         final confirmationSent = await EmailService.sendBookingConfirmation(
//           userName: widget.user.fullName,
//           userEmail: widget.user.email,
//           checkInDate: checkInFormatted,
//           checkOutDate: checkOutFormatted,
//           roomType: _roomType,
//           guestCount: _guestCount,
//           specialRequests: _specialRequests,
//           bookingId: bookingId,
//         );
        
//         if (notificationSent && confirmationSent) {
//           setState(() {
//             _successMessage = 'Бронирование успешно отправлено! Проверьте вашу электронную почту для получения подтверждения.';
//           });
          
//           // Здесь можно сохранить бронирование в локальную базу данных или на сервер
          
//           // Сброс формы после успешного бронирования
//           Future.delayed(Duration(seconds: 3), () {
//             if (mounted) {
//               _formKey.currentState?.reset();
//               setState(() {
//                 _checkInDate = null;
//                 _checkOutDate = null;
//                 _roomType = '';
//                 _guestCount = 1;
//                 _specialRequests = '';
//               });
//             }
//           });
//         } else {
//           setState(() {
//             _errorMessage = 'Произошла ошибка при отправке бронирования. Пожалуйста, попробуйте позже.';
//           });
//         }
//       } catch (e) {
//         setState(() {
//           _errorMessage = 'Ошибка: ${e.toString()}';
//         });
//       } finally {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Бронирование номера'),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 // Приветствие пользователя
//                 Text(
//                   'Здравствуйте, ${widget.user.fullName}!',
//                   style: Theme.of(context).textTheme.titleLarge,
//                 ),
//                 SizedBox(height: 5),
//                 Text(
//                   'Заполните форму для бронирования номера:',
//                   style: TextStyle(fontSize: 16),
//                 ),
//                 SizedBox(height: 20),
                
//                 // Выбор даты заезда
//                 InkWell(
//                   onTap: () => _selectDate(context, true),
//                   child: InputDecorator(
//                     decoration: InputDecoration(
//                       labelText: 'Дата заезда',
//                       prefixIcon: Icon(Icons.calendar_today),
//                       border: OutlineInputBorder(),
//                     ),
//                     child: Text(
//                       _checkInDate == null
//                           ? 'Выберите дату заезда'
//                           : DateFormat('dd.MM.yyyy').format(_checkInDate!),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 15),
                
//                 // Выбор даты выезда
//                 InkWell(
//                   onTap: () => _checkInDate == null
//                       ? ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(content: Text('Сначала выберите дату заезда')),
//                         )
//                       : _selectDate(context, false),
//                   child: InputDecorator(
//                     decoration: InputDecoration(
//                       labelText: 'Дата выезда',
//                       prefixIcon: Icon(Icons.calendar_today),
//                       border: OutlineInputBorder(),
//                     ),
//                     child: Text(
//                       _checkOutDate == null
//                           ? 'Выберите дату выезда'
//                           : DateFormat('dd.MM.yyyy').format(_checkOutDate!),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 15),
                
//                 // Выбор типа номера
//                 DropdownButtonFormField<String>(
//                   decoration: InputDecoration(
//                     labelText: 'Тип номера',
//                     prefixIcon: Icon(Icons.hotel),
//                     border: OutlineInputBorder(),
//                   ),
//                   hint: Text('Выберите тип номера'),
//                   value: _roomType.isEmpty ? null : _roomType,
//                   onChanged: (String? newValue) {
//                     setState(() {
//                       _roomType = newValue ?? '';
//                     });
//                   },
//                   items: _roomTypes.map<DropdownMenuItem<String>>((Map<String, dynamic> room) {
//                     return DropdownMenuItem<String>(
//                       value: room['value'],
//                       child: Text('${room['value']} - ${room['price']} ₽/ночь'),
//                     );
//                   }).toList(),
//                 ),
//                 SizedBox(height: 15),
                
//                 // Выбор количества гостей
//                 DropdownButtonFormField<int>(
//                   decoration: InputDecoration(
//                     labelText: 'Количество гостей',
//                     prefixIcon: Icon(Icons.people),
//                     border: OutlineInputBorder(),
//                   ),
//                   value: _guestCount,
//                   onChanged: (int? newValue) {
//                     setState(() {
//                       _guestCount = newValue ?? 1;
//                     });
//                   },
//                   items: [1, 2, 3, 4].map<DropdownMenuItem<int>>((int value) {
//                     return DropdownMenuItem<int>(
//                       value: value,
//                       child: Text('$value ${value == 1 ? 'гость' : (value < 5 ? 'гостя' : 'гостей')}'),
//                     );
//                   }).toList(),
//                 ),
//                 SizedBox(height: 15),
                
//                 // Особые пожелания
//                 TextFormField(
//                   decoration: InputDecoration(
//                     labelText: 'Особые пожелания',
//                     prefixIcon: Icon(Icons.note_alt),
//                     border: OutlineInputBorder(),
//                   ),
//                   maxLines: 3,
//                   onChanged: (value) {
//                     _specialRequests = value;
//                   },
//                 ),
//                 SizedBox(height: 20),
                
//                 // Отображение сообщения об ошибке, если есть
//                 if (_errorMessage.isNotEmpty)
//                   Container(
//                     padding: EdgeInsets.all(10),
//                     color: Colors.red.shade100,
//                     child: Text(
//                       _errorMessage,
//                       style: TextStyle(color: Colors.red),
//                     ),
//                   ),
                
//                 // Отображение сообщения об успехе, если есть
//                 if (_successMessage.isNotEmpty)
//                   Container(
//                     padding: EdgeInsets.all(10),
//                     color: Colors.green.shade100,
//                     child: Text(
//                       _successMessage,
//                       style: TextStyle(color: Colors.green),
//                     ),
//                   ),
                
//                 SizedBox(height: 20),
                
//                 // Кнопка отправки бронирования
//                 _isLoading
//                     ? Center(child: CircularProgressIndicator())
//                     : ElevatedButton(
//                         onPressed: _submitBooking,
//                         child: Text('Забронировать'),
//                       ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
}

extension on html.ScriptElement {
  set innerHTML(String innerHTML) {}
}