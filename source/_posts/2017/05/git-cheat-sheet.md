---
title:      Git cheat sheet for beginer
date:       2017-05-28
summary:    Các lệnh git cần nhớ để khỏi ăn hành với git
categories: tools
tags: 
    - git 
    - cheatsheet
---

#### Git configuration
1. Tạo ssh key 
```bash
$ ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
```
2. Cấu hình user và email
```
$ git config --global user.name "Your Name"
$ git config --global user.email "your_email@example.com"
```

#### Day-to-day Work
- Xem danh sách thay đổi mà bạn cần add hoặc commit. Branch hiện tại đang đứng là gì.   
```
$ git status
```
**Tips**: Khuyến khích thường xuyên xem git status để đỡ ngậm hành.

- Thêm file vào staging.   
```
$ git add <file>
```
**Tips:** `git add .` để thêm toàn bộ các thay đổi ở thư mục hiện tại.   

- Lỡ tay add file, giờ cần gỡ ra khỏi staging  
```
$ git reset <file> 
```

- Commit file đã được staging.
```
$ git commit -m "vừa làm gì thì viết vào" 
```
**Tips**: Commit toàn bộ thay đổi `git commit -am "message có tâm"`  

- Lỡ tay commit, redo để commit lại cho cẩn thận 
```
$ git reset HEAD~
```

- Đẩy toàn bộ file đang dở tay sửa vào stash  
```
$ git stash 
```

- Kéo lại thay đổi từ stash 
```
$ git stash pop 
```
**Tips**: quên mất có những cái gì trong stash, gõ: `git stash list`   

- Clear stash 
```
$ git stash drop
```

- Sửa file chán chê, giờ muốn quay lại trạng thái ban đầu
```
$ git checkout -- <file> 
```
**Tips**: checkout file từ branch khác: `git checkout <branch> -- <file>`  

- Xoá toàn bộ file chưa được track bởi git
```
$ git clean -df 
```
**Tips**: nắn tay 3 lần trước khi gõ. Để xem nó sẽ xoá file gì cho chắc ăn: `git clean -dn`  

- Reset files về lại mốc commit nào đó. Toàn bộ thay đổi giữ nguyên như chưa từng commit. 
```
$ git reset <branch> 
```
**Tips**: Muốn reset về master của server: `git reset origin/master`. Xài cái này để làm thành 1 commit đẹp chuẩn bị merge vào master. 

- Reset về mốc commit nào đó. Xoá hết toàn bộ thay đổi. 
```
$ git reset --hard 
```
**Tips**: cực kỳ cẩn thận khi gõ. Chỉ dùng khi muốn xoá hết làm lại từ đầu.  


| Command| Chức năng| Lưu ý|
| ---| ---| ---|
|`git clone path-to-repository`| Tạo clone của một repository lên thư mục đang đứng| Nên config ssh key cho để sử dụng git thuận tiện hơn|
|`git push`| Đẩy những commit sau lần push trước lên branch ở origin| Nên pull trước để update thay đổi ở origin branch. Hạn chế sử dụng `git push -f`. Thao tác này sẽ thay đổi toàn bộ branch ở trên server giống với branch ở local.|
|`git pull`| Update toàn bộ những thay đổi của branch ở trên server||
|`git checkout -b branch-foo`| Tạo mới branch tên là branch-foo từ branch đang đứng và chuyển sang branch-foo|Những thay đổi chưa commit sẽ chuyển sang branch-foo|
|`git checkout branch-foo`| Chuyển sang branch có tên là branch-foo| | 
|`git branch`| Liệt kê ra toàn bộ branch trên repository và chỉ ra branch mình đang đứng||
|`git branch -d branch-foo`| Xoá branch có tên là branch-foo|| 
|`git push origin branch-foo`| Đẩy branch có tên là branch-foo lên remote repository||
|`git fetch origin`| Cập nhật origin ở remote||
|`git reset origin/master`| Reset toàn bộ commit ở branch hiện tại giống với trạng thái của branch master| Nhưng thay đổi vẫn được giữ nguyên nhưng chưa được add và commit vào|
|`git merge branch-foo`| Merge branch hiện tại với branch có tên là branch-foo| Nên sử dụng chức năng merge để solve conflict|