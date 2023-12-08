class Bookmark {
  final String identify;
  final int id;
  final int api_id;

  Bookmark({required this.identify, required this.id, required this.api_id});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'indentify': identify,
      'api_id': api_id,
    };
  }
  
  @override
  String toString() {
    return 'Bookmark{id: $id, identify: $identify,  api_id: $api_id}';
  }
}
