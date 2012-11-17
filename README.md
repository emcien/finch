Finch is a (very) lightweight wrapper for the Twitter 1.1 API. Finch is intended
primarily to provide the following features:
* Transparent handling of user-authenticated requests
* First-class support for per-endpoint rate limits
* Simple JSON response objects (using Oj for faster parsing)

As opposed to the standard `twitter` gem, finch makes no attempt to expose a
stable ruby API, nor to be backwards-compatible with Twitter 1.0.

TESTING:
In order to run tests, you must be able to authenticate a Twitter user. Copy spec/credentials.json.tmp to spec/credentials.json and fill in the required fields.

TODO:
- error handling
- write specs
- add tools for exposing Faraday builder / response as needed
  - use VCR for testing once a Faraday builder is exposed