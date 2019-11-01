# Datomic Peer Server

This Dockerfile defines a base image for the version of Datomic
Peer Server that ships
with [Datomic Pro Starter Edition](http://www.datomic.com/). It
defines the necessary automation steps for running a Datomic Peer Server,
while deferring all privileged, user-specific configuration to a
derived image via **ONBUILD** instructions.

This approach is adapted from [pointslope/docker-datomic-console](https://github.com/pointslope/docker-datomic-console).

This approach makes it trivial to customize your own Dockerfile to run
any supported Datomic configuration. To do so, you need only to follow
these steps:

1. Create a `Dockerfile` that is based **FROM** this image
2. Create a `.credentials` file containing your http user and password
   for downloading from **my.datomic.com** in the form `user:pass`
3. Add a **CMD** instruction in your `Dockerfile` to configure the -a and -d 
   options for the peer server

No other configuration is necessary. Simply **docker build** and
**docker run** your image.

## Example Folder Structure

    .
    ├── .credentials
    └── Dockerfile

## Example Dockerfile

    FROM quay.io/parkside-securities/datomic-peer-server:0.9.5981
    MAINTAINER John Doe "jdoe@example.org"
    CMD ["-a", "your-access-key,your-secret", -d", "my-db,datomic:dev://db:4334/"]

## Miscellany

The Dockerfile **EXPOSES** port 9001. Once the container is running,
you can connect to the peer server using the [datomic client api](http://docs.datomic.com/peer-server.html):

    (require
       '[clojure.core.async :refer (<!!)]
       '[datomic.client :as client])

    (def conn
       (<!! (client/connect
            {:db-name "my-db"
             :account-id client/PRO_ACCOUNT
             :secret "my-secret"
             :access-key "my-access-key"
             :endpoint "{host}:9001"
             :region "none"
             :service "peer-server"})))

where {host} represents the IP address or hostname of the host running
the Docker container.

## License

The MIT License (MIT)

Copyright (c) 2016 Michael Frericks

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
