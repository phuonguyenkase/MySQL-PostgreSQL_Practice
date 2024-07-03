1.	Chuyển đổi kiểu dữ liệu phù hợp cho các trường (sử dụng câu lệnh ALTER):
ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN ordernumber TYPE integer USING (TRIM(ordernumber)::integer),
ALTER COLUMN quantityordered TYPE integer USING (TRIM(quantityordered)::integer),
ALTER COLUMN priceeach TYPE numeric USING(TRIM(priceeach)::numeric),
ALTER COLUMN orderlinenumber TYPE integer USING (TRIM(orderlinenumber)::integer),
ALTER COLUMN sales TYPE numeric USING (TRIM(sales)::numeric),
ALTER COLUMN orderdate TYPE TIMESTAMP USING TO_TIMESTAMP(orderdate, 'MM-DD-YYYY HH24:MI:SS');

2.	Check NULL/BLANK (‘’)  ở các trường: ORDERNUMBER, QUANTITYORDERED, PRICEEACH, ORDERLINENUMBER, SALES, ORDERDATE.

SELECT ordernumber, quantityordered, orderlinenumber, sales, orderdate
FROM sales_dataset_rfm_prj
WHERE ordernumber IS NULL OR TRIM(ordernumber::text) = ' '
OR quantityordered IS NULL OR TRIM(quantityordered::text) = ' '
OR orderlinenumber IS NULL OR TRIM(orderlinenumber::text) = ' '
OR sales IS NULL OR TRIM(sales::text) = ' '
OR orderdate IS NULL OR TRIM(orderdate::text) = ' ';

3.	Thêm cột CONTACTLASTNAME, CONTACTFIRSTNAME được tách ra từ CONTACTFULLNAME. Chuẩn hóa CONTACTLASTNAME, CONTACTFIRSTNAME theo định dạng chữ cái đầu tiên viết hoa, chữ cái tiếp theo viết thường.

ALTER TABLE sales_dataset_rfm_prj
ADD COLUMN First_name VARCHAR(50),
ADD COLUMN Last_name VARCHAR(50);

UPDATE sales_dataset_rfm_prj
SET First_name = INITCAP(LEFT(contactfullname, POSITION('-' IN contactfullname) - 1)),
Last_name = INITCAP(SUBSTRING(contactfullname FROM POSITION('-' IN contactfullname) + 1));

4.	Thêm cột QTR_ID, MONTH_ID, YEAR_ID lần lượt là Qúy, tháng, năm được lấy ra từ ORDERDATE

ALTER TABLE sales_dataset_rfm_prj
ADD COLUMN QTR_ID INTEGER,
ADD COLUMN MONTH_ID INTEGER,
ADD COLUMN YEAR_ID INTEGER;

UPDATE sales_dataset_rfm_prj
SET QTR_ID = EXTRACT(QUARTER FROM orderdate),
	MONTH_ID = EXTRACT(MONTH FROM orderdate),
	YEAR_ID = EXTRACT(YEAR FROM orderdate);
5.	Hãy tìm outlier (nếu có) cho cột QUANTITYORDERED và hãy chọn cách xử lý cho bản ghi đó (2 cách) ( Không chạy câu lệnh trước khi bài được review)

ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN Outliers TYPE boolean USING (Outliers::boolean);

WITH quartiles AS (
SELECT
PERCENTILE_CONT(.25) WITHIN GROUP (ORDER BY quantityordered) AS Q1,
PERCENTILE_CONT(.75) WITHIN GROUP (ORDER BY quantityordered) AS Q3
FROM sales_dataset_rfm_prj),
Min_Max AS (
SELECT 
Q1 - 1.5*(Q3 - Q1) AS MINIMUM,
Q3 + 1.5*(Q3 - Q1) AS MAXIMUM
FROM quartiles)

UPDATE sales_dataset_rfm_prj sdp
SET Outliers = 
CASE WHEN sdp.quantityordered < mm.minimum OR sdp.quantityordered > mm.maximum
THEN TRUE
ELSE FALSE END
FROM min_max mm; #Tạo 1 cột true false để xóa những thằng true là outliers

DELETE FROM sales_dataset_rfm_prj WHERE Outliers = true;

6.	Sau khi làm sạch dữ liệu, hãy lưu vào bảng mới  tên là SALES_DATASET_RFM_PRJ_CLEAN

CREATE TABLE sales_dataset_rfm_prj_clean AS
SELECT *
FROM sales_dataset_rfm_prj;
