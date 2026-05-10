type CalculatorKey = 'length' | 'volume' | 'time' | 'stopwatch' | 'weight' | 'area' | 'tax' | 'mortgage';
type RepaymentType = 'interest' | 'principal';

interface CalculatorCategory {
  key: CalculatorKey;
  title: string;
  icon: string;
  desc: string;
}

interface UnitDefinition {
  name: string;
  symbol: string;
  factor: number;
}

interface ConverterConfig {
  title: string;
  desc: string;
  valuePlaceholder: string;
  units: UnitDefinition[];
  precision: number;
  estimateNote: string;
}

interface MetricItem {
  label: string;
  value: string;
}

interface TaxBracket {
  threshold: number;
  rate: number;
  deduction: number;
}

interface DeductionItem {
  key: string;
  title: string;
  standard: string;
  note: string;
}

const CATEGORIES: CalculatorCategory[] = [
  { key: 'length', title: '长度', icon: 'm', desc: '米、厘米、英尺、英里' },
  { key: 'volume', title: '体积', icon: 'L', desc: '升、毫升、立方米' },
  { key: 'time', title: '时间', icon: 'h', desc: '秒、分钟、小时、天' },
  { key: 'stopwatch', title: '秒表', icon: '⏱', desc: '计时、暂停、计次' },
  { key: 'weight', title: '重量', icon: 'kg', desc: '克、千克、磅、吨' },
  { key: 'area', title: '面积', icon: '㎡', desc: '平方米、公顷、亩' },
  { key: 'tax', title: '个税', icon: '¥', desc: '综合所得估算' },
  { key: 'mortgage', title: '房贷', icon: '%', desc: '等额本息、等额本金' }
];

const LENGTH_UNITS: UnitDefinition[] = [
  { name: '毫米', symbol: 'mm', factor: 0.001 },
  { name: '厘米', symbol: 'cm', factor: 0.01 },
  { name: '米', symbol: 'm', factor: 1 },
  { name: '千米', symbol: 'km', factor: 1000 },
  { name: '英寸', symbol: 'in', factor: 0.0254 },
  { name: '英尺', symbol: 'ft', factor: 0.3048 },
  { name: '码', symbol: 'yd', factor: 0.9144 },
  { name: '英里', symbol: 'mi', factor: 1609.344 }
];

const VOLUME_UNITS: UnitDefinition[] = [
  { name: '毫升', symbol: 'ml', factor: 0.001 },
  { name: '升', symbol: 'L', factor: 1 },
  { name: '立方厘米', symbol: 'cm³', factor: 0.001 },
  { name: '立方米', symbol: 'm³', factor: 1000 },
  { name: '加仑', symbol: 'gal', factor: 3.785411784 }
];

const TIME_UNITS: UnitDefinition[] = [
  { name: '秒', symbol: 's', factor: 1 },
  { name: '分钟', symbol: 'min', factor: 60 },
  { name: '小时', symbol: 'h', factor: 3600 },
  { name: '天', symbol: 'd', factor: 86400 },
  { name: '周', symbol: 'w', factor: 604800 },
  { name: '月', symbol: 'mo', factor: 2629800 },
  { name: '年', symbol: 'y', factor: 31557600 }
];

const WEIGHT_UNITS: UnitDefinition[] = [
  { name: '毫克', symbol: 'mg', factor: 0.000001 },
  { name: '克', symbol: 'g', factor: 0.001 },
  { name: '千克', symbol: 'kg', factor: 1 },
  { name: '吨', symbol: 't', factor: 1000 },
  { name: '盎司', symbol: 'oz', factor: 0.028349523125 },
  { name: '磅', symbol: 'lb', factor: 0.45359237 }
];

const AREA_UNITS: UnitDefinition[] = [
  { name: '平方毫米', symbol: 'mm²', factor: 0.000001 },
  { name: '平方厘米', symbol: 'cm²', factor: 0.0001 },
  { name: '平方米', symbol: 'm²', factor: 1 },
  { name: '亩', symbol: '亩', factor: 666.6666667 },
  { name: '公顷', symbol: 'ha', factor: 10000 },
  { name: '平方千米', symbol: 'km²', factor: 1000000 },
  { name: '平方英尺', symbol: 'ft²', factor: 0.09290304 }
];

const TAX_BRACKETS: TaxBracket[] = [
  { threshold: 960000, rate: 0.45, deduction: 181920 },
  { threshold: 660000, rate: 0.35, deduction: 85920 },
  { threshold: 420000, rate: 0.30, deduction: 52920 },
  { threshold: 300000, rate: 0.25, deduction: 31920 },
  { threshold: 144000, rate: 0.20, deduction: 16920 },
  { threshold: 36000, rate: 0.10, deduction: 2520 },
  { threshold: 0, rate: 0.03, deduction: 0 }
];

const TAX_MONTHS: number[] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];

const DEDUCTION_ITEMS: DeductionItem[] = [
  {
    key: 'childrenEducation',
    title: '1 子女教育',
    standard: '2000元/孩子/月',
    note: '3岁至博士后；父母各扣50%或一方扣100%。'
  },
  {
    key: 'continuingEducation',
    title: '2 继续教育',
    standard: '400元/月或3600元/年',
    note: '学历教育每月400元最长48个月；职业资格证书当年扣3600。'
  },
  {
    key: 'seriousIllness',
    title: '3 大病医疗',
    standard: '最高80000元/年',
    note: '医保报销后自负金额累计超15000元部分。'
  },
  {
    key: 'mortgageInterest',
    title: '4 住房贷款利息',
    standard: '1000元/户/月',
    note: '首套房贷利息年度内，最长240个月。'
  },
  {
    key: 'housingRent',
    title: '5 住房租金',
    standard: '800/1100/1500元/月',
    note: '主要工作城市无自有住房。'
  },
  {
    key: 'elderSupport',
    title: '6 赡养老人',
    standard: '3000元/户/月',
    note: '独生子女3000；非独生分摊1500-3000。'
  },
  {
    key: 'childCare',
    title: '7 3岁以下婴幼儿照护',
    standard: '2000元/婴幼儿/月',
    note: '出生当月至满3周岁。'
  }
];

@Entry
@Component
struct Index {
  @State activeKey: CalculatorKey = 'length';
  @State categoryItems: CalculatorCategory[] = CATEGORIES.slice();
  @State showCategoryEditor: boolean = false;
  @State showFromUnitPicker: boolean = false;
  @State showToUnitPicker: boolean = false;
  @State converterValue: string = '128';
  @State fromIndex: number = 2;
  @State toIndex: number = 1;
  @State fromUnitName: string = '米';
  @State toUnitName: string = '厘米';
  @State stopwatchMs: number = 0;
  @State stopwatchRunning: boolean = false;
  @State lapItems: string[] = [];
  @State monthlyIncome: string = '20000';
  @State monthlyBasicDeduction: string = '5000';
  @State socialSecurityMode: 'rate' | 'fixed' = 'rate';
  @State housingFundMode: 'rate' | 'fixed' = 'rate';
  @State socialSecurityRate: string = '10.5';
  @State housingFundRate: string = '7';
  @State socialSecurityFixed: string = '2100';
  @State housingFundFixed: string = '1400';
  @State childEducationEnabled: boolean = false;
  @State childEducationAmount: string = '2000';
  @State continuingEducationEnabled: boolean = false;
  @State continuingEducationAmount: string = '400';
  @State seriousIllnessEnabled: boolean = false;
  @State seriousIllnessAmount: string = '0';
  @State mortgageInterestEnabled: boolean = false;
  @State mortgageInterestAmount: string = '1000';
  @State housingRentEnabled: boolean = false;
  @State housingRentAmount: string = '1500';
  @State elderSupportEnabled: boolean = false;
  @State elderSupportAmount: string = '3000';
  @State childCareEnabled: boolean = false;
  @State childCareAmount: string = '2000';
  @State loanAmount: string = '100';
  @State loanYears: string = '30';
  @State annualRate: string = '4.2';
  @State repaymentType: RepaymentType = 'interest';
  private timerId: number = -1;

  aboutToDisappear(): void {
    this.stopTimer();
  }

  private getConverterConfig(): ConverterConfig {
    if (this.activeKey === 'volume') {
      return {
        title: '体积换算',
        desc: '升、毫升、立方厘米、立方米和加仑快速换算。',
        valuePlaceholder: '输入体积',
        units: VOLUME_UNITS,
        precision: 4,
        estimateNote: ''
      };
    }
    if (this.activeKey === 'time') {
      return {
        title: '时间换算',
        desc: '秒、分钟、小时、天、周、月、年之间换算。',
        valuePlaceholder: '输入时间',
        units: TIME_UNITS,
        precision: 4,
        estimateNote: '月和年按固定平均值估算。'
      };
    }
    if (this.activeKey === 'weight') {
      return {
        title: '重量换算',
        desc: '毫克、克、千克、吨、盎司和磅之间换算。',
        valuePlaceholder: '输入重量',
        units: WEIGHT_UNITS,
        precision: 4,
        estimateNote: ''
      };
    }
    if (this.activeKey === 'area') {
      return {
        title: '面积换算',
        desc: '平方米、亩、公顷、平方千米等面积单位换算。',
        valuePlaceholder: '输入面积',
        units: AREA_UNITS,
        precision: 4,
        estimateNote: ''
      };
    }
    return {
      title: '长度换算',
      desc: '毫米、厘米、米、千米和英制长度单位快速换算。',
      valuePlaceholder: '输入长度',
      units: LENGTH_UNITS,
      precision: 4,
      estimateNote: ''
    };
  }

  private getConverterConfigByKey(key: CalculatorKey): ConverterConfig {
    if (key === 'volume') {
      return {
        title: '体积换算',
        desc: '升、毫升、立方厘米、立方米和加仑快速换算。',
        valuePlaceholder: '输入体积',
        units: VOLUME_UNITS,
        precision: 4,
        estimateNote: ''
      };
    }
    if (key === 'time') {
      return {
        title: '时间换算',
        desc: '秒、分钟、小时、天、周、月、年之间换算。',
        valuePlaceholder: '输入时间',
        units: TIME_UNITS,
        precision: 4,
        estimateNote: '月和年按固定平均值估算。'
      };
    }
    if (key === 'weight') {
      return {
        title: '重量换算',
        desc: '毫克、克、千克、吨、盎司和磅之间换算。',
        valuePlaceholder: '输入重量',
        units: WEIGHT_UNITS,
        precision: 4,
        estimateNote: ''
      };
    }
    if (key === 'area') {
      return {
        title: '面积换算',
        desc: '平方米、亩、公顷、平方千米等面积单位换算。',
        valuePlaceholder: '输入面积',
        units: AREA_UNITS,
        precision: 4,
        estimateNote: ''
      };
    }
    return {
      title: '长度换算',
      desc: '毫米、厘米、米、千米和英制长度单位快速换算。',
      valuePlaceholder: '输入长度',
      units: LENGTH_UNITS,
      precision: 4,
      estimateNote: ''
    };
  }

  private parseNumber(value: string): number {
    const parsed: number = Number(value);
    if (Number.isFinite(parsed)) {
      return parsed;
    }
    return 0;
  }

  private clampUnitIndex(index: number, units: UnitDefinition[]): number {
    if (index < 0 || index >= units.length) {
      return 0;
    }
    return index;
  }

  private findUnitIndexByName(units: UnitDefinition[], unitName: string): number {
    for (let index: number = 0; index < units.length; index++) {
      if (units[index].name === unitName) {
        return index;
      }
    }
    return 0;
  }

  private findUnitByName(units: UnitDefinition[], unitName: string): UnitDefinition {
    const index: number = this.findUnitIndexByName(units, unitName);
    return units[index];
  }

  private formatNumber(value: number, precision: number = 2): string {
    if (!Number.isFinite(value)) {
      return '0';
    }
    const fixed: string = value.toFixed(precision);
    return fixed.replace(/\.?0+$/, '');
  }

  private formatMoney(value: number): string {
    if (!Number.isFinite(value)) {
      return '¥ 0.00';
    }
    return `¥ ${value.toFixed(2)}`;
  }

  private getConversionValue(): number {
    const config: ConverterConfig = this.getConverterConfig();
    const fromUnit: UnitDefinition = this.findUnitByName(config.units, this.fromUnitName);
    const toUnit: UnitDefinition = this.findUnitByName(config.units, this.toUnitName);
    const input: number = this.parseNumber(this.converterValue);
    return input * fromUnit.factor / toUnit.factor;
  }

  private getConversionText(): string {
    const config: ConverterConfig = this.getConverterConfig();
    const toUnit: UnitDefinition = this.findUnitByName(config.units, this.toUnitName);
    return `${this.formatNumber(this.getConversionValue(), config.precision)} ${toUnit.symbol}`;
  }

  private getConversionTextByState(key: CalculatorKey, inputValue: string, fromUnitName: string, toUnitName: string): string {
    const config: ConverterConfig = this.getConverterConfigByKey(key);
    const fromUnit: UnitDefinition = this.findUnitByName(config.units, fromUnitName);
    const toUnit: UnitDefinition = this.findUnitByName(config.units, toUnitName);
    const input: number = this.parseNumber(inputValue);
    const result: number = input * fromUnit.factor / toUnit.factor;
    return `${this.formatNumber(result, config.precision)} ${toUnit.symbol}`;
  }

  private getCurrentConversionText(): string {
    return this.getConversionTextByState(this.activeKey, this.converterValue, this.fromUnitName, this.toUnitName);
  }

  private setFromUnitName(unitName: string): void {
    const config: ConverterConfig = this.getConverterConfig();
    const nextIndex: number = this.findUnitIndexByName(config.units, unitName);
    const nextUnitName: string = config.units[nextIndex].name;
    this.fromUnitName = nextUnitName;
    this.fromIndex = nextIndex;
  }

  private setToUnitName(unitName: string): void {
    const config: ConverterConfig = this.getConverterConfig();
    const nextIndex: number = this.findUnitIndexByName(config.units, unitName);
    const nextUnitName: string = config.units[nextIndex].name;
    this.toUnitName = nextUnitName;
    this.toIndex = nextIndex;
  }

  private setFromUnitIndex(index: number): void {
    const nextIndex: number = this.clampUnitIndex(index, this.getConverterConfig().units);
    this.fromIndex = nextIndex;
    this.fromUnitName = this.getConverterConfig().units[nextIndex].name;
  }

  private setToUnitIndex(index: number): void {
    const nextIndex: number = this.clampUnitIndex(index, this.getConverterConfig().units);
    this.toIndex = nextIndex;
    this.toUnitName = this.getConverterConfig().units[nextIndex].name;
  }

  private openUnitPicker(target: 'from' | 'to'): void {
    if (target === 'from') {
      this.showFromUnitPicker = true;
    } else {
      this.showToUnitPicker = true;
    }
  }

  private selectFromUnitName(unitName: string): void {
    this.setFromUnitName(unitName);
    this.showFromUnitPicker = false;
  }

  private selectToUnitName(unitName: string): void {
    this.setToUnitName(unitName);
    this.showToUnitPicker = false;
  }

  private resetConverterIndexes(key: CalculatorKey): void {
    let nextFromIndex: number = 0;
    let nextToIndex: number = 1;
    if (key === 'length') {
      nextFromIndex = 2;
      nextToIndex = 1;
    }
    if (key === 'volume') {
      nextFromIndex = 1;
      nextToIndex = 0;
    }
    if (key === 'time') {
      nextFromIndex = 2;
      nextToIndex = 3;
    }
    if (key === 'weight') {
      nextFromIndex = 2;
      nextToIndex = 5;
    }
    if (key === 'area') {
      nextFromIndex = 2;
      nextToIndex = 3;
    }
    this.fromIndex = nextFromIndex;
    this.toIndex = nextToIndex;
    const config: ConverterConfig = this.getConverterConfigByKey(key);
    this.fromUnitName = config.units[this.clampUnitIndex(nextFromIndex, config.units)].name;
    this.toUnitName = config.units[this.clampUnitIndex(nextToIndex, config.units)].name;
  }

  private selectCategory(key: CalculatorKey): void {
    this.activeKey = key;
    if (this.isConverterCategory(key)) {
      this.resetConverterIndexes(key);
    }
  }

  private getActiveCategory(): CalculatorCategory {
    for (let index: number = 0; index < this.categoryItems.length; index++) {
      const item: CalculatorCategory = this.categoryItems[index];
      if (item.key === this.activeKey) {
        return item;
      }
    }
    return CATEGORIES[0];
  }

  private getCategoryIndex(key: CalculatorKey): number {
    for (let index: number = 0; index < this.categoryItems.length; index++) {
      if (this.categoryItems[index].key === key) {
        return index;
      }
    }
    return -1;
  }

  private clampCategoryIndex(index: number): number {
    if (index < 0) {
      return 0;
    }
    const maxIndex: number = this.categoryItems.length - 1;
    if (index > maxIndex) {
      return maxIndex;
    }
    return index;
  }

  private moveCategory(fromIndex: number, toIndex: number): void {
    if (fromIndex < 0 || toIndex < 0 || fromIndex === toIndex) {
      return;
    }
    const nextItems: CalculatorCategory[] = this.categoryItems.slice();
    const movingItems: CalculatorCategory[] = nextItems.splice(fromIndex, 1);
    if (movingItems.length === 0) {
      return;
    }
    nextItems.splice(toIndex, 0, movingItems[0]);
    this.categoryItems = nextItems;
  }

  private resetCategoryOrder(): void {
    this.categoryItems = CATEGORIES.slice();
  }

  private isConverterCategory(key: CalculatorKey): boolean {
    return key === 'length' || key === 'volume' || key === 'time' || key === 'weight' || key === 'area';
  }

  private startTimer(): void {
    if (this.stopwatchRunning) {
      return;
    }
    this.stopwatchRunning = true;
    this.timerId = setInterval((): void => {
      this.stopwatchMs += 10;
    }, 10);
  }

  private stopTimer(): void {
    if (this.timerId >= 0) {
      clearInterval(this.timerId);
      this.timerId = -1;
    }
    this.stopwatchRunning = false;
  }

  private resetTimer(): void {
    this.stopTimer();
    this.stopwatchMs = 0;
    this.lapItems = [];
  }

  private addLap(): void {
    if (this.stopwatchMs <= 0) {
      return;
    }
    const nextItems: string[] = this.lapItems.slice();
    nextItems.unshift(this.formatDuration(this.stopwatchMs));
    this.lapItems = nextItems;
  }

  private formatDuration(ms: number): string {
    const totalCentiseconds: number = Math.floor(ms / 10);
    const centiseconds: number = totalCentiseconds % 100;
    const totalSeconds: number = Math.floor(totalCentiseconds / 100);
    const seconds: number = totalSeconds % 60;
    const totalMinutes: number = Math.floor(totalSeconds / 60);
    const minutes: number = totalMinutes % 60;
    const hours: number = Math.floor(totalMinutes / 60);
    return `${this.pad2(hours)}:${this.pad2(minutes)}:${this.pad2(seconds)}.${this.pad2(centiseconds)}`;
  }

  private pad2(value: number): string {
    if (value < 10) {
      return `0${value}`;
    }
    return `${value}`;
  }

  private getTaxableIncome(): number {
    const annualIncome: number = this.parseNumber(this.monthlyIncome) * 12;
    const taxableIncome: number = annualIncome - this.parseNumber(this.monthlyBasicDeduction) * 12 -
      this.getAnnualSocialSecurityDeduction() - this.getAnnualHousingFundDeduction() -
      this.getAnnualSpecialDeduction();
    return Math.max(0, taxableIncome);
  }

  private getMonthlySocialSecurityDeduction(): number {
    if (this.socialSecurityMode === 'fixed') {
      return this.parseNumber(this.socialSecurityFixed);
    }
    return this.parseNumber(this.monthlyIncome) * this.parseNumber(this.socialSecurityRate) / 100;
  }

  private getMonthlyHousingFundDeduction(): number {
    if (this.housingFundMode === 'fixed') {
      return this.parseNumber(this.housingFundFixed);
    }
    return this.parseNumber(this.monthlyIncome) * this.parseNumber(this.housingFundRate) / 100;
  }

  private getAnnualSocialSecurityDeduction(): number {
    return this.getMonthlySocialSecurityDeduction() * 12;
  }

  private getAnnualHousingFundDeduction(): number {
    return this.getMonthlyHousingFundDeduction() * 12;
  }

  private getMonthlySpecialDeduction(): number {
    let total: number = 0;
    if (this.childEducationEnabled) {
      total += this.parseNumber(this.childEducationAmount);
    }
    if (this.continuingEducationEnabled) {
      total += this.parseNumber(this.continuingEducationAmount);
    }
    if (this.seriousIllnessEnabled) {
      total += this.parseNumber(this.seriousIllnessAmount) / 12;
    }
    if (this.mortgageInterestEnabled) {
      total += this.parseNumber(this.mortgageInterestAmount);
    }
    if (this.housingRentEnabled) {
      total += this.parseNumber(this.housingRentAmount);
    }
    if (this.elderSupportEnabled) {
      total += this.parseNumber(this.elderSupportAmount);
    }
    if (this.childCareEnabled) {
      total += this.parseNumber(this.childCareAmount);
    }
    return total;
  }

  private getAnnualSpecialDeduction(): number {
    return this.getMonthlySpecialDeduction() * 12;
  }

  private getTaxByTaxableIncome(taxableIncome: number): number {
    for (let index: number = 0; index < TAX_BRACKETS.length; index++) {
      const bracket: TaxBracket = TAX_BRACKETS[index];
      if (taxableIncome > bracket.threshold) {
        return Math.max(0, taxableIncome * bracket.rate - bracket.deduction);
      }
    }
    return 0;
  }

  private getTaxDue(): number {
    return this.getCumulativeTax(12);
  }

  private getMonthlyTaxableIncome(): number {
    const monthlyIncome: number = this.parseNumber(this.monthlyIncome);
    return Math.max(0, monthlyIncome - this.parseNumber(this.monthlyBasicDeduction) -
      this.getMonthlySocialSecurityDeduction() - this.getMonthlyHousingFundDeduction() -
      this.getMonthlySpecialDeduction());
  }

  private getCumulativeTax(month: number): number {
    return this.getTaxByTaxableIncome(this.getMonthlyTaxableIncome() * month);
  }

  private getMonthlyTax(month: number): number {
    if (month <= 1) {
      return this.getCumulativeTax(1);
    }
    return Math.max(0, this.getCumulativeTax(month) - this.getCumulativeTax(month - 1));
  }

  private getMonthlyNetIncome(month: number): number {
    const monthlyIncome: number = this.parseNumber(this.monthlyIncome);
    const monthlyDeductions: number = this.getMonthlySocialSecurityDeduction() + this.getMonthlyHousingFundDeduction();
    return monthlyIncome - monthlyDeductions - this.getMonthlyTax(month);
  }

  private getTaxMetrics(): MetricItem[] {
    const annualIncome: number = this.parseNumber(this.monthlyIncome) * 12;
    const taxDue: number = this.getTaxDue();
    return [
      { label: '应纳税所得额', value: this.formatMoney(this.getTaxableIncome()) },
      { label: '年度起征扣除', value: this.formatMoney(this.parseNumber(this.monthlyBasicDeduction) * 12) },
      { label: '社保年度扣除', value: this.formatMoney(this.getAnnualSocialSecurityDeduction()) },
      { label: '公积金年度扣除', value: this.formatMoney(this.getAnnualHousingFundDeduction()) },
      { label: '专项附加扣除', value: this.formatMoney(this.getAnnualSpecialDeduction()) },
      { label: '估算税后收入', value: this.formatMoney(annualIncome - this.getAnnualSocialSecurityDeduction() -
        this.getAnnualHousingFundDeduction() - taxDue) }
    ];
  }

  private getMonthlyRate(): number {
    return this.parseNumber(this.annualRate) / 100 / 12;
  }

  private getLoanPrincipal(): number {
    return this.parseNumber(this.loanAmount) * 10000;
  }

  private getLoanMonths(): number {
    return Math.max(1, Math.round(this.parseNumber(this.loanYears) * 12));
  }

  private getEqualInterestPayment(): number {
    const principal: number = this.getLoanPrincipal();
    const months: number = this.getLoanMonths();
    const monthlyRate: number = this.getMonthlyRate();
    if (monthlyRate <= 0) {
      return principal / months;
    }
    const power: number = Math.pow(1 + monthlyRate, months);
    return principal * monthlyRate * power / (power - 1);
  }

  private getEqualPrincipalFirstPayment(): number {
    const principal: number = this.getLoanPrincipal();
    const months: number = this.getLoanMonths();
    const monthlyRate: number = this.getMonthlyRate();
    return principal / months + principal * monthlyRate;
  }

  private getEqualPrincipalLastPayment(): number {
    const principal: number = this.getLoanPrincipal();
    const months: number = this.getLoanMonths();
    const monthlyRate: number = this.getMonthlyRate();
    return principal / months + principal / months * monthlyRate;
  }

  private getMortgageMetrics(): MetricItem[] {
    const principal: number = this.getLoanPrincipal();
    const months: number = this.getLoanMonths();
    const monthlyRate: number = this.getMonthlyRate();
    if (this.repaymentType === 'interest') {
      const monthlyPayment: number = this.getEqualInterestPayment();
      const totalPayment: number = monthlyPayment * months;
      return [
        { label: '总利息', value: this.formatMoney(totalPayment - principal) },
        { label: '总还款', value: this.formatMoney(totalPayment) },
        { label: '还款期数', value: `${months} 期` }
      ];
    }
    const totalInterest: number = principal * monthlyRate * (months + 1) / 2;
    return [
      { label: '末月月供', value: this.formatMoney(this.getEqualPrincipalLastPayment()) },
      { label: '总利息', value: this.formatMoney(totalInterest) },
      { label: '总还款', value: this.formatMoney(principal + totalInterest) }
    ];
  }

  @Builder
  CategoryTabs() {
    Row() {
      Scroll() {
        Row({ space: 8 }) {
          ForEach(this.categoryItems, (item: CalculatorCategory) => {
            Row() {
              Text(item.icon)
                .fontSize(15)
                .fontWeight(FontWeight.Bold)
                .fontColor(this.activeKey === item.key ? Color.White : '#147C78')
                .width(28)
                .height(28)
                .textAlign(TextAlign.Center)
                .borderRadius(8)
                .backgroundColor(this.activeKey === item.key ? '#147C78' : '#DFF2F0')
              Text(item.title)
                .fontSize(14)
                .fontWeight(FontWeight.Bold)
                .fontColor(this.activeKey === item.key ? '#147C78' : '#334247')
                .margin({ left: 7 })
            }
            .height(46)
            .padding({ left: 10, right: 12 })
            .borderRadius(8)
            .backgroundColor(this.activeKey === item.key ? '#F1FBFA' : Color.White)
            .border({ width: 1, color: this.activeKey === item.key ? '#147C78' : '#E4ECEB' })
            .onClick((): void => {
              this.selectCategory(item.key);
            })
          }, (item: CalculatorCategory): string => item.key)
        }
        .padding({ left: 16, right: 8, bottom: 2 })
      }
      .scrollable(ScrollDirection.Horizontal)
      .scrollBar(BarState.Off)
      .layoutWeight(1)

      Button('≡')
        .height(42)
        .width(42)
        .fontSize(22)
        .fontColor('#147C78')
        .backgroundColor('rgba(0,0,0,0)')
        .borderRadius(0)
        .margin({ right: 16, left: 4 })
        .onClick((): void => {
          this.showCategoryEditor = true;
        })
    }
    .width('100%')
    .height(54)
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
              .fontColor('#182326')
            Text('使用上移、下移调整顶部标签顺序。')
              .fontSize(13)
              .fontColor('#667579')
              .margin({ top: 6 })
          }
          .alignItems(HorizontalAlign.Start)
          .layoutWeight(1)
          Button('重置')
            .height(34)
            .width(62)
            .fontSize(13)
            .fontColor('#147C78')
            .backgroundColor('#DFF2F0')
            .borderRadius(8)
            .onClick((): void => {
              this.resetCategoryOrder();
            })
        }
        .width('100%')
        .margin({ bottom: 14 })

        Column() {
          ForEach(this.categoryItems, (item: CalculatorCategory, index: number) => {
            Row() {
              Text(item.icon)
                .fontSize(15)
                .fontWeight(FontWeight.Bold)
                .fontColor(Color.White)
                .width(30)
                .height(30)
                .textAlign(TextAlign.Center)
                .borderRadius(8)
                .backgroundColor('#147C78')
              Text(item.title)
                .fontSize(15)
                .fontWeight(FontWeight.Bold)
                .fontColor('#182326')
                .margin({ left: 10 })
                .layoutWeight(1)
              Button('上移')
                .height(34)
                .width(58)
                .fontSize(13)
                .fontColor(index === 0 ? '#9AA7AA' : '#147C78')
                .backgroundColor(index === 0 ? '#F2F5F5' : '#DFF2F0')
                .borderRadius(8)
                .enabled(index > 0)
                .onClick((): void => {
                  this.moveCategory(index, index - 1);
                })
              Button('下移')
                .height(34)
                .width(58)
                .fontSize(13)
                .fontColor(index === this.categoryItems.length - 1 ? '#9AA7AA' : '#147C78')
                .backgroundColor(index === this.categoryItems.length - 1 ? '#F2F5F5' : '#DFF2F0')
                .borderRadius(8)
                .margin({ left: 8 })
                .enabled(index < this.categoryItems.length - 1)
                .onClick((): void => {
                  this.moveCategory(index, index + 1);
                })
            }
            .width('100%')
            .height(50)
            .padding({ left: 10, right: 10 })
            .borderRadius(8)
            .backgroundColor(item.key === this.activeKey ? '#F1FBFA' : '#FFFFFF')
            .border({ width: 1, color: item.key === this.activeKey ? '#147C78' : '#E4ECEB' })
            .margin({ bottom: 8 })
          }, (item: CalculatorCategory): string => item.key)
        }
        .width('100%')

        Row() {
          Button('完成')
            .height(44)
            .layoutWeight(1)
            .fontSize(16)
            .fontColor(Color.White)
            .backgroundColor('#147C78')
            .borderRadius(8)
            .onClick((): void => {
              this.showCategoryEditor = false;
            })
        }
        .width('100%')
        .margin({ top: 10 })
      }
      .width('88%')
      .padding({ left: 18, right: 18, top: 20, bottom: 18 })
      .borderRadius(18)
      .backgroundColor(Color.White)
      Blank()
    }
    .width('100%')
    .height('100%')
    .padding({ left: 16, right: 16 })
    .backgroundColor('#00000066')
  }

  @Builder
  FromUnitPickerDialog() {
    Column() {
      Blank()
      Column() {
        Row()
          .width(38)
          .height(4)
          .borderRadius(2)
          .backgroundColor('#C7D3D1')
          .margin({ bottom: 14 })

        Row() {
          Column() {
            Text('选择原单位')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor('#182326')
            Text(this.getConverterConfig().title)
              .fontSize(13)
              .fontColor('#667579')
              .margin({ top: 6 })
          }
          .alignItems(HorizontalAlign.Start)
          .layoutWeight(1)
          Text('关闭')
            .height(32)
            .fontSize(14)
            .fontColor('#147C78')
            .textAlign(TextAlign.Center)
            .padding({ left: 12, right: 12 })
            .borderRadius(8)
            .backgroundColor('#DFF2F0')
            .onClick((): void => {
              this.showFromUnitPicker = false;
            })
        }
        .width('100%')
        .margin({ bottom: 14 })

        Column() {
          ForEach(this.getConverterConfig().units, (unit: UnitDefinition, index: number) => {
            Row() {
              Text(unit.name)
                .fontSize(15)
                .fontWeight(FontWeight.Bold)
                .fontColor('#182326')
                .layoutWeight(1)
              Text(unit.symbol)
                .fontSize(13)
                .fontColor('#667579')
              if (unit.name === this.fromUnitName) {
                Text('✓')
                  .fontSize(16)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#147C78')
                  .width(24)
                  .textAlign(TextAlign.End)
              }
            }
            .width('100%')
            .height(42)
            .padding({ left: 12, right: 10 })
            .borderRadius(8)
            .backgroundColor(unit.name === this.fromUnitName ? '#DFF2F0' : '#F8FAFA')
            .border({ width: 1, color: unit.name === this.fromUnitName ? '#147C78' : '#E4ECEB' })
            .margin({ bottom: 6 })
            .onClick((): void => {
              this.selectFromUnitName(unit.name);
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

  @Builder
  ToUnitPickerDialog() {
    Column() {
      Blank()
      Column() {
        Row()
          .width(38)
          .height(4)
          .borderRadius(2)
          .backgroundColor('#C7D3D1')
          .margin({ bottom: 14 })

        Row() {
          Column() {
            Text('选择目标单位')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor('#182326')
            Text(this.getConverterConfig().title)
              .fontSize(13)
              .fontColor('#667579')
              .margin({ top: 6 })
          }
          .alignItems(HorizontalAlign.Start)
          .layoutWeight(1)
          Text('关闭')
            .height(32)
            .fontSize(14)
            .fontColor('#147C78')
            .textAlign(TextAlign.Center)
            .padding({ left: 12, right: 12 })
            .borderRadius(8)
            .backgroundColor('#DFF2F0')
            .onClick((): void => {
              this.showToUnitPicker = false;
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
                .fontColor('#182326')
                .layoutWeight(1)
              Text(unit.symbol)
                .fontSize(13)
                .fontColor('#667579')
              if (unit.name === this.toUnitName) {
                Text('✓')
                  .fontSize(16)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#147C78')
                  .width(24)
                  .textAlign(TextAlign.End)
              }
            }
            .width('100%')
            .height(42)
            .padding({ left: 12, right: 10 })
            .borderRadius(8)
            .backgroundColor(unit.name === this.toUnitName ? '#DFF2F0' : '#F8FAFA')
            .border({ width: 1, color: unit.name === this.toUnitName ? '#147C78' : '#E4ECEB' })
            .margin({ bottom: 6 })
            .onClick((): void => {
              this.selectToUnitName(unit.name);
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

  @Builder
  MetricList(items: MetricItem[]) {
    Column() {
      ForEach(items, (item: MetricItem) => {
        Row() {
          Text(item.label)
            .fontSize(14)
            .fontColor('#667579')
          Text(item.value)
            .fontSize(15)
            .fontWeight(FontWeight.Bold)
            .fontColor('#182326')
            .textAlign(TextAlign.End)
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .width('100%')
        .padding({ top: 12, bottom: 12 })
        .border({ width: { bottom: 1 }, color: '#E4ECEB' })
      }, (item: MetricItem): string => item.label)
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
            Text(this.formatMoney(this.getMonthlyTax(month)))
              .layoutWeight(1)
              .fontSize(13)
              .fontColor('#182326')
              .textAlign(TextAlign.End)
            Text(this.formatMoney(this.getMonthlyNetIncome(month)))
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

  @Builder
  TaxResultCard() {
    Column() {
      Text('年度应纳税额')
        .fontSize(13)
        .fontWeight(FontWeight.Bold)
        .fontColor('rgba(255,255,255,0.72)')
      Text(this.formatMoney(this.getTaxDue()))
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
  SectionTitle(title: string) {
    Text(title)
      .fontSize(16)
      .fontWeight(FontWeight.Bold)
      .fontColor('#182326')
      .margin({ bottom: 12 })
  }

  @Builder
  InputField(label: string, value: string, placeholder: string, onChange: (value: string) => void) {
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
        .type(InputType.Normal)
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
          .height(36)
          .layoutWeight(1)
          .fontSize(13)
          .fontColor(this.socialSecurityMode === 'rate' ? Color.White : '#147C78')
          .backgroundColor(this.socialSecurityMode === 'rate' ? '#102729' : '#DFF2F0')
          .borderRadius(8)
          .margin({ right: 4 })
          .onClick((): void => {
            this.socialSecurityMode = 'rate';
          })
        Button('固定额度')
          .height(36)
          .layoutWeight(1)
          .fontSize(13)
          .fontColor(this.socialSecurityMode === 'fixed' ? Color.White : '#147C78')
          .backgroundColor(this.socialSecurityMode === 'fixed' ? '#102729' : '#DFF2F0')
          .borderRadius(8)
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
          .height(36)
          .layoutWeight(1)
          .fontSize(13)
          .fontColor(this.housingFundMode === 'rate' ? Color.White : '#147C78')
          .backgroundColor(this.housingFundMode === 'rate' ? '#102729' : '#DFF2F0')
          .borderRadius(8)
          .margin({ right: 4 })
          .onClick((): void => {
            this.housingFundMode = 'rate';
          })
        Button('固定额度')
          .height(36)
          .layoutWeight(1)
          .fontSize(13)
          .fontColor(this.housingFundMode === 'fixed' ? Color.White : '#147C78')
          .backgroundColor(this.housingFundMode === 'fixed' ? '#102729' : '#DFF2F0')
          .borderRadius(8)
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

  private isDeductionEnabled(key: string): boolean {
    if (key === 'childrenEducation') {
      return this.childEducationEnabled;
    }
    if (key === 'continuingEducation') {
      return this.continuingEducationEnabled;
    }
    if (key === 'seriousIllness') {
      return this.seriousIllnessEnabled;
    }
    if (key === 'mortgageInterest') {
      return this.mortgageInterestEnabled;
    }
    if (key === 'housingRent') {
      return this.housingRentEnabled;
    }
    if (key === 'elderSupport') {
      return this.elderSupportEnabled;
    }
    if (key === 'childCare') {
      return this.childCareEnabled;
    }
    return false;
  }

  private getDeductionAmount(key: string): string {
    if (key === 'childrenEducation') {
      return this.childEducationAmount;
    }
    if (key === 'continuingEducation') {
      return this.continuingEducationAmount;
    }
    if (key === 'seriousIllness') {
      return this.seriousIllnessAmount;
    }
    if (key === 'mortgageInterest') {
      return this.mortgageInterestAmount;
    }
    if (key === 'housingRent') {
      return this.housingRentAmount;
    }
    if (key === 'elderSupport') {
      return this.elderSupportAmount;
    }
    if (key === 'childCare') {
      return this.childCareAmount;
    }
    return '0';
  }

  private setDeductionEnabled(key: string, enabled: boolean): void {
    if (key === 'childrenEducation') {
      this.childEducationEnabled = enabled;
    } else if (key === 'continuingEducation') {
      this.continuingEducationEnabled = enabled;
    } else if (key === 'seriousIllness') {
      this.seriousIllnessEnabled = enabled;
    } else if (key === 'mortgageInterest') {
      this.mortgageInterestEnabled = enabled;
    } else if (key === 'housingRent') {
      this.housingRentEnabled = enabled;
    } else if (key === 'elderSupport') {
      this.elderSupportEnabled = enabled;
    } else if (key === 'childCare') {
      this.childCareEnabled = enabled;
    }
  }

  private setDeductionAmount(key: string, value: string): void {
    if (key === 'childrenEducation') {
      this.childEducationAmount = value;
    } else if (key === 'continuingEducation') {
      this.continuingEducationAmount = value;
    } else if (key === 'seriousIllness') {
      this.seriousIllnessAmount = value;
    } else if (key === 'mortgageInterest') {
      this.mortgageInterestAmount = value;
    } else if (key === 'housingRent') {
      this.housingRentAmount = value;
    } else if (key === 'elderSupport') {
      this.elderSupportAmount = value;
    } else if (key === 'childCare') {
      this.childCareAmount = value;
    }
  }

  private getDeductionAmountLabel(key: string): string {
    if (key === 'seriousIllness') {
      return '扣除金额（元/年）';
    }
    return '扣除金额（元/月）';
  }

  @Builder
  DeductionItemCard(item: DeductionItem) {
    Column() {
      Row() {
        Text(this.isDeductionEnabled(item.key) ? '✓' : '')
          .width(28)
          .height(28)
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
          .textAlign(TextAlign.Center)
          .borderRadius(8)
          .backgroundColor(this.isDeductionEnabled(item.key) ? '#147C78' : '#DCE5E4')
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
        this.setDeductionEnabled(item.key, !this.isDeductionEnabled(item.key));
      })

      this.InputField(this.getDeductionAmountLabel(item.key), this.getDeductionAmount(item.key), '请输入扣除额', (value: string): void => {
        this.setDeductionAmount(item.key, value);
      })
    }
    .width('100%')
    .padding(12)
    .borderRadius(8)
    .backgroundColor(this.isDeductionEnabled(item.key) ? '#F1FBFA' : '#FFFFFF')
    .border({ width: 1, color: this.isDeductionEnabled(item.key) ? '#147C78' : '#E4ECEB' })
    .margin({ bottom: 10 })
  }

  @Builder
  UnitSelector(label: string, target: 'from' | 'to') {
    Column() {
      Text(label)
        .fontSize(13)
        .fontWeight(FontWeight.Bold)
        .fontColor('#415155')
        .margin({ bottom: 7 })
      Row() {
        Text(target === 'from' ? this.fromUnitName : this.toUnitName)
          .height(44)
          .width('100%')
          .fontSize(15)
          .fontWeight(FontWeight.Bold)
          .fontColor('#182326')
          .textAlign(TextAlign.Center)
          .backgroundColor('#FBFDFD')
          .borderRadius(8)
          .border({ width: 1, color: '#DCE5E4' })
          .onClick((): void => {
            this.openUnitPicker(target);
          })
        Text('▾')
          .height(44)
          .width(34)
          .fontSize(16)
          .fontColor('#147C78')
          .textAlign(TextAlign.Center)
          .margin({ left: -34 })
          .onClick((): void => {
            this.openUnitPicker(target);
          })
      }
      .width('100%')
    }
    .width('100%')
  }

  @Builder
  ConverterResultCard() {
    Column() {
      Text('换算结果')
        .fontSize(13)
        .fontWeight(FontWeight.Bold)
        .fontColor('rgba(255,255,255,0.72)')
      Text(this.getCurrentConversionText())
        .fontSize(34)
        .fontWeight(FontWeight.Bold)
        .fontColor(Color.White)
        .width('100%')
        .margin({ top: 10, bottom: 8 })
      Text(`${this.fromUnitName} → ${this.toUnitName}`)
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
  ConverterPanel() {
    Column() {
      this.SectionTitle(this.getConverterConfig().title)
      Text(this.getConverterConfig().desc)
        .fontSize(14)
        .fontColor('#667579')
        .lineHeight(21)
        .margin({ bottom: 16 })
      this.InputField('数值', this.converterValue, this.getConverterConfig().valuePlaceholder, (value: string): void => {
        this.converterValue = value;
      })
      Row() {
        Column() {
          this.UnitSelector('从', 'from')
        }
        .layoutWeight(1)
        .margin({ right: 6 })
        Column() {
          this.UnitSelector('到', 'to')
        }
        .layoutWeight(1)
        .margin({ left: 6 })
      }
      .width('100%')
      .margin({ top: 14 })

      this.ConverterResultCard()
    }
    .width('100%')
  }

  @Builder
  StopwatchPanel() {
    Column() {
      this.SectionTitle('秒表')
      Text(this.formatDuration(this.stopwatchMs))
        .fontSize(42)
        .fontWeight(FontWeight.Bold)
        .fontColor('#102729')
        .width('100%')
        .textAlign(TextAlign.Center)
        .margin({ top: 20, bottom: 22 })
      Row() {
        Button(this.stopwatchRunning ? '暂停' : '开始')
          .height(42)
          .layoutWeight(1)
          .margin({ right: 5 })
          .backgroundColor('#147C78')
          .onClick((): void => {
            if (this.stopwatchRunning) {
              this.stopTimer();
            } else {
              this.startTimer();
            }
          })
        Button('计次')
          .height(42)
          .layoutWeight(1)
          .margin({ left: 5, right: 5 })
          .fontColor('#334247')
          .backgroundColor('#EEF4F3')
          .onClick((): void => {
            this.addLap();
          })
        Button('重置')
          .height(42)
          .layoutWeight(1)
          .margin({ left: 5 })
          .fontColor('#334247')
          .backgroundColor('#EEF4F3')
          .onClick((): void => {
            this.resetTimer();
          })
      }
      .width('100%')
      Column() {
        ForEach(this.lapItems, (item: string, index: number) => {
          Row() {
            Text(`计次 ${this.lapItems.length - index}`)
              .fontSize(14)
              .fontColor('#667579')
            Text(item)
              .fontSize(15)
              .fontWeight(FontWeight.Bold)
              .fontColor('#182326')
          }
          .justifyContent(FlexAlign.SpaceBetween)
          .width('100%')
          .padding({ top: 12, bottom: 12 })
          .border({ width: { bottom: 1 }, color: '#E4ECEB' })
        }, (item: string): string => item)
      }
      .width('100%')
      .margin({ top: 18 })
    }
    .width('100%')
  }

  @Builder
  TaxPanel() {
    Column() {
      this.SectionTitle('个税估算')
      Text('按中国大陆综合所得年度口径估算，起征点、社保、公积金和专项附加扣除均可调整。')
        .fontSize(14)
        .fontColor('#667579')
        .lineHeight(21)
        .margin({ bottom: 16 })
      this.InputField('月收入（元）', this.monthlyIncome, '请输入月收入', (value: string): void => {
        this.monthlyIncome = value;
      })
      this.InputField('起征点（元/月）', this.monthlyBasicDeduction, '默认 5000', (value: string): void => {
        this.monthlyBasicDeduction = value;
      })

      this.SocialSecurityModeToggle()
      if (this.socialSecurityMode === 'rate') {
        this.InputField('社保比例（%）', this.socialSecurityRate, '请输入社保比例', (value: string): void => {
          this.socialSecurityRate = value;
        })
      } else {
        this.InputField('社保固定额（元/月）', this.socialSecurityFixed, '请输入社保固定额', (value: string): void => {
          this.socialSecurityFixed = value;
        })
      }

      this.HousingFundModeToggle()
      if (this.housingFundMode === 'rate') {
        this.InputField('公积金比例（%）', this.housingFundRate, '请输入公积金比例', (value: string): void => {
          this.housingFundRate = value;
        })
      } else {
        this.InputField('公积金固定额（元/月）', this.housingFundFixed, '请输入公积金固定额', (value: string): void => {
          this.housingFundFixed = value;
        })
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
      this.MetricList(this.getTaxMetrics())
      this.MonthlyTaxTable()
    }
    .width('100%')
  }

  @Builder
  MortgagePanel() {
    Column() {
      this.SectionTitle('房贷计算')
      Text('支持等额本息和等额本金，输入商业贷款金额、年限和年利率。')
        .fontSize(14)
        .fontColor('#667579')
        .lineHeight(21)
        .margin({ bottom: 16 })
      this.InputField('贷款总额（万元）', this.loanAmount, '请输入贷款总额', (value: string): void => {
        this.loanAmount = value;
      })
      this.InputField('贷款年限（年）', this.loanYears, '请输入贷款年限', (value: string): void => {
        this.loanYears = value;
      })
      this.InputField('年利率（%）', this.annualRate, '请输入年利率', (value: string): void => {
        this.annualRate = value;
      })
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
      this.ResultCard(this.repaymentType === 'interest' ? '预计月供' : '首月月供',
        this.formatMoney(this.repaymentType === 'interest' ? this.getEqualInterestPayment() : this.getEqualPrincipalFirstPayment()),
        '结果按输入利率本地计算，仅供参考。')
      this.MetricList(this.getMortgageMetrics())
    }
    .width('100%')
  }

  @Builder
  ResultCard(label: string, value: string, note: string) {
    Column() {
      Text(label)
        .fontSize(13)
        .fontWeight(FontWeight.Bold)
        .fontColor('rgba(255,255,255,0.72)')
      Text(value)
        .fontSize(34)
        .fontWeight(FontWeight.Bold)
        .fontColor(Color.White)
        .width('100%')
        .margin({ top: 10, bottom: 8 })
      Text(note === '' ? '输入变化后结果会实时更新。' : note)
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
  ActiveToolPanel() {
    if (this.isConverterCategory(this.activeKey)) {
      this.ConverterPanel()
    } else if (this.activeKey === 'stopwatch') {
      this.StopwatchPanel()
    } else if (this.activeKey === 'tax') {
      this.TaxPanel()
    } else {
      this.MortgagePanel()
    }
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      Column() {
        Column() {
          Text('Hola Calculator')
            .fontSize(13)
            .fontWeight(FontWeight.Bold)
            .fontColor('#147C78')
          Text('万能计算器')
            .fontSize(30)
            .fontWeight(FontWeight.Bold)
            .fontColor('#182326')
            .margin({ top: 8 })
          Text(this.getActiveCategory().desc)
            .fontSize(14)
            .fontColor('#667579')
            .lineHeight(21)
            .margin({ top: 10 })
        }
        .alignItems(HorizontalAlign.Start)
        .width('100%')
        .padding({ left: 34, right: 34, top: 24, bottom: 12 })

        this.CategoryTabs()

        Scroll() {
          Column() {
            Column() {
              this.ActiveToolPanel()
            }
            .width('100%')
            .padding(18)
            .borderRadius(16)
            .backgroundColor(Color.White)
            .border({ width: 1, color: '#E4ECEB' })
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
      .width('100%')
      .height('100%')
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.Start)
      .backgroundColor('#F5F7F8')

      if (this.showCategoryEditor) {
        this.CategoryEditorDialog()
      }
      if (this.showFromUnitPicker) {
        this.FromUnitPickerDialog()
      }
      if (this.showToUnitPicker) {
        this.ToUnitPickerDialog()
      }
    }
    .width('100%')
    .height('100%')
  }
}
