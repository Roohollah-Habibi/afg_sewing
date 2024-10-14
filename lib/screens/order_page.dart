import 'package:afg_sewing/custom_widgets/text_field.dart';
import 'package:flutter/material.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final tt = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
      ),
      body: Center(
          child: Form(
        child: SingleChildScrollView(
          child: Wrap(
            alignment: WrapAlignment.spaceEvenly,
            runSpacing: 20,
            children: [
              CustomTextField(txtEditingController: tt, label: 'HEIGHT', prefixIcon: Icon(Icons.height),),
              CustomTextField(txtEditingController: tt, label: 'SHOULDER', prefixIcon: Icon(Icons.border_color),),
              CustomTextField(txtEditingController: tt, label: 'SHOULDER', prefixIcon: Icon(Icons.border_color),),
              CustomTextField(txtEditingController: tt, label: 'SHOULDER', prefixIcon: Icon(Icons.border_color),),
              CustomTextField(txtEditingController: tt, label: 'SHOULDER', prefixIcon: Icon(Icons.border_color),),
              CustomTextField(txtEditingController: tt, label: 'SHOULDER', prefixIcon: Icon(Icons.border_color),),
              CustomTextField(txtEditingController: tt, label: 'SHOULDER', prefixIcon: Icon(Icons.border_color),),
              CustomTextField(txtEditingController: tt, label: 'SHOULDER', prefixIcon: Icon(Icons.border_color),),
              CustomTextField(txtEditingController: tt, label: 'SHOULDER', prefixIcon: Icon(Icons.border_color),),
              CustomTextField(txtEditingController: tt, label: 'SHOULDER', prefixIcon: Icon(Icons.border_color),),
              CustomTextField(txtEditingController: tt, label: 'SHOULDER', prefixIcon: Icon(Icons.border_color),),
              Row(children: [
                Expanded(child: CustomTextField(txtEditingController: tt, label: 'TotalMody', prefixIcon: Icon(Icons.monetization_on))),
                Expanded(child: CustomTextField(txtEditingController: tt, label: 'Recieved', prefixIcon: Icon(Icons.monetization_on))),
              ],),
              CustomTextField(txtEditingController: tt, label: 'Remaining', prefixIcon: Icon(Icons.border_color),),
              ElevatedButton(onPressed: (){}, child: Text('Save')),
              ElevatedButton(onPressed: (){}, child: Text('Cancel'))
            ],
          ),
        ),
      )),
    );
  }
}
