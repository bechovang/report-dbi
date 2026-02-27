-- ======================================================================
-- SCRIPT TẠO DATABASE LIBRARYDB
-- Dựa trên nội dung main.tex - BÁO CÁO 4
-- ======================================================================

USE master;
GO

-- ======================================================================
-- 1. XÓA DATABASE CŨ NẾU CÓ (ĐỂ LÀM MỚI)
-- ======================================================================
IF EXISTS (SELECT name FROM sys.databases WHERE name = N'LibraryDB')
BEGIN
    ALTER DATABASE LibraryDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE LibraryDB;
END
GO

CREATE DATABASE LibraryDB;
GO

USE LibraryDB;
GO

PRINT N'Database LibraryDB đã được tạo!';

-- ======================================================================
-- 2. XÓA BẢNG NẾU TỒN TẠI (THỨ TỰ CON TRƯỚC CHA SAU)
-- ======================================================================
IF OBJECT_ID('dbo.LOAN', 'U') IS NOT NULL DROP TABLE dbo.LOAN;
IF OBJECT_ID('dbo.BOOK_AUTHOR', 'U') IS NOT NULL DROP TABLE dbo.BOOK_AUTHOR;
IF OBJECT_ID('dbo.BOOK_COPY', 'U') IS NOT NULL DROP TABLE dbo.BOOK_COPY;
IF OBJECT_ID('dbo.BOOK', 'U') IS NOT NULL DROP TABLE dbo.BOOK;
IF OBJECT_ID('dbo.MEMBER', 'U') IS NOT NULL DROP TABLE dbo.MEMBER;
IF OBJECT_ID('dbo.AUTHOR', 'U') IS NOT NULL DROP TABLE dbo.AUTHOR;
IF OBJECT_ID('dbo.PUBLISHER', 'U') IS NOT NULL DROP TABLE dbo.PUBLISHER;
GO

-- ======================================================================
-- 3. TẠO CÁC BẢNG VỚI ĐẦY ĐỦ RÀNG BUỘC
-- ======================================================================

-- ----------------------------------------------------------
-- BẲNG PUBLISHER (Nhà xuất bản)
-- ----------------------------------------------------------
CREATE TABLE PUBLISHER (
    PublisherID      INT            NOT NULL   IDENTITY(1,1),
    Name             VARCHAR(255)   NOT NULL,
    Address          VARCHAR(500)   NULL,
    ContactNumber    VARCHAR(50)    NULL,

    CONSTRAINT PK_PUBLISHER PRIMARY KEY (PublisherID),
    CONSTRAINT CK_PUBLISHER_Name CHECK (LEN(Name) > 0),
    CONSTRAINT CK_PUBLISHER_ContactNumber CHECK (ContactNumber IS NULL OR ContactNumber LIKE '[0-9]%')
);
GO

PRINT N'Bảng PUBLISHER đã tạo!';

-- ----------------------------------------------------------
-- BẲNG AUTHOR (Tác giả)
-- ----------------------------------------------------------
CREATE TABLE AUTHOR (
    AuthorID         INT            NOT NULL   IDENTITY(1,1),
    Name             VARCHAR(255)   NOT NULL,
    Nationality      VARCHAR(100)   NULL,
    YearOfBirth      INT            NULL,

    CONSTRAINT PK_AUTHOR PRIMARY KEY (AuthorID),
    CONSTRAINT CK_AUTHOR_Name CHECK (LEN(Name) > 0),
    CONSTRAINT CK_AUTHOR_YearOfBirth
        CHECK (YearOfBirth IS NULL
               OR (YearOfBirth BETWEEN 1000 AND YEAR(GETDATE()) AND YearOfBirth <= YEAR(GETDATE()) - 10))
);
GO

PRINT N'Bảng AUTHOR đã tạo!';

-- ----------------------------------------------------------
-- BẲNG MEMBER (Thành viên)
-- ----------------------------------------------------------
CREATE TABLE MEMBER (
    MemberID         INT            NOT NULL   IDENTITY(1,1),
    Name             VARCHAR(255)   NOT NULL,
    Address          VARCHAR(500)   NULL,
    Phone            VARCHAR(20)    NULL,
    MembershipType   VARCHAR(50)    NOT NULL,
    JoinDate         DATE           NOT NULL   DEFAULT (GETDATE()),

    CONSTRAINT PK_MEMBER PRIMARY KEY (MemberID),
    CONSTRAINT CK_MEMBER_Name CHECK (LEN(Name) > 0),
    CONSTRAINT CK_MEMBER_MembershipType
        CHECK (MembershipType IN ('Student', 'Faculty', 'Standard', 'Premium')),
    CONSTRAINT CK_MEMBER_Phone CHECK (Phone IS NULL OR Phone LIKE '[0-9]%')
);
GO

PRINT N'Bảng MEMBER đã tạo!';

-- ----------------------------------------------------------
-- BẲNG BOOK (Sách)
-- ----------------------------------------------------------
CREATE TABLE BOOK (
    BookID             INT            NOT NULL   IDENTITY(1,1),
    ISBN               VARCHAR(17)    NULL,
    Title              VARCHAR(255)   NOT NULL,
    SubjectCategory    VARCHAR(100)   NULL,
    PublicationYear    INT            NULL,
    PublisherID        INT            NOT NULL,

    CONSTRAINT PK_BOOK PRIMARY KEY (BookID),
    CONSTRAINT FK_BOOK_PUBLISHER FOREIGN KEY (PublisherID)
        REFERENCES PUBLISHER(PublisherID)
        ON UPDATE CASCADE
        ON DELETE NO ACTION,
    CONSTRAINT UQ_BOOK_ISBN UNIQUE (ISBN),
    CONSTRAINT CK_BOOK_Title CHECK (LEN(Title) > 0),
    CONSTRAINT CK_BOOK_PublicationYear
        CHECK (PublicationYear IS NULL OR PublicationYear BETWEEN 1000 AND YEAR(GETDATE()) + 5),
    CONSTRAINT CK_BOOK_ISBN
        CHECK (ISBN IS NULL
               OR ISBN LIKE '[0-9][0-9][0-9]%'  -- ISBN-10 hoặc ISBN-13 (đơn giản hóa)
              )
);
GO

PRINT N'Bảng BOOK đã tạo!';

-- ----------------------------------------------------------
-- BẲNG BOOK_AUTHOR (Bảng trung gian Tác giả - Sách)
-- ----------------------------------------------------------
CREATE TABLE BOOK_AUTHOR (
    BookID         INT   NOT NULL,
    AuthorID       INT   NOT NULL,

    CONSTRAINT PK_BOOK_AUTHOR PRIMARY KEY (BookID, AuthorID),
    CONSTRAINT FK_BOOK_AUTHOR_BOOK FOREIGN KEY (BookID)
        REFERENCES BOOK(BookID)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT FK_BOOK_AUTHOR_AUTHOR FOREIGN KEY (AuthorID)
        REFERENCES AUTHOR(AuthorID)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);
GO

PRINT N'Bảng BOOK_AUTHOR đã tạo!';

-- ----------------------------------------------------------
-- BẲNG BOOK_COPY (Bản sao vật lý của sách)
-- ----------------------------------------------------------
CREATE TABLE BOOK_COPY (
    CopyID         INT             NOT NULL   IDENTITY(1,1),
    BookID         INT             NOT NULL,
    Condition      VARCHAR(50)     NOT NULL,
    Status         VARCHAR(20)     NOT NULL   DEFAULT ('Available'),

    CONSTRAINT PK_BOOK_COPY PRIMARY KEY (CopyID),
    CONSTRAINT FK_BOOK_COPY_BOOK FOREIGN KEY (BookID)
        REFERENCES BOOK(BookID)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT CK_BOOK_COPY_Condition
        CHECK (Condition IN ('New', 'Good', 'Fair', 'Poor')),
    CONSTRAINT CK_BOOK_COPY_Status
        CHECK (Status IN ('Available', 'Borrowed', 'Maintenance', 'Lost'))
);
GO

PRINT N'Bảng BOOK_COPY đã tạo!';

-- ----------------------------------------------------------
-- BẲNG LOAN (Giao dịch mượn/trả sách)
-- ----------------------------------------------------------
CREATE TABLE LOAN (
    LoanID         INT             NOT NULL   IDENTITY(1,1),
    MemberID       INT             NOT NULL,
    CopyID         INT             NOT NULL,
    BorrowDate     DATE            NOT NULL   DEFAULT (GETDATE()),
    DueDate        DATE            NOT NULL,
    ReturnDate     DATE            NULL,
    OverdueFine    DECIMAL(10,2)   NOT NULL   DEFAULT (0),

    CONSTRAINT PK_LOAN PRIMARY KEY (LoanID),
    CONSTRAINT FK_LOAN_MEMBER FOREIGN KEY (MemberID)
        REFERENCES MEMBER(MemberID)
        ON UPDATE CASCADE
        ON DELETE NO ACTION,
    CONSTRAINT FK_LOAN_BOOK_COPY FOREIGN KEY (CopyID)
        REFERENCES BOOK_COPY(CopyID)
        ON UPDATE CASCADE
        ON DELETE NO ACTION,
    CONSTRAINT CK_LOAN_DueDate CHECK (DueDate >= BorrowDate),
    CONSTRAINT CK_LOAN_ReturnDate
        CHECK (ReturnDate IS NULL OR ReturnDate >= BorrowDate),
    CONSTRAINT CK_LOAN_OverdueFine CHECK (OverdueFine >= 0)
);
GO

-- Tao filtered UNIQUE index (chi ap dung khi ReturnDate IS NULL)
CREATE UNIQUE NONCLUSTERED INDEX UQ_LOAN_CopyID_Active
ON LOAN(CopyID)
WHERE (ReturnDate IS NULL);
GO

PRINT N'Bảng LOAN đã tạo!';

-- ======================================================================
-- 4. TÓM TẮT KẾT QUẢ
-- ======================================================================
PRINT N'';
PRINT N'===========================================================';
PRINT N'TOÀN BỘ DATABASE LIBRARYDB ĐÃ ĐƯỢC TẠO THÀNH CÔNG!';
PRINT N'===========================================================';
PRINT N'Tổng số bảng: 7 (PUBLISHER, AUTHOR, MEMBER, BOOK, BOOK_AUTHOR, BOOK_COPY, LOAN)';
PRINT N'Tổng số Primary Keys: 7';
PRINT N'Tổng số Foreign Keys: 7';
PRINT N'Total CHECK constraints: Đầy đủ';
PRINT N'===========================================================';
GO

-- Hiển thị thông tin các bảng vừa tạo
SELECT
    t.TABLE_NAME AS 'TenBang',
    t.TABLE_TYPE AS 'Kieu'
FROM INFORMATION_SCHEMA.TABLES t
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY t.TABLE_NAME;
GO

-- Hiển thị các ràng buộc
SELECT
    OBJECT_NAME(object_id) AS 'Bang',
    name AS 'RangBuoc',
    type_desc AS 'Kieu'
FROM sys.objects
WHERE type IN ('C', 'F', 'UQ', 'PK')
ORDER BY OBJECT_NAME(object_id), type_desc;
GO
