import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/categoryModel/category_data_model.dart';

final List<CategoryData> expenseCategories = [
  // Health & Fitness
  CategoryData(
    'doctor',
    Icons.local_hospital,
    Color(0xFFFF6B6B),
    'health_fitness',
  ),
  CategoryData(
    'medicine',
    Icons.medication,
    Color(0xFF4ECDC4),
    'health_fitness',
  ),
  CategoryData(
    'gym_exercise',
    Icons.fitness_center,
    Color(0xFF45B7D1),
    'health_fitness',
  ),
  CategoryData(
    'cycling',
    Icons.directions_bike,
    Color(0xFF96CEB4),
    'health_fitness',
  ),
  CategoryData(
    'yoga',
    Icons.self_improvement,
    Color(0xFFB388FF),
    'health_fitness',
  ),
  CategoryData(
    'sports',
    Icons.sports_soccer,
    Color(0xFFFF8C00),
    'health_fitness',
  ),

  // Food & Dining
  CategoryData(
    'groceries',
    Icons.shopping_cart,
    Color(0xFF4ECDC4),
    'food_dining',
  ),
  CategoryData(
    'tea_coffee',
    Icons.local_cafe,
    Color(0xFF6C5CE7),
    'food_dining',
  ),
  CategoryData(
    'restaurants',
    Icons.restaurant,
    Color(0xFFFFB142),
    'food_dining',
  ),
  CategoryData(
    'snacks_fast_food',
    Icons.fastfood,
    Color(0xFFFF7675),
    'food_dining',
  ),
  CategoryData(
    'drinks_beverages',
    Icons.local_bar,
    Color(0xFF74B9FF),
    'food_dining',
  ),
  CategoryData('home_cooking', Icons.kitchen, Color(0xFF81ECEC), 'food_dining'),

  // Bills & Utilities
  CategoryData(
    'phone_bill',
    Icons.phone_android,
    Color(0xFFFF6B9D),
    'bills_utilities',
  ),
  CategoryData(
    'water_bill',
    Icons.water_drop,
    Color(0xFF4ECDC4),
    'bills_utilities',
  ),
  CategoryData(
    'electricity_bill',
    Icons.electric_bolt,
    Color(0xFFFFA07A),
    'bills_utilities',
  ),
  CategoryData(
    'gas_bill',
    Icons.local_fire_department,
    Color(0xFFFF9F43),
    'bills_utilities',
  ),
  CategoryData(
    'internet_wifi',
    Icons.wifi,
    Color(0xFF6C5CE7),
    'bills_utilities',
  ),
  CategoryData('house_rent', Icons.home, Color(0xFF00B894), 'bills_utilities'),

  // Transportation
  CategoryData(
    'fuel',
    Icons.local_gas_station,
    Color(0xFFFF9F43),
    'transportation',
  ),
  CategoryData(
    'parking',
    Icons.local_parking,
    Color(0xFF74B9FF),
    'transportation',
  ),
  CategoryData(
    'public_transport',
    Icons.directions_bus,
    Color(0xFF00B894),
    'transportation',
  ),
  CategoryData(
    'taxi_ride_share',
    Icons.local_taxi,
    Color(0xFFEE5A24),
    'transportation',
  ),
  CategoryData(
    'vehicle_maintenance',
    Icons.build,
    Color(0xFF60A3BC),
    'transportation',
  ),

  // Entertainment
  CategoryData('movies', Icons.movie, Color(0xFF6C5CE7), 'entertainment'),
  CategoryData('games', Icons.games, Color(0xFFFF7675), 'entertainment'),
  CategoryData('music', Icons.music_note, Color(0xFF00CEC9), 'entertainment'),
  CategoryData(
    'travel_trips',
    Icons.flight,
    Color(0xFFFFB142),
    'entertainment',
  ),
  CategoryData(
    'streaming_services',
    Icons.tv,
    Color(0xFF0984E3),
    'entertainment',
  ),
  CategoryData('events_shows', Icons.event, Color(0xFFD980FA), 'entertainment'),

  // Shopping
  CategoryData('clothes', Icons.checkroom, Color(0xFFFFB142), 'shopping'),
  CategoryData('electronics', Icons.devices, Color(0xFF74B9FF), 'shopping'),
  CategoryData('books', Icons.book, Color(0xFF81ECEC), 'shopping'),
  CategoryData('accessories', Icons.watch, Color(0xFF6C5CE7), 'shopping'),
  CategoryData('gifts', Icons.card_giftcard, Color(0xFFFF7675), 'shopping'),

  // Education
  CategoryData('tuition_fees', Icons.school, Color(0xFF00CEC9), 'education'),
  CategoryData(
    'courses',
    Icons.cast_for_education,
    Color(0xFF74B9FF),
    'education',
  ),
  CategoryData('stationery', Icons.edit_note, Color(0xFFFFB142), 'education'),
  CategoryData(
    'books_study_materials',
    Icons.menu_book,
    Color(0xFF81ECEC),
    'education',
  ),

  // Family & Personal
  CategoryData(
    'child_care',
    Icons.child_friendly,
    Color(0xFFFD7272),
    'family_personal',
  ),
  CategoryData(
    'gifts_donations',
    Icons.volunteer_activism,
    Color(0xFF10AC84),
    'family_personal',
  ),
  CategoryData('pets', Icons.pets, Color(0xFFFF9FF3), 'family_personal'),
  CategoryData(
    'personal_care',
    Icons.spa,
    Color(0xFF48C9B0),
    'family_personal',
  ),
  CategoryData(
    'salon_beauty',
    Icons.face_retouching_natural,
    Color(0xFFFF6B81),
    'family_personal',
  ),

  // Investments & Finance
  CategoryData(
    'savings',
    Icons.savings,
    Color(0xFF009432),
    'investments_finance',
  ),
  CategoryData(
    'insurance',
    Icons.shield,
    Color(0xFF38ADA9),
    'investments_finance',
  ),
  CategoryData(
    'loan_emi',
    Icons.payments,
    Color(0xFFB53471),
    'investments_finance',
  ),
  CategoryData(
    'taxes',
    Icons.receipt_long,
    Color(0xFF6D214F),
    'investments_finance',
  ),

  // Miscellaneous
  CategoryData('emergency', Icons.warning, Color(0xFFE17055), 'miscellaneous'),
  CategoryData(
    'charity',
    Icons.volunteer_activism,
    Color(0xFF1ABC9C),
    'miscellaneous',
  ),
  CategoryData(
    'subscriptions',
    Icons.subscriptions,
    Color(0xFF0984E3),
    'miscellaneous',
  ),
  CategoryData(
    'repairs',
    Icons.build_circle,
    Color(0xFF6C5CE7),
    'miscellaneous',
  ),
  CategoryData('others', Icons.category, Color(0xFF636E72), 'miscellaneous'),
];
