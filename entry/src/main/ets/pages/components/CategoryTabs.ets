import { CalculatorCategory, CalculatorKey } from '../../common/Types';
import { CATEGORIES } from '../../common/Constants';
import { COLOR_PRIMARY, COLOR_TEXT_MUTED, COLOR_SURFACE, COLOR_LINE_LIGHT, RADIUS_MD } from '../../common/DesignTokens';

@Component
export struct CategoryTabs {
  @Link activeKey: CalculatorKey;
  @Link categoryItems: CalculatorCategory[];
  @Link showCategoryEditor: boolean;
  onCategorySelect: (key: CalculatorKey) => void = (): void => {};

  private cols: number = 0;

  private getTopCategoryItems(): CalculatorCategory[] {
    this.cols = Math.ceil(this.categoryItems.length / 2);
    return this.categoryItems.slice(0, this.cols);
  }

  private getBottomCategoryItems(): CalculatorCategory[] {
    this.cols = Math.ceil(this.categoryItems.length / 2);
    return this.categoryItems.slice(this.cols);
  }

  private getBlankCount(): number {
    return this.cols - this.getBottomCategoryItems().length;
  }

  @Builder
  CategoryMenuItem(item: CalculatorCategory) {
    Column() {
      Text(item.icon)
        .fontSize(22)
        .textAlign(TextAlign.Center)
        .width(51)
        .height(51)
        .borderRadius(RADIUS_MD)
        .backgroundColor(COLOR_SURFACE)
        .border({ width: 1, color: this.activeKey === item.key ? COLOR_PRIMARY : COLOR_LINE_LIGHT })
        .shadow({
          radius: this.activeKey === item.key ? 10 : 7,
          color: this.activeKey === item.key ? 'rgba(20,124,120,0.20)' : 'rgba(30,47,50,0.06)',
          offsetX: 0,
          offsetY: 4
        })
      Text(item.title)
        .fontSize(13)
        .fontWeight(FontWeight.Bold)
        .fontColor(this.activeKey === item.key ? COLOR_PRIMARY : COLOR_TEXT_MUTED)
        .textAlign(TextAlign.Center)
        .width('100%')
        .margin({ top: 6 })
    }
    .width(72)
    .height(78)
    .alignItems(HorizontalAlign.Center)
    .onClick((): void => {
      if (item.key === 'editor') {
        this.showCategoryEditor = true;
      } else {
        this.onCategorySelect(item.key as CalculatorKey);
      }
    })
  }

  build() {
    Row() {
      Scroll() {
        Column({ space: 8 }) {
          Row({ space: 10 }) {
            ForEach(this.getTopCategoryItems(), (item: CalculatorCategory) => {
              this.CategoryMenuItem(item)
            }, (item: CalculatorCategory): string => item.key)
          }
          Row({ space: 10 }) {
            ForEach(this.getBottomCategoryItems(), (item: CalculatorCategory) => {
              this.CategoryMenuItem(item)
            }, (item: CalculatorCategory): string => item.key)
            ForEach(Array(this.getBlankCount()).fill(0), (_: number, index: number) => {
              Blank()
                .width(72)
                .height(78)
            }, (_: number, index: number): string => `blank-${index}`)
          }
        }
        .padding({ left: 18, right: 10, top: 4, bottom: 6 })
      }
      .scrollable(ScrollDirection.Horizontal)
      .scrollBar(BarState.Off)
      .layoutWeight(1)
    }
    .width('100%')
    .height(172)
    .alignItems(VerticalAlign.Top)
  }
}
