-- MySQL dump 10.13  Distrib 5.1.50, for redhat-linux-gnu (i686)
--
-- Host: localhost    Database: p3r83364_knack
-- ------------------------------------------------------
-- Server version	5.1.50

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `administrators`
--

DROP TABLE IF EXISTS `administrators`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `administrators` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `UserName` varchar(30) NOT NULL DEFAULT '',
  `Password` varchar(30) NOT NULL DEFAULT '',
  `FirstName` varchar(30) NOT NULL DEFAULT '',
  `LastName` varchar(30) NOT NULL DEFAULT '',
  `Email` varchar(30) NOT NULL DEFAULT '',
  `Phone` varchar(50) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `IsDeleted` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `brands`
--

DROP TABLE IF EXISTS `brands`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `brands` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) NOT NULL DEFAULT '',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `IsDeleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=64 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `categories` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) NOT NULL DEFAULT '',
  `Description` varchar(300) DEFAULT NULL,
  `Parent_ID` int(11) unsigned DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `IsDeleted` tinyint(1) NOT NULL DEFAULT '0',
  `Image` mediumblob,
  `ImageGUID` char(39) DEFAULT NULL,
  `PerShipment` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ImageGUID` (`ImageGUID`)
) ENGINE=InnoDB AUTO_INCREMENT=98 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `closed_payment_statuses`
--

DROP TABLE IF EXISTS `closed_payment_statuses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `closed_payment_statuses` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `IsDeleted` tinyint(4) NOT NULL DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `Name` varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `closed_payments`
--

DROP TABLE IF EXISTS `closed_payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `closed_payments` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `IsDeleted` tinyint(4) NOT NULL DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `order_id` int(11) unsigned NOT NULL,
  `typepayment_id` int(11) unsigned NOT NULL,
  `amount` decimal(11,2) NOT NULL DEFAULT '0.00',
  `status_id` int(11) unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `orders_closed_payments_fk` (`order_id`),
  KEY `typepayments_closed_payments_fk` (`typepayment_id`),
  KEY `statuses_closed_payments_fk` (`status_id`),
  CONSTRAINT `orders_closed_payments_fk` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`),
  CONSTRAINT `statuses_closed_payments_fk` FOREIGN KEY (`status_id`) REFERENCES `closed_payment_statuses` (`id`),
  CONSTRAINT `typepayments_closed_payments_fk` FOREIGN KEY (`typepayment_id`) REFERENCES `typepayments` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `colors`
--

DROP TABLE IF EXISTS `colors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colors` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) NOT NULL DEFAULT '',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `IsDeleted` tinyint(1) NOT NULL DEFAULT '0',
  `RGB` varchar(6) DEFAULT 'ffffff',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `commissions`
--

DROP TABLE IF EXISTS `commissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `commissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Name` char(30) NOT NULL,
  `Percent` float(9,3) NOT NULL,
  `IsDeleted` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `contributes`
--

DROP TABLE IF EXISTS `contributes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `contributes` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `Contribute` decimal(11,2) NOT NULL,
  `FirstName` varchar(50) DEFAULT 'Unknown',
  `LastName` varchar(50) DEFAULT 'Unknown',
  `Notes` varchar(300) DEFAULT '',
  `Registrant2Products_ID` int(11) unsigned NOT NULL,
  `IsDeleted` bit(1) NOT NULL DEFAULT b'0',
  PRIMARY KEY (`id`),
  KEY `r2p_contributes_fk` (`Registrant2Products_ID`),
  CONSTRAINT `r2p_contributes_fk` FOREIGN KEY (`Registrant2Products_ID`) REFERENCES `registrant2products` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `email_servers`
--

DROP TABLE IF EXISTS `email_servers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `email_servers` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `address` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `port` int(11) DEFAULT NULL,
  `tls` tinyint(1) DEFAULT NULL,
  `user_name` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `password` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `domain` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `from` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `knack_payments`
--

DROP TABLE IF EXISTS `knack_payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `knack_payments` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `Order2Product_ID` int(11) unsigned DEFAULT NULL,
  `Order2Registrant2Product_ID` int(11) unsigned DEFAULT NULL,
  `Partner_ID` int(11) unsigned DEFAULT NULL,
  `Amount` decimal(11,2) DEFAULT NULL,
  `IsDeleted` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `DateTime` datetime DEFAULT NULL,
  `Withdrawal_ID` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `o2p_knack_payment_fk` (`Order2Product_ID`),
  KEY `partner_knack_payment_fk` (`Partner_ID`),
  KEY `o2r2p_knack_payments_fk` (`Order2Registrant2Product_ID`),
  KEY `withdrawal_knack_payments_fk` (`Withdrawal_ID`),
  CONSTRAINT `o2p_knack_payment_fk` FOREIGN KEY (`Order2Product_ID`) REFERENCES `orders2products` (`id`),
  CONSTRAINT `o2r2p_knack_payments_fk` FOREIGN KEY (`Order2Registrant2Product_ID`) REFERENCES `orders2registrant2products` (`id`),
  CONSTRAINT `partner_knack_payment_fk` FOREIGN KEY (`Partner_ID`) REFERENCES `partners` (`id`),
  CONSTRAINT `withdrawal_knack_payments_fk` FOREIGN KEY (`Withdrawal_ID`) REFERENCES `withdrawals` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=77 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `line_statuses`
--

DROP TABLE IF EXISTS `line_statuses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `line_statuses` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `IsDeleted` tinyint(4) NOT NULL DEFAULT '0',
  `name` varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  `alias` varchar(10) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `myproducts`
--

DROP TABLE IF EXISTS `myproducts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `myproducts` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) NOT NULL DEFAULT '',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `IsDeleted` tinyint(1) NOT NULL DEFAULT '0',
  `Image` mediumblob,
  `StoreName` varchar(50) NOT NULL DEFAULT '',
  `Description` varchar(300) DEFAULT NULL,
  `Price` decimal(11,2) NOT NULL,
  `StoreUrl` varchar(50) DEFAULT NULL,
  `Category_ID` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `categories_myproducts_fk` (`Category_ID`),
  CONSTRAINT `categories_myproducts_fk` FOREIGN KEY (`Category_ID`) REFERENCES `categories` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `order2payments`
--

DROP TABLE IF EXISTS `order2payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `order2payments` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `Order_ID` int(11) unsigned NOT NULL,
  `Payment_ID` int(11) unsigned NOT NULL,
  `IsDeleted` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `orders_order2payments_fk` (`Order_ID`),
  KEY `payment_order2payments_fk` (`Payment_ID`),
  CONSTRAINT `orders_order2payments_fk` FOREIGN KEY (`Order_ID`) REFERENCES `orders` (`id`),
  CONSTRAINT `payment_order2payments_fk` FOREIGN KEY (`Payment_ID`) REFERENCES `payments` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `order_lines`
--

DROP TABLE IF EXISTS `order_lines`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `order_lines` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `Store_ID` int(11) unsigned NOT NULL,
  `Order_ID` int(11) unsigned NOT NULL,
  `Product_ID` int(11) unsigned DEFAULT NULL,
  `MyProduct_ID` int(11) unsigned DEFAULT NULL,
  `Value` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `stores_order_lines_fk` (`Store_ID`),
  KEY `orders_order_lines_fk` (`Order_ID`),
  KEY `products_order_lines_fk` (`Product_ID`),
  KEY `order_lines_fk` (`MyProduct_ID`),
  CONSTRAINT `orders_order_lines_fk` FOREIGN KEY (`Order_ID`) REFERENCES `orders` (`id`),
  CONSTRAINT `order_lines_fk` FOREIGN KEY (`MyProduct_ID`) REFERENCES `myproducts` (`id`),
  CONSTRAINT `products_order_lines_fk` FOREIGN KEY (`Product_ID`) REFERENCES `products` (`id`),
  CONSTRAINT `stores_order_lines_fk` FOREIGN KEY (`Store_ID`) REFERENCES `stores` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `orders` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `Registrant_ID` int(11) unsigned DEFAULT NULL,
  `OrdersStatus_ID` int(11) unsigned NOT NULL,
  `DateTime` datetime NOT NULL,
  `Amount` decimal(11,2) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `IsDeleted` tinyint(1) NOT NULL DEFAULT '0',
  `BillingFirstName` varchar(50) DEFAULT '',
  `BillingLastName` varchar(50) DEFAULT '',
  `BillingAddress` varchar(100) DEFAULT '',
  `BillingCity` varchar(50) DEFAULT '',
  `BillingState` varchar(50) DEFAULT NULL,
  `BillingZip` varchar(20) DEFAULT '',
  `BillingEmail` varchar(50) DEFAULT '',
  `BillingPhone` varchar(50) DEFAULT NULL,
  `ShippingFirstName` varchar(50) DEFAULT '',
  `ShippingLastName` varchar(50) DEFAULT '',
  `ShippingAddress` varchar(100) DEFAULT '',
  `ShippingCity` varchar(50) DEFAULT '',
  `ShippingState` varchar(50) DEFAULT NULL,
  `ShippingZip` varchar(20) DEFAULT '',
  `ShippingEmail` varchar(50) DEFAULT '',
  `ShippingPhone` varchar(50) DEFAULT NULL,
  `ShippingMethod_ID` int(11) unsigned DEFAULT NULL,
  `BillingState_ID` int(11) unsigned DEFAULT NULL,
  `ShippingState_ID` int(11) unsigned DEFAULT NULL,
  `TypePayment_ID` int(11) unsigned NOT NULL DEFAULT '1',
  `PaymentMethod_ID` int(11) unsigned DEFAULT NULL,
  `PayPalEmail` varchar(50) DEFAULT NULL,
  `TakeMoneyAmount` decimal(11,2) DEFAULT NULL,
  `ShipmentTracking` varchar(20) DEFAULT NULL,
  `DeliveryDate` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `registrant_orders_fk` (`Registrant_ID`),
  KEY `orderstatuses_orders_fk` (`OrdersStatus_ID`),
  KEY `shippingmethods_orders_fk` (`ShippingMethod_ID`),
  KEY `state_bilstate_fk` (`BillingState_ID`),
  KEY `state_shipstate_fk` (`ShippingState_ID`),
  KEY `TypePayment_ID` (`TypePayment_ID`),
  CONSTRAINT `orderstatuses_orders_fk` FOREIGN KEY (`OrdersStatus_ID`) REFERENCES `orders_statuses` (`id`),
  CONSTRAINT `registrant_orders_fk` FOREIGN KEY (`Registrant_ID`) REFERENCES `registrants` (`id`),
  CONSTRAINT `shippingmethods_orders_fk` FOREIGN KEY (`ShippingMethod_ID`) REFERENCES `shippingmethods` (`id`),
  CONSTRAINT `state_bilstate_fk` FOREIGN KEY (`BillingState_ID`) REFERENCES `states` (`id`),
  CONSTRAINT `state_shipstate_fk` FOREIGN KEY (`ShippingState_ID`) REFERENCES `states` (`id`),
  CONSTRAINT `typepayment_orders_fk` FOREIGN KEY (`TypePayment_ID`) REFERENCES `type_payments` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=562 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `orders2products`
--

DROP TABLE IF EXISTS `orders2products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `orders2products` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `Order_ID` int(11) unsigned NOT NULL,
  `Product_ID` int(11) unsigned NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `IsDeleted` tinyint(1) NOT NULL DEFAULT '0',
  `Color_ID` int(11) unsigned DEFAULT NULL,
  `Quantity` int(11) NOT NULL,
  `Tax` decimal(11,2) NOT NULL DEFAULT '0.00',
  `Shipment` decimal(11,2) NOT NULL DEFAULT '0.00',
  `Price` decimal(11,2) NOT NULL,
  `status_id` int(11) unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `orders_orders2products_fk` (`Order_ID`),
  KEY `products_orders2products_fk` (`Product_ID`),
  KEY `colors_orders2products_fk` (`Color_ID`),
  CONSTRAINT `colors_orders2products_fk` FOREIGN KEY (`Color_ID`) REFERENCES `colors` (`id`),
  CONSTRAINT `orders_orders2products_fk` FOREIGN KEY (`Order_ID`) REFERENCES `orders` (`id`),
  CONSTRAINT `products_orders2products_fk` FOREIGN KEY (`Product_ID`) REFERENCES `products` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=197 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `orders2registrant2products`
--

DROP TABLE IF EXISTS `orders2registrant2products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `orders2registrant2products` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `Order_ID` int(11) unsigned NOT NULL,
  `Registrant2Product_ID` int(11) unsigned NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `IsDeleted` tinyint(1) NOT NULL DEFAULT '0',
  `Contribute_ID` int(11) unsigned DEFAULT NULL,
  `IsGetMoney` tinyint(1) NOT NULL DEFAULT '0',
  `status_id` int(11) unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `orders_orders2registrant2products_fk` (`Order_ID`),
  KEY `registrant2products_orders2registrant2products_fk` (`Registrant2Product_ID`),
  KEY `contributes_orders2registrant2products_fk` (`Contribute_ID`),
  CONSTRAINT `contributes_orders2registrant2products_fk` FOREIGN KEY (`Contribute_ID`) REFERENCES `contributes` (`id`),
  CONSTRAINT `orders_orders2registrant2products_fk` FOREIGN KEY (`Order_ID`) REFERENCES `orders` (`id`),
  CONSTRAINT `registrant2products_orders2registrant2products_fk` FOREIGN KEY (`Registrant2Product_ID`) REFERENCES `registrant2products` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=173 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `orders_statuses`
--

DROP TABLE IF EXISTS `orders_statuses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `orders_statuses` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `Name` varchar(20) NOT NULL DEFAULT '',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `IsDeleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `partner_administrators`
--

DROP TABLE IF EXISTS `partner_administrators`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `partner_administrators` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `IsDeleted` tinyint(1) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `FirstName` varchar(50) NOT NULL,
  `LastName` varchar(50) NOT NULL,
  `Login` varchar(50) NOT NULL,
  `Password` varchar(50) NOT NULL,
  `Phone` varchar(50) DEFAULT NULL,
  `Email` varchar(50) DEFAULT NULL,
  `Partner_ID` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `partners_partner_administrators_fk` (`Partner_ID`),
  CONSTRAINT `partners_partner_administrators_fk` FOREIGN KEY (`Partner_ID`) REFERENCES `partners` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `partners`
--

DROP TABLE IF EXISTS `partners`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `partners` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `Email` varchar(30) NOT NULL,
  `Password` varchar(50) NOT NULL,
  `FirstName` varchar(30) DEFAULT NULL,
  `LastName` varchar(30) DEFAULT NULL,
  `Address` varchar(50) DEFAULT NULL,
  `AgreeWithSitePolicy` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `IsDeleted` tinyint(1) NOT NULL DEFAULT '0',
  `ZIP` varchar(10) DEFAULT NULL,
  `PhoneNumber` int(20) DEFAULT NULL,
  `Description` varchar(900) DEFAULT NULL,
  `City` varchar(50) DEFAULT NULL,
  `State_ID` int(11) unsigned DEFAULT NULL,
  `Image` mediumblob,
  `ImageGUID` varchar(40) DEFAULT NULL,
  `Cash` decimal(11,0) NOT NULL DEFAULT '0',
  `PaymentSystem` int(11) DEFAULT NULL,
  `OwnerName` varchar(50) DEFAULT NULL,
  `OwnerLastName` varchar(50) DEFAULT NULL,
  `OwnerStreet` varchar(50) DEFAULT NULL,
  `OwnerCity` varchar(50) DEFAULT NULL,
  `OwnerZIP` varchar(10) DEFAULT NULL,
  `OwnerPhone` varchar(50) DEFAULT NULL,
  `OwnerEmail` varchar(50) DEFAULT NULL,
  `OwnerState_ID` int(11) unsigned DEFAULT NULL,
  `BillingName` varchar(50) DEFAULT NULL,
  `BillingLastName` varchar(50) DEFAULT NULL,
  `BillingStreet` varchar(50) DEFAULT NULL,
  `BillingCity` varchar(50) DEFAULT NULL,
  `BillingZIP` varchar(10) DEFAULT NULL,
  `BillingPhone` varchar(50) DEFAULT NULL,
  `BillingEmail` varchar(50) DEFAULT NULL,
  `BillingState_ID` int(11) unsigned DEFAULT NULL,
  `Check` varchar(50) DEFAULT NULL,
  `PayPalAccount` varchar(50) DEFAULT NULL,
  `WebSite` varchar(50) DEFAULT NULL,
  `LogoGUID` varchar(40) DEFAULT NULL,
  `LogoImage` mediumblob,
  `PartnerName` char(50) DEFAULT NULL,
  `IsActivated` tinyint(1) DEFAULT '0',
  `Logins` bigint(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `State_ID` (`State_ID`),
  CONSTRAINT `partners_states_fk` FOREIGN KEY (`State_ID`) REFERENCES `states` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=55 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `payments`
--

DROP TABLE IF EXISTS `payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `payments` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `IsDeleted` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `PaymentType_ID` int(11) unsigned NOT NULL,
  `IsTakeMoney` tinyint(1) NOT NULL,
  `PaymentStatus` varchar(50) DEFAULT NULL,
  `PaymentDate` datetime NOT NULL,
  `TransactionID` varchar(50) DEFAULT NULL,
  `FeeAmount` decimal(11,2) DEFAULT NULL,
  `GrossAmount` decimal(11,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `typepayment_payments_fk` (`PaymentType_ID`),
  CONSTRAINT `typepayment_payments_fk` FOREIGN KEY (`PaymentType_ID`) REFERENCES `typepayments` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_params`
--

DROP TABLE IF EXISTS `product_params`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_params` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `IsDeleted` tinyint(1) DEFAULT '0',
  `Name` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `Product_ID` int(11) unsigned NOT NULL,
  `Partner_ID` int(11) unsigned DEFAULT NULL,
  `IsTemplate` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `products_product_params_fk` (`Product_ID`),
  KEY `partners_product_params_fk` (`Partner_ID`),
  CONSTRAINT `partners_product_params_fk` FOREIGN KEY (`Partner_ID`) REFERENCES `partners` (`id`),
  CONSTRAINT `products_product_params_fk` FOREIGN KEY (`Product_ID`) REFERENCES `products` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=66 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_params2orders`
--

DROP TABLE IF EXISTS `product_params2orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_params2orders` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `IsDeleted` tinyint(1) DEFAULT '0',
  `Registrant2Product_ID` int(11) unsigned DEFAULT NULL,
  `Order2Product_ID` int(11) unsigned DEFAULT NULL,
  `Name` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `Value` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `r2p_product_params2orders_fk` (`Registrant2Product_ID`),
  KEY `o2p_product_params2orders_fk` (`Order2Product_ID`),
  CONSTRAINT `o2p_product_params2orders_fk` FOREIGN KEY (`Order2Product_ID`) REFERENCES `orders2products` (`id`),
  CONSTRAINT `r2p_product_params2orders_fk` FOREIGN KEY (`Registrant2Product_ID`) REFERENCES `registrant2products` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=156 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_statuses`
--

DROP TABLE IF EXISTS `product_statuses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_statuses` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `Name` varchar(20) NOT NULL DEFAULT '',
  `Description` varchar(50) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `IsDeleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `productimages`
--

DROP TABLE IF EXISTS `productimages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `productimages` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `Image` mediumblob,
  `Product_ID` int(11) unsigned NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `IsDeleted` tinyint(1) NOT NULL DEFAULT '0',
  `ImageGUID` char(39) NOT NULL,
  `BigImage` mediumblob,
  `IsPDF` tinyint(1) DEFAULT '0',
  `IsVertical` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  UNIQUE KEY `ImageGUID` (`ImageGUID`),
  KEY `productimages_fk` (`Product_ID`),
  CONSTRAINT `productimages_ibfk_1` FOREIGN KEY (`Product_ID`) REFERENCES `products` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=632 DEFAULT CHARSET=utf8 AVG_ROW_LENGTH=360448;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `products` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) NOT NULL,
  `Description` varchar(900) NOT NULL DEFAULT '',
  `MasterPrice` decimal(11,2) NOT NULL,
  `ProductStatus_ID` int(11) unsigned NOT NULL,
  `Brand_ID` int(11) unsigned DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `IsDeleted` tinyint(1) NOT NULL DEFAULT '0',
  `MainImage` mediumblob,
  `Store_ID` int(11) unsigned DEFAULT NULL,
  `ImageGUID` char(39) DEFAULT NULL,
  `Registrant_ID` int(11) unsigned DEFAULT NULL,
  `ShipmentCategory_ID` int(11) unsigned DEFAULT '0',
  `IsKind` tinyint(1) DEFAULT '0',
  `IsKindView` tinyint(1) DEFAULT '1',
  `BigImage` mediumblob,
  `BigImageGUID` char(39) DEFAULT NULL,
  `SalesPrice` decimal(11,2) DEFAULT NULL,
  `ShipmentType` int(11) DEFAULT '1',
  `ShipmentCost` decimal(11,2) DEFAULT NULL,
  `PartnerProduct_ID` int(11) DEFAULT NULL,
  `IsVertical` tinyint(1) DEFAULT '1',
  `CountView` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `ImageGUID` (`ImageGUID`),
  KEY `brands_products_fk` (`Brand_ID`),
  KEY `products_fk` (`ProductStatus_ID`),
  KEY `registrant_products_fk` (`Registrant_ID`),
  KEY `category_products_fk` (`ShipmentCategory_ID`),
  KEY `stores_products_fk1` (`Store_ID`),
  CONSTRAINT `brands_products_fk` FOREIGN KEY (`Brand_ID`) REFERENCES `brands` (`id`),
  CONSTRAINT `category_products_fk` FOREIGN KEY (`ShipmentCategory_ID`) REFERENCES `categories` (`id`),
  CONSTRAINT `products_fk` FOREIGN KEY (`ProductStatus_ID`) REFERENCES `product_statuses` (`id`),
  CONSTRAINT `registrant_products_fk` FOREIGN KEY (`Registrant_ID`) REFERENCES `registrants` (`id`),
  CONSTRAINT `stores_products_fk1` FOREIGN KEY (`Store_ID`) REFERENCES `stores` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=930 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `products2categories`
--

DROP TABLE IF EXISTS `products2categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `products2categories` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `Product_ID` int(11) unsigned NOT NULL,
  `Category_ID` int(11) unsigned NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `IsDeleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `products_products_to_categories_fk` (`Product_ID`),
  KEY `categories_products_to_categories_fk` (`Category_ID`),
  CONSTRAINT `categories_products_to_categories_fk` FOREIGN KEY (`Category_ID`) REFERENCES `categories` (`id`),
  CONSTRAINT `productes_products_to_categories_fk` FOREIGN KEY (`Product_ID`) REFERENCES `products` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1016 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `products2colors`
--

DROP TABLE IF EXISTS `products2colors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `products2colors` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `Product_ID` int(11) unsigned NOT NULL,
  `Color_ID` int(11) unsigned NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `IsDeleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `products_products_to_colors_fk` (`Product_ID`),
  KEY `color_products_to_colors_fk` (`Color_ID`),
  CONSTRAINT `color_products_to_colors_fk` FOREIGN KEY (`Color_ID`) REFERENCES `colors` (`id`),
  CONSTRAINT `products_products_to_colors_fk` FOREIGN KEY (`Product_ID`) REFERENCES `products` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=296 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `products2stores`
--

DROP TABLE IF EXISTS `products2stores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `products2stores` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `Product_ID` int(11) unsigned NOT NULL,
  `Store_ID` int(11) unsigned NOT NULL,
  `IsDeleted` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `products_products2stores_fk` (`Product_ID`),
  KEY `stores_products2stores_fk` (`Store_ID`),
  CONSTRAINT `products_products2stores_fk` FOREIGN KEY (`Product_ID`) REFERENCES `products` (`id`),
  CONSTRAINT `stores_products2stores_fk` FOREIGN KEY (`Store_ID`) REFERENCES `stores` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=418 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `registrant2products`
--

DROP TABLE IF EXISTS `registrant2products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `registrant2products` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `Product_ID` int(11) unsigned NOT NULL,
  `Registrant_ID` int(11) unsigned NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `IsDeleted` tinyint(1) NOT NULL DEFAULT '0',
  `Price` decimal(11,2) NOT NULL,
  `MyProduct_ID` int(11) unsigned DEFAULT NULL,
  `AlocatedMoney` decimal(11,2) DEFAULT NULL,
  `Quantity` int(11) NOT NULL DEFAULT '1',
  `Color_ID` int(11) unsigned DEFAULT NULL,
  `Notes` varchar(50) DEFAULT '',
  `Category_ID` int(11) unsigned NOT NULL,
  `Action_ID` int(11) DEFAULT '3',
  `Purchased_ID` int(11) DEFAULT NULL,
  `Contributed` decimal(11,2) NOT NULL DEFAULT '0.00',
  `Ordered` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `OrderNumber` int(11) DEFAULT NULL,
  `StoreName` varchar(50) DEFAULT NULL,
  `StoreWebSite` varchar(300) DEFAULT NULL,
  `IsGetMoney` tinyint(1) DEFAULT NULL,
  `Tax` decimal(11,2) NOT NULL DEFAULT '0.00',
  `Shipment` decimal(11,2) NOT NULL DEFAULT '0.00',
  `IsToolbar` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `products_couples2products_fk` (`Product_ID`),
  KEY `couples_couples2products_fk` (`Registrant_ID`),
  KEY `myprodcuts_registrant2products_fk` (`MyProduct_ID`),
  KEY `colors_registrant2products_fk` (`Color_ID`),
  KEY `categories_registrant2products_fk` (`Category_ID`),
  CONSTRAINT `categories_registrant2products_fk` FOREIGN KEY (`Category_ID`) REFERENCES `categories` (`id`),
  CONSTRAINT `colors_registrant2products_fk` FOREIGN KEY (`Color_ID`) REFERENCES `colors` (`id`),
  CONSTRAINT `myprodcuts_registrant2products_fk` FOREIGN KEY (`MyProduct_ID`) REFERENCES `myproducts` (`id`),
  CONSTRAINT `products_couples2products_fk` FOREIGN KEY (`Product_ID`) REFERENCES `products` (`id`),
  CONSTRAINT `registrants_registrant2products_fk` FOREIGN KEY (`Registrant_ID`) REFERENCES `registrants` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=807 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `registrant_types`
--

DROP TABLE IF EXISTS `registrant_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `registrant_types` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) NOT NULL DEFAULT '',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `IsDeleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `registrants`
--

DROP TABLE IF EXISTS `registrants`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `registrants` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `Email` varchar(30) NOT NULL DEFAULT '',
  `Password` varchar(50) NOT NULL DEFAULT '',
  `FirstName` varchar(30) DEFAULT '',
  `LastName` varchar(30) DEFAULT '',
  `FirstNameCoCreated` varchar(30) DEFAULT '',
  `LastNameCoCreated` varchar(30) DEFAULT '',
  `Address` varchar(50) DEFAULT '',
  `AgreeWithSitePolicy` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `IsDeleted` tinyint(1) NOT NULL DEFAULT '0',
  `ZIP` varchar(10) DEFAULT NULL,
  `PhoneNumber` varchar(20) DEFAULT NULL,
  `RegistryType_ID` int(11) unsigned DEFAULT NULL,
  `Description` varchar(300) DEFAULT NULL,
  `City` varchar(50) DEFAULT NULL,
  `State_ID` int(11) unsigned DEFAULT NULL,
  `EventDate` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `Image` mediumblob,
  `ImageGUID` varchar(40) DEFAULT NULL,
  `Cash` decimal(11,2) NOT NULL DEFAULT '0.00',
  `fbuid` varchar(32) DEFAULT NULL,
  `PaymentSystem` int(11) DEFAULT '0',
  `EventLocation` varchar(150) DEFAULT NULL,
  `IsActivated` tinyint(1) DEFAULT '0',
  `Logins` bigint(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `couples_cities_fk` (`City`),
  KEY `states_couples_fk` (`State_ID`),
  KEY `couples_registryTypes_fk` (`RegistryType_ID`),
  CONSTRAINT `couples_registryTypes_fk` FOREIGN KEY (`RegistryType_ID`) REFERENCES `registrant_types` (`id`),
  CONSTRAINT `states_couples_fk` FOREIGN KEY (`State_ID`) REFERENCES `states` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=117 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `schema_migrations`
--

DROP TABLE IF EXISTS `schema_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schema_migrations` (
  `version` varchar(255) NOT NULL DEFAULT '',
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sessions`
--

DROP TABLE IF EXISTS `sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sessions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `session_id` varchar(5000) NOT NULL,
  `data` text,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=35451 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `shippingmethods`
--

DROP TABLE IF EXISTS `shippingmethods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `shippingmethods` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `IsDeleted` tinyint(1) NOT NULL DEFAULT '0',
  `Price` decimal(11,0) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table `simple_captcha_data`
--

DROP TABLE IF EXISTS `simple_captcha_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `simple_captcha_data` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `key` varchar(40) COLLATE utf8_unicode_ci DEFAULT NULL,
  `value` varchar(6) COLLATE utf8_unicode_ci DEFAULT NULL,
  `create_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `update_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `states`
--

DROP TABLE IF EXISTS `states`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `states` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) NOT NULL DEFAULT '',
  `IsDeleted` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `GeneralTax` float NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table `store_types`
--

DROP TABLE IF EXISTS `store_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `store_types` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) NOT NULL DEFAULT '',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `IsDeleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table `stores`
--

DROP TABLE IF EXISTS `stores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `stores` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) NOT NULL DEFAULT '',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `IsDeleted` tinyint(1) NOT NULL DEFAULT '0',
  `City` varchar(50) DEFAULT '',
  `State_ID` int(11) unsigned DEFAULT NULL,
  `Login` varchar(30) NOT NULL DEFAULT '',
  `Password` varchar(30) NOT NULL DEFAULT '',
  `Description` varchar(300) DEFAULT NULL,
  `StoreType_ID` int(11) unsigned NOT NULL,
  `Street` varchar(50) DEFAULT NULL,
  `ZIP` varchar(10) DEFAULT NULL,
  `Phone` varchar(50) DEFAULT NULL,
  `Web` varchar(50) DEFAULT NULL,
  `Email` varchar(50) DEFAULT NULL,
  `LastVisited` datetime DEFAULT NULL,
  `PartnerID` int(11) unsigned NOT NULL,
  `IsDefault` tinyint(1) DEFAULT '0',
  `Image` mediumblob,
  `ImageGUID` varchar(40) DEFAULT NULL,
  `Category_ID` int(11) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `states_stores_fk` (`State_ID`),
  KEY `cities_stores_fk` (`City`),
  KEY `StoreType_ID` (`StoreType_ID`),
  KEY `PartnerID` (`PartnerID`),
  CONSTRAINT `partners_stores_fk` FOREIGN KEY (`PartnerID`) REFERENCES `partners` (`id`),
  CONSTRAINT `stores_fk` FOREIGN KEY (`StoreType_ID`) REFERENCES `store_types` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=63 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `tax_shipments`
--

DROP TABLE IF EXISTS `tax_shipments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tax_shipments` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `IsDeleted` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `CityPlace` char(50) DEFAULT NULL,
  `StatePlace_ID` int(11) unsigned DEFAULT NULL,
  `ZIPPlace` char(20) DEFAULT NULL,
  `CityRegistrant` char(50) DEFAULT NULL,
  `StateRegistrant_ID` int(11) unsigned DEFAULT NULL,
  `ZIPRegistrant` char(20) DEFAULT NULL,
  `Tax` decimal(11,2) DEFAULT NULL,
  `MasterPrice` decimal(11,2) DEFAULT NULL,
  `Shipment` decimal(11,2) DEFAULT '0.00',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `type_payments`
--

DROP TABLE IF EXISTS `type_payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `type_payments` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `Name` char(50) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `IsDeleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `typepayments`
--

DROP TABLE IF EXISTS `typepayments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `typepayments` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) NOT NULL,
  `IsDeleted` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table `value_params`
--

DROP TABLE IF EXISTS `value_params`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `value_params` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `IsDeleted` tinyint(1) DEFAULT '0',
  `Value` varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  `ProductParam_ID` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `product_params_value_params_fk` (`ProductParam_ID`),
  CONSTRAINT `product_params_value_params_fk` FOREIGN KEY (`ProductParam_ID`) REFERENCES `product_params` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1237 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `withdrawals`
--

DROP TABLE IF EXISTS `withdrawals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `withdrawals` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `Registrant_ID` int(11) unsigned NOT NULL,
  `Order_ID` int(11) unsigned NOT NULL,
  `IsDeleted` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `Cash` decimal(11,2) DEFAULT NULL,
  `Tax` decimal(11,2) DEFAULT '0.00',
  `Registrant2Product_ID` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `registrants_withdrawals_fk` (`Registrant_ID`),
  KEY `orders_withdrawals_fk` (`Order_ID`),
  KEY `registrant2product_withdrawals_fk` (`Registrant2Product_ID`),
  CONSTRAINT `orders_withdrawals_fk` FOREIGN KEY (`Order_ID`) REFERENCES `orders` (`id`),
  CONSTRAINT `registrant2product_withdrawals_fk` FOREIGN KEY (`Registrant2Product_ID`) REFERENCES `registrant2products` (`id`),
  CONSTRAINT `registrants_withdrawals_fk` FOREIGN KEY (`Registrant_ID`) REFERENCES `registrants` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=52 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;


/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2011-11-07 22:07:03
