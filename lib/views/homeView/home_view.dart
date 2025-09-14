
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/expense_provider.dart';
import '../../providers/theme_provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    context.read<AddExpenseProvider>().getAllExpenses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(
        child: Center(child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Text("Home View",style: Theme.of(context).textTheme.bodyLarge,)
            ,ElevatedButton(onPressed: (){
              context.read<ThemeProvider>().toggleTheme();
            }, child: Text("Change Theme",style:Theme.of(context).textTheme.bodyMedium ,))
        ],),),
      ),
    );
  }
}
