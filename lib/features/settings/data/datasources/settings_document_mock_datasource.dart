import '../../domain/entities/settings_document.dart';

class SettingsDocumentMockDataSource {
  const SettingsDocumentMockDataSource();

  SettingsDocument fetchDocument(SettingsDocumentType type) {
    return switch (type) {
      SettingsDocumentType.userAgreement => _userAgreement,
      SettingsDocumentType.privacyPolicy => _privacyPolicy,
      SettingsDocumentType.thirdPartySharing => _thirdPartySharing,
    };
  }

  static const SettingsDocument _userAgreement = SettingsDocument(
    type: SettingsDocumentType.userAgreement,
    heading: '《点点穿书》平台使用许可及服务协议',
    updatedAt: '更新日期：2026-07-01',
    sections: [
      SettingsDocumentSection(
        title: '前言',
        body:
            '欢迎使用点点穿书平台。你在注册、登录或使用本平台服务前，应认真阅读并充分理解本协议内容。你点击同意或继续使用服务，即表示你已接受本协议。',
      ),
      SettingsDocumentSection(
        title: '服务内容',
        body: '点点穿书为用户提供互动阅读、虚拟角色陪伴、书籍推荐、会员权益和虚拟道具等服务。平台可根据运营安排对服务形态进行升级或调整。',
      ),
      SettingsDocumentSection(
        title: '用户行为规范',
        body: '你不得发布违法、侵权、骚扰、诱导交易或破坏平台秩序的内容，不得通过外挂、脚本、漏洞等方式影响服务公平性。',
      ),
      SettingsDocumentSection(
        title: '账号与安全',
        body: '你应妥善保管账号、验证码和登录设备。因用户主动泄露、共享账号或使用非官方渠道导致的损失，由用户自行承担。',
      ),
      SettingsDocumentSection(
        title: '协议变更',
        body: '平台可依据法律法规或业务变化更新本协议。更新后将通过站内公告、弹窗或页面提示等方式告知用户。',
      ),
    ],
  );

  static const SettingsDocument _privacyPolicy = SettingsDocument(
    type: SettingsDocumentType.privacyPolicy,
    heading: '《点点穿书》隐私政策',
    updatedAt: '更新日期：2026-07-01',
    sections: [
      SettingsDocumentSection(
        title: '我们如何收集信息',
        body: '为保障账号登录、内容推荐、阅读记录同步、订单处理和客服反馈等功能，我们会收集必要的账号信息、设备信息、操作日志和交易记录。',
      ),
      SettingsDocumentSection(
        title: '我们如何使用信息',
        body: '收集的信息将用于提供基础服务、优化阅读体验、保障账号与交易安全、处理用户反馈，以及在取得授权后进行个性化推荐。',
      ),
      SettingsDocumentSection(
        title: '信息共享与委托处理',
        body: '除法律法规要求或实现必要功能外，我们不会向第三方出售你的个人信息。涉及支付、推送、统计等能力时，会与合规合作方共享必要字段。',
      ),
      SettingsDocumentSection(
        title: '你的权利',
        body: '你可以访问、更正、删除你的部分个人信息，也可以在设置中管理个性化推荐、通知和授权状态。',
      ),
      SettingsDocumentSection(
        title: '未成年人保护',
        body: '我们重视未成年人信息保护。未成年人使用平台前，应在监护人指导下阅读并同意本政策。',
      ),
    ],
  );

  static const SettingsDocument _thirdPartySharing = SettingsDocument(
    type: SettingsDocumentType.thirdPartySharing,
    heading: '第三方服务共享清单',
    updatedAt: '更新日期：2026-07-01',
    sections: [
      SettingsDocumentSection(
        title: '支付服务',
        body: '为完成充值和订单支付，我们可能向微信支付、支付宝等支付服务方共享订单号、支付金额、商品名称和必要设备信息。',
      ),
      SettingsDocumentSection(
        title: '消息推送',
        body: '为向你发送书籍更新、福利领取和账号安全提醒，我们可能接入系统推送或第三方推送服务，仅共享推送所需的设备标识与通知状态。',
      ),
      SettingsDocumentSection(
        title: '统计分析',
        body: '为了解功能稳定性和页面访问情况，我们可能使用统计分析服务处理去标识化的设备信息、崩溃日志和页面访问事件。',
      ),
      SettingsDocumentSection(
        title: '客服与反馈',
        body: '当你提交问题反馈时，我们可能将问题类型、联系方式、设备型号和日志信息提供给客服系统用于定位和处理问题。',
      ),
    ],
  );
}
