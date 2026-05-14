create database final;
use final;

-- Phần 1
create table Customers (
	Customer_ID varchar(5) primary key,
    Full_Name varchar(50) not null,
    Phone_Number int unique,
    Email varchar(100) not null,
    Join_Date date 
);

create table Insurance_Packages (
	Package_ID varchar(5) primary key,
    Package_Name varchar(255) not null,
    Max_Limit decimal(18, 2) check (Max_Limit > 0),
    Base_Premium decimal (18, 2) 
);

create table Policies (
	Policy_ID varchar(6) primary key,
    Customer_ID varchar(5) not null,
    Package_ID varchar(5) not null,
    Start_Date date,
    End_Date date,
    Status varchar(20),
    foreign key (Customer_ID) references Customers (Customer_ID),
    foreign key (Package_ID) references Insurance_Packages (Package_ID)
);

create table Claims (
	Claim_ID varchar(6) primary key,
    Policy_ID varchar (6) not null,
    Claim_Date date,
    Claim_Amount decimal(18, 2) check (Claim_Amount > 0),
    Status varchar(20),
    foreign key (Policy_ID) references Policies (Policy_ID)
);

create table Claim_Processing_Log (
	Log_ID varchar(4) primary key,
    Claim_ID varchar(6) not null,
    Action_Detail varchar(255),
    Recorded_At datetime,
    Processor varchar(50),
    foreign key (Claim_ID) references Claims (Claim_ID)
);

insert into Customers (Customer_ID, Full_Name, Phone_Number, Email, Join_Date)
values
('C001', 'Nguyen Hoang Long', 0901112223, 'long.nh@gmail.com', '2024-01-15'),
('C002', 'Tran Thi Kim Anh', 0988877766, 'anh.tk@yahoo.com', '2024-03-10'),
('C003', 'Le Hoang Nam', 0903334445, 'nam.lh@outlook.com', '2025-05-20'),
('C004', 'Pham Minh Duc', 0355556667, 'duc.pm@gmail.com', '2025-08-12'),
('C005', 'Hoang Thu Thao', 0779998881, 'thao.ht@gmail.com', '2026-05-01');

insert into Insurance_Packages (Package_ID, Package_Name, Max_Limit, Base_Premium )
values
('PKG01', 'Bảo hiểm Sức khỏe Gold', 500000000, 5000000),
('PKG02', 'Bảo hiểm Ô tô Liberty', 1000000000, 15000000),
('PKG03', 'Bảo hiểm Nhân thọ An Bình', 2000000000, 25000000),
('PKG04', 'Bảo hiểm Du lịch Quốc tế', 100000000, 1000000),
('PKG05', 'Bảo hiểm Tai nạn 24/7', 200000000, 2500000);

insert into Policies (Policy_ID, Customer_ID, Package_ID, Start_Date, End_Date, Status)
values
('POL101', 'C001', 'PKG01', '2024-01-15', '2025-01-15', 'Expired'),
('POL102', 'C002', 'PKG02', '2024-03-10', '2026-03-10', 'Active'),
('POL103', 'C003', 'PKG03', '2025-05-20', '2035-05-20', 'Active'),
('POL104', 'C004', 'PKG04', '2025-08-12', '2025-09-12', 'Expired'),
('POL105', 'C005', 'PKG01', '2026-01-01', '2027-01-01', 'Active');

insert into Claims (Claim_ID, Policy_ID, Claim_Date, Claim_Amount , Status)
values
('CLM901', 'POL102', '2024-06-15', 12000000, 'Approved'),
('CLM902', 'POL103', '2025-10-20', 50000000, 'Pending'),
('CLM903', 'POL101', '2024-11-05', 5500000, 'Approved'),
('CLM904', 'POL105', '2026-01-15', 2000000, 'Rejected'),
('CLM905', 'POL102', '2025-02-10', 120000000, 'Approved');

insert into Claim_Processing_Log (Log_ID, Claim_ID, Action_Detail, Recorded_At, Processor)
values
('L001', 'CLM901', 'Đã nhận hồ sơ hiện trường', '2024-06-15 09:00', 'Admin_01'),
('L002', 'CLM901', 'Chấp nhận bồi thường xe tai nạn', '2024-06-20 14:30', 'Admin_01'),
('L003', 'CLM902', 'Đang thẩm định hồ sơ bệnh án', '2025-10-21 10:00', 'Admin_02'),
('L004', 'CLM904', 'Từ chối do lỗi cố ý của khách hàng', '2026-01-16 16:00', 'Admin_03'),
('L005', 'CLM905', 'Đã thanh toán qua chuyển khoản', '2025-02-15 08:30', 'Accountant_01');

-- Câu 1: tăng phí bảo hiểm cơ bản thêm 15%
update Insurance_Packages
set Base_Premium = Base_Premium * 0.15
where Base_Premium > 500000000;

-- test case
select * from Insurance_Packages;

-- Câu 2: Viết câu lệnh xóa các nhật ký xử lý bồi thường 
delete from Claim_Processing_Log
where Recorded_At < '2025-06-17';

-- test case
select * from Claim_Processing_Log;

-- Phần 2
-- Câu 1: Liệt kê thông tin các hợp đồng
select * from Policies
where Status = 'Active'
and (End_Date >= '2026-01-01' and End_Date <= '2026-12-30');

-- Câu 2: Lấy thông tin khách hàng
select Full_Name, Email from Customers
where Full_Name like '%Hoang%'
and Join_Date > '2024-12-30';

-- Câu 3: Hiển thị
select * from Claims
order by Claim_Amount desc
limit 4
offset 1;

-- Phần 3
-- Câu 1: Sử dụng JOIN để hiển thị
select c.Full_Name, i.Package_Name, p.Start_Date, cl.Claim_Amount
from Customers c
join Policies p on c.Customer_ID = p.Customer_ID
join Insurance_Packages i on i.Package_ID = p.Package_ID
join Claims cl on p.Policy_ID = cl.Policy_ID;

-- Câu 2: Thống kê tổng số tiền bồi thường đã được duyệt
select c.Customer_ID, c.Full_Name, c.Email, cl.Claim_Amount
from Customers c
join Policies p on c.Customer_ID = p.Customer_ID
join Claims cl on p.Policy_ID = cl.Policy_ID
where cl.Status = 'Approved' and cl.Claim_Amount > 50000000;

-- Câu 3: Tìm gói bảo hiểm có số lượng khách hàng đăng ký nhiều nhất
select i.Package_Name, count(c.Customer_ID) 'Tong luot dang ky'
from Insurance_Packages i
join Policies p on i.Package_ID = p.Package_ID
join Customers c on p.Customer_ID = c.Customer_ID
group by i.Package_Name;

-- Phần 4
-- Câu 1: Tạo Composite Index
create index idx_policy_status_date  on Policies (Status, Start_Date);

-- Câu 2: Tạo một View tên vw_customer_summary
create view vw_customer_summary as (
	select c.Full_Name, count(cl.Claim_ID) 'So luong hop dong', count(i.Package_ID) 'Tong phi bao hiem co ban'
    from Customers c
    join Policies p on c.Customer_ID = p.Customer_ID
    join Claims cl on p.Policy_ID = cl.Policy_ID
    join Insurance_Packages i on p.Package_ID = i.Package_ID
    group by c.Full_Name
);

-- test case
select * from vw_customer_summary;

-- Phần 5
-- Câu 1: Viết Trigger trg_after_claim_approved
delimiter //
	create trigger trg_after_claim_approved
	after update on Claims
	for each row
	begin
		update Claims
		set Status = 'Approved'
		where Claim_ID = new.Claim_ID;
    
		insert into Claim_Processing_Log (Claim_ID, Action_Detail)
		values (new.Claim_ID, 'Payment processed to customer');

	end //

delimiter ;

-- Câu 2: Viết Trigger ngăn chặn việc xóa hợp đồng
delimiter //
	create trigger trg_before_policies_active
    before delete on Policies 
    for each row
    begin
		if old.Status = 'Active' then
        signal sqlstate '45000'
        set message_text = 'Hop dong van co hieu luc, ban khong the xoa';
        end if;
    
    end //

delimiter ;

-- test case 
delete from Policies
where Policy_ID = 'POL102';

-- phần 6
-- Câu 1: Viết Procedure sp_check_claim_limit
delimiter //
	create procedure sp_check_claim_limit (
	in p_Claim_ID varchar(6), 
	out p_message varchar(10)
	)
	begin
		
    
    end //

delimiter ;