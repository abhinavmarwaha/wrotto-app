enum Mood { crying, sad, neutral, happy, grin }

Mood fromEmoji(String emoji) {
  switch (emoji) {
    case '😢':
      return Mood.crying;
    default:
      return null;
  }
}

extension MoodExtensions on Mood {
  String toEmoji() {
    switch (this) {
      case Mood.crying:
        return '😢';
      case Mood.sad:
        return '🙁';
      case Mood.neutral:
        return '😐';
      case Mood.happy:
        return '🙂';
      case Mood.grin:
        return '😁';
      default:
        return null;
    }
  }

  String toShortString() {
    return this.toString().substring(this.toString().indexOf('.') + 1);
  }
}
