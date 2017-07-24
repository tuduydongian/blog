---
title:      Webpack thật đơn giản phần 2
date:       2017-07-23
categories: frontend
tags: 
  - js
  - webpack
---
Bài này chủ yếu bổ sung các cấu hình nâng cao của webpack.   
Nếu bạn chưa nắm được webpack là gì thì có thể xem lại [phần 1](/2017/06/webpack-simple/).  
<!--more--> 

### Webpack dev server
Bạn sẽ cần 1 cái web server để chạy code của mình trong lúc dev. Trước thì có nhiều tools nhưng giờ webpack tích hợp sẵn luôn, rất tiện. Trước tiên cần kéo webpack dev server về:  
```
$ npm install --save-dev webpack-dev-server
```
Sau đó thêm đoạn config sau vào webpack: 
```js webpack.config.js
    devServer: {
        contentBase: path.join(__dirname, "dist") //đọc content từ thư mục dist 
    }
```
Để cho tiện thì ta sẽ add thêm command `dev` vào package.json 
```json package.json
"scripts": {
    "dev": "webpack-dev-server --config webpack.config.js --watch --open"
  }
```
Giờ bạn gõ `npm run dev` sẽ thấy một server mới được mở ra ở địa chỉ: http://localhost:8080 và code của bạn được thực thi ở đó.  
Để ý tí là có tham số `--watch`, nghĩa là mỗi khi bạn code xong và save file thì nó sẽ tự build lại cho bạn nhé. 
Cool :D   

### Source map
Có 1 thứ khá khoai là hiện tại nếu code bị lỗi, nó sẽ thông báo ở file bundle.js đã được build ra. Ngoài ra mình đang code es6 và transfrom sang es5 nên có lần đến thì code cũng khác. Cái chúng ta muốn là lỗi ở file nào mình code thì show ra chính xác dòng đó ở file gốc. Source map sinh ra để giải quyết điều đó, thêm cấu hình sau vào webpack:    
```js webpack.config.js
    devtool: 'inline-source-map',
```
Giờ thì code lỗi đâu show ở đấy rồi nhé ;)  

### Provide plugin 
Thử tưởng tượng mình cần dùng jquery. Chỗ nào cũng import để sử dụng `$` thì hơi mệt. Mục tiêu là chúng ta muốn `$` hoặc `jQuery` sẽ có sẵn ở mọi nơi. Provide plugin sinh ra để làm cái này.  
```js webpack.config.js 
const webpack = require('webpack'); //require webpack 

// thêm vào plugins
new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery'
})
```
Done <3

### Commons chunk plugin
Trong project của ta sẽ có nhiều module dùng chung. Hoặc những thứ như jquery. Commons chunk plugin cho phép ta chia code dùng chung vào 1 file mới. 
```js webpack.config.js 
// thêm tiếp vào plugins 
new webpack.optimize.CommonsChunkPlugin({
  name: "commons",
  filename: "commons.js",
})
```
Giờ bạn chạy code sẽ thấy có thêm 1 file là commons.js nhé.  
Ví dụ nếu mình muốn gom jquery và mấy cái lib khác vào 1 file là vendor.js?  
```js webpack.config.js 
// thêm vào entry 
entry: {
  vendor: ["jquery", "other-lib"],
}

// thêm vào plugins
new webpack.optimize.CommonsChunkPlugin({
    name: "vendor",
    filename: "vendor.js",
    minChunks: Infinity,
})
```

### Uglifyjs Webpack Plugin
Giả sử mình muốn code khi được build ra sẽ được uglify và minify cho nhẹ? UglifyjsWebpackPlugin sinh ra để làm điều này. Trước tiên cần kéo plugin về:  
```
$ npm install uglifyjs-webpack-plugin --save-dev
```
Sau đó bật plugin lên:  
```js webpack.config.js 
const UglifyJsPlugin = require('uglifyjs-webpack-plugin'); // require plugin 

// thêm vào plugins 
new UglifyJsPlugin()
```

### Hot Module Replacement 
Viết code xong, chuyển qua browser refresh để xem kết quả. Bạn đã quá mệt mỏi với việc này? 
Vậy thì dùng Hot Module Replacement để tay đỡ to. Cứ save phát là nó tự refresh cho bạn. Đơn giản chỉ cần thêm plugin này vào:  
```js webpack.config.js
new webpack.HotModuleReplacementPlugin()
```

### Environment configuration  
Thường thì ta sẽ cần cấu hình build cho nhiều môi trường khác nhau. Ví dụ lúc dev thì mình không cần uglify code. Lúc build ra cho production thì sẽ không cần hot module replacement. Để làm điều này thì ta sẽ dựa vào environment variable để làm. Ví dụ lúc chạy cho development ta dùng `NODE_ENV=development` và lúc chạy cho production thì là `NODE_ENV=production`.  
Có 1 vấn đề là nếu dùng environment thì sẽ không ok lắm nếu dùng windows, do đó ta sẽ dùng thêm `cross-env` library để đảm bảo không gặp lỗi. 
```
$ npm install --save-dev cross-env
```
Ta sẽ sửa lại scripts trong package.json để pass thêm environment variable:   
```json package.json
"build": "cross-env NODE_ENV=production webpack --config webpack.config.js",
"dev": "cross-env NODE_ENV=development webpack-dev-server --config webpack.config.js --watch --open"
```
Ở đây mình sẽ mặc định khi `npm run build` là cho production và khi chạy `npm run dev` là development.  
Giờ ta sẽ modify webpack.config.js để làm vài điều như sau:
- Chỉ dùng uglify khi build cho production 
- Chỉ dùng sourcemap, dev server và hot module replacement cho development

```js webpack.config.js 
// Kiểm tra môi trường 
const IS_DEV = process.env.NODE_ENV === 'development';
const IS_PROD = process.env.NODE_ENV === 'production';

const config = {
    // cấu hình chung cho webpack nằm đây 
    // entry: 
    // output:
    // ...
}

if (IS_DEV) {
    config.plugins.push(new webpack.HotModuleReplacementPlugin());
    config.devtool = 'inline-source-map';
    config.devServer = {
        contentBase: path.join(__dirname, "dist")
    };
}

if (IS_PROD) {
    config.plugins.push(new UglifyJsPlugin());
}

module.exports = config;
```
Về cơ bản là vậy. Bạn muốn thêm logic nào nữa thì có thể bổ sung vào.  

### Define Plugin 
Tiếp câu chuyện về environment configuration. Giả sử bạn có 1 vài biến toàn cục như SERVICE_URL, lúc dev thì nó là `https://dev.tuduydongian.com/api` còn khi ở prod thì nó là `https://tuduydongian.com/api`. Ta sẽ dùng define plugin để đạt được điều này.  
```js webpack.config.js 
new webpack.DefinePlugin({
  'SERVICE_URL': JSON.stringify("https://dev.tuduydongian.com/api")
})
```

Về cơ bản là bài cũng dài rồi nên mình xin tạm dừng ở đây nhé. Sang tháng mình sẽ viết tiếp 1 bài nữa về optimization với webpack :D  
Bạn có thể tham khảo thêm về cấu hình tại đây: [webpack starter](https://github.com/tuduydongian/webpack-starter)  
Bộ starter này gần như sẽ là bộ chuẩn của team mình nên cấu hình sẽ hơi khác một chút. 


