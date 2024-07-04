/// 作者：SanDaoHai
/// 日期：2024/07/02
/// 描述：API 配置
class ApiConfig {
  // 根據不同的 type 來返回不同的 URL
  static String baseUrlVersion(String type) =>
      'https://tpnco.blob.core.windows.net/$type/';

  static String baseUrlV1 = baseUrlVersion('blobfs');

  // 定義兩個 API 的 URL 陸橋 和 人行橋
  static bridgesUrl(String bridgeId) => '$baseUrlV1$bridgeId';
}
