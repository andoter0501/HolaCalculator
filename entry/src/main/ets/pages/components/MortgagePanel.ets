import { CalculatorKey, MortgageLoanType, MortgagePartResult, RepaymentType } from '../../common/Types';
import { formatMoney } from '../../common/Utils';
import {
  calculatePart,
  getActiveMortgageParts,
  getMortgageLastMonthPayment,
  getMortgageMainPayment,
  getMortgageMaxMonths,
  getMortgageTotalInterest,
  getMortgageTotalPayment
} from '../../common/MortgageCalculator';

@Component
export struct MortgagePanel {
  @Link mortgageLoanType: MortgageLoanType;
  @Link commercialLoanAmount: string;
  @Link commercialLoanYears: string;
  @Link commercialAnnualRate: string;
  @Link fundLoanAmount: string;
  @Link fundLoanYears: string;
  @Link fundAnnualRate: string;
  @Link repaymentType: RepaymentType;

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
  LoanTypeToggle() {
    Column() {
      Text('贷款类型')
        .fontSize(13)
        .fontWeight(FontWeight.Bold)
        .fontColor('#415155')
        .margin({ bottom: 7 })
      Row() {
        Button('商业贷款')
          .height(38)
          .layoutWeight(1)
          .margin({ right: 4 })
          .fontSize(13)
          .fontColor(this.mortgageLoanType === 'commercial' ? Color.White : '#147C78')
          .backgroundColor(this.mortgageLoanType === 'commercial' ? '#147C78' : '#DFF2F0')
          .onClick((): void => {
            this.mortgageLoanType = 'commercial';
          })
        Button('公积金贷款')
          .height(38)
          .layoutWeight(1)
          .margin({ left: 4, right: 4 })
          .fontSize(13)
          .fontColor(this.mortgageLoanType === 'fund' ? Color.White : '#147C78')
          .backgroundColor(this.mortgageLoanType === 'fund' ? '#147C78' : '#DFF2F0')
          .onClick((): void => {
            this.mortgageLoanType = 'fund';
          })
        Button('组合贷')
          .height(38)
          .layoutWeight(1)
          .margin({ left: 4 })
          .fontSize(13)
          .fontColor(this.mortgageLoanType === 'mixed' ? Color.White : '#147C78')
          .backgroundColor(this.mortgageLoanType === 'mixed' ? '#147C78' : '#DFF2F0')
          .onClick((): void => {
            this.mortgageLoanType = 'mixed';
          })
      }
      .width('100%')
    }
    .width('100%')
    .margin({ bottom: 12 })
  }

  @Builder
  PartInputCard(title: string, amount: string, years: string, rate: string,
    onAmountChange: (value: string) => void, onYearsChange: (value: string) => void, onRateChange: (value: string) => void) {
    Column() {
      Text(title)
        .fontSize(15)
        .fontWeight(FontWeight.Bold)
        .fontColor('#182326')
        .margin({ bottom: 10 })
      this.InputField('贷款金额（万元）', amount, '请输入贷款金额', onAmountChange, InputType.NUMBER_DECIMAL)
      this.InputField('贷款年限（年）', years, '请输入贷款年限', onYearsChange, InputType.Number)
      this.InputField('年利率（%）', rate, '请输入年利率', onRateChange, InputType.NUMBER_DECIMAL)
    }
    .width('100%')
    .padding({ left: 12, right: 12, top: 12, bottom: 2 })
    .borderRadius(8)
    .backgroundColor('#F8FAFA')
    .margin({ bottom: 12 })
  }

  @Builder
  ResultCard() {
    Column() {
      Text(this.repaymentType === 'interest' ? '预计月供' : '首月月供')
        .fontSize(13)
        .fontWeight(FontWeight.Bold)
        .fontColor('rgba(255,255,255,0.72)')
      Text(formatMoney(this.getMainPayment()))
        .fontSize(34)
        .fontWeight(FontWeight.Bold)
        .fontColor(Color.White)
        .width('100%')
        .margin({ top: 10, bottom: 8 })
      Text(this.repaymentType === 'interest' ? '组合贷按两笔贷款分别计算后汇总。' : `末月月供约 ${formatMoney(this.getLastMonthPayment())}`)
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
  MetricList() {
    Column() {
      Row() {
        Text(this.repaymentType === 'interest' ? '总利息' : '末月月供')
          .fontSize(14)
          .fontColor('#667579')
        Text(this.repaymentType === 'interest' ? formatMoney(this.getTotalInterest()) : formatMoney(this.getLastMonthPayment()))
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
        Text(this.repaymentType === 'interest' ? '总还款' : '总利息')
          .fontSize(14)
          .fontColor('#667579')
        Text(this.repaymentType === 'interest' ? formatMoney(this.getTotalPayment()) : formatMoney(this.getTotalInterest()))
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
        Text(this.repaymentType === 'interest' ? '还款期数（最长）' : '总还款')
          .fontSize(14)
          .fontColor('#667579')
        Text(this.repaymentType === 'interest' ? `${this.getMaxMonths()} 期` : formatMoney(this.getTotalPayment()))
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
  PartSummary(title: string, part: MortgagePartResult) {
    if (part.principal > 0) {
      Column() {
        Text(title)
          .fontSize(14)
          .fontWeight(FontWeight.Bold)
          .fontColor('#182326')
          .margin({ bottom: 8 })
        Row() {
          Text(this.repaymentType === 'interest' ? '月供' : '首月/末月')
            .fontSize(13)
            .fontColor('#667579')
          Text(this.repaymentType === 'interest' ?
            formatMoney(part.monthlyPayment) :
            `${formatMoney(part.firstMonthPayment)} / ${formatMoney(part.lastMonthPayment)}`)
            .fontSize(13)
            .fontWeight(FontWeight.Bold)
            .fontColor('#182326')
            .textAlign(TextAlign.End)
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .width('100%')
        .padding({ top: 8, bottom: 8 })
        Row() {
          Text('总利息')
            .fontSize(13)
            .fontColor('#667579')
          Text(formatMoney(part.totalInterest))
            .fontSize(13)
            .fontWeight(FontWeight.Bold)
            .fontColor('#182326')
            .textAlign(TextAlign.End)
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .width('100%')
      }
      .width('100%')
      .padding({ left: 12, right: 12, top: 10, bottom: 10 })
      .borderRadius(8)
      .backgroundColor('#F8FAFA')
      .margin({ bottom: 10 })
    }
  }

  private getActiveParts(): MortgagePartResult[] {
    return getActiveMortgageParts(this.mortgageLoanType,
      this.commercialLoanAmount, this.commercialLoanYears, this.commercialAnnualRate,
      this.fundLoanAmount, this.fundLoanYears, this.fundAnnualRate, this.repaymentType);
  }

  private getMainPayment(): number {
    return getMortgageMainPayment(this.getActiveParts(), this.repaymentType);
  }

  private getLastMonthPayment(): number {
    return getMortgageLastMonthPayment(this.getActiveParts());
  }

  private getTotalPayment(): number {
    return getMortgageTotalPayment(this.getActiveParts());
  }

  private getTotalInterest(): number {
    return getMortgageTotalInterest(this.getActiveParts());
  }

  private getMaxMonths(): number {
    return getMortgageMaxMonths(this.getActiveParts());
  }

  build() {
    Column() {
      Text('房贷计算')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .fontColor('#182326')
        .margin({ bottom: 12 })
      Text('支持商业贷款、公积金贷款和组合贷，支持等额本息与等额本金，组合贷可分别设置两部分年限与利率。')
        .fontSize(14)
        .fontColor('#667579')
        .lineHeight(21)
        .margin({ bottom: 16 })
      this.LoanTypeToggle()

      if (this.mortgageLoanType === 'commercial') {
        this.PartInputCard('商业贷款', this.commercialLoanAmount, this.commercialLoanYears, this.commercialAnnualRate,
          (value: string): void => { this.commercialLoanAmount = value; },
          (value: string): void => { this.commercialLoanYears = value; },
          (value: string): void => { this.commercialAnnualRate = value; })
      } else if (this.mortgageLoanType === 'fund') {
        this.PartInputCard('公积金贷款', this.fundLoanAmount, this.fundLoanYears, this.fundAnnualRate,
          (value: string): void => { this.fundLoanAmount = value; },
          (value: string): void => { this.fundLoanYears = value; },
          (value: string): void => { this.fundAnnualRate = value; })
      } else {
        this.PartInputCard('商业贷款', this.commercialLoanAmount, this.commercialLoanYears, this.commercialAnnualRate,
          (value: string): void => { this.commercialLoanAmount = value; },
          (value: string): void => { this.commercialLoanYears = value; },
          (value: string): void => { this.commercialAnnualRate = value; })
        this.PartInputCard('公积金贷款', this.fundLoanAmount, this.fundLoanYears, this.fundAnnualRate,
          (value: string): void => { this.fundLoanAmount = value; },
          (value: string): void => { this.fundLoanYears = value; },
          (value: string): void => { this.fundAnnualRate = value; })
      }

      Row() {
        Button('等额本息')
          .height(38)
          .layoutWeight(1)
          .margin({ right: 4 })
          .fontColor(this.repaymentType === 'interest' ? Color.White : '#147C78')
          .backgroundColor(this.repaymentType === 'interest' ? '#147C78' : '#DFF2F0')
          .onClick((): void => {
            this.repaymentType = 'interest';
          })
        Button('等额本金')
          .height(38)
          .layoutWeight(1)
          .margin({ left: 4 })
          .fontColor(this.repaymentType === 'principal' ? Color.White : '#147C78')
          .backgroundColor(this.repaymentType === 'principal' ? '#147C78' : '#DFF2F0')
          .onClick((): void => {
            this.repaymentType = 'principal';
          })
      }
      .width('100%')
      .margin({ top: 2 })
      this.ResultCard()
      this.MetricList()
      if (this.mortgageLoanType === 'mixed') {
        this.PartSummary('商业贷款明细', calculatePart(this.commercialLoanAmount, this.commercialLoanYears, this.commercialAnnualRate, this.repaymentType))
        this.PartSummary('公积金贷款明细', calculatePart(this.fundLoanAmount, this.fundLoanYears, this.fundAnnualRate, this.repaymentType))
      }
    }
    .width('100%')
  }
}
