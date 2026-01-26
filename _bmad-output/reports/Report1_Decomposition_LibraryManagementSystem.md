# BÁO CÁO 1: PHÂN RÃ
# REPORT 1: DECOMPOSITION

---

## ĐẠI HỌC FPT
## FPT UNIVERSITY

**Thể loại:** Assignment
**CHỦ ĐỀ:** XÂY DỰNG HỆ THỐNG CƠ SỞ DỮ LIỆU QUẢN LÝ THƯ VIỆN
**TOPIC:** BUILDING A DATABASE SYSTEM FOR LIBRARY MANAGEMENT

**MÔN HỌC:** HỆ THỐNG CƠ SỞ DỮ LIỆU
**COURSE:** DATABASE SYSTEMS (DBI202)

---

## MỤC LỤC | TABLE OF CONTENTS

### 0. GIỚI THIỆU TỔNG QUAN | INTRODUCTION
   - 0.1 Phân tích bối cảnh và vấn đề bài toán | Context Analysis and Problem Statement
   - 0.2 Yêu cầu chức năng từ người dùng | Functional Requirements
   - 0.3 Phạm vi dự án và công cụ sử dụng | Project Scope and Tools

### I. BÁO CÁO 1: PHÂN RÃ | REPORT 1: DECOMPOSITION
   - 1.1 Phân công nhiệm vụ | Task Assignment
   - 1.2 Cơ sở lý thuyết | Theoretical Foundation
   - 1.3 Tập thực thể | Entity Sets
   - 1.4 Các mối quan hệ | Relationships
   - 1.5 Thuộc tính | Attributes
   - 1.6 Sơ đồ Thực thể - Mối quan hệ | Entity-Relationship Diagram
   - 1.7 Kết luận báo cáo 1 | Report 1 Conclusion

---

## 0. GIỚI THIỆU TỔNG QUAN | INTRODUCTION

### 0.1 Phân tích bối cảnh và vấn đề bài toán | Context Analysis and Problem Statement

#### Bối cảnh bài toán | Context

Một thư viện (Library) cần xây dựng một hệ thống cơ sở dữ liệu để lưu trữ và quản lý toàn bộ thông tin liên quan đến các hoạt động quản lý sách và dịch vụ cho độc giả. Hệ thống này phải đảm bảo khả năng theo dõi thông tin chi tiết về các cuốn sách (books), các tác giả (authors), nhà xuất bản (publishers), bản sao sách (book copies), và thành viên thư viện (library members). Dữ liệu bao gồm thông tin xuất bản, thông tín mượn/trả sách, tình trạng sách, và các khoản phí phạt khi trả sách muộn.

#### Vấn đề cần giải quyết | Problem Statement

Bài toán đặt ra là phải thiết kế một mô hình cơ sở dữ liệu quan hệ có khả năng biểu diễn chính xác các mối quan hệ phức tạp giữa các thực thể nói trên. Cụ thể:

*   Mỗi cuốn sách có thể có nhiều tác giả, và mỗi tác giả có thể viết nhiều sách (mối quan hệ nhiều-nhiều).
*   Mỗi cuốn sách có thể có nhiều bản sao (copies), và mỗi bản sao có thể được mượn bởi một thành viên tại một thời điểm.
*   Mỗi cuốn sách được xuất bản bởi một nhà xuất bản duy nhất.
*   Thành viên thư viện có thể mượn nhiều sách, và mỗi lần mượn cần lưu trữ thông tin ngày mượn, ngày hết hạn, ngày trả, và khoản phí phạt (nếu có).
*   Hệ thống phải hỗ trợ các báo cáo: sách được mượn nhiều nhất, lịch sử mượn sách của thành viên, các sách quá hạn, và thống kê sách theo tác giả hoặc nhà xuất bản.

Do đó, yêu cầu cốt lõi của bài toán là phân tích, xác định các thực thể, thuộc tính, và mối quan hệ giữa chúng, sau đó chuẩn hóa dữ liệu để đảm bảo tính toàn vẹn, tránh dư thừa và hỗ trợ truy vấn hiệu quả cho hoạt động quản lý của thư viện.

---

### 0.2 Yêu cầu chức năng từ người dùng | Functional Requirements

Dựa trên nhu cầu quản lý thư viện, cơ sở dữ liệu phải hỗ trợ các chức năng sau:

#### Quản lý sách | Book Management

**Yêu cầu:**
*   Lưu trữ thông tin chi tiết về các cuốn sách, bao gồm:
    *   Mã sách (Book ID) - định danh duy nhất
    *   Tên sách (Title)
    *   Thể loại/Sự phân loại (Subject Category)
    *   Năm xuất bản (Publication Year)
    *   Nhà xuất bản (Publisher)

**Mục đích:** Hệ thống có thể tra cứu, tìm kiếm và quản lý danh mục sách hiệu quả.

---

#### Quản lý tác giả | Author Management

**Yêu cầu:**
*   Lưu trữ thông tin chi tiết về các tác giả:
    *   Mã tác giả (Author ID) - định danh duy nhất
    *   Tên tác giả (Name)
    *   Quốc tịch (Nationality)
    *   Năm sinh (Year of Birth)

**Mục đích:** Theo dõi danh mục tác giả và các tác phẩm của họ.

---

#### Quản lý nhà xuất bản | Publisher Management

**Yêu cầu:**
*   Lưu trữ thông tin về các nhà xuất bản:
    *   Mã nhà xuất bản (Publisher ID) - định danh duy nhất
    *   Tên nhà xuất bản (Name)
    *   Địa chỉ (Address)
    *   Số điện thoại liên hệ (Contact Number)

**Mục đích:** Quản lý thông tin đối tác cung cấp sách.

---

#### Quản lý bản sao sách | Book Copy Management

**Yêu cầu:**
*   Lưu trữ thông tin về từng bản sao vật lý của sách:
    *   Mã bản sao (Copy ID) - định danh duy nhất
    *   Tình trạng (Condition) - mới, cũ, hư hại
    *   Trạng thái (Status) - có sẵn, đang mượn, bảo dưỡng

**Mục đích:** Theo dõi chính xác số lượng sách sẵn sàng cho mượn.

---

#### Quản lý thành viên | Member Management

**Yêu cầu:**
*   Lưu trữ thông tin thành viên thư viện:
    *   Mã thành viên (Member ID) - định danh duy nhất
    *   Tên thành viên (Name)
    *   Địa chỉ (Address)
    *   Số điện thoại (Phone Number)
    *   Loại thành viên (Membership Type) - sinh viên, giảng viên, độc giả thường

**Mục đích:** Quản lý thông tin độc giả và phân loại quyền lợi.

---

#### Quản lý mượn/trả sách | Loan Management

**Yêu cầu:**
*   Lưu trữ chi tiết các giao dịch mượn/trả:
    *   Mã mượn (Loan ID) - định danh duy nhất
    *   Ngày mượn (Borrow Date)
    *   Ngày hết hạn (Due Date)
    *   Ngày trả (Return Date)
    *   Phí phạt quá hạn (Overdue Fine) - tính theo ngày

**Mục đích:** Theo dõi luồng sách mượn/trả và tính toán phí phạt.

---

#### Báo cáo thống kê | Reporting Requirements

**Yêu cầu:**
*   **Sách được mượn nhiều nhất:** Tổng hợp số lần mượn của từng sách
*   **Lịch sử mượn của thành viên:** Xem tất cả sách một thành viên đã mượn
*   **Sách quá hạn:** Liệt kê sách chưa trả và quá hạn
*   **Thống kê theo tác giả:** Số lượng sách và lượt mượn theo từng tác giả
*   **Thống kê theo nhà xuất bản:** Số lượng sách theo từng nhà xuất bản

**Mục đích:** Hỗ trợ quản lý ra quyết định về mua sách, điều chỉnh quy định, và cải thiện dịch vụ.

---

### 0.3 Phạm vi dự án và công cụ sử dụng | Project Scope and Tools

#### Phạm vi dự án | Project Scope

**Trong phạm vi dự án | In Scope:**

*   Phân tích yêu cầu và thiết kế sơ đồ ERD
*   Chuyển đổi ERD sang mô hình quan hệ (Relational Data Model)
*   Chuẩn hóa cơ sở dữ liệu đến 3NF (Third Normal Form)
*   Định nghĩa lược đồ cơ sở dữ liệu với các ràng buộc (Constraints)
*   Triển khai cơ sở dữ liệu trên SQL Server
*   Thêm dữ liệu mẫu (Sample Data)
*   Tạo các stored procedures, functions, và triggers
*   Viết các câu lệnh SQL truy vấn cho báo cáo

**Ví dụ về các câu truy vấn SQL cần triển khai:**
*   Liệt kê tất cả các tác phẩm của một tác giả cụ thể
*   Tìm các thành viên đang mượn sách quá hạn
*   Thống kê sách được mượn nhiều nhất
*   Tính tổng phí phạt của một thành viên
*   Lấy lịch sử mượn sách của một thành viên

**Ngoài phạm vi dự án | Out of Scope:**

*   Giao diện người dùng đồ họa (GUI/Web Application)
*   Hệ thống thanh toán điện tử
*   Quản lý kho phức tạp (đặt hàng, nhập hàng)
*   Hệ thống thông báo tự động (email/SMS)
*   Phân tích dữ liệu nâng cao (Data Analytics)
*   Quản lý người dùng và phân quyền chi tiết

---

#### Công cụ sử dụng | Tools and Technologies

| Công cụ | Mục đích | Lý do chọn |
|---------|----------|------------|
| **SQL Server** | Hệ quản trị cơ sở dữ liệu | Đáng tin cậy, hỗ trợ T-SQL đầy đủ, phù hợp với môi trường học thuật |
| **SQL Server Management Studio (SSMS)** | Công cụ phát triển | Giao diện trực quan, hỗ trợ viết và debug T-SQL |
| **draw.io / DiagramGPT** | Tạo sơ đồ ERD | Công cụ trực quan, hỗ trợ AI-assisted diagram creation |
| **T-SQL** | Ngôn ngữ truy vấn | Ngôn ngữ chuẩn của SQL Server, hỗ trợ procedural logic |
| **Git / GitHub** | Quản lý phiên bản | Theo dõi thay đổi mã nguồn và tài liệu |
| **Microsoft Word / Markdown** | Tài liệu hóa | Tạo báo cáo và tài liệu kỹ thuật |

---

## I. BÁO CÁO 1: PHÂN RÃ | REPORT 1: DECOMPOSITION

### 1.1 Phân công nhiệm vụ | Task Assignment

| MSSV | Họ và tên | Phân công nhiệm vụ | Đánh giá |
|------|-----------|-------------------|----------|
| SE200064 | Lê Khôi Nguyên | Thiết kế E/R Diagram, kiểm tra chất lượng tài liệu về chuyên môn | Điểm: 10 - Tốt, chủ động đưa ý kiến cải thiện |
| SE191001 | Nguyễn Thị Thanh Thảo | Thu thập và phân tích yêu cầu người dùng, phạm vi dự án và công cụ sử dụng | Điểm: 10 - Tốt, chủ động trong giao tiếp |
| SE201706 | Trần Đình Bảo Hoàng | Xác định mối quan hệ giữa các thực thể và các thực thể dẫn xuất | Điểm: 2 - Cần cải thiện |
| SE201711 | Đoàn Đức Nguyên | Xác định mối quan hệ giữa các thực thể và các thực thể dẫn xuất | Điểm: 2 - Cần cải thiện |
| SE191138 | Nguyễn Tiến Dũng | Xác định các thực thể (Entity) và thuộc tính (Attributes) | Điểm: 7 - Hoàn thành đúng nhiệm vụ |
| SE171267 | Trần Phương Uyên | Tổng hợp các tài liệu và viết báo cáo 1 | Điểm: 9 - Hoàn thành tốt |
| SS170814 | Lê Kim Ngân | Phân công nhiệm vụ, kiểm tra và chỉnh sửa tài liệu về chuyên môn | Điểm: 10 - Tốt, chủ động trong giao tiếp |

---

### 1.2 Cơ sở lý thuyết | Theoretical Foundation

#### A. Khái niệm về Phân rã (Decomposition)

Phân rã trong thiết kế cơ sở dữ liệu là quá trình đầu tiên và quan trọng nhất trong việc chuyển đổi các yêu cầu nghiệp vụ phức tạp thành một mô hình dữ liệu có cấu trúc. Quá trình này bao gồm:

**1. Xác định Thực thể (Entity Identification):**
*   Nhận diện các đối tượng chính trong hệ thống cần quản lý
*   Mỗi thực thể đại diện cho một danh mục (category) của dữ liệu
*   Ví dụ: Book (Sách), Member (Thành viên), Loan (Mượn/trả)

**2. Xác định Thuộc tính (Attribute Identification):**
*   Mô tả các đặc điểm chi tiết của từng thực thể
*   Phân loại thuộc tính: đơn (simple), phức hợp (composite), đa trị (multi-valued), dẫn xuất (derived)
*   Xác định khóa chính (Primary Key) để định danh duy nhất

**3. Xác định Mối quan hệ (Relationship Identification):**
*   Mô tả sự liên kết giữa các thực thể
*   Xác định bội số (cardinality): 1-1, 1-N, N-M
*   Xác định tính chất (optionality): bắt buộc hoặc tùy chọn

**Kết quả:** Sơ đồ Thực thể - Mối quan hệ (Entity-Relationship Diagram - ERD), giúp trực quan hóa cấu trúc dữ liệu trước khi chuyển đổi sang mô hình quan hệ.

---

#### B. Các thành phần chính trong mô hình E/R

**1. Entity (Thực thể):**

*   **Định nghĩa:** Là tập hợp các đối tượng có cùng đặc điểm và thuộc tính
*   **Biểu diễn:** Hình chữ nhật trong ERD
*   **Đặc điểm:**
    *   Có tên duy nhất (không trùng lặp)
    *   Có khóa chính (Primary Key) để định danh
    *   Có thể là thực thể mạnh (strong entity) hoặc thực thể yếu (weak entity)

**Ví dụ:**
```
┌─────────────┐
│    BOOK     │  ← Thực thể
├─────────────┤
│ BookID (PK) │  ← Khóa chính
│ Title       │  ← Thuộc tính
│ Category    │
│ Year        │
└─────────────┘
```

---

**2. Attribute (Thuộc tính):**

*   **Định nghĩa:** Mô tả các đặc trưng của thực thể hoặc mối quan hệ
*   **Biểu diễn:** Hình ellip trong ERD
*   **Phân loại:**

| Loại thuộc tính | Mô tả | Ví dụ |
|-----------------|--------|-------|
| **Simple (Đơn)** | Không thể chia nhỏ | Title, Year |
| **Composite (Phức hợp)** | Có thể chia nhỏ thành các thuộc tính nhỏ hơn | Address = Street + City + ZipCode |
| **Multi-valued (Đa trị)** | Có nhiều giá trị | Phone numbers |
| **Derived (Dẫn xuất)** | Giá trị được tính từ thuộc tính khác | Age = CurrentYear - BirthYear |
| **Key (Khóa)** | Định danh duy nhất | BookID, ISBN |

---

**3. Relationship (Mối quan hệ):**

*   **Định nghĩa:** Mô tả sự liên kết giữa hai hoặc nhiều thực thể
*   **Biểu diễn:** Hình thoi (diamond) trong ERD
*   **Bội số (Cardinality):**

| Loại | Biểu diễn | Ý nghĩa |
|------|-----------|---------|
| **One-to-One (1:1)** | 1 — 1 | Một bản ghi của A liên kết với một bản ghi của B |
| **One-to-Many (1:N)** | 1 — N | Một bản ghi của A liên kết với nhiều bản ghi của B |
| **Many-to-Many (N:M)** | M — N | Nhiều bản ghi của A liên kết với nhiều bản ghi của B |

**Ví dụ:**
```
    PUBLISHER         BOOK
         1      ──→     N
(một nhà xuất bản  (nhiều sách)
   có nhiều sách)
```

---

**4. Cardinality (Bội số) & Participation (Sự tham gia):**

*   **Cardinality:** Số lượng tối thiểu và tối đa của thực thể tham gia vào mối quan hệ
    *   (0, 1): Tối thiểu 0, tối đa 1
    *   (1, 1): Bắt buộc 1, tối đa 1
    *   (0, N): Tối thiểu 0, tối đa N
    *   (1, N): Bắt buộc 1, tối đa N

*   **Participation:** Tính chất bắt buộc hoặc tùy chọn của mối quan hệ
    *   **Total Participation (Tham gia toàn bộ):** Mọi thực thể đều phải tham gia
    *   **Partial Participation (Tham gia một phần):** Một số thực thể không tham gia

---

#### C. Quy trình xác định E/R Diagram

**Bước 1: Phân tích yêu cầu bài toán**

*   Đọc và hiểu rõ yêu cầu nghiệp vụ
*   Xác định các đối tượng cần quản lý
*   Liệt kê các chức năng chính

**Bước 2: Xác định các thực thể chính**

*   Tìm các danh từ chính trong yêu cầu
*   Mỗi danh từ thường đại diện cho một thực thể
*   Đặt tên thực thể theo quy ước (số ít, viết hoa)

**Bước 3: Xác định mối quan hệ giữa các thực thể**

*   Tìm các động từ mô tả sự liên kết
*   Xác định bội số (1-1, 1-N, N-M)
*   Xác định tính chất (bắt buộc/tùy chọn)

**Bước 4: Liệt kê thuộc tính cho từng thực thể**

*   Tìm các tính từ mô tả đặc điểm
*   Phân loại thuộc tính (đơn, phức hợp, đa trị, dẫn xuất)
*   Xác định khóa chính (PK) và khóa ngoại (FK)

**Bước 5: Vẽ sơ đồ E/R**

*   Sử dụng công cụ: draw.io, Visual Paradigm, ERDPlus
*   Biểu diễn:
    *   Thực thể: Hình chữ nhật
    *   Thuộc tính: Hình ellip
    *   Mối quan hệ: Hình thoi
*   Thêm khóa chính và khóa ngoại

**Bước 6: Kiểm tra và hoàn thiện**

*   Rà soát lại các yêu cầu
*   Đảm bảo tất cả thực thể và mối quan hệ đã được thể hiện
*   Xác minh tính chính xác của bội số
*   Chuẩn bị cho bước chuyển đổi sang mô hình quan hệ

---

### 1.3 Tập thực thể | Entity Sets

Sau khi phân tích yêu cầu bài toán, chúng tôi xác định được **6 thực thể chính** cần quản lý trong hệ thống thư viện:

---

#### **1. BOOK (SÁCH)**

**Mô tả thực thể:**
Lưu trữ thông tin về các cuốn sách trong thư viện. Mỗi cuốn sách đại diện cho một tác phẩm có tên duy nhất, được phân loại theo thể loại, xuất bản trong một năm nhất định.

**Thuộc tính:**
| Thuộc tính | Kiểu dữ liệu | Mô tả | Ràng buộc |
|------------|--------------|-------|-----------|
| **BookID** | INT | Mã định danh duy nhất của sách | PRIMARY KEY, NOT NULL |
| **ISBN** | VARCHAR(17) | Mã số tiêu chuẩn quốc tế cho sách | UNIQUE, NULL |
| **Title** | VARCHAR(255) | Tên tiêu đề của sách | NOT NULL |
| **SubjectCategory** | VARCHAR(100) | Thể loại phân loại sách | NULL |
| **PublicationYear** | INT | Năm xuất bản sách | NULL |
| **PublisherID** | INT | Mã nhà xuất bản | FOREIGN KEY |

**Ghi chú:**
*   BookID được tự động tăng (IDENTITY) để đảm bảo tính duy nhất
*   ISBN là mã quốc tế, có thể NULL cho sách cũ
*   SubjectCategory dùng để phân loại sách (Văn học, Khoa học, Kỹ thuật, etc.)
*   PublisherID là khóa ngoại tham chiếu đến thực thể PUBLISHER

---

#### **2. AUTHOR (TÁC GIẢ)**

**Mô tả thực thể:**
Lưu trữ thông tin cá nhân về các tác giả của sách. Mỗi tác giả được định danh duy nhất và có thể có nhiều sách.

**Thuộc tính:**
| Thuộc tính | Kiểu dữ liệu | Mô tả | Ràng buộc |
|------------|--------------|-------|-----------|
| **AuthorID** | INT | Mã định danh duy nhất của tác giả | PRIMARY KEY, NOT NULL |
| **Name** | VARCHAR(255) | Tên đầy đủ của tác giả | NOT NULL |
| **Nationality** | VARCHAR(100) | Quốc tịch của tác giả | NULL |
| **YearOfBirth** | INT | Năm sinh của tác giả | NULL |

**Ghi chú:**
*   AuthorID được tự động tăng
*   Một tác giả có thể viết nhiều sách (mối quan hệ 1:N)
*   Một sách có thể có nhiều tác giả (mối quan hệ N:M)
*   Cần bảng trung gian BOOK_AUTHOR để quản lý mối quan hệ N:M

---

#### **3. PUBLISHER (NHÀ XUẤT BẢN)**

**Mô tả thực thể:**
Lưu trữ thông tin về các nhà xuất bản. Mỗi nhà xuất bản xuất bản nhiều sách, nhưng mỗi sách chỉ thuộc về một nhà xuất bản.

**Thuộc tính:**
| Thuộc tính | Kiểu dữ liệu | Mô tả | Ràng buộc |
|------------|--------------|-------|-----------|
| **PublisherID** | INT | Mã định danh duy nhất của nhà xuất bản | PRIMARY KEY, NOT NULL |
| **Name** | VARCHAR(255) | Tên nhà xuất bản | NOT NULL |
| **Address** | VARCHAR(500) | Địa chỉ của nhà xuất bản | NULL |
| **ContactNumber** | VARCHAR(50) | Số điện thoại liên hệ | NULL |

**Ghi chú:**
*   PublisherID được tự động tăng
*   Mối quan hệ với BOOK là 1:N (một nhà xuất bản có nhiều sách)
*   ContactNumber có thể bao gồm mã vùng quốc gia

---

#### **4. BOOK_COPY (BẢN SAO SÁCH)**

**Mô tả thực thể:**
Lưu trữ thông tin về từng bản sao vật lý của sách trong thư viện. Mỗi cuốn sách có thể có nhiều bản sao, mỗi bản sao có thể mượn độc lập.

**Thuộc tính:**
| Thuộc tính | Kiểu dữ liệu | Mô tả | Ràng buộc |
|------------|--------------|-------|-----------|
| **CopyID** | INT | Mã định danh duy nhất của bản sao | PRIMARY KEY, NOT NULL |
| **BookID** | INT | Mã sách mà bản sao thuộc về | FOREIGN KEY, NOT NULL |
| **Condition** | VARCHAR(50) | Tình trạng bản sao | NULL |
| **Status** | VARCHAR(20) | Trạng thái hiện tại của bản sao | NOT NULL, DEFAULT 'Available' |

**Ghi chú:**
*   CopyID được tự động tăng
*   BookID là khóa ngoại tham chiếu đến BOOK
*   Condition có thể là: 'New' (Mới), 'Good' (Tốt), 'Fair' (Trung bình), 'Poor' (Kém)
*   Status có thể là: 'Available' (Sẵn sàng), 'Borrowed' (Đang mượn), 'Maintenance' (Bảo dưỡng), 'Lost' (Mất)

---

#### **5. MEMBER (THÀNH VIÊN)**

**Mô tả thực thể:**
Lưu trữ thông tin về thành viên thư viện. Thành viên có thể mượn sách và cần tuân thủ các quy định về mượn/trả.

**Thuộc tính:**
| Thuộc tính | Kiểu dữ liệu | Mô tả | Ràng buộc |
|------------|--------------|-------|-----------|
| **MemberID** | INT | Mã định danh duy nhất của thành viên | PRIMARY KEY, NOT NULL |
| **Name** | VARCHAR(255) | Tên đầy đủ của thành viên | NOT NULL |
| **Address** | VARCHAR(500) | Địa chỉ liên lạc | NULL |
| **Phone** | VARCHAR(20) | Số điện thoại liên hệ | NULL |
| **MembershipType** | VARCHAR(50) | Loại thành viên | NOT NULL |

**Ghi chú:**
*   MemberID được tự động tăng
*   MembershipType có thể là: 'Student' (Sinh viên), 'Faculty' (Giảng viên), 'Standard' (Thông thường), 'Premium' (VIP)
*   Mỗi loại thành viên có thể có giới hạn mượn khác nhau

---

#### **6. LOAN (MƯỢN/TRẢ)**

**Mô tả thực thể:**
Lưu trữ thông tin về các giao dịch mượn/trả sách. Mỗi lần mượn liên kết một thành viên với một bản sao sách cụ thể.

**Thuộc tính:**
| Thuộc tính | Kiểu dữ liệu | Mô tả | Ràng buộc |
|------------|--------------|-------|-----------|
| **LoanID** | INT | Mã định danh duy nhất của giao dịch mượn | PRIMARY KEY, NOT NULL |
| **MemberID** | INT | Mã thành viên mượn | FOREIGN KEY, NOT NULL |
| **CopyID** | INT | Mã bản sao được mượn | FOREIGN KEY, NOT NULL |
| **BorrowDate** | DATE | Ngày mượn sách | NOT NULL, DEFAULT GETDATE() |
| **DueDate** | DATE | Ngày hết hạn phải trả | NOT NULL |
| **ReturnDate** | DATE | Ngày thực tế trả sách | NULL |
| **OverdueFine** | DECIMAL(10,2) | Phí phạt quá hạn | DEFAULT 0 |

**Ghi chú:**
*   LoanID được tự động tăng
*   BorrowDate mặc định là ngày hiện tại
*   DueDate được tính dựa trên BorrowDate + số ngày mượn được phép
*   ReturnDate là NULL khi sách chưa được trả
*   OverdueFine được tính = số ngày quá hạn × mức phạt mỗi ngày

---

#### **Bảng tổng hợp thực thể:**

| # | Tên thực thể | Mô tả | Khóa chính |
|---|--------------|-------|------------|
| 1 | **BOOK** | Danh mục sách trong thư viện | BookID |
| 2 | **AUTHOR** | Danh mục tác giả | AuthorID |
| 3 | **PUBLISHER** | Danh mục nhà xuất bản | PublisherID |
| 4 | **BOOK_COPY** | Các bản sao vật lý của sách | CopyID |
| 5 | **MEMBER** | Thành viên thư viện | MemberID |
| 6 | **LOAN** | Giao dịch mượn/trả sách | LoanID |

---

### 1.4 Các mối quan hệ | Relationships

Sau khi xác định các thực thể, chúng tôi phân tích và xác định được **6 mối quan hệ chính** giữa các thực thể:

---

#### **1. PUBLISHES (XUẤT BẢN)**

**Thực thể tham gia:** PUBLISHER ↔ BOOK

**Bội số (Cardinality):** 1 : N

**Mô tả:**
*   Một nhà xuất bản có thể xuất bản nhiều cuốn sách
*   Mỗi cuốn sách được xuất bản bởi chính xác một nhà xuất bản

**Quy tắc kinh doanh:**
*   Khi thêm sách mới, phải xác định nhà xuất bản
*   Không thể xóa nhà xuất bản nếu vẫn còn sách của họ trong hệ thống (hoặc thiết lập ON DELETE SET NULL)

**Biểu diễn:**
```
PUBLISHER (1) ──PUBLISHES──> (N) BOOK
```

---

#### **2. WRITES (VIẾT)**

**Thực thể tham gia:** AUTHOR ↔ BOOK

**Bội số (Cardinality):** M : N

**Mô tả:**
*   Một tác giả có thể viết nhiều cuốn sách
*   Một cuốn sách có thể có nhiều tác giả

**Quy tắc kinh doanh:**
*   Cần bảng trung gian **BOOK_AUTHOR** để quản lý mối quan hệ nhiều-nhiều
*   Mỗi bản ghi trong BOOK_AUTHOR đại diện cho một tác giả của một cuốn sách

**Biểu diễn:**
```
AUTHOR (M) ──WRITES──> (N) BOOK
        ↓         ↓
    BOOK_AUTHOR (Bảng trung gian)
```

---

#### **3. HAS (CÓ)**

**Thực thể tham gia:** BOOK ↔ BOOK_COPY

**Bội số (Cardinality):** 1 : N

**Mô tả:**
*   Một cuốn sách (title) có thể có nhiều bản sao vật lý
*   Mỗi bản sao thuộc về một cuốn sách duy nhất

**Quy tắc kinh doanh:**
*   Khi xóa sách, tất cả bản sao của sách đó cũng bị xóa (ON DELETE CASCADE)
*   Không thể tạo bản sao nếu sách không tồn tại

**Biểu diễn:**
```
BOOK (1) ──HAS──> (N) BOOK_COPY
```

---

#### **4. BORROWS (MƯỢN)**

**Thực thể tham gia:** MEMBER ↔ BOOK_COPY

**Bội số (Cardinality):** 1 : N

**Mô tả:**
*   Một thành viên có thể mượn nhiều bản sao sách
*   Mỗi bản sao tại một thời điểm chỉ được mượn bởi một thành viên

**Quy tắc kinh doanh:**
*   Một thành viên không thể mượn quá số lượng sách cho phép
*   Không thể mượn bản sao có Status = 'Borrowed'
*   Khi mượn, Status của BOOK_COPY chuyển sang 'Borrowed'

**Biểu diễn:**
```
MEMBER (1) ──BORROWS──> (N) BOOK_COPY
```

---

#### **5. PROCESSES (XỬ LÝ)**

**Thực thể tham gia:** MEMBER ↔ LOAN

**Bội số (Cardinality):** 1 : N

**Mô tả:**
*   Một thành viên có thể có nhiều giao dịch mượn/trả
*   Mỗi giao dịch mượn/trả thuộc về một thành viên

**Quy tắc kinh doanh:**
*   Lưu trữ lịch sử đầy đủ của các giao dịch
*   Có thể truy vấn lịch sử mượn của một thành viên

**Biểu diễn:**
```
MEMBER (1) ──PROCESSES──> (N) LOAN
```

---

#### **6. RECORDS (GHI NHẬN)**

**Thực thể tham gia:** LOAN ↔ BOOK_COPY

**Bội số (Cardinality):** 1 : 1

**Mô tả:**
*   Mỗi giao dịch mượn ghi nhận một bản sao sách cụ thể
*   Mỗi bản sao tại một thời điểm chỉ được ghi nhận trong một giao dịch mượn đang hoạt động

**Quy tắc kinh doanh:**
*   Một bản sao không thể có hai giao dịch mượn đang hoạt động cùng lúc
*   Khi trả sách, ReturnDate được cập nhật và bản sao có thể mượn lại

**Biểu diễn:**
```
LOAN (1) ──RECORDS──> (1) BOOK_COPY
```

---

#### **Bảng tổng hợp mối quan hệ:**

| # | Tên mối quan hệ | Thực thể 1 | Thực thể 2 | Bội số | Mô tả |
|---|-----------------|------------|------------|--------|-------|
| 1 | **Publishes** | PUBLISHER | BOOK | 1 : N | Nhà xuất bản xuất bản sách |
| 2 | **Writes** | AUTHOR | BOOK | M : N | Tác giả viết sách (cần bảng trung gian) |
| 3 | **Has** | BOOK | BOOK_COPY | 1 : N | Sách có nhiều bản sao |
| 4 | **Borrows** | MEMBER | BOOK_COPY | 1 : N | Thành viên mượn bản sao |
| 5 | **Processes** | MEMBER | LOAN | 1 : N | Thành viên có nhiều giao dịch |
| 6 | **Records** | LOAN | BOOK_COPY | 1 : 1 | Giao dịch ghi nhận bản sao |

---

### 1.5 Thuộc tính | Attributes

Dưới đây là chi tiết tất cả các thuộc tính của mỗi thực thể, bao gồm loại thuộc tính và ràng buộc dữ liệu:

---

#### **Chi tiết thuộc tính BOOK:**

| Thuộc tính | Kiểu dữ liệu | Độ dài | Cho phép NULL | Mặc định | Mô tả chi tiết |
|------------|--------------|--------|---------------|----------|----------------|
| **BookID** | INT | - | NOT NULL | AUTO | Khóa chính, tự động tăng từ 1 |
| **ISBN** | VARCHAR | 17 | NULL | - | Mã ISBN quốc tế (13 hoặc 17 số ký tự) |
| **Title** | VARCHAR | 255 | NOT NULL | - | Tên tiêu đề sách, bắt buộc |
| **SubjectCategory** | VARCHAR | 100 | NULL | - | Thể loại: Văn học, Khoa học, Kỹ thuật, etc. |
| **PublicationYear** | INT | - | NULL | - | Năm xuất bản (4 chữ số) |
| **PublisherID** | INT | - | NOT NULL | - | Khóa ngoại tham chiếu PUBLISHER |

**Các ràng buộc bổ sung:**
*   CHECK (PublicationYear >= 1000 AND PublicationYear <= YEAR(GETDATE()) + 1)
*   UNIQUE (ISBN) - đảm bảo mỗi ISBN là duy nhất

---

#### **Chi tiết thuộc tính AUTHOR:**

| Thuộc tính | Kiểu dữ liệu | Độ dài | Cho phép NULL | Mặc định | Mô tả chi tiết |
|------------|--------------|--------|---------------|----------|----------------|
| **AuthorID** | INT | - | NOT NULL | AUTO | Khóa chính, tự động tăng |
| **Name** | VARCHAR | 255 | NOT NULL | - | Tên đầy đủ tác giả |
| **Nationality** | VARCHAR | 100 | NULL | - | Quốc tịch (Vietnam, USA, UK, etc.) |
| **YearOfBirth** | INT | - | NULL | - | Năm sinh tác giả |

**Các ràng buộc bổ sung:**
*   CHECK (YearOfBirth >= 1000 AND YearOfBirth <= YEAR(GETDATE()))

---

#### **Chi tiết thuộc tính PUBLISHER:**

| Thuộc tính | Kiểu dữ liệu | Độ dài | Cho phép NULL | Mặc định | Mô tả chi tiết |
|------------|--------------|--------|---------------|----------|----------------|
| **PublisherID** | INT | - | NOT NULL | AUTO | Khóa chính, tự động tăng |
| **Name** | VARCHAR | 255 | NOT NULL | - | Tên nhà xuất bản |
| **Address** | VARCHAR | 500 | NULL | - | Địa chỉ đầy đủ |
| **ContactNumber** | VARCHAR | 50 | NULL | - | Số điện thoại liên hệ |

**Các ràng buộc bổ sung:**
*   Có thể thêm UNIQUE constraint trên (Name, Address) để tránh trùng lặp

---

#### **Chi tiết thuộc tính BOOK_COPY:**

| Thuộc tính | Kiểu dữ liệu | Độ dài | Cho phép NULL | Mặc định | Mô tả chi tiết |
|------------|--------------|--------|---------------|----------|----------------|
| **CopyID** | INT | - | NOT NULL | AUTO | Khóa chính, tự động tăng |
| **BookID** | INT | - | NOT NULL | - | Khóa ngoại tham chiếu BOOK |
| **Condition** | VARCHAR | 50 | NULL | 'Good' | Tình trạng: New, Good, Fair, Poor |
| **Status** | VARCHAR | 20 | NOT NULL | 'Available' | Trạng thái: Available, Borrowed, Maintenance, Lost |

**Các ràng buộc bổ sung:**
*   CHECK (Condition IN ('New', 'Good', 'Fair', 'Poor'))
*   CHECK (Status IN ('Available', 'Borrowed', 'Maintenance', 'Lost'))
*   FOREIGN KEY (BookID) REFERENCES BOOK(BookID)

---

#### **Chi tiết thuộc tính MEMBER:**

| Thuộc tính | Kiểu dữ liệu | Độ dài | Cho phép NULL | Mặc định | Mô tả chi tiết |
|------------|--------------|--------|---------------|----------|----------------|
| **MemberID** | INT | - | NOT NULL | AUTO | Khóa chính, tự động tăng |
| **Name** | VARCHAR | 255 | NOT NULL | - | Tên đầy đủ thành viên |
| **Address** | VARCHAR | 500 | NULL | - | Địa chỉ liên lạc |
| **Phone** | VARCHAR | 20 | NULL | - | Số điện thoại |
| **MembershipType** | VARCHAR | 50 | NOT NULL | 'Standard' | Loại thành viên |

**Các ràng buộc bổ sung:**
*   CHECK (MembershipType IN ('Student', 'Faculty', 'Standard', 'Premium'))
*   Có thể thêm UNIQUE constraint trên Phone

---

#### **Chi tiết thuộc tính LOAN:**

| Thuộc tính | Kiểu dữ liệu | Độ dài | Cho phép NULL | Mặc định | Mô tả chi tiết |
|------------|--------------|--------|---------------|----------|----------------|
| **LoanID** | INT | - | NOT NULL | AUTO | Khóa chính, tự động tăng |
| **MemberID** | INT | - | NOT NULL | - | Khóa ngoại tham chiếu MEMBER |
| **CopyID** | INT | - | NOT NULL | - | Khóa ngoại tham chiếu BOOK_COPY |
| **BorrowDate** | DATE | - | NOT NULL | GETDATE() | Ngày mượn sách |
| **DueDate** | DATE | - | NOT NULL | - | Ngày hết hạn (thường là BorrowDate + 14 ngày) |
| **ReturnDate** | DATE | - | NULL | - | Ngày trả sách (NULL nếu chưa trả) |
| **OverdueFine** | DECIMAL | (10,2) | NULL | 0 | Phí phạt quá hạn |

**Các ràng buộc bổ sung:**
*   CHECK (DueDate >= BorrowDate)
*   CHECK (ReturnDate IS NULL OR ReturnDate >= BorrowDate)
*   CHECK (OverdueFine >= 0)
*   FOREIGN KEY (MemberID) REFERENCES MEMBER(MemberID)
*   FOREIGN KEY (CopyID) REFERENCES BOOK_COPY(CopyID)

---

#### **Bảng trung gian BOOK_AUTHOR:**

| Thuộc tính | Kiểu dữ liệu | Độ dài | Cho phép NULL | Mặc định | Mô tả chi tiết |
|------------|--------------|--------|---------------|----------|----------------|
| **BookID** | INT | - | NOT NULL | - | Khóa ngoại tham chiếu BOOK |
| **AuthorID** | INT | - | NOT NULL | - | Khóa ngoại tham chiếu AUTHOR |

**Các ràng buộc:**
*   PRIMARY KEY (BookID, AuthorID) - Khóa chính kép
*   FOREIGN KEY (BookID) REFERENCES BOOK(BookID)
*   FOREIGN KEY (AuthorID) REFERENCES AUTHOR(AuthorID)

---

### 1.6 Sơ đồ Thực thể - Mối quan hệ | Entity-Relationship Diagram

Dưới đây là sơ đồ ERD hoàn chỉnh cho hệ thống quản lý thư viện:

---

#### **Sơ đồ ERD (Chen Notation):**

```
┌──────────────────┐
│   PUBLISHER      │
├──────────────────┤
│ PK PublisherID   │
│    Name          │
│    Address       │
│    ContactNumber │
└────────┬─────────┘
         │
         │ 1
         │
         │ Publishes
         │
         │ N
         │
┌────────▼─────────┐         ┌──────────────────┐
│      BOOK        │         │     AUTHOR       │
├──────────────────┤         ├──────────────────┤
│ PK BookID        │         │ PK AuthorID      │
│    ISBN          │◄────────│    Name          │
│    Title         │         │    Nationality   │
│    SubjectCateg. │         │    YearOfBirth   │
│    PubYear       │         └──────────────────┘
│ FK PublisherID   │                  ▲
└────────┬─────────┘                  │
         │                            │ M
         │ 1                          │
         │                            │
         │ Has                        │ Writes
         │                            │
         │ N                          │ 1
         │                            │
┌────────▼─────────┐                  │
│   BOOK_COPY      │                  │
├──────────────────┤         ┌────────┴─────────┐
│ PK CopyID        │         │   BOOK_AUTHOR    │
│ FK BookID        │         ├──────────────────┤
│    Condition     │         │ PK BookID        │
│    Status        │         │ PK AuthorID      │
└────────┬─────────┘         └──────────────────┘
         │
         │ 1
         │
         │ Borrows / Records
         │
         │ N
         │
┌────────▼─────────┐
│     LOAN         │◄────────┐
├──────────────────┤         │
│ PK LoanID        │         │ 1
│ FK MemberID      │         │
│ FK CopyID        │         │ Processes
│    BorrowDate    │         │
│    DueDate       │         │
│    ReturnDate    │         │
│    OverdueFine   │         │
└──────────────────┘         │
                             │ N
                     ┌───────▼─────────┐
                     │    MEMBER       │
                     ├─────────────────┤
                     │ PK MemberID     │
                     │    Name         │
                     │    Address      │
                     │    Phone        │
                     │    MemberType   │
                     └─────────────────┘
```

---

#### **Ghi chú sơ đồ ERD:**

*   **PK**: Primary Key (Khóa chính)
*   **FK**: Foreign Key (Khóa ngoại)
*   **1:N**: Quan hệ một-nhiều
*   **M:N**: Quan hệ nhiều-nhiều (cần bảng trung gian)
*   **Mũi tên**: Chỉ hướng của quan hệ (từ 1 đến N)

---

#### **Các quyết định thiết kế chính:**

1. **Tách BOOK và BOOK_COPY:**
   *   BOOK lưu thông tin chung về title/ISBN
   *   BOOK_COPY lưu thông tin về từng bản sao vật lý
   *   Giúp quản lý chính xác số lượng sách có sẵn

2. **Sử dụng bảng trung gian BOOK_AUTHOR:**
   *   Hỗ trợ mối quan hệ M:N giữa AUTHOR và BOOK
   *   Cho phép một sách có nhiều tác giả
   *   Cho phép một tác giả có nhiều sách

3. **Tách LOAN thành thực thể riêng:**
   *   Lưu trữ đầy đủ thông tin về mỗi giao dịch mượn
   *   Hỗ trợ tính toán phí phạt
   *   Lưu trữ lịch sử mượn/trả đầy đủ

4. **Mối quan hệ trực tiếp giữa LOAN và BOOK_COPY:**
   *   Mỗi giao dịch mượn liên kết với một bản sao cụ thể
   *   Giảm độ phức tạp so với liên kết qua BOOK
   *   Dễ dàng theo dõi tình trạng của từng bản sao

---

### 1.7 Kết luận báo cáo 1 | Report 1 Conclusion

#### **Tổng kết kết quả:**

Báo cáo 1 đã hoàn thành phân tích và thiết kế sơ đồ ERD cho hệ thống quản lý thư viện với các kết quả sau:

**1. Xác định được 6 thực thể chính:**
*   BOOK (Sách) - 6 thuộc tính
*   AUTHOR (Tác giả) - 4 thuộc tính
*   PUBLISHER (Nhà xuất bản) - 4 thuộc tính
*   BOOK_COPY (Bản sao sách) - 4 thuộc tính
*   MEMBER (Thành viên) - 5 thuộc tính
*   LOAN (Mượn/trả) - 7 thuộc tính

**2. Xác định được 6 mối quan hệ:**
*   Publishes (1:N) - PUBLISHER → BOOK
*   Writes (M:N) - AUTHOR ↔ BOOK (cần bảng trung gian)
*   Has (1:N) - BOOK → BOOK_COPY
*   Borrows (1:N) - MEMBER → BOOK_COPY
*   Processes (1:N) - MEMBER → LOAN
*   Records (1:1) - LOAN → BOOK_COPY

**3. Xác định được 1 bảng trung gian:**
*   BOOK_AUTHOR - quản lý mối quan hệ nhiều-nhiều giữa AUTHOR và BOOK

**4. Hoàn thiện sơ đồ ERD:**
*   Biểu diễn rõ ràng các thực thể và thuộc tính
*   Thể hiện chính xác các mối quan hệ và bội số
*   Xác định khóa chính và khóa ngoại

#### **Chuẩn bị cho báo cáo 2:**

Báo cáo 2 sẽ chuyển đổi sơ đồ ERD sang mô hình quan hệ (Relational Data Model) và thực hiện các bước sau:

1.  **Chuyển đổi thực thể thành bảng (tables)**
2.  **Xác định khóa chính và khóa ngoại**
3.  **Xác định các lược đồ quan hệ (relation schemas)**
4.  **Nhận dạng các mẫu không chuẩn hóa**
5.  **Chuẩn bị cho quá trình chuẩn hóa trong báo cáo 3**

#### **Đánh giá chất lượng thiết kế:**

*   **Tính đầy đủ:** Tất cả các thực thể và mối quan hệ cần thiết đã được xác định
*   **Tính chính xác:** Bội số và các ràng buộc được xác định đúng theo yêu cầu
*   **Tính rõ ràng:** Sơ đồ ERD thể hiện rõ cấu trúc dữ liệu
*   **Khả năng mở rộng:** Thiết kế cho phép thêm các thực thể mới (như RESERVATION, FINE_PAYMENT) trong tương lai

---

## KẾT THÚC BÁO CÁO 1 | END OF REPORT 1

---

**Người thực hiện:** Nhóm 2 - Lớp AI2005
**Ngày hoàn thành:** 26/01/2026
**Giảng viên hướng dẫn:** Vũ Thanh Phong

---

**Tài liệu tham khảo | References:**
1.  Database System Concepts - Silberschatz, Korth, Sudarshan
2.  Fundamentals of Database Systems - Elmasri, Navathe
3.  SQL Server Documentation - Microsoft
4.  Course Materials - DBI202 - FPT University
