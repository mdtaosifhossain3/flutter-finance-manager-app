class FestivalItem {
  final String key;
  final int amount;

  const FestivalItem(this.key, this.amount);
}

class FestivalTemplate {
  final String key;
  final String emoji;
  final List<FestivalItem> items;

  /// Known upcoming dates. Islamic dates are estimates and move with the
  /// moon sighting, so the user can always change the date.
  final List<DateTime> dates;
  final bool dateIsEstimate;

  const FestivalTemplate({
    required this.key,
    required this.emoji,
    required this.items,
    this.dates = const [],
    this.dateIsEstimate = false,
  });

  DateTime? nextDate(DateTime now) {
    for (final d in dates) {
      if (d.isAfter(now)) return d;
    }
    return null;
  }
}

final festivalTemplates = <FestivalTemplate>[
  FestivalTemplate(
    key: 'fest_eid_ul_fitr',
    emoji: '🌙',
    dateIsEstimate: true,
    dates: [DateTime(2027, 3, 10), DateTime(2028, 2, 27), DateTime(2029, 2, 15)],
    items: const [
      FestivalItem('fest_item_clothes', 8000),
      FestivalItem('fest_item_salami', 3000),
      FestivalItem('fest_item_food_guests', 4000),
      FestivalItem('fest_item_travel_home', 3000),
      FestivalItem('fest_item_fitra_zakat', 1000),
    ],
  ),
  FestivalTemplate(
    key: 'fest_eid_ul_adha',
    emoji: '🐄',
    dateIsEstimate: true,
    dates: [DateTime(2027, 5, 17), DateTime(2028, 5, 5), DateTime(2029, 4, 24)],
    items: const [
      FestivalItem('fest_item_qurbani', 60000),
      FestivalItem('fest_item_butcher_spices', 5000),
      FestivalItem('fest_item_clothes', 5000),
      FestivalItem('fest_item_travel_home', 3000),
    ],
  ),
  FestivalTemplate(
    key: 'fest_ramadan',
    emoji: '🕌',
    dateIsEstimate: true,
    dates: [DateTime(2027, 2, 8), DateTime(2028, 1, 28), DateTime(2029, 1, 16)],
    items: const [
      FestivalItem('fest_item_iftar', 6000),
      FestivalItem('fest_item_sehri', 4000),
      FestivalItem('fest_item_iftar_party', 3000),
      FestivalItem('fest_item_charity', 2000),
    ],
  ),
  const FestivalTemplate(
    key: 'fest_durga_puja',
    emoji: '🪔',
    items: [
      FestivalItem('fest_item_clothes', 7000),
      FestivalItem('fest_item_puja_items', 3000),
      FestivalItem('fest_item_food_guests', 4000),
      FestivalItem('fest_item_travel_home', 2000),
    ],
  ),
  FestivalTemplate(
    key: 'fest_pohela_boishakh',
    emoji: '🎉',
    dates: [DateTime(2027, 4, 14), DateTime(2028, 4, 14), DateTime(2029, 4, 14)],
    items: const [
      FestivalItem('fest_item_clothes', 3000),
      FestivalItem('fest_item_food_guests', 1500),
      FestivalItem('fest_item_outing', 1000),
    ],
  ),
  FestivalTemplate(
    key: 'fest_school_admission',
    emoji: '🎒',
    dates: [DateTime(2027, 1, 1), DateTime(2028, 1, 1), DateTime(2029, 1, 1)],
    items: const [
      FestivalItem('fest_item_admission_fee', 10000),
      FestivalItem('fest_item_books', 3000),
      FestivalItem('fest_item_uniform', 2500),
      FestivalItem('fest_item_coaching', 3000),
    ],
  ),
];
