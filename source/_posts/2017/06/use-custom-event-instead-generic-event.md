---
title:      Use Custom Event instead Generic Event
date:       2017-06-28
categories: symfony
tags:
    - best practice
---

Vào một ngày đẹp trời, tôi đã quyết định chỉ xài Custom event thay vì Generic event. Tại sao?
<!--more-->

Khi sử dụng Event Listener, để tiết kiệm thời gian ta thường hay sử dụng [Generic Event](https://symfony.com/doc/current/components/event_dispatcher/generic_event.html). Tuy nhiên nó cũng để lại nhiều phiền phức trong quá trình maintenance. Sau đây là những lợi điểm của việc sử dụng [Custom Event](http://symfony.com/doc/current/components/event_dispatcher.html#creating-an-event-class) thay vì `Generic Event`.

### 1. Custom event is class

Vâng, cháu nó là class nên có thể `extends`, `implement` interface, use `trait` và những thứ hay ho của lập trình hướng đối tượng

### 2. Find Usage

Xài IDE dễ dàng `find usage` để biết được event của chúng ta được sử dụng ở những chỗ nào và mò ra được nơi nào ném event, nơi nào nghe event.

### 3. Test nếu thích

Vì nó là class nên có thể unit test được nó, tuy nhiên chỉ nên test khi có logic trong này (còn nếu class chỉ thuần `getter` và  `setter` thì hãy test nếu tay bạn đủ to)


```php
class CircleDrawedEvent extends Event
{
    public __construct($center, $radius) {
        $this->center = $center;
        $this->radius = $radius;
    }
    
    // should test this
    public getDiameter() {
        return $this->radius * 2;
    }
}
```

### 4. Strictype của class event ở listener

```php
class ShapeSubscriber implements EventSubscriberInterface
{
    public static function getSubscribedEvents()
    {
        return [
            'circle.drawed' => 'logNewCircleDrawed',
        ];
    }

    public function logNewCircleDrawed(CircleDrawedEvent $event)
    {
        // ...
    }
}
```

### 5. Properties, getter/setter đầy đủ

Nếu xài `Generic Event`, bạn sẽ phải đảm bảo sự đồng bộ về data lúc ném ra và lúc lắng nghe để xử lý một cách thủ công, như sau:

```php
$event = new GenericEvent($subject, ['data' => 'Foo']);
$dispatcher->dispatch(AppEvent::Foo, $event);
```

```php
class FooListener
{
    public function filter(GenericEvent $event)
    {
        $data = $event['data'];
        $subject = $event->getSubject();
    }
}
```

```php
final class AppEvent {

    /**
     * Please ensure Generic event should be like:
     * 
     * new GenericEvent($subject, ['data' => 'Foo']);
     */
    public static Foo = 'app.foo';
}
```

Vậy đấy, nếu event là class custom thì bạn set, get các properties một cách bình thường và đúng chuẩn, không cần phải lăn tăn về vấn đề maintenance kiểu nông dân như trên.

### So, let's use Custom event, please :rock:
