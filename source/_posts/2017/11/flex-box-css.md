---
title:      Tìm hiểu về Flexbox trong CSS
date:       2017-11-26
categories: frontend
tags:
  - flexbox
---
Đã bao giờ bạn gặp khó khăn trong việc căn chỉnh hay phân chia bố cục bằng CSS? Với một đứa lúc nào cũng thù địch với CSS như Dzung thì việc chia layout là một việc cực kỳ thử thách và cần rất nhiều não. Nhưng mọi chuyện khác đi sau khi Dzung biết đến flexbox. Vậy mọi người hãy cùng Dzung tìm hiểu về flexbox qua bài viết này nhé.
<!-- more -->

#### Flexbox là gì? 
Flexbox(Flexible box) là một module của CSS giúp bạn dễ thở hơn trong việc chia bố trí, căn chỉnh và phân chia các khoảng trống của các items trong một container, đặc biệt là trong những trường hợp không biết trước về kích thước container hoặc kích thước container có thể thay đổi.
Một flexbox layout bao gồm một phần tử cha với một hoặc nhiều phần tử con. Phần tử cha dược xem là một container và các phần tử con là item.
![](/images/flex-box/flex-box.png)
Phía trên là minh hoạ về flexbox layout với container là phần có background màu hồng chứa các item có background màu xanh.
#### Các thuộc tính của container:

##### display: flex;
*Container* được hiểu nôm na là vật chứa hay phần tử cha và có chứa các phần tử ở phía trong. Container được định nghĩa bằng thuộc tính `display: flex;`.

```css
  .container {
    display: flex;
  }
```
##### flex-direction: row | row-reverse | column | column-reverse;

`row`(mặc định): Hiển thị các item từ trái qua phải.
`row-reverse`: Hiển thị các item theo thứ tự từ phải qua trái.
`column`: Hiển thị tất cả item từ trên xuống dưới.
`column-reverse`: Hiển thị tất cả item từ dưới lên trên.

![](/images/flex-box/flex-direction.png)

##### flex-wrap: no-wrap | wrap | wrap-reverse;
`no-wrap`(mặc định): Toàn bộ item sẽ nằm trên một hàng hoặc một cột.
`wrap`: Các item có thể chia thành nhiều hàng nếu không đủ diện tích với chiều là chiều của `flex-direction`.
`wrap-reverse`: Các item có thể chia thành nhiều hàng nếu không đủ diện tích với chiều là chiều ngược với `flex-direction`.

Ở đây, Dzung xin giải thích về một số khái niệm mà Dzung sẽ dùng ở các phần sau của bài viết:

**- Trục chính** là một vector có phương và chiều theo thuộc tính `flex-direction`. 
**- Trục đối xứng** là một vector vuông góc với **trục chính**.
Ví dụ:
```css
.container-row {
  display: flex;
  flex-direction: row;
}
/* Trục chính là vector đi từ trái qua phải */
/* Trục đối xứng là vector đi từ trên xuống dưới */

.container-row-reverse {
  display: flex;
  flex-direction: row-reverse;
}
/* Trục chính là vector đi từ phải qua trái */
/* Trục đối xứng là vector đi từ trên xuống dưới */

.container-column {
  display: flex;
  flex-direction: column;
}
/* Trục chính là vector đi từ trên xuống dưới */
/* Trục đối xứng là vector đi từ trái qua phải */

.container-column-reverse {
  display: flex;
  flex-direction: column-reverse;
}
/* Trục chính là vector đi từ dưới lên trên */
/* Trục đối xứng là vector đi từ trái qua phải */
```

##### flex-flow: <'flex-direction'> || <'flex-wrap'>;
Đây là cách viết rút gọn của `flex-direction` và `flex-wrap`. Ví dụ như: 
```css
.container {
  flex-direction: column;
  flex-wrap: wrap-rerverse;
}

/* Chúng ta có thể viết lại như sau*/

.container {
  flex-flow: column wrap-reverse;
}
```

##### justify-content: flex-start | center | flex-end | space-between | space-around | space-evenly;
`Justify content` định nghĩa về sự căn chỉnh các items trong container so với **trục chính**.

`flex start`: Toàn bộ items căn về điểm *bắt đầu* của **trục chính**.
`flex-end`: Toàn bộ items căn về điểm *kết thúc* của **trục chính**.
`center`: Toàn bộ items căn giữa của **trục chính**.
`space-between`: Toàn bộ items được bố trí đều nhau trên **trục chính**, item đầu tiên nằm ở điểm bắt đầu của trục, item cuối cùng nằm ở điểm cuối cùng của trục.
`space-around`: Toàn bộ items được bố trí đều nhau với các khoảng trống xung quanh mỗi item đều giống nhau.
`space-evenly`: Toàn bộ items được bố trí với khoảng trống giữa mỗi 2 item là bằng nhau.

##### align-items: flex-start | center | flex-end | baseline | stretch;
`Justify content` giúp chúng ta căn chỉnh các items trên **trục chính** thì `align-items` giúp chúng ta căn chỉnh các items theo trục đối xứng).
`flex start`: Toàn bộ items căn về điểm *bắt đầu* của **trục đối xứng**.
`flex-end`: Toàn bộ items căn về điểm *kết thúc* của **trục đối xứng**.
`center`: Toàn bộ items căn về điểm giữa của **trục đối xứng**.
`baseline`: Toàn bộ items được căn chỉnh theo một đường cơ sở.
`stretch`: Toàn bộ items sẽ giãn ra và phủ kín container.

##### align-content: flex-start | center | flex-end | space-between | space-around | stretch;
Nếu trong container có nhiều hàng items, thuộc tính này sẽ có tác dụng tương tự như `justify-content` nhưng nó sẽ chia khoảng trống giữa các hàng trên **trục đối xứng**.

`flex start`: Các hàng dồn về điểm *bắt đầu* của **trục đối xứng**.
`flex-end`: Các hàng dồn về điểm *kết thúc* của **trục đối xứng**.
`center`: Các hàng dồn về giữa của **trục đối xứng**.
`space-between`: Hàng đầu tiên ở điểm *bắt đầu* và hàng cuối cùng ở điểm *kết thúc* của **trục đối xứng**. Các hàng còn lại sẽ chia đều khoảng cách.
`space-around`: Khoảng cách giữa các hàng bằng nhau.
`stretch`: Đây là giá trị mặc định. Các hàng sẽ giãn ra để lấp đầy container.

#### Các thuộc tính của item:

##### order: <integer>;
Thuộc tính `order` quyết định thứ tự mà một hoặc nhiều item xuất hiện trong một flexbox container.

##### flex-grow: <number>;
Thuộc tính `flex-grow` quyết định khả năng giãn ra của 1 item nếu cần thiết. Thuộc tính này cũng có thể được sử dụng như tỷ lệ giữa các item. Ví dụ, nếu ta css như sau:

```css
.container {
  display: flex;
}
#item-1 {
  flex-grow: 1;
}
#item-2 {
  flex-grow: 2;
}
```
Kết quả, thì `item-2` sẽ có độ rộng gấp đôi `item-1`.

##### flex-shrink: <number>;
Thuộc tính `flex-shirk` quyết định khả năng co lại của item. Khi thuộc tính này được đặt bằng 0 thì item sẽ không co lại. Giá trị mặc định bằng 1. Thuộc tính này không chấp nhận tham số bé hơn 0.

##### flex-basis: length | auto;
Thuộc tính `flex-basis` quyết định độ rộng mặc định của 1 item.

##### flex: none | [ <'flex-grow'> <'flex-shrink'>? || <'flex-basis'> ];
Đây là cách viết rút gọn của 3 thuộc tính `flex-grow` `flex-shrink` và `flex-basis`.

```css
/*Thay vì viết*/
.item {
  flex-grow: 1;
  flex-shrink: 0;
  flex-basis: 0;
}
/*Ta có thể viết là*/
.item {
  flex: 1 0 0;
}
```
##### align-self: auto | flex-start | flex-end | center | baseline | stretch;
Thuộc tính này giúp chúng ta có thể ghi đè thuộc tính `align-items` của *container* hoặc căn chỉnh độc lập theo mỗi item.

`flex start`: Nội dung item căn về điểm *bắt đầu* của **trục đối xứng**.
`flex-end`: Nội dung item căn về điểm *kết thúc* của **trục đối xứng**.
`center`: Nội dung item căn về điểm giữa của **trục đối xứng**.
`baseline`: Nội dung item được căn chỉnh theo một đường cơ sở.
`stretch`: Nội dung item sẽ giãn ra và phủ kín container.

#### Kết bài
Ở trên, Dzung đã nêu ra toàn bộ thuộc tính của . Hy vọng qua bài viết các bạn có thể hiểu rõ hơn về  cũng như dễ thở hơn một chút trong viết components CSS.[Đây](http://flexboxfroggy.com/) là một game khá fun giúp các bạn luyện tập để hiểu rõ hơn về flexbox. Thanks you and happy coding <3
