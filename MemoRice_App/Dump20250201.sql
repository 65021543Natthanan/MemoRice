-- MySQL dump 10.13  Distrib 8.0.40, for Win64 (x86_64)
--
-- Host: localhost    Database: flutter_auth
-- ------------------------------------------------------
-- Server version	8.0.40

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `albumnotes`
--

DROP TABLE IF EXISTS `albumnotes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `albumnotes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `albumId` int NOT NULL,
  `noteName` varchar(255) NOT NULL,
  `plantingDate` date DEFAULT NULL,
  `eventDate` date DEFAULT NULL,
  `riceVariety` varchar(255) DEFAULT NULL,
  `temperature` float DEFAULT NULL,
  `humidity` float DEFAULT NULL,
  `rainfall` float DEFAULT NULL,
  `symptoms` text,
  `additionalNotes` text,
  `createdAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `albumId` (`albumId`),
  CONSTRAINT `albumnotes_ibfk_1` FOREIGN KEY (`albumId`) REFERENCES `albums` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `albumnotes`
--

LOCK TABLES `albumnotes` WRITE;
/*!40000 ALTER TABLE `albumnotes` DISABLE KEYS */;
INSERT INTO `albumnotes` VALUES (5,1,'Updated note Name','2023-02-01','2023-02-10','OIIAIIO',32,75,120,'Minor issues','Update test notes','2025-01-20 05:51:47'),(7,3,'yyyyy','2546-01-01','2547-02-02','thji',258,8965,5965,'rghjggg','6fgbj','2025-01-20 06:42:51'),(8,5,'New Albumnote','1999-05-01','1998-05-01','ryufjfkfkf',5634660,135695,165656,'eyydjfjfjfjfjf','yrhfjgjgjghf','2025-01-20 12:07:50'),(9,9,'ยันทึกนาB','2456-04-30','2456-09-04','หอมมะลิ',55,55,58,'ป่วย','ง่วงซึม','2025-01-21 07:36:30'),(10,12,'ใบสีแสด','2566-12-03','2567-06-01','หอมมะลิ',25,55,66,'ใบสีแสด','แห้ง','2025-02-01 09:32:35');
/*!40000 ALTER TABLE `albumnotes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `albums`
--

DROP TABLE IF EXISTS `albums`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `albums` (
  `id` int NOT NULL AUTO_INCREMENT,
  `farmId` int NOT NULL,
  `userId` int NOT NULL,
  `albumName` varchar(255) NOT NULL,
  `isDeleted` tinyint(1) DEFAULT '0',
  `createdAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `farmId` (`farmId`),
  KEY `userId` (`userId`),
  CONSTRAINT `albums_ibfk_1` FOREIGN KEY (`farmId`) REFERENCES `farms` (`id`),
  CONSTRAINT `albums_ibfk_2` FOREIGN KEY (`userId`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `albums`
--

LOCK TABLES `albums` WRITE;
/*!40000 ALTER TABLE `albums` DISABLE KEYS */;
INSERT INTO `albums` VALUES (1,11,19,'New Album',0,'2025-01-19 17:05:12'),(2,11,19,'ttt',1,'2025-01-19 17:06:30'),(3,11,19,'ploy',0,'2025-01-20 06:08:32'),(4,11,19,'owen',0,'2025-01-20 09:26:22'),(5,12,18,'New Album',0,'2025-01-20 10:55:10'),(6,19,21,'นา',0,'2025-01-20 12:23:56'),(7,20,22,'อัลบั้มA',0,'2025-01-20 13:02:35'),(8,21,23,'ใบจุดน้ำตาล',0,'2025-01-20 14:49:54'),(9,22,22,'อัลบั้มนาB',0,'2025-01-21 07:33:33'),(10,23,19,'ใบจุดน้ำตาล',1,'2025-02-01 09:04:09'),(11,23,19,'11',1,'2025-02-01 09:04:22'),(12,23,19,'ใบสีแสด',0,'2025-02-01 09:22:44');
/*!40000 ALTER TABLE `albums` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `farms`
--

DROP TABLE IF EXISTS `farms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `farms` (
  `id` int NOT NULL AUTO_INCREMENT,
  `userId` int DEFAULT NULL,
  `farmName` varchar(255) DEFAULT NULL,
  `x` float DEFAULT NULL,
  `y` float DEFAULT NULL,
  `area` varchar(255) DEFAULT NULL,
  `createdAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `isDeleted` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `userId` (`userId`),
  CONSTRAINT `farms_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `farms`
--

LOCK TABLES `farms` WRITE;
/*!40000 ALTER TABLE `farms` DISABLE KEYS */;
INSERT INTO `farms` VALUES (2,20,'Farm A',12.3456,98.7654,'10.5','2025-01-18 11:56:32',0),(3,19,'จิรา',15,289.467,'100 ไร่ 10 งาน 1ตารางวา','2025-01-18 12:10:39',1),(4,20,'แปลง2',555,777,'77','2025-01-18 12:14:34',0),(5,20,'แปลง3',345,245,'10 ไร่','2025-01-18 12:16:30',0),(6,19,'444',444,444,'444','2025-01-18 12:27:08',1),(7,19,'ff',13455,1345,'13445','2025-01-18 12:28:41',1),(8,19,'hhh',153663,153636,'256363','2025-01-18 12:35:40',1),(9,19,'ygg',456,455,'3456','2025-01-18 12:36:19',1),(10,19,'111',111,111,'111','2025-01-18 12:36:30',1),(11,19,'777',666,666,'666','2025-01-18 14:45:46',1),(12,18,'natt',455,466,'100 ไร่','2025-01-20 10:02:07',0),(13,18,'ploy',6337,6337,'90ไร่','2025-01-20 10:02:21',0),(14,18,'ลลล',0,0,'','2025-01-20 10:02:39',0),(15,18,'นรรน',0,0,'','2025-01-20 10:02:42',0),(16,18,'านกก',0,0,'','2025-01-20 10:02:47',0),(17,18,'ดาดสเ',0,0,'','2025-01-20 10:02:51',1),(18,21,'p',23,21,'4ไร่','2025-01-20 12:17:20',1),(19,21,'pp',14,57,'5ไร่','2025-01-20 12:18:55',0),(20,22,'นา',14.25,20.95,'10ไร่ 2 งาน 39 ตารางวา','2025-01-20 13:00:55',0),(21,23,'แปลง1',77654600,8665,'1 ไร่','2025-01-20 14:49:20',0),(22,22,'แปลง D',23,45,'10ไร่','2025-01-21 07:30:32',0),(23,19,'แปลง1',1234,4321,'10ไร่','2025-02-01 08:46:09',0);
/*!40000 ALTER TABLE `farms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notes`
--

DROP TABLE IF EXISTS `notes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `farmId` int NOT NULL,
  `userId` int NOT NULL,
  `noteName` varchar(255) NOT NULL,
  `plantedDate` date DEFAULT NULL,
  `eventDate` date DEFAULT NULL,
  `riceType` varchar(255) DEFAULT NULL,
  `temperature` float DEFAULT NULL,
  `humidity` float DEFAULT NULL,
  `rainfall` float DEFAULT NULL,
  `symptoms` text,
  `additionalNotes` text,
  `isDeleted` tinyint(1) DEFAULT '0',
  `createdAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `farmId` (`farmId`),
  KEY `userId` (`userId`),
  CONSTRAINT `notes_ibfk_1` FOREIGN KEY (`farmId`) REFERENCES `farms` (`id`),
  CONSTRAINT `notes_ibfk_2` FOREIGN KEY (`userId`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notes`
--

LOCK TABLES `notes` WRITE;
/*!40000 ALTER TABLE `notes` DISABLE KEYS */;
INSERT INTO `notes` VALUES (1,11,19,'BB Note',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'2025-01-19 10:24:10'),(2,11,19,'AA Note','2025-01-19','2025-01-20','จัสมิน',30.5,70.5,120,'ไม่มีอาการ','บันทึกเพิ่มเติม',0,'2025-01-19 10:26:30'),(3,11,19,'go note','2546-09-22','2548-06-04','baba',2258,2885,458,'edggjh','rchhu',0,'2025-01-19 10:33:46'),(4,11,19,'rey','2546-01-01',NULL,'',NULL,NULL,NULL,'','',0,'2025-01-19 13:47:00'),(5,12,18,'New Note','2003-12-29','2003-06-09','durjfjf',326595,136595,26556,'eydhjffj','rudyfhfjfj',0,'2025-01-20 10:54:48'),(6,12,18,'New Note2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'2025-01-20 10:56:24'),(7,12,18,'New Note3',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'2025-01-20 11:03:46'),(8,19,21,'นา','2025-01-20','2025-04-06','ข้าวเหนียว',23,23,250,'-','_',0,'2025-01-20 12:19:21'),(9,20,22,'บันทึกA',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'2025-01-20 13:02:15'),(10,21,23,'โรคไหม้','2568-12-12','2568-12-09','กข6',23,23,66,'ไหม้หลายจุดสกาก่กากสก่ด้ดาสกสหาก่กากสหสกาหากากกสหสหาีเเเกห้าสบยสวสสาาากาากสกสห','สหาก่หสห่ก่ห่ด้กาก่ก่ก่ด้กาสกาก่ก่กาก่ก่ากากากากากาหาากากากาก้ปกเ',0,'2025-01-20 14:49:37'),(11,21,23,'ใบแดง',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'2025-01-20 14:53:48'),(12,22,22,'ใบส้ม','2546-09-13','2548-02-26','บาสมาติ',26,25,25,'ใบสีส้ม','ง่วง',0,'2025-01-21 07:31:05'),(13,23,19,'โรคไหม้ในข้าว','2546-09-26','2548-02-08','กข.2',35,55,46,'ใบไหม้','เป็นวงกว้าง',0,'2025-02-01 08:47:07'),(14,23,19,'โรคไหม้ในข้าว',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'2025-02-01 08:47:08');
/*!40000 ALTER TABLE `notes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `photos`
--

DROP TABLE IF EXISTS `photos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `photos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `album_id` int NOT NULL,
  `url` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `album_id` (`album_id`),
  CONSTRAINT `photos_ibfk_1` FOREIGN KEY (`album_id`) REFERENCES `albums` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `photos`
--

LOCK TABLES `photos` WRITE;
/*!40000 ALTER TABLE `photos` DISABLE KEYS */;
INSERT INTO `photos` VALUES (2,1,'http://192.168.83.50:3000/uploads/1737346526410.png'),(5,5,'http://192.168.83.50:3000/uploads/1737373011833.jpg'),(7,5,'http://192.168.83.50:3000/uploads/1737373401561.jpg'),(8,5,'http://192.168.83.50:3000/uploads/1737373408484.jpg'),(9,5,'http://192.168.83.50:3000/uploads/1737373430418.jpg'),(10,5,'http://192.168.83.50:3000/uploads/1737373439138.jpg'),(11,5,'http://192.168.83.50:3000/uploads/1737373445728.jpg'),(22,8,'http://192.168.83.50:3000/uploads/1737384786534.jpg'),(23,1,'http://192.168.83.50:3000/uploads/1737387876087.jpg'),(24,1,'http://192.168.83.50:3000/uploads/1737387895860.jpg'),(25,9,'http://192.168.83.50:3000/uploads/1737444851270.jpg'),(26,9,'http://192.168.83.50:3000/uploads/1737444855534.jpg'),(28,10,'http://192.168.83.50:3000/uploads/1738400708323.jpg'),(29,10,'http://192.168.83.50:3000/uploads/1738400721484.jpg'),(30,10,'http://192.168.83.50:3000/uploads/1738400725134.jpg'),(31,10,'http://192.168.83.50:3000/uploads/1738400727999.jpg'),(32,10,'http://192.168.83.50:3000/uploads/1738400769315.jpg'),(34,12,'http://192.168.139.50:3000/uploads/1738401943640.jpg'),(36,10,'http://192.168.139.50:3000/uploads/1738402033042.jpg'),(37,10,'http://192.168.139.50:3000/uploads/1738402036742.jpg'),(38,10,'http://192.168.139.50:3000/uploads/1738402039325.jpg'),(39,10,'http://192.168.139.50:3000/uploads/1738402043092.jpg'),(40,10,'http://192.168.139.50:3000/uploads/1738402048963.jpg');
/*!40000 ALTER TABLE `photos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'testuser','testuser@example.com','$2a$10$xqazOhmAr.6/5.ttbluddOh9FZXf3TaqGGLoz0sGSN7Z8G3LFHkEG'),(4,'testuserr','testuserr@example.com','$2a$10$KQK0QbhVtdNAyNhdK6Zubealj8P47sZA/ovAurMsxYmU3mY.rrDt6'),(7,'nattt','nattt26946@gmail.con','$2a$10$/EPwN1FYMMFg97a9s0/lSeASeg9tr/Q.RpXqYYkcF9qs/l.RDY/e6'),(8,'hhh','hhh@gmail.com','$2a$10$JkhB/XvZs2F8mE8FBwINr.5J4sLJF6XrXIjp62ib94yAzE58.AG2O'),(9,'nnn','nnn@gmail.com','$2a$10$ZW2wyuFwf3l/odCQxAqGJOFImDgVuEemJpPPPRWIhAt3t7RVo2LUC'),(10,'ning','hsningkrittima@gmail.com','$2a$10$Vgv3FjL4gvghJSghvtyozelCXpg9RK..S65SyAJe5.hokeeUPpURa'),(11,'nnnnnnnnnn','krittimaning2546@gmail.com','$2a$10$6moIuBK4wxSUxRX.IStwK.DgzajSkBW/PsTjZmdOgMHWQ9ddr1O3W'),(12,'jjj','jjj@gmail.com','$2a$10$/FZCrDZqNx2c0gb1z7qfIucS7RuPdutjh334A3c1g6i1b7v9olhYi'),(13,'kkk','kkk@gmail.com','$2a$10$.lxijTYhN/KhvFUFDBcVXOW6IWWGJ0fHafqNTmiJRRsfe3plzCQdm'),(18,'nat','nat26946@gmail.com','$2a$10$09Kj12elAiJ4tyRrYrNg6OO6kA3DDEX7x8LJumKIYDzpOHnRtYMCS'),(19,'ooo','ooo@gmail.com','$2a$10$tNyf2AjEKpED/rJ1zeu18e9sP9JJc1XnHuJP3Y7PduZGdkUabL9Em'),(20,'userA','userA@example.com','$2a$10$ZlZfNbetLynYb4ecRqZXceL/7iPuwvjf7enucXQhsuT.b7OXm/AKm'),(21,'ploy','65024759.up.ac.th','$2a$10$DRhwAIPRgOQWhWDv4HRYxOFIeLbunCV9jNT6lPAujfu1aciQgbMAW'),(22,'nat','nat@gmail.com','$2a$10$bIWXQPifIgB2PiRxVBFA8eEX2ocRPEcCT9yBld/NgHAd84bI6nXUa'),(23,'หนิงหนิง','ningning@gmail.com','$2a$10$wt1.IqhB1/rbGtHAUc0zReupF.v.eO7.tp1V0EECO2WlIgHagYFBm');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-02-01 17:57:07
