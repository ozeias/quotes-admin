--
-- Name: events; Type: TABLE; Schema: public;
--
DROP TABLE IF EXISTS public.events;

CREATE TABLE public.events (
    id BIGSERIAL NOT NULL,
    user_id uuid references auth.users on delete cascade,
    resource_id uuid,
    resource_type character varying,
    event_type SMALLINT NOT NULL,
    event_count INTEGER DEFAULT 1 NOT NULL,
    created_at timestamp(6) without time zone NOT NULL DEFAULT NOW()
);

--
-- Name: quotes events_pkey; Type: CONSTRAINT; Schema: public;
--
ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);

--
-- Name: index_events_on_event_type; Type: INDEX; Schema: public;
--
CREATE INDEX index_events_on_event_type ON public.events USING btree (event_type);

--
-- Security
--
ALTER TABLE "public"."events" OWNER TO "postgres";
ALTER TABLE "public"."events" ENABLE ROW LEVEL SECURITY;

-- GRANT ALL ON TABLE "public"."events" TO "anon";
GRANT ALL ON TABLE "public"."events" TO "authenticated";
GRANT ALL ON TABLE "public"."events" TO "service_role";

CREATE POLICY "Enable insert for authenticated users" ON "public"."events"
AS PERMISSIVE FOR INSERT
TO authenticated
WITH CHECK ((event_type IN (1,2,3)) AND ((resource_type)::text = 'quotes'::text));

--
-- Name: update_quotes_likes; Type: FUNCTION; Schema: public;
--
CREATE OR REPLACE FUNCTION public.update_quotes_likes() RETURNS void AS $$
BEGIN
  RAISE NOTICE 'Refreshing all quotes likes...';
  WITH deleted_events AS (
    DELETE FROM events WHERE resource_type = 'quotes' AND event_type = 1 RETURNING *),
    quotes_update AS (
      SELECT resource_id, SUM(event_count) AS count FROM deleted_events GROUP BY resource_id)

  UPDATE quotes SET likes_count = likes_count + quotes_update.count FROM quotes_update WHERE quotes.id = quotes_update.resource_id;
RAISE NOTICE 'Done refreshing quotes likes.';
END;
$$ LANGUAGE plpgsql;

--
-- Name: update_quotes_shares; Type: FUNCTION; Schema: public;
--
CREATE OR REPLACE FUNCTION public.update_quotes_shares() RETURNS void AS $$
BEGIN
  RAISE NOTICE 'Refreshing all quotes shares...';
  WITH deleted_events AS (
    DELETE FROM events WHERE resource_type = 'quotes' AND event_type = 2 RETURNING *),
    quotes_update AS (
      SELECT resource_id, SUM(event_count) AS count FROM deleted_events GROUP BY resource_id)

  UPDATE quotes SET shares_count = shares_count + quotes_update.count FROM quotes_update WHERE quotes.id = quotes_update.resource_id;
  RAISE NOTICE 'Done refreshing quotes shares.';
END;
$$ LANGUAGE plpgsql;

--
-- Name: update_quotes_favorites; Type: FUNCTION; Schema: public;
--
CREATE OR REPLACE FUNCTION public.update_quotes_favorites() RETURNS void AS $$
BEGIN
  RAISE NOTICE 'Refreshing all quotes favorites...';
  WITH deleted_events AS (
    DELETE FROM events WHERE resource_type = 'quotes' AND event_type = 3 RETURNING *),
    quotes_update AS (
      SELECT resource_id, SUM(event_count) AS count FROM deleted_events GROUP BY resource_id)

  UPDATE quotes SET favorites_count = favorites_count + quotes_update.count FROM quotes_update WHERE quotes.id = quotes_update.resource_id;
  RAISE NOTICE 'Done refreshing quotes favorites.';
END;
$$ LANGUAGE plpgsql;

--
-- Name: pg_cron; Type: EXTENSION; Schema: extensions;
--
CREATE EXTENSION IF NOT EXISTS "pg_cron" WITH SCHEMA "extensions";

--
-- Name: update_quotes_likes; Type: JOB; Schema: public;
--
SELECT cron.schedule('update_quotes_likes', '*/15 * * * *', 'SELECT public.update_quotes_likes()');

--
-- Name: update_quotes_shares; Type: JOB; Schema: public;
--
SELECT cron.schedule('update_quotes_shares', '5,20,35,50 * * * *', 'SELECT public.update_quotes_shares()');

--
-- Name: update_quotes_favorites; Type: JOB; Schema: public;
--
SELECT cron.schedule('update_quotes_favorites', '10,25,40,55 * * * *', 'SELECT public.update_quotes_favorites()');
