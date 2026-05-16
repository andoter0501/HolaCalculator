export type CalculatorKey = 'normal' | 'length' | 'volume' | 'time' | 'stopwatch' | 'weight' | 'area' | 'tax' | 'mortgage';
export type CategoryMenuKey = CalculatorKey | 'editor';
export type RepaymentType = 'interest' | 'principal';
export type MortgageLoanType = 'commercial' | 'fund' | 'mixed';
export type HousingRentTier = 'large' | 'medium' | 'small';

export interface CalculatorCategory {
  key: CategoryMenuKey;
  title: string;
  icon: string;
  desc: string;
}

export interface UnitDefinition {
  name: string;
  symbol: string;
  factor: number;
}

export interface ConverterConfig {
  title: string;
  desc: string;
  valuePlaceholder: string;
  units: UnitDefinition[];
  precision: number;
  estimateNote: string;
}

export interface MetricItem {
  label: string;
  value: string;
}

export interface MortgagePartResult {
  principal: number;
  months: number;
  monthlyPayment: number;
  firstMonthPayment: number;
  lastMonthPayment: number;
  totalPayment: number;
  totalInterest: number;
}

export interface TaxBracket {
  threshold: number;
  rate: number;
  deduction: number;
}

export interface DeductionItem {
  key: string;
  title: string;
  standard: string;
  note: string;
}

export interface TaxDeductionState {
  enabled: boolean;
  amount: string;
}
