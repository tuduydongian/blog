---
title:      Tối ưu hoá webpack bundle
date:       2017-09-30
categories: frontend
tags: 
  - js
  - webpack
---
Sau một thời gian dùng webpack để build thì song song cùng độ sướng chắc hẳn bạn sẽ thấy dung lượng của file bundle càng ngày càng phình ra.  
Bài này chủ yếu tập trung về tối ưu hoá dung lượng bundle và tốc độ tải, từ đó tăng độ sướng cho người dùng.  
<!--more--> 
**TLDR:**  
- Code splitting về cơ bản đã giải quyết hiệu năng tốt.  
- Hãy phân tích kỹ bundle size trước khi quyết định tối ưu hoá hiệu năng.  
- Mỗi app là khác nhau nên cần các phương án tối ưu khác nhau.  

Mình đã từng đề cập ở [phần 1](/2017/06/webpack-simple/) và [phần 2](/2017/07/webpack-simple-2/), để chia nhỏ dung lượng của file bundle cuối cùng thì 2 cách đơn giản nhất là:  
- Gom toàn bộ những library dùng chung vào 1 file (vendor.js chẳng hạn), file này sẽ được cache lại nên khi load những trang khác sẽ nhanh hơn.  
- Chia nhỏ entry point cho những page riêng biệt. Nếu tối ưu tốt thì có những page gần như không cần js để chạy, hoặc 1 lượng lớn code js chỉ dùng cho 1 page thì các page còn lại sẽ nhẹ hơn rất nhiều. 

Nếu áp dụng 1 cách khoa học 2 cách trên thì tốc độ load trang về cơ bản đã được cải thiện nhiều.  
Tuy nhiên bản chất của cách trên chỉ là thay vì 1 cục code to thì mình chia ra nhiều cục nhỏ và tải theo từng page cho phù hợp. Tổng lại thì bundle size cũng không khác như cũ là bao nhiêu.  

Nếu thực sự nghiêm túc với tối ưu hoá tốc độ tải và dung lượng của bundle thì trước hết ta cần phân tích sâu hơn tình trạng của bundle.   

### Phân tích dung lượng bundle  
Bản thân webpack đã hỗ trợ điều này, bạn chỉ cần chạy lệnh:  
```bash 
$ webpack --json > stats.json 
```
Nó sẽ xuất ra cho bạn 1 file json thống kê trạng thái bundle. File json này về cơ bản là khó đọc, có nhiều tools để bạn có thể mô hình hoá file này cho dễ hiểu. Mình thường hay dùng `webpack-visualizer-plugin`  
Đơn giản nhất thì bạn vào [trang này](https://chrisbateman.github.io/webpack-visualizer/), upload file json là nó sẽ hiển thị dạng đồ thị cho bạn dễ hình dung.  
Như hình này là thống kê 1 dự án bọn mình đang làm.  
![Bundle stats](/images/bundle_stats.png)  

Nhìn qua graph thì ta thấy chủ yếu thằng momentjs chiếm đến 50% dung lượng. Do đó, nếu có tối ưu thì hiệu quả nhất vẫn là tối ưu cách load momentjs. Đối với dự án này bọn mình chỉ dùng momentjs cho 1 page duy nhất, do đó phương án hiệu quả nhất là chỉ load momentjs cho trang đó, hoặc chuyển qua dùng thư viện đáp ứng tính năng mình cần nhưng nhẹ hơn nhiều.  

### Tree Shaking  
Tree Shaking có nghĩa là xoá những code được thực sự sử dụng đến. Nếu bạn đang viết es2015 (import/ export) và dùng webpack 2 thì tin mừng là đã được hỗ trợ native.  
Để hiểu rõ hơn thì tưởng tượng ta có module thế này:  
```js math.js 
export function square(x) {
  return x * x;
}

export function cube(x) {
  return x * x * x;
}
```

Và trong project thì chúng ta chỉ dùng mỗi hàm `square` thôi.  
```js app.js 

import { cube } from './math.js';

```

Giờ build và nhìn trong bundle ta sẽ thấy cái này:  
```js bundle.js 
"use strict";
/* unused harmony export square */
/* harmony export (immutable) */ __webpack_exports__["a"] = cube;
function square(x) {
  return x * x;
}

function cube(x) {
  return x * x * x;
}
```
Nếu để ý kỹ bạn sẽ thấy là webpack chỉ export `cube` còn `square` thì không đụng đến. Lúc này hàm `square()` được hiểu là dead code.   
Khi build code ở production, kết hợp với `uglifyjs-webpack-plugin` (đã đề cập ở phần trước) thì nó sẽ xoá toàn bộ dead code. Bundle size sẽ giảm đi code thừa nên sẽ nhẹ hơn.  

### Lazy Loading 
Lazy loading, có thể hiểu là `load khi cần`. Đây là một trong những cách tuyệt vời để tối ưu hoá hiệu năng.  
Hiểu một cách đơn giản thì bình thường cứ load trang là mình load những đoạn code mình cần. Với lazy loading, mình có thể làm một mức cao hơn nữa là chỉ load khi `thực sự cần`.  
Ví dụ bây giờ mình có 1 module là print.js, khi người dùng vào trang, click vào 1 button thì minh mới thực sự load và thực thi module này.  

Trước tiên là tạo 1 module print.js 
```js print.js
console.log('The print.js module has loaded! See the network tab in dev tools...');

export default () => {
  console.log('Button Clicked: Here\'s "some text"!');
};
```

Và giờ trong app của mình, ta sẽ tạo 1 button, khi nào button được click thì mình sẽ load module print.js 
```js app.js 
function component() {
  const element = document.createElement('div');
  const button = document.createElement('button');
  button.innerHTML = 'Click me and look at the console!';
  element.appendChild(button);

  button.onclick = () => System.import(/* webpackChunkName: "print" */ './print').then((module) => {
    const print = module.default;

    print();
  });

  return element;
}

document.body.appendChild(component());
```

Giờ bạn chạy app và bật dev toolbar lên nhé. Để ý bạn sẽ thấy khi nào mình click button thì network mới load module print.js 

Có nhiều tips nhỏ nữa liên quan đến tối ưu hoá nhưng không liên quan nhiều lắm đến webpack nên chắc là mình sẽ chia sẻ ở bài khác. Bài này mình xin dừng tại đây để kịp merge trước khi hết tháng :D  
P/s: code và cấu hình webpack mình sẽ thường xuyên cập nhật [ở đây](https://github.com/tuduydongian/webpack-starter). Nếu bạn thấy có gì cần cải thiện thì cứ merge request nhé <3  