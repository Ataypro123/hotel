import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/bookingmodel.dart';

class AlkhanHotelAdminApp extends StatelessWidget {
  const AlkhanHotelAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Отель Алихан - Админ-панель',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF1A3365),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A3365),
          secondary: const Color(0xFFE7A83E),
        ),
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1A3365),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFE7A83E),
            foregroundColor: Colors.white,
          ),
        ),
      ),
      home: const AdminPanelScreen(),
    );
  }
}

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  int _selectedIndex = 0;
  final List<String> _filterOptions = ['Все', 'Активные', 'Завершенные', 'Отмененные'];
  String _selectedFilter = 'Все';
  
  // Имитация данных бронирований
  final List<BookingModel> _bookings = [
    BookingModel(
      id: "B001",
      roomNumber: "101",
      roomType: "Люкс",
      guestName: "Александр Иванов",
      checkIn: DateTime.now().subtract(const Duration(days: 2)),
      checkOut: DateTime.now().add(const Duration(days: 3)),
      guests: 2,
      totalPrice: 32500,
      status: BookingStatus.active,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      phoneNumber: "+7 (901) 123-45-67",
      notes: "Ранний заезд, нужны дополнительные подушки",
    ),
    BookingModel(
      id: "B002",
      roomNumber: "205",
      roomType: "Стандарт",
      guestName: "Мария Петрова",
      checkIn: DateTime.now().add(const Duration(days: 5)),
      checkOut: DateTime.now().add(const Duration(days: 10)),
      guests: 1,
      totalPrice: 18750,
      status: BookingStatus.upcoming,
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
      phoneNumber: "+7 (902) 234-56-78",
    ),
    BookingModel(
      id: "B003",
      roomNumber: "304",
      roomType: "Полулюкс",
      guestName: "Сергей Смирнов",
      checkIn: DateTime.now().subtract(const Duration(days: 10)),
      checkOut: DateTime.now().subtract(const Duration(days: 5)),
      guests: 3,
      totalPrice: 24000,
      status: BookingStatus.completed,
      createdAt: DateTime.now().subtract(const Duration(days: 45)),
      phoneNumber: "+7 (903) 345-67-89",
    ),
    BookingModel(
      id: "B004",
      roomNumber: "402",
      roomType: "Семейный",
      guestName: "Елена Кузнецова",
      checkIn: DateTime.now().add(const Duration(days: 2)),
      checkOut: DateTime.now().add(const Duration(days: 9)),
      guests: 4,
      totalPrice: 42800,
      status: BookingStatus.active,
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
      phoneNumber: "+7 (904) 456-78-90",
      notes: "Нужна детская кроватка",
    ),
    BookingModel(
      id: "B005",
      roomNumber: "110",
      roomType: "Стандарт",
      guestName: "Дмитрий Козлов",
      checkIn: DateTime.now().subtract(const Duration(days: 3)),
      checkOut: DateTime.now().add(const Duration(days: 1)),
      guests: 2,
      totalPrice: 12000,
      status: BookingStatus.active,
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
      phoneNumber: "+7 (905) 567-89-01",
    ),
    BookingModel(
      id: "B006",
      roomNumber: "215",
      roomType: "Люкс",
      guestName: "Наталья Морозова",
      checkIn: DateTime.now().add(const Duration(days: 15)),
      checkOut: DateTime.now().add(const Duration(days: 22)),
      guests: 2,
      totalPrice: 49000,
      status: BookingStatus.upcoming,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      phoneNumber: "+7 (906) 678-90-12",
      notes: "Поздний выезд",
    ),
    BookingModel(
      id: "B007",
      roomNumber: "303",
      roomType: "Стандарт",
      guestName: "Андрей Волков",
      checkIn: DateTime.now().subtract(const Duration(days: 6)),
      checkOut: DateTime.now().subtract(const Duration(days: 1)),
      guests: 1,
      totalPrice: 15000,
      status: BookingStatus.cancelled,
      createdAt: DateTime.now().subtract(const Duration(days: 25)),
      phoneNumber: "+7 (907) 789-01-23",
      notes: "Отменено клиентом",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/logo.png',
              height: 40,
              // Замените на действительный логотип или удалите этот блок
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.hotel, size: 32),
            ),
            const SizedBox(width: 12),
            const Text('Отель Алихан | Админ-панель'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Уведомления')),
              );
            },
          ),
          const CircleAvatar(
            radius: 16,
            backgroundColor: Colors.white,
            child: Text('АА', style: TextStyle(color: Color(0xFF1A3365), fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Row(
        children: [
          // Боковое меню
          NavigationRail(
            backgroundColor: Colors.white,
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            labelType: NavigationRailLabelType.selected,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.dashboard_outlined),
                selectedIcon: Icon(Icons.dashboard),
                label: Text('Панель'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.hotel_outlined),
                selectedIcon: Icon(Icons.hotel),
                label: Text('Номера'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.people_outline),
                selectedIcon: Icon(Icons.people),
                label: Text('Гости'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.bar_chart_outlined),
                selectedIcon: Icon(Icons.bar_chart),
                label: Text('Отчеты'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.settings_outlined),
                selectedIcon: Icon(Icons.settings),
                label: Text('Настройки'),
              ),
            ],
          ),
          
          // Главный контент
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Заголовок страницы
                  const Text(
                    'Бронирования',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A3365),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Управление всеми бронированиями отеля',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Панель с краткой статистикой
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          'Активные', 
                          '12', 
                          Colors.green[100]!, 
                          Colors.green,
                          Icons.check_circle_outline,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildStatCard(
                          'Ожидающие', 
                          '8', 
                          Colors.orange[100]!, 
                          Colors.orange,
                          Icons.schedule,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildStatCard(
                          'Отмененные', 
                          '3', 
                          Colors.red[100]!, 
                          Colors.red,
                          Icons.cancel_outlined,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildStatCard(
                          'Всего за месяц', 
                          '45', 
                          Colors.blue[100]!, 
                          Colors.blue,
                          Icons.calendar_month_outlined,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Фильтры и поиск
                  Row(
                    children: [
                      // Фильтры
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedFilter,
                            items: _filterOptions.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                _selectedFilter = newValue!;
                              });
                            },
                            icon: const Icon(Icons.filter_list),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      
                      // Поиск
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Поиск бронирований...',
                            prefixIcon: const Icon(Icons.search),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(width: 16),
                      
                      // Кнопка добавления
                      ElevatedButton.icon(
                        onPressed: () {
                          _showAddBookingDialog(context);
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Новое бронирование'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          elevation: 0,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Таблица бронирований
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: _buildBookingsTable(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color bgColor, Color? iconColor, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBookingsTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: MaterialStateProperty.all(Colors.grey[50]),
          headingTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
          columns: const [
            DataColumn(label: Text('ID')),
            DataColumn(label: Text('Номер')),
            DataColumn(label: Text('Гость')),
            DataColumn(label: Text('Заезд')),
            DataColumn(label: Text('Выезд')),
            DataColumn(label: Text('Гостей')),
            DataColumn(label: Text('Сумма')),
            DataColumn(label: Text('Статус')),
            DataColumn(label: Text('Действия')),
          ],
          rows: _bookings.map((booking) {
            return DataRow(
              cells: [
                DataCell(Text(booking.id)),
                DataCell(Text('${booking.roomNumber} (${booking.roomType})')),
                DataCell(Text(booking.guestName)),
                DataCell(Text(_formatDate(booking.checkIn))),
                DataCell(Text(_formatDate(booking.checkOut))),
                DataCell(Text(booking.guests.toString())),
                DataCell(Text('${booking.totalPrice.toStringAsFixed(0)} ₽')),
                DataCell(_getStatusBadge(booking.status)),
                DataCell(Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.visibility, size: 20),
                      onPressed: () {
                        _showBookingDetails(context, booking);
                      },
                      color: Theme.of(context).primaryColor,
                      tooltip: 'Просмотреть',
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20),
                      onPressed: () {
                        // Редактирование бронирования
                      },
                      color: Colors.orange,
                      tooltip: 'Редактировать',
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, size: 20),
                      onPressed: () {
                        // Удаление бронирования
                      },
                      color: Colors.red,
                      tooltip: 'Удалить',
                    ),
                  ],
                )),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _getStatusBadge(BookingStatus status) {
    late Color color;
    late String text;
    
    switch (status) {
      case BookingStatus.active:
        color = Colors.green;
        text = 'Активно';
        break;
      case BookingStatus.upcoming:
        color = Colors.blue;
        text = 'Ожидается';
        break;
      case BookingStatus.completed:
        color = Colors.grey;
        text = 'Завершено';
        break;
      case BookingStatus.cancelled:
        color = Colors.red;
        text = 'Отменено';
        break;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontWeight: FontWeight.w500),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd.MM.yyyy').format(date);
  }

  void _showBookingDetails(BuildContext context, BookingModel booking) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.hotel, color: Color(0xFF1A3365)),
              const SizedBox(width: 8),
              Text('Бронирование №${booking.id}'),
            ],
          ),
          content: SizedBox(
            width: 500,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        _buildInfoColumn('Статус', _getStatusBadge(booking.status)),
                        const SizedBox(width: 16),
                        _buildInfoColumn('Дата создания', Text(_formatDate(booking.createdAt))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Информация о госте',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Divider(),
                  _buildInfoRow('Имя гостя', booking.guestName),
                  _buildInfoRow('Телефон', booking.phoneNumber),
                  const SizedBox(height: 24),
                  const Text(
                    'Детали бронирования',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Divider(),
                  _buildInfoRow('Номер комнаты', '${booking.roomNumber} (${booking.roomType})'),
                  _buildInfoRow('Дата заезда', _formatDate(booking.checkIn)),
                  _buildInfoRow('Дата выезда', _formatDate(booking.checkOut)),
                  _buildInfoRow('Количество гостей', booking.guests.toString()),
                  _buildInfoRow(
                    'Общая стоимость', 
                    '${booking.totalPrice.toStringAsFixed(0)} ₽',
                    valueStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF1A3365),
                    ),
                  ),
                  if (booking.notes != null && booking.notes!.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    const Text(
                      'Примечания',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Divider(),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Text(booking.notes!),
                    ),
                  ],
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Закрыть'),
            ),
            if (booking.status == BookingStatus.upcoming || booking.status == BookingStatus.active)
              ElevatedButton(
                onPressed: () {
                  // Редактировать бронирование
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A3365),
                ),
                child: const Text('Редактировать'),
              ),
          ],
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value, {TextStyle? valueStyle}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: valueStyle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoColumn(String label, Widget value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          value,
        ],
      ),
    );
  }

  void _showAddBookingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.add_circle_outline, color: Color(0xFF1A3365)),
              const SizedBox(width: 8),
              const Text('Новое бронирование'),
            ],
          ),
          content: SizedBox(
            width: 500,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const TextField(
                    decoration: InputDecoration(
                      labelText: 'ФИО гостя',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: '101',
                              items: ['101', '102', '103', '201', '202'].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {},
                              hint: const Text('Номер комнаты'),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: 'Стандарт',
                              items: ['Стандарт', 'Люкс', 'Полулюкс', 'Семейный'].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {},
                              hint: const Text('Тип номера'),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: const TextField(
                          decoration: InputDecoration(
                            labelText: 'Дата заезда',
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: const TextField(
                          decoration: InputDecoration(
                            labelText: 'Дата выезда',
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: const TextField(
                          decoration: InputDecoration(
                            labelText: 'Телефон',
                            border: OutlineInputBorder(),
                            prefixText: '+7 ',
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: const TextField(
                          decoration: InputDecoration(
                            labelText: 'Количество гостей',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const TextField(
                    decoration: InputDecoration(
                      labelText: 'Сумма (₽)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  const TextField(
                    decoration: InputDecoration(
                      labelText: 'Примечания',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Сохранить'),
            ),
          ],
        );
      },
    );
  }
}
