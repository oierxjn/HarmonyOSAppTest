import { PageName } from "./Index";
import { Third } from "./Third";

class BasicDataSource implements IDataSource{
  listeners: DataChangeListener[] = [];
  originDataArray: string[] = [];
  list: number[] = [];

  constructor(list: number[]){
    this.list = list;
  }

  // public totalCount(): number {
  //   return this.originDataArray.length;
  // }
  //
  // public getData(index: number): string {
  //   return this.originDataArray[index];
  // }

  public totalCount(): number {
    return this.list.length;
  }
  public getData(index: number): number {
    return this.list[index];
  }

  public registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      console.info('add listener');
      this.listeners.push(listener);
    }
  }
  public unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener);
    if (pos >= 0) {
      console.info('remove listener');
      this.listeners.splice(pos, 1);
    }
  }

  public notifyDataChanged(): void {
    this.listeners.forEach((listener) => {
      listener.onDataReloaded()
    });
  }

  public notifyDataAdd(index: number): void{
    this.listeners.forEach((listener) => {
      listener.onDataAdd(index)
    })
  }

  public notifyDataChange(index: number): void{
    this.listeners.forEach((listener) => {
      listener.onDataChange(index)
    })
  }

  public notifyDataDelete(index: number): void{
    this.listeners.forEach((listener) => {
      listener.onDataDelete(index)
    })
  }

  public notifyDataMove(fromIndex: number, toIndex: number): void{
    this.listeners.forEach((listener) => {
      listener.onDataMove(fromIndex, toIndex)
    })
  }

  public notifyDatasetChange(operations: DataOperation[]): void{
    this.listeners.forEach((listener) => {
      listener.onDatasetChange(operations)
    })
  }
}

function fetchData(): Promise<string> {
  return new Promise((resolve) => {
    setTimeout(() => {
      resolve("Data fetched successfully!");
    }, 3000);
  });
}

@Component
export struct Second {
  @State message: string = 'Hi there';

  @State testCount1: number = 0;

  @Consume('navPathStack') navPathStack: NavPathStack
  arr: BasicDataSource = new BasicDataSource([1,2,3,4,5,6,7,8,9,10]);

  build() {
    NavDestination(){
      List({space: 20}){
        ListItem(){
          Row(){
            Text('Hello')
              .height('100%').fontSize(30)
              .textAlign(TextAlign.Center).borderRadius(3)
              .backgroundColor('#100D9FFB')
            Column(){
              Button('Next')
                .fontSize(25)
                .width('80%')
                .margin({top: 20})
                .onClick(() =>{
                  this.navPathStack.pushPath({name: PageName.Third})
                })
              Button(this.testCount1.toString())
                .fontSize(25)
                .width('80%')
                .margin({top: 20})
                .onClick(() => {
                  this.testCount1++;
                  this.getUIContext().showAlertDialog({
                    title: '警告弹窗',
                    message: 'cnt++cnt++cnt++cnt++cnt++cnt++cnt++cnt++cnt++cnt++cnt++cnt++cnt++cnt++cnt++cnt++cnt++cnt++cnt++cnt++cnt++cnt++cnt++cnt++cnt++',
                    confirm: {
                      value: '确认',
                      action: () => {}
                    }
                  })
                })
            }
            .width('40%')
          }
        }
        .width('100%').height('20%')
        LazyForEach(this.arr, (item: number) => {
          ListItem(){
            Text(item + '')
              .width('100%').height(100).fontSize(16)
              .textAlign(TextAlign.Center).borderRadius(10).backgroundColor('#0D9FFB')
          }
        })
      }
      .width('90%').height('100%')
      .listDirection(Axis.Vertical)
      .scrollBar(BarState.Auto)
      .friction(0.6)
    }
    .hideBackButton(true)
    .onBackPressed(() => {
      this.navPathStack.pop();
      return true;
    })
    .onVisibleAreaChange([0.0, 1.0], async (isExpand, radio) => {
      if (isExpand) {
        const testResult = await fetchData()
        console.debug(`调试得到结果：${testResult}`)
        console.debug("调试可见区域展开")
      }
    })
  }
}