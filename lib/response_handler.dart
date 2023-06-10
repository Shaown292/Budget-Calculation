
import 'package:calculating_budget/mobile/expense_view_mobile.dart';
import 'package:calculating_budget/view_model.dart';
import 'package:calculating_budget/web/expense_view_web.dart';
import 'package:calculating_budget/web/login_view_web.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'mobile/login_view_mobile.dart';

class ResponseHanlder extends HookConsumerWidget{
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    final viewModelProvider = ref.watch(viewModel);
    viewModelProvider.isLoggedin();
    if(viewModelProvider.isSignedIn == true){
      return LayoutBuilder(builder: (context, constraints){
        if (constraints.maxWidth > 600){
          return ExpenseViewWeb();
        }
        else{
          return ExpenseViewMobile();
        }
      });
    }
    else{
      return LayoutBuilder(builder: (context, constraints){
        if (constraints.maxWidth > 600){
          return LoginViewWeb();
        }
        else{
          return LoginViewMobile();
        }
      });
    }

  }

}