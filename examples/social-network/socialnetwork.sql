-- MySQL Script generated by MySQL Workbench
-- Fri Apr 10 23:47:27 2020
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema socialnetwork
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema socialnetwork
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `socialnetwork` DEFAULT CHARACTER SET utf8 ;
USE `socialnetwork` ;

-- -----------------------------------------------------
-- Table `socialnetwork`.`user`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `socialnetwork`.`user` ;

CREATE TABLE IF NOT EXISTS `socialnetwork`.`user` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45) NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  `password` BLOB NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `socialnetwork`.`post`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `socialnetwork`.`post` ;

CREATE TABLE IF NOT EXISTS `socialnetwork`.`post` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `content` TEXT(200) NOT NULL,
  `user_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_post_user1_idx` (`user_id` ASC),
  CONSTRAINT `fk_post_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `socialnetwork`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `socialnetwork`.`like`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `socialnetwork`.`like` ;

CREATE TABLE IF NOT EXISTS `socialnetwork`.`like` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `post_id` INT UNSIGNED NOT NULL,
  `user_id` INT UNSIGNED NOT NULL,
  `created_at` DATETIME NULL,
  `like_type` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_like_post_idx` (`post_id` ASC),
  INDEX `fk_like_user1_idx` (`user_id` ASC),
  CONSTRAINT `fk_like_post`
    FOREIGN KEY (`post_id`)
    REFERENCES `socialnetwork`.`post` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_like_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `socialnetwork`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `socialnetwork`.`friendship`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `socialnetwork`.`friendship` ;

CREATE TABLE IF NOT EXISTS `socialnetwork`.`friendship` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `created_at` DATETIME NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `socialnetwork`.`user_has_friendship`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `socialnetwork`.`user_has_friendship` ;

CREATE TABLE IF NOT EXISTS `socialnetwork`.`user_has_friendship` (
  `user_id` INT UNSIGNED NOT NULL,
  `friendship_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`user_id`, `friendship_id`),
  INDEX `fk_user_has_friendship_friendship1_idx` (`friendship_id` ASC),
  INDEX `fk_user_has_friendship_user1_idx` (`user_id` ASC),
  CONSTRAINT `fk_user_has_friendship_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `socialnetwork`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_user_has_friendship_friendship1`
    FOREIGN KEY (`friendship_id`)
    REFERENCES `socialnetwork`.`friendship` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `socialnetwork`.`image`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `socialnetwork`.`image` ;

CREATE TABLE IF NOT EXISTS `socialnetwork`.`image` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `post_id` INT UNSIGNED NOT NULL,
  `views` INT NULL,
  `original_url` VARCHAR(45) NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_image_post1_idx` (`post_id` ASC),
  CONSTRAINT `fk_image_post1`
    FOREIGN KEY (`post_id`)
    REFERENCES `socialnetwork`.`post` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `socialnetwork`.`image_variation`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `socialnetwork`.`image_variation` ;

CREATE TABLE IF NOT EXISTS `socialnetwork`.`image_variation` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `image_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_image_variation_image1_idx` (`image_id` ASC),
  CONSTRAINT `fk_image_variation_image1`
    FOREIGN KEY (`image_id`)
    REFERENCES `socialnetwork`.`image` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `socialnetwork`.`comment`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `socialnetwork`.`comment` ;

CREATE TABLE IF NOT EXISTS `socialnetwork`.`comment` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `content` TEXT(200) NOT NULL,
  `post_id` INT UNSIGNED NOT NULL,
  `user_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_comment_post1_idx` (`post_id` ASC),
  INDEX `fk_comment_user1_idx` (`user_id` ASC),
  CONSTRAINT `fk_comment_post1`
    FOREIGN KEY (`post_id`)
    REFERENCES `socialnetwork`.`post` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_comment_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `socialnetwork`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `socialnetwork`.`comment_like`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `socialnetwork`.`comment_like` ;

CREATE TABLE IF NOT EXISTS `socialnetwork`.`comment_like` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `comment_id` INT UNSIGNED NOT NULL,
  `user_id` INT UNSIGNED NOT NULL,
  `created_at` DATETIME NULL,
  `like_type` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_comment_like_comment1_idx` (`comment_id` ASC),
  INDEX `fk_comment_like_user1_idx` (`user_id` ASC),
  CONSTRAINT `fk_comment_like_comment1`
    FOREIGN KEY (`comment_id`)
    REFERENCES `socialnetwork`.`comment` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_comment_like_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `socialnetwork`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
