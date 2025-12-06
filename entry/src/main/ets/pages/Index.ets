import { BusinessError } from '@kit.BasicServicesKit';
import { Forth } from './Forth';
import { Second } from './Second';
import { Third } from './Third';

export enum PageName{
  Second = "Second",
  Third = "Third",
  Forth = "Forth",
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
    }else if(name == PageName.Third){
      Forth()
    }else if(name == PageName.Forth){
      Forth()
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
          })
        }.width('100%')
      }
      .height('100%')
      .width('100%')
    }
    .navDestination(this.pageMap)
  }
}