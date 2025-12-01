@Component
export struct Second {
  @State message: string = 'Hi there';

  @Consume('navPathStack') navPathStack: NavPathStack

  build() {
    NavDestination(){
      Row(){
        Column(){
          Text(this.message)
            .fontSize(50)
            .fontWeight(FontWeight.Bold)
          Button(){
            Text('Back')
              .fontSize(30)
              .fontWeight(FontWeight.Bold)
          }
          .type(ButtonType.Capsule)
          .margin({top: 20})
          .backgroundColor('#0D9FFB')
          .width('40%')
          .height('5%')
          .onClick(() => {
            this.navPathStack.pop()
          })
        }.width('100%')
      }.height('100%')

    }
    .hideBackButton(true)
    .onBackPressed(() => {
      this.navPathStack.pop();
      return true;
    })
  }
}