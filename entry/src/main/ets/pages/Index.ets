import { BusinessError } from '@kit.BasicServicesKit';
import { Second } from './Second';

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';

  @Provide('navPathStack') navPathStack: NavPathStack = new NavPathStack()

  @Builder
  pageMap(name: string){
    if(name == 'HomePage'){
      Second()
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
          .onClick(() => {
            this.navPathStack.pushPath({name : 'HomePage'})
          })
        }.width('100%')
      }
      .height('100%')
      .width('100%')
    }
    .navDestination(this.pageMap)
  }
}