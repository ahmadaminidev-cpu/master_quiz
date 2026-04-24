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

  static const List<ExamQuestion> examQuestionsPool = [
    ExamQuestion(
      question: 'Why is the sky blue during a clear day?',
      options: ['Reflection of the ocean', 'Rayleigh scattering', 'Oxygen gas color', 'Distance from the sun'],
      correctIndex: 1,
      explanation: 'As sunlight reaches Earth\'s atmosphere, it is scattered in all directions by the gases and particles in the air. Blue light is scattered more than other colors because it travels as shorter, smaller waves. This is called Rayleigh scattering.',
    ),
    ExamQuestion(
      question: 'What is the main function of red blood cells?',
      options: ['Fighting infections', 'Clotting blood', 'Carrying oxygen', 'Digesting food'],
      correctIndex: 2,
      explanation: 'Red blood cells contain a protein called hemoglobin, which binds to oxygen in the lungs and carries it to all the tissues in your body. They also help carry carbon dioxide back to the lungs to be exhaled.',
    ),
    ExamQuestion(
      question: 'Which of these is the most common gas in Earth\'s atmosphere?',
      options: ['Oxygen', 'Carbon Dioxide', 'Nitrogen', 'Hydrogen'],
      correctIndex: 2,
      explanation: 'Nitrogen makes up about 78% of Earth\'s atmosphere, while oxygen makes up about 21%. Argon, carbon dioxide, and other gases exist in much smaller amounts.',
    ),
    ExamQuestion(
      question: 'How do plants help reduce global warming?',
      options: ['By releasing heat', 'By absorbing CO2', 'By creating wind', 'By reflecting sunlight'],
      correctIndex: 1,
      explanation: 'Plants absorb carbon dioxide (CO2) from the atmosphere during photosynthesis. CO2 is a major greenhouse gas that traps heat, so plants act as a "carbon sink" that helps cool the planet.',
    ),
    ExamQuestion(
      question: 'What causes the tides in the Earth\'s oceans?',
      options: ['The Sun\'s heat', 'Earth\'s rotation', 'Gravitational pull of the Moon', 'Undersea volcanoes'],
      correctIndex: 2,
      explanation: 'Tides are primarily caused by the gravitational pull of the Moon on Earth\'s oceans. The Sun also has a smaller effect. As Earth rotates, different parts of the planet pass through these gravitational bulges, causing high and low tides.',
    ),
    ExamQuestion(
      question: 'Why is the Great Wall of China significant in history?',
      options: ['It was a trade route', 'It was built for defense', 'It was a religious site', 'It was built for irrigation'],
      correctIndex: 1,
      explanation: 'The Great Wall was built over many centuries by various Chinese dynasties primarily to protect the Chinese states and empires against the raids and invasions of various nomadic groups from the Eurasian Steppe.',
    ),
    ExamQuestion(
      question: 'What is the primary purpose of the International Space Station (ISS)?',
      options: ['A space hotel', 'A military base', 'A research laboratory', 'A communication satellite'],
      correctIndex: 2,
      explanation: 'The ISS is a modular space station in low Earth orbit. It serves as a microgravity and space environment research laboratory in which crew members conduct experiments in biology, physics, astronomy, and meteorology.',
    ),
    ExamQuestion(
      question: 'Which historical figure is known for the theory of relativity?',
      options: ['Isaac Newton', 'Nikola Tesla', 'Albert Einstein', 'Marie Curie'],
      correctIndex: 2,
      explanation: 'Albert Einstein developed the theory of relativity, which revolutionized our understanding of space, time, and gravity. His famous equation E=mc² showed that energy and mass are interchangeable.',
    ),
    ExamQuestion(
      question: 'What is the largest internal organ in the human body?',
      options: ['Heart', 'Lungs', 'Liver', 'Kidneys'],
      correctIndex: 2,
      explanation: 'The liver is the largest internal organ. it performs over 500 vital functions, including detoxification, protein synthesis, and the production of chemicals that help digest food.',
    ),
    ExamQuestion(
      question: 'What was the Industrial Revolution?',
      options: ['A political war', 'A shift to new manufacturing processes', 'The discovery of America', 'The fall of the Roman Empire'],
      correctIndex: 1,
      explanation: 'The Industrial Revolution was a period of global economic transition toward manufacturing processes that began in the 18th century. It included the transition from hand production to machines and the rise of the factory system.',
    ),
    ExamQuestion(
      question: 'What is the role of the ozone layer in the atmosphere?',
      options: ['To provide oxygen', 'To trap heat', 'To absorb UV radiation', 'To create rain'],
      correctIndex: 2,
      explanation: 'The ozone layer is a region of Earth\'s stratosphere that absorbs most of the Sun\'s harmful ultraviolet (UV) radiation. Without it, life on Earth would be exposed to dangerous levels of radiation.',
    ),
    ExamQuestion(
      question: 'What defines a "Leap Year"?',
      options: ['A year with 364 days', 'A year with 366 days', 'A year with no summer', 'A year with two winters'],
      correctIndex: 1,
      explanation: 'A leap year has 366 days instead of 365. We add an extra day (February 29) every four years to keep our calendar in sync with the Earth\'s orbit around the Sun, which takes approximately 365.25 days.',
    ),
    ExamQuestion(
      question: 'Which organ is responsible for filtering waste from the blood?',
      options: ['Stomach', 'Pancreas', 'Kidneys', 'Spleen'],
      correctIndex: 2,
      explanation: 'The kidneys filter about 120 to 150 quarts of blood daily to produce 1 to 2 quarts of urine, composed of wastes and extra fluid. This process is essential for maintaining a healthy balance of water and minerals.',
    ),
    ExamQuestion(
      question: 'Who was the first woman to win a Nobel Prize?',
      options: ['Mother Teresa', 'Marie Curie', 'Rosa Parks', 'Jane Addams'],
      correctIndex: 1,
      explanation: 'Marie Curie was the first woman to win a Nobel Prize (Physics, 1903). She was also the first person and only woman to win the Nobel Prize twice, and the only person to win in two different scientific fields (Physics and Chemistry).',
    ),
    ExamQuestion(
      question: 'What is the main source of energy for the Earth?',
      options: ['Coal', 'Wind', 'The Sun', 'Volcanoes'],
      correctIndex: 2,
      explanation: 'The Sun provides the energy that drives Earth\'s weather, ocean currents, seasons, and climate, and makes plant life possible through photosynthesis.',
    ),
    ExamQuestion(
      question: 'What is the purpose of a "Vaccine"?',
      options: ['To cure a disease', 'To provide instant energy', 'To train the immune system', 'To replace blood cells'],
      correctIndex: 2,
      explanation: 'A vaccine stimulates the immune system to produce antibodies, exactly as it would if you were exposed to the disease. After getting vaccinated, you develop immunity to that disease without having to get the disease first.',
    ),
    ExamQuestion(
      question: 'Which ocean is the deepest in the world?',
      options: ['Atlantic', 'Indian', 'Arctic', 'Pacific'],
      correctIndex: 3,
      explanation: 'The Pacific Ocean is the largest and deepest of Earth\'s oceanic divisions. It contains the Mariana Trench, which is the deepest known point in the world\'s oceans.',
    ),
    ExamQuestion(
      question: 'What does the term "Sustainability" mean?',
      options: ['Using resources as fast as possible', 'Meeting needs without compromising the future', 'Living without technology', 'Growing more food only'],
      correctIndex: 1,
      explanation: 'Sustainability means meeting our own needs without compromising the ability of future generations to meet their own needs. it involves balancing economic, social, and environmental factors.',
    ),
    ExamQuestion(
      question: 'How many bones are in the adult human body?',
      options: ['106', '206', '306', '406'],
      correctIndex: 1,
      explanation: 'An adult human has 206 bones. Infants are actually born with about 300 bones, but as they grow, some of these bones fuse together to form the adult skeleton.',
    ),
    ExamQuestion(
      question: 'What is the capital of France?',
      options: ['Berlin', 'Madrid', 'Paris', 'Rome'],
      correctIndex: 2,
      explanation: 'Paris is the capital and most populous city of France. Since the 17th century, it has been one of the world\'s major centers of finance, diplomacy, commerce, fashion, gastronomy, and science.',
    ),
    ExamQuestion(
      question: 'What is the "Greenhouse Effect"?',
      options: ['Plants growing in a house', 'Atmosphere trapping heat', 'Painting houses green', 'Reflecting light from the moon'],
      correctIndex: 1,
      explanation: 'The greenhouse effect is the process by which radiation from a planet\'s atmosphere warms the planet\'s surface to a temperature above what it would be without its atmosphere.',
    ),
    ExamQuestion(
      question: 'What is the significance of the Rosetta Stone?',
      options: ['It was a building block', 'It helped decode hieroglyphics', 'It was a religious idol', 'It was a decorative garden stone'],
      correctIndex: 1,
      explanation: 'The Rosetta Stone is a stone with writing on it in two languages (Egyptian and Greek), using three scripts (hieroglyphic, demotic and Greek). It was the key to understanding Egyptian hieroglyphics.',
    ),
    ExamQuestion(
      question: 'What is the "Big Bang Theory"?',
      options: ['A theory about a TV show', 'The origin of the universe', 'A type of musical style', 'The sound of a supernova'],
      correctIndex: 1,
      explanation: 'The Big Bang theory is the prevailing cosmological model for the universe from the earliest known periods through its subsequent large-scale evolution.',
    ),
    ExamQuestion(
      question: 'What is the role of DNA in cells?',
      options: ['To provide energy', 'To store genetic information', 'To protect the cell wall', 'To help with movement'],
      correctIndex: 1,
      explanation: 'DNA (Deoxyribonucleic acid) is a molecule that carries the genetic instructions used in the growth, development, functioning and reproduction of all known living organisms.',
    ),
    ExamQuestion(
      question: 'What was the "Cold War"?',
      options: ['A war in the Arctic', 'A period of political tension', 'A war fought with ice', 'A winter-only conflict'],
      correctIndex: 1,
      explanation: 'The Cold War was a period of geopolitical tension between the United States and the Soviet Union and their respective allies, which began after World War II.',
    ),
    ExamQuestion(
      question: 'What is the "Water Cycle"?',
      options: ['A cycle used for exercise', 'The continuous movement of water', 'A type of water pump', 'A water-saving technique'],
      correctIndex: 1,
      explanation: 'The water cycle is the continuous movement of water on, above, and below the surface of the Earth. It involves evaporation, condensation, and precipitation.',
    ),
    ExamQuestion(
      question: 'What is the primary language of the Roman Empire?',
      options: ['Greek', 'Latin', 'Italian', 'French'],
      correctIndex: 1,
      explanation: 'Latin was the primary language of the Roman Empire. It is the root of many modern European languages, including Italian, French, Spanish, and Portuguese.',
    ),
    ExamQuestion(
      question: 'What is the purpose of the "Red Cross"?',
      options: ['A military organization', 'A humanitarian organization', 'A political party', 'A sports club'],
      correctIndex: 1,
      explanation: 'The International Red Cross and Red Crescent Movement is a global humanitarian network that helps people affected by disasters, conflicts, and health and social problems.',
    ),
    ExamQuestion(
      question: 'What is the "Internet of Things" (IoT)?',
      options: ['A network of computers', 'Interconnected everyday objects', 'A type of internet browser', 'A social media platform'],
      correctIndex: 1,
      explanation: 'The Internet of Things (IoT) is a network of physical objects ("things") that are embedded with sensors, software, and other technologies for the purpose of connecting and exchanging data with other devices and systems over the internet.',
    ),
    ExamQuestion(
      question: 'What is the "Renaissance"?',
      options: ['A religious movement', 'A cultural and artistic rebirth', 'A political revolution', 'A scientific discovery'],
      correctIndex: 1,
      explanation: 'The Renaissance was a fervent period of European cultural, artistic, political and economic "rebirth" following the Middle Ages.',
    ),
    ExamQuestion(
      question: 'Why do we have different seasons on Earth?',
      options: ['Earth\'s distance from the sun', 'Earth\'s axial tilt', 'The moon\'s shadow', 'Volcanic activity'],
      correctIndex: 1,
      explanation: 'Seasons are caused by Earth\'s axial tilt (23.5 degrees) as it orbits the Sun. Different parts of Earth receive more direct sunlight at different times of the year.',
    ),
    ExamQuestion(
      question: 'What is the function of the human "Immune System"?',
      options: ['To digest food', 'To protect against pathogens', 'To circulate blood', 'To control muscle movement'],
      correctIndex: 1,
      explanation: 'The immune system is a complex network of cells, tissues, and organs that work together to defend the body against attacks by "foreign" invaders like bacteria, viruses, and parasites.',
    ),
    ExamQuestion(
      question: 'What is "Photosynthesis"?',
      options: ['How animals breathe', 'How plants make food', 'How rocks are formed', 'How water evaporates'],
      correctIndex: 1,
      explanation: 'Photosynthesis is the process by which green plants and some other organisms use sunlight to synthesize foods from carbon dioxide and water.',
    ),
    ExamQuestion(
      question: 'What was the significance of the "Magna Carta"?',
      options: ['It was a map of the world', 'It limited the power of the king', 'It was a religious text', 'It started the French Revolution'],
      correctIndex: 1,
      explanation: 'The Magna Carta, signed in 1215, was the first document to put into writing the principle that the king and his government were not above the law.',
    ),
    ExamQuestion(
      question: 'What is a "Black Hole"?',
      options: ['A hole in the ozone layer', 'A region of intense gravity', 'A dark spot on the sun', 'A tunnel through the earth'],
      correctIndex: 1,
      explanation: 'A black hole is a region of spacetime where gravity is so strong that nothing—no particles or even electromagnetic radiation such as light—can escape from it.',
    ),
    ExamQuestion(
      question: 'What is the purpose of "Recycling"?',
      options: ['To make new products from waste', 'To throw away more trash', 'To create more plastic', 'To increase pollution'],
      correctIndex: 0,
      explanation: 'Recycling is the process of collecting and processing materials that would otherwise be thrown away as trash and turning them into new products.',
    ),
    ExamQuestion(
      question: 'What is the "Great Barrier Reef"?',
      options: ['A mountain range', 'The world\'s largest coral reef system', 'A large desert in Africa', 'A famous wall in Europe'],
      correctIndex: 1,
      explanation: 'The Great Barrier Reef is the world\'s largest coral reef system, composed of over 2,900 individual reefs and 900 islands stretching for over 2,300 kilometers.',
    ),
    ExamQuestion(
      question: 'Who is considered the "Father of Modern Physics"?',
      options: ['Isaac Newton', 'Albert Einstein', 'Galileo Galilei', 'Niels Bohr'],
      correctIndex: 1,
      explanation: 'Albert Einstein is often called the father of modern physics for his development of the theory of relativity and his contributions to quantum mechanics.',
    ),
    ExamQuestion(
      question: 'What is "Artificial Intelligence"?',
      options: ['A type of robot', 'Simulation of human intelligence by machines', 'A new video game', 'A method of building computers'],
      correctIndex: 1,
      explanation: 'Artificial intelligence (AI) is the simulation of human intelligence processes by machines, especially computer systems, including learning, reasoning, and self-correction.',
    ),
  ];

  static List<ExamQuestion> get examQuestions {
    return (List<ExamQuestion>.from(examQuestionsPool)..shuffle(Random()))
        .take(12)
        .toList();
  }

  // ── Daily Challenge ────────────────────────────────────────────────────────

  static const List<QuizQuestion> dailyChallengePool = [
    QuizQuestion(question: 'Which fruit is famous for keeping the doctor away?', options: ['Banana', 'Orange', 'Apple', 'Grape'], correctIndex: 2),
    QuizQuestion(question: 'What is the color of a school bus?', options: ['Red', 'Yellow', 'Blue', 'Green'], correctIndex: 1),
    QuizQuestion(question: 'How many days are in a week?', options: ['5', '6', '7', '8'], correctIndex: 2),
    QuizQuestion(question: 'What do you use to stay dry in the rain?', options: ['Hat', 'Sunglasses', 'Umbrella', 'Coat'], correctIndex: 2),
    QuizQuestion(question: 'Which animal says "Meow"?', options: ['Dog', 'Cat', 'Cow', 'Bird'], correctIndex: 1),
    QuizQuestion(question: 'What is the color of the grass?', options: ['Blue', 'Red', 'Green', 'Yellow'], correctIndex: 2),
    QuizQuestion(question: 'How many fingers does a person typically have on one hand?', options: ['4', '5', '6', '10'], correctIndex: 1),
    QuizQuestion(question: 'Which of these is a primary color?', options: ['Green', 'Purple', 'Red', 'Orange'], correctIndex: 2),
    QuizQuestion(question: 'What do you use to smell things?', options: ['Eyes', 'Ears', 'Nose', 'Mouth'], correctIndex: 2),
    QuizQuestion(question: 'Which shape is round like a ball?', options: ['Square', 'Triangle', 'Circle', 'Star'], correctIndex: 2),
    QuizQuestion(question: 'What is the opposite of "Hot"?', options: ['Warm', 'Cold', 'Wet', 'Dry'], correctIndex: 1),
    QuizQuestion(question: 'Which animal is known as the "King of the Jungle"?', options: ['Tiger', 'Elephant', 'Lion', 'Giraffe'], correctIndex: 2),
    QuizQuestion(question: 'How many legs does a dog have?', options: ['2', '4', '6', '8'], correctIndex: 1),
    QuizQuestion(question: 'What do you wear on your feet to go for a run?', options: ['Gloves', 'Socks', 'Shoes', 'Hats'], correctIndex: 2),
    QuizQuestion(question: 'Which fruit is yellow and long?', options: ['Apple', 'Banana', 'Cherry', 'Plum'], correctIndex: 1),
    QuizQuestion(question: 'What is the largest planet in our solar system?', options: ['Earth', 'Mars', 'Jupiter', 'Venus'], correctIndex: 2),
    QuizQuestion(question: 'Which bird can mimic human speech?', options: ['Eagle', 'Parrot', 'Owl', 'Crow'], correctIndex: 1),
    QuizQuestion(question: 'How many wheels does a bicycle have?', options: ['1', '2', '3', '4'], correctIndex: 1),
    QuizQuestion(question: 'What is the color of the sun?', options: ['Blue', 'Green', 'Yellow', 'Purple'], correctIndex: 2),
    QuizQuestion(question: 'Which ocean is the largest?', options: ['Atlantic', 'Indian', 'Pacific', 'Arctic'], correctIndex: 2),
    QuizQuestion(question: 'What do you use to write on paper?', options: ['Fork', 'Pencil', 'Spoon', 'Brush'], correctIndex: 1),
    QuizQuestion(question: 'How many colors are in a rainbow?', options: ['5', '6', '7', '8'], correctIndex: 2),
    QuizQuestion(question: 'Which season comes after Winter?', options: ['Summer', 'Fall', 'Spring', 'Autumn'], correctIndex: 2),
    QuizQuestion(question: 'What is the capital of the USA?', options: ['New York', 'Los Angeles', 'Washington D.C.', 'Chicago'], correctIndex: 2),
    QuizQuestion(question: 'Which animal gives us wool?', options: ['Cow', 'Horse', 'Sheep', 'Pig'], correctIndex: 2),
    QuizQuestion(question: 'What do you use to cut paper?', options: ['Glue', 'Tape', 'Scissors', 'Eraser'], correctIndex: 2),
    QuizQuestion(question: 'Which planet is known as the Red Planet?', options: ['Earth', 'Mars', 'Jupiter', 'Saturn'], correctIndex: 1),
    QuizQuestion(question: 'How many hours are in a day?', options: ['12', '24', '48', '60'], correctIndex: 1),
    QuizQuestion(question: 'What is the largest land animal?', options: ['Giraffe', 'Elephant', 'Hippo', 'Rhino'], correctIndex: 1),
    QuizQuestion(question: 'Which of these is a vegetable?', options: ['Apple', 'Banana', 'Carrot', 'Grape'], correctIndex: 2),
    QuizQuestion(question: 'What do you use to see things?', options: ['Nose', 'Eyes', 'Ears', 'Hands'], correctIndex: 1),
    QuizQuestion(question: 'Which animal has a very long neck?', options: ['Elephant', 'Giraffe', 'Zebra', 'Horse'], correctIndex: 1),
    QuizQuestion(question: 'What is the freezing point of water?', options: ['0°C', '50°C', '100°C', '32°C'], correctIndex: 0),
    QuizQuestion(question: 'How many sides does a triangle have?', options: ['2', '3', '4', '5'], correctIndex: 1),
    QuizQuestion(question: 'Which country is famous for the Eiffel Tower?', options: ['Italy', 'Germany', 'France', 'Spain'], correctIndex: 2),
    QuizQuestion(question: 'What is the opposite of "Big"?', options: ['Large', 'Huge', 'Small', 'Tall'], correctIndex: 2),
    QuizQuestion(question: 'Which animal lives in the water and has fins?', options: ['Dog', 'Cat', 'Fish', 'Bird'], correctIndex: 2),
    QuizQuestion(question: 'What is the color of an orange?', options: ['Blue', 'Orange', 'Green', 'Red'], correctIndex: 1),
    QuizQuestion(question: 'How many months are in a year?', options: ['10', '11', '12', '13'], correctIndex: 2),
    QuizQuestion(question: 'What do you use to tell the time?', options: ['Phone', 'Watch', 'Calendar', 'Map'], correctIndex: 1),
  ];

  static List<QuizQuestion> get dailyChallengeQuestions {
    return (List<QuizQuestion>.from(dailyChallengePool)..shuffle(Random()))
        .take(3) // Each daily challenge is 3 questions
        .toList();
  }

  // ── Game Mode Questions (200 Pool) ──────────────────────────────────────────

  static const List<QuizQuestion> gameModeQuestionsPool = [
    // --- General Knowledge (20) ---
    QuizQuestion(question: 'What is the largest ocean on Earth?', options: ['Atlantic', 'Indian', 'Arctic', 'Pacific'], correctIndex: 3),
    QuizQuestion(question: 'Which country is known for its Sushi?', options: ['China', 'Japan', 'Korea', 'Thailand'], correctIndex: 1),
    QuizQuestion(question: 'How many continents are there?', options: ['5', '6', '7', '8'], correctIndex: 2),
    QuizQuestion(question: 'What is the capital of Italy?', options: ['Venice', 'Milan', 'Naples', 'Rome'], correctIndex: 3),
    QuizQuestion(question: 'What is the currency of the USA?', options: ['Euro', 'Dollar', 'Pound', 'Yen'], correctIndex: 1),
    QuizQuestion(question: 'Which planet is known as the Red Planet?', options: ['Venus', 'Mars', 'Jupiter', 'Saturn'], correctIndex: 1),
    QuizQuestion(question: 'How many legs does a spider have?', options: ['6', '8', '10', '12'], correctIndex: 1),
    QuizQuestion(question: 'Which is the longest river in the world?', options: ['Amazon', 'Nile', 'Yangtze', 'Mississippi'], correctIndex: 1),
    QuizQuestion(question: 'Who wrote "Romeo and Juliet"?', options: ['Charles Dickens', 'William Shakespeare', 'Mark Twain', 'Jane Austen'], correctIndex: 1),
    QuizQuestion(question: 'What is the hardest natural substance?', options: ['Gold', 'Iron', 'Diamond', 'Quartz'], correctIndex: 2),
    QuizQuestion(question: 'Which is the tallest mountain in the world?', options: ['K2', 'Mount Everest', 'Fuji', 'Kilimanjaro'], correctIndex: 1),
    QuizQuestion(question: 'How many players are in a soccer team on the field?', options: ['9', '10', '11', '12'], correctIndex: 2),
    QuizQuestion(question: 'What is the largest mammal in the world?', options: ['Elephant', 'Blue Whale', 'Giraffe', 'Shark'], correctIndex: 1),
    QuizQuestion(question: 'Which gas do we need to breathe to live?', options: ['Nitrogen', 'Oxygen', 'Carbon', 'Hydrogen'], correctIndex: 1),
    QuizQuestion(question: 'What is the capital of France?', options: ['Berlin', 'Madrid', 'Paris', 'Rome'], correctIndex: 2),
    QuizQuestion(question: 'What is the color of an emerald?', options: ['Red', 'Blue', 'Green', 'Yellow'], correctIndex: 2),
    QuizQuestion(question: 'How many days are in a regular year?', options: ['364', '365', '366', '367'], correctIndex: 1),
    QuizQuestion(question: 'Which is the largest country in the world by size?', options: ['China', 'USA', 'Russia', 'Canada'], correctIndex: 2),
    QuizQuestion(question: 'What is the freezing point of water?', options: ['0°C', '32°C', '100°C', '50°C'], correctIndex: 0),
    QuizQuestion(question: 'Which bird is the symbol of peace?', options: ['Eagle', 'Dove', 'Parrot', 'Owl'], correctIndex: 1),

    // --- Science & Nature (20) ---
    QuizQuestion(question: 'What is the chemical symbol for water?', options: ['H2O', 'O2', 'CO2', 'NaCl'], correctIndex: 0),
    QuizQuestion(question: 'How many planets are in our solar system?', options: ['7', '8', '9', '10'], correctIndex: 1),
    QuizQuestion(question: 'What part of the plant grows underground?', options: ['Leaf', 'Stem', 'Flower', 'Root'], correctIndex: 3),
    QuizQuestion(question: 'Which planet is closest to the Sun?', options: ['Venus', 'Mercury', 'Earth', 'Mars'], correctIndex: 1),
    QuizQuestion(question: 'What is the study of animals called?', options: ['Biology', 'Zoology', 'Botany', 'Geology'], correctIndex: 1),
    QuizQuestion(question: 'What is the boiling point of water?', options: ['50°C', '100°C', '150°C', '200°C'], correctIndex: 1),
    QuizQuestion(question: 'Which force pulls things to the ground?', options: ['Magnetism', 'Gravity', 'Wind', 'Electricity'], correctIndex: 1),
    QuizQuestion(question: 'What is the largest organ of the human body?', options: ['Heart', 'Lungs', 'Liver', 'Skin'], correctIndex: 3),
    QuizQuestion(question: 'What do bees make?', options: ['Milk', 'Honey', 'Juice', 'Water'], correctIndex: 1),
    QuizQuestion(question: 'How many teeth does a typical adult have?', options: ['28', '30', '32', '34'], correctIndex: 2),
    QuizQuestion(question: 'What gas do plants need to grow?', options: ['Oxygen', 'Carbon Dioxide', 'Nitrogen', 'Argon'], correctIndex: 1),
    QuizQuestion(question: 'Which is the closest star to Earth?', options: ['Sirius', 'The Sun', 'North Star', 'Vega'], correctIndex: 1),
    QuizQuestion(question: 'Which animal is the "King of the Jungle"?', options: ['Tiger', 'Elephant', 'Lion', 'Bear'], correctIndex: 2),
    QuizQuestion(question: 'What is the chemical symbol for Gold?', options: ['Go', 'Au', 'Ag', 'Fe'], correctIndex: 1),
    QuizQuestion(question: 'How many colors are in a rainbow?', options: ['5', '6', '7', '8'], correctIndex: 2),
    QuizQuestion(question: 'Which organ pumps blood?', options: ['Brain', 'Lungs', 'Heart', 'Stomach'], correctIndex: 2),
    QuizQuestion(question: 'What is the center of an atom called?', options: ['Electron', 'Proton', 'Nucleus', 'Neutron'], correctIndex: 2),
    QuizQuestion(question: 'What do you call a baby frog?', options: ['Cub', 'Tadpole', 'Puppy', 'Kitten'], correctIndex: 1),
    QuizQuestion(question: 'Which planet is famous for its rings?', options: ['Mars', 'Jupiter', 'Saturn', 'Neptune'], correctIndex: 2),
    QuizQuestion(question: 'What is the main gas in the air we breathe?', options: ['Oxygen', 'Nitrogen', 'Carbon', 'Hydrogen'], correctIndex: 1),

    // --- History (20) ---
    QuizQuestion(question: 'Who was the first President of the USA?', options: ['Lincoln', 'Washington', 'Jefferson', 'Kennedy'], correctIndex: 1),
    QuizQuestion(question: 'Which country built the pyramids?', options: ['Greece', 'Italy', 'Egypt', 'Mexico'], correctIndex: 2),
    QuizQuestion(question: 'Who discovered America in 1492?', options: ['Marco Polo', 'Columbus', 'Magellan', 'Cook'], correctIndex: 1),
    QuizQuestion(question: 'In which year did World War II end?', options: ['1918', '1945', '1960', '2000'], correctIndex: 1),
    QuizQuestion(question: 'Which wall was pulled down in Germany in 1989?', options: ['Great Wall', 'Berlin Wall', 'Western Wall', 'Roman Wall'], correctIndex: 1),
    QuizQuestion(question: 'Who was the famous Queen of Ancient Egypt?', options: ['Cleopatra', 'Elizabeth', 'Victoria', 'Mary'], correctIndex: 0),
    QuizQuestion(question: 'Who invented the light bulb?', options: ['Tesla', 'Edison', 'Bell', 'Newton'], correctIndex: 1),
    QuizQuestion(question: 'Which country did the Vikings come from?', options: ['Spain', 'Italy', 'Norway', 'Egypt'], correctIndex: 2),
    QuizQuestion(question: 'What was the name of the ship that sank in 1912?', options: ['Mayflower', 'Titanic', 'Victory', 'Beagle'], correctIndex: 1),
    QuizQuestion(question: 'Who was the first man on the moon?', options: ['Buzz Aldrin', 'Neil Armstrong', 'Yuri Gagarin', 'Elon Musk'], correctIndex: 1),
    QuizQuestion(question: 'Which empire was ruled by Julius Caesar?', options: ['Greek', 'Roman', 'Persian', 'British'], correctIndex: 1),
    QuizQuestion(question: 'In which country was the Great Wall built?', options: ['Japan', 'China', 'India', 'Korea'], correctIndex: 1),
    QuizQuestion(question: 'Who wrote the Declaration of Independence?', options: ['Washington', 'Jefferson', 'Franklin', 'Adams'], correctIndex: 1),
    QuizQuestion(question: 'Which city was buried by a volcano in 79 AD?', options: ['Rome', 'Pompeii', 'Athens', 'Paris'], correctIndex: 1),
    QuizQuestion(question: 'Who was the first woman to fly solo across the Atlantic?', options: ['Amelia Earhart', 'Marie Curie', 'Rosa Parks', 'Queen Victoria'], correctIndex: 0),
    QuizQuestion(question: 'What ancient civilization used hieroglyphics?', options: ['Romans', 'Greeks', 'Egyptians', 'Aztecs'], correctIndex: 2),
    QuizQuestion(question: 'Who was the leader of the Civil Rights movement in the USA?', options: ['Malcolm X', 'Martin Luther King Jr.', 'Obama', 'Nelson Mandela'], correctIndex: 1),
    QuizQuestion(question: 'Which country did the Samurai come from?', options: ['China', 'Japan', 'Thailand', 'Vietnam'], correctIndex: 1),
    QuizQuestion(question: 'What was the main weapon of a medieval knight?', options: ['Gun', 'Sword', 'Bow', 'Sling'], correctIndex: 1),
    QuizQuestion(question: 'Who was the legendary King of Camelot?', options: ['King George', 'King Arthur', 'King Henry', 'King Richard'], correctIndex: 1),

    // --- Geography (20) ---
    QuizQuestion(question: 'What is the capital of England?', options: ['Paris', 'London', 'Berlin', 'Madrid'], correctIndex: 1),
    QuizQuestion(question: 'Which is the largest continent?', options: ['Africa', 'Asia', 'Europe', 'North America'], correctIndex: 1),
    QuizQuestion(question: 'Which country has the most people?', options: ['USA', 'India', 'China', 'Russia'], correctIndex: 2),
    QuizQuestion(question: 'What is the capital of Japan?', options: ['Seoul', 'Beijing', 'Tokyo', 'Bangkok'], correctIndex: 2),
    QuizQuestion(question: 'Which ocean is between Europe and America?', options: ['Pacific', 'Atlantic', 'Indian', 'Arctic'], correctIndex: 1),
    QuizQuestion(question: 'What is the smallest continent?', options: ['Europe', 'Asia', 'Australia', 'Africa'], correctIndex: 2),
    QuizQuestion(question: 'Which country is known as "Down Under"?', options: ['Canada', 'New Zealand', 'Australia', 'Brazil'], correctIndex: 2),
    QuizQuestion(question: 'What is the capital of Spain?', options: ['Barcelona', 'Madrid', 'Seville', 'Valencia'], correctIndex: 1),
    QuizQuestion(question: 'In which country is the Eiffel Tower?', options: ['Italy', 'Germany', 'France', 'England'], correctIndex: 2),
    QuizQuestion(question: 'What is the capital of Russia?', options: ['Kiev', 'Moscow', 'Warsaw', 'Prague'], correctIndex: 1),
    QuizQuestion(question: 'Which river flows through London?', options: ['Nile', 'Amazon', 'Thames', 'Seine'], correctIndex: 2),
    QuizQuestion(question: 'What is the capital of Germany?', options: ['Munich', 'Hamburg', 'Berlin', 'Frankfurt'], correctIndex: 2),
    QuizQuestion(question: 'In which continent is the Amazon Rainforest?', options: ['Africa', 'Asia', 'South America', 'Australia'], correctIndex: 2),
    QuizQuestion(question: 'What is the capital of Italy?', options: ['Milan', 'Rome', 'Venice', 'Naples'], correctIndex: 1),
    QuizQuestion(question: 'Which country is home to the Taj Mahal?', options: ['China', 'India', 'Pakistan', 'Nepal'], correctIndex: 1),
    QuizQuestion(question: 'What is the capital of Canada?', options: ['Toronto', 'Ottawa', 'Montreal', 'Vancouver'], correctIndex: 1),
    QuizQuestion(question: 'Which sea is between Europe and Africa?', options: ['Red Sea', 'Dead Sea', 'Mediterranean Sea', 'Black Sea'], correctIndex: 2),
    QuizQuestion(question: 'What is the capital of Egypt?', options: ['Alexandria', 'Cairo', 'Giza', 'Luxor'], correctIndex: 1),
    QuizQuestion(question: 'Which country is shaped like a boot?', options: ['Greece', 'Spain', 'Italy', 'Portugal'], correctIndex: 2),
    QuizQuestion(question: 'What is the largest island in the world?', options: ['Australia', 'Greenland', 'Iceland', 'Japan'], correctIndex: 1),

    // --- Sports (20) ---
    QuizQuestion(question: 'How many players are on a soccer team?', options: ['9', '10', '11', '12'], correctIndex: 2),
    QuizQuestion(question: 'Which sport uses a "shuttlecock"?', options: ['Tennis', 'Badminton', 'Golf', 'Baseball'], correctIndex: 1),
    QuizQuestion(question: 'How many rings are on the Olympic flag?', options: ['4', '5', '6', '7'], correctIndex: 1),
    QuizQuestion(question: 'Which country has won the most World Cups in soccer?', options: ['Germany', 'Brazil', 'Italy', 'Argentina'], correctIndex: 1),
    QuizQuestion(question: 'In which sport do you hit a "home run"?', options: ['Cricket', 'Baseball', 'Tennis', 'Hockey'], correctIndex: 1),
    QuizQuestion(question: 'How many players are on a basketball team on court?', options: ['4', '5', '6', '7'], correctIndex: 1),
    QuizQuestion(question: 'What is the color of the jerseys in the Tour de France leader?', options: ['Red', 'Yellow', 'Blue', 'Green'], correctIndex: 1),
    QuizQuestion(question: 'Which sport is played at Wimbledon?', options: ['Soccer', 'Tennis', 'Golf', 'Cricket'], correctIndex: 1),
    QuizQuestion(question: 'How many holes are in a standard round of golf?', options: ['9', '12', '18', '24'], correctIndex: 2),
    QuizQuestion(question: 'Which sport uses a "puck"?', options: ['Soccer', 'Ice Hockey', 'Field Hockey', 'Basketball'], correctIndex: 1),
    QuizQuestion(question: 'Who is the fastest man in the world?', options: ['Bolt', 'Gay', 'Blake', 'Gatlin'], correctIndex: 0),
    QuizQuestion(question: 'How many minutes is a regular soccer match?', options: ['80', '90', '100', '120'], correctIndex: 1),
    QuizQuestion(question: 'Which sport is known as the "Gentleman\'s Game"?', options: ['Polo', 'Cricket', 'Golf', 'Tennis'], correctIndex: 1),
    QuizQuestion(question: 'How many points is a touchdown worth in American Football?', options: ['3', '6', '7', '1'], correctIndex: 1),
    QuizQuestion(question: 'In which sport do you use a "racket"?', options: ['Golf', 'Baseball', 'Tennis', 'Hockey'], correctIndex: 2),
    QuizQuestion(question: 'Which country hosts the Super Bowl?', options: ['UK', 'Canada', 'USA', 'Australia'], correctIndex: 2),
    QuizQuestion(question: 'What is the shape of a soccer ball?', options: ['Oval', 'Round', 'Square', 'Flat'], correctIndex: 1),
    QuizQuestion(question: 'Which sport uses the term "Love" for zero score?', options: ['Tennis', 'Golf', 'Badminton', 'Darts'], correctIndex: 0),
    QuizQuestion(question: 'How many players are on a volleyball team on court?', options: ['4', '5', '6', '7'], correctIndex: 2),
    QuizQuestion(question: 'What is the color of the balls in a standard pool game?', options: ['One color', 'Numbered/Colored', 'All White', 'All Black'], correctIndex: 1),

    // --- Food & Drink (20) ---
    QuizQuestion(question: 'What is the main ingredient in bread?', options: ['Sugar', 'Flour', 'Milk', 'Eggs'], correctIndex: 1),
    QuizQuestion(question: 'Which fruit is used to make wine?', options: ['Apple', 'Grape', 'Pear', 'Orange'], correctIndex: 1),
    QuizQuestion(question: 'What is the primary ingredient in guacamole?', options: ['Tomato', 'Avocado', 'Onion', 'Lemon'], correctIndex: 1),
    QuizQuestion(question: 'Which country is famous for Pizza?', options: ['France', 'Italy', 'Spain', 'Greece'], correctIndex: 1),
    QuizQuestion(question: 'What is the most popular drink after water?', options: ['Coffee', 'Tea', 'Soda', 'Beer'], correctIndex: 1),
    QuizQuestion(question: 'What do you call a person who doesn\'t eat meat?', options: ['Vegan', 'Vegetarian', 'Carnivore', 'Herbivore'], correctIndex: 1),
    QuizQuestion(question: 'What is the main ingredient in chocolate?', options: ['Sugar', 'Cocoa', 'Milk', 'Butter'], correctIndex: 1),
    QuizQuestion(question: 'Which fruit is yellow and curved?', options: ['Apple', 'Banana', 'Orange', 'Grape'], correctIndex: 1),
    QuizQuestion(question: 'What is used to make a traditional Omelet?', options: ['Milk', 'Eggs', 'Cheese', 'Bread'], correctIndex: 1),
    QuizQuestion(question: 'Which country is known for its Baguettes?', options: ['Germany', 'France', 'England', 'Italy'], correctIndex: 1),
    QuizQuestion(question: 'What is the main ingredient in Hummus?', options: ['Lentils', 'Chickpeas', 'Beans', 'Peas'], correctIndex: 1),
    QuizQuestion(question: 'Which fruit is red and has seeds on the outside?', options: ['Apple', 'Strawberry', 'Cherry', 'Plum'], correctIndex: 1),
    QuizQuestion(question: 'What drink is made from roasted beans?', options: ['Tea', 'Coffee', 'Juice', 'Soda'], correctIndex: 1),
    QuizQuestion(question: 'Which vegetable is orange and grows in the ground?', options: ['Potato', 'Carrot', 'Onion', 'Broccoli'], correctIndex: 1),
    QuizQuestion(question: 'What is the main ingredient in Tofu?', options: ['Rice', 'Soybeans', 'Corn', 'Wheat'], correctIndex: 1),
    QuizQuestion(question: 'What do you call the morning meal?', options: ['Lunch', 'Dinner', 'Breakfast', 'Snack'], correctIndex: 2),
    QuizQuestion(question: 'Which fruit is often associated with New York City?', options: ['Orange', 'Apple', 'Pear', 'Peach'], correctIndex: 1),
    QuizQuestion(question: 'What is the main ingredient in cheese?', options: ['Water', 'Milk', 'Cream', 'Butter'], correctIndex: 1),
    QuizQuestion(question: 'Which country is famous for its "Paella"?', options: ['Italy', 'Spain', 'Portugal', 'Mexico'], correctIndex: 1),
    QuizQuestion(question: 'What do you use to eat soup?', options: ['Fork', 'Knife', 'Spoon', 'Chopsticks'], correctIndex: 2),

    // --- Pop Culture (20) ---
    QuizQuestion(question: 'Who is known as the "King of Pop"?', options: ['Elvis', 'Michael Jackson', 'Prince', 'Freddie Mercury'], correctIndex: 1),
    QuizQuestion(question: 'Which movie features Jack Sparrow?', options: ['Star Wars', 'Pirates of the Caribbean', 'Harry Potter', 'Avengers'], correctIndex: 1),
    QuizQuestion(question: 'Who played Iron Man?', options: ['Chris Evans', 'Robert Downey Jr.', 'Chris Hemsworth', 'Mark Ruffalo'], correctIndex: 1),
    QuizQuestion(question: 'What is the name of the school in Harry Potter?', options: ['Narnia', 'Hogwarts', 'Middle-earth', 'Neverland'], correctIndex: 1),
    QuizQuestion(question: 'Which animated movie has a character named Elsa?', options: ['Moana', 'Frozen', 'Tangled', 'Brave'], correctIndex: 1),
    QuizQuestion(question: 'Who is the creator of Mickey Mouse?', options: ['Walt Disney', 'Stan Lee', 'Hanna-Barbera', 'Warner'], correctIndex: 0),
    QuizQuestion(question: 'Which superhero is also Bruce Wayne?', options: ['Superman', 'Batman', 'Spider-Man', 'Flash'], correctIndex: 1),
    QuizQuestion(question: 'What is the name of the kingdom in The Lion King?', options: ['Pride Lands', 'Shadow Lands', 'Outlands', 'Far Away'], correctIndex: 0),
    QuizQuestion(question: 'Which singer is known as "Queen Bey"?', options: ['Adele', 'Beyoncé', 'Rihanna', 'Lady Gaga'], correctIndex: 1),
    QuizQuestion(question: 'Which band sang "Yellow Submarine"?', options: ['The Beatles', 'The Rolling Stones', 'Queen', 'ABBA'], correctIndex: 0),
    QuizQuestion(question: 'What is the name of the green ogre in the movies?', options: ['Fiona', 'Donkey', 'Shrek', 'Puss'], correctIndex: 2),
    QuizQuestion(question: 'Who is the "King of Rock and Roll"?', options: ['Michael Jackson', 'Elvis Presley', 'Chuck Berry', 'Jerry Lee Lewis'], correctIndex: 1),
    QuizQuestion(question: 'What is the name of the boy with the lightning scar?', options: ['Percy Jackson', 'Harry Potter', 'Ron Weasley', 'Luke Skywalker'], correctIndex: 1),
    QuizQuestion(question: 'Which movie has a character named Woody?', options: ['Toy Story', 'Finding Nemo', 'Cars', 'Up'], correctIndex: 0),
    QuizQuestion(question: 'Who is the main character in SpongeBob SquarePants?', options: ['Patrick', 'Squidward', 'SpongeBob', 'Sandy'], correctIndex: 2),
    QuizQuestion(question: 'Which city is the setting for "Friends"?', options: ['Chicago', 'Los Angeles', 'New York', 'Boston'], correctIndex: 2),
    QuizQuestion(question: 'What is the name of the giant gorilla?', options: ['Godzilla', 'King Kong', 'Tarzan', 'Mighty Joe'], correctIndex: 1),
    QuizQuestion(question: 'Who sang the hit song "Hello"?', options: ['Adele', 'Taylor Swift', 'Rihanna', 'Katy Perry'], correctIndex: 0),
    QuizQuestion(question: 'Which show features a family in Springfield?', options: ['Family Guy', 'The Simpsons', 'South Park', 'Futurama'], correctIndex: 1),
    QuizQuestion(question: 'What is the name of the pink panther?', options: ['Pinky', 'Panther', 'The Pink Panther', 'Leo'], correctIndex: 2),

    // --- Language & Literature (20) ---
    QuizQuestion(question: 'How many letters are in the English alphabet?', options: ['24', '25', '26', '27'], correctIndex: 2),
    QuizQuestion(question: 'Who wrote the Harry Potter books?', options: ['Tolkien', 'J.K. Rowling', 'Lewis', 'King'], correctIndex: 1),
    QuizQuestion(question: 'What is the first letter of the alphabet?', options: ['A', 'B', 'C', 'Z'], correctIndex: 0),
    QuizQuestion(question: 'What do you call a book about your own life?', options: ['Biography', 'Autobiography', 'Novel', 'Diary'], correctIndex: 1),
    QuizQuestion(question: 'What is a word with the opposite meaning?', options: ['Synonym', 'Antonym', 'Homonym', 'Acronym'], correctIndex: 1),
    QuizQuestion(question: 'Who wrote "Hamlet"?', options: ['Dickens', 'Shakespeare', 'Austen', 'Twain'], correctIndex: 1),
    QuizQuestion(question: 'What is the largest library in the world?', options: ['British Library', 'Library of Congress', 'Vatican', 'China'], correctIndex: 1),
    QuizQuestion(question: 'Which language is spoken in Brazil?', options: ['Spanish', 'Portuguese', 'French', 'English'], correctIndex: 1),
    QuizQuestion(question: 'What do you use to write on a blackboard?', options: ['Pen', 'Pencil', 'Chalk', 'Marker'], correctIndex: 2),
    QuizQuestion(question: 'Who is the main character in "Sherlock Holmes"?', options: ['Watson', 'Sherlock', 'Moriarty', 'Lestrade'], correctIndex: 1),
    QuizQuestion(question: 'What is a group of words that makes sense?', options: ['Letter', 'Word', 'Sentence', 'Paragraph'], correctIndex: 2),
    QuizQuestion(question: 'What do you call a person who writes books?', options: ['Painter', 'Author', 'Singer', 'Doctor'], correctIndex: 1),
    QuizQuestion(question: 'What is the language spoken in Mexico?', options: ['Mexican', 'Spanish', 'Portuguese', 'Latin'], correctIndex: 1),
    QuizQuestion(question: 'Which book is the most sold worldwide?', options: ['Harry Potter', 'The Bible', 'The Hobbit', 'Twilight'], correctIndex: 1),
    QuizQuestion(question: 'What is the last letter of the English alphabet?', options: ['X', 'Y', 'Z', 'W'], correctIndex: 2),
    QuizQuestion(question: 'What do you call a book of maps?', options: ['Dictionary', 'Atlas', 'Encyclopedia', 'Novel'], correctIndex: 1),
    QuizQuestion(question: 'What is a story for children with magic called?', options: ['News', 'Fairy Tale', 'History', 'Report'], correctIndex: 1),
    QuizQuestion(question: 'Which language is known as the "Language of Love"?', options: ['English', 'German', 'French', 'Russian'], correctIndex: 2),
    QuizQuestion(question: 'What do you call the name of a book?', options: ['Title', 'Author', 'Page', 'Cover'], correctIndex: 0),
    QuizQuestion(question: 'How many vowels are in the English alphabet?', options: ['4', '5', '6', '7'], correctIndex: 1),

    // --- Math & Logic (20) ---
    QuizQuestion(question: 'What is 2 + 2?', options: ['3', '4', '5', '6'], correctIndex: 1),
    QuizQuestion(question: 'How many sides does a triangle have?', options: ['2', '3', '4', '5'], correctIndex: 1),
    QuizQuestion(question: 'What is 10 x 10?', options: ['10', '100', '1000', '1'], correctIndex: 1),
    QuizQuestion(question: 'What is half of 100?', options: ['25', '50', '75', '100'], correctIndex: 1),
    QuizQuestion(question: 'How many sides does a square have?', options: ['3', '4', '5', '6'], correctIndex: 1),
    QuizQuestion(question: 'What is 5 + 5 + 5?', options: ['10', '15', '20', '25'], correctIndex: 1),
    QuizQuestion(question: 'How many degrees are in a right angle?', options: ['45', '90', '180', '360'], correctIndex: 1),
    QuizQuestion(question: 'What is 12 divided by 2?', options: ['4', '6', '8', '10'], correctIndex: 1),
    QuizQuestion(question: 'What is 100 - 50?', options: ['25', '50', '75', '100'], correctIndex: 1),
    QuizQuestion(question: 'How many minutes are in an hour?', options: ['30', '45', '60', '90'], correctIndex: 2),
    QuizQuestion(question: 'What is 3 x 3?', options: ['6', '9', '12', '15'], correctIndex: 1),
    QuizQuestion(question: 'How many sides does a hexagon have?', options: ['5', '6', '7', '8'], correctIndex: 1),
    QuizQuestion(question: 'What is 20 + 30?', options: ['40', '50', '60', '70'], correctIndex: 1),
    QuizQuestion(question: 'What is the square root of 9?', options: ['2', '3', '4', '5'], correctIndex: 1),
    QuizQuestion(question: 'How many seconds are in a minute?', options: ['30', '60', '90', '120'], correctIndex: 1),
    QuizQuestion(question: 'What is 100 + 100?', options: ['100', '200', '300', '400'], correctIndex: 1),
    QuizQuestion(question: 'How many sides does an octagon have?', options: ['6', '7', '8', '10'], correctIndex: 2),
    QuizQuestion(question: 'What is 7 x 1?', options: ['1', '7', '8', '0'], correctIndex: 1),
    QuizQuestion(question: 'What is 10 divided by 10?', options: ['0', '1', '10', '100'], correctIndex: 1),
    QuizQuestion(question: 'How many sides does a circle have?', options: ['0', '1', '2', 'Infinite'], correctIndex: 1),

    // --- Animals (20) ---
    QuizQuestion(question: 'Which animal is the fastest on land?', options: ['Lion', 'Cheetah', 'Leopard', 'Horse'], correctIndex: 1),
    QuizQuestion(question: 'What is a baby dog called?', options: ['Kitten', 'Puppy', 'Cub', 'Calf'], correctIndex: 1),
    QuizQuestion(question: 'Which animal gives us milk?', options: ['Dog', 'Cat', 'Cow', 'Lion'], correctIndex: 2),
    QuizQuestion(question: 'How many legs does an insect have?', options: ['4', '6', '8', '10'], correctIndex: 1),
    QuizQuestion(question: 'Which bird is the largest?', options: ['Eagle', 'Ostrich', 'Parrot', 'Penguin'], correctIndex: 1),
    QuizQuestion(question: 'What animal has a long trunk?', options: ['Giraffe', 'Hippo', 'Elephant', 'Rhino'], correctIndex: 2),
    QuizQuestion(question: 'What is a baby cat called?', options: ['Puppy', 'Kitten', 'Cub', 'Kid'], correctIndex: 1),
    QuizQuestion(question: 'Which animal is the tallest?', options: ['Elephant', 'Giraffe', 'Moose', 'Camel'], correctIndex: 1),
    QuizQuestion(question: 'What animal is known for its black and white stripes?', options: ['Tiger', 'Zebra', 'Panda', 'Skunk'], correctIndex: 1),
    QuizQuestion(question: 'Which animal can fly?', options: ['Dog', 'Cat', 'Bird', 'Fish'], correctIndex: 2),
    QuizQuestion(question: 'What do you call a baby cow?', options: ['Puppy', 'Kitten', 'Calf', 'Foal'], correctIndex: 2),
    QuizQuestion(question: 'Which animal is known as the "Ship of the Desert"?', options: ['Horse', 'Camel', 'Elephant', 'Donkey'], correctIndex: 1),
    QuizQuestion(question: 'What is the largest animal in the ocean?', options: ['Shark', 'Dolphin', 'Blue Whale', 'Octopus'], correctIndex: 2),
    QuizQuestion(question: 'Which animal barks?', options: ['Cat', 'Dog', 'Bird', 'Cow'], correctIndex: 1),
    QuizQuestion(question: 'Which animal meows?', options: ['Dog', 'Cat', 'Lion', 'Tiger'], correctIndex: 1),
    QuizQuestion(question: 'Which animal jumps and has a pouch?', options: ['Koala', 'Kangaroo', 'Panda', 'Monkey'], correctIndex: 1),
    QuizQuestion(question: 'What animal is slow and has a hard shell?', options: ['Snail', 'Turtle', 'Crab', 'Spider'], correctIndex: 1),
    QuizQuestion(question: 'Which animal produces wool?', options: ['Cow', 'Sheep', 'Goat', 'Horse'], correctIndex: 1),
    QuizQuestion(question: 'Which animal is famous for its long neck?', options: ['Ostrich', 'Giraffe', 'Swan', 'Snake'], correctIndex: 1),
    QuizQuestion(question: 'What animal lives in a hive and makes honey?', options: ['Ant', 'Fly', 'Bee', 'Wasp'], correctIndex: 2),
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
}
