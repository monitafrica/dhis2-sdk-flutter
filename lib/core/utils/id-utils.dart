import 'dart:math';

String makeid() {
  var text = '';
  var rng = new Random();
  const first_letter_possible_combinations =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
  const possible_combinations =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  for (var i = 0; i < 11; i++) {
    if (i == 0) {
      text += first_letter_possible_combinations[rng.nextInt(first_letter_possible_combinations.length)];
    } else {
      text += possible_combinations[rng.nextInt(possible_combinations.length)];
    }
  }
  return text;
}