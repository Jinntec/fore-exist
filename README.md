# Fore-eXist

This is a blueprint app for eXist-db showing the use of [Fore](https://github.com/Jinntec/Fore) and allowing to
create your own pages to play with it.

A very simplistic todo example application demonstrates the use of OpenAPI endpoints
and how that integrates with Fore submissions.

Instructions and documentation on its use is given in the app itself.

## Building

You should have a npm installation at hand.

After cloning run:
```
npm install
```

To build the app:
```
gulp xar
```

To install the xar in eXist-db:
```
gulp install
```

