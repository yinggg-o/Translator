/*
 Navicat Premium Data Transfer

 Source Server         : test
 Source Server Type    : MySQL
 Source Server Version : 80300
 Source Host           : localhost:3306
 Source Schema         : translator

 Target Server Type    : MySQL
 Target Server Version : 80300
 File Encoding         : 65001

 Date: 19/11/2024 16:26:06
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for t_question_bank
-- ----------------------------
DROP TABLE IF EXISTS `t_question_bank`;
CREATE TABLE `t_question_bank`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '句子唯一标识',
  `source_text` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '源语言句子',
  `target_text` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '目标语言句子',
  `user_id` int NULL DEFAULT NULL COMMENT '上传句子的用户id，关联用户表',
  `upload_time` datetime NULL DEFAULT NULL COMMENT '句子上传时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `user`(`user_id` ASC) USING BTREE,
  CONSTRAINT `user` FOREIGN KEY (`user_id`) REFERENCES `t_user` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_question_bank
-- ----------------------------
INSERT INTO `t_question_bank` VALUES (5, 'On a Harmonious Dormitory Life', '论和谐的宿舍生活', 1, '2024-11-19 16:22:28');
INSERT INTO `t_question_bank` VALUES (6, 'When it comes to the dormitory life, we have to face theproblem that sometimes the harmony in the dormitory is disturbed in one way or another', '说到宿舍生活，我们不得不面对宿舍里的和谐有时会受到这样或那样的干扰', 1, '2024-11-19 16:22:28');
INSERT INTO `t_question_bank` VALUES (7, 'As is known to all, dormitory life plays an important role in students day-to-day life', '众所周知，宿舍生活在学生的日常生活中起着重要作用', 1, '2024-11-19 16:22:28');
INSERT INTO `t_question_bank` VALUES (8, ' Onthe one hand, we can have a good rest and put our hearts into study', '一方面，我们可以好好休息，全心投入学习', 1, '2024-11-19 16:22:28');
INSERT INTO `t_question_bank` VALUES (9, ' On the other hand, wewill have a good mood and enjoy being together', '另一方面，我们会有一个好心情，享受在一起的时光', 1, '2024-11-19 16:22:28');
INSERT INTO `t_question_bank` VALUES (10, ' in contrast, disharmony may causesubstantial impact on our daily life', '相反，不和谐可能会导致对我们的日常生活产生了重大影响', 1, '2024-11-19 16:22:28');
INSERT INTO `t_question_bank` VALUES (11, ' Considering tire seriousness of the problem, measuresshould be taken to prevent disharmony life from bringing us more harm', '考虑到轮胎问题的严重性，措施应该采取措施，防止不和谐的生活给我们带来更多的伤害', 1, '2024-11-19 16:22:28');
INSERT INTO `t_question_bank` VALUES (12, ' For one thing, it ishigh time that all of the students realized the important of a harmonious dormitory life', '首先，它是所有学生都意识到和谐宿舍生活的重要性', 1, '2024-11-19 16:22:28');
INSERT INTO `t_question_bank` VALUES (13, ' Foranother, we have to evaluate our life style and try to get rid of discomforting habits, if thereare any', '另一方面，我们必须评估我们的生活方式，并尝试摆脱不舒服的习惯，如果有的话是任何', 1, '2024-11-19 16:22:28');
INSERT INTO `t_question_bank` VALUES (14, ' Last but not least, when an annoying situation arises, we have to learn to tolerateeach other and co-exist', '最后但同样重要的是，当出现恼人的情况时，我们必须学会容忍彼此共存', 1, '2024-11-19 16:22:28');
INSERT INTO `t_question_bank` VALUES (15, ' Only in this way can we create and maintain a harmonious dormitorylife', '只有这样，我们才能创造和维护一个和谐的宿舍生活', 1, '2024-11-19 16:22:28');

-- ----------------------------
-- Table structure for t_translation_records
-- ----------------------------
DROP TABLE IF EXISTS `t_translation_records`;
CREATE TABLE `t_translation_records`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '翻译记录 ID，自增长的主键',
  `user_id` int NULL DEFAULT NULL COMMENT '提交翻译请求的用户 ID，外键关联用户表',
  `original_text` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '原文内容',
  `translated_text` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '翻译后的内容',
  `source_language` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '原文语言',
  `target_language` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '目标翻译语言',
  `translation_date` datetime NOT NULL COMMENT '翻译时间，默认当前时间',
  `differences` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '用户自行翻译与软件翻译结果的差异（可存储为特定格式，如 JSON）',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_translation_records
-- ----------------------------
INSERT INTO `t_translation_records` VALUES (2, 2, 'world', '世界', 'English', 'Chinese', '2024-11-14 15:47:08', '世界');
INSERT INTO `t_translation_records` VALUES (3, 1, 'gril', '女孩', 'English', 'Chinese', '2024-11-14 15:47:08', '女孩');

-- ----------------------------
-- Table structure for t_user
-- ----------------------------
DROP TABLE IF EXISTS `t_user`;
CREATE TABLE `t_user`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '用户 ID，自增长的主键',
  `username` char(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '用户名，唯一且不能为空',
  `password` char(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '用户密码，存储经过加密处理后的密码值',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '用户电子邮箱，可为空',
  `created_at` datetime NULL DEFAULT NULL COMMENT '用户注册时间，默认当前时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `account`(`username` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_user
-- ----------------------------
INSERT INTO `t_user` VALUES (1, 'admin', '123456', NULL, NULL);
INSERT INTO `t_user` VALUES (2, 'test', '123456', NULL, NULL);

SET FOREIGN_KEY_CHECKS = 1;
