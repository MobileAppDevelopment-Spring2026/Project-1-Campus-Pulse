import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/event_model.dart';
import '../controllers/event_detail_controller.dart';
import 'dashboard_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class ExpenseDetailScreen extends StatefulWidget {
  final Expense expense;
  final VoidCallback updateExpenses;
  final bool canRemoveEvent;

  const ExpenseDetailScreen(
      {super.key,
      required this.expense,
      required this.updateExpenses,
      this.canRemoveEvent = true});

  @override
  State<ExpenseDetailScreen> createState() => _ExpenseDetailScreenState();
}

class _ExpenseDetailScreenState extends State<ExpenseDetailScreen> {
  late final ExpenseDetailController _controller;
  late bool _isReserved;
  late bool _isSocialMission;

  @override
  void initState() {
    super.initState();
    _controller = ExpenseDetailController(
      expense: widget.expense,
      updateExpenses: widget.updateExpenses,
    );
    _isReserved = widget.expense.isReserved;
    _isSocialMission = _controller.isSocialMission;
  }

  Future<void> _toggleReservation() async {
    final bool updated = _isReserved
        ? await _controller.unreserveExpense(context)
        : await _controller.reserveExpense(context);

    if (updated && mounted) {
      setState(() {
        _isReserved = !_isReserved;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Event Details & RSVP',
          style: GoogleFonts.kalam(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.indigo.shade400,
        actions: [
          IconButton(
            icon: const Icon(Icons.home_outlined, color: Colors.white),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Dashboard()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30),
                Center(
                  child: Text(
                    'Track: ${widget.expense.category}',
                    style: GoogleFonts.archivo(
                      color: Colors.black,
                      fontSize: 34,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 25),
                Text(
                  'Expected Participants: ${widget.expense.amount.toStringAsFixed(0)}',
                  style: GoogleFonts.notoSans(
                    color: Colors.black,
                    fontSize: 23,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  'Date: ${DateFormat.yMd().format(widget.expense.date)}',
                  style: GoogleFonts.rubik(
                    color: Colors.black,
                    fontSize: 23,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  'Description: ${widget.expense.notes}',
                  style: GoogleFonts.rubik(
                    color: Colors.black,
                    fontSize: 23,
                  ),
                ),
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isReserved
                              ? Colors.green.shade300
                              : Colors.lightBlue.shade100,
                          side: const BorderSide(
                            color: Colors.black,
                            width: 2.0,
                          ),
                        ),
                        child: Text(
                          _isSocialMission
                              ? (_isReserved
                                  ? 'Completed (Tap to Undo)'
                                  : 'Mark as Completed')
                              : (_isReserved ? 'Unreserve' : 'RSVP Now'),
                          style: GoogleFonts.ibmPlexSansArabic(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                        onPressed: _toggleReservation,
                      ),
                    ),
                    if (widget.canRemoveEvent) ...[
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pinkAccent.shade100,
                            side: const BorderSide(
                              color: Colors.black,
                              width: 2.0,
                            ),
                          ),
                          child: Text(
                            'Remove Event',
                            style: GoogleFonts.ibmPlexSansArabic(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                          onPressed: () {
                            _controller.deleteExpense(context);
                          },
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
