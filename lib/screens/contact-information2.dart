import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pikatcha/screens/home.dart';
import 'package:pikatcha/screens/login.dart';
import 'package:pikatcha/widgets/button.dart';
import 'package:pikatcha/widgets/inputfield.dart';
import 'package:pikatcha/widgets/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContactInformationForGoogle extends StatelessWidget {

  final String email;
  final String uid;
  final String Uname;

  ContactInformationForGoogle({Key key, this.email, this.uid, this.Uname}) : super(key: key);

  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController address = TextEditingController();
  CollectionReference collectionReference = Firestore.instance.collection('users');

  signUp(BuildContext context) async {
    if(name.text!='' && phone.text!='' && address.text!=''){
      try{

        await collectionReference.document(uid).setData({
          'email': email,
          'name': name.text,
          'phone': phone.text,
          'address': address.text
        });

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('email', email);
        prefs.setString('uid', uid);


        Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context){
          return Home();}));
        
      }
      catch(E){
        ToastBar(color: Colors.red,text: 'Something Went Wrong!').show();
        print(E);
      }
    }else{
      ToastBar(color: Colors.red,text: 'Please Fill all the Fields!').show();
    }
  }


  @override
  Widget build(BuildContext context) {
    name.text = Uname;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Contact Information',style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: InputField(hint: 'Name',prefix: Icons.person,controller: name,),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: InputField(hint: 'Phone Number',type: TextInputType.phone,prefix: Icons.phone_android,controller: phone,),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: InputField(hint: 'Address',prefix: Icons.location_city,controller: address,),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(30,100,30,0),
            child: Button(text: 'Submit',onclick: ()=>signUp(context),),
          ),
        ],
      ),
    );
  }
}