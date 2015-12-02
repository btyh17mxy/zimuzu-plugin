# 字幕组迅雷下载链接提取器

从[字幕组](http://www.zimuzu.tv/)网站上下载用迅雷批量下载美剧是个麻烦事, 它貌似没有可以批量复制迅雷下载链接的选项, 于是乎我就撸了这个东西. 这个小脚本可以在字幕组的下载页插入一个"提取链接"的按钮, 可以通过这个来一次复制一季美剧的下载链接, 然后粘到迅雷远程下载中, 岂不爽乎?

![preview](http://7vzol6.com1.z0.glb.clouddn.com/monkey/zimuzu/preview.png)

1. 将dialog.css上传到CDN, 或者就用我的.
2. 在chrome安装[Tampermonkey](http://tampermonkey.net/)插件并将zimuzu.coffee添加进去.
3. 修改Tampermonkey的脚本, 加入以下两行

```
// @require      http://7vzol6.com1.z0.glb.clouddn.com/monkey/zimuzu/jquery.min.js
// @match        http://www.zimuzu.tv/resource/list/*
```
