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
