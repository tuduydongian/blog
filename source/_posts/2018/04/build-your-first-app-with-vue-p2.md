---
title: Tìm hiểu Vue thông qua xây dựng ứng dụng to do list(Part 2)
date: 2018-04-30
categories: javascript
tags: 
  - Vuejs
  - frontend
---
Dzung trở lại sau 1 thời gian dài để tiếp tục series bài viết tìm hiểu Vue. Ở bài viết này,chúng ta sẽ đi tìm hiểu các khái niệm cơ bản như component, props, data,... thông qua xây dựng tính năng pomodoro clock.
<!--more-->
Pomodoro là một kỹ thuật quản lý thời gian bằng cách chia thành nhiều quảng ngắn (thường là 25 phút) với những quãng nghỉ ngắn (thường là 5 phút) ở giữa. Mục tiêu của chúng ta trong bài viết này sẽ bắt đầu tạo một page với đồng hồ bấm giờ như dưới đây:

![](/images/04/pomodoro-clock.png)

#### Start

Đầu tiên, tạo `single file component` CountdownClock.vue trong thư mục `src/components` với nội dung như sau:

```js src/components/CountdownClock.vue
<template>
  <div class="clock">
    {{ padOneZero(minutes) }} : {{ padOneZero(seconds) }}
  </div>
</template>
<script>
export default {
  props: {
    counting: {
      type: Boolean,
      default: false,
    },
    timeInSeconds: {
      type: Number,
      default: 0,
    },
  },
  data() {
    return {
      minutes: this.getMinutes(),
      seconds: this.getSeconds(),
      timer: null,
    };
  },
  watch: {
    counting(value) {
     if (value) {
       this.timer = setInterval(this.decreaseTime, 1000);
       return;
     }
     clearInterval(this.timer);
    },
    timeInSeconds(value) {
      this.setTime();
    },
  },
  methods: {
    getMinutes() {
      return this.minutes = Math.round(this.timeInSeconds / 60);
    },
    getSeconds() {
      return this.seconds = this.timeInSeconds - Math.round(this.timeInSeconds / 60) * 60;
    },
    decreaseTime() {
      if (this.seconds === 0 && this.minutes === 0) {
        this.$emit('finish');
        return;
      } 
      if (this.seconds > 0) {
        this.seconds -= 1;
        return;
      }
      this.seconds = 59;
      this.minutes -= 1;
    },
    setTime() {
      this.minutes = this.getMinutes();
      this.seconds = this.getSeconds();
    },
    padOneZero(number) {
      if (number < 10) {
        return `0${number}`;
      }
      return number;
    },
    reset() {
      this.setTime();
      this.$emit('update:counting', false);
    },
  },
}
</script>
```
Ở đây, ta dễ dàng thấy được cấu trúc 1 component với 2 phần là template và script. Phần template được viết trông khá giống mã `Html`. Chúng ta có thể tìm hiểu kỹ hơn về syntax của template [ở đây](https://vuejs.org/v2/guide/syntax.html). Tiếp theo, khi nhìn vào phần script chúng ta có thể thấy được một component gồm những thành phần chính sau:

- props: Là một thuộc tính được khai báo ỏ một component. Chúng ta có thể truyền data vào component thông qua props và các hành động ở trong component không nên thay đổi props. Như ở trong component CountdownClock, chúng ta cần truyền vào 2 props là timeInSeconds và counting.
- data: Là một object trong Vue component mà khi Vue instance được tạo ra, các thuộc tính của object này sẽ được đẩy vào hệ thống reactivity của Vue. Điều này có nghĩa là khi data có sự thay đổi, những view liên quan đến thuộc tính này sẽ cập nhật và render lại. Như ở trên, mỗi lần thuộc tính minutes và seconds thay đổi thì kết quả hiển thị ra cũng thay đổi.
- watch: là những hàm sẽ chạy lúc các thuộc tính được watch thay đổi. Ở trên, khi thuộc tính counting thây đổi, hàm sẽ chạy và thêm hoặc xoá timer hay khi thuộc tính timeInSeconds thay đổi thì chúng ta set lại time cho coundownClock.
- methods: là các hàm sẽ sử dụng trong component hoặc sử dụng trong template.

Tiếp theo, chúng ta sẽ tạo file `Pomodoro.vue` trong thư mục `src/pages` với nội dung như sau:

```js src/pages/Pomodoro.vue
<template>
  <div class="pomodoro" :style="{ 'background-color': backgroundColor }">
    <div class="pomodoro__clock">
      <coundown-clock :counting.sync="counting"
                      @finish="changeState"
                      ref="clock"
                      :timeInSeconds="timeInSeconds">
      </coundown-clock>
    </div>
    <div class="podomoro__settings">
      <div class="pomodoro__settings-field">
        <div class="pomodoro__settings-label">
          <label>Working time</label>
        </div>
        <div class="pomodoro__settings-input">
          <input type="number"
                 :value="toMinutes(workingTime)"
                 :disabled="counting"
                 @change="changeWorkingTime"/> 
        </div>
        <div class="pomodoro__settings-unit">
          <span>minutes</span>
        </div>
      </div>
      <div class="pomodoro__settings-field">
        <div class="pomodoro__settings-label">
          <label>Break time</label>
        </div>
        <div class="pomodoro__settings-input">
          <input type="number"
                 :value="toMinutes(breakTime)"
                              @change="changeBreakTime"
                :disabled="counting"/> 
        </div>
        <div class="pomodoro__settings-unit">
          <span>minutes</span>
        </div>
      </div>
    </div>
    <div class="pomodoro__menu">
      <button class="pomodoro__btn pomodoro__btn--primary"
              @click="toggleCounting">{{counting ? 'Pause' : 'Start'}}
      </button>
      <button class="pomodoro__btn pomodoro__btn--outlined"
              @click="reset">Reset</button>
    </div>
  </div>
</template>
<script>
import CoundownClock from "../components/CoundownClock";
const STATE_WORKING = 'working';
const STATE_BREAKING = 'breaking';
const DEFAULT_WORKING_TIME = 1500;
const DEFAULT_BREAK_TIME = 300;
export default {
  components: {
    CoundownClock
  },
  data() {
    return {
      counting: false,
      workingTime: DEFAULT_WORKING_TIME,
      breakTime: DEFAULT_BREAK_TIME,
      state: STATE_WORKING,
    };
  },
  computed: {
    timeInSeconds() {
      if (this.state === STATE_BREAKING) {
        return this.breakTime;
      }
      return this.workingTime;
    },
    backgroundColor() {
      if (this.state === STATE_BREAKING) {
        return '#69F0AE';
      }
      return '#00BCD4';
    },
  },
  methods: {
    toggleCounting() {
      this.counting = !this.counting;
    },
    changeState() {
      if (this.state === STATE_BREAKING) {
        window.alert('Time is up! Back to work now!');
        this.state = STATE_WORKING;
        return;
      }
      window.alert('Time is up! Take a cup of coffee!');
      this.state = STATE_BREAKING;
    },
    toMinutes(seconds) {
      return seconds / 60;
    },
    toSeconds(minutes) {
      return minutes * 60;
    },
    changeWorkingTime(e) {
      const minutes = Number.parseInt(e.target.value);
      this.workingTime = this.toSeconds(minutes);
    },
    changeBreakTime(e) {
      const minutes = Number.parseInt(e.target.value);
      this.breakTime = this.toSeconds(minutes);
    },
    reset() {
      this.state = STATE_WORKING;
      this.$refs.clock.reset();
    },
  }
};
</script>
<style>
.pomodoro {
  width: 100%;
  height: 100vh;
  max-width: 600px;
  margin: auto;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
}
.pomodoro input {
  padding: 8px 10px;
}
.pomodoro__clock {
  font-size: 35px;
  font-style: italic;
  font-weight: bold;
  margin-bottom: 20px;
}
.podomoro__settings {
  margin-bottom: 30px;
}
.pomodoro__settings-field {
  display: flex;
  width: 400px;
  padding: 5px;
  align-items: center;
}
.pomodoro__settings-label {
  flex: 1 0 0;
  text-transform: uppercase;
}
.pomodoro__settings-input {
  flex: 1 0 0
}
.pomodoro__settings-unit {
  padding-left: 20px;
}
.pomodoro__btn {
  text-transform: uppercase;
  padding: 10px 30px;
  background-color: #fff;
  box-shadow: none;
  outline: none;
  border: 1px solid #000;
  font-size: 14px;
  font-weight: bold;
}
.pomodoro__btn:hover {
  cursor: pointer;
}
</style>
```
Ở đây, chúng ta có sử dụng 2 thuộc tính mới là:

- components: Ở đây, chúng ta sử dụng component CountdownClock đã tạo để sử dụng trong template. Props được truyền vào component qua thuộc tính [v-bind](https://vuejs.org/v2/guide/syntax.html#Arguments) ([shorthand](https://vuejs.org/v2/guide/syntax.html#v-bind-Shorthand)). Ngoài ra, mình có sử dụng thuộc tính [v-on](https://vuejs.org/v2/guide/syntax.html#Modifiers) ([shorthand](https://vuejs.org/v2/guide/syntax.html#v-on-Shorthand)) để handle event `finish` của component clock. Event `finish` được emit từ trong component CountdownClock như ở trên. Props `counting` sử dụng thêm từ khoá `.sync` có nghĩa là mỗi khi có event `update:counting` thì giá trị của `counting` được gán lại.
- computed: Tương tự như `watch`, khi thuộc tính trong `computed` thay đổi thì `computed` thay đổi. Ở đây, màu nền của ứng dụng sẽ thay đổi khi thuộc tính `state` thay đổi.

Ở file `src/router/index.js` sẽ có nội dung như dưới đây:

```js src/router/index.js
import Vue from 'vue'
import Router from 'vue-router'
import Pomodoro from '@/page/Pomodoro'

Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '/',
      name: 'Pomodoro',
      component: Pomodoro
    }
  ]
});
```

Và ở file `src/App.vue`:

```js src/App.vue
<template>
  <router-view></router-view>
</template>
```

Các bạn chạy sử dụng command `yarn dev` để xem kết quả.

#### Kết luận

Mình nghĩ đây là một ví dụ phù hợp để mọi người bắt đầu tìm hiểu Vue. Các bạn có thể tham khảo thêm ở tài liệu chính thức của [Vue](https://vuejs.org/v2/guide/) để hiểu rõ hơn về ví dụ mình đưa ra. Mình nghĩ cách tốt nhất để làm quen với một framework mới là đọc `official documentation`, `code example` và `practice`. Hy vọng các bạn có thể làm quen Vue qua ví dụ của mình. Happy coding <3 
