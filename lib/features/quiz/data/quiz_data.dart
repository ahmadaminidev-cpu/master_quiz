import 'dart:math';
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

  // ── Game Mode Questions (200 Pool) ──────────────────────────────────────────

  static const List<QuizQuestion> gameModeQuestionsPool = [
    // --- General Knowledge (20) ---
    QuizQuestion(question: 'What is the largest ocean on Earth?', options: ['Atlantic', 'Indian', 'Arctic', 'Pacific'], correctIndex: 3),
    QuizQuestion(question: 'Which country is known as the Land of the Rising Sun?', options: ['China', 'Japan', 'South Korea', 'Thailand'], correctIndex: 1),
    QuizQuestion(question: 'How many continents are there?', options: ['5', '6', '7', '8'], correctIndex: 2),
    QuizQuestion(question: 'Which is the smallest country in the world?', options: ['Monaco', 'Vatican City', 'San Marino', 'Liechtenstein'], correctIndex: 1),
    QuizQuestion(question: 'What is the capital of Italy?', options: ['Venice', 'Milan', 'Naples', 'Rome'], correctIndex: 3),
    QuizQuestion(question: 'Which language is the most spoken worldwide?', options: ['English', 'Spanish', 'Mandarin', 'Hindi'], correctIndex: 2),
    QuizQuestion(question: 'What is the currency of Japan?', options: ['Yuan', 'Won', 'Yen', 'Ringgit'], correctIndex: 2),
    QuizQuestion(question: 'In which year did the Titanic sink?', options: ['1910', '1912', '1914', '1916'], correctIndex: 1),
    QuizQuestion(question: 'What is the largest desert in the world?', options: ['Sahara', 'Gobi', 'Kalahari', 'Antarctic'], correctIndex: 3),
    QuizQuestion(question: 'Which is the longest river in the world?', options: ['Amazon', 'Nile', 'Yangtze', 'Mississippi'], correctIndex: 1),
    QuizQuestion(question: 'What is the capital of Canada?', options: ['Toronto', 'Montreal', 'Vancouver', 'Ottawa'], correctIndex: 3),
    QuizQuestion(question: 'Who wrote "Romeo and Juliet"?', options: ['Charles Dickens', 'William Shakespeare', 'Mark Twain', 'Jane Austen'], correctIndex: 1),
    QuizQuestion(question: 'Which planet is known as the Red Planet?', options: ['Venus', 'Mars', 'Jupiter', 'Saturn'], correctIndex: 1),
    QuizQuestion(question: 'What is the hardest natural substance on Earth?', options: ['Gold', 'Iron', 'Diamond', 'Quartz'], correctIndex: 2),
    QuizQuestion(question: 'Which is the tallest mountain in the world?', options: ['K2', 'Mount Everest', 'Kangchenjunga', 'Lhotse'], correctIndex: 1),
    QuizQuestion(question: 'What is the main ingredient in hummus?', options: ['Lentils', 'Chickpeas', 'Broad beans', 'Peas'], correctIndex: 1),
    QuizQuestion(question: 'How many players are there in a soccer team?', options: ['9', '10', '11', '12'], correctIndex: 2),
    QuizQuestion(question: 'What is the largest mammal in the world?', options: ['Elephant', 'Blue Whale', 'Giraffe', 'Great White Shark'], correctIndex: 1),
    QuizQuestion(question: 'Which gas do humans need to breathe to survive?', options: ['Nitrogen', 'Oxygen', 'Carbon Dioxide', 'Hydrogen'], correctIndex: 1),
    QuizQuestion(question: 'What is the capital of Australia?', options: ['Sydney', 'Melbourne', 'Canberra', 'Perth'], correctIndex: 2),

    // --- Science & Nature (20) ---
    QuizQuestion(question: 'What is the chemical symbol for water?', options: ['H2O', 'O2', 'CO2', 'NaCl'], correctIndex: 0),
    QuizQuestion(question: 'How many planets are in our solar system?', options: ['7', '8', '9', '10'], correctIndex: 1),
    QuizQuestion(question: 'What part of the plant conducts photosynthesis?', options: ['Root', 'Stem', 'Flower', 'Leaf'], correctIndex: 3),
    QuizQuestion(question: 'What is the center of an atom called?', options: ['Electron', 'Proton', 'Nucleus', 'Neutron'], correctIndex: 2),
    QuizQuestion(question: 'Which planet is closest to the Sun?', options: ['Venus', 'Mercury', 'Earth', 'Mars'], correctIndex: 1),
    QuizQuestion(question: 'What is the study of stars and planets called?', options: ['Biology', 'Geology', 'Astronomy', 'Chemistry'], correctIndex: 2),
    QuizQuestion(question: 'How many legs does a spider have?', options: ['6', '8', '10', '12'], correctIndex: 1),
    QuizQuestion(question: 'What is the boiling point of water?', options: ['50°C', '80°C', '100°C', '120°C'], correctIndex: 2),
    QuizQuestion(question: 'Which force pulls objects toward the Earth?', options: ['Magnetism', 'Friction', 'Gravity', 'Tension'], correctIndex: 2),
    QuizQuestion(question: 'What is the largest organ of the human body?', options: ['Heart', 'Lungs', 'Liver', 'Skin'], correctIndex: 3),
    QuizQuestion(question: 'What do bees collect from flowers?', options: ['Honey', 'Nectar', 'Wax', 'Water'], correctIndex: 1),
    QuizQuestion(question: 'Which metal is liquid at room temperature?', options: ['Silver', 'Mercury', 'Iron', 'Copper'], correctIndex: 1),
    QuizQuestion(question: 'How many teeth does an adult human typically have?', options: ['28', '30', '32', '34'], correctIndex: 2),
    QuizQuestion(question: 'What gas do plants absorb from the atmosphere?', options: ['Oxygen', 'Nitrogen', 'Carbon Dioxide', 'Argon'], correctIndex: 2),
    QuizQuestion(question: 'What is the closest star to Earth?', options: ['Proxima Centauri', 'Sirius', 'The Sun', 'Betelgeuse'], correctIndex: 2),
    QuizQuestion(question: 'Which animal is known as the King of the Jungle?', options: ['Tiger', 'Elephant', 'Lion', 'Gorilla'], correctIndex: 2),
    QuizQuestion(question: 'What is the chemical symbol for Gold?', options: ['Go', 'Au', 'Ag', 'Fe'], correctIndex: 1),
    QuizQuestion(question: 'How many colors are there in a rainbow?', options: ['5', '6', '7', '8'], correctIndex: 2),
    QuizQuestion(question: 'What is the freezing point of water?', options: ['0°C', '-10°C', '32°C', '100°C'], correctIndex: 0),
    QuizQuestion(question: 'Which organ pumps blood throughout the body?', options: ['Brain', 'Lungs', 'Heart', 'Stomach'], correctIndex: 2),

    // --- History (20) ---
    QuizQuestion(question: 'Who was the first President of the United States?', options: ['Abraham Lincoln', 'George Washington', 'Thomas Jefferson', 'John Adams'], correctIndex: 1),
    QuizQuestion(question: 'Which ancient civilization built the pyramids?', options: ['Romans', 'Greeks', 'Egyptians', 'Mayans'], correctIndex: 2),
    QuizQuestion(question: 'Who discovered America in 1492?', options: ['Marco Polo', 'Vasco da Gama', 'Christopher Columbus', 'Ferdinand Magellan'], correctIndex: 2),
    QuizQuestion(question: 'In which year did World War II end?', options: ['1943', '1944', '1945', '1946'], correctIndex: 2),
    QuizQuestion(question: 'Who was known as the Maid of Orleans?', options: ['Marie Antoinette', 'Joan of Arc', 'Queen Elizabeth I', 'Catherine the Great'], correctIndex: 1),
    QuizQuestion(question: 'Which wall divided East and West Berlin?', options: ['Great Wall', 'Berlin Wall', 'Western Wall', 'Hadrian\'s Wall'], correctIndex: 1),
    QuizQuestion(question: 'Who was the famous leader of the Mongol Empire?', options: ['Kublai Khan', 'Genghis Khan', 'Attila the Hun', 'Tamerlane'], correctIndex: 1),
    QuizQuestion(question: 'The Renaissance began in which country?', options: ['France', 'Spain', 'Germany', 'Italy'], correctIndex: 3),
    QuizQuestion(question: 'Which ship brought the Pilgrims to America?', options: ['Santa Maria', 'Mayflower', 'Endeavour', 'Beagle'], correctIndex: 1),
    QuizQuestion(question: 'Who was the primary author of the Declaration of Independence?', options: ['Benjamin Franklin', 'Thomas Jefferson', 'Alexander Hamilton', 'James Madison'], correctIndex: 1),
    QuizQuestion(question: 'Which empire was ruled by Julius Caesar?', options: ['Greek Empire', 'Persian Empire', 'Roman Empire', 'Ottoman Empire'], correctIndex: 2),
    QuizQuestion(question: 'What was the first man-made satellite to orbit Earth?', options: ['Apollo 11', 'Sputnik 1', 'Explorer 1', 'Vanguard 1'], correctIndex: 1),
    QuizQuestion(question: 'Who was the Queen of Ancient Egypt?', options: ['Nefertiti', 'Cleopatra', 'Hatshepsut', 'Isis'], correctIndex: 1),
    QuizQuestion(question: 'Which war was fought between the North and South in the US?', options: ['Revolutionary War', 'War of 1812', 'Civil War', 'Vietnam War'], correctIndex: 2),
    QuizQuestion(question: 'Who invented the light bulb?', options: ['Nikola Tesla', 'Thomas Edison', 'Alexander Graham Bell', 'Isaac Newton'], correctIndex: 1),
    QuizQuestion(question: 'The Magna Carta was signed in which country?', options: ['France', 'Italy', 'England', 'Germany'], correctIndex: 2),
    QuizQuestion(question: 'Who was the leader of the Civil Rights Movement in the US?', options: ['Malcolm X', 'Martin Luther King Jr.', 'Rosa Parks', 'John Lewis'], correctIndex: 1),
    QuizQuestion(question: 'Which city was the capital of the Byzantine Empire?', options: ['Rome', 'Athens', 'Constantinople', 'Alexandria'], correctIndex: 2),
    QuizQuestion(question: 'Who was the first woman to win a Nobel Prize?', options: ['Marie Curie', 'Mother Teresa', 'Indira Gandhi', 'Florence Nightingale'], correctIndex: 0),
    QuizQuestion(question: 'What was the ancient trade route connecting East and West?', options: ['Spice Road', 'Amber Road', 'Silk Road', 'Incense Road'], correctIndex: 2),

    // --- Geography (20) ---
    QuizQuestion(question: 'What is the capital of France?', options: ['Berlin', 'Madrid', 'Paris', 'Rome'], correctIndex: 2),
    QuizQuestion(question: 'Which continent is the Sahara Desert located on?', options: ['Asia', 'Africa', 'South America', 'Australia'], correctIndex: 1),
    QuizQuestion(question: 'What is the capital of the United Kingdom?', options: ['Dublin', 'Edinburgh', 'London', 'Cardiff'], correctIndex: 2),
    QuizQuestion(question: 'Which country has the largest population?', options: ['India', 'China', 'USA', 'Indonesia'], correctIndex: 1),
    QuizQuestion(question: 'Which river flows through Egypt?', options: ['Amazon', 'Ganges', 'Nile', 'Danube'], correctIndex: 2),
    QuizQuestion(question: 'What is the capital of Spain?', options: ['Barcelona', 'Seville', 'Madrid', 'Valencia'], correctIndex: 2),
    QuizQuestion(question: 'Which ocean is between the US and Europe?', options: ['Pacific', 'Indian', 'Atlantic', 'Arctic'], correctIndex: 2),
    QuizQuestion(question: 'What is the smallest continent?', options: ['Europe', 'Antarctica', 'Australia', 'South America'], correctIndex: 2),
    QuizQuestion(question: 'Which country is shaped like a boot?', options: ['Greece', 'Italy', 'Spain', 'Portugal'], correctIndex: 1),
    QuizQuestion(question: 'What is the capital of Russia?', options: ['Saint Petersburg', 'Moscow', 'Kiev', 'Minsk'], correctIndex: 1),
    QuizQuestion(question: 'Which is the largest country by land area?', options: ['Canada', 'China', 'USA', 'Russia'], correctIndex: 3),
    QuizQuestion(question: 'What is the capital of Germany?', options: ['Munich', 'Hamburg', 'Berlin', 'Frankfurt'], correctIndex: 2),
    QuizQuestion(question: 'Which mountain range is the highest in the world?', options: ['Andes', 'Rockies', 'Alps', 'Himalayas'], correctIndex: 3),
    QuizQuestion(question: 'What is the capital of Japan?', options: ['Osaka', 'Kyoto', 'Tokyo', 'Yokohama'], correctIndex: 2),
    QuizQuestion(question: 'Which country is home to the Great Barrier Reef?', options: ['New Zealand', 'Australia', 'Fiji', 'Indonesia'], correctIndex: 1),
    QuizQuestion(question: 'What is the capital of Brazil?', options: ['Rio de Janeiro', 'São Paulo', 'Brasília', 'Salvador'], correctIndex: 2),
    QuizQuestion(question: 'Which island country is located south of Florida?', options: ['Jamaica', 'Cuba', 'Bahamas', 'Haiti'], correctIndex: 1),
    QuizQuestion(question: 'What is the capital of Egypt?', options: ['Alexandria', 'Luxor', 'Cairo', 'Giza'], correctIndex: 2),
    QuizQuestion(question: 'Which country is known for the Eiffel Tower?', options: ['Italy', 'France', 'England', 'Spain'], correctIndex: 1),
    QuizQuestion(question: 'What is the largest island in the world?', options: ['Australia', 'Greenland', 'New Guinea', 'Borneo'], correctIndex: 1),

    // --- Sports (20) ---
    QuizQuestion(question: 'How many players are on a baseball team?', options: ['7', '8', '9', '10'], correctIndex: 2),
    QuizQuestion(question: 'Which sport uses the term "home run"?', options: ['Cricket', 'Baseball', 'Tennis', 'Golf'], correctIndex: 1),
    QuizQuestion(question: 'How many rings are on the Olympic flag?', options: ['4', '5', '6', '7'], correctIndex: 1),
    QuizQuestion(question: 'Which country has won the most FIFA World Cups?', options: ['Germany', 'Italy', 'Brazil', 'Argentina'], correctIndex: 2),
    QuizQuestion(question: 'What is the highest score possible in a single frame of bowling?', options: ['10', '20', '30', '40'], correctIndex: 2),
    QuizQuestion(question: 'In which sport would you use a "shuttlecock"?', options: ['Tennis', 'Badminton', 'Squash', 'Table Tennis'], correctIndex: 1),
    QuizQuestion(question: 'How long is a marathon?', options: ['21 km', '42.195 km', '10 km', '50 km'], correctIndex: 1),
    QuizQuestion(question: 'Which sport is known as the "Gentleman\'s Game"?', options: ['Golf', 'Tennis', 'Cricket', 'Polo'], correctIndex: 2),
    QuizQuestion(question: 'How many players are on a basketball team on the court?', options: ['4', '5', '6', '7'], correctIndex: 1),
    QuizQuestion(question: 'In which city are the headquarters of the IOC?', options: ['Paris', 'London', 'Lausanne', 'Geneva'], correctIndex: 2),
    QuizQuestion(question: 'Which tennis tournament is played on grass?', options: ['French Open', 'US Open', 'Wimbledon', 'Australian Open'], correctIndex: 2),
    QuizQuestion(question: 'How many minutes are in a professional soccer match (excluding extra time)?', options: ['80', '90', '100', '120'], correctIndex: 1),
    QuizQuestion(question: 'Who is the fastest man in history?', options: ['Tyson Gay', 'Yohan Blake', 'Usain Bolt', 'Justin Gatlin'], correctIndex: 2),
    QuizQuestion(question: 'Which sport uses a "puck"?', options: ['Field Hockey', 'Ice Hockey', 'Lacrosse', 'Curling'], correctIndex: 1),
    QuizQuestion(question: 'How many holes are in a standard round of golf?', options: ['9', '12', '18', '24'], correctIndex: 2),
    QuizQuestion(question: 'In which sport do players compete for the Stanley Cup?', options: ['Basketball', 'Baseball', 'Football', 'Ice Hockey'], correctIndex: 3),
    QuizQuestion(question: 'What is the color of the jersey worn by the leader in the Tour de France?', options: ['Green', 'Red', 'Yellow', 'White'], correctIndex: 2),
    QuizQuestion(question: 'Which country hosts the Wimbledon tennis tournament?', options: ['USA', 'France', 'UK', 'Australia'], correctIndex: 2),
    QuizQuestion(question: 'How many points is a touchdown worth in American Football?', options: ['3', '6', '7', '1'], correctIndex: 1),
    QuizQuestion(question: 'In which sport can you get a "hole in one"?', options: ['Tennis', 'Golf', 'Bowling', 'Darts'], correctIndex: 1),

    // --- Food & Drink (20) ---
    QuizQuestion(question: 'What is the main ingredient in bread?', options: ['Flour', 'Sugar', 'Milk', 'Eggs'], correctIndex: 0),
    QuizQuestion(question: 'Which fruit is known as the "King of Fruits" in Southeast Asia?', options: ['Mango', 'Durian', 'Pineapple', 'Papaya'], correctIndex: 1),
    QuizQuestion(question: 'What is the primary ingredient in guacamole?', options: ['Tomato', 'Onion', 'Avocado', 'Pepper'], correctIndex: 2),
    QuizQuestion(question: 'Which country is famous for sushi?', options: ['China', 'Japan', 'Korea', 'Vietnam'], correctIndex: 1),
    QuizQuestion(question: 'What type of pasta is shaped like little ears?', options: ['Penne', 'Fusilli', 'Orecchiette', 'Farfalle'], correctIndex: 2),
    QuizQuestion(question: 'Which nut is used to make marzipan?', options: ['Walnut', 'Hazelnut', 'Almond', 'Cashew'], correctIndex: 2),
    QuizQuestion(question: 'What is the most popular drink in the world after water?', options: ['Coffee', 'Tea', 'Soda', 'Beer'], correctIndex: 1),
    QuizQuestion(question: 'Which country invented pizza?', options: ['Greece', 'Italy', 'France', 'USA'], correctIndex: 1),
    QuizQuestion(question: 'What is the main ingredient in a traditional omelet?', options: ['Cheese', 'Milk', 'Eggs', 'Potatoes'], correctIndex: 2),
    QuizQuestion(question: 'Which fruit is used to make wine?', options: ['Apples', 'Grapes', 'Pears', 'Cherries'], correctIndex: 1),
    QuizQuestion(question: 'What is the spice saffron derived from?', options: ['Crocus flower', 'Orchid', 'Rose', 'Lily'], correctIndex: 0),
    QuizQuestion(question: 'Which country is the largest producer of coffee?', options: ['Colombia', 'Vietnam', 'Brazil', 'Ethiopia'], correctIndex: 2),
    QuizQuestion(question: 'What is the main ingredient in chocolate?', options: ['Sugar', 'Cocoa beans', 'Milk', 'Vanilla'], correctIndex: 1),
    QuizQuestion(question: 'Which vegetable is known for being orange and good for eyesight?', options: ['Broccoli', 'Potato', 'Carrot', 'Spinach'], correctIndex: 2),
    QuizQuestion(question: 'What is the primary ingredient in tofu?', options: ['Rice', 'Wheat', 'Soybeans', 'Corn'], correctIndex: 2),
    QuizQuestion(question: 'Which drink is known as "the brew" in many cultures?', options: ['Coffee', 'Beer', 'Tea', 'Wine'], correctIndex: 2),
    QuizQuestion(question: 'What is the main ingredient in cheese?', options: ['Water', 'Milk', 'Cream', 'Yogurt'], correctIndex: 1),
    QuizQuestion(question: 'Which fruit is used to make cider?', options: ['Peaches', 'Pears', 'Apples', 'Plums'], correctIndex: 2),
    QuizQuestion(question: 'What is the most expensive spice in the world?', options: ['Vanilla', 'Cinnamon', 'Saffron', 'Cardamom'], correctIndex: 2),
    QuizQuestion(question: 'Which country is famous for its "Baguette"?', options: ['Italy', 'France', 'Germany', 'Spain'], correctIndex: 1),

    // --- Pop Culture (20) ---
    QuizQuestion(question: 'Who is known as the King of Pop?', options: ['Elvis Presley', 'Michael Jackson', 'Prince', 'Freddie Mercury'], correctIndex: 1),
    QuizQuestion(question: 'Which movie features a character named Jack Sparrow?', options: ['Star Wars', 'Harry Potter', 'Pirates of the Caribbean', 'Lord of the Rings'], correctIndex: 2),
    QuizQuestion(question: 'Who played Iron Man in the Marvel movies?', options: ['Chris Evans', 'Chris Hemsworth', 'Robert Downey Jr.', 'Mark Ruffalo'], correctIndex: 2),
    QuizQuestion(question: 'What is the name of the fictional school in Harry Potter?', options: ['Narnia', 'Middle-earth', 'Hogwarts', 'Neverland'], correctIndex: 2),
    QuizQuestion(question: 'Which singer is known for the hit "Hello"?', options: ['Adele', 'Beyoncé', 'Taylor Swift', 'Rihanna'], correctIndex: 0),
    QuizQuestion(question: 'What is the name of the lead singer of Queen?', options: ['David Bowie', 'Mick Jagger', 'Freddie Mercury', 'Robert Plant'], correctIndex: 2),
    QuizQuestion(question: 'Which animated movie features a character named Elsa?', options: ['Moana', 'Tangled', 'Frozen', 'Brave'], correctIndex: 2),
    QuizQuestion(question: 'Who wrote the "Harry Potter" book series?', options: ['J.R.R. Tolkien', 'C.S. Lewis', 'J.K. Rowling', 'Stephen King'], correctIndex: 2),
    QuizQuestion(question: 'Which superhero is also known as Bruce Wayne?', options: ['Superman', 'Batman', 'Spider-Man', 'Flash'], correctIndex: 1),
    QuizQuestion(question: 'What is the name of the main character in "The Matrix"?', options: ['Neo', 'Morpheus', 'Trinity', 'Agent Smith'], correctIndex: 0),
    QuizQuestion(question: 'Which pop star is known as "Queen Bey"?', options: ['Adele', 'Madonna', 'Beyoncé', 'Lady Gaga'], correctIndex: 2),
    QuizQuestion(question: 'What is the longest-running scripted TV show in the US?', options: ['Friends', 'The Simpsons', 'South Park', 'Grey\'s Anatomy'], correctIndex: 1),
    QuizQuestion(question: 'Which city is the setting for "Friends"?', options: ['Chicago', 'Los Angeles', 'New York City', 'Boston'], correctIndex: 2),
    QuizQuestion(question: 'Who directed the movie "Jurassic Park"?', options: ['George Lucas', 'Steven Spielberg', 'James Cameron', 'Christopher Nolan'], correctIndex: 1),
    QuizQuestion(question: 'What is the name of the kingdom in "The Lion King"?', options: ['Pride Lands', 'Shadow Lands', 'Elephant Graveyard', 'Outlands'], correctIndex: 0),
    QuizQuestion(question: 'Which band released the album "Abbey Road"?', options: ['The Rolling Stones', 'The Beatles', 'The Who', 'Led Zeppelin'], correctIndex: 1),
    QuizQuestion(question: 'Who is the creator of Mickey Mouse?', options: ['Charles Schulz', 'Walt Disney', 'Stan Lee', 'Hanna-Barbera'], correctIndex: 1),
    QuizQuestion(question: 'Which movie won the first Academy Award for Best Picture?', options: ['Gone with the Wind', 'Wings', 'Casablanca', 'Ben-Hur'], correctIndex: 1),
    QuizQuestion(question: 'What is the name of the fictional city where Batman lives?', options: ['Metropolis', 'Gotham City', 'Central City', 'Star City'], correctIndex: 1),
    QuizQuestion(question: 'Which actor played the Joker in "The Dark Knight"?', options: ['Jack Nicholson', 'Jared Leto', 'Heath Ledger', 'Joaquin Phoenix'], correctIndex: 2),

    // --- Language & Literature (20) ---
    QuizQuestion(question: 'What is a word that means the opposite of another word?', options: ['Synonym', 'Antonym', 'Homonym', 'Acronym'], correctIndex: 1),
    QuizQuestion(question: 'Who wrote "1984"?', options: ['Aldous Huxley', 'George Orwell', 'Ray Bradbury', 'H.G. Wells'], correctIndex: 1),
    QuizQuestion(question: 'How many letters are in the English alphabet?', options: ['24', '25', '26', '27'], correctIndex: 2),
    QuizQuestion(question: 'What is the name of the protagonist in "The Catcher in the Rye"?', options: ['Holden Caulfield', 'Jay Gatsby', 'Atticus Finch', 'Huckleberry Finn'], correctIndex: 0),
    QuizQuestion(question: 'Which language has the most native speakers?', options: ['English', 'Spanish', 'Mandarin Chinese', 'Hindi'], correctIndex: 2),
    QuizQuestion(question: 'Who wrote "The Great Gatsby"?', options: ['Ernest Hemingway', 'F. Scott Fitzgerald', 'William Faulkner', 'John Steinbeck'], correctIndex: 1),
    QuizQuestion(question: 'What is the first letter of the Greek alphabet?', options: ['Beta', 'Gamma', 'Delta', 'Alpha'], correctIndex: 3),
    QuizQuestion(question: 'Who wrote "Pride and Prejudice"?', options: ['Charlotte Brontë', 'Jane Austen', 'Emily Dickinson', 'Mary Shelley'], correctIndex: 1),
    QuizQuestion(question: 'What is the term for a book about someone\'s life written by themselves?', options: ['Biography', 'Autobiography', 'Memoir', 'Novel'], correctIndex: 1),
    QuizQuestion(question: 'Who wrote "The Hobbit"?', options: ['C.S. Lewis', 'J.R.R. Tolkien', 'Ursula K. Le Guin', 'George R.R. Martin'], correctIndex: 1),
    QuizQuestion(question: 'What is the most translated book in the world?', options: ['The Bible', 'The Little Prince', 'Pinocchio', 'Don Quixote'], correctIndex: 0),
    QuizQuestion(question: 'Who wrote "Hamlet"?', options: ['Christopher Marlowe', 'William Shakespeare', 'Ben Jonson', 'John Milton'], correctIndex: 1),
    QuizQuestion(question: 'What is the study of language called?', options: ['Linguistics', 'Philosophy', 'Sociology', 'Psychology'], correctIndex: 0),
    QuizQuestion(question: 'Which poet wrote "The Raven"?', options: ['Robert Frost', 'Walt Whitman', 'Edgar Allan Poe', 'Emily Dickinson'], correctIndex: 2),
    QuizQuestion(question: 'What is the name of the main character in "To Kill a Mockingbird"?', options: ['Scout Finch', 'Boo Radley', 'Atticus Finch', 'Tom Robinson'], correctIndex: 0),
    QuizQuestion(question: 'Who wrote "The Odyssey"?', options: ['Sophocles', 'Euripides', 'Homer', 'Virgil'], correctIndex: 2),
    QuizQuestion(question: 'What is the largest library in the world?', options: ['British Library', 'Library of Congress', 'Vatican Library', 'National Library of China'], correctIndex: 1),
    QuizQuestion(question: 'Who wrote "War and Peace"?', options: ['Fyodor Dostoevsky', 'Leo Tolstoy', 'Anton Chekhov', 'Ivan Turgenev'], correctIndex: 1),
    QuizQuestion(question: 'What is a group of lions called?', options: ['Pack', 'Herd', 'Pride', 'Flock'], correctIndex: 2),
    QuizQuestion(question: 'Who wrote "Moby-Dick"?', options: ['Nathaniel Hawthorne', 'Herman Melville', 'Mark Twain', 'Edgar Allan Poe'], correctIndex: 1),

    // --- Math & Logic (20) ---
    QuizQuestion(question: 'What is 5 + 7?', options: ['11', '12', '13', '14'], correctIndex: 1),
    QuizQuestion(question: 'How many sides does a hexagon have?', options: ['5', '6', '7', '8'], correctIndex: 1),
    QuizQuestion(question: 'What is the square root of 64?', options: ['6', '7', '8', '9'], correctIndex: 2),
    QuizQuestion(question: 'What is 100 divided by 4?', options: ['20', '25', '30', '35'], correctIndex: 1),
    QuizQuestion(question: 'How many degrees are in a right angle?', options: ['45', '60', '90', '180'], correctIndex: 2),
    QuizQuestion(question: 'What is 9 x 9?', options: ['72', '81', '90', '99'], correctIndex: 1),
    QuizQuestion(question: 'How many sides does an octagon have?', options: ['6', '7', '8', '10'], correctIndex: 2),
    QuizQuestion(question: 'What is the value of Pi (approx)?', options: ['2.14', '3.14', '4.14', '5.14'], correctIndex: 1),
    QuizQuestion(question: 'What is 15 - 8?', options: ['6', '7', '8', '9'], correctIndex: 1),
    QuizQuestion(question: 'How many zeros are in a million?', options: ['5', '6', '7', '8'], correctIndex: 1),
    QuizQuestion(question: 'What is 12 x 12?', options: ['124', '134', '144', '154'], correctIndex: 2),
    QuizQuestion(question: 'How many sides does a triangle have?', options: ['2', '3', '4', '5'], correctIndex: 1),
    QuizQuestion(question: 'What is 50% of 200?', options: ['50', '100', '150', '200'], correctIndex: 1),
    QuizQuestion(question: 'What is the next prime number after 7?', options: ['8', '9', '10', '11'], correctIndex: 3),
    QuizQuestion(question: 'What is 8 x 7?', options: ['54', '56', '58', '64'], correctIndex: 1),
    QuizQuestion(question: 'How many minutes are in two hours?', options: ['60', '90', '120', '150'], correctIndex: 2),
    QuizQuestion(question: 'What is 10 squared?', options: ['20', '50', '100', '200'], correctIndex: 2),
    QuizQuestion(question: 'How many sides does a pentagon have?', options: ['4', '5', '6', '7'], correctIndex: 1),
    QuizQuestion(question: 'What is 1/4 as a percentage?', options: ['10%', '20%', '25%', '40%'], correctIndex: 2),
    QuizQuestion(question: 'What is 3 + 3 x 3?', options: ['18', '9', '12', '15'], correctIndex: 2),

    // --- Animals (20) ---
    QuizQuestion(question: 'Which animal is the fastest on land?', options: ['Lion', 'Cheetah', 'Leopard', 'Greyhound'], correctIndex: 1),
    QuizQuestion(question: 'What is a baby cow called?', options: ['Calf', 'Foal', 'Cub', 'Kid'], correctIndex: 0),
    QuizQuestion(question: 'How many legs does an insect have?', options: ['4', '6', '8', '10'], correctIndex: 1),
    QuizQuestion(question: 'Which bird is the largest?', options: ['Eagle', 'Emu', 'Ostrich', 'Penguin'], correctIndex: 2),
    QuizQuestion(question: 'What animal is known for its trunk?', options: ['Rhino', 'Hippo', 'Elephant', 'Giraffe'], correctIndex: 2),
    QuizQuestion(question: 'Which animal lives in a pride?', options: ['Wolf', 'Lion', 'Elephant', 'Dolphin'], correctIndex: 1),
    QuizQuestion(question: 'What is the only mammal that can fly?', options: ['Bat', 'Bird', 'Squirrel', 'Butterfly'], correctIndex: 0),
    QuizQuestion(question: 'Which animal is the tallest?', options: ['Elephant', 'Giraffe', 'Ostrich', 'Moose'], correctIndex: 1),
    QuizQuestion(question: 'How many hearts does an octopus have?', options: ['1', '2', '3', '4'], correctIndex: 2),
    QuizQuestion(question: 'What is a group of fish called?', options: ['Pack', 'Flock', 'School', 'Swarm'], correctIndex: 2),
    QuizQuestion(question: 'Which animal is known as the "Ship of the Desert"?', options: ['Horse', 'Donkey', 'Camel', 'Elephant'], correctIndex: 2),
    QuizQuestion(question: 'What do you call a baby cat?', options: ['Puppy', 'Kitten', 'Cub', 'Chick'], correctIndex: 1),
    QuizQuestion(question: 'Which animal is famous for its black and white stripes?', options: ['Tiger', 'Panda', 'Zebra', 'Skunk'], correctIndex: 2),
    QuizQuestion(question: 'What is the largest species of shark?', options: ['Great White', 'Hammerhead', 'Whale Shark', 'Tiger Shark'], correctIndex: 2),
    QuizQuestion(question: 'Which animal is slow-moving and lives in trees?', options: ['Koala', 'Sloth', 'Monkey', 'Panda'], correctIndex: 1),
    QuizQuestion(question: 'What animal produces silk?', options: ['Spider', 'Silkworm', 'Bee', 'Ant'], correctIndex: 1),
    QuizQuestion(question: 'Which bird can mimic human speech?', options: ['Parrot', 'Crow', 'Owl', 'Hawk'], correctIndex: 0),
    QuizQuestion(question: 'What is a baby dog called?', options: ['Kitten', 'Puppy', 'Cub', 'Kid'], correctIndex: 1),
    QuizQuestion(question: 'Which animal is the largest reptile?', options: ['Alligator', 'Crocodile', 'Komodo Dragon', 'Turtle'], correctIndex: 1),
    QuizQuestion(question: 'What is the primary food of giant pandas?', options: ['Leaves', 'Bamboo', 'Fish', 'Fruit'], correctIndex: 1),
  ];

  // ── Fast Mode ──────────────────────────────────────────────────────────────

  static List<QuizQuestion> get fastModeQuestions {
    return (List<QuizQuestion>.from(gameModeQuestionsPool)..shuffle(Random()))
        .take(10)
        .toList();
  }

  // ── Power Up ───────────────────────────────────────────────────────────────

  static List<QuizQuestion> get powerUpQuestions {
    return (List<QuizQuestion>.from(gameModeQuestionsPool)..shuffle(Random()))
        .take(12)
        .toList();
  }

  // ── Time Attack ────────────────────────────────────────────────────────────

  static List<QuizQuestion> get timeAttackQuestions {
    return (List<QuizQuestion>.from(gameModeQuestionsPool)..shuffle(Random()))
        .take(40)
        .toList();
  }

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
