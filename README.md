Finch
=====

[![Code Climate](https://codeclimate.com/github/emcien/finch.png)](https://codeclimate.com/github/emcien/finch)

Finch is a (very) lightweight wrapper for the Twitter 1.1 API. Finch is intended
primarily to provide the following features:
* Transparent handling of user-authenticated requests
* First-class support for per-endpoint rate limits
* Simple JSON response objects (using Oj for faster parsing)

As opposed to the standard `twitter` gem, finch makes no attempt to expose a
stable ruby API, nor to be backwards-compatible with Twitter 1.0.

Usage
-----
`user` should be an object with a `credentials` hash with the following keys: `:token`, `:token_secret`, `:consumer_key`, `:consumer_secret`. 
See the [Twitter docs](https://dev.twitter.com/docs/auth/implementing-sign-twitter) for more information on obtaining these keys.

Initializing the client:

    client = Finch[user]

Making a query:

    client.get 'search/tweets', q: 'Emcien'

Handling rate limits:

    client.rate_limit do |rem, tot, user|
      if rem.to_f / tot < 0.5
        user.warn "You have used half of your rate limit for this endpoint"
      end
    end

Testing
-------
In order to run tests, you must be able to authenticate a Twitter user. Copy spec/credentials.json.tmp to spec/credentials.json and fill in the required fields.

TODO
----
* write specs
* add tools for exposing Faraday builder / response as needed
  * use VCR for testing once a Faraday builder is exposed
