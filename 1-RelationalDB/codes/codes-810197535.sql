-- *************** SqlDBM: PostgreSQL ****************;
-- ***************************************************;


-- ************************************** "user"

CREATE TABLE "user"
(
 username uuid NOT NULL,
 name     varchar(50) NOT NULL,
 email    varchar(50) NOT NULL,
 phone    varchar(12) NOT NULL,
 CONSTRAINT PK_6 PRIMARY KEY ( username )
);


-- ************************************** admin

CREATE TABLE admin
(
 username uuid NOT NULL,
 CONSTRAINT PK_309 PRIMARY KEY ( username ),
 CONSTRAINT FK_272 FOREIGN KEY ( username ) REFERENCES "user" ( username )
);

CREATE INDEX fkIdx_274 ON admin
(
 username
);


-- ************************************** educational_experience

CREATE TABLE educational_experience
(
 educational_exp_ID int NOT NULL,
 "from"               date NOT NULL,
 "to"                 date NULL,
 level              varchar(20) NOT NULL,
 place_name         varchar(40) NOT NULL,
 average            real NOT NULL,
 CONSTRAINT PK_135 PRIMARY KEY ( educational_exp_ID )
);



-- ************************************** job_experience

CREATE TABLE job_experience
(
 job_exp_ID   int NOT NULL,
 "from"         date NOT NULL,
 "to"           date NULL,
 company_name varchar(50) NOT NULL,
 CONSTRAINT PK_129 PRIMARY KEY ( job_exp_ID )
);



-- ************************************** applicant

CREATE TABLE applicant
(
 educational_exp_ID int NOT NULL,
 job_exp_ID         int NOT NULL,
 username           uuid NOT NULL,
 CONSTRAINT PK_306 PRIMARY KEY ( username ),
 CONSTRAINT FK_141 FOREIGN KEY ( educational_exp_ID ) REFERENCES educational_experience ( educational_exp_ID ),
 CONSTRAINT FK_150 FOREIGN KEY ( job_exp_ID ) REFERENCES job_experience ( job_exp_ID ),
 CONSTRAINT FK_24 FOREIGN KEY ( username ) REFERENCES "user" ( username )
);

CREATE INDEX fkIdx_143 ON applicant
(
 educational_exp_ID
);

CREATE INDEX fkIdx_152 ON applicant
(
 job_exp_ID
);

CREATE INDEX fkIdx_26 ON applicant
(
 username
);


-- ************************************** employer

CREATE TABLE employer
(
 username          uuid NOT NULL,
 company_name      varchar(100) NOT NULL,
 Location          text NOT NULL,
 confirmation_date time NOT NULL,
 admin_username    uuid NOT NULL,
 CONSTRAINT PK_318 PRIMARY KEY ( username ),
 CONSTRAINT FK_172 FOREIGN KEY ( admin_username ) REFERENCES admin ( username ),
 CONSTRAINT FK_18 FOREIGN KEY ( username ) REFERENCES "user" ( username )
);

CREATE INDEX fkIdx_174 ON employer
(
 admin_username
);

CREATE INDEX fkIdx_20 ON employer
(
 username
);


-- ************************************** viewer

CREATE TABLE viewer
(
 viewer_ip     varchar(20) NOT NULL,
 entrance_time timestamp NOT NULL,
 CONSTRAINT PK_247 PRIMARY KEY ( viewer_ip, entrance_time )
);



-- ************************************** agent_registered_by_employer

CREATE TABLE agent_registered_by_employer
(
 username          uuid NOT NULL,
 employer_username uuid NOT NULL,
 last_modified     timestamp NOT NULL,
 agent_role        varchar(40) NOT NULL,
 CONSTRAINT PK_332 PRIMARY KEY ( username ),
 CONSTRAINT FK_329 FOREIGN KEY ( username ) REFERENCES "user" ( username ),
 CONSTRAINT FK_336 FOREIGN KEY ( employer_username ) REFERENCES employer ( username )
);

CREATE INDEX fkIdx_331 ON agent_registered_by_employer
(
 username
);

CREATE INDEX fkIdx_338 ON agent_registered_by_employer
(
 employer_username
);



-- ************************************** payment

CREATE TABLE payment
(
 payment_ID     int NOT NULL,
 fee            money NOT NULL,
 payment_status varchar(20) NOT NULL,
 CONSTRAINT PK_88 PRIMARY KEY ( payment_ID )
);



-- ************************************** category

CREATE TABLE category
(
 category_name varchar(30) NOT NULL,
 CONSTRAINT PK_29 PRIMARY KEY ( category_name )
);



-- ************************************** category_checked_by_agent

CREATE TABLE category_checked_by_agent
(
 category_name  varchar(30) NOT NULL,
 agent_username uuid NOT NULL,
 CONSTRAINT PK_341 PRIMARY KEY ( category_name, agent_username ),
 CONSTRAINT FK_164 FOREIGN KEY ( category_name ) REFERENCES category ( category_name ),
 CONSTRAINT FK_333 FOREIGN KEY ( agent_username ) REFERENCES agent_registered_by_employer ( username )
);

CREATE INDEX fkIdx_166 ON category_checked_by_agent
(
 category_name
);

CREATE INDEX fkIdx_335 ON category_checked_by_agent
(
 agent_username
);



-- ************************************** post

CREATE TABLE post
(
 post_ID            uuid NOT NULL,
 category_name      varchar(30) NOT NULL,
 payment_ID         int NOT NULL,
 username           uuid NOT NULL,
 post_title         varchar(100) NOT NULL,
 contract_type      varchar(30) NULL,
 min_job_experience varchar(20) NULL,
 deadline_limit     varchar(20) NULL,
 description        text NOT NULL,
 CONSTRAINT PK_321 PRIMARY KEY ( post_ID ),
 CONSTRAINT FK_349 FOREIGN KEY ( username ) REFERENCES employer ( username ),
 CONSTRAINT FK_42 FOREIGN KEY ( category_name ) REFERENCES category ( category_name ),
 CONSTRAINT FK_90 FOREIGN KEY ( payment_ID ) REFERENCES payment ( payment_ID )
);

CREATE INDEX fkIdx_351 ON post
(
 username
);

CREATE INDEX fkIdx_44 ON post
(
 category_name
);

CREATE INDEX fkIdx_92 ON post
(
 payment_ID
);



-- ************************************** remove_post

CREATE TABLE remove_post
(
 "time"     timestamp NOT NULL,
 reason   text NOT NULL,
 username uuid NOT NULL,
 post_ID  uuid NOT NULL,
 CONSTRAINT PK_371 PRIMARY KEY ( post_ID ),
 CONSTRAINT FK_197 FOREIGN KEY ( post_ID ) REFERENCES post ( post_ID ),
 CONSTRAINT FK_238 FOREIGN KEY ( username ) REFERENCES admin ( username )
);

CREATE INDEX fkIdx_199 ON remove_post
(
 post_ID
);

CREATE INDEX fkIdx_240 ON remove_post
(
 username
);



-- ************************************** mark_post

CREATE TABLE mark_post
(
 post_ID  uuid NOT NULL,
 username uuid NOT NULL,
 note     text NULL,
 "time"     timestamp NOT NULL,
 CONSTRAINT PK_377 PRIMARY KEY ( post_ID, username ),
 CONSTRAINT FK_113 FOREIGN KEY ( post_ID ) REFERENCES post ( post_ID ),
 CONSTRAINT FK_117 FOREIGN KEY ( username ) REFERENCES applicant ( username )
);

CREATE INDEX fkIdx_115 ON mark_post
(
 post_ID
);

CREATE INDEX fkIdx_119 ON mark_post
(
 username
);



-- ************************************** viewer_login

CREATE TABLE viewer_login
(
 login_time    timestamp NOT NULL,
 viewer_ip     varchar(20) NOT NULL,
 entrance_time timestamp NOT NULL,
 username      uuid NOT NULL,
 CONSTRAINT PK_310 PRIMARY KEY ( viewer_ip, entrance_time, username ),
 CONSTRAINT FK_267 FOREIGN KEY ( viewer_ip, entrance_time ) REFERENCES viewer ( viewer_ip, entrance_time ),
 CONSTRAINT FK_290 FOREIGN KEY ( username ) REFERENCES "user" ( username )
);

CREATE INDEX fkIdx_270 ON viewer_login
(
 viewer_ip,
 entrance_time
);

CREATE INDEX fkIdx_292 ON viewer_login
(
 username
);



-- ************************************** viewer_visit_post

CREATE TABLE viewer_visit_post
(
 search_filters  json NOT NULL,
 post_ID         uuid NOT NULL,
 viewer_ip       varchar(20) NOT NULL,
 entrance_time   timestamp NOT NULL,
 post_visit_time timestamp NOT NULL,
 CONSTRAINT PK_372 PRIMARY KEY ( post_ID, viewer_ip, entrance_time, post_visit_time ),
 CONSTRAINT FK_255 FOREIGN KEY ( post_ID ) REFERENCES post ( post_ID ),
 CONSTRAINT FK_259 FOREIGN KEY ( viewer_ip, entrance_time ) REFERENCES viewer ( viewer_ip, entrance_time )
);

CREATE INDEX fkIdx_257 ON viewer_visit_post
(
 post_ID
);

CREATE INDEX fkIdx_262 ON viewer_visit_post
(
 viewer_ip,
 entrance_time
);



-- ************************************** visit_post

CREATE TABLE visit_post
(
 search_filters json NOT NULL,
 username       uuid NOT NULL,
 post_ID        uuid NOT NULL,
 "time"           timestamp NOT NULL,
 CONSTRAINT PK_368 PRIMARY KEY ( username, post_ID, "time" ),
 CONSTRAINT FK_52 FOREIGN KEY ( username ) REFERENCES "user" ( username ),
 CONSTRAINT FK_56 FOREIGN KEY ( post_ID ) REFERENCES post ( post_ID )
);

CREATE INDEX fkIdx_54 ON visit_post
(
 username
);

CREATE INDEX fkIdx_58 ON visit_post
(
 post_ID
);



-- ************************************** applies

CREATE TABLE applies
(
 post_ID          uuid NOT NULL,
 username         uuid NOT NULL,
 stage_and_result varchar(20) NOT NULL,
 description      text NULL,
 apply_time       timestamp NOT NULL,
 CONSTRAINT PK_369 PRIMARY KEY ( post_ID, username ),
 CONSTRAINT FK_101 FOREIGN KEY ( post_ID ) REFERENCES post ( post_ID ),
 CONSTRAINT FK_105 FOREIGN KEY ( username ) REFERENCES applicant ( username )
);

CREATE INDEX fkIdx_103 ON applies
(
 post_ID
);

CREATE INDEX fkIdx_107 ON applies
(
 username
);



