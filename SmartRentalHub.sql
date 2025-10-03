-- MySQL dump 10.13  Distrib 8.0.43, for Win64 (x86_64)
--
-- Host: localhost    Database: smartrentalhub
-- ------------------------------------------------------
-- Server version	8.0.43

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
-- Table structure for table `abuse_reports`
--

DROP TABLE IF EXISTS `abuse_reports`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `abuse_reports` (
  `id` int NOT NULL AUTO_INCREMENT,
  `target_type` enum('user','property','post') NOT NULL,
  `target_id` int NOT NULL,
  `reporter` varchar(50) NOT NULL,
  `notes` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_once_per_post` (`target_type`,`target_id`,`reporter`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `abuse_reports`
--

LOCK TABLES `abuse_reports` WRITE;
/*!40000 ALTER TABLE `abuse_reports` DISABLE KEYS */;
INSERT INTO `abuse_reports` VALUES (1,'post',9,'kavindya_avd','Offensive content','2025-09-18 15:44:30'),(2,'post',11,'jennie','Hate speech','2025-09-18 15:48:53'),(3,'post',9,'jennie','Promoting illegal activity','2025-09-18 15:50:53');
/*!40000 ALTER TABLE `abuse_reports` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `community_comments`
--

DROP TABLE IF EXISTS `community_comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `community_comments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `post_id` int NOT NULL,
  `username` varchar(50) NOT NULL,
  `comment` text NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `post_id` (`post_id`),
  CONSTRAINT `community_comments_ibfk_1` FOREIGN KEY (`post_id`) REFERENCES `community_posts` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `community_comments`
--

LOCK TABLES `community_comments` WRITE;
/*!40000 ALTER TABLE `community_comments` DISABLE KEYS */;
INSERT INTO `community_comments` VALUES (1,2,'beebuu','qwerth','2025-08-27 06:41:20'),(2,4,'gothami','Furnished! Saves me the hassle.','2025-09-18 15:19:42'),(3,5,'kaveesha','My plants!','2025-09-18 15:24:12'),(4,4,'kaveesha','Furnished! Saves me the hassle.','2025-09-18 15:24:29'),(5,6,'senuri','Spacious, Affordable, Bright','2025-09-18 15:27:23'),(6,5,'senuri','Friendly neighbors.','2025-09-18 15:27:49'),(7,4,'senuri','Furnished for short-term, unfurnished for long-term.','2025-09-18 15:28:04'),(8,7,'tharudini_uththama','Scams and fake ads online.','2025-09-18 15:31:34'),(9,6,'tharudini_uththama','Modern, Safe, Connected','2025-09-18 15:32:02'),(10,5,'tharudini_uththama','Cozy corner with books & coffee.','2025-09-18 15:32:20'),(11,4,'tharudini_uththama','Only if it has appliances included.','2025-09-18 15:32:38'),(12,9,'kavindya_avd','That’s illegal ?','2025-09-18 15:38:56'),(13,8,'kavindya_avd','Central saves time.','2025-09-18 15:41:20'),(14,7,'kavindya_avd','Places rented out too quickly.','2025-09-18 15:41:40'),(15,8,'kavindya_avd','Shared! Meet new people.','2025-09-18 15:42:05'),(16,6,'kavindya_avd','Location, Location, Location','2025-09-18 15:42:22'),(17,5,'kavindya_avd','Freedom to decorate walls.','2025-09-18 15:42:52'),(18,4,'kavindya_avd','Unfurnished. Love decorating myself.','2025-09-18 15:43:05'),(19,11,'jennie','Don’t even think about it ?','2025-09-18 15:48:17'),(20,12,'gothami','Personal items & memories.','2025-09-18 15:52:04');
/*!40000 ALTER TABLE `community_comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `community_post_likes`
--

DROP TABLE IF EXISTS `community_post_likes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `community_post_likes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `post_id` int NOT NULL,
  `username` varchar(50) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_like` (`post_id`,`username`),
  CONSTRAINT `community_post_likes_ibfk_1` FOREIGN KEY (`post_id`) REFERENCES `community_posts` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `community_post_likes`
--

LOCK TABLES `community_post_likes` WRITE;
/*!40000 ALTER TABLE `community_post_likes` DISABLE KEYS */;
INSERT INTO `community_post_likes` VALUES (1,1,'samre','2025-08-17 12:35:57'),(2,2,'beebuu','2025-08-27 06:41:22'),(3,4,'gothami','2025-09-18 15:18:42'),(4,3,'gothami','2025-09-18 15:18:44'),(5,5,'kaveesha','2025-09-18 15:24:13'),(6,4,'kaveesha','2025-09-18 15:24:31'),(7,6,'kaveesha','2025-09-18 15:24:37'),(8,7,'senuri','2025-09-18 15:26:56'),(9,6,'senuri','2025-09-18 15:27:25'),(10,5,'senuri','2025-09-18 15:27:32'),(11,4,'senuri','2025-09-18 15:28:06'),(12,8,'tharudini_uththama','2025-09-18 15:30:58'),(13,6,'tharudini_uththama','2025-09-18 15:31:39'),(14,4,'tharudini_uththama','2025-09-18 15:32:23'),(15,5,'tharudini_uththama','2025-09-18 15:32:42'),(16,7,'tharudini_uththama','2025-09-18 15:32:46'),(17,10,'kavindya_avd','2025-09-18 15:37:57'),(18,9,'kavindya_avd','2025-09-18 15:38:03'),(19,8,'kavindya_avd','2025-09-18 15:41:04'),(20,7,'kavindya_avd','2025-09-18 15:41:24'),(21,6,'kavindya_avd','2025-09-18 15:42:10'),(22,5,'kavindya_avd','2025-09-18 15:42:25'),(23,4,'kavindya_avd','2025-09-18 15:43:09'),(24,12,'jennie','2025-09-18 15:49:52'),(25,10,'jennie','2025-09-18 15:49:56'),(26,9,'jennie','2025-09-18 15:49:57'),(27,8,'jennie','2025-09-18 15:49:59'),(28,7,'jennie','2025-09-18 15:50:01'),(29,6,'jennie','2025-09-18 15:50:07'),(30,5,'jennie','2025-09-18 15:50:08'),(31,4,'jennie','2025-09-18 15:50:11'),(32,12,'gothami','2025-09-18 15:51:39'),(33,13,'ayesha','2025-09-18 16:54:36'),(34,14,'ayesha','2025-09-18 16:55:22'),(35,15,'Nethmini','2025-09-18 16:57:28'),(36,16,'Nethmini','2025-09-18 16:58:03');
/*!40000 ALTER TABLE `community_post_likes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `community_posts`
--

DROP TABLE IF EXISTS `community_posts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `community_posts` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) DEFAULT NULL,
  `message` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `image_path` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `community_posts`
--

LOCK TABLES `community_posts` WRITE;
/*!40000 ALTER TABLE `community_posts` DISABLE KEYS */;
INSERT INTO `community_posts` VALUES (1,'samre','sdfghj','2025-08-17 08:19:39',NULL),(2,'beebuu','mnbtrew','2025-08-27 06:41:14',NULL),(3,'gothami','Question: When looking for a rental, do you prefer a place that is fully furnished so you don’t have to worry about buying furniture, appliances, and decorations, or would you rather pay less and customize an unfurnished space completely in your own style and taste? ??\r\nComments:\r\nUser1: Furnished! Saves me the hassle.\r\nUser2: Unfurnished. Love decorating myself.\r\nUser3: Furnished for short-term, unfurnished for long-term.\r\nUser4: Only if it has appliances included.\r\n','2025-09-18 15:14:50',NULL),(4,'gothami','Question: When looking for a rental, do you prefer a place that is fully furnished so you don’t have to worry about buying furniture, appliances, and decorations, or would you rather pay less and customize an unfurnished space completely in your own style and taste? ??\r\nComments:\r\nUser1: Furnished! Saves me the hassle.\r\nUser2: Unfurnished. Love decorating myself.\r\nUser3: Furnished for short-term, unfurnished for long-term.\r\nUser4: Only if it has appliances included.\r\n','2025-09-18 15:14:58',NULL),(5,'gothami','What are the small things in your rental that make it truly feel like “home,” whether it’s a cozy reading corner, your favorite indoor plants, pictures on the wall, or the friendly interactions you have with neighbors? ?☕\r\n','2025-09-18 15:18:34',NULL),(6,'kaveesha','Imagine your dream rental — if you could describe it in three words, what would they be? Consider size, light, safety, location, and style. ??\r\n','2025-09-18 15:23:53',NULL),(7,'senuri','What has been the biggest challenge you’ve faced while searching for a rental property? Was it hidden costs, difficulty contacting landlords, dishonest listings, or restrictions like no pets allowed? ??\r\n','2025-09-18 15:26:50',NULL),(8,'tharudini_uththama','When choosing a rental, how important is having access to shared amenities such as gyms, swimming pools, or community spaces versus having private facilities for yourself? ?‍♂?‍♀\r\n','2025-09-18 15:30:48',NULL),(9,'tharudini_uththama','Who wants to share their rental so I can squat there for free? ? No rent needed!','2025-09-18 15:35:40',NULL),(10,'kavindya_avd','How much does a rental’s location influence your decision — would you prefer to live closer to your workplace, city center, or public transport even if the rent is higher, or do you prefer a quieter, more affordable area even if it takes longer to commute? ???\r\n','2025-09-18 15:37:54',NULL),(11,'kavindya_avd','LOL, I hate all my neighbors. They’re so annoying and stupid ?','2025-09-18 15:43:53',NULL),(12,'jennie','When a rental feels like “home,” what’s the main reason — personal touches, location, community, comfort, or the sense of safety and belonging? ??\r\n','2025-09-18 15:49:46',NULL),(13,'ayesha','Looking to sell my 3-bedroom house in Rajagiriya with a beautiful garden. Perfect for families! ? Contact me at 077-1234567 for details.','2025-09-18 16:54:10',NULL),(14,'ayesha','Affordable single-story house in Kelaniya for quick sale. Close to schools and supermarkets ?. Call 075-4455667.','2025-09-18 16:55:21',NULL),(15,'Nethmini','Brand-new modern villa in Kandy?️ For sale at attractive price! Comes with swimming pool & parking.','2025-09-18 16:57:26',NULL),(16,'Nethmini','Quick sale: Commercial building in Dehiwala suitable for shops or offices. DM if interested.','2025-09-18 16:58:01',NULL);
/*!40000 ALTER TABLE `community_posts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `properties`
--

DROP TABLE IF EXISTS `properties`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `properties` (
  `id` int NOT NULL AUTO_INCREMENT,
  `landlord_id` int NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text,
  `city` varchar(100) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `property_type` varchar(50) NOT NULL,
  `image` varchar(255) DEFAULT NULL,
  `availability` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `landlord_id` (`landlord_id`),
  CONSTRAINT `properties_ibfk_1` FOREIGN KEY (`landlord_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `properties`
--

LOCK TABLES `properties` WRITE;
/*!40000 ALTER TABLE `properties` DISABLE KEYS */;
INSERT INTO `properties` VALUES (1,13,'Luxury Apartment in Bambalapitiya','3-bedroom apartment with sea view and rooftop gym. Contact: 077-3344556','Colombo',175000.00,'House','1758213100009_house2.jpg',1,'2025-08-09 21:07:08'),(7,13,'Commercial Building in Kurunegala','3-story building suitable for office or retail. Call: 071-6677889','Kurunegala',220000.00,'Commercial Land','1758213221449_com land 2.jpg',1,'2025-08-10 08:59:41'),(8,13,'Traditional House in Jaffna','Spacious 5-bedroom with courtyard and parking. Contact: 072-5566774','Jaffna',90000.00,'Residential Land','1758213298173_resi land 2.jpg',1,'2025-08-10 09:01:29'),(11,13,'Guest House in Trincomalee','8-room guest house with sea view and restaurant space. Call: 074-3344221','Trincomalee',300000.00,'Bungalow','1758213361844_bunglow2.jpg',1,'2025-08-10 10:09:26'),(13,13,'Cottage in Bandarawela','2-bedroom hill-side cottage with tea estate view. Phone: 078-4455668\r\n','Bandarawela',70000.00,'Annex','1758213433679_aneex3.jpg',1,'2025-08-10 11:06:07'),(23,13,'Modern Villa in Matara','Luxury villa with swimming pool and 4 bedrooms. Contact: 070-7788991','Matara',250000.00,'Villa','1758213502219_villa3.jpg',1,'2025-08-28 12:49:01'),(25,30,'Apartment in Rajagiriya','2-bedroom fully furnished with AC, near supermarkets. Call: 076-8877665','Rajagiriya',85000.00,'Apartment','1758213645305_apartment1.jpg',1,'2025-09-13 09:13:34'),(26,35,'Cozy Apartment in Colombo 7','Fully furnished 2-bedroom apartment near Independence Square. Contact: 077-1234567','Colombo',85000.00,'Apartment','1758214858689_apartment3.jpg',1,'2025-09-18 16:16:45'),(27,35,'Luxury House in Kandy','Spacious 4-bedroom house with a garden and parking space. Call: 071-2345678','Kandy',120000.00,'House','housee1.jpg',1,'2025-09-18 16:18:03'),(28,35,'Modern Studio in Nugegoda','Studio apartment with AC and balcony, close to university. Phone: 075-9876543','Nugegoda',45000.00,'Annex','anex1.jpg',1,'2025-09-18 16:19:10'),(29,35,'Beachfront Villa in Galle','3-bedroom villa with sea view and private pool. Contact: 072-3456789','Galle',200000.00,'Villa','villa1.jpg',1,'2025-09-18 16:19:58'),(30,35,'Budget Room in Dehiwala','Single room for rent with shared facilities. Call: 074-8765432','Dehiwala',25000.00,'Bungalow','bunglow1.jpg',1,'2025-09-18 16:21:04'),(31,35,'Penthouse in Colombo 3','High-rise luxury penthouse with city view. Phone: 078-1122334','Colombo',350000.00,'Residential Land','resi land1.jpg',1,'2025-09-18 16:22:21'),(32,35,'Family House in Negombo','5-bedroom house near the beach, suitable for families. Contact: 070-5566778','Negombo',95000.00,'Apartment','com land 1.jpg',1,'2025-09-18 16:23:18'),(33,35,'Apartment in Battaramulla','2-bedroom apartment close to Parliament. Call: 076-9988776','Battaramulla',65000.00,'Beachfront Land','beach lland 1.jpg',1,'2025-09-18 16:24:09'),(34,35,'Cottage in Nuwara Eliya','Cozy 2-bedroom cottage with mountain view. Phone: 073-4455667','Nuwara Eliya',80000.00,'House','house3.jpg',1,'2025-09-18 16:26:25'),(36,35,'Shared Flat in Maharagama','Room available in shared flat, close to bus stand. Contact: 079-2233445','Maharagama',30000.00,'Annex','aneex3.jpg',1,'2025-09-18 16:28:46'),(37,30,'Boarding Room in Kelaniya','Affordable boarding room near university campus. Phone: 073-2233446','Kelaniya',20000.00,'Bungalow','bunglow1.jpg',1,'2025-09-18 16:46:13'),(38,30,'Luxury Bungalow in Anuradhapura','6-bedroom bungalow with large garden and parking. Contact: 079-4455668','Anuradhapura',180000.00,'Residential Land','resi land 2.jpg',1,'2025-09-18 16:47:05');
/*!40000 ALTER TABLE `properties` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `property_likes`
--

DROP TABLE IF EXISTS `property_likes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `property_likes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `property_id` int NOT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `property_id` (`property_id`,`user_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `property_likes_ibfk_1` FOREIGN KEY (`property_id`) REFERENCES `properties` (`id`) ON DELETE CASCADE,
  CONSTRAINT `property_likes_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `property_likes`
--

LOCK TABLES `property_likes` WRITE;
/*!40000 ALTER TABLE `property_likes` DISABLE KEYS */;
INSERT INTO `property_likes` VALUES (11,1,13),(26,7,24),(22,8,13),(8,11,10),(16,13,13),(32,23,30),(29,25,30),(39,26,30),(38,26,35),(34,28,35),(40,36,35),(35,37,30);
/*!40000 ALTER TABLE `property_likes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_covers`
--

DROP TABLE IF EXISTS `user_covers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_covers` (
  `user_id` int NOT NULL,
  `cover_img` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  CONSTRAINT `fk_cover_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_covers`
--

LOCK TABLES `user_covers` WRITE;
/*!40000 ALTER TABLE `user_covers` DISABLE KEYS */;
INSERT INTO `user_covers` VALUES (37,'1e0521110868452eb840c1f3ae677cad.jpg');
/*!40000 ALTER TABLE `user_covers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_settings`
--

DROP TABLE IF EXISTS `user_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_settings` (
  `user_id` int NOT NULL,
  `profile_visible` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`user_id`),
  CONSTRAINT `fk_user_settings_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_settings`
--

LOCK TABLES `user_settings` WRITE;
/*!40000 ALTER TABLE `user_settings` DISABLE KEYS */;
INSERT INTO `user_settings` VALUES (46,0);
/*!40000 ALTER TABLE `user_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `full_name` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `bio` text,
  `profile_img` varchar(255) DEFAULT NULL,
  `role` enum('tenant','landlord','admin') DEFAULT 'tenant',
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=47 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (7,'wocebuloc','b2fe8b46929bfa4c65fee9d5d43a2423799b18e360782e9abc27bd420877243e','Orlando Dorsey','tumyqyj@mailinator.com','Ea nihil elit tempo','uploads/Screenshot (237).png','admin'),(8,'lily','f803a78f88c8bf378d2fc008bb29bc275eea0152627cf060b3a40ec33285f81a','Xanthus Rice','qujijysaji@mailinator.com','Labore incididunt ip','uploads/Screenshot (241).png','landlord'),(9,'sanduni','07110ae566f574d7598b0485961b216bc671bfd2e2931096a87674d426350916','sandunii','vyhybumoxy@mailinator.com','Dolore et exercitati','uploads/Screenshot (237).png','landlord'),(10,'yamuna','07110ae566f574d7598b0485961b216bc671bfd2e2931096a87674d426350916','Lionel Garcia','fufu@mailinator.com','Quod et qui ut qui i','uploads/Screenshot (241).png','tenant'),(13,'beebuu','07110ae566f574d7598b0485961b216bc671bfd2e2931096a87674d426350916','beebaer','qoqymawap@mailinator.com','Qui corrupti quis n','uploads/524ea521da911e325fbb29d59d28aaa5.jpg','landlord'),(21,'mola','2060286b09566b29b574a0ef052028f9f157f697e0961debd0bc01ba618d683a','Hedley Brooks','topogeny@mailinator.com','Vel velit ducimus p','07b7b26fb66f4e1990771703a7d82984.jpg','tenant'),(23,'isandu','45dbada596597bb56695e265eee3814291b2ece4f1116b125613be047abd6bc2','Germaine Mccullough','pavazowi@mailinator.com','Quod dolorum illo qu','08076be3d1a44fab968454e79090b6b3.jpg','landlord'),(24,'samre','5e4d301807cada1e57cd362dfef63a27d4409543d8cb3a0e64027dfe924f9750','Samreeee','pixenaz@mailinator.com','Repellendus Ullamco','d1b20035374a4065b4da110e91ada825.jpg','landlord'),(30,'ayesha','0de3941069a81cbdd8599056e4e5237a1fd47d823936af137b04e86c7257087b','Ayesha','asdfg@gmail.com','asdfg','7f207ae6fd764356b0de2fe40b28b382.jpg','landlord'),(31,'gamini','f194fde33ea904ac7b49e037e1acd9bbcd6db893171175f9a7cf19c53fea9385','Lance Zimmerman','lecyqe@mailinator.com','Consequatur ut duci','a16a69f49c4747818189bbd73202f786.png','tenant'),(32,'tenant','b4f08230cddd4c1bc52a876e12db534f8b40eedb08ba78a5501d1cdf8eb8cb33','Kane Farley','rehoz@mailinator.com','Sequi debitis enim i','349b15c65958437d9ff69e92fbaaee5c.jpg','tenant'),(33,'landloard','f6ce747b3a70af95384c55191adad3271daaa558a2a028306edd82217f5da380','Brian Conley','hitiny@mailinator.com','Provident rerum mai',NULL,'landlord'),(34,'admin','240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9','Winifred Wise','rejelota@mailinator.com','Vel ducimus natus i',NULL,'admin'),(35,'Nethmini','c0374b649e4a4dd3e994f21bdb554df9a34b8becb827e78eb8fef20eca9622e9','Nethmini','fidesuke@mailinator.com','Qui aut velit cupida','c14db7656d4945cb964d5f7bdf7e2f47.jpg','landlord'),(36,'Alex','d9508122cd143d69df229bf3624b7bcb2b8ac81ed210a0c926455ef119c12abd','Elliott Wong','kudawipu@mailinator.com','Amet id voluptas ut','f6b46d399f1e4f469861c16cce2e5f64.jpg','tenant'),(37,'gothami','35241e7ae1522db3c69ee5d70774c0425ac5138a93b55f39983a525f53a00554','Gothami Chamodika','gothami@mailinator.com','Adipisci iusto ut qu','aca679fabd684722bad36c90cb4c9ef9.jpg','tenant'),(38,'lahiruka','44d9783399ca698b1df0bf7a6d29532068197729cbce9b3603b61c49c85d5c08','Mihili Lahiruka','lahiruka@mailinator.com','Ad aute aliquip reru',NULL,'landlord'),(39,'kaveesha','32b58c6544aa7fe8970bb36b721615eb9a4ec1c5751d13adbf06f9a23f1fb5d3','Kaveesha Sathsarani','kaveesha@gmail.com','Magna eos doloremque','f555d24ca48e4b23b29a8ecefc686a7e.jpg','tenant'),(40,'senuri','25c1fa113491b6c6384b95e625341a2e877863f0a1c006a5aa0159e98649dd63','Senuri','senuri@mailinator.com','Sit atque delectus','1e3e6563c7904225a10f123d7cc3067c.jpg','tenant'),(41,'tharudini_uththama','3adcdbe0b67cfc83c1ecdb1a7fb0786ef85d17b7d964f9d68f8eb79f98127ca7','Eliana Williamson','tapo@mailinator.com','Cupiditate elit qui','0bc7e1fcee114a94830032f9ed42bf4d.jpg','tenant'),(42,'kavindya_avd','e5bf79ef7bb8d8f2b5f94085d5a62872f72cff2702b434a448a238b540fd5e9f','Chava Willis','kavindya@mailinator.com','Perspiciatis dicta','d1b4bec914ec4f55908f873018afc419.jpg','tenant'),(43,'jennie','40ab210ebcf9b769276a3c6a275a9acf86595e5c7bd05a4f9780035b69d55792','Jennie Kim','jennie@mailinator.com','Do minim saepe duis','c9ff59be40454a2085ba1298192b6cce.jpg','tenant'),(44,'felix','92905682bbf364b088d3dc14aa78454aae679d3bacf7457564474f9684cadd48','Lee Felix','felix@mailinator.com','Eum quibusdam corpor','f354e8c05b0344ffa8b9530caf7bc1e3.jpg','admin'),(45,'bavindu','ac99130c531dbe451d44ebf74f8b715f08eb1d97ae28c329496a620b02b68de5','Solomon Wright','zyjaxeneh@mailinator.com','Laboris cupiditate e','ce8e277c0e114f19a221859d55ef4e70.jpg','landlord'),(46,'sadev','728f3f0950fe611d38b096916cc30aedc0830624f5a018a35932616f7a7193af','Leilani Frederickjnjn','zopihebyf@mailinator.com','In est asperiores vojnjn','35b7025fda1948858ad10753ef5c09cc.jpg','tenant');
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

-- Dump completed on 2025-09-19 23:07:57
