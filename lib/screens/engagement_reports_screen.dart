import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/engagement_reports_controller.dart';
import 'dashboard_screen.dart';
import '../utils/app_screen_widgets.dart';

class ReportsAndChartsScreenState extends State<ReportsAndChartsScreen> {
  final ReportsAndChartsController _controller = ReportsAndChartsController();

  void _showBadgeInfoDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.indigo.shade50,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Colors.black, width: 1.2),
          ),
          title: Text(
            'How Streak & Badges Work',
            style: GoogleFonts.kalam(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 26,
            ),
          ),
          content: Text(
            'Streak and badges are calculated from reserved events only.\n\n'
            'Streak Rules:\n'
            '- A streak is consecutive days with at least 1 reserved event.\n'
            '- Multiple reserved events on the same day count as 1 day.\n'
            '- The app shows your highest (maximum) streak across all time.\n\n'
            'Badge Rules:\n'
            '- You earn 1 badge for every 3 reserved events.\n'
            '- You earn +1 bonus badge when your streak is 3 days or more.\n\n',
            style: GoogleFonts.rubik(
              color: Colors.black,
              fontSize: 16,
              height: 1.35,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Got it',
                style: GoogleFonts.rubik(
                  color: Colors.indigo.shade700,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _controller.getExpenses();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Engagement Reports',
          style: GoogleFonts.kalam(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.indigo.shade400,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            tooltip: 'How badges work',
            onPressed: _showBadgeInfoDialog,
          ),
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
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          _controller.expenseList.isEmpty
              ? _controller.buildEmptyState()
              : _controller.buildCharts(context, _updateExpenses),
        ],
      ),
    );
  }

  void _updateExpenses() async {
    await _controller.getExpenses();
    setState(() {});
  }
}
