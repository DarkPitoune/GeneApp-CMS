# GeneApp CMS

This project is a Strapi application, used as a headless CMS for [the d'Hébrail's GeneApp project](genealogie.dhebrail.fr). You'll find useful documentation [here](https://docs.strapi.io/developer-docs/).

## How to run

The project uses node.js and npm. Ensure you use node 14.

Clone the repository and run the following commands in the project directory.

- install dependencies: `npm install`
- create an `.env` file `cp .env.example .env`
- run locally (with autoReload enabled): `npm run develop`
- run a production server:
  - build the admin panel: `NODE_ENV=production npm run build`
  - `npm run start`

## Deployment

Deployment is handled by github's actions.

If it's the first time, you'll need to ssh to the machine and run:

```
NODE_ENV=production pm2 start npm --name "CMS" -- start
```

