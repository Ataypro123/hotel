// screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:html' as html;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentBannerIndex = 0;
  final ScrollController _scrollController = ScrollController();
  
  // Placeholder data for hotel features
  final List<Map<String, dynamic>> _hotelFeatures = [
    {
      'icon': FontAwesomeIcons.wifi,
      'title': 'Бесплатный Wi-Fi',
      'description': 'Высокоскоростной интернет во всех номерах и общественных зонах'
    },
    {
      'icon': FontAwesomeIcons.panorama,
      'title': 'Бассейн',
      'description': 'Открытый и закрытый бассейны с подогревом'
    },
    {
      'icon': FontAwesomeIcons.utensils,
      'title': 'Ресторан',
      'description': 'Изысканная кухня и широкий выбор блюд'
    },
    {
      'icon': FontAwesomeIcons.spa,
      'title': 'СПА-центр',
      'description': 'Различные процедуры для вашего комфорта и релаксации'
    },
    {
      'icon': FontAwesomeIcons.dumbbell,
      'title': 'Фитнес-центр',
      'description': 'Современное оборудование для поддержания формы'
    },
    {
      'icon': FontAwesomeIcons.car,
      'title': 'Парковка',
      'description': 'Бесплатная парковка для гостей отеля'
    },
  ];
  
  // Placeholder data for room types
  final List<Map<String, dynamic>> _roomTypes = [
    {
      'image': 'assets/images/room_standard.jpg', // Add your own image paths
      'title': 'Стандарт',
      'price': '5000₽',
      'description': 'Комфортный номер с двуспальной кроватью и всеми необходимыми удобствами',
    },
    {
      'image': 'assets/images/room_comfort.jpg',
      'title': 'Комфорт',
      'price': '7500₽',
      'description': 'Просторный номер с панорамным видом и улучшенной мебелью',
    },
    {
      'image': 'assets/images/room_lux.jpg',
      'title': 'Люкс',
      'price': '12000₽',
      'description': 'Двухкомнатный люкс с гостиной, спальней и джакузи',
    },
    {
      'image': 'assets/images/room_premium.jpg',
      'title': 'Премиум',
      'price': '20000₽',
      'description': 'Эксклюзивный номер с отдельной террасой и персональным обслуживанием',
    },
  ];
  
  // Placeholder banner images
  final List<String> _bannerImages = [
    'assets/images/banner1.jpg',
    'assets/images/banner2.png',
    'assets/images/banner3.png',
    'assets/images/banner4.png',
  ];
  
  // Placeholder reviews
  final List<Map<String, dynamic>> _reviews = [
    {
      'name': 'Александра М.',
      'avatar': 'assets/images/avatar1.jpg',
      'rating': 5,
      'comment': 'Потрясающий отель с великолепным обслуживанием! Обязательно вернемся снова.',
      'date': '15 марта 2025',
    },
    {
      'name': 'Игорь В.',
      'avatar': 'assets/images/avatar2.jpg',
      'rating': 4,
      'comment': 'Очень впечатлил СПА-центр и бассейн. Отличное место для отдыха.',
      'date': '2 апреля 2025',
    },
    {
      'name': 'Екатерина Д.',
      'avatar': 'assets/images/avatar3.jpg',
      'rating': 5,
      'comment': 'Безупречный сервис, очень вкусная еда в ресторане. Всем рекомендую!',
      'date': '10 апреля 2025',
    },
  ];

  void _scrollToSection(String sectionId) {
    // Implement smooth scrolling to sections
    switch (sectionId) {
      case 'rooms':
        _scrollController.animateTo(
          500, // Adjust based on your layout
          duration: Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
        break;
      case 'features':
        _scrollController.animateTo(
          900, // Adjust based on your layout
          duration: Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
        break;
      case 'reviews':
        _scrollController.animateTo(
          1500, // Adjust based on your layout
          duration: Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
        break;
      case 'contact':
        _scrollController.animateTo(
          2000, // Adjust based on your layout
          duration: Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo.png', // Add your logo image
              height: 40,
              fit: BoxFit.contain,
            ),
            SizedBox(width: 12),
            Text('Hotel Alihan'),
          ],
        ),
        actions: [
          // Navigation links for desktop view
          if (MediaQuery.of(context).size.width > 768) ...[
            TextButton(
              onPressed: () => _scrollToSection('rooms'),
              child: Text('Номера', 
                style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.w500),
              ),
            ),
            TextButton(
              onPressed: () => _scrollToSection('features'),
              child: Text('Удобства', 
                style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.w500),
              ),
            ),
            TextButton(
              onPressed: () => _scrollToSection('reviews'),
              child: Text('Отзывы', 
                style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.w500),
              ),
            ),
            TextButton(
              onPressed: () => _scrollToSection('contact'),
              child: Text('Контакты', 
                style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.w500),
              ),
            ),
          ],
          PopupMenuButton<String>(
            icon: Icon(Icons.account_circle, size: 28),
            onSelected: (value) {
              switch (value) {
                case 'booking':
                  Navigator.pushNamed(context, '/booking');
                  break;
                case 'my_bookings':
                  Navigator.pushNamed(context, '/my_bookings');
                  break;
                case 'regis':
                  Navigator.pushNamed(context, '/regis');
                break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'booking',
                child: Row(
                  children: [
                    Icon(Icons.add_circle_outline, color: Colors.indigo),
                    SizedBox(width: 8),
                    Text('Забронировать номер'),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'my_bookings',
                child: Row(
                  children: [
                    Icon(Icons.list_alt, color: Colors.indigo),
                    SizedBox(width: 8),
                    Text('Мои бронирования'),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'regis',
                child: Row(
                  children: [
                    Icon(Icons.login, color: Colors.indigo),
                    SizedBox(width: 8),
                    Text('Login'),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(width: 20),
        ],
        backgroundColor: Colors.white.withOpacity(0.9),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Hero Banner Section
            Stack(
              children: [
                CarouselSlider(
                  options: CarouselOptions(
                    height: 600,
                    viewportFraction: 1.0,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 5),
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    enlargeCenterPage: false,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentBannerIndex = index;
                      });
                    },
                  ),
                  items: _bannerImages.map((imageUrl) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(imageUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.black.withOpacity(0.1),
                                  Colors.black.withOpacity(0.7),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 50),
                    child: Column(
                      children: [
                        Text(
                          'HOTEL ALIHAN',
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 3,
                            fontFamily: 'Playfair Display',
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'РОСКОШНЫЙ ОТДЫХ В САМОМ СЕРДЦЕ ГОРОДА',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            letterSpacing: 2,
                          ),
                        ),
                        SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/booking');
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          ),
                          child: Text(
                            'ЗАБРОНИРОВАТЬ СЕЙЧАС',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        SizedBox(height: 30),
                        AnimatedSmoothIndicator(
                          activeIndex: _currentBannerIndex,
                          count: _bannerImages.length,
                          effect: ExpandingDotsEffect(
                            dotHeight: 8,
                            dotWidth: 8,
                            activeDotColor: Colors.amber,
                            dotColor: Colors.white.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            
            // Welcome Section
            Container(
              padding: EdgeInsets.symmetric(vertical: 80, horizontal: 20),
              color: Colors.white,
              child: Column(
                children: [
                  Text(
                    'ДОБРО ПОЖАЛОВАТЬ',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber[800],
                      letterSpacing: 2,
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Откройте для себя роскошь и комфорт',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo[900],
                      fontFamily: 'Playfair Display',
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: 50,
                    height: 2,
                    color: Colors.amber[800],
                  ),
                  SizedBox(height: 30),
                  Container(
                    constraints: BoxConstraints(maxWidth: 800),
                    child: Text(
                      'Отель Alihan — это уникальное сочетание роскоши, комфорта и первоклассного сервиса. Расположенный в живописном месте, наш отель предлагает незабываемый отдых для тех, кто ценит высокое качество жизни. Изысканные номера, великолепная кухня и множество дополнительных услуг сделают ваше пребывание по-настоящему незабываемым.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                        height: 1.6,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Room Types Section
            Container(
              padding: EdgeInsets.symmetric(vertical: 80, horizontal: 20),
              color: Colors.grey[50],
              child: Column(
                children: [
                  Text(
                    'НАШИ НОМЕРА',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber[800],
                      letterSpacing: 2,
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Выберите идеальный номер для вашего отдыха',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo[900],
                      fontFamily: 'Playfair Display',
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: 50,
                    height: 2,
                    color: Colors.amber[800],
                  ),
                  SizedBox(height: 50),
                  
                  // Room grid with StaggeredGridView for responsive design
                  StaggeredGrid.count(
                    crossAxisCount: MediaQuery.of(context).size.width > 1100 ? 4 : 
                                 MediaQuery.of(context).size.width > 700 ? 2 : 1,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    children: _roomTypes.map((room) {
                      return StaggeredGridTile.fit(
                        crossAxisCellCount: 1,
                        child: _buildRoomCard(room),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            
            // Hotel Features Section
            Container(
              padding: EdgeInsets.symmetric(vertical: 80, horizontal: 20),
              color: Colors.white,
              child: Column(
                children: [
                  Text(
                    'УДОБСТВА ОТЕЛЯ',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber[800],
                      letterSpacing: 2,
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Все для вашего комфорта',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo[900],
                      fontFamily: 'Playfair Display',
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: 50,
                    height: 2,
                    color: Colors.amber[800],
                  ),
                  SizedBox(height: 50),
                  
                  // Features grid
                  StaggeredGrid.count(
                    crossAxisCount: MediaQuery.of(context).size.width > 1100 ? 3 : 
                                 MediaQuery.of(context).size.width > 700 ? 2 : 1,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    children: _hotelFeatures.map((feature) {
                      return StaggeredGridTile.fit(
                        crossAxisCellCount: 1,
                        child: _buildFeatureCard(feature),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            
            // CTA Banner (Book Now)
            Container(
              height: 300,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/cta_banner.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.indigo.withOpacity(0.8),
                      Colors.indigo.withOpacity(0.6),
                    ],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'СПЕЦИАЛЬНОЕ ПРЕДЛОЖЕНИЕ',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber[300],
                          letterSpacing: 2,
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        'Забронируйте прямо сейчас и получите скидку 15%',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Playfair Display',
                        ),
                      ),
                      SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/booking');
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        ),
                        child: Text(
                          'ЗАБРОНИРОВАТЬ НОМЕР',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Reviews Section
            Container(
              padding: EdgeInsets.symmetric(vertical: 80, horizontal: 20),
              color: Colors.grey[50],
              child: Column(
                children: [
                  Text(
                    'ОТЗЫВЫ ГОСТЕЙ',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber[800],
                      letterSpacing: 2,
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Что говорят о нас наши гости',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo[900],
                      fontFamily: 'Playfair Display',
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: 50,
                    height: 2,
                    color: Colors.amber[800],
                  ),
                  SizedBox(height: 50),
                  
                  // Reviews carousel
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 250,
                      enlargeCenterPage: true,
                      enableInfiniteScroll: true,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 5),
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      viewportFraction: MediaQuery.of(context).size.width > 768 ? 0.5 : 0.85,
                    ),
                    items: _reviews.map((review) {
                      return Builder(
                        builder: (BuildContext context) {
                          return _buildReviewCard(review);
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            
            // Contact Section
            Container(
              padding: EdgeInsets.symmetric(vertical: 80, horizontal: 20),
              color: Colors.indigo[900],
              child: Column(
                children: [
                  Text(
                    'СВЯЗАТЬСЯ С НАМИ',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber[300],
                      letterSpacing: 2,
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Мы всегда рады вам помочь',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Playfair Display',
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: 50,
                    height: 2,
                    color: Colors.amber[300],
                  ),
                  SizedBox(height: 50),
                  
                  // Contact info in a responsive layout
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 50,
                    runSpacing: 30,
                    children: [
                      _buildContactItem(
                        FontAwesomeIcons.locationDot, 
                        'Адрес', 
                        'ул. 312 , Бодрум'
                      ),
                      _buildContactItem(
                        FontAwesomeIcons.phone, 
                        'Телефон', 
                        '+8 (495) 123-45-67'
                      ),
                      _buildContactItem(
                        FontAwesomeIcons.envelope, 
                        'Email', 
                        'info@hotelalihan.ru'
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 50),
                  
                  // Social Media Icons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildSocialIcon(FontAwesomeIcons.facebook),
                      SizedBox(width: 20),
                      _buildSocialIcon(FontAwesomeIcons.instagram),
                      SizedBox(width: 20),
                      _buildSocialIcon(FontAwesomeIcons.twitter),
                      SizedBox(width: 20),
                      _buildSocialIcon(FontAwesomeIcons.telegram),
                    ],
                  ),
                ],
              ),
            ),
            
            // Footer
            Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              color: Colors.indigo[950],
              child: Center(
                child: Text(
                  '© 2025 Hotel Alihan. Все права защищены.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            
            // Floating Booking Button for Mobile
            if (MediaQuery.of(context).size.width <= 768) 
              Positioned(
                bottom: 20,
                right: 20,
                child: FloatingActionButton.extended(
                  onPressed: () {
                    Navigator.pushNamed(context, '/booking');
                  },
                  label: Text('Забронировать'),
                  icon: Icon(Icons.hotel),
                  backgroundColor: Colors.amber[800],
                ),
              ),
          ],
        ),
      ),
    );
  }
  
  // Room Card Widget
  Widget _buildRoomCard(Map<String, dynamic> room) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.asset(
              room['image'],
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      room['title'],
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo[900],
                      ),
                    ),
                    Text(
                      room['price'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber[800],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  'за ночь',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  room['description'],
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/booking');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                  ),
                  child: Text('ЗАБРОНИРОВАТЬ'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  // Feature Card Widget
  Widget _buildFeatureCard(Map<String, dynamic> feature) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              feature['icon'],
              size: 45,
              color: Colors.amber[800],
            ),
            SizedBox(height: 16),
            Text(
              feature['title'],
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.indigo[900],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              feature['description'],
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
  
  // Review Card Widget
  Widget _buildReviewCard(Map<String, dynamic> review) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: AssetImage(review['avatar']),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review['name'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        review['date'],
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      index < review['rating'] ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 18,
                    );
                  }),
                ),
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child: Text(
                review['comment'],
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // Contact Item Widget
  Widget _buildContactItem(IconData icon, String title, String info) {
    return Container(
      width: 250,
      child: Column(
        children: [
          Icon(
            icon,
            color: Colors.amber[300],
            size: 36,
          ),
          SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            info,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  
  // Social Media Icon Widget
  Widget _buildSocialIcon(IconData icon) {
    return InkWell(
      onTap: () {
        // Add social media link action
      },
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.1),
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }
}