---
title: Async/Await trong javascript
date: 2017-11-23
categories: javascript
tags: js async 
---
Async/Await là kỹ thuật xử lý bất đồng bộ từ ECMAScript 2016 (ES7).
<!--more -->
## Đồng bộ và bất đồng bộ

Trước khi tìm hiểu về async/await, ta cần nắm được khái niệm về đồng bộ và bất đồng bộ trong javascript.
Đông bộ là khi 1 đoạn code được thực thi xong và trả về kết quả, đoạn code tiếp theo mới được thực thi.

```
A-Start ----------------------- A-End
                                       B-Start ---- B-End
```

Ngược lại với đồng bộ, bất đồng bộ nghĩa là xen vào giữa quá trình thực thi 1 đoạn code, chương trình có thể thực thi 1 hoặc nhiều đoạn code khác.

```
A-Start----------------------- A-End
        B-Start ---- B-End    
```

Ở ví dụ trên A và B không thực thi đồng thời, bởi javascript chỉ có 1 thread duy nhất nên tại 1 thời điểm, chỉ có 1 đoạn code được thực thi. Ở đây, A bắt đầu thực thi, A gọi đến 1 thao tác non-blocking, B được gọi, B kết thúc, thao tác non-blocking trả kết quả cho A, A tiếp tục thực thi. Thao tác non-blocking trong javascript thường là các thao tác vào ra như đọc ghi file, đọc ghi database, truyền nhận dữ liệu qua http, ...

```javascript
let data;
$.get("example.com", (response) => {
    data = response;
});
console.log(data);
```

Kết quả thu được sẽ là undefined, bởi sau khi send request đến example.com, chương trình tiếp tục thực thi và in ra data lúc này vẫn chưa gán giá trị. Câu lệnh gán 'data = response' chỉ được gọi khi có response trả về.
Thay vào đó để in được ra kết quả trả về

```javascript
let data;
$.get("example.com", (response) => {
    data = response;
    console.log(data);
});
```

Đoạn code trên sử dụng callback để xử lý bất đồng bộ. Nhược điểm của callback, hay Promise trong ES6 là đoạn code bất đồng bộ trở nên khó đọc, khó làm quen với người mới bắt đầu. Vì vậy mà async/await ra đời, giúp viết code bất đồng bộ gần tương đồng với những đoạn code đồng bộ thông thường.

## Sử dụng async/await

Một async function được viết dưới dạng

```javascript
async function name([...params]) {
	...
    await somethingAsync;
    ...
}
```

Cú pháp async function khá giống với các function bình thường, ngoại trừ 2 từ khóa async và await. Khi thực thi, async function luôn trả về promise.
Từ khóa async, dùng để chỉ ra 1 function là bất đồng bộ, và cho phép gọi await trong function.
Từ khóa await, đi kèm sau nó là 1 promise, nên sau await ta cũng có thể gọi thực thi 1 async function khác, hoặc 1 api trả về promise.
Async function sẽ thực thi như các function thông thường cho đến khi gặp từ khóa await. Tại đây, async function sẽ trả lại quyền thực thi cho chương trình. Các câu lệnh ở sau await sẽ phải đợi đến khi promise trả về kết quả.

## Một số lưu ý

- Nếu bạn cần gọi 1 promise trong async function và không quan tâm đến kết quả trả về, thì không cần có từ khóa await trước lời gọi promise.

```javascript
    async function name() {
        sendAndForgetAsync;
    }
```

- Sử dụng Promise.all() để tránh thực hiện tuần tự nếu các promise được gọi không ràng buộc nhau

```javascript
    await Promise.all(somethingAsync1, somethingAsync2);
```

Tương tự với vòng lặp

```javascript
    await Promise.all([1, 2, 3].map(x => somethingAsync(x)));
```

- Nên tránh sử dụng async/await kết hợp với forEach

```javascript
const arr = [];
[1, 2, 3].forEach(async (x) => {
    await somethingAsync(x);
    arr.push(x);
});
console.log(arr.length);
```

Kết quả là câu lệnh console.log() sẽ thực hiện trước arr.push(), in ra length của arr là 0. Bởi forEach được chuyển thành 1 vòng lặp thông thường, callback được gọi qua mỗi lần lặp nhưng ta lại không đợi kết quả trả về trước khi sang vòng lặp tiếp theo.