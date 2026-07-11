import { useState, type CSSProperties, type ReactNode } from "react";
import {
  Stack,
  Row,
  Grid,
  H1,
  H3,
  Text,
  Code,
  Table,
  Callout,
  Divider,
  Pill,
  Stat,
  useHostTheme,
  useCanvasState,
  useCanvasAction,
  mergeStyle,
} from "cursor/canvas";

/**
 * 点点穿书 · 深色 UI 设计规范
 * 来源：lib/core/theme/*.dart（token）与 lib/shared/*（组件）。
 * 本文件是「可视化目录」：真源仍是 Dart 代码，每个条目附源码路径（可点击打开）。
 */

// 应用真实品牌色值 / 关键尺寸（还原深色 UI 观感，数值对齐 lib/core/theme）。
const APP = {
  bg: "#090E17",
  surface: "rgba(255,255,255,0.04)", // white04
  glass: "rgba(255,255,255,0.04)", // white04 · surfaceGlass
  navBg: "rgba(255,255,255,0.20)", // white20 · navBarBackground
  border: "rgba(255,255,255,0.08)",
  panelEdge: "rgba(255,255,255,0.10)",
  accent: "#FFE847",
  onAccent: "#131820",
  dialogBg: "#131820",
  text: "#FFFFFF",
  textMuted: "rgba(255,255,255,0.60)",
  segFill: "rgba(255,232,71,0.10)",
  hair: "0.5px", // AppSizes.hairline
};

/* ───────────────── 筛选：分区注册表 ───────────────── */

type PartId = "01" | "02" | "03";
type PartFilter = PartId | "all";

const PARTS: Record<PartId, { title: string; subtitle: string; label: string }> = {
  "01": {
    title: "视觉基础规范",
    subtitle: "字号 · 行高 · 字重 · 字体族 · 颜色 · 间距 · 圆角",
    label: "视觉基础",
  },
  "02": {
    title: "组件规范与样式展现",
    subtitle: "每个组件独占一行 · 可点击体验 · 附源码入口",
    label: "组件",
  },
  "03": {
    title: "动效与特殊设计",
    subtitle: "全局自定义动效 / 特殊视觉索引 · 约 50 项 · 点源码路径打开真源",
    label: "动效",
  },
};

interface SpecEntry {
  part: PartId;
  title: string;
  keywords: string;
  render: ReactNode;
}

export default function DesignSystemSpec() {
  const [activePart, setActivePart] = useCanvasState<PartFilter>("specPart", "all");

  const filtering = activePart !== "all";

  // 01 / 02 分区条目（03 动效由结构化数据单独渲染）。
  const entries: SpecEntry[] = [
    { part: "01", title: "字号", keywords: "", render: <TypeScaleSection /> },
    { part: "01", title: "行高", keywords: "", render: <LineHeightSection /> },
    { part: "01", title: "字重", keywords: "", render: <WeightSection /> },
    { part: "01", title: "字体族", keywords: "", render: <FontFamilySection /> },
    { part: "01", title: "颜色", keywords: "", render: <ColorSection /> },
    { part: "01", title: "间距", keywords: "", render: <SpacingSection /> },
    { part: "01", title: "圆角", keywords: "", render: <RadiusSection /> },
    { part: "01", title: "组件尺寸 token", keywords: "", render: <SizeIndexSection /> },
    { part: "02", title: "按压反馈", keywords: "", render: <PressableSection /> },
    { part: "02", title: "按钮", keywords: "", render: <ButtonSection /> },
    { part: "02", title: "卡片", keywords: "", render: <CardSection /> },
    { part: "02", title: "角标", keywords: "", render: <CornerBadgeSection /> },
    { part: "02", title: "弹窗", keywords: "", render: <DialogSection /> },
    { part: "02", title: "底部弹层", keywords: "", render: <SheetSection /> },
    { part: "02", title: "顶栏", keywords: "", render: <TopBarSection /> },
    { part: "02", title: "底部导航", keywords: "", render: <BottomNavSection /> },
    { part: "02", title: "分段切换", keywords: "", render: <SegmentedSection /> },
    { part: "02", title: "选中指示线", keywords: "", render: <TabIndicatorSection /> },
    { part: "02", title: "搜索框", keywords: "", render: <SearchSection /> },
    { part: "02", title: "开关", keywords: "", render: <SwitchSection /> },
    { part: "02", title: "选项选择", keywords: "", render: <OptionSelectSection /> },
    { part: "02", title: "扫光高亮层", keywords: "", render: <SweepHighlightSection /> },
    { part: "02", title: "轻提示", keywords: "", render: <ToastSection /> },
    { part: "02", title: "空状态", keywords: "", render: <EmptyStateSection /> },
    { part: "02", title: "异步门闸", keywords: "", render: <AsyncPageBodySection /> },
    { part: "02", title: "分组列表卡", keywords: "", render: <GroupedListCardSection /> },
    { part: "02", title: "导航列表行", keywords: "", render: <NavigationListRowSection /> },
    { part: "02", title: "加载更多脚", keywords: "", render: <ListLoadMoreFooterSection /> },
    { part: "02", title: "区块标题", keywords: "", render: <SectionHeaderSection /> },
  ];

  const matchPart = (p: PartId) => activePart === "all" || activePart === p;
  const visibleEntries = entries.filter((e) => matchPart(e.part));
  const motionVisible = matchPart("03");

  return (
    <Stack gap={28} style={{ padding: 32, maxWidth: 1040 }}>
      <CoverHeader />

      <FilterBar activePart={activePart} onPart={setActivePart} />

      {filtering ? null : (
        <>
          <SummaryStats />
          <Callout tone="warning" title="关于「改一处，全局生效」">
            <Stack gap={4}>
              <Text>
                这份可视化文档是 <Text weight="semibold">组件目录 / 预览</Text>
                ，用于对照与定位；它本身是 React 手写近似，<Text weight="semibold">不是</Text>
                应用的运行源码，也<Text weight="semibold">不会</Text>像素级复刻 Flutter 渲染。
              </Text>
              <Text>
                真正「改一处即全局生效」的源头是 Dart：设计 token 在{" "}
                <Code>lib/core/theme/*</Code>，共享组件在 <Code>lib/shared/*</Code>。
                画廊与 APP 观感不一致时，以源码路径打开的 Flutter 组件为准。
              </Text>
              <Text>
                用法：在下方找到组件 → 点它的「源码」路径打开真源 → 告诉我要改什么，我改这一处 Dart，页面即全局更新。
              </Text>
            </Stack>
          </Callout>
        </>
      )}

      {(["01", "02"] as PartId[]).map((p) => {
        const partEntries = visibleEntries.filter((e) => e.part === p);
        if (partEntries.length === 0) return null;
        return (
          <div key={p}>
            <Stack gap={28}>
              <PartBanner index={p} title={PARTS[p].title} subtitle={PARTS[p].subtitle} />
              {partEntries.map((e) => (
                <div key={e.title}>{e.render}</div>
              ))}
            </Stack>
          </div>
        );
      })}

      {motionVisible ? (
        <div>
          <Stack gap={28}>
            <PartBanner
              index="03"
              title={PARTS["03"].title}
              subtitle={PARTS["03"].subtitle}
            />
            <MotionGallerySection />
          </Stack>
        </div>
      ) : null}

      {filtering ? null : (
        <>
          <Divider />
          <Callout tone="info" title="使用约定">
            <Stack gap={4}>
              <Text>
                1. 界面只用 token：禁止 <Code>Color(0x…)</Code> / <Code>fontSize 数字</Code> /
                <Code>EdgeInsets 数字</Code> / <Code>BorderRadius.circular 数字</Code>。
              </Text>
              <Text>
                2. 单一真源：token → <Code>lib/core/theme/*</Code>；组件 →{" "}
                <Code>lib/shared/*</Code>。改源即全局。
              </Text>
              <Text>
                3. 新增即询问：任何超出本文档的新 token、新变体、新组件，先确认再落地，并同步本文档。
              </Text>
            </Stack>
          </Callout>
        </>
      )}
    </Stack>
  );
}

/* ───────────────── 顶部分区切换（吸顶 · 仅 tab）───────────────── */

function FilterBar({
  activePart,
  onPart,
}: {
  activePart: PartFilter;
  onPart: (v: PartFilter) => void;
}) {
  const theme = useHostTheme();
  const chips: Array<{ id: PartFilter; label: string }> = [
    { id: "all", label: "全部" },
    { id: "01", label: PARTS["01"].label },
    { id: "02", label: PARTS["02"].label },
    { id: "03", label: PARTS["03"].label },
  ];
  return (
    <div
      style={{
        position: "sticky",
        top: 0,
        zIndex: 20,
        background: theme.bg.editor,
        marginLeft: -32,
        marginRight: -32,
        padding: "10px 32px",
      }}
    >
      <Row gap={8} wrap>
        {chips.map((c) => {
          const active = activePart === c.id;
          return (
            <SelectableItem
              key={c.id}
              active={active}
              onClick={() => onPart(c.id)}
              activeColor={APP.onAccent}
              fontSize={13}
              style={{
                padding: "7px 14px",
                borderRadius: 999,
                background: active ? APP.accent : APP.surface,
                border: `${APP.hair} solid ${active ? APP.accent : APP.border}`,
                transition: "background 0.15s, color 0.15s, border-color 0.15s",
              }}
            >
              {c.label}
            </SelectableItem>
          );
        })}
      </Row>
    </div>
  );
}

/* ───────────────── 03 动效与特殊设计 ───────────────── */

interface MotionEffect {
  name: string;
  desc: string;
  tech: string;
  path: string;
}

const MOTION_CATEGORIES: Array<{ title: string; items: MotionEffect[] }> = [
  {
    title: "点击按压微动效",
    items: [
      {
        name: "AppPressable",
        desc: "全局「缩小 → overshoot 反弹 → 回落」点击脚本，已铺至 70+ 组件",
        tech: "TweenSequence + Transform.scale，延迟触发动作",
        path: "lib/shared/widgets/app_pressable.dart",
      },
      {
        name: "AppButton 按压",
        desc: "所有按钮变体继承按压回弹",
        tech: "外层包裹 AppPressable",
        path: "lib/shared/widgets/app_button.dart",
      },
      {
        name: "伙伴卡按下叠层",
        desc: "按下叠加粉色半透明遮罩（保留自有反馈）",
        tech: "onTapDown/Up + Positioned.fill",
        path: "lib/features/partner/presentation/components/partner_character_card.dart",
      },
      {
        name: "伙伴 chip 按下态",
        desc: "chip / 排序栏按下变色",
        tech: "_pressed 布尔 + onTapDown/Up",
        path: "lib/features/partner/presentation/components/partner_category_chip_bar.dart",
      },
    ],
  },
  {
    title: "弹性 / 回弹 / 物理",
    items: [
      {
        name: "ElasticTabIndicator",
        desc: "黄条平移 + 沿主轴长度拉伸回弹（架构 §3.5）；横向下划线 / 竖向侧边条（axis）",
        tech: "AnimationController + 分段 _stretchProgress",
        path: "lib/shared/components/elastic_tab_indicator.dart",
      },
      {
        name: "底部导航图标弹跳",
        desc: "选中图标冲高 → 回落 → 稳定",
        tech: "TweenSequence + ScaleTransition",
        path: "lib/shared/widgets/app_nav_icon.dart",
      },
      {
        name: "分类筛选弹性下划线",
        desc: "共享下划线在 chip 间滑动 + 拉伸",
        tech: "Offset.lerp + 宽度拉伸",
        path: "lib/features/category/presentation/components/category_filter_section.dart",
      },
      {
        name: "会员 Hero 橡皮筋回弹",
        desc: "轮播取消回弹 + 插图弹入",
        tech: "animateToPage + Curves.easeOutBack",
        path: "lib/features/membership/presentation/components/membership_hero.dart",
      },
      {
        name: "伙伴弹簧物理",
        desc: "单次手势最多翻一页 + 弹簧回稳，已接入互动 Feed PageView",
        tech: "ScrollSpringSimulation + SpringDescription",
        path: "lib/features/partner/presentation/components/partner_interaction_page_physics.dart",
      },
    ],
  },
  {
    title: "呼吸 / 循环 / 引导 / 加载",
    items: [
      {
        name: "SweepHighlightOverlay",
        desc: "CTA 循环左 → 右扫光",
        tech: "repeat() + Transform.translate + LinearGradient",
        path: "lib/shared/components/sweep_highlight_overlay.dart",
      },
      {
        name: "AppGradientCtaButton",
        desc: "共享渐变强动效 CTA:呼吸缩放 + 扫光 + loading;各处传渐变/高度/圆角/扫光色",
        tech: "ScaleTransition + SweepHighlightOverlay",
        path: "lib/shared/components/app_gradient_cta_button.dart",
      },
      {
        name: "MembershipCtaButton",
        desc: "会员金色 CTA,委派 AppGradientCtaButton",
        tech: "AppGradientCtaButton(金渐变)",
        path: "lib/features/membership/presentation/components/membership_cta_button.dart",
      },
      {
        name: "福利签到 CTA",
        desc: "「立即签到」呼吸 + 扫光",
        tech: "呼吸 token + SweepHighlightOverlay",
        path: "lib/features/welfare/presentation/components/daily_check_in_section.dart",
      },
      {
        name: "VIP 领取按钮",
        desc: "签到成功弹窗粉色 VIP 按钮呼吸 + 扫光",
        tech: "repeat(reverse) + 扫光层",
        path: "lib/features/welfare/presentation/components/check_in_success_dialog.dart",
      },
      {
        name: "验证码光标闪烁",
        desc: "OTP 输入格内光标闪烁",
        tech: "repeat(reverse) + FadeTransition",
        path: "lib/features/auth/presentation/pages/login_page.dart",
      },
      {
        name: "AppConfetti",
        desc: "庆祝礼花迸发（签到成功全屏）",
        tech: "confetti 包，双向爆发喷发器",
        path: "lib/shared/components/app_confetti.dart",
      },
      {
        name: "AppShimmer + 书卡骨架",
        desc: "加载时高光扫过骨架占位，替代整屏 spinner（榜单/分类/搜索/书架）",
        tech: "AnimationController + ShaderMask 高光带",
        path: "lib/shared/widgets/app_shimmer.dart",
      },
      {
        name: "AppLottie",
        desc: "Lottie 帧动画统一封装（基建就绪，资源放 assets/lottie/）",
        tech: "lottie 包 Lottie.asset",
        path: "lib/shared/components/app_lottie.dart",
      },
    ],
  },
  {
    title: "着色器 / 自绘",
    items: [
      {
        name: "极光 GLSL 背景",
        desc: "噪声 + 三色渐变动态极光，含降级渐变",
        tech: "FragmentShader + Ticker 驱动 uTime + CustomPaint",
        path: "lib/shared/widgets/aurora_background.dart",
      },
      {
        name: "极光着色器源",
        desc: "simplex noise + 三色 ramp + 垂直衰减",
        tech: "GLSL 片元着色器",
        path: "assets/shaders/aurora.frag",
      },
      {
        name: "方案卡渐变描边",
        desc: "选中会员方案卡金色渐变描边",
        tech: "CustomPaint 路径 + LinearGradient shader",
        path: "lib/features/membership/presentation/components/membership_plan_card.dart",
      },
      {
        name: "勾选标记自绘",
        desc: "圆内手绘对勾",
        tech: "CustomPaint 描边路径",
        path: "lib/shared/widgets/app_selection_mark.dart",
      },
      {
        name: "福利气泡自绘",
        desc: "圆角气泡 + 底部小尾巴",
        tech: "CustomPaint 圆角矩形 + 三角",
        path: "lib/features/welfare/presentation/components/welfare_reward_bubble.dart",
      },
      {
        name: "焦点封面裁剪",
        desc: "按焦点保脸比例裁剪封面",
        tech: "布局计算 + 条件留白",
        path: "lib/shared/components/app_focal_cover_image.dart",
      },
    ],
  },
  {
    title: "玻璃 / 模糊",
    items: [
      {
        name: "showAppBlurredDialog",
        desc: "居中弹窗统一入口（80% 黑遮罩）",
        tech: "showGeneralDialog + 透明 barrier",
        path: "lib/shared/components/app_blurred_dialog.dart",
      },
      {
        name: "AppBlurredChromeBar",
        desc: "顶 / 底 chrome 磨砂玻璃",
        tech: "ClipRect + BackdropFilter",
        path: "lib/shared/components/app_blurred_chrome_bar.dart",
      },
      {
        name: "滚动触发 chrome 模糊",
        desc: "内容滚到 chrome 下方时起雾",
        tech: "ScrollNotification → shouldBlur",
        path: "lib/shared/components/app_scroll_blur_scope.dart",
      },
      {
        name: "吸顶 sliver 模糊",
        desc: "吸顶头与内容重叠时模糊",
        tech: "SliverPersistentHeaderDelegate",
        path: "lib/shared/components/blurred_pinned_header_delegate.dart",
      },
      {
        name: "GlassChipButton",
        desc: "玻璃胶囊 / 搜索框容器",
        tech: "BackdropFilter(glassBlurSigma)",
        path: "lib/shared/components/glass_chip_button.dart",
      },
      {
        name: "AppBottomNav 玻璃",
        desc: "悬浮导航渐隐 + 胶囊模糊",
        tech: "LinearGradient + BackdropFilter",
        path: "lib/shared/layouts/app_bottom_nav.dart",
      },
      {
        name: "继续阅读封面底纹",
        desc: "页面背景色 + 放大封面背景层（撑满宽度、居中、半透明 + 模糊 continueReadingBgBlurSigma），随书籍变化；左侧封面缩略图放大溢出卡片顶部 + 投影，悬浮抬起",
        tech: "Opacity + ImageFiltered(continueReadingBgBlurSigma)",
        path: "lib/features/bookstore/presentation/components/continue_reading_card.dart",
      },
      {
        name: "圆形磨砂图标框",
        desc: "顶栏圆形磨砂图标按钮",
        tech: "ClipOval + BackdropFilter",
        path: "lib/shared/components/app_top_bar_icon_button.dart",
      },
    ],
  },
  {
    title: "页面转场 / 容器变换",
    items: [
      {
        name: "AdvancedTransitionWrapper",
        desc: "卡片 → 全屏容器变形（充值卡 → 详情）",
        tech: "OpenContainer + fadeThrough",
        path: "lib/shared/widgets/advanced_transition_wrapper.dart",
      },
      {
        name: "目录抽屉滑入",
        desc: "左侧目录面板滑入",
        tech: "showGeneralDialog + SlideTransition",
        path: "lib/features/book_detail/presentation/components/book_detail_catalog_drawer.dart",
      },
      {
        name: "会员权益 3D 轮播",
        desc: "权益卡随滚动缩放 / 透明 / Y 位移 / Y 旋转",
        tech: "PageView + AnimatedBuilder + Matrix4.rotateY",
        path: "lib/features/membership/presentation/pages/membership_benefits_detail_page.dart",
      },
      {
        name: "书封 Hero 共享元素",
        desc: "列表书封 → 书详情头图同 tag 飞行（仅书 id 唯一的列表启用）",
        tech: "Hero(tag) + 入口封面即时渲染作落点",
        path: "lib/shared/widgets/book_cover.dart",
      },
    ],
  },
  {
    title: "Tab 跟手切换 / 滑块",
    items: [
      {
        name: "AppSwipeTabSwitcher",
        desc: "顶部固定、内容跟手横滑（架构 §3.4，8 页复用）",
        tech: "PageView + PageScrollPhysics",
        path: "lib/shared/components/app_swipe_tab_switcher.dart",
      },
      {
        name: "AppSegmentedSwitch",
        desc: "玻璃分段控件选中滑块横移",
        tech: "AnimatedPositioned + easeInOut",
        path: "lib/shared/components/app_segmented_switch.dart",
      },
      {
        name: "AppVerticalRailSwitch",
        desc: "竖向轨道黄条平移 + 高度拉伸回弹（榜单维度导航），复用 ElasticTabIndicator",
        tech: "ElasticTabIndicator(axis: Axis.vertical)",
        path: "lib/shared/components/app_vertical_rail_switch.dart",
      },
    ],
  },
  {
    title: "滚动 / 沉浸式 Hero 头图",
    items: [
      {
        name: "AppTopBar 沉浸蒙版",
        desc: "沉浸头图上加深色渐变保证 chrome 可读",
        tech: "showScrim LinearGradient + 可选 blur",
        path: "lib/shared/components/app_top_bar.dart",
      },
      {
        name: "榜单 Hero",
        desc: "定比头图 + 蒙版底 + 桂冠镜像装饰",
        tech: "Stack + 渐隐 + Transform.scale(-1)",
        path: "lib/features/ranking/presentation/components/ranking_hero_banner.dart",
      },
      {
        name: "装扮 Hero 头",
        desc: "沉浸顶（scrim 开、blur 关）",
        tech: "AppTopBar(showScrim)",
        path: "lib/features/dress_up/presentation/components/dress_up_hero_header.dart",
      },
      {
        name: "OverscrollStretch 头图视差",
        desc: "下拉回弹时头图放大的视差 / 拉伸（书详情 + 会员 Hero）",
        tech: "ScrollController overscroll + Transform.scale",
        path: "lib/shared/widgets/overscroll_stretch.dart",
      },
    ],
  },
  {
    title: "其它自定义",
    items: [
      {
        name: "AppToast",
        desc: "黄底居中轻提示，自动消失",
        tech: "OverlayEntry + AnimatedOpacity",
        path: "lib/shared/components/app_toast.dart",
      },
      {
        name: "AppSwitch",
        desc: "开关滑块 + 轨道色过渡",
        tech: "AnimatedContainer + AnimatedAlign",
        path: "lib/shared/widgets/app_switch.dart",
      },
      {
        name: "登录输入框聚焦下划线",
        desc: "黄色下划线聚焦时中心向两侧展开",
        tech: "AnimationController + 宽度 lerp",
        path: "lib/features/auth/presentation/components/login_text_field.dart",
      },
      {
        name: "福利任务倒计时",
        desc: "HH:MM:SS 每秒跳动",
        tech: "Timer.periodic + setState",
        path: "lib/features/welfare/presentation/components/welfare_task_row.dart",
      },
      {
        name: "续费提示交叉淡入",
        desc: "提示文案交叉淡入滑动，slot 高度动画",
        tech: "AnimatedSize + AnimatedSwitcher",
        path: "lib/features/membership/presentation/components/membership_renew_hint.dart",
      },
      {
        name: "「换一换」旋转",
        desc: "推荐区刷新图标点击自转一圈",
        tech: "RotationTransition forward(from:0)",
        path: "lib/features/book_detail/presentation/components/book_detail_recommendation_section.dart",
      },
      {
        name: "AnimatedCountText",
        desc: "数值变化时从旧值滚动到新值（余额 / 钱包 / 星尘 / 阅读分钟）",
        tech: "TweenAnimationBuilder<double>",
        path: "lib/shared/widgets/animated_count_text.dart",
      },
      {
        name: "AppMarqueeText",
        desc: "文本溢出时横向循环滚动（「继续阅读」书名）",
        tech: "LayoutBuilder 测宽 + AnimationController 平移",
        path: "lib/shared/widgets/app_marquee_text.dart",
      },
    ],
  },
];

const MOTION_GAPS =
  "Lottie 具体动画（基建就绪：lottie 依赖 + AppLottie + assets/lottie/，待放入 JSON 资源并接入）";

function MotionGallerySection({
  categories = MOTION_CATEGORIES,
  showExtras = true,
}: {
  categories?: Array<{ title: string; items: MotionEffect[] }>;
  showExtras?: boolean;
}) {
  return (
    <Stack gap={18}>
      {showExtras ? (
        <Text tone="tertiary" size="small">
          约 50 项独立效果，分 9 类；<Code>AppPressable</Code> 已铺至 70+
          组件。每项点右侧「源码」路径直接打开真源。
        </Text>
      ) : null}
      {categories.map((category) => (
        <div key={category.title}>
          <Stack gap={8}>
            <Row gap={8} align="center">
              <H3>{category.title}</H3>
              <Pill size="sm">{`${category.items.length}`}</Pill>
            </Row>
            <Table
              headers={["名称", "说明", "实现技术", "源码"]}
              columnAlign={["left", "left", "left", "left"]}
              rows={category.items.map((effect) => [
                cell(<Code>{effect.name}</Code>),
                cell(
                  <div style={{ minWidth: 240 }}>
                    <Text>{effect.desc}</Text>
                  </div>,
                ),
                cell(
                  <Text tone="tertiary" size="small">
                    {effect.tech}
                  </Text>,
                ),
                cell(<SourceLink path={effect.path} />),
              ])}
            />
          </Stack>
        </div>
      ))}
      {showExtras ? (
        <Callout tone="neutral" title="尚未实现（后续增强候选）">
          <Text>{MOTION_GAPS}</Text>
        </Callout>
      ) : null}
    </Stack>
  );
}

/* ───────────────── 封面 / 通用排版 ───────────────── */

function CoverHeader() {
  const meta: string[] = ["版本 v1.0", "更新 2026-07-08", "深色优先", "唯一权威"];
  return (
    <Stack gap={18}>
      <Row gap={14} align="center">
        <div
          style={{
            width: 46,
            height: 46,
            flexShrink: 0,
            borderRadius: 13,
            background: APP.accent,
            color: APP.onAccent,
            display: "flex",
            alignItems: "center",
            justifyContent: "center",
            fontSize: 22,
            fontWeight: 700,
          }}
        >
          点
        </div>
        <Stack gap={2}>
          <H1>深色 UI 设计规范</H1>
          <Text tone="secondary">
            点点穿书 · 设计 token 与组件的唯一权威基线（Single Source of Truth）
          </Text>
        </Stack>
      </Row>
      <Row gap={8} wrap align="center">
        {meta.map((m) => (
          <Pill key={m} size="sm">
            {m}
          </Pill>
        ))}
      </Row>
      <Text tone="tertiary" size="small">
        所有界面一律引用下列 token，禁止写死数值；换色系走{" "}
        <Code>--dart-define=THEME</Code>。真源：<Code>lib/core/theme/*.dart</Code>{" "}
        · <Code>lib/shared/*</Code>
      </Text>
    </Stack>
  );
}

function SummaryStats() {
  const motionItems = MOTION_CATEGORIES.reduce((n, c) => n + c.items.length, 0);
  const stats: Array<[string, string]> = [
    ["8", "字号档"],
    ["4", "行高档"],
    ["6", "字重档"],
    ["8", "间距档"],
    ["5", "圆角档"],
    ["16", "核心组件"],
    [`${MOTION_CATEGORIES.length}`, "动效类"],
    [`${motionItems}`, "动效项"],
  ];
  return (
    <Stage>
      <Grid columns={4} gap={12}>
        {stats.map(([value, label]) => (
          <Stat key={label} value={value} label={label} />
        ))}
      </Grid>
    </Stage>
  );
}

function PartBanner({
  index,
  title,
  subtitle,
}: {
  index: string;
  title: string;
  subtitle: string;
}) {
  const theme = useHostTheme();
  return (
    <Stack gap={16} style={{ marginTop: 56, marginBottom: 32 }}>
      <Row gap={14} align="center">
        <span
          style={{
            fontSize: 34,
            fontWeight: 700,
            lineHeight: 1,
            color: APP.accent,
            fontVariantNumeric: "tabular-nums",
            minWidth: 46,
          }}
        >
          {index}
        </span>
        <div
          style={{
            width: 1,
            alignSelf: "stretch",
            background: theme.stroke.secondary,
          }}
        />
        <Stack gap={12}>
          <span
            style={{ fontSize: 20, fontWeight: 700, color: theme.text.primary }}
          >
            {title}
          </span>
          <Text tone="tertiary" size="small">
            {subtitle}
          </Text>
        </Stack>
      </Row>
    </Stack>
  );
}

function SourceLink({ path }: { path: string }) {
  const dispatch = useCanvasAction();
  return (
    <span
      onClick={() => dispatch({ type: "openFile", path })}
      title="打开源码"
      style={{
        cursor: "pointer",
        fontSize: 12,
        color: APP.accent,
        fontFamily: "monospace",
        textDecoration: "underline",
        textUnderlineOffset: 2,
      }}
    >
      {path}
    </span>
  );
}

function SectionTitle({
  zh,
  note,
  src,
}: {
  zh: string;
  note?: string;
  src?: string;
}) {
  return (
    <Stack gap={3}>
      <H3>{zh}</H3>
      {note ? (
        <Text tone="tertiary" size="small">
          {note}
        </Text>
      ) : null}
      {src ? (
        <Row gap={6} align="center">
          <Text tone="tertiary" size="small">
            源码
          </Text>
          <SourceLink path={src} />
        </Row>
      ) : null}
    </Stack>
  );
}

/** 规范条目外壳：标题行 + 内容区，统一各 *Section 脚手架。 */
function SpecSection({
  zh,
  note,
  src,
  gap = 16,
  children,
}: {
  zh: string;
  note?: string;
  src?: string;
  gap?: number;
  children: ReactNode;
}) {
  return (
    <Stack gap={gap}>
      <SectionTitle zh={zh} note={note} src={src} />
      {children}
    </Stack>
  );
}

/** 选中态文案：黄字加粗 / 灰字常规（可覆写色与附加样式）。 */
function SelectableItem({
  active,
  onClick,
  children,
  activeColor = APP.accent,
  inactiveColor = APP.textMuted,
  fontSize = 14,
  style,
}: {
  active: boolean;
  onClick?: () => void;
  children: ReactNode;
  activeColor?: string;
  inactiveColor?: string;
  fontSize?: number;
  style?: CSSProperties;
}) {
  return (
    <div
      onClick={onClick}
      style={mergeStyle(
        {
          cursor: "pointer",
          userSelect: "none",
          color: active ? activeColor : inactiveColor,
          fontWeight: active ? 600 : 400,
          fontSize,
          transition: "color 0.15s",
        },
        style,
      )}
    >
      {children}
    </div>
  );
}

/** 玻璃面占位 / 容器：APP.glass + 默认圆角 md。 */
function GlassPlaceholder({
  width,
  height,
  borderRadius = 12,
  border,
  style,
  onClick,
  children,
}: {
  width?: number | string;
  height?: number | string;
  borderRadius?: number | string;
  border?: boolean | string;
  style?: CSSProperties;
  onClick?: () => void;
  children?: ReactNode;
}) {
  return (
    <div
      onClick={onClick}
      style={mergeStyle(
        {
          width,
          height,
          flexShrink: 0,
          background: APP.glass,
          borderRadius,
          ...(border === true
            ? { border: `${APP.hair} solid ${APP.border}` }
            : typeof border === "string"
              ? { border }
              : {}),
        },
        style,
      )}
    >
      {children}
    </div>
  );
}

function Stage({
  children,
  style,
}: {
  children: ReactNode;
  style?: CSSProperties;
}) {
  return (
    <div
      style={mergeStyle(
        {
          background: APP.bg,
          border: `1px solid ${APP.panelEdge}`,
          borderRadius: 16,
          padding: 20,
        },
        style,
      )}
    >
      {children}
    </div>
  );
}

function Caption({ children }: { children: ReactNode }) {
  return <span style={{ fontSize: 11, color: APP.textMuted }}>{children}</span>;
}

/// 表格单元格：上下固定 24px 内边距。
function cell(node: ReactNode): ReactNode {
  return (
    <div style={{ paddingTop: 24, paddingBottom: 24 }}>{node}</div>
  );
}

/// 小色卡（表格内用）。
function swatch(color: string): ReactNode {
  return (
    <div
      style={{
        width: 28,
        height: 28,
        borderRadius: 6,
        background: color,
        border: `1px solid ${APP.panelEdge}`,
      }}
    />
  );
}

function Pressable({
  onClick,
  children,
  style,
}: {
  onClick?: () => void;
  children: ReactNode;
  style?: CSSProperties;
}) {
  const [pressed, setPressed] = useState(false);
  return (
    <div
      onClick={onClick}
      onPointerDown={() => setPressed(true)}
      onPointerUp={() => setPressed(false)}
      onPointerLeave={() => setPressed(false)}
      style={mergeStyle(
        {
          cursor: "pointer",
          userSelect: "none",
          transition: "transform 0.09s ease, filter 0.09s ease",
          transform: pressed ? "scale(0.96)" : "scale(1)",
          filter: pressed ? "brightness(0.86)" : "none",
        },
        style,
      )}
    >
      {children}
    </div>
  );
}

/**
 * 统一按钮组件（对应 Flutter 的 AppButton）。
 * 按钮区、弹窗、Toast 触发钮等全部复用它——与真实代码「弹窗调用 AppButton」一致：
 * 改这里 = 预览里所有用到按钮的地方一起变。
 */
type BtnVariant = "accent" | "secondary" | "outline" | "vip";
type BtnSize = "normal" | "compact" | "small";

const BTN_VARIANTS: Record<
  BtnVariant,
  { bg: string; fg: string; radius: number; border: boolean }
> = {
  accent: { bg: APP.accent, fg: APP.onAccent, radius: 999, border: false },
  secondary: { bg: APP.surface, fg: "#FFFFFF", radius: 999, border: false },
  outline: { bg: "transparent", fg: "#FFFFFF", radius: 999, border: true },
  vip: {
    bg: "linear-gradient(90deg, #FFDDC1 0%, #F393DC 100%)",
    fg: "#740551",
    radius: 999,
    border: false,
  },
};

const BTN_SIZES: Record<BtnSize, { pad: string; fs: number; fw: number }> = {
  normal: { pad: "16px 24px", fs: 16, fw: 700 },
  compact: { pad: "8px 24px", fs: 14, fw: 500 },
  small: { pad: "8px 16px", fs: 14, fw: 500 },
};

function DemoButton({
  variant = "secondary",
  size = "normal",
  expand = false,
  onClick,
  children,
}: {
  variant?: BtnVariant;
  size?: BtnSize;
  expand?: boolean;
  onClick?: () => void;
  children: ReactNode;
}) {
  const v = BTN_VARIANTS[variant];
  const s = BTN_SIZES[size];
  return (
    <Pressable
      onClick={onClick}
      style={{
        background: v.bg,
        color: v.fg,
        borderRadius: v.radius,
        border: v.border ? `${APP.hair} solid ${APP.border}` : "none",
        padding: s.pad,
        fontSize: s.fs,
        fontWeight: s.fw,
        lineHeight: 1,
        textAlign: "center",
        ...(expand ? { flex: 1 } : {}),
      }}
    >
      {children}
    </Pressable>
  );
}

/* ───────────────── 图标（内联 SVG，近似还原资产图标）───────────────── */

function Glyph({
  name,
  color,
  size = 24,
  strokeWidth = 1.8,
}: {
  name: string;
  color: string;
  size?: number;
  strokeWidth?: number;
}) {
  const p = {
    width: size,
    height: size,
    viewBox: "0 0 24 24",
    fill: "none",
    stroke: color,
    strokeWidth,
    strokeLinecap: "round" as const,
    strokeLinejoin: "round" as const,
  };
  switch (name) {
    case "search":
      return (
        <svg {...p}>
          <circle cx="11" cy="11" r="7" />
          <line x1="20" y1="20" x2="16.5" y2="16.5" />
        </svg>
      );
    case "home":
      return (
        <svg {...p}>
          <path d="M3 10.5 12 3l9 7.5" />
          <path d="M5 9.5V20h14V9.5" />
        </svg>
      );
    case "shelf":
      return (
        <svg {...p}>
          <rect x="4" y="4" width="5" height="16" rx="1" />
          <rect x="11" y="4" width="5" height="16" rx="1" />
          <line x1="18.5" y1="6" x2="20.5" y2="19" />
        </svg>
      );
    case "gift":
      return (
        <svg {...p}>
          <rect x="4" y="9" width="16" height="11" rx="1" />
          <path d="M4 12h16" />
          <path d="M12 9v11" />
          <path d="M12 9C10 9 8 8 8 6.5S9 4 10 5s2 4 2 4 1-3 2-4 2 0 2 1.5S14 9 12 9Z" />
        </svg>
      );
    case "message":
      return (
        <svg {...p}>
          <path d="M4 5h16v11H9l-4 3v-3H4Z" />
        </svg>
      );
    case "profile":
      return (
        <svg {...p}>
          <circle cx="12" cy="8" r="3.5" />
          <path d="M5 20c0-3.5 3-6 7-6s7 2.5 7 6" />
        </svg>
      );
    case "more":
      return (
        <svg {...p}>
          <circle cx="5" cy="12" r="1.4" fill={color} stroke="none" />
          <circle cx="12" cy="12" r="1.4" fill={color} stroke="none" />
          <circle cx="19" cy="12" r="1.4" fill={color} stroke="none" />
        </svg>
      );
    case "back":
      return (
        <svg {...p}>
          <path d="M15 5l-7 7 7 7" />
        </svg>
      );
    case "arrow":
      return (
        <svg {...p}>
          <path d="M9 6l6 6-6 6" />
        </svg>
      );
    default:
      return null;
  }
}

/* ───────────────── 第一部分 · 视觉基础 ───────────────── */

function TypeScaleSection() {
  const sizes: Array<[string, number, string]> = [
    ["xxs", 9, "极小角标"],
    ["xs", 10, "小标签"],
    ["md", 12, "说明 / 次要正文 / 标签"],
    ["base", 14, "正文（主力档）"],
    ["lg", 16, "小标题 / 卡片标题"],
    ["xl", 18, "页面标题"],
    ["xxl", 24, "大标题 / 数值"],
    ["display", 32, "Hero / 展示级"],
  ];
  return (
    <SpecSection
        zh="字号（8 档）"
        note="AppFontSizes"
        src="lib/core/theme/app_text_styles.dart"
      >
      <Table
        headers={["档位", "px", "用途", "示例"]}
        columnAlign={["left", "center", "left", "left"]}
        rows={sizes.map(([name, px, use]) => [
          <Code key={name}>{name}</Code>,
          `${px}`,
          use,
          <span key={name} style={{ fontSize: px, lineHeight: 1.1 }}>
            示例文字 换肤 123
          </span>,
        ].map(cell))}
      />
    </SpecSection>
  );
}

function LineHeightSection() {
  return (
    <SpecSection
        zh="行高（4 档）"
        note="AppLineHeights"
        src="lib/core/theme/app_text_styles.dart"
      >
      <Table
        headers={["档位", "值", "用途"]}
        columnAlign={["left", "center", "left"]}
        rows={[
          ["none", "1.0", "单行标签 / 数字 / 图标旁文字"],
          ["tight", "1.2", "大标题 / 展示级 / 标题"],
          ["normal", "1.4", "副标题 / 正文段落"],
          ["loose", "1.75", "多行说明 / 协议类长文"],
        ].map((r) => r.map(cell))}
      />
    </SpecSection>
  );
}

function WeightSection() {
  const weights: Array<[string, number, string]> = [
    ["regular", 400, "正文 / 说明 / 未选中"],
    ["medium", 500, "标签 / 选中态 / 次级按钮"],
    ["semibold", 600, "页面标题 / 区块标题"],
    ["bold", 700, "主按钮 / 强调数值"],
    ["heavy", 800, "榜单大标题"],
    ["black", 900, "会员价格等极强调"],
  ];
  return (
    <SpecSection
        zh="字重（6 档）"
        note="AppFontWeights"
        src="lib/core/theme/app_text_styles.dart"
      >
      <Table
        headers={["档位", "值", "用途", "示例"]}
        columnAlign={["left", "center", "left", "left"]}
        rows={weights.map(([name, w, usage]) => [
          <Code key={name}>{name}</Code>,
          `${w}`,
          usage,
          <span key={name} style={{ fontSize: 18, fontWeight: w }}>
            示例 Aa 123
          </span>,
        ].map(cell))}
      />
    </SpecSection>
  );
}

function FontFamilySection() {
  return (
    <SpecSection
        zh="字体族 · 定制数字字体"
        note="AppFontFamilies"
        src="lib/core/theme/app_text_styles.dart"
      >
      <Table
        headers={["Token", "值", "使用场景"]}
        columnAlign={["left", "left", "left"]}
        rows={[
          ["number", "TCloudNumber", "定制数字字体（数字 / 标点 / 符号字形）"],
        ].map((r) => r.map(cell))}
      />
      <Callout tone="warning">
        <Stack gap={4}>
          <Text weight="semibold">规则：仅 ≥18px 字号引用</Text>
          <Text tone="secondary" size="small">
            字号 xl(18) / xxl(24) / display(32) 的文字样式统一带{" "}
            <Code>fontFamily: AppFontFamilies.number</Code>；&lt;18px（含 lg 16px 及以下）不引用，保持系统字体。
          </Text>
          <Text tone="secondary" size="small">
            字重降一档：字体注册桶整体上移（<Code>Light→500 / Regular→700 / Bold→900</Code>），数字字形比文本标称字重轻一档；中文 / 字母回退按标称字重渲染。
          </Text>
          <Text tone="secondary" size="small">
            该字体仅覆盖数字、标点与符号；中文 / 字母自动回退系统字体，可安全用于中英混排标题与数值。字体注册于{" "}
            <Code>pubspec.yaml</Code>（桶 500/700/900，资源在 <Code>assets/fonts/</Code>）。
          </Text>
        </Stack>
      </Callout>
    </SpecSection>
  );
}

function ColorSection() {
  return (
    <SpecSection
        zh="颜色(单一真源)"
        note="AppColors · AppBrandColors"
        src="lib/core/theme/app_colors.dart"
        gap={14}
      >

      <Stack gap={8}>
        <Text weight="semibold">中性阶 · 白色透明度叠加（深色态真源）</Text>
        <Table
          headers={["档位", "不透明度", "ARGB", "典型用途"]}
          columnAlign={["left", "center", "left", "left"]}
          rows={[
            ["white100", "100%", "0xFFFFFFFF", "主文字"],
            ["white85", "85%", "0xD9FFFFFF", "次强调文字"],
            ["white60", "60%", "0x99FFFFFF", "弱化 / 占位 / 图标"],
            ["white50", "50%", "0x80FFFFFF", "弱化文字 / 扫光"],
            ["white24", "24%", "0x3DFFFFFF", "头图蒙版软档"],
            ["white20", "20%", "0x33FFFFFF", "分隔线 / 导航底"],
            ["white08", "8%", "0x14FFFFFF", "分隔"],
            ["white06", "6%", "0x0FFFFFFF", "回复区底"],
            ["white05", "5%", "0x0DFFFFFF", "卡片弱底"],
            ["white04", "4%", "0x0AFFFFFF", "玻璃面 / 卡片面 / 描边 / 标签底"],
            ["white00", "0%", "0x00FFFFFF", "渐变透明端"],
          ].map((r) => r.map(cell))}
        />
      </Stack>

      <Stack gap={8}>
        <Text weight="semibold">中性阶 · 黑色透明度（遮罩）</Text>
        <Table
          headers={["档位", "不透明度", "用途"]}
          columnAlign={["left", "center", "left"]}
          rows={[
            ["black80", "80%", "居中弹窗遮罩（80% 纯黑，无模糊）"],
            ["black60", "60%", "封面选择遮罩"],
            ["black40", "40%", "选中态封面遮罩"],
            ["black30", "30%", "顶栏图标框 / 通用遮罩"],
            ["black08", "8%", "顶栏图标框底"],
            ["black04", "4%", "封面描边 / 签到底"],
            ["black00", "0%", "渐变透明端"],
          ].map((r) => r.map(cell))}
        />
      </Stack>
      <Stack gap={8}>
        <Text weight="semibold">背景 tint 阶（随主题换色）</Text>
        <Text tone="secondary" size="small">
          基于基础背景 <Code>#090E17</Code> 的不同透明度，用于渐隐 / 毛玻璃底 /
          头图蒙版；换色系时整条随背景色相变化。
        </Text>
        <BgTintSwatches />
      </Stack>

      <Stack gap={8}>
        <Text weight="semibold">品牌 / 主题源色</Text>
        <BrandSwatches />
        <Text tone="tertiary" size="small">
          福利金 <Code>#935C1A</Code>、伙伴粉 <Code>#FF4D88</Code>、VIP 粉{" "}
          <Code>#F393DC</Code>、签到高亮 <Code>#FFDD47</Code>、会员金渐变{" "}
          <Code>#FFE794→#FFCD5A</Code>、面板深字 <Code>#202020</Code>、中性图标灰{" "}
          <Code>#B2B3BA</Code>/<Code>#ABACB3</Code>、榜单头图标题{" "}
          <Code>#FFFAD7</Code> 等 feature 色均定义于此，被各 feature 色板引用。
        </Text>
      </Stack>

      <Stack gap={8}>
        <Text weight="semibold">feature 语义色 token（引用上述源色，值不变为主）</Text>
        <Text tone="tertiary" size="small">
          各 feature 色板（<Code>app_welfare_colors.dart</Code> /{" "}
          <Code>app_membership_colors.dart</Code> / <Code>app_colors.dart</Code>）在源色之上派生的语义 token；除少量透明度变体外均为对源色的别名（收敛去重）。
        </Text>
        <Table
          headers={["Token", "值", "用途"]}
          columnAlign={["left", "left", "left"]}
          rows={[
            ["checkInHighlightSurface / …Bg", "0x14FCE64D（8% checkInYellow）", "今日签到高亮卡底"],
            ["checkInHighlightHeader", "#FCE64D（checkInYellow）", "今日签到高亮头"],
            ["checkInHighlightBorder", "#FFDD47", "高亮卡描边"],
            ["checkInRewardTodayText", "#FCE64D（checkInYellow）", "今日奖励文字"],
            ["checkInDayBg", "white04", "普通签到日底"],
            ["checkInCumulativeBg", "0x14FCE64D（8% checkInYellow）", "累计签到徽章底"],
            ["checkInCumulativeBorder", "white00（透明）", "累计徽章描边"],
            ["checkInMilestoneAmount", "white100", "里程碑数值"],
            ["planSelectedBg", "0x14FFE794（8% 会员金）", "会员方案选中卡底"],
            ["planSelectedBorder", "#FFE794（ctaGradientStart）", "会员方案选中描边"],
            ["planSelectedGoldStart", "#FFE794（ctaGradientStart）", "选中金渐变起"],
            ["planSelectedGoldEnd", "#FFCD5A（ctaGradientEnd）", "选中金渐变止"],
            ["planSelectedSecondary", "white60", "选中卡次要文字"],
            ["planSelectedFooterText", "#202020（textOnLightPanel）", "选中卡脚文字"],
            ["searchHotAccent", "#FF7E32（accentOrange）", "搜索热词强调"],
            ["bookDetailUpdateHighlight", "#F0B16A", "书详情「更新」高亮：日期 / 圆点边 / 文字"],
            ["rankingSegmentedSelectedText", "#202020（textOnLightPanel）", "榜单分段控件选中字"],
            ["segmentedSelectedBorder", "white00（透明）", "分段控件选中去描边（仅 fill + 黄字）"],
            ["bookDetailPromoGradientStart/Mid/End", "#FF4E6C / #FF6F4B / #FF9359", "悬浮促销条底暖渐变（约 94°）"],
            ["bookDetailPromoTitle", "white100", "促销条主标题"],
            ["bookDetailPromoSubtitle", "#FFF9F2（promoSubtitle）", "促销条副标题"],
            ["bookDetailPromoRewardText", "#E64D00（promoRewardText）", "+N 能量角标文字"],
            ["bookDetailPromoCloseIcon", "white100", "促销条关闭 X"],
          ].map((r) => r.map(cell))}
        />
      </Stack>
    </SpecSection>
  );
}

function BgTintSwatches() {
  const tints: Array<[string, string]> = [
    ["bgTint00", "rgba(9,14,23,0)"],
    ["bgTint35", "rgba(9,14,23,0.35)"],
    ["bgTint45", "rgba(9,14,23,0.45)"],
    ["bgTint55", "rgba(9,14,23,0.55)"],
    ["bgTint60", "rgba(9,14,23,0.60)"],
    ["bgTint80", "rgba(9,14,23,0.80)"],
    ["bgTint90", "rgba(9,14,23,0.90)"],
  ];
  return (
    <Table
      headers={["色卡", "Token", "值"]}
      columnAlign={["left", "left", "left"]}
      rows={tints.map(([name, c]) => [
        swatch(c),
        <Code key={name}>{name}</Code>,
        c,
      ].map(cell))}
    />
  );
}

function BrandSwatches() {
  const brand: Array<[string, string, string, string]> = [
    ["backgroundDark", "#090E17", "全局背景", "#FFFFFF"],
    ["accent", "#FFE847", "主强调（黄）· CTA · 点赞 / 选中", "#131820"],
    ["auroraGlow", "#FFF2C6", "极光亮核（暖米金）", "#131820"],
    ["auroraEdge", "#1D0B10", "极光暗边（暗红近黑）", "#FFFFFF"],
    ["dialogBackground", "#131820", "弹窗底", "#FFFFFF"],
    ["surfaceMuted", "#262B33", "深青灰实心浮层 / 卡片底", "#FFFFFF"],
    ["success", "#39D98A", "成功", "#131820"],
    ["warning", "#FFA940", "警告", "#131820"],
    ["error", "#FF667F", "错误", "#131820"],
    ["premiumGold", "#F9C74F", "VIP 会员金主题（v1.0）", "#131820"],
    ["info", "#59AEFF", "信息 / 提示（v1.0）", "#131820"],
    ["fantasyPurple", "#9C87FF", "奇幻紫（v1.0）", "#131820"],
    ["energyCyan", "#42DDFF", "能量青（v1.0）", "#131820"],
    ["growthBlue", "#7E95FF", "成长蓝（v1.0）", "#131820"],
  ];
  return (
    <Table
      headers={["色卡", "Token", "Hex", "角色"]}
      columnAlign={["left", "left", "left", "left"]}
      rows={brand.map(([name, hex, role]) => [
        swatch(hex),
        <Code key={name}>{name}</Code>,
        hex,
        role,
      ].map(cell))}
    />
  );
}

function SpacingSection() {
  const items: Array<[string, number, string]> = [
    ["xxsHalf", 2, "极小间隔"],
    ["xxs", 4, "紧凑间隔"],
    ["xs", 8, "常用小间距 / 小内边距"],
    ["sm", 12, "常用间距"],
    ["md", 16, "区块内边距"],
    ["lg", 24, "区块间距"],
    ["xl", 32, "大区块间距"],
    ["xxl", 48, "超大间距"],
  ];
  return (
    <SpecSection
        zh="间距（8 档）"
        note="AppSpacing · 基阶 2·4·8·12·16·24·32·48"
        src="lib/core/theme/app_spacing.dart"
      >
      <Table
        headers={["档位", "px", "用途", "示意"]}
        columnAlign={["left", "center", "left", "left"]}
        rows={items.map(([name, px, use]) => [
          <Code key={name}>{name}</Code>,
          `${px}`,
          use,
          <div
            key={name}
            style={{
              width: px,
              height: 12,
              background: APP.accent,
              borderRadius: 2,
            }}
          />,
        ].map(cell))}
      />
    </SpecSection>
  );
}

function RadiusSection() {
  const theme = useHostTheme();
  const items: Array<[string, number, string]> = [
    ["xs", 4, "小角标 / 输入"],
    ["md", 12, "卡片 / 封面"],
    ["lg", 16, "大卡片 / 区块"],
    ["xl", 24, "弹窗 / 胶囊按钮"],
    ["full", 999, "全圆 / 药丸"],
  ];
  return (
    <SpecSection
        zh="圆角（5 档）"
        note="AppRadius · 基阶 4·12·16·24·full"
        src="lib/core/theme/app_radius.dart"
      >
      <Table
        headers={["档位", "px", "用途", "示意"]}
        columnAlign={["left", "center", "left", "left"]}
        rows={items.map(([name, r, use]) => [
          <Code key={name}>{name}</Code>,
          r === 999 ? "full" : `${r}`,
          use,
          <div
            key={name}
            style={{
              width: 56,
              height: 56,
              background: theme.fill.tertiary,
              border: `1px solid ${theme.stroke.secondary}`,
              borderRadius: Math.min(r, 28),
            }}
          />,
        ].map(cell))}
      />
    </SpecSection>
  );
}

function SizeIndexSection() {
  const groups: Array<[string, string, string]> = [
    ["通用基础", "描边 / 通用图标 / 启动图", "hairline · iconSm · splashLogoSize"],
    ["顶栏 AppTopBar", "顶栏高度 / 图标框 / 返回钮", "topBar*"],
    ["按钮 AppButton", "内边距 / loading / 图标间距", "buttonPadding*"],
    ["搜索栏 / 玻璃模糊", "搜索框高 / 各级磨砂半径", "searchBarHeight · glassBlurSigma · strongBlurSigma"],
    ["书城首页", "顶栏 / 加载 / 继续阅读浮层", "bookstore* · continueReading*"],
    ["底部导航 AppBottomNav", "胶囊 / 图标 / 弹跳缩放", "bottomNav*"],
    ["榜单", "指示器 / 轮播 / 头图 / 维度导航", "ranking* · tab*"],
    ["书籍封面 / 书卡", "列表/网格封面 / 大封面横向书卡", "bookCover* · bookGrid* · bookCardLarge*"],
    ["福利页", "头图 / 签到里程碑 / 任务时间线 / 充值弹窗", "welfare* · rechargePurchaseDialog*"],
    ["书架页", "顶栏 / 阅读横幅 / 空状态 / 封面角标", "bookshelf* · bookCoverTag*"],
    ["我的页", "Hero / 头像 / 快捷入口 / 成就勋章", "profile* · homeIndicator* · listRowMinHeight"],
    ["我的-子页", "账号设置 / 消息 / 卡包", "accountSettings* · myMessages* · cardPack*"],
    ["设置页", "Logo / 开关 AppSwitch", "settings* · appSwitch*"],
    ["书籍详情页", "头图 / 目录抽屉 / 角色卡 / 讨论区 / 更新时间线", "bookDetail* · bookDiscussionDetail*"],
    ["搜索页", "顶栏返回 / 输入图标 / 空状态", "searchAppBar* · searchInput* · searchEmpty*"],
    ["会员页", "Hero 轮播 / 方案卡 / 权益宫格 / CTA / 特权详情", "membership*"],
    ["伙伴页", "头部 / 顶部极光 / 角色卡 / 消息 Tab / 互动 Tab", "partner* · partnerTopAuroraHeight · partnerTopAuroraOpacity"],
    ["分类页", "筛选组 / chip / 下划线", "categoryFilter*"],
    ["帮助与反馈", "Banner / 输入 / 上传框", "helpFeedback*"],
    ["Toast / 交互阈值", "轻提示内边距 / 滑动切换阈值", "toast* · swipeTabVelocityThreshold"],
  ];
  return (
    <SpecSection
        zh="组件尺寸 token · 分组索引"
        note="AppSizes · 组件级布局精确值（真值随源码为准）"
        src="lib/core/theme/app_sizes.dart"
      >
      <Text tone="tertiary" size="small">
        尺寸档不同于上方基阶体系，是按页面/组件命名的精确值集合。下表仅作「按 feature 分组」的导航索引，改值只改 <Code>app_sizes.dart</Code> 一处。
      </Text>
      <Table
        headers={["分组", "覆盖范围", "Token 前缀 / 示例"]}
        columnAlign={["left", "left", "left"]}
        rows={groups.map(([g, cover, prefix]) => [g, cover, <Code key={g}>{prefix}</Code>])}
      />
    </SpecSection>
  );
}

/* ───────────────── 第二部分 · 组件（每个独占一行）───────────────── */

function PressableSection() {
  return (
    <SpecSection
        zh="按压反馈"
        note="AppPressable（L1）· 按下缩小 → 松手 overshoot 回弹 · 全局可点击模块统一微交互"
        src="lib/shared/widgets/app_pressable.dart"
      >
      <Stage>
        <div style={{ display: "flex", gap: 20, alignItems: "center", flexWrap: "wrap" }}>
          <Pressable
            style={{
              width: 96,
              height: 96,
              borderRadius: 16,
              background: APP.glass,
              display: "flex",
              alignItems: "center",
              justifyContent: "center",
              color: APP.text,
              fontSize: 14,
              fontWeight: 600,
            }}
          >
            按我
          </Pressable>
          <Pressable
            style={{
              display: "flex",
              gap: 12,
              width: 300,
              padding: 12,
              borderRadius: 12,
              background: APP.glass,
              alignItems: "center",
            }}
          >
            <div style={{ width: 44, height: 44, flexShrink: 0, background: APP.surface, borderRadius: 12 }} />
            <div style={{ color: APP.text, fontSize: 14, fontWeight: 600 }}>整行可点击（列表行柔和缩放）</div>
          </Pressable>
          <Caption>按住体验：先缩小，松手回弹</Caption>
        </div>
      </Stage>
      <Table
        headers={["参数", "值", "说明"]}
        columnAlign={["left", "left", "left"]}
        rows={[
          ["tapPressScale", "0.94", "按下缩小到的比例"],
          ["tapPressScaleSubtle", "0.97", "全宽列表行等大面积模块的柔和缩放"],
          ["tapPressReboundScale", "1.05", "反弹的 overshoot 峰值（随后回落到 1）"],
          ["tapPressDown", "70ms · easeOut", "缩小阶段时长"],
          ["tapPressRebound", "170ms", "反弹时长（冲峰 easeOut + 回落 easeInOut）"],
          ["tapPressActionDelay", "150ms", "点击后延迟触发跳转，让反弹峰值先可见"],
        ].map((r) => r.map(cell))}
      />
      <Text tone="tertiary" size="small">
        由 <Code>onTap</Code> 驱动固定脚本动画（缩小 → 反弹 → 回正），在可滚动列表内也能稳定看到完整回弹；
        动作/跳转延后 <Code>tapPressActionDelay</Code> 触发，保证「按下 → 弹起 → 跳转」可见。已全局接入
        <Code>AppButton</Code> 与书卡 / 列表行 / 图标 / Tab / chip；新可点击组件应优先用它替代裸 <Code>GestureDetector</Code>。
      </Text>
    </SpecSection>
  );
}

function ButtonSection() {
  const variants: Array<{ zh: string; code: BtnVariant }> = [
    { zh: "主 CTA", code: "accent" },
    { zh: "次操作", code: "secondary" },
    { zh: "描边", code: "outline" },
    { zh: "VIP", code: "vip" },
  ];
  const sizes: BtnSize[] = ["normal", "compact", "small"];
  return (
    <SpecSection
        zh="按钮"
        note="AppButton（L1）· 4 视觉变体 × 3 尺寸 · 弹窗等组件复用它"
        src="lib/shared/widgets/app_button.dart"
        gap={12}
      >

      <Text tone="tertiary" size="small">
        4 视觉变体 × 3 尺寸 组合总览（每行一个变体，每列一个尺寸）：
      </Text>
      <Stage>
        <div style={{ display: "flex", flexDirection: "column", gap: 20 }}>
          {variants.map((b) => (
            <div
              key={b.code}
              style={{ display: "flex", gap: 24, alignItems: "center", flexWrap: "wrap" }}
            >
              <div style={{ width: 92, flexShrink: 0 }}>
                <div style={{ color: APP.text, fontSize: 13, fontWeight: 600 }}>{b.zh}</div>
                <Caption>{b.code}</Caption>
              </div>
              {sizes.map((s) => (
                <div
                  key={s}
                  style={{ display: "flex", flexDirection: "column", gap: 6, alignItems: "flex-start" }}
                >
                  <DemoButton variant={b.code} size={s}>
                    按钮
                  </DemoButton>
                  <Caption>{s}</Caption>
                </div>
              ))}
            </div>
          ))}
        </div>
      </Stage>

      <Table
        headers={["变体", "外观", "使用场景"]}
        columnAlign={["left", "left", "left"]}
        rows={[
          ["accent", "黄底深字 · 胶囊", "深色页主 CTA：阅读 / 确认 / 提交 / 领取 / 充值（最常用）"],
          ["secondary", "4% 白底 · 无描边 · 胶囊", "次操作 / 弱化 / 未激活态（重试默认、退出登录、验证码倒计时）· 默认变体"],
          ["outline", "透明底 + 细边框", "对话框取消 · 轻量次要操作"],
          ["vip", "粉金渐变底 + 深粉字 · 胶囊", "VIP 领取 / 会员向操作（福利「VIP领取」等）"],
        ].map((r) => r.map(cell))}
      />
      <Table
        headers={["尺寸", "内边距 H×V", "文字", "使用场景"]}
        columnAlign={["left", "left", "left", "left"]}
        rows={[
          ["normal", "24 × 16", "16 · bold", "页面 / 弹窗主按钮（默认）"],
          ["small", "16 × 8", "14 · medium", "卡片内 / 行内小操作（领取、去书城）"],
          ["compact", "24 × 8", "14 · medium", "紧凑行内操作（卡包页）"],
        ].map((r) => r.map(cell))}
      />

      <Text tone="tertiary" size="small">
        状态：默认 · 加载中 · 禁用（前景 40%）· 撑满宽度 <Code>isExpanded</Code>；
        可选前置图标 <Code>leadingIcon</Code>。描边一律 0.5px hairline。
      </Text>
    </SpecSection>
  );
}

function CardSection() {
  return (
    <SpecSection
        zh="卡片"
        note="书卡族 · 底 4% 白底 + 圆角 · 禁止卡中卡 · 可点按"
        src="lib/shared/components/book_card_variants.dart"
      >
      <Stage>
        <div style={{ display: "flex", flexDirection: "column", gap: 20 }}>
          <Pressable style={{ width: 112 }}>
            <GlassPlaceholder height={150} style={{ marginBottom: 8 }} />
            <div style={{ color: APP.text, fontSize: 14, fontWeight: 600 }}>示例书名标题</div>
            <div style={{ color: APP.textMuted, fontSize: 12, marginTop: 4 }}>都市 · 悬疑</div>
            <div style={{ marginTop: 8 }}>
              <Caption>竖版 BookCardVertical · 上图下文</Caption>
            </div>
          </Pressable>
          <Pressable style={{ display: "flex", gap: 12, width: 300 }}>
            <GlassPlaceholder width={72} height={96} />
            <div style={{ display: "flex", flexDirection: "column", gap: 4 }}>
              <div style={{ color: APP.text, fontSize: 14, fontWeight: 600 }}>示例书名标题较长会省略</div>
              <div style={{ color: APP.textMuted, fontSize: 12 }}>古言 · 甜宠</div>
              <div style={{ marginTop: "auto" }}>
                <Caption>横版 BookCardHorizontal · 左图右文</Caption>
              </div>
            </div>
          </Pressable>
        </div>
      </Stage>
    </SpecSection>
  );
}

function CornerBadgeSection() {
  const badges: Array<{ label: string; bg: string; fg: string }> = [
    { label: "热", bg: "#FF7E32", fg: "#FFFFFF" },
    { label: "新手福利", bg: "#FF7E32", fg: "#FFFFFF" },
    { label: "会员免费领", bg: "#FFCD50", fg: "#131820" },
  ];
  return (
    <SpecSection
        zh="角标"
        note="AppCornerBadge（L2）· 卡片右上角斜切胶囊（topRight + bottomLeft 圆角 md，另两角直角）· 底色/文字色/水平内边距按语义传入 · 充值/兑换档位「热」「新手福利」「会员免费领」等共用"
        src="lib/shared/components/app_corner_badge.dart"
      >
      <Stage>
        <div style={{ display: "flex", gap: 20, flexWrap: "wrap" }}>
          {badges.map((b) => (
            <div key={b.label} style={{ display: "flex", flexDirection: "column", gap: 8 }}>
              <GlassPlaceholder
                width={100}
                height={128}
                border
                style={{ position: "relative", overflow: "hidden" }}
              >
                <div
                  style={{
                    position: "absolute",
                    top: 0,
                    right: 0,
                    padding: "2px 6px",
                    background: b.bg,
                    color: b.fg,
                    fontSize: 10,
                    fontWeight: 600,
                    lineHeight: 1.2,
                    borderRadius: "0 12px 0 12px",
                    whiteSpace: "nowrap",
                  }}
                >
                  {b.label}
                </div>
              </GlassPlaceholder>
              <Caption>{b.label}</Caption>
            </div>
          ))}
        </div>
      </Stage>
      <Text tone="tertiary" size="small">
        必须作 <Code>Stack</Code> 直接子节点（内部返回 <Code>Positioned</Code> 贴右上角）。
        形状固定，仅 <Code>label</Code> / <Code>color</Code> / <Code>textColor</Code> /
        <Code>horizontalPadding</Code> 按调用方语义传入。改组件，全项目角标同步。
      </Text>
    </SpecSection>
  );
}

function DialogSection() {
  return (
    <SpecSection
        zh="弹窗"
        note="showAppBlurredDialog 遮罩入口 + AppConfirmDialog 确认壳 · 80% 纯黑遮罩 · 圆角 xl"
        src="lib/shared/components/app_confirm_dialog.dart"
      >
      <Stage style={{ padding: 0, overflow: "hidden" }}>
        <div
          style={{
            minHeight: 200,
            background: "rgba(0,0,0,0.8)",
            display: "flex",
            alignItems: "center",
            justifyContent: "center",
            padding: 24,
          }}
        >
          <div style={{ width: 280, background: APP.dialogBg, borderRadius: 24, padding: 20, border: `1px solid ${APP.panelEdge}` }}>
            <div style={{ color: APP.text, fontSize: 16, fontWeight: 700, textAlign: "center" }}>删除提示</div>
            <div style={{ color: APP.textMuted, fontSize: 13, lineHeight: 1.5, textAlign: "center", marginTop: 8 }}>
              确认删除全部搜索历史吗？
            </div>
            <div style={{ display: "flex", gap: 10, marginTop: 18 }}>
              <DemoButton variant="outline" expand>
                取消
              </DemoButton>
              <DemoButton variant="accent" expand>
                确认
              </DemoButton>
            </div>
          </div>
        </div>
      </Stage>
      <Text tone="tertiary" size="small">
        两层分工：遮罩入口{" "}
        <Code>lib/shared/components/app_blurred_dialog.dart</Code>
        （<Code>showAppBlurredDialog</Code>）+ 确认壳{" "}
        <Code>AppConfirmDialog</Code>。自定义内容弹窗也走遮罩入口，只是不用确认壳。
        按钮即 <Code>AppButton</Code>（取消 <Code>outline</Code> / 确认 <Code>accent</Code>）。
      </Text>
    </SpecSection>
  );
}

function SheetSection() {
  const options = ["综合排序", "最新更新", "人气最高", "字数最多"];
  const [selected, setSelected] = useCanvasState<number>("demoSheetSelected", 0);
  return (
    <SpecSection
        zh="底部弹层"
        note="showModalBottomSheet · 顶部圆角 + 玻璃 · 可选中"
        src="lib/features/partner/presentation/components/partner_filter_sheet.dart"
      >
      <Stage style={{ padding: 0, overflow: "hidden" }}>
        <div style={{ background: "rgba(0,0,0,0.45)", paddingTop: 36 }}>
          <div style={{ background: APP.dialogBg, borderTopLeftRadius: 16, borderTopRightRadius: 16, borderTop: `${APP.hair} solid ${APP.border}`, padding: "16px 0" }}>
            <div style={{ color: APP.text, fontSize: 15, fontWeight: 600, padding: "0 16px 8px" }}>筛选</div>
            {options.map((o, i) => {
              const active = i === selected;
              return (
                <SelectableItem
                  key={o}
                  active={active}
                  onClick={() => setSelected(i)}
                  style={{
                    display: "flex",
                    alignItems: "center",
                    justifyContent: "space-between",
                    padding: "12px 16px",
                    background: active ? "rgba(255,232,71,0.06)" : "transparent",
                    transition: "color 0.15s, background 0.15s",
                  }}
                >
                  <span>{o}</span>
                  <span style={{ opacity: active ? 1 : 0, transition: "opacity 0.15s" }}>✓</span>
                </SelectableItem>
              );
            })}
          </div>
        </div>
      </Stage>
      <Text tone="tertiary" size="small">
        通用分享弹层 <Code>ShareBottomSheet</Code>（
        <Code>lib/shared/components/share_bottom_sheet.dart</Code>，L2）同规范：玻璃态 + 顶部圆角，
        一行渠道（QQ好友/QQ空间/微信/朋友圈/分享海报）+「取消」，点渠道回调 <Code>onChannelTap</Code>。
      </Text>
    </SpecSection>
  );
}

function TopBarSection() {
  return (
    <SpecSection
        zh="顶栏"
        note="AppTopBar（L2）· 高 44 · 图标框 32 · 三槽位 leading / center / trailing"
        src="lib/shared/components/app_top_bar.dart"
      >
      <Stage>
        <div style={{ display: "flex", flexDirection: "column", gap: 12 }}>
          <GlassPlaceholder
            height={44}
            style={{ display: "flex", alignItems: "center", padding: "0 8px" }}
          >
            <Pressable style={{ width: 32, height: 32, display: "flex", alignItems: "center", justifyContent: "center" }}>
              <Glyph name="back" color={APP.text} size={20} strokeWidth={2} />
            </Pressable>
            <div style={{ flex: 1, textAlign: "center", color: APP.text, fontSize: 16, fontWeight: 600 }}>页面标题</div>
            <Pressable style={{ width: 32, height: 32, display: "flex", alignItems: "center", justifyContent: "center" }}>
              <Glyph name="search" color={APP.text} size={24} strokeWidth={2} />
            </Pressable>
          </GlassPlaceholder>
          <Caption>二级页：返回 + 标题 + 动作（图标可按压）</Caption>
        </div>
      </Stage>
    </SpecSection>
  );
}

function BottomNavSection() {
  return (
    <SpecSection
        zh="底部导航"
        note="AppBottomNav · 图标 26 · 选中弹跳（1.18→0.92→1）· hairline 描边"
        src="lib/shared/layouts/app_bottom_nav.dart"
      >
      <Stage>
        <BottomNavDemo />
        <div style={{ marginTop: 8 }}>
          <Caption>点击切换 Tab，选中图标会弹跳（放大 → 回缩 → 复位）</Caption>
        </div>
      </Stage>
    </SpecSection>
  );
}

function BottomNavDemo() {
  const tabs = [
    { zh: "书城", icon: "home" },
    { zh: "书架", icon: "shelf" },
    { zh: "福利", icon: "gift" },
    { zh: "消息", icon: "message" },
    { zh: "我的", icon: "profile" },
  ];
  const [sel, setSel] = useCanvasState<number>("demoNav", 0);
  const [bounce, setBounce] = useState(1);
  const select = (i: number) => {
    if (i === sel) return;
    setSel(i);
    setBounce(1.18);
    window.setTimeout(() => setBounce(0.92), 90);
    window.setTimeout(() => setBounce(1), 180);
  };
  return (
    <div
      style={{
        display: "flex",
        background: APP.navBg,
        border: `${APP.hair} solid ${APP.border}`,
        borderRadius: 47,
        padding: 4,
      }}
    >
      {tabs.map((t, i) => {
        const active = i === sel;
        return (
          <div
            key={t.zh}
            onClick={() => select(i)}
            style={{ flex: 1, display: "flex", flexDirection: "column", alignItems: "center", gap: 2, cursor: "pointer", userSelect: "none" }}
          >
            <div
              style={{
                width: 26,
                height: 26,
                borderRadius: 6,
                background: active ? APP.accent : APP.textMuted,
                transform: `scale(${active ? bounce : 1})`,
                transition: "transform 0.09s ease, background 0.2s",
              }}
            />
            <SelectableItem
              active={active}
              fontSize={11}
              style={{ transition: "color 0.2s", fontWeight: 400 }}
            >
              {t.zh}
            </SelectableItem>
          </div>
        );
      })}
    </div>
  );
}

function SegmentedSection() {
  return (
    <SpecSection
        zh="分段切换"
        note="AppSegmentedSwitch · 玻璃态 + 滑块动画（选中无描边，8% 黄底 + 黄字）· 书籍详情「详情/讨论/更新」、榜单频道同款（圆角 46）"
        src="lib/shared/components/app_segmented_switch.dart"
      >
      <Stage>
        <SegmentedDemo />
      </Stage>
    </SpecSection>
  );
}

function SegmentedDemo() {
  const segs = ["详情", "讨论", "更新"];
  const segWidth = 92;
  const pad = 4;
  const [sel, setSel] = useCanvasState<number>("demoSeg", 0);
  return (
    <div
      style={{
        position: "relative",
        alignSelf: "flex-start",
        display: "inline-flex",
        background: APP.surface,
        border: `${APP.hair} solid ${APP.border}`,
        borderRadius: 46,
        padding: pad,
      }}
    >
      <div
        style={{
          position: "absolute",
          top: pad,
          bottom: pad,
          left: pad + sel * segWidth,
          width: segWidth,
          background: APP.segFill,
          border: "none",
          borderRadius: 999,
          transition: "left 0.25s cubic-bezier(0.2,0,0,1)",
        }}
      />
      {segs.map((s, i) => {
        const active = i === sel;
        return (
          <SelectableItem
            key={s}
            active={active}
            onClick={() => setSel(i)}
            style={{
              position: "relative",
              width: segWidth,
              textAlign: "center",
              padding: "7px 0",
              transition: "color 0.2s",
            }}
          >
            {s}
          </SelectableItem>
        );
      })}
    </div>
  );
}

function TabIndicatorSection() {
  return (
    <SpecSection
        zh="选中指示线"
        note="ElasticTabIndicator · 线宽 24 · 平移时先拉长再回弹 · 竖向变体做侧边条"
        src="lib/shared/components/elastic_tab_indicator.dart"
      >
      <Stage>
        <TabIndicatorDemo />
      </Stage>
      <Text tone="tertiary" size="small">
        变宽（按文案实测）横向 Tab 行统一用 <Code>ElasticTabRow</Code>（
        <Code>lib/shared/components/elastic_tab_row.dart</Code>）封装测量 + 叠加指示条，
        支持跟手 <Code>swipeProgress</Code> 与主题色（书架 / 装扮 Tab 共用）。
      </Text>
      <Text tone="tertiary" size="small">
        顶部同级 Tab 栏统一用 <Code>AppTopTabBar</Code>（
        <Code>lib/shared/components/app_top_tab_bar.dart</Code>）：组合{" "}
        <Code>AppAnimatedTabLabel</Code>（选中↔未选文字 <Code>TextStyle.lerp</Code> 平滑过渡）
        + <Code>ElasticTabIndicator</Code> 黄条 + 可选未读角标（<Code>AppTopTabItem.badgeCount</Code>）；
        伙伴顶栏「探索/消息/互动」、帮助与反馈「常见问题/意见反馈」共用。
      </Text>
    </SpecSection>
  );
}

function TabIndicatorDemo() {
  const tabs = ["推荐", "分类", "榜单"];
  const slot = 64;
  const base = 24;
  const [sel, setSel] = useCanvasState<number>("demoTab", 0);
  const [w, setW] = useState(base);
  const select = (i: number) => {
    if (i === sel) return;
    setSel(i);
    setW(42);
    window.setTimeout(() => setW(base), 220);
  };
  return (
    <div style={{ position: "relative", alignSelf: "flex-start" }}>
      <div style={{ display: "flex" }}>
        {tabs.map((t, i) => {
          const active = i === sel;
          return (
            <SelectableItem
              key={t}
              active={active}
              onClick={() => select(i)}
              activeColor={APP.text}
              fontSize={15}
              style={{
                width: slot,
                textAlign: "center",
                paddingBottom: 9,
                transition: "color 0.2s",
              }}
            >
              {t}
            </SelectableItem>
          );
        })}
      </div>
      <div
        style={{
          position: "absolute",
          bottom: 0,
          left: sel * slot + slot / 2 - w / 2,
          width: w,
          height: 3,
          borderRadius: 2,
          background: APP.accent,
          transition: "left 0.28s cubic-bezier(0.2,0,0,1), width 0.2s ease",
        }}
      />
    </div>
  );
}

function SearchSection() {
  return (
    <SpecSection
        zh="搜索框"
        note="GlassChipButton · 高 40 · 圆角 35 · 放大镜图标 · hairline 描边"
        src="lib/shared/components/glass_chip_button.dart"
      >
      <Stage>
        <SearchDemo />
      </Stage>
    </SpecSection>
  );
}

function SearchDemo() {
  const [focused, setFocused] = useState(false);
  return (
    <GlassPlaceholder
      height={40}
      borderRadius={35}
      border={`${APP.hair} solid ${focused ? APP.accent : APP.border}`}
      onClick={() => setFocused((v) => !v)}
      style={{
        display: "flex",
        alignItems: "center",
        gap: 8,
        padding: "0 16px",
        color: APP.textMuted,
        fontSize: 14,
        cursor: "text",
        transition: "border-color 0.2s",
        maxWidth: 360,
      }}
    >
      <Glyph name="search" color={focused ? APP.accent : APP.textMuted} size={16} strokeWidth={2} />
      <span style={{ color: focused ? APP.text : APP.textMuted }}>搜索书名 / 作者</span>
      {focused ? (
        <span style={{ width: 1.5, height: 16, marginLeft: 2, background: APP.accent }} />
      ) : null}
    </GlassPlaceholder>
  );
}

function SwitchSection() {
  return (
    <SpecSection
        zh="开关"
        note="AppSwitch · 50×30 · 滑块 24 · 开(黄4%底+黄钮) / 关(玻璃+白钮)"
        src="lib/shared/widgets/app_switch.dart"
      >
      <Stage>
        <div style={{ display: "flex", gap: 16, alignItems: "center" }}>
          <InteractiveSwitch stateKey="demoSwitchA" initial={true} />
          <InteractiveSwitch stateKey="demoSwitchB" initial={false} />
          <Caption>点击切换</Caption>
        </div>
      </Stage>
    </SpecSection>
  );
}

function InteractiveSwitch({ stateKey, initial }: { stateKey: string; initial: boolean }) {
  const [on, setOn] = useCanvasState<boolean>(stateKey, initial);
  // 对齐 AppSwitch：50×30 · inset 3 · thumb 24 · 开 accentYellow04+黄钮 / 关 surfaceGlass+白钮
  return (
    <div
      onClick={() => setOn((v) => !v)}
      style={{
        width: 50,
        height: 30,
        borderRadius: 999,
        background: on ? "rgba(255,232,71,0.04)" : APP.glass,
        padding: 3,
        boxSizing: "border-box",
        cursor: "pointer",
        transition: "background 0.2s",
        display: "flex",
        alignItems: "center",
        justifyContent: on ? "flex-end" : "flex-start",
      }}
    >
      <div
        style={{
          width: 24,
          height: 24,
          borderRadius: 999,
          background: on ? APP.accent : APP.text,
          transition: "background 0.2s",
        }}
      />
    </div>
  );
}

function OptionSelectSection() {
  const [gender, setGender] = useCanvasState<number>("demoGender", 0);
  const [age, setAge] = useCanvasState<number>("demoAge", 1);
  const genders = ["女生", "男生"];
  const ages = ["18岁以下", "18-24岁", "25-30岁", "31岁以上"];
  return (
    <SpecSection
        zh="选项选择"
        note="GenderAvatarOption（头像图 + 黄描边环）· AgeRangeOption（选中 8% 黄底+黄字加粗；未选白字+细描边）"
        src="lib/shared/components/gender_avatar_option.dart"
      >
      <Stage>
        <Stack gap={20}>
          <div style={{ display: "flex", gap: 24 }}>
            {genders.map((g, i) => {
              const active = i === gender;
              return (
                <div
                  key={g}
                  onClick={() => setGender(i)}
                  style={{
                    display: "flex",
                    flexDirection: "column",
                    alignItems: "center",
                    gap: 8,
                    cursor: "pointer",
                    userSelect: "none",
                  }}
                >
                  {/* 对齐 GenderAvatarOption：80 圆 · surfaceCard · 选中 1.5 黄环+内间隙 · 未选 hairline；真机为彩色/灰色头像资源 */}
                  <div
                    style={{
                      width: 80,
                      height: 80,
                      borderRadius: "50%",
                      background: APP.surface,
                      border: active
                        ? `1.5px solid ${APP.accent}`
                        : `${APP.hair} solid ${APP.border}`,
                      boxSizing: "border-box",
                      padding: active ? 4 : 0,
                      transition: "border-color 0.15s, padding 0.15s",
                    }}
                  >
                    <div
                      style={{
                        width: "100%",
                        height: "100%",
                        borderRadius: "50%",
                        background: active
                          ? "linear-gradient(160deg,#FFE8A3 0%,#F0B16A 55%,#C47A4A 100%)"
                          : "linear-gradient(160deg,#6A6E76 0%,#3A3E46 100%)",
                      }}
                    />
                  </div>
                  <span
                    style={{
                      fontSize: 14,
                      color: active ? APP.text : APP.textMuted,
                      fontWeight: 400,
                    }}
                  >
                    {g}
                  </span>
                </div>
              );
            })}
          </div>
          <div style={{ display: "flex", flexDirection: "column", gap: 10, width: 260 }}>
            {ages.map((a, i) => {
              const active = i === age;
              return (
                <div
                  key={a}
                  onClick={() => setAge(i)}
                  style={{
                    padding: "12px 16px",
                    borderRadius: 999,
                    textAlign: "center",
                    cursor: "pointer",
                    userSelect: "none",
                    fontSize: 14,
                    // 对齐 AgeRangeOption：选中 segFill+黄字加粗；未选 surfaceCard+白字+细描边
                    background: active ? APP.segFill : APP.surface,
                    border: active
                      ? `${APP.hair} solid transparent`
                      : `${APP.hair} solid ${APP.border}`,
                    color: active ? APP.accent : APP.text,
                    fontWeight: active ? 600 : 400,
                    transition: "all 0.15s",
                  }}
                >
                  {a}
                </div>
              );
            })}
          </div>
        </Stack>
      </Stage>
      <Text tone="tertiary" size="small">
        画廊用渐变块代替头像 PNG；真源资源在{" "}
        <Code>assets/images/onboarding/gender_*.png</Code>。年龄胶囊源码{" "}
        <Code>lib/shared/components/age_range_option.dart</Code>
        ；新手弹窗与偏好设置页共用。
      </Text>
    </SpecSection>
  );
}

function SweepHighlightSection() {
  return (
    <SpecSection
        zh="扫光高亮层"
        note="SweepHighlightOverlay · 仅高亮带本身（白 50%→透明）· 粉渐变是宿主 CTA 示意"
        src="lib/shared/components/sweep_highlight_overlay.dart"
      >
      <Stage>
        <div style={{ display: "flex", flexDirection: "column", gap: 10 }}>
          <div
            style={{
              position: "relative",
              width: 260,
              height: 44,
              borderRadius: 999,
              overflow: "hidden",
              background: "linear-gradient(90deg,#FFDDC1,#F393DC)",
              display: "flex",
              alignItems: "center",
              justifyContent: "center",
            }}
          >
            <div
              style={{
                position: "absolute",
                top: 0,
                left: "42%",
                width: "42%",
                height: "100%",
                background:
                  "linear-gradient(90deg,rgba(255,255,255,0),rgba(255,255,255,0.5),rgba(255,255,255,0))",
                pointerEvents: "none",
              }}
            />
            <span style={{ position: "relative", color: "#740551", fontWeight: 700 }}>
              VIP 再领取1000能量
            </span>
          </div>
          <Caption>
            组件本身只有扫光带（默认 white50→透明，带宽约 42%，周期约 2200ms）；粉金底与文案来自宿主按钮（会员/福利 CTA），不是 Overlay 的样式。
          </Caption>
        </div>
      </Stage>
    </SpecSection>
  );
}

function ToastSection() {
  return (
    <SpecSection
        zh="轻提示"
        note="AppToast · 黄底 · 圆角 md · 淡入后自动消失"
        src="lib/shared/components/app_toast.dart"
      >
      <Stage>
        <ToastDemo />
      </Stage>
    </SpecSection>
  );
}

function ToastDemo() {
  const [visible, setVisible] = useState(false);
  const trigger = () => {
    setVisible(true);
    window.setTimeout(() => setVisible(false), 1600);
  };
  return (
    <div style={{ display: "flex", alignItems: "center", gap: 12, minHeight: 40 }}>
      <DemoButton variant="secondary" size="small" onClick={trigger}>
        加入书架
      </DemoButton>
      <div
        style={{
          background: APP.accent,
          color: APP.onAccent,
          borderRadius: 12,
          padding: "9px 14px",
          fontSize: 13,
          fontWeight: 600,
          opacity: visible ? 1 : 0,
          transform: visible ? "translateY(0)" : "translateY(4px)",
          transition: "opacity 0.25s, transform 0.25s",
        }}
      >
        加入书架成功
      </div>
    </div>
  );
}

function EmptyStateSection() {
  return (
    <SpecSection
        zh="空状态"
        note="EmptyState · 标题 + 说明 + 操作 · 可选 illustration / contentWidth"
        src="lib/shared/components/empty_state.dart"
      >
      <Stage>
        <div style={{ textAlign: "center", padding: "16px 0" }}>
          <div style={{ color: APP.text, fontSize: 16, fontWeight: 600 }}>暂无内容</div>
          <div style={{ color: APP.textMuted, fontSize: 13, marginTop: 6 }}>这里还没有数据</div>
        </div>
      </Stage>
    </SpecSection>
  );
}

function AsyncPageBodySection() {
  return (
    <SpecSection
        zh="异步门闸"
        note="AppAsyncPageBody（L2）· 加载中 / 失败重试 / 空数据 / 内容"
        src="lib/shared/components/app_async_page_body.dart"
      >
      <Stage>
        <div style={{ display: "flex", gap: 16, flexWrap: "wrap" }}>
          <div style={{ flex: 1, minWidth: 120, textAlign: "center", padding: 16, background: APP.surface, borderRadius: 12 }}>
            <Caption>isLoading</Caption>
            <div style={{ marginTop: 12, color: APP.textMuted, fontSize: 12 }}>CircularProgress</div>
          </div>
          <div style={{ flex: 1, minWidth: 120, textAlign: "center", padding: 16, background: APP.surface, borderRadius: 12 }}>
            <Caption>error</Caption>
            <div style={{ marginTop: 8, color: APP.text, fontSize: 14, fontWeight: 600 }}>加载失败</div>
            <div style={{ marginTop: 8 }}>
              <DemoButton variant="accent" size="small">重试</DemoButton>
            </div>
          </div>
          <div style={{ flex: 1, minWidth: 120, textAlign: "center", padding: 16, background: APP.surface, borderRadius: 12 }}>
            <Caption>empty</Caption>
            <div style={{ marginTop: 8, color: APP.text, fontSize: 14, fontWeight: 600 }}>暂无数据</div>
          </div>
        </div>
      </Stage>
    </SpecSection>
  );
}

function GroupedListCardSection() {
  return (
    <SpecSection
        zh="分组列表卡"
        note="AppGroupedListCard（L2）· 可选标题 + surfaceCard + 行间分割线"
        src="lib/shared/components/app_grouped_list_card.dart"
      >
      <Stage>
        <div style={{ color: APP.textMuted, fontSize: 13, marginBottom: 8, paddingLeft: 4 }}>账号信息</div>
        <div style={{ background: APP.surface, borderRadius: 16, overflow: "hidden" }}>
          {["头像", "昵称", "手机号"].map((label, i, arr) => (
            <div key={label}>
              <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between", padding: "14px 16px", color: APP.text, fontSize: 14 }}>
                <span>{label}</span>
                <span style={{ color: APP.textMuted, fontSize: 12 }}>›</span>
              </div>
              {i < arr.length - 1 ? (
                <div style={{ height: 1, background: APP.border, margin: "0 16px" }} />
              ) : null}
            </div>
          ))}
        </div>
      </Stage>
    </SpecSection>
  );
}

function NavigationListRowSection() {
  return (
    <SpecSection
        zh="导航列表行"
        note="AppNavigationListRow（L2）· 标题 + 可选副标题/尾部 + 箭头"
        src="lib/shared/components/app_navigation_list_row.dart"
      >
      <Stage>
        <div style={{ background: APP.surface, borderRadius: 16 }}>
          <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between", padding: "14px 16px" }}>
            <div>
              <div style={{ color: APP.text, fontSize: 14 }}>消息通知</div>
              <div style={{ color: APP.textMuted, fontSize: 12, marginTop: 2 }}>推送与站内信</div>
            </div>
            <span style={{ color: APP.textMuted, fontSize: 12 }}>›</span>
          </div>
        </div>
      </Stage>
    </SpecSection>
  );
}

function ListLoadMoreFooterSection() {
  return (
    <SpecSection
        zh="加载更多脚"
        note="AppListLoadMoreFooter（L2）· 列表底部上拉加载 · asSliver 可选"
        src="lib/shared/components/app_list_load_more_footer.dart"
      >
      <Stage>
        <div style={{ textAlign: "center", padding: "20px 0" }}>
          <div
            style={{
              width: 22,
              height: 22,
              margin: "0 auto",
              borderRadius: "50%",
              border: `2px solid ${APP.border}`,
              borderTopColor: APP.accent,
            }}
          />
          <div style={{ marginTop: 8 }}>
            <Caption>isLoading · bookstoreLoadingIndicator*</Caption>
          </div>
        </div>
      </Stage>
    </SpecSection>
  );
}

function SectionHeaderSection() {
  return (
    <SpecSection
        zh="区块标题"
        note="SectionHeader · 标题 + 右侧操作链接"
        src="lib/shared/components/section_header.dart"
      >
      <Stage>
        <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between" }}>
          <span style={{ color: APP.text, fontSize: 16, fontWeight: 600 }}>猜你喜欢</span>
          <Pressable style={{ display: "flex", alignItems: "center", gap: 2, color: APP.textMuted, fontSize: 12 }}>
            <span>更多</span>
            <Glyph name="arrow" color={APP.textMuted} size={12} strokeWidth={2} />
          </Pressable>
        </div>
      </Stage>
    </SpecSection>
  );
}
