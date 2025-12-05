import { BusinessError } from '@kit.BasicServicesKit';
import { Second } from './Second';
import { Third } from './Third';

export enum PageName{
  Second = "Second",
  Third = "Third"
}

function delayWithPromise(ms: number) {
  return new Promise<void>((resolve) => {
    setTimeout(resolve, ms);
  });
}

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';

  @Provide('navPathStack') navPathStack: NavPathStack = new NavPathStack()

  @Builder
  pageMap(name: string){
    if(name == PageName.Second){
      Second()
    }
    if(name == PageName.Third){
      Third()
    }
  }

  build() {
    Navigation(this.navPathStack){
      Row() {
        Column() {
          Text(this.message)
            .id('HelloWorld')
            .fontSize($r('app.float.page_text_font_size'))
            .fontWeight(FontWeight.Bold)
            .onClick(() => {
              this.message = 'Welcome';
            })
          Button(){
            Text('Button')
              .fontSize(30)
              .fontWeight(FontWeight.Bold)
          }
          .type(ButtonType.Capsule)
          .margin({ top: 20 })
          .backgroundColor('#0D9FFB')
          .width('40%')
          .height('5%')
          .onClick(async () => {
            this.navPathStack.pushPath({name : PageName.Second})
            await delayWithPromise(5000)
            console.debug("调试：延迟时间结束")
          })
        }.width('100%')
      }
      .height('100%')
      .width('100%')
    }
    .navDestination(this.pageMap)
  }
}