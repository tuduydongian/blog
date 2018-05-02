---
title: Tìm hiểu vue thông qua xây dựng ứng dụng to do list (Part 1)
date: 2017-01-31
categories: frontend
tags: 
  - vuejs
  - javascript
---

Bài viết này, Dzung chọn viết về **Vue**, một trong những framework nổi tiếng nhất hiện nay(cùng với Angular, React). Vậy, hãy cùng Dzung học về những khái niệm cơ bản trong **vue** thông qua việc xây dựng ứng dụng to do list nhé.
<!-- more -->
### Yêu cầu
Để bắt đầu làm quen với Vue(hoặc bất cứ framework nào khác), chúng ta nên trang bị sẵn cho mình những kiến thức nền tảng như html, css, javascript. Trong cuộc chiến giữa các framework và tooling thì những kiến thức cơ bản nhất sẽ giúp bạn sống sót. Ngoài ra, bạn nên có kiến thức về một số tools về quản lý packages ([npm](https://www.npmjs.com/) hoặc [yarn](https://yarnpkg.com), tool build [webpack](https://tuduydongian.com/2017/06/webpack-simple/).
### Khởi tạo project 
Để giữ mọi thứ thật đơn giản, đầu tiên chúng ta sẽ sử dụng **vue-cli** để các bạn không phải chạm tới sự khủng khiếp của webpack. Nếu bạn chưa cài **vue-cli**, chúng ta sẽ sử dụng câu lệnh dưới đây để cài đặt.

```bash
$npm install -g vue-cli
```
Sau khi cài đặt thành công, chúng ta có thể tạo một vue project thông qua **vue-cli**. 
Bạn hãy chạy lệnh sau:

```bash
$vue init webpack to-do-list
```
Ngay sau đó, bạn chỉ việc chọn các options đi kèm của project template:
- name, description, author
- [Run time](https://vuejs.org/v2/guide/installation.html#Runtime-Compiler-vs-Runtime-only)
- [Vue-router](https://router.vuejs.org/en/)
- [Eslint](https://eslint.org/docs/user-guide/getting-started)
- Ngoài ra còn có các tool về testing...
- Cuối cùng là chọn package manager bạn sử dụng để install các package đi cùng. Có thể skip và install ở trong folder.

Tiếp tục, chúng ta chạy các lệnh sau:
```bash
//Vào folder chứa project
$cd to-do-list
//Kéo các package về nếu bạn skip ở bước cuối.
$npm install
```
Sau khi hoàn thành các bước, chúng ta sẽ có một project với cấu trúc như sau:
![](/images/vue-cli-project.png)
Để chạy, ta sử dụng lệnh:
```bash 
//Chạy dev server
$npm run dev
```
Sau đó, chúng ta truy cập vào [](http://localhost:8080) chúng ta sẽ có được kết quả như dưới:
![](/images/vue-first-page.png)

### Hello, Vue

Tiếp theo, chúng ta sẽ đi tìm hiểu về project vừa tạo. Đầu tiên, chúng ta nhìn vào file `main.js` trong folder `src`, ta sẽ thấy nội dung:

```js
import Vue from 'vue';
import App from './App';
import router from './router';

Vue.config.productionTip = false;

/* eslint-disable no-new */
new Vue({
  el: '#app',
  router,
  components: { App },
  template: '<App/>',
});
```
Ở trên, chúng ta đã khởi tạo 1 vue instance có chứa component. Ở đây có 2 khái niệm mà bạn cần phải hiểu bao gồm: 
- [Vue Instance](https://vuejs.org/v2/guide/instance.html)
- [Vue Component](https://vuejs.org/v2/guide/components.html)

Trong project, các component sẽ được lưu thành các file có định dạng là .vue. Một file .vue thường gồm 3 phần như sau:
- Template được viết với cú pháp tương tự html và có thể render DOM thông qua data của vue instance. Các cú pháp trong template sẽ được giới thiệu cụ thể ở phần sau.
- Script dùng để viết mã js và export ra component. Mình sẽ nói kỹ hơn về phần này ở phần tiếp theo.
- Style được sử dụng để viết css. Bạn có thể viết css hoặc scss, sass,... tuỳ ý bằng cách sử dụng loader tương ứng.

Ví dụ, chúng ta sẽ sửa lại file App.vue với nội dung như sau:
```js
//template
<template>
  <div class="hello">Hello world</div>
</template>
//script
<script>
  export default {
    data() {
      return {
        message: 'Hello, Vue'
      };
    }
  }
</script>
//style
<style>
  .hello {
    background: pink;
  }
</style>
```
Kết quả sẽ là:
![](/images/hello-vue.png)

### Kết bài

Vì thời gian có hạn nên ở phần 1, Dzung chỉ kịp lướt qua về việc cài cắm cũng như một số khái niệm cơ bản trong vue. Những phần còn lại, Dzung xin phép được để dành viết tiếp ở phần sau. Cảm ơn và mong các bạn theo dõi các phần tiếp theo <3
