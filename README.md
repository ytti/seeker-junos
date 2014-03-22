# Seeker JunOS
Finds hidden commands from JunOS devices by brute-forcing commands over SSH

## Install
```
 % gem install seeker-junos
 % cat >> ~/.netrc
   machine Seeker
     login <username>
     password <passwrod>
  ^d
```

## Run
```
% seeker-junos --level routing-options 193.88.239.31
I, [2014-03-22T13:15:09.320710 #66906]  INFO -- : starting
I, [2014-03-22T13:25:09.544325 #66906]  INFO -- : now at 'inhed', found 0 so far
I, [2014-03-22T13:29:00.236750 #66906]  INFO -- : Found: 'kernel-options'
I, [2014-03-22T13:31:59.445597 #66906]  INFO -- : Found: 'maximum-routes'
I, [2014-03-22T13:34:41.146006 #66906]  INFO -- : Found: 'max-interface-supported'
I, [2014-03-22T13:35:10.340298 #66906]  INFO -- : now at 'max-interface-supps', found 3 so far
I, [2014-03-22T13:39:07.812630 #66906]  INFO -- : Found: 'nsr-phantom-holdtime'
I, [2014-03-22T13:43:15.168970 #66906]  INFO -- : Found: 'rpd-server'
I, [2014-03-22T13:45:09.499291 #66906]  INFO -- : now at 'task-accounc', found 5 so far
I, [2014-03-22T13:45:31.663623 #66906]  INFO -- : Found: 'task-accounting'
I, [2014-03-22T13:47:18.411653 #66906]  INFO -- : Found: 'task-scheduling'
I, [2014-03-22T13:49:00.204509 #66906]  INFO -- : finishing, took 33.84805928741667 minutes
["kernel-options", "maximum-routes", "max-interface-supported", "nsr-phantom-holdtime", "rpd-server", "task-accounting", "task-scheduling"]
```
Reports progress every 10min, outputs list of found commands when finished

## Todo
 * Full recurse, not just single level. Not sure if sane, as it already takes very fscking long to run
