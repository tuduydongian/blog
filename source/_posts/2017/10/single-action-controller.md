---
title:      Single Action Controller
date:       2017-10-24
categories: php
tags:
  - best practice
---
- Khi nhìn những controller với cả chục methods, bạn có vui cảm thấy dễ chịu không?
- Khi phải nhận nhiệm vụ sửa 1 endpoint, mò tìm cái action method tương ứng để sửa bạn có vui không?

(Tất nhiên là mình ví dụ thôi, chứ controller mà kinh hoàng vậy thì design chắc chắn có vấn đề rồi).

Vậy thì hãy thử qua ý tưởng về `Single Action Controller`
<!-- more -->

Nghe tên thì nó kêu vậy thôi, chứ thực ra thì công việc chỉ là chia nhỏ cái `old controller` hầm hố kia thành nhiều `new controller`, với mỗi `action` là một `controller` nằm trong 1 file code (`mini controller`).

Eg:

```php
class ShowPost extends Controller
{
    /**
     * Show post
     */
    public function __invoke(string $id)
    {
        $post = $this->getPost(...);

        // do something

        return $post;
    }
}
```


```php
class CreatePost extends Controller
{
    private $mailer;

    public function __construct(Mailer $mailer) {
        $this->mailer = $mailer;
    }

    /**
     * Create new post
     */
    public function __invoke()
    {
        $post = new Post();

        // do something

        $this->mailer->sendMail(...);

        return $post;
    }
}
```


```php
class EditPost extends Controller
{
    /**
     * Create new post
     */
    public function __invoke(string $id)
    {
        $post = $this->getPost(...);

        $this->denyAccessUnlessGrantedEdit($post);

        // do something

        return $post;
    }

    private function denyAccessUnlessGrantedEdit(Post $post)
    {
        if ($this->isAuthor($post) || $this->isAdmin()) {
            return;
        }

        throw $this->createAccessDeniedException();
    }
}
```

Như bạn thấy, ở phía trên mình tạo ra 3 `mini controller` làm 3 công việc rất __Single responsibility__ và tất nhiên các công việc chung thì vẫn nằm ở các component phụ trợ để đảm bảo tính __DRY__

#### Đây là ý tưởng hay (Ưu điểm)?

- Chia nhỏ `controller` hầm hố thành các `mini controller`, tránh được việc đập vào mặt một controller hơn ngàn dòng.
- Dễ mò tới code của endpoint (theo controller cổ điển, từ router để mò được tới action trong code, đôi khi rất cực nếu không có kinh nghiệm).
- Dễ sửa chữa, maintain.
- Các dependencies cho mỗi action là khác nhau (chẳng hạn ở VD trên, `CreatePost` cần Mailer còn các endpoint khác thì không), chia nhỏ sẽ giúp cho việc inject và kiểm soát các component dễ dàng hơn.
- Vì dependencies rõ ràng nên việc testing sẽ dễ hơn nhiều.

#### Không, rõ ràng là ý tưởng tồi (Nhược điểm)!

- Thực tế, chỉ là split code từ 1 nơi thành nhiều nơi, không có tí chất xám nào trong đó.
- Dẫn tới có quá nhiều files được tạo ra.

### Conclusion

Bản thân mình thấy đây cũng là một phương án hay, phù hợp với những project có số resources ít nhưng xử lý behavior phức tạp. Vài links tham khảo về vấn đề này:

https://laravel.com/docs/5.5/controllers#single-action-controllers

https://github.com/pmjones/adr

https://dunglas.fr/2016/01/dunglasactionbundle-symfony-controllers-redesigned/

