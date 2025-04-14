import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
class Utils {
  static void fieldFocusChange(
      BuildContext , context ,
      FocusNode current  ,FocusNode nextFocus)
  {
    current.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
 static toastMessage(String message){
  Fluttertoast.showToast(
      msg:message ,
      backgroundColor:
  Colors.green  , textColor: Colors.white);
}
static void flushBarErrorMessage(String message , BuildContext context){

  showFlushbar(context: context, flushbar: Flushbar(
   forwardAnimationCurve: Curves.decelerate,
   margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
   padding: EdgeInsets.all(15),
   flushbarPosition: FlushbarPosition.TOP,
   reverseAnimationCurve: Curves.easeInOut,
   borderRadius: BorderRadius.circular(8),
   positionOffset: 20,
   icon: Icon(Icons.error_outline,size: 20,color: Colors.white,),
   message: message,
   duration: Duration(seconds: 5),
   backgroundColor: Colors.green,
   messageColor: Colors.white,

  )..show(context)
  );
}
static snackBar (String message , BuildContext context ){
  return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          backgroundColor: Colors.green,
          content: Text(message)));
}
}