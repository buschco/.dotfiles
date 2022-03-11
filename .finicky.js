// Use https://finicky-kickstart.now.sh to generate basic configuration
// Learn more about configuration options: https://github.com/johnste/finicky/wiki/Configuration

module.exports = {
  defaultBrowser: "Firefox",
  handlers: [
    {
      match: [
        "https://sentry.io/organizations/dwins-gmbh/*",
        "https://meet.google.com/*"
      ],
      browser: "Google Chrome"
    }
  ]
}
