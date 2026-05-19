import { CalculatorCategory, CalculatorKey } from '../../common/Types';
import { CATEGORIES } from '../../common/Constants';
import { COLOR_PRIMARY, COLOR_TEXT_MUTED, COLOR_SURFACE } from '../../common/DesignTokens';

@Component
export struct CategoryTabs {
  @Link activeKey: CalculatorKey;
  @Link categoryItems: CalculatorCategory[];
  @Link showCategoryEditor: boolean;
  onCategorySelect: (key: CalculatorKey) => void = (): void => {};

  private getTopCategoryItems(): CalculatorCategory[] {
    return this.categoryItems.slice(0, 5);
  }

  private getBottomCategoryItems(): CalculatorCategory[] {
    return this.categoryItems.slice(5);
  }

  @Builder
  CategoryMenuItem(item: CalculatorCategory) {
    Column() {
      Text(item.icon)
        .fontSize(22)
        .textAlign(TextAlign.Center)
        .width(51)
        .height(51)
        .borderRadius(16)
        .backgroundColor(Color.White)
        .border({ width: 1, color: this.activeKey === item.key ? COLOR_PRIMARY : COLOR_SURFACE })
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
            if (this.getBottomCategoryItems().length < 5) {
              ForEach([0], (index: number) => {
                Blank()
                  .width(72)
                  .height(78)
              }, (index: number): string => `${index}`)
            }
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
