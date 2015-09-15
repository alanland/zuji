define {
    run: (map)->
# 百度地图API功能
        map.centerAndZoom new BMap.Point(116.404, 39.915), 11
        walking = new BMap.WalkingRoute(map,
            renderOptions:
                map: map
                autoViewport: true
        )
        walking.search "天坛公园", "故宫", {waypoints: ["中华民族园", "对外经贸大学"]}
}