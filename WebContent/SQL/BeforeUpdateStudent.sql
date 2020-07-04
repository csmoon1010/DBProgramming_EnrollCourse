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
	/*����ȣ����*/
	SELECT COUNT(*)
	INTO isPhone
	FROM DUAL
	WHERE REGEXP_LIKE(:new.s_phone, '\d{2,3}-\d{3,4}-\d{4}');
	
	nLength := LENGTH(:new.s_pwd); /*��ȣ�� ����*/
	nBlank := nLength - LENGTH(REPLACE(:new.s_pwd, ' ', '')); /*����*/
	isEmail := INSTR(:new.s_email, '@', 1, 1); /*�̸�������*/

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
			RAISE_APPLICATION_ERROR(-20002, '��ȣ����');
		WHEN invalid_value THEN
			RAISE_APPLICATION_ERROR(-20003, '����');
		WHEN not_email_format THEN
			RAISE_APPLICATION_ERROR(-20004, '�̸�������');
		WHEN not_phone_format THEN
			RAISE_APPLICATION_ERROR(-20005, '����ȣ����');
		WHEN OTHERS THEN
			DBMS_OUTPUT.PUT_LINE('��Ÿ ���� �߻�');
END;
/
