import {
  CalculatorCategory,
  CalculatorKey,
  ConverterConfig,
  HousingRentTier,
  LaborIncomeMode,
  MortgageLoanType,
  RepaymentType,
  TaxDeductionState,
  UnitDefinition
} from '../common/Types';
import { CATEGORIES, CONVERTER_CONFIGS, DEFAULT_UNIT_INDEXES } from '../common/Constants';
import { clampUnitIndex, findUnitIndexByName } from '../common/Utils';
import {
  COLOR_PRIMARY,
  COLOR_PRIMARY_SOFT,
  COLOR_PRIMARY_PALE,
  COLOR_TEXT_PRIMARY,
  COLOR_TEXT_MUTED,
  COLOR_TEXT_BODY,
  COLOR_TEXT_PLACEHOLDER,
  COLOR_SURFACE_2,
  COLOR_SURFACE_3,
  COLOR_BG,
  COLOR_LINE,
  COLOR_LINE_LIGHT
} from '../common/DesignTokens';
import { CategoryTabs } from './components/CategoryTabs';
import { NormalCalculator } from './components/NormalCalculator';
import { ConverterPanel } from './components/ConverterPanel';
import { StopwatchPanel } from './components/StopwatchPanel';
import { TaxPanel } from './components/TaxPanel';
import { MortgagePanel } from './components/MortgagePanel';

@Entry
@Component
struct Index {
  @State activeKey: CalculatorKey = 'normal';
  @State categoryItems: CalculatorCategory[] = CATEGORIES.slice();
  @State showCategoryEditor: boolean = false;

  @State converterKey: CalculatorKey = 'length';
  @State converterValues: Map<string, string> = new Map<string, string>([
    ['length', ''], ['volume', ''], ['time', ''], ['weight', ''], ['area', '']
  ]);
  @State fromIndex: number = 2;
  @State toIndex: number = 1;
  @State fromUnitName: string = '米';
  @State toUnitName: string = '厘米';
  @State showFromUnitPicker: boolean = false;
  @State showToUnitPicker: boolean = false;

  @State normalExpression: string = '';
  @State normalDisplay: string = '0';
  @State normalJustEvaluated: boolean = false;

  @State stopwatchMs: number = 0;
  @State stopwatchRunning: boolean = false;
  @State lapItems: string[] = [];

  @State incomeType: string = 'salary';
  @State monthlyIncome: string = '';
  @State monthlyLaborIncome: string = '';
  @State laborIncomeMode: LaborIncomeMode = 'fixed';
  @State monthlyLaborAmounts: string[] = ['', '', '', '', '', '', '', '', '', '', '', ''];
  @State monthlyBasicDeduction: string = '5000';
  @State socialSecurityMode: string = 'rate';
  @State housingFundMode: string = 'rate';
  @State socialSecurityRate: string = '';
  @State socialSecurityFixed: string = '';
  @State housingFundRate: string = '';
  @State housingFundFixed: string = '';
  @State deductions: Map<string, TaxDeductionState> = new Map<string, TaxDeductionState>([
    ['childrenEducation', { enabled: false, amount: '2000' }],
    ['continuingEducation', { enabled: false, amount: '400' }],
    ['seriousIllness', { enabled: false, amount: '0' }],
    ['mortgageInterest', { enabled: false, amount: '1000' }],
    ['housingRent', { enabled: false, amount: '1500' }],
    ['elderSupport', { enabled: false, amount: '3000' }],
    ['childCare', { enabled: false, amount: '2000' }]
  ]);
  @State housingRentTier: HousingRentTier = 'large';

  @State mortgageLoanType: MortgageLoanType = 'commercial';
  @State commercialLoanAmount: string = '';
  @State commercialLoanYears: string = '';
  @State commercialAnnualRate: string = '';
  @State fundLoanAmount: string = '';
  @State fundLoanYears: string = '';
  @State fundAnnualRate: string = '';
  @State repaymentType: RepaymentType = 'interest';

  private isConverterCategory(key: CalculatorKey): boolean {
    return key === 'length' || key === 'volume' || key === 'time' || key === 'weight' || key === 'area';
  }

  private getConverterConfig(): ConverterConfig {
    return CONVERTER_CONFIGS.get(this.converterKey) as ConverterConfig;
  }

  private resetConverterIndexes(key: CalculatorKey): void {
    const indexes: number[] | undefined = DEFAULT_UNIT_INDEXES.get(key);
    const nextFromIndex: number = indexes !== undefined ? indexes[0] : 0;
    const nextToIndex: number = indexes !== undefined ? indexes[1] : 1;
    this.fromIndex = nextFromIndex;
    this.toIndex = nextToIndex;
    const config = CONVERTER_CONFIGS.get(key);
    if (config !== undefined) {
      this.fromUnitName = config.units[clampUnitIndex(nextFromIndex, config.units)].name;
      this.toUnitName = config.units[clampUnitIndex(nextToIndex, config.units)].name;
    }
  }

  private clearAllConverterValues(): void {
    this.converterValues = new Map<string, string>([
      ['length', ''], ['volume', ''], ['time', ''], ['weight', ''], ['area', '']
    ]);
  }

  private selectCategory(key: CalculatorKey): void {
    if (this.activeKey === key) {
      return;
    }
    if (this.isConverterCategory(key)) {
      this.converterKey = key;
    }
    this.clearAllConverterValues();
    this.activeKey = key;
    if (this.isConverterCategory(key)) {
      this.resetConverterIndexes(key);
    }
  }

  private selectFromUnitName(unitName: string): void {
    const config: ConverterConfig = this.getConverterConfig();
    const nextIndex: number = findUnitIndexByName(config.units, unitName);
    this.fromUnitName = config.units[nextIndex].name;
    this.fromIndex = nextIndex;
    this.showFromUnitPicker = false;
  }

  private selectToUnitName(unitName: string): void {
    const config: ConverterConfig = this.getConverterConfig();
    const nextIndex: number = findUnitIndexByName(config.units, unitName);
    this.toUnitName = config.units[nextIndex].name;
    this.toIndex = nextIndex;
    this.showToUnitPicker = false;
  }

  @Builder
  CategoryEditorDialog() {
    Column() {
      Blank()
      Column() {
        Row() {
          Column() {
            Text('编辑分类顺序')
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .fontColor(COLOR_TEXT_PRIMARY)
            Text('使用上移、下移调整顶部标签顺序。')
              .fontSize(13)
              .fontColor(COLOR_TEXT_MUTED)
              .margin({ top: 6 })
          }
          .alignItems(HorizontalAlign.Start)
          .layoutWeight(1)
          Button('重置')
            .height(34)
            .width(62)
            .fontSize(13)
            .fontColor(COLOR_PRIMARY)
            .backgroundColor(COLOR_PRIMARY_SOFT)
            .borderRadius(RADIUS_SM)
            .onClick((): void => {
              this.categoryItems = CATEGORIES.slice();
            })
        }
        .width('100%')
        .margin({ bottom: 14 })

        Scroll() {
          Column() {
            ForEach(this.categoryItems, (item: CalculatorCategory, index: number) => {
              Row() {
                Text(item.icon)
                  .fontSize(14)
                  .fontWeight(FontWeight.Bold)
                  .fontColor(Color.White)
                  .width(28)
                  .height(28)
                  .textAlign(TextAlign.Center)
                  .borderRadius(RADIUS_SM)
                  .backgroundColor(COLOR_PRIMARY)
                Text(item.title)
                  .fontSize(14)
                  .fontWeight(FontWeight.Bold)
                  .fontColor(COLOR_TEXT_PRIMARY)
                  .margin({ left: 10 })
                  .layoutWeight(1)
                Button('上移')
                  .height(30)
                  .width(60)
                  .fontSize(11)
                  .fontColor(index === 0 || item.key === 'editor' ? COLOR_TEXT_PLACEHOLDER : COLOR_PRIMARY)
                  .backgroundColor(index === 0 || item.key === 'editor' ? COLOR_SURFACE_2 : COLOR_PRIMARY_SOFT)
                  .borderRadius(RADIUS_SM)
                  .enabled(index > 0 && item.key !== 'editor')
                  .onClick((): void => {
                    if (item.key === 'editor') return;
                    const nextItems: CalculatorCategory[] = this.categoryItems.slice();
                    const moving = nextItems.splice(index, 1);
                    if (moving.length > 0) {
                      nextItems.splice(index - 1, 0, moving[0]);
                      this.categoryItems = nextItems;
                    }
                  })
                Button('下移')
                  .height(30)
                  .width(60)
                  .fontSize(11)
                  .fontColor(index === this.categoryItems.length - 1 || item.key === 'editor' ? COLOR_TEXT_PLACEHOLDER : COLOR_PRIMARY)
                  .backgroundColor(index === this.categoryItems.length - 1 || item.key === 'editor' ? COLOR_SURFACE_2 : COLOR_PRIMARY_SOFT)
                  .borderRadius(RADIUS_SM)
                  .margin({ left: 6 })
                  .enabled(index < this.categoryItems.length - 1 && item.key !== 'editor')
                  .onClick((): void => {
                    if (item.key === 'editor') return;
                    const nextItems: CalculatorCategory[] = this.categoryItems.slice();
                    const moving = nextItems.splice(index, 1);
                    if (moving.length > 0) {
                      nextItems.splice(index + 1, 0, moving[0]);
                      this.categoryItems = nextItems;
                    }
                  })
              }
              .width('100%')
              .height(44)
              .padding({ left: 10, right: 10 })
              .borderRadius(RADIUS_SM)
              .backgroundColor(item.key === this.activeKey ? COLOR_PRIMARY_PALE : COLOR_SURFACE_3)
              .border({ width: 1, color: item.key === this.activeKey ? COLOR_PRIMARY : COLOR_LINE_LIGHT })
              .margin({ bottom: 6 })
            }, (item: CalculatorCategory): string => item.key)
          }
          .width('100%')
        }
        .layoutWeight(1)
        .width('100%')
        .scrollBar(BarState.Auto)

        Row() {
          Button('完成')
            .height(44)
            .layoutWeight(1)
            .fontSize(16)
            .fontColor(Color.White)
            .backgroundColor(COLOR_PRIMARY)
            .borderRadius(RADIUS_SM)
            .onClick((): void => {
              this.showCategoryEditor = false;
            })
        }
        .width('100%')
        .margin({ top: 4 })
      }
      .width('82%')
      .height('62%')
      .padding({ left: 16, right: 16, top: 18, bottom: 16 })
      .borderRadius(14)
      .backgroundColor(COLOR_SURFACE_3)
      .border({ width: 1, color: COLOR_LINE })
      Blank()
    }
    .width('100%')
    .height('100%')
    .padding({ left: 16, right: 16 })
    .backgroundColor('rgba(16,39,41,0.38)')
  }

  @Builder
  UnitPickerDialog(target: string) {
    Column() {
      Blank()
      Column() {
        Row()
          .width(38)
          .height(4)
          .borderRadius(2)
          .backgroundColor(COLOR_LINE)
          .margin({ bottom: 14 })

        Row() {
          Column() {
            Text(target === 'from' ? '选择原单位' : '选择目标单位')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor(COLOR_TEXT_PRIMARY)
            Text(this.getConverterConfig().title)
              .fontSize(13)
              .fontColor(COLOR_TEXT_MUTED)
              .margin({ top: 6 })
          }
          .alignItems(HorizontalAlign.Start)
          .layoutWeight(1)
          Text('关闭')
            .height(32)
            .fontSize(14)
            .fontColor(COLOR_PRIMARY)
            .textAlign(TextAlign.Center)
            .padding({ left: 12, right: 12 })
            .borderRadius(RADIUS_SM)
            .backgroundColor(COLOR_PRIMARY_SOFT)
            .onClick((): void => {
              if (target === 'from') {
                this.showFromUnitPicker = false;
              } else {
                this.showToUnitPicker = false;
              }
            })
        }
        .width('100%')
        .margin({ bottom: 14 })

        Column() {
          ForEach(this.getConverterConfig().units, (unit: UnitDefinition) => {
            Row() {
              Text(unit.name)
                .fontSize(15)
                .fontWeight(FontWeight.Bold)
                .fontColor(COLOR_TEXT_PRIMARY)
                .layoutWeight(1)
              Text(unit.symbol)
                .fontSize(13)
                .fontColor(COLOR_TEXT_MUTED)
              if (unit.name === (target === 'from' ? this.fromUnitName : this.toUnitName)) {
                Text('✓')
                  .fontSize(16)
                  .fontWeight(FontWeight.Bold)
                  .fontColor(COLOR_PRIMARY)
                  .width(24)
                  .textAlign(TextAlign.End)
              }
            }
            .width('100%')
            .height(42)
            .padding({ left: 12, right: 10 })
            .borderRadius(RADIUS_SM)
            .backgroundColor(unit.name === (target === 'from' ? this.fromUnitName : this.toUnitName) ? COLOR_PRIMARY_SOFT : COLOR_SURFACE_3)
            .border({ width: 1, color: unit.name === (target === 'from' ? this.fromUnitName : this.toUnitName) ? COLOR_PRIMARY : COLOR_LINE_LIGHT })
            .margin({ bottom: 6 })
            .onClick((): void => {
              if (target === 'from') {
                this.selectFromUnitName(unit.name);
              } else {
                this.selectToUnitName(unit.name);
              }
            })
          }, (unit: UnitDefinition): string => unit.name)
        }
        .width('100%')
      }
      .width('100%')
      .padding({ left: 18, right: 18, top: 14, bottom: 10 })
      .borderRadius({ topLeft: 20, topRight: 20, bottomLeft: 0, bottomRight: 0 })
      .backgroundColor(Color.White)
      .shadow({
        radius: 24,
        color: 'rgba(0,0,0,0.22)',
        offsetX: 0,
        offsetY: -8
      })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#00000099')
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      Column() {
        Column() {
          Text('Hola 计算器')
            .fontSize(28)
            .fontWeight(FontWeight.Bold)
            .fontColor(COLOR_TEXT_PRIMARY)
        }
        .alignItems(HorizontalAlign.Start)
        .width('100%')
        .padding({ left: 34, right: 34, top: 24, bottom: 10 })

        CategoryTabs({
          activeKey: this.activeKey,
          categoryItems: this.categoryItems,
          showCategoryEditor: this.showCategoryEditor,
          onCategorySelect: (key: CalculatorKey): void => {
            this.selectCategory(key);
          }
        })

        if (this.activeKey === 'normal') {
          Column() {
            Column() {
              NormalCalculator({
                normalExpression: this.normalExpression,
                normalDisplay: this.normalDisplay,
                normalJustEvaluated: this.normalJustEvaluated
              })
            }
            .width('100%')
            .height('100%')
            .padding(10)
            .borderRadius(RADIUS_SM)
            .backgroundColor(COLOR_BG)
            .align(Alignment.TopStart)
            .alignSelf(ItemAlign.Start)
          }
          .width('100%')
          .layoutWeight(1)
          .alignItems(HorizontalAlign.Start)
          .justifyContent(FlexAlign.Start)
          .padding({ left: 16, right: 16, top: 4, bottom: 10 })
          .align(Alignment.TopStart)
          .alignSelf(ItemAlign.Start)
        } else {
          Scroll() {
            Column() {
              Column() {
                if (this.isConverterCategory(this.activeKey)) {
                  ConverterPanel({
                    converterKey: this.converterKey,
                    fromUnitName: this.fromUnitName,
                    toUnitName: this.toUnitName,
                    fromIndex: this.fromIndex,
                    toIndex: this.toIndex,
                    converterValues: this.converterValues,
                    onOpenFromPicker: (): void => { this.showFromUnitPicker = true; },
                    onOpenToPicker: (): void => { this.showToUnitPicker = true; }
                  })
                } else if (this.activeKey === 'stopwatch') {
                  StopwatchPanel({
                    stopwatchMs: this.stopwatchMs,
                    stopwatchRunning: this.stopwatchRunning,
                    lapItems: this.lapItems
                  })
                } else if (this.activeKey === 'tax') {
                  TaxPanel({
                    incomeType: this.incomeType,
                    monthlyIncome: this.monthlyIncome,
                    monthlyLaborIncome: this.monthlyLaborIncome,
                    laborIncomeMode: this.laborIncomeMode,
                    monthlyLaborAmounts: this.monthlyLaborAmounts,
                    monthlyBasicDeduction: this.monthlyBasicDeduction,
                    socialSecurityMode: this.socialSecurityMode,
                    housingFundMode: this.housingFundMode,
                    socialSecurityRate: this.socialSecurityRate,
                    socialSecurityFixed: this.socialSecurityFixed,
                    housingFundRate: this.housingFundRate,
                    housingFundFixed: this.housingFundFixed,
                    deductions: this.deductions,
                    housingRentTier: this.housingRentTier
                  })
                } else if (this.activeKey === 'mortgage') {
                  MortgagePanel({
                    mortgageLoanType: this.mortgageLoanType,
                    commercialLoanAmount: this.commercialLoanAmount,
                    commercialLoanYears: this.commercialLoanYears,
                    commercialAnnualRate: this.commercialAnnualRate,
                    fundLoanAmount: this.fundLoanAmount,
                    fundLoanYears: this.fundLoanYears,
                    fundAnnualRate: this.fundAnnualRate,
                    repaymentType: this.repaymentType
                  })
                }
              }
              .width('100%')
              .padding(18)
              .borderRadius(16)
              .backgroundColor(Color.White)
              .border({ width: 1, color: COLOR_LINE_LIGHT })
              .align(Alignment.TopStart)
              .alignSelf(ItemAlign.Start)
            }
            .width('100%')
            .alignItems(HorizontalAlign.Start)
            .justifyContent(FlexAlign.Start)
            .padding({ left: 16, right: 16, top: 10, bottom: 28 })
            .align(Alignment.TopStart)
            .alignSelf(ItemAlign.Start)
          }
          .width('100%')
          .layoutWeight(1)
          .scrollBar(BarState.Off)
          .align(Alignment.TopStart)
          .alignSelf(ItemAlign.Start)
        }
      }
      .width('100%')
      .height('100%')
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.Start)
      .backgroundColor(COLOR_BG)

      if (this.showCategoryEditor) {
        this.CategoryEditorDialog()
      }
      if (this.showFromUnitPicker) {
        this.UnitPickerDialog('from')
      }
      if (this.showToUnitPicker) {
        this.UnitPickerDialog('to')
      }
    }
    .width('100%')
    .height('100%')
  }
}
