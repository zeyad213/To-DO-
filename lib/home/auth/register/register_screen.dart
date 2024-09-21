import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/dialog_utlis.dart';
import 'package:todo_app/firebase_utils.dart';
import 'package:todo_app/home/auth/customer_text_form_field.dart';
import 'package:todo_app/home/homescreen.dart';
import 'package:todo_app/my_user.dart';
import 'package:todo_app/user_provider.dart';


class RegisterScreen extends StatelessWidget {
 static const String routeName = 'register_screen';
 TextEditingController nameController =  TextEditingController(text: 'Zeyad99');
 TextEditingController emailController =  TextEditingController(text: 'zeyadamin@route.com');
 TextEditingController passwordController =  TextEditingController(text: '393398900');
 TextEditingController confirmPasswordController =  TextEditingController(text: '393398900');
 var formKey = GlobalKey<FormState>() ;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Account'),
          centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
         
          children: [
            Form(
              key: formKey,
                child:Column(
                  crossAxisAlignment:  CrossAxisAlignment.stretch,
              children: [
                CustomerTextFormField(label: 'User Name' ,
                controller: nameController,
                  validator: (text){
                    if(text == null || text.trim().isEmpty){
                      return 'Please enter user name' ;
                    }
                    return null ;
                  },
                ),
                CustomerTextFormField(label: 'Email',
                controller: emailController,
                  validator: (text){
                    if(text == null || text.trim().isEmpty){
                      return 'Please enter Email' ;
                    }
                    final bool emailValid =
                        RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+.[a-zA-Z]+").hasMatch(text) ;
                    if(!emailValid){
                      return 'Please enter a Valid Email' ;
                    }
                     return null ;
                  },
                  keyboardType:  TextInputType.emailAddress,
                ),
                CustomerTextFormField(label: 'Password',
                controller: passwordController,
                  validator: (text){
                    if(text == null || text.trim().isEmpty){
                      return 'Please enter Password' ;
                    }
                    if(text.length < 6){
                      return 'Password must be at least 6  characters. ' ;

                    }
                    return null ;
                  },
                  keyboardType: TextInputType.number,
                  obscureText: true,
                ),
                CustomerTextFormField(label: 'Confirm Password',
                controller: confirmPasswordController,
                  validator: (text){
                    if(text == null || text.trim().isEmpty){
                      return 'Please enter Confirm Password' ;
                    }
                    if(text.length < 6){
                      return 'Password must be at least 6  characters. ' ;

                    }
                    if(passwordController.text !=  confirmPasswordController.text){
                      return "Confirm Password doesn't match your Password " ;

                    }
                    return null ;
                  },
                  keyboardType: TextInputType.number,
                  obscureText: true,

                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ElevatedButton(
                      onPressed : (){
                       register(context);
                  },
                      child: Text("Creat an Account",
                      style: Theme.of(context).textTheme.bodyLarge,
                  )),
                )

              ],
            ) )
          ],
        ),
      ),
    );
  }

  void register(BuildContext context) async {
    DialogUtlis.showLoading(context: context, loadingLabel: 'loading' ,
    barrierDismissible: false) ;
    if(formKey.currentState?.validate() == true){
      try {
        final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        MyUser myUser = MyUser(
            id: credential.user?.uid??'',
            name: nameController.text,
            email: emailController.text
        );
        await FirebaseUtils.addUserToFireStore(myUser);
        var userProvider = Provider.of<UserProvider>(context,listen:false );
        userProvider.updateUser(myUser);
        DialogUtlis.hideLoading(context);
        DialogUtlis.showMessage(context: context, message: 'Register Successfully' ,
        title: 'Success' ,posActionName: 'Ok',posAction: (){
          Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
            });

      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          DialogUtlis.hideLoading(context);
          DialogUtlis.showMessage(context: context, message: 'The password provided is very weak.',title: 'Error',
          posActionName: 'OK');

        } else if (e.code == 'email-already-in-use') {
          DialogUtlis.hideLoading(context);
          DialogUtlis.showMessage(context: context, message: 'The account already exists for that email.',title: 'Error',
              posActionName: 'OK');

        }
      } catch (e) {
        DialogUtlis.hideLoading(context);
        DialogUtlis.showMessage(context: context, message: e.toString() ,title: 'Error',
            posActionName: 'OK');

      }
    }
  }
}
