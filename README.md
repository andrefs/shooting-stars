# shooting-stars-docker

Thin Portainer deploy repo for the **Shooting Stars** stack (api + game +
stats + mongo). It contains **only** this `docker-compose.yml` — the three
service images are built **remotely** straight from their own public Git
repos via build contexts, so there are no copies of those repos here and no
git submodules (Portainer does not support submodules — see
portainer/portainer discussions #9767).

| Service | Built from | Port (host) |
|---------|-----------|-------------|
| api     | github.com/andrefs/shooting-stars-api   | 15111 |
| game    | github.com/andrefs/shooting-stars-game  | 3001  |
| stats   | github.com/andrefs/shooting-stars-stats | 3002  |
| mongo   | `mongo:4.4` (pinned)                    | 27019 |

## Deploy on Portainer

1. Push this repo to GitHub.
2. Portainer → **Stacks → Create stack → Repository**.
3. Repository URL: `https://github.com/<you>/shooting-stars-docker.git`
4. Compose path: `docker-compose.yml`
5. **Deploy** — Portainer clones each service repo directly to build it.

## Required deployment data (provided on the server, not in this repo)

The `api` service mounts `./data/items/images` into the container at
`/usr/src/ss-api/images` and the database references item images by their
**md5** filename. Provide these on the server's stack directory:

1. `data/items/images/*.jpg` — the item images, **renamed to `<md5>.jpg`**.
   Use the helper from the main repo:
   ```sh
   # from the shooting-stars main repo, after copying images here:
   ./scripts/normalize-images.sh
   ```
   (or copy the already-renamed images from the main repo's
   `data/items/images/`.)
2. `data/db/` — created automatically by mongo on first start.
3. `data/export/` — created automatically.

## Restore the production database

```sh
# inside the mongo container
mongorestore --db shooting-stars-prod /path/to/ss-prod-YYYYMMDD-HHMM.tgz
```

(target DB name is `shooting-stars-prod`).

## Verify

```sh
curl -s -o /dev/null -w "%{http_code}\n" \
  http://<host>:15111/items/images/<md5>.jpg   # expect 200
```
