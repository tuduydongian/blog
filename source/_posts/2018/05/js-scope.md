---
title:      Scope trong javascript
date:       2018-05-10
categories: javascript
tags:
  - javascript
---
Khả năng cơ bản nhất của hầu hết ngôn ngữ lập trình là lưu trữ giá trị trong các biến, lấy ra giá trị đã lưu hoặc sửa đổi nó. Nhưng các biến đó được lưu trữ ở đâu, và làm thế nào ta tìm thấy chúng khi cần đến? Để hiểu được điều này ta cần một tập các nguyên tắc lưu trữ cũng như tìm lại các biến, ta gọi chúng là scope. Một cách đơn giản hơn, scope dùng để xác định phạm vi, khả năng truy cập của các biến.
<!--more -->
Trong bài viết này, ta sẽ cùng tìm hiểu về một số khái niệm cơ bản của scope trong javascript.
## Lexical Scope
Là mô hình scope trong javascript, và cũng được sử dụng trong hầu hết các ngôn ngữ. Lexical scope nghĩa là scope được định nghĩa trong quá trình lexing: Quá trình phân tách mã nguồn thành từng token. Lexical scope dựa trên vị trí các block và biến được đặt lúc viết mã nguồn.

![](/images/nestedscope.png)

Quan sát ví dụ trên, ở đây ta có 3 nested scopes.
- Scope 1 là global scope, với 1 thực thể là function foo.
- Scope 2 là scope tạo ra bởi function foo, gồm 3 thực thể là biến a, b và function bar.
- Scope 3 là scope tạo ra bởi function bar, có 1 thực thể là c.

Scope 3, được tạo ra bởi function bar, nó nằm hoàn toàn trong scope 2, tạo bởi function foo, bởi lý do duy nhất là function bar được định nghĩa ở trong function foo.

Khi Engine thực thi câu lệnh console.log(...), nó sẽ tìm kiếm tham chiếu đến 3 biến là a, b và c. Engine sẽ theo thứ tự các scope từ trong ra ngoài, bắt đầu từ scope gần nhất, tức là scope 3, và dừng tìm kiếm khi tìm được biến đầu tiên thỏa mãn. Trong ví dụ trên, Engine sẽ tìm thấy c ở scope 3, b ở scope 2, và a ở scope 1.

Để hiểu hơn về lexcial scope, ta sẽ so sánh sự khác nhau giữa nó với một mô hình khác là dynamic scope.

```javascript
function foo() {
	console.log(a); // 2
}
function bar() {
	var a = 3;
	foo();
}
var a = 2;
bar();
```

Ở ví dụ trên, theo nguyên tắc của lexical scope, câu lệnh console.log(a) sẽ tìm tham chiếu đến biến a ở trong scope của function foo, vì không tìm thấy, nó tiếp tục tìm ở scope bên ngoài là global scope, kết quả ta có giá trị của a là 2.

Nếu javascript sử dụng mô hình dynamic scope thay vì lexical scope, câu lệnh trên sẽ hiển thị giá trị 3. Bởi vì khác với lexcial scope xác định dựa trên quá trình khai báo, dynamic scope sẽ chỉ xem xét function foo được gọi từ đâu, như ở ví dụ trên foo được gọi từ bar, và trong scope của bar thì a có giá trị là 3.
## Function và Block Scope
### Function Scope
Trong ví dụ đầu bài, ta thấy scope được tạo ra bởi function, mỗi function tạo ra một scope của chính nó. Cùng xem xét ví dụ tiếp theo:

```javascript
  function foo(a) {
	  var b = 2;
	  function bar() {
		  // ...
	  }
  }
  bar(); // error
  console.log(a, b); // error
```

foo tạo ra scope riêng của nó; a, b, bar thuộc vào scope của foo nên không thể truy cập ở ngoài foo. Tuy nhiên, a, b không chỉ có thể truy cập ở trong foo, mà còn cả ở trong bar. Ý tưởng của function scope là các biến được khai báo trong scope của function có thể được sử dụng ở xuyên suốt trong function đó, và cả các function bên trong nó.
### Block Scope
Trong javascript, các functions là đơn vị thông dụng nhất của scope, nhưng vẫn có các phương pháp tiếp cận khác để tạo ra scope, giúp code sạch sẽ cũng như dễ bảo trì hơn.

Rất nhiều ngôn ngữ lập trình hỗ trợ Block Scope, nghĩa là scope được tạo ra bởi cặp dấu ngoặc nhọn {...}. Ta cùng xem xét ví dụ sau

```javascript
for (var i = 0; i < 10; i += 1) {
  console.log(i); // 0 -> 9
}
console.log(i); // 10
```

Nhiều người sẽ nghĩ rằng câu lệnh console.log(i) ở ngoài vòng lặp for sẽ trả về ReferenceError, bởi i được khai báo trong vòng lặp for, nhưng thực tế i vẫn có thể truy cập từ ngoài block tạo bởi for, và có giá trị là 10.

Ta có ví dụ tương tự với block tạo bởi if

```javascript
var foo = true;
if (foo) {
	var bar = !foo;
	console.log( bar ); // false
}
console.log(bar); // false
```

Nguyên nhân là do khi sử dụng từ khóa var để khai báo biến, scope của biến sẽ không phụ thuộc vào vị trí block khai báo.
**let và const**
ES6 cho ta giải pháp giải quyết vấn đề trên, đó là từ khóa let và const. Khi sử dụng let hoặc const để khai báo biến, biến sẽ được gắn với block hiện tại.

```javascript
var foo = true;
if (foo) {
	let bar = !foo;
	console.log( bar ); // false
}
console.log(bar); // error
```

Lúc này, bar không còn truy cập được ngoài block tạo bởi if.
##Hoisting
Ta thường nghĩ rằng các đoạn mã javascript sẽ được thông dịch theo từng dòng khi chương trình thực thi, nhưng điều này không hoàn toàn đúng. Cùng xem xét ví dụ sau

```javascript
a = 2;
var a;
console.log(a);
```

Ta sẽ nghĩ rằng kết quả là undefined, bởi a được định nghĩa lại sau khi gán giá trị 2. Tuy nhiên kết quả ở đây vẫn là 2.

Lý do là trong javascript các câu lệnh khởi tao sẽ được thực thi trước tiên. Thứ tự thực hiện đúng sẽ là: Khai báo biến a -> Gán cho a giá trị 2 -> Hiển thị a.

Ta có ví dụ tiếp theo

```javascript
console.log(a);
var a = 2;
```

Từ câu trả lời ở ví dụ trên, ta dễ dàng đoán được kết quả của ví dụ này cũng là 2. Nhưng không may, 2 là câu trả lời sai, undefined mới là kết quả đúng.

Câu lệnh var a = 2; thực tế sẽ được chia thành 2 phần: var a; và a = 2;. Phần đầu tiên là câu lệnh khởi tạo biến a sẽ được đưa lên thực hiện trước, phần còn lại là câu lệnh gán sẽ thực hiện theo thứ tự thông thường, tức là sau câu lệnh console.log(), bởi vậy ta có kết quả là undefined.

Hiểu một cách đơn giản, hoisting là đưa các khai báo biến và hàm lên thực thi đầu tiên. Ngoài ra, cũng cần lưu ý thêm rằng hoisting chỉ xảy ra trong phạm vi của scope hiện tại.
##Closure
Closure được định nghĩa là khả năng function nhớ và truy cập được vào lexical scope của nó kể cả khi function được thực thi ở ngoài lexical scope đó.

Cùng xem xét ví dụ sau:

```javascript
function foo() {
    var a = 2;
    function bar() {
        console.log(a);
    }
    return bar
}
var baz = foo()
baz()
```

Ở ví dụ trên, khi thực thi, function foo trả về một function object, chính là tham chiếu đến function bar, ta gán nó vào biến baz. Thực thi function baz thực chất là gọi đến function bar, ta thấy rằng bar được thực thi ở ngoài lexcial scope mà nó được khai báo.

Sau khi foo được thực thi, thông thường toàn bộ scope bên trong foo được xóa bỏ để tránh lãng phí bộ nhớ, bởi function foo không còn được sử dụng. Tuy nhiên closure ngăn điều này xảy ra. Bởi bar có lexical scope vượt ra ngoài scope của foo, và vì bar vẫn còn sử dụng nên scope này vẫn được giữ và bar có thể tham chiếu đến bất cứ lúc nào. Khả năng tham chiếu này chính là closure.

Scope là khái niệm nền tảng quan trọng trong javascript, cũng như rất cần thiết để ta tiếp cận các chủ đề nâng cao hơn. Qua bài viết hy vọng các bạn hiểu hơn về scope và các khái niệm xung quanh nó.