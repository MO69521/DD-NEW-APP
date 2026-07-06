import {
  Stack,
  Row,
  Grid,
  H1,
  H2,
  H3,
  Text,
  Code,
  Table,
  Callout,
  Divider,
  Pill,
  useHostTheme,
  mergeStyle,
} from "cursor/canvas";

/**
 * 点点穿书 · 深色 UI 设计规范（token 基线）
 * 来源：lib/core/theme/*.dart（2026-07-06 收敛后）。
 */
export default function DesignSystemSpec() {
  return (
    <Stack gap={26} style={{ padding: 24, maxWidth: 1040 }}>
      <Stack gap={6}>
        <H1>深色 UI 设计规范</H1>
        <Text tone="secondary">
          收敛后的 token 基线：字号 / 行高 / 字重 / 颜色 / 间距 / 圆角。
          UI 层禁止写死数值，一律引用下列 token；换色系走
          <Code>--dart-define=THEME</Code>。
        </Text>
        <Text tone="tertiary" size="small">
          源：<Code>lib/core/theme/*.dart</Code> · 2026-07-06
        </Text>
      </Stack>

      <TypeScaleSection />
      <Divider />
      <LineHeightSection />
      <Divider />
      <WeightSection />
      <Divider />
      <ColorSection />
      <Divider />
      <SpacingSection />
      <Divider />
      <RadiusSection />
      <Divider />

      <Callout tone="info" title="使用约定">
        <Stack gap={4}>
          <Text>
            1. UI 只用 token：禁止 <Code>Color(0x…)</Code> / <Code>fontSize 数字</Code> /
            <Code>EdgeInsets 数字</Code> / <Code>BorderRadius.circular 数字</Code>。
          </Text>
          <Text>
            2. 单一真源：中性叠加色→<Code>AppColors</Code> 白/黑阶；品牌与主题源色→
            <Code>AppBrandColors</Code>；背景蒙版→<Code>bgTint</Code> 阶。
          </Text>
          <Text>
            3. 换色系：在 <Code>AppBrandColors</Code> 按 <Code>themeId</Code> 加分支，
            构建时 <Code>--dart-define=THEME=pink</Code>；默认不带参永远是深色。
          </Text>
        </Stack>
      </Callout>
    </Stack>
  );
}

function TypeScaleSection() {
  const sizes: Array<[string, number]> = [
    ["xxs", 9],
    ["xs", 10],
    ["sm", 11],
    ["md", 12],
    ["base", 14],
    ["lg", 16],
    ["xl", 18],
    ["xxl", 24],
    ["display", 32],
  ];
  return (
    <Stack gap={10}>
      <H2>字号 · AppFontSizes（9 档）</H2>
      <Stack gap={8}>
        {sizes.map(([name, px]) => (
          <div
            key={name}
            style={{ display: "flex", gap: 16, alignItems: "center" }}
          >
            <Text tone="tertiary" size="small" style={{ width: 72 }}>
              <Code>{name}</Code>
            </Text>
            <Text tone="tertiary" size="small" style={{ width: 40 }}>
              {px}
            </Text>
            <Text style={mergeStyle({ fontSize: px, lineHeight: 1.2 })}>
              示例文字 Aa 快速换肤 123
            </Text>
          </div>
        ))}
      </Stack>
    </Stack>
  );
}

function LineHeightSection() {
  return (
    <Stack gap={10}>
      <H2>行高 · AppLineHeights（6 档）</H2>
      <Table
        headers={["Token", "值", "用途"]}
        columnAlign={["left", "center", "left"]}
        rows={[
          ["none", "1.0", "单行标签 / 数字 / 图标旁文字"],
          ["tight", "1.2", "大标题 / display"],
          ["snug", "1.3", "标题"],
          ["normal", "1.4", "副标题 / 紧凑正文"],
          ["relaxed", "1.5", "正文段落"],
          ["loose", "1.75", "多行说明 / 协议类长文"],
        ]}
      />
    </Stack>
  );
}

function WeightSection() {
  const weights: Array<[string, number]> = [
    ["regular", 400],
    ["medium", 500],
    ["semibold", 600],
    ["bold", 700],
    ["heavy", 800],
    ["black", 900],
  ];
  return (
    <Stack gap={10}>
      <H2>字重 · AppFontWeights（6 档）</H2>
      <Grid columns={3} gap={12}>
        {weights.map(([name, w]) => (
          <div
            key={name}
            style={{ display: "flex", gap: 10, alignItems: "center" }}
          >
            <Text style={mergeStyle({ fontSize: 18, fontWeight: w })}>
              示例 Aa
            </Text>
            <Text tone="tertiary" size="small">
              <Code>{name}</Code> {w}
            </Text>
          </div>
        ))}
      </Grid>
    </Stack>
  );
}

function ColorSection() {
  return (
    <Stack gap={14}>
      <H2>颜色 · 单一真源</H2>

      <Stack gap={8}>
        <H3>中性阶 · 白色透明度叠加（AppColors.whiteNN）</H3>
        <Table
          headers={["Token", "不透明度", "ARGB", "典型用途"]}
          columnAlign={["left", "center", "left", "left"]}
          rows={[
            ["white100", "100%", "0xFFFFFFFF", "主文字 textOnDark"],
            ["white85", "85%", "0xD9FFFFFF", "次强调文字"],
            ["white60", "60%", "0x99FFFFFF", "muted / placeholder / icon"],
            ["white50", "50%", "0x80FFFFFF", "弱化文字 / 扫光高亮"],
            ["white24", "24%", "0x3DFFFFFF", "头图蒙版软档"],
            ["white20", "20%", "0x33FFFFFF", "分隔线 / 导航底"],
            ["white08", "8%", "0x14FFFFFF", "surfaceGlass / divider"],
            ["white06", "6%", "0x0FFFFFFF", "回复区底"],
            ["white05", "5%", "0x0DFFFFFF", "卡片弱底"],
            ["white04", "4%", "0x0AFFFFFF", "surfaceCard / 描边 / 标签底"],
            ["white00", "0%", "0x00FFFFFF", "渐变透明端"],
          ]}
        />
      </Stack>

      <Grid columns={2} gap={16}>
        <Stack gap={8}>
          <H3>中性阶 · 黑色透明度（遮罩）</H3>
          <Table
            headers={["Token", "不透明度", "用途"]}
            columnAlign={["left", "center", "left"]}
            rows={[
              ["black80", "80%", "无模糊弹窗遮罩"],
              ["black60", "60%", "封面选择遮罩"],
              ["black40", "40%", "选中态封面遮罩"],
              ["black30", "30%", "顶栏图标框 / 通用遮罩"],
              ["black08", "8%", "顶栏图标框底"],
              ["black04", "4%", "封面描边 / 签到底"],
              ["black00", "0%", "渐变透明端"],
            ]}
          />
        </Stack>
        <Stack gap={8}>
          <H3>背景 tint 阶（随 THEME 换色系）</H3>
          <Text tone="secondary" size="small">
            基于基础背景 <Code>#090E17</Code> 的不同透明度，用于渐隐 / 毛玻璃底 /
            头图蒙版。换色系时整条随基础背景色相变化。
          </Text>
          <Row gap={6} wrap>
            <Pill>bgTint00</Pill>
            <Pill>bgTint35</Pill>
            <Pill>bgTint45</Pill>
            <Pill>bgTint55</Pill>
            <Pill>bgTint60</Pill>
            <Pill>bgTint80</Pill>
            <Pill>bgTint90</Pill>
          </Row>
        </Stack>
      </Grid>

      <Stack gap={8}>
        <H3>品牌 / 主题源色（AppBrandColors）</H3>
        <Table
          headers={["Token", "Hex", "角色"]}
          columnAlign={["left", "left", "left"]}
          rowTone={[
            "info",
            "warning",
            "neutral",
            "success",
            "warning",
            "danger",
          ]}
          rows={[
            ["backgroundDark", "#090E17", "全局背景（主题源色）"],
            ["accent", "#FFE847", "主强调色（黄）"],
            ["dialogBackground", "#131820", "弹窗底"],
            ["success", "#10B981", "成功"],
            ["warning", "#F59E0B", "警告"],
            ["error", "#EF4444", "错误"],
          ]}
        />
        <Text tone="tertiary" size="small">
          feature 品牌色（福利金 <Code>#935C1A</Code>、伙伴粉 <Code>#FF4D88</Code>、
          VIP 粉 <Code>#F393DC</Code> 等）均定义于此，被各 feature 色板引用。
        </Text>
      </Stack>
    </Stack>
  );
}

function SpacingSection() {
  const theme = useHostTheme();
  const items: Array<[string, number, string]> = [
    ["xxsHalf", 2, "极小间隔"],
    ["countdownValueInset", 3, "倒计时数字内边距"],
    ["xxs", 4, "紧凑间隔"],
    ["insetXs", 6, "小内边距"],
    ["xs", 8, "常用小间距"],
    ["sm", 12, "常用间距"],
    ["insetMd", 14, "中内边距"],
    ["md", 16, "区块内边距"],
    ["lg", 24, "区块间距"],
    ["xl", 32, "大区块间距"],
    ["xxl", 48, "超大间距"],
    ["authTitleContentGap", 50, "登录标题-内容间距"],
  ];
  return (
    <Stack gap={10}>
      <H2>间距 · AppSpacing</H2>
      <Text tone="secondary" size="small">
        基阶 <Code>4 · 8 · 12 · 16 · 24 · 32 · 48</Code>；
        <Code>3 / 6 / 14 / 50</Code> 为语义化一次性值（保留）。
      </Text>
      <Stack gap={6}>
        {items.map(([name, px, use]) => (
          <div
            key={name}
            style={{ display: "flex", gap: 14, alignItems: "center" }}
          >
            <Text tone="tertiary" size="small" style={{ width: 176 }}>
              <Code>{name}</Code>
            </Text>
            <Text size="small" style={{ width: 32 }}>
              {px}
            </Text>
            <div
              style={{
                width: px,
                height: 12,
                background: theme.accent.primary,
                borderRadius: 2,
              }}
            />
            <Text tone="tertiary" size="small">
              {use}
            </Text>
          </div>
        ))}
      </Stack>
    </Stack>
  );
}

function RadiusSection() {
  const theme = useHostTheme();
  const items: Array<[string, number, string]> = [
    ["xs", 4, "小角标 / 输入"],
    ["coverSm", 6, "封面"],
    ["sm", 8, "小卡片"],
    ["md", 12, "卡片"],
    ["lg", 16, "大卡片 / 区块"],
    ["xl", 24, "弹窗"],
    ["cta", 26, "CTA / 胶囊按钮（多处 26 的真源）"],
    ["full", 999, "全圆 / 药丸"],
  ];
  return (
    <Stack gap={10}>
      <H2>圆角 · AppRadius</H2>
      <Text tone="secondary" size="small">
        基阶 <Code>4 · 8 · 12 · 16 · 24 · full</Code> + <Code>coverSm 6</Code> +
        <Code>cta 26</Code>；feature 专用圆角在此之上按页面命名。
      </Text>
      <Grid columns={4} gap={16}>
        {items.map(([name, r, use]) => (
          <div
            key={name}
            style={{ display: "flex", gap: 10, alignItems: "center" }}
          >
            <div
              style={{
                width: 40,
                height: 40,
                flexShrink: 0,
                background: theme.fill.tertiary,
                border: `1px solid ${theme.stroke.secondary}`,
                borderRadius: Math.min(r, 20),
              }}
            />
            <Stack gap={2}>
              <Text size="small">
                <Code>{name}</Code> {r}
              </Text>
              <Text tone="tertiary" size="small">
                {use}
              </Text>
            </Stack>
          </div>
        ))}
      </Grid>
    </Stack>
  );
}
