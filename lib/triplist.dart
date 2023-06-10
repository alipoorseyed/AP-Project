import 'package:flutter/material.dart';

import 'BottomBar.dart';

class Flight {
  final String shomare_sefaresh;
  final String time;
  final String cost;
  final String company;
  final DateTime date;

  Flight({
    required this.time,
    required this.cost,
    required this.company,
    required this.shomare_sefaresh,
    required this.date,
  });
}

class TripsListPage extends StatefulWidget {
  final List<Flight> flights;

  TripsListPage({required this.flights});

  @override
  _TripsListPageState createState() => _TripsListPageState();
}

class _TripsListPageState extends State<TripsListPage> {
  List<Flight> filteredFlights = [];

  TextEditingController shomareSefareshController = TextEditingController();
  DateTime? fromDate;
  DateTime? toDate;

  @override
  void initState() {
    super.initState();
    filteredFlights = widget.flights;
  }

  void applyFilters() {
    String filterShomareSefaresh = shomareSefareshController.text.toLowerCase().trim();

    setState(() {
      filteredFlights = widget.flights.where((flight) {
        bool shomareSefareshMatches = flight.shomare_sefaresh.toLowerCase().contains(filterShomareSefaresh);

        bool dateMatches = true;
        if (fromDate != null && toDate != null) {
          dateMatches = flight.date.isAfter(fromDate!) && flight.date.isBefore(toDate!.add(Duration(days: 1)));
        }

        return shomareSefareshMatches && dateMatches;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // Set text direction to right-to-left
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'لیست سفر ها',
          ),
          centerTitle: true,
          backgroundColor: Colors.indigo,
        ),
        body: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: shomareSefareshController,
                decoration: InputDecoration(
                  labelText: 'شماره سفارش',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: fromDate ?? DateTime.now(),
                          firstDate: DateTime(2021),
                          lastDate: DateTime(2025),
                        );

                        if (pickedDate != null) {
                          setState(() {
                            fromDate = pickedDate;
                          });
                        }
                      },
                      icon: Icon(Icons.calendar_today),
                      label: Text(
                        fromDate != null ? 'از: ${fromDate!.toString().split(' ')[0]}' : 'انتخاب تاریخ شروع',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.indigo[600],
                        onPrimary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: toDate ?? DateTime.now(),
                          firstDate: DateTime(2021),
                          lastDate: DateTime(2025),
                        );

                        if (pickedDate != null) {
                          setState(() {
                            toDate = pickedDate;
                          });
                        }
                      },
                      icon: Icon(Icons.calendar_today),
                      label: Text(
                        toDate != null ? 'تا: ${toDate!.toString().split(' ')[0]}' : 'انتخاب تاریخ پایان',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.indigo[600],
                        onPrimary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.0),
              ElevatedButton(
                onPressed: applyFilters,
                child: Text(
                  'جستجو',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue[700],
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredFlights.length,
                  itemBuilder: (context, index) {
                    final flight = filteredFlights[index];
                    return Card(
                      elevation: 2.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: ListTile(
                        title: Text(
                          flight.shomare_sefaresh,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          '${flight.date.toString().split(' ')[0]}, ${flight.time}',
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                        trailing: Text(
                          '${flight.cost} - ${flight.company}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Bar(index: 2),
      ),
    );
  }
}
