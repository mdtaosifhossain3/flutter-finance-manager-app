import 'package:finance_manager_app/models/categoryModel/category_item_model.dart';
import 'package:flutter/material.dart';

final List<CategoryItemModel> categoryItems = [
  CategoryItemModel('health_fitness', Icons.favorite, Colors.redAccent),
  CategoryItemModel('food_dining', Icons.restaurant, Colors.orangeAccent),
  CategoryItemModel('bills_utilities', Icons.receipt_long, Colors.blueAccent),
  CategoryItemModel('beauty', Icons.spa, Colors.pinkAccent),
  CategoryItemModel('housing', Icons.home, Colors.teal),
  CategoryItemModel('transportation', Icons.directions_car, Colors.blueGrey),
  CategoryItemModel('entertainment', Icons.movie, Colors.deepPurpleAccent),
  CategoryItemModel('shopping', Icons.shopping_bag, Colors.purpleAccent),
  CategoryItemModel('groceries', Icons.local_grocery_store, Colors.greenAccent),
  CategoryItemModel('education', Icons.school, Colors.lightBlue),
  CategoryItemModel('personal', Icons.person, Colors.brown),
  CategoryItemModel('investment', Icons.trending_up, Colors.green),
  CategoryItemModel('marketing_advertising', Icons.campaign, Colors.amber),
  CategoryItemModel(
    'travel_accommodation',
    Icons.flight_takeoff,
    Colors.deepOrange,
  ),
  CategoryItemModel('office_supplies_equipment', Icons.work, Colors.cyan),
  CategoryItemModel('insurance', Icons.health_and_safety, Colors.blue),
  CategoryItemModel(
    'subscription_services',
    Icons.subscriptions,
    Colors.deepPurple,
  ),
  CategoryItemModel('fuel_mileage', Icons.local_gas_station, Colors.orange),
  CategoryItemModel('charity_donations', Icons.volunteer_activism, Colors.pink),
  CategoryItemModel('kids', Icons.child_friendly, Colors.lightGreen),
  CategoryItemModel('repairs', Icons.build, Colors.grey),
  CategoryItemModel('pets', Icons.pets, Colors.brown),
  CategoryItemModel('sports', Icons.sports_soccer, Colors.lightBlueAccent),
  CategoryItemModel('miscellaneous', Icons.category, Colors.grey),
];
