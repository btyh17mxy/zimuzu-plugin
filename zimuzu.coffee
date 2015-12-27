// ==UserScript==
// @name         New Coffee-Userscript
// @namespace    http://www.zimuzu.tv/
// @version      0.1
// @description  shows how to use coffeescript compiler
// @author       Mush Mo <mush@pandorica.io>
// @require      http://coffeescript.org/extras/coffee-script.js
// @require      http://7vzol6.com1.z0.glb.clouddn.com/monkey/zimuzu/jquery.min.js
// @require      http://7vzol6.com1.z0.glb.clouddn.com/monkey%2Fzimuzu%2Fclipboard.min.js
// @require      http://7vzol6.com1.z0.glb.clouddn.com/monkey%2Fzimuzu%2Ftoastr.js
// @match        http://www.zimuzu.tv/resource/list/*
// ==/UserScript==
/* jshint ignore:start */
var inline_src = (<><![CDATA[
addStyle = (stylePath, f) ->
    container = document.getElementsByTagName("head")[0]
    _addStyle = document.createElement("link")
    _addStyle.rel = "stylesheet"
    _addStyle.type = "text/css"
    _addStyle.media = "screen"
    _addStyle.href = stylePath
    container.appendChild(_addStyle)
    if f
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
                _html = ""
                for key, v of resource_list
                    _html = _html + '<a class="btn btn-copy btn-' + v.title +
                         '" data_num_urls="' + v.items.length +
                         '" data-clipboard-target=".copy-' + v.title + '">' +
                         v.title + '</a>'
                    clipboard = new Clipboard('.btn-' + v.title)
                    clipboard.on(
                        'success',
                        (e)->
                            toastr.success '复制' +
                                $(e.trigger).getAttributes().data_num_urls +
                                 '个' + $(e.trigger).text() + '资源', "复制成功!"
                    )
                    clipboard.on(
                        'error',
                        (e)->
                            toastr.error '但看起来是复制失败了', '我也不知道发生了什么'
                    )
                _html = _html +
                    '<table border="1" class="url-table diymodal-item">'
                for key, v of resource_list
                    _urls = ""
                    for item, i in v.items
                        _urls = _urls + item.thunder_url + '\n'
                        if i == 0
                            _html = _html + '<tr>' +
                                '<th rowspan="'+ v.items.length+'">' + v.title +
                                 '<br>共' + v.items.length + '个</th>' +
                                '<td><span>' + item.thunder_url +
                                '</span></td>' + '</tr>'
                        else
                            _html = _html + '<tr><td><span>' +
                                item.thunder_url + '</span></td></tr>'
                    _html = _html + '<pre class="super-hide copy-' +
                         v.title + '">' + _urls + '</pre>'
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
    addStyle 'http://7vzol6.com1.z0.glb.clouddn.com/monkey%2Fzimuzu%2Ftoastr.css'
    addStyle 'http://7vzol6.com1.z0.glb.clouddn.com/monkey%2Fzimuzu%2Fdialog.css', ->
        setTimeout ->
            $(".download-tab").append "<a class=\"btn diy-btn\" " +
                "href=\"javascript:void(0);\">提取链接</a>"
            $('.diy-btn').DIYModal html: "<h3 class=\'title\'>下载链接提取器</h3>" +
                "<a class=\'btn close-btn\' href=\'javascript:void(0)\'>关闭</a>",
            1500
]]></>).toString();
var compiled = this.CoffeeScript.compile(inline_src);
eval(compiled);
/* jshint ignore:end */
