# 百度地图API功能
define(
    run: (map)->
        map.centerAndZoom new BMap.Point(116.404, 39.915), 15
        myP1 = new BMap.Point(116.380967, 39.913285) #起点
        myP2 = new BMap.Point(116.424374, 39.914668) #终点
        myIcon = new BMap.Icon("http://developer.baidu.com/map/jsdemo/img/Mario.png", new BMap.Size(32, 70), #小车图片
#            offset: new BMap.Size(0, -5),    #相当于CSS精灵
            imageOffset: new BMap.Size(0, 0) #图片的偏移量。为了是图片底部中心对准坐标点。
        )
        driving2 = new BMap.DrivingRoute(map, #驾车实例
            renderOptions:
                map: map
                autoViewport: true
        )
        driving2.search myP1, myP2 #显示一条公交线路
        window.run = ->
            driving = new BMap.DrivingRoute(map) #驾车实例
            driving.search myP1, myP2
            driving.setSearchCompleteCallback ->
#通过驾车实例，获得一系列点的数组
#获得有几个点
                resetMkPoint = (i) ->
                    carMk.setPosition pts[i]
                    if i < paths
                        setTimeout (->
                            i++
                            resetMkPoint i
                        ), 100
                pts = driving.getResults().getPlan(0).getRoute(0).getPath()
                paths = pts.length
                carMk = new BMap.Marker(pts[0],
                    icon: myIcon
                )
                map.addOverlay carMk
                i = 0
                setTimeout (->
                    resetMkPoint 5
                ), 100


        setTimeout (->
            run()
        ), 1500
);
