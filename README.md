## Serverless Docker (V2)

This deployment:

- Respond with dynamic data by running code
- Automatically scale to zero with no traffic
- Boot from cold in under a second
- Are built reproducibly from `Dockerfile`

### Overview

| Demo | Language | Description | Size |
|:------|:----------:|:-------------|------|
| [php-wordpress](https://php-wordpress-v2.now.sh) | [PHP](https://en.wikipedia.org/wiki/PHP) | An example running [WordPress](https://wordpress.org/) backed by a SQLite database| 45.3M |

# now-wordpress

Example deployment of WordPress backed by a SQLite database.

There is an example sqlite database in the [`data`](./data) directory,
with a single user (username: `nowuser`, password: `demo_test_123`) that
can be used to create posts, etc.

Note that changes the sqlite database on a _live_ deployment will only be
temporary, as the changes will be lost once the deployment goes to sleep.

To make more permanent modifications to the sqlite database, you can start up
this docker container locally, using a *volume mount* to the local `data`
directory. For example:

```bash
docker build -t now-wordpress .
docker run --rm -v $PWD/data:/data -p 3000:3000 now-wordpress
```

After running this command, you can access the WordPress server by visiting
http://localhost:3000 and visit the WP Admin page to write a blog post.

Once you're finished, the sqlite file in the local `data` directory will
have been updated, and you can invoke `now` to create a new deployment with
the changes embedded into the deployment image.
