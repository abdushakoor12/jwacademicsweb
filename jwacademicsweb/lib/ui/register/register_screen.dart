import 'package:easy_nav/easy_nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jwacademicsweb/ui/register/register_view_model.dart';

import '../../core/app_colors.dart';
import '../widgets/main_text_field.dart';

class RegisterScreen extends HookConsumerWidget {
  RegisterScreen({Key? key}) : super(key: key);

  static const String routeName = '/register';

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loading = ref.watch(registerViewModelProvider).loading;
    final nameController = useTextEditingController();
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final confirmPasswordController = useTextEditingController();
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Form(
        key: _formKey,
        child: Center(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            width: 420,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Text("Create An Account", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w500)),
                SizedBox(height: 10),

                Text("Enter your details to sign up to JW Academics", style: TextStyle(color: Colors.white,)),
                SizedBox(height: 16),

                MainTextField(hintText: "Full Name",
                  controller: nameController,
                  validator: (val){
                    if(val == null || val.trim().isEmpty){
                      return "Name is required";
                    }

                    return null;
                  },),
                SizedBox(height: 10),

                MainTextField(hintText: "Email Address",
                  controller: emailController,
                  validator: (val){
                    if(val == null || val.trim().isEmpty){
                      return "Email is required";
                    }
                    if(!val.contains("@") || !val.contains(".")){
                      return "Email is not valid";
                    }

                    return null;
                  },),
                SizedBox(height: 10),
                MainTextField(hintText: "Password",
                  controller: passwordController,
                  hideCharacters: true, validator: (val){
                    if(val == null || val.isEmpty){
                      return "Password is required";
                    }

                    if(val.length < 8){
                      return "Password must be at least 8 characters";
                    }

                    return null;
                  },),
                SizedBox(height: 10),
                MainTextField(hintText: "Confirm Password",
                  controller: confirmPasswordController,
                  hideCharacters: true, validator: (val){
                    if(val == null || val.isEmpty){
                      return "Password is required";
                    }

                    if(val.length < 8){
                      return "Password must be at least 8 characters";
                    }

                    if(val != passwordController.text){
                      return "Passwords do not match";
                    }

                    return null;
                  },),
                SizedBox(height: 30),
                Visibility(
                    visible: loading,
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                    )),
                Visibility(
                  visible: !loading,
                  child: Center(
                    child: FloatingActionButton.extended(onPressed: (){
                      if(_formKey.currentState!.validate()){
                        ref.read(registerViewModelProvider).register(
                          nameController.text.toString().trim(),
                            emailController.text.toString().trim(),
                            passwordController.text.toString()
                        );
                      }
                    },
                        backgroundColor: AppColors.lightSalmonColor,
                        label: Text("Register", style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary
                        ),)),
                  ),
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account?", style: TextStyle(color: Colors.white, fontSize: 16)),
                    TextButton(onPressed: (){
                      NavManager().goToNamed("/login");
                    }, child: Text("Login", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
