import { distributedKVStore } from "@kit.ArkData";

const appID = "com.example.testapp";
export let kvManager: distributedKVStore.KVManager | undefined = undefined;

export function initKVManager(context: Context): void {
  const kvManagerConfig: distributedKVStore.KVManagerConfig = {
    context: context,
    bundleName: appID
  }
  try {
    kvManager = distributedKVStore.createKVManager(kvManagerConfig);
  } catch (err) {
    console.error(`数据库实例初始化错误：${err}`)
  }
}