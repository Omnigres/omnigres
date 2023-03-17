CREATE TYPE http_method AS ENUM ('GET', 'HEAD', 'POST', 'PUT', 'DELETE', 'CONNECT', 'OPTIONS', 'TRACE', 'PATCH');

CREATE TYPE http_header AS (
    name text,
    value text,
    append bool
);

CREATE TYPE http_request AS (
    method http_method,
    path text,
    query_string text,
    body bytea,
    headers http_header[]
);

CREATE FUNCTION http_header(name text, value text, append bool DEFAULT false) RETURNS http_header AS $$
SELECT ROW(name, value, append) AS result;
$$
LANGUAGE SQL;

CREATE TYPE http_response AS (
    status smallint,
    headers http_header[],
    body bytea
);

CREATE FUNCTION http_response(
    status int DEFAULT 200,
    headers http_header[] DEFAULT array[]::http_header[],
    body anycompatible DEFAULT ''::bytea
)
    RETURNS http_response
    AS 'MODULE_PATHNAME', 'http_response'
    LANGUAGE C;

CREATE DOMAIN port integer CHECK (VALUE >= 0 AND VALUE <= 65535);

CREATE TYPE http_protocol AS ENUM ('http', 'https');


CREATE TABLE handlers (
    id integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    role_name name NOT NULL DEFAULT current_user CHECK (current_user = role_name),
    name text
);

CREATE TABLE handlers_queries (
   id integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
   handler_id integer NOT NULL REFERENCES handlers (id),
   query text,
   name text,
   priority integer
);

CREATE FUNCTION handlers_queries_validity_trigger() RETURNS trigger
AS 'MODULE_PATHNAME', 'handlers_queries_validity_trigger' LANGUAGE C;

CREATE CONSTRAINT TRIGGER handlers_queries_validity_trigger AFTER INSERT OR UPDATE
  ON handlers_queries
  DEFERRABLE INITIALLY DEFERRED
  FOR EACH ROW
  EXECUTE FUNCTION handlers_queries_validity_trigger();

 CREATE TABLE listeners (
    id integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    address inet NOT NULL DEFAULT '127.0.0.1',
    port port NOT NULL DEFAULT 80,
    protocol http_protocol NOT NULL DEFAULT 'http',
    handler_id integer NOT NULL REFERENCES handlers (id)
);

CREATE TABLE configuration_reloads (
    id integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    happened_at timestamp NOT NULL DEFAULT now()
);

-- Wait for the number of configuration reloads to be `n` or greater
-- Useful for testing
CREATE PROCEDURE wait_for_configuration_reloads(n int) AS $$
DECLARE
c int;
BEGIN
LOOP
 SELECT count(*) INTO c  FROM omni_httpd.configuration_reloads;
 EXIT WHEN c >= n;
END LOOP;
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION reload_configuration_trigger() RETURNS trigger
    AS 'MODULE_PATHNAME', 'reload_configuration'
    LANGUAGE C;

CREATE FUNCTION reload_configuration() RETURNS bool
    AS 'MODULE_PATHNAME', 'reload_configuration'
    LANGUAGE C;

CREATE TRIGGER listeners_updated
    AFTER UPDATE OR DELETE OR INSERT
    ON listeners
EXECUTE FUNCTION reload_configuration_trigger();

CREATE TRIGGER handlers_updated
    AFTER UPDATE OR DELETE OR INSERT
    ON handlers
EXECUTE FUNCTION reload_configuration_trigger();

CREATE TRIGGER handlers_queries_updated
    AFTER UPDATE OR DELETE OR INSERT
    ON handlers_queries
EXECUTE FUNCTION reload_configuration_trigger();

CREATE FUNCTION cascading_query_reduce(internal, name text, query text) RETURNS internal
 AS 'MODULE_PATHNAME', 'cascading_query_reduce' LANGUAGE C;

CREATE FUNCTION cascading_query_final(internal) RETURNS text
 AS 'MODULE_PATHNAME', 'cascading_query_final' LANGUAGE C;

CREATE AGGREGATE cascading_query (name text, query text) (
  sfunc = cascading_query_reduce,
  finalfunc = cascading_query_final,
  stype = internal
 );

-- Initialization
WITH config AS
          (SELECT coalesce(NOT current_setting('omni_httpd.no_init', true)::bool, true)     AS should_init,
                  coalesce(current_setting('omni_httpd.init_listen_address', true),
                           '0.0.0.0')::inet                                                 AS init_listen_address,
                  coalesce(current_setting('omni_httpd.init_port', true)::port, 8080::port) AS init_port),
      handler AS (INSERT INTO handlers (name) VALUES ('default') RETURNING id),
      listener AS (INSERT INTO listeners (address, port, handler_id) SELECT init_listen_address, init_port, (SELECT id FROM handler) FROM config RETURNING id)
      INSERT INTO handlers_queries (handler_id, query) SELECT queries.* FROM (VALUES((SELECT id FROM handler),
        $$
        WITH stats AS (SELECT * FROM pg_catalog.pg_stat_database WHERE datname = current_database())
        SELECT omni_httpd.http_response(headers => array[omni_httpd.http_header('content-type', 'text/html')],
        body => $html$
        <!DOCTYPE html>
        <html>
          <head>
            <title>Omnigres</title>
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bulma@0.9.4/css/bulma.min.css">
            <meta name="viewport" content="width=device-width, initial-scale=1">
          </head>
          <body class="container">
          <section class="section">
            <div class="container">
              <h1 class="title">Omnigres</h1>

              <div class="tile is-ancestor">
                 <div class="tile is-parent is-8">
                  <article class="tile is-child notification is-primary">
                    <div class="content">
                      <p class="title">Welcome!</p>
                      <p class="subtitle">What's next?</p>
                      <div class="content">
                      <p>You can update the query in the <code>omni_httpd.handlers</code> table to change this default page.</p>

                      <p><a href="https://docs.omnigres.org">Documentation</a></p>
                      </div>
                    </div>
                  </article>
                </div>
                <div class="tile is-vertical">
                  <div class="tile">
                    <div class="tile is-parent is-vertical">
                      <article class="tile is-child notification is-grey-lighter">
                        <p class="title">Database</p>
                        <p class="subtitle"><strong>$html$ || current_database() || $html$</strong></p>
                        <p> <strong>Backends</strong>: $html$ || (SELECT numbackends FROM stats) || $html$ </p>
                        <p> <strong>Transactions committed</strong>: $html$ || (SELECT xact_commit FROM stats) || $html$ </p>
                      </article>
                    </div>
                  </div>
                </div>
              </div>

              <p class="is-size-7">
                Running on <strong> $html$ || version() || $html$ </strong>
              </p>
            </div>
          </section>
          </body>
        </html>
        $html$) FROM request $$)) AS queries(handler_id, query), config, listener WHERE config.should_init;
