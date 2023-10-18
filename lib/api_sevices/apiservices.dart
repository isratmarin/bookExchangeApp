
import 'package:book_exchange/models/customer_modals.dart';
import 'package:http/http.dart' as http;

class ApiService {

  final String _baseUrl = 'http://192.168.0.128:8080';


    Future<List<Customermodel>?> fetchCustomer() async {
      final url = '$_baseUrl/customar/all';
      final uri = Uri.parse(url);
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final List<Customermodel> data = customermodelFromJson(response.body);
        return data;
      } else {
        throw Exception('Fail to load data');
      }
    }

    Future<void> deleteCustomer(int customer_id) async {
      final url = '$_baseUrl/deletes/$customer_id';
      final uri = Uri.parse(url);
      final response = await http.delete(uri);
      if (response.statusCode == 204) {
      } else if (response.statusCode == 404) {
        throw Exception('Customer not found'); // Handle not found case
      } else {
        throw Exception('Failed to delete Customer'); // Handle other errors
      }
    }


  // Future<void> addCustomer() async {
  //   customermodel = Customermodel(
  //       customer_id: int.parse(_cid.text.toString()),
  //       name: _cname.text.toString(),
  //       email: _email.text.toString(),
  //       password: _password.text.toString(),
  //       dob: _dob.text.toString(),
  //       nationality: _nationality.text.toString(),
  //       phone: _phone.text.toString(),
  //       address: _address.text.toString());
  //
  //   if (_cid.text.isNotEmpty) {
  //     final url = '$_baseUrl/save';
  //     final uri = Uri.parse(url);
  //     final response = await http.post(uri,
  //         headers: {"content-type": "application/json"},
  //         body: jsonEncode(customermodel.toJson()));
  //     if (response.statusCode == 200) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text('Success: Product deleted successfully'),
  //           backgroundColor: Colors.green, // Customize the background color
  //         ),
  //       );
  //     }
  //   }
  // }

  }




