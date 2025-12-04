import { kvManager } from "../func/DataUtils";
import { PageName } from "./Index";
import { Third } from "./Third";
import { distributedKVStore } from "@kit.ArkData";

export function buildAlertDialogParams(
  message: string | Error | null,
  title: string = '错误',
  tipText: string = '你可以选择截图并联系开发人员'
): AlertDialogParam {
  let result: AlertDialogParamWithConfirm = {
    title: title,
    message: `${message}\n`+tipText,
    confirm: {
      value: '确认',
      action: () => {}
    }
  }
  return result
}

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

const testCountKey: string = 'test_count_key';

let testKVStore: distributedKVStore.SingleKVStore | undefined;

@Component
export struct Second {
  @State message: string = (new Date()).toLocaleString();

  @State testCount1: number = 0;

  @Consume('navPathStack') navPathStack: NavPathStack
  arr: BasicDataSource = new BasicDataSource([1,2,3,4,5,6,7,8,9,10]);

  async aboutToAppear(): Promise<void> {
    console.debug(`即将初始化数据库`)
    try {
      testKVStore = await kvManager!!.getKVStore<distributedKVStore.SingleKVStore>('testStore1', {
        securityLevel: distributedKVStore.SecurityLevel.S1
      })
      console.debug(`创建/获取数据库实例成功`)
      try {
        let valueTask = testKVStore!!.get(testCountKey)
        let value = await valueTask
        this.testCount1 = value as number
        if(value == undefined) {
          throw new Error('键值为空')
        }
        console.debug(`获取数据成功：${value}`)
      } catch (error) {
        console.error(`获取数据失败：${error}`)
      }
    } catch (error) {
      console.error(`创建/获取数据库实例失败：${error}`)
    }
    console.debug(`键值对获取部分完成`)
  }
  build() {
    NavDestination(){
      List({space: 20}){
        ListItem(){
          Row(){
            Column(){
              Text('删除数据库')
                .fontSize(30)
                .textAlign(TextAlign.Center).borderRadius(3)
                .backgroundColor('#100D9FFB')
                .onClick(async () => {
                  try {
                    await testKVStore?.delete(testCountKey)
                    console.debug(`删除数据成功`)
                  } catch (e){
                    console.error(`删除数据失败：${e}`)
                  }
                })
              Text(this.message)
                .fontSize(20)
                .width('100%')
                .textAlign(TextAlign.Center).borderRadius(3)
                .backgroundColor('#100D9FFB')
            }.width('60%')
            Column(){
              Button('Next')
                .fontSize(25)
                .width('100%')
                .margin({top: 20})
                .onClick(() =>{
                  this.navPathStack.pushPath({name: PageName.Third})
                })
              Button(this.testCount1.toString())
                .fontSize(25)
                .width('100%')
                .margin({top: 20})
                .onClick(async () => {
                  this.testCount1 =Date.now();
                  this.message = (new Date(this.testCount1)).toLocaleString()
                  this.getUIContext().showAlertDialog(
                    buildAlertDialogParams(this.testCount1.toString(), 'Test')
                  )
                  try {
                    if (testKVStore == null) {
                      throw new Error('数据库实例为空')
                    }
                    await testKVStore?.put(testCountKey, this.testCount1)
                    console.debug(`存储数据成功：${this.testCount1}`)
                  } catch (e){
                    console.error(`存储数据失败：${e}`)
                  }
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
        console.debug(`得到结果：${testResult}`)
        console.debug("可见区域展开")
      }
    })
  }
}