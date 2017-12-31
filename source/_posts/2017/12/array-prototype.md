---
title: Sử dụng một số methods thông dụng với Array trong javascript
date: 2017-12-31
categories: javascript
tags: js array prototype
---
Trong javascript, Arrays là tập hợp một danh sách các phần tử. Javascript cung cấp nhiều built-in methods để làm việc với array. Các phương thức này được chia làm 2 loại: Mutator methods và Accessor methods.
<!--more -->
## Mutator methods

Còn gọi là setter methods, là các methods chỉnh sửa trực tiếp trên array đầu vào. Một số mutator methods thông dụng: 

### pop()

Xóa phần tử cuối cùng khỏi array, trả về phần tử bị xóa.

```javascript
const animals = ['dog', 'cat', 'fish'];
animals.pop();
console.log(animals);
// output: ['dog', 'cat']
```

### shift()

Xóa phần tử đầu tiên khỏi array, trả về phần tử bị xóa.

### push()

Thêm vào cuối array một hoặc nhiều phần tử, trả về kích thước mới của array.

```javascript
const animals = ['dog', 'cat'];
animals.push('fish', 'tiger');
console.log(animals);
// output: ['dog', 'cat', 'fish', 'tiger']
```

### unshift()

Thêm vào đầu array một hoặc nhiều phần tử, trả về kích thước mới của array.

### splice()

Thêm hoặc xóa một hay nhiều phần tử của array tại vị trí xác định, trả về mảng các phần tử bị xóa.

```javascript
array.splice(start[, deleteCount[, item1[, item2[, ...]]]])
```

```javascript
const animals = ['dog', 'cat', 'fish'];
animals.splice(1, 1, 'tiger');
console.log(animals)
// output: ['dog', 'tiger', 'fish']
animals.splice(1, 0, 'cat');
// output: ['dog', 'cat', 'tiger', 'fish']
```

### reverse()

Đảo ngược thứ tự các phần tử trong array

```javascript
const animals = ['dog', 'cat', 'fish'];
animals.reverse();
console.log(animals)
// output: ['fish', 'cat', 'dog']
```

### sort()

Sắp xếp các phần tử trong array, trả về chính nó sau khi được sắp xếp

```javascript
const numbers = [2, 3, 1];
numbers.sort();
console.log(numbers)
// output: [1, 2, 3]
```

Ta cũng có thể  thay đổi cách sắp xếp

```javascript
const numbers = [2, 3, 1];
numbers.sort((a, b) => (b - a));
console.log(numbers)
// output: [3, 2, 1]
```

Sắp xếp dựa theo một thuộc tính của object

```javascript
const cars = [{name: 'Audi', price: 1000}, {name: 'Toyota', price: 100}];
cars.sort((a, b) => (a.price - b.price));
console.log(cars)
// output: [{name: 'Toyota', price: 100}, {name: 'Audi', price: 1000}]
```

## Accessor methos

Còn gọi là getter methods, trả về một array mới, array ban đầu vẫn được giữ nguyên.

### slice()

Copy các phần tử được chỉ định của array ban đầu sang một array mới.

```javascript
arr.slice([begin[, end]])
```

Nếu không khai báo tham số, mặc định begin là vị trí bắt đầu, end là cuối array.

```javascript
const animals = ['dog', 'cat', 'fish'];
const newArr = animals.slice(0, 1);
console.log(newArr);
// output: ['dog', 'cat']
```

### concat()

Trả về array mới là kết hợp của 2 hay nhiều array ban đầu.

```javascript
const odd = [1, 3, 5];
const even = [2, 4, 6];
const numbers = odd.concat(even);
console.log(numbers);
// output: [1, 3, 5, 2, 4, 6]
```

### find()

Tìm và trả về phần tử đầu tiên trong array thỏa mãn điều kiện cho trước.

```javascript
const numbers = [1, 2, 3, 4];
console.log(numbers.find(x => x % 2 === 0));
// output: 2
```

### map()

Tạo một array mới với mỗi phần tử là phần tử của array cũ sau khi xử lý trong function.

```javascript
const numbers = [1, 2, 3];
console.log(numbers.map(x => x + 1));
// output: [2, 3, 4];
console.log(numbers.map(x => ({value: x})));
// output: [{value: 1}, {value: 2}, {value: 3}]
```

### filter()

Giống với find(), nhưng filter trả về một array mới gồm tất cả các phần tử của array ban đầu thỏa mãn điều kiện cho trước.

### every()

Kiểm tra xem tất cả phần tử của array có thỏa mãn điều kiện, trả về true hoặc false.

```javascript
const numbers = [1, 2, 3];
console.log(numbers.every(x => x % 2 === 0));
// output: false
console.log(numbers.every(x => x % 1 === 0));
// output: true
```

### some()

Kiểm tra nếu có ít nhất một phần tử trong array thỏa mãn điều kiện, trả về true hoặc false.

```javascript
const numbers = [1, 2, 3];
console.log(numbers.some(x => x % 2 === 0));
// output: true
```

Some thường kết hợp với các function khác để xử lý đồng thời nhiều array:
- Kiểm tra nếu có bất kỳ phần tử nào của 2 array trùng nhau.

```javascript
const arr1 = [1, 2, 3];
const arr2 = [1, 4, 5];
console.log(arr1.some(x => arr2.some(y => x === y)));
// output: true
```

- Trả về các phần tử của một array mà trong array còn lại cũng có các phần tử đó.

```javascript
const arr1 = [1, 2, 3];
const arr2 = [1, 4, 5];
console.log(arr1.filter(x => arr2.some(y => x === y)));
// output: [1]
```