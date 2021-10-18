using System;
using System.Collections.Generic;
using System.Text;

namespace Hangman
{
    class Program
    {
        static void Main(string[] args)
        {
            Random random = new Random((int)DateTime.Now.Ticks);

            string[] wordBank = { "Blue", "Purple", "Red", "Orange", "Pink" };

            string wordToGuess = wordBank[random.Next(0, wordBank.Length)];
            string wordToGuessUppercase = wordToGuess.ToUpper();

            StringBuilder displayToPlayer = new StringBuilder(wordToGuess.Length);
            for (int i = 0; i < wordToGuess.Length; i++)
                displayToPlayer.Append('_');

            List<char> correctGuesses = new List<char>();
            List<char> incorrectGuesses = new List<char>();

            int lives = 5;
            bool won = false;
            int lettersRevealed = 0;

            string input;
            char guess;

            while (!won && lives > 0)
            {
                Console.WriteLine("Guess a Letter: ");

                input = Console.ReadLine().ToUpper();
                guess = input[0];

                if (correctGuesses.Contains(guess))
                {
                    Console.WriteLine("You've already tried '{0}', and it was correct!", guess);
                    continue;
                }
                else if (incorrectGuesses.Contains(guess))
                {
                    Console.WriteLine("You've already tried '{0}', and it was wrong!", guess);
                    continue;
                }

                if(wordToGuessUppercase.Contains(guess))
                {
                    correctGuesses.Add(guess);

                    for (int i = 0; i < wordToGuess.Length; i++)
                    {
                        if (wordToGuessUppercase[i] == guess)
                        {
                            displayToPlayer[i] = wordToGuess[i];
                            lettersRevealed++;
                        }
                    }

                    if (lettersRevealed == wordToGuess.Length)
                        won = true;
                }
                else
                {
                    incorrectGuesses.Add(guess);
                    Console.WriteLine("Nope, there's no '{0}' in it!", guess);
                    lives--;
                }

                Console.WriteLine(displayToPlayer.ToString());
            }

            if (won)
                Console.WriteLine("You won!");
            else
                Console.WriteLine("You lost! It was '{0}'", wordToGuess);

            Console.Write("Press ENTER to exit....");
            Console.ReadLine();
        }
    }
}
