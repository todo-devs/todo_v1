class ApklisInfo {
  final String packageName;
  final double rating;
  final int downloadCount;
  final String versionName;
  final String published;

  ApklisInfo({
    this.packageName,
    this.rating,
    this.downloadCount,
    this.versionName,
    this.published,
  });
  factory ApklisInfo.fromJson(Map<String, dynamic> json) {
    return ApklisInfo(
      packageName: json["package_name"],
      rating: json["rating"] as double,
      downloadCount: json["download_count"] as int,
      versionName: json["last_release"]["version_name"],
      published: json["last_release"]["published"],
    );
  }

  Map toJson() => {
        'package_name': packageName,
        'rating': rating,
        'download_count': downloadCount,
        'version_name': versionName,
        'published': published,
      };
}
