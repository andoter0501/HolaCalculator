import { parseNumber } from './Utils';

export function isOperator(value: string): boolean {
  return value === '+' || value === '-' || value === '*' || value === '/';
}

export function getPrecedence(operator: string): number {
  if (operator === '*' || operator === '/') {
    return 2;
  }
  if (operator === '+' || operator === '-') {
    return 1;
  }
  return 0;
}

export function applyOperator(left: number, right: number, operator: string): number {
  if (operator === '+') {
    return left + right;
  }
  if (operator === '-') {
    return left - right;
  }
  if (operator === '*') {
    return left * right;
  }
  if (operator === '/') {
    return left / right;
  }
  return right;
}

export function tokenize(expression: string): string[] {
  const tokens: string[] = [];
  let current: string = '';
  for (let index: number = 0; index < expression.length; index++) {
    const char: string = expression.charAt(index);
    if (isOperator(char)) {
      if (char === '-' && (index === 0 || isOperator(expression.charAt(index - 1)))) {
        current += char;
      } else {
        if (current !== '') {
          tokens.push(current);
          current = '';
        }
        tokens.push(char);
      }
    } else {
      current += char;
    }
  }
  if (current !== '') {
    tokens.push(current);
  }
  return tokens;
}

export function evaluate(expression: string): number {
  const tokens: string[] = tokenize(expression);
  const values: number[] = [];
  const operators: string[] = [];
  for (let index: number = 0; index < tokens.length; index++) {
    const token: string = tokens[index];
    if (isOperator(token)) {
      while (operators.length > 0 &&
        getPrecedence(operators[operators.length - 1]) >= getPrecedence(token)) {
        const rightValue: number | undefined = values.pop();
        const leftValue: number | undefined = values.pop();
        const operator: string | undefined = operators.pop();
        if (rightValue === undefined || leftValue === undefined || operator === undefined) {
          return Number.NaN;
        }
        values.push(applyOperator(leftValue, rightValue, operator));
      }
      operators.push(token);
    } else {
      const parsed: number = parseNumber(token);
      if (!Number.isFinite(parsed)) {
        return Number.NaN;
      }
      values.push(parsed);
    }
  }
  while (operators.length > 0) {
    const rightValue: number | undefined = values.pop();
    const leftValue: number | undefined = values.pop();
    const operator: string | undefined = operators.pop();
    if (rightValue === undefined || leftValue === undefined || operator === undefined) {
      return Number.NaN;
    }
    values.push(applyOperator(leftValue, rightValue, operator));
  }
  if (values.length !== 1) {
    return Number.NaN;
  }
  return values[0];
}
