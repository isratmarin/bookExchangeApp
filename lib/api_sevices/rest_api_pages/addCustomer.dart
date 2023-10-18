
import 'dart:convert';

import 'package:book_exchange/dashboard/user_dashboard.dart';
import 'package:book_exchange/models/customer_modals.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddCustomer extends StatefulWidget {
  final Customermodel? customerToEdit;
  const AddCustomer({super.key, this.customerToEdit});

  @override
  State<AddCustomer> createState() => _AddCustomerState();
}

class _AddCustomerState extends State<AddCustomer> {

  TextEditingController _cid = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _cname = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _dob = TextEditingController();
  TextEditingController _nationality = TextEditingController();
  TextEditingController _phone = TextEditingController();
  TextEditingController _address = TextEditingController();
  final String _baseUrl = 'http://192.168.0.128:8080';
  late Customermodel customerModel;
  bool isEditMode = false;


  Future<void> addCustomer() async {
    customerModel = Customermodel(
        customer_id: int.parse(_cid.text.toString()),
              name: _cname.text.toString(),
              email: _email.text.toString(),
              password: _password.text.toString(),
              dob: _dob.text.toString(),
              nationality: _nationality.text.toString(),
              phone: _phone.text.toString(),
              address: _address.text.toString());

    if (_cid.text.isNotEmpty) {
      final url = '$_baseUrl/customarinsert';
      final uri = Uri.parse(url);
      final response = await http.post(uri,
          headers: {"content-type": "application/json"},
          body: jsonEncode(customerModel.toJson()));
      if (response.statusCode == 200) {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>UserDashboard()));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Success: Customer Added successfully'),
            backgroundColor: Colors.green, // Customize the background color
          ),
        );
      }
    }
  }

  void initState() {
    super.initState();
    if (widget.customerToEdit != null) {
      isEditMode = true;
      _cid = TextEditingController(text: widget.customerToEdit?.customer_id.toString());
    }
    _cname = TextEditingController(text: widget.customerToEdit?.name);
    _email =
        TextEditingController(text: widget.customerToEdit?.email);
    _password =
        TextEditingController(text: widget.customerToEdit?.password);
    _dob = TextEditingController(text: widget.customerToEdit?.dob);
    _nationality = TextEditingController(text: widget.customerToEdit?.nationality);
    _phone = TextEditingController(text: widget.customerToEdit?.phone);
    _address = TextEditingController(text: widget.customerToEdit?.address);
  }

  @override
  Widget build(BuildContext context) {
    TextStyle? textStyle = Theme.of(context).textTheme.titleMedium;
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Customer"),
      ),
      body: Form(
        child: Padding(
          padding: const EdgeInsets.all(5 * 2),
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 5),
                child: TextFormField(
                  style: textStyle,
                  controller: _cid,
                  readOnly: isEditMode,
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'please enter customer id';
                    }
                  },
                  decoration: InputDecoration(
                      labelText: 'customer id',
                      hintText: 'Emter customer id',
                      labelStyle: textStyle,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 5),
                child: TextFormField(
                  style: textStyle,
                  controller: _cname,
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'please enter customer name';
                    }
                  },
                  decoration: InputDecoration(
                      labelText: 'Customer name',
                      hintText: 'Emter customer name',
                      labelStyle: textStyle,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 5),
                child: TextFormField(
                  style: textStyle,
                  controller: _email,
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'please enter customer email';
                    }
                  },
                  decoration: InputDecoration(
                      labelText: 'Email',
                      hintText: 'Emter customer email',
                      labelStyle: textStyle,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 5),
                child: TextFormField(
                  style: textStyle,
                  controller: _password,
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'please enter password';
                    }
                  },
                  decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Emter password',
                      labelStyle: textStyle,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 5),
                child: TextFormField(
                  style: textStyle,
                  controller: _dob,
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'please enter customer dob';
                    }
                  },
                  decoration: InputDecoration(
                      labelText: 'DOB',
                      hintText: 'Enter customer dob',
                      labelStyle: textStyle,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 5),
                child: TextFormField(
                  style: textStyle,
                  controller: _nationality,
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'please enter Nationality';
                    }
                  },
                  decoration: InputDecoration(
                      labelText: 'Nationality',
                      hintText: 'Emter Nationality',
                      labelStyle: textStyle,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 5),
                child: TextFormField(
                  style: textStyle,
                  controller: _phone,
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'please enter phone number';
                    }
                  },
                  decoration: InputDecoration(
                      labelText: 'Phone',
                      hintText: 'Emter Phone number',
                      labelStyle: textStyle,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 5),
                child: TextFormField(
                  style: textStyle,
                  controller: _address,
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'please enter address';
                    }
                  },
                  decoration: InputDecoration(
                      labelText: 'Address',
                      hintText: 'Emter customer address',
                      labelStyle: textStyle,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    addCustomer();
                    Navigator.pop(context);
                    setState(() {
                    });
                  },
                  child: Text( 'Submit'))
            ],
          ),
        ),
      ),
    );
  }
  }

