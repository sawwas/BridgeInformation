import 'package:bridge_information/utils/widgets/safe_screen_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/bridge.dart';
import '../utils/widgets/multi_text.dart';

/// 作者：SanDaoHai
/// 日期：2024/07/03
/// 描述：詳情頁
class DetailPage extends StatefulHookConsumerWidget {
  final Map<String, dynamic>? data;

  const DetailPage({super.key, required this.data});

  @override
  ConsumerState<DetailPage> createState() {
    return _DetailPageState();
  }
}

class _DetailPageState extends ConsumerState<DetailPage> {
  @override
  Widget build(BuildContext context) {
    var data = widget.data?['bridge_data'];

    // 详情页的item - Hooks callback
    Function({dynamic title, dynamic subTitle}) itemWidget = useCallback(
      ({title, subTitle}) => Container(
        margin: EdgeInsets.only(top: 20.h, left: 16.w, right: 16.w),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final widgetWidth = constraints.maxWidth / 2 - 32.w;
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MultiTextWidget(
                  title: title ?? "",
                  style: TextStyle(fontSize: 15.sp),
                  width: widgetWidth * 2 / 3,
                  maxLines: 2,
                ),
                MultiTextWidget(
                  title: subTitle ?? "",
                  style: TextStyle(fontSize: 15.sp),
                  width: widgetWidth * 4 / 3,
                  maxLines: 5,
                ),
              ],
            );
          },
        ),
      ),
    );
    return Scaffold(
      appBar: AppBar(
          title: Container(
        padding: EdgeInsets.only(right: 45.w),
        alignment: Alignment.center,
        child: data is Bridge
            ? Text(
                data.bridgeName ?? "",
                textAlign: TextAlign.center,
              )
            : Text(
                data?.footbridgeName ?? "",
                textAlign: TextAlign.center,
              ),
      )),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: BridgeMapWidget(
                data: data,
              ),
            ),
            itemWidget(
                title: translate('bridge_name'),
                subTitle: data is Bridge
                    ? data.bridgeName
                    : data?.footbridgeName ?? ""),
            itemWidget(
                title: translate('DesignEngineers'),
                subTitle: data is Bridge
                    ? data.designer
                    : data?.DesignEngineers ?? ""),
            itemWidget(
                title: translate('Address'),
                subTitle: data is Bridge ? data.locational : data?.Route ?? ""),
            SizedBox(height: bottomPadding),
          ],
        ),
      ),
    );
  }
}

class BridgeMapWidget extends HookConsumerWidget {
  final dynamic data;

  const BridgeMapWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapController = useState<GoogleMapController?>(null);

    // 設置地圖初始位置
    final LatLng _center = LatLng(
        data?.objLatitude ?? 24.991444, data?.objLongitude ?? 121.572744);

    // 起始位置標記
    final LatLng startLocation = LatLng(
        data is Bridge ? data?.latitudeStart : 0,
        data is Bridge ? data?.longitudeStart : 0);
    // 結束位置標記
    final LatLng endLocation = LatLng(data is Bridge ? data?.latitudeEnd : 0,
        data is Bridge ? data?.longitudeEnd : 0);
    // 橋樑位置標記
    final LatLng objectLocation = LatLng(
        data?.objLatitude ?? 24.991444, data?.objLongitude ?? 121.572744);

    // 當地圖初始化完成後的回調函數
    void _onMapCreated(GoogleMapController controller) {
      mapController.value = controller;
    }

    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: _center,
        zoom: 17.5,
      ),
      markers: {
        // 橋樑起始位置
        if (data is Bridge)
          Marker(
            markerId: const MarkerId('start'),
            position: startLocation,
            infoWindow: InfoWindow(
              title: translate('starting_point'),
              snippet: translate('bridge_start'),
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen),
          ),
        // 橋樑結束位置
        if (data is Bridge)
          Marker(
            markerId: const MarkerId('end'),
            position: endLocation,
            infoWindow: InfoWindow(
              title: translate('ending_point'),
              snippet: translate('bridge_ending'),
            ),
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          ),
        // 橋樑具體位置標記
        Marker(
          markerId: const MarkerId('object'),
          position: objectLocation,
          infoWindow: InfoWindow(
            title: translate('bridge_position'),
            snippet: translate('bridge_detail_position'),
          ),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
        ),
      },
    );
  }
}
