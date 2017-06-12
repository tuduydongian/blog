---
title:      Symfony repository - a little practice
date:       2017-05-27
categories: symfony
tags:
    - best practice
---
Một vài practices và conventions có thể giúp cho việc sử dụng repository của bạn dễ thở hơn ;)
<!--more-->
### 1. Define repository as service

```yaml
app.repository.user:
    class: Doctrine\ORM\EntityRepository
    factory: ['@doctrine.orm.entity_manager', getRepository]
    arguments: [AppBundle\Entity\User]
```

Sử dụng:

```php
// old
$repository = $this->getDoctrine()->getRepository('AppBundle:User');

// new
$repository = $this->get('app.repository.user');
```

Việc khai báo repository thành service có các lợi điểm:

- Dễ dàng inject vào các service khác (thể hiện rõ ràng service depends những cháu nào)
- Khi thay đổi repository class chỉ việc thay đổi một chỗ ở `service.yml`

### 2. Put save method to repository

```php
class ProfileRepository extends EntityRepository
{
    public function save(Profile $profile)
    {
        $this->_em->persist($profile);
        $this->_em->flush();
    }
}
```

Sử dụng sẽ gọn gàng hơn:

```php
$profile = new Profile();

// old
$em = $this->getDoctrine()->getManager();
$em->persist($profile);
$em->flush();

// new
$repository = $this->get('app.repository.profile');
$repository->save($profile);
```

Ngoài ra có thêm 1 lợi điểm nữa là có thể tương tác với entity trước khi save vào db, ví dụ thay đổi giá trị `updatedAt = new \DateTime()`

### 3. Document var

Khi sử dụng method `custom` của repository, nên có `document var` cho repository. Lợi điểm là:

- Dễ tìm được những nơi nào sử dụng method này (Find Usage)
- Dễ tìm tới nơi define method (Go to Declaration)

```php
// don't need declare document var because this repository use find method (base method)
$repository = $this->get('app.repository.order');
$order = $repository->find($id);

/** @var PostRepository $repository */
$repository = $this->get('app.repository.post');
$post = $repository->findByCategoryAndAuthor($category, $author);
```

### 4. Method Custom Naming

Chúng ta nên có những quy chuẩn để việc sử dụng các method custom được dễ dàng hơn

- `findBy...`: trả về array các object mục tiêu (vs UserRepository trả về array object User) hoặc array rỗng
- `find...`: trả về object mục tiêu hoặc `null`
- `get...`: trả về các kết quả không phải là object mục tiêu. Vd: trong `UserRepository` có method `getIds` sẽ trả về array các id của `User`. Với loại này, cần lưu ý:
  - throw Exception mái thoải
  - nên có document dữ liệu sample trả về

```php
/**
  * @return array ['mbchest', 'mbheight']
  */
public function getIdsByGenderAndType(string $gender, string $type): array
{
    $alias = 'm';
    $result = $this->createQueryBuilder($alias)
        ->select($alias.'.id')
        ->where($alias.'.gender = :gender')
        ->andWhere($alias.'.type = :type')
        ->setParameters([
            'gender' => $gender,
            'type' => $type
        ])
        ->getQuery()->getResult();

    $ids = array_column($result, 'id');

    return $ids;
}
```

#### Feedback is welcome ;)
