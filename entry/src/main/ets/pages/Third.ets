import { http } from "@kit.NetworkKit"


@Component
export struct Third{
  @Consume('navPathStack') navPathStack: NavPathStack

  @State responseText: string = '响应内容'
  @State textContent: string = ''

  build() {
    NavDestination(){
      Row(){
        Column(){
          Text('Third')
            .fontSize(32)
          TextInput({text: 'https://'})
            .onChange((text) => {
              this.textContent = text
            })
          Button('Fetch')
            .fontSize(25)
            .width('60%')
            .onClick(() => {
              let httpRequest = http.createHttp();
              httpRequest.request(this.textContent, (err: BusinessError, httpResponse: http.HttpResponse) => {
                if(!err){
                  console.debug('URL请求成功')
                  this.responseText = `状态码：${httpResponse.responseCode}\n结果：${httpResponse.result}\n}`
                }else{
                  console.debug('URL请求失败')
                  this.responseText = `错误码：${err.code}\n消息：${err.message}\n数据：${err.data}`
                }
                httpRequest.destroy()
              })
            })
          Text(this.textContent)
            .fontSize(26)
          Divider()
            .margin({top: '2%', bottom: '2%'})
          List(){
            ListItem(){
              Text(this.responseText)
                .fontSize(28)
            }
          }
          .height('50%').width('100%')
        }
        .height('100%').width('100%')
        .alignItems(HorizontalAlign.Center)
      }
      .height('100%').width('100%')
      .alignItems(VerticalAlign.Center)
    }
    .onBackPressed(() => {
      this.navPathStack.pop()
      return true
    })
  }
}