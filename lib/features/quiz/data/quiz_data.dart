import '../models/quiz_question.dart';

class QuizData {
  static const Map<String, List<QuizQuestion>> questionsByCategory = {
    'Football': [
      QuizQuestion(
        question: 'Which soccer team won the FIFA World Cup for the first time?',
        options: ['Uruguay', 'Brazil', 'Italy', 'Germany'],
        correctIndex: 0,
      ),
      QuizQuestion(
        question: 'How many players are on a standard football team on the field?',
        options: ['9', '10', '11', '12'],
        correctIndex: 2,
      ),
      QuizQuestion(
        question: 'Which country has won the most FIFA World Cup titles?',
        options: ['Germany', 'Argentina', 'Brazil', 'France'],
        correctIndex: 2,
      ),
      QuizQuestion(
        question: 'What is the maximum duration of a standard football match?',
        options: ['80 minutes', '90 minutes', '100 minutes', '120 minutes'],
        correctIndex: 1,
      ),
      QuizQuestion(
        question: 'Which player has won the most Ballon d\'Or awards?',
        options: ['Cristiano Ronaldo', 'Lionel Messi', 'Ronaldinho', 'Zinedine Zidane'],
        correctIndex: 1,
      ),
    ],
    'Science': [
      QuizQuestion(
        question: 'What is the chemical symbol for water?',
        options: ['WA', 'H2O', 'HO2', 'OHH'],
        correctIndex: 1,
      ),
      QuizQuestion(
        question: 'How many bones are in the adult human body?',
        options: ['196', '206', '216', '226'],
        correctIndex: 1,
      ),
      QuizQuestion(
        question: 'What planet is known as the Red Planet?',
        options: ['Venus', 'Jupiter', 'Mars', 'Saturn'],
        correctIndex: 2,
      ),
      QuizQuestion(
        question: 'What is the speed of light in a vacuum?',
        options: ['299,792 km/s', '199,792 km/s', '399,792 km/s', '499,792 km/s'],
        correctIndex: 0,
      ),
      QuizQuestion(
        question: 'What is the powerhouse of the cell?',
        options: ['Nucleus', 'Ribosome', 'Mitochondria', 'Golgi apparatus'],
        correctIndex: 2,
      ),
    ],
    'Fashion': [
      QuizQuestion(
        question: 'Which fashion house created the iconic "little black dress"?',
        options: ['Dior', 'Chanel', 'Versace', 'Gucci'],
        correctIndex: 1,
      ),
      QuizQuestion(
        question: 'What city is considered the fashion capital of the world?',
        options: ['New York', 'London', 'Milan', 'Paris'],
        correctIndex: 3,
      ),
      QuizQuestion(
        question: 'Which material is known as the "fabric of our lives"?',
        options: ['Silk', 'Wool', 'Cotton', 'Polyester'],
        correctIndex: 2,
      ),
      QuizQuestion(
        question: 'What does "haute couture" literally mean?',
        options: ['High fashion', 'Fine sewing', 'Luxury wear', 'Custom design'],
        correctIndex: 1,
      ),
      QuizQuestion(
        question: 'Which brand is famous for its red-soled shoes?',
        options: ['Jimmy Choo', 'Manolo Blahnik', 'Christian Louboutin', 'Valentino'],
        correctIndex: 2,
      ),
    ],
    'Movie': [
      QuizQuestion(
        question: 'Which film won the first Academy Award for Best Picture?',
        options: ['Wings', 'Sunrise', 'The Jazz Singer', 'Chang'],
        correctIndex: 0,
      ),
      QuizQuestion(
        question: 'Who directed the movie "Inception"?',
        options: ['Steven Spielberg', 'James Cameron', 'Christopher Nolan', 'Ridley Scott'],
        correctIndex: 2,
      ),
      QuizQuestion(
        question: 'What is the highest-grossing film of all time?',
        options: ['Titanic', 'Avengers: Endgame', 'Avatar', 'Star Wars'],
        correctIndex: 2,
      ),
      QuizQuestion(
        question: 'In which year was the first Star Wars film released?',
        options: ['1975', '1977', '1979', '1981'],
        correctIndex: 1,
      ),
      QuizQuestion(
        question: 'Which actor played Iron Man in the Marvel Cinematic Universe?',
        options: ['Chris Evans', 'Chris Hemsworth', 'Robert Downey Jr.', 'Mark Ruffalo'],
        correctIndex: 2,
      ),
    ],
    'Music': [
      QuizQuestion(
        question: 'How many strings does a standard guitar have?',
        options: ['4', '5', '6', '7'],
        correctIndex: 2,
      ),
      QuizQuestion(
        question: 'Which band is known as the "Fab Four"?',
        options: ['The Rolling Stones', 'The Beatles', 'Led Zeppelin', 'Pink Floyd'],
        correctIndex: 1,
      ),
      QuizQuestion(
        question: 'What is the best-selling album of all time?',
        options: ['Thriller', 'Back in Black', 'The Dark Side of the Moon', 'Hotel California'],
        correctIndex: 0,
      ),
      QuizQuestion(
        question: 'Which instrument has 88 keys?',
        options: ['Organ', 'Harpsichord', 'Piano', 'Synthesizer'],
        correctIndex: 2,
      ),
      QuizQuestion(
        question: 'Who is known as the "Queen of Pop"?',
        options: ['Beyoncé', 'Madonna', 'Lady Gaga', 'Rihanna'],
        correctIndex: 1,
      ),
    ],
  };
}
