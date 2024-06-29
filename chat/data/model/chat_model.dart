class ChatModel {
  final String email;
  final String image;
  final String name;
  final senderId;
  final receiverId;
  ChatModel(
      {required this.email,
      required this.image,
      required this.name,
      required this.receiverId,
      required this.senderId});
}
