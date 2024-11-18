import 'package:flutter/material.dart';
import 'package:medilab/Constants/constants.dart';

class ReusableContainer extends StatelessWidget {
  final String name;
  final VoidCallback onTap;
  final Icon icon;

  const ReusableContainer({
    super.key,
    required this.name,
    required this.onTap,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.17,
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Color(0xff3E7696))),
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              // Icon at the left
              icon,
              Expanded(
                child: Center(
                  child: Text(
                    name,
                    style: kGoogleBlackTextStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReusableTextfield extends StatefulWidget {
  final String title;
  final TextEditingController controller;
  final Icon icon;
  final bool isPassword;

  const ReusableTextfield({
    super.key,
    required this.title,
    required this.controller,
    required this.icon,
    this.isPassword = false,
  });

  @override
  _ReusableTextfieldState createState() => _ReusableTextfieldState();
}

class _ReusableTextfieldState extends State<ReusableTextfield> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextFormField(
            controller: widget.controller,
            obscureText: widget.isPassword ? _obscureText : false,
            decoration: InputDecoration(
              hintText: widget.title,
              prefixIcon: widget.icon,
              suffixIcon: widget.isPassword
                  ? IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    )
                  : null,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.grey),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.red),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
            validator: (value) {
              if (widget.title == 'Email') {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                  return 'Please enter a valid email';
                }
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}

class ReusableButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  const ReusableButton({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          height: MediaQuery.of(context).size.height * .08,
          width: MediaQuery.of(context).size.width * .6,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Color(0xff3E7696)),
          child: Center(
            child: Text(
              text,
              style: kWhiteTextStyle,
            ),
          ),
        ),
      ),
    );
  }
}

//Reusable Container for IMAGES ON DASHBOARDS
class ReusableDashboardImages extends StatelessWidget {
  final Image image;
  final VoidCallback onTap;
  final String text;

  const ReusableDashboardImages({
    super.key,
    required this.image,
    required this.onTap,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4, // Consistent width
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.15,
              child: image,
            ),
            SizedBox(height: 8), // Space between image and text
            Text(
              text,
              style: kGoogleBlackTextStyle,
              textAlign: TextAlign.center, // Center align the text
            ),
          ],
        ),
      ),
    );
  }
}
