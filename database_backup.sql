-- MySQL dump 10.13  Distrib 9.6.0, for Win64 (x86_64)
--
-- Host: localhost    Database: poddar_tours
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
SET @MYSQLDUMP_TEMP_LOG_BIN = @@SESSION.SQL_LOG_BIN;
SET @@SESSION.SQL_LOG_BIN= 0;

--
-- GTID state at the beginning of the backup 
--

SET @@GLOBAL.GTID_PURGED=/*!80000 '+'*/ 'acd4a756-1572-11f1-b3e7-98e7432f0635:1-870';

--
-- Table structure for table `account_emailaddress`
--

DROP TABLE IF EXISTS `account_emailaddress`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `account_emailaddress` (
  `id` int NOT NULL AUTO_INCREMENT,
  `email` varchar(254) NOT NULL,
  `verified` tinyint(1) NOT NULL,
  `primary` tinyint(1) NOT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `account_emailaddress_user_id_email_987c8728_uniq` (`user_id`,`email`),
  KEY `account_emailaddress_email_03be32b2` (`email`),
  CONSTRAINT `account_emailaddress_user_id_2c513194_fk_main_customuser_id` FOREIGN KEY (`user_id`) REFERENCES `main_customuser` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `account_emailaddress`
--

LOCK TABLES `account_emailaddress` WRITE;
/*!40000 ALTER TABLE `account_emailaddress` DISABLE KEYS */;
/*!40000 ALTER TABLE `account_emailaddress` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `account_emailconfirmation`
--

DROP TABLE IF EXISTS `account_emailconfirmation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `account_emailconfirmation` (
  `id` int NOT NULL AUTO_INCREMENT,
  `created` datetime(6) NOT NULL,
  `sent` datetime(6) DEFAULT NULL,
  `key` varchar(64) NOT NULL,
  `email_address_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `key` (`key`),
  KEY `account_emailconfirm_email_address_id_5b7f8c58_fk_account_e` (`email_address_id`),
  CONSTRAINT `account_emailconfirm_email_address_id_5b7f8c58_fk_account_e` FOREIGN KEY (`email_address_id`) REFERENCES `account_emailaddress` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `account_emailconfirmation`
--

LOCK TABLES `account_emailconfirmation` WRITE;
/*!40000 ALTER TABLE `account_emailconfirmation` DISABLE KEYS */;
/*!40000 ALTER TABLE `account_emailconfirmation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group`
--

DROP TABLE IF EXISTS `auth_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group`
--

LOCK TABLES `auth_group` WRITE;
/*!40000 ALTER TABLE `auth_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group_permissions`
--

DROP TABLE IF EXISTS `auth_group_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `group_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group_permissions`
--

LOCK TABLES `auth_group_permissions` WRITE;
/*!40000 ALTER TABLE `auth_group_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_permission`
--

DROP TABLE IF EXISTS `auth_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_permission` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `content_type_id` int NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`),
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=89 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_permission`
--

LOCK TABLES `auth_permission` WRITE;
/*!40000 ALTER TABLE `auth_permission` DISABLE KEYS */;
INSERT INTO `auth_permission` VALUES (1,'Can add category',2,'add_category'),(2,'Can change category',2,'change_category'),(3,'Can delete category',2,'delete_category'),(4,'Can view category',2,'view_category'),(5,'Can add newsletter',5,'add_newsletter'),(6,'Can change newsletter',5,'change_newsletter'),(7,'Can delete newsletter',5,'delete_newsletter'),(8,'Can view newsletter',5,'view_newsletter'),(9,'Can add user',3,'add_customuser'),(10,'Can change user',3,'change_customuser'),(11,'Can delete user',3,'delete_customuser'),(12,'Can view user',3,'view_customuser'),(13,'Can add tour package',10,'add_tourpackage'),(14,'Can change tour package',10,'change_tourpackage'),(15,'Can delete tour package',10,'delete_tourpackage'),(16,'Can view tour package',10,'view_tourpackage'),(17,'Can add tour itinerary',9,'add_touritinerary'),(18,'Can change tour itinerary',9,'change_touritinerary'),(19,'Can delete tour itinerary',9,'delete_touritinerary'),(20,'Can view tour itinerary',9,'view_touritinerary'),(21,'Can add tour highlight',8,'add_tourhighlight'),(22,'Can change tour highlight',8,'change_tourhighlight'),(23,'Can delete tour highlight',8,'delete_tourhighlight'),(24,'Can view tour highlight',8,'view_tourhighlight'),(25,'Can add tour gallery',7,'add_tourgallery'),(26,'Can change tour gallery',7,'change_tourgallery'),(27,'Can delete tour gallery',7,'delete_tourgallery'),(28,'Can view tour gallery',7,'view_tourgallery'),(29,'Can add review',6,'add_review'),(30,'Can change review',6,'change_review'),(31,'Can delete review',6,'delete_review'),(32,'Can view review',6,'view_review'),(33,'Can add enquiry',4,'add_enquiry'),(34,'Can change enquiry',4,'change_enquiry'),(35,'Can delete enquiry',4,'delete_enquiry'),(36,'Can view enquiry',4,'view_enquiry'),(37,'Can add booking',1,'add_booking'),(38,'Can change booking',1,'change_booking'),(39,'Can delete booking',1,'delete_booking'),(40,'Can view booking',1,'view_booking'),(41,'Can add tour rule',11,'add_tourrule'),(42,'Can change tour rule',11,'change_tourrule'),(43,'Can delete tour rule',11,'delete_tourrule'),(44,'Can view tour rule',11,'view_tourrule'),(45,'Can add log entry',12,'add_logentry'),(46,'Can change log entry',12,'change_logentry'),(47,'Can delete log entry',12,'delete_logentry'),(48,'Can view log entry',12,'view_logentry'),(49,'Can add permission',14,'add_permission'),(50,'Can change permission',14,'change_permission'),(51,'Can delete permission',14,'delete_permission'),(52,'Can view permission',14,'view_permission'),(53,'Can add group',13,'add_group'),(54,'Can change group',13,'change_group'),(55,'Can delete group',13,'delete_group'),(56,'Can view group',13,'view_group'),(57,'Can add content type',15,'add_contenttype'),(58,'Can change content type',15,'change_contenttype'),(59,'Can delete content type',15,'delete_contenttype'),(60,'Can view content type',15,'view_contenttype'),(61,'Can add session',16,'add_session'),(62,'Can change session',16,'change_session'),(63,'Can delete session',16,'delete_session'),(64,'Can view session',16,'view_session'),(65,'Can add site',17,'add_site'),(66,'Can change site',17,'change_site'),(67,'Can delete site',17,'delete_site'),(68,'Can view site',17,'view_site'),(69,'Can add email address',18,'add_emailaddress'),(70,'Can change email address',18,'change_emailaddress'),(71,'Can delete email address',18,'delete_emailaddress'),(72,'Can view email address',18,'view_emailaddress'),(73,'Can add email confirmation',19,'add_emailconfirmation'),(74,'Can change email confirmation',19,'change_emailconfirmation'),(75,'Can delete email confirmation',19,'delete_emailconfirmation'),(76,'Can view email confirmation',19,'view_emailconfirmation'),(77,'Can add social account',20,'add_socialaccount'),(78,'Can change social account',20,'change_socialaccount'),(79,'Can delete social account',20,'delete_socialaccount'),(80,'Can view social account',20,'view_socialaccount'),(81,'Can add social application',21,'add_socialapp'),(82,'Can change social application',21,'change_socialapp'),(83,'Can delete social application',21,'delete_socialapp'),(84,'Can view social application',21,'view_socialapp'),(85,'Can add social application token',22,'add_socialtoken'),(86,'Can change social application token',22,'change_socialtoken'),(87,'Can delete social application token',22,'delete_socialtoken'),(88,'Can view social application token',22,'view_socialtoken');
/*!40000 ALTER TABLE `auth_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_admin_log`
--

DROP TABLE IF EXISTS `django_admin_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_admin_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint unsigned NOT NULL,
  `change_message` longtext NOT NULL,
  `content_type_id` int DEFAULT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  KEY `django_admin_log_user_id_c564eba6_fk_main_customuser_id` (`user_id`),
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk_main_customuser_id` FOREIGN KEY (`user_id`) REFERENCES `main_customuser` (`id`),
  CONSTRAINT `django_admin_log_chk_1` CHECK ((`action_flag` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_admin_log`
--

LOCK TABLES `django_admin_log` WRITE;
/*!40000 ALTER TABLE `django_admin_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `django_admin_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_content_type`
--

DROP TABLE IF EXISTS `django_content_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_content_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_content_type`
--

LOCK TABLES `django_content_type` WRITE;
/*!40000 ALTER TABLE `django_content_type` DISABLE KEYS */;
INSERT INTO `django_content_type` VALUES (18,'account','emailaddress'),(19,'account','emailconfirmation'),(12,'admin','logentry'),(13,'auth','group'),(14,'auth','permission'),(15,'contenttypes','contenttype'),(1,'main','booking'),(2,'main','category'),(3,'main','customuser'),(4,'main','enquiry'),(5,'main','newsletter'),(6,'main','review'),(7,'main','tourgallery'),(8,'main','tourhighlight'),(9,'main','touritinerary'),(10,'main','tourpackage'),(11,'main','tourrule'),(16,'sessions','session'),(17,'sites','site'),(20,'socialaccount','socialaccount'),(21,'socialaccount','socialapp'),(22,'socialaccount','socialtoken');
/*!40000 ALTER TABLE `django_content_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_migrations`
--

DROP TABLE IF EXISTS `django_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_migrations` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_migrations`
--

LOCK TABLES `django_migrations` WRITE;
/*!40000 ALTER TABLE `django_migrations` DISABLE KEYS */;
INSERT INTO `django_migrations` VALUES (1,'contenttypes','0001_initial','2026-05-09 08:29:24.177189'),(2,'contenttypes','0002_remove_content_type_name','2026-05-09 08:29:26.175107'),(3,'auth','0001_initial','2026-05-09 08:29:27.907218'),(4,'auth','0002_alter_permission_name_max_length','2026-05-09 08:29:28.178062'),(5,'auth','0003_alter_user_email_max_length','2026-05-09 08:29:28.193781'),(6,'auth','0004_alter_user_username_opts','2026-05-09 08:29:28.210980'),(7,'auth','0005_alter_user_last_login_null','2026-05-09 08:29:28.230617'),(8,'auth','0006_require_contenttypes_0002','2026-05-09 08:29:28.235662'),(9,'auth','0007_alter_validators_add_error_messages','2026-05-09 08:29:28.252966'),(10,'auth','0008_alter_user_username_max_length','2026-05-09 08:29:28.269241'),(11,'auth','0009_alter_user_last_name_max_length','2026-05-09 08:29:28.291154'),(12,'auth','0010_alter_group_name_max_length','2026-05-09 08:29:28.417822'),(13,'auth','0011_update_proxy_permissions','2026-05-09 08:29:28.440527'),(14,'auth','0012_alter_user_first_name_max_length','2026-05-09 08:29:28.458770'),(15,'main','0001_initial','2026-05-09 08:29:32.298377'),(16,'admin','0001_initial','2026-05-09 08:29:32.645169'),(17,'admin','0002_logentry_remove_auto_add','2026-05-09 08:29:32.678181'),(18,'admin','0003_logentry_add_action_flag_choices','2026-05-09 08:29:32.709238'),(19,'sessions','0001_initial','2026-05-09 08:29:32.786536'),(20,'main','0002_alter_customuser_managers','2026-05-09 08:30:17.725591'),(21,'account','0001_initial','2026-05-10 05:52:43.634240'),(22,'account','0002_email_max_length','2026-05-10 05:52:43.759949'),(23,'account','0003_alter_emailaddress_create_unique_verified_email','2026-05-10 05:52:44.162794'),(24,'account','0004_alter_emailaddress_drop_unique_email','2026-05-10 05:52:44.957332'),(25,'account','0005_emailaddress_idx_upper_email','2026-05-10 05:52:45.213636'),(26,'account','0006_emailaddress_lower','2026-05-10 05:52:45.431366'),(27,'account','0007_emailaddress_idx_email','2026-05-10 05:52:45.495523'),(28,'account','0008_emailaddress_unique_primary_email_fixup','2026-05-10 05:52:45.525372'),(29,'account','0009_emailaddress_unique_primary_email','2026-05-10 05:52:45.537334'),(30,'main','0003_alter_customuser_phone_number','2026-05-10 05:52:46.802462'),(31,'sites','0001_initial','2026-05-10 05:52:46.934571'),(32,'sites','0002_alter_domain_unique','2026-05-10 05:52:47.098430'),(33,'socialaccount','0001_initial','2026-05-10 05:52:48.286510'),(34,'socialaccount','0002_token_max_lengths','2026-05-10 05:52:48.386570'),(35,'socialaccount','0003_extra_data_default_dict','2026-05-10 05:52:48.404217'),(36,'socialaccount','0004_app_provider_id_settings','2026-05-10 05:52:48.831814'),(37,'socialaccount','0005_socialtoken_nullable_app','2026-05-10 05:52:49.055422'),(38,'socialaccount','0006_alter_socialaccount_extra_data','2026-05-10 05:52:49.125187');
/*!40000 ALTER TABLE `django_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_session`
--

DROP TABLE IF EXISTS `django_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_expire_date_a5c62663` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_session`
--

LOCK TABLES `django_session` WRITE;
/*!40000 ALTER TABLE `django_session` DISABLE KEYS */;
INSERT INTO `django_session` VALUES ('7ujf3e76bmf5otqjz3ykadt9u7o59z1b','.eJytzcEKgjAYAOB3-c9D-rW5zWMgREpdgg4hMuay1XC2zQrEdy_oFTp_h2-G4JSRVirlpiG2IcqoAxQz6OPj5HflvtzeUjodPBTnGUbvlA5fB-t6MwCBTkYJxTBZS2C8K90q1-n2qb25GO1_shBkjGeC5hwTFIKukDcE1LWq165Hh129eVevfwwsFUnGOKY5NsvyAdc8SQ0:1wLxy5:2eAgV0ZBFBxR1NwwZxF-Iiq0jd4IuRcHHJC_tnhAcUw','2026-05-24 06:48:49.379486'),('gy7udbr1gmh8xixy886x5z8w2tqab20l','.eJyt0N1KwzAcBfB3-V-X0iTLV--mY1KUqkxxIKPENJ3dYjKarlpK393AXqF3B87Fj3MmCF63yiqt_dX1VehVbwLkE_Ss3ey20vo7d67N8z3knxNcOq9NiD1Yf2wdJFCrXkHurtYmcDlrU2lfm2owXdu0prs1c4I4F0RihrMUrSjBRBwSKE6y-Djq5vGrca9I_i4iMJaKmBGhURjDqRO0UOj75W0o1-MCAuFCpmRFKRc8CoPBWNYh-5GjpSz8LSBQEjfEj5i4vdRkD-X7-LTL1qTkar-IIEQqJMGcs8M8_wMOj6Zo:1wLy3c:TvK9v9XOkuK4JrFPsD5YyyWY11JrxCD-VBalWJ0vNwk','2026-05-24 06:54:32.823853');
/*!40000 ALTER TABLE `django_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_site`
--

DROP TABLE IF EXISTS `django_site`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_site` (
  `id` int NOT NULL AUTO_INCREMENT,
  `domain` varchar(100) NOT NULL,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_site_domain_a2e37b91_uniq` (`domain`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_site`
--

LOCK TABLES `django_site` WRITE;
/*!40000 ALTER TABLE `django_site` DISABLE KEYS */;
INSERT INTO `django_site` VALUES (1,'example.com','example.com');
/*!40000 ALTER TABLE `django_site` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `main_booking`
--

DROP TABLE IF EXISTS `main_booking`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `main_booking` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `booking_id` varchar(20) NOT NULL,
  `travel_date` date NOT NULL,
  `num_adults` int unsigned NOT NULL,
  `num_children` int unsigned NOT NULL,
  `total_price` decimal(10,2) NOT NULL,
  `status` varchar(20) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `user_id` bigint NOT NULL,
  `tour_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `booking_id` (`booking_id`),
  KEY `main_booking_user_id_7fb45758_fk_main_customuser_id` (`user_id`),
  KEY `main_booking_tour_id_ef812a40_fk_main_tourpackage_id` (`tour_id`),
  CONSTRAINT `main_booking_tour_id_ef812a40_fk_main_tourpackage_id` FOREIGN KEY (`tour_id`) REFERENCES `main_tourpackage` (`id`),
  CONSTRAINT `main_booking_user_id_7fb45758_fk_main_customuser_id` FOREIGN KEY (`user_id`) REFERENCES `main_customuser` (`id`),
  CONSTRAINT `main_booking_chk_1` CHECK ((`num_adults` >= 0)),
  CONSTRAINT `main_booking_chk_2` CHECK ((`num_children` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `main_booking`
--

LOCK TABLES `main_booking` WRITE;
/*!40000 ALTER TABLE `main_booking` DISABLE KEYS */;
/*!40000 ALTER TABLE `main_booking` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `main_category`
--

DROP TABLE IF EXISTS `main_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `main_category` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `slug` varchar(50) NOT NULL,
  `image` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `slug` (`slug`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `main_category`
--

LOCK TABLES `main_category` WRITE;
/*!40000 ALTER TABLE `main_category` DISABLE KEYS */;
INSERT INTO `main_category` VALUES (1,'Honeymoon','honeymoon',''),(2,'Adventure','adventure',''),(3,'Family','family',''),(4,'Weekend','weekend',''),(5,'Pilgrimage','pilgrimage','');
/*!40000 ALTER TABLE `main_category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `main_customuser`
--

DROP TABLE IF EXISTS `main_customuser`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `main_customuser` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `first_name` varchar(150) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  `email` varchar(254) NOT NULL,
  `phone_number` varchar(15) DEFAULT NULL,
  `role` varchar(20) NOT NULL,
  `profile_picture` varchar(100) DEFAULT NULL,
  `address` longtext NOT NULL,
  `city` varchar(100) NOT NULL,
  `loyalty_points` int unsigned NOT NULL,
  `is_email_verified` tinyint(1) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `phone_number` (`phone_number`),
  CONSTRAINT `main_customuser_chk_1` CHECK ((`loyalty_points` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `main_customuser`
--

LOCK TABLES `main_customuser` WRITE;
/*!40000 ALTER TABLE `main_customuser` DISABLE KEYS */;
INSERT INTO `main_customuser` VALUES (1,'pbkdf2_sha256$1200000$nrb2uc8LJknbBfJHIDgsBo$kO2Ax7pN3YoFy2vvf6H/ijRpMOclA/8Tp9twsD28B7w=','2026-05-10 05:22:01.594666',1,'','',1,1,'2026-05-09 08:30:25.188666','admin@poddar.com','1234567890','traveler','','','',0,0,'2026-05-09 08:30:27.949974'),(3,'pbkdf2_sha256$1200000$K2OUMfmI1OhFLY5XwwKWUv$Y0ZMFvjHnj+Wc7mj2GV67DfPj37y76Kjzi70mdD4DCQ=',NULL,0,'','',0,1,'2026-05-10 05:12:04.444255','test2@test.com','0987654321','traveler','','','',0,0,'2026-05-10 05:12:05.462452'),(4,'pbkdf2_sha256$1200000$Zpxzu1jQ4b1GcLh5EpYkYR$SFxfRoJgMvC4V5o26QPIXVY2yJA0JbhvNUGaEdBjObc=',NULL,0,'Admin','User',0,1,'2026-05-10 05:25:10.967989','admin@example.com','9999999991','traveler','','','',0,0,'2026-05-10 05:25:11.631995'),(5,'pbkdf2_sha256$1200000$x9f6iLt2VP0MQwLYa9VOWY$iTVftA8P4Okemd9WN206OUNxJpbMJ5pi/lBfd7+5SE0=',NULL,0,'John','Doe',0,1,'2026-05-10 05:25:11.651947','john@example.com','9999999992','traveler','','','',0,0,'2026-05-10 05:25:12.341215'),(6,'pbkdf2_sha256$1200000$lqJm8gw7Jt5U9jY4KVbYuU$Wlf5NWjx3idV1t3Kq5xDCsk7CWBij3L7uZPlbg0TmMI=',NULL,0,'Jane','Smith',0,1,'2026-05-10 05:25:12.375971','jane@example.com','9999999993','traveler','','','',0,0,'2026-05-10 05:25:13.005835');
/*!40000 ALTER TABLE `main_customuser` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `main_customuser_groups`
--

DROP TABLE IF EXISTS `main_customuser_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `main_customuser_groups` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `customuser_id` bigint NOT NULL,
  `group_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `main_customuser_groups_customuser_id_group_id_8a5023dd_uniq` (`customuser_id`,`group_id`),
  KEY `main_customuser_groups_group_id_8149f607_fk_auth_group_id` (`group_id`),
  CONSTRAINT `main_customuser_grou_customuser_id_13869e25_fk_main_cust` FOREIGN KEY (`customuser_id`) REFERENCES `main_customuser` (`id`),
  CONSTRAINT `main_customuser_groups_group_id_8149f607_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `main_customuser_groups`
--

LOCK TABLES `main_customuser_groups` WRITE;
/*!40000 ALTER TABLE `main_customuser_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `main_customuser_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `main_customuser_user_permissions`
--

DROP TABLE IF EXISTS `main_customuser_user_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `main_customuser_user_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `customuser_id` bigint NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `main_customuser_user_per_customuser_id_permission_06a652d8_uniq` (`customuser_id`,`permission_id`),
  KEY `main_customuser_user_permission_id_38e6f657_fk_auth_perm` (`permission_id`),
  CONSTRAINT `main_customuser_user_customuser_id_34d37f86_fk_main_cust` FOREIGN KEY (`customuser_id`) REFERENCES `main_customuser` (`id`),
  CONSTRAINT `main_customuser_user_permission_id_38e6f657_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `main_customuser_user_permissions`
--

LOCK TABLES `main_customuser_user_permissions` WRITE;
/*!40000 ALTER TABLE `main_customuser_user_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `main_customuser_user_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `main_enquiry`
--

DROP TABLE IF EXISTS `main_enquiry`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `main_enquiry` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `email` varchar(254) NOT NULL,
  `phone` varchar(15) NOT NULL,
  `message` longtext NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `tour_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `main_enquiry_tour_id_a4b91bd3_fk_main_tourpackage_id` (`tour_id`),
  CONSTRAINT `main_enquiry_tour_id_a4b91bd3_fk_main_tourpackage_id` FOREIGN KEY (`tour_id`) REFERENCES `main_tourpackage` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `main_enquiry`
--

LOCK TABLES `main_enquiry` WRITE;
/*!40000 ALTER TABLE `main_enquiry` DISABLE KEYS */;
/*!40000 ALTER TABLE `main_enquiry` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `main_newsletter`
--

DROP TABLE IF EXISTS `main_newsletter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `main_newsletter` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `email` varchar(254) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `subscribed_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `main_newsletter`
--

LOCK TABLES `main_newsletter` WRITE;
/*!40000 ALTER TABLE `main_newsletter` DISABLE KEYS */;
/*!40000 ALTER TABLE `main_newsletter` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `main_review`
--

DROP TABLE IF EXISTS `main_review`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `main_review` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `rating` int unsigned NOT NULL,
  `comment` longtext NOT NULL,
  `verified_purchase` tinyint(1) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `user_id` bigint NOT NULL,
  `tour_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `main_review_user_id_ee71ed52_fk_main_customuser_id` (`user_id`),
  KEY `main_review_tour_id_b3836459_fk_main_tourpackage_id` (`tour_id`),
  CONSTRAINT `main_review_tour_id_b3836459_fk_main_tourpackage_id` FOREIGN KEY (`tour_id`) REFERENCES `main_tourpackage` (`id`),
  CONSTRAINT `main_review_user_id_ee71ed52_fk_main_customuser_id` FOREIGN KEY (`user_id`) REFERENCES `main_customuser` (`id`),
  CONSTRAINT `main_review_chk_1` CHECK ((`rating` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `main_review`
--

LOCK TABLES `main_review` WRITE;
/*!40000 ALTER TABLE `main_review` DISABLE KEYS */;
INSERT INTO `main_review` VALUES (1,5,'Absolutely breathtaking experience! The arrangements were top-notch and the views were mesmerizing. Highly recommended!',1,'2026-05-10 05:25:13.017753',4,1),(2,5,'God\'s own country indeed. The houseboats were clean, and the food was amazing. Great package by Poddar Tours.',1,'2026-05-10 05:25:13.055528',5,2),(3,5,'A perfect getaway. Everything was smoothly handled from airport pickup to hotel stays. Couldn\'t ask for more.',1,'2026-05-10 05:25:13.062240',6,7),(4,5,'The adventure of a lifetime. The tour guides were very experienced and made sure we were safe the entire trip.',1,'2026-05-10 05:25:13.068014',5,8);
/*!40000 ALTER TABLE `main_review` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `main_tourgallery`
--

DROP TABLE IF EXISTS `main_tourgallery`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `main_tourgallery` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `image` varchar(100) NOT NULL,
  `caption` varchar(200) NOT NULL,
  `tour_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `main_tourgallery_tour_id_a79c238b_fk_main_tourpackage_id` (`tour_id`),
  CONSTRAINT `main_tourgallery_tour_id_a79c238b_fk_main_tourpackage_id` FOREIGN KEY (`tour_id`) REFERENCES `main_tourpackage` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `main_tourgallery`
--

LOCK TABLES `main_tourgallery` WRITE;
/*!40000 ALTER TABLE `main_tourgallery` DISABLE KEYS */;
/*!40000 ALTER TABLE `main_tourgallery` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `main_tourhighlight`
--

DROP TABLE IF EXISTS `main_tourhighlight`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `main_tourhighlight` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `text` varchar(200) NOT NULL,
  `tour_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `main_tourhighlight_tour_id_212d0864_fk_main_tourpackage_id` (`tour_id`),
  CONSTRAINT `main_tourhighlight_tour_id_212d0864_fk_main_tourpackage_id` FOREIGN KEY (`tour_id`) REFERENCES `main_tourpackage` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `main_tourhighlight`
--

LOCK TABLES `main_tourhighlight` WRITE;
/*!40000 ALTER TABLE `main_tourhighlight` DISABLE KEYS */;
INSERT INTO `main_tourhighlight` VALUES (1,'Dal Lake Shikara Ride',1),(2,'Luxury Houseboat Stay',1),(3,'Gulmarg Gondola Ride',1),(4,'Sonmarg & Pahalgam Tour',1),(5,'Mughal Gardens Visit',1),(6,'Premium Hotel Stay',1),(7,'Expert Tour Guide',1),(8,'Airport Pickup & Drop',1),(9,'Alleppey Houseboat Stay',2),(10,'Munnar Tea Garden Visit',2),(11,'Eravikulam National Park',2),(12,'Periyar Wildlife Tour',2),(13,'Kovalam Beach Visit',2),(14,'Cochin City Tour',2),(15,'Kathakali Dance Show',2),(16,'Premium Hotel Stay',2),(17,'Ooty Lake Boating',3),(18,'Botanical Garden Tour',3),(19,'Doddabetta Peak Visit',3),(20,'Coonoor Tea Garden',3),(21,'Nilgiri Mountain Railway',3),(22,'Pykara Lake & Falls',3),(23,'Premium Hotel Stay',3),(24,'Pickup & Drop',3),(25,'Golden Temple Visit',4),(26,'Wagah Border Ceremony',4),(27,'Jallianwala Bagh Tour',4),(28,'Premium Hotel Stay',4),(29,'Local Sightseeing',4),(30,'AC Transportation',4),(31,'Tea Garden Visit',5),(32,'Tiger Hill Sunrise',5),(33,'Batasia Loop',5),(34,'Toy Train Ride',5),(35,'Mall Road Shopping',5),(36,'Premium Hotel Stay',5),(37,'Local Sightseeing',5),(38,'Pickup & Drop',5),(39,'Shimla Mall Road & Kufri',6),(40,'Manali Local Sightseeing',6),(41,'Solang Valley (Snow Point)',6),(42,'Kullu Valley River Rafting',6),(43,'Hadimba Temple Visit',6),(44,'Rohtang Pass (Optional)',6),(45,'Premium Hotel Stay',6),(46,'Luxury Volvo/Car Transfers',6),(47,'North & South Goa Tour',7),(48,'8 Days / 7 Nights Stay',7),(49,'Famous Beach Visits',7),(50,'Heritage Church Tours',7),(51,'Daily Breakfast Included',7),(52,'All Local Transfers',7),(53,'Pangong Lake Visit',8),(54,'Nubra Valley & Sand Dunes',8),(55,'Khardung La Pass (Highest)',8),(56,'Chandrataal Lake Camping',8),(57,'Leh Local Sightseeing',8),(58,'Magnetic Hill Experience',8),(59,'Premium Hotel & Camp Stay',8),(60,'All Permits Included',8);
/*!40000 ALTER TABLE `main_tourhighlight` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `main_touritinerary`
--

DROP TABLE IF EXISTS `main_touritinerary`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `main_touritinerary` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `day_number` int unsigned NOT NULL,
  `title` varchar(200) NOT NULL,
  `description` longtext NOT NULL,
  `tour_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `main_touritinerary_tour_id_e1164e19_fk_main_tourpackage_id` (`tour_id`),
  CONSTRAINT `main_touritinerary_tour_id_e1164e19_fk_main_tourpackage_id` FOREIGN KEY (`tour_id`) REFERENCES `main_tourpackage` (`id`),
  CONSTRAINT `main_touritinerary_chk_1` CHECK ((`day_number` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `main_touritinerary`
--

LOCK TABLES `main_touritinerary` WRITE;
/*!40000 ALTER TABLE `main_touritinerary` DISABLE KEYS */;
/*!40000 ALTER TABLE `main_touritinerary` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `main_tourpackage`
--

DROP TABLE IF EXISTS `main_tourpackage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `main_tourpackage` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `title` varchar(200) NOT NULL,
  `slug` varchar(50) NOT NULL,
  `duration` varchar(100) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `discount_price` decimal(10,2) DEFAULT NULL,
  `short_description` longtext NOT NULL,
  `full_description` longtext NOT NULL,
  `image` varchar(100) NOT NULL,
  `is_featured` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `slug` (`slug`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `main_tourpackage`
--

LOCK TABLES `main_tourpackage` WRITE;
/*!40000 ALTER TABLE `main_tourpackage` DISABLE KEYS */;
INSERT INTO `main_tourpackage` VALUES (1,'KASHMIR: PARADISE ON EARTH','kashmir','7 Days / 6 Nights',24999.00,NULL,'Snow-capped peaks and serene valleys await you in the heart of the Himalayas.','Kashmir is one of the most beautiful regions in India, often called <b>“Paradise on Earth”</b>. It is famous for its scenic valleys, snow-capped mountains, Dal Lake, and rich cultural heritage. Experience the serenity of a Houseboat stay and the thrill of a Gondola ride in Gulmarg.','tours/kash2.jpg',1,1,'2026-05-09 08:31:06.271499'),(2,'KERALA: GOD\'S OWN COUNTRY','kerala','6 Days / 5 Nights',19999.00,NULL,'Peaceful lagoons and lush palm groves in God’s own country.','Kerala is famous for its serene backwaters, lush green landscapes, Ayurvedic therapies, and peaceful beaches. It\'s a sanctuary for nature lovers. Experience the magic of Alleppey\'s houseboats and the cool mist of Munnar\'s tea gardens.','tours/kerala.jpeg',1,1,'2026-05-09 08:31:06.363598'),(3,'OOTY: QUEEN OF HILL STATIONS','ooty','4 Days / 3 Nights',12999.00,NULL,'Escape to the cool blue mountains for a refreshing break in nature.','Ooty, located in the Nilgiri Hills, is famous for its pleasant climate, vast tea gardens, and peaceful atmosphere. It is the perfect escape for nature lovers and families seeking tranquility. Experience the charm of the Nilgiri Mountain Railway and the beauty of Pykara Lake.','tours/ooty.jpg',0,1,'2026-05-09 08:31:06.417882'),(4,'AMRITSAR TOUR PACKAGE','amritsar','3 Days / 2 Nights',8999.00,NULL,'A journey of soul and culture at the iconic Golden Temple.','Explore the spiritual heart of Punjab. Amritsar, home to the iconic Golden Temple, offers a profound blend of devotion, history, and vibrant culture. Experience the stunning Wagah Border ceremony and witness the rich heritage of Jallianwala Bagh.','tours/Amritsar.jpg',0,1,'2026-05-09 08:31:06.476335'),(5,'DARJEELING TOUR PACKAGE','darjeeling','5 Days / 4 Nights',15999.00,NULL,'Wake up to the majestic Kanchenjunga and rolling tea gardens.','Darjeeling is a charming hill station known for its lush tea gardens, cool climate, and stunning views of the Kanchenjunga range. It offers a perfect blend of nature, heritage, and peace. Experience the magical sunrise at Tiger Hill and a ride on the iconic Himalayan Toy Train.','tours/dd.jpeg',0,1,'2026-05-09 08:31:06.520571'),(6,'SHIMLA–KULLU–MANALI (11 DAYS)','shimla-kullu-manali','11 Days / 10 Nights',34999.00,NULL,'Adventure and heritage combined in these stunning mountain escapes.','This comprehensive 11-day tour offers a perfect blend of hill station charm, scenic valleys, snow-capped mountains, and cultural experiences. Ideal for families, couples, and nature enthusiasts seeking the best of the Himalayas.','tours/shimla-manali-tour1.png',0,1,'2026-05-09 08:31:06.648233'),(7,'GOA TOUR PACKAGE (8 DAYS)','goa','8 Days / 7 Nights',22999.00,NULL,'Relax on world-class beaches and experience the vibrant Goan spirit.','Experience the vibrant beaches, nightlife, Portuguese heritage, and scenic coastline of Goa with this relaxing 8-day tour package. Perfect for couples, friends, and family vacations. Relax, party, and discover the soul of the coast.','tours/Places-to-Visit-in-South-Goa-1024x683.webp',1,1,'2026-05-09 08:31:06.823085'),(8,'LADAKH & CHANDRATAAL ADVENTURE','ladakh','9 Days / 8 Nights',39999.00,NULL,'Unearth the wild beauty of high passes and crystal-clear lakes.','Explore the breathtaking landscapes of Ladakh along with the magical Chandrataal Lake on this adventurous 10-day journey. Experience high mountain passes, ancient monasteries, white deserts, crystal lakes, and the resilient Himalayan culture.','tours/2019102967.jpg',0,1,'2026-05-09 08:31:06.852845');
/*!40000 ALTER TABLE `main_tourpackage` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `main_tourpackage_categories`
--

DROP TABLE IF EXISTS `main_tourpackage_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `main_tourpackage_categories` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `tourpackage_id` bigint NOT NULL,
  `category_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `main_tourpackage_categor_tourpackage_id_category__4d5c5e12_uniq` (`tourpackage_id`,`category_id`),
  KEY `main_tourpackage_cat_category_id_8ddf5898_fk_main_cate` (`category_id`),
  CONSTRAINT `main_tourpackage_cat_category_id_8ddf5898_fk_main_cate` FOREIGN KEY (`category_id`) REFERENCES `main_category` (`id`),
  CONSTRAINT `main_tourpackage_cat_tourpackage_id_f5252d90_fk_main_tour` FOREIGN KEY (`tourpackage_id`) REFERENCES `main_tourpackage` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `main_tourpackage_categories`
--

LOCK TABLES `main_tourpackage_categories` WRITE;
/*!40000 ALTER TABLE `main_tourpackage_categories` DISABLE KEYS */;
INSERT INTO `main_tourpackage_categories` VALUES (1,1,1),(2,1,3),(3,2,1),(4,2,3),(6,3,3),(5,3,4),(8,4,3),(7,4,5),(10,5,3),(9,5,4),(12,6,1),(11,6,2),(14,7,2),(13,7,4),(15,8,2);
/*!40000 ALTER TABLE `main_tourpackage_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `main_tourrule`
--

DROP TABLE IF EXISTS `main_tourrule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `main_tourrule` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `text` varchar(500) NOT NULL,
  `tour_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `main_tourrule_tour_id_bc55dca3_fk_main_tourpackage_id` (`tour_id`),
  CONSTRAINT `main_tourrule_tour_id_bc55dca3_fk_main_tourpackage_id` FOREIGN KEY (`tour_id`) REFERENCES `main_tourpackage` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `main_tourrule`
--

LOCK TABLES `main_tourrule` WRITE;
/*!40000 ALTER TABLE `main_tourrule` DISABLE KEYS */;
INSERT INTO `main_tourrule` VALUES (1,'Valid ID proof (Aadhar Card/Voter ID) is mandatory for all travelers.',1),(2,'Smoking and alcohol consumption are strictly prohibited during transit.',1),(3,'Please maintain the decorum and silence in religious and heritage sites.',1),(4,'Follow the tour guide\'s instructions for a safe and enjoyable experience.',1),(5,'Any personal expenses or activities not in the itinerary will be extra.',1),(6,'Punctuality is essential for the smooth operation of the group tour.',1),(7,'Carry heavy woolens, gloves, and caps even in summer for high-altitude areas.',1),(8,'Prepaid SIM cards from other states do not work in J&K; only postpaid works.',1),(9,'Valid ID proof (Aadhar Card/Voter ID) is mandatory for all travelers.',2),(10,'Smoking and alcohol consumption are strictly prohibited during transit.',2),(11,'Please maintain the decorum and silence in religious and heritage sites.',2),(12,'Follow the tour guide\'s instructions for a safe and enjoyable experience.',2),(13,'Any personal expenses or activities not in the itinerary will be extra.',2),(14,'Punctuality is essential for the smooth operation of the group tour.',2),(15,'Follow the traditional dress code when visiting the Padmanabhaswamy Temple.',2),(16,'Use eco-friendly bags; Kerala is a plastic-free zone in many areas.',2),(17,'Valid ID proof (Aadhar Card/Voter ID) is mandatory for all travelers.',3),(18,'Smoking and alcohol consumption are strictly prohibited during transit.',3),(19,'Please maintain the decorum and silence in religious and heritage sites.',3),(20,'Follow the tour guide\'s instructions for a safe and enjoyable experience.',3),(21,'Any personal expenses or activities not in the itinerary will be extra.',3),(22,'Punctuality is essential for the smooth operation of the group tour.',3),(23,'Valid ID proof (Aadhar Card/Voter ID) is mandatory for all travelers.',4),(24,'Smoking and alcohol consumption are strictly prohibited during transit.',4),(25,'Please maintain the decorum and silence in religious and heritage sites.',4),(26,'Follow the tour guide\'s instructions for a safe and enjoyable experience.',4),(27,'Any personal expenses or activities not in the itinerary will be extra.',4),(28,'Punctuality is essential for the smooth operation of the group tour.',4),(29,'Keep your head covered with a scarf or handkerchief inside the Golden Temple.',4),(30,'Remove shoes and wash hands/feet before entering the temple complex.',4),(31,'Valid ID proof (Aadhar Card/Voter ID) is mandatory for all travelers.',5),(32,'Smoking and alcohol consumption are strictly prohibited during transit.',5),(33,'Please maintain the decorum and silence in religious and heritage sites.',5),(34,'Follow the tour guide\'s instructions for a safe and enjoyable experience.',5),(35,'Any personal expenses or activities not in the itinerary will be extra.',5),(36,'Punctuality is essential for the smooth operation of the group tour.',5),(37,'Be prepared for sudden weather changes and carry a light umbrella/raincoat.',5),(38,'Respect the local tea garden workers and avoid plucking tea leaves.',5),(39,'Valid ID proof (Aadhar Card/Voter ID) is mandatory for all travelers.',6),(40,'Smoking and alcohol consumption are strictly prohibited during transit.',6),(41,'Please maintain the decorum and silence in religious and heritage sites.',6),(42,'Follow the tour guide\'s instructions for a safe and enjoyable experience.',6),(43,'Any personal expenses or activities not in the itinerary will be extra.',6),(44,'Punctuality is essential for the smooth operation of the group tour.',6),(45,'Valid ID proof (Aadhar Card/Voter ID) is mandatory for all travelers.',7),(46,'Smoking and alcohol consumption are strictly prohibited during transit.',7),(47,'Please maintain the decorum and silence in religious and heritage sites.',7),(48,'Follow the tour guide\'s instructions for a safe and enjoyable experience.',7),(49,'Any personal expenses or activities not in the itinerary will be extra.',7),(50,'Punctuality is essential for the smooth operation of the group tour.',7),(51,'Avoid swimming in the sea during high tide or after sunset.',7),(52,'Wear sunscreen and keep yourself hydrated throughout the day.',7),(53,'Valid ID proof (Aadhar Card/Voter ID) is mandatory for all travelers.',8),(54,'Smoking and alcohol consumption are strictly prohibited during transit.',8),(55,'Please maintain the decorum and silence in religious and heritage sites.',8),(56,'Follow the tour guide\'s instructions for a safe and enjoyable experience.',8),(57,'Any personal expenses or activities not in the itinerary will be extra.',8),(58,'Punctuality is essential for the smooth operation of the group tour.',8),(59,'First 24-48 hours of complete rest is mandatory for acclimatization.',8),(60,'Carry personal oxygen cylinders if you have respiratory issues.',8);
/*!40000 ALTER TABLE `main_tourrule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `socialaccount_socialaccount`
--

DROP TABLE IF EXISTS `socialaccount_socialaccount`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `socialaccount_socialaccount` (
  `id` int NOT NULL AUTO_INCREMENT,
  `provider` varchar(200) NOT NULL,
  `uid` varchar(191) NOT NULL,
  `last_login` datetime(6) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  `extra_data` json NOT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `socialaccount_socialaccount_provider_uid_fc810c6e_uniq` (`provider`,`uid`),
  KEY `socialaccount_social_user_id_8146e70c_fk_main_cust` (`user_id`),
  CONSTRAINT `socialaccount_social_user_id_8146e70c_fk_main_cust` FOREIGN KEY (`user_id`) REFERENCES `main_customuser` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `socialaccount_socialaccount`
--

LOCK TABLES `socialaccount_socialaccount` WRITE;
/*!40000 ALTER TABLE `socialaccount_socialaccount` DISABLE KEYS */;
/*!40000 ALTER TABLE `socialaccount_socialaccount` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `socialaccount_socialapp`
--

DROP TABLE IF EXISTS `socialaccount_socialapp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `socialaccount_socialapp` (
  `id` int NOT NULL AUTO_INCREMENT,
  `provider` varchar(30) NOT NULL,
  `name` varchar(40) NOT NULL,
  `client_id` varchar(191) NOT NULL,
  `secret` varchar(191) NOT NULL,
  `key` varchar(191) NOT NULL,
  `provider_id` varchar(200) NOT NULL,
  `settings` json NOT NULL DEFAULT (_utf8mb4'{}'),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `socialaccount_socialapp`
--

LOCK TABLES `socialaccount_socialapp` WRITE;
/*!40000 ALTER TABLE `socialaccount_socialapp` DISABLE KEYS */;
/*!40000 ALTER TABLE `socialaccount_socialapp` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `socialaccount_socialapp_sites`
--

DROP TABLE IF EXISTS `socialaccount_socialapp_sites`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `socialaccount_socialapp_sites` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `socialapp_id` int NOT NULL,
  `site_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `socialaccount_socialapp_sites_socialapp_id_site_id_71a9a768_uniq` (`socialapp_id`,`site_id`),
  KEY `socialaccount_socialapp_sites_site_id_2579dee5_fk_django_site_id` (`site_id`),
  CONSTRAINT `socialaccount_social_socialapp_id_97fb6e7d_fk_socialacc` FOREIGN KEY (`socialapp_id`) REFERENCES `socialaccount_socialapp` (`id`),
  CONSTRAINT `socialaccount_socialapp_sites_site_id_2579dee5_fk_django_site_id` FOREIGN KEY (`site_id`) REFERENCES `django_site` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `socialaccount_socialapp_sites`
--

LOCK TABLES `socialaccount_socialapp_sites` WRITE;
/*!40000 ALTER TABLE `socialaccount_socialapp_sites` DISABLE KEYS */;
/*!40000 ALTER TABLE `socialaccount_socialapp_sites` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `socialaccount_socialtoken`
--

DROP TABLE IF EXISTS `socialaccount_socialtoken`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `socialaccount_socialtoken` (
  `id` int NOT NULL AUTO_INCREMENT,
  `token` longtext NOT NULL,
  `token_secret` longtext NOT NULL,
  `expires_at` datetime(6) DEFAULT NULL,
  `account_id` int NOT NULL,
  `app_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `socialaccount_socialtoken_app_id_account_id_fca4e0ac_uniq` (`app_id`,`account_id`),
  KEY `socialaccount_social_account_id_951f210e_fk_socialacc` (`account_id`),
  CONSTRAINT `socialaccount_social_account_id_951f210e_fk_socialacc` FOREIGN KEY (`account_id`) REFERENCES `socialaccount_socialaccount` (`id`),
  CONSTRAINT `socialaccount_social_app_id_636a42d7_fk_socialacc` FOREIGN KEY (`app_id`) REFERENCES `socialaccount_socialapp` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `socialaccount_socialtoken`
--

LOCK TABLES `socialaccount_socialtoken` WRITE;
/*!40000 ALTER TABLE `socialaccount_socialtoken` DISABLE KEYS */;
/*!40000 ALTER TABLE `socialaccount_socialtoken` ENABLE KEYS */;
UNLOCK TABLES;
SET @@SESSION.SQL_LOG_BIN = @MYSQLDUMP_TEMP_LOG_BIN;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-05-10 12:55:07
