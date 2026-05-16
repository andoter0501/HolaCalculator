import { UnitDefinition } from './Types';

export function parseNumber(value: string): number {
  const normalized: string = value
    .normalize('NFKC')
    .replace(/,/g, '')
    .replace(/，/g, '')
    .replace(/。/g, '.')
    .replace(/\s+/g, '');
  const parsed: number = Number(normalized);
  if (Number.isFinite(parsed)) {
    return parsed;
  }
  return 0;
}

export function formatNumber(value: number, precision: number = 2): string {
  if (!Number.isFinite(value)) {
    return '0';
  }
  const fixed: string = value.toFixed(precision);
  return fixed.replace(/\.?0+$/, '');
}

export function formatMoney(value: number): string {
  if (!Number.isFinite(value)) {
    return '¥ 0.00';
  }
  return `¥ ${value.toFixed(2)}`;
}

export function formatDuration(ms: number): string {
  const totalCentiseconds: number = Math.floor(ms / 10);
  const centiseconds: number = totalCentiseconds % 100;
  const totalSeconds: number = Math.floor(totalCentiseconds / 100);
  const seconds: number = totalSeconds % 60;
  const totalMinutes: number = Math.floor(totalSeconds / 60);
  const minutes: number = totalMinutes % 60;
  const hours: number = Math.floor(totalMinutes / 60);
  return `${pad2(hours)}:${pad2(minutes)}:${pad2(seconds)}.${pad2(centiseconds)}`;
}

export function pad2(value: number): string {
  if (value < 10) {
    return `0${value}`;
  }
  return `${value}`;
}

export function clampUnitIndex(index: number, units: UnitDefinition[]): number {
  if (index < 0 || index >= units.length) {
    return 0;
  }
  return index;
}

export function findUnitIndexByName(units: UnitDefinition[], unitName: string): number {
  for (let index: number = 0; index < units.length; index++) {
    if (units[index].name === unitName) {
      return index;
    }
  }
  return 0;
}

export function findUnitByName(units: UnitDefinition[], unitName: string): UnitDefinition {
  const index: number = findUnitIndexByName(units, unitName);
  return units[index];
}
