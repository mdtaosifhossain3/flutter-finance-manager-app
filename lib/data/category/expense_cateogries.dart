import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/categoryModel/category_data_model.dart';

final List<CategoryData> expenseCategories = [
  // Health & Fitness
  CategoryData(
    'doctor'.tr,
    Icons.local_hospital,
    Color(0xFFFF6B6B),
    'health_fitness'.tr,
  ),
  CategoryData(
    'medicine'.tr,
    Icons.medication,
    Color(0xFF4ECDC4),
    'health_fitness'.tr,
  ),
  CategoryData(
    'gym_exercise'.tr,
    Icons.fitness_center,
    Color(0xFF45B7D1),
    'health_fitness'.tr,
  ),
  CategoryData(
    'cycling'.tr,
    Icons.directions_bike,
    Color(0xFF96CEB4),
    'health_fitness'.tr,
  ),
  CategoryData(
    'yoga'.tr,
    Icons.self_improvement,
    Color(0xFFB388FF),
    'health_fitness'.tr,
  ),
  CategoryData(
    'sports'.tr,
    Icons.sports_soccer,
    Color(0xFFFF8C00),
    'health_fitness'.tr,
  ),

  // Food & Dining
  CategoryData(
    'groceries'.tr,
    Icons.shopping_cart,
    Color(0xFF4ECDC4),
    'food_dining'.tr,
  ),
  CategoryData(
    'tea_coffee'.tr,
    Icons.local_cafe,
    Color(0xFF6C5CE7),
    'food_dining'.tr,
  ),
  CategoryData(
    'restaurants'.tr,
    Icons.restaurant,
    Color(0xFFFFB142),
    'food_dining'.tr,
  ),
  CategoryData(
    'snacks_fast_food'.tr,
    Icons.fastfood,
    Color(0xFFFF7675),
    'food_dining'.tr,
  ),
  CategoryData(
    'drinks_beverages'.tr,
    Icons.local_bar,
    Color(0xFF74B9FF),
    'food_dining'.tr,
  ),
  CategoryData(
    'home_cooking'.tr,
    Icons.kitchen,
    Color(0xFF81ECEC),
    'food_dining'.tr,
  ),

  // Bills & Utilities
  CategoryData(
    'phone_bill'.tr,
    Icons.phone_android,
    Color(0xFFFF6B9D),
    'bills_utilities'.tr,
  ),
  CategoryData(
    'water_bill'.tr,
    Icons.water_drop,
    Color(0xFF4ECDC4),
    'bills_utilities'.tr,
  ),
  CategoryData(
    'electricity_bill'.tr,
    Icons.electric_bolt,
    Color(0xFFFFA07A),
    'bills_utilities'.tr,
  ),
  CategoryData(
    'gas_bill'.tr,
    Icons.local_fire_department,
    Color(0xFFFF9F43),
    'bills_utilities'.tr,
  ),
  CategoryData(
    'internet_wifi'.tr,
    Icons.wifi,
    Color(0xFF6C5CE7),
    'bills_utilities'.tr,
  ),
  CategoryData(
    'house_rent'.tr,
    Icons.home,
    Color(0xFF00B894),
    'bills_utilities'.tr,
  ),

  // Transportation
  CategoryData(
    'fuel'.tr,
    Icons.local_gas_station,
    Color(0xFFFF9F43),
    'transportation'.tr,
  ),
  CategoryData(
    'parking'.tr,
    Icons.local_parking,
    Color(0xFF74B9FF),
    'transportation'.tr,
  ),
  CategoryData(
    'public_transport'.tr,
    Icons.directions_bus,
    Color(0xFF00B894),
    'transportation'.tr,
  ),
  CategoryData(
    'taxi_ride_share'.tr,
    Icons.local_taxi,
    Color(0xFFEE5A24),
    'transportation'.tr,
  ),
  CategoryData(
    'vehicle_maintenance'.tr,
    Icons.build,
    Color(0xFF60A3BC),
    'transportation'.tr,
  ),

  // Entertainment
  CategoryData('movies'.tr, Icons.movie, Color(0xFF6C5CE7), 'entertainment'.tr),
  CategoryData('games'.tr, Icons.games, Color(0xFFFF7675), 'entertainment'.tr),
  CategoryData('music'.tr, Icons.music_note, Color(0xFF00CEC9), 'entertainment'.tr),
  CategoryData('travel_trips'.tr, Icons.flight, Color(0xFFFFB142), 'entertainment'.tr),
  CategoryData('streaming_services'.tr, Icons.tv, Color(0xFF0984E3), 'entertainment'.tr),
  CategoryData('events_shows'.tr, Icons.event, Color(0xFFD980FA), 'entertainment'.tr),

  // Shopping
  CategoryData('clothes'.tr, Icons.checkroom, Color(0xFFFFB142), 'shopping'.tr),
  CategoryData('electronics'.tr, Icons.devices, Color(0xFF74B9FF), 'shopping'.tr),
  CategoryData('books'.tr, Icons.book, Color(0xFF81ECEC), 'shopping'.tr),
  CategoryData('accessories'.tr, Icons.watch, Color(0xFF6C5CE7), 'shopping'.tr),
  CategoryData('gifts'.tr, Icons.card_giftcard, Color(0xFFFF7675), 'shopping'.tr),

  // Education
  CategoryData('tuition_fees'.tr, Icons.school, Color(0xFF00CEC9), 'education'.tr),
  CategoryData('courses'.tr, Icons.cast_for_education, Color(0xFF74B9FF), 'education'.tr),
  CategoryData('stationery'.tr, Icons.edit_note, Color(0xFFFFB142), 'education'.tr),
  CategoryData('books_study_materials'.tr, Icons.menu_book, Color(0xFF81ECEC), 'education'.tr),

  // Family & Personal
  CategoryData('child_care'.tr, Icons.child_friendly, Color(0xFFFD7272), 'family_personal'.tr),
  CategoryData('gifts_donations'.tr, Icons.volunteer_activism, Color(0xFF10AC84), 'family_personal'.tr),
  CategoryData('pets'.tr, Icons.pets, Color(0xFFFF9FF3), 'family_personal'.tr),
  CategoryData('personal_care'.tr, Icons.spa, Color(0xFF48C9B0), 'family_personal'.tr),
  CategoryData('salon_beauty'.tr, Icons.face_retouching_natural, Color(0xFFFF6B81), 'family_personal'.tr),

  // Investments & Finance
  CategoryData('savings'.tr, Icons.savings, Color(0xFF009432), 'investments_finance'.tr),
  CategoryData('insurance'.tr, Icons.shield, Color(0xFF38ADA9), 'investments_finance'.tr),
  CategoryData('loan_emi'.tr, Icons.payments, Color(0xFFB53471), 'investments_finance'.tr),
  CategoryData('taxes'.tr, Icons.receipt_long, Color(0xFF6D214F), 'investments_finance'.tr),

  // Miscellaneous
  CategoryData('emergency'.tr, Icons.warning, Color(0xFFE17055), 'miscellaneous'.tr),
  CategoryData('charity'.tr, Icons.volunteer_activism, Color(0xFF1ABC9C), 'miscellaneous'.tr),
  CategoryData('subscriptions'.tr, Icons.subscriptions, Color(0xFF0984E3), 'miscellaneous'.tr),
  CategoryData('repairs'.tr, Icons.build_circle, Color(0xFF6C5CE7), 'miscellaneous'.tr),
  CategoryData('others'.tr, Icons.category, Color(0xFF636E72), 'miscellaneous'.tr),
];