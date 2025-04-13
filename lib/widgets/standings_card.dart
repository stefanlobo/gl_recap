import 'package:flutter/material.dart';

class StandingsCard extends StatelessWidget {
  final List<DataColumn> columns;
  final List<DataRow> rows;
  final String title;

  const StandingsCard({
    Key? key,
    required this.columns,
    required this.rows,
    this.title = "League Standings",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            DataTable(
              columns: columns,
              rows: rows,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              columnSpacing: 24,
              horizontalMargin: 16,
            ),
          ],
        ),
      ),
    );
  }
}
