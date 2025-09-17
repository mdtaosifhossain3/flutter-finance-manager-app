import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final IconData leadingIcon;
  final String title;
  final String subtitle;
  final String money;
  //final VoidCallback onActionTap;
  //final VoidCallback? onTap;

  const CustomListTile({
    super.key,
    required this.leadingIcon,
    required this.title,
    required this.subtitle,
    required this.money,
    //required this.onActionTap,
    //this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      //onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              blurRadius: 0,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(leadingIcon, size: 28, color: Colors.blue),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500)),
                const SizedBox(height: 2,),
                Text(subtitle,
                    style: const TextStyle(
                        fontSize: 10, fontWeight: FontWeight.w200)),

              ],
            ),
            Text(money,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w400)),
          ],
        ),
      ),
    );
  }
}