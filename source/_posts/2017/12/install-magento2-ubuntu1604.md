---
title:      Install Magento 2 on Ubuntu 16.04
date:       2017-12-25
categories: php
tags:
  - tips
---

Đây là tutorial cài đặt Magento Community Edition (Magento Open Source) ver 2.2 với Nginx trên hệ điều hành Ubuntu 16.04.

Tùy theo mục đích sử dụng mà có [các cách start khác nhau để setup Magento](http://devdocs.magento.com/guides/v2.2/install-gde/bk-install-guide.html). Mục tiêu của mình khi làm việc với Magento là dev custom module & theme nên hướng cài đặt sẽ là `Integrator`.

<!-- more -->

### Prerequisites

- [Authentication keys](http://devdocs.magento.com/guides/v2.2/install-gde/prereq/connect-auth.html)
- [PHP 7.1 modules](http://devdocs.magento.com/guides/v2.2/install-gde/prereq/php-ubuntu.html)
- MySql
- Composer

### Get the Magento Open Source metapackage

Chuyển tới thư mục bạn muốn cài đặt Magento (giả định của bài viết này là `/projects`) và run command:

```bash
composer create-project --repository-url=https://repo.magento.com/ magento/project-community-edition magento2
```

Nhập authention keys của bạn.

- Username: public key
- Password: private key

Composer sẽ tiến hành tạo project `magento2` và downloads các dependencies. Bây giờ project của chúng ta sẽ có đường dẫn là `/projects/magento2`.

### Add user to www-data group

Ta sẽ tiến hành setup để `web server` và `file system owner` (ở local là chính là user hiện tại mà bạn đang login) đều có quyền write files & create directories (để Magento có thể compile code, write cache,...).

Note: ở đây ta sẽ dùng `$(whoami)` thay cho username phòng trường hợp bạn không biết username hiện tại của mình.

- Add user `$(whoami)` vào group `www-data`. Sau khi thực hiện thao tác này, bạn nên re-login hoặc restart máy để environment nhận được cập nhật.

```bash
sudo usermod -a -G www-data $(whoami)
```

- Kiểm tra:

```bash
groups $(whoami)
```

Nếu kết quả hiển thị có `www-data` trong list groups là ok.

```bash
$(whoami): foo www-data bar
```

### Set ownership and permissions for the shared group

Run các commands sau tại root của project (`/projects/magento2`):

```
find var generated vendor pub/static pub/media app/etc -type f -exec chmod g+w {} \;
find var generated vendor pub/static pub/media app/etc -type d -exec chmod g+ws {} \;
sudo chown -R :www-data .
chmod u+x bin/magento
```

### Add magento path (Optional)

Bạn nên add `magento bin` vào path để thao tác với Magento được thuận tiện hơn. Add thêm dòng sau vào file: `~/.profile` và re-login

```bash
export PATH=$PATH:/projects/magento2/bin
```

Từ bây giờ bạn có thể sử dụng binary `magento` trực tiếp thay vì `/projects/magento2/bin/magento`. Kiểm tra:

```bash
source ~/.profile # nếu bạn chưa re-login

magento
```

### Nginx configuration

Tạo file conf của nginx:

```bash
sudo nano /etc/nginx/sites-enabled/magento.conf
```

với nội dung như sau:

```bash
upstream fastcgi_backend {
  server   unix:/var/run/php/php7.1-fpm.sock;
}

server {
  listen 80;
  server_name mage.local; # địa chỉ truy cập: http://mage.local hoặc mage.local
  set $MAGE_ROOT /projects/magento2; # đường dẫn tới project root
  include /projects/magento2/nginx.conf.sample; # include nginx.conf.sample từ project root
}
```

Sau khi hoàn thành, tiến hành restart Nginx: (hoặc reload)

```bash
sudo service nginx restart
```

### Edit hosts file

Sửa file hosts trỏ `mage.local` vào `localhost`

```bash
sudo nano /etc/hosts
```

Thêm `mage.local` vào phía sau dải `localhost`

```bash
127.0.0.1       localhost foo.local mage.local
```

### Create database

Tiến hành tạo database với name là `magento2` (bạn có thể grant thêm quyền nếu muốn, vì ở môi trường dev nên mình thường dùng luôn tài khoản `root`).

```bash
mysql -u root -p
```

```bash
create database magento2;
exit;
```

### Install

Tới đây bạn có thể tiến hành cài đặt Magento theo 2 cách:

#### Setup Wizard

Mở trình duyệt và access vào url `mage.local` và tiến hành cài dặt.

Đây là cách mà mình khyến nghị, bởi vì:

- Dùng UI các thông số rõ ràng, giao diện trực quan.
- Khi setup với command line, đường dẫn tới admin luôn kèm theo đoạn token phía sau, vd: `mage.local/admin_foobar` (có thể sửa lại sau này). Với UI có thể handle được admin access url (bạn có thể truy cập vào admin với đường dẫn đẹp: `mage.local/admin`)

#### Command line

Nếu vẫn muốn sử dụng command line thì command bạn cần chạy có dạng như sau:

```bash
magento setup:install --base-url=http://mage.local --db-host=localhost --db-name=magento --db-user=root --db-password=mypassword --admin-firstname=Admin --admin-lastname=Super --admin-email=admin@example.com --admin-user=admin --admin-password=admin123 --language=en_US --currency=USD --timezone=America/Chicago --use-rewrites=1
```

Tham khảo thêm các options: http://devdocs.magento.com/guides/v2.2/install-gde/install/cli/install-cli-install.html

### Enable developer mode

Khi dev ở local, bạn cần chuyển qua developer mode. Các lợi ích mà nó đem lại bạn có thể xem ở đây: http://devdocs.magento.com/guides/v2.2/config-guide/bootstrap/magento-modes.html

```bash
magento deploy:mode:show
magento deploy:mode:set developer
```

### Install sample data

Nếu là lần đầu làm quen với Magento, bạn có thể install sample data và đi dạo vòng quanh để hiểu thêm về hệ thống.

```bash
magento sampledata:deploy
```

Done! Quá trình cài đặt của bạn đã hoàn tất. Việc của bạn bây giờ là nuốt hành với Magento. Good luck!
