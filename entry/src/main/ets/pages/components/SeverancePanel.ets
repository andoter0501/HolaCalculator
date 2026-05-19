import { SeveranceType } from '../../common/Types';
import { formatMoney, parseNumber } from '../../common/Utils';
import { SeveranceResult, calculateSeverance } from '../../common/SeveranceCalculator';
import {
  COLOR_PRIMARY,
  COLOR_PRIMARY_SOFT,
  COLOR_TEXT_PRIMARY,
  COLOR_TEXT_MUTED,
  COLOR_TEXT_BODY,
  COLOR_TEXT_ON_PRIMARY,
  COLOR_SURFACE,
  COLOR_LINE,
  COLOR_LINE_LIGHT,
  COLOR_CARD_DARK,
  COLOR_CARD_DARK_TEXT,
  COLOR_CARD_DARK_MUTED,
  RADIUS_SM
} from '../../common/DesignTokens';

@Component
export struct SeverancePanel {
  @Link severanceType: SeveranceType;
  @Link severanceMultiplier: string;
  @Link workYears: string;
  @Link monthlySalary: string;
  @Link bonus: string;
  @Link localAvgSalary: string;

  private getSeveranceResult(): SeveranceResult {
    return calculateSeverance(
      this.severanceType,
      parseNumber(this.workYears),
      parseNumber(this.monthlySalary),
      parseNumber(this.bonus),
      parseNumber(this.localAvgSalary),
      parseNumber(this.severanceMultiplier) || 1
    );
  }

  private getSeveranceTypeLabel(): string {
    if (this.severanceType === 'n') return '经济补偿金（N）';
    if (this.severanceType === 'n1') return '经济补偿金 + 代通知金（N+1）';
    if (this.severanceType === 'n2') return '违法解除赔偿金（2N）';
    return `赔偿金（${this.severanceMultiplier || '?'}N）`;
  }

  private getSeveranceTypeNote(): string {
    const years: number = parseNumber(this.workYears);
    const result: SeveranceResult = this.getSeveranceResult();
    if (this.severanceType === 'n') {
      return `工作年限 ${years} 年 × 月均工资 ${formatMoney(result.avgMonthlySalary)}`;
    }
    if (this.severanceType === 'n1') {
      return `工作年限 ${years} 年 × 月均工资 ${formatMoney(result.avgMonthlySalary)} + 1 个月代通知金`;
    }
    if (this.severanceType === 'n2') {
      return `工作年限 ${years} 年 × 月均工资 ${formatMoney(result.avgMonthlySalary)} × 2 倍`;
    }
    const mult: string = this.severanceMultiplier || '?';
    return `工作年限 ${years} 年 × 月均工资 ${formatMoney(result.avgMonthlySalary)} × ${mult} 倍`;
  }

  @Builder
  SeveranceTypeToggle() {
    Column() {
      Text('赔偿类型')
        .fontSize(13)
        .fontWeight(FontWeight.Bold)
        .fontColor(COLOR_TEXT_BODY)
        .margin({ bottom: 7 })
      Row() {
        Button('N')
          .height(38)
          .layoutWeight(1)
          .margin({ right: 4 })
          .fontSize(13)
          .fontColor(this.severanceType === 'n' ? COLOR_TEXT_ON_PRIMARY : COLOR_PRIMARY)
          .backgroundColor(this.severanceType === 'n' ? COLOR_PRIMARY : COLOR_PRIMARY_SOFT)
          .onClick((): void => {
            this.severanceType = 'n';
          })
        Button('N+1')
          .height(38)
          .layoutWeight(1)
          .margin({ left: 4, right: 4 })
          .fontSize(13)
          .fontColor(this.severanceType === 'n1' ? COLOR_TEXT_ON_PRIMARY : COLOR_PRIMARY)
          .backgroundColor(this.severanceType === 'n1' ? COLOR_PRIMARY : COLOR_PRIMARY_SOFT)
          .onClick((): void => {
            this.severanceType = 'n1';
          })
        Button('2N')
          .height(38)
          .layoutWeight(1)
          .margin({ left: 4, right: 4 })
          .fontSize(13)
          .fontColor(this.severanceType === 'n2' ? COLOR_TEXT_ON_PRIMARY : COLOR_PRIMARY)
          .backgroundColor(this.severanceType === 'n2' ? COLOR_PRIMARY : COLOR_PRIMARY_SOFT)
          .onClick((): void => {
            this.severanceType = 'n2';
          })
        Button('自定义')
          .height(38)
          .layoutWeight(1)
          .margin({ left: 4 })
          .fontSize(13)
          .fontColor(this.severanceType === 'custom' ? COLOR_TEXT_ON_PRIMARY : COLOR_PRIMARY)
          .backgroundColor(this.severanceType === 'custom' ? COLOR_PRIMARY : COLOR_PRIMARY_SOFT)
          .onClick((): void => {
            this.severanceType = 'custom';
          })
      }
      .width('100%')
    }
    .width('100%')
    .margin({ bottom: 12 })
  }

  @Builder
  InputField(
    label: string,
    value: string,
    placeholder: string,
    onChange: (value: string) => void,
    inputType: InputType = InputType.NUMBER_DECIMAL
  ) {
    Column() {
      Text(label)
        .fontSize(13)
        .fontWeight(FontWeight.Bold)
        .fontColor(COLOR_TEXT_BODY)
        .margin({ bottom: 7 })
      TextInput({ text: value, placeholder: placeholder })
        .height(44)
        .fontSize(16)
        .backgroundColor(COLOR_SURFACE)
        .borderRadius(RADIUS_SM)
        .border({ width: 1, color: COLOR_LINE })
        .padding({ left: 12, right: 12 })
        .type(inputType)
        .onChange(onChange)
    }
    .width('100%')
    .margin({ bottom: 12 })
  }

  @Builder
  ResultCard() {
    Column() {
      Text(this.getSeveranceTypeLabel())
        .fontSize(13)
        .fontWeight(FontWeight.Bold)
        .fontColor(COLOR_CARD_DARK_TEXT)
      Text(formatMoney(this.getSeveranceResult().severance))
        .fontSize(34)
        .fontWeight(FontWeight.Bold)
        .fontColor(COLOR_TEXT_ON_PRIMARY)
        .width('100%')
        .margin({ top: 10, bottom: 8 })
      Text(this.getSeveranceTypeNote())
        .fontSize(13)
        .fontColor(COLOR_CARD_DARK_MUTED)
        .lineHeight(19)
    }
    .width('100%')
    .padding(18)
    .borderRadius(RADIUS_SM)
    .backgroundColor(COLOR_CARD_DARK)
    .margin({ top: 18 })
  }

  @Builder
  MetricList() {
    Column() {
      Row() {
        Text('工作年限（N）')
          .fontSize(14)
          .fontColor(COLOR_TEXT_MUTED)
        Text(`${parseNumber(this.workYears)} 年`)
          .fontSize(15)
          .fontWeight(FontWeight.Bold)
          .fontColor(COLOR_TEXT_PRIMARY)
          .textAlign(TextAlign.End)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      .padding({ top: 12, bottom: 12 })
      .border({ width: { bottom: 1 }, color: COLOR_LINE_LIGHT })

      Row() {
        Text('离职前12个月平均月工资')
          .fontSize(14)
          .fontColor(COLOR_TEXT_MUTED)
        Text(formatMoney(this.getSeveranceResult().avgMonthlySalary))
          .fontSize(15)
          .fontWeight(FontWeight.Bold)
          .fontColor(COLOR_TEXT_PRIMARY)
          .textAlign(TextAlign.End)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      .padding({ top: 12, bottom: 12 })
      .border({ width: { bottom: 1 }, color: COLOR_LINE_LIGHT })

      if (this.getSeveranceResult().isCapped) {
        Row() {
          Text('封顶后月工资')
            .fontSize(14)
            .fontColor(COLOR_TEXT_MUTED)
          Text(formatMoney(this.getSeveranceResult().cappedSalary))
            .fontSize(15)
            .fontWeight(FontWeight.Bold)
            .fontColor(COLOR_TEXT_PRIMARY)
            .textAlign(TextAlign.End)
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .width('100%')
        .padding({ top: 12, bottom: 12 })
        .border({ width: { bottom: 1 }, color: COLOR_LINE_LIGHT })

        Row() {
          Text('有效年限')
            .fontSize(14)
            .fontColor(COLOR_TEXT_MUTED)
          Text(`${this.getSeveranceResult().effectiveYears} 年（上限 12 年）`)
            .fontSize(15)
            .fontWeight(FontWeight.Bold)
            .fontColor(COLOR_TEXT_PRIMARY)
            .textAlign(TextAlign.End)
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .width('100%')
        .padding({ top: 12, bottom: 12 })
        .border({ width: { bottom: 1 }, color: COLOR_LINE_LIGHT })
      }

      if (this.severanceType === 'custom') {
        Row() {
          Text('赔偿倍数')
            .fontSize(14)
            .fontColor(COLOR_TEXT_MUTED)
          Text(`${this.severanceMultiplier || '?'} N`)
            .fontSize(15)
            .fontWeight(FontWeight.Bold)
            .fontColor(COLOR_TEXT_PRIMARY)
            .textAlign(TextAlign.End)
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .width('100%')
        .padding({ top: 12, bottom: 12 })
        .border({ width: { bottom: 1 }, color: COLOR_LINE_LIGHT })
      }

      Row() {
        Text(this.severanceType === 'custom' ? '赔偿金' : '经济补偿金')
          .fontSize(14)
          .fontColor(COLOR_TEXT_MUTED)
        Text(formatMoney(this.getSeveranceResult().severance))
          .fontSize(15)
          .fontWeight(FontWeight.Bold)
          .fontColor(COLOR_PRIMARY)
          .textAlign(TextAlign.End)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      .padding({ top: 12, bottom: 12 })
      .border({ width: { bottom: 1 }, color: COLOR_LINE_LIGHT })

      if (this.severanceType === 'n1') {
        Row() {
          Text('代通知金（+1）')
            .fontSize(14)
            .fontColor(COLOR_TEXT_MUTED)
          Text(formatMoney(this.getSeveranceResult().noticePay))
            .fontSize(15)
            .fontWeight(FontWeight.Bold)
            .fontColor(COLOR_PRIMARY)
            .textAlign(TextAlign.End)
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .width('100%')
        .padding({ top: 12, bottom: 12 })
        .border({ width: { bottom: 1 }, color: COLOR_LINE_LIGHT })
      }

      Row() {
        Text('赔偿总额')
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor(COLOR_TEXT_PRIMARY)
        Text(formatMoney(this.getSeveranceResult().total))
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor(COLOR_PRIMARY)
          .textAlign(TextAlign.End)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      .padding({ top: 12, bottom: 12 })
    }
    .width('100%')
    .margin({ top: 16 })
  }

  @Builder
  CapWarning() {
    Column() {
      Text(`⚠️ 离职前12个月平均工资 ${formatMoney(this.getSeveranceResult().avgMonthlySalary)} 超过当地社平工资三倍（${formatMoney(this.getSeveranceResult().cappedSalary)}），已按封顶标准计算，年限上限 12 年。`)
        .fontSize(13)
        .fontColor('#A85F00')
        .lineHeight(19)
    }
    .width('100%')
    .padding(12)
    .borderRadius(RADIUS_SM)
    .backgroundColor('#FFF7E8')
    .margin({ top: 12 })
  }

  build() {
    Column() {
      Text('裁员赔偿金')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .fontColor(COLOR_TEXT_PRIMARY)
        .margin({ bottom: 4 })
      Text('N · N+1 · 2N · 自定义赔偿倍数，按《劳动合同法》计算')
        .fontSize(14)
        .fontColor(COLOR_TEXT_MUTED)
        .lineHeight(21)
        .margin({ bottom: 14 })

      this.SeveranceTypeToggle()
      this.InputField('工作年限（年）', this.workYears, '如 3.5', (value: string): void => {
        this.workYears = value;
      })
      this.InputField('每月基本工资（元）', this.monthlySalary, '如 15000', (value: string): void => {
        this.monthlySalary = value;
      })
      this.InputField('年度奖金（可选，元）', this.bonus, '如 30000', (value: string): void => {
        this.bonus = value;
      })
      this.InputField('当地社平工资（可选，元/月）', this.localAvgSalary, '填入后自动触发三倍封顶', (value: string): void => {
        this.localAvgSalary = value;
      })

      if (this.severanceType === 'custom') {
        this.InputField('赔偿倍数', this.severanceMultiplier, '如 1.5', (value: string): void => {
          this.severanceMultiplier = value;
        })
      }

      this.ResultCard()
      this.MetricList()

      if (this.getSeveranceResult().isCapped) {
        this.CapWarning()
      }
    }
    .width('100%')
  }
}
