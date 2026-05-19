import { SeveranceType } from './Types';

export interface SeveranceResult {
  years: number;
  monthlySalary: number;
  cappedSalary: number;
  effectiveYears: number;
  isCapped: boolean;
  severance: number;
  noticePay: number;
  bonus: number;
  total: number;
}

export function calculateSeverance(
  severanceType: SeveranceType,
  years: number,
  monthlySalary: number,
  bonus: number,
  localAvgSalary: number
): SeveranceResult {
  const hasCap: boolean = localAvgSalary > 0;
  const capSalary: number = hasCap ? localAvgSalary * 3 : 0;
  const isCapped: boolean = hasCap && monthlySalary > capSalary;
  const effectiveSalary: number = isCapped ? capSalary : monthlySalary;
  const effectiveYears: number = isCapped ? Math.min(years, 12) : years;

  let severance: number = 0;
  let noticePay: number = 0;

  if (severanceType === 'n') {
    severance = effectiveYears * effectiveSalary;
  } else if (severanceType === 'n1') {
    severance = effectiveYears * effectiveSalary;
    noticePay = monthlySalary;
  } else {
    severance = 2 * effectiveYears * effectiveSalary;
  }

  return {
    years: years,
    monthlySalary: monthlySalary,
    cappedSalary: isCapped ? capSalary : 0,
    effectiveYears: effectiveYears,
    isCapped: isCapped,
    severance: severance,
    noticePay: noticePay,
    bonus: bonus,
    total: severance + noticePay + bonus
  };
}
