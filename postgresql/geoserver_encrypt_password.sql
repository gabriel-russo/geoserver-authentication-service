CREATE OR REPLACE FUNCTION geoserver.geoserver_encrypt_password() RETURNS TRIGGER AS $$
DECLARE
	passwd text := SPLIT_PART(NEW.password, 'plain:', 2);
BEGIN

	IF (passwd <> '') IS TRUE THEN

		IF TG_OP = 'UPDATE' THEN
 			IF (OLD.password = passwd) IS TRUE THEN
				RETURN OLD;
			END IF;
		END IF;

		NEW.password := crypt(passwd, gen_salt('bf', 8));

		RETURN NEW;
	END IF;

	RAISE EXCEPTION 'Error on Update or Select, password is empty';
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tg_geoserver_encrypt_password
	BEFORE INSERT OR UPDATE
	OF password
	ON geoserver.users
FOR EACH ROW EXECUTE PROCEDURE geoserver.geoserver_encrypt_password();
