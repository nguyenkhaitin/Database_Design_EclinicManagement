﻿-- 2.1.1.	Cho các nhóm đối đối tượng (y tá, bác sĩ, bệnh nhân)
-- PROCEDURE 1: NHẬP MÃ BỆNH NHÂN TRA CỨU HÓA ĐƠN 
CREATE PROCEDURE HOADON_BENHNHAN
    @MABENHNHAN numeric(8, 0)
AS
BEGIN
    SELECT *
    FROM HOADON
    WHERE MABENHNHAN = @MABENHNHAN
END
EXEC HOADON_BENHNHAN @MABENHNHAN = '10000001'


-- PROCEDURE 2: NHẬP MÃ BỆNH NHÂN XUẤT ĐƠN THUỐC 
CREATE PROCEDURE DONTHUOC_BENHNHAN
    @MABENHNHAN numeric(8, 0)
AS
BEGIN
    SELECT BN.MABENHNHAN, BN.HOBN, BN.TENBN, BN.DIACHIBN, B.TENBENH, T.THUOC, CT.SOLUONG, CT.HDSD, (T.GIATHUOC * CT.SOLUONG) AS GIA
    FROM DONTHUOC DT
	JOIN DONTHUOCCHITIET CT ON DT.MADONTHUOC = CT.MADONTHUOC
	JOIN THUOC T ON T.MATHUOC = CT.MATHUOC
	JOIN KHAMCHIDINH KCD ON KCD.MAKHAM = DT.MAKHAM
	JOIN KHAMCHITIET KCT ON KCT.MAKHAM = KCD.MAKHAM
	JOIN BENH B ON B.MABENH = KCT.MABENH
    JOIN BENHNHAN BN ON BN.MABENHNHAN = KCD.MABENHNHAN
	WHERE BN.MABENHNHAN = @MABENHNHAN
END
EXEC DONTHUOC_BENHNHAN @MABENHNHAN = '10000001'


-- PROCEDURE 3: TRA CỨU LỊCH SỬ KHÁM BẰNG HỌ TÊN VÀ NGÀY SINH BỆNH NHÂN
CREATE PROCEDURE TRACUALICHSUKHAM
    @HOBN  [nvarchar](100),
	@TENBN  [nvarchar](100),
	@NGAYSINH [smalldatetime]
AS
BEGIN
    SELECT BN.*, HD.TENBENH, HD.NGAYXUATHOADON, COUNT(*) AS N'SỐ LẦN KHÁM'
    FROM BENHNHAN BN
	JOIN HOADON HD ON HD.MABENHNHAN = BN.MABENHNHAN 
    WHERE BN.HOBN = @HOBN AND BN.TENBN = @TENBN AND BN.NGAYSINHBN = @NGAYSINH
	GROUP BY BN.MABENHNHAN, BN.TENBN, BN.HOBN, NGAYSINHBN, GIOITINHBN, NGHENGHIEP, DIACHIBN, HD.TENBENH, HD.NGAYXUATHOADON
END
EXEC TRACUALICHSUKHAM @HOBN = N'Nguyễn Mai Xuân', @TENBN = N'Linh',  @NGAYSINH = '2000-01-13'


-- PROCEDURE 4: XEM BỆNH NHÂN ĐƯỢC CHỮA BỞI PHÒNG BAN NÀO, THUỘC CHUYÊN MÔN NÀO VÀ PHƯƠNG THỨC CHỮA LÀ GÌ?
CREATE PROCEDURE THONGTINBENHNHAN
    @MABENHNHAN NUMERIC(8, 0)
AS
BEGIN
    SELECT DISTINCT
        BN.MABENHNHAN,
        BN.TENBN,
        NV.TENNV,
        PB.TENPHONGBAN,
		CM.TENCHUYENMON,
        CBPT.PHUONGTHUCCHUA 
    FROM 
        BENHNHAN BN
        JOIN KHAMCHIDINH KCD ON KCD.MABENHNHAN = BN.MABENHNHAN
        JOIN CHUABENH CB ON CB.MAKHAM = KCD.MAKHAM
        JOIN CHUABENHPHUONGTHUC CBPT ON CBPT.MAPHUONGTHUCCHUA = CB.MAPHUONGTHUCCHUA
        JOIN CHUABENHCHITIET CBCT ON CBCT.MACHUABENH = CB.MACHUABENH
        JOIN NHANVIEN NV ON NV.MANHANVIEN = CBCT.MANHANVIEN 
		JOIN CHUYENMON CM ON CM.MACHUYENMON = NV.MACHUYENMON
        JOIN PHONGBAN PB ON PB.MAPHONGBAN = NV.MAPHONGBAN
    WHERE 
        BN.MABENHNHAN = @MABENHNHAN
END
GO
EXEC THONGTINBENHNHAN @MABENHNHAN = 10000001


-- 2.1.2.	Cho hai đối tượng y tá, bác sĩ
-- PROCEDURE 5: TRA CỨU LOẠI BỆNH BẰNG TÊN BỆNH VÀ NGƯỢC LẠI
CREATE PROCEDURE TRACUU_LOAIBENH
	@PHANLOAI NVARCHAR (255),
	@MAPHANLOAI NUMERIC (3,0)
AS
BEGIN
		SELECT B.PHANLOAI, CM.TENCHUYENMON, B.TENBENH
		FROM BENH B
		JOIN CHUYENMON CM ON CM.MACHUYENMON = B.PHANLOAI
		WHERE CM.TENCHUYENMON = @PHANLOAI
		OR B.PHANLOAI = @MAPHANLOAI
END

EXEC TRACUU_LOAIBENH @PHANLOAI = N'Tiêu hóa - Gan mật', @MAPHANLOAI = NULL


-- PROCEDURE 6: TRA CỨU TÊN BỆNH BẰNG MÃ BỆNH VÀ NGƯỢC LẠI
CREATE PROCEDURE BENH_MA
    @MABENH numeric(3, 0),
	@TENBENH [nvarchar](100)
AS
BEGIN
    SELECT *
    FROM BENH
    WHERE MABENH = @MABENH
	OR TENBENH = @TENBENH
END
EXEC BENH_MA @MABENH = NULL , @TENBENH = N'Loét thực quản'


-- PROCEDURE 7: TRA CỨU BỆNH NHÂN ĐÃ XUẤT VIỆN HAY CHƯA
CREATE PROCEDURE XUATVIEN
    @TRANGTHAI NVARCHAR(255)
AS
BEGIN
    IF @TRANGTHAI = 'DA XUAT VIEN'
    BEGIN
        SELECT *
        FROM HOADON
        WHERE  NGAYXUATHOADON IS NOT NULL
    END
    ELSE IF @TRANGTHAI = 'CHUA XUAT VIEN'
    BEGIN
        SELECT *
        FROM HOADON
        WHERE  NGAYXUATHOADON IS NULL
    END
END
EXEC XUATVIEN  @TRANGTHAI = 'DA XUAT VIEN'


-- PROCEDURE 8: TRA CỨU DANH SÁCH BỆNH NHÂN BÁC SĨ PHỤ TRÁCH BẰNG MÃ NHÂN VIÊN
CREATE PROCEDURE DANHSACH_BENHNHAN_BACSI
    @MABACSI numeric(8, 0)
AS
BEGIN
    SELECT 
        HD.MABENHNHAN, HD.HOBN, HD.TENBN
    FROM HOADON HD
	JOIN CHUABENH CB ON CB.MACHUABENH = HD.MACHUABENH
	JOIN CHUABENHCHITIET CBCT ON CBCT.MACHUABENH = CB.MACHUABENH
	JOIN NHANVIEN NV ON NV.MANHANVIEN = CBCT.MANHANVIEN
    WHERE NV.MANHANVIEN = @MABACSI
END

EXEC DANHSACH_BENHNHAN_BACSI @MABACSI = 10000000


--2.2.1.	Cho đối tương bác sĩ
-- PROCEDURE 9: TRA CỨU SỐ LƯỢNG THUỐC TRONG KHO BẰNG MÃ THUỐC HOẶC TÊN THUỐC, BÁN THUỐC TỰ ĐỘNG NHẬP DỮ LIỆU VÀO BẢNG VỚI ĐIỀU KIỆN MÃ ĐƠN THUỐC TỒN TẠI VÀ SỐ LƯỢNG THUỐC BÁN RA KHÔNG VƯỢT QUÁ SỐ LƯỢNG TỒN KHO
CREATE PROCEDURE BAN_THUOC
	@MADONTHUOC NUMERIC(8, 0) = NULL,
    @MATHUOC NUMERIC(6, 0),
    @TENTHUOC NVARCHAR(255),
    @SOLUONGBAN INT = 0,
	@HDSG NVARCHAR(100) = NULL
AS
BEGIN
    DECLARE @SOLUONGKHO INT;
	DECLARE @TEN_THUOC NVARCHAR (255);

    SELECT DISTINCT T.MATHUOC, T.THUOC, T.TONKHO
    FROM THUOC T
    WHERE (T.MATHUOC = @MATHUOC OR @MATHUOC IS NULL)
    AND (T.THUOC = @TENTHUOC OR @TENTHUOC IS NULL)

    IF NOT EXISTS (SELECT * FROM DONTHUOC WHERE MADONTHUOC = @MADONTHUOC OR @MADONTHUOC IS NULL)
		BEGIN
			RAISERROR ('MÃ ĐƠN THUỐC KHÔNG TỒN TẠI', 16, 1)
			RETURN
		END
    IF @SOLUONGBAN > 0
    BEGIN
        SELECT @SOLUONGKHO = TONKHO, @TEN_THUOC = THUOC
        FROM THUOC
        WHERE MATHUOC = @MATHUOC
        IF @SOLUONGBAN > @SOLUONGKHO
		BEGIN
		RAISERROR ('SỐ LƯỢNG THUỐC BÁN RA LỚN HƠN SỐ LƯỢNG THUỐC TRONG KHO', 16, 1)
		ROLLBACK TRANSACTION
		END
		ELSE
			BEGIN
				UPDATE THUOC
				SET TONKHO = TONKHO - @SOLUONGBAN
				WHERE MATHUOC = @MATHUOC 
				INSERT DONTHUOCCHITIET (MATHUOC, MADONTHUOC, SOLUONG, HDSD)
				VALUES (@MATHUOC, @MADONTHUOC, @SOLUONGBAN, @HDSG)
			PRINT (N'ĐÃ BÁN THUỐC VÀ CẬP NHẬT KHO THÀNH CÔNG. TÊN THUỐC: ' + @TEN_THUOC + N'. SỐ LƯỢNG BÁN: ' + CAST(@SOLUONGBAN AS NVARCHAR(10)) + N'.')
			END
    END
END
-- TRA CỨU THUỐC 
EXEC BAN_THUOC @MATHUOC = 100009, @TENTHUOC = NULL
-- BÁN THUỐC
EXEC BAN_THUOC		@MADONTHUOC = 10000011,
					@MATHUOC = 100009,
					@TENTHUOC = NULL,
					@SOLUONGBAN = 100,
					@HDSG = N'NHAI THUỐC'


-- 2.2.2.	Cho đối tượng bệnh nhân (kết quả ở tài khoản bệnh nhân)
-- PROCEDURE 10 : BỆNH NHÂN CÓ QUYỀN ĐĂNG NHẬP HỆ THỐNG ĐỂ XEM BỆNH ÁN CÁ NHÂN 
--USER BENHNHAN1 - OLDPASS: "password1", NEWPASS: "123" (TẠO USER TỪ ADMIN TRƯỚC)
CREATE PROCEDURE HOSOBN
AS
BEGIN
DECLARE @TENDANGNHAP NVARCHAR(128) = SUSER_SNAME()
SELECT * 
FROM dbo.BENHNHAN
WHERE MABENHNHAN = ( SELECT MADANGNHAP 
        FROM dbo.DANGNHAP 
        WHERE TENDANGNHAP = @TENDANGNHAP)
END
GO


-- PROCEDURE 11 : XEM HÓA ĐƠN BỆNH NHÂN
CREATE PROCEDURE HOADONBN
AS
BEGIN
    DECLARE @TENDANGNHAP NVARCHAR(128) = SUSER_SNAME()
    DECLARE @MADANGNHAP NUMERIC(8, 0)
SELECT @MADANGNHAP = MADANGNHAP 
FROM dbo.DANGNHAP 
WHERE TENDANGNHAP = @TENDANGNHAP
SELECT * 
    FROM dbo.HOADON
    WHERE MABENHNHAN = @MADANGNHAP
END
GO


-- PROCEDURE 12 : XEM ĐƠN THUỐC BỆNH NHÂN
CREATE PROCEDURE DONTHUOCBN
AS
BEGIN
DECLARE  @TENDANGNHAP NVARCHAR(128) = SUSER_SNAME()
SELECT DISTINCT BN.MABENHNHAN, BN.HOBN, BN.TENBN, BN.DIACHIBN, B.TENBENH, T.THUOC, CT.SOLUONG, CT.HDSD, (T.GIATHUOC * CT.SOLUONG) AS GIA
    FROM DONTHUOC DT
	JOIN DONTHUOCCHITIET CT ON DT.MADONTHUOC = CT.MADONTHUOC
	JOIN THUOC T ON T.MATHUOC = CT.MATHUOC
	JOIN KHAMCHIDINH KCD ON KCD.MAKHAM = DT.MAKHAM
	JOIN KHAMCHITIET KCT ON KCT.MAKHAM = KCD.MAKHAM
	JOIN BENH B ON B.MABENH = KCT.MABENH
 	JOIN BENHNHAN BN ON BN.MABENHNHAN = KCD.MABENHNHAN
	JOIN DANGNHAP DN ON DN.MADANGNHAP = BN.MABENHNHAN
	WHERE DN.TENDANGNHAP = @TENDANGNHAP
END 
GO



--2.2.3.	Cho đối tượng quản trị viên
-- PROCEDURE 13 : TẠO LOGIN, USER TỰ ĐỘNG CHO BÊNH NHÂN VÀ NHÂN VIÊN
 CREATE PROCEDURE USERS
AS
BEGIN
    DECLARE @MADANGNHAP NUMERIC(8, 0)
    DECLARE @TENDANGNHAP NVARCHAR(12)
    DECLARE @MATKHAU NVARCHAR(12)
    DECLARE @SQL NVARCHAR(MAX)
    DECLARE cur CURSOR FOR
    SELECT MADANGNHAP, TENDANGNHAP, MATKHAU FROM dbo.DANGNHAP
    OPEN cur
    FETCH NEXT FROM cur INTO @MADANGNHAP, @TENDANGNHAP, @MATKHAU
    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @SQL = 'CREATE LOGIN [' + CONVERT(VARCHAR(12), @TENDANGNHAP) + '] WITH PASSWORD = ''' + @MATKHAU + ''';'
        EXEC sp_executesql @SQL

        SET @SQL = 'CREATE USER [' + CONVERT(VARCHAR(12), @TENDANGNHAP) + '] FOR LOGIN [' + CONVERT(VARCHAR(12), @TENDANGNHAP) + '];'
        EXEC sp_executesql @SQL
        FETCH NEXT FROM cur INTO @MADANGNHAP, @TENDANGNHAP, @MATKHAU
    END
    CLOSE cur
    DEALLOCATE cur
END
GO


-- PROCEDURE 14 : THỐNG KÊ DOANH THU TỪNG THÁNG THEO NĂM
CREATE PROCEDURE THONGKE_DOANHTHU
    @NAM int
AS
BEGIN
    SELECT	ISNULL([1], 0) AS [Thang1],
			ISNULL([2], 0) AS [Thang2],
			ISNULL([3], 0) AS [Thang3],
			ISNULL([4], 0) AS [Thang4],
			ISNULL([5], 0) AS [Thang5],
			ISNULL([6], 0) AS [Thang6],
			ISNULL([7], 0) AS [Thang7],
			ISNULL([8], 0) AS [Thang8],
			ISNULL([9], 0) AS [Thang9],
			ISNULL([10], 0) AS [Thang10],
			ISNULL([11], 0) AS [Thang11],
			ISNULL([12], 0) AS [Thang12]
    FROM (
        SELECT 
        MONTH(NGAYXUATHOADON) AS THANG, HD.TONGTIEN
        FROM HOADON HD
        WHERE YEAR(NGAYXUATHOADON) = @NAM
    ) AS DOANHTHU
    PIVOT
    (
        SUM(TONGTIEN)
        FOR THANG IN ([1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12])
    ) AS THANG
END
EXEC THONGKE_DOANHTHU @NAM = 2023


-- PROCEDURE 15 : TÍNH LƯƠNG NHÂN VIÊN BẰNG MÃ NHÂN VIÊN VÀ NĂM (LƯƠNG CƠ BẢN 10 TRIỆU + THƯỞNG 10% TIỀN CÓ KHÁM/CHỮA/THƯỐC NHÂN VIÊN ĐÓ PHỤ TRÁCH)
CREATE PROCEDURE TINH_LUONG_NHANVIEN
    @MANHANVIEN numeric(8, 0),
    @NAM int
AS
BEGIN
    DECLARE @LUONGCOBAN money
    DECLARE @THUONG money
    DECLARE @TONGLUONG money
		
		SET @LUONGCOBAN = 10000000.0000
		SELECT 
			@THUONG = ISNULL(SUM((0.1 * ISNULL(KCD.GIAKHAM, 0)) + 
                            (0.1 * ISNULL(CB.GIACHUA, 0)) + 
                            (0.1 * ISNULL(DT.GIADONTHUOC, 0))), 0)
		FROM KHAMCHIDINH KCD 
		LEFT JOIN CHUABENH CB ON CB.MAKHAM = KCD.MAKHAM
		LEFT JOIN CHUABENHCHITIET CBCT ON CBCT.MACHUABENH = CB.MACHUABENH
		LEFT JOIN DONTHUOC DT ON DT.MAKHAM = KCD.MAKHAM
		LEFT JOIN HOADON HD ON HD.MAKHAM = KCD.MAKHAM
		WHERE (KCD.MANHANVIEN = @MANHANVIEN OR CBCT.MANHANVIEN = @MANHANVIEN OR DT.MANHANVIEN = @MANHANVIEN)
		AND YEAR(HD.NGAYXUATHOADON) = @NAM	
		SET @TONGLUONG = @LUONGCOBAN + @THUONG
    SELECT @MANHANVIEN AS MANHANVIEN, @LUONGCOBAN AS LUONGCOBAN, @THUONG AS THUONG, @TONGLUONG AS TONGLUONG
END	
EXEC TINH_LUONG_NHANVIEN @MANHANVIEN = 10000003, @NAM = 2024


-- PROCEDURE 16 : THỐNG KÊ TỶ LỆ BỆNH CỦA PHÒNG KHÁM
CREATE PROCEDURE TILE_BENH
AS
BEGIN
    SELECT TENCHUYENMON, 
           COUNT(*) AS SOLUONG, 
           CAST(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM BENH) AS DECIMAL(5,2)) AS TILE
    INTO #BENH
    FROM BENH
    JOIN CHUYENMON ON MACHUYENMON = PHANLOAI
    GROUP BY TENCHUYENMON

    CREATE TABLE #KETQUA (
		[Hạng mục] NVARCHAR(50),
        [Tai mũi họng] DECIMAL(5,2) NULL,
        [Tim mạch] DECIMAL(5,2) NULL,
        [Hô hấp - Dị ứng miễn dịch lâm sàng] DECIMAL(5,2) NULL,
        [Tiêu hóa - Gan mật] DECIMAL(5,2) NULL,
        [Truyền nhiễm] DECIMAL(5,2) NULL
    )

    INSERT INTO #KETQUA ([Hạng mục], [Tai mũi họng], [Tim mạch], [Hô hấp - Dị ứng miễn dịch lâm sàng], [Tiêu hóa - Gan mật], [Truyền nhiễm])
    SELECT N'SỐ LƯỢNG', *
    FROM (
        SELECT TENCHUYENMON, SOLUONG
        FROM #BENH
    ) AS SL
    PIVOT (
        MAX(SOLUONG) FOR TENCHUYENMON IN ([Tai mũi họng], [Tim mạch], [Hô hấp - Dị ứng miễn dịch lâm sàng], [Tiêu hóa - Gan mật], [Truyền nhiễm])
    ) AS PV_SOLUONG;
	 INSERT INTO #KETQUA ([Hạng mục], [Tai mũi họng], [Tim mạch], [Hô hấp - Dị ứng miễn dịch lâm sàng], [Tiêu hóa - Gan mật], [Truyền nhiễm])
    SELECT N'TỈ LỆ (%)', *
    FROM (
        SELECT TENCHUYENMON, TILE
        FROM #BENH
    ) AS TL
    PIVOT (
        MAX(TILE) FOR TENCHUYENMON IN ([Tai mũi họng], [Tim mạch], [Hô hấp - Dị ứng miễn dịch lâm sàng], [Tiêu hóa - Gan mật], [Truyền nhiễm])
    ) AS PV_TILE

	SELECT * FROM #KETQUA

    DROP TABLE #BENH
    DROP TABLE #KETQUA
END
EXEC TILE_BENH


-- PROCEDURE 17 : THỐNG KÊ TOP 10 BỆNH CÓ XÁC XUẤT MẮC PHẢI CAO NHẤT
CREATE PROCEDURE TOP_BENH
AS
BEGIN
    CREATE TABLE #TAM_BENH (
        TENBENH NVARCHAR(255),
        SOLUONG INT,
        XACXUAT DECIMAL(5, 2)
    );
    INSERT INTO #TAM_BENH (TENBENH, SOLUONG, XACXUAT)
    SELECT 
        TENBENH,
        COUNT(KHAMCHITIET.MABENH) AS SOLUONG,
        CAST(COUNT(KHAMCHITIET.MABENH) * 1.0 / (SELECT COUNT(*) FROM BENH) AS DECIMAL(5,2)) AS TILE
    FROM BENH
	JOIN KHAMCHITIET ON BENH.MABENH = KHAMCHITIET.MABENH
    GROUP BY TENBENH

    SELECT TOP 10 TENBENH, SOLUONG, XACXUAT
    FROM #TAM_BENH
    ORDER BY XACXUAT DESC

    DROP TABLE #TAM_BENH
END
EXEC TOP_BENH


-- FUNCTION 1 : TẠO FUNCTION XẾP HẠNG CÁC LOẠI THUỐC DỰA THEO SỐ LƯỢNG BÁN RA TRONG NĂM
CREATE FUNCTION XEPHANGTHUOCBAN
(
    @NAM INT
)
RETURNS TABLE
AS
RETURN
(
  SELECT DT.MATHUOC AS MaThuoc, T.Thuoc, SUM(DT.SoLuong) AS TongSoLuongBan,
CASE 
 WHEN SUM(DT.SoLuong) > 30 THEN N'THUỐC BÁN CHẠY'
 WHEN SUM(DT.SoLuong) < 5 THEN N'THUỐC BÁN Ế' ELSE N'THUỐC BÁN BÌNH THƯỜNG'
END AS TrangThai
FROM THUOC T
    LEFT JOIN DONTHUOCCHITIET DT ON T.MATHUOC = DT.MATHUOC
	LEFT JOIN HOADON HD ON HD.MADONTHUOC = DT.MADONTHUOC
WHERE YEAR(HD.NGAYXUATHOADON) = @NAM
GROUP BY DT.MATHUOC, T.Thuoc)

SELECT * FROM XEPHANGTHUOCBAN(2023)
