-- ============================================================
-- DATABASE: LibraryDB - Quản Lý Thư Viện
-- PROJECT: Database System for Library Management
-- CLASS: SE2043
-- GROUP: 3
-- DATE: 2026-02-05
-- ============================================================

USE master;
GO

-- Drop database if exists (for testing purposes)
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'LibraryDB')
BEGIN
    ALTER DATABASE LibraryDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE LibraryDB;
END
GO

-- Create database
CREATE DATABASE LibraryDB;
GO

-- Use the database
USE LibraryDB;
GO

PRINT N'================================================================'
PRINT N'DATABASE LibraryDB CREATED SUCCESSFULLY'
PRINT N'================================================================'
GO

-- ============================================================
-- DROP TABLES (for re-running the script)
-- ============================================================
PRINT N'Dropping existing tables...';

DROP TABLE IF EXISTS LOAN;
DROP TABLE IF EXISTS BOOK_AUTHOR;
DROP TABLE IF EXISTS BOOK_COPY;
DROP TABLE IF EXISTS BOOK;
DROP TABLE IF EXISTS MEMBER;
DROP TABLE IF EXISTS AUTHOR;
DROP TABLE IF EXISTS PUBLISHER;
GO

-- ============================================================
-- CREATE TABLES
-- ============================================================
PRINT N'Creating tables...';

-- Table 1: PUBLISHER (Nhà xuất bản)
PRINT N'Creating table PUBLISHER...';
CREATE TABLE PUBLISHER (
    PublisherID      INT           NOT NULL   IDENTITY(1,1),
    Name             VARCHAR(255)  NOT NULL,
    Address          VARCHAR(500)  NULL,
    ContactNumber    VARCHAR(50)   NULL,

    -- Primary Key
    CONSTRAINT PK_PUBLISHER PRIMARY KEY (PublisherID),

    -- Check Constraints
    CONSTRAINT CK_PUBLISHER_Name
        CHECK (LEN(Name) > 0),
    CONSTRAINT CK_PUBLISHER_ContactNumber
        CHECK (ContactNumber IS NULL OR ContactNumber LIKE '%[0-9]%')
);
GO

-- Table 2: AUTHOR (Tác giả)
PRINT N'Creating table AUTHOR...';
CREATE TABLE AUTHOR (
    AuthorID         INT           NOT NULL   IDENTITY(1,1),
    Name             VARCHAR(255)  NOT NULL,
    Nationality      VARCHAR(100)  NULL,
    YearOfBirth      INT           NULL,

    -- Primary Key
    CONSTRAINT PK_AUTHOR PRIMARY KEY (AuthorID),

    -- Check Constraints
    CONSTRAINT CK_AUTHOR_Name
        CHECK (LEN(Name) > 0),
    CONSTRAINT CK_AUTHOR_YearOfBirth
        CHECK (YearOfBirth IS NULL
               OR (YearOfBirth BETWEEN 1000 AND YEAR(GETDATE()) AND YearOfBirth <= YEAR(GETDATE()) - 10))
);
GO

-- Table 3: MEMBER (Thành viên)
PRINT N'Creating table MEMBER...';
CREATE TABLE MEMBER (
    MemberID         INT           NOT NULL   IDENTITY(1,1),
    Name             VARCHAR(255)  NOT NULL,
    Address          VARCHAR(500)  NULL,
    Phone            VARCHAR(20)   NULL,
    MembershipType   VARCHAR(50)   NOT NULL,
    JoinDate         DATE          NOT NULL   DEFAULT (GETDATE()),

    -- Primary Key
    CONSTRAINT PK_MEMBER PRIMARY KEY (MemberID),

    -- Check Constraints
    CONSTRAINT CK_MEMBER_Name
        CHECK (LEN(Name) > 0),
    CONSTRAINT CK_MEMBER_MembershipType
        CHECK (MembershipType IN ('Student', 'Faculty', 'Standard', 'Premium')),
    CONSTRAINT CK_MEMBER_Phone
        CHECK (Phone IS NULL OR Phone LIKE '%[0-9]%')
);
GO

-- Table 4: BOOK (Sách)
PRINT N'Creating table BOOK...';
CREATE TABLE BOOK (
    BookID             INT           NOT NULL   IDENTITY(1,1),
    ISBN               VARCHAR(17)   NULL,
    Title              VARCHAR(255)  NOT NULL,
    SubjectCategory    VARCHAR(100)  NULL,
    PublicationYear    INT           NULL,
    PublisherID        INT           NOT NULL,

    -- Primary Key
    CONSTRAINT PK_BOOK PRIMARY KEY (BookID),

    -- Foreign Key
    CONSTRAINT FK_BOOK_PUBLISHER FOREIGN KEY (PublisherID)
        REFERENCES PUBLISHER(PublisherID)
        ON UPDATE CASCADE
        ON DELETE NO ACTION,

    -- Unique Constraint
    CONSTRAINT UQ_BOOK_ISBN UNIQUE (ISBN),

    -- Check Constraints
    CONSTRAINT CK_BOOK_Title
        CHECK (LEN(Title) > 0),
    CONSTRAINT CK_BOOK_PublicationYear
        CHECK (PublicationYear IS NULL
               OR PublicationYear BETWEEN 1000 AND YEAR(GETDATE()) + 5)
);
GO

-- Table 5: BOOK_COPY (Bản sao sách)
PRINT N'Creating table BOOK_COPY...';
CREATE TABLE BOOK_COPY (
    CopyID         INT          NOT NULL   IDENTITY(1,1),
    BookID         INT          NOT NULL,
    Condition      VARCHAR(50)  NOT NULL,
    Status         VARCHAR(20)  NOT NULL   DEFAULT ('Available'),

    -- Primary Key
    CONSTRAINT PK_BOOK_COPY PRIMARY KEY (CopyID),

    -- Foreign Key
    CONSTRAINT FK_BOOK_COPY_BOOK FOREIGN KEY (BookID)
        REFERENCES BOOK(BookID)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    -- Check Constraints
    CONSTRAINT CK_BOOK_COPY_Condition
        CHECK (Condition IN ('New', 'Good', 'Fair', 'Poor')),
    CONSTRAINT CK_BOOK_COPY_Status
        CHECK (Status IN ('Available', 'Borrowed', 'Maintenance', 'Lost'))
);
GO

-- Table 6: LOAN (Mượn/trả)
PRINT N'Creating table LOAN...';
CREATE TABLE LOAN (
    LoanID         INT             NOT NULL   IDENTITY(1,1),
    MemberID       INT             NOT NULL,
    CopyID         INT             NOT NULL,
    BorrowDate     DATE            NOT NULL   DEFAULT (GETDATE()),
    DueDate        DATE            NOT NULL,
    ReturnDate     DATE            NULL,
    OverdueFine    DECIMAL(10,2)   NOT NULL   DEFAULT (0),

    -- Primary Key
    CONSTRAINT PK_LOAN PRIMARY KEY (LoanID),

    -- Foreign Keys
    CONSTRAINT FK_LOAN_MEMBER FOREIGN KEY (MemberID)
        REFERENCES MEMBER(MemberID)
        ON UPDATE CASCADE
        ON DELETE NO ACTION,
    CONSTRAINT FK_LOAN_BOOK_COPY FOREIGN KEY (CopyID)
        REFERENCES BOOK_COPY(CopyID)
        ON UPDATE CASCADE
        ON DELETE NO ACTION,

    -- Unique Constraint (Filtered - chỉ áp dụng khi đang mượn)
    CONSTRAINT UQ_LOAN_CopyID_Active
        UNIQUE (CopyID)
        WHERE (ReturnDate IS NULL),

    -- Check Constraints
    CONSTRAINT CK_LOAN_DueDate
        CHECK (DueDate >= BorrowDate),
    CONSTRAINT CK_LOAN_ReturnDate
        CHECK (ReturnDate IS NULL OR ReturnDate >= BorrowDate),
    CONSTRAINT CK_LOAN_OverdueFine
        CHECK (OverdueFine >= 0)
);
GO

-- Table 7: BOOK_AUTHOR (Bảng trung gian)
PRINT N'Creating table BOOK_AUTHOR...';
CREATE TABLE BOOK_AUTHOR (
    BookID         INT   NOT NULL,
    AuthorID       INT   NOT NULL,

    -- Primary Key (Composite)
    CONSTRAINT PK_BOOK_AUTHOR PRIMARY KEY (BookID, AuthorID),

    -- Foreign Keys
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

PRINT N'================================================================'
PRINT N'ALL TABLES CREATED SUCCESSFULLY'
PRINT N'================================================================'
GO

-- ============================================================
-- INSERT SAMPLE DATA
-- ============================================================
PRINT N'Inserting sample data...';

-- Insert PUBLISHER
PRINT N'Inserting PUBLISHER data...';
SET IDENTITY_INSERT PUBLISHER ON;
INSERT INTO PUBLISHER (PublisherID, Name, Address, ContactNumber) VALUES
(1, N'Nhà Xuất Bản Giáo dục Việt Nam', N'81 Trần Hưng Đạo, Hà Nội', '024-38225162'),
(2, N'Nhà Xuất Bản Trẻ', N'161B Nguyễn Du, Quận 1, TP.HCM', '028-38223642'),
(3, N'Nhà Xuất Bản Tổng hợp TP.HCM', N'61 Nguyễn Thị Minh Khai, Quận 1, TP.HCM', '028-38229685'),
(4, N'Nhà Xuất Bản Đà Nẵng', N'36 Điện Biên Phủ, TP. Đà Nẵng', '0236-3822565'),
(5, N'NXB Công an Nhân dân', N'43 Trần Phú, Hà Nội', '024-38263267'),
(6, N'NXB Lao động', N'53 Nguyễn Du, Hai Bà Trưng, Hà Nội', '024-38225261'),
(7, N'NXB Hồng Đức', N'36A Tràng Tiền, Hoàn Kiếm, Hà Nội', '024-39382008'),
(8, N'NXB Alpha Books', N'46 Đường số 7, Phường 4, Quận 5, TP.HCM', '028-38388067');
SET IDENTITY_INSERT PUBLISHER OFF;
GO

-- Insert AUTHOR
PRINT N'Inserting AUTHOR data...';
SET IDENTITY_INSERT AUTHOR ON;
INSERT INTO AUTHOR (AuthorID, Name, Nationality, YearOfBirth) VALUES
(1, N'Nguyen Nhat Anh', N'Việt Nam', 1980),
(2, N'To Hoai', N'Việt Nam', 1965),
(3, N'Nam Cao', N'Việt Nam', 1975),
(4, N'Tran Dang Khoa', N'Việt Nam', 1988),
(5, N'J.K. Rowling', N'Anh', 1965),
(6, N'Haruki Murakami', N'Nhật Bản', 1949),
(7, N'George Orwell', N'Anh', 1903),
(8, N'F. Scott Fitzgerald', N'Mỹ', 1896),
(9, N'Ernest Hemingway', N'Mỹ', 1899),
(10, N'Jane Austen', N'Anh', 1775),
(11, N'Leo Tolstoy', N'Nga', 1828),
(12, N'Victor Hugo', N'Pháp', 1802),
(13, N'Albert Camus', N'Pháp', 1913),
(14, N'Gabriel Garcia Marquez', N'Colombia', 1927),
(15, N'Isabel Allende', N'Chile', 1942);
SET IDENTITY_INSERT AUTHOR OFF;
GO

-- Insert MEMBER
PRINT N'Inserting MEMBER data...';
SET IDENTITY_INSERT MEMBER ON;
INSERT INTO MEMBER (MemberID, Name, Address, Phone, MembershipType, JoinDate) VALUES
(1, N'Nguyen Van An', N'123 Đường ABC, Quận 1, TP.HCM', '0901234567', 'Student', '2025-09-01'),
(2, N'Tran Thi Bich', N'456 Đường XYZ, Quận 3, TP.HCM', '0912345678', 'Faculty', '2024-08-15'),
(3, N'Le Van Cuong', N'789 Đường DEF, Quận 5, TP.HCM', '0923456789', 'Standard', '2025-01-10'),
(4, N'Pham Thi Dung', N'321 Đường GHI, Đà Nẵng', '0934567890', 'Premium', '2024-06-20'),
(5, N'Vu Van Em', N'654 Đường JKL, Hà Nội', '0945678901', 'Student', '2025-09-05'),
(6, N'Do Thi Phong', N'987 Đường MNO, Hải Phòng', '0956789012', 'Faculty', '2024-03-12'),
(7, N'Hoang Van Quy', N'147 Đường PQR, Cần Thơ', '0967890123', 'Standard', '2025-02-28'),
(8, N'Nguyen Thi Sang', N'258 Đường STU, Nghệ An', '0978901234', 'Student', '2025-08-20'),
(9, N'Tran Van Tan', N'369 Đường VWX, Huế', '0989012345', 'Premium', '2024-11-05'),
(10, N'Le Thi Uyen', N'741 Đường YZ, Buôn Ma Thuột', '0990123456', 'Faculty', '2024-07-18');
SET IDENTITY_INSERT MEMBER OFF;
GO

-- Insert BOOK
PRINT N'Inserting BOOK data...';
SET IDENTITY_INSERT BOOK ON;
INSERT INTO BOOK (BookID, ISBN, Title, SubjectCategory, PublicationYear, PublisherID) VALUES
(1, '978-604-0-00123-4', N'Tôi thấy hoa vàng trên cỏ xanh', N'Văn học', 2010, 1),
(2, '978-604-0-00234-5', N'Mắt biếc', N'Văn học', 2018, 1),
(3, '978-604-0-00345-6', N'Cho tôi xin một vé đi tuổi thơ', N'Văn học', 2015, 2),
(4, '978-604-0-00456-7', N'Bên kia rào cấm', N'Văn học', 2012, 3),
(5, '978-0-7475-3269-9', N'Harry Potter và the Philosopher''s Stone', N'Fantasy', 1997, 5),
(6, '978-0-7475-3849-3', N'Harry Potter và Chamber of Secrets', N'Fantasy', 1998, 5),
(7, '978-4-77-01536-8', N'Norwegian Wood', N'Romance', 1987, 4),
(8, '978-0-452-28423-4', N'1Q84', N'Fiction', 2009, 4),
(9, '978-0-452-28423-5', N'Animal Farm', N'Political Fiction', 1945, 6),
(10, '978-0-7432-7356-5', N'The Great Gatsby', N'Classic', 1925, 7),
(11, '978-0-684-80323-7', N'For Whom the Bell Tolls', N'Classic', 1940, 6),
(12, '978-0-14-143951-8', N'Pride and Prejudice', N'Romance', 1813, 8),
(13, '978-0-14-303999-8', N'War and Peace', N'Classic', 1869, 8),
(14, '978-0-679-72126-3', N'Les Misérables', N'Classic', 1862, 9),
(15, '978-0-375-40653-5', N'The Plague', N'Philosophy', 1947, 10),
(16, '978-0-06-088328-7', N'One Hundred Years of Solitude', N'Magic Realism', 1967, 11),
(17, '978-1-5011-7033-3', N'The House of the Spirits', N'Magic Realism', 1982, 7),
(18, '978-604-0-00567-8', N'Làng', N'Văn học', 2011, 1),
(19, '978-604-0-00678-9', N'Chí Phèo', N'Văn học', 2009, 1),
(20, '978-604-0-00789-0', N'Số đỏ', N'Văn học', 2013, 2);
SET IDENTITY_INSERT BOOK OFF;
GO

-- Insert BOOK_AUTHOR
PRINT N'Inserting BOOK_AUTHOR data...';
INSERT INTO BOOK_AUTHOR (BookID, AuthorID) VALUES
(1, 1),  -- Tôi thấy hoa vàng trên cỏ xanh - Nguyen Nhat Anh
(2, 2),  -- Mắt biếc - To Hoai
(3, 3),  -- Cho tôi xin một vé đi tuổi thơ - Nguyen Nhat Anh
(4, 4),  -- Bên kia rào cấm - Tran Dang Khoa
(5, 5),  -- Harry Potter 1 - J.K. Rowling
(6, 5),  -- Harry Potter 2 - J.K. Rowling
(7, 6),  -- Norwegian Wood - Haruki Murakami
(8, 6),  -- 1Q84 - Haruki Murakami
(9, 7),  -- Animal Farm - George Orwell
(10, 8), -- The Great Gatsby - F. Scott Fitzgerald
(11, 9), -- For Whom the Bell Tolls - Ernest Hemingway
(12, 10),-- Pride and Prejudice - Jane Austen
(13, 11),-- War and Peace - Leo Tolstoy
(14, 12),-- Les Misérables - Victor Hugo
(15, 13),-- The Plague - Albert Camus
(16, 14),-- One Hundred Years of Solitude - Gabriel Garcia Marquez
(17, 15),-- The House of the Spirits - Isabel Allende
(18, 2),  -- Làng - To Hoai
(19, 3),  -- Chí Phèo - Nam Cao
(20, 3);  -- Số đỏ - Nam Cao
GO

-- Insert BOOK_COPY
PRINT N'Inserting BOOK_COPY data...';
SET IDENTITY_INSERT BOOK_COPY ON;
INSERT INTO BOOK_COPY (CopyID, BookID, Condition, Status) VALUES
-- Sách tiếng Việt
(1, 1, 'New', 'Available'), (2, 1, 'New', 'Available'), (3, 1, 'Good', 'Available'),
(4, 2, 'Good', 'Available'), (5, 2, 'Fair', 'Available'),
(6, 3, 'New', 'Available'), (7, 3, 'Good', 'Available'), (8, 3, 'Good', 'Available'),
(9, 4, 'Fair', 'Available'), (10, 4, 'Poor', 'Maintenance'),
-- Harry Potter
(11, 5, 'New', 'Available'), (12, 5, 'New', 'Available'), (13, 5, 'Good', 'Borrowed'),
(14, 6, 'Good', 'Available'), (15, 6, 'Fair', 'Available'),
-- Murakami
(16, 7, 'Good', 'Available'), (17, 7, 'Good', 'Available'),
(18, 8, 'New', 'Available'), (19, 8, 'New', 'Available'), (20, 8, 'Fair', 'Available'),
-- Classics
(21, 9, 'Good', 'Available'), (22, 9, 'Fair', 'Available'),
(23, 10, 'New', 'Available'), (24, 10, 'Good', 'Available'), (25, 10, 'Good', 'Available'),
(26, 11, 'Fair', 'Available'), (27, 11, 'Poor', 'Available'),
(28, 12, 'Good', 'Available'), (29, 12, 'Good', 'Available'),
(30, 13, 'New', 'Available'), (31, 13, 'Fair', 'Available'),
(32, 14, 'Good', 'Available'), (33, 14, 'Good', 'Available'),
(34, 15, 'Fair', 'Available'), (35, 15, 'Fair', 'Available'),
-- More
(36, 16, 'New', 'Available'), (37, 16, 'Good', 'Available'),
(38, 17, 'Good', 'Available'), (39, 17, 'Fair', 'Available'),
(40, 18, 'Good', 'Available'), (41, 18, 'Good', 'Available'),
(42, 19, 'Fair', 'Available'),
(43, 20, 'New', 'Available'), (44, 20, 'Good', 'Available');
SET IDENTITY_INSERT BOOK_COPY OFF;
GO

-- Insert LOAN
PRINT N'Inserting LOAN data...';
SET IDENTITY_INSERT LOAN ON;
INSERT INTO LOAN (LoanID, MemberID, CopyID, BorrowDate, DueDate, ReturnDate, OverdueFine) VALUES
-- Mượn đang hoạt động (chưa trả)
(1, 1, 3, '2026-01-15', '2026-01-29', NULL, 0),
(2, 2, 12, '2026-01-20', '2026-02-03', NULL, 0),
(3, 3, 16, '2026-01-25', '2026-02-08', NULL, 0),
(4, 4, 10, '2026-01-10', '2026-01-24', NULL, 0),  -- Quá hạn!
(5, 5, 21, '2026-01-28', '2026-02-11', NULL, 0),
-- Mượn đã trả (đúng hạn)
(6, 1, 2, '2025-12-01', '2025-12-15', '2025-12-14', 0),
(7, 2, 4, '2025-12-05', '2025-12-19', '2025-12-18', 0),
(8, 3, 18, '2025-12-10', '2025-12-24', '2025-12-22', 0),
(9, 6, 21, '2025-12-15', '2025-12-29', '2025-12-28', 0),
(10, 7, 23, '2025-12-20', '2026-01-03', '2026-01-02', 0),
-- Mượn đã trả (quá hạn - có phạt)
(11, 4, 30, '2025-11-01', '2025-11-15', '2025-11-20', 25000),  -- 5 ngày quá hạn
(12, 5, 32, '2025-11-10', '2025-11-24', '2025-11-30', 60000),  -- 12 ngày quá hạn
(13, 8, 34, '2025-11-15', '2025-11-29', '2025-11-25', 0),    -- Trả sớm
(14, 9, 36, '2025-11-20', '2025-12-04', '2025-12-10', 60000), -- 12 ngày quá hạn
(15, 10, 38, '2025-11-25', '2025-12-09', '2025-12-08', 0);   -- Trả sớm
SET IDENTITY_INSERT LOAN OFF;
GO

PRINT N'================================================================'
PRINT N'SAMPLE DATA INSERTED SUCCESSFULLY'
PRINT N'  - PUBLISHER: 8 records'
PRINT N'  - AUTHOR: 15 records'
PRINT N'  - MEMBER: 10 records'
PRINT N'  - BOOK: 20 records'
PRINT N'  - BOOK_AUTHOR: 20 records'
PRINT N'  - BOOK_COPY: 44 records'
PRINT N'  - LOAN: 15 records'
PRINT N'================================================================'
GO

-- ============================================================
-- CREATE FUNCTIONS
-- ============================================================
PRINT N'Creating functions...';

-- Function 1: Get Books by Author (Table-Valued Function)
PRINT N'Creating function ufn_GetBooksByAuthor...';
GO
CREATE FUNCTION dbo.ufn_GetBooksByAuthor(@AuthorName VARCHAR(255))
RETURNS TABLE
AS
RETURN
(
    SELECT b.BookID, b.Title, b.ISBN, b.PublicationYear, p.Name AS Publisher
    FROM BOOK b
    INNER JOIN BOOK_AUTHOR ba ON b.BookID = ba.BookID
    INNER JOIN AUTHOR a ON ba.AuthorID = a.AuthorID
    INNER JOIN PUBLISHER p ON b.PublisherID = p.PublisherID
    WHERE a.Name = @AuthorName
);
GO

-- Function 2: Calculate Overdue Fine (Scalar Function)
PRINT N'Creating function ufn_CalculateOverdueFine...';
GO
CREATE FUNCTION dbo.ufn_CalculateOverdueFine(
    @DueDate DATE,
    @ReturnDate DATE,
    @DailyRate DECIMAL(10,2) = 5000
)
RETURNS DECIMAL(10,2)
AS
BEGIN
    IF @ReturnDate IS NULL OR @DueDate IS NULL
        RETURN 0;

    DECLARE @DaysOverdue INT;
    SET @DaysOverdue = DATEDIFF(DAY, @DueDate, @ReturnDate);

    IF @DaysOverdue > 0
        RETURN @DaysOverdue * @DailyRate;
    ELSE
        RETURN 0;
END;
GO

-- Function 3: Get Available Copies by Book (Table-Valued Function)
PRINT N'Creating function ufn_GetAvailableCopies...';
GO
CREATE FUNCTION dbo.ufn_GetAvailableCopies(@BookID INT)
RETURNS TABLE
AS
RETURN
(
    SELECT bc.CopyID, bc.Condition
    FROM BOOK_COPY bc
    WHERE bc.BookID = @BookID
      AND bc.Status = 'Available'
);
GO

PRINT N'================================================================'
PRINT N'ALL FUNCTIONS CREATED SUCCESSFULLY'
PRINT N'================================================================'
GO

-- ============================================================
-- CREATE STORED PROCEDURES
-- ============================================================
PRINT N'Creating stored procedures...';

-- Procedure 1: Borrow Book
PRINT N'Creating procedure usp_BorrowBook...';
GO
CREATE PROCEDURE dbo.usp_BorrowBook
    @MemberID    INT,
    @CopyID      INT,
    @DueDays     INT = 14
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @DueDate DATE;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- 1. Kiểm tra thành viên tồn tại
        IF NOT EXISTS (SELECT 1 FROM MEMBER WHERE MemberID = @MemberID)
        BEGIN
            RAISERROR(N'Lỗi: Thành viên không tồn tại!', 16, 1);
            RETURN;
        END

        -- 2. Kiểm tra bản sao sách tồn tại và AVAILABLE
        IF NOT EXISTS (
            SELECT 1 FROM BOOK_COPY
            WHERE CopyID = @CopyID AND Status = 'Available'
        )
        BEGIN
            RAISERROR(N'Lỗi: Sách không có sẵn để mượn!', 16, 1);
            RETURN;
        END

        -- 3. Kiểm tra thành viên có sách quá hạn chưa trả
        IF EXISTS (
            SELECT 1 FROM LOAN
            WHERE MemberID = @MemberID
              AND ReturnDate IS NULL
              AND DueDate < CAST(GETDATE() AS DATE)
        )
        BEGIN
            RAISERROR(N'Lỗi: Thành viên đang có sách quá hạn chưa trả. Không thể mượn thêm!', 16, 1);
            RETURN;
        END

        -- 4. Tính ngày hết hạn
        SET @DueDate = DATEADD(DAY, @DueDays, GETDATE());

        -- 5. Tạo giao dịch mượn
        INSERT INTO LOAN (MemberID, CopyID, BorrowDate, DueDate)
        VALUES (@MemberID, @CopyID, GETDATE(), @DueDate);

        -- 6. Cập nhật trạng thái bản sao
        UPDATE BOOK_COPY
        SET Status = 'Borrowed'
        WHERE CopyID = @CopyID;

        COMMIT TRANSACTION;

        SELECT N'Mượn sách thành công!' AS Message,
               @DueDate AS DueDate,
               (SELECT Title FROM BOOK WHERE BookID = (SELECT BookID FROM BOOK_COPY WHERE CopyID = @CopyID)) AS BookTitle;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO

-- Procedure 2: Return Book
PRINT N'Creating procedure usp_ReturnBook...';
GO
CREATE PROCEDURE dbo.usp_ReturnBook
    @CopyID      INT,
    @ReturnDate  DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @ReturnDate IS NULL
        SET @ReturnDate = CAST(GETDATE() AS DATE);

    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @LoanID INT, @DueDate DATE, @DaysOverdue INT, @Fine DECIMAL(10,2);
        DECLARE @BookTitle VARCHAR(255);

        -- 1. Lấy thông tin giao dịch mượn
        SELECT @LoanID = LoanID, @DueDate = DueDate
        FROM LOAN
        WHERE CopyID = @CopyID AND ReturnDate IS NULL;

        IF @LoanID IS NULL
        BEGIN
            RAISERROR(N'Lỗi: Không tìm thấy giao dịch mượn đang hoạt động!', 16, 1);
            RETURN;
        END

        -- Get book title for message
        SELECT @BookTitle = b.Title
        FROM BOOK b
        INNER JOIN BOOK_COPY bc ON b.BookID = bc.BookID
        WHERE bc.CopyID = @CopyID;

        -- 2. Tính phí phạt (nếu quá hạn)
        SET @DaysOverdue = DATEDIFF(DAY, @DueDate, @ReturnDate);

        IF @DaysOverdue > 0
            SET @Fine = @DaysOverdue * 5000; -- 5000 VNĐ/ngày
        ELSE
            SET @Fine = 0;

        -- 3. Cập nhật giao dịch mượn
        UPDATE LOAN
        SET ReturnDate = @ReturnDate,
            OverdueFine = @Fine
        WHERE LoanID = @LoanID;

        -- 4. Cập nhật trạng thái bản sao
        UPDATE BOOK_COPY
        SET Status = 'Available'
        WHERE CopyID = @CopyID;

        COMMIT TRANSACTION;

        SELECT N'Trả sách thành công!' AS Message,
               @BookTitle AS BookTitle,
               @DaysOverdue AS DaysOverdue,
               @Fine AS OverdueFine;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO

-- Procedure 3: Get Member Loan History
PRINT N'Creating procedure usp_GetMemberLoanHistory...';
GO
CREATE PROCEDURE dbo.usp_GetMemberLoanHistory
    @MemberID INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        l.LoanID,
        b.Title AS BookTitle,
        l.BorrowDate,
        l.DueDate,
        l.ReturnDate,
        l.OverdueFine,
        CASE
            WHEN l.ReturnDate IS NULL AND GETDATE() > l.DueDate THEN N'Quá hạn'
            WHEN l.ReturnDate IS NULL THEN N'Đang mượn'
            ELSE N'Đã trả'
        END AS Status
    FROM LOAN l
    INNER JOIN BOOK_COPY bc ON l.CopyID = bc.CopyID
    INNER JOIN BOOK b ON bc.BookID = b.BookID
    WHERE l.MemberID = @MemberID
    ORDER BY l.BorrowDate DESC;
END;
GO

-- Procedure 4: Get Overdue Loans Report
PRINT N'Creating procedure usp_GetOverdueLoansReport...';
GO
CREATE PROCEDURE dbo.usp_GetOverdueLoansReport
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        m.MemberID,
        m.Name AS MemberName,
        m.Phone AS MemberPhone,
        b.Title AS BookTitle,
        l.BorrowDate,
        l.DueDate,
        DATEDIFF(DAY, l.DueDate, GETDATE()) AS DaysOverdue,
        DATEDIFF(DAY, l.DueDate, GETDATE()) * 5000 AS EstimatedFine
    FROM LOAN l
    INNER JOIN MEMBER m ON l.MemberID = m.MemberID
    INNER JOIN BOOK_COPY bc ON l.CopyID = bc.CopyID
    INNER JOIN BOOK b ON bc.BookID = b.BookID
    WHERE l.ReturnDate IS NULL
      AND l.DueDate < CAST(GETDATE() AS DATE)
    ORDER BY DaysOverdue DESC;
END;
GO

PRINT N'================================================================'
PRINT N'ALL STORED PROCEDURES CREATED SUCCESSFULLY'
PRINT N'================================================================'
GO

-- ============================================================
-- CREATE TRIGGERS
-- ============================================================
PRINT N'Creating triggers...';

-- Trigger 1: Auto-calculate Overdue Fine on Return
PRINT N'Creating trigger trg_CalculateOverdueFine...';
GO
CREATE TRIGGER trg_CalculateOverdueFine
ON LOAN
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Chỉ xử lý khi ReturnDate được cập nhật từ NULL sang có giá trị
    IF UPDATE(ReturnDate)
    BEGIN
        UPDATE LOAN
        SET OverdueFine = dbo.ufn_CalculateOverdueFine(
                            i.DueDate,
                            i.ReturnDate,
                            5000
                         )
        FROM inserted i
        INNER JOIN LOAN l ON l.LoanID = i.LoanID
        WHERE i.ReturnDate IS NOT NULL
          AND l.OverdueFine = 0; -- Only calculate if not already set
    END
END;
GO

-- Trigger 2: Prevent Book Deletion if Active Loans Exist
PRINT N'Creating trigger trg_PreventDeleteBook_ActiveLoans...';
GO
CREATE TRIGGER trg_PreventDeleteBook_ActiveLoans
ON BOOK
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM deleted d
        INNER JOIN BOOK_COPY bc ON d.BookID = bc.BookID
        INNER JOIN LOAN l ON bc.CopyID = l.CopyID
        WHERE l.ReturnDate IS NULL
    )
    BEGIN
        RAISERROR(
            N'Lỗi: Không thể xóa sách vì đang có giao dịch mượn chưa hoàn trả!',
            16,
            1
        );
        RETURN;
    END

    -- If no active loans, proceed with delete
    DELETE FROM BOOK
    WHERE BookID IN (SELECT BookID FROM deleted);

    PRINT N'Sách đã được xóa thành công!';
END;
GO

-- Trigger 3: Log Price Changes (for future extension - add audit table)
-- Note: This trigger is prepared for when pricing is added to the system
PRINT N'Note: Audit trigger for pricing (prepared for future use)';
GO

PRINT N'================================================================'
PRINT N'ALL TRIGGERS CREATED SUCCESSFULLY'
PRINT N'================================================================'
GO

-- ============================================================
-- SAMPLE QUERIES FOR REPORTING
-- ============================================================
PRINT N'Creating views for reporting...';

-- View 1: Currently Borrowed Books
PRINT N'Creating view vw_CurrentlyBorrowedBooks...';
GO
CREATE VIEW vw_CurrentlyBorrowedBooks AS
SELECT
    l.LoanID,
    m.MemberID,
    m.Name AS MemberName,
    m.Phone AS MemberPhone,
    b.Title AS BookTitle,
    bc.CopyID,
    l.BorrowDate,
    l.DueDate,
    CASE
        WHEN l.ReturnDate IS NULL AND GETDATE() > l.DueDate THEN N'Quá hạn'
        WHEN l.ReturnDate IS NULL THEN N'Đang mượn'
        ELSE N'Đã trả'
    END AS Status,
    DATEDIFF(DAY, l.DueDate, GETDATE()) AS DaysOverdue
FROM LOAN l
INNER JOIN MEMBER m ON l.MemberID = m.MemberID
INNER JOIN BOOK_COPY bc ON l.CopyID = bc.CopyID
INNER JOIN BOOK b ON bc.BookID = b.BookID
WHERE l.ReturnDate IS NULL;
GO

-- View 2: Book Statistics
PRINT N'Creating view vw_BookStatistics...';
GO
CREATE VIEW vw_BookStatistics AS
SELECT
    b.BookID,
    b.Title,
    b.SubjectCategory,
    p.Name AS Publisher,
    COUNT(DISTINCT bc.CopyID) AS TotalCopies,
    SUM(CASE WHEN bc.Status = 'Available' THEN 1 ELSE 0 END) AS AvailableCopies,
    SUM(CASE WHEN bc.Status = 'Borrowed' THEN 1 ELSE 0 END) AS BorrowedCopies,
    COUNT(l.LoanID) AS TotalTimesBorrowed
FROM BOOK b
INNER JOIN PUBLISHER p ON b.PublisherID = p.PublisherID
LEFT JOIN BOOK_COPY bc ON b.BookID = bc.BookID
LEFT JOIN LOAN l ON bc.CopyID = l.CopyID
GROUP BY b.BookID, b.Title, b.SubjectCategory, p.Name;
GO

-- View 3: Member Statistics
PRINT N'Creating view vw_MemberStatistics...';
GO
CREATE VIEW vw_MemberStatistics AS
SELECT
    m.MemberID,
    m.Name,
    m.MembershipType,
    m.JoinDate,
    COUNT(l.LoanID) AS TotalLoans,
    SUM(l.OverdueFine) AS TotalFinesPaid,
    MAX(l.BorrowDate) AS LastBorrowDate
FROM MEMBER m
LEFT JOIN LOAN l ON m.MemberID = l.MemberID
GROUP BY m.MemberID, m.Name, m.MembershipType, m.JoinDate;
GO

PRINT N'================================================================'
PRINT N'ALL VIEWS CREATED SUCCESSFULLY'
PRINT N'================================================================'
GO

-- ============================================================
-- DEMONSTRATION QUERIES
-- ============================================================
PRINT N'';
PRINT N'================================================================'
PRINT N'DEMONSTRATION QUERIES'
PRINT N'================================================================'
PRINT N'';

-- Query 1: List all currently borrowed books
PRINT N'-- Query 1: Currently Borrowed Books --';
SELECT * FROM vw_CurrentlyBorrowedBooks ORDER BY DueDate;
GO

-- Query 2: Top 10 most borrowed books
PRINT N'-- Query 2: Top 10 Most Borrowed Books --';
SELECT TOP 10
    BookTitle,
    Publisher,
    TotalCopies,
    AvailableCopies,
    TotalTimesBorrowed
FROM vw_BookStatistics
ORDER BY TotalTimesBorrowed DESC;
GO

-- Query 3: Overdue books report
PRINT N'-- Query 3: Overdue Books Report --';
EXEC dbo.usp_GetOverdueLoansReport;
GO

-- Query 4: Books by publisher
PRINT N'-- Query 4: Books by Publisher --';
SELECT
    p.Name AS Publisher,
    COUNT(DISTINCT b.BookID) AS TotalBooks,
    COUNT(DISTINCT bc.CopyID) AS TotalCopies,
    COUNT(l.LoanID) AS TotalLoans
FROM PUBLISHER p
LEFT JOIN BOOK b ON p.PublisherID = b.PublisherID
LEFT JOIN BOOK_COPY bc ON b.BookID = bc.BookID
LEFT JOIN LOAN l ON bc.CopyID = l.CopyID
GROUP BY p.Name, p.PublisherID
ORDER BY TotalBooks DESC;
GO

-- Query 5: Member borrowing statistics
PRINT N'-- Query 5: Member Statistics --';
SELECT * FROM vw_MemberStatistics ORDER BY TotalLoans DESC;
GO

-- ============================================================
-- FINAL SUMMARY
-- ============================================================
PRINT N'';
PRINT N'================================================================'
PRINT N'DATABASE CREATION COMPLETED SUCCESSFULLY!'
PRINT N'================================================================'
PRINT N'Database: LibraryDB'
PRINT N'Tables: 7 (PUBLISHER, AUTHOR, MEMBER, BOOK, BOOK_COPY, LOAN, BOOK_AUTHOR)'
PRINT N'Functions: 3'
PRINT N'Stored Procedures: 4'
PRINT N'Triggers: 2'
PRINT N'Views: 3'
PRINT N'Sample Records: 123'
PRINT N'================================================================'
PRINT N''
PRINT N'Common Commands:'
PRINT N'  - View all books: SELECT * FROM vw_BookStatistics;'
PRINT N'  - View borrowed books: SELECT * FROM vw_CurrentlyBorrowedBooks;'
PRINT N'  - Borrow a book: EXEC dbo.usp_BorrowBook @MemberID=1, @CopyID=3;'
PRINT N'  - Return a book: EXEC dbo.usp_ReturnBook @CopyID=3;'
PRINT N'  - Overdue report: EXEC dbo.usp_GetOverdueLoansReport;'
PRINT N'================================================================'
GO

-- ============================================================
-- END OF SCRIPT
-- ============================================================
