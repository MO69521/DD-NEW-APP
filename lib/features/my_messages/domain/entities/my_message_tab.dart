/// 我的消息 Tab 类型。
enum MyMessageTab {
  reply('回复'),
  like('获赞'),
  notification('通知');

  const MyMessageTab(this.label);

  final String label;
}
