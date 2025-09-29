import 'package:finance_manager_app/config/myColors/app_colors.dart';
import 'package:finance_manager_app/views/authView/phnVerificationView/verify_otp_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SentOtpView extends StatelessWidget {
  const SentOtpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkMainBackground,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomRight,
                  colors: [AppColors.darkMainBackground,AppColors.darkSecondaryBackground])
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            //  Icon(Icons.wallet,size: 140,color: AppColors.primaryBlue,),
              Image.asset("assets/images/playstore.png",height: 140,),
              SizedBox(height: 20,),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                Text("Phone  Verification ",style: TextStyle(
                  fontSize: 24,
                  color: AppColors.textPrimary
                ),),
                SizedBox(height: 10,),
                Text("We need to register your phone number before you started",
                  textAlign: TextAlign.center,style: TextStyle(fontSize: 16,color: AppColors.textSecondary),)
              ],),
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(children: [
                  TextFormField(

                    decoration: InputDecoration(
                      hintText: "Enter Robi/Airtel Number...",
                        enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.border,)
                      ),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.border,))
                    ),
                  ),
                  SizedBox(height: 20,),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        padding: EdgeInsetsGeometry.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))
                      ),
                        onPressed: (){
                        Get.to(VerifyOtpView());
                        }, child: Text("Send Code",style: TextStyle(color: AppColors.textPrimary),)),
                  )
                ],),
              )
            ],
          ),
        ),
      ),
    );
  }
}
