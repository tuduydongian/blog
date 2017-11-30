---
title:      PHP Type hinting
date:       2017-11-13
categories: php
tags:
  - best practice
---
Có thể bạn đã biết, tự cổ chí kim, PHP luôn được dành những cái nhìn đầy ác cảm từ các lập trình viên `Java` hoặc `.Net`. Một trong những lý do đặc trưng chính là việc định kiểu lỏng lẻo (mixed), không nhất quán, phụ thuộc vào giá trị được gán. Và sau vài lần releases thì tới PHP 7.x, `Type Declarations` và `Return type declarations` ra đời đã giải quyết gần như triệt để vấn đề này.

<!-- more -->
Để tránh nêu đi nêu lại mớ kiến thức rõ ràng, bạn vui lòng xem về `Type Declarations` (thực chất là bản upgrade của cái tên thân thiện hơn từ PHP 5.x là `Type Hints`) và `Return type declarations` đã được giới thiệu rất chi tiết tại đây: 
- http://php.net/manual/en/functions.arguments.php#functions.arguments.type-declaration
- http://php.net/manual/en/functions.returning-values.php#functions.returning-values.type-declaration

Note: từ giờ mình xin gọi ngắn gọn bộ combo `Type Declarations` và `Return type declarations` là `Type hinting`.

### Tại sao nhất định phải dùng Type hinting?
Thỉnh thoảng mình có nhận trách nhiệm review code của đồng nghiệp, và cái mà mình thường nhắc nhở các bạn chính là vấn đề về `Type hinting`. Thử tưởng tượng bạn thấy một hàm như thế này:

```php
function readFile($filename);
```

Tên hàm là `readFile`, rất là readable. Vậy giờ gọi hàm này như thế nào?

`$filename` là đường dẫn tuyệt đối?

```php
readFile('/path/to/file.txt');
```

hay là file handle?

```php
readFile(fopen('/path/to/file.txt', 'r'));
```

hay là 1 class wrapper:

```php
readFile(new UploadedFle('/path/to/file.txt'));
```

Ok, fine. Nếu không có document, để có thể sử dụng được hàm này, bắt buộc bạn phải đọc code của hàm để biết rốt cuộc `$filename` nó là cái gì. Mọi việc sẽ dễ dàng hơn nếu ta khai báo hàm trên với `Type hinting`:

```php
function readFile(string $filename): string
```
Lợi ích:
- Biết được kiểu của biến truyền vào.
- Biết được kiểu của giá trị trả về.
- Dễ dàng reference variable (Find variable usages).

Vậy liệu `Type hinting` đã thực sự tốt? Theo mình thì chưa nếu đặt cùng trên một bàn cân so với các ngôn ngữ khác như `.Net`, `Golang`, ... Như đã đề cập ở đầu bài viết, sức mạnh hiện tại của `Type hinting` chỉ đủ để `giải quyết gần như triệt để`. Xét case đặc trưng sau:

### Trường hợp định kiểu của array

Với các ngôn ngữ khác, việc định kiểu như sau đây được thực hiện rất dễ dàng, tuy nhiên hiện tại là không thể đối với PHP:

```php
function setTags(array<Tag> $tags);
// usage:
setTags([new Tag(), new Tag()]);

function getPosts(): array<Post>
```

Với hàm `setTags` ta có thể linh động thay đổi 1 tí như sau với variadic arguments (chính xác là nhiều tí vì đầu vào không còn là array nữa):

```php
function setTags(Tag... $tags)
// usage:
setTags(new Tag(), new Tag());
```
Xem thêm: http://php.net/manual/en/functions.arguments.php#functions.variable-arg-list

Tuy nhiên không may là cách trên không áp dụng được với trường hợp `Return type` (và bản thân mình cũng chưa có dịp sử dụng cái cách phía trên nên về cơ bản nhìn nó khá là NGU). Vậy người nông dân phải làm thế nào?

Hiện tại, lựa chọn duy nhất để giải quyết case này là nương nhờ vào `PhpDoc` (docblock) và khả năng đọc hiểu của IDE. Tất nhiên, chương trình của chúng ta sẽ không throw ra Runtime Error nếu kiểu dữ liệu truyền vào bị sai; đây thực sự là `Type hinting` đúng nghĩa:

```php
/**
 * @param Tag[] $tags
 */
function setTags(array $tags);

/**
 * @return Post[]
 */
function getPosts(): array
```

Hi vọng vào lần update tới, PHP sẽ có phương án giải quyết triệt để vấn đề này.

## Conclusion

Túm cái váy lại:
- Nếu có thể dùng Type-hint, BẮT BUỘC phải dùng Type-hint
- Nếu không thể dùng Type-hint, BẮT BUỘC document đầy đủ về kiểu dữ liệu của biến ở docblock
- Trường hợp Type-hint của array, BẮT BUỘC đọc lại đoạn trên nhé :smile:
