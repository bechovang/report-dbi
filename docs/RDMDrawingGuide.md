# Hướng dẫn vẽ Sơ đồ Mô hình Quan hệ (RDM)
## Relational Data Model Diagram - Library Management System

---

## PHẦN 1: CHUẨN BỊ

### Công cụ cần thiết:
1. **draw.io** (khuyến nghị) - Truy cập: https://app.diagrams.net/
2. Hoặc **Excalidraw** - Truy cập: https://excalidraw.com/
3. Hoặc **Lucidchart**, **Visual Paradigm**, etc.

### Tạo file mới:
1. Mở draw.io
2. Chọn "Blank Diagram"
3. Lưu file với tên: `RDM_Library_Management.drawio`

---

## PHẦN 2: KÍCH THƯỚC VÀ BỐ CỤC

### Kích thước bảng (Table Box):
- **Width:** 180-200 pixels
- **Height:** Tùy theo số cột (mỗi cột ~25px)
- **Header height:** 40px
- **Border thickness:** 2px

### Màu sắc (Color Scheme):
- **Table Header:**
  - Regular tables: `#E3F2FD` (light blue)
  - Junction table (BOOK_AUTHOR): `#E8F5E9` (light green)
- **Table Body:** `#FFFFFF` (white)
- **Border:** `#1976D2` (blue) hoặc `#388E3C` (green cho junction)
- **Text:** `#1E1E1E` (dark gray/black)

---

## PHẦN 3: VẼ BẢNG (DRAW TABLES)

### Bước 1: Tạo hình dạng bảng

**Trong draw.io:**
1. Chọn hình "Rectangle" từ menu hình khối
2. Vẽ một hình chữ nhật
3. Thêm đường kẻ ngang để chia header và body:
   - Click chuột phải → "Edit Style" → add second line

**Hoặc đơn giản hơn:**
1. Vẽ 2 hình chữ nhật chồng lên nhau:
   - Hình 1 (Header): width 180, height 40
   - Hình 2 (Body): width 180, height (tùy số cột)
2. Ghép 2 hình lại, canh đều biên

### Bước 2: Thêm tên bảng (Table Name)

**Vùng Header:**
- Font: **Arial Bold**, size: **14-16pt**
- Căn giữa: Center
- Màu: `#1976D2` (blue)

**Ví dụ:** `PUBLISHER`, `BOOK`, `MEMBER`, `BOOK_AUTHOR`

### Bước 3: Thêm danh sách cột (Columns)

**Vùng Body:**
- Font: **Arial Regular**, size: **11-12pt**
- Căn lề: Left với padding 10px
- Line spacing: 25px giữa các cột

**Format cột:**
```
PK ColumnName        (Khóa chính)
FK ColumnName        (Khóa ngoại)
PK FK ColumnName     (Vừa PK vừa FK - junction table)
   ColumnName        (Cột thường)
```

---

## PHẦN 4: CHI TIẾT TỪNG BẢNG

### TABLE 1: PUBLISHER
- **Position:** x=400, y=60
- **Columns:**
  - `PK PublisherID`
  - `   Name`
  - `   Address`
  - `   ContactNumber`
- **Height:** ~140px total (40 header + 100 body)

### TABLE 2: AUTHOR
- **Position:** x=100, y=280
- **Columns:**
  - `PK AuthorID`
  - `   Name`
  - `   Nationality`
  - `   YearOfBirth`
- **Height:** ~140px total

### TABLE 3: BOOK
- **Position:** x=460, y=280
- **Columns:**
  - `PK BookID`
  - `   ISBN`
  - `   Title`
  - `   SubjectCategory`
  - `   PublicationYear`
  - `FK PublisherID`
- **Height:** ~190px total

### TABLE 4: BOOK_AUTHOR (Junction Table)
- **Position:** x=820, y=280
- **Background:** Green (`#E8F5E9`)
- **Border:** Green (`#388E3C`)
- **Columns:**
  - `PK FK BookID`
  - `PK FK AuthorID`
- **Height:** ~90px total

### TABLE 5: MEMBER
- **Position:** x=100, y=500
- **Columns:**
  - `PK MemberID`
  - `   Name`
  - `   Address`
  - `   Phone`
  - `   MembershipType`
- **Height:** ~165px total

### TABLE 6: BOOK_COPY
- **Position:** x=460, y=500
- **Columns:**
  - `PK CopyID`
  - `FK BookID`
  - `   Condition`
  - `   Status`
- **Height:** ~140px total

### TABLE 7: LOAN
- **Position:** x=280, y=720
- **Columns:**
  - `PK LoanID`
  - `FK MemberID`
  - `FK CopyID`
  - `   BorrowDate`
  - `   DueDate`
  - `   ReturnDate`
  - `   OverdueFine`
- **Height:** ~215px total

---

## PHẦN 5: VẼ ĐƯỜNG NỐI (RELATIONSHIPS)

### Kiểu đường nối:
- **Line style:** Solid
- **Thickness:** 2px
- **Color:**
  - Regular relationships: Blue (`#1976D2`)
  - M:N relationships: Green (`#388E3C`)
- **Arrow:** Single arrowhead at end

### Các mối quan hệ cần vẽ:

#### 1. PUBLISHER → BOOK (1:N)
- **Start:** PUBLISHER (bottom edge, center)
- **End:** BOOK (top edge, center)
- **Cardinality:** `1` at PUBLISHER, `N` at BOOK
- **Line type:** Straight vertical

#### 2. AUTHOR ↔ BOOK_AUTHOR (M:N)
- **Start:** AUTHOR (right edge, center)
- **End:** BOOK_AUTHOR (left edge, center)
- **Cardinality:** `M` at AUTHOR, `N` at BOOK_AUTHOR
- **Line type:** Straight horizontal

#### 3. BOOK ↔ BOOK_AUTHOR (M:N)
- **Start:** BOOK (right edge, center)
- **End:** BOOK_AUTHOR (left edge, center)
- **Cardinality:** `N` at BOOK, `N` at BOOK_AUTHOR
- **Line type:** Straight horizontal

#### 4. BOOK → BOOK_COPY (1:N)
- **Start:** BOOK (bottom edge, center)
- **End:** BOOK_COPY (top edge, center)
- **Cardinality:** `1` at BOOK, `N` at BOOK_COPY
- **Line type:** Straight vertical

#### 5. MEMBER → LOAN (1:N)
- **Start:** MEMBER (right edge, upper portion)
- **End:** LOAN (left edge, upper portion)
- **Cardinality:** `1` at MEMBER, `N` at LOAN
- **Line type:** Diagonal (elbow nếu cần)

#### 6. BOOK_COPY → LOAN (1:1)
- **Start:** BOOK_COPY (bottom edge, center)
- **End:** LOAN (top edge, center)
- **Cardinality:** `1` at BOOK_COPY, `1` at LOAN
- **Line type:** Straight vertical

---

## PHẦN 6: THÊM CARDINALITY (BỘI SỐ)

### Cách thêm cardinality labels:

**Trong draw.io:**
1. Chọn công cụ "Text" (phím T)
2. Click vào vị trí gần đường nối
3. Nhập số: `1`, `N`, hoặc `M`
4. Format:
   - Font: Arial Bold, 12pt
   - Color: Blue hoặc Green (giống màu line)
   - Background: White (để che đường nếu overlap)

### Vị trí cardinality:

```
PUBLISHER ───1──↓──────N──→ BOOK
              1              N

AUTHOR ────M──→←─────N──── BOOK_AUTHOR
          M                N
                     ↑
BOOK ────────────────┘
          N          N

BOOK ────1──↓───────N──→ BOOK_COPY
            1              N

MEMBER ───1──↘───────────→ LOAN
              1            N

BOOK_COPY ──1──↓───────1──→ LOAN
                1            1
```

---

## PHẦN 7: KIỂM TRA VÀ HOÀN THIỆN

### Checklist:
- [ ] 7 bảng đều được vẽ
- [ ] Tất cả các cột đều liệt kê đúng
- [ ] PK và FK được đánh dấu đúng
- [ ] 6 đường nối đều có
- [ ] Cardinality labels hiển thị đúng
- [ ] Màu sắc nhất quán
- [ ] Font size và style đều
- [ ] Layout cân đối, không bị chồng chéo

### Xuất file (Export):

**Cho LaTeX (.pdf):**
1. File → Export as → PDF
2. Chọn "Crop" để cắt khoảng trắng
3. Lưu vào: `latex/images/RDM_Library_Management.pdf`

**Hoặc .png:**
1. File → Export as → PNG
2. Resolution: 300 DPI
3. Transparent background: unchecked (white background)
4. Lưu vào: `latex/images/RDM_Library_Management.png`

---

## PHẦN 8: CHÈN VÀO LATEX

### Bước 1: Đặt file diagram vào đúng thư mục
```
latex/images/RDM_Library_Management.pdf  (hoặc .png)
```

### Bước 2: Bỏ comment dòng include trong main.tex
Tìm dòng (khoảng line 1210-1212):
```latex
% \includegraphics[width=\textwidth,keepaspectratio]{images/RDM_Library_Management.pdf}
```
Bỏ dấu `%`:
```latex
\includegraphics[width=\textwidth,keepaspectratio]{images/RDM_Library_Management.pdf}
```

### Bước 3: Compile LaTeX
```bash
xelatex main.tex
```

---

## PHẦN 9: MẸO VÀ THỦ THUẬT

### Tips cho draw.io:
1. **Grid alignment:** Bật grid (View → Grid) để căn đều
2. **Group elements:** Ctrl+G để group bảng và text
3. **Duplicate:** Ctrl+D để copy bảng đã format
4. **Connectors:** Dùng connector tool thay vì line để tự động gắn vào edge

### Keyboard Shortcuts:
- `Ctrl+D`: Duplicate
- `Ctrl+G`: Group
- `Ctrl+Shift+G`: Ungroup
- `F2`: Edit text
- `Ctrl+Shift+Arrow`: Resize object

---

## PHẦN 10: THAM KHẢO

Sơ đồ bố cục gợi ý:

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│              ┌─────────────┐                                   │
│              │  PUBLISHER  │                                   │
│              └──────┬──────┘                                   │
│                     │ 1:N                                      │
│                     ↓                                          │
│  ┌──────────┐   ┌─────────────┐   ┌──────────────┐            │
│  │  AUTHOR  │   │    BOOK     │──→│ BOOK_AUTHOR  │            │
│  └─────┬────┘   └──────┬──────┘   └──────────────┘            │
│        │ M:N            │ 1:N                               M:N│
│        └────────────────┴───────────────────┐                   │
│                                              │                  │
│  ┌──────────┐                         ┌─────┴─────┐            │
│  │  MEMBER  │                         │ BOOK_COPY │            │
│  └─────┬────┘                         └──────┬────┘            │
│        │ 1:N                                 │ 1:1              │
│        │                                     │                  │
│        └──────────────→  ┌─────────────┐ ←───┘                  │
│                    N:1  │    LOAN     │   1:1                  │
│                         └─────────────┘                         │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## CÁC LƯU Ý QUAN TRỌNG

1. **RDM vs ERD:**
   - ERD dùng hình thoi (diamond) cho mối quan hệ
   - RDM dùng bảng + đường nối trực tiếp

2. **Junction Table:**
   - BOOK_AUTHOR có 2 FK, cả 2 đều là PK
   - Nên tô màu khác biệt để phân biệt

3. **Chữ PK/FK:**
   - Có thể in đậm (bold)
   - Có thể màu khác: PK=red, FK=blue
   - Hoặc dùng icon: 🔑 cho PK, 🔗 cho FK

4. **Đường nối 1:1:**
   - LOAN và BOOK_COPY là 1:1
   - Cardinality hiển thị "1" ở cả 2 đầu

---

Chúc bạn vẽ thành công! Nếu cần hỗ trợ thêm, hãy hỏi tôi.
