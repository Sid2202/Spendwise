// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';


// class MonthSelector extends StatefulWidget {
//   final Function(String) onMonthSelected; // Pass a callback for when a month is selected

//   MonthSelector({required this.onMonthSelected});

//   @override
//   _MonthSelectorState createState() => _MonthSelectorState();
// }

// class _MonthSelectorState extends State<MonthSelector> {
//   String _selectedMonth = DateFormat('MMMM').format(DateTime.now());
//   final List<String> _months = [
//     'January', 'February', 'March', 'April', 'May', 'June',
//     'July', 'August', 'September', 'October', 'November', 'December'
//   ];

//   void _showMonthPicker(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       builder: (BuildContext context) {
//         return Container(
//           height: 300,
//           child: ListView.builder(
//             itemCount: _months.length,
//             itemBuilder: (context, index) {
//               return ListTile(
//                 title: Text(_months[index]),
//                 onTap: () {
//                   setState(() {
//                     _selectedMonth = _months[index]; // Update the selected month in state
//                   });
//                   widget.onMonthSelected(_selectedMonth); // Notify parent of the selected month
//                   Navigator.pop(context); // Close the modal
//                 },
//               );
//             },
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => _showMonthPicker(context), // Open the month picker on tap
//       child: Text(
//         _selectedMonth,
//         style: const TextStyle(
//           fontSize: 16,
//           color: Colors.white,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonthSelector extends StatefulWidget {
  final Function(String) onMonthSelected; // Pass a callback for when a month is selected

  MonthSelector({required this.onMonthSelected});

  @override
  _MonthSelectorState createState() => _MonthSelectorState();
}

class _MonthSelectorState extends State<MonthSelector> {
  String _selectedMonth = DateFormat('MMMM').format(DateTime.now());
  final List<String> _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  void _showMonthPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          child: ListView.builder(
            itemCount: _months.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(_months[index]),
                onTap: () {
                  setState(() {
                    _selectedMonth = _months[index]; // Update the selected month in state
                  });
                  widget.onMonthSelected(_selectedMonth); // Notify parent of the selected month
                  Navigator.pop(context); // Close the modal
                },
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showMonthPicker(context), 
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text(
            'month > ', // The "month >" text
            style: TextStyle(
              fontSize: 16,
              color: Color.fromARGB(255, 16, 16, 16), // You can adjust the color based on your theme
            ),
          ),
          Text(
            _selectedMonth,
            style: const TextStyle(
              fontSize: 16,
              color: Color.fromARGB(255, 6, 6, 6),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
