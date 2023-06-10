import 'package:calculating_budget/component.dart';
import 'package:calculating_budget/view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class ExpenseViewWeb extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModelProvider = ref.watch(viewModel);
    double deviceWidth = MediaQuery.of(context).size.width;

    int totalExpense = 0;
    int totalIncome = 0;

    void Calculate() {
      for (int i = 0; i < viewModelProvider.expenseAmount.length; i++) {
        totalExpense =
            totalExpense + int.parse(viewModelProvider.expenseAmount[i]);
      }
      for (int i = 0; i < viewModelProvider.incomeAmount.length; i++) {
        totalExpense =
            totalIncome + int.parse(viewModelProvider.incomeAmount[i]);
      }
    }

    Calculate();

    int budgetLeft = totalIncome - totalExpense;

    return SafeArea(
        child: Scaffold(
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DrawerHeader(
              padding: EdgeInsets.only(bottom: 20.0),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(width: 1.0, color: Colors.black),
                ),
                child: const CircleAvatar(
                  radius: 180.0,
                  backgroundColor: Colors.white,
                  child: Image(
                    height: 100.0,
                    image: AssetImage('assets/logo.png'),
                    filterQuality: FilterQuality.high,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            MaterialButton(
              onPressed: () async {
                await viewModelProvider.logout();
              },
              color: Colors.black,
              height: 50.0,
              minWidth: 200.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
              elevation: 20.0,
              child: const OpenSans(
                text: 'Log Out',
                size: 20.0,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //instagram
                IconButton(
                  onPressed: () async => await launchUrl(Uri.parse(
                      'https://www.instagram.com/kzshaown/?next=%2F')),
                  icon: SvgPicture.asset(
                    'assets/instagram.svg',
                    color: Colors.black,
                    width: 35.0,
                  ),
                ),

                //git
                IconButton(
                  onPressed: () async => await launchUrl(
                      Uri.parse('https://github.com/Shaown292')),
                  icon: SvgPicture.asset(
                    'assets/git.svg',
                    color: Colors.black,
                    width: 40.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),

      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
          size: 30.0,
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Poppins(
          text: 'Dashboard',
          size: 20.0,
          color: Colors.white,
        ),
        actions: [
          IconButton(onPressed: () async{
            /// the reset function
          }, icon: Icon(Icons.refresh)),
        ],

      ),
          body: ListView(
            children: [
              SizedBox(height: 40.0,),
              Column(
                children: [
                  Container(
                    width: deviceWidth/1.5,
                    height: 240.0,
                    padding: EdgeInsets.all(15.0),
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.all(Radius.circular(25.0),),
                    ),
                    child:  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Poppins(text: 'Budget left',size: 14.0,color: Colors.white,),
                            Poppins(text: 'Total expense',size: 14.0,color: Colors.white,),
                            Poppins(text: 'Total income',size: 14.0,color: Colors.white,),
                          ],
                        ),
                        RotatedBox(
                          quarterTurns: 1,
                          child: Divider(
                            indent: 40.0,
                            endIndent: 40.0,
                            color: Colors.grey,
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Poppins(text: budgetLeft.toString(), size: 14.0, color: Colors.white,),
                            Poppins(text: totalExpense.toString(), size: 14.0, color: Colors.white,),
                            Poppins(text: totalIncome.toString(), size: 14.0, color: Colors.white,),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40.0,),
            ],
          ),
    ),);
  }
}
