import { MortgagePartResult } from './Types';
import { parseNumber } from './Utils';

export function getPartMonthlyRate(rate: string): number {
  return parseNumber(rate) / 100 / 12;
}

export function getPartPrincipal(amountWan: string): number {
  return Math.max(0, parseNumber(amountWan) * 10000);
}

export function getPartMonths(years: string): number {
  return Math.max(1, Math.round(parseNumber(years) * 12));
}

export function calculatePart(
  amountWan: string,
  years: string,
  annualRate: string,
  repaymentType: string
): MortgagePartResult {
  const principal: number = getPartPrincipal(amountWan);
  const months: number = getPartMonths(years);
  const monthlyRate: number = getPartMonthlyRate(annualRate);
  if (principal <= 0) {
    return {
      principal: 0,
      months: 0,
      monthlyPayment: 0,
      firstMonthPayment: 0,
      lastMonthPayment: 0,
      totalPayment: 0,
      totalInterest: 0
    };
  }
  let monthlyPayment: number;
  if (monthlyRate <= 0) {
    monthlyPayment = principal / months;
  } else {
    const power: number = Math.pow(1 + monthlyRate, months);
    monthlyPayment = principal * monthlyRate * power / (power - 1);
  }
  const firstMonthPayment: number = principal / months + principal * monthlyRate;
  const lastMonthPayment: number = principal / months + principal / months * monthlyRate;
  let totalPayment: number;
  if (repaymentType === 'interest') {
    totalPayment = monthlyPayment * months;
  } else {
    totalPayment = principal + principal * monthlyRate * (months + 1) / 2;
  }
  return {
    principal: principal,
    months: months,
    monthlyPayment: monthlyPayment,
    firstMonthPayment: firstMonthPayment,
    lastMonthPayment: lastMonthPayment,
    totalPayment: totalPayment,
    totalInterest: totalPayment - principal
  };
}

export function getActiveMortgageParts(
  loanType: string,
  commercialAmount: string,
  commercialYears: string,
  commercialRate: string,
  fundAmount: string,
  fundYears: string,
  fundRate: string,
  repaymentType: string
): MortgagePartResult[] {
  const results: MortgagePartResult[] = [];
  if (loanType === 'commercial' || loanType === 'mixed') {
    const commercialPart: MortgagePartResult = calculatePart(commercialAmount, commercialYears, commercialRate, repaymentType);
    if (commercialPart.principal > 0) {
      results.push(commercialPart);
    }
  }
  if (loanType === 'fund' || loanType === 'mixed') {
    const fundPart: MortgagePartResult = calculatePart(fundAmount, fundYears, fundRate, repaymentType);
    if (fundPart.principal > 0) {
      results.push(fundPart);
    }
  }
  return results;
}

export function getMortgageMainPayment(parts: MortgagePartResult[], repaymentType: string): number {
  let total: number = 0;
  for (let index: number = 0; index < parts.length; index++) {
    if (repaymentType === 'interest') {
      total += parts[index].monthlyPayment;
    } else {
      total += parts[index].firstMonthPayment;
    }
  }
  return total;
}

export function getMortgageLastMonthPayment(parts: MortgagePartResult[]): number {
  let total: number = 0;
  for (let index: number = 0; index < parts.length; index++) {
    total += parts[index].lastMonthPayment;
  }
  return total;
}

export function getMortgageTotalPayment(parts: MortgagePartResult[]): number {
  let total: number = 0;
  for (let index: number = 0; index < parts.length; index++) {
    total += parts[index].totalPayment;
  }
  return total;
}

export function getMortgageTotalInterest(parts: MortgagePartResult[]): number {
  let total: number = 0;
  for (let index: number = 0; index < parts.length; index++) {
    total += parts[index].totalInterest;
  }
  return total;
}

export function getMortgageMaxMonths(parts: MortgagePartResult[]): number {
  let maxMonths: number = 0;
  for (let index: number = 0; index < parts.length; index++) {
    if (parts[index].months > maxMonths) {
      maxMonths = parts[index].months;
    }
  }
  return maxMonths;
}
