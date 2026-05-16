import { formatDuration } from '../../common/Utils';

@Component
export struct StopwatchPanel {
  @Link stopwatchMs: number;
  @Link stopwatchRunning: boolean;
  @Link lapItems: string[];
  private timerId: number = -1;

  aboutToDisappear(): void {
    this.stopTimer();
  }

  private startTimer(): void {
    if (this.stopwatchRunning) {
      return;
    }
    this.stopwatchRunning = true;
    this.timerId = setInterval((): void => {
      this.stopwatchMs += 10;
    }, 10);
  }

  private stopTimer(): void {
    if (this.timerId >= 0) {
      clearInterval(this.timerId);
      this.timerId = -1;
    }
    this.stopwatchRunning = false;
  }

  private resetTimer(): void {
    this.stopTimer();
    this.stopwatchMs = 0;
    this.lapItems = [];
  }

  private addLap(): void {
    if (this.stopwatchMs <= 0) {
      return;
    }
    const nextItems: string[] = this.lapItems.slice();
    nextItems.unshift(formatDuration(this.stopwatchMs));
    this.lapItems = nextItems;
  }

  build() {
    Column() {
      Text('秒表')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .fontColor('#182326')
        .margin({ bottom: 12 })
      Text(formatDuration(this.stopwatchMs))
        .fontSize(42)
        .fontWeight(FontWeight.Bold)
        .fontColor('#102729')
        .width('100%')
        .textAlign(TextAlign.Center)
        .margin({ top: 20, bottom: 22 })
      Row() {
        Button(this.stopwatchRunning ? '暂停' : '开始')
          .height(42)
          .layoutWeight(1)
          .margin({ right: 5 })
          .backgroundColor('#147C78')
          .onClick((): void => {
            if (this.stopwatchRunning) {
              this.stopTimer();
            } else {
              this.startTimer();
            }
          })
        Button('计次')
          .height(42)
          .layoutWeight(1)
          .margin({ left: 5, right: 5 })
          .fontColor('#334247')
          .backgroundColor('#EEF4F3')
          .onClick((): void => {
            this.addLap();
          })
        Button('重置')
          .height(42)
          .layoutWeight(1)
          .margin({ left: 5 })
          .fontColor('#334247')
          .backgroundColor('#EEF4F3')
          .onClick((): void => {
            this.resetTimer();
          })
      }
      .width('100%')
      Column() {
        ForEach(this.lapItems, (item: string, index: number) => {
          Row() {
            Text(`计次 ${this.lapItems.length - index}`)
              .fontSize(14)
              .fontColor('#667579')
            Text(item)
              .fontSize(15)
              .fontWeight(FontWeight.Bold)
              .fontColor('#182326')
          }
          .justifyContent(FlexAlign.SpaceBetween)
          .width('100%')
          .padding({ top: 12, bottom: 12 })
          .border({ width: { bottom: 1 }, color: '#E4ECEB' })
        }, (item: string): string => item)
      }
      .width('100%')
      .margin({ top: 18 })
    }
    .width('100%')
  }
}
