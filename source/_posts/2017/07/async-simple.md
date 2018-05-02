---
title:      Async thật đơn giản
date:       2017-07-30
categories: javascript
tags:
    - async
---
Trong 3 tháng trở lại đây, Dzung tay to, một trong những back-end programer khét tiếng về độ bựa và độ vi diệu 
trong những dòng code mà hắn viết ra đã chân ướt chân ráo vào lãnh địa front-end đầy vi diệu. Với Dzung, back-end
đã ảo diệu thì front-end là một phạm trù triết học không có lời giải. Vì vậy, Dzung quyết định viết một series về 
front-end với một mong muốn nhỏ nhoi là "chắc ai đó sẽ đọc thôi" để cuối năm kiếm giải best author về cưới vợ. Để 
bắt đầu sereries, cháu xin viết một xíu về async, một rổ hành thơm lừng cho ai mới làm quen với em gái JS.
<!--more--> 

## Vì sao lại phải có Async?

Vấn đề được bắt đầu từ engine của JS. Engine của JS có nhiệm vụ biên dịch và xử lý các đoạn mã của chương trình 
trong cùng một thời điểm. Điều đó đồng nghĩa với việc JS xử lý các đoạn mã đơn luồng. Các phần của đoạn mã sẽ 
được đẩy vào Callstack và gọi ra theo thứ tự. Ví dụ như:

```js
function foo() {
  console.log('foo');
}

function bar() {
  foo();
  console.log('bar');
}

bar();

/*Result in console
    foo
    bar
   */
```
Quá trình xử lý diễn ra như sau:

- Hàm `bar()` được gọi thì hàm `bar()` sẽ được đẩy vào call stack.
- Hàm `foo()` được gọi trong hàm `bar()` nên được đẩy vào call stack. 
- Hàm `foo()` được pop ra khỏi call stack và run. Kết qủa in ra `'foo'`.
- Hàm `bar()` được pop ra khỏi call stack và run. Kết qủa in ra `'bar'`.

Các đoạn mã được thực hiện theo thứ tự của call stack. Như vậy, nếu theo cơ chế hoạt động này khi thực hiện một task có 
thời gian xử lý dài, tất cả sẽ bị blocking. Nó giống như việc bạn gửi 1 load ảnh và trình duyệt bị block không thể sử dụng. 
Nhưng trong thực tế, điều đó hoàn toàn không xuất hiện vì JS có cơ chế Async giúp chúng ta tránh được việc bị blocking.

## Async là gì?

Async(Asynchronous) là sự xử lý bất đồng bộ. Nó có giống như là có 2 công việc A, B. Đầu tiên thực hiện công việc 
A nhưng không chờ công việc A hoàn thành thì thực hiện tiếp công việc B. Ở trong Javasript, file .js sẽ được chia 
thành nhiều phần nhỏ để xử lý. Thông thường những đơn vị nhỏ đó sẽ là function. Các function ở đây sẽ được xử lý bất 
đồng bộ nên có thể có nhiều function được xử lý đồng thời. Ví dụ như ở dưới:

```js
  function foo() {
    console.log('foo');
  }
  
  function bar() {
    setTimeout(foo, 2000);
    console.log('bar');
  }
  
  bar();
  
  /*Result in console
    bar
    foo
   */
```

Trong ví dụ ta thấy, mặc dù `foo()` được gọi trước `bar()` nhưng khi `foo()` đang xử lý thì `bar()` cũng xử lý. Kết 
quả là sẽ log ra `'bar'` rồi 2s sau sẽ log ra `'foo'`. Như vậy, ví dụ trên thể hiện quá trình xử lý bất đồng bộ của 
Javasript engine. Hay nói một cách khách, async là quá trình xử lý nhiều phần của chương trình không theo tuần tự.

## Async hoạt động như thế nào? 

Javascript có một cơ chế gọi là event loop. Nó là một process của Javascript engine hoạt động liên tục kiểm tra call 
stack. Khi call stack rỗng, nó sẽ đẩy call back đầu tiên ở event queue qua call stack và xử lý. Khi có event đăng ký, 
event sẽ được đẩy vào event map cùng với hàm call back. Khi có event xảy ra, nó sẽ đẩy call back vào event queue.

Như ở ví dụ phần 2, các phần của chương trình được thực hiện như sau: 
- Hàm `bar()` được gọi và được đẩy vào call stack. 
- Hàm `setTimeout(foo, 2000)` được gọi sẽ đăng ký với event map là sau 2s sẽ gọi hàm `foo()`. Hàm `foo()` được gọi là callback.
- Call stack pop `bar()` ra và xử lý. Kết quả được log ra màn hình là `'bar'`.
- Sau 2s, event `timeout` xảy ra. Hàm callback `foo()` được đẩy vào event queue.
- Trong quá trình kiểm tra liên tục, khi thấy call stack rỗng, thì `foo()` cũng là callback duy nhất ở trong event queue 
nên được đẩy sang call stack và và xử lý. Kết quả in ra là `'foo'`.
- Kết quả in ra sẽ là `'bar'` rồi đến `'foo'`. Hoàn toàn khác với quá trình xử lý đồng bộ giúp hoàn toàn tránh được hiện 
tượng code blocking cũng như giúp tăng hiệu năng.

## Tổng kết 

Như vậy, ở bài viết này Dzung đã làm rõ về khái niệm async cũng như cơ chế hoạt động của Async trong Javascript. Hy vọng 
bài viết sẽ giúp các bạn hiểu rõ hơn về Async và cảm thấy nó thật đơn giản. Bài viết xin dừng lại ở đây. Ở bài viết vào 
tháng tới, mình sẽ viết về callback và promise để giúp mọi người có thể ứng dụng Async vào coding dễ dàng hơn, mong mọi 
người theo dõi bài viết. 