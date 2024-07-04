//
/// 作者：SanDaoHai
/// 日期：2024/07/04
/// 描述：用於儲存首頁狀態
///
class HomePageState {
  double scrollPosition; // 滾動位置紀錄
  Map<String, bool> expandedTemp; // 展開臨時狀態紀錄

  HomePageState({this.scrollPosition = 0.0, this.expandedTemp = const {}});
}
