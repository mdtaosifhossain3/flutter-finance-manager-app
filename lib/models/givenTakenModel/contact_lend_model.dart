class ContactLend {
  final int? id;
  final String name;
  final String? phone;
  final String? address;
  final int totalGiven;
  final int totalTaken;
  final int balance;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? imagePath;

  ContactLend({
    this.id,
    required this.name,
    this.phone,
    this.address,
    this.totalGiven = 0,
    this.totalTaken = 0,
    this.balance = 0,
    required this.createdAt,
    required this.updatedAt,
    this.imagePath,
  });

  /// Convert to Map for database storage
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'phone': phone,
      'address': address,
      'total_given': totalGiven,
      'total_taken': totalTaken,
      'balance': balance,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'image_path': imagePath,
    };
  }

  /// Create from database Map
  factory ContactLend.fromMap(Map<String, dynamic> map) {
    return ContactLend(
      id: map['id'] as int?,
      name: map['name'] as String,
      phone: map['phone'] as String?,
      address: map['address'] as String?,
      totalGiven: map['total_given'] as int? ?? 0,
      totalTaken: map['total_taken'] as int? ?? 0,
      balance: map['balance'] as int? ?? 0,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
      imagePath: map['image_path'] as String?,
    );
  }

  /// Create a copy with some fields updated
  ContactLend copyWith({
    int? id,
    String? name,
    String? phone,
    String? address,
    int? totalGiven,
    int? totalTaken,
    int? balance,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? imagePath,
  }) {
    return ContactLend(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      totalGiven: totalGiven ?? this.totalGiven,
      totalTaken: totalTaken ?? this.totalTaken,
      balance: balance ?? this.balance,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  @override
  String toString() {
    return 'ContactLend(id: $id, name: $name, balance: $balance)';
  }
}
