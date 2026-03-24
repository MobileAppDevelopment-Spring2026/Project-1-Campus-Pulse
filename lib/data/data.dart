import '../models/event_model.dart';

class CampusEventSeedData {
  static const List<String> interestTracks = [
    'Arts & Culture',
    'STEM',
    'Career Growth',
    'Sports & Wellness',
    'Community Service',
  ];

  static List<Expense> getEvents() {
    return [
      // Arts & Culture (5)
      Expense(
        amount: 80,
        date: DateTime(2026, 4, 2),
        category: 'Arts & Culture',
        notes: 'Open Mic Night at Student Center',
      ),
      Expense(
        amount: 60,
        date: DateTime(2026, 4, 5),
        category: 'Arts & Culture',
        notes: 'Campus Film Club Screening & Discussion',
      ),
      Expense(
        amount: 45,
        date: DateTime(2026, 4, 8),
        category: 'Arts & Culture',
        notes: 'Pottery Workshop for Beginners',
      ),
      Expense(
        amount: 120,
        date: DateTime(2026, 4, 12),
        category: 'Arts & Culture',
        notes: 'Spring Cultural Showcase Festival',
      ),
      Expense(
        amount: 50,
        date: DateTime(2026, 4, 17),
        category: 'Arts & Culture',
        notes: 'Street Photography Walk',
      ),

      // STEM (5)
      Expense(
        amount: 100,
        date: DateTime(2026, 4, 3),
        category: 'STEM',
        notes: 'AI Hack Night: Build a Chatbot',
      ),
      Expense(
        amount: 70,
        date: DateTime(2026, 4, 7),
        category: 'STEM',
        notes: 'Women in Engineering Speaker Panel',
      ),
      Expense(
        amount: 40,
        date: DateTime(2026, 4, 10),
        category: 'STEM',
        notes: 'Robotics Lab Open House',
      ),
      Expense(
        amount: 90,
        date: DateTime(2026, 4, 15),
        category: 'STEM',
        notes: 'Data Science Career Sprint',
      ),
      Expense(
        amount: 65,
        date: DateTime(2026, 4, 19),
        category: 'STEM',
        notes: 'Cybersecurity Capture-the-Flag',
      ),

      // Career Growth (5)
      Expense(
        amount: 110,
        date: DateTime(2026, 4, 4),
        category: 'Career Growth',
        notes: 'Resume & LinkedIn Clinic',
      ),
      Expense(
        amount: 95,
        date: DateTime(2026, 4, 9),
        category: 'Career Growth',
        notes: 'Internship Networking Mixer',
      ),
      Expense(
        amount: 130,
        date: DateTime(2026, 4, 11),
        category: 'Career Growth',
        notes: 'Mock Interviews with Alumni',
      ),
      Expense(
        amount: 85,
        date: DateTime(2026, 4, 16),
        category: 'Career Growth',
        notes: 'Personal Branding Bootcamp',
      ),
      Expense(
        amount: 75,
        date: DateTime(2026, 4, 20),
        category: 'Career Growth',
        notes: 'Startup Founder AMA Session',
      ),

      // Sports & Wellness (5)
      Expense(
        amount: 140,
        date: DateTime(2026, 4, 1),
        category: 'Sports & Wellness',
        notes: 'Campus 5K Fun Run',
      ),
      Expense(
        amount: 55,
        date: DateTime(2026, 4, 6),
        category: 'Sports & Wellness',
        notes: 'Sunrise Yoga on the Lawn',
      ),
      Expense(
        amount: 90,
        date: DateTime(2026, 4, 13),
        category: 'Sports & Wellness',
        notes: 'Intramural Basketball Kickoff',
      ),
      Expense(
        amount: 65,
        date: DateTime(2026, 4, 18),
        category: 'Sports & Wellness',
        notes: 'Stress Relief Workshop',
      ),
      Expense(
        amount: 80,
        date: DateTime(2026, 4, 22),
        category: 'Sports & Wellness',
        notes: 'Campus Hiking Meetup',
      ),

      // Community Service (5)
      Expense(
        amount: 75,
        date: DateTime(2026, 4, 2),
        category: 'Community Service',
        notes: 'Neighborhood Clean-Up Drive',
      ),
      Expense(
        amount: 90,
        date: DateTime(2026, 4, 8),
        category: 'Community Service',
        notes: 'Food Pantry Volunteer Shift',
      ),
      Expense(
        amount: 50,
        date: DateTime(2026, 4, 14),
        category: 'Community Service',
        notes: 'Tutoring Day for Local Schools',
      ),
      Expense(
        amount: 70,
        date: DateTime(2026, 4, 21),
        category: 'Community Service',
        notes: 'Tree Planting Mission',
      ),
      Expense(
        amount: 85,
        date: DateTime(2026, 4, 25),
        category: 'Community Service',
        notes: 'Care Package Assembly Event',
      ),
    ];
  }
}
