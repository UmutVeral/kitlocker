enum LockerSortOption { dateAdded, teamAlphabetic, seasonChronological }

class LockerSortState {
  const LockerSortState({
    this.option = LockerSortOption.dateAdded,
    this.favoritesFirst = true,
  });

  final LockerSortOption option;
  final bool favoritesFirst;

  LockerSortState copyWith({
    LockerSortOption? option,
    bool? favoritesFirst,
  }) =>
      LockerSortState(
        option: option ?? this.option,
        favoritesFirst: favoritesFirst ?? this.favoritesFirst,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LockerSortState &&
          option == other.option &&
          favoritesFirst == other.favoritesFirst;

  @override
  int get hashCode => Object.hash(option, favoritesFirst);
}
