import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/categoryModel/category_data_model.dart';

final List<CategoryData> incomeCategories = [
  // Primary Income
  CategoryData('salary', Icons.work, Color(0xFF00B894), 'primary_income'),
  CategoryData('business', Icons.business, Color(0xFF6C5CE7), 'primary_income'),
  CategoryData('freelance', Icons.laptop, Color(0xFF74B9FF), 'primary_income'),
  CategoryData(
    'contract_work',
    Icons.assignment,
    Color(0xFFFFB142),
    'primary_income',
  ),
  CategoryData(
    'overtime_pay',
    Icons.timer,
    Color(0xFF45B7D1),
    'primary_income',
  ),

  // Investments
  CategoryData('stocks', Icons.trending_up, Color(0xFF00CEC9), 'investments'),
  CategoryData(
    'dividends',
    Icons.account_balance,
    Color(0xFF81ECEC),
    'investments',
  ),
  CategoryData(
    'crypto',
    Icons.currency_bitcoin,
    Color(0xFFFFB142),
    'investments',
  ),
  CategoryData(
    'mutual_funds',
    Icons.ssid_chart,
    Color(0xFF0984E3),
    'investments',
  ),
  CategoryData('bonds', Icons.insert_chart, Color(0xFF1ABC9C), 'investments'),
  CategoryData('real_estate', Icons.house, Color(0xFFFF6B6B), 'investments'),

  // Rental & Assets
  CategoryData('rental', Icons.home, Color(0xFF55A3FF), 'rental_assets'),
  CategoryData(
    'vehicle_rent',
    Icons.directions_car,
    Color(0xFFFF9F43),
    'rental_assets',
  ),
  CategoryData(
    'property_lease',
    Icons.apartment,
    Color(0xFF4ECDC4),
    'rental_assets',
  ),
  CategoryData(
    'equipment_hire',
    Icons.handyman,
    Color(0xFF9B59B6),
    'rental_assets',
  ),

  // Side Income
  CategoryData('part_time', Icons.schedule, Color(0xFFFF9F43), 'side_income'),
  CategoryData('commission', Icons.percent, Color(0xFF4ECDC4), 'side_income'),
  CategoryData(
    'consulting',
    Icons.psychology,
    Color(0xFFFF7675),
    'side_income',
  ),
  CategoryData('tutoring', Icons.school, Color(0xFF74B9FF), 'side_income'),
  CategoryData(
    'affiliate_marketing',
    Icons.link,
    Color(0xFF6C5CE7),
    'side_income',
  ),
  CategoryData(
    'online_sales',
    Icons.shopping_bag,
    Color(0xFF00B894),
    'side_income',
  ),
  CategoryData(
    'content_creation',
    Icons.videocam,
    Color(0xFFFF6B9D),
    'side_income',
  ),

  // Other Income
  CategoryData('bonus', Icons.star, Color(0xFFFFCE56), 'other_income'),
  CategoryData(
    'incomegifts',
    Icons.card_giftcard,
    Color(0xFFFF6B9D),
    'other_income',
  ),
  CategoryData('refund', Icons.refresh, Color(0xFF96CEB4), 'other_income'),
  CategoryData(
    'donations',
    Icons.volunteer_activism,
    Color(0xFF10AC84),
    'other_income',
  ),
  CategoryData(
    'awards_prizes',
    Icons.emoji_events,
    Color(0xFFFFB142),
    'other_income',
  ),
  CategoryData(
    'lottery_gambling',
    Icons.casino,
    Color(0xFF9B59B6),
    'other_income',
  ),
  CategoryData(
    'cashback_rewards',
    Icons.redeem,
    Color(0xFF1ABC9C),
    'other_income',
  ),
  CategoryData(
    'interest_income',
    Icons.savings,
    Color(0xFF009432),
    'other_income',
  ),

  // Passive / Digital Income
  CategoryData(
    'royalties',
    Icons.library_music,
    Color(0xFF00CEC9),
    'passive_income',
  ),
  CategoryData(
    'ads_revenue',
    Icons.ads_click,
    Color(0xFFFF7675),
    'passive_income',
  ),
  CategoryData(
    'licensing',
    Icons.description,
    Color(0xFF6C5CE7),
    'passive_income',
  ),
  CategoryData(
    'divine_donations',
    Icons.favorite,
    Color(0xFFFF6B6B),
    'passive_income',
  ),

  // Final catch-all
  CategoryData(
    'other',
    Icons.category,
    Color(0xFF636E72),
    'income miscellaneous',
  ),
];
