// Use https://finicky-kickstart.now.sh to generate basic configuration
// Learn more about configuration options: https://github.com/johnste/finicky/wiki/Configuration

module.exports = {
  defaultBrowser: "Firefox",
  handlers: [
    {
      match: [
        "https://dwins-gmbh.sentry.io/*",
        "https://sentry.dwins.de/organizations/finanzguru/issues/659",
        "https://meet.google.com/*",
        "http://localhost:7007*",
        "http://localhost:3000*",
        "http://127.0.0.1:5173/*",
        "http://localhost:5173/*",
        "http://localhost:8081/debugger-ui/",
        "https://github.com/finanzguru/*",
        "http://localhost:8081/debugger-ui/",
      ],
      browser: "Firefox Developer Edition",
    },
    {
      match: ["http://www.blobby-online.com/*"],
      browser: "Google Chrome",
    },
  ],
};
