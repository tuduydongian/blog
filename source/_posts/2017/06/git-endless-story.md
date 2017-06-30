---
title:      Git, những niềm đau
date:       2017-06-30
categories: tools
tags:
    - git
---
Lưu ý bé xíu xíu: Đây là bí kíp tương tự Quỳ Hoa Bảo Điển, đọc xong vẫn ăn hành với git xin hãy tự cung! Cấm có gọi 
Dzung thêm 1 lần nào nữa...
<!--more-->
#### 1. Git là gì?
Ngày xửa ngày xưa, khi các lão đại trong làng coding sau khi vật vã với sao chép code khi team work cũng như 
quản lý source của team thì các bác mới nghĩ ra các tools VSC (version source control) giúp việc quản lý source dễ 
dàng hơn bao giờ hết.Git là một trong nhũng tool thần thành ấy. Sâu xa hơn về git thì em cũng ứ biết đâu.

#### 2. Các khái niệm cần biết ở trong git?

- Repository: Repository có thể được hiểu như thư mục chứa source code, khi clone project từ trên git server tức là 
    bạn đang tạo một bản sao của remote repository ở trên local và được hiểu là local repository.
- Branch: Branch là nhánh phát triển của project. Một project có thể có nhiều branch được phát triển đồng thời giúp 
    tiến độ phát triển project nhanh hơn.
- Master: Đây là branch chính chứa version code đúng nhất của project và được protected. Thường thì không được 
    commit trực tiếp vào master.
- Commit: Đánh dấu lưu lại toàn bộ thay đổi nằm trong vùng staging vào branch.
- Merge: Ở đây có thể hiểu là gộp branch hiện tại với 1 branch khác, update những commit còn thiếu ở branch kia vào
     branch hiện tại.
- Checkout: Chuyển từ branch hiện tại sang một branch khác đã có sẵn hoặc một branch mới. Nếu là branch mới, code 
    của branch sau khi checkout sẽ giống với branch làm việc. Toàn bộ thay đổi nếu chưa commit thì sẽ chuyển sang branch
    mới. Branch cũ sẽ trở về trạng thái của lần commit gần nhất.
- Pull là kéo toàn bộ code của remote repository về local repository.
- Push là đẩy những code đã commit ở local repository lên branch hiện tại ở trên remote server.

#### 3. Enguys git workflow
Bước 1: Clone project về local bằng command : `git clone địa_chỉ_repository`

Bước 2: Để thêm một tính năng mới hay fix bug, ta checkout ra 1 branch mới bằng command `git checkout -b tên_branch`.
Nếu branch đi kèm với issue thì nên tên branch nên kèm thêm id của issue. Vd như:
```
git checkout -b 69-fix-bug-created-by-dzung
```
Như vậy sau khi merge branch vào master, issue sẽ tự động close.

Bước 3: Sau khi hoàn thành công việc, chúng ta sẽ commit code và push lên remote server và tạo merge request. 
Thực ra, trước hoàn thành chúng ta cũng nên thường xuyên đẩy code lên thường xuyên để reviewer dễ review code
cũng như là đề phòng lỡ tay làm mất code trên local còn có để back up. Các thao tác để đẩy code lên origin:

- Sử dụng lệnh `git add path_của_file` để thêm toàn bộ thay đổi vào staging. Để add toàn bộ ta sử dụng dấu `.` thay 
    cho tên file
     Commit toàn bộ thay đổi bằng lệnh `git commit -am "commit message"`. Nếu commit riêng từng file sử dụng lệnh 
    `git commit -m path_của_file "commit message"`
- Sử dụng lệnh `git push origin tên_branch` để đẩy code lên remote origin. Nếu trong lần commit đầu sử dụng thêm 
    thuộc tính -u thì sẽ up stream branch hiện tại với branch ở trên origin. Các lần sau chỉ cần sử dụng lệnh `git push`
    để đẩy code lên. 
    
Bước 4: Sau n lần bị chặt chém bởi reviewer, team sẽ đi đến quyết định merge branch hiện tại vào master. Trước khi merge,
chúng ta phải gộp toàn bộ commit lại thành 1 commit để dễ dàng quản lý project. Để gộp toàn bộ thành 1 commit 
đẹp ta làm theo những bước sau:
 
- Checkout master và pull code mới nhất về 
- Merge master vào branch hiện tại để chắc chắn code hiện tại không cách master quá xa 
- Sử dụng lệnh `git reset origin/master` để reset lại những commit thay đổi khác với master
- Add toàn bộ thay đổi vào bằng lệnh `git add .`
- Commit toàn bộ thay đổi với 1 message thật có tâm 
- Do branch ở local khác số commit ở branch remote nên chúng ta sẽ sử dụng lệnh `git push -f` để thay đổi 
    branch ở trên remote giống ở local

Bước 5: Sau khi branch hiện tại được merge vào master, chúng ta pull master mới nhất về và xử lý task mới như 
từ bước 2 trở đi.
    
#### 4. Những lưu ý nho nhỏ khi dùng git  

- Conflict: Là trường hợp người cùng làm việc trên 1 file hoặc 2 branch đều sửa chung 1 file. Như thế git sẽ
không biết nhận sự thay đổi nào. Lúc này nên solve bằng tay để tránh code lỗi hoặc mất code. Để tránh conflict,
nên tránh làm việc trên cùng 1 file. Nếu có hãy pull về trước khi push code.
- Commit message không có tâm: Lúc mới vào, do lười nghĩ nên commit message của Dzung thường xuyên là ".". Sau 
một lần Dzung phải lục vào đống message "." của bản thân để tìm đoạn code  cần thì Dũng đã biết commit có tâm 
hơn. Vì vậy hãy commit có tâm, đừng để đồng đội khổ. Đừng như Dzung!
- Update master ngay lúc có branch khác được merge vào master.
- Xem git graph để xem vị trí của branch hiện tại so với master thường xuyên.
- Gọi người có khả năng trước khi mọi chuyện đi quá xa ngoài tầm kiểm soát.