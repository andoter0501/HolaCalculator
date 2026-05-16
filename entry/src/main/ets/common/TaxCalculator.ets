import { TaxBracket, TaxDeductionState } from './Types';
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
