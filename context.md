# Video API — Full Codebase Analysis

## 1. What the App Does

**Video API** is a self-hosted video transcoding and streaming service built with the Elixir Phoenix framework. It allows users to:

- **Sign up / sign in** with email and password (bcrypt-hashed)
- **Upload MP4 videos** via a web UI (multipart form)
- **Transcode videos** into HLS (HTTP Live Streaming) adaptive-bitrate formats: 360p, 480p, 720p, 1080p using FFmpeg (shelled out via Porcelain)
- **Watch videos** through an embedded Video.js player
- **Organize videos into "Properties"** (sites/projects)
- **Publish videos to Properties** — this makes them available via the JSON API
- **Generate/revoke API auth tokens** per Property for external access
- **JSON API** (`/api/videos`, `/api/videos/:id`, `/api/property`) — token-authenticated, returns published videos
- **Stream transcoded segments** via `/stream/:guid/:filename` for HLS playback (serves `.m3u8` and `.ts` files)
- **Dashboard** showing video count, published count, property count, recent transcoding events
- **Pagination** via Scrivener on videos, transcoding logs, properties, and auth tokens

Key business model: users upload videos, the system transcodes them, users publish them to "properties" (representing external sites/apps), then external apps consume published videos via a token-authenticated JSON API.

---

## 2. Tech Stack and Key Dependencies

### Backend (Elixir / Phoenix)
| Dependency | Version | Purpose |
|---|---|---|
| **Elixir** | ~> 1.7 (runs on 1.10.2 per buildpack) | Language |
| **Erlang OTP** | 22.2 | Runtime |
| **Phoenix** | 1.5.7 | Web framework |
| **Ecto** | 3.5.5 | Database ORM |
| **Ecto SQL** | 3.5.3 | SQL adapter |
| **Postgrex** | 0.15.7 | PostgreSQL driver |
| **Guardian** | 2.1.1 | JWT-based authentication |
| **Bcrypt** | 2.2.0 | Password hashing |
| **Honeydew** | 1.4.6 | Job queue (in-memory, for async transcoding) |
| **Porcelain** | 2.0.3 | External process runner (shells out to bash/FFmpeg) |
| **EctoEnum** | 1.4.0 | Enum-backed DB columns |
| **Scrivener** | 2.7.0 | Pagination |
| **Scrivener Ecto** | 2.7.0 | Ecto-backed pagination |
| **Scrivener HTML** | 1.8.1 | Pagination helpers in templates |
| **CORS Plug** | 2.0.2 | CORS headers for JSON API |
| **Jason** | 1.2.2 | JSON encoding |
| **Cowboy** | 2.8.0 | HTTP server |
| **Gettext** | 0.17.4 | i18n (minimally used) |

### Frontend
| Tool | Version | Purpose |
|---|---|---|
| **Webpack** | 4.41.5 | JS/CSS bundling |
| **React** | 16.13.0 | Publish page component |
| **ReactDOM** | 16.13.0 | Render React components |
| **@kenshooui/react-multi-select** | 1.1.6 | Multi-select for video publishing |
| **Video.js** | 7.6.6 | HTML5 video player |
| **Bulma** | 0.8.0 | CSS framework |
| **Babel** | 7.12.10 | JS transpilation |
| **Node Sass** | 4.13.1 | SCSS compilation |

### Infrastructure
| Tool | Purpose |
|---|---|
| **FFmpeg** | Video transcoding (installed via `apt-packages`) |
| **bc** | `apt-packages` — used in HLS script for FPS calculations |
| **PostgreSQL** | Primary database |
| **Heroku / Dokku** | Deployment target (per README and todo.md) |
| **Heroku Buildpacks** | `heroku-buildpack-elixir` + `heroku-buildpack-phoenix-static` |

---

## 3. File Structure Overview

```
video-api/
├── mix.exs                          # Project definition, deps, aliases
├── mix.lock                         # Locked dependency versions
├── README.md                        # Minimal overview
├── todo.md                          # Feature checklist (mostly done)
├── Procfile                         # "web: elixir --sname server -S mix phx.server"
├── .formatter.exs                   # Elixir formatter config
├── .buildpacks                      # Heroku buildpacks list
├── elixir_buildpack.config          # Erlang 22.2 / Elixir 1.10.2
├── phoenix_static_buildpack.config  # Node 13.9.0 / compile script
├── compile                          # "npm run deploy && mix phx.digest"
├── apt-packages                     # "bc\nffmpeg"
├── nginx.conf.d/
│   └── upload.conf                  # client_max_body_size 50m
│
├── config/
│   ├── config.exs                   # Base config (DB, secrets, upload dirs, Guardian, Porcelain)
│   ├── dev.exs                      # Dev overrides (port 4000, webpack watchers, DB creds)
│   ├── prod.exs                     # Prod overrides (env vars, HTTPS, SSL)
│   └── test.exs                     # Test overrides (sandbox pool, test DB)
│
├── lib/
│   ├── video_api.ex                 # Top-level module (empty, just docs)
│   ├── video_api/
│   │   ├── application.ex           # OTP Application (supervisor, Honeydew queue/workers)
│   │   ├── repo.ex                  # Ecto Repo (Postgres + Scrivener pagination)
│   │   ├── ecto_enums.ex            # StatusEnum + ErrorLevelEnum definitions
│   │   ├── utils.ex                 # Path/URL helpers for videos and transcodes
│   │   ├── accounts/
│   │   │   ├── accounts.ex          # User CRUD context
│   │   │   ├── auth.ex              # Sign-in authentication logic
│   │   │   ├── encryption.ex        # Bcrypt password hashing
│   │   │   ├── user.ex              # User Ecto schema + changesets
│   │   │   └── users.ex             # Alternate user context (duplicated!)
│   │   ├── auth_tokens/
│   │   │   ├── auth_token.ex        # AuthToken schema + changesets
│   │   │   └── auth_tokens.ex       # AuthToken context (CRUD, generation)
│   │   ├── videos/
│   │   │   ├── video.ex             # Video schema + changesets
│   │   │   └── videos.ex            # Video context (CRUD, file persistence, async transcode)
│   │   ├── transcodings/
│   │   │   ├── transcoder.ex        # Honeydew worker: shells out to FFmpeg bash script
│   │   │   ├── transcoding_log.ex   # TranscodingLog schema + changeset
│   │   │   └── transcodings.ex      # Transcodings context (log creation)
│   │   ├── properties/
│   │   │   ├── property.ex          # Property schema + changesets
│   │   │   └── properties.ex        # Properties context (CRUD)
│   │   ├── publish/
│   │   │   ├── publish.ex           # Publish context (video-to-property linking)
│   │   │   └── published.ex         # Published join-table schema
│   │   └── json/
│   │       └── json.ex              # JSON API context (token-authenticated queries)
│   │
│   └── video_api_web/
│       ├── video_api_web.ex         # Phoenix web module (controller/view/router macros)
│       ├── endpoint.ex              # Phoenix endpoint (static files, sessions, parsers, CORS)
│       ├── router.ex                # Routes: public, authenticated, API, streaming
│       ├── gettext.ex               # Gettext i18n module
│       ├── guardian/
│       │   ├── guardian.ex          # Guardian JWT implementation
│       │   ├── auth_error_handler.ex # Redirect to sign-in on auth failure
│       │   ├── auth_pipeline.ex     # Enforce auth pipeline
│       │   └── load_session_pipeline.ex # Load session (no enforcement)
│       ├── plugs/
│       │   ├── current_user.ex      # Assigns :current_user to conn
│       │   └── redirector.ex        # Redirects authed users away from sign-in pages
│       ├── channels/
│       │   └── user_socket.ex       # WebSocket socket (unused, no channels defined)
│       ├── controllers/             # 12 controllers (see below)
│       ├── views/                   # 13 view modules
│       └── templates/               # EEx templates organized by controller
│
├── priv/
│   ├── repo/
│   │   ├── migrations/              # 7 Ecto migrations
│   │   └── seeds.exs                # Empty seed file
│   ├── scripts/
│   │   └── create-vod-hls.sh       # FFmpeg HLS transcoding script (1080p, 720p, 480p, 360p)
│   └── gettext/                     # i18n .po/.pot files
│
├── assets/
│   ├── package.json                 # Frontend dependencies
│   ├── webpack.config.js            # Webpack 4 config
│   ├── babel.config.json            # Babel config (React + env presets)
│   ├── css/app.scss                 # Bulma + custom styles
│   ├── js/
│   │   ├── app.js                   # Entry point
│   │   ├── socket.js                # Phoenix socket (unused)
│   │   ├── common/index.js          # Navbar burger toggle
│   │   ├── per_pages/
│   │   │   ├── index.js             # Auto-loads page-specific JS by body[data-js-file]
│   │   │   ├── videoview_new.js     # File input label updater
│   │   │   ├── videoview_show.js    # Loads Video.js
│   │   │   └── publishview_new.js   # React publish page (multi-select)
│   │   └── components/
│   │       ├── dropdown.js          # React dropdown component
│   │       ├── property_select.js   # React property selector
│   │       └── video_select.js      # React video multi-select
│   └── static/                      # Static assets (favicon, images, robots.txt)
│
└── test/
    ├── video_api/
    │   ├── api_keys/api_keys_test.exs           # Tests for non-existent ApiKeys context
    │   ├── properties/properties_test.exs        # Property context tests (outdated)
    │   └── transcodings/transcodings_test.exs    # Transcoding context tests (outdated)
    └── video_api_web/controllers/
        ├── api_key_controller_test.exs           # Tests for non-existent controller
        ├── property_controller_test.exs          # Property controller tests (basic)
        └── transcoding_controller_test.exs       # Transcoding controller tests (outdated)
```

### Controllers and Their Roles

| Controller | Routes | Auth | Purpose |
|---|---|---|---|
| `PageController` | `GET /` | Public | Landing page |
| `SessionController` | `GET /sign_in`, `POST /sign_in`, `GET /sign_out` | Public/Auth | Sign in/out |
| `SignUpController` | `GET /sign_up`, `POST /sign_up` | Public | User registration |
| `DashboardController` | `GET /dashboard` | Auth | Dashboard with stats |
| `DocumentationController` | `GET /documentation` | Auth | API docs page |
| `VideoController` | CRUD `/videos`, `GET /videos/json` | Auth | Video management |
| `TranscodingController` | `GET /transcodings` (index only) | Auth | Transcoding log viewer |
| `PropertyController` | CRUD `/properties` | Auth | Property (site) management |
| `PublishController` | `GET /publish`, `POST /publish` | Auth | Publish videos to properties |
| `AuthTokenController` | `POST /user/auth/generate`, `DELETE /user/auth/:id` | Auth | API key management |
| `UserController` | Profile show/edit/update | Auth | User profile |
| `JsonController` | `GET /api/*` | API key | JSON API for external consumption |
| `StreamController` | `GET /stream/:guid/:filename` | CORS only | Serve HLS segments |
| `WatchController` | `GET /watch/:id` | Auth | Range-request video serving |

---

## 4. How It's Built and Deployed

### Development

```bash
# Start PostgreSQL, then:
mix deps.get
cd assets && npm install && cd ..
mix ecto.create && mix ecto.migrate
mix phx.server  # Webpack runs as a watcher in dev
```

The dev config starts on port 4000 with webpack watching assets. Uploads and transcodes are stored at `/home/cory/Downloads/tmp/` and `/home/cory/Downloads/tmp/transcodes` (hardcoded in dev config).

### Production (Heroku/Dokku)

**Buildpacks:**
1. `heroku-buildpack-elixir` — compiles Elixir app
2. `heroku-buildpack-phoenix-static` — runs `npm run deploy` (webpack production build), then `mix phx.digest`

**Runtime:** `Procfile` starts `elixir --sname server -S mix phx.server`

**System deps:** `apt-packages` installs `bc` and `ffmpeg` on the host

**Nginx:** `upload.conf` sets `client_max_body_size 50m` (used with nginx buildpack or Dokku nginx plugin)

**config/prod.exs** reads all sensitive values from environment variables:
- `DATABASE_URL`, `SECRET_KEY_BASE`, `SECRET_KEY` (Guardian), `UPLOADS_DIR`, `TRANSCODES_DIR`, `SERVER_URL`, `PORT`

### Data Flow

```
User uploads MP4 → VideoController.create → Videos.create_video
  → Ecto.Multi: insert video row + persist file to uploads_dir
  → Honeydew.async({:transcode, [video]}, :transcoding_jobs)

Honeydew worker (VideoApi.Transcoder.transcode/1):
  → Shells out: bash create-vod-hls.sh <source> <output_dir>
  → FFmpeg creates .m3u8 playlists + .ts segments (360p/480p/720p/1080p)
  → Logs progress/errors to transcoding_logs table
  → Updates video.status → :complete or :failed

Publishing:
  → PublishController links videos to a Property via Published join table

External API consumption:
  → GET /api/videos?api_key=<token>
  → JsonController → Json context queries through AuthToken → Property → Published → Video
  → Returns JSON with video URLs pointing to /stream/:guid/:filename
```

---

## 5. Obvious Issues and Outdated Patterns

### Critical / High Severity

1. **Hardcoded secrets in `config/config.exs`** (lines 14, 23-24):
   - `secret_key_base` (`HkeaNO...`) and Guardian `secret_key` (`wnYhbR...`) are committed in plaintext to version control. These should be sourced from env vars or secret files.

2. **Hardcoded local paths in `config/config.exs`** (lines 26-27):
   - `uploads_dir: "/home/cory/Downloads/tmp/"` and `transcodes_dir: "/home/cory/Downloads/tmp/transcodes"` — these are specific to the original developer's machine. They should move to `dev.exs` or use env vars.

3. **Duplicated `Accounts` context** — There are TWO user context modules:
   - `lib/video_api/accounts/accounts.ex` (`VideoApi.Accounts`) — has `get_user!/1`, `create_user/1`, `update_user/2`, `delete_user/1`
   - `lib/video_api/accounts/users.ex` (`VideoApi.Accounts.Users`) — has `get_user/1`, `get_user!/1`, `create_user/1`
   - Both define `get_user!/1` and `create_user/1` with identical implementations. The `Auth` module calls `VideoApi.Accounts.Encryption` and `VideoApi.Accounts.User` directly. The `SessionController` uses `Accounts`; the `Guardian` uses `Accounts.Users`. This is confusing and error-prone.

4. **`AuthToken` schema has wrong association** (`lib/video_api/auth_tokens/auth_token.ex`, line 11):
   - `belongs_to(:property, VideoApi.Accounts.User)` — should be `VideoApi.Properties.Property`, NOT `VideoApi.Accounts.User`. This is a bug that could cause runtime errors if the association is traversed.

5. **`JsonController` uses `render` after `put_status`** (lines 12, 24, 36):
   - `put_status(conn, :not_found) |> json(%{})` — the `json(%{})` call overwrites the status. Correct would be `conn |> put_status(:not_found) |> json(%{})` (which it does), but testing this may not produce the expected status code because the rendering pipeline may reset it.

### Medium Severity

6. **Duplicate function definitions in `AuthTokens` context** (`lib/video_api/auth_tokens/auth_tokens.ex`, lines 36-50):
   - `list_auth_tokens/2` is defined twice (identical body). This will not compile.

7. **PublishController has two `create/2` clauses** — the second one (`create(conn, _params)`) will never match because the first handles all cases. This is dead code.

8. **`Redirector` plug logic appears inverted** (`lib/video_api_web/plugs/redirector.ex`, line 20-28):
   - `if authenticated?(conn) and current_resource(conn) != nil → redirect to session_path(:new)` — this redirects already-authenticated users to the sign-in page instead of the dashboard. The condition logic seems reversed. Also, `current_resource(conn) != nil` should be truthy if authenticated, making the second clause unreachable.

9. **Test files reference modules/contexts that don't exist**:
   - `test/video_api/api_keys/api_keys_test.exs` — references `VideoApi.ApiKeys`, `VideoApi.ApiKeys.ApiKey`, `ApiKeys.create_api_key/1`, etc. None of these modules exist. The actual module is `VideoApi.AuthTokens` / `VideoApi.AuthTokens.AuthToken`.
   - `test/video_api/transcodings/transcodings_test.exs` — references `Transcodings.create_transcoding/1`, `Transcoding` struct with fields `video_1080p`, `video_360p`, etc. These don't match the actual `TranscodingLog` schema.
   - `test/video_api_web/controllers/api_key_controller_test.exs` — references `ApiKeys.create_api_key/1` which doesn't exist.
   - `test/video_api_web/controllers/transcoding_controller_test.exs` — references `Transcodings.create_transcoding/1` with outdated fields.

10. **No test support files** — `mix.exs` references `test/support` in `elixirc_paths/1` but there is no `test/support/` directory. Test helper modules like `DataCase` and `ConnCase` are undefined, meaning tests cannot compile or run as-is.

11. **`Transcodings.log/3` silently swallows errors** (`lib/video_api/transcodings/transcodings.ex`, lines 30-40):
    - Uses `Enum.each` on split log lines but discards the result. If any `Repo.insert()` fails, the error is silently ignored.

12. **`Transcoder.transcode/1` pattern match for error** (`lib/video_api/transcodings/transcoder.ex`, lines 24-31):
    - Matches `%Result{out: output, status: 1}` then also has a catch-all `error ->` clause. The `status: 1` match captures a failure and logs it, but the catch-all also logs and returns `{:error, error}`. The catch-all is needed for non-zero exit codes other than 1, but the `status: 1` clause doesn't return an error tuple — it just returns the value of `Videos.update_video_status(video, :failed)`, which could be `{:ok, video}` — making a failure appear successful.

### Low Severity / Code Quality

13. **`Utils.build_video_url/1` is hardcoded** (`lib/video_api/utils.ex`, line 10):
    - Always appends `1080p.m3u8` regardless of available renditions. Should use `playlist.m3u8` (the master playlist generated by the transcoding script).

14. **Outdated dependencies**:
    - Elixir `~> 1.7` but runs on 1.10.2 — Phoenix 1.5.7 supports Elixir 1.7+
    - Node 13.9.0 (EOL since June 2020)
    - Webpack 4.41.5 (Webpack 5 released Oct 2020)
    - `node-sass` 4.13.1 (deprecated in favor of `sass`/dart-sass)
    - `hard-source-webpack-plugin` is deprecated and can cause issues with newer Node versions
    - `uglifyjs-webpack-plugin` 2.0.0 is redundant alongside TerserPlugin

15. **No test helper/support modules** — `mix.exs` configures `elixirc_paths(:test)` to include `test/support` but the directory doesn't exist. Tests reference `use VideoApi.DataCase` and `use VideoApiWeb.ConnCase` but neither module is defined.

16. **EEx templates use deprecated `@conn` and `@` assigns** — This is standard Phoenix 1.5 style, but Phoenix 1.6+ moved to HEEx. Not a bug, just outdated.

17. **`VideoApiWeb.UserSocket` is unused** — Sockets endpoint is registered but no channels are defined and the JS socket connection has no authentication.

18. **`VideoApiWeb.TranscodingController` only has `:index` in routes but test references `:new`, `:create`, `:edit`, `:update`, `:delete`, `:show`**.

19. **`Videos.video_stats/1` uses raw SQL string** (`lib/video_api/videos/videos.ex`, line 15):
    - `from v in "videos"` uses a string table name instead of the schema module. The `published` count is hardcoded to 0.

20. **No input validation on stream controller filenames beyond basic regex** — `@allowed_files ~r/(1080p|360p|720p|480p)(_[0-9]+)*/` — doesn't prevent path traversal on the `guid` parameter, which is used directly in `Path.join`. Though `guid` comes from the DB's UUID path, any path traversal in the DB could be exploitable.

21. **CORS configuration is permissive** — `StreamController` uses the `:cors` pipeline without an authentication check, meaning anyone with a valid URL can stream video segments.

22. **`PublishController` accepts raw comma-separated string from a hidden input** — `String.split(video_ids, ",")` could break if video IDs contain unexpected characters, and there's no validation that the IDs belong to the current user until the SQL query filters.

23. **`StreamController` MIME type is hardcoded** (`video/mp2t` for both .m3u8 and .ts) — `.m3u8` files should be served as `application/vnd.apple.mpegurl` or `application/x-mpegURL`.

24. **Package lock files committed without corresponding install** — `package-lock.json` exists at project root but `package.json` is in `assets/`. The root-level `package-lock.json` appears unused.

---

## Key Entry Points

| What | File | Lines |
|---|---|---|
| OTP Application start | `lib/video_api/application.ex` | 1-30 |
| Router / routes | `lib/video_api_web/router.ex` | 1-80 |
| Video upload + transcode flow | `lib/video_api/videos/videos.ex` | 69-105 |
| Transcode job worker | `lib/video_api/transcodings/transcoder.ex` | 1-35 |
| FFmpeg HLS script | `priv/scripts/create-vod-hls.sh` | 1-80 |
| JSON API queries | `lib/video_api/json/json.ex` | 1-55 |
| Auth (sign in/sign up) | `lib/video_api/accounts/auth.ex` + `lib/video_api_web/controllers/session_controller.ex` | — |
| Guardian JWT auth | `lib/video_api_web/guardian/guardian.ex` | 1-17 |

## Start Here

For someone new to this codebase, start at **`lib/video_api/application.ex`** (line 1) to understand the OTP supervision tree and Honeydew queue setup, then **`lib/video_api_web/router.ex`** to see all routes, then follow the video upload lifecycle through **`lib/video_api_web/controllers/video_controller.ex`** → **`lib/video_api/videos/videos.ex`** → **`lib/video_api/transcodings/transcoder.ex`**.
