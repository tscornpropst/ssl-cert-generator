ssl-cert-generator
==================

Makefile and configs to generate SSL certificates for development environments

This main purpose of this Makefile is to create SSL certificates for development. System Administrators could use this to generate signing requests as well.

There are three configuration files. Replace the values in angle brackets with something meaningful for your project. Don't forget to remove the angle brackets.

If you are generating a real certificate, make sure to set the CN to the domain you intend to use with the certificate.

Creating a self signed cert
---------------------------

```
make ss-cert.pem
make ss-verify
```

For a Node app you can do
-------------------------

```javascript
var https_options = {
  key: fs.readFileSync(config.server.ssl_key),
  cert: fs.readFileSync(config.server.ssl_cer)
};

var server = https.createServer(https_options, app);
```
