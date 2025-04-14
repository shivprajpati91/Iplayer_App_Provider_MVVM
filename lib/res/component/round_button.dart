import 'dart:ffi';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../utils/utils.dart';
import '../color.dart';
class RoundButton extends StatelessWidget {

  final String title ;
  final bool loading ;
  final VoidCallback onPress ;
  const RoundButton({Key? key , required this.title ,this.loading = false , required this.onPress,

  }) : super(key: key );
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.07,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),
          color:Appcolor.whiteColor,),

        child: Center(child:loading? CircularProgressIndicator(color: Colors.black,)
            :  Text(title,style: TextStyle(color: Colors.black,fontSize: MediaQuery.of(context).size.width * 0.05,),)),
      ),
    );
  }
}
