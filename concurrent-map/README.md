# concurrent-map

```
$ CACHE=0 ruby -v bench.rb
ruby 2.7.0dev (2019-03-28 trunk 67359) [x86_64-linux]
1.6259882250160445

$ CACHE=1 ruby -v bench.rb
ruby 2.7.0dev (2019-03-28 trunk 67359) [x86_64-linux]
1.6596061189775355

$ CACHE=0 ruby --jit -v bench.rb
ruby 2.7.0dev (2019-03-28 trunk 67359) +JIT [x86_64-linux]
compile1
compile2
1.525636806996772

$ CACHE=1 ruby --jit -v bench.rb
ruby 2.7.0dev (2019-03-28 trunk 67359) +JIT [x86_64-linux]
compile1
compile2
1.7935741410183255
```
