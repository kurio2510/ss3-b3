-- I. Phân tích I/O
-- Input 
-- •	Bảng: CUSTOMERS 
-- Output 
-- Từ dữ liệu và comment “bẫy”, có thể suy ra Sếp muốn:
-- •	Danh sách khách hàng hợp lệ 
-- •	Phục vụ Marketing / chăm sóc 
-- Các cột hợp lý:
-- •	FullName 
-- •	Email 
-- •	City 
-- •	LastPurchaseDate 
-- •	Status 
-- II. Vì sao SELECT * là sai lầm?
-- Vấn đề:
-- 1. Lấy dư dữ liệu
-- •	Bảng có nhiều cột: Gender, DateOfBirth, Points, Address... 
-- •	Nhưng không dùng > lãng phí I/O 
-- 2. Tăng tải hệ thống
-- •	Quét nhiều dữ liệu hơn cần thiết > chậm 
-- •	Tốn RAM / network / disk 
-- 3. Phá index
-- •	DB không thể dùng covering index 
-- •	Buộc phải đọc full row > nghẽn cổ chai 
-- 4. Dễ “dính bẫy dữ liệu”
-- •	Lôi cả dữ liệu bẩn (NULL, sai format...) ra xử lý phía app 
-- III. Logic lọc dữ liệu


-- Từ dữ liệu mẫu:
-- Cần loại bỏ:
-- 1.	Khách không có Email 
-- Email IS NULL
-- 2.	Tài khoản bị khóa 
-- Status = 'Locked'
-- 3.	Dữ liệu ngày sai logic 
-- •	Ví dụ: ngày mua trong tương lai (2026-02-10) 
-- LastPurchaseDate <= GETDATE()
-- 4.	Khách quá lâu không mua ( > 6 tháng ) 
-- LastPurchaseDate >= DATEADD(MONTH, -6, GETDATE())
-- 5.	City không chuẩn hóa 
-- •	Ví dụ: 'TP HCM' vs 'Hồ Chí Minh'
-- Có thể tạm loại: 
-- City IN (N'Hà Nội', N'Hồ Chí Minh')
-- IV. Triển khai code:
SELECT 
    FullName,
    Email,
    City,
    LastPurchaseDate,
    Status
FROM CUSTOMERS
WHERE 
    Email IS NOT NULL
    AND Status = 'Active'
    AND LastPurchaseDate <= GETDATE()
    AND LastPurchaseDate >= DATEADD(MONTH, -6, GETDATE())
    AND City IN ('Hà Nội', 'Hồ Chí Minh');

