/// 用户性别（新手基础信息收集）。
enum UserGender {
  female('女生'),
  male('男生');

  const UserGender(this.label);

  final String label;
}

/// 用户年龄段（新手基础信息收集）。
enum UserAgeRange {
  under18('17岁以下'),
  age18to25('18-25岁'),
  age26to40('26-40岁'),
  over40('41岁以上');

  const UserAgeRange(this.label);

  final String label;
}
