import 'package:dotmik_app/api/bbpsService.dart';
import 'package:flutter/material.dart';

class FormScreen extends StatefulWidget {
  final Map<String, dynamic> formParams;
  final String billerId;

  FormScreen({required this.formParams, required this.billerId});

  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _formData = <String, String>{}; // Store form data as String
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    List<Widget> formFields = [];

    for (var entry in widget.formParams.entries) {
      String paramKey = entry.key;
      var fieldParams = entry.value;

      if (fieldParams is Map<String, dynamic>) {
        final name = fieldParams['${paramKey}Name'] ?? 'Field';
        final regexPattern = fieldParams['${paramKey}Regex'] ?? '.*';
        final isNumeric = fieldParams['${paramKey}DataType'] == 'NUMERIC';
        final isOptional = fieldParams['${paramKey}Optional'] == 'true';

        formFields.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: name,
                hintText: name,
                hintStyle: TextStyle(color: Colors.black54),
                labelStyle: TextStyle(color: Colors.black),
              ),
              validator: (input) {
                if (input == null || input.isEmpty) {
                  if (!isOptional) {
                    return 'This field is required';
                  }
                } else {
                  final regex = RegExp(regexPattern);
                  if (!regex.hasMatch(input)) {
                    return 'Invalid input';
                  }
                }
                return null;
              },
              keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
              onSaved: (value) {
                _formData[paramKey] = value ?? '';
              },
              style: TextStyle(color: Colors.black),
            ),
          ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Fetch Bill'),
        backgroundColor: const Color.fromARGB(255, 237, 238, 239),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: formFields,
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                SizedBox(width: 8.0),
                ElevatedButton(
                  child: Text('Submit'),
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      _formKey.currentState?.save();
                      // Use the form data to call fetchBill
                      _fetchBill(widget.billerId, _formData);
                    }
                  },
                ),
              ],
            ),
            if (_isLoading)
              Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _fetchBill(String billerId, Map<String, String> params) async {
    setState(() {
      _isLoading = true;
    });

    try {
      Bbpsservice service = Bbpsservice();
      await service.fetchBill(billerId, params, context);
    } catch (e) {
      print("Error fetching bill: $e");
      // Optionally handle errors
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}


