# by Mush Mo (mush@pandorica.io)
addStyle = (stylePath, f) ->
    container = document.getElementsByTagName("head")[0]
    addStyle = document.createElement("link")
    addStyle.rel = "stylesheet"
    addStyle.type = "text/css"
    addStyle.media = "screen"
    addStyle.href = stylePath
    container.appendChild(addStyle)
    f()

extract_url = ->
    result=[]
    for item in $(".media-list:visible")
        data = {}
        data.title = $(item).find("h2").text()
        data.items = []
        for down_section in $(item).find("li:visible")
            down_links = $(down_section).find(".fr")
            for down_title_item, index in $(down_section).find(".fl")
                title = $.trim($(down_title_item).text())
                for key, value of $(down_links[index]).find(
                    "a[thundertype]").getAttributes()
                        if value.indexOf('thunder') == 0
                            thunder_url = value
                            data.items.push {
                                title: title, thunder_url: thunder_url}
        result.push data
    return result

(($) ->
    $.fn.getAttributes = ->
        attributes = {}
        if @length
            $.each this[0].attributes, (index, attr) ->
                attributes[attr.name] = attr.value
        attributes

    $.fn.DIYModal = (options) ->

        defaults = {}
        settings = $.extend({}, defaults, options)

        @each ->
            $elem = $(this)

            $modal = $(
                '<div class=\'diymodal\'><div class=\'diymodal-container\'>' +
                settings.html +
                '<span class=\'diymodal-close-btn close-btn\'>X</span>' +
                '</div></div>'
            )
            $mask = $('<div class=\'mask\'></div>')
            $modal.css
                'visibility': 'hidden'
            $mask.css
                'visibility': 'hidden'
            $('body').append $modal
            $('body').append $mask

            _show = ->
                resource_list = extract_url()
                _html = '<table border="1" class="url-table diymodal-item">'
                for key, v of resource_list
                    
                    for item, i in v.items
                        if i == 0
                            _html = _html + '<tr>' +
                            '<th rowspan="'+ v.items.length+'">' + v.title +
                             '<br>共' + v.items.length + '个</th>' +
                            '<td><span>' + item.thunder_url + '</span></td>' +
                            '</tr>'
                        else
                            _html = _html + '<tr><td><span>' +
                                item.thunder_url + '</span></td></tr>'
                _html += "</table>"
                
                $modal.find(".diymodal-container>.title").after(_html)
                $modal.css
                    'visibility': 'visible'
                    'opacity': 1
                $modal.find('.diymodal-container').css 'transform', 'scale(1)'
                $mask.css
                    'visibility': 'visible'
                    'opacity': 1
                $("html").css
                    'overflow-y': 'hidden'

            _hide = ->
                $modal.css
                    'visibility': 'hidden'
                    'opacity': 0
                $modal.find('.diymodal-container').css 'transform', 'scale(0.7)'
                $mask.css
                    'visibility': 'hidden'
                    'opacity': 0
                $(".diymodal-item").remove()
                $("html").css
                    'overflow-y': 'auto'

            $elem.click ->
                _show()

            $mask.click ->
                _hide()

            $modal.find('.close-btn').click ->
                _hide()
) jQuery
$(document).ready ->
    addStyle 'http://7vzol6.com1.z0.glb.clouddn.com/monkey/zimuzu/' +
        'dialog.css', ->
        setTimeout ->
            $(".download-tab").append "<a class=\"btn diy-btn\" " +
                "href=\"javascript:void(0);\">提取链接</a>"
            $('.diy-btn').DIYModal html: "<h3 class=\'title\'>下载链接提取器</h3>" +
                "<a class=\'btn close-btn\' href=\'javascript:void(0)\'>关闭</a>",
            200
