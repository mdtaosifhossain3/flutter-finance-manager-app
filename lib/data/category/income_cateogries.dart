import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/categoryModel/category_data_model.dart';

final List<CategoryData> incomeCategories = [
  // Primary Income
  CategoryData('salary'.tr, Icons.work, Color(0xFF00B894), 'primary_income'.tr),
  CategoryData('business'.tr, Icons.business, Color(0xFF6C5CE7), 'primary_income'.tr),
  CategoryData('freelance'.tr, Icons.laptop, Color(0xFF74B9FF), 'primary_income'.tr),
  CategoryData('contract_work'.tr, Icons.assignment, Color(0xFFFFB142), 'primary_income'.tr),
  CategoryData('overtime_pay'.tr, Icons.timer, Color(0xFF45B7D1), 'primary_income'.tr),

  // Investments
  CategoryData('stocks'.tr, Icons.trending_up, Color(0xFF00CEC9), 'investments'.tr),
  CategoryData('dividends'.tr, Icons.account_balance, Color(0xFF81ECEC), 'investments'.tr),
  CategoryData('crypto'.tr, Icons.currency_bitcoin, Color(0xFFFFB142), 'investments'.tr),
  CategoryData('mutual_funds'.tr, Icons.ssid_chart, Color(0xFF0984E3), 'investments'.tr),
  CategoryData('bonds'.tr, Icons.insert_chart, Color(0xFF1ABC9C), 'investments'.tr),
  CategoryData('real_estate'.tr, Icons.house, Color(0xFFFF6B6B), 'investments'.tr),

  // Rental & Assets
  CategoryData('rental'.tr, Icons.home, Color(0xFF55A3FF), 'rental_assets'.tr),
  CategoryData('vehicle_rent'.tr, Icons.directions_car, Color(0xFFFF9F43), 'rental_assets'.tr),
  CategoryData('property_lease'.tr, Icons.apartment, Color(0xFF4ECDC4), 'rental_assets'.tr),
  CategoryData('equipment_hire'.tr, Icons.handyman, Color(0xFF9B59B6), 'rental_assets'.tr),

  // Side Income
  CategoryData('part_time'.tr, Icons.schedule, Color(0xFFFF9F43), 'side_income'.tr),
  CategoryData('commission'.tr, Icons.percent, Color(0xFF4ECDC4), 'side_income'.tr),
  CategoryData('consulting'.tr, Icons.psychology, Color(0xFFFF7675), 'side_income'.tr),
  CategoryData('tutoring'.tr, Icons.school, Color(0xFF74B9FF), 'side_income'.tr),
  CategoryData('affiliate_marketing'.tr, Icons.link, Color(0xFF6C5CE7), 'side_income'.tr),
  CategoryData('online_sales'.tr, Icons.shopping_bag, Color(0xFF00B894), 'side_income'.tr),
  CategoryData('content_creation'.tr, Icons.videocam, Color(0xFFFF6B9D), 'side_income'.tr),

  // Other Income
  CategoryData('bonus'.tr, Icons.star, Color(0xFFFFCE56), 'other_income'.tr),
  CategoryData('incomegifts'.tr, Icons.card_giftcard, Color(0xFFFF6B9D), 'other_income'.tr),
  CategoryData('refund'.tr, Icons.refresh, Color(0xFF96CEB4), 'other_income'.tr),
  CategoryData('donations'.tr, Icons.volunteer_activism, Color(0xFF10AC84), 'other_income'.tr),
  CategoryData('awards_prizes'.tr, Icons.emoji_events, Color(0xFFFFB142), 'other_income'.tr),
  CategoryData('lottery_gambling'.tr, Icons.casino, Color(0xFF9B59B6), 'other_income'.tr),
  CategoryData('cashback_rewards'.tr, Icons.redeem, Color(0xFF1ABC9C), 'other_income'.tr),
  CategoryData('interest_income'.tr, Icons.savings, Color(0xFF009432), 'other_income'.tr),

  // Passive / Digital Income
  CategoryData('royalties'.tr, Icons.library_music, Color(0xFF00CEC9), 'passive_income'.tr),
  CategoryData('ads_revenue'.tr, Icons.ads_click, Color(0xFFFF7675), 'passive_income'.tr),
  CategoryData('licensing'.tr, Icons.description, Color(0xFF6C5CE7), 'passive_income'.tr),
  CategoryData('divine_donations'.tr, Icons.favorite, Color(0xFFFF6B6B), 'passive_income'.tr),

  // Final catch-all
  CategoryData('other'.tr, Icons.category, Color(0xFF636E72), 'incomemiscellaneous'.tr),
];
