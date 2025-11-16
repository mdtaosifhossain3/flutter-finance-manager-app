import 'package:finance_manager_app/models/categoryModel/category_item_model.dart';
import 'package:flutter/material.dart';

final List<CategoryItemModel> incomeCategoryItems = [
  CategoryItemModel('salary', Icons.work, Colors.green),
  CategoryItemModel('business', Icons.business_center, Colors.teal),
  CategoryItemModel('sales_revenue', Icons.point_of_sale, Colors.blueAccent),
  CategoryItemModel(
    'service_income',
    Icons.home_repair_service,
    Colors.orangeAccent,
  ),
  CategoryItemModel(
    'freelance_contracts',
    Icons.laptop_mac,
    Colors.deepPurpleAccent,
  ),
  CategoryItemModel(
    'investment_returns',
    Icons.trending_up,
    Colors.greenAccent,
  ),
  CategoryItemModel('rental_income', Icons.house, Colors.lightBlue),
  CategoryItemModel('asset_sales', Icons.attach_money, Colors.amber),
  CategoryItemModel('royalties_licensing', Icons.library_music, Colors.purple),
  CategoryItemModel('interest_dividends', Icons.savings, Colors.indigoAccent),
  CategoryItemModel('side_income', Icons.timelapse, Colors.deepOrangeAccent),
  CategoryItemModel('commissions_affiliates', Icons.link, Colors.lightGreen),
  CategoryItemModel('refunds_reimbursements', Icons.refresh, Colors.blueGrey),
  CategoryItemModel('gifts', Icons.card_giftcard, Colors.pinkAccent),
  CategoryItemModel(
    'grants_subsidies',
    Icons.volunteer_activism,
    Colors.deepPurple,
  ),
  CategoryItemModel('miscellaneous', Icons.category, Colors.grey),
];
