# shooting-stars

Monorepo that orchestrates the **Shooting Stars** game and its supporting services
with Docker Compose.

## Overview

This repository is the deployment root (git superproject) for Shooting Stars. It
ties together the individual components as git submodules and provides a single
`docker-compose.yml` to run the full stack locally or in production.

| Submodule                                                    | Description                              |
| ------------------------------------------------------------ | ---------------------------------------- |
| [`shooting-stars-api`](./shooting-stars-api)                 | REST API (Node.js / restify / MongoDB)   |
| [`shooting-stars-game`](./shooting-stars-game)               | Frontend web client (Vue.js / Vuetify)   |
| [`shooting-stars-stats`](./shooting-stars-stats)             | Statistics / analytics dashboard         |

## Repository layout

```
shooting-stars/
├── docker-compose.yml   # Mongo + API + stats services
├── data/                # Persisted DB and exported data (git-ignored)
├── shooting-stars-api/  # submodule
├── shooting-stars-game/ # submodule
└── shooting-stars-stats/# submodule
```

## Getting started

First, clone this repository:

```
git clone https://github.com/andrefs/shooting-stars.git
```

Then init the Git submodules to pull in the game API, frontend and stats
backoffice from their own repositories:

```
cd shooting-stars
git submodule update --init --recursive
```

Then run:

```
docker compose up --build
```

The game will be accessible on port 3001.

## Running the stack

The API, a MongoDB instance, and the stats dashboard are defined in
`docker-compose.yml`. The game client is currently commented out in the compose
file (it is built and served separately, see its own README).

This starts:

- **mongo**  — MongoDB, exposed on `localhost:27018`
- **api**    — Shooting Stars API, exposed on `localhost:15111`
- **stats**  — Statistics dashboard, exposed on `localhost:3002`

The API reads the following environment variables from the compose file:

- `MONGODB_HOST=mongo`
- `NODE_ENV=production`
- `API_PORT=15111`

## Customize items

If you want to start Shooting Stars using different items:

1. Stop the application.
2. Remove the contents of `data/db/`.
3. Edit `data/items/items.json`.
4. Put the new image file in `data/items`.
5. Restart the application.

## Data volumes

- `./data/db`    — MongoDB data files
- `./data/export` — data exported by the API scripts
- `./data/items`  — uploaded item images

See each submodule's README for component-specific setup, development, and
testing instructions.
