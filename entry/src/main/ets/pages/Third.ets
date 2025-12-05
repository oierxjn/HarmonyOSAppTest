import { http } from "@kit.NetworkKit"
import url from "@ohos.url"


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
            .onClick(async () => {
              let httpRequest = http.createHttp();
              try {
                let response = await httpRequest.request(this.textContent)
                console.debug('调试：请求成功')
                this.responseText = `状态码：${response.responseCode}\n结果：${response.result}\n}`
                return
              } catch (e){
                console.debug('调试：${e}')
                return
              } finally {
                httpRequest.destroy()
                console.debug('调试：销毁成功')
              }
            })
          Text(this.textContent)
            .fontSize(26)
          Text()
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