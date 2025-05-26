import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class EmailService {
  // Настройки SMTP-сервера
  static final String _username = 'your_email@gmail.com'; // Ваш email для отправки
  static final String _password = 'your_app_password'; // Пароль или App Password
  static final String _hostUrl = 'smtp.gmail.com'; // SMTP-сервер (зависит от провайдера почты)
  static final int _smtpPort = 587; // Порт SMTP (обычно 587 для TLS)
  
  // Email администратора отеля (получатель бронирований)
  static final String _adminEmail = 'dzheenbekovatay@gmail.com'; // Ваш email для получения уведомлений

  // Отправка уведомления о бронировании администратору
  static Future<bool> sendBookingNotification({
    required String userName,
    required String userEmail,
    required String userPhone,
    required String checkInDate,
    required String checkOutDate,
    required String roomType,
    required int guestCount,
    String? specialRequests,
  }) async {
    try {
      // Настройка SMTP-сервера
      final smtpServer = SmtpServer(
        _hostUrl,
        port: _smtpPort,
        username: _username,
        password: _password,
        ssl: false,
        allowInsecure: false,
      );

      // Создание сообщения
      final message = Message()
        ..from = Address(_username, 'Отель Алихан')
        ..recipients.add(_adminEmail)
        ..subject = 'Новое бронирование от $userName'
        ..html = '''
          <h2>Детали бронирования в отеле Алихан</h2>
          <p><strong>Имя гостя:</strong> $userName</p>
          <p><strong>Email:</strong> $userEmail</p>
          <p><strong>Телефон:</strong> $userPhone</p>
          <p><strong>Дата заезда:</strong> $checkInDate</p>
          <p><strong>Дата выезда:</strong> $checkOutDate</p>
          <p><strong>Тип номера:</strong> $roomType</p>
          <p><strong>Количество гостей:</strong> $guestCount</p>
          <p><strong>Особые пожелания:</strong> ${specialRequests ?? 'Не указаны'}</p>
          <hr>
          <p>Это автоматическое уведомление. Пожалуйста, свяжитесь с гостем для подтверждения бронирования.</p>
        ''';

      // Отправка сообщения
      final sendReport = await send(message, smtpServer);
      print('Сообщение отправлено: ${sendReport.toString()}');
      return true;
    } catch (e) {
      print('Ошибка при отправке email: $e');
      return false;
    }
  }

  // Отправка подтверждения бронирования гостю
  static Future<bool> sendBookingConfirmation({
    required String userName,
    required String userEmail,
    required String checkInDate,
    required String checkOutDate,
    required String roomType,
    required int guestCount,
    String? specialRequests,
    String? bookingId,
  }) async {
    try {
      // Настройка SMTP-сервера
      final smtpServer = SmtpServer(
        _hostUrl,
        port: _smtpPort,
        username: _username,
        password: _password,
        ssl: false,
        allowInsecure: false,
      );

      // Создание сообщения
      final message = Message()
        ..from = Address(_username, 'Отель Алихан')
        ..recipients.add(userEmail)
        ..subject = 'Подтверждение бронирования в отеле Алихан'
        ..html = '''
          <h2>Уважаемый(ая) $userName!</h2>
          <p>Спасибо за бронирование в отеле Алихан. Ваше бронирование получено и ожидает подтверждения.</p>
          
          <h3>Детали вашего бронирования:</h3>
          <p><strong>Номер бронирования:</strong> ${bookingId ?? 'Будет предоставлен после подтверждения'}</p>
          <p><strong>Дата заезда:</strong> $checkInDate</p>
          <p><strong>Дата выезда:</strong> $checkOutDate</p>
          <p><strong>Тип номера:</strong> $roomType</p>
          <p><strong>Количество гостей:</strong> $guestCount</p>
          <p><strong>Особые пожелания:</strong> ${specialRequests ?? 'Не указаны'}</p>
          
          <p>Наш менеджер свяжется с вами в ближайшее время для подтверждения деталей бронирования.</p>
          
          <h3>Контактная информация отеля:</h3>
          <p>Телефон: +X XXX XXX XX XX</p>
          <p>Email: info@alihan-hotel.com</p>
          <p>Адрес: ул. Примерная, 123, Город</p>
          
          <p>С уважением,<br>Администрация отеля Алихан</p>
        ''';

      // Отправка сообщения
      final sendReport = await send(message, smtpServer);
      print('Подтверждение отправлено: ${sendReport.toString()}');
      return true;
    } catch (e) {
      print('Ошибка при отправке подтверждения: $e');
      return false;
    }
  }
}