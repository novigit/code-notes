Multiprocessing

         +-----------------------------+
         |    Python Script Process    |
         +--------------+--------------+
                        |
                        V
    +----------+----------+----------+----------+
    | Python   | Python   | Python   | Python   |
    | Process1 | Process2 | Process3 | ProcessN |
    +----------+----------+----------+----------+
         |          |          |          |    
         V          V          V          V    
      Task 1     Task 2     Task 3     Task N 


* Python can only use one (logical) core or CPU at any one time

* This has to do with the Global Interpreter Lock, or the GIL

* However, you can still invoke multiple python _processes_ from a single python script!
Each of these processes still honor the GIL and can only use one CPU core at a time

* Useful if tasks are CPU bound (crunching numbers, for example)
If tasks are I/O bound (opening files, downloading files, database operations),
multi-threading is perhaps more useful

* These are the same processes that you can see in `htop` and have process ID's, etc

* You can only invoke as many processes at any one time equal to the number of (logical)
cores you have on your machine

* Some processors have CPU cores with 'hyper-threading'.
In that case, each CPU core has two 'logical' cores

* I think that 1 process can have multiple threads
(as threads here defined in the python context)

# How many cores do you have?

```python
import os
os.cpu_count()
```

# ProcessPoolExecutor

```python
from concurrent.futures import ProcessPoolExecutor

def some_function(x):
        ...

# invoke / submit a single python process to execute
# your 'some_function' with argument 'x'
with ProcessPoolExecutor() as executor:
        future = executor.submit(some_function, x)
        result = future.result()
```

* `ProcessPoolExecutor()` creates and instantiates a 'pool' of idle processes
_before_ any task is scheduled and executed. This reduces the overhead of
creating new processes on the fly. (how multiple processes were managed before
this strategy was concocted)

* By invoking it as a context manager, python will not start interpreting/executing
lines of code after the `with` statement until all processes are done/completed

* `.submit()` starts/schedules the execution of your function.
The function typically starts running immediately once python arrives and
interprets this line of code.

* It returns a `Future` object, which contains the information of the process that is running the execution
of the function. For example, whether it is pending, running, or finished, etc.

* `future.result()` retrieves the return value of your `some_function`, once
the function has completed execution.

```python

# invoke multiple python processes, each
# executing the 'some_function' on one element of 'some_data'
some_data = [1, 2, 3, 4, 5]
with ProcessPoolExecutor() as executor:
        results = executor.map(some_function, some_data)
```

* Here, `results` is not a list of `Future` objects.
It is rather the actual results returned by `some_function`.

```python

# only run a maximum of 3 processes at any one time 
some_data = [1, 2, 3, 4, 5]
with ProcessPoolExecutor(max_workers=3) as executor:
        results = executor.map(some_function, some_data)
```

* By default, `ProcessPoolExecutor()` will make us of all available
CPU cores

* By setting `max_workers=<n>` you can limit the maximum number of
CPU cores used at any one time

```python

# if you're curious you can get the process id of each invoked
# process like so
import os

def some_function(x):
        print(f'process id: {os.getpid()}')

some_data = [1, 2, 3, 4, 5]
with ProcessPoolExecutor(max_workers=3) as executor:
        results = executor.map(some_function, some_data)
```

* Take make use of multithreading instead of multiprocessing,
you can simply replace `ProcessPoolExecutor` with `ThreadPoolExecutor`!
All syntax and arguments are essentially the same

```python
```
```python
```
```python
```
```python
```
