import {
  CalculatorCategory,
  CategoryMenuKey,
  ConverterConfig,
  DeductionItem,
  TaxBracket,
  UnitDefinition
} from './Types';

export const CATEGORIES: CalculatorCategory[] = [
  { key: 'normal', title: '计算器', icon: '🔢', desc: '加减乘除' },
  { key: 'tax', title: '个税', icon: '💰', desc: '综合所得估算' },
  { key: 'mortgage', title: '房贷', icon: '🏠', desc: '等额本息、等额本金' },
  { key: 'severance', title: '裁员赔偿', icon: '⚠️', desc: 'N、N+1、2N 赔偿金' },
  { key: 'length', title: '长度', icon: '📏', desc: '米、厘米、英尺、英里' },
  { key: 'volume', title: '体积', icon: '🧱', desc: '升、毫升、立方米' },
  { key: 'time', title: '时间', icon: '⌛', desc: '秒、分钟、小时、天' },
  { key: 'stopwatch', title: '秒表', icon: '⏱', desc: '计时、暂停、计次' },
  { key: 'weight', title: '重量', icon: '⚖️', desc: '克、千克、磅、吨' },
  { key: 'area', title: '面积', icon: '📐', desc: '平方米、公顷、亩' },
  { key: 'editor', title: '编辑', icon: '≡', desc: '调整顺序' }
];

export const LENGTH_UNITS: UnitDefinition[] = [
  { name: '毫米', symbol: 'mm', factor: 0.001 },
  { name: '厘米', symbol: 'cm', factor: 0.01 },
  { name: '米', symbol: 'm', factor: 1 },
  { name: '千米', symbol: 'km', factor: 1000 },
  { name: '英寸', symbol: 'in', factor: 0.0254 },
  { name: '英尺', symbol: 'ft', factor: 0.3048 },
  { name: '码', symbol: 'yd', factor: 0.9144 },
  { name: '英里', symbol: 'mi', factor: 1609.344 }
];

export const VOLUME_UNITS: UnitDefinition[] = [
  { name: '毫升', symbol: 'ml', factor: 0.001 },
  { name: '升', symbol: 'L', factor: 1 },
  { name: '立方厘米', symbol: 'cm³', factor: 0.001 },
  { name: '立方米', symbol: 'm³', factor: 1000 },
  { name: '加仑', symbol: 'gal', factor: 3.785411784 }
];

export const TIME_UNITS: UnitDefinition[] = [
  { name: '秒', symbol: 's', factor: 1 },
  { name: '分钟', symbol: 'min', factor: 60 },
  { name: '小时', symbol: 'h', factor: 3600 },
  { name: '天', symbol: 'd', factor: 86400 },
  { name: '周', symbol: 'w', factor: 604800 },
  { name: '月', symbol: 'mo', factor: 2629800 },
  { name: '年', symbol: 'y', factor: 31557600 }
];

export const WEIGHT_UNITS: UnitDefinition[] = [
  { name: '毫克', symbol: 'mg', factor: 0.000001 },
  { name: '克', symbol: 'g', factor: 0.001 },
  { name: '千克', symbol: 'kg', factor: 1 },
  { name: '吨', symbol: 't', factor: 1000 },
  { name: '盎司', symbol: 'oz', factor: 0.028349523125 },
  { name: '磅', symbol: 'lb', factor: 0.45359237 }
];

export const AREA_UNITS: UnitDefinition[] = [
  { name: '平方毫米', symbol: 'mm²', factor: 0.000001 },
  { name: '平方厘米', symbol: 'cm²', factor: 0.0001 },
  { name: '平方米', symbol: 'm²', factor: 1 },
  { name: '亩', symbol: '亩', factor: 666.6666667 },
  { name: '公顷', symbol: 'ha', factor: 10000 },
  { name: '平方千米', symbol: 'km²', factor: 1000000 },
  { name: '平方英尺', symbol: 'ft²', factor: 0.09290304 }
];

export const TAX_BRACKETS: TaxBracket[] = [
  { threshold: 960000, rate: 0.45, deduction: 181920 },
  { threshold: 660000, rate: 0.35, deduction: 85920 },
  { threshold: 420000, rate: 0.30, deduction: 52920 },
  { threshold: 300000, rate: 0.25, deduction: 31920 },
  { threshold: 144000, rate: 0.20, deduction: 16920 },
  { threshold: 36000, rate: 0.10, deduction: 2520 },
  { threshold: 0, rate: 0.03, deduction: 0 }
];

export const TAX_MONTHS: number[] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];

export const DEDUCTION_ITEMS: DeductionItem[] = [
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

export const CONVERTER_CONFIGS = new Map<string, ConverterConfig>([
  ['length', {
    title: '长度换算',
    desc: '毫米、厘米、米、千米和英制长度单位快速换算。',
    valuePlaceholder: '输入长度',
    units: LENGTH_UNITS,
    precision: 4,
    estimateNote: ''
  }],
  ['volume', {
    title: '体积换算',
    desc: '升、毫升、立方厘米、立方米和加仑快速换算。',
    valuePlaceholder: '输入体积',
    units: VOLUME_UNITS,
    precision: 4,
    estimateNote: ''
  }],
  ['time', {
    title: '时间换算',
    desc: '秒、分钟、小时、天、周、月、年之间换算。',
    valuePlaceholder: '输入时间',
    units: TIME_UNITS,
    precision: 4,
    estimateNote: '月和年按固定平均值估算。'
  }],
  ['weight', {
    title: '重量换算',
    desc: '毫克、克、千克、吨、盎司和磅之间换算。',
    valuePlaceholder: '输入重量',
    units: WEIGHT_UNITS,
    precision: 4,
    estimateNote: ''
  }],
  ['area', {
    title: '面积换算',
    desc: '平方米、亩、公顷、平方千米等面积单位换算。',
    valuePlaceholder: '输入面积',
    units: AREA_UNITS,
    precision: 4,
    estimateNote: ''
  }]
]);

export const DEFAULT_UNIT_INDEXES = new Map<string, number[]>([
  ['length', [2, 1]],
  ['volume', [1, 0]],
  ['time', [2, 3]],
  ['weight', [2, 5]],
  ['area', [2, 3]]
]);

export const DEFAULT_DEDUCTION_AMOUNTS = new Map<string, string>([
  ['childrenEducation', '2000'],
  ['continuingEducation', '400'],
  ['seriousIllness', '0'],
  ['mortgageInterest', '1000'],
  ['housingRent', '1500'],
  ['elderSupport', '3000'],
  ['childCare', '2000']
]);
