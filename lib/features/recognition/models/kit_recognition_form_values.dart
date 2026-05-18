class KitRecognitionFormValues {
  const KitRecognitionFormValues({
    required this.teamName,
    required this.season,
    this.playerName,
    this.number,
  });

  final String teamName;
  final String season;
  final String? playerName;
  final String? number;
}
