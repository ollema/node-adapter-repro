## Create project:

```
pnpm create svelte@latest node-adapter-repro
cd node-adapter-repor
pnpm install
```

## Install `adapter-node`, remove `adapter-auto`

```
pnpm add -D @sveltejs/adapter-node
pnpm remove @sveltejs/adapter-auto
```

## Update `svelte.config.js`

```ts
import adapter from '@sveltejs/adapter-node';
```

## Add `src/hooks.server.ts`

```ts
import { error } from '@sveltejs/kit';

export const handle = async ({ event, resolve }) => {
	return resolve(event);
};
```

## Add Dockerfile

```Dockerfile
# use node 18 as base image and set platform to linux/amd64
FROM --platform=linux/amd64 node:18-bullseye

# set working directory
WORKDIR /usr/src/app

# set environment variables
ENV PNPM_HOME=/usr/local/.pnpm-store
ENV PATH=$PNPM_HOME/bin:$PATH

# install pnpm
ENV PNPM_VERSION=8.5.1
RUN npm install -g pnpm@${PNPM_VERSION}

# copy pnpm lock files
COPY pnpm-lock.yaml ./

# fetch dependencies
RUN pnpm fetch

# copy source code
COPY . ./

# install dependencies
RUN pnpm install --offline

# build app
RUN pnpm svelte-kit sync
RUN pnpm build

# set port
ENV PORT=3000
EXPOSE ${PORT}

# set user and environment
USER node
ENV NODE_ENV=production

CMD [ "node", "build" ]
```

## Build and run Docker image

```
docker build -t node-adapter-repro . && docker run --rm -it node-adapter-repro
```

## Notice how the container exits without printing anything
