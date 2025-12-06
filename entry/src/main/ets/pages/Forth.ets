import { JSON } from "@kit.ArkTS"

function processJson(jsonStr: string){
  let jsonObj: Object = JSON.parse(jsonStr)!!
  let responseCode: string = (jsonObj as object)?.['code']
  console.debug(`调试：响应码：${responseCode}`)
  let responseData: Object = (jsonObj as object)?.['data']
  console.debug(`调试：响应数据：${responseData}`)
  let responseName: string = (responseData as object)?.['simpleName']
  console.debug(`调试：响应名称：${responseName}`)
}


@Component
export struct Forth{

  jsonText: string = `{"code":"A00000","data":{"name":"2025/12/06 2025-2026学年度第1学期第12周","now":"2025年12月","schoolCalendar":{"beginDay":1757865600000,"classTimeId":2,"createdAt":null,"deleteFlag":null,"endDay":1772380799000,"examWeekEnd":18,"examWeekStart":17,"id":120,"noWeekendWorkTimes":null,"teachingWeekEnd":16,"teachingWeekStart":1,"term":1,"updatedAt":null,"weekBenginDay":2,"weekNum":24,"weekendWorkTimes":null,"workTimeGroupConfig":null,"year":2025,"zerothWeekDay":21},"simpleName":"2025-2026学年度第1学期","week":12},"msg":"操作成功"}`

  @State showText: string = '屏幕内容'
  @Consume('navPathStack') navPathStack: NavPathStack

  aboutToAppear(): void {
    console.debug(`调试：即将启动Forth`)
  }

  onDidBuild(): void {
    console.debug(`调试：Forth已经构建完成`)
  }

  build() {
    NavDestination(){
      Column(){
        Text(this.showText)
          .height('40%')
          .width('100%')
          .fontSize(20)
        Text('HelloWorld')
        Button(`Play`)
          .onAreaChange((_, newValue) => {
            console.debug(`调试：按钮区域改变\n${JSON.stringify(newValue)}`)
          })
          .onClick(() => {
            processJson(this.jsonText)
          })
      }
      .height('100%').width('100%')
    }
    .onBackPressed(() => {
      this.navPathStack.pop()
      return true
    })
  }
}