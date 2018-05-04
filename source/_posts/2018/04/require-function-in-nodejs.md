---
title:      Require function trong Node.js
date:       2018-04-30
categories: nodejs
tags:
  - js
---

Node.js sử dụng kiến trúc module để chia tách code thành các thành phần riêng rẽ để giúp cho việc bảo trì và tái sử dụng code được tốt hơn. Mỗi module là 1 tập hàm có chức năng liên quan tới một đối tượng và được khai báo ở một file.

Note: đây là format của CommonJS.

<!-- more -->

### Export & Import module:

- Export module với `module.exports`
- Import module với `require` function.

Có 2 cách để export và import module:

- Cách 1: export và require trực tiếp hàm từ module:

```javascript add.js

function add(a, b) {
  return a + b;
}

module.exports = add;
```

```javascript index.js
const add = require('./add');

console.log(add(1, 2)); // 3
```

- Cách 2: export và require module dưới dạng object:

```javascript util.js

function add(a, b) {
  return a + b;
}

module.exports = {
  add,
};
```

```javascript index.js
const util = require('./util');

console.log(util.add(1, 2)); // 3
```

Với cách này, khuyến nghị combine với destructuring assignment:

```javascript index.js
const { add } = require('./util');

console.log(add(1, 2)); // 3
```

Có 2 đặc tính của hàm `require` mà mình nghĩ bạn cần lưu ý: resolving & caching.

#### Resolving

Đây là bước Node.js tiến hành tìm ra đường dẫn tuyệt đối của file để import. Các giá trị mà hàm `require` chấp nhận là:

- Core module. VD: `require('http')`
- 3rd module. VD: `require('express')`
- JS file, NODE file, đường dẫn tuyệt đối hoặc tương đối. VD: `require('./foo.node')`, `require('./foo.js')` hoặc `require('/lorem/ipsum.js')`
- JSON file, tương tự như JS file. VD: `require('./foo.json')`
- Folder. VD: `require('./foo')` (chính là require tới file index.js trong thư mục foo: `require('./foo/index.js')`)

Đối với trường hợp không phải là đường dẫn tương đối hay tuyệt đối, Node.js sẽ tìm trong thư mục `node_modules` và tiếp tục truy ngược lên thư mục cha (cho tới lúc chạm root thì dừng) nếu không tìm thấy. VD: giả dụ bạn đang đứng ở thư mục `/home/duc/Projects/nodejs` và sử dụng `require('foo.js')` thì thứ tự tìm sẽ là:

- /home/duc/Projects/nodejs/node_modules/foo.js
- /home/duc/Projects/node_modules/foo.js
- /home/duc/node_modules/foo.js
- /home/node_modules/foo.js
- /node_modules/foo.js

Và tất nhiên nếu không tìm được kết quả thỏa mãn, Node.js sẽ throw ra Error.

Note:

- Ngoài ra Node.js còn tìm trong các thư mục được define ở biến môi trường `NODE_PATH`.
- Có thể xem Node.js sẽ tìm kiếm module trong những thư mục nào bằng việc log ra `path` của `module`

```javascript
console.log(module);
```

```javascript
Module {
  id: '.',
  exports: {},
  parent: null,
  filename: '/home/duc/Data/Projects/nodejs/index.js',
  loaded: false,
  children: [],
  paths: 
   [ '/home/duc/Data/Projects/nodejs/node_modules',
     '/home/duc/Data/Projects/node_modules',
     '/home/duc/Data/node_modules',
     '/home/duc/node_modules',
     '/home/node_modules',
     '/node_modules' 
   ]
}
```

#### Caching

Require là tiến trình đồng bộ, việc cache module sẽ giúp giảm thiểu thời gian load ứng dụng. Trong lần đầu tiên module được load, nó sẽ được cache lại, trong các lần `require` tiếp theo, bản cache của module sẽ được trả về. Xét VD:

```javascript foo.js
console.log(123);
```

```javascript index.js
require('foo.js');

console.log(456);

require('foo.js');

console.log(789);
```

Và khi chạy file `index.js`, kết quả xuất hiện sẽ là:

```
123
456
789
```

### Conclusion

Note: Hiện tại bạn có thể sử dụng ES6 với Babel. Babel sẽ convert cụm `import`/`export` sang `require`/`module.exports`.

Trên đây là giới thiệu về hàm `require` trong kiến trúc module của Node.js và một số đặc tính của nó. Thanks for reading!