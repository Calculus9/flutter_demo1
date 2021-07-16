class SearchHistory {
  int id;
  String keyword;
  int time;

  SearchHistory(this.keyword, {this.id, this.time});

  SearchHistory.fromMap(Map<String, dynamic> map) {
    this.keyword = map['keyword'];
    this.id = map['id'];
    this.time = map['time'];
  }

  Map<String, dynamic> toMap() => {'keyword': keyword, 'id': id, 'time': time};
}
