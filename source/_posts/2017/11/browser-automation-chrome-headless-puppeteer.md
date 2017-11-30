---
title:      Tự động hoá browser với Chrome headless - Puppeteer - Nodejs 
date:       2017-11-30
categories: nodejs
tags:
  - chrome headless 
  - puppeteer
---

Bài viết này giới thiệu với các bạn một tool cực cool với tên gọi là Puppeteer.  
Nếu bạn thường phải làm các task liên quan đến browser automation thì Puppeteer là tool không thể bỏ qua.  
<!-- more -->

Mọi người đều biết hiện tại Chrome là trình duyệt có thị phần lớn nhất. Hồi đầu năm nay thì Chrome được bổ sung tính năng mới là [Chrome Headless](https://developers.google.com/web/updates/2017/04/headless-chrome) (Kể từ bản Chrome 59). Nôm na là bạn có thể chạy Chrome mà không thực sự phải chạy Chrome. :D  
Tiếp liền sau đó thì Google Chrome team cũng cho ra đời Puppeteer, một Nodejs library giúp bạn có thể control được Chrome Headless.  
Khỏi phải nói về độ khủng của mấy tool này trong lĩnh vực browser automation, bằng chứng là khi được chính thức giới thiệu mà một loạt các tools tương tự khác thông báo ngừng phát triển, điển hình là [PhantomJS](https://groups.google.com/forum/#!topic/phantomjs/9aI5d-LDuNE)  

Bài viết này sẽ tập trung giới thiệu sơ bộ Puppeteer. Còn các bạn muốn tìm hiểu sâu hơn về Chrome headless thì có thể [vào đây](https://developers.google.com/web/updates/2017/04/headless-chrome).  

### Puppeteer là gì?  
Nôm na thì Puppeteer là Nodejs libary chính chủ, giúp bạn điều khiển headless Chrome.  
Những gì mà bạn làm được bằng giao diện người dùng trên Chrome thì bạn đều có thể làm bằng Puppeteer.  
Bạn có thể xem mã nguồn của Puppeteer trên [Github](https://github.com/GoogleChrome/puppeteer).  

Từ đó mở ra một chân trời những thứ hay ho mà bạn có thể làm được với Puppeteer.  

#### Tạo screenshot hoặc PDF của trang web  
Nếu trước giờ bạn vẫn dùng những tool như [wkhtmltox](https://wkhtmltopdf.org/) thì nó base trên 1 nhân webkit version khá cũ. Điều này dẫn đến những bất cập như không tương thích CSS mới nhất. Khi bạn muốn tạo 1 invoice bằng PDF chẳng hạn thì quá trình viết CSS để gen ra style chuẩn khá khoai, ngồi căn chỉnh css khá mệt. Nay với Puppeteer thì mọi việc dễ hơn nhiều, Chrome hiển thị thế nào thì gen ra thế nấy.  

#### Viết crawler để lấy nội dung website 
Dùng HTTP client để crawler thì có ưu điểm là nhanh và performance cao hơn. Tuy nhiên với việc các trang web ngày càng cập nhật nhiều phương pháp để chặn bot thì HTTP client rất dễ bị chặn dù bạn có cố gắng by pass chuẩn cỡ nào. Với Puppeteer thì mỗi khi bạn mở 1 session mới thì nó sẽ tương đương với việc tạo 1 user mới hoàn toàn trên Chrome và nó có hành vi của một trình duyệt người dùng bình thường.  
Puppeteer đặc biệt phù hợp với các trang web mà nặng về javascript và bắt buộc phải thực thi js thì mới có thể lấy được nội dung.  

#### Kiểm thử tự động 
Mình nghĩ đây là phần thú vị nhất. Ví dụ với End to end testing, mình có thể bootstrap trình duyệt lên, click vào các đường link để chuyển trang, điền form đăng nhập... Hoặc với Unit testing, bạn có 1 môi trường để chạy test với nhân là 1 browser hiện đại với đầy đủ các tính năng mới nhất. Mình nghĩ là trong tương lai gần thì Chrome headless sẽ dẫn đầu về thị phần kiểm thử tự động luôn.  

### Coding 
Giờ là lúc ta sẽ thử code với Puppeteer. Để sử dụng được những code snippet trong này thì yêu cầu bạn cài Node 8 nhé.  

#### Cài cắm  
Cài Puppeteer thì đơn giản chỉ là:  
```bash 
$ npm instal --save puppeteer 
```
Puppeteer sẽ kéo về bản Chrome mới nhất tương thích với nó và đảm bảo cho bạn mọi thứ sẵn sàng làm việc, quá cool <3  

#### Tạo screenshot của trang web  
Giờ mình sẽ viết 1 đoạn code nhỏ để chụp ảnh màn hình trang chủ của tuduydongian.com và lưu vào 1 file tên là screenshot.png  
```js 
const puppeteer = require('puppeteer');

async function run() {
  const browser = await puppeteer.launch();
  const page = await browser.newPage();
  await page.goto('https://tuduydongian.com');
  await page.screenshot({ path: 'screenshot.png' });

  await browser.close();
}

run();
```

Xong, bạn sẽ thấy file screenshot.png đã được tạo ra. Nếu mở file này ra bạn sẽ thấy ảnh có kích cỡ 800x600 px.  
Nếu bạn muốn tạo screenshot với kích cỡ lớn hơn, rất đơn giản chỉ cần `setViewPort()`, Chrome sẽ được mở với kích cỡ cửa sổ theo ý bạn.  
```js 
await page.setViewport({width: 1000, height: 1000})
```

Nếu bạn muốn generate file PDF? rất đơn giản, chỉ cần thay vì gọi `page.screenshot()` thì bạn gọi `page.pdf()` 
```js 
await page.pdf({ path: 'page.pdf', format: 'A4' });
```

Nếu bạn muốn show Chrome lên để tiện cho quá trình debug, chỉ cần set `headless: false`:  
```js 
const browser = await puppeteer.launch({headless: false});
```

#### Scrape nội dung trang web
Giả sử ta cần lấy link (thẻ a) của các bài viết mới nhất ở trang chủ tuduydongian.com, điều cần làm là truy cập vào trang chủ, bóc tách nội dung và lấy toàn bộ thẻ a ở phần content.  
```js 
const puppeteer = require('puppeteer');

async function run() {
  const browser = await puppeteer.launch();
  const page = await browser.newPage();
  await page.goto('https://tuduydongian.com');

  const result = await page.evaluate(() => {
    let data = []; 
    let elements = document.querySelectorAll('a.article-title'); 

    elements.forEach((el) => {
      data.push(el.getAttribute('href')); 
    })

    return data;
  });

  await browser.close();

  return result; 
}

run().then((value) => {
  console.log(value); 
});
```

Bài viết đến đây là hết. Vì puppeteer còn khá mới nên mình cũng đang trong quá trình tìm hiểu và đưa vào trong quy trình.  
Nếu bạn có ý tưởng gì hay ho với Puppeteer thì cứ đóng góp nhé <3  
