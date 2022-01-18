-- semi 계성 생성함
drop table member;

CREATE TABLE member (
	member_id	varchar2(20)		NOT NULL,
	member_pwd	varchar2(300)		NOT NULL,
	member_role	char(1)	DEFAULT 'U' 	NOT NULL,
	member_name	 varchar2(50)		NOT NULL,
	phone	char(11)		NOT NULL,
	mileage 	number	DEFAULT 0	NOT NULL,
	reg_date	date	DEFAULT sysdate	NOT NULL,
    
    constraint pk_member_id primary key(member_id),
    constraint ck_member_role check (member_role in ('U', 'A'))
);

select * from member;

insert into member
values (
    'honggd', '1234', 'U', '홍길동',
    '01012341234', 1000,  default
);


-- 탈퇴 회원(member_del)테이블 생성
CREATE TABLE member_del (
    member_id2    varchar2(20)    NOT NULL,
    member_pwd    varchar2(300) NOT NULL,
    member_role    char(1)    DEFAULT 'U' NOT NULL,
    member_name    varchar2(50)    NOT NULL,
    phone    char(11)    NOT NULL,
    mileage    char(10)    NOT NULL,
    del_date date NOT NULL,
    reg_date date NOT NULL,
    issue_date    date     DEFAULT sysdate  NOT NULL,
    license_type    varchar2(20)    DEFAULT 'auto' NOT NULL    ,

    ------ 제악조건
    constraint pk_member_del_member_id2 primary key(member_id2),
    constraint fk_member_del_member_id2 foreign key(member_id2) references member(member_id)
);


-- 차 정보(car_info) 테이블 생성
CREATE TABLE car_info (
    car_info_no number,
    car_name varchar2(50) NOT NULL,
    fuel varchar2(10) NOT NULL,
    back_camera char(1)    DEFAULT 'N' NOT NULL,
    navigation char(1) DEFAULT 'Y' NOT NULL,
    blackBox char(1) DEFAULT 'Y' NOT NULL,
    age_restrict number    NOT NULL,
    maker varchar2(20),
    release date NOT NULL,
    capacity number NOT NULL,
    smoke char(1) DEFAULT 'N' NOT NULL,
    price number NULL,
    car_size varchar2(30) NULL,
    img varchar2(50) NOT NULL,

    --  카 테이블 제약조건 생성 
    constraint pk_car_no primary key(car_info_no),
    constraint uq_car_name unique(car_name)
);

--  차 목록(car_list)테이블 생성
CREATE TABLE car_list (
	car_code	varchar2(30)	NOT NULL,
	car_name	varchar2(50)	NOT NULL,
	start_date	date	,
	end_date	date,
	memo	varchar2(500),	
	number_plate	varchar2(30),
    
    constraint pk_car_code primary key(car_code),
    constraint fk_car_name foreign key(car_name) references car_info(car_name)
);



--  예약(reservation)테이블 생성
CREATE TABLE reservation (
    reser_no    varchar2(20)    NOT NULL,
    member_id varchar2(50)    NOT NULL,
    car_code varchar2(30) not null,
    car_name     varchar2(50)    NOT NULL,
    start_date date not null,
    end_date date NOT NULL,
    insurance_type char(1) NOT NULL,
    issue_date date not null,
    license_type varchar2(20) not null,
    aptitude_expire date not null,
    license_renewal date not null,

    constraint pk_reservation_reser_no primary key(reser_no),
    constraint fk_reservation_member_id foreign key(member_id) references member(member_id),
    constraint fk_reservation_car_code foreign key(car_code) references car_list(car_code),
    constraint fk_reservation_car_name foreign key(car_name) references car_info(car_name)
);


-- 공지사항(notice) 테이블 추가
CREATE TABLE notice (
    notice_no    number NOT NULL, 
    notice_title varchar2(30)    NOT NULL,
    content    varchar2(4000)    NOT NULL,
    reg_date    date        DEFAULT sysdate NOT NULL,
    read_count number    NOT NULL,
    -- 제약조건 추가
    constraint pk_notice_notice_no primary key(notice_no)
);
-- notice 테이블 시퀀스 추가
create sequence seq_notice_notice_no;


--  자유게시판(community) 테이블 추가
CREATE TABLE community (
    community_no    number    NOT NULL,
    member_id varchar2(20) NOT NULL,
    title    varchar2(30)    NOT NULL,
    content    varchar2(4000)    NOT NULL,
    reg_date    date     DEFAULT sysdate NOT NULL,
    read_count    number    NOT NULL,
    -- 제약조건
    constraint pk_community_notice_no primary key(community_no),
    constraint fk_community_member_id foreign key(member_id) references member(member_id)
    
);

    --  community_notice_no sequence 생성
create sequence seq_community_notice_no;


--  자유게시판 댓글(community_comment) 테이블 추가
CREATE TABLE community_comment (
    no    number    NOT NULL,
    community_no    number    NOT NULL,
    writer    varchar2(20)    NOT NULL,
    content    varchar2(4000)    NOT NULL,
    reg_date    date     DEFAULT sysdate NOT NULL,
    comment_level     number     DEFAULT 1 NOT NULL,
    comment_ref    number    NOT NULL,
    -- 제약조건
    constraint pk_community_comment_no primary key(no),
    constraint fk_community_writer foreign key(writer) references member(member_id),
    constraint fk_community_comment_notice_no foreign key(community_no) references community(community_no) on delete cascade,
    constraint fk_community_comment_ref foreign key(comment_ref) references community_comment(no) on delete cascade
);
    --  community_notice_no sequence 생성
create sequence seq_community_comment_no;


--  자유게시판 첨부파일(community_attach) 테이블 추가
CREATE TABLE community_attach (
    no    number    NOT NULL,
    community_no    number    NOT NULL,
    original_filename    varchar2(255) NOT NULL,
    renamed_filename    varchar2(255) NOT NULL,
    reg_date    date     DEFAULT sysdate NOT NULL,

      -- 제약조건
    constraint pk_community_attach_no primary key(no),
    constraint fk_community_attach_community_no foreign key(community_no) references community(community_no)

);




--  문의사항(qna_board)테이블 생성
CREATE TABLE qna_board (
    no    number    NOT NULL,
    member_id    varchar2(20)    NOT NULL,
    qna_title    varchar2(30)    NOT NULL,
    qna_content    varchar2(4000)    NOT NULL,
    reg_date    date     DEFAULT sysdate     NOT NULL,
    answer_status    char(1)    DEFAULT 'N' NOT NULL,

    ------ 제악조건
    constraint pk_qna_board_no primary key(no),
    constraint fk_qna_board_member_id foreign key(member_id) references member(member_id)

);
    --  qna_board sequence 생성
create sequence seq_qna_board_no;

-- 문의 사항 첨부파일(qna_board_attach) 테이블 추가
CREATE TABLE  qna_board_attach (
    no    number,
    que_no    number    NOT NULL,
    original_filename    varchar2(255) NOT NULL,
    renamed_filename    varchar2(255) NOT NULL,
    reg_date    date     DEFAULT sysdate NOT NULL,
    -- 제약조건 추가
    constraint pk_qna_board_attach_no primary key(no),
    constraint fk_qna_board_attach_que_no foreign key(no) references qna_board(no)
);
    --  qna_board sequence 생성
create sequence seq_qna_board_attach_no;

-- 문의 사항 댓글(qna_comment) 테이블 추가
CREATE TABLE qna_comment (
    no    number    NOT NULL,
    qna_no    number    NOT NULL,
    writer    varchar2(30)    NOT NULL,
    content    varchar2(4000)    NOT NULL,
    reg_date    date    NOT NULL,
    comment_level    number    NOT NULL,
    comment_ref    number    NOT NULL,

    -- 제약조건 추가
    constraint pk_qna_comment_no primary key(no),
    constraint fk_qna_comment_qna_no foreign key(qna_no) references qna_board(no) on delete cascade,
    constraint fk_qna_comment_writer foreign key(writer) references member(member_id),
    constraint fk_qna_comment_comment_ref foreign key(comment_ref) references qna_comment(no) on delete cascade
);


--  이용후기(review) 테이블 생성
CREATE TABLE review_board (
	no	number,
	member_id	varchar2(30)	NOT NULL,
	car_name	 varchar2(30)	NOT NULL,
	title	varchar2(30)	NOT NULL,
	content	varchar2(4000)	NOT NULL,
	reg_date	date	 DEFAULT sysdate NOT NULL,
	read_count number NOT NULL,
	score number NOT NULL,
    
    -- 제약조건 생성
    constraint pk_review_board_no primary key(no),
    constraint fk_review_board_member_id foreign key(member_id) references member(member_id),
    constraint fk_review_board_car_name foreign key(car_name) references car_info(car_name)
);

-- 이용후기 테이블 sequence 생성
create sequence seq_review_board_no;


--  이용후기 첨부파일(Review_board_attach) 테이블 생성
CREATE TABLE review_board_attach (
	no	number,
	board_no number	NOT NULL,
	original_filename	varchar2(255)	NOT NULL,
	renamed_filename	varchar2(255)	NOT NULL,
	reg_date	date	 DEFAULT sysdate,
    
     -- 제약조건 생성
    constraint pk_review_board_attach_no primary key(no),
    constraint fk_review_board_attach_board_no foreign key(board_no) references review_board(no)
);

-- 이용후기 첨부파일 테이블 sequence 생성
create sequence seq_review_board_attach_no;


-- 이용 후기 댓글 테이블 생성
CREATE TABLE review_comment (
	no	number	NOT NULL,
	review_no	number	NOT NULL,
	writer	varchar2(30)	NOT NULL,
	content	varchar2(4000)	NOT NULL,
	reg_date	date	 NOT NULL,
	comment_level	 number	 NOT NULL,
	comment_ref	number	NOT NULL,
    
    ---제약 조건
    constraint pk_review_comment_no primary key(no),
    constraint fk_review_comment_review_no foreign key(review_no) references review_board(no) on delete cascade,
    constraint fk_review_comment_writer foreign key(writer) references member(member_id),
    constraint fk_review_comment_comment_ref foreign key(comment_ref) references review_comment(no) on delete cascade
);