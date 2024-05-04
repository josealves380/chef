FROM node:alpine as BUILD_IMAGE
WORKDIR /chef
COPY \package.json ./
# install dependencies
RUN yarn install --frozen-lockfile
COPY . .
# build
RUN yarn build
# remove dev dependencies
RUN npm prune --production
FROM node:alpine
WORKDIR /chef
# copy from build image
COPY --from=BUILD_IMAGE /chef/package.json ./package.json
COPY --from=BUILD_IMAGE /chef/node_modules ./node_modules
COPY --from=BUILD_IMAGE /chef/.next ./.next
COPY --from=BUILD_IMAGE /chef/public ./public
EXPOSE 3000
CMD ["yarn", "start"]