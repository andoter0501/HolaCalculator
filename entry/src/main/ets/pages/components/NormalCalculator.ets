import { CalculatorKey } from '../../common/Types';
import { parseNumber, formatNumber } from '../../common/Utils';
import { isOperator, evaluate } from '../../common/ExpressionEvaluator';

@Component
export struct NormalCalculator {
  @Link normalExpression: string;
  @Link normalDisplay: string;
  @Link normalJustEvaluated: boolean;

  private getNormalPreviewText(): string {
    if (this.normalExpression === '') {
      return '';
    }
    return this.normalExpression
      .replace(/\*/g, '×')
      .replace(/\//g, '÷');
  }

  private formatNormalResult(value: number): string {
    if (!Number.isFinite(value)) {
      return '错误';
    }
    return formatNumber(value, 10);
  }

  private trimTrailingOperator(expression: string): string {
    if (expression.length === 0) {
      return expression;
    }
    const lastChar: string = expression.charAt(expression.length - 1);
    if (isOperator(lastChar)) {
      return expression.substring(0, expression.length - 1);
    }
    return expression;
  }

  private getCurrentOperand(): string {
    for (let index: number = this.normalExpression.length - 1; index >= 0; index--) {
      const char: string = this.normalExpression.charAt(index);
      if (isOperator(char)) {
        if (char === '-' && index === 0) {
          return this.normalExpression;
        }
        return this.normalExpression.substring(index + 1);
      }
    }
    return this.normalExpression;
  }

  private refreshDisplay(): void {
    const currentOperand: string = this.getCurrentOperand();
    if (currentOperand === '') {
      this.normalDisplay = '0';
    } else {
      this.normalDisplay = currentOperand;
    }
  }

  private appendDigit(value: string): void {
    if (this.normalJustEvaluated || this.normalDisplay === '错误') {
      this.normalExpression = '';
      this.normalDisplay = '0';
      this.normalJustEvaluated = false;
    }
    const currentOperand: string = this.getCurrentOperand();
    if (currentOperand === '0') {
      this.normalExpression = this.normalExpression.substring(0, this.normalExpression.length - 1) + value;
    } else {
      this.normalExpression += value;
    }
    this.refreshDisplay();
  }

  private appendDecimal(): void {
    if (this.normalJustEvaluated || this.normalDisplay === '错误') {
      this.normalExpression = '';
      this.normalDisplay = '0';
      this.normalJustEvaluated = false;
    }
    const currentOperand: string = this.getCurrentOperand();
    if (currentOperand.indexOf('.') >= 0) {
      return;
    }
    if (currentOperand === '') {
      this.normalExpression += '0.';
    } else {
      this.normalExpression += '.';
    }
    this.refreshDisplay();
  }

  private appendOperator(operator: string): void {
    if (this.normalDisplay === '错误') {
      return;
    }
    if (this.normalExpression === '') {
      if (operator === '-') {
        this.normalExpression = '-';
        this.normalDisplay = '-';
      }
      return;
    }
    this.normalJustEvaluated = false;
    const lastChar: string = this.normalExpression.charAt(this.normalExpression.length - 1);
    if (isOperator(lastChar)) {
      this.normalExpression = this.normalExpression.substring(0, this.normalExpression.length - 1) + operator;
    } else {
      this.normalExpression += operator;
    }
    this.refreshDisplay();
  }

  private clearCalculator(): void {
    this.normalExpression = '';
    this.normalDisplay = '0';
    this.normalJustEvaluated = false;
  }

  private backspace(): void {
    if (this.normalJustEvaluated || this.normalDisplay === '错误') {
      this.clearCalculator();
      return;
    }
    if (this.normalExpression.length > 0) {
      this.normalExpression = this.normalExpression.substring(0, this.normalExpression.length - 1);
    }
    this.refreshDisplay();
  }

  private applyPercent(): void {
    if (this.normalExpression === '' || this.normalDisplay === '错误') {
      return;
    }
    const currentOperand: string = this.getCurrentOperand();
    if (currentOperand === '' || currentOperand === '-') {
      return;
    }
    const percentValue: string = this.formatNormalResult(parseNumber(currentOperand) / 100);
    this.normalExpression = this.normalExpression.substring(0, this.normalExpression.length - currentOperand.length) + percentValue;
    this.refreshDisplay();
  }

  private calculateResult(): void {
    const expression: string = this.trimTrailingOperator(this.normalExpression);
    if (expression === '' || expression === '-') {
      return;
    }
    const result: number = evaluate(expression);
    this.normalDisplay = this.formatNormalResult(result);
    if (Number.isFinite(result)) {
      this.normalExpression = this.normalDisplay;
      this.normalJustEvaluated = true;
    } else {
      this.normalExpression = '';
      this.normalJustEvaluated = false;
    }
  }

  @Builder
  CalcButton(label: string, textColor: string, backgroundColor: string, onClick: () => void) {
    Button(label)
      .height(54)
      .layoutWeight(1)
      .fontSize(28)
      .fontWeight(FontWeight.Medium)
      .fontColor(textColor)
      .backgroundColor(backgroundColor)
      .borderRadius(27)
      .margin({ left: 4, right: 4, top: 5, bottom: 5 })
      .shadow({
        radius: 8,
        color: 'rgba(30,47,50,0.08)',
        offsetX: 0,
        offsetY: 4
      })
      .onClick(onClick)
  }

  @Builder
  EqualButton() {
    Button('=')
      .height(118)
      .width(58)
      .fontSize(32)
      .fontWeight(FontWeight.Bold)
      .fontColor(Color.White)
      .backgroundColor('#1E4AA8')
      .borderRadius(29)
      .margin({ left: 4, right: 4, top: 5, bottom: 5 })
      .shadow({
        radius: 10,
        color: 'rgba(30,74,168,0.26)',
        offsetX: 0,
        offsetY: 5
      })
      .onClick((): void => {
        this.calculateResult();
      })
  }

  build() {
    Column() {
      Column() {
        Text(this.getNormalPreviewText())
          .height(24)
          .fontSize(18)
          .fontColor('#7C6F82')
          .textAlign(TextAlign.End)
          .width('100%')
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
        Text(this.normalDisplay)
          .height(62)
          .fontSize(42)
          .fontWeight(FontWeight.Bold)
          .fontColor('#17121D')
          .textAlign(TextAlign.End)
          .width('100%')
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      .width('100%')
      .padding({ left: 10, right: 10, top: 8, bottom: 8 })
      .margin({ bottom: 6 })

      Row() {
        this.CalcButton('C', '#1E4AA8', '#F5EFF8', (): void => {
          this.clearCalculator();
        })
        this.CalcButton('÷', '#1E4AA8', '#F5EFF8', (): void => {
          this.appendOperator('/');
        })
        this.CalcButton('×', '#1E4AA8', '#F5EFF8', (): void => {
          this.appendOperator('*');
        })
        this.CalcButton('⌫', '#1E4AA8', '#F5EFF8', (): void => {
          this.backspace();
        })
      }
      .width('100%')

      Row() {
        this.CalcButton('7', '#17121D', '#F8F1FA', (): void => {
          this.appendDigit('7');
        })
        this.CalcButton('8', '#17121D', '#F8F1FA', (): void => {
          this.appendDigit('8');
        })
        this.CalcButton('9', '#17121D', '#F8F1FA', (): void => {
          this.appendDigit('9');
        })
        this.CalcButton('-', '#1E4AA8', '#F5EFF8', (): void => {
          this.appendOperator('-');
        })
      }
      .width('100%')

      Row() {
        this.CalcButton('4', '#17121D', '#F8F1FA', (): void => {
          this.appendDigit('4');
        })
        this.CalcButton('5', '#17121D', '#F8F1FA', (): void => {
          this.appendDigit('5');
        })
        this.CalcButton('6', '#17121D', '#F8F1FA', (): void => {
          this.appendDigit('6');
        })
        this.CalcButton('+', '#1E4AA8', '#F5EFF8', (): void => {
          this.appendOperator('+');
        })
      }
      .width('100%')

      Row() {
        Column() {
          Row() {
            this.CalcButton('1', '#17121D', '#F8F1FA', (): void => {
              this.appendDigit('1');
            })
            this.CalcButton('2', '#17121D', '#F8F1FA', (): void => {
              this.appendDigit('2');
            })
            this.CalcButton('3', '#17121D', '#F8F1FA', (): void => {
              this.appendDigit('3');
            })
          }
          .width('100%')
          Row() {
            this.CalcButton('%', '#17121D', '#F8F1FA', (): void => {
              this.applyPercent();
            })
            this.CalcButton('0', '#17121D', '#F8F1FA', (): void => {
              this.appendDigit('0');
            })
            this.CalcButton('.', '#17121D', '#F8F1FA', (): void => {
              this.appendDecimal();
            })
          }
          .width('100%')
        }
        .layoutWeight(1)
        this.EqualButton()
      }
      .width('100%')
    }
    .width('100%')
    .height('100%')
    .padding({ left: 4, right: 4, bottom: 4 })
    .backgroundColor('#F8EAF8')
    .borderRadius(8)
  }
}
