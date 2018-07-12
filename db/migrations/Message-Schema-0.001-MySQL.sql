-- 
-- Created by SQL::Translator::Producer::MySQL
-- Created on Thu Jul 12 16:14:39 2018
-- 
SET foreign_key_checks=0;

DROP TABLE IF EXISTS author;

--
-- Table: author
--
CREATE TABLE author (
  id integer NOT NULL auto_increment,
  nick varchar(64) NOT NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS topic;

--
-- Table: topic
--
CREATE TABLE topic (
  id integer NOT NULL auto_increment,
  name varchar(255) NOT NULL,
  parent_id integer NOT NULL,
  INDEX topic_idx_parent_id (parent_id),
  PRIMARY KEY (id),
  CONSTRAINT topic_fk_parent_id FOREIGN KEY (parent_id) REFERENCES topic (id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

DROP TABLE IF EXISTS message;

--
-- Table: message
--
CREATE TABLE message (
  id integer NOT NULL auto_increment,
  topic_id integer NOT NULL,
  author_id integer NOT NULL,
  text text NOT NULL,
  created_at datetime NOT NULL DEFAULT now(),
  INDEX message_idx_author_id (author_id),
  INDEX message_idx_topic_id (topic_id),
  PRIMARY KEY (id),
  CONSTRAINT message_fk_author_id FOREIGN KEY (author_id) REFERENCES author (id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT message_fk_topic_id FOREIGN KEY (topic_id) REFERENCES topic (id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

DROP TABLE IF EXISTS bookmark;

--
-- Table: bookmark
--
CREATE TABLE bookmark (
  id integer NOT NULL auto_increment,
  author_id integer NOT NULL,
  message_id integer NOT NULL,
  INDEX bookmark_idx_author_id (author_id),
  INDEX bookmark_idx_message_id (message_id),
  PRIMARY KEY (id),
  CONSTRAINT bookmark_fk_author_id FOREIGN KEY (author_id) REFERENCES author (id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT bookmark_fk_message_id FOREIGN KEY (message_id) REFERENCES message (id)
) ENGINE=InnoDB;

SET foreign_key_checks=1;

