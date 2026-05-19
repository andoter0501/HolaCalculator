import { CalculatorKey, ConverterConfig, UnitDefinition } from '../../common/Types';
import { CONVERTER_CONFIGS } from '../../common/Constants';
import { findUnitByName, formatNumber, parseNumber } from '../../common/Utils';
import {
  COLOR_PRIMARY,
  COLOR_PRIMARY_SOFT,
  COLOR_TEXT_PRIMARY,
  COLOR_TEXT_MUTED,
  COLOR_TEXT_BODY,
  COLOR_SURFACE_3,
  COLOR_SURFACE_2,
  COLOR_LINE,
  RADIUS_MD
} from '../../common/DesignTokens';

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
        .fontColor(COLOR_TEXT_BODY)
        .margin({ bottom: 8 })
      Row() {
        TextInput({ text: this.getConverterInputValue(), placeholder: this.getConverterConfig().valuePlaceholder })
          .layoutWeight(1)
          .height(64)
          .fontSize(30)
          .fontWeight(FontWeight.Bold)
          .fontColor(COLOR_TEXT_PRIMARY)
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
          .fontColor(COLOR_TEXT_BODY)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          Text('▾')
            .fontSize(16)
            .fontColor(COLOR_TEXT_MUTED)
            .margin({ left: 5, top: 2 })
        }
        .height(48)
        .padding({ left: 10, right: 8 })
        .backgroundColor(COLOR_SURFACE_2)
        .borderRadius(10)
        .onClick((): void => {
          this.onOpenFromPicker();
        })
      }
      .width('100%')
      .height(78)
      .padding({ left: 14, right: 14 })
      .borderRadius(RADIUS_MD)
      .border({ width: 1.5, color: COLOR_LINE })
      .backgroundColor(COLOR_SURFACE_3)
    }
    .width('100%')
  }

  @Builder
  ResultRow() {
    Column() {
      Text('换算为')
        .fontSize(13)
        .fontWeight(FontWeight.Bold)
        .fontColor(COLOR_TEXT_BODY)
        .margin({ bottom: 8 })
      Row() {
        Text(this.getCurrentConversionResultValue())
          .layoutWeight(1)
          .height(64)
          .fontSize(30)
          .fontWeight(FontWeight.Bold)
          .fontColor(COLOR_TEXT_PRIMARY)
          .textAlign(TextAlign.Start)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
          .padding({ right: 6 })
        Row() {
          Text(this.getCurrentConversionResultUnit())
            .fontSize(22)
            .fontWeight(FontWeight.Medium)
            .fontColor(COLOR_TEXT_BODY)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
          Text('▾')
            .fontSize(16)
            .fontColor(COLOR_TEXT_MUTED)
            .margin({ left: 5, top: 2 })
        }
        .height(48)
        .padding({ left: 10, right: 8 })
        .backgroundColor(COLOR_SURFACE_2)
        .borderRadius(10)
        .onClick((): void => {
          this.onOpenToPicker();
        })
      }
      .width('100%')
      .height(78)
      .padding({ left: 14, right: 14 })
      .borderRadius(RADIUS_MD)
      .border({ width: 1.5, color: COLOR_LINE })
      .backgroundColor(COLOR_SURFACE_3)
    }
    .width('100%')
  }

  build() {
    Column() {
      Text(this.getConverterConfig().title)
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .fontColor(COLOR_TEXT_PRIMARY)
        .margin({ bottom: 12 })
      Text(this.getConverterConfig().desc)
        .fontSize(14)
        .fontColor(COLOR_TEXT_MUTED)
        .lineHeight(21)
        .margin({ bottom: 14 })
      this.InputRow()

      Button('⇅')
        .width(54)
        .height(54)
        .fontSize(28)
        .fontWeight(FontWeight.Bold)
        .fontColor(COLOR_PRIMARY)
        .backgroundColor(COLOR_PRIMARY_SOFT)
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
