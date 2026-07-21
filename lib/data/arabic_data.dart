class ArabicWord {
  final String arabic;
  final String transliteration;
  final String urdu;
  final String english;
  final String category;
  final String emoji;

  const ArabicWord({
    required this.arabic,
    required this.transliteration,
    required this.urdu,
    required this.english,
    required this.category,
    required this.emoji,
  });
}

class ArabicData {
  static const List<ArabicWord> words = [
    // Greetings
    ArabicWord(arabic: 'مَرْحَبًا', transliteration: 'Marhaban', urdu: 'ہیلو', english: 'Hello', category: 'Greetings', emoji: '👋'),
    ArabicWord(arabic: 'السَّلَامُ عَلَيْكُمْ', transliteration: 'Assalamu Alaikum', urdu: 'سلام', english: 'Peace be upon you', category: 'Greetings', emoji: '🤲'),
    ArabicWord(arabic: 'شُكْرًا', transliteration: 'Shukran', urdu: 'شکریہ', english: 'Thank you', category: 'Greetings', emoji: '🙏'),
    ArabicWord(arabic: 'مَعَ السَّلَامَة', transliteration: 'Ma\'a Salama', urdu: 'خدا حافظ', english: 'Goodbye', category: 'Greetings', emoji: '👋'),
    ArabicWord(arabic: 'نَعَمْ', transliteration: 'Na\'am', urdu: 'ہاں', english: 'Yes', category: 'Greetings', emoji: '✅'),
    ArabicWord(arabic: 'لَا', transliteration: 'La', urdu: 'نہیں', english: 'No', category: 'Greetings', emoji: '❌'),

    // Numbers
    ArabicWord(arabic: 'وَاحِد', transliteration: 'Wahid', urdu: 'ایک', english: 'One', category: 'Numbers', emoji: '1️⃣'),
    ArabicWord(arabic: 'اِثْنَان', transliteration: 'Ithnan', urdu: 'دو', english: 'Two', category: 'Numbers', emoji: '2️⃣'),
    ArabicWord(arabic: 'ثَلَاثَة', transliteration: 'Thalatha', urdu: 'تین', english: 'Three', category: 'Numbers', emoji: '3️⃣'),
    ArabicWord(arabic: 'أَرْبَعَة', transliteration: 'Arba\'a', urdu: 'چار', english: 'Four', category: 'Numbers', emoji: '4️⃣'),
    ArabicWord(arabic: 'خَمْسَة', transliteration: 'Khamsa', urdu: 'پانچ', english: 'Five', category: 'Numbers', emoji: '5️⃣'),

    // Colors
    ArabicWord(arabic: 'أَحْمَر', transliteration: 'Ahmar', urdu: 'سرخ', english: 'Red', category: 'Colors', emoji: '🔴'),
    ArabicWord(arabic: 'أَزْرَق', transliteration: 'Azraq', urdu: 'نیلا', english: 'Blue', category: 'Colors', emoji: '🔵'),
    ArabicWord(arabic: 'أَخْضَر', transliteration: 'Akhdar', urdu: 'سبز', english: 'Green', category: 'Colors', emoji: '🟢'),
    ArabicWord(arabic: 'أَصْفَر', transliteration: 'Asfar', urdu: 'پیلا', english: 'Yellow', category: 'Colors', emoji: '🟡'),

    // Family
    ArabicWord(arabic: 'أَب', transliteration: 'Ab', urdu: 'باپ', english: 'Father', category: 'Family', emoji: '👨'),
    ArabicWord(arabic: 'أُم', transliteration: 'Um', urdu: 'ماں', english: 'Mother', category: 'Family', emoji: '👩'),
    ArabicWord(arabic: 'أَخ', transliteration: 'Akh', urdu: 'بھائی', english: 'Brother', category: 'Family', emoji: '👦'),
    ArabicWord(arabic: 'أُخْت', transliteration: 'Ukht', urdu: 'بہن', english: 'Sister', category: 'Family', emoji: '👧'),

    // Food
    ArabicWord(arabic: 'مَاء', transliteration: 'Ma\'a', urdu: 'پانی', english: 'Water', category: 'Food', emoji: '💧'),
    ArabicWord(arabic: 'خُبْز', transliteration: 'Khubz', urdu: 'روٹی', english: 'Bread', category: 'Food', emoji: '🍞'),
    ArabicWord(arabic: 'تُفَّاح', transliteration: 'Tuffah', urdu: 'سیب', english: 'Apple', category: 'Food', emoji: '🍎'),
    ArabicWord(arabic: 'لَبَن', transliteration: 'Laban', urdu: 'دودھ', english: 'Milk', category: 'Food', emoji: '🥛'),
  ];

  static List<String> get categories =>
      words.map((w) => w.category).toSet().toList();

  static List<ArabicWord> getByCategory(String category) =>
      words.where((w) => w.category == category).toList();
}