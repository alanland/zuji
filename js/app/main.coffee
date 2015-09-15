# 百度地图API功能
map = new BMap.Map("allmap")
map.centerAndZoom new BMap.Point(116.4035, 39.915), 8
map.centerAndZoom new BMap.Point(113.547463, 22.806838), 14
#setTimeout (->
#    map.panTo new BMap.Point(113.262232, 23.154345)
#), 2000

map.addEventListener "dblclick", (e) ->
    console.log e.point
    alert e.point.lng + ", " + e.point.lat

# move to clicked
map.addEventListener 'click', (e)->
#    marker2.setPosition(e.point)
    markers.push(addMarker(e.point))


# 途径点
markers = []
# 删除一个点
removeMarker = (e, ee, marker)->
    map.removeOverlay marker
    markers = (item for item in markers when not item.point.equals(marker.point))
    return

# 添加一个marker
addMarker = (point)->
    marker = new BMap.Marker(point)
    marker.enableDragging()
    map.addOverlay marker

    #创建右键菜单
    markerMenu = new (BMap.ContextMenu)
    markerMenu.addItem new (BMap.MenuItem)('删除', removeMarker.bind(marker))
    marker.addContextMenu markerMenu

    marker

newStartIcon = ->
    icon = new (BMap.Icon)('http://api0.map.bdimg.com/images/dest_markers.png', new (BMap.Size)(42, 34),
        offset: new (BMap.Size)(0, 0)
        imageOffset: new (BMap.Size)(0, 0))
    return icon
newDestIcon = ->
    icon = new (BMap.Icon)('http://api0.map.bdimg.com/images/dest_markers.png', new (BMap.Size)(42, 34),
        offset: new (BMap.Size)(0, 0)
        imageOffset: new (BMap.Size)(0, 0 - (34)))
    return icon

lines = []
$('#generateBtn').click ->
    for line in lines
        map.removeOverlay(line)
    lines = []
    if markers.length > 1
        for i in [0..markers.length - 2]
            drv.search markers[i].point, markers[i + 1].point
        markers[0].setIcon(newStartIcon())
        markers[markers.length - 1].setIcon(newDestIcon())

drv = new BMap.WalkingRoute("广州",
    onSearchComplete: (res) ->
        if drv.getStatus() is BMAP_STATUS_SUCCESS
            plan = res.getPlan(0)
            console.log plan.getDistance()
            arrPois = []
            j = 0

            while j < plan.getNumRoutes()
                route = plan.getRoute(j)
                arrPois = arrPois.concat(route.getPath())
                j++
            line = new BMap.Polyline(arrPois,
                strokeColor: "blue"
            )
            lines.push line
            map.addOverlay line
)
