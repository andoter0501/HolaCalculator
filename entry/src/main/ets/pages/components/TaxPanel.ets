import { CalculatorKey, DeductionItem, HousingRentTier, TaxDeductionState } from '../../common/Types';
import { DEDUCTION_ITEMS, TAX_MONTHS } from '../../common/Constants';
import { formatMoney, parseNumber } from '../../common/Utils';
import {
  getAnnualHousingFundDeduction,
  getAnnualSocialSecurityDeduction,
  getAnnualSpecialDeduction,
  getMonthlyHousingFund,
  getMonthlyNetIncome,
  getMonthlySocialSecurity,
  getMonthlyTax,
  getTaxableIncome,
  getTaxDue
} from '../../common/TaxCalculator';

@Component
export struct TaxPanel {
  @Link monthlyIncome: string;
  @Link monthlyBasicDeduction: string;
  @Link socialSecurityMode: string;
  @Link housingFundMode: string;
  @Link socialSecurityRate: string;
  @Link socialSecurityFixed: string;
  @Link housingFundRate: string;
  @Link housingFundFixed: string;
  @Link deductions: Map<string, TaxDeductionState>;
  @Link housingRentTier: HousingRentTier;

  private getDeductionEnabled(key: string): boolean {
    const state: TaxDeductionState | undefined = this.deductions.get(key);
    return state !== undefined && state.enabled;
  }

  private getDeductionAmount(key: string): string {
    const state: TaxDeductionState | undefined = this.deductions.get(key);
    return state !== undefined ? state.amount : '0';
  }

  private setDeductionEnabled(key: string, enabled: boolean): void {
    const next: Map<string, TaxDeductionState> = new Map(this.deductions);
    const existing: TaxDeductionState | undefined = next.get(key);
    if (existing !== undefined) {
      next.set(key, { enabled: enabled, amount: existing.amount });
    }
    this.deductions = next;
  }

  private setDeductionAmount(key: string, value: string): void {
    const next: Map<string, TaxDeductionState> = new Map(this.deductions);
    const existing: TaxDeductionState | undefined = next.get(key);
    if (existing !== undefined) {
      next.set(key, { enabled: existing.enabled, amount: value });
    }
    this.deductions = next;
  }

  private getDeductionAmountLabel(key: string): string {
    if (key === 'seriousIllness') {
      return '扣除金额（元/年）';
    }
    return '扣除金额（元/月）';
  }

  private getHousingRentAmountByTier(tier: HousingRentTier): string {
    if (tier === 'large') {
      return '1500';
    }
    if (tier === 'medium') {
      return '1100';
    }
    return '800';
  }

  private setHousingRentTier(tier: HousingRentTier): void {
    this.housingRentTier = tier;
    this.setDeductionAmount('housingRent', this.getHousingRentAmountByTier(tier));
  }

  @Builder
  InputField(
    label: string,
    value: string,
    placeholder: string,
    onChange: (value: string) => void,
    inputType: InputType = InputType.Normal
  ) {
    Column() {
      Text(label)
        .fontSize(13)
        .fontWeight(FontWeight.Bold)
        .fontColor('#415155')
        .margin({ bottom: 7 })
      TextInput({ text: value, placeholder: placeholder })
        .height(44)
        .fontSize(16)
        .backgroundColor('#FBFDFD')
        .borderRadius(8)
        .border({ width: 1, color: '#DCE5E4' })
        .padding({ left: 12, right: 12 })
        .type(inputType)
        .onChange(onChange)
    }
    .width('100%')
    .margin({ bottom: 12 })
  }

  @Builder
  SocialSecurityModeToggle() {
    Column() {
      Text('社保扣除方式')
        .fontSize(13)
        .fontWeight(FontWeight.Bold)
        .fontColor('#415155')
        .margin({ bottom: 7 })
      Row() {
        Button('按比例')
          .height(38)
          .layoutWeight(1)
          .fontSize(13)
          .fontColor(this.socialSecurityMode === 'rate' ? Color.White : '#147C78')
          .backgroundColor(this.socialSecurityMode === 'rate' ? '#147C78' : '#DFF2F0')
          .margin({ right: 4 })
          .onClick((): void => {
            this.socialSecurityMode = 'rate';
          })
        Button('固定额度')
          .height(38)
          .layoutWeight(1)
          .fontSize(13)
          .fontColor(this.socialSecurityMode === 'fixed' ? Color.White : '#147C78')
          .backgroundColor(this.socialSecurityMode === 'fixed' ? '#147C78' : '#DFF2F0')
          .margin({ left: 4 })
          .onClick((): void => {
            this.socialSecurityMode = 'fixed';
          })
      }
      .width('100%')
    }
    .width('100%')
    .margin({ bottom: 12 })
  }

  @Builder
  HousingFundModeToggle() {
    Column() {
      Text('公积金扣除方式')
        .fontSize(13)
        .fontWeight(FontWeight.Bold)
        .fontColor('#415155')
        .margin({ bottom: 7 })
      Row() {
        Button('按比例')
          .height(38)
          .layoutWeight(1)
          .fontSize(13)
          .fontColor(this.housingFundMode === 'rate' ? Color.White : '#147C78')
          .backgroundColor(this.housingFundMode === 'rate' ? '#147C78' : '#DFF2F0')
          .margin({ right: 4 })
          .onClick((): void => {
            this.housingFundMode = 'rate';
          })
        Button('固定额度')
          .height(38)
          .layoutWeight(1)
          .fontSize(13)
          .fontColor(this.housingFundMode === 'fixed' ? Color.White : '#147C78')
          .backgroundColor(this.housingFundMode === 'fixed' ? '#147C78' : '#DFF2F0')
          .margin({ left: 4 })
          .onClick((): void => {
            this.housingFundMode = 'fixed';
          })
      }
      .width('100%')
    }
    .width('100%')
    .margin({ bottom: 12 })
  }

  @Builder
  DeductionItemCard(item: DeductionItem) {
    Column() {
      Row() {
        Text(this.getDeductionEnabled(item.key) ? '✓' : '')
          .width(28)
          .height(28)
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
          .textAlign(TextAlign.Center)
          .borderRadius(8)
          .backgroundColor(this.getDeductionEnabled(item.key) ? '#147C78' : '#DCE5E4')
        Column() {
          Text(item.title)
            .fontSize(14)
            .fontWeight(FontWeight.Bold)
            .fontColor('#182326')
          Text(`${item.standard}  ${item.note}`)
            .fontSize(12)
            .fontColor('#667579')
            .lineHeight(17)
            .margin({ top: 3 })
        }
        .alignItems(HorizontalAlign.Start)
        .layoutWeight(1)
        .margin({ left: 10 })
      }
      .width('100%')
      .onClick((): void => {
        this.setDeductionEnabled(item.key, !this.getDeductionEnabled(item.key));
      })

      this.InputField(this.getDeductionAmountLabel(item.key), this.getDeductionAmount(item.key), '请输入扣除额', (value: string): void => {
        this.setDeductionAmount(item.key, value);
      }, InputType.NUMBER_DECIMAL)
    }
    .width('100%')
    .padding(12)
    .borderRadius(8)
    .backgroundColor(this.getDeductionEnabled(item.key) ? '#F1FBFA' : '#FFFFFF')
    .border({ width: 1, color: this.getDeductionEnabled(item.key) ? '#147C78' : '#E4ECEB' })
    .margin({ bottom: 10 })
  }

  @Builder
  TaxResultCard() {
    Column() {
      Text('年度应纳税额')
        .fontSize(13)
        .fontWeight(FontWeight.Bold)
        .fontColor('rgba(255,255,255,0.72)')
      Text(formatMoney(getTaxDue(this.monthlyIncome, this.monthlyBasicDeduction,
        this.socialSecurityMode, this.socialSecurityRate, this.socialSecurityFixed,
        this.housingFundMode, this.housingFundRate, this.housingFundFixed, this.deductions)))
        .fontSize(34)
        .fontWeight(FontWeight.Bold)
        .fontColor(Color.White)
        .width('100%')
        .margin({ top: 10, bottom: 8 })
      Text('估算结果仅供参考，未覆盖城市社保、公积金差异。')
        .fontSize(13)
        .fontColor('rgba(255,255,255,0.68)')
        .lineHeight(19)
    }
    .width('100%')
    .padding(18)
    .borderRadius(8)
    .backgroundColor('#102729')
    .margin({ top: 18 })
  }

  @Builder
  TaxMetricList() {
    Column() {
      Row() {
        Text('应纳税所得额')
          .fontSize(14)
          .fontColor('#667579')
        Text(formatMoney(getTaxableIncome(this.monthlyIncome, this.monthlyBasicDeduction,
          this.socialSecurityMode, this.socialSecurityRate, this.socialSecurityFixed,
          this.housingFundMode, this.housingFundRate, this.housingFundFixed, this.deductions)))
          .fontSize(15)
          .fontWeight(FontWeight.Bold)
          .fontColor('#182326')
          .textAlign(TextAlign.End)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      .padding({ top: 12, bottom: 12 })
      .border({ width: { bottom: 1 }, color: '#E4ECEB' })

      Row() {
        Text('年度起征扣除')
          .fontSize(14)
          .fontColor('#667579')
        Text(formatMoney(parseNumber(this.monthlyBasicDeduction) * 12))
          .fontSize(15)
          .fontWeight(FontWeight.Bold)
          .fontColor('#182326')
          .textAlign(TextAlign.End)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      .padding({ top: 12, bottom: 12 })
      .border({ width: { bottom: 1 }, color: '#E4ECEB' })

      Row() {
        Text('社保年度扣除')
          .fontSize(14)
          .fontColor('#667579')
        Text(formatMoney(getAnnualSocialSecurityDeduction(this.monthlyIncome,
          this.socialSecurityMode, this.socialSecurityRate, this.socialSecurityFixed)))
          .fontSize(15)
          .fontWeight(FontWeight.Bold)
          .fontColor('#182326')
          .textAlign(TextAlign.End)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      .padding({ top: 12, bottom: 12 })
      .border({ width: { bottom: 1 }, color: '#E4ECEB' })

      Row() {
        Text('公积金年度扣除')
          .fontSize(14)
          .fontColor('#667579')
        Text(formatMoney(getAnnualHousingFundDeduction(this.monthlyIncome,
          this.housingFundMode, this.housingFundRate, this.housingFundFixed)))
          .fontSize(15)
          .fontWeight(FontWeight.Bold)
          .fontColor('#182326')
          .textAlign(TextAlign.End)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      .padding({ top: 12, bottom: 12 })
      .border({ width: { bottom: 1 }, color: '#E4ECEB' })

      Row() {
        Text('专项附加扣除')
          .fontSize(14)
          .fontColor('#667579')
        Text(formatMoney(getAnnualSpecialDeduction(this.deductions)))
          .fontSize(15)
          .fontWeight(FontWeight.Bold)
          .fontColor('#182326')
          .textAlign(TextAlign.End)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      .padding({ top: 12, bottom: 12 })
      .border({ width: { bottom: 1 }, color: '#E4ECEB' })

      Row() {
        Text('税后总收入')
          .fontSize(14)
          .fontColor('#667579')
        Text(formatMoney(parseNumber(this.monthlyIncome) * 12 -
          getAnnualSocialSecurityDeduction(this.monthlyIncome, this.socialSecurityMode, this.socialSecurityRate, this.socialSecurityFixed) -
          getAnnualHousingFundDeduction(this.monthlyIncome, this.housingFundMode, this.housingFundRate, this.housingFundFixed) -
          getTaxDue(this.monthlyIncome, this.monthlyBasicDeduction, this.socialSecurityMode, this.socialSecurityRate, this.socialSecurityFixed,
            this.housingFundMode, this.housingFundRate, this.housingFundFixed, this.deductions)))
          .fontSize(15)
          .fontWeight(FontWeight.Bold)
          .fontColor('#182326')
          .textAlign(TextAlign.End)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      .padding({ top: 12, bottom: 12 })
      .border({ width: { bottom: 1 }, color: '#E4ECEB' })
    }
    .width('100%')
    .margin({ bottom: 12 })
  }

  @Builder
  MonthlyTaxTable() {
    Column() {
      Text('月度扣税明细')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .fontColor('#182326')
        .margin({ bottom: 10 })
      Row() {
        Text('月份')
          .layoutWeight(1)
          .fontSize(13)
          .fontWeight(FontWeight.Bold)
          .fontColor('#415155')
        Text('扣税')
          .layoutWeight(1)
          .fontSize(13)
          .fontWeight(FontWeight.Bold)
          .fontColor('#415155')
          .textAlign(TextAlign.End)
        Text('到手工资')
          .layoutWeight(1)
          .fontSize(13)
          .fontWeight(FontWeight.Bold)
          .fontColor('#415155')
          .textAlign(TextAlign.End)
      }
      .width('100%')
      .padding({ left: 12, right: 12, top: 10, bottom: 10 })
      .backgroundColor('#DFF2F0')
      .borderRadius({ topLeft: 8, topRight: 8, bottomLeft: 0, bottomRight: 0 })

      Column() {
        ForEach(TAX_MONTHS, (month: number) => {
          Row() {
            Text(`${month}月`)
              .layoutWeight(1)
              .fontSize(13)
              .fontColor('#667579')
            Text(formatMoney(getMonthlyTax(month, this.monthlyIncome, this.monthlyBasicDeduction,
              this.socialSecurityMode, this.socialSecurityRate, this.socialSecurityFixed,
              this.housingFundMode, this.housingFundRate, this.housingFundFixed, this.deductions)))
              .layoutWeight(1)
              .fontSize(13)
              .fontColor('#182326')
              .textAlign(TextAlign.End)
            Text(formatMoney(getMonthlyNetIncome(month, this.monthlyIncome,
              this.socialSecurityMode, this.socialSecurityRate, this.socialSecurityFixed,
              this.housingFundMode, this.housingFundRate, this.housingFundFixed,
              this.monthlyBasicDeduction, this.deductions)))
              .layoutWeight(1)
              .fontSize(13)
              .fontWeight(FontWeight.Bold)
              .fontColor('#182326')
              .textAlign(TextAlign.End)
          }
          .width('100%')
          .padding({ left: 12, right: 12, top: 11, bottom: 11 })
          .border({ width: { bottom: 1 }, color: '#E4ECEB' })
        }, (month: number): string => `${month}`)
      }
      .width('100%')
      .border({ width: { left: 1, right: 1, bottom: 1 }, color: '#E4ECEB' })
      .borderRadius({ topLeft: 0, topRight: 0, bottomLeft: 8, bottomRight: 8 })
    }
    .width('100%')
    .margin({ top: 16, bottom: 12 })
  }

  build() {
    Column() {
      Text('个税估算')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .fontColor('#182326')
        .margin({ bottom: 12 })
      Text('按中国大陆综合所得年度口径估算，起征点、社保、公积金和专项附加扣除均可调整。')
        .fontSize(14)
        .fontColor('#667579')
        .lineHeight(21)
        .margin({ bottom: 16 })
      this.InputField('月收入（元）', this.monthlyIncome, '请输入月收入', (value: string): void => {
        this.monthlyIncome = value;
      }, InputType.NUMBER_DECIMAL)
      this.InputField('起征点（元/月）', this.monthlyBasicDeduction, '请输入起征点', (value: string): void => {
        this.monthlyBasicDeduction = value;
      }, InputType.NUMBER_DECIMAL)

      this.SocialSecurityModeToggle()
      if (this.socialSecurityMode === 'rate') {
        this.InputField('社保比例（%）', this.socialSecurityRate, '请输入社保比例', (value: string): void => {
          this.socialSecurityRate = value;
        }, InputType.NUMBER_DECIMAL)
      } else {
        this.InputField('社保固定额（元/月）', this.socialSecurityFixed, '请输入社保固定额', (value: string): void => {
          this.socialSecurityFixed = value;
        }, InputType.NUMBER_DECIMAL)
      }

      this.HousingFundModeToggle()
      if (this.housingFundMode === 'rate') {
        this.InputField('公积金比例（%）', this.housingFundRate, '请输入公积金比例', (value: string): void => {
          this.housingFundRate = value;
        }, InputType.NUMBER_DECIMAL)
      } else {
        this.InputField('公积金固定额（元/月）', this.housingFundFixed, '请输入公积金固定额', (value: string): void => {
          this.housingFundFixed = value;
        }, InputType.NUMBER_DECIMAL)
      }

      Text('专项附加扣除')
        .fontSize(15)
        .fontWeight(FontWeight.Bold)
        .fontColor('#182326')
        .margin({ top: 8, bottom: 10 })
      ForEach(DEDUCTION_ITEMS, (item: DeductionItem) => {
        this.DeductionItemCard(item)
      }, (item: DeductionItem): string => item.key)

      this.TaxResultCard()
      this.TaxMetricList()
      this.MonthlyTaxTable()
    }
    .width('100%')
  }
}
