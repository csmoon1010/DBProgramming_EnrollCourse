CREATE OR REPLACE FUNCTION Date2Enroll(today IN DATE)
RETURN NUMBER
IS
   month NUMBER;
   year NUMBER;
   semester NUMBER;
BEGIN
   month := TO_NUMBER(TO_CHAR(today, 'MM'));
   IF(month = 11 or month = 12) THEN
      year := (TO_NUMBER(TO_CHAR(today, 'YYYY')) + 1);
      semester := 1;
   ELSIF (month >= 5 and month <= 10) THEN
      year := TO_NUMBER(TO_CHAR(today, 'YYYY'));
      semester := 2;
   ELSE
      year := TO_NUMBER(TO_CHAR(today, 'YYYY'));
      semester := 1;
   END IF;
   RETURN year*10 + semester;
END;
/

/*year와 month를 합친 우리 형식의 sem으로 수정 */


