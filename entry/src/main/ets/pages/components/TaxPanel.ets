import { DeductionItem, HousingRentTier, LaborIncomeMode, TaxDeductionState } from '../../common/Types';
import { DEDUCTION_ITEMS, TAX_MONTHS } from '../../common/Constants';
import { formatMoney, parseNumber } from '../../common/Utils';
import {
  AnnualSettlementResult,
  getAnnualHousingFundDeduction,
  getAnnualLaborTaxFromAmounts,
  getAnnualSocialSecurityDeduction,
  getAnnualSpecialDeduction,
  getAnnualSettlement,
  getMonthlyHousingFund,
  getMonthlyLaborTax,
  getMonthlyNetIncome,
  getMonthlySocialSecurity,
  getMonthlyTax,
  getTaxableIncome,
  getTaxDue
} from '../../common/TaxCalculator';
import { COLOR_PRIMARY, COLOR_PRIMARY_SOFT, COLOR_TEXT_BODY } from '../../common/DesignTokens';

@Component
export struct TaxPanel {
  @Link incomeType: string;
  @Link monthlyIncome: string;
  @Link monthlyLaborIncome: string;
  @Link laborIncomeMode: LaborIncomeMode;
  @Link monthlyLaborAmounts: string[];
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

  private setMonthlyLaborAmount(index: number, value: string): void {
    const next: string[] = this.monthlyLaborAmounts.slice();
    next[index] = value;
    this.monthlyLaborAmounts = next;
  }

  private getMonthlyLaborAmount(month: number): string {
    if (this.laborIncomeMode === 'monthly') {
      return this.monthlyLaborAmounts[month - 1];
    }
    if (this.laborIncomeMode === 'total') {
      return String(parseNumber(this.monthlyLaborIncome) / 12);
    }
    return this.monthlyLaborIncome;
  }

  private getSettlementResult(): AnnualSettlementResult {
    return getAnnualSettlement(this.monthlyIncome, this.monthlyLaborIncome, this.monthlyBasicDeduction,
      this.socialSecurityMode, this.socialSecurityRate, this.socialSecurityFixed,
      this.housingFundMode, this.housingFundRate, this.housingFundFixed, this.deductions,
      this.laborIncomeMode, this.monthlyLaborAmounts);
  }

  private getAnnualLaborTax(): number {
    if (this.laborIncomeMode === 'monthly') {
      return getAnnualLaborTaxFromAmounts(this.monthlyLaborAmounts);
    }
    return getMonthlyLaborTax(
      this.laborIncomeMode === 'total'
        ? String(parseNumber(this.monthlyLaborIncome) / 12)
        : this.monthlyLaborIncome
    ) * 12;
  }

  @Builder
  IncomeTypeToggle() {
    Column() {
      Text('收入类型')
        .fontSize(13)
        .fontWeight(FontWeight.Bold)
        .fontColor(COLOR_TEXT_BODY)
        .margin({ bottom: 7 })
      Row() {
        Button('仅工资')
          .height(38)
          .layoutWeight(1)
          .fontSize(13)
          .fontColor(this.incomeType === 'salary' ? Color.White : COLOR_PRIMARY)
          .backgroundColor(this.incomeType === 'salary' ? COLOR_PRIMARY : COLOR_PRIMARY_SOFT)
          .margin({ right: 4 })
          .onClick((): void => {
            this.incomeType = 'salary';
          })
        Button('仅劳务')
          .height(38)
          .layoutWeight(1)
          .fontSize(13)
          .fontColor(this.incomeType === 'labor' ? Color.White : COLOR_PRIMARY)
          .backgroundColor(this.incomeType === 'labor' ? COLOR_PRIMARY : COLOR_PRIMARY_SOFT)
          .margin({ left: 4, right: 4 })
          .onClick((): void => {
            this.incomeType = 'labor';
          })
        Button('工资+劳务')
          .height(38)
          .layoutWeight(1)
          .fontSize(13)
          .fontColor(this.incomeType === 'both' ? Color.White : COLOR_PRIMARY)
          .backgroundColor(this.incomeType === 'both' ? COLOR_PRIMARY : COLOR_PRIMARY_SOFT)
          .margin({ left: 4 })
          .onClick((): void => {
            this.incomeType = 'both';
          })
      }
      .width('100%')
    }
    .width('100%')
    .margin({ bottom: 12 })
  }

  @Builder
  LaborIncomeModeToggle() {
    Column() {
      Text('劳务报酬计税方式')
        .fontSize(13)
        .fontWeight(FontWeight.Bold)
        .fontColor(COLOR_TEXT_BODY)
        .margin({ bottom: 7 })
      Row() {
        Button('按月固定')
          .height(38)
          .layoutWeight(1)
          .fontSize(13)
          .fontColor(this.laborIncomeMode === 'fixed' ? Color.White : COLOR_PRIMARY)
          .backgroundColor(this.laborIncomeMode === 'fixed' ? COLOR_PRIMARY : COLOR_PRIMARY_SOFT)
          .margin({ right: 4 })
          .onClick((): void => {
            this.laborIncomeMode = 'fixed';
          })
        Button('按月分别')
          .height(38)
          .layoutWeight(1)
          .fontSize(13)
          .fontColor(this.laborIncomeMode === 'monthly' ? Color.White : COLOR_PRIMARY)
          .backgroundColor(this.laborIncomeMode === 'monthly' ? COLOR_PRIMARY : COLOR_PRIMARY_SOFT)
          .margin({ left: 4, right: 4 })
          .onClick((): void => {
            this.laborIncomeMode = 'monthly';
          })
        Button('按总额')
          .height(38)
          .layoutWeight(1)
          .fontSize(13)
          .fontColor(this.laborIncomeMode === 'total' ? Color.White : COLOR_PRIMARY)
          .backgroundColor(this.laborIncomeMode === 'total' ? COLOR_PRIMARY : COLOR_PRIMARY_SOFT)
          .margin({ left: 4 })
          .onClick((): void => {
            this.laborIncomeMode = 'total';
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
    inputType: InputType = InputType.Normal
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
        .fontColor(COLOR_TEXT_BODY)
        .margin({ bottom: 7 })
      Row() {
        Button('按比例')
          .height(38)
          .layoutWeight(1)
          .fontSize(13)
          .fontColor(this.socialSecurityMode === 'rate' ? Color.White : COLOR_PRIMARY)
          .backgroundColor(this.socialSecurityMode === 'rate' ? COLOR_PRIMARY : COLOR_PRIMARY_SOFT)
          .margin({ right: 4 })
          .onClick((): void => {
            this.socialSecurityMode = 'rate';
          })
        Button('固定额度')
          .height(38)
          .layoutWeight(1)
          .fontSize(13)
          .fontColor(this.socialSecurityMode === 'fixed' ? Color.White : COLOR_PRIMARY)
          .backgroundColor(this.socialSecurityMode === 'fixed' ? COLOR_PRIMARY : COLOR_PRIMARY_SOFT)
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
        .fontColor(COLOR_TEXT_BODY)
        .margin({ bottom: 7 })
      Row() {
        Button('按比例')
          .height(38)
          .layoutWeight(1)
          .fontSize(13)
          .fontColor(this.housingFundMode === 'rate' ? Color.White : COLOR_PRIMARY)
          .backgroundColor(this.housingFundMode === 'rate' ? COLOR_PRIMARY : COLOR_PRIMARY_SOFT)
          .margin({ right: 4 })
          .onClick((): void => {
            this.housingFundMode = 'rate';
          })
        Button('固定额度')
          .height(38)
          .layoutWeight(1)
          .fontSize(13)
          .fontColor(this.housingFundMode === 'fixed' ? Color.White : COLOR_PRIMARY)
          .backgroundColor(this.housingFundMode === 'fixed' ? COLOR_PRIMARY : COLOR_PRIMARY_SOFT)
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
  MonthlyLaborInputGrid() {
    Column() {
      Text('各月劳务报酬（元）')
        .fontSize(13)
        .fontWeight(FontWeight.Bold)
        .fontColor(COLOR_TEXT_BODY)
        .margin({ bottom: 7 })
      Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.SpaceBetween }) {
        ForEach(TAX_MONTHS, (month: number) => {
          Column() {
            Text(`${month}月`)
              .fontSize(12)
              .fontColor('#667579')
              .margin({ bottom: 4 })
            TextInput({ text: this.monthlyLaborAmounts[month - 1], placeholder: '元' })
              .height(40)
              .fontSize(14)
              .backgroundColor('#FBFDFD')
              .borderRadius(8)
              .border({ width: 1, color: '#DCE5E4' })
              .padding({ left: 8, right: 8 })
              .type(InputType.NUMBER_DECIMAL)
              .onChange((value: string): void => {
                this.setMonthlyLaborAmount(month - 1, value);
              })
          }
          .width('48%')
          .margin({ bottom: 10 })
        }, (month: number): string => `month_${month}`)
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
          .backgroundColor(this.getDeductionEnabled(item.key) ? COLOR_PRIMARY : '#DCE5E4')
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
    .border({ width: 1, color: this.getDeductionEnabled(item.key) ? COLOR_PRIMARY : '#E4ECEB' })
    .margin({ bottom: 10 })
  }

  @Builder
  LaborTaxCard() {
    Column() {
      Text(this.laborIncomeMode === 'monthly' ? '劳务报酬平均月度预扣税' : '劳务报酬月度预扣税')
        .fontSize(13)
        .fontWeight(FontWeight.Bold)
        .fontColor('rgba(255,255,255,0.72)')
      Text(formatMoney(getMonthlyLaborTax(this.getMonthlyLaborAmount(1))))
        .fontSize(34)
        .fontWeight(FontWeight.Bold)
        .fontColor(Color.White)
        .width('100%')
        .margin({ top: 10, bottom: 8 })
      Text('≤800免税；800~4000按(收入-800)×20%；>4000按收入×80%×税率（20%/30%/40%）')
        .fontSize(13)
        .fontColor('rgba(255,255,255,0.68)')
        .lineHeight(19)
    }
    .width('100%')
    .padding(18)
    .borderRadius(8)
    .backgroundColor('#1A3A3C')
    .margin({ top: 18 })
  }

  @Builder
  SettlementCard() {
    Column() {
      Text('年度汇算清缴')
        .fontSize(13)
        .fontWeight(FontWeight.Bold)
        .fontColor('rgba(255,255,255,0.72)')

      Text(formatMoney(this.getSettlementResult().settlement))
        .fontSize(34)
        .fontWeight(FontWeight.Bold)
        .fontColor(Color.White)
        .width('100%')
        .margin({ top: 10, bottom: 8 })

      Text(this.getSettlementResult().settlement >= 0 ? '需补税' : '可退税')
        .fontSize(13)
        .fontColor('rgba(255,255,255,0.68)')
        .lineHeight(19)
    }
    .width('100%')
    .padding(18)
    .borderRadius(8)
    .backgroundColor('#0D2B2D')
    .margin({ top: 18 })
  }

  @Builder
  TaxResultCard() {
    Column() {
      if (this.incomeType === 'salary') {
        Text('年度工资应纳税额')
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
      } else if (this.incomeType === 'labor') {
        Text('年度劳务应纳税额')
          .fontSize(13)
          .fontWeight(FontWeight.Bold)
          .fontColor('rgba(255,255,255,0.72)')
        Text(formatMoney(this.getAnnualLaborTax()))
          .fontSize(34)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
          .width('100%')
          .margin({ top: 10, bottom: 8 })
      } else {
        Text('年度综合应纳税额')
          .fontSize(13)
          .fontWeight(FontWeight.Bold)
          .fontColor('rgba(255,255,255,0.72)')
        Text(formatMoney(this.getSettlementResult().totalTax))
          .fontSize(34)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
          .width('100%')
          .margin({ top: 10, bottom: 8 })
      }
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
      if (this.incomeType === 'salary' || this.incomeType === 'both') {
        Row() {
          Text('工资应纳税所得额')
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
      }

      if (this.incomeType === 'labor' || this.incomeType === 'both') {
        Row() {
          Text('劳务年度预扣税')
            .fontSize(14)
            .fontColor('#667579')
          Text(formatMoney(this.getAnnualLaborTax()))
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
          .fontColor(COLOR_TEXT_BODY)
        if (this.incomeType === 'salary' || this.incomeType === 'both') {
          Text('工资税')
            .layoutWeight(1)
            .fontSize(13)
            .fontWeight(FontWeight.Bold)
            .fontColor(COLOR_TEXT_BODY)
            .textAlign(TextAlign.End)
        }
        if (this.incomeType === 'labor' || this.incomeType === 'both') {
          Text('劳务税')
            .layoutWeight(1)
            .fontSize(13)
            .fontWeight(FontWeight.Bold)
            .fontColor(COLOR_TEXT_BODY)
            .textAlign(TextAlign.End)
        }
        Text('到手')
          .layoutWeight(1)
          .fontSize(13)
          .fontWeight(FontWeight.Bold)
          .fontColor(COLOR_TEXT_BODY)
          .textAlign(TextAlign.End)
      }
      .width('100%')
      .padding({ left: 12, right: 12, top: 10, bottom: 10 })
      .backgroundColor(COLOR_PRIMARY_SOFT)
      .borderRadius({ topLeft: 8, topRight: 8, bottomLeft: 0, bottomRight: 0 })

      Column() {
        ForEach(TAX_MONTHS, (month: number) => {
          Row() {
            Text(`${month}月`)
              .layoutWeight(1)
              .fontSize(13)
              .fontColor('#667579')
            if (this.incomeType === 'salary' || this.incomeType === 'both') {
              Text(formatMoney(getMonthlyTax(month, this.monthlyIncome, this.monthlyBasicDeduction,
                this.socialSecurityMode, this.socialSecurityRate, this.socialSecurityFixed,
                this.housingFundMode, this.housingFundRate, this.housingFundFixed, this.deductions)))
                .layoutWeight(1)
                .fontSize(13)
                .fontColor('#182326')
                .textAlign(TextAlign.End)
            }
            if (this.incomeType === 'labor' || this.incomeType === 'both') {
              Text(formatMoney(getMonthlyLaborTax(this.getMonthlyLaborAmount(month))))
                .layoutWeight(1)
                .fontSize(13)
                .fontColor('#182326')
                .textAlign(TextAlign.End)
            }
            Text(formatMoney(
              this.incomeType === 'salary' ?
                getMonthlyNetIncome(month, this.monthlyIncome, this.socialSecurityMode, this.socialSecurityRate,
                  this.socialSecurityFixed, this.housingFundMode, this.housingFundRate, this.housingFundFixed,
                  this.monthlyBasicDeduction, this.deductions) :
              this.incomeType === 'labor' ?
                parseNumber(this.getMonthlyLaborAmount(month)) - getMonthlyLaborTax(this.getMonthlyLaborAmount(month)) :
                getMonthlyNetIncome(month, this.monthlyIncome, this.socialSecurityMode, this.socialSecurityRate,
                  this.socialSecurityFixed, this.housingFundMode, this.housingFundRate, this.housingFundFixed,
                  this.monthlyBasicDeduction, this.deductions) - getMonthlyLaborTax(this.getMonthlyLaborAmount(month))))
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
      Text('按中国大陆综合所得年度口径估算，支持工资薪金和劳务报酬，起征点、社保、公积金和专项附加扣除均可调整。')
        .fontSize(14)
        .fontColor('#667579')
        .lineHeight(21)
        .margin({ bottom: 16 })

      this.IncomeTypeToggle()

      if (this.incomeType === 'salary' || this.incomeType === 'both') {
        this.InputField('每月工资（元）', this.monthlyIncome, '请输入月工资', (value: string): void => {
          this.monthlyIncome = value;
        }, InputType.NUMBER_DECIMAL)
      }
      if (this.incomeType === 'labor' || this.incomeType === 'both') {
        this.LaborIncomeModeToggle()

        if (this.laborIncomeMode === 'fixed') {
          this.InputField('每月劳务报酬（元）', this.monthlyLaborIncome, '请输入劳务报酬', (value: string): void => {
            this.monthlyLaborIncome = value;
          }, InputType.NUMBER_DECIMAL)
        } else if (this.laborIncomeMode === 'monthly') {
          this.MonthlyLaborInputGrid()
        } else {
          this.InputField('年度劳务报酬总额（元）', this.monthlyLaborIncome, '请输入年度总额', (value: string): void => {
            this.monthlyLaborIncome = value;
          }, InputType.NUMBER_DECIMAL)
          Text('系统将按总额÷12估算月度预扣税，结果仅供参考。')
            .fontSize(12)
            .fontColor('#667579')
            .margin({ bottom: 12 })
        }
      }
      if (this.incomeType === 'salary' || this.incomeType === 'both') {
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
      }

      if (this.incomeType === 'salary' || this.incomeType === 'both') {
        Text('专项附加扣除')
          .fontSize(15)
          .fontWeight(FontWeight.Bold)
          .fontColor('#182326')
          .margin({ top: 8, bottom: 10 })
        ForEach(DEDUCTION_ITEMS, (item: DeductionItem) => {
          this.DeductionItemCard(item)
        }, (item: DeductionItem): string => item.key)
      }

      this.TaxResultCard()
      if (this.incomeType === 'labor' || this.incomeType === 'both') {
        this.LaborTaxCard()
      }
      if (this.incomeType === 'both') {
        this.SettlementCard()
      }
      this.TaxMetricList()
      this.MonthlyTaxTable()
    }
    .width('100%')
  }
}
