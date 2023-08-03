REQUESTS

Scrape data from websites

```py
# get data from some url using requests.get()
url = f'https://rest.uniprot.org/uniprotkb/stream?format=json&query=%28{acc}%29'
# r is a Response object
r = requests.get(url)
```

Common attributes
```py
# url of the Response object
r.url

# get some text from the website
# could be HTML, JSON or whatever
r.text

# get http status_codes
r.status_code
# 200s are a success
# 300s are redirects
# 400s are client errors
# 500s are server errors

# is the server ok?
r.ok
# returns True if r.status_code is less than 400

r.headers
```

Common status_codes
```
400 Bad Request
404 Resource Not Found
429 Too Many Requests
500 Internal Server Error
```


URL parameters
```py
# if parameters are page=2 and count=25
# parameters can be passed on directly in the URL like so
url = 'https://httpbin.org/get?page=2&count=25'
r = requests.get(url)

# but they can also be passed down more cleanly like so
payload = {'page' : 2, 'count' : 25}
url = 'https://httpbin.org/get'
r = requests.get(url, params=payload)
```

JSON responses
```py
# create a python Dictionary from a JSON response
dict = r.json()
# basically the same as using the 'json' module with json.loads()

# access certain keys of that JSON form
names = dict['names']

# JSON dicts are typically nested dicts of dicts
```

Mutiple requests to the same website/host
```py
# open a single session, then get your stuff
# this prevents the extra overhead of opening and closing the TCP connection for each request

# slow
for item in table.keys():
    r = requests.get(url)

# faster
session = requests.Session()
for item in table.keys():
    r = session.get(url)
```

