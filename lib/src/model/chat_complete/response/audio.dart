class Audio {
  final int? expiresAt;
  final String? id;
  final String? data;
  final String? transcript;

  Audio({
    this.expiresAt,
    this.id,
    this.data,
    this.transcript,
  });

  Audio copyWith({
    int? expiresAt,
    String? id,
    String? data,
    String? transcript,
  }) =>
      Audio(
        expiresAt: expiresAt ?? this.expiresAt,
        id: id ?? this.id,
        data: data ?? this.data,
        transcript: transcript ?? this.transcript,
      );

  factory Audio.fromJson(Map<String, dynamic> json) => Audio(
        expiresAt: json["expires_at"],
        id: json["id"],
        data: json["data"],
        transcript: json["transcript"],
      );

  Map<String, dynamic> toJson() => {
        "expires_at": expiresAt,
        "id": id,
        "data": data,
        "transcript": transcript,
      };
}
