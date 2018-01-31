---
title:      Thực thi javascript es2017 trên aws lambda 
date:       2018-01-30
categories: nodejs
tags:
  - aws lambda
  - babel
---

AWS Lambda được giới thiệu vào khoảng năm 2014, và kể từ đó cho đến nay thì serverless architecture đang ngày càng trở nên phổ biến.  
Một điều khá thất vọng là runtime hiện tại của AWS Lambda là nodejs 6.10.3
Nếu bạn là 1 nodejs developer và đã quen với những tính năng nhưng async/ await trong es2017 thì không khỏi thất vọng.  
Bài viết này sẽ hướng dẫn bạn chạy es2017 (hoặc bất kỳ next feature nào) trên AWS Lambda.  
<!-- more -->

> Nếu bạn chưa biết serverless architecture là gì thì nó là 1 dạng chương trình mà trong đó phụ thuộc vào các bên thứ 3 (Backend as a service `BaaS` hoặc Function as a service `FaaS`) 
> Serverless nghĩa là bây giờ application của bạn sẽ không có server nào cả. Bạn chỉ cần code các backend hoặc function và bên thứ 3 sẽ làm tất tần tật phần còn lại cho bạn  

## Làm thế nào để thực thi es2017 trên aws lambda?  
Nếu bạn đã quen với workflow sử dụng các bundler như webpack thì bạn chắc đã khá quen với 1 tool tên là `Babel`  
Babel giúp ta transform code của mình sang các es thấp hơn, đảm bảo tính tương thích.  
Thực ra ở đây không hẳn chúng ta chạy es2017, mà là chúng ta sẽ viết code trên es2017, sau đó dùng babel transform sang code tương thích với nodejs 6.10.3, đóng gói lại và upload lên AWS Lambda.  
> Hiện tại thì Nodejs LTS version 8.x đã hỗ trợ gần hết es2017 nên tương lai gần khi AWS Lambda update runtime lên 8.x thì mình không phải lo migrate code nữa <3 

Trước tiên chúng ta cần tải về các thư viện liên quan đến babel nhé  
```
$ npm install --save-dev babel-cli babel-core babel-preset-env 
```

Cấu hình babel để transform ra nodejs 6.10.3 
```.babelrc
{
  "presets": [
    [
      "env",
      {
        "targets": { "node": "6.10.3" }
      }
    ]
  ]
}
```

Project của chúng ta sẽ bố trí cây thư mục như sau:  
```
|
|-- .babelrc 
|-- package.json
|-- src 
|-- dist 
|-- node_modules
```

Để tự động hoá quá trình build thì ta sẽ thêm vào package.json 1 vài scripts:  
```json 
"scripts": {
  "build": "npm run build:init && npm run build:js && npm run build:install",
  "build:init": "rm -rf dist && mkdir dist",
  "build:js": "cd src && babel . -d ../dist",
  "build:install": "cp package.json dist/ && cd dist && npm install --production"
}
```
Giải thích sơ bộ 1 tí thì mỗi khi mình cần build code, chúng ta sẽ phải:  
1. Xoá và tạo lại thư mục dist để đảm bảo build không dính các file cũ  
2. Dùng babel để transform code ở source sang dist 
3. copy file package.json vào dist và install các package của production  

Bây giờ bạn thử viết 1 handler, build và up lên AWS Lambda xem đã chạy chưa nhé 
```js src/index.js 
exports.handler = async (event, context, callback) => {
  const result = await doSomething();

  callback(null, result);
};
```

P/s: với Babel thì bạn có thể chạy bất kỳ es nào ở stage nào mà bạn muốn. Tuy nhiên nếu dùng quá nhiều tính năng mới và không tối ưu hoá build thì code được build ra sẽ cho performance khá thấp. Tốt nhất bạn nên cân bằng giữa những feature mà bạn thật sự cần và dung lượng code build ra. 
