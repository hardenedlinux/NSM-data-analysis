#!/usr/bin/env python3

import broker
import sys

## this thing has two directions:
## it sends and receives. thus it needs to be a subscriber


ep = broker.Endpoint()
subscription = ep.make_subscriber("demo/ping_pong")
status_subscriber = ep.make_status_subscriber(True)
ep.peer("127.0.0.1", 9999)

# blocking operation. wait until you get a status.
status = status_subscriber.get()

if type(status) != broker.Status or status.code() != broker.SC.PeerAdded:
    print("peering with remote machine failed")
    sys.exit(1)

for i in range(5):
    ## the bro on the other side needs to have an event handler called "ping".
    event = broker.bro.Event("ping", i)
    ep.publish("demo/ping_pong", event)

    ## blocking operation. wait until at least 1 message is available and take it.
    (topic, data) = subscription.get()
    response = broker.bro.Event(data)
    print("received on topic: {}    response event name: {}    content: {}".format(topic, response.name(), response.args()))
