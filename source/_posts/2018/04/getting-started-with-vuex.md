---
title: Getting started with Vuex
date: 2018-04-24
categories: javascript
tags: 
  - vuejs
  - frontend
  - vuex
---
Tháng này mình muốn giới thiệu cho mọi người một library của Vue có khá nhiều lợi ích đó là `Vuex`
<!-- more -->

### Vuex là gì?

Vuex được xem như là một thư viện dùng để quản lý `state` cho các ứng dụng của Vue.

`State được hiểu như là trạng thái của của ứng dụng`. Ví dụ như app sẽ có trạng thái là đã login hay chưa.

### Tại sao lại cần phải dùng Vuex?
Trước  tiên về `Vue`. Vue chia nhỏ `state` và quản lý trong từng component, điều này mang đến nhiều lợi ích như: dễ dùng lại code, giảm sự phức tạp của ứng dụng, việc test trở nên dễ dàng hơn... Nhưng một ngày đẹp trời có 3, 4... n component dùng chung một state thì phải làm sao?

 Cách dễ dàng nhất là mỗi component đều sử dụng event send state ra ngoài để các component khác sử dụng và tự trigger khi state này thay đổi. Ngoài ra thì có thể tạo một component cha làm nơi trung chuyển state. Hai cách này đều làm cho workflow trở nên phức tạp hơn nhiều và khó có thể kiểm soát (điển hình nhất là khó khăn trong việc debug).

Vuex ra đời để giải quyết những điều này :))

### Kiến trúc của Vuex

![](/images/vuex.png)

Với Vuex, state của ứng dụng được quản lý tập trung một chỗ được gọi là `store`, nó bao gồm 5 phần chính:
+ State 
+ Getters
+ Mutation
+ Actions
+ Modules

#### State
Cái tên nói lên tất cả :)) State là một object chứa toàn bộ state của ứng dụng

```javascript
const state = {
  numbers: [1, 2, 3, 4, 5]
}
```
#### Getters
Là một tập các hàm dùng để filter state ra được output như mong muốn.

```javascript
const state = {
  // không có tham số truyền vào 
  getEvenNumbers: state => {
    return state.numbers.filter(item => item%2 === 0)
  }
  // có tham số truyền vào 
  hasNumber : state => num => {
    return state.numbers.include(num)
  }
}
```
Để sử dụng trong component thì có thể gọi trực tiếp `this.$store.getters.getEvenNumbers` hoặc sử dụng `mapGetter`

Chi tiết : [Getters](https://vuex.vuejs.org/en/getters.html)

#### Mutations
Đây là nơi duy nhất cho phép thay đổi state. Một điều cần lưu ý là `mutations` là `synchronous`. Vì sao phải cần điều này? Nếu không có rule này thì trong trường hợp nhiều action cùng gọi 1 mutation làm sao ta kiểm soát được cái nào đã thay đổi state hay thứ tự thay đổi state như nào.

```javascript
const mutations = {
  add(state, num){
    return state.numbers.push(num)
  }
  remove(state, num) {
    return state.numbers.include(num)
  }
}
```

#### Actions
Actions có thể nói là nơi thể hiện `bussiness logic`. Nó là nơi gọi API, save vào database, thực hiện các `commit` (gọi mutation) để thay đổi state... 

VD: Thêm một số, nếu số đó đã tồn tạo trong state thì xoá rồi thêm lại.

```javascript
const actions = {
  updateNum({commit, state}, num){
    if (state.includes(num)) {
      commit('remove', num)
    }
    commit('add', num)
  }

  // có thể gọi một action khác bằng cách 
  foo ({dispatch}, num) {
    dispatch('updateNum', num)
  }
}
```
Ngược lại với `mutation`, `action` lại là asynchronous. Đơn giản là bởi vì các action có thể không có logic liên quan đến nhau.

#### Modules
Được xem như là `store` thu nhỏ, nó cũng bao gồm: state, mutation và action. Khi `store` phình quá to thì có thể chia nhỏ ra thành các module để dễ quản lý hơn. 

Chi tiết: [Modules](https://vuex.vuejs.org/en/modules.html)

### Những điều cần lưu ý với Vuex
* Xác định cái nào là `state` sẽ lưu trữ trong `store`, cái nào chỉ là `local state` chỉ nằm trong component. Tất nhiên là có để đưa tất cả vào store, nhưng đến khi quy mô ứng dụng tăng lên kéo theo `store` cũng sẽ phình to ra => việc quản lý state sẽ trở nên khó khăn hơn nhiều nhiều.

* Đồng bộ giữa client và server

### Kết luận 
Qua bài viết này, mong các bạn có được cái nhìn rõ ràng hơn về Vuex và tuỳ ứng dụng mà có thể sử dụng nó hợp lý.
Nếu có câu hỏi hoặc góp ý thì đừng ngần ngại mà hãy comment bên dưới nhé ^^