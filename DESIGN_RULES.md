# HolaCalculator UI Design Rules

## Design Tokens

所有颜色、圆角必须从 `common/DesignTokens.ets` 导入，禁止硬编码值（例外：警告横幅 `#FFF7E8`/`#A85F00`、遮罩 `rgba(16,39,41,0.38)`/`#00000099`）。

### Color Palette

| Token | Value | Usage |
|---|---|---|
| `COLOR_PRIMARY` | `#147C78` | 品牌色、active 状态、= 按钮 |
| `COLOR_PRIMARY_SOFT` | `#DFF2F0` | 次要按钮、运算符、表格头 |
| `COLOR_PRIMARY_PALE` | `#F0F9F8` | active 背景 |
| `COLOR_BG` | `#F5F7F8` | 页面背景 |
| `COLOR_SURFACE` | `#FFFFFF` | 白色卡片、数字按钮 |
| `COLOR_SURFACE_2` | `#EEF4F3` | 次要按钮背景 |
| `COLOR_SURFACE_3` | `#F8FAFA` | 交替背景 |
| `COLOR_TEXT_PRIMARY` | `#182326` | 标题、主显示 |
| `COLOR_TEXT_BODY` | `#334247` | 正文 |
| `COLOR_TEXT_MUTED` | `#667579` | 次要说明 |
| `COLOR_TEXT_PLACEHOLDER` | `#9AA7AA` | 占位符、禁用按钮 |
| `COLOR_LINE` | `#DCE5E4` | 标准边框（输入框） |
| `COLOR_LINE_LIGHT` | `#E4ECEB` | 浅色边框（卡片轮廓） |
| `COLOR_CARD_DARK` | `#102729` | 深色结果卡片背景 |
| `COLOR_CARD_DARKER` | `#0D2B2D` | 更深色结果卡片变体 |
| `COLOR_CARD_DARK_TEXT` | `rgba(255,255,255,0.72)` | 深色卡片标签文字 |
| `COLOR_CARD_DARK_MUTED` | `rgba(255,255,255,0.68)` | 深色卡片辅助文字 |

### Border Radius

| Token | Value | Usage |
|---|---|---|
| `RADIUS_SM` | 8 | 输入框、按钮、结果卡片、列表项 |
| `RADIUS_MD` | 12 | 分类图标方块、换算行、计算器容器 |
| `RADIUS_LG` | 20 | 底部弹窗上角 |

## Panel Container

每个功能面板遵循统一容器结构：

```ets
Column() { /* panel content */ }
  .width('100%').padding(18)
  .borderRadius(16)
  .backgroundColor(Color.White)
  .border({ width: 1, color: COLOR_LINE_LIGHT })
```

外层 Scroll: `padding({ left: 16, right: 16, top: 10, bottom: 28 })`

## Panel 内容结构

```
Text("标题")        // fontSize: 16, Bold, COLOR_TEXT_PRIMARY, margin.bottom: 12
Text("描述")        // fontSize: 14, COLOR_TEXT_MUTED, lineHeight: 21, margin.bottom: 14-16
// 表单控件...
// 结果卡片...
// 指标列表...
```

## 表单输入

```
Column() {
  Text("标签").fontSize(13).Bold.COLOR_TEXT_BODY.margin({ bottom: 7 })
  TextInput(...)
    .height(44).fontSize(16)
    .backgroundColor(COLOR_SURFACE)
    .borderRadius(RADIUS_SM)
    .border({ width: 1, color: COLOR_LINE })
    .padding({ left: 12, right: 12 })
}
.width('100%').margin({ bottom: 12 })
```

## 切换按钮组

- height: 38, layoutWeight 相等, fontSize: 13
- active: `COLOR_PRIMARY` bg + `Color.White` text
- inactive: `COLOR_PRIMARY_SOFT` bg + `COLOR_PRIMARY` text
- 按钮间距: 相邻按钮 margin left/right 各 4（总间距 8px）

## 深色结果卡片

```
Column() {
  Text("标签").fontSize(13).Bold.COLOR_CARD_DARK_TEXT
  Text("数值").fontSize(34).Bold.Color.White.margin({ top: 10, bottom: 8 })
  Text("备注").fontSize(13).COLOR_CARD_DARK_MUTED
}
.padding(18).borderRadius(RADIUS_SM).backgroundColor(COLOR_CARD_DARK).margin({ top: 18 })
```

## 指标列表行

```
Row() {
  Text("标签").fontSize(14).COLOR_TEXT_MUTED
  Text("数值").fontSize(15).Bold.COLOR_TEXT_PRIMARY.textAlign(TextAlign.End)
}
.justifyContent(FlexAlign.SpaceBetween).width('100%')
.padding({ top: 12, bottom: 12 })
.border({ width: { bottom: 1 }, color: COLOR_LINE_LIGHT })
```

## 标签栏卡片网格

- 图标容器: 51x51, borderRadius RADIUS_MD, 白色背景
- 卡片尺寸: 72w x 78h
- 图标字号: 22
- 标题: fontSize 13, Bold, margin top 6
- 固定 2 行，列数 = `ceil(总数/2)`，第 2 行不足补充空白，上下每列对齐
- 超出屏幕宽度水平滑动
- 卡片尺寸: 72w x 78h，水平间距 10，垂直间距 8
- 分隔线 (tab 下): 无
- 水平滚动, BarState.Off

## 普通计算器按钮

- 数字: `COLOR_TEXT_PRIMARY` + 白色背景
- 运算符: `COLOR_PRIMARY` + `COLOR_PRIMARY_SOFT`
- 功能(C/⌫): `COLOR_TEXT_MUTED` + `COLOR_SURFACE_2`
- height: 54, fontSize: 28, borderRadius: 27 (圆形)
- =按钮: height 118, width 58, primary 背景, 白色文字
- 4列固定网格, 按钮间距 4-5px
- 阴影: radius 8, rgba(30,47,50,0.08), offsetY 4
- =阴影: radius 10, rgba(20,124,120,0.25), offsetY 5

## Stopwatch

- 计时文字: fontSize 42, Bold, 居中
- 按钮: height 42, layoutWeight 1
- 开始/暂停: primary bg
- 计次/重置: COLOR_SURFACE_2 bg
- 计次列表: SpaceBetween, padding top/bottom 12, 底部边框 COLOR_LINE_LIGHT

## 单位换算

- 输入/结果行: height 78, padding 14, RADIUS_MD, border 1.5 COLOR_LINE
- 输入框: fontSize 30, Bold, 透明背景
- 单位选择器: height 48, COLOR_SURFACE_2, borderRadius 10
- 交换按钮: 54x54, 圆形, primary 主题

## 弹窗样式

**居中弹窗 (分类编辑)**:
- 遮罩: `rgba(16,39,41,0.38)`
- 内容: width 82%, borderRadius 14, COLOR_SURFACE_3 bg

**底部弹窗 (单位选择)**:
- 遮罩: `#00000099`
- 内容: 圆角上20下0, 阴影 offsetY -8
- 手柄条: 38x4, borderRadius 2, COLOR_LINE

## 布局间距

| 位置 | 数值 |
|---|---|
| 页面左右边距 | 16 |
| 面板容器内边距 | 18 |
| 组件间垂直间距 | 12 |
| 表单字段间距 | bottom margin 12 |
| 结果卡片上方间距 | margin top 18 |
| 标签栏内边距 | left:18, right:10, top:4, bottom:6 |

## 状态管理

- `Index.ets` 持有所有 `@State`
- 子面板通过 `@Link` 接收/修改状态
- 回调通过箭头函数传递
- 子面板 `无 @State`（除 StopwatchPanel 的 `timerId`）

## 字号规范

| 大小 | 用途 |
|---|---|
| 42 | 计算器主显示、计时器 |
| 30-34 | 换算值、结果数值 |
| 28 | App 标题、计算器按钮 |
| 22 | 单位名称 |
| 20 | 弹窗标题 |
| 16 | 面板标题 |
| 14-15 | 正文、指标值 |
| 13 | 标签、说明、指标标签 |
| 11-12 | 辅助文字 |

## 边框规范

- active: `{ width: 1, color: COLOR_PRIMARY }`
- inactive: `{ width: 1, color: COLOR_LINE_LIGHT }`
- 输入框: `{ width: 1, color: COLOR_LINE }`
- 表格分隔: `{ width: { bottom: 1 }, color: COLOR_LINE_LIGHT }`
- 换算行边框: width 1.5

## 检查项清单

每次修改 UI 后，逐项检查：

- [ ] 1. 颜色值是否从 `DesignTokens.ets` 导入？无硬编码色值
- [ ] 2. 圆角是否使用 `RADIUS_SM/MD/LG`？
- [ ] 3. 面板容器是否统一使用 18px padding + 16px borderRadius + white bg + 1px COLOR_LINE_LIGHT border？
- [ ] 4. 滚动区域是否使用 `padding({ left: 16, right: 16, top: 10, bottom: 28 })`？
- [ ] 5. 表单输入是否统一: height 44, fontSize 16, RADIUS_SM, COLOR_LINE border, 12px horizontal padding？
- [ ] 6. 切换按钮: height 38, 相等权重, 4px 间距？
- [ ] 7. 结果卡片: dark bg, fontSize 34 数值, 18px padding？
- [ ] 8. 指标列表: SpaceBetween, 12px 垂直 padding, 底部边框？
- [ ] 9. 标签栏: 72x78 卡片, 图标51x51, RADIUS_MD, 固定2行列数=ceil(总数/2)？
- [ ] 10. 页面不持有硬编码字符串作为字号/间距？
- [ ] 11. 子面板是否通过 `@Link` 接收状态？
- [ ] 12. 字体大小属于规范字号列表？
- [ ] 13. 边框宽度与颜色符合规范？
- [ ] 14. 阴影参数是否符合 Category/Calculator 规范？
