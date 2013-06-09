#!/bin/bash

knife solo cook -p 222 root@sf.tmate.io nodes/sf.json &
knife solo cook -p 222 root@ny.tmate.io nodes/ny.json &
knife solo cook -p 222 root@am.tmate.io nodes/am.json &
wait
