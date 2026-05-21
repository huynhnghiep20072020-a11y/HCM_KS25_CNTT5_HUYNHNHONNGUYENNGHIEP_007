CREATE DATABASE Hakathonck;
USE Hakathonck;

CREATE TABLE PATIENTS(
  patient_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  full_name VARCHAR(100) NOT NULL,
  phone_number CHAR(15) NOT NULL UNIQUE,
  gender VARCHAR(15) NOT NULL,
  date_of_birth DATE NOT NULL
);

CREATE TABLE DOCTORS(
  doctor_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  full_name VARCHAR(100) NOT NULL,
  specialty VARCHAR(100) NOT NULL,
  phone_number CHAR(15) NOT NULL,
  rating DECIMAL(2,1)
);

CREATE TABLE APPOINTMENTS(
  appointment_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  doctor_id INT NOT NULL,
  patient_id INT NOT NULL,
  appointment_time DATETIME NOT NULL,
  fee DECIMAL(10,2) DEFAULT 0,
  status VARCHAR(15),
  FOREIGN KEY (doctor_id) REFERENCES DOCTORS(doctor_id) ,
  FOREIGN KEY (patient_id) REFERENCES PATIENTS(patient_id)
);

CREATE TABLE MEDICAL_RECORDS(
  record_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  appointment_id INT NOT NULL,
  symptoms VARCHAR(100) NOT NULL,
  diagnosis VARCHAR(100) NOT NULL,
  prescription VARCHAR(200),
  record_date DATETIME NOT NULL,
  FOREIGN KEY (appointment_id) REFERENCES APPOINTMENTS(appointment_id)
);

CREATE TABLE VISIT_LOG(
  log_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  record_id INT NOT NULL,
  doctor_id INT NOT NULL,
  log_time DATETIME NOT NULL,
  note VARCHAR(255),
  FOREIGN KEY (doctor_id) REFERENCES DOCTORS(doctor_id) ON DELETE CASCADE,
  FOREIGN KEY (record_id) REFERENCES MEDICAL_RECORDS(record_id)
);

INSERT INTO PATIENTS(patient_id,full_name,phone_number,gender,date_of_birth) VALUES
(1,'Nguyen Thi Lan','091234567','Female','1999-03-12'),
(2,'Tran Vna MiNH','0902345678','Male','1996-11-25'),
(3,'Le Hoai Phuong','091234567','Female','2001-07-08'),
(4,'Pham Duc Anh','091234567','Male','1998-01-19'),
(5,'Hoang Ngoc Mai','091234567','Female','2000-09-30');

INSERT INTO DOCTORS (doctor_id,full_name,specialty,phone_number,rating) VALUES
(1,'BS. Nguyen Van Hai','Noi','0931112223',4.8),
(2,'BS. Tran Thu Ha','Nhi','0932223334',5.0),
(3,'BS. Le Quoc Tuan','Ngoai','0933334445',4.6),
(4,'BS. Pham Minh Chau','Nda lieu','0934445556',4.9),
(5,'BS. Hoang Gia Bao','Tim mach','0935556667',4.8);

INSERT INTO APPOINTMENTS(appointment_id,doctor_id,patient_id,appointment_time,fee,status) VALUES
(7001,1,1,'2024-05-20 08:00:00',200000,'Booked'),
(7002,2,2,'2024-05-20 09:30:00',250000,'Completed'),
(7003,3,3,'2024-05-21 10:45:00',300000,'Booked'),
(7004,4,4,'2024-05-21 07:00:00',350000,'Completed'),
(7005,5,5,'2024-05-21 08:45:00',220000,'Cancelled');

INSERT INTO MEDICAL_RECORDS(record_id,appointment_id,symptoms,diagnosis,prescription,record_date) VALUES
(8001,7002,'Sốt cao, ho','Viêm họng','paracetamol+siro ho','2024-05-10 10:00:00'),
(8002,7004,'đau ngực nhẹ','Theo dõi tim mạch','Vitamin+tái khám','2024-05-21 08:00:00'),
(8003,7001,'Đau bụng','Rối loạn tiêu hóa','Men tiêu hóa','2024-05-20 09:00:00'),
(8004,7003,'Đau vai gáy','Căng cơ','Giảm đau + nghỉ ngơi','2024-05-20 11:00:00'),
(8005,7005,'Ngứa da','Dị ứng','Thuốc bôi ngoài da','2024-05-21 09:00:00');

INSERT INTO VISIT_LOG(log_id,record_id,doctor_id,log_time,note) VALUES
(1,8003,1,'2024-05-20 09:05:00','Đã khám lần đầu'),
(2,8001,2,'2024-05-20 10:05:00','Hoàn tất khám'),
(3,8004,3,'2024-05-20 11:10:00','Tư vấn trị liệu'),
(4,8002,4,'2024-05-21 08:10:00','Hướng dẫn tái khám'),
(5,8005,5,'2024-05-21 09:05:00','Bệnh nhân hủy hẹn');

-- câu 2 
-- viết câu lệnh tăng 10% phí khám cho accs phiếu hẹn thỏa mãn dồng thời : có trang thái Completed và thuộc bênh nhân có năm sinh <2000

UPDATE APPOINTMENTS a
JOIN PATIENTS p ON a.patient_id = p.patient_id
SET a.fee = a.fee * 1.10
WHERE a.status = 'Completed'
  AND YEAR(p.date_of_birth) < 2000;

-- viết câu lệnh xóa các bản ghi trong visit_log thỏa mãn: có log_time trước ngày 20/05/2024 

DELETE FROM VISIT_LOG
WHERE log_time < '2024-05-20';


-- phần 3 
-- câu 1 liệt kê các thông tin bác sĩ gồm full_name ,specialty và rating của những bác sĩ có ratinng lớn hơn 4.7 hoặc chuyên khoa "Nhi"

SELECT full_name, specialty, rating
FROM DOCTORS
WHERE rating > 4.7
   OR specialty = 'Nhi';

-- câu 2 liệt kê các thôngt tin bệnh nhân gồm full_name vàd phone_number của những bệnh nhân có ngày sinh trong khoảng từ 1998-01-01 đến 2001-12-31 và số điện thoại bắt đầu bnagwf "090"

SELECT full_name, phone_number
FROM PATIENTS
WHERE date_of_birth BETWEEN '1998-01-01' AND '2001-12-31'
  AND phone_number LIKE '090%';

-- câu 3 liệt các phiếu hẹn gồm appointment_id,appointment_time và fee ,trong đó danh sách đucojw sắp xếp theo fee giảm dần và chủ hiện thị 2 phiếu ở trang thứ 2  

SELECT appointment_id, appointment_time, fee
FROM APPOINTMENTS
ORDER BY fee DESC
LIMIT 2 OFFSET 2;  -- lỗi trang nên cho mỗi trang 2 bản 

-- phần 4 
-- câu 1 liệt kê các thông tin khám gồm họ tên bệnh nhân , họ tên bác sĩ chuyên khoa ,phí khám và thời điểm hẹnh khám , với dữ liệu đucojw lấy từ accs bảng quan hệ thống 

SELECT p.full_name AS patient_name,
       d.full_name AS doctor_name,
       a.fee,
       a.appointment_time
FROM APPOINTMENTS a
JOIN PATIENTS p ON a.patient_id = p.patient_id
JOIN DOCTORS d ON a.doctor_id = d.doctor_id;

-- câu 2 liệt kê thông tin bác sĩ gồm họ tên và tổng phí khám mà bác sĩ đó thực hiện (chỉ tính phiếu Comleted) chỉ hiện thị những bác sĩ có tổng phí lớn hơn 500000 

SELECT d.full_name,
       SUM(a.fee) AS total_fee
FROM DOCTORS d
JOIN APPOINTMENTS a ON d.doctor_id = a.doctor_id
WHERE a.status = 'Completed'
GROUP BY d.doctor_id, d.full_name
HAVING SUM(a.fee) > 500000;

-- câu 3 liệt kê các thông tin bác sĩ gồm doctr_id ,ful_name và rating của những bác sĩ có điểm đánh gía cao nhất 

SELECT doctor_id,
       full_name,
       rating
FROM DOCTORS
WHERE rating = (SELECT MAX(rating) FROM DOCTORS);

-- phần 5 
-- câu 1 tạo chỉ mục trên bảng appointments dựa trên hai thông tin là trang thái hẹn tái khám và phí khám phucn vụ việc tối ưu truy vấn 

CREATE INDEX idx_appointments_status_fee
ON APPOINTMENTS (status, fee);

-- câu 2 tạo một khung nhìn dữ liệu hiện thị họ tên bác sĩ , tổng số phiếu hẹn mà bác sĩ đã nhận và tổng danh thu phí khám bác sĩ đó mang lại, trong đó các phiếu bị hủy 

CREATE VIEW vw_doctor_revenue AS
SELECT d.doctor_id,
       d.full_name,
       SUM(CASE WHEN a.status <> 'Cancelled' THEN 1 ELSE 0 END) AS total_appointments,
       SUM(CASE WHEN a.status <> 'Cancelled' THEN a.fee ELSE 0 END) AS total_revenue
FROM DOCTORS d
LEFT JOIN APPOINTMENTS a ON d.doctor_id = a.doctor_id
GROUP BY d.doctor_id, d.full_name;

-- phần 6 
-- câu 1 viết một trigger sao cho khi trang thái của một phiếu hẹn trong bảng appointment đuọcw cập nhật sang giá trị Completed thì hệ thống tự động thêm nột bản ghi mới vào bảng visit_log các thông tin sau 
-- appointment_id/record_id hồ ssow tương ứng của phiếu vừa cập nhật 
-- doctor_id bác sĩ của phiếu hẹn 
-- note visit completed
-- log_time thời gian hiện tại của ghệ thống 

DELIMITER $$
CREATE TRIGGER trg_appointments_status_completed
AFTER UPDATE ON APPOINTMENTS
FOR EACH ROW
BEGIN
  IF NEW.status = 'Completed' AND OLD.status <> 'Completed' THEN
    INSERT INTO VISIT_LOG(record_id, doctor_id, log_time, note)
    SELECT mr.record_id, NEW.doctor_id, NOW(), 'visit completed'
    FROM MEDICAL_RECORDS mr
    WHERE mr.appointment_id = NEW.appointment_id
    LIMIT 1;
  END IF;
END$$
DELIMITER ;

-- câu 2 viết một trigger sao cho khi hệ thống thêm mới một bảng ghi vào bảng appointment có trang thái Completed thì hệ thống tự động tăng điểm đáng giá của bác sĩ tương ứng trong bảng doctor thêm 0.1, nhưng đảm bảo điểm đánh giá ko vược quá 5.0 

DELIMITER $$
CREATE TRIGGER trg_appointments_after_insert_completed
AFTER INSERT ON APPOINTMENTS
FOR EACH ROW
BEGIN
  IF NEW.status = 'Completed' THEN
    UPDATE DOCTORS
    SET rating = LEAST(5.0, COALESCE(rating, 0) + 0.1)
    WHERE doctor_id = NEW.doctor_id;
  END IF;
END$$
DELIMITER ;

-- phần 7
-- câu 1 viết một stored procedure nhận vào mã bác sĩ và trả về một thông báo kết quả trrong đó nếu 
-- tổng phí khám Completed của bác sĩ >1,000,000 thì trả về High revenue 
-- nếu bằng nhau thì trả về Taget met 
-- nếu nhỏ hơn thì trả về Normal

DROP PROCEDURE IF EXISTS sp_doctor_completed_revenue_status;
DELIMITER $$
CREATE PROCEDURE sp_doctor_completed_revenue_status(
  IN p_doctor_id INT,
  OUT p_result VARCHAR(50)
)
BEGIN
  DECLARE v_total_fee DECIMAL(15,2) DEFAULT 0;

  SELECT COALESCE(SUM(fee), 0)
  INTO v_total_fee
  FROM APPOINTMENTS
  WHERE doctor_id = p_doctor_id
    AND status = 'Completed';

  IF v_total_fee > 1000000 THEN
    SET p_result = 'High revenue';
  ELSEIF v_total_fee = 1000000 THEN
    SET p_result = 'Target met';
  ELSE
    SET p_result = 'Normal';
  END IF;
END$$
DELIMITER ;

-- câu 2 viết một stored procedure để thực hiện việc đỗi bác sĩ cho một phiếu hẹn khám gồm các bước 
-- bước 1 bắt đầu quá trình xử lý 
-- bước 2 cập nhật mã bác sĩ mới cho phiếu hẹn trong bảng appointments 
-- bước 3 ghi một bản ghi mới vào bảng visit_log với ghi chú doctor reassigned 
-- bước 4 Nếu toàn bộ quá trình thành công thì hoàn tất , nếu xảy ra lỗi ở bất kỳ bước nào thì hủy toàn bộ thao tác

DROP PROCEDURE IF EXISTS sp_reassign_doctor_for_appointment;
DELIMITER $$
CREATE PROCEDURE sp_reassign_doctor_for_appointment(
  IN p_appointment_id INT,
  IN p_new_doctor_id INT,
  OUT p_result VARCHAR(255)
)
BEGIN
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    SET p_result = 'Failed: transaction rolled back';
  END;

  START TRANSACTION;

  UPDATE APPOINTMENTS
  SET doctor_id = p_new_doctor_id
  WHERE appointment_id = p_appointment_id;

  IF ROW_COUNT() = 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Appointment not found';
  END IF;

  INSERT INTO VISIT_LOG(record_id, doctor_id, log_time, note)
  SELECT mr.record_id, p_new_doctor_id, NOW(), 'doctor reassigned'
  FROM MEDICAL_RECORDS mr
  WHERE mr.appointment_id = p_appointment_id
  LIMIT 1;

  IF ROW_COUNT() = 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Related medical record not found';
  END IF;

  COMMIT;
  SET p_result = 'Success: doctor reassigned';
END$$
DELIMITER ;
