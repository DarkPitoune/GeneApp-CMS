module.exports = ({ env }) => ({
  host: env('HOST', '0.0.0.0'),
  port: env.int('PORT', 1337),
  url: process.env.NODE_ENV === "development" ? "http://localhost:1337/":"https://api.genealogie.dhebrail.fr/",
  app: {
    keys: env.array('APP_KEYS'),
  },
});
