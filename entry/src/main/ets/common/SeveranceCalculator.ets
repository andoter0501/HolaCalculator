import { SeveranceType } from './Types';

export interface SeveranceResult {
  years: number;
  baseMonthlySalary: number;
  annualBonus: number;
  avgMonthlySalary: number;
  cappedSalary: number;
  effectiveYears: number;
  isCapped: boolean;
  severance: number;
  noticePay: number;
  total: number;
}

export function calculateSeverance(
  severanceType: SeveranceType,
  years: number,
  baseMonthlySalary: number,
  annualBonus: number,
  localAvgSalary: number,
  customMultiplier: number = 0
): SeveranceResult {
  const avgMonthlySalary: number = (baseMonthlySalary * 12 + annualBonus) / 12;
  const hasCap: boolean = localAvgSalary > 0;
  const capSalary: number = hasCap ? localAvgSalary * 3 : 0;
  const isCapped: boolean = hasCap && avgMonthlySalary > capSalary;
  const effectiveSalary: number = isCapped ? capSalary : avgMonthlySalary;
  const effectiveYears: number = isCapped ? Math.min(years, 12) : years;

  let severance: number = 0;
  let noticePay: number = 0;

  if (severanceType === 'n') {
    severance = effectiveYears * effectiveSalary;
  } else if (severanceType === 'n1') {
    severance = effectiveYears * effectiveSalary;
    noticePay = avgMonthlySalary;
  } else if (severanceType === 'n2') {
    severance = 2 * effectiveYears * effectiveSalary;
  } else {
    severance = customMultiplier * effectiveYears * effectiveSalary;
  }

  return {
    years: years,
    baseMonthlySalary: baseMonthlySalary,
    annualBonus: annualBonus,
    avgMonthlySalary: avgMonthlySalary,
    cappedSalary: isCapped ? capSalary : 0,
    effectiveYears: effectiveYears,
    isCapped: isCapped,
    severance: severance,
    noticePay: noticePay,
    total: severance + noticePay
  };
}
