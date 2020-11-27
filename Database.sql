CREATE SCHEMA `eCommerceWebsiteDb`;
USE `eCommerceWebsiteDb`;


-- TỈNH/ TP
DROP TABLE IF EXISTS `PROVINCE`;
CREATE TABLE IF NOT EXISTS `PROVINCE` (
	`PROVINCE_ID` VARCHAR(2) NOT NULL,
	`PROVINCE_NAME` NVARCHAR(20) NOT NULL,
	`PROVINCE_TYPE` VARCHAR(1) NOT NULL					-- C: thành phố trực thuộc trung ương, P: tỉnh
) ENGINE = InnoDB;
ALTER TABLE `PROVINCE` ADD CONSTRAINT PK_PROVINCE PRIMARY KEY (`PROVINCE_ID`);


-- HUYỆN/ QUẬN
DROP TABLE IF EXISTS `DISTRICT`;
CREATE TABLE IF NOT EXISTS `DISTRICT` (
	`DISTRICT_ID` VARCHAR(3) NOT NULL,
	`DISTRICT_NAME` NVARCHAR(40) NOT NULL,
	`DISTRICT_TYPE` VARCHAR(1) NOT NULL, 				-- C: thành phố trực thuộc tỉnh, D: quận, H: huyện, T: thị xã
	`PROVINCE_ID` VARCHAR(2) NOT NULL
) ENGINE = InnoDB;
ALTER TABLE `DISTRICT` ADD CONSTRAINT `PK_DISTRICT` PRIMARY KEY(`DISTRICT_ID`);
ALTER TABLE `DISTRICT` ADD CONSTRAINT `FK_DISTRICT_PROVINCE` FOREIGN KEY (`PROVINCE_ID`) REFERENCES `PROVINCE`(`PROVINCE_ID`);


-- XÃ/ PHƯỜNG
DROP TABLE IF EXISTS `COMMUNE`;
CREATE TABLE IF NOT EXISTS `COMMUNE` (
	`COMMUNE_ID` VARCHAR(5) NOT NULL,
	`COMMUNE_NAME` NVARCHAR(40) NOT NULL,
	`COMMUNE_TYPE` VARCHAR(1) NOT NULL, 				-- W: Phường, V: xã, T: thị trấn
	`DISTRICT_ID` VARCHAR(3) NOT NULL
) ENGINE = InnoDB;
ALTER TABLE `COMMUNE` ADD CONSTRAINT `PK_COMMUNE` PRIMARY KEY(`COMMUNE_ID`);
ALTER TABLE `COMMUNE` ADD CONSTRAINT `FK_COMMUNE_DISTRICT` FOREIGN KEY (`DISTRICT_ID`) REFERENCES `DISTRICT`(`DISTRICT_ID`);


-- ĐỊA CHỈ
DROP TABLE IF EXISTS `ADDRESS`;
CREATE TABLE IF NOT EXISTS `ADDRESS` (
	`ADDRESS_ID` BIGINT AUTO_INCREMENT,
	`STREET` NVARCHAR(100) NOT NULL,
	`COMMUNE_ID` VARCHAR(5) NOT NULL,
	`DISTRICT_ID` VARCHAR(3) NOT NULL,
	`PROVINCE_ID` VARCHAR(2) NOT NULL,
    
    PRIMARY KEY(`ADDRESS_ID`)
) ENGINE = InnoDB;
ALTER TABLE `ADDRESS` ADD CONSTRAINT `FK_ADDRESS_COMMUNE` FOREIGN KEY (`COMMNUNE_ID`) REFERENCES `COMMUNE`(`COMMUNE_ID`);
ALTER TABLE `ADDRESS` ADD CONSTRAINT `FK_ADDRESS_DISTRICT` FOREIGN KEY (`DISTRICT_ID`) REFERENCES `DISTRICT`(`DISTRICT_ID`);
ALTER TABLE `ADDRESS` ADD CONSTRAINT `FK_ADDRESS_PROVINCE` FOREIGN KEY (`PROVINCE_ID`) REFERENCES `PROVINCE`(`PROVINCE_ID`);


-- THÔNG TIN TÀI KHOẢN
DROP TABLE IF EXISTS `USER`;
CREATE TABLE IF NOT EXISTS `USER` (
	`USER_ID` BIGINT AUTO_INCREMENT NOT NULL,
	`LAST_NAME` NVARCHAR(40) NOT NULL,
	`FIRST_NAME` NVARCHAR(10) NOT NULL,
	`GENDER` NVARCHAR(5) NULL,										-- NAM, NỮ, KHÁC
	`DATE_OF_BIRTH` DATE NULL,										-- NGÀY SINH
    `SSN` VARCHAR(12) NULL,											-- CĂN CƯỚNG CÔNG DÂN
    `IMAGE_PATH` VARCHAR(100) NULL,									-- ĐƯỜNG DẪN ĐẾN ẢNH
	
    `PHONE_NUMBER` VARCHAR(15) NULL,
    `EMAIL` VARCHAR(40) NULL,
    
	`USER_NAME` VARCHAR(16) NOT NULL,
	`PASSWORD` VARCHAR(32) NOT NULL,
    `USER_TYPE` VARCHAR(15) DEFAULT 'CUSTOMMER' NOT NULL,			-- ADMIN, EMPLOYEE, SELLER, DELIVERY, CUSTOMMER
    
	`STATUS` TINYINT(1) DEFAULT '1',								-- TRẠNG THÁI
    
    PRIMARY KEY(`USER_ID`)
) ENGINE = InnoDB;


-- QUAN HỆ NHIỀU NHIỀU USER - ADDRESS
DROP TABLE IF EXISTS `USER_ADDRESS`;
CREATE TABLE IF NOT EXISTS `USER_ADDRESS` (
	`USER_ID` BIGINT NOT NULL,
	`ADDRESS_ID` BIGINT NOT NULL,
	`FULL_NAME` NVARCHAR(50),
	`PHONE_NUMBER` NVARCHAR (15),
	`ADDRESS_NAME` nvarchar(20)											-- tên địa chỉ: nhà, công ty, trường ...
) ENGINE = InnoDB;
ALTER TABLE `USER_ADDRESS` ADD CONSTRAINT `PK_USER_ADDRESS` PRIMARY KEY(`USER_ID`, `ADDRESS_ID`);

-- QUẢN TRỊ VIÊN
-- DROP TABLE IF EXISTS `ADMIN`;
-- CREATE TABLE IF NOT EXISTS `ADMIN` (
-- 	`USER_ID` BIGINT NOT NULL
-- ) ENGINE = InnoDB;


-- NHÂN VIÊN
DROP TABLE IF EXISTS `EMPLOYEE`;
CREATE TABLE IF NOT EXISTS `EMPLOYEE` (
	`USER_ID` BIGINT NOT NULL,
	`START_DATE` DATE NULL,		-- NGÀY BẮT ĐẦU LÀM VIỆC
    `SALARY` DECIMAL(19, 2) NULL
) ENGINE = InnoDB;


-- NGÀNH HÀNG
DROP TABLE IF EXISTS `SELLER_CATEGORY`;
CREATE TABLE IF NOT EXISTS `SELLER_CATEGORY` (
	`SELLER_CATEGORY_ID` BIGINT AUTO_INCREMENT,
	`CATEGORY_NAME` NVARCHAR(50)
) ENGINE = InnoDB;


-- NGƯỜI BÁN HÀNG
DROP TABLE IF EXISTS `SELLER`;
CREATE TABLE IF NOT EXISTS `SELLER` (
	`USER_ID` BIGINT NOT NULL,
	`STORE_NAME` NVARCHAR(50),					-- TÊN SHOP
	`STORE_LINK` VARCHAR(50),					
	`BUSINESS_LICENSE_ID` VARCHAR(50),			-- GIẤY PHÉP KINH DOAN
	`SELLER_CATEGORY_ID` BIGINT,
	`BANK_ACCOUNT_ID` BIGINT					-- SỐ TÀI KHOẢN
) ENGINE = InnoDB;


--
DROP TABLE IF EXISTS `CUSTOMER`;
CREATE TABLE IF NOT EXISTS `CUSTOMER` (
	`USER_ID` BIGINT NOT NULL,
    `REGISTER_DATE` DATE NULL
) ENGINE = InnoDB;


-- CHUYÊN MỤC HÀNG HÓA
DROP TABLE IF EXISTS `PRODUCT_CATEGORY`;
CREATE TABLE IF NOT EXISTS `PRODUCT_CATEGORY` (
	`PRODUCT_CATEGORY_ID` BIGINT AUTO_INCREMENT,
	`PRODUCT_CATEGORY_NAME` NVARCHAR(50) NOT NULL,
    
    PRIMARY KEY(PRODUCT_CATEGORY_ID)
) ENGINE = InnoDB;

-- 
DROP TABLE IF EXISTS `PRODUCT_SUB_CATEGORY`;
CREATE TABLE IF NOT EXISTS `PRODUCT_SUB_CATEGORY` (
	`PRODUCT_SUB_CATEGORY_ID` BIGINT AUTO_INCREMENT,
	`PRODUCT_CATEGORY_ID` BIGINT NOT NULL,
	`PRODUCT_SUB_CATEGORY_NAME` NVARCHAR(50),
    
    PRIMARY KEY(`PRODUCT_SUB_CATEGORY_ID`)
) ENGINE = InnoDB;


-- THƯƠNG HIỆU
DROP TABLE IF EXISTS `BRAND`;
CREATE TABLE IF NOT EXISTS `BRAND` (
	`BRAND_ID` BIGINT AUTO_INCREMENT,
	`BRAND_NAME` NVARCHAR(50) NOT NULL,
	`BRAND_ORIGIN` NVARCHAR(30) NOT NULL,				-- XUẤT XỨ THƯƠNG HIỆU
    
    PRIMARY KEY(`BRAND_ID`)
) ENGINE = InnoDB;

DROP TABLE IF EXISTS `PRODUCT`;
CREATE TABLE IF NOT EXISTS `PRODUCT` (
	`PRODUCT_ID` BIGINT AUTO_INCREMENT,	
	`BRAND_ID` BIGINT NOT NULL,							-- THƯƠNG HIỆU
	`SELLER_ID` BIGINT NOT NULL,						-- SELLER.USER_ID: ID NGƯỜI BÁN HÀNG
	`PRODUCT_NAME` NVARCHAR(100) NOT NULL,
	`PRODUCT_RATE` FLOAT DEFAULT 5.0 NOT NULL,
	`PRODUCT_ORIGIN` NVARCHAR(30) NOT NULL, 			-- XUẤT XỨ SẢN PHẨM
	`PRODUCT_DESC` LONGTEXT NOT NULL,					-- MÔ TẢ SẢN PHẨM
	`QUANTITY` INT NOT NULL,							-- SỐ LƯỢNG SẢN PHẨM 
	`PRICE_ORIGIN` DECIMAL(19, 2) NOT NULL,				-- GIÁ MẶC ĐỊNH
	`PRICE_ORDER` DECIMAL(19, 2) NOT NULL,				-- GIÁ KHI MUA
    
    PRIMARY KEY(`PRODUCT_ID`)
) ENGINE = InnoDB;


-- LOẠI SẢN PHẨM (MÀU XANH, ĐỎ) OR KÍCH THƯỚC
-- DROP TABLE IF EXISTS `PRODUCT_TYPE`;
-- CREATE TABLE IF NOT EXISTS `PRODUCT_TYPE` (
-- 	`PRODUCT_TYPE_ID` BIGINT AUTO_INCREMENT,
-- 	`PRODUCT_TYPE_NAME` NVARCHAR(50),
-- 	`PRODUCT_ID` BIGINT NOT NULL,
--     
--     PRIMARY KEY(`PRODUCT_TYPE_ID`)
-- ) ENGINE = InnoDB;


-- ĐÁNH GIÁ VÀ NHẬN XÉT
DROP TABLE IF EXISTS `RATE_COMMENT`;
CREATE TABLE IF NOT EXISTS `RATE_COMMENT` (
	`RATE_COMMENT_ID` BIGINT AUTO_INCREMENT,
	`RATE_START` INT,
	`COMMENT` LONGTEXT COLLATE UTF8MB4_UNICODE_C,
	`NO_OF_LIKE` INT,
	`NO_OF_DISLIKE` INT,
	`USER_ID` BIGINT NOT NULL,
	`PRODUCT_ID` BIGINT NOT NULL,
    
    PRIMARY KEY(`RATE_COMMENT_ID`)
) ENGINE = InnoDB;


-- TRẢ LỜI COMMENT
DROP TABLE IF EXISTS `REPLY_COMMENT`;
CREATE TABLE IF NOT EXISTS `REPLY_COMMENT` (
	`SUB_COMMENT_ID` BIGINT AUTO_INCREMENT,
	`RATE_COMMENT_ID` BIGINT NOT NULL,
	`COMMENT` LONGTEXT COLLATE UTF8MB4_UNICODE_C,
	`NO_OF_LIKE` INT,
	`NO_OF_DISLIKE` INT,
	`NO_OF_DISLIKE` BIGINT NOT NULL,
    
    PRIMARY KEY(`SUB_COMMENT_ID`)
) ENGINE = InnoDB;


-- MÃ GIẢM GIÁ
DROP TABLE IF EXISTS `DISCOUNT`;
CREATE TABLE IF NOT EXISTS `DISCOUNT` (
	`DISCOUNT_ID` BIGINT AUTO_INCREMENT,
	`DISCOUNT_CODE` VARCHAR(10) NOT NULL, 
	`DISCOUNT_VALUE` DECIMAL(19, 2) NOT NULL,
	`DISCOUNT_MAX_VALUE` DECIMAL(19, 2) NOT NULL,
    
    PRIMARY KEY(`DISCOUNT_ID`)
) ENGINE = InnoDB;


-- BIIL
DROP TABLE IF EXISTS `BILL`;
CREATE TABLE IF NOT EXISTS `BILL` (
	`BILL_ID` BIGINT AUTO_INCREMENT,
	`ADDRESS_ID` BIGINT NOT NULL,
	`DISCOUNT_ID` BIGINT NOT NULL
) ENGINE = InnoDB;


-- CHÍ TIẾT ĐƠN
DROP TABLE IF EXISTS `BILL_DETAIL`;
CREATE TABLE IF NOT EXISTS `BILL_DETAIL` (
	`BILL_DETAIL_ID` BIGINT AUTO_INCREMENT,
	`BILL_ID` BIGINT NOT NULL,
	`PRODUCT_ID` BIGINT NOT NULL
) ENGINE = InnoDB;


-- THANH TOÁN
DROP TABLE IF EXISTS `BILL_PAYMENT`;
CREATE TABLE IF NOT EXISTS `BILL_PAYMENT` (
	`BILL_PAYMENT_ID` BIGINT AUTO_INCREMENT,
	`BILL_ID` BIGINT NOT NULL
) ENGINE = InnoDB;







