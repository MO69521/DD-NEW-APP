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
  glass: "rgba(255,255,255,0.08)", // white08
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

export default function DesignSystemSpec() {
  return (
    <Stack gap={28} style={{ padding: 32, maxWidth: 1040 }}>
      <CoverHeader />
      <SummaryStats />

      <Callout tone="warning" title="关于「改一处，全局生效」">
        <Stack gap={4}>
          <Text>
            这份可视化文档是 <Text weight="semibold">组件目录 / 预览</Text>
            ，用于对照与定位；它本身是 React 预览，<Text weight="semibold">不是</Text>
            应用的运行源码。
          </Text>
          <Text>
            真正「改一处即全局生效」的源头是 Dart 代码：设计 token 在{" "}
            <Code>lib/core/theme/*</Code>，共享组件在 <Code>lib/shared/*</Code>。
            全项目都引用它们，改动即全局同步。
          </Text>
          <Text>
            用法：在下方找到组件 → 点它的「源码」路径打开真源 → 告诉我要改什么，我改这一处 Dart，页面即全局更新。
          </Text>
        </Stack>
      </Callout>

      <PartBanner
        index="01"
        title="视觉基础规范"
        subtitle="字号 · 行高 · 字重 · 字体族 · 颜色 · 间距 · 圆角"
      />
      <TypeScaleSection />
      <LineHeightSection />
      <WeightSection />
      <FontFamilySection />
      <ColorSection />
      <SpacingSection />
      <RadiusSection />
      <SizeIndexSection />

      <Divider />

      <PartBanner
        index="02"
        title="组件规范与样式展现"
        subtitle="每个组件独占一行 · 可点击体验 · 附源码入口"
      />
      <ButtonSection />
      <CardSection />
      <DialogSection />
      <SheetSection />
      <TopBarSection />
      <BottomNavSection />
      <SegmentedSection />
      <TabIndicatorSection />
      <SearchSection />
      <SwitchSection />
      <SweepHighlightSection />
      <ToastSection />
      <EmptyStateSection />
      <SectionHeaderSection />

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
  const stats: Array<[string, string]> = [
    ["8", "字号档"],
    ["4", "行高档"],
    ["6", "字重档"],
    ["8", "间距档"],
    ["5", "圆角档"],
    ["14", "核心组件"],
  ];
  return (
    <Grid columns={6} gap={12}>
      {stats.map(([value, label]) => (
        <Stat key={label} value={value} label={label} />
      ))}
    </Grid>
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
    <Stack gap={16} style={{ marginTop: 28, marginBottom: 12 }}>
      <Divider />
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
        <Stack gap={2}>
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
type BtnVariant = "accent" | "secondary" | "outline";
type BtnSize = "normal" | "compact" | "small";

const BTN_VARIANTS: Record<
  BtnVariant,
  { bg: string; fg: string; radius: number; border: boolean }
> = {
  accent: { bg: APP.accent, fg: APP.onAccent, radius: 999, border: false },
  secondary: { bg: APP.surface, fg: "#FFFFFF", radius: 999, border: false },
  outline: { bg: "transparent", fg: "#FFFFFF", radius: 999, border: true },
};

const BTN_SIZES: Record<BtnSize, { pad: string; fs: number; fw: number }> = {
  normal: { pad: "12px 24px", fs: 16, fw: 700 },
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
    <Stack gap={10}>
      <SectionTitle
        zh="字号（8 档）"
        note="AppFontSizes"
        src="lib/core/theme/app_text_styles.dart"
      />
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
    </Stack>
  );
}

function LineHeightSection() {
  return (
    <Stack gap={10}>
      <SectionTitle
        zh="行高（4 档）"
        note="AppLineHeights"
        src="lib/core/theme/app_text_styles.dart"
      />
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
    </Stack>
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
    <Stack gap={10}>
      <SectionTitle
        zh="字重（6 档）"
        note="AppFontWeights"
        src="lib/core/theme/app_text_styles.dart"
      />
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
    </Stack>
  );
}

function FontFamilySection() {
  return (
    <Stack gap={10}>
      <SectionTitle
        zh="字体族 · 定制数字字体"
        note="AppFontFamilies"
        src="lib/core/theme/app_text_styles.dart"
      />
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
    </Stack>
  );
}

function ColorSection() {
  return (
    <Stack gap={14}>
      <SectionTitle
        zh="颜色(单一真源)"
        note="AppColors · AppBrandColors"
        src="lib/core/theme/app_colors.dart"
      />

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
            ["white08", "8%", "0x14FFFFFF", "玻璃面 / 分隔"],
            ["white06", "6%", "0x0FFFFFFF", "回复区底"],
            ["white05", "5%", "0x0DFFFFFF", "卡片弱底"],
            ["white04", "4%", "0x0AFFFFFF", "卡片面 / 描边 / 标签底"],
            ["white00", "0%", "0x00FFFFFF", "渐变透明端"],
          ].map((r) => r.map(cell))}
        />
      </Stack>

      <Grid columns={2} gap={16}>
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
      </Grid>

      <Stack gap={8}>
        <Text weight="semibold">品牌 / 主题源色</Text>
        <BrandSwatches />
        <Text tone="tertiary" size="small">
          福利金 <Code>#935C1A</Code>、伙伴粉 <Code>#FF4D88</Code>、VIP 粉{" "}
          <Code>#F393DC</Code>、签到高亮 <Code>#FFDD47</Code>、会员金渐变{" "}
          <Code>#FFE794→#FFCD5A</Code>、面板深字 <Code>#202020</Code> 等 feature
          色均定义于此，被各 feature 色板引用。
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
          ].map((r) => r.map(cell))}
        />
      </Stack>
    </Stack>
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
    ["success", "#10B981", "成功", "#FFFFFF"],
    ["warning", "#F59E0B", "警告", "#131820"],
    ["error", "#EF4444", "错误", "#FFFFFF"],
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
    <Stack gap={10}>
      <SectionTitle
        zh="间距（8 档）"
        note="AppSpacing · 基阶 2·4·8·12·16·24·32·48"
        src="lib/core/theme/app_spacing.dart"
      />
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
    </Stack>
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
    <Stack gap={10}>
      <SectionTitle
        zh="圆角（5 档）"
        note="AppRadius · 基阶 4·12·16·24·full"
        src="lib/core/theme/app_radius.dart"
      />
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
    </Stack>
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
    ["伙伴页", "头部 / 角色卡 / 消息 Tab / 互动 Tab", "partner*"],
    ["分类页", "筛选组 / chip / 下划线", "categoryFilter*"],
    ["帮助与反馈", "Banner / 输入 / 上传框", "helpFeedback*"],
    ["Toast / 交互阈值", "轻提示内边距 / 滑动切换阈值", "toast* · swipeTabVelocityThreshold"],
  ];
  return (
    <Stack gap={10}>
      <SectionTitle
        zh="组件尺寸 token · 分组索引"
        note="AppSizes · 组件级布局精确值（真值随源码为准）"
        src="lib/core/theme/app_sizes.dart"
      />
      <Text tone="tertiary" size="small">
        尺寸档不同于上方基阶体系，是按页面/组件命名的精确值集合。下表仅作「按 feature 分组」的导航索引，改值只改 <Code>app_sizes.dart</Code> 一处。
      </Text>
      <Table
        headers={["分组", "覆盖范围", "Token 前缀 / 示例"]}
        columnAlign={["left", "left", "left"]}
        rows={groups.map(([g, cover, prefix]) => [g, cover, <Code key={g}>{prefix}</Code>])}
      />
    </Stack>
  );
}

/* ───────────────── 第二部分 · 组件（每个独占一行）───────────────── */

function ButtonSection() {
  const variants: Array<{ zh: string; code: BtnVariant }> = [
    { zh: "主 CTA", code: "accent" },
    { zh: "次操作", code: "secondary" },
    { zh: "描边", code: "outline" },
  ];
  const sizes: BtnSize[] = ["normal", "compact", "small"];
  return (
    <Stack gap={12}>
      <SectionTitle
        zh="按钮"
        note="AppButton（L1）· 3 视觉变体 × 3 尺寸 · 弹窗等组件复用它"
        src="lib/shared/widgets/app_button.dart"
      />

      <Text weight="semibold">视觉变体（不同样式）</Text>
      <Stage>
        <div style={{ display: "flex", gap: 20, flexWrap: "wrap" }}>
          {variants.map((b) => (
            <div key={b.code} style={{ display: "flex", flexDirection: "column", gap: 8 }}>
              <DemoButton variant={b.code}>{b.zh}</DemoButton>
              <Caption>{b.code}</Caption>
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
        ].map((r) => r.map(cell))}
      />

      <Text weight="semibold">尺寸（不同大小）</Text>
      <Stage>
        <div style={{ display: "flex", gap: 24, alignItems: "center", flexWrap: "wrap" }}>
          {sizes.map((s) => (
            <div key={s} style={{ display: "flex", flexDirection: "column", gap: 8, alignItems: "flex-start" }}>
              <DemoButton variant="accent" size={s}>
                按钮
              </DemoButton>
              <Caption>{s}</Caption>
            </div>
          ))}
        </div>
      </Stage>
      <Table
        headers={["尺寸", "内边距 H×V", "文字", "使用场景"]}
        columnAlign={["left", "left", "left", "left"]}
        rows={[
          ["normal", "24 × 12", "16 · bold", "页面 / 弹窗主按钮（默认）"],
          ["small", "16 × 8", "14 · medium", "卡片内 / 行内小操作（领取、去书城）"],
          ["compact", "24 × 8", "14 · medium", "紧凑行内操作（卡包页）"],
        ].map((r) => r.map(cell))}
      />

      <Text tone="tertiary" size="small">
        状态：默认 · 加载中 · 禁用（前景 40%）· 撑满宽度 <Code>isExpanded</Code>；
        可选前置图标 <Code>leadingIcon</Code>。描边一律 0.5px hairline。
      </Text>
    </Stack>
  );
}

function CardSection() {
  return (
    <Stack gap={10}>
      <SectionTitle
        zh="卡片"
        note="书卡族 · 底 4% 白底 + 圆角 · 禁止卡中卡 · 可点按"
        src="lib/shared/components/book_card_variants.dart"
      />
      <Stage>
        <div style={{ display: "flex", flexDirection: "column", gap: 20 }}>
          <Pressable style={{ width: 112 }}>
            <div style={{ height: 150, background: APP.glass, borderRadius: 12, marginBottom: 8 }} />
            <div style={{ color: APP.text, fontSize: 14, fontWeight: 600 }}>示例书名标题</div>
            <div style={{ color: APP.textMuted, fontSize: 12, marginTop: 4 }}>都市 · 悬疑</div>
            <div style={{ marginTop: 8 }}>
              <Caption>竖版 BookCardVertical · 上图下文</Caption>
            </div>
          </Pressable>
          <Pressable style={{ display: "flex", gap: 12, width: 300 }}>
            <div style={{ width: 72, height: 96, flexShrink: 0, background: APP.glass, borderRadius: 12 }} />
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
    </Stack>
  );
}

function DialogSection() {
  return (
    <Stack gap={10}>
      <SectionTitle
        zh="弹窗"
        note="showAppBlurredDialog · 80% 纯黑遮罩(无模糊) · 圆角 xl · 关闭钮 DialogCloseButton"
        src="lib/shared/components/app_blurred_dialog.dart"
      />
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
            <div style={{ color: APP.text, fontSize: 16, fontWeight: 700, textAlign: "center" }}>提示标题</div>
            <div style={{ color: APP.textMuted, fontSize: 13, lineHeight: 1.5, textAlign: "center", marginTop: 8 }}>
              居中弹窗，弹窗底 #131820、圆角 xl，背后 80% 纯黑遮罩（无模糊）。
            </div>
            <div style={{ display: "flex", gap: 10, marginTop: 18 }}>
              <DemoButton variant="outline" expand>
                取消
              </DemoButton>
              <DemoButton variant="accent" expand>
                确定
              </DemoButton>
            </div>
          </div>
        </div>
      </Stage>
      <Text tone="tertiary" size="small">
        弹窗内的「取消 / 确定」即 <Code>AppButton</Code>（取消 <Code>outline</Code>、
        确定 <Code>accent</Code>，各 <Code>Expanded</Code> 平分宽度）。改按钮组件，全项目弹窗按钮同步。
      </Text>
    </Stack>
  );
}

function SheetSection() {
  const options = ["综合排序", "最新更新", "人气最高", "字数最多"];
  const [selected, setSelected] = useCanvasState<number>("demoSheetSelected", 0);
  return (
    <Stack gap={10}>
      <SectionTitle
        zh="底部弹层"
        note="showModalBottomSheet · 顶部圆角 + 玻璃 · 可选中"
        src="lib/features/partner/presentation/components/partner_filter_sheet.dart"
      />
      <Stage style={{ padding: 0, overflow: "hidden" }}>
        <div style={{ background: "rgba(0,0,0,0.45)", paddingTop: 36 }}>
          <div style={{ background: APP.dialogBg, borderTopLeftRadius: 20, borderTopRightRadius: 20, borderTop: `${APP.hair} solid ${APP.border}`, padding: "16px 0" }}>
            <div style={{ color: APP.text, fontSize: 15, fontWeight: 600, padding: "0 16px 8px" }}>筛选</div>
            {options.map((o, i) => {
              const active = i === selected;
              return (
                <div
                  key={o}
                  onClick={() => setSelected(i)}
                  style={{
                    display: "flex",
                    alignItems: "center",
                    justifyContent: "space-between",
                    padding: "12px 16px",
                    cursor: "pointer",
                    userSelect: "none",
                    color: active ? APP.accent : APP.textMuted,
                    fontSize: 14,
                    fontWeight: active ? 600 : 400,
                    background: active ? "rgba(255,232,71,0.06)" : "transparent",
                    transition: "color 0.15s, background 0.15s",
                  }}
                >
                  <span>{o}</span>
                  <span style={{ opacity: active ? 1 : 0, transition: "opacity 0.15s" }}>✓</span>
                </div>
              );
            })}
          </div>
        </div>
      </Stage>
    </Stack>
  );
}

function TopBarSection() {
  return (
    <Stack gap={10}>
      <SectionTitle
        zh="顶栏"
        note="AppTopBar（L2）· 三槽位 leading / center / trailing"
        src="lib/shared/components/app_top_bar.dart"
      />
      <Stage>
        <div style={{ display: "flex", flexDirection: "column", gap: 12 }}>
          <div style={{ display: "flex", alignItems: "center", height: 48, padding: "0 8px", background: APP.glass, borderRadius: 12 }}>
            <Pressable style={{ width: 40, height: 40, display: "flex", alignItems: "center", justifyContent: "center" }}>
              <Glyph name="back" color={APP.text} size={22} strokeWidth={2} />
            </Pressable>
            <div style={{ flex: 1, textAlign: "center", color: APP.text, fontSize: 16, fontWeight: 600 }}>页面标题</div>
            <Pressable style={{ width: 40, height: 40, display: "flex", alignItems: "center", justifyContent: "center" }}>
              <Glyph name="search" color={APP.text} size={20} strokeWidth={2} />
            </Pressable>
          </div>
          <Caption>二级页：返回 + 标题 + 动作（图标可按压）</Caption>
        </div>
      </Stage>
    </Stack>
  );
}

function BottomNavSection() {
  return (
    <Stack gap={10}>
      <SectionTitle
        zh="底部导航"
        note="AppBottomNav · 图标 26 · 选中弹跳（1.18→0.92→1）· hairline 描边"
        src="lib/shared/layouts/app_bottom_nav.dart"
      />
      <Stage>
        <BottomNavDemo />
        <div style={{ marginTop: 8 }}>
          <Caption>点击切换 Tab，选中图标会弹跳（放大 → 回缩 → 复位）</Caption>
        </div>
      </Stage>
    </Stack>
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
        justifyContent: "space-between",
        background: APP.glass,
        border: `${APP.hair} solid ${APP.border}`,
        borderRadius: 999,
        padding: "8px 20px",
      }}
    >
      {tabs.map((t, i) => {
        const active = i === sel;
        return (
          <div
            key={t.zh}
            onClick={() => select(i)}
            style={{ display: "flex", flexDirection: "column", alignItems: "center", gap: 4, cursor: "pointer", userSelect: "none" }}
          >
            <div
              style={{
                transform: `scale(${active ? bounce : 1})`,
                transition: "transform 0.09s ease",
                lineHeight: 0,
              }}
            >
              <Glyph name={t.icon} color={active ? APP.accent : APP.textMuted} size={26} strokeWidth={1.8} />
            </div>
            <span style={{ fontSize: 11, color: active ? APP.accent : APP.textMuted, transition: "color 0.2s" }}>{t.zh}</span>
          </div>
        );
      })}
    </div>
  );
}

function SegmentedSection() {
  return (
    <Stack gap={10}>
      <SectionTitle
        zh="分段切换"
        note="AppSegmentedSwitch · 玻璃态 + 黄色滑块动画"
        src="lib/shared/components/app_segmented_switch.dart"
      />
      <Stage>
        <SegmentedDemo />
      </Stage>
    </Stack>
  );
}

function SegmentedDemo() {
  const segs = ["书架", "阅读历史"];
  const segWidth = 104;
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
        borderRadius: 16,
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
          border: `${APP.hair} solid ${APP.accent}`,
          borderRadius: 12,
          transition: "left 0.25s cubic-bezier(0.2,0,0,1)",
        }}
      />
      {segs.map((s, i) => {
        const active = i === sel;
        return (
          <div
            key={s}
            onClick={() => setSel(i)}
            style={{
              position: "relative",
              width: segWidth,
              textAlign: "center",
              padding: "7px 0",
              fontSize: 14,
              cursor: "pointer",
              userSelect: "none",
              color: active ? APP.accent : APP.textMuted,
              fontWeight: active ? 600 : 400,
              transition: "color 0.2s",
            }}
          >
            {s}
          </div>
        );
      })}
    </div>
  );
}

function TabIndicatorSection() {
  return (
    <Stack gap={10}>
      <SectionTitle
        zh="选中指示线"
        note="ElasticTabIndicator · 线宽 24 · 平移时先拉长再回弹"
        src="lib/shared/components/elastic_tab_indicator.dart"
      />
      <Stage>
        <TabIndicatorDemo />
      </Stage>
    </Stack>
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
            <div
              key={t}
              onClick={() => select(i)}
              style={{
                width: slot,
                textAlign: "center",
                paddingBottom: 9,
                fontSize: 15,
                cursor: "pointer",
                userSelect: "none",
                color: active ? APP.text : APP.textMuted,
                fontWeight: active ? 600 : 400,
                transition: "color 0.2s",
              }}
            >
              {t}
            </div>
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
    <Stack gap={10}>
      <SectionTitle
        zh="搜索框"
        note="GlassChipButton · 高 40 · 圆角 35 · 放大镜图标 · hairline 描边"
        src="lib/shared/components/glass_chip_button.dart"
      />
      <Stage>
        <SearchDemo />
      </Stage>
    </Stack>
  );
}

function SearchDemo() {
  const [focused, setFocused] = useState(false);
  return (
    <div
      onClick={() => setFocused((v) => !v)}
      style={{
        display: "flex",
        alignItems: "center",
        gap: 8,
        height: 40,
        borderRadius: 35,
        background: APP.glass,
        border: `${APP.hair} solid ${focused ? APP.accent : APP.border}`,
        padding: "0 14px",
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
    </div>
  );
}

function SwitchSection() {
  return (
    <Stack gap={10}>
      <SectionTitle
        zh="开关"
        note="AppSwitch · 50×30 · 滑块 24 · 开(黄) / 关(玻璃)"
        src="lib/shared/widgets/app_switch.dart"
      />
      <Stage>
        <div style={{ display: "flex", gap: 16, alignItems: "center" }}>
          <InteractiveSwitch stateKey="demoSwitchA" initial={true} />
          <InteractiveSwitch stateKey="demoSwitchB" initial={false} />
          <Caption>点击切换</Caption>
        </div>
      </Stage>
    </Stack>
  );
}

function InteractiveSwitch({ stateKey, initial }: { stateKey: string; initial: boolean }) {
  const [on, setOn] = useCanvasState<boolean>(stateKey, initial);
  return (
    <div
      onClick={() => setOn((v) => !v)}
      style={{ width: 50, height: 30, borderRadius: 999, background: on ? APP.accent : APP.glass, padding: 3, cursor: "pointer", transition: "background 0.2s" }}
    >
      <div
        style={{
          width: 24,
          height: 24,
          borderRadius: 999,
          background: "#FFFFFF",
          transform: on ? "translateX(20px)" : "translateX(0)",
          transition: "transform 0.2s cubic-bezier(0.2,0,0,1)",
        }}
      />
    </div>
  );
}

function SweepHighlightSection() {
  return (
    <Stack gap={10}>
      <SectionTitle
        zh="扫光高亮层"
        note="SweepHighlightOverlay · 高亮带循环左→右滑过"
        src="lib/shared/components/sweep_highlight_overlay.dart"
      />
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
            {/* 静态示意：实际为高亮带循环从左滑到右 */}
            <div
              style={{
                position: "absolute",
                top: 0,
                left: "42%",
                width: "42%",
                height: "100%",
                background:
                  "linear-gradient(90deg,rgba(255,255,255,0),rgba(255,255,255,0.5),rgba(255,255,255,0))",
              }}
            />
            <span style={{ position: "relative", color: "#740551", fontWeight: 700 }}>
              VIP 再领取1000能量
            </span>
          </div>
          <Caption>
            高亮带（默认 white50→透明）循环从左滑到右；带宽 42% · 周期 2200ms。会员开通 CTA、福利签到 CTA、签到成功弹窗 VIP 按钮统一复用。
          </Caption>
        </div>
      </Stage>
    </Stack>
  );
}

function ToastSection() {
  return (
    <Stack gap={10}>
      <SectionTitle
        zh="轻提示"
        note="AppToast · 黄底 · 圆角 md · 淡入后自动消失"
        src="lib/shared/components/app_toast.dart"
      />
      <Stage>
        <ToastDemo />
      </Stage>
    </Stack>
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
    <Stack gap={10}>
      <SectionTitle
        zh="空状态"
        note="EmptyState · 标题 + 说明 + 操作"
        src="lib/shared/components/empty_state.dart"
      />
      <Stage>
        <div style={{ textAlign: "center", padding: "16px 0" }}>
          <div style={{ color: APP.text, fontSize: 16, fontWeight: 600 }}>暂无内容</div>
          <div style={{ color: APP.textMuted, fontSize: 13, marginTop: 6 }}>这里还没有数据</div>
        </div>
      </Stage>
    </Stack>
  );
}

function SectionHeaderSection() {
  return (
    <Stack gap={10}>
      <SectionTitle
        zh="区块标题"
        note="SectionHeader · 标题 + 右侧操作链接"
        src="lib/shared/components/section_header.dart"
      />
      <Stage>
        <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between" }}>
          <span style={{ color: APP.text, fontSize: 16, fontWeight: 600 }}>猜你喜欢</span>
          <Pressable style={{ display: "flex", alignItems: "center", gap: 2, color: APP.textMuted, fontSize: 12 }}>
            <span>更多</span>
            <Glyph name="arrow" color={APP.textMuted} size={12} strokeWidth={2} />
          </Pressable>
        </div>
      </Stage>
    </Stack>
  );
}
