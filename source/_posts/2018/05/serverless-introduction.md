---
title: Giới thiệu về serverless 
date: 2018-05-24
categories: backend 
tags:
  - serverless
  - AWS lambda
---

Trong thời gian gần đây, kiến trúc serverless đang là một xu hướng rất hot. Vậy serverless là gì? Vì sao lại chọn serverless? ... Vì Dzung làm đồ án về serverless nên Dzung xin viết một bài ngắn về serverless. Hy vọng mọi người có thể hiểu hơn về serverless thông qua bài viết này.
<!-- more -->
## Serverless là gì?
Để trả lời câu hỏi "serverless là gì?", chúng ta cần nhìn lại về quá trình phát triển của infrastructure.
 
- Vào những năm 1958, cùng với sự bùng nổ của internet là sự ra đời của các ứng dụng web triển khai theo mô hình client-server. Mô hình này đòi hỏi các doanh nghiệp cần phải có một physical để triển khai hệ thống. Các bài toán về chi phí mua server, vận hành, quản lý, bảo trì server là một bài toán khó đối với doanh nghiệp.
- Đến năm 2008, cloud computing xuất hiện đi kèm với mô hình IaaS (Infrastructure as a Service) giúp các doanh nghiệp giải quyết được những bài toán về chi phí ban đầu, chi phí vận hành và bảo trì server. Mô hình này cho phép doanh nghiệp có thể thuê một máy ảo trên cloud mà không cần tốn chi phí phần cứng. Doanh nghiệp sử dụng IaaS chỉ cần tập trung vào việc quản lý infrastructure như nâng cấp hệ điều hành, backup data, ...
- Đến năm 2012, các mô hình PaaS (Platform as a Service) xuất hiện. Việc này giúp các doanh nghiệp không cần giải quyết các vấn đề về quản lý infrastructure nữa. Thay vào đó, doanh nghiệp chỉ cần lựa chọn cấu hình và môi trường phù hợp với ứng dụng và tập trung vào phát triển ứng dụng. Bài toán duy nhất về infrastructure ở PaaS là scale.
- Mô hình serverless xuất hiện và giúp doanh nghiệp giải quyết toàn bộ bài toán về infrastructure. Doanh nghiệp chỉ cần tập trung vào viết code và deploy. Các nhà cung cấp dịch vụ serverless hỗ trợ toàn bộ về infrastructure.

Vậy serverless là gì?
- Serverless không đồng nghĩa với server không tồn tại mà server vẫn tồn tại và được quản lý bởi các nhà cung cấp dịch vụ serverless. 
- Serverless có nghĩa là phát triển ứng dụng mà không cần nghĩ đến các bài toán về Infrastructure như quản lý, scale,...
- FaaS (Function as a Service), mô hình cho phép developer chỉ việc viết code và deploy dưới dạng fuction để chạy mà không cần quan tâm đến infrastucture là một dạng của mô hình serverless.

## Serverless có thể sử dụng trong trường hợp nào?
Serverless có thể sử dụng ở rất nhiều trường hợp. Sau đây là một số trường hợp phổ biến có thể sử dụng:
- **Xử lý file sau khi upload:** Sau khi file được upload lên, event file được tải lên được gửi đi. Các function serverless lắng nghe event file được tải lên được trigger. Với cùng một tệp, có thể có nhiều fuction serverless cùng xử lý để trả về các kết quả khác nhau. Ví dụ như khi một file ảnh được tải lên và cần xử lý để hiển thị trên nhiều màn hình với kích thước khác nhau. Sau khi file ảnh được tải lên, các function sẽ được trigger cùng lúc và xử lý song song để cho ra những file ảnh với kích thuớc khác nhau.
- **Xử lý data stream:** Để xử lý data stream cần có một fuction lắng nghe event từ stream. Khi data được đẩy vào stream, function được trigger với input là data vừa được đẩy vào stream. Sau khi function xử lý xong, data sẽ được lưu lại hoặc đẩy qua một function khác để xử lý tiếp.
- **REST API:** Ở đây, chúng ta cần một API Gateway để nhận request. Khi API Gateway nhận được request, event nhận request sẽ được gửi đi và fuction đăng ký lắng nghe event từ API Gateway được trigger. Sau khi xử lý logic, kết quả sẽ được trả về thông qua API Gateway.
- **Mobile backend:** Ngoài việc sử dụng serverless để viết REST API cho ứng dụng, chúng ta có thể sử dụng các dịch vụ BaaS để làm backend cho ứng dụng mobile như Authentication. 
## Lợi ích
Một số lợi ích chính của serverless là:
- **Giảm thời gian và chi phí phát triển:** BaaS giúp các nhà phát triển không cần mất thời gian để phát triển những chức năng phổ biến. Ví dụ như trong sản phẩm demo đồ án của mình sử dụng Amazon Cognito để làm làm tính năng authentication để tiết kiệm thời gian và tập trung vào viết các tính năng khác. Điều này giúp tiết kiệm thời gian và chi phí phát triển. Thời gian phát triển ứng dụng được rút ngắn đồng nghĩa với việc có thể sớm đưa sản phẩm ra thị trường.
- **Linh hoạt về chi phí sử dụng:** Mô hình FaaS chỉ tính toán chi phí dựa trên số lần gọi hàm và thời gian thực hiện hàm. Nếu ứng dụng của nhà phát triển đang trong thời gian xây dựng hoặc chưa có người sử dụng, nhà phát triển sẽ không mất chi phí sử dụng.
- **Tự động scale tuỳ theo nhu cầu ứng dụng:** Linh hoạt về chi phí sử dụng đồng nghĩa với việc chúng ta không cần lo lắng về vấn đề scale.
## Hạn chế
Ngoài những lợi ích mà serverless mang lại, chúng ta cũng nên xem xét đến một số mặt hạn chế của serverless như:
- **Nhiều khó khăn trong việc debug:** Trong môi trường serverless, việc debug còn nhiều khó khăn. Ví dụ như trong trường hợp có 2 function là function 1, function 2. Sau khi được function 1 được trigger và xử lý xong, funtion 1 trigger funtion 2 với input là output của function 1. Việc phải tái tạo lại input của funtion 2 là nguyên nhân gây ra khó khăn trong debug.
- **Ứng dụng không thể giữ state:** Các function của serverless đều là stateless. Điều đó có nghĩa là các ứng dụng kiểu truyền thống như là sau khi login sẽ có session sẽ không thể hoạt động trên môi trường serverless.
- **Khó khăn trong testing:** Việc các function có thể phụ thuộc lên nhau khiến việc triển khai integration testing và acceptance testing khó khăn hơn.
## Kết luận
Serverless là một mô hình giúp chúng ta giải quyết được các bài toán về infrastructure bằng 2 concept chính là FaaS và BaaS. Mô hình này có nhiều lợi ích về chi phí và khả năng scale. Tuy nhiên, serverless không phải hoàn toàn là hướng giải quyết của mọi bài toán. Vì vậy, chúng ta cần dựa vào nhu cầu thực tế  để suy nghĩ thật cẩn thận trước khi chuyển ứng dụng hiện tại sang kiến trúc serverless.