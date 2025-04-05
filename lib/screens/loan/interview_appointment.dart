import 'package:flutter/material.dart';

class InterviewAppointmentPage extends StatefulWidget {
  const InterviewAppointmentPage({super.key});

  @override
  InterviewAppointmentState createState() => InterviewAppointmentState();
}

class InterviewAppointmentState extends State<InterviewAppointmentPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'InterviewAppointment',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
