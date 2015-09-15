define {
    run: (map)->
        map.enableScrollWheelZoom()
        map.centerAndZoom new BMap.Point(116.404, 39.915), 13
        lushu = undefined

        # 实例化一个驾车导航用来生成路线
        drv = new BMap.DrivingRoute("北京",
            onSearchComplete: (res) ->
                if drv.getStatus() is BMAP_STATUS_SUCCESS
                    plan = res.getPlan(0)
                    arrPois = []
                    j = 0

                    while j < plan.getNumRoutes()
                        route = plan.getRoute(j)
                        arrPois = arrPois.concat(route.getPath())
                        j++
                    map.addOverlay new BMap.Polyline(arrPois,
                        strokeColor: "blue"
                    )
                    map.setViewport arrPois
                    lushu = new BMapLib.LuShu(map, arrPois,
                        defaultContent: "" #"从天安门到百度大厦"
                        autoView: true #是否开启自动视野调整，如果开启那么路书在运动过程中会根据视野自动调整
                        icon: new BMap.Icon("http://developer.baidu.com/map/jsdemo/img/car.png", new BMap.Size(52/2, 26/2),
                            anchor: new BMap.Size(27, 13)
                        )
                        speed: 4500
                        enableRotation: true #是否设置marker随着道路的走向进行旋转
                        landmarkPois: [
                            lng: 116.314782
                            lat: 39.913508
                            html: "加油站"
                            pauseTime: 2
                        ,
                            lng: 116.315391
                            lat: 39.964429
                            html: "高速公路收费<div><img src=\"http://map.baidu.com/img/logo-map.gif\"/></div>"
                            pauseTime: 3
                        ,
                            lng: 116.381476
                            lat: 39.974073
                            html: "肯德基早餐<div><img src=\"http://ishouji.baidu.com/resource/images/map/show_pic04.gif\"/></div>"
                            pauseTime: 2
                        ]
                    )
        )
        drv.search "天安门", "百度大厦"


        #绑定事件
        $ = (element) ->
            document.getElementById element
        $("run").onclick = ->
            lushu.start()

        $("stop").onclick = ->
            lushu.stop()

        $("pause").onclick = ->
            lushu.pause()

        $("hide").onclick = ->
            lushu.hideInfoWindow()

        $("show").onclick = ->
            lushu.showInfoWindow()
        window.setTimeout(->
            lushu.start()
        2000
        )
        lushu.start()
}
