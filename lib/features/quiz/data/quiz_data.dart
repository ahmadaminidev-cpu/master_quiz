import '../models/exam_question.dart';
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

  // ── Exam Mode ──────────────────────────────────────────────────────────────

  static const List<ExamQuestion> examQuestions = [
    ExamQuestion(
      question: 'What does the "S" in SOLID principles stand for?',
      options: ['Scalable', 'Single Responsibility', 'Structured', 'Stateless'],
      correctIndex: 1,
      explanation: 'Single Responsibility Principle (SRP) states that a class should have only one reason to change — meaning it should have only one job or responsibility.',
    ),
    ExamQuestion(
      question: 'Which data structure uses LIFO (Last In, First Out)?',
      options: ['Queue', 'Linked List', 'Stack', 'Tree'],
      correctIndex: 2,
      explanation: 'A Stack follows LIFO — the last element pushed is the first to be popped. Common uses include undo operations, call stacks, and expression parsing.',
    ),
    ExamQuestion(
      question: 'What is the time complexity of binary search?',
      options: ['O(n)', 'O(n²)', 'O(log n)', 'O(1)'],
      correctIndex: 2,
      explanation: 'Binary search halves the search space on each step, giving O(log n) time complexity. It requires the input array to be sorted.',
    ),
    ExamQuestion(
      question: 'In REST APIs, which HTTP method is idempotent but NOT safe?',
      options: ['GET', 'POST', 'PUT', 'DELETE'],
      correctIndex: 2,
      explanation: 'PUT is idempotent (calling it multiple times has the same effect) but not safe because it modifies server state. GET is both safe and idempotent. POST is neither.',
    ),
    ExamQuestion(
      question: 'What does "immutable" mean in programming?',
      options: ['Can be changed at runtime', 'Cannot be modified after creation', 'Stored in heap memory', 'Compiled at build time'],
      correctIndex: 1,
      explanation: 'An immutable object cannot be changed after it is created. Immutability helps prevent bugs, makes code easier to reason about, and is a core concept in functional programming.',
    ),
    ExamQuestion(
      question: 'Which SQL clause is used to filter groups after aggregation?',
      options: ['WHERE', 'FILTER', 'HAVING', 'GROUP BY'],
      correctIndex: 2,
      explanation: 'HAVING filters rows after GROUP BY aggregation. WHERE filters rows before aggregation. Example: SELECT dept, COUNT(*) FROM employees GROUP BY dept HAVING COUNT(*) > 5.',
    ),
    ExamQuestion(
      question: 'What is a "race condition" in concurrent programming?',
      options: ['A performance benchmark', 'Two threads competing for CPU time', 'A bug where output depends on unpredictable thread timing', 'A deadlock between two processes'],
      correctIndex: 2,
      explanation: 'A race condition occurs when two or more threads access shared data simultaneously and the result depends on the order of execution. It leads to unpredictable bugs that are hard to reproduce.',
    ),
    ExamQuestion(
      question: 'What does "dependency injection" primarily achieve?',
      options: ['Faster code execution', 'Loose coupling between components', 'Automatic memory management', 'Reduced bundle size'],
      correctIndex: 1,
      explanation: 'Dependency Injection (DI) decouples components by providing dependencies from outside rather than creating them internally. This makes code more testable, maintainable, and flexible.',
    ),
    ExamQuestion(
      question: 'Which Git command creates a new branch and switches to it?',
      options: ['git branch new-branch', 'git switch new-branch', 'git checkout -b new-branch', 'git create new-branch'],
      correctIndex: 2,
      explanation: '"git checkout -b <name>" creates a new branch and immediately switches to it. The modern equivalent is "git switch -c <name>". Both are widely used in professional workflows.',
    ),
    ExamQuestion(
      question: 'What is the purpose of an index in a database?',
      options: ['To encrypt data', 'To speed up data retrieval', 'To enforce foreign keys', 'To compress table storage'],
      correctIndex: 1,
      explanation: 'A database index is a data structure that improves the speed of data retrieval. It works like a book index — instead of scanning every row, the DB jumps directly to the relevant data.',
    ),
    ExamQuestion(
      question: 'In OOP, what is "polymorphism"?',
      options: ['Hiding internal implementation details', 'A class inheriting from multiple parents', 'The ability of different objects to respond to the same interface', 'Storing multiple data types in one variable'],
      correctIndex: 2,
      explanation: 'Polymorphism allows objects of different types to be treated through a common interface. For example, a "draw()" method can behave differently for Circle, Square, and Triangle objects.',
    ),
    ExamQuestion(
      question: 'What does "CI/CD" stand for?',
      options: ['Code Integration / Code Deployment', 'Continuous Integration / Continuous Delivery', 'Compiled Interface / Compiled Distribution', 'Central Index / Central Database'],
      correctIndex: 1,
      explanation: 'CI/CD stands for Continuous Integration and Continuous Delivery (or Deployment). CI automates building and testing code on every commit. CD automates releasing that code to production.',
    ),
  ];

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

  // ── Power Up ───────────────────────────────────────────────────────────────

  static const List<QuizQuestion> powerUpQuestions = [
    QuizQuestion(question: 'What is the rarest blood type?', options: ['A+', 'O-', 'AB-', 'B-'], correctIndex: 2),
    QuizQuestion(question: 'Which element has the highest melting point?', options: ['Iron', 'Tungsten', 'Platinum', 'Carbon'], correctIndex: 1),
    QuizQuestion(question: 'How many moons does Mars have?', options: ['0', '1', '2', '3'], correctIndex: 2),
    QuizQuestion(question: 'What is the only mammal capable of true flight?', options: ['Flying squirrel', 'Sugar glider', 'Bat', 'Colugo'], correctIndex: 2),
    QuizQuestion(question: 'In what year was the Eiffel Tower built?', options: ['1885', '1887', '1889', '1892'], correctIndex: 2),
    QuizQuestion(question: 'What is the most spoken language in Africa?', options: ['Swahili', 'Arabic', 'Hausa', 'Amharic'], correctIndex: 1),
    QuizQuestion(question: 'Which organ produces insulin?', options: ['Liver', 'Kidney', 'Pancreas', 'Spleen'], correctIndex: 2),
    QuizQuestion(question: 'What is the speed of sound in air (approx)?', options: ['243 m/s', '343 m/s', '443 m/s', '543 m/s'], correctIndex: 1),
    QuizQuestion(question: 'Which country has the most UNESCO World Heritage Sites?', options: ['China', 'France', 'Italy', 'Spain'], correctIndex: 2),
    QuizQuestion(question: 'What is the chemical formula for table salt?', options: ['KCl', 'NaCl', 'MgCl2', 'CaCl2'], correctIndex: 1),
    QuizQuestion(question: 'How many teeth does an adult human have?', options: ['28', '30', '32', '34'], correctIndex: 2),
    QuizQuestion(question: 'Which planet rotates on its side?', options: ['Neptune', 'Saturn', 'Uranus', 'Jupiter'], correctIndex: 2),
  ];

  // ── Time Attack ────────────────────────────────────────────────────────────

  static const List<QuizQuestion> timeAttackQuestions = [
    // General
    QuizQuestion(question: 'What is the capital of Australia?', options: ['Sydney', 'Melbourne', 'Canberra', 'Brisbane'], correctIndex: 2),
    QuizQuestion(question: 'How many sides does a triangle have?', options: ['2', '3', '4', '5'], correctIndex: 1),
    QuizQuestion(question: 'What is 12 × 12?', options: ['124', '134', '144', '154'], correctIndex: 2),
    QuizQuestion(question: 'Which gas do plants absorb from the air?', options: ['Oxygen', 'Nitrogen', 'Carbon Dioxide', 'Hydrogen'], correctIndex: 2),
    QuizQuestion(question: 'What is the longest river in the world?', options: ['Amazon', 'Nile', 'Yangtze', 'Mississippi'], correctIndex: 1),
    QuizQuestion(question: 'How many colors are in a rainbow?', options: ['5', '6', '7', '8'], correctIndex: 2),
    QuizQuestion(question: 'What is the smallest country in the world?', options: ['Monaco', 'San Marino', 'Vatican City', 'Liechtenstein'], correctIndex: 2),
    QuizQuestion(question: 'Which metal is liquid at room temperature?', options: ['Lead', 'Mercury', 'Tin', 'Zinc'], correctIndex: 1),
    // Science
    QuizQuestion(question: 'What is the atomic number of carbon?', options: ['4', '6', '8', '12'], correctIndex: 1),
    QuizQuestion(question: 'What planet is known as the Blue Planet?', options: ['Neptune', 'Uranus', 'Earth', 'Saturn'], correctIndex: 2),
    QuizQuestion(question: 'How many chambers does the human heart have?', options: ['2', '3', '4', '5'], correctIndex: 2),
    QuizQuestion(question: 'What is the chemical symbol for gold?', options: ['Go', 'Gd', 'Au', 'Ag'], correctIndex: 2),
    QuizQuestion(question: 'What force keeps planets in orbit?', options: ['Magnetism', 'Gravity', 'Friction', 'Tension'], correctIndex: 1),
    QuizQuestion(question: 'What is the most abundant gas in Earth\'s atmosphere?', options: ['Oxygen', 'Carbon Dioxide', 'Argon', 'Nitrogen'], correctIndex: 3),
    QuizQuestion(question: 'How many bones are in the human spine?', options: ['24', '26', '33', '36'], correctIndex: 2),
    QuizQuestion(question: 'What is the unit of electrical resistance?', options: ['Volt', 'Ampere', 'Ohm', 'Watt'], correctIndex: 2),
    // History & Geography
    QuizQuestion(question: 'In which year did the Berlin Wall fall?', options: ['1987', '1988', '1989', '1990'], correctIndex: 2),
    QuizQuestion(question: 'Which country has the most natural lakes?', options: ['Russia', 'USA', 'Canada', 'Brazil'], correctIndex: 2),
    QuizQuestion(question: 'Who was the first US President?', options: ['John Adams', 'Thomas Jefferson', 'George Washington', 'Benjamin Franklin'], correctIndex: 2),
    QuizQuestion(question: 'What is the capital of Brazil?', options: ['São Paulo', 'Rio de Janeiro', 'Salvador', 'Brasília'], correctIndex: 3),
    QuizQuestion(question: 'Which ancient wonder was in Alexandria?', options: ['Colossus', 'Lighthouse', 'Hanging Gardens', 'Mausoleum'], correctIndex: 1),
    QuizQuestion(question: 'What is the largest desert in the world?', options: ['Sahara', 'Arabian', 'Gobi', 'Antarctic'], correctIndex: 3),
    // Math & Logic
    QuizQuestion(question: 'What is the square root of 256?', options: ['14', '15', '16', '17'], correctIndex: 2),
    QuizQuestion(question: 'How many degrees in a right angle?', options: ['45', '60', '90', '180'], correctIndex: 2),
    QuizQuestion(question: 'What is 15% of 200?', options: ['20', '25', '30', '35'], correctIndex: 2),
    QuizQuestion(question: 'What comes next: 2, 4, 8, 16, __?', options: ['24', '28', '32', '36'], correctIndex: 2),
    // Pop Culture & Sports
    QuizQuestion(question: 'How many players are on a basketball team on court?', options: ['4', '5', '6', '7'], correctIndex: 1),
    QuizQuestion(question: 'In which sport is a "birdie" a term used?', options: ['Tennis', 'Golf', 'Cricket', 'Baseball'], correctIndex: 1),
    QuizQuestion(question: 'How many Olympic rings are there?', options: ['4', '5', '6', '7'], correctIndex: 1),
    QuizQuestion(question: 'Which country won the first FIFA World Cup?', options: ['Brazil', 'Italy', 'Uruguay', 'Argentina'], correctIndex: 2),
    // Language & Literature
    QuizQuestion(question: 'How many letters are in the word "RHYTHM"?', options: ['5', '6', '7', '8'], correctIndex: 1),
    QuizQuestion(question: 'Who wrote "Romeo and Juliet"?', options: ['Charles Dickens', 'William Shakespeare', 'Jane Austen', 'Mark Twain'], correctIndex: 1),
    QuizQuestion(question: 'What is a synonym for "happy"?', options: ['Sad', 'Angry', 'Joyful', 'Tired'], correctIndex: 2),
    QuizQuestion(question: 'How many vowels are in the English alphabet?', options: ['4', '5', '6', '7'], correctIndex: 1),
    // Technology
    QuizQuestion(question: 'What does "CPU" stand for?', options: ['Central Processing Unit', 'Computer Power Unit', 'Core Processing Utility', 'Central Program Unit'], correctIndex: 0),
    QuizQuestion(question: 'Which company created the iPhone?', options: ['Samsung', 'Google', 'Apple', 'Microsoft'], correctIndex: 2),
    QuizQuestion(question: 'What does "HTML" stand for?', options: ['Hyper Text Markup Language', 'High Tech Modern Language', 'Hyper Transfer Markup Logic', 'Home Tool Markup Language'], correctIndex: 0),
    QuizQuestion(question: 'How many bits are in a byte?', options: ['4', '6', '8', '16'], correctIndex: 2),
    QuizQuestion(question: 'What year was the World Wide Web invented?', options: ['1985', '1989', '1991', '1995'], correctIndex: 1),
    QuizQuestion(question: 'Which programming language is known as the "language of the web"?', options: ['Python', 'Java', 'JavaScript', 'C++'], correctIndex: 2),
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
