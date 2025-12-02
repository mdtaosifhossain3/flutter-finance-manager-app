import 'package:finance_manager_app/models/categoryModel/category_item_model.dart';
import 'package:flutter/material.dart';

final List<CategoryItemModel> incomeCategoryItems = [
  CategoryItemModel('salary', "salary", Colors.green),
  CategoryItemModel('business', "business", Colors.teal),
  CategoryItemModel('sales_revenue', "sales", Colors.blueAccent),
  CategoryItemModel('service_income', "service_seba", Colors.orangeAccent),
  CategoryItemModel(
    'freelance_contracts',
    "freelance",
    Colors.deepPurpleAccent,
  ),
  CategoryItemModel(
    'investment_returns',
    "inevesment_return",
    Colors.greenAccent,
  ),
  CategoryItemModel('rental_income', "rental", Colors.lightBlue),
  CategoryItemModel('asset_sales', "asset", Colors.amber),
  CategoryItemModel('royalties_licensing', "royalties", Colors.purple),
  CategoryItemModel('interest_dividends', "interest", Colors.indigoAccent),
  CategoryItemModel('side_income', "side_income", Colors.deepOrangeAccent),
  CategoryItemModel('commissions_affiliates', "commission", Colors.lightGreen),
  CategoryItemModel('refunds_reimbursements', "refund", Colors.blueGrey),
  CategoryItemModel('gifts', "gift", Colors.pinkAccent),
  CategoryItemModel('grants_subsidies', "grants", Colors.deepPurple),
  CategoryItemModel('miscellaneous_income', "other_income", Colors.grey),
];
