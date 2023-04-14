# shooting-stars

First, clone this repository:

```
git clone https://github.com/andrefs/shooting-stars.git
```

Then you need to init the Git submodules to pull in the game API, frontend and stats backoffice from their own repositories.

```
git submodule init
git submodule update
```

Then run

```
docker compose up --build
```

The game will be accessible on port 3001.
