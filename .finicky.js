// Use https://finicky-kickstart.now.sh to generate basic configuration
// Learn more about configuration options: https://github.com/johnste/finicky/wiki/Configuration

module.exports = {
  defaultBrowser: "Firefox",
  handlers: [
    {
      match: [
        "https://dwins-gmbh.sentry.io/*",
        "https://meet.google.com/*",
        "http://localhost:7007*",
        "http://localhost:3000*",
        "http://www.blobby-online.com/*",
        "http://127.0.0.1:5173/*",
        "http://localhost:5173/*",
        "http://localhost:8081/debugger-ui/",
      ],
      browser: "Google Chrome",
    },
  ],
};
