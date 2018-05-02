---
title:      JSON Web Tokens
date:       2018-04-10
categories: backend
tags:
  - jwt
---
JSON Web Token (JWT) là một tiêu chuẩn để truyền thông tin an toàn dưới dạng JSON object, được định nghĩa tại https://tools.ietf.org/html/rfc7519. Thông tin bên trong được xác thực bởi chữ ký số.
<!--more -->

JWT thường được sử dụng để xác thực người dùng. Ta cùng xem xét kịch bản sau để thấy cách JWT hoạt động.

Hệ thống gồm 3 thực thể chính là người dùng, máy chủ xác thực và máy chủ ứng dụng.

![](/images/jwt-01.png)

Người dùng trước tiên đăng nhập vào hệ thống bằng thông tin đăng nhập. Máy chủ xác thực có nhiệm vụ kiểm tra thông tin người dùng, đồng thời trả về một chuỗi JWT. Từ đây, mỗi lần người dùng thực hiện một lời gọi API tới máy chủ ứng dụng đều đính kèm theo chuỗi JWT. Máy chủ ứng dụng sẽ kiểm tra rằng liệu chuỗi JWT có được tạo ra bởi máy chủ xác thực, từ đó biết được người dùng có hợp lệ hay không.

### Cấu trúc của JWT

JWT bao gồm 3 thành phần, cách nhau bằng dấu chấm (.):

* Header
* Payload
* Signature

Ta cùng đi vào chi tiết từng thành phần

**Header**
Header bao gồm 2 thành phần: Kiểu của token, ở đây là JWT; và thuật toán dùng để mã hóa (HMAC, RSA)

```
{
  "alg": "HS256",
  "typ": "JWT"
}
```

Sau khi mã hóa object trên bằng Base64, ta được thành phần đầu tiên của JWT.

```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9
```

**Payload**
Payload là object chứa thông tin cần trao đổi, bạn có thể đặt bất cứ thông tin nào vào đây, 

```
{
  "name": "John",
  "admin": true
}
```

Tương tự, payload cũng được mã hóa bằng Base64.

```
eyJuYW1lIjoiSm9obiIsImFkbWluIjp0cnVlfQ
```

**Signature**
Là thành phần cuối cùng của JWT, dùng để xác minh tính xác thực của nguồn dữ liệu, như trong ví dụ ở phần đầu, thì chữ ký dùng để kiểm tra liệu JWT được tạo ra bởi máy chủ xác thực. Chữ ký được tạo thành bằng cách mã hóa chuỗi tạo bởi header và payload với thuật toán mã hóa được khai báo ở header.

```
data = base64urlEncode( header ) + “.” + base64urlEncode( payload )
signature = Hash( data, secret );
```

Ví dụ với secret là 'mysecret', ta được singature là:

```
Cqt0aaqownd82rRw-b93uF9OAwen1xMCvvypRSeIitE
```

Kết hợp 3 thành phần trên ta được chuỗi JWT hoàn chỉnh.

```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1lIjoiSm9obiIsImFkbWluIjp0cnVlfQ.Cqt0aaqownd82rRw-b93uF9OAwen1xMCvvypRSeIitE
```

Từ cấu trúc của JWT, dễ thấy thông tin trong JWT không được ẩn đi, mà có thể xem bởi bất cứ ai. Với những thông tin bí mật, ta cần mã hóa nó trước khi sử dụng JWT, bởi mục đích của việc sử dụng JWT là để xác thực nguồn gốc, độ tin cậy của thông tin.

Để xác minh JWT được tạo bởi đúng nguồn, người xác minh cần biết được thuật toán dùng để mã hóa, như ở trên là HS256, cũng như khóa bí mật của thuật toán.

Như vậy qua bài viết này, ta hiểu được JWT là gì, cách thực để tạo và xác thực JWT, cũng như cách thức JWT được sử dụng trong thực tế.