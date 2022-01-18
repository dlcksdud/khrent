-- 회원 테이블 생성
CREATE TABLE member (
	member_id	varchar2(20)		NOT NULL,
	member_pwd	varchar2(300)		NOT NULL,
	member_role	char(1)	DEFAULT 'U' 	NOT NULL,
	member_name	 varchar2(50)		NOT NULL,
	phone	char(11)		NOT NULL,
	mileage 	number	DEFAULT 0	NOT NULL,
	reg_date	date	DEFAULT sysdate	NOT NULL,
	issue_date date,
	license_type varchar2(20),
	license_no char(12),
   
    constraint pk_member_id primary key(member_id),
    constraint ck_member_role check (member_role in ('U', 'A'))
);



-- 탈퇴 회원(member_del)테이블 생성
create table member_del
as
select
    m.*,
    systimestamp del_Date
from
    member m
where
    1 = 0;



-- 탈퇴 회원 트리거
create or replace trigger trg_member_del
    before delete on member
    for each row
begin
    insert into member_del (member_id, member_pwd, member_role, member_name, phone, mileage, reg_date, issue_date, license_type, license_no, del_date)
    values (
    :old.member_id,
    :old.member_pwd,
    :old.member_role,
    :old.member_name,
    :old.phone,
    :old.mileage,
    :old.reg_date,
    :old.issue_date,
    :old.license_type,
    :old.license_no,
    sysdate);
end;
/



-- 차 정보(car_info) 테이블 생성
CREATE TABLE car_info (
    car_info_no number,
    car_name varchar2(50) NOT NULL,
    fuel varchar2(10) NOT NULL,
    back_camera char(1)    DEFAULT 'N',
    navigation char(1) DEFAULT 'Y',
    blackbox char(1) DEFAULT 'Y',
    smoke char(1) DEFAULT 'N',
    maker varchar2(20),
    release char(4) NOT NULL,
    capacity varchar2(20)NOT NULL,
    price number not null,
    car_size varchar2(30),
    img varchar2(50) NOT NULL,

    --  카 테이블 제약조건 생성 
    constraint pk_car_info_no primary key(car_info_no),
    constraint uq_car_name unique(car_name)
);

-- 차 정보 테이블 시퀀스 추가
create sequence seq_car_info_no;



--  차 목록(car_list)테이블 생성
CREATE TABLE car_list (
	car_code	varchar2(30)	NOT NULL,
	car_name	varchar2(50)	NOT NULL,
	start_date date	,
	end_date date,
	number_plate	varchar2(30),
    
    constraint pk_car_code primary key(car_code),
    constraint fk_car_name foreign key(car_name) references car_info(car_name) on delete cascade
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
    review_status char(1) default 'N',
    return_status char(1) default 'N',

    constraint pk_reservation_reser_no primary key(reser_no),
    constraint fk_reservation_member_id foreign key(member_id) references member(member_id) on delete cascade,
    constraint fk_reservation_car_code foreign key(car_code) references car_list(car_code) on delete cascade
);




-- 공지사항(notice) 테이블 추가
CREATE TABLE notice (
    notice_no number NOT NULL, 
    notice_title varchar2(30)    NOT NULL,
    notice_content    varchar2(4000)    NOT NULL,
    reg_date    date        DEFAULT sysdate NOT NULL,
    read_count number    NOT NULL,
    -- 제약조건 추가
    constraint pk_notice_no primary key(notice_no)
);

-- 공지사항 테이블 시퀀스 추가
create sequence seq_notice_no;



--  자유게시판(community) 테이블 추가
CREATE TABLE community (
    community_no    number    NOT NULL,
    community_title    varchar2(30)    NOT NULL,
    community_writer varchar2(20) NOT NULL,
    community_content    varchar2(4000)    NOT NULL,
    reg_date    date     DEFAULT sysdate NOT NULL,
    read_count    number    NOT NULL,
    
    -- 제약조건
    constraint pk_community_no primary key(community_no),
    constraint fk_community_writer foreign key(community_writer) references member(member_id) on delete cascade
);

--  community_notice_no sequence 생성
create sequence seq_community_no;



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
    constraint fk_community_comment_writer foreign key(writer) references member(member_id) on delete cascade,
    constraint fk_community_comment_notice_no foreign key(community_no) references community(community_no) on delete cascade,
    constraint fk_community_comment_ref foreign key(comment_ref) references community_comment(no) on delete cascade
);

--  자유게시판 댓글 시퀀스 생성
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

--  community_attach_no sequence 생성
create sequence seq_community_attach_no;



--  문의사항(qna_board)테이블 생성
CREATE TABLE qna_board (
    qna_no    number    NOT NULL,
    qna_writer    varchar2(20)    NOT NULL,
    qna_title    varchar2(30)    NOT NULL,
    qna_content    varchar2(4000)    NOT NULL,
    reg_date    date     DEFAULT sysdate     NOT NULL,
    answer_status    char(1)    DEFAULT 'N' NOT NULL,

    ------ 제악조건
    constraint pk_qna_no primary key(qna_no),
    constraint fk_qna_writer foreign key(qna_writer) references member(member_id) on delete cascade
);

--  qna_board sequence 생성
create sequence seq_qna_no;

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
    constraint fk_qna_comment_qna_no foreign key(qna_no) references qna_board(qna_no) on delete cascade,
    constraint fk_qna_comment_writer foreign key(writer) references member(member_id) on delete cascade,
    constraint fk_qna_comment_comment_ref foreign key(comment_ref) references qna_comment(no) on delete cascade
);

--  qna_comment_no sequence 생성
create sequence seq_qna_comment_no;
    
-- 문의 사항 첨부파일(qna_attach) 테이블 추가
CREATE TABLE  qna_attach (
    no number,
    qna_no    number    NOT NULL,
    original_filename    varchar2(255) NOT NULL,
    renamed_filename    varchar2(255) NOT NULL,
    reg_date    date     DEFAULT sysdate NOT NULL,
       
    -- 제약조건 추가
    constraint pk_qna_attach_no primary key(no),
    constraint fk_qna_attach_qna_no foreign key(qna_no) references qna_board(qna_no) on delete cascade
);

    --  qna_board sequence 생성
create sequence seq_qna_attach_no;



--  이용후기(review_board) 테이블 생성
CREATE TABLE review_board (
	review_no	number,
	review_writer	varchar2(30)	NOT NULL,
	review_title	varchar2(30)	NOT NULL,
	review_content	varchar2(4000)	NOT NULL,
    car_name	 varchar2(30)	NOT NULL,
	reg_date	date	 DEFAULT sysdate NOT NULL,
	read_count number NOT NULL,
	score number NOT NULL,
    
    -- 제약조건 생성
    constraint pk_review_no primary key(review_no),
    constraint fk_review_writer foreign key(review_writer) references member(member_id) on delete cascade,
    constraint fk_review_car_name foreign key(car_name) references car_info(car_name) on delete cascade
);

-- 이용후기 테이블 sequence 생성
create sequence seq_review_no;

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
    constraint fk_review_comment_review_no foreign key(review_no) references review_board(review_no) on delete cascade,
    constraint fk_review_comment_writer foreign key(writer) references member(member_id) on delete cascade,
    constraint fk_review_comment_comment_ref foreign key(comment_ref) references review_comment(no) on delete cascade
);

-- 이용후기 댓글 테이블 sequence 생성
create sequence seq_review_comment_no;

--  이용후기 첨부파일(Review_board_attach) 테이블 생성
CREATE TABLE review_attach (
	no	number,
	review_no number	NOT NULL,
	original_filename	varchar2(255)	NOT NULL,
	renamed_filename	varchar2(255)	NOT NULL,
	reg_date	date	 DEFAULT sysdate,
    
     -- 제약조건 생성
    constraint pk_review_attach_no primary key(no),
    constraint fk_review_attach_review_no foreign key(no) references review_board(review_no)
);

--
--ALTER TABLE review_attach
--RENAME CONSTRAINT fk_review_attach_board_no TO
--                  fk_review_attach_review_no;

-- 이용후기 첨부파일 테이블 sequence 생성
create sequence seq_review_attach_no;