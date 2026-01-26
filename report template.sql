CREATE DATABASE GalleryDatabase;
Go

USE GalleryDatabase

DROP TABLE IF EXISTS LikesGroup;
DROP TABLE IF EXISTS LikesArtist;
DROP TABLE IF EXISTS ArtworkGroup;
DROP TABLE IF EXISTS Artwork;
DROP TABLE IF EXISTS Customer;
DROP TABLE IF EXISTS [Group];
DROP TABLE IF EXISTS Artist;

--SELECT * FROM LikesGroup;
--SELECT * FROM LikesArtist;
--SELECT * FROM ArtworkGroup;
--SELECT * FROM Artwork;
--SELECT * FROM Customer;
--SELECT * FROM [Group];
--SELECT * FROM Artist;

 
CREATE TABLE Artist (
    ArtistName  VARCHAR(255)  NOT NULL,
    Birthplace  VARCHAR(255)  NULL,
    Age         INT           NULL,
    Style       VARCHAR(100)  NOT NULL,
    CONSTRAINT PK_Artist PRIMARY KEY (ArtistName),
    CONSTRAINT CK_Artist_Age 
        CHECK (Age IS NULL OR (Age BETWEEN 0 AND 130))
);

CREATE TABLE [Group] (
    GroupName     VARCHAR(255)  NOT NULL,
    [Description] NVARCHAR(MAX)  NULL,
    CONSTRAINT PK_Group PRIMARY KEY (GroupName)
);

CREATE TABLE Customer (
    CustomerName VARCHAR(255)  NOT NULL,
    [Address]    VARCHAR(255)  NULL,
    TotalSpent   DECIMAL(12,2) NOT NULL 
    CONSTRAINT DF_Customer_TotalSpent DEFAULT (0),
    CONSTRAINT PK_Customer PRIMARY KEY (CustomerName),
    CONSTRAINT CK_Customer_TotalSpent CHECK (TotalSpent >= 0)
);

CREATE TABLE Artwork (
    ArtworkTitle VARCHAR(255)  NOT NULL,
    [Type]       VARCHAR(100)  NULL,
    YearMade     SMALLINT      NULL,
    Price        DECIMAL(14,2) NULL,
    ArtistName   VARCHAR(255)  NOT NULL,
    CONSTRAINT PK_Artwork PRIMARY KEY (ArtworkTitle),
    CONSTRAINT CK_Artwork_YearMade 
        CHECK (YearMade IS NULL OR (YearMade BETWEEN 1 AND 2100)),
    CONSTRAINT CK_Artwork_Price CHECK (Price IS NULL OR (Price >= 0)),
    CONSTRAINT FK_Artwork_Artist FOREIGN KEY (ArtistName)
        REFERENCES Artist(ArtistName)
        ON UPDATE CASCADE
        ON DELETE NO ACTION
);

CREATE TABLE ArtworkGroup (
    ArtworkTitle VARCHAR(255) NOT NULL,
    GroupName    VARCHAR(255) NOT NULL,
    CONSTRAINT PK_ArtworkGroup PRIMARY KEY (ArtworkTitle, GroupName),
    CONSTRAINT FK_AG_Artwork FOREIGN KEY (ArtworkTitle)
        REFERENCES Artwork(ArtworkTitle)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT FK_AG_Group FOREIGN KEY (GroupName)
        REFERENCES [Group](GroupName)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE LikesArtist (
    CustomerName VARCHAR(255) NOT NULL,
    ArtistName   VARCHAR(255) NOT NULL,
    CONSTRAINT PK_LikesArtist PRIMARY KEY (CustomerName, ArtistName),
    CONSTRAINT FK_LA_Customer FOREIGN KEY (CustomerName)
        REFERENCES Customer(CustomerName)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT FK_LA_Artist FOREIGN KEY (ArtistName)
        REFERENCES Artist(ArtistName)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE LikesGroup (
    CustomerName VARCHAR(255) NOT NULL,
    GroupName    VARCHAR(255) NOT NULL,
    CONSTRAINT PK_LikesGroup PRIMARY KEY (CustomerName, GroupName),
    CONSTRAINT FK_LG_Customer FOREIGN KEY (CustomerName)
        REFERENCES Customer(CustomerName)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT FK_LG_Group FOREIGN KEY (GroupName)
        REFERENCES [Group](GroupName)
        ON UPDATE CASCADE ON DELETE CASCADE
);


 

INSERT INTO Artist (ArtistName, Birthplace, Age, Style) VALUES
('Vincent van Gogh', 'Netherlands', 37, 'Post-Impressionism'),
('Frida Kahlo', 'Mexico', 47, 'Surrealism'),
('Andy Warhol', 'USA', 58, 'Pop Art'),
('Salvador Dalí', 'Spain', 45, 'Surrealism'),
('Pablo Picasso', 'Spain', 50, 'Cubism'),
('Henri Matisse', 'France', 76, 'Fauvism'),
('Claude Monet', 'France', 86, 'Impressionism'),
('Georgia O''Keeffe', 'USA', 98, 'Modernism'),
('Jackson Pollock', 'USA', 44, 'Abstract Expressionism'),
('Banksy', 'UK', 50, 'Street Art'),
('Yayoi Kusama', 'Japan', 96, 'Pop Art');

INSERT INTO [Group] (GroupName, [Description]) VALUES
('Abstract', N'Phong cách nghệ thuật trừu tượng, tập trung vào hình dạng, màu sắc và cảm xúc.'),
('Modern', N'Nghệ thuật hiện đại từ cuối thế kỷ 19 đến giữa thế kỷ 20, nhấn mạnh sự đổi mới.'),
('Renaissance', N'Thời kỳ Phục Hưng (thế kỷ 14–17), nổi bật với sự hài hòa và hiện thực.'),
('Contemporary', N'Nghệ thuật đương đại từ sau năm 1970, khám phá bản sắc cá nhân và công nghệ.'),
('Surrealism', N'Phong cách siêu thực, lấy cảm hứng từ giấc mơ và tiềm thức.'),
('Impressionism', N'Phong cách ấn tượng, tập trung vào ánh sáng và khoảnh khắc.'),
('Fauvism', N'Phong cách dã thú, sử dụng màu sắc mạnh mẽ.'),
('Pop Art', N'Nghệ thuật đại chúng, phản ánh văn hóa tiêu dùng và quảng cáo.'),
('Street Art', N'Nghệ thuật đường phố, bao gồm graffiti và stencil.');

INSERT INTO Customer (CustomerName, [Address], TotalSpent) VALUES
('Nguyen Van An', 'Ha Noi', 15000),
('Hoang Van Giang', 'Ho Chi Minh', 25000),
('Le Van Chi', 'Da Nang', 8000),
('Pham Thi Dung', 'Hue', 35000),
('Nguyen Van Em', 'Ha Noi', 12000),
('Vu Thi Phong', 'Da Nang', 9000),
('Do Van Y', 'Hue', 30000),
('Maria Rossi', 'Ho Chi Minh', 40000),
('John Smith', 'Ha Noi', 15000),
('Tran Thi Mai', 'Ho Chi Minh', 25000),
('Pham Thi Trang', 'Hue', 35000),
('Vu Thi Hong Thuy', 'London', 32000),
('Hiroshi Tanaka', 'Paris', 28000);


INSERT INTO Artwork (ArtworkTitle, [Type], YearMade, Price, ArtistName) VALUES
('Guernica', 'Painting', 1937, 50000000, 'Pablo Picasso'),
('Starry Night', 'Painting', 1889, 100000000, 'Vincent van Gogh'),
('The Two Fridas', 'Painting', 1939, 8000000, 'Frida Kahlo'),
('Campbell''s Soup Cans', 'Print', 1962, 11000000, 'Andy Warhol'),
('The Persistence of Memory', 'Painting', 1931, 60000000, 'Salvador Dalí'),
('Guernica Duplicate', 'Painting', 1937, 5000000, 'Pablo Picasso'),
('Starry Night Variant', 'Painting', 1890, 50000000, 'Vincent van Gogh'),
('The Dance', 'Painting', 1910, 90000000, 'Henri Matisse'),
('Water Lilies', 'Painting', 1916, 43000000, 'Claude Monet'),
('Black Iris', 'Painting', 1926, 6500000, 'Georgia O''Keeffe'),
('Number 1A, 1948', 'Painting', 1948, 140000000, 'Jackson Pollock'),
('Self-Portrait with Thorn Necklace', 'Painting', 1940, 12000000, 'Frida Kahlo'),
('Lobster Telephone', 'Sculpture', 1936, 2800000, 'Salvador Dalí'),
('Balloon Girl', 'Print', 2002, 17850000, 'Banksy'),
('Infinity Mirrored Room', 'Installation', 1965, 20000000, 'Yayoi Kusama'),
('Guernica Replica', 'Painting', 1937, 3000000, 'Pablo Picasso');

 
INSERT INTO ArtworkGroup (ArtworkTitle, GroupName) VALUES
('Starry Night', 'Modern'),
('The Two Fridas', 'Surrealism'),
('Campbell''s Soup Cans', 'Contemporary'),
('The Persistence of Memory', 'Surrealism'),
('Guernica Duplicate', 'Abstract'),
('Starry Night Variant', 'Modern'),
('The Dance', 'Fauvism'),
('Water Lilies', 'Impressionism'),
('Black Iris', 'Modern'),
('Number 1A, 1948', 'Abstract'),
('Self-Portrait with Thorn Necklace', 'Surrealism'),
('Lobster Telephone', 'Surrealism'),
('Balloon Girl', 'Street Art'),
('Infinity Mirrored Room', 'Contemporary'),
('Guernica Replica', 'Surrealism'),
('Guernica', 'Abstract');


INSERT INTO LikesArtist (CustomerName, ArtistName) VALUES
('Nguyen Van An', 'Pablo Picasso'),
('Hoang Van Giang', 'Vincent van Gogh'),
('Le Van Chi', 'Frida Kahlo'),
('Pham Thi Dung', 'Andy Warhol'),
('Nguyen Van Em', 'Pablo Picasso'),
('Vu Thi Phong', 'Henri Matisse'),
('Do Van Y', 'Claude Monet'),
('Maria Rossi', 'Georgia O''Keeffe'),
('John Smith', 'Pablo Picasso'),
('Tran Thi Mai', 'Vincent van Gogh'),
('Pham Thi Trang', 'Andy Warhol'),
('Vu Thi Hong Thuy', 'Salvador Dalí'),
('Hiroshi Tanaka', 'Andy Warhol');

INSERT INTO LikesGroup (CustomerName, GroupName) VALUES
('Nguyen Van An', 'Abstract'),
('Hoang Van Giang', 'Modern'),
('Le Van Chi', 'Surrealism'),
('Pham Thi Dung', 'Contemporary'),
('Nguyen Van Em', 'Abstract'),
('Vu Thi Phong', 'Impressionism'),
('Do Van Y', 'Modern'),
('Maria Rossi', 'Abstract'),
('John Smith', 'Abstract'),
('Tran Thi Mai', 'Modern'),
('Pham Thi Trang', 'Contemporary'),
('Vu Thi Hong Thuy', 'Contemporary'),
('Hiroshi Tanaka', 'Contemporary');

PRINT N'Dữ liệu đã được chèn đầy đủ và khớp với dataset GalleryDB chuẩn hóa.';

-- Queries

-- 1. Tìm tất cả các tác phẩm nghệ thuật có giá trị (Price) lớn hơn giá trung bình của các tác phẩm cùng loại (Type).
SELECT ArtworkTitle, [Type], Price,
       AVG(Price) OVER (PARTITION BY [Type]) AS GiaTrungBinhLoai
FROM Artwork
WHERE Price > (SELECT AVG(Price) 
               FROM Artwork a2 
               WHERE a2.[Type] = Artwork.[Type]);

-- 2. Tìm những nhóm nghệ thuật có hơn 2 tác phẩm, và trong số đó có ít nhất 1 tác phẩm được tạo bởi họa sĩ trên 45 tuổi.
SELECT 
    g.GroupName,
    COUNT(ag.ArtworkTitle) AS SoLuongArtwork,
    STRING_AGG(a.ArtistName, ', ') AS DanhSachArtist
FROM [Group] AS g
JOIN ArtworkGroup AS ag ON g.GroupName = ag.GroupName
JOIN (
    SELECT DISTINCT ArtworkTitle, ArtistName
    FROM Artwork
) AS a ON ag.ArtworkTitle = a.ArtworkTitle
WHERE EXISTS (
    SELECT 1
    FROM Artist AS ar
    WHERE ar.ArtistName = a.ArtistName
      AND ar.Age >= 45
)
GROUP BY g.GroupName
HAVING COUNT(ag.ArtworkTitle) >= 2;

-- 3. Với mỗi Style, tìm artwork đắt nhất và artist trẻ nhất (Age nhỏ nhất) thuộc style đó. Nếu có nhiều artwork cùng giá, lấy artwork có YearMade mới nhất
WITH RankedArtwork AS (
    SELECT ar.Style, aw.ArtworkTitle, aw.Price, aw.YearMade, aw.ArtistName, ar.Age,
        ROW_NUMBER() OVER (
            PARTITION BY ar.Style
            ORDER BY aw.Price DESC, aw.YearMade DESC
        ) AS RankByPrice
    FROM Artist AS ar JOIN Artwork AS aw ON ar.ArtistName = aw.ArtistName
),
YoungestArtist AS (
    SELECT Style,ArtistName,Age,
        ROW_NUMBER() OVER (
            PARTITION BY Style
            ORDER BY Age ASC
        ) AS RankByAge
    FROM Artist
)
SELECT r.Style, r.ArtworkTitle, r.Price, r.YearMade, y.ArtistName AS YoungestArtist,y.Age AS YoungestAge
FROM RankedArtwork AS r JOIN YoungestArtist AS y ON r.Style = y.Style
WHERE r.RankByPrice = 1 AND y.RankByAge = 1
ORDER BY r.Style;

-- 4.Liệt kê tất cả các tác phẩm nghệ thuật (Artwork) có giá trên 50 triệu đồng, sắp xếp theo giá giảm dần.---
SELECT ArtworkTitle, [Type], Price, ArtistName
FROM Artwork
WHERE Price > 50000000
ORDER BY Price DESC;

-- 5. Đếm số lượng tác phẩm (Artwork) mà mỗi họa sĩ (Artist) đã sáng tác. Chỉ hiển thị các họa sĩ có tối thiểu 2 tác phẩm
SELECT ArtistName, COUNT(*) AS SoLuongArtwork
FROM Artwork
GROUP BY ArtistName
HAVING COUNT(*) >= 2;
Go


-- Functions
-- Function 1: phân loại giá artwork
CREATE FUNCTION dbo.ufn_GetPriceLabel
(
    @Price DECIMAL(14,2)
)
RETURNS NVARCHAR(50)
AS
BEGIN
    DECLARE @Label NVARCHAR(50);

    IF @Price IS NULL
        SET @Label = N'Không có giá';
    ELSE IF @Price = 0
        SET @Label = N'Miễn phí';
    ELSE IF @Price < 50000000
        SET @Label = N'Giá thường';
    ELSE
        SET @Label = N'Giá cao';

    RETURN @Label;
END;
GO

-- Function 2: trả về tổng giá trị artwork theo artist và theo khoảng năm
CREATE FUNCTION dbo.ufn_GetArtistTotalValueByYearRange
(
    @FromYear INT,
    @ToYear   INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        a.ArtistName,
        SUM(aw.Price) AS TotalArtworkValue,
        COUNT(*)      AS ArtworkCount,
        MIN(aw.YearMade) AS EarliestYear,
        MAX(aw.YearMade) AS LatestYear
    FROM Artist a
    INNER JOIN Artwork aw ON a.ArtistName = aw.ArtistName
    WHERE
        aw.YearMade BETWEEN @FromYear AND @ToYear
        AND aw.Price IS NOT NULL
        AND aw.Price > 0
    GROUP BY a.ArtistName
);
GO


-- Procedure
-- Procedure 1: truyền tên artist → trả về danh sách tranh của người đó
CREATE PROCEDURE dbo.usp_GetArtworksByArtist
    @ArtistName NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        aw.ArtworkTitle,
        aw.[Type],
        aw.YearMade,
        aw.Price,
        aw.ArtistName
    FROM dbo.Artwork AS aw
    WHERE aw.ArtistName = @ArtistName
    ORDER BY aw.YearMade DESC, aw.ArtworkTitle;
END;
GO


-- PROCEDURE 2
-- Cập nhật giá của một Artwork, truyền vào thủ tục tên (ArtworkTitle) và giá mới cần cập nhật. Cần kiểm tra Artwork đó có tồn tại không, nếu không thì báo lỗi, thỏa điều kiện thì cập nhật giá mới.

CREATE PROCEDURE dbo.usp_UpdateArtworkPrice
    @ArtworkTitle NVARCHAR(255),
    @NewPrice     DECIMAL(14,2)
AS
BEGIN
    SET NOCOUNT ON;

    -- 1. Kiểm tra tồn tại
    IF NOT EXISTS (SELECT 1 FROM Artwork WHERE ArtworkTitle = @ArtworkTitle)
    BEGIN
        RAISERROR (N'Lỗi: Artwork "%s" không tồn tại.', 16, 1, @ArtworkTitle);
        RETURN;
    END

    -- 2. Kiểm tra giá
    IF @NewPrice IS NULL OR @NewPrice < 0
    BEGIN
        RAISERROR (N'Lỗi: Giá phải >= 0.', 16, 1);
        RETURN;
    END

    -- 3. Lấy giá cũ
    DECLARE @OldPrice DECIMAL(14,2);
    SELECT @OldPrice = Price
    FROM Artwork
    WHERE ArtworkTitle = @ArtworkTitle;

    -- 4. Cập nhật
    UPDATE Artwork
    SET Price = @NewPrice
    WHERE ArtworkTitle = @ArtworkTitle;

    -- 5. Trả kết quả
    SELECT 
        @ArtworkTitle AS ArtworkTitle,
        @OldPrice     AS OldPrice,
        @NewPrice     AS NewPrice,
        CASE 
            WHEN @OldPrice IS NULL THEN N'Đã cập nhật giá từ NULL → ' + CAST(@NewPrice AS NVARCHAR(30))
            ELSE N'Đã cập nhật giá từ ' + CAST(@OldPrice AS NVARCHAR(30)) + N' → ' + CAST(@NewPrice AS NVARCHAR(30))
        END AS Message;
END;
GO



-- Trigger
-- TRIGGER 1: Không đước xóa những Artist có giá hơn 50000000
CREATE TRIGGER trg_PreventDeleteExpensiveArtist
ON Artist
INSTEAD OF DELETE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM deleted d
        JOIN Artwork a ON d.ArtistName = a.ArtistName
        WHERE a.Price > 50000000
    )
    BEGIN
        DECLARE @ErrorMsg NVARCHAR(500);   -- dùng NVARCHAR
        
        SELECT TOP 1
            @ErrorMsg = N'Lỗi: Không thể xóa artist "' + d.ArtistName +
                        N'" vì có artwork trị giá ' + CAST(MAX(a.Price) AS NVARCHAR(20)) +
                        N' (> 50 triệu)!'
        FROM deleted d
        JOIN Artwork a ON d.ArtistName = a.ArtistName
        WHERE a.Price > 50000000
        GROUP BY d.ArtistName;
        
        RAISERROR(@ErrorMsg, 16, 1);
        RETURN;
    END

    DELETE FROM Artist
    WHERE ArtistName IN (SELECT ArtistName FROM deleted);

    PRINT N'Xóa artist thành công!';
END;
GO

-- Trigger 2: Nếu giảm quá 50% giá trị gốc -> chặn,Nếu tăng quá 50% giá trị gốc -> chặn
-- Bảng log (nếu đã tạo rồi thì bỏ đoạn này)
IF OBJECT_ID('dbo.ArtworkPriceAudit', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.ArtworkPriceAudit (
        AuditID       INT IDENTITY(1,1) PRIMARY KEY,
        ArtworkTitle  NVARCHAR(255),
        ArtistName    NVARCHAR(255),
        OldPrice      DECIMAL(14,2) NULL,
        NewPrice      DECIMAL(14,2) NULL,
        ChangedBy     NVARCHAR(255) NULL,
        ChangedAt     DATETIME NOT NULL DEFAULT (GETDATE()),
        ActionType    NVARCHAR(10) NOT NULL
    );
END;
GO

CREATE TRIGGER dbo.trg_Artwork_ControlPrice
ON dbo.Artwork
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN deleted d ON i.ArtworkTitle = d.ArtworkTitle
        WHERE d.Price IS NOT NULL
          AND i.Price IS NOT NULL
          AND (
                 i.Price > d.Price * 1.5   -- tăng quá 50%
              OR i.Price < d.Price * 0.5   -- giảm quá 50%
          )
    )
    BEGIN
        RAISERROR (
            N'Lỗi: Không được tăng hoặc giảm giá quá 50%% trong một lần cập nhật!',
            16, 1
        );
        ROLLBACK TRANSACTION;
        RETURN;
    END

    -- Ghi log các dòng đổi giá hợp lệ
    INSERT INTO dbo.ArtworkPriceAudit
    (
        ArtworkTitle,
        ArtistName,
        OldPrice,
        NewPrice,
        ChangedBy,
        ActionType
    )
    SELECT
        i.ArtworkTitle,
        i.ArtistName,
        d.Price AS OldPrice,
        i.Price AS NewPrice,
        SUSER_SNAME(),
        N'UPDATE'
    FROM inserted i
    JOIN deleted d ON i.ArtworkTitle = d.ArtworkTitle
    WHERE ISNULL(i.Price, -1) <> ISNULL(d.Price, -1);
END;
GO