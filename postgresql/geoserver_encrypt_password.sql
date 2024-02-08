CREATE OR REPLACE FUNCTION geoserver.geoserver_encrypt_password() RETURNS TRIGGER AS $$
DECLARE
	passwd text := SPLIT_PART(NEW.password, 'plain:', 2);
BEGIN

	IF (passwd <> '') IS TRUE THEN

		NEW.password := crypt(passwd, gen_salt('bf', 8));
	ELSE
		RAISE EXCEPTION 'Password string empty';
	END IF;

	RETURN NEW;
END; 
$$ LANGUAGE plpgsql;

CREATE TRIGGER tg_geoserver_encrypt_password
	BEFORE INSERT OR UPDATE 
	ON geoserver.users
FOR EACH ROW EXECUTE PROCEDURE geoserver.geoserver_encrypt_password();
