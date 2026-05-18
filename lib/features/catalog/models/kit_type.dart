enum KitType {
  home,
  away,
  third;

  String get label => switch (this) {
        KitType.home => 'İç saha',
        KitType.away => 'Deplasman',
        KitType.third => 'Üçüncü',
      };
}
