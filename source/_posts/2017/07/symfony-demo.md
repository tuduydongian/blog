---
title:      Vài thứ hay ho từ Symfony Demo
date:       2017-07-26
categories: symfony
tags:
    - best practice
---

Bữa nay rảnh rỗi clone Symfony demo (ver hiện tại chạy với Symfony 3.3.*) về để xem thử mặt mũi nó thế nào, và cũng quả không phí, có vài thứ bản thân nhận thấy khá là hay ho.

<!--more--> 

### Không handle được nội dung của logout action

Khi bạn configure logout của firewall như này:

```yaml
security:
    firewalls:
        secured_area:
            logout:
                path: security_logout
```

Done, khi bạn tạo một route mới với name là `security_logout` thì xin chúc mừng, Symfony sẽ tự động handle việc logout của user và bạn sẽ chả làm được gì ở cái action này

```php
/**
 * Symfony will intercept this first and handle the logout automatically.
 *
 * @Route("/logout", name="security_logout")
 */
public function logoutAction()
{
    throw new \Exception('Never hit to here :((');
}
```

### Symfony Styles

Bắt đầu từ Symfony 2.7, `Symfony Styles` được giới thiệu. Công việc của nó là giúp cho các command bạn viết ra được `consistent`. Và việc sử dụng nó gần như là bắt buộc nếu các command của bạn có sự tương tác cao khi sử dụng (như render `list`, `table`, `process bar`, `confirm`, ...)

```php
class GreetCommand extends ContainerAwareCommand
{
    protected function execute(InputInterface $input, OutputInterface $output)
    {
        $io = new SymfonyStyle($input, $output);
        $io->title('Lorem Ipsum Dolor Sit Amet');

        // ...
    }
}
```

Xem thêm về cháu nó: [Symfony Styles](http://symfony.com/doc/current/console/style.html)

### Submit form with multiple buttons

Trong trường hợp form của bạn có nhiều submmit buttons thì bạn handle nó bằng việc kiểm tra `isClicked` của button đó. (Lưu ý: submmit button add trong template nhé, đừng như ví dụ bên dưới)

```php
$form = $this->createFormBuilder($task)
    ->add('task', TextType::class)
    ->add('save', SubmitType::class, array('label' => 'Create Task'))
    ->add('saveAndAdd', SubmitType::class, array('label' => 'Save and Add'))
    ->getForm();

if ($form->isSubmitted() && $form->isValid()) {
    $nextAction = $form->get('saveAndAdd')->isClicked()
        ? 'task_new'
        : 'task_success';

    return $this->redirectToRoute($nextAction);
}
```

Xem thêm: [How to Submit a Form with Multiple Buttons](https://symfony.com/doc/current/form/multiple_buttons.html)

### Việc check `$form->isSubmmited()` chỉ là optional

Bình thường lúc viết code ta sẽ viết như này:

```php
if ($form->isSubmitted() && $form->isValid()) {
    $post = $form->getData();
}
```

Thực tế thì việc check `$form->isSubmitted()` là không cần thiết vì `$form->isValid()` đã ôm luôn việc check submmited trong đó rồi. Vậy tại sao ta vẫn cứ viết như vậy? Câu trả lời là vì thuận miệng, thuận mắt (from Symfony demo: `to improve code readability`)

### Security annotation

Khi bạn giỏi tiếng Anh và thích viết những message exception thật trất thì:

```php
/*
 * @Method("GET")
 */
public function showAction(Post $post)
{
    $this->denyAccessUnlessGranted('show', $post, 'Posts can only be shown to their authors.');
    
    dump($post);
}
```

Tuy nhiên dốt thì không có quyền được deep, âu cơ, sử dụng annotation, khỏi message gì sất:

```php
/*
 * @Method("GET")
 * @Security("is_granted('show', post)")
 */
public function showAction(Post $post)
{
    dump($post);
}
```

### Define util as service

Đây là cái mình thấy khá dị từ Symfony demo và một vài opensource khác, define thành service hết bất kể (`static function` là cái gì dạ?). Không biết nên thế nào là hợp lý hơn và xin nhắc lại tí:

- Service nếu không gọi đến thì nó cũng chả tự chạy đâu mà sợ tốn memory
- Symfony giờ đã có `autowired`, xài service éo cần quan tâm cháu nó tên gì nữa, cứ pass nó thành args của action mà táng

```php
public function editAction(Request $request, Post $post, Slugger $slugger)
{
    $name = $request->request->get('name');

    $post->setName($name);
    $post->setSlug($slugger->generate($name));
}
```

### Render controller

Thử tưởng tượng bạn render một page `show post` có phần `related posts`. Có nhiều cách để làm được cái phần đó như là:
- query đống posts đó ra ngay trong `showPostAction` và render như phình phường
- render cháu nó bằng ajax append
- viết 1 action mới (không nhất thiết phải có router) và render cháu nó trong template của `showPostAction`. Đây là cách khuyến cáo vì nó sáng sủa và rõ ràng

```php
public function relatedPostsAction(Post $post) {
    $posts = $repository->findRelated($post);

    return $this->render(...);
}
```

```php
public function showPostAction(Post $post) {
    return $this->render(...);
}
```

```javascript
// template of showPostAction
{{ render(controller('AppBundle:Blog:relatedPosts', {'id': post.id})) }}
```

### DependentFixtureInterface

Khi tạo `DataFixture`, có những data set bạn cần phải có data từ những fixture trước. VD: khi chạy fixture `Order`, bạn cần có `Product`, `Customer` trước. Để giải quyết, bạn có 2 cách:

- Sử dụng `OrderedFixtureInterface` (thô thiển và mất công handle order number)

```php
class Customer implements FixtureInterface, OrderedFixtureInterface {
    public function load() {
        $this->addReference('foo', $foo);    
    }

    public function getOrder()
    {
        return 0;
    }
}

class Product implements FixtureInterface, OrderedFixtureInterface {
    public function load() {
        $this->addReference('bar', $bar);    
    }

    public function getOrder()
    {
        return 1;
    }
}

class Order implements FixtureInterface, OrderedFixtureInterface {
    public function load() {
        $customer = $this->getReference('foo');
        $product = $this->getReference('bar');
    }

    public function getOrder()
    {
        return 2;
    }
}
```

- Xài `DependentFixtureInterface` <- right way, code sẽ clean hơn RẤT RẤT nhiều

```php
class Customer implements FixtureInterface {
    public function load() {
        $this->addReference('foo', $foo);    
    }
}

class Product implements FixtureInterface {
    public function load() {
        $this->addReference('bar', $bar);    
    }
}

class Order implements FixtureInterface, DependentFixtureInterface {
    public function load() {
        $customer = $this->getReference('foo');
        $product = $this->getReference('bar');
    }

    public function getDependencies()
    {
        return [
            Customer::class,
            Product::class,
        ];
    }
}
```

### Trans everywhere

Bạn có thể apply được trans ở rất nhiều chỗ (controller, template,...) trong đó có `Entiy constraints message` & `form label` (và tất nhiên, trans hay không là tùy bạn, mình thì nhác)

```php
use Symfony\Component\Validator\Constraints as Assert;

class Post
{
    /**
     * @var string
     *
     * @ORM\Column(type="string")
     * @Assert\NotBlank(message="post.blank_summary")
     */
    private $summary;

    /**
     * @var string
     *
     * @ORM\Column(type="text")
     * @Assert\NotBlank(message="post.blank_content")
     * @Assert\Length(min=10, minMessage="post.too_short_content")
     */
    private $content;
}
```

```php
class PostType extends AbstractType
{
    public function buildForm(FormBuilderInterface $builder, array $options)
    {
        $builder->add('title', null, [
            'attr' => ['autofocus' => true],
            'label' => 'label.title',
        ]);
    }
}
```

### Data provider and yield

Biết cái `yield` này rồi mới thấy hồi viết data provider mình bị ngu các bợn ạ. À, tất nhiên bạn thích dùng kiểu nào là tùy nhé, mình chả nói gì đâu :troll:

```php
/**
 * @dataProvider getUrlsForRegularUsers
 */
public function testAccessDeniedForRegularUsers($httpMethod, $url)
{
    $client->request($httpMethod, $url);
}
```

```php
// Old
public function getUrlsForRegularUsers(): array
{
    return [
        ['GET', '/en/admin/post/'],
        ['GET', '/en/admin/post/1'],
        ['GET', '/en/admin/post/1/edit'],
        ['POST', '/en/admin/post/1/delete']
    ];
}
```

```php
// New
public function getUrlsForRegularUsers()
{
    yield ['GET', '/en/admin/post/'];
    yield ['GET', '/en/admin/post/1'];
    yield ['GET', '/en/admin/post/1/edit'];
    yield ['POST', '/en/admin/post/1/delete'];
}
```

Âu cơ, đây là những thứ mình thấy hay ho khi lần đầu tiên thực sự clone Symfony demo về máy thay vì cưỡi ngựa xem hoa qua giao diện UI của github.

Về cơ bản, nó là những kiến thức cơ bản nên nếu cơ bản bạn thấy nó cơ bản thì đúng là nó cơ bản thật và đừng cười mình nhé :troll: