# Wikipedia game API
API for [Wikipedia game](https://en.wikipedia.org/wiki/Wikipedia:Wiki_Game) solutions.
The implementation is based on Breath First Search and attempt for solution with weighted page links
with elasticsearch. The searching for path algorithms are easily replaceable with strategy design pattern.

# Setup
Run the following to install [bundler](http://bundler.io):
```bash
gem install bundler
```

Run the following to install all gems:
```bash
bundle install
```

(Installing elasticsearch)[https://www.elastic.co/guide/en/elasticsearch/reference/current/_installation.html]
(Installing redis-client)[https://redis.io/topics/quickstart]

# Run
To start the app run:
```bash
rackup -p 3000
```
To access the API:
```bash
http://localhost:3000/api/connect?from=A*%20search%20algorithm&to=Algorithm
```

# Test
To run the tests run the following:
```bash
rspec spec --format documentation
```
