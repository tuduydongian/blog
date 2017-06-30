---
title:      Webpack thật đơn giản
date:       2017-06-28
categories: frontend
tags: 
  - js
  - webpack
---
Webpack là một trong những tools "khủng khiếp" nhất về ý tưởng cũng như độ khoai của việc cấu hình. Nhưng khi đã quen rồi thì có vẻ nó cũng không khoai lắm.  
<!--more-->
Khi mới xuất hiện thì webpack được cho là có ý tưởng khá "dị". Nếu bạn đã quá mệt mỏi với việc maintain assets của phần frontend trong mỗi project, nào là js, css, images, fonts, blah blah... thì ý tưởng của webpack là 1 tool build duy nhất để quản lý toàn bộ mớ assets này.   
_Bài viết này dựa trên webpack 3_  
Để bắt đầu thì trước tiên ta cần tạo 1 project mới và kéo webpack về  
```
npm init 
npm install --save-dev webpack 
```

Giờ ta sẽ setup 1 project đơn giản để in ra chữ `Hello World!` ra màn hình, cấu trúc thư mục như sau:  
```
node_modules
package.json
src
├── app.js
└── index.html
```

Nội dung các files  
```html src/index.html
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf8"/>
    <title>Webpack Starter</title>
</head>
<body>
    <script src="app.js"></script>
</body>
</html>
```

```js src/app.js
var el = document.body;
if (el) {
    el.innerHTML = 'Hello World!';
}
```

Mở file index.html bằng trình duyệt lên bạn sẽ thấy chữ Hello World! được in ra.  
Mọi thứ đã chạy, bây giờ ta sẽ dùng webpack để build.  
Tạo file webpack.config.js với nội dung như sau:  

```js webpack.config.json
const path = require('path');

module.exports = {
    entry: './src/app.js', //webpack sẽ đọc thằng này đầu tiên 
    output: {
        path: path.resolve(__dirname, "dist"), // mình sẽ build mọi thứ ra thư mục dist 
        // thằng path này đòi hỏi phải là absolute nên mình phải kéo thằng module path vào
        filename: "bundle.js", // file được build ra sẽ là file này 
    }
}
```
Vậy là đã xong cả, giờ bạn chạy `./node_modules/.bin/webpack --config webpack.config.js` sẽ thấy một file mới được build ra trong thư mục dist là bundle.js  
Để cho tiện thì bạn nên add thêm 1 command mới vào trong package.json để build:  
```json package.json
"scripts": {
    "build": "webpack --config webpack.config.js"
  }
```
Từ giờ khi nào mình nói `build lại` thì các bạn cứ gõ `npm run build` nhé ;)  
Giờ là bắt đầu những thứ hay ho với webpack.   

### Loader   
Webpack đơn thuần chỉ làm việc với js. Các định dạng khác nhau thì cần thêm loader để load.  

#### Babel loader  
Hiện tại thì es2015 (es6) vẫn chưa hỗ trợ đầy đủ bởi các trình duyệt, nhưng nếu bạn thích viết es6 ngay cho phê, code được build ra sẽ được transform sang es5 thì ta sẽ dùng babel loader.  
Trước tiên ta cần kéo các dependencies về:  
```
npm install --save-dev babel-core babel-loader babel-preset-es2015 
```
Sau đó thì add thêm config module cho webpack  
```
module: {
        rules: [
        {
            test: /\.js$/, // kiểm tra xem file nào có đuôi là .js 
            loader: 'babel-loader' // dùng thằng loader này để xử lý file đó 
            options: {
                presets: ["es2015"] // dùng cái preset này 
            },
        }]
     }
```
Giờ ta sẽ modify lại file app.js tí dùng es6  
```
const el = document.body;
if (el) {
    const target = 'World';
    el.innerHTML = `Hello ${target}!`;
}
```
Build lại chút ta sẽ thấy code es6 đã được transform ra es5 và có thể chạy ngon lành trên mọi trình duyệt  
```js dist/bundle.js 
...
var el = document.body;
if (el) {
    var target = 'World';
    el.innerHTML = 'Hello ' + target + '!';
}
...
```

Nếu bạn để ý kỹ tí thì sẽ thấy cái section module mình cấu hình từng thể loại file mà webpack xử lý theo rules.   

#### Css Loader
Như đã nói từ trước, bây giờ mọi thể loại assets của mình sẽ được webpack xử lý và build ra. Ta sẽ thử với css, tạo 1 file app.css và apply 1 ít css cho nó máu lửa  
```css src/app.css
body {
    font: #f00;
}
```
Webpack cho phép chúng ta load module như là viết trên nodejs, ta sẽ coi file css vừa rồi như là 1 module và load nó từ entry app.js  
```js app.js 
// thêm dòng này vào đầu file 
import './app.css';
```
Xong, giờ ta build lại sẽ thấy ... báo lỗi :D  
Lý do là mình chưa khai báo loader nào để xử lý file .css nên ẻm webpack không hiểu. Để xử lý thì ta sẽ cần:  
Cài css loader 
```
npm install --save-dev css-loader
```
Add thêm rule để load file css
```js webpack.config.css 
{
    test: /\.css$/,

    use: [
        {
            loader: "css-loader",
        }
    ]
}
```
Giờ build lại chắc chắn thành công. Nếu bạn mở file bundle.js ra sẽ thấy toàn bộ code css và js đã được build vào trong đó. Ý tưởng của webpack là vậy, xem tất cả như js và dùng webpack để build hết :D  

Nhúng css vào trong js thì cũng có nhiều nhược điểm: ví dụ như browser phải có js enabled thì mới chạy được, hoặc không thể cache css ra riêng để tăng tốc độ tải.  

Yên tâm thích thế nào thì webpack chiều thế nấy <3   

### Plugins
Webpack có cơ chế plugin để hỗ trợ tuỳ biến quá trình xử lý file. 

#### ExtractTextWebpackPlugin
Ok, bây giờ chúng ta không thích nhúng css vào js nữa, và muốn thằng webpack xử lý cho css ra riêng, đường ai nấy đi, ta sẽ cần dùng ExtractTextWebpackPlugin này.  
Kéo module về trước 
```
npm install --save-dev extract-text-webpack-plugin
```
Sửa lại file config 1 chút phần load css 
```js webpack.config.js
// require thêm plugin 
const ExtractTextPlugin = require("extract-text-webpack-plugin");

// đổi cách load css 
{
    test: /\.css$/,
    use: ExtractTextPlugin.extract({
        use: "css-loader"
    })
}

// thêm section plugin vào  
plugins: [
        new ExtractTextPlugin({
            filename: 'bundle.css',
            allChunks: true,
        }),
    ]
```
Giờ build ra thì bạn sẽ thấy có 2 file là bundle.js và bundle.css :D  

Để add style thì ta sẽ cần sửa index.html, thêm link rel="stylesheet" và trỏ đến file bundle.css.  
Nhưng nếu ta cấu hình webpack để build ra nhiều file, ví dụ js có vendor.js và mỗi page có 1 js riêng, hoặc mình sửa để build ra file có thêm hash (bundle.ade8kdh.js) thì chuyện đi nhúng mấy file này thủ công là not cool :(  

#### HtmlWebpackPlugin
Plugin này sinh ra để giải quyết chuyện đó. Nó sẽ tự tạo ra 1 file html và load toàn bộ bundle của mình vào ;)  
Kéo cháu module này về  
```
npm install --save-dev html-webpack-plugin
```
Sửa config để load plugin:  
```js webpack.config.js  
// require thêm plugin  
const HtmlWebpackPlugin = require('html-webpack-plugin');

// thêm plugin này 
plugins: [
    new HtmlWebpackPlugin()
    ]
```
Giờ bạn không cần file index.html nữa nên có thể xoá nó đi.  
Build lại code và mở file index.html trong thư mục dist bạn sẽ thấy mọi thứ đã được load sẵn ở đó.  

Đến đây hy vọng bạn đã hiểu phần nào về webpack. Túm cái váy lại: 
- Webpack: xem mọi file như là js, quản lý file theo module, browser không cần care nữa.  
- Loader: chỉ định các thể loại file nào sẽ được xử lý như nào. 
- Plugin: giúp tuỳ biến quá trình process file.  

Các bạn có thể tham khảo thêm tại: 
- [Cấu hình đầy đủ webpack](https://webpack.js.org/configuration/)
- [Danh sách các loaders](https://webpack.js.org/loaders/)
- [Danh sách các plugins](https://webpack.js.org/plugins/)

P/s: chờ sang tháng mình sẽ làm tiếp 1 bài về cấu hình nâng cao cho webpack nhé <3 
Toàn bộ mã nguồn của bài viết này có thể xem tại: [webpack starter](https://github.com/tuduydongian/webpack-starter)