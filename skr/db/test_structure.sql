CREATE TABLE `administrators` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
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

CREATE TABLE `brands` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) NOT NULL DEFAULT '',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `IsDeleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=980190963 DEFAULT CHARSET=utf8;

CREATE TABLE `categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) NOT NULL DEFAULT '',
  `Description` varchar(300) DEFAULT NULL,
  `Parent_ID` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `IsDeleted` tinyint(1) NOT NULL DEFAULT '0',
  `Image` mediumblob,
  `ImageGUID` varchar(39) DEFAULT NULL,
  `PerShipment` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ImageGUID` (`ImageGUID`)
) ENGINE=InnoDB AUTO_INCREMENT=980190963 DEFAULT CHARSET=utf8;

CREATE TABLE `categories2stores` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `IsDeleted` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `Store_ID` int(11) NOT NULL,
  `Category_ID` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=980190963 DEFAULT CHARSET=utf8;

CREATE TABLE `closed_payment_statuses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `IsDeleted` tinyint(4) NOT NULL DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `Name` varchar(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=980190963 DEFAULT CHARSET=utf8;

CREATE TABLE `closed_payments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `IsDeleted` tinyint(4) NOT NULL DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `order_id` int(11) NOT NULL,
  `typepayment_id` int(11) NOT NULL,
  `amount` decimal(11,2) NOT NULL DEFAULT '0.00',
  `status_id` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `orders_closed_payments_fk` (`order_id`),
  KEY `statuses_closed_payments_fk` (`status_id`),
  KEY `typepayments_closed_payments_fk` (`typepayment_id`)
) ENGINE=InnoDB AUTO_INCREMENT=980190963 DEFAULT CHARSET=utf8;

CREATE TABLE `colors` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) NOT NULL DEFAULT '',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `IsDeleted` tinyint(1) NOT NULL DEFAULT '0',
  `RGB` varchar(6) DEFAULT 'ffffff',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=980190963 DEFAULT CHARSET=utf8;

CREATE TABLE `commissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(30) NOT NULL,
  `Percent` float NOT NULL,
  `IsDeleted` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=980190963 DEFAULT CHARSET=utf8;

CREATE TABLE `contributes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `Contribute` decimal(11,2) NOT NULL,
  `FirstName` varchar(50) DEFAULT 'Unknown',
  `LastName` varchar(50) DEFAULT 'Unknown',
  `Notes` varchar(300) DEFAULT '',
  `Registrant2Products_ID` int(11) NOT NULL,
  `IsDeleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `r2p_contributes_fk` (`Registrant2Products_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=980190963 DEFAULT CHARSET=utf8;

CREATE TABLE `email_servers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `address` varchar(50) DEFAULT NULL,
  `port` int(11) DEFAULT NULL,
  `tls` tinyint(1) DEFAULT NULL,
  `user_name` varchar(50) DEFAULT NULL,
  `password` varchar(50) DEFAULT NULL,
  `domain` varchar(50) DEFAULT NULL,
  `from` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=980190963 DEFAULT CHARSET=utf8;

CREATE TABLE `knack_payments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Order2Product_ID` int(11) DEFAULT NULL,
  `Order2Registrant2Product_ID` int(11) DEFAULT NULL,
  `Partner_ID` int(11) DEFAULT NULL,
  `Amount` decimal(11,2) DEFAULT NULL,
  `IsDeleted` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `DateTime` datetime DEFAULT NULL,
  `Withdrawal_ID` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `o2p_knack_payment_fk` (`Order2Product_ID`),
  KEY `o2r2p_knack_payments_fk` (`Order2Registrant2Product_ID`),
  KEY `partner_knack_payment_fk` (`Partner_ID`),
  KEY `withdrawal_knack_payments_fk` (`Withdrawal_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=980190963 DEFAULT CHARSET=utf8;

CREATE TABLE `line_statuses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `IsDeleted` tinyint(4) NOT NULL DEFAULT '0',
  `name` varchar(20) NOT NULL,
  `alias` varchar(10) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=980190963 DEFAULT CHARSET=utf8;

CREATE TABLE `myproducts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) NOT NULL DEFAULT '',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `IsDeleted` tinyint(1) NOT NULL DEFAULT '0',
  `Image` mediumblob,
  `StoreName` varchar(50) NOT NULL DEFAULT '',
  `Description` varchar(300) DEFAULT NULL,
  `Price` decimal(11,2) NOT NULL,
  `StoreUrl` varchar(50) DEFAULT NULL,
  `Category_ID` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `categories_myproducts_fk` (`Category_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `order2payments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Order_ID` int(11) NOT NULL,
  `Payment_ID` int(11) NOT NULL,
  `IsDeleted` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `orders_order2payments_fk` (`Order_ID`),
  KEY `payment_order2payments_fk` (`Payment_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=980190963 DEFAULT CHARSET=utf8;

CREATE TABLE `order_lines` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Store_ID` int(11) NOT NULL,
  `Order_ID` int(11) NOT NULL,
  `Product_ID` int(11) DEFAULT NULL,
  `MyProduct_ID` int(11) DEFAULT NULL,
  `Value` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `order_lines_fk` (`MyProduct_ID`),
  KEY `orders_order_lines_fk` (`Order_ID`),
  KEY `products_order_lines_fk` (`Product_ID`),
  KEY `stores_order_lines_fk` (`Store_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `order_payments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `IsDeleted` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `Order_ID` int(11) NOT NULL,
  `accaunt` varchar(50) DEFAULT NULL,
  `amount` decimal(11,2) NOT NULL,
  `TypePayment_ID` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `Order_ID` (`Order_ID`),
  KEY `TypePayment_ID` (`TypePayment_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `orders` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Registrant_ID` int(11) DEFAULT NULL,
  `OrdersStatus_ID` int(11) NOT NULL,
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
  `ShippingMethod_ID` int(11) DEFAULT NULL,
  `BillingState_ID` int(11) DEFAULT NULL,
  `ShippingState_ID` int(11) DEFAULT NULL,
  `TypePayment_ID` int(11) NOT NULL DEFAULT '1',
  `PaymentMethod_ID` int(11) DEFAULT NULL,
  `PayPalEmail` varchar(50) DEFAULT NULL,
  `TakeMoneyAmount` decimal(11,2) DEFAULT NULL,
  `ShipmentTracking` varchar(20) DEFAULT NULL,
  `DeliveryDate` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `state_bilstate_fk` (`BillingState_ID`),
  KEY `orderstatuses_orders_fk` (`OrdersStatus_ID`),
  KEY `registrant_orders_fk` (`Registrant_ID`),
  KEY `shippingmethods_orders_fk` (`ShippingMethod_ID`),
  KEY `state_shipstate_fk` (`ShippingState_ID`),
  KEY `TypePayment_ID` (`TypePayment_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=980190963 DEFAULT CHARSET=utf8;

CREATE TABLE `orders2products` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Order_ID` int(11) NOT NULL,
  `Product_ID` int(11) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `IsDeleted` tinyint(1) NOT NULL DEFAULT '0',
  `Color_ID` int(11) DEFAULT NULL,
  `Quantity` int(11) NOT NULL,
  `Tax` decimal(11,2) NOT NULL DEFAULT '0.00',
  `Shipment` decimal(11,2) NOT NULL DEFAULT '0.00',
  `Price` decimal(11,2) NOT NULL,
  `status_id` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `colors_orders2products_fk` (`Color_ID`),
  KEY `orders_orders2products_fk` (`Order_ID`),
  KEY `products_orders2products_fk` (`Product_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=980190963 DEFAULT CHARSET=utf8;

CREATE TABLE `orders2registrant2products` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Order_ID` int(11) NOT NULL,
  `Registrant2Product_ID` int(11) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `IsDeleted` tinyint(1) NOT NULL DEFAULT '0',
  `Contribute_ID` int(11) DEFAULT NULL,
  `IsGetMoney` tinyint(1) NOT NULL DEFAULT '0',
  `status_id` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `contributes_orders2registrant2products_fk` (`Contribute_ID`),
  KEY `orders_orders2registrant2products_fk` (`Order_ID`),
  KEY `registrant2products_orders2registrant2products_fk` (`Registrant2Product_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=980190963 DEFAULT CHARSET=utf8;

CREATE TABLE `orders_statuses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(20) NOT NULL DEFAULT '',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `IsDeleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=980190963 DEFAULT CHARSET=utf8;

CREATE TABLE `partner_administrators` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `IsDeleted` tinyint(1) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `FirstName` varchar(50) NOT NULL,
  `LastName` varchar(50) NOT NULL,
  `Login` varchar(50) NOT NULL,
  `Password` varchar(50) NOT NULL,
  `Phone` varchar(50) DEFAULT NULL,
  `Email` varchar(50) DEFAULT NULL,
  `Partner_ID` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `partners_partner_administrators_fk` (`Partner_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=980190963 DEFAULT CHARSET=utf8;

CREATE TABLE `partners` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
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
  `PhoneNumber` int(11) DEFAULT NULL,
  `Description` varchar(900) DEFAULT NULL,
  `City` varchar(50) DEFAULT NULL,
  `State_ID` int(11) DEFAULT NULL,
  `Image` mediumblob,
  `ImageGUID` varchar(40) DEFAULT NULL,
  `Cash` int(11) NOT NULL DEFAULT '0',
  `PaymentSystem` int(11) DEFAULT NULL,
  `OwnerName` varchar(50) DEFAULT NULL,
  `OwnerLastName` varchar(50) DEFAULT NULL,
  `OwnerStreet` varchar(50) DEFAULT NULL,
  `OwnerCity` varchar(50) DEFAULT NULL,
  `OwnerZIP` varchar(10) DEFAULT NULL,
  `OwnerPhone` varchar(50) DEFAULT NULL,
  `OwnerEmail` varchar(50) DEFAULT NULL,
  `OwnerState_ID` int(11) DEFAULT NULL,
  `BillingName` varchar(50) DEFAULT NULL,
  `BillingLastName` varchar(50) DEFAULT NULL,
  `BillingStreet` varchar(50) DEFAULT NULL,
  `BillingCity` varchar(50) DEFAULT NULL,
  `BillingZIP` varchar(10) DEFAULT NULL,
  `BillingPhone` varchar(50) DEFAULT NULL,
  `BillingEmail` varchar(50) DEFAULT NULL,
  `BillingState_ID` int(11) DEFAULT NULL,
  `Check` varchar(50) DEFAULT NULL,
  `PayPalAccount` varchar(50) DEFAULT NULL,
  `WebSite` varchar(50) DEFAULT NULL,
  `LogoGUID` varchar(40) DEFAULT NULL,
  `LogoImage` mediumblob,
  `PartnerName` varchar(50) DEFAULT NULL,
  `IsActivated` tinyint(1) DEFAULT '0',
  `Logins` bigint(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `State_ID` (`State_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=980190963 DEFAULT CHARSET=utf8;

CREATE TABLE `payments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `IsDeleted` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `PaymentType_ID` int(11) NOT NULL,
  `IsTakeMoney` tinyint(1) NOT NULL,
  `PaymentStatus` varchar(50) DEFAULT NULL,
  `PaymentDate` datetime NOT NULL,
  `TransactionID` varchar(50) DEFAULT NULL,
  `FeeAmount` decimal(11,2) DEFAULT NULL,
  `GrossAmount` decimal(11,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `typepayment_payments_fk` (`PaymentType_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=980190963 DEFAULT CHARSET=utf8;

CREATE TABLE `product_params` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `IsDeleted` tinyint(1) DEFAULT '0',
  `Name` varchar(50) NOT NULL,
  `Product_ID` int(11) NOT NULL,
  `Partner_ID` int(11) DEFAULT NULL,
  `IsTemplate` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `partners_product_params_fk` (`Partner_ID`),
  KEY `products_product_params_fk` (`Product_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=980190963 DEFAULT CHARSET=utf8;

CREATE TABLE `product_params2orders` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `IsDeleted` tinyint(1) DEFAULT '0',
  `Registrant2Product_ID` int(11) DEFAULT NULL,
  `Order2Product_ID` int(11) DEFAULT NULL,
  `Name` varchar(50) NOT NULL,
  `Value` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `o2p_product_params2orders_fk` (`Order2Product_ID`),
  KEY `r2p_product_params2orders_fk` (`Registrant2Product_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=980190963 DEFAULT CHARSET=utf8;

CREATE TABLE `product_statuses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(20) NOT NULL DEFAULT '',
  `Description` varchar(50) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `IsDeleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=980190963 DEFAULT CHARSET=utf8;

CREATE TABLE `productimages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Image` mediumblob,
  `Product_ID` int(11) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `IsDeleted` tinyint(1) NOT NULL DEFAULT '0',
  `ImageGUID` varchar(39) NOT NULL,
  `BigImage` mediumblob,
  `IsPDF` tinyint(1) DEFAULT '0',
  `IsVertical` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `ImageGUID` (`ImageGUID`),
  UNIQUE KEY `id` (`id`),
  KEY `productimages_fk` (`Product_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=298486375 DEFAULT CHARSET=utf8;

CREATE TABLE `products` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) NOT NULL,
  `Description` varchar(900) NOT NULL DEFAULT '',
  `MasterPrice` decimal(11,2) NOT NULL,
  `ProductStatus_ID` int(11) NOT NULL,
  `Brand_ID` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `IsDeleted` tinyint(1) NOT NULL DEFAULT '0',
  `MainImage` mediumblob,
  `Store_ID` int(11) DEFAULT NULL,
  `ImageGUID` varchar(39) DEFAULT NULL,
  `Registrant_ID` int(11) DEFAULT NULL,
  `ShipmentCategory_ID` int(11) DEFAULT '0',
  `IsKind` tinyint(1) DEFAULT '0',
  `IsKindView` tinyint(1) DEFAULT '1',
  `BigImage` mediumblob,
  `BigImageGUID` varchar(39) DEFAULT NULL,
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
  KEY `stores_products_fk1` (`Store_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=980190963 DEFAULT CHARSET=utf8;

CREATE TABLE `products2categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Product_ID` int(11) NOT NULL,
  `Category_ID` int(11) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `IsDeleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `categories_products_to_categories_fk` (`Category_ID`),
  KEY `products_products_to_categories_fk` (`Product_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=980190963 DEFAULT CHARSET=utf8;

CREATE TABLE `products2colors` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Product_ID` int(11) NOT NULL,
  `Color_ID` int(11) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `IsDeleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `color_products_to_colors_fk` (`Color_ID`),
  KEY `products_products_to_colors_fk` (`Product_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=980190963 DEFAULT CHARSET=utf8;

CREATE TABLE `products2stores` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Product_ID` int(11) NOT NULL,
  `Store_ID` int(11) NOT NULL,
  `IsDeleted` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `products_products2stores_fk` (`Product_ID`),
  KEY `stores_products2stores_fk` (`Store_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=980190963 DEFAULT CHARSET=utf8;

CREATE TABLE `registrant2products` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Product_ID` int(11) NOT NULL,
  `Registrant_ID` int(11) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `IsDeleted` tinyint(1) NOT NULL DEFAULT '0',
  `Price` decimal(11,2) NOT NULL,
  `MyProduct_ID` int(11) DEFAULT NULL,
  `AlocatedMoney` decimal(11,2) DEFAULT NULL,
  `Quantity` int(11) NOT NULL DEFAULT '1',
  `Color_ID` int(11) DEFAULT NULL,
  `Notes` varchar(50) DEFAULT '',
  `Category_ID` int(11) NOT NULL,
  `Action_ID` int(11) DEFAULT '3',
  `Purchased_ID` int(11) DEFAULT NULL,
  `Contributed` decimal(11,2) NOT NULL DEFAULT '0.00',
  `Ordered` datetime NOT NULL,
  `OrderNumber` int(11) DEFAULT NULL,
  `StoreName` varchar(50) DEFAULT NULL,
  `StoreWebSite` varchar(300) DEFAULT NULL,
  `IsGetMoney` tinyint(1) DEFAULT NULL,
  `Tax` decimal(11,2) NOT NULL DEFAULT '0.00',
  `Shipment` decimal(11,2) NOT NULL DEFAULT '0.00',
  `IsToolbar` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `categories_registrant2products_fk` (`Category_ID`),
  KEY `colors_registrant2products_fk` (`Color_ID`),
  KEY `myprodcuts_registrant2products_fk` (`MyProduct_ID`),
  KEY `products_couples2products_fk` (`Product_ID`),
  KEY `couples_couples2products_fk` (`Registrant_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=980190963 DEFAULT CHARSET=utf8;

CREATE TABLE `registrant_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) NOT NULL DEFAULT '',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `IsDeleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=980190963 DEFAULT CHARSET=utf8;

CREATE TABLE `registrants` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
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
  `RegistryType_ID` int(11) DEFAULT NULL,
  `Description` varchar(300) DEFAULT NULL,
  `City` varchar(50) DEFAULT NULL,
  `State_ID` int(11) DEFAULT NULL,
  `EventDate` datetime NOT NULL,
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
  KEY `couples_registryTypes_fk` (`RegistryType_ID`),
  KEY `states_couples_fk` (`State_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=980190963 DEFAULT CHARSET=utf8;

CREATE TABLE `schema_migrations` (
  `version` varchar(255) NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `sessions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `session_id` varchar(5000) NOT NULL,
  `data` text,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `shippingmethods` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `IsDeleted` tinyint(1) NOT NULL DEFAULT '0',
  `Price` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=980190963 DEFAULT CHARSET=utf8;

CREATE TABLE `simple_captcha_data` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `key` varchar(40) DEFAULT NULL,
  `value` varchar(6) DEFAULT NULL,
  `create_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `update_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `states` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) NOT NULL DEFAULT '',
  `IsDeleted` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `GeneralTax` float NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=980190963 DEFAULT CHARSET=utf8;

CREATE TABLE `store_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) NOT NULL DEFAULT '',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `IsDeleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `stores` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) NOT NULL DEFAULT '',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `IsDeleted` tinyint(1) NOT NULL DEFAULT '0',
  `City` varchar(50) DEFAULT '',
  `State_ID` int(11) DEFAULT NULL,
  `Login` varchar(30) NOT NULL DEFAULT '',
  `Password` varchar(30) NOT NULL DEFAULT '',
  `Description` varchar(300) DEFAULT NULL,
  `StoreType_ID` int(11) NOT NULL,
  `Street` varchar(50) DEFAULT NULL,
  `ZIP` varchar(10) DEFAULT NULL,
  `Phone` varchar(50) DEFAULT NULL,
  `Web` varchar(50) DEFAULT NULL,
  `Email` varchar(50) DEFAULT NULL,
  `LastVisited` datetime DEFAULT NULL,
  `PartnerID` int(11) NOT NULL,
  `IsDefault` tinyint(1) DEFAULT '0',
  `Image` mediumblob,
  `ImageGUID` varchar(40) DEFAULT NULL,
  `Category_ID` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `cities_stores_fk` (`City`),
  KEY `PartnerID` (`PartnerID`),
  KEY `states_stores_fk` (`State_ID`),
  KEY `StoreType_ID` (`StoreType_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=980190963 DEFAULT CHARSET=utf8;

CREATE TABLE `tax_shipments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `IsDeleted` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `CityPlace` varchar(50) DEFAULT NULL,
  `StatePlace_ID` int(11) DEFAULT NULL,
  `ZIPPlace` varchar(20) DEFAULT NULL,
  `CityRegistrant` varchar(50) DEFAULT NULL,
  `StateRegistrant_ID` int(11) DEFAULT NULL,
  `ZIPRegistrant` varchar(20) DEFAULT NULL,
  `Tax` decimal(11,2) DEFAULT NULL,
  `MasterPrice` decimal(11,2) DEFAULT NULL,
  `Shipment` decimal(11,2) DEFAULT '0.00',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=980190963 DEFAULT CHARSET=utf8;

CREATE TABLE `type_payments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `IsDeleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `typepayments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) NOT NULL,
  `IsDeleted` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=980190963 DEFAULT CHARSET=utf8;

CREATE TABLE `value_params` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `IsDeleted` tinyint(1) DEFAULT '0',
  `Value` varchar(20) NOT NULL,
  `ProductParam_ID` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `product_params_value_params_fk` (`ProductParam_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=980190963 DEFAULT CHARSET=utf8;

CREATE TABLE `withdrawals` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Registrant_ID` int(11) NOT NULL,
  `Order_ID` int(11) NOT NULL,
  `IsDeleted` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `Cash` decimal(11,2) DEFAULT NULL,
  `Tax` decimal(11,2) DEFAULT '0.00',
  `Registrant2Product_ID` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `orders_withdrawals_fk` (`Order_ID`),
  KEY `registrant2products_withdrawals_fk` (`Registrant2Product_ID`),
  KEY `registrants_withdrawals_fk` (`Registrant_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=980190963 DEFAULT CHARSET=utf8;

INSERT INTO schema_migrations (version) VALUES ('1');