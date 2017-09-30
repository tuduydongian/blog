---
title:      Asyn thật đơn giản(P2)
date:       2017-09-30
categories: frontend
tags:
  - js
  - async
---

Chào các bạn, Dzung tay to đã trở lại và ăn hại như xưa. Tháng vừa rồi, Dzung đã không hoàn thành kpi khi không có bài viết về Async phần 2. Mong các bạn tha thứ và tiếp tục cày view cho Dzung. Bài này, Dzung lại tiếp tục viết về Async sau khi nhận ra nhiều thứ bản thân đã nhầm về em gái Js. Các bạn có thể đọc lại phần 1 [tại đây](/2017/07/async-simple/). Ở phần 1, Dzung đã nói về `async` cũng như cơ chế hoạt động của `async`. Phần này, Dzung xin đưa ra 2 cách cơ bản để giúp bạn xử lý `async` một cách hiệu quả. 
<!--more-->
### I. Callback
#### 1. Callback là gì?
Các bạn có thể đọc định nghĩa về callback [ở đây](https://en.wikipedia.org/wiki/Callback_%28computer_programming%29). Nói một cách nôm na thì `callback là một đoạn mã  A được truyền vào một đoạn mã B như tham số, đoạn mã A sẽ được chạy khi nó được gọi trong đoạn mã B`. Dzung đoán mặt các bạn đầy hoang mang. Dzung cũng từng hoang mang như các bạn. Trong thực tế, nó sẽ giống như là bạn đăng ký sms banking. Bạn sẽ đăng ký với ngân hàng đoạn mã là `mày nhắn tin cho tao lúc nào tài khoản tao nhận được tiền`. Vì thế nên, mỗi lần lương được chuyển vào tài khoản của bạn. Điện thoại bạn sẽ kêu `ting ting` sẽ nhận được tin nhắn với nội dung:

```
Người gửi: Ngân hàng
-------------------------------------------
Tài khoản của bạn cộng thêm xxx xèng. Bạn hãy nhanh chóng đến cây ATM gần nhất để rút tiền trả nợ.
```

Ở đây, chúng ta có thể viết lại bằng js như sau:

```javascript
function nhanTinChoTao() {
  console.log('Đây là nội dung tin nhắn!');
}

function dangKyDichVu() {
  const taiKhoan = new TaiKhoan();
  taiKhoan.onEvent('nhan_duoc_tien', nhanTinChoTao);
}
```
Đấy, dễ hiểu hơn 1 xíu rồi đúng không các bạn?

#### 2. Ừ, rồi sao?
Nếu các bạn đã viết code JS, chắc 99% các bạn đã viết đoạn code tương tự như bên dưới:

```js
document.querySelector('.button').onclick = function () { console.log('Hello World'); };
```
Ở đoạn code trên, bạn đã viết callback log ra `Hello World` khi click vào nút đó. Trong Js, callback được sử dụng rất nhiều để xử lý async. Chỉ cần lắng nghe sự kiện,lúc sự kiện xảy ra thì gọi callback, async sẽ không trở thành khó khăn nữa. Một cách xử lý async đơn giản và đầy hấp dẫn đúng không ạ. Nếu nó chưa đủ đơn giản theo dõi tiếp ví dụ sau nhé. Một task thường được sử dụng và luôn có async là gọi AJAX. Bạn sẽ gửi 1 request lên server. Bạn không thể biết trước được bao lâu thì sẽ nhận được response cũng như response sẽ như thế nào. Vì vậy, cách tốt nhất là viết callback trong trường hợp này.

```js
// Khởi tạo một XMLHttpRequest 
 const request = new XMLHttpRequest();
// Set url là /porn-hub với method là GET và async là true
request.open('GET', '/porn-hub', true);
// Gán sự kiện on load bằng hàm callback. Callback sẽ được gọi vào sự kiện load.
request.onload = function() {
  if (request.status >= 200 && request.status < 400) {
    console.log('Get dữ liệu từ /porn-hub thành công!');
  } else {
    console.log('Cá mập cắn cáp nên không lấy được dữ liệu!');
  }
};

// Gửi request 
request.send();
```

Qua ví dụ, callback đủ đơn giản rồi đúng không ạ?

#### 3. Callback ngon thế thì còn đưa ra cách 2 làm gì? 
Sự thật là code sử dụng callback rất tiện. Nhưng mặt tối của callback được là **callback hell**. Các bạn thử tưởng tượng nếu phải viết khoảng 4 hoặc 5 cái callback lồng nhau, code của bạn sẽ nhìn như kim tự tháp và người ta thường gọi nó là [pyramid of doom](https://en.wikipedia.org/wiki%2FPyramid_of_doom_%28programming%29). Nếu không tin bạn có thể thử viết code để thực hiện task sau bằng callback. Đầu tiên, bạn lắng nghe sự kiện `click` ở một button. Nếu có người `click` vào button đó thì sau đó 10s gửi 1 request lên server. Sau khi nhận được response, nếu status code là 200 thì log ra `Success!`. Nếu status code là 400 thì gửi lại request sau 10s. Nào, bây giờ chúng ta thử viết đoạn code trên nhé.

```js
function sendAJAX(callback) {
  const request = new XMLHttpRequest();
  request.open('GET', '/porn-hub', true);
  request.onload = function() {
    if (request.status >= 200 && request.status < 400) {
      callback(request.status);
    }
  };
  request.send();
}

const button = document.querySelector('.button');
button.addEventListerner('click',function() {
  setTimeout(function() {
    sendAJAX(function(statusCode) {
      if(statusCode === 200){
        console.log('Success!');
      }
      if(statusCode === 400){
        setTimeout(function() {
          sendAJAX(function() {
            console.log('foo bar');
          })
        }, 1000);
      }
    });
  },1000);
}); 
```
Phía trên là đoạn code mình viết thử. Code rất phức tạp và khó đọc. Tất nhiên, nếu bạn là người có tâm bạn sẽ nghĩ đến việc viết các function cô lập ra để đễ đọc hơn. Nhưng điều đó không thực sự là **root of problem**, nếu bạn gặp trường hợp phải lồng nhiều callback vào nhau hơn nữa, code của bạn sẽ rất khoai. Vì vậy, solution đơn giản hơn là **Promise**.

### II.Promise
#### 1. Promise là một lời hứa à?
Bingo! Promise đúng là một lời hứa ngọt ngào! Nó cũng giống như những ngày cuối tháng, Dzung lại mượn tiền anh Đức để chích trà sữa. Lúc mượn tiền, Dzung hứa lúc nào có tiền sẽ trả. Lúc đó, Dzung đã khởi tạo 1 Promise. Khi Dzung trả tiền, Dzung đã **resolve** promise đó. Còn nếu lỡ, Dzung uống trà sữa nhiều quá, không còn khả năng chi trả. Dzung sẽ **reject** với message ngọt ngào như trà sữa là `em vỡ nợ rồi, anh em sờ vếu nhau đã lâu có mấy chục củ thì mình xí xoá anh nhỉ`. Message ngọt ngào như thế đỡ mất tình cảm anh em. Ai cũng lịch sự như Dzung, đâu có bài hát `người đừng lặng im đến thế, vì lặng im giết bạnt com chim`. Quay lại với vấn đề technical, ở trên là ví dụ mô tả về Promise. Áp dụng vào code, ta sẽ có:

```js
function muonTien() {
  return new Promise(function(resolve, reject) {
    Dzung.taiKhoan.onCoLuong = function(luong) {
      resolve(luong);
    };
    Dzung.taiKhoan.onVoNo = function() {
      reject(new Error('Xài quá tay!'));
    };
  });
}

muonTien()
.then(function() {
  console.log('Trả anh Đức!');
})
.catch(function() {
  console.log('Nhắn tin ngọt ngào để báo vỡ nợ!')
});
```
Phía trên là code minh hoạ cách sử dụng `Promise`. Dễ như uống trà sữa đúng không ạ?

#### 2. Vậy nhiều Promise lồng nhau có khoai như callback không?

Câu trả lời là không. Promise có thể thực hiện theo thứ tự gọi là **chaining**. Nó có nghĩa là bạn có thể gọi **then**nhiều lần. Ví dụ như sau khi trả nợ, anh Đức cảm động và mời Dzung trà sữa. Chúng ta có thể viết tiếp như sau:

```js
muonTien()
.then(function(luong) {
  console.log('Trả anh Đức!');
  return luong;
})
.then(function(luong) {
  const trasua = muaTraSua(luong);
  return trasua;
})
.then(function(trasua) {
  Dzung.chichTraSua(trasua);
})
.catch(function() {
  console.log('Nhắn tin ngọt ngào để báo vỡ nợ!')
});
```
Đấy, code clean lên trông thấy đúng không ạ? Thú thực là Dzung viết **Promise** cũng ngu nên câu chuyện chỉ chuyển qua từ **callback hell** qua **Promise hell**. Chỉ là viết giới thiệu để các bạn tham khảo thôi.

#### 3. Lưu ý bé xíu
Promise vừa được update ở ES6. Vì vậy, Promise chưa hỗ trợ toàn bộ browser nên khi sử dụng Promise các bạn cần kéo thêm [core-js](https://github.com/zloirock/core-js#ecmascript-6-promise) để có polyfill. 

### III. Kết bài
Ở trên là 2 pattern để giải quyết async ở trong JS. Callback là cách truyền thống, dễ viết, hỗ trợ đầy đủ trên mọi browser nhưng điểm yếu là dễ rơi vào callback hell. Còn Promise có thể khắc phục điểm yếu của callback giúp code clean hơn nhưng cần sử dụng library để có polly fill. Các bạn có thể lựa chọn để sử dụng một cách hợp lý. Cảm ơn các bạn đã theo dõi bài viết.