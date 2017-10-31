---
title:      Bảo mật Gitlab với Let's Encrypt 
date:       2017-10-30
categories: devops
tags:
  - gitlab
---
Gitlab có thể được xem là một trong những giải pháp tuyệt vời nhất hiện nay cho các team dev. Bài viết này sẽ hướng dẫn bạn bảo mật Gitlab instance bằng Let's encrypt SSL.  
<!--more -->
Gitlab hiện nay chắc chắn là giải pháp ngon, bổ, rẻ nhất cho team dev. Chỉ với 1 VPS ram 2GB là bạn có thể có 1 environement cho team dev với số lượng projects không hạn chế. Gitlab cung cấp Omnibus Package rất tiện lợi cho việc cài đặt và cập nhật phiên bản mới. Đến giờ này nếu bạn vẫn đang cho truy cập Gitlab instance của bạn qua HTTP thì không phải là `có gì đó sai sai` mà là sai cực kỳ nghiêm trọng. Hãy cố gắng bảo mật cho instance của bạn qua giao thức SSL (HTTPS).  
Trên tinh thần tiết kiệm chi phí tối đa thì mình sẽ hướng dẫn các bạn cấu hình SSL sử dụng Let's Encrypt.  
Nếu bạn chưa biết Let's Encypt là gì thì bạn có thể tham khảo thêm [tại đây](https://letsencrypt.org/). Nôm na thì ngày xưa bạn phải bỏ ít cũng $10/ năm để mua SSL certificate, nay thì với Let's Encrypt, nó là 100% free.  
Bài viết này hướng dẫn bạn dựa trên Ubuntu 16.04  

### Cài cắm Cerbot 
Certbot là Let's Encrypt client, giúp bạn có thể đăng ký cert dễ dàng hơn.  
Thêm certbot PPA:   
```bash
$ sudo add-apt-repository ppa:certbot/certbot
```
Cài certbot: 
```bash 
$ sudo apt-get update && sudo apt-get install certbot -y
```

### Chuẩn bị để verify domain 
Để có thể đăng ký SSL Certificate, thằng Let's Encrypt sẽ cần phải chứng thực mình sở hữu cái domain mà mình muốn đăng ký.  
Có nhiều phương thức để xác thực domain, nhưng mình tư vấn bạn chọn phương pháp xác thực dùng webroot.  
Tại vì sao? đơn giản nếu bạn đang có 1 service chạy port 80 (ví dụ nginx), thì bạn ko cần tắt service đó để đăng ký.  
Tạo thư mục root cho letsencrypt: 
```bash 
$ sudo mkdir -p /var/www/letsencrypt
```
Sửa gitlab config, thêm cấu hình cho nginx: 
```ruby /etc/gitlab/gitlab.rb
nginx['custom_gitlab_server_config'] = "location ^~ /.well-known { root /var/www/letsencrypt; }"
```
Xong xuôi thì mình cần cập nhật lại cấu hình cho gitlab:  
```bash 
$ sudo gitlab-ctl reconfigure
```

### Đăng ký Certificate
Giờ thì chỉ cần gọi certbot dùng phương thức xác thực là webroot
```bash 
$ sudo certbot certonly --webroot --webroot-path=/var/www/letsencrypt -d your_domain
```
Bạn sẽ được hỏi vài câu, tuy nhiên nếu được hỏi email thì bạn cứ điền email nào mà bạn dùng để quản lý infrastructure. 
Khi nào cert gần hết hạn thì bạn sẽ có email thông báo đỡ quên.  
Nếu bạn thấy giao diện thông báo thế này thì mọi việc đã xong:  
```
IMPORTANT NOTES:
 - Congratulations! Your certificate and chain have been saved at
   /etc/letsencrypt/live/your_domain.com/fullchain.pem. Your cert
   will expire on 2017-10-30. To obtain a new or tweaked version of
   this certificate in the future, simply run certbot again. To
   non-interactively renew *all* of your certificates, run "certbot
   renew"
 - If you lose your account credentials, you can recover through
   e-mails sent to john@example.com.
 - Your account credentials have been saved in your Certbot
   configuration directory at /etc/letsencrypt. You should make a
   secure backup of this folder now. This configuration directory will
   also contain certificates and private keys obtained by Certbot so
   making regular backups of this folder is ideal.
 - If you like Certbot, please consider supporting our work by:

   Donating to ISRG / Let's Encrypt:   https://letsencrypt.org/donate
   Donating to EFF:                    https://eff.org/donate-le
```
Let's Encrypt sẽ tạo cho bạn 4 file trong thư mục /etc/letsencrypt/live/your_domain.com:  
```
cert.pem  chain.pem  fullchain.pem  privkey.pem
```
Để cấu hình nginx thì ta chỉ cần quan tâm đến `fullchain.pem` và `privkey.pem`  

### Cấu hình Gitlab dùng Certificate vừa tạo  
```ruby /etc/gitlab/gitlab.rb 
# thay đổi url dùng giao thức SSL 
external_url 'https://your_domain.com'

# sửa cấu hình nginx 
nginx['redirect_http_to_https'] = true
nginx['ssl_certificate'] = "/etc/letsencrypt/live/your_domain.com/fullchain.pem"
nginx['ssl_certificate_key'] = "/etc/letsencrypt/live/your_domain.com/privkey.pem"
```

Giờ bạn cần cập nhật lại cấu hình cho gitlab:
```bash 
$ sudo gitlab-ctl reconfigure
```
Giờ bạn thử truy cập vào https://your_domain.com xem đã nhận certificate mới chưa nhé <3  

### Cấu hình gia hạn certificate tự động  
Tại thời điểm hiện tại thì certificate của Let's Encrypt chỉ có thời hạn sử dụng là 90 ngày.  
Sẽ hơi phiền và dễ quên để gia hạn. Và nếu bạn cũng lười như mình thì tốt nhất cứ để máy tính làm.  
Đơn giản thôi, chỉ cần tạo 1 crontab:  
```bash 
sudo crontab -e
```
Thêm config sau: 
```
0 */12 * * * root perl -e 'sleep int(rand(3600))' && /usr/bin/letsencrypt renew --renew-hook="/usr/bin/gitlab-ctl hup nginx" >> /var/log/letsencrypt-renew.log
```

P/s: mình nhắc lại là nếu hiện tại Gitlab của bạn vẫn được truy cập qua giao thức HTTP thì `cực kỳ nghiêm trọng` và các bạn nên bảo mật instance của mình bằng SSL sớm nhất có thể nhé ;) 
