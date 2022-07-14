// Use https://finicky-kickstart.now.sh to generate basic configuration
// Learn more about configuration options: https://github.com/johnste/finicky/wiki/Configuration

module.exports = {
  defaultBrowser: "Firefox",
  handlers: [
    {
      match: [
        "https://sentry.io/organizations/dwins-gmbh/*",
        "https://meet.google.com/*",
        "http://localhost:7007*",
        "http://localhost:3000*",
        "http://www.blobby-online.com/*"
      ],
      browser: "Google Chrome",
    },
  ],
};
