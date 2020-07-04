CREATE OR REPLACE TRIGGER BeforeUpdateStudent 
BEFORE
UPDATE ON student
FOR EACH ROW
DECLARE
	underflow_length EXCEPTION;
	invalid_value EXCEPTION;
	not_email_format EXCEPTION;
	not_phone_format EXCEPTION;
	nLength NUMBER;
	nBlank NUMBER;
	isEmail NUMBER;
	isPhone NUMBER;	
BEGIN
	/*폰번호형식*/
	SELECT COUNT(*)
	INTO isPhone
	FROM DUAL
	WHERE REGEXP_LIKE(:new.s_phone, '\d{2,3}-\d{3,4}-\d{4}');
	
	nLength := LENGTH(:new.s_pwd); /*암호의 길이*/
	nBlank := nLength - LENGTH(REPLACE(:new.s_pwd, ' ', '')); /*공란*/
	isEmail := INSTR(:new.s_email, '@', 1, 1); /*이메일형식*/

	IF (nLength < 4) THEN
		RAISE underflow_length;
	ELSIF (nBlank <> 0) THEN
		RAISE invalid_value;
	ELSIF (isEmail <= 0) THEN
		RAISE not_email_format;
	ELSIF (isPhone <= 0) THEN
		RAISE not_phone_format;
	END IF;
	EXCEPTION
		WHEN underflow_length THEN
			RAISE_APPLICATION_ERROR(-20002, '암호길이');
		WHEN invalid_value THEN
			RAISE_APPLICATION_ERROR(-20003, '공란');
		WHEN not_email_format THEN
			RAISE_APPLICATION_ERROR(-20004, '이메일형식');
		WHEN not_phone_format THEN
			RAISE_APPLICATION_ERROR(-20005, '폰번호형식');
		WHEN OTHERS THEN
			DBMS_OUTPUT.PUT_LINE('기타 에러 발생');
END;
/
