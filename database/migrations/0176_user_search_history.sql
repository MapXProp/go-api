BEGIN;
CREATE TABLE public.user_search_history_state (
    user_id bigint PRIMARY KEY REFERENCES public.auth_users(id) ON DELETE CASCADE,
    revision bigint NOT NULL DEFAULT 0 CHECK (revision >= 0)
);
CREATE TABLE public.user_search_history (
    user_id bigint NOT NULL REFERENCES public.auth_users(id) ON DELETE CASCADE,
    event_id uuid NOT NULL,
    event jsonb NOT NULL CHECK (jsonb_typeof(event) = 'object'),
    searched_at timestamptz NOT NULL,
    PRIMARY KEY (user_id, event_id)
);
CREATE INDEX user_search_history_recent ON public.user_search_history(user_id, searched_at DESC, event_id);
COMMIT;
