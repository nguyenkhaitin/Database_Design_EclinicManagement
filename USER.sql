﻿--TẠO USER TỰ ĐỘNG BẰNG PROCEDURE (TÊN ĐĂNG NHẬP VÀ MẬT KHẨU Ở BẢNG ĐĂNG NHẬP)
EXEC USERS

--PHÂN QUYỀN

-- USER BENHNHAN
GRANT EXECUTE ON HOSOBN TO [BENHNHAN1]
GRANT EXECUTE ON HOADONBN TO [BENHNHAN1]
GRANT EXECUTE ON DONTHUOCBN TO [BENHNHAN1]
GRANT EXECUTE ON HOADON_BENHNHAN TO [BENHNHAN1]
GRANT EXECUTE ON DONTHUOC_BENHNHAN TO [BENHNHAN1]
GRANT EXECUTE ON TRACUALICHSUKHAM TO [BENHNHAN1]
GRANT EXECUTE ON THONGTINBENHNHAN TO [BENHNHAN1]





--USER YTA 
GRANT SELECT, INSERT, DELETE, UPDATE ON BENHNHAN TO YTA
GRANT SELECT, UPDATE ON HOADON TO YTA
DENY  SELECT, DELETE ON HOADON TO YTA
GRANT SELECT, INSERT, DELETE, UPDATE ON NHANVIEN TO YTA
--TRUY XUẤT CHỨC NĂNG PROCEDURE
GRANT EXECUTE ON HOADON_BENHNHAN TO YTA
GRANT EXECUTE ON DONTHUOC_BENHNHAN TO YTA
GRANT EXECUTE ON TRACUALICHSUKHAM TO YTA
GRANT EXECUTE ON THONGTINBENHNHAN TO YTA
GRANT EXECUTE ON TRACUU_LOAIBENH TO YTA
GRANT EXECUTE ON BENH_MA TO YTA
GRANT EXECUTE ON XUATVIEN TO YTA
GRANT EXECUTE ON DANHSACH_BENHNHAN_BACSI TO YTA



--USER BACSICD 
GRANT SELECT, INSERT, UPDATE ON KHAMCHIDINH to BACSICD
GRANT SELECT, INSERT, UPDATE ON KHAMCHITIET to BACSICD
GRANT SELECT, INSERT, UPDATE ON KHAMPHUONGTHUC to BACSICD
GRANT SELECT, INSERT, UPDATE ON BENH to BACSICD
GRANT SELECT, INSERT, DELETE, UPDATE ON NHANVIEN TO BACSICD
--TRUY XUẤT CHỨC NĂNG PROCEDURE
GRANT EXECUTE ON HOADON_BENHNHAN TO BACSICD
GRANT EXECUTE ON DONTHUOC_BENHNHAN TO BACSICD
GRANT EXECUTE ON TRACUALICHSUKHAM TO BACSICD
GRANT EXECUTE ON THONGTINBENHNHAN TO BACSICD
GRANT EXECUTE ON TRACUU_LOAIBENH TO BACSICD
GRANT EXECUTE ON BENH_MA TO BACSICD
GRANT EXECUTE ON XUATVIEN TO BACSICD
GRANT EXECUTE ON DANHSACH_BENHNHAN_BACSI TO BACSICD


--USER BACSITMH
--TRUY XUAT DU LIEU KHAU KHAM
GRANT SELECT ON KHAMCHIDINH to BACSITMH
GRANT SELECT ON KHAMCHITIET to BACSITMH
GRANT SELECT ON KHAMPHUONGTHUC to BACSITMH
GRANT SELECT ON BENH to BACSITMH
--NHAP, TRUY XUAT DU LIEU CHUA BENH	
GRANT SELECT, INSERT, UPDATE, DELETE ON CHUABENH to BACSITMH
GRANT SELECT, INSERT, UPDATE, DELETE ON CHUABENHPHUONGTHUC to BACSITMH
GRANT SELECT, INSERT, UPDATE, DELETE ON CHUABENHCHITIET to BACSITMH
GRANT SELECT, INSERT, UPDATE, DELETE ON DONTHUOC to BACSITMH
GRANT SELECT, INSERT, UPDATE, DELETE ON DONTHUOCCHITIET to BACSITMH
GRANT SELECT, INSERT, UPDATE, DELETE ON THUOC to BACSITMH
GRANT SELECT, INSERT, DELETE, UPDATE ON NHANVIEN TO BACSITMH
--TRUY XUẤT CHỨC NĂNG PROCEDURE
GRANT EXECUTE ON HOADON_BENHNHAN TO BACSITMH
GRANT EXECUTE ON DONTHUOC_BENHNHAN TO BACSITMH
GRANT EXECUTE ON TRACUALICHSUKHAM TO BACSITMH
GRANT EXECUTE ON THONGTINBENHNHAN TO BACSITMH
GRANT EXECUTE ON TRACUU_LOAIBENH TO BACSITMH
GRANT EXECUTE ON BENH_MA TO BACSITMH
GRANT EXECUTE ON XUATVIEN TO BACSITMH
GRANT EXECUTE ON DANHSACH_BENHNHAN_BACSI TO BACSITMH
GRANT EXECUTE ON BAN_THUOC TO BACSITMH




