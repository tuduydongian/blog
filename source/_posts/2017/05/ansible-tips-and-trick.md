---
title:      Ansible - tips and tricks
date:       2017-05-29
summary:    Vài tips và trick nhỏ nhỏ để tăng độ sướng khi dùng ansible
categories: devops
tags: 
  - tips
  - ansible
---
### Deal with known hosts  
Thỉnh thoảng anh em sẽ thấy vài task ansible (ví dụ clone git, rsync...) đứng hình. Đơn giản là nó đòi xác thực cái server đang connect đến.  
Có option trong ansible để disable check known host nhưng có 1 cách đơn giản hơn là làm 1 cái task, server nào của mình thì tự fetch và add known host vào. 

```yaml
tasks: 
  - known_hosts: path=/home/user/.ssh/known_hosts name='my.server.com' key="{{ lookup('pipe', 'ssh-keyscan -t rsa my.server.com') }}"
```

### Deal with vault 
Thường thường thì một project sẽ có nhiều secret key và mình không nên commit vào trong code. Để giấu nó đi thì ta dùng vault.  
Tuy nhiên hơi khoai tí là file vault thì toàn bộ mã hoá và mỗi lần mở vault ra hơi mệt. Có 1 rule khá đơn giản, ví dụ bạn cần mã hoá 
biến mysql_db_password thì bạn sẽ đặt 1 biến tương ứng trong file vault là: vault_mysql_db_password.   
Cấu trúc thư mục sẽ như sau:  
```
-- group_vars 
---- all  
------ all.yml 
------ vault.yml 
```

Trong file all.yml  
```yaml
mysql_db_password: "{{ vault_mysql_db_password }}"
```

Trong file vault.yml  
```yaml
vault_mysql_db_password: rat_dai_va_rat_kho_nho
```

### Multiple environment  
Có nhiều cách để setup multiple environement trong ansible. Và mình thường follow theo cách đặt tên inventory trùng với environment.  
Ví dụ bạn có 2 environment là: prod và dev  
Cấu trúc thư mục:  
```
# inventory  
-- prod 
-- dev
-- group_vars  
---- all.yml # các biến dùng chung 
---- prod # các biến cho prod env 
------ prod.yml 
------ vault.yml 
---- dev # các biến cho dev env 
------ dev.yml 
------ vault.yml 
```

Nội dung của file inventory sẽ cần có thêm env, ví dụ cho prod:  
```
[db]
192.168.1.3
[prod:children]
db 
[prod:vars]
ansible_python_interpreter=/usr/bin/python2.7
```

Để chạy 1 playbook cho prod environment:  
```
ansible-playbook -i prod dbserver.yml
```

### SSH Bastion Host 
Nếu infrastructure của bạn nằm toàn bộ trong private và vẫn muốn bảo mật như vậy nếu chạy ansible thì sẽ cần xài SSH bastion host.  
Ý tưởng là mình sẽ có 1 cháu server làm vai trò bastion host. Toàn bộ các cháu trong private sẽ cho cháu này kết nối qua ssh. Và chỉ riêng mình cháu này có kết nối mạng với bên ngoài.  
Làm cách này thì bạn sẽ yên tâm là không bao giờ ssh trực tiếp được vào production và gõ nhầm command (dại khái như rm -rf /).  
Để làm cái này thì cấu hình ansible của bạn sẽ cần thêm 2 files: ssh.cfg và ansible.cfg    
```
# ansible.cfg
[ssh_connection]
ssh_args = -F ssh.cfg
control_path = ~/.ssh/mux-%r@%h:%p
```

```
# ssh.cfg
Host 192.168.1.*
  ProxyCommand           ssh -W %h:%p user@bastion.host

Host *
  ControlMaster          auto
  ControlPath            ~/.ssh/mux-%r@%h:%p
  ControlPersist         15m
```

Nếu anh em có prod và dev env nằm ở 2 private network khác nhau và setup env theo phương án ở phía trên thì có thể tweak ssh.cfg 
cho từng bastion host khác nhau dựa vào dải ip được nhé  
```
# ssh.cfg
Host 192.168.1.*
  ProxyCommand           ssh -W %h:%p user@bastion.host

Host 10.0.0.*
  ProxyCommand           ssh -W %h:%p user@prod_bastion.host
```

Gần 2 năm làm với ansible mình rút ra được chừng này. Khi nào nhớ ra thêm thì bổ sung tiếp.  
Anh em có tips hoặc tricks nào hay ho nữa thì merge request nhé ;) 