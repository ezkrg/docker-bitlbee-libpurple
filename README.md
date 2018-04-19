# docker-bitlbee-libpurple

This docker image includes bitlbee with a bunch of useful plugins, the most
significant being the [libpurple Slack plugin](https://github.com/dylex/slack-libpurple).

As Slack is turning off its IRC gateway on May 15 2018, now is the time to
spin up your own docker image and start using bitlbee instead.

## Building and running the image
Build the image and tag it:
```bash
docker build -t bitlbee:latest .
```

Then run it:
```bash
docker run -p 6667:6667 --name bitlbee -v /local/path/to/configurations:/var/lib/bitlbee --restart=always --detach bitlbee:latest
```

The local path to the configurations will contain the configuration as saved by 
bitlbee. It is advisable to do so, as you're configuration will be gone when
the docker image gets deleted.

## Setting up a Slack account
Connect with your IRC client to the host running the image. Then register with a password in the &bitlbee channel:
```
/join &bitlbee
register <your password>
```

Then, go to [the Slack legacy token site](https://api.slack.com/custom-integrations/legacy-tokens) to acquire
an API token, which is necessary in order to log in.

Copy the token, register your slack account in bitlbee and enable the account:
```
account add slack yourusername@whatever.slack.com thetoken
account on
```

This should log your account in right away:
```
<@root> Trying to get all accounts connected...
<@root> slack - Logging in: Requesting RTM
<@root> slack - Logging in: Connecting to RTM
<@root> slack - Logging in: RTM Connected
<@root> slack - Logging in: Loading Users
<@root> slack - Logging in: Loading conversations
<@root> slack - Logging in: Logged in
```

By default, none of the channels you normally reside in will be joined. To join them, you first need to add them:
```
<@you> chat add slack general
<@root> Chatroom successfully added.
```

Don't add the leading #. Adding private channels works the same way as public channels, both without the leading #.
Now, join the channel with /join #channnelname and you'll be good to go.

will add channel general,
