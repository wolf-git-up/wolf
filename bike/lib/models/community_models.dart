enum FriendRequestStatus { pending, accepted, rejected }

enum InvitationStatus { active, used }

class FriendRequest {
  final String id;
  final String senderId;
  final String receiverId;
  final String senderName;
  final String senderEmail;
  final String receiverName;
  final String receiverEmail;
  final FriendRequestStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const FriendRequest({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.senderName,
    required this.senderEmail,
    required this.receiverName,
    required this.receiverEmail,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  FriendRequest copyWith({FriendRequestStatus? status, DateTime? updatedAt}) =>
      FriendRequest(
        id: id,
        senderId: senderId,
        receiverId: receiverId,
        senderName: senderName,
        senderEmail: senderEmail,
        receiverName: receiverName,
        receiverEmail: receiverEmail,
        status: status ?? this.status,
        createdAt: createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'senderId': senderId,
    'receiverId': receiverId,
    'senderName': senderName,
    'senderEmail': senderEmail,
    'receiverName': receiverName,
    'receiverEmail': receiverEmail,
    'status': status.name,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory FriendRequest.fromJson(Map<String, dynamic> json) => FriendRequest(
    id: json['id'] as String,
    senderId: json['senderId'] as String,
    receiverId: json['receiverId'] as String,
    senderName: json['senderName'] as String,
    senderEmail: json['senderEmail'] as String,
    receiverName: json['receiverName'] as String,
    receiverEmail: json['receiverEmail'] as String,
    status: FriendRequestStatus.values.byName(json['status'] as String),
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
  );
}

class SquadInvitation {
  final String id;
  final String squadId;
  final String squadName;
  final String createdBy;
  final String code;
  final DateTime createdAt;
  final DateTime expiresAt;
  final InvitationStatus status;

  const SquadInvitation({
    required this.id,
    required this.squadId,
    required this.squadName,
    required this.createdBy,
    required this.code,
    required this.createdAt,
    required this.expiresAt,
    required this.status,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  SquadInvitation copyWith({InvitationStatus? status}) => SquadInvitation(
    id: id,
    squadId: squadId,
    squadName: squadName,
    createdBy: createdBy,
    code: code,
    createdAt: createdAt,
    expiresAt: expiresAt,
    status: status ?? this.status,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'squadId': squadId,
    'squadName': squadName,
    'createdBy': createdBy,
    'code': code,
    'createdAt': createdAt.toIso8601String(),
    'expiresAt': expiresAt.toIso8601String(),
    'status': status.name,
  };

  factory SquadInvitation.fromJson(Map<String, dynamic> json) =>
      SquadInvitation(
        id: json['id'] as String,
        squadId: json['squadId'] as String,
        squadName: json['squadName'] as String,
        createdBy: json['createdBy'] as String,
        code: json['code'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        expiresAt: DateTime.parse(json['expiresAt'] as String),
        status: InvitationStatus.values.byName(json['status'] as String),
      );
}
