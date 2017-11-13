---
title:      Terminal Cheat Sheet
date:       2017-08-31
categories: tools
tags: 
  - terminal 
  - cheatsheet
---
Terminal gần như là 1 tools không thể thiếu trong công việc hàng ngày của một lập trình viên. 
Mình là 1 fan cuồng của terminal nhưng trí nhớ không được tốt lắm, dẫn đến cực kỳ hay quên lệnh. 
Bài viết này chủ yếu note lại các tools mình hay dùng, các commands cần thiết, ít dùng, dễ quên, khi cần toàn phải search. Có gì hay ho thì các bạn cứ merge request nhé 
<!-- more -->
### Cheatsheet 

##### Muốn lục lại 1 lệnh đã gõ nhưng chỉ nhớ mang máng? 
```
$ history | grep keyword
```
Ví dụ: `history | grep 'git commit'`  

##### Gen ssh key 
```
$ ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
```

##### Tunnel một port qua server trung gian 
``` 
# vào port 22 của server 10. thông qua server 139.
$ ssh -L 22:10.10.56.30:2022 -N root@139.69.60.20
# tiếp tục ssh vào sau khi đã tunnel 
$ ssh root@localhost -p 2022 
```

##### Xem xem domain phân giải thế nào, đã thông hết chưa 
``` 
$ dig google.com +trace 
```

##### Generate nginx password 
```bash
# thay sammy bằng username muốn tạo 
$ sudo sh -c "echo -n 'sammy:' >> /etc/nginx/.htpasswd"
$ sudo sh -c "openssl passwd -apr1 >> /etc/nginx/.htpasswd"
```

#### Mysql 
##### Backup 1 database 
```
$ mysqldump -u username -pPassword dbname > /path/to/file.sql 
```
#### Restore database 
```
$ mysql -u username -pPassword dbname < /path/to/file.sql 
```

### Tools 
#### Oh my ZSH 
Download: http://ohmyz.sh/  
Zsh thì khỏi nói về độ thần thánh. Bổ sung màu mè cho đẹp, autocomplete thông minh, cơ số plugin để hiện đại hoá terminal.   

#### Gopass 
Download: https://www.justwatch.com/gopass/  
Thường nếu bạn quản trị hệ thống nhiều thì lưu trữ password là việc khá đau đầu. Lưu trong file text thì rõ ràng là cực kỳ không an toàn. Gopass cho phép bạn lưu trữ password, mã hoá bằng GPG key, lưu trữ dùng git nên rất tiện, nhất là trường hợp cần share cho team. 

#### Mycli 
Download: https://www.mycli.net/  
Nếu bạn không thích dùng UI để connect đến mysql mà thích dùng terminal thì tools này đảm bảo bao phê. Autocomplete, syntax highlight, pager, còn cần gì hơn nữa :D  

#### Httpie 
Download: https://httpie.org/  
Nếu bạn thường xuyên dev api và thì bạn cũng biết CURL củ khoai thế nào, mình gần như không thể nhớ nổi mấy cái command của CURL. Httpie có thể nói là life saver.  

#### Jq 
Download: https://stedolan.github.io/jq/  
Httpie vẫn có 1 điểm yếu khi response trả về rất dài thì việc cuộn và kiểm tra data trong đống đó không thể nào tiện bằng UI (ví dụ Postman). Tool JQ này khá đơn giản, bổ trợ luôn cho bạn query data trong json để chỉ hiển thị hoặc format cho đẹp response.  
