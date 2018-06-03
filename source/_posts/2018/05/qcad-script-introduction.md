---
title:      Giới thiệu về QCAD script
date:       2018-05-24
categories: tools
tags:
  - qcad
  - js
---

Trích lời giới thiệu từ `QCAD official`:

```
- The QCAD Application ("QCAD") is a cross platform open source 2D CAD system.
- QCAD is based on the QCAD Application Framework, a framework that can be used to build CAD related applications in C++ or in ECMAScript.
```

Trong bài viết này sẽ gọi ngắn gọn:
- `QCAD Application`: `QCAD`
- `QCAD Application Framework`: `QCAD Framework`

Và `QCAD script` là cách mà chúng ta tương tác (sử dụng) API của `QCAD Framework`. Bạn có thể dùng C++ hoặc ECMAScript (Javascript) để viết script này.

<!--more -->

Đây là kiến trúc của `QCAD`:

![](http://www.qcad.org/doc/qcad/3.0/developer/qt_qcad_functionality.png)

Đi từ trái sang phải chính là các mức level (layers) mà `QCAD` implement.
- `Qt Application Framework` giúp tương tác với desktop system. VD: bạn sẽ dùng API của `Qt` để đọc, ghi file từ ổ cứng...
- `QCAD Application Framework` bao gồm các CAD core functionality.
- `ECMAScript`: đây chính là phần mặt tiền mà chúng ta có thể tác động vào. Khi `QCAD` khởi động, nó sẽ phải load tới file `autostart`. Nếu không truyền file này vào, file `autostart default` sẽ được sử dụng nằm ở `scripts/autostart.js`. Công việc viết `QCAD script` chính là viết lại file `autostart` này.

### QCAD script làm được những gì?

Chúng ta dùng `QCAD script` để xử lý các tác vụ liên quan tới 2D CAD (tính toán, xử lý hình học, import, export data). Chỉ cần nhớ:

- Những gì QCAD làm được, script làm được.
- Những gì QCAD không làm được, script có thể làm được.

Có 2 hướng để phát triển `QCAD script`:

- **Thêm mới hoặc sửa đổi các hành vi của `QCAD`**. VD: chúng ta có thể thêm 1 menu, khi chọn nó thì một dialog hiện lên, sau khi nhập một vài input thì một bản vẽ sẽ được gen ra.

![](http://www.qcad.org/doc/qcad/3.0/developer/ecmascript_extensions.png)

- **Xây dựng 1 ứng dụng hoàn toàn mới tách rời khỏi QCAD**. VD: các ứng dụng console hoặc desktop đọc CAD file, tính toán và export thành các file có format đặc biệt.

![](http://www.qcad.org/doc/qcad/3.0/developer/ecmascript_applications.png)

### Write the first script (console application):

**Bài toán**: Vẽ một hình chữ nhật và xuất nó ra file DXF.

**Giải quyết**: Chúng ta sẽ viết 1 script file có tên là `ex.js` với nội dung như sau (và chúng ta sẽ sử dụng ECMAScript):

#### Document init:

Đây là cụm code bắt buộc phải có khi ta làm việc với `QCAD script`:

```js
var storage = new RMemoryStorage();
var spatialIndex = new RSpatialIndexNavel();
var document = new RDocument(storage, spatialIndex);

var di = new RDocumentInterface(document);
```
- `RMemoryStorage` là nơi lưu trữ data thực tế.
- `RSpatialIndexNavel` là nơi giữ các index giúp cho việc query các entity được nhanh hơn.
- `RMemoryStorage` và `RSpatialIndexNavel` là 2 low levels data và chúng ta gần như không tương tác trực tiếp tới nó trong quá trình dev script.
- `RDocument` chính là một CAD document. Đây là lớp mà ta sẽ làm việc trực tiếp.
- `RDocumentInterface` chỉ cần thiết khi ta làm các tác vụ liên quan tới import, export, graphics scenes và views.
- Sau khi đoạn code này được load, đồng nghĩa với việc bạn đã có 1 CAD document với 1 vài init data (layer `0`, `model space` block,...)

#### Draw:

```js
var p1 = new RVector(0, 0);
var p2 = new RVector(20, 0);
var p3 = new RVector(20, 10);
var p4 = new RVector(0, 10);

var l1 = new RLineEntity(document, new RLineData(p1, p2));
var l2 = new RLineEntity(document, new RLineData(p2, p3));
var l3 = new RLineEntity(document, new RLineData(p3, p4));
var l4 = new RLineEntity(document, new RLineData(p4, p1));
```

- `RVector` là 1 point trong hệ toạ độ x-y
- `RLineEntity` là staight line, ngoài ra chúng ta còn có: `RSplineEntity`, `RPolylineEntity`,...

#### Operations

Vẽ thì đã vẽ rồi, tuy nhiên ta cần register lines vừa vẽ vào document. Chúng ta làm việc này bằng `RAddObjectsOperation`.

```js
var operation = new RAddObjectsOperation();

operation.addObject(l1);
operation.addObject(l2);
operation.addObject(l3);
operation.addObject(l4);

operation.apply(document);
```

- `RAddObjectsOperation` sẽ tạo ra transaction để apply những lines đó vào document.
- Vì chưa khai báo layer cho line nên mặc định line sẽ nằm ở default layer là layer `0`.

#### Export to file
Export document chúng ta vừa làm việc với version `DXF 2000` ở đường dẫn `/tmp/ex.dxf`

```js
di.exportFile('/tmp/ex.dxf', 'DXF 2000');
```

Tới đây chúng ta sẽ test thử script vừa viết bằng việc chạy command sau trên terminal và check file được gen ra ở `/tmp/ex.dxf`

```bash
./qcad -autostart ex.js
```

### Conclusion

Vậy là chúng ta đã vừa tìm hiểu qua về `QCAD script` và viết thử script đầu tiên. Bạn có thể tham khảo thêm và tìm kiếm `QCAD Framework API` ở trang [Doc for developer](http://www.qcad.org/doc/qcad/3.0/developer/index.html) của QCAD. Chúc vui!



