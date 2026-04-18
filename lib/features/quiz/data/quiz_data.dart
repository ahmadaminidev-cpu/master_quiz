import '../models/quiz_question.dart';

class QuizData {
  // ── Daily Challenge ────────────────────────────────────────────────────────

  static const int dailyQuestionCount = 3;

  static const List<List<QuizQuestion>> _dailyPool = [
    [
      QuizQuestion(question: 'What is the largest planet in our solar system?', options: ['Saturn', 'Neptune', 'Jupiter', 'Uranus'], correctIndex: 2),
      QuizQuestion(question: 'Which country invented the game of chess?', options: ['China', 'India', 'Persia', 'Greece'], correctIndex: 1),
      QuizQuestion(question: 'How many sides does a hexagon have?', options: ['5', '6', '7', '8'], correctIndex: 1),
    ],
    [
      QuizQuestion(question: 'What is the capital city of Japan?', options: ['Osaka', 'Kyoto', 'Hiroshima', 'Tokyo'], correctIndex: 3),
      QuizQuestion(question: 'Which element has the chemical symbol "O"?', options: ['Gold', 'Osmium', 'Oxygen', 'Oganesson'], correctIndex: 2),
      QuizQuestion(question: 'Who painted the Mona Lisa?', options: ['Michelangelo', 'Raphael', 'Leonardo da Vinci', 'Donatello'], correctIndex: 2),
    ],
    [
      QuizQuestion(question: 'What is the fastest land animal?', options: ['Lion', 'Cheetah', 'Leopard', 'Greyhound'], correctIndex: 1),
      QuizQuestion(question: 'In which year did World War II end?', options: ['1943', '1944', '1945', '1946'], correctIndex: 2),
      QuizQuestion(question: 'How many continents are there on Earth?', options: ['5', '6', '7', '8'], correctIndex: 2),
    ],
    [
      QuizQuestion(question: 'What is the hardest natural substance on Earth?', options: ['Gold', 'Iron', 'Diamond', 'Quartz'], correctIndex: 2),
      QuizQuestion(question: 'Which ocean is the largest?', options: ['Atlantic', 'Indian', 'Arctic', 'Pacific'], correctIndex: 3),
      QuizQuestion(question: 'How many strings does a violin have?', options: ['3', '4', '5', '6'], correctIndex: 1),
    ],
    [
      QuizQuestion(question: 'What language has the most native speakers worldwide?', options: ['English', 'Spanish', 'Mandarin Chinese', 'Hindi'], correctIndex: 2),
      QuizQuestion(question: 'Which planet is closest to the Sun?', options: ['Venus', 'Earth', 'Mercury', 'Mars'], correctIndex: 2),
      QuizQuestion(question: 'What is the square root of 144?', options: ['10', '11', '12', '13'], correctIndex: 2),
    ],
  ];

  static List<QuizQuestion> get dailyQuestions {
    final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays;
    return _dailyPool[dayOfYear % _dailyPool.length];
  }

  // ── Fast Mode ──────────────────────────────────────────────────────────────

  static const List<QuizQuestion> fastModeQuestions = [
    QuizQuestion(question: 'What is the capital of France?', options: ['London', 'Berlin', 'Paris', 'Rome'], correctIndex: 2),
    QuizQuestion(question: 'How many days are in a leap year?', options: ['364', '365', '366', '367'], correctIndex: 2),
    QuizQuestion(question: 'What color do you get mixing red and blue?', options: ['Green', 'Purple', 'Orange', 'Brown'], correctIndex: 1),
    QuizQuestion(question: 'Which animal is the tallest in the world?', options: ['Elephant', 'Giraffe', 'Camel', 'Horse'], correctIndex: 1),
    QuizQuestion(question: 'How many minutes are in an hour?', options: ['30', '45', '60', '90'], correctIndex: 2),
    QuizQuestion(question: 'What is 7 × 8?', options: ['54', '56', '58', '64'], correctIndex: 1),
    QuizQuestion(question: 'Which planet has rings around it?', options: ['Mars', 'Venus', 'Saturn', 'Mercury'], correctIndex: 2),
    QuizQuestion(question: 'What is the boiling point of water in Celsius?', options: ['90°C', '95°C', '100°C', '110°C'], correctIndex: 2),
    QuizQuestion(question: 'How many letters are in the English alphabet?', options: ['24', '25', '26', '27'], correctIndex: 2),
    QuizQuestion(question: 'Which continent is the largest by area?', options: ['Africa', 'Asia', 'Europe', 'Americas'], correctIndex: 1),
  ];

  // ── Category Questions ─────────────────────────────────────────────────────

  static const Map<String, List<QuizQuestion>> questionsByCategory = {
    'Football': [
      QuizQuestion(question: 'Which soccer team won the FIFA World Cup for the first time?', options: ['Uruguay', 'Brazil', 'Italy', 'Germany'], correctIndex: 0),
      QuizQuestion(question: 'How many players are on a standard football team on the field?', options: ['9', '10', '11', '12'], correctIndex: 2),
      QuizQuestion(question: 'Which country has won the most FIFA World Cup titles?', options: ['Germany', 'Argentina', 'Brazil', 'France'], correctIndex: 2),
      QuizQuestion(question: 'What is the maximum duration of a standard football match?', options: ['80 minutes', '90 minutes', '100 minutes', '120 minutes'], correctIndex: 1),
      QuizQuestion(question: "Which player has won the most Ballon d'Or awards?", options: ['Cristiano Ronaldo', 'Lionel Messi', 'Ronaldinho', 'Zinedine Zidane'], correctIndex: 1),
    ],
    'Science': [
      QuizQuestion(question: 'What is the chemical symbol for water?', options: ['WA', 'H2O', 'HO2', 'OHH'], correctIndex: 1),
      QuizQuestion(question: 'How many bones are in the adult human body?', options: ['196', '206', '216', '226'], correctIndex: 1),
      QuizQuestion(question: 'What planet is known as the Red Planet?', options: ['Venus', 'Jupiter', 'Mars', 'Saturn'], correctIndex: 2),
      QuizQuestion(question: 'What is the speed of light in a vacuum?', options: ['299,792 km/s', '199,792 km/s', '399,792 km/s', '499,792 km/s'], correctIndex: 0),
      QuizQuestion(question: 'What is the powerhouse of the cell?', options: ['Nucleus', 'Ribosome', 'Mitochondria', 'Golgi apparatus'], correctIndex: 2),
    ],
    'Fashion': [
      QuizQuestion(question: 'Which fashion house created the iconic "little black dress"?', options: ['Dior', 'Chanel', 'Versace', 'Gucci'], correctIndex: 1),
      QuizQuestion(question: 'What city is considered the fashion capital of the world?', options: ['New York', 'London', 'Milan', 'Paris'], correctIndex: 3),
      QuizQuestion(question: 'Which material is known as the "fabric of our lives"?', options: ['Silk', 'Wool', 'Cotton', 'Polyester'], correctIndex: 2),
      QuizQuestion(question: 'What does "haute couture" literally mean?', options: ['High fashion', 'Fine sewing', 'Luxury wear', 'Custom design'], correctIndex: 1),
      QuizQuestion(question: 'Which brand is famous for its red-soled shoes?', options: ['Jimmy Choo', 'Manolo Blahnik', 'Christian Louboutin', 'Valentino'], correctIndex: 2),
    ],
    'Movie': [
      QuizQuestion(question: 'Which film won the first Academy Award for Best Picture?', options: ['Wings', 'Sunrise', 'The Jazz Singer', 'Chang'], correctIndex: 0),
      QuizQuestion(question: 'Who directed the movie "Inception"?', options: ['Steven Spielberg', 'James Cameron', 'Christopher Nolan', 'Ridley Scott'], correctIndex: 2),
      QuizQuestion(question: 'What is the highest-grossing film of all time?', options: ['Titanic', 'Avengers: Endgame', 'Avatar', 'Star Wars'], correctIndex: 2),
      QuizQuestion(question: 'In which year was the first Star Wars film released?', options: ['1975', '1977', '1979', '1981'], correctIndex: 1),
      QuizQuestion(question: 'Which actor played Iron Man in the Marvel Cinematic Universe?', options: ['Chris Evans', 'Chris Hemsworth', 'Robert Downey Jr.', 'Mark Ruffalo'], correctIndex: 2),
    ],
    'Music': [
      QuizQuestion(question: 'How many strings does a standard guitar have?', options: ['4', '5', '6', '7'], correctIndex: 2),
      QuizQuestion(question: 'Which band is known as the "Fab Four"?', options: ['The Rolling Stones', 'The Beatles', 'Led Zeppelin', 'Pink Floyd'], correctIndex: 1),
      QuizQuestion(question: 'What is the best-selling album of all time?', options: ['Thriller', 'Back in Black', 'The Dark Side of the Moon', 'Hotel California'], correctIndex: 0),
      QuizQuestion(question: 'Which instrument has 88 keys?', options: ['Organ', 'Harpsichord', 'Piano', 'Synthesizer'], correctIndex: 2),
      QuizQuestion(question: 'Who is known as the "Queen of Pop"?', options: ['Beyoncé', 'Madonna', 'Lady Gaga', 'Rihanna'], correctIndex: 1),
    ],
  };
}
