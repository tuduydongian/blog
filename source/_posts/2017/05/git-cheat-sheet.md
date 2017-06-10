---
title:      Git cheat sheet for beginer
date:       2017-05-28
summary:    Các lệnh git cần nhớ để khỏi ăn hành với git
categories: tools
tags: 
    - git 
    - cheatsheet
---

| Command| Chức năng| Lưu ý|
| ---| ---| ---|
|`git clone path-to-repository`| Tạo clone của một repository lên thư mục đang đứng| Nên config ssh key cho để sử dụng git thuận tiện hơn|
|`git add tên-file`| Thêm trạng thái thay đổi hiện tại cho lần commit tiếp theo| `git add .` thêm toàn bộ file thay đổi|
|`git commit -am "Commit message"`| Commit toàn bộ file đã add vào kèm commit message||
|`git push`| Đẩy những commit sau lần push trước lên branch ở origin| Nên pull trước để update thay đổi ở origin branch. Hạn chế sử dụng `git push -f`. Thao tác này sẽ thay đổi toàn bộ branch ở trên server giống với branch ở local.|
|`git pull`| Update toàn bộ những thay đổi của branch ở trên server||
|`git status`|Xem danh sách thay đổi mà bạn cần add hoặc commit | Khuyến khích thường xuyên xem git status để đỡ ngậm hành |
|`git checkout -b branch-foo`| Tạo mới branch tên là branch-foo từ branch đang đứng và chuyển sang branch-foo|Những thay đổi chưa commit sẽ chuyển sang branch-foo|
|`git checkout branch-foo`| Chuyển sang branch có tên là branch-foo| | 
|`git branch`| Liệt kê ra toàn bộ branch trên repository và chỉ ra branch mình đang đứng||
|`git branch -d branch-foo`| Xoá branch có tên là branch-foo|| 
|`git push origin branch-foo`| Đẩy branch có tên là branch-foo lên remote repository||
|`git fetch origin`| Cập nhật origin ở remote||
|`git reset origin/master`| Reset toàn bộ commit ở branch hiện tại giống với trạng thái của branch master| Nhưng thay đổi vẫn được giữ nguyên nhưng chưa được add và commit vào|
|`git reset --hard`| Bỏ hết toàn bộ những thay đổi chưa được commit||
|`git merge branch-foo`| Merge branch hiện tại với branch có tên là branch-foo| Nên sử dụng chức năng merge để solve conflict|

[Hướng dẫn tạo ssh key và add to git account](https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/)