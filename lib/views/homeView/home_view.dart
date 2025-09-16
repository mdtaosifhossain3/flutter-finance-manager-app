
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../globalWidgets/Custom_listtile.dart';
import '../../providers/expense_provider.dart';
import '../../providers/theme_provider.dart';
import 'package:percent_indicator/percent_indicator.dart';

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

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black12,
        elevation: 0,

        // ✅ Profile picture + name
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundImage: AssetImage("assets/images/avatar.png"), // or NetworkImage
          ),
        ),
        title: const Text(
          "Najmus Sakib", // Replace with your name or dynamic data
          style: TextStyle(fontWeight: FontWeight.w400,fontSize: 20),
        ),

        // ✅ Actions (two icons)
        actions: [
          IconButton(onPressed: (){
            context.read<ThemeProvider>().toggleTheme();
          }, icon: Icon( context.watch<ThemeProvider>().isDark ? Icons.dark_mode : Icons.light_mode)),

          IconButton(
            onPressed: () {
              // Notifications action
            },
            icon: const Icon(Icons.notifications),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(

          children: [
         Column(
           children: [
             Container(
               color: Colors.black,
               height: screenHeight * 0.5,
               width: screenWidth,

               child: Center(
                 child: CircularPercentIndicator(
                     radius: 130,
                   lineWidth: 20,
                   percent: 0.4,
                   progressColor: Colors.lightGreen,
                   backgroundColor: Colors.grey.shade50,
                   circularStrokeCap: CircularStrokeCap.round,

                   center:Column(
                     children: [
                       SizedBox(height: 100,),
                       Text('Expenses',style: TextStyle(color: Colors.white60,fontSize:15),),
                       SizedBox(height: 5,),
                       Text('6000 BDT',style: TextStyle(color: Colors.white,fontSize:30),),
                       SizedBox(height: 5,),
                       Text("Out of BDT \$5000",style: TextStyle(color: Colors.white60,fontSize:15),),
                     ],
                   ),
                 ),

               ),

             ),
           ],
         ),

           SizedBox(height: 5,) ,
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('History',style: TextStyle(color: Colors.white,fontSize:20,fontWeight: FontWeight.bold),),
                    TextButton(onPressed: (){}, child:Text('All >>',style: TextStyle(color: Colors.white60,fontSize:15),) )
                  ],
            ),
                CustomListTile(leadingIcon: Icons.person, title: 'Giving Money',subtitle: "15 Dec 2025", money: '1000-BDT',),
                CustomListTile(leadingIcon: Icons.person, title: 'Giving Money',subtitle: "15 Dec 2025", money: '1000-BDT',),
                //CustomListTile(leadingIcon: Icons.person, title: 'Giving Money',subtitle: "15 Dec 2025", money: '1000-BDT',),


              ],
            )
          ],

        ),
      ),


    );
  }
}
