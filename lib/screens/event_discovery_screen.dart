import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../controllers/event_discovery_controller.dart';
import '../models/event_model.dart';
import 'dashboard_screen.dart';
import 'event_detail_screen.dart';
import '../utils/app_screen_widgets.dart';

class ExpenseEntryScreenState extends State<ExpenseEntryScreen> {
  final ExpenseEntryController _controller = ExpenseEntryController();

  @override
  void initState() {
    super.initState();
    _initializeEvents();
  }

  Future<void> _initializeEvents() async {
    await _controller.getExpenses();
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _saveEvent() async {
    final bool saved = await _controller.saveExpense(context);
    if (saved && mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Expense> filteredEvents = _controller.getFilteredEvents();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Event Discovery',
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
          SingleChildScrollView(
            padding: const EdgeInsets.only(
                top: 16, left: 16.0, right: 16.0, bottom: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  'Browse upcoming campus events by interest track:',
                  style: GoogleFonts.rubik(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10.0),
                DropdownButtonFormField<String>(
                  value: _controller.selectedFilter,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _controller.selectedFilter = value ?? 'All Tracks';
                    });
                  },
                  items: _controller.filterOptions
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16.0),
                Container(
                  height: 250,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: filteredEvents.isEmpty
                      ? Center(
                          child: Text(
                            'No events available for this filter yet.',
                            style: GoogleFonts.rubik(fontSize: 16),
                          ),
                        )
                      : ListView.builder(
                          itemCount: filteredEvents.length,
                          itemBuilder: (context, index) {
                            final Expense event = filteredEvents[index];
                            return Card(
                              child: ListTile(
                                title: Text(
                                  event.notes.isEmpty
                                      ? 'Campus Event'
                                      : event.notes,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text(
                                  '${event.category} • ${DateFormat.yMMMd().format(event.date)}',
                                ),
                                trailing: const Icon(Icons.chevron_right),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ExpenseDetailScreen(
                                        expense: event,
                                        updateExpenses: _initializeEvents,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                ),
                const SizedBox(height: 24.0),
                Text(
                  'Create a Campus Event',
                  style: GoogleFonts.kalam(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Date: ${DateFormat.yMd().format(_controller.selectedDate)}',
                        style: GoogleFonts.lora(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      IconButton(
                        icon: const Icon(Icons.calendar_month),
                        onPressed: () async {
                          await _controller.selectDate(context);
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: _controller.amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Expected Participants',
                    labelStyle: GoogleFonts.rubik(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                  style: GoogleFonts.rubik(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 16.0),
                DropdownButtonFormField<String>(
                  value: _controller.selectedCategory,
                  hint: Text(
                    'Interest / Academic Track',
                    style: GoogleFonts.rubik(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _controller.selectedCategory = value.toString();
                    });
                  },
                  items: _controller.eventCategories
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: GoogleFonts.rubik(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: _controller.notesController,
                  decoration: InputDecoration(
                    labelText: 'Event Description',
                    labelStyle: GoogleFonts.rubik(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                  style: GoogleFonts.rubik(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo.shade100,
                    side: const BorderSide(color: Colors.black, width: 2.0),
                  ),
                  child: Text(
                    'Save Event',
                    style: GoogleFonts.ibmPlexSansArabic(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                  onPressed: _saveEvent,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
