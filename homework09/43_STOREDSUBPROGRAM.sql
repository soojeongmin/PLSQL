--1) 전공과 전공별 기말고사 평균 점수를 갖는 테이블
--   T_MAJOR_AVG_RES를 생성하고 SCORE테이블과 STUDENT테이블을 참조해서
--   T_MAJOR_AVG_RES에 데이터를 저장하는 프로시저 P_MAJOR_AVG_RES를 생성하세요.
CREATE TABLE T_MAJOR_AVG_RES(
    MAJOR VARCHAR2(20),
    AVG_RES NUMBER(5, 2)
);
CREATE OR REPLACE PROCEDURE P_MAJOR_AVG_RES
IS
    CURSOR CUR_MAJOR_AVG_RES IS
        SELECT ST.MAJOR
             , ROUND(AVG(SC.RESULT), 2) AS AVG_RES
        FROM STUDENT ST
        JOIN SCORE SC
          ON ST.SNO = SC.SNO
        GROUP BY ST.MAJOR;
BEGIN
    DELETE FROM T_MAJOR_AVG_RES;
    FOR MAJOR_AVG_RES_ROW IN CUR_MAJOR_AVG_RES LOOP
        INSERT INTO T_MAJOR_AVG_RES
        VALUES MAJOR_AVG_RES_ROW;
        COMMIT;
    END LOOP;
END;
/

EXEC P_MAJOR_AVG_RES;

SELECT * FROM T_MAJOR_AVG_RES;

--2) 교수들은 부임일로부터 5년마다 안식년을 갖습니다.
--   교수들의 오늘날짜까지의 안식년 횟수를 리턴하는 함수 F_GET_VACATION_CNT를 구현하세요.
CREATE OR REPLACE FUNCTION F_GET_VACATION_CNT (PARAM_DATE DATE)
RETURN NUMBER
IS
BEGIN
    RETURN (MONTHS_BETWEEN(SYSDATE, PARAM_DATE)/12)/5;
END;
/
SELECT PNO
     , PNAME
     , HIREDATE
     , ROUND(F_GET_VACATION_CNT(HIREDATE), 0) AS "안식년"
    FROM PROFESSOR;