import { LaborIncomeMode, TaxBracket, TaxDeductionState } from './Types';
import { TAX_BRACKETS } from './Constants';
import { parseNumber } from './Utils';

export function getMonthlySocialSecurity(
  income: string,
  mode: string,
  rate: string,
  fixed: string
): number {
  if (mode === 'fixed') {
    return parseNumber(fixed);
  }
  return parseNumber(income) * parseNumber(rate) / 100;
}

export function getMonthlyHousingFund(
  income: string,
  mode: string,
  rate: string,
  fixed: string
): number {
  if (mode === 'fixed') {
    return parseNumber(fixed);
  }
  return parseNumber(income) * parseNumber(rate) / 100;
}

export function getMonthlySpecialDeduction(
  deductions: Map<string, TaxDeductionState>
): number {
  let total: number = 0;
  const keys: string[] = ['childrenEducation', 'continuingEducation', 'seriousIllness',
    'mortgageInterest', 'housingRent', 'elderSupport', 'childCare'];
  for (let i: number = 0; i < keys.length; i++) {
    const key: string = keys[i];
    const state: TaxDeductionState | undefined = deductions.get(key);
    if (state !== undefined && state.enabled) {
      if (key === 'seriousIllness') {
        total += parseNumber(state.amount) / 12;
      } else {
        total += parseNumber(state.amount);
      }
    }
  }
  return total;
}

export function getAnnualSocialSecurityDeduction(
  income: string,
  mode: string,
  rate: string,
  fixed: string
): number {
  return getMonthlySocialSecurity(income, mode, rate, fixed) * 12;
}

export function getAnnualHousingFundDeduction(
  income: string,
  mode: string,
  rate: string,
  fixed: string
): number {
  return getMonthlyHousingFund(income, mode, rate, fixed) * 12;
}

export function getAnnualSpecialDeduction(
  deductions: Map<string, TaxDeductionState>
): number {
  return getMonthlySpecialDeduction(deductions) * 12;
}

export function getTaxableIncome(
  income: string,
  basicDeduction: string,
  socialSecurityMode: string,
  socialSecurityRate: string,
  socialSecurityFixed: string,
  housingFundMode: string,
  housingFundRate: string,
  housingFundFixed: string,
  deductions: Map<string, TaxDeductionState>
): number {
  const annualIncome: number = parseNumber(income) * 12;
  const taxableIncome: number = annualIncome - parseNumber(basicDeduction) * 12 -
    getAnnualSocialSecurityDeduction(income, socialSecurityMode, socialSecurityRate, socialSecurityFixed) -
    getAnnualHousingFundDeduction(income, housingFundMode, housingFundRate, housingFundFixed) -
    getAnnualSpecialDeduction(deductions);
  return Math.max(0, taxableIncome);
}

export function getTaxByTaxableIncome(taxableIncome: number): number {
  for (let index: number = 0; index < TAX_BRACKETS.length; index++) {
    const bracket: TaxBracket = TAX_BRACKETS[index];
    if (taxableIncome > bracket.threshold) {
      return Math.max(0, taxableIncome * bracket.rate - bracket.deduction);
    }
  }
  return 0;
}

export function getMonthlyTaxableIncome(
  income: string,
  basicDeduction: string,
  socialSecurityMode: string,
  socialSecurityRate: string,
  socialSecurityFixed: string,
  housingFundMode: string,
  housingFundRate: string,
  housingFundFixed: string,
  deductions: Map<string, TaxDeductionState>
): number {
  const monthlyIncome: number = parseNumber(income);
  return Math.max(0, monthlyIncome - parseNumber(basicDeduction) -
    getMonthlySocialSecurity(income, socialSecurityMode, socialSecurityRate, socialSecurityFixed) -
    getMonthlyHousingFund(income, housingFundMode, housingFundRate, housingFundFixed) -
    getMonthlySpecialDeduction(deductions));
}

export function getCumulativeTax(
  month: number,
  income: string,
  basicDeduction: string,
  socialSecurityMode: string,
  socialSecurityRate: string,
  socialSecurityFixed: string,
  housingFundMode: string,
  housingFundRate: string,
  housingFundFixed: string,
  deductions: Map<string, TaxDeductionState>
): number {
  return getTaxByTaxableIncome(
    getMonthlyTaxableIncome(income, basicDeduction, socialSecurityMode, socialSecurityRate, socialSecurityFixed,
      housingFundMode, housingFundRate, housingFundFixed, deductions) * month
  );
}

export function getMonthlyTax(
  month: number,
  income: string,
  basicDeduction: string,
  socialSecurityMode: string,
  socialSecurityRate: string,
  socialSecurityFixed: string,
  housingFundMode: string,
  housingFundRate: string,
  housingFundFixed: string,
  deductions: Map<string, TaxDeductionState>
): number {
  if (month <= 1) {
    return getCumulativeTax(1, income, basicDeduction, socialSecurityMode, socialSecurityRate, socialSecurityFixed,
      housingFundMode, housingFundRate, housingFundFixed, deductions);
  }
  return Math.max(0,
    getCumulativeTax(month, income, basicDeduction, socialSecurityMode, socialSecurityRate, socialSecurityFixed,
      housingFundMode, housingFundRate, housingFundFixed, deductions) -
    getCumulativeTax(month - 1, income, basicDeduction, socialSecurityMode, socialSecurityRate, socialSecurityFixed,
      housingFundMode, housingFundRate, housingFundFixed, deductions)
  );
}

export function getMonthlyNetIncome(
  month: number,
  income: string,
  socialSecurityMode: string,
  socialSecurityRate: string,
  socialSecurityFixed: string,
  housingFundMode: string,
  housingFundRate: string,
  housingFundFixed: string,
  basicDeduction: string,
  deductions: Map<string, TaxDeductionState>
): number {
  const monthlyIncome: number = parseNumber(income);
  const monthlyDeductions: number =
    getMonthlySocialSecurity(income, socialSecurityMode, socialSecurityRate, socialSecurityFixed) +
    getMonthlyHousingFund(income, housingFundMode, housingFundRate, housingFundFixed);
  return monthlyIncome - monthlyDeductions -
    getMonthlyTax(month, income, basicDeduction, socialSecurityMode, socialSecurityRate, socialSecurityFixed,
      housingFundMode, housingFundRate, housingFundFixed, deductions);
}

export function getTaxDue(
  income: string,
  basicDeduction: string,
  socialSecurityMode: string,
  socialSecurityRate: string,
  socialSecurityFixed: string,
  housingFundMode: string,
  housingFundRate: string,
  housingFundFixed: string,
  deductions: Map<string, TaxDeductionState>
): number {
  return getCumulativeTax(12, income, basicDeduction, socialSecurityMode, socialSecurityRate, socialSecurityFixed,
    housingFundMode, housingFundRate, housingFundFixed, deductions);
}

// 劳务报酬预扣预缴
// ≤800: 免税; 800~4000: (income-800)*20%; >4000: income*80% * rate
export function getMonthlyLaborTax(laborIncome: string): number {
  const income: number = parseNumber(laborIncome);
  if (income <= 800) {
    return 0;
  }
  let taxableIncome: number;
  if (income <= 4000) {
    taxableIncome = income - 800;
  } else {
    taxableIncome = income * 0.8;
  }
  // 三级税率
  if (taxableIncome <= 20000) {
    return taxableIncome * 0.2;
  }
  if (taxableIncome <= 50000) {
    return taxableIncome * 0.3 - 2000;
  }
  return taxableIncome * 0.4 - 7000;
}

export function getAnnualLaborTax(laborIncome: string): number {
  return getMonthlyLaborTax(laborIncome) * 12;
}

export function getAnnualLaborTaxFromAmounts(monthlyLaborAmounts: string[]): number {
  let total: number = 0;
  for (let i: number = 0; i < monthlyLaborAmounts.length; i++) {
    total += getMonthlyLaborTax(monthlyLaborAmounts[i]);
  }
  return total;
}

export function getAnnualLaborIncome(
  laborIncomeMode: LaborIncomeMode,
  monthlyLaborIncome: string,
  monthlyLaborAmounts: string[]
): number {
  if (laborIncomeMode === 'monthly') {
    let total: number = 0;
    for (let i: number = 0; i < monthlyLaborAmounts.length; i++) {
      total += parseNumber(monthlyLaborAmounts[i]);
    }
    return total;
  }
  if (laborIncomeMode === 'total') {
    return parseNumber(monthlyLaborIncome);
  }
  return parseNumber(monthlyLaborIncome) * 12;
}

export interface AnnualSettlementResult {
  totalTax: number;
  prepaidSalaryTax: number;
  prepaidLaborTax: number;
  settlement: number;
}

// 年度汇算清缴
export function getAnnualSettlement(
  salaryIncome: string,
  laborIncome: string,
  basicDeduction: string,
  socialSecurityMode: string,
  socialSecurityRate: string,
  socialSecurityFixed: string,
  housingFundMode: string,
  housingFundRate: string,
  housingFundFixed: string,
  deductions: Map<string, TaxDeductionState>,
  laborIncomeMode: LaborIncomeMode,
  monthlyLaborAmounts: string[]
): AnnualSettlementResult {
  const annualSalary: number = parseNumber(salaryIncome) * 12;
  const annualLabor: number = getAnnualLaborIncome(laborIncomeMode, laborIncome, monthlyLaborAmounts);
  const laborDeducted: number = annualLabor * 0.8;
  const comprehensiveIncome: number = annualSalary + laborDeducted;

  const annualBasicDeduction: number = parseNumber(basicDeduction) * 12;
  const annualSS: number = getAnnualSocialSecurityDeduction(salaryIncome, socialSecurityMode, socialSecurityRate, socialSecurityFixed);
  const annualHF: number = getAnnualHousingFundDeduction(salaryIncome, housingFundMode, housingFundRate, housingFundFixed);
  const annualSpecial: number = getAnnualSpecialDeduction(deductions);

  const taxableIncome: number = Math.max(0, comprehensiveIncome - annualBasicDeduction - annualSS - annualHF - annualSpecial);
  const totalTax: number = getTaxByTaxableIncome(taxableIncome);

  const prepaidSalaryTax: number = getTaxDue(salaryIncome, basicDeduction, socialSecurityMode, socialSecurityRate, socialSecurityFixed,
    housingFundMode, housingFundRate, housingFundFixed, deductions);
  const prepaidLaborTax: number = laborIncomeMode === 'monthly'
    ? getAnnualLaborTaxFromAmounts(monthlyLaborAmounts)
    : getAnnualLaborTax(laborIncome);

  return {
    totalTax: totalTax,
    prepaidSalaryTax: prepaidSalaryTax,
    prepaidLaborTax: prepaidLaborTax,
    settlement: totalTax - prepaidSalaryTax - prepaidLaborTax
  };
}
