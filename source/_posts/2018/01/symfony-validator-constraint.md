---
title:      How to pass parameters to custom validation constraint in Symfony
date:       2018-01-31
categories: symfony
tags:
  - tips
---
Có lúc nào bạn cần validate data bằng validator cuả Symfony mà cần thêm các dữ liệu từ bên ngoài vào?

Sau đây mà một số cách mà mình đã sử dụng, tuỳ từng trường hợp mà áp dụng cho hợp lý.

Trước khi tiếp tục xem thì các bạn có thể  đọc qua một số bài viết để có cái nhìn rõ hơn:

[Validation](http://symfony.com/doc/current/validation.html)

[How to Create a custom Validation Constraint](https://symfony.com/doc/current/validation/custom_constraint.html)

<!-- more -->

### Bài toán

Khi bạn cần thay đổi email của user A, bạn cần phải check trong database xem email này đã được sử dụng bởi user nào khác user A hay chưa. Vậy để validate thì ngoài email ra ta cần thêm thông tin của user hiện tại.

### Cách 1: Pass class

```php
/**
 * @AppAssert\UniqueEmail()
*/
class User
{
    private $id;

    private $email;
}
```

Ở Constraint chỉ cần thay đổi `target`:

```php
class UniqueEmail extends Constraints
{
    public $messsage = 'Email already exists.';

    public function validateBy()
    {
        return UniqueEmailValidator::class;
    }

    public function getTargets()
    {
        return self::CLASS_CONSTRAINT;
    }
}
```
 Nếu muốn dùng constraint cho cả class và property thì chỉ cần: 
 ```php
     public function getTargets()
    {
        return [self::CLASS_CONSTRAINT, self::PROPERTY_CONSTRAINT];
    }
 ```

``` php
class UniqueEmailValidator extends ConstraintValidator
{
    public function validate($value, Constraint $constraint)
    {
        // lúc này $value sẽ là một User
        // thực hiện check
    }
}
```

### Cách 2: Tạo thêm property cho Constraint 

Thêm một property cho Constraint:
```php
class UniqueEmail extends Constraints
{
    public $messsage = 'Email already exists.';

    public $id;

    public function validateBy()
    {
        return UniqueEmailValidator::class;
    }
}
```
Lúc này có thể  pass giá trị cho `id`:
```php
class User
{
    private $id;

    /**
    * @AppAssert\UniqueEmail(id='foo')
    */
    private $email;
}
```
``` php
class UniqueEmailValidator extends ConstraintValidator
{
    public function validate($value, Constraint $constraint)
    {
        // $constraint->id = foo và có thể làm bất cứ thứ gì với nó
    }
}
```

Nếu phức tạp hơn một xíu thì bạn có thể pass vào tên của một function:

```php
class UniqueEmail extends Constraints
{
    public $messsage = 'Email already exists.';

    public $id;

    public function validateBy()
    {
        return UniqueEmailValidator::class;
    }
}
```
```php
class User
{
    private $id;

    /**
    * @AppAssert\UniqueEmail(id="getValue")
    */
    private $email;

    public function getValue()
    {
        // xử lý 
        return 'foo';
    }
}
```
``` php
class UniqueEmailValidator extends ConstraintValidator
{
    public function validate($value, Constraint $constraint)
    {
        // $constraint->id = 'getValue'
        // kiểm tra xem getValue có phải là tên của function không 

        if (!is_callable($id = [$this->context->getObject(), $constraint->id)] && !is_callable($id = [$this->context->getClassName(), $constraint->id)] && !is_callable($id = $constraint->id)) {
            throw new ConstraintDefinitionException('Id is invalid');
            }
            $id = call_user_func($id);
            // $id = foo
    }
}
```
### Kết bài
Mong sau bài viết này các bạn có thể hiểu thêm về  Validator Constraint của Symfony và nếu có ý kiến hoặc cách nào hay ho hơn nữa thì đừng ngần ngại mà comment bên dưới nhé.