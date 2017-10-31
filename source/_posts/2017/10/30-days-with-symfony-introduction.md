title:      [ 30 ngày với symfony ] - Giới thiệu va cai dat
date:       2017-09-18
categories: symfony
tags:
  - 30 days with symfony
--------
Thật tình cờ và thật bất ngờ, trong khi lượn lờ tìm đọc các bài viết của symfony để hướng dẫn cho một cậu bạn thì cháu đã bắt găp series ` 30 ngày với symfony` ở phiên bản 1.*. Các bài viết này đã khá lỗi thời  .. và thực sự là không hiểu gì luôn. Điều này đã nảy sinh ra ý tưởng viết lại series này theo cách của cháu với phiên bản mới hơn.
` 30 ngày với Symfony by Chi` là series các bài viết cơ bản dành cho các bạn mới làm quen với Symfony và sẽ follow theo `symfony demo`.

### Giới thiệu về Symfony Flex

Symfony Flex là cách tổ chức code mới của Symfony, sử dụng phiên bản 3.3 trở lên. Hiện nay bản chuẩn và ổn định hơn vẫn là Symfony Standard, nhưng khi ra bản 4.0 thì nó sẽ được thay thế bởi Symfony Flex. 

### Kéo project và cấu hình

`Ps: nhớ cài composer trước nhé`

```
composer create-project "symfony/skeleton:^3.3" 30-days-with-symfony
```

Project:

![](images/symfony-flex.png)


```
composer update

composer install
```
Cài webserver
```
composer req webserver
```

Cài cli
``` 
composer req cli
```

Chạy thử để kiểm tra
``` 
sf server:run
```

Ok. Vậy là bước ban đầu đã xong. Hẹn mọi người vào bài viết sau ` Cấu hình database và sơ lược về ORM và Doctrine `.