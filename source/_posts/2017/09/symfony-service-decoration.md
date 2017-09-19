---
title:      Symfony Service Decoration
date:       2017-09-18
categories: symfony
tags:
  - best practice
---
Trong bài viết này mình sẽ thử implement `Symfony Service Decoration` để giải quyết bài toán làm mình chán nản cả ngày hôm nay.
<!-- more -->
### Bài toán:
#### Mô tả:

Giả sử chúng ta có `Post` và `PostRevision` entity. Trong hệ thống có rất nhiều nơi tác động để update `Post`:

- Edit review của admin
- Edit của user
- Edit bằng api
- ...

Yêu cầu là mỗi khi `Post` updated thì sẽ tạo mới `PostRevision`.

#### Giải quyết:

Để giải quyết vấn đề nêu ra thì phương án hiển nhiên là tạo ra 1 `Listener` lắng nghe sự kiện `Post updated` để tạo mới revision.

```php
// AppBundle/Event/PostUpdatedEvent.php

namespace AppBundle\Event;

use AppBundle\Entity\Post;
use Symfony\Component\EventDispatcher\Event;

class PostUpdatedEvent extends Event
{
    const NAME = 'app.post_updated';

    private $post;

    public function __construct(Post $post)
    {
        $this->post = $post;
    }

    public function getPost(): Post
    {
        return $this->post;
    }
}
```
```php
// AppBundle/EventSubscriber/PostRevisionSubscriber.php

namespace AppBundle\EventSubscriber;

use AppBundle\Event\PostUpdatedEvent;
use Symfony\Component\EventDispatcher\EventSubscriberInterface;

class PostRevisionSubscriber implements EventSubscriberInterface
{
    public static function getSubscribedEvents()
    {
        return [
            PostUpdatedEvent::NAME => 'onPostUpdated'
        ];
    }

    public function onPostUpdated()
    {
        dump('do something');
    }
}
```
#### Vấn đề phát sinh:

`Listener` đã sẵn sàng, nhưng công cuộc `dispatch event` thì làm như thế nào? Có rất nhiều nơi trong hệ thống cần ném event ra, vậy ta sẽ:

##### 1. Tay to:

Chỗ nào cần `dispatch` thì cứ táng vào thôi :trollface: Với cách làm này thì code sẽ bị "đúp" khá nhiều và dễ bị bỏ sót nếu không cẩn thận khi thêm endpoint mới :facepalm:

```php
$post = updateContent();

$em = $this->getDoctrine()->getManager();
$em->persist($post);
$em->flush();

$this->get('event_dispatcher')->dispatch(PostUpdatedEvent::NAME, new PostUpdatedEvent($post));
```

##### 2. Xài Service trung gian:

Tống phần `flush db` và `dispatch event` vào 1 `service` trung gian. Đây là phương án mình cho là hợp lý nhất.

```php
// AppBundle/Manager/PostManager.php

namespace AppBundle\Manager;

use AppBundle\Entity\Post;
use AppBundle\Event\PostUpdatedEvent;
use AppBundle\Repository\PostRepository;
use Symfony\Component\EventDispatcher\EventDispatcherInterface;

class PostManager
{
    private $repository;
    private $dispatcher;

    public function __construct(PostRepository $repository, EventDispatcherInterface $dispatcher)
    {
        $this->repository = $repository;
        $this->dispatcher = $dispatcher;
    }

    public function save(Post $post)
    {
        $this->repository->save($post);

        $this->dispatcher->dispatch(PostUpdatedEvent::NAME, new PostUpdatedEvent($post));
    }
}
```

##### 3. Service Decoration

Okay, phương án phía trên được xem là perfect để giải quyết bài toán (trong tầm hiểu biết của mình). Tuy nhiên vì tiêu đề bài viết nên ta sẽ phịa thêm cách này nữa để có cái cớ implement `Service Decoration`

### Symfony Service Decoration

Trước tiên hãy xem qua về pattern này để có cái nhìn tổng quan: https://en.wikipedia.org/wiki/Decorator_pattern 

Hiểu đơn giản, ta đang cố gắng `viết lớp wrapper để thêm hành vi (behavior) cho class sẵn có`.

Ở đây, ta sẽ cố `decorate` `Repository` và thêm hành vi cho nó.

Ta có repository của `Post` entity:

```php
// AppBundle/Repository/PostRepository.php

namespace AppBundle\Repository;

use AppBundle\Entity\Post;
use Doctrine\ORM\EntityRepository;

class PostRepository extends EntityRepository
{
    public function save(Post $post)
    {
        $this->_em->persist($post);
        $this->_em->flush();
    }
}
```

Tạo class `DecoratingPostRepository` với method `save`:

- Save post
- Dispatch event

Lưu ý: Trong pattern này, `PostRepository` không hề biết đến sự có mặt của `DecoratingPostRepository`

```php
// AppBundle/Repository/DecoratingPostRepository.php

namespace AppBundle\Repository;

use AppBundle\Entity\Post;
use AppBundle\Event\PostUpdatedEvent;
use Symfony\Component\EventDispatcher\EventDispatcherInterface;

class DecoratingPostRepository
{
    private $repository;
    private $dispatcher;

    public function __construct(PostRepository $repository, EventDispatcherInterface $dispatcher)
    {
        $this->repository = $repository;
        $this->dispatcher = $dispatcher;
    }

    public function save(Post $post)
    {
        $this->repository->save($post);

        $this->dispatcher->dispatch(PostUpdatedEvent::NAME, new PostUpdatedEvent($post));
    }
}
```

Như bạn thấy ở trên, `constructor` của `DecoratingPostRepository` gồm `PostRepository` và `EventDispatcherInterface`. Vậy làm sao để inject được 2 class này? Việc này rất đơn giản chỉ với vài dòng config service của Symfony:

```yaml
# services.yml

services:
    app.repository.post:
        class: Doctrine\ORM\EntityRepository
        public: true
        factory: ['@doctrine.orm.entity_manager', getRepository]
        arguments: [AppBundle\Entity\Post]

    app.repository.post_decorating:
        class: AppBundle\Repository\DecoratingPostRepository
        # với dòng config này, bạn hiểu là:
        # app.repository.post_decorating.inner = app.repository.post
        # app.repository.post = app.repository.post_decorating
        decorates: app.repository.post
        # chúng ta sẽ không bao giờ fetch service này trực tiếp nên set public = false
        public: false
        arguments:
            $repository: '@app.repository.post_decorating.inner'
            $dispatcher: '@event_dispatcher'
```

Done, từ bây giờ, khi bạn gọi service `app.repository.post` thì `app.repository.post_decorating` sẽ có mặt để phục vụ. Và bây giờ vấn đề phía trên của chúng ta sẽ chỉ là:

```php
$post = updateContent();

$container->get('app.repository.post')->save($post);
```

Vài links để các bạn tìm hiểu thêm về vấn đề này:

http://symfony.com/blog/new-in-symfony-2-8-dependencyinjection-improvements

https://symfony.com/doc/current/service_container/alias_private.html

https://stovepipe.systems/post/service-decoration-in-practice

https://symfony.com/doc/2.7/service_container/service_decoration.html

http://www.marcelsud.com/service-decoration-with-symfony-2-3/
