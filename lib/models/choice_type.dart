enum ChoiceType { follow, argue, rebel }

extension ChoiceTypeExtension on ChoiceType {
  String get name {
    switch (this) {
      case ChoiceType.follow:
        return 'follow';
      case ChoiceType.argue:
        return 'argue';
      case ChoiceType.rebel:
        return 'rebel';
    }
  }

  String get displayLabel {
    switch (this) {
      case ChoiceType.follow:
        return 'FOLLOW';
      case ChoiceType.argue:
        return 'ARGUE';
      case ChoiceType.rebel:
        return 'REBEL';
    }
  }

  String get emoji {
    switch (this) {
      case ChoiceType.follow:
        return '✅';
      case ChoiceType.argue:
        return '🗣️';
      case ChoiceType.rebel:
        return '😈';
    }
  }

  static ChoiceType fromName(String value) {
    switch (value) {
      case 'follow':
        return ChoiceType.follow;
      case 'argue':
        return ChoiceType.argue;
      case 'rebel':
        return ChoiceType.rebel;
      default:
        return ChoiceType.follow;
    }
  }
}
