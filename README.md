[![Build Status](https://travis-ci.org/blazingkin/blazingkin-party-pack.svg?branch=master)](https://travis-ci.org/blazingkin/blazingkin-party-pack)

The blazingkin party pack!

# Ruby Version
 ~> 2.3

# Database notes
    * Currently using mysql2
    * Databases are named `blazingkin-party-pack_X` (where X is test, development, or production)
    * Database connects using user 'root' and whatever password is set in the BLAZINGKINPARTYPACK_DATABASE_PASSWORD environment variable

# Action Cable Store
    Action Cable is currently storing everything in memory. This is *bad*.
    Before moving to production, this will need to be changed to Redis

# Webserver
    - Puma (ActionCable needs a multithreaded server)

# Word2Vec Data.
    - A 'gutenberg-vector.bin' file is needed in the data/ directory
    - This can be generated using Google's word2vec
    - The current one I'm using is ~1Gb, so no can git