import { CalculatorKey, ConverterConfig, UnitDefinition } from '../../common/Types';
import { CONVERTER_CONFIGS } from '../../common/Constants';
import { findUnitByName, formatNumber, parseNumber } from '../../common/Utils';

@Component
export struct ConverterPanel {
  @Link converterKey: CalculatorKey;
  @Link fromUnitName: string;
  @Link toUnitName: string;
  @Link fromIndex: number;
  @Link toIndex: number;
  @Link converterValues: Map<string, string>;
  onOpenFromPicker: () => void = (): void => {};
  onOpenToPicker: () => void = (): void => {};

  private getConverterConfig(): ConverterConfig {
    return CONVERTER_CONFIGS.get(this.converterKey) as ConverterConfig;
  }

  private getConverterInputValue(): string {
    return this.converterValues.get(this.converterKey) ?? '';
  }

  private setConverterInputValue(value: string): void {
    const next: Map<string, string> = new Map(this.converterValues);
    next.set(this.converterKey, value);
    this.converterValues = next;
  }

  private getConversionValue(): number {
    const config: ConverterConfig = this.getConverterConfig();
    const fromUnit: UnitDefinition = findUnitByName(config.units, this.fromUnitName);
    const toUnit: UnitDefinition = findUnitByName(config.units, this.toUnitName);
    const input: number = parseNumber(this.getConverterInputValue());
    return input * fromUnit.factor / toUnit.factor;
  }

  private getCurrentConversionResultValue(): string {
    if (this.getConverterInputValue().trim() === '') {
      return '';
    }
    const config: ConverterConfig = this.getConverterConfig();
    return formatNumber(this.getConversionValue(), config.precision);
  }

  private getCurrentConversionResultUnit(): string {
    return this.toUnitName;
  }

  private swapUnits(): void {
    const nextFromName: string = this.toUnitName;
    const nextToName: string = this.fromUnitName;
    const nextFromIndex: number = this.toIndex;
    const nextToIndex: number = this.fromIndex;
    this.fromUnitName = nextFromName;
    this.toUnitName = nextToName;
    this.fromIndex = nextFromIndex;
    this.toIndex = nextToIndex;
  }

  @Builder
  InputRow() {
    Column() {
      Text('金额')
        .fontSize(13)
        .fontWeight(FontWeight.Bold)
        .fontColor('#415155')
        .margin({ bottom: 8 })
      Row() {
        TextInput({ text: this.getConverterInputValue(), placeholder: this.getConverterConfig().valuePlaceholder })
          .layoutWeight(1)
          .height(64)
          .fontSize(30)
          .fontWeight(FontWeight.Bold)
          .fontColor('#111111')
          .backgroundColor('rgba(0,0,0,0)')
          .padding({ left: 0, right: 6 })
          .type(InputType.NUMBER_DECIMAL)
          .onChange((nextValue: string): void => {
            this.setConverterInputValue(nextValue);
          })
        Row() {
          Text(this.fromUnitName)
            .fontSize(22)
            .fontWeight(FontWeight.Medium)
            .fontColor('#4A4A4A')
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
          Text('▾')
            .fontSize(16)
            .fontColor('#858585')
            .margin({ left: 5, top: 2 })
        }
        .height(48)
        .padding({ left: 10, right: 8 })
        .backgroundColor('#F0F0F0')
        .borderRadius(10)
        .onClick((): void => {
          this.onOpenFromPicker();
        })
      }
      .width('100%')
      .height(78)
      .padding({ left: 14, right: 14 })
      .borderRadius(16)
      .border({ width: 1.5, color: '#8F8F8F' })
      .backgroundColor('#F7F7F7')
    }
    .width('100%')
  }

  @Builder
  ResultRow() {
    Column() {
      Text('换算为')
        .fontSize(13)
        .fontWeight(FontWeight.Bold)
        .fontColor('#415155')
        .margin({ bottom: 8 })
      Row() {
        Text(this.getCurrentConversionResultValue())
          .layoutWeight(1)
          .height(64)
          .fontSize(30)
          .fontWeight(FontWeight.Bold)
          .fontColor('#111111')
          .textAlign(TextAlign.Start)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
          .padding({ right: 6 })
        Row() {
          Text(this.getCurrentConversionResultUnit())
            .fontSize(22)
            .fontWeight(FontWeight.Medium)
            .fontColor('#4A4A4A')
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
          Text('▾')
            .fontSize(16)
            .fontColor('#858585')
            .margin({ left: 5, top: 2 })
        }
        .height(48)
        .padding({ left: 10, right: 8 })
        .backgroundColor('#F0F0F0')
        .borderRadius(10)
        .onClick((): void => {
          this.onOpenToPicker();
        })
      }
      .width('100%')
      .height(78)
      .padding({ left: 14, right: 14 })
      .borderRadius(16)
      .border({ width: 1.5, color: '#8F8F8F' })
      .backgroundColor('#F7F7F7')
    }
    .width('100%')
  }

  build() {
    Column() {
      Text(this.getConverterConfig().title)
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .fontColor('#182326')
        .margin({ bottom: 12 })
      Text(this.getConverterConfig().desc)
        .fontSize(14)
        .fontColor('#667579')
        .lineHeight(21)
        .margin({ bottom: 14 })
      this.InputRow()

      Button('⇅')
        .width(54)
        .height(54)
        .fontSize(28)
        .fontWeight(FontWeight.Bold)
        .fontColor('#111111')
        .backgroundColor('#96E25E')
        .borderRadius(27)
        .margin({ top: 14, bottom: 14 })
        .onClick((): void => {
          this.swapUnits();
        })

      this.ResultRow()
    }
    .width('100%')
  }
}
